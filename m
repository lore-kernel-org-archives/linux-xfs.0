Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:37420 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933117AbeGCRXU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Jul 2018 13:23:20 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8B17E8182D38
        for <linux-xfs@vger.kernel.org>; Tue,  3 Jul 2018 17:23:19 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 757031117629
        for <linux-xfs@vger.kernel.org>; Tue,  3 Jul 2018 17:23:19 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 01/25] xfs: allow null firstblock in xfs_bmapi_write() when tp is null
Date: Tue,  3 Jul 2018 13:22:55 -0400
Message-Id: <20180703172319.24509-2-bfoster@redhat.com>
In-Reply-To: <20180703172319.24509-1-bfoster@redhat.com>
References: <20180703172319.24509-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

xfs_bmapi_write() always expects a valid firstblock pointer. It
immediately dereferences the pointer to help determine how to
initialize the bma.minleft field. The remaining accesses are
related to modifying btree format forks, which is only relevant for
!COW fork callers.

The reflink code passes a NULL transaction to xfs_bmapi_write() in a
couple places that do COW fork unwritten conversion. The purpose of
the firstblock field is to track the first block allocation in the
current transaction, so technically firstblock should not be
required for these callers either.

Tweak xfs_bmapi_write() to initialize the bma correctly without
accessing the firstblock pointer if no transaction is provided in
the first place. Update the reflink callers to pass NULL instead of
otherwise unused firstblock references.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 2 +-
 fs/xfs/xfs_reflink.c     | 9 +++------
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 2e2a9661600b..c6a5a957674d 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4304,7 +4304,7 @@ xfs_bmapi_write(
 
 	XFS_STATS_INC(mp, xs_blk_mapw);
 
-	if (*firstblock == NULLFSBLOCK) {
+	if (!tp || *firstblock == NULLFSBLOCK) {
 		if (XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_BTREE)
 			bma.minleft = be16_to_cpu(ifp->if_broot->bb_level) + 1;
 		else
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 8496312dde6a..92b6e1b5d33c 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -314,7 +314,6 @@ xfs_reflink_convert_cow_extent(
 	xfs_fileoff_t			offset_fsb,
 	xfs_filblks_t			count_fsb)
 {
-	xfs_fsblock_t			first_block = NULLFSBLOCK;
 	int				nimaps = 1;
 
 	if (imap->br_state == XFS_EXT_NORM)
@@ -325,8 +324,8 @@ xfs_reflink_convert_cow_extent(
 	if (imap->br_blockcount == 0)
 		return 0;
 	return xfs_bmapi_write(NULL, ip, imap->br_startoff, imap->br_blockcount,
-			XFS_BMAPI_COWFORK | XFS_BMAPI_CONVERT, &first_block,
-			0, imap, &nimaps);
+			XFS_BMAPI_COWFORK | XFS_BMAPI_CONVERT, NULL, 0, imap,
+			&nimaps);
 }
 
 /* Convert all of the unwritten CoW extents in a file's range to real ones. */
@@ -341,7 +340,6 @@ xfs_reflink_convert_cow(
 	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, offset + count);
 	xfs_filblks_t		count_fsb = end_fsb - offset_fsb;
 	struct xfs_bmbt_irec	imap;
-	xfs_fsblock_t		first_block = NULLFSBLOCK;
 	int			nimaps = 1, error = 0;
 
 	ASSERT(count != 0);
@@ -349,8 +347,7 @@ xfs_reflink_convert_cow(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	error = xfs_bmapi_write(NULL, ip, offset_fsb, count_fsb,
 			XFS_BMAPI_COWFORK | XFS_BMAPI_CONVERT |
-			XFS_BMAPI_CONVERT_ONLY, &first_block, 0, &imap,
-			&nimaps);
+			XFS_BMAPI_CONVERT_ONLY, NULL, 0, &imap, &nimaps);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 }
-- 
2.17.1

