Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:34628 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S935152AbeFZMPC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 26 Jun 2018 08:15:02 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6EF687A7ED
        for <linux-xfs@vger.kernel.org>; Tue, 26 Jun 2018 12:15:02 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 59D4A2166B5D
        for <linux-xfs@vger.kernel.org>; Tue, 26 Jun 2018 12:15:02 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: cow unwritten conversion uses uninitialized dfops
Date: Tue, 26 Jun 2018 08:15:02 -0400
Message-Id: <20180626121502.41354-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

A couple COW fork unwritten extent conversion helpers pass an
uninitialized dfops pointer to xfs_bmapi_write(). This does not
cause problems because conversion does not use a transaction or the
dfops structure for the COW fork.  Drop the uninitialized usage of
dfops in these codepaths and pass NULL along to xfs_bmapi_write()
instead.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_reflink.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 592fb2071a03..ff10b5e70029 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -312,8 +312,7 @@ xfs_reflink_convert_cow_extent(
 	struct xfs_inode		*ip,
 	struct xfs_bmbt_irec		*imap,
 	xfs_fileoff_t			offset_fsb,
-	xfs_filblks_t			count_fsb,
-	struct xfs_defer_ops		*dfops)
+	xfs_filblks_t			count_fsb)
 {
 	xfs_fsblock_t			first_block = NULLFSBLOCK;
 	int				nimaps = 1;
@@ -327,7 +326,7 @@ xfs_reflink_convert_cow_extent(
 		return 0;
 	return xfs_bmapi_write(NULL, ip, imap->br_startoff, imap->br_blockcount,
 			XFS_BMAPI_COWFORK | XFS_BMAPI_CONVERT, &first_block,
-			0, imap, &nimaps, dfops);
+			0, imap, &nimaps, NULL);
 }
 
 /* Convert all of the unwritten CoW extents in a file's range to real ones. */
@@ -342,7 +341,6 @@ xfs_reflink_convert_cow(
 	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, offset + count);
 	xfs_filblks_t		count_fsb = end_fsb - offset_fsb;
 	struct xfs_bmbt_irec	imap;
-	struct xfs_defer_ops	dfops;
 	xfs_fsblock_t		first_block = NULLFSBLOCK;
 	int			nimaps = 1, error = 0;
 
@@ -352,7 +350,7 @@ xfs_reflink_convert_cow(
 	error = xfs_bmapi_write(NULL, ip, offset_fsb, count_fsb,
 			XFS_BMAPI_COWFORK | XFS_BMAPI_CONVERT |
 			XFS_BMAPI_CONVERT_ONLY, &first_block, 0, &imap, &nimaps,
-			&dfops);
+			NULL);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 }
@@ -458,8 +456,7 @@ xfs_reflink_allocate_cow(
 	if (nimaps == 0)
 		return -ENOSPC;
 convert:
-	return xfs_reflink_convert_cow_extent(ip, imap, offset_fsb, count_fsb,
-			&dfops);
+	return xfs_reflink_convert_cow_extent(ip, imap, offset_fsb, count_fsb);
 out_bmap_cancel:
 	xfs_defer_cancel(&dfops);
 	xfs_trans_unreserve_quota_nblks(tp, ip, (long)resblks, 0,
-- 
2.17.1

