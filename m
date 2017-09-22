Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36204 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751860AbdIVI0f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Sep 2017 04:26:35 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v8M8NuYG036288
        for <linux-xfs@vger.kernel.org>; Fri, 22 Sep 2017 04:26:35 -0400
Received: from e16.ny.us.ibm.com (e16.ny.us.ibm.com [129.33.205.206])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2d4png9be0-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Fri, 22 Sep 2017 04:26:34 -0400
Received: from localhost
        by e16.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Fri, 22 Sep 2017 04:26:33 -0400
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH V3] iomap_dio_rw: Allocate AIO completion queue before submitting dio
Date: Fri, 22 Sep 2017 13:57:14 +0530
In-Reply-To: <20170922070753.GF10955@dastard>
References: <20170922070753.GF10955@dastard>
Message-Id: <20170922082714.14625-1-chandan@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, hch@infradead.org, eguan@redhat.com, linux-fsdevel@vger.kernel.org, david@fromorbit.com

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
---

Changelog:
v1->v2:
 1. Fix indentation for the continuation of the if conditional.
v2->v3:
 1. Remove architecture specific register dumps from the stack trace.

fs/iomap.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index 269b24a..d4f526a 100644
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
2.9.5

