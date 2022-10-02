Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62D6AC433F5
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:31:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbiJBSbC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbiJBSbA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:31:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0B28286D7
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:30:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A407DB80D89
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:30:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55A25C433D6;
        Sun,  2 Oct 2022 18:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735457;
        bh=5/jllzTq1SZssOQlOmyAAKGEXbpJaMT8z1tXDTLp9w4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=JmdQrmmgIQVf5I4H/OtR1SP2CD9lcFyQrz1cU1Fp45uEIjtZWFFwAHopdLTVyFnla
         /ilYGkJjQFO6SvWlpjh9YQg7QZKNNtsSKweNhW+5Ty+++UiZYxnCG2Elm30eQECfp+
         3Kig/jCYVeGIewBs2I43cFol1ujYRtAND6ENBPILf74yecy1Ut7uHA0D6vHt5/vAZA
         s1IEjdtIZeHWPj33lACfewuURZt0Um/FQsVKwkbZIlwS1J7cUEohwGWoU5ANqCPnzP
         sfARo6qcQUZUAj9GefTTESBmXuaCDNuaw66A43feZKcYkm+NS041cuLYesMGREYqHn
         CfXGWXO0qFiWg==
Subject: [PATCH 1/6] xfs: fix perag loop in xchk_bmap_check_rmaps
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:08 -0700
Message-ID: <166473480888.1083927.912685328486215875.stgit@magnolia>
In-Reply-To: <166473480864.1083927.11062319917293302327.stgit@magnolia>
References: <166473480864.1083927.11062319917293302327.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

sparse complains that we can return an uninitialized error from this
function and that pag could be uninitialized.  We know that there are no
zero-AG filesystems and hence we had to call xchk_bmap_check_ag_rmaps at
least once, so this is not actually possible, but I'm too worn out from
automated complaints from unsophisticated AIs so let's just fix this and
move on to more interesting problems, eh?

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/bmap.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 576c02cc8b8f..63e43fd8af5d 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -602,14 +602,14 @@ xchk_bmap_check_rmaps(
 
 	for_each_perag(sc->mp, agno, pag) {
 		error = xchk_bmap_check_ag_rmaps(sc, whichfork, pag);
-		if (error)
-			break;
-		if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
-			break;
+		if (error ||
+		    (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)) {
+			xfs_perag_put(pag);
+			return error;
+		}
 	}
-	if (pag)
-		xfs_perag_put(pag);
-	return error;
+
+	return 0;
 }
 
 /*

