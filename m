Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52682 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933157AbdBPWCN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Feb 2017 17:02:13 -0500
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4CDE14E4FC
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2017 22:02:14 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id v1GM2E4J019366
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2017 17:02:14 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2] xfs: clear delalloc and cache on buffered write failure
Date: Thu, 16 Feb 2017 17:02:12 -0500
Message-Id: <1487282532-18349-1-git-send-email-bfoster@redhat.com>
In-Reply-To: <1487077389-5626-2-git-send-email-bfoster@redhat.com>
References: <1487077389-5626-2-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The buffered write failure handling code in
xfs_file_iomap_end_delalloc() has a couple minor problems. First, if
written == 0, start_fsb is not rounded down and it fails to kill off a
delalloc block if the start offset is block unaligned. This results in a
lingering delalloc block and broken delalloc block accounting detected
at unmount time. Fix this by rounding down start_fsb in the unlikely
event that written == 0.

Second, it is possible for a failed overwrite of a delalloc extent to
leave dirty pagecache around over a hole in the file. This is because is
possible to hit ->iomap_end() on write failure before the iomap code has
attempted to allocate pagecache, and thus has no need to clean it up. If
the targeted delalloc extent was successfully written by a previous
write, however, then it does still have dirty pages when ->iomap_end()
punches out the underlying blocks. This ultimately results in writeback
over a hole. To fix this problem, unconditionally punch out the
pagecache from XFS before the associated delalloc range.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---

v2:
- Used if/else logic and added a comment.

 fs/xfs/xfs_iomap.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index e0bc290..4009e7c 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1078,7 +1078,15 @@ xfs_file_iomap_end_delalloc(
 	xfs_fileoff_t		end_fsb;
 	int			error = 0;
 
-	start_fsb = XFS_B_TO_FSB(mp, offset + written);
+	/*
+	 * start_fsb refers to the first unused block after a short write. If
+	 * nothing was written, round offset down to point at the first block in
+	 * the range.
+	 */
+	if (unlikely(!written))
+		start_fsb = XFS_B_TO_FSBT(mp, offset);
+	else
+		start_fsb = XFS_B_TO_FSB(mp, offset + written);
 	end_fsb = XFS_B_TO_FSB(mp, offset + length);
 
 	/*
@@ -1090,6 +1098,9 @@ xfs_file_iomap_end_delalloc(
 	 * blocks in the range, they are ours.
 	 */
 	if (start_fsb < end_fsb) {
+		truncate_pagecache_range(VFS_I(ip), XFS_FSB_TO_B(mp, start_fsb),
+					 XFS_FSB_TO_B(mp, end_fsb) - 1);
+
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		error = xfs_bmap_punch_delalloc_range(ip, start_fsb,
 					       end_fsb - start_fsb);
-- 
2.7.4

