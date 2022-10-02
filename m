Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B669DC433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:34:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbiJBSd7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbiJBSd6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:33:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F2223C167
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:33:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CC9560F07
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:33:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF3DC433C1;
        Sun,  2 Oct 2022 18:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735636;
        bh=OVC+ULuoeXFJfcZrOCwVJEbR/q/Ug5NBMCprs8CuRYA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=qaiTt2/fcdito9hQ69oJnRHLaELuyarEov/PzoCViQ5jYkDZEpSgS5jrtmHcF69nt
         US6CnSvPv6h2Z+VFlnEt+VDIgxjgUazWXK7etzQkGe2aPGXl0JyWHae+NZdXazAfWR
         uGUYk+DeFxsR69+AhsLYsfGOBwuOXaj9VkzzO8w+CjHKmoC3g7nODLqdrkdg+ENEee
         To3XrGZxbugCVRFm5aem6Soz8U8gVR+Kk/ZAz7ln6fCSdpFDjBIbzCzY0PmrkqXV+Q
         UOq1sMOkQXOSykRLafUl819siWq4pVUVVzGP3ZA7iooQCcyLMLuXmeCLYgUQI4a8Qf
         HpeVjqGsWwYhA==
Subject: [PATCH 2/2] xfs: ensure that single-owner file blocks are not owned
 by others
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:23 -0700
Message-ID: <166473482321.1084491.4688155992707660926.stgit@magnolia>
In-Reply-To: <166473482288.1084491.14541503667313246834.stgit@magnolia>
References: <166473482288.1084491.14541503667313246834.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

For any file fork mapping that can only have a single owner, make sure
that there are no other rmap owners for that mapping.  This patch
requires the more detailed checking provided by xfs_rmap_count_owners so
that we can know how many rmap records for a given range of space had a
matching owner, how many had a non-matching owner, and how many
conflicted with the records that have a matching owner.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/bmap.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 1e4813c82cc5..d310f74fe650 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -308,6 +308,7 @@ xchk_bmap_iextent_xref(
 	struct xchk_bmap_info	*info,
 	struct xfs_bmbt_irec	*irec)
 {
+	struct xfs_owner_info	oinfo;
 	struct xfs_mount	*mp = info->sc->mp;
 	xfs_agnumber_t		agno;
 	xfs_agblock_t		agbno;
@@ -328,19 +329,30 @@ xchk_bmap_iextent_xref(
 	xchk_bmap_xref_rmap(info, irec, agbno);
 	switch (info->whichfork) {
 	case XFS_DATA_FORK:
-		if (!xfs_is_reflink_inode(info->sc->ip))
+		if (!xfs_is_reflink_inode(info->sc->ip)) {
+			xfs_rmap_ino_owner(&oinfo, info->sc->ip->i_ino,
+					info->whichfork, irec->br_startoff);
+			xchk_xref_is_only_owned_by(info->sc, agbno,
+					irec->br_blockcount, &oinfo);
 			xchk_xref_is_not_shared(info->sc, agbno,
 					irec->br_blockcount);
+		}
 		xchk_xref_is_not_cow_staging(info->sc, agbno,
 				irec->br_blockcount);
 		break;
 	case XFS_ATTR_FORK:
+		xfs_rmap_ino_owner(&oinfo, info->sc->ip->i_ino,
+				info->whichfork, irec->br_startoff);
+		xchk_xref_is_only_owned_by(info->sc, agbno, irec->br_blockcount,
+				&oinfo);
 		xchk_xref_is_not_shared(info->sc, agbno,
 				irec->br_blockcount);
 		xchk_xref_is_not_cow_staging(info->sc, agbno,
 				irec->br_blockcount);
 		break;
 	case XFS_COW_FORK:
+		xchk_xref_is_only_owned_by(info->sc, agbno, irec->br_blockcount,
+				&XFS_RMAP_OINFO_COW);
 		xchk_xref_is_cow_staging(info->sc, agbno,
 				irec->br_blockcount);
 		xchk_xref_is_not_shared(info->sc, agbno,

