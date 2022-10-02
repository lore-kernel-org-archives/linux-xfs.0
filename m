Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D8CCC433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:31:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbiJBSbz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:31:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbiJBSby (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:31:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2743C3C156
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:31:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5ECCDB80D89
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:31:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AE85C433D6;
        Sun,  2 Oct 2022 18:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735510;
        bh=1HV+MWF3WFALnIlchlCunXox1Uu9+6PQkkrgNa7ZGBE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Ubnv73KV1HKf2gp1lIfj4bQ8X0Zm828kIMgwXJ5qUi4ZAPgyZWg+ynU2K1JpokaI/
         9jBaIRWOZMcHyOBBiVlIZol3zi82TrZBXndj9HZrmd+fv5HtoVGE5vrYX3yjM6Mpek
         NGNRLQ14YfrdAMm/I0GyiosIBntp2W/NhG1WETRvuIMoSLUoAQ8JyBExIC6+SrP169
         oTklc1KFv1cLKeKYRtDO4W9irIQVlNe7zOgfqgxZcKTbqfHyxFRKkVWac3i9ry5Zwe
         kIWwTb/r76lisKLjVMW0rXZND3h6jlC8b/dPZIsfkq4AXLX7r/ddKS6tJav8iGEhIu
         GrA9B6h5ORjrg==
Subject: [PATCH 6/6] xfs: teach scrub to flag non-extents format cow forks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:09 -0700
Message-ID: <166473480956.1083927.1804040835619289778.stgit@magnolia>
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

CoW forks only exist in memory, which means that they can only ever have
an incore extent tree.  Hence they must always be FMT_EXTENTS, so check
this when we're scrubbing them.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/bmap.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index c3dd231eea1c..5c4b25585b8c 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -751,6 +751,8 @@ xchk_bmap(
 	case XFS_DINODE_FMT_DEV:
 	case XFS_DINODE_FMT_LOCAL:
 		/* No mappings to check. */
+		if (whichfork == XFS_COW_FORK)
+			xchk_fblock_set_corrupt(sc, whichfork, 0);
 		goto out;
 	case XFS_DINODE_FMT_EXTENTS:
 		break;

