Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6807C7F37
	for <xfs@oss.sgi.com>; Thu, 18 Sep 2014 13:54:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EB037AC009
	for <xfs@oss.sgi.com>; Thu, 18 Sep 2014 11:54:24 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id vTTVgjjpN9KxCeWW (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 18 Sep 2014 11:54:23 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s8IIsM12000664
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Thu, 18 Sep 2014 14:54:22 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s8IIsL8i005118
	for <xfs@oss.sgi.com>; Thu, 18 Sep 2014 14:54:21 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: restore buffer_head unwritten bit on ioend cancel
Date: Thu, 18 Sep 2014 14:54:20 -0400
Message-Id: <1411066460-23992-1-git-send-email-bfoster@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

xfs_vm_writepage() walks each buffer_head on the page, maps to the block
on disk and attaches to a running ioend structure that represents the
I/O submission. A new ioend is created when the type of I/O (unwritten,
delayed allocation or overwrite) required for a particular buffer_head
differs from the previous. If a buffer_head is a delalloc or unwritten
buffer, the associated bits are cleared by xfs_map_at_offset() once the
buffer_head is added to the ioend.

The process of mapping each buffer_head occurs in xfs_map_blocks() and
acquires the ilock in blocking or non-blocking mode, depending on the
type of writeback in progress. If the lock cannot be acquired for
non-blocking writeback, we cancel the ioend, redirty the page and
return. Writeback will revisit the page at some later point.

Note that we acquire the ilock for each buffer on the page. Therefore
during non-blocking writeback, it is possible to add an unwritten buffer
to the ioend, clear the unwritten state, fail to acquire the ilock when
mapping a subsequent buffer and cancel the ioend. If this occurs, the
unwritten status of the buffer sitting in the ioend has been lost. The
page will eventually hit writeback again, but xfs_vm_writepage() submits
overwrite I/O instead of unwritten I/O and does not perform unwritten
extent conversion at I/O completion. This leads to data corruption
because unwritten extents are treated as holes on reads and zeroes are
returned instead of reading from disk.

Modify xfs_cancel_ioend() to restore the buffer unwritten bit for ioends
of type XFS_IO_UNWRITTEN. This ensures that unwritten extent conversion
occurs once the page is eventually written back.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Hi all,

This fixes the problem I've been chasing the past few days with regard
to data corruption after hole punch. It turns out the problem isn't
directly related to the hole punch after all. I found that the problem
still occurs when I remove the truncate_pagecache_range() rounding from
xfs_free_file_space(). The difference is data is still sitting in cache
and the pages aren't thrown away until reclaimed. E.g., the file
corruption is reproducible on subsequent remount. The current method of
rounding the truncate throws the pages away such that the corruption is
detectable immediately after the hole punch.

This is only lightly tested so far with my hacky reproducer. The next
step is to turn it into a regression test. xfstests test to follow...

Brian

 fs/xfs/xfs_aops.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 2f50253..f5b2453 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -560,6 +560,13 @@ xfs_cancel_ioend(
 		do {
 			next_bh = bh->b_private;
 			clear_buffer_async_write(bh);
+			/*
+			 * The unwritten flag is cleared when added to the
+			 * ioend. We're not submitting for I/O so mark the
+			 * buffer unwritten again for next time around.
+			 */
+			if (ioend->io_type == XFS_IO_UNWRITTEN)
+				set_buffer_unwritten(bh);
 			unlock_buffer(bh);
 		} while ((bh = next_bh) != NULL);
 
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
