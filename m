Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82455C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:39:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235589AbiL3Wj2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:39:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbiL3Wj0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:39:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA9B818692
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:39:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58A9561645
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:39:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7B3AC433EF;
        Fri, 30 Dec 2022 22:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672439964;
        bh=xy6GW9ZxJz6HAqN0eiilvkcLOiyBg1VLLUQwZQxJ8jM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=h0ak1VonbulnklA3drnauKcUc/C2s+JQko1qdoiY0w2Y7ep7OkY6jRBXUTJL6N9gB
         ZqaXCNbKreT8ZwbuBmdrE9pJ5c5be36zI1cwtcSbNYYtbnFEk+WqzelNbIQZ77Vcaa
         ixLhGvj0dheBDpUgOdS0xkCeIF1xr0xpLJskI+YP2HliqY3dr5Jqez2/oq2FZ+6XdS
         BfmHSgj5NrucoqnRCM1qASAgvZmT5cYuv3PceM3x/FRW6p4TEtGbA2YmpEIii8E7fM
         IPhiB4ZDxwKjLoQ0izQIeCFGvtNj8tN8raKi3EhT9RaxnrlcsvQA0ZmH5H7FPIuRH/
         GSVJCxthU9YOA==
Subject: [PATCH 6/8] xfs: standardize ondisk to incore conversion for bmap
 btrees
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:12 -0800
Message-ID: <167243827217.683855.169260372160243186.stgit@magnolia>
In-Reply-To: <167243827121.683855.6049797551028464473.stgit@magnolia>
References: <167243827121.683855.6049797551028464473.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Fix all xfs_bmbt_disk_get_all callsites to call xfs_bmap_validate_extent
and bubble up corruption reports.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/bmap.c |    6 ++++++
 1 file changed, 6 insertions(+)


diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 5c4b25585b8c..575f2c80d055 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -471,6 +471,12 @@ xchk_bmapbt_rec(
 		return 0;
 
 	xfs_bmbt_disk_get_all(&rec->bmbt, &irec);
+	if (xfs_bmap_validate_extent(ip, info->whichfork, &irec) != NULL) {
+		xchk_fblock_set_corrupt(bs->sc, info->whichfork,
+				irec.br_startoff);
+		return 0;
+	}
+
 	if (!xfs_iext_lookup_extent(ip, ifp, irec.br_startoff, &icur,
 				&iext_irec) ||
 	    irec.br_startoff != iext_irec.br_startoff ||

