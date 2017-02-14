Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37668 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752584AbdBNNDP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 14 Feb 2017 08:03:15 -0500
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A94383A769D
        for <linux-xfs@vger.kernel.org>; Tue, 14 Feb 2017 13:03:10 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id v1ED3AvS020228
        for <linux-xfs@vger.kernel.org>; Tue, 14 Feb 2017 08:03:10 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 1/4] xfs: clear delalloc and cache on buffered write failure
Date: Tue, 14 Feb 2017 08:03:06 -0500
Message-Id: <1487077389-5626-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1487077389-5626-1-git-send-email-bfoster@redhat.com>
References: <1487077389-5626-1-git-send-email-bfoster@redhat.com>
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
---
 fs/xfs/xfs_iomap.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index e0bc290..e2fbed4 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1079,6 +1079,8 @@ xfs_file_iomap_end_delalloc(
 	int			error = 0;
 
 	start_fsb = XFS_B_TO_FSB(mp, offset + written);
+	if (unlikely(!written))
+		start_fsb = XFS_B_TO_FSBT(mp, offset);
 	end_fsb = XFS_B_TO_FSB(mp, offset + length);
 
 	/*
@@ -1090,6 +1092,9 @@ xfs_file_iomap_end_delalloc(
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

