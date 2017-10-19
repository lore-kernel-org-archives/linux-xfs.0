Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:39827 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753807AbdJSOVb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2017 10:21:31 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/18] iomap_dio_rw: Allocate AIO completion queue before submitting dio
Date: Thu, 19 Oct 2017 16:21:06 +0200
Message-Id: <20171019142123.18109-2-hch@lst.de>
In-Reply-To: <20171019142123.18109-1-hch@lst.de>
References: <20171019142123.18109-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Chandan Rajendra <chandan@linux.vnet.ibm.com>, "Darrick J . Wong" <darrick.wong@oracle.com>

From: Chandan Rajendra <chandan@linux.vnet.ibm.com>

commit 546e7be8244dc050effef0555df5b8d94d10dafc upstream.

Executing xfs/104 test in a loop on Linux-v4.13 kernel on a ppc64
machine can cause the following NULL pointer dereference,

.queue_work_on+0x4c/0x80
.iomap_dio_bio_end_io+0xbc/0x1f0
.bio_endio+0x118/0x1f0
.blk_update_request+0xd0/0x470
.blk_mq_end_request+0x24/0xc0
.lo_complete_rq+0x40/0xe0
.__blk_mq_complete_request_remote+0x28/0x40
.flush_smp_call_function_queue+0xc4/0x1e0
.smp_ipi_demux_relaxed+0x8c/0x100
.icp_hv_ipi_action+0x54/0xa0
.__handle_irq_event_percpu+0x84/0x2c0
.handle_irq_event_percpu+0x28/0x80
.handle_percpu_irq+0x78/0xc0
.generic_handle_irq+0x40/0x70
.__do_irq+0x88/0x200
.call_do_irq+0x14/0x24
.do_IRQ+0x84/0x130

This occurs due to the following sequence of events,

1. Allocate dio for Direct I/O write.
2. Invoke iomap_apply() until iov_iter_count() bytes have been submitted.
   - Assume that we have submitted atleast one bio. Hence iomap_dio->ref value
     will be >= 2.
   - If during the second iteration, iomap_apply() ends up returning -ENOSPC, we would
     break out of the loop and since the 'ret' value is a negative number we
     end up not allocating memory for super_block->s_dio_done_wq.
3. Meanwhile, iomap_dio_bio_end_io() is invoked for bios that have been
   submitted and here the code ends up dereferencing the NULL pointer stored
   at super_block->s_dio_done_wq.

This commit fixes the bug by allocating memory for
super_block->s_dio_done_wq before iomap_apply() is invoked.

Reported-by: Eryu Guan <eguan@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: Eryu Guan <eguan@redhat.com>
Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/iomap.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index 59cc98ad7577..b8a91064abc6 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -993,6 +993,13 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 	WARN_ON_ONCE(ret);
 	ret = 0;
 
+	if (iov_iter_rw(iter) == WRITE && !is_sync_kiocb(iocb) &&
+	    !inode->i_sb->s_dio_done_wq) {
+		ret = sb_init_dio_done_wq(inode->i_sb);
+		if (ret < 0)
+			goto out_free_dio;
+	}
+
 	inode_dio_begin(inode);
 
 	blk_start_plug(&plug);
@@ -1015,13 +1022,6 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 	if (ret < 0)
 		iomap_dio_set_error(dio, ret);
 
-	if (ret >= 0 && iov_iter_rw(iter) == WRITE && !is_sync_kiocb(iocb) &&
-			!inode->i_sb->s_dio_done_wq) {
-		ret = sb_init_dio_done_wq(inode->i_sb);
-		if (ret < 0)
-			iomap_dio_set_error(dio, ret);
-	}
-
 	if (!atomic_dec_and_test(&dio->ref)) {
 		if (!is_sync_kiocb(iocb))
 			return -EIOCBQUEUED;
-- 
2.14.2

