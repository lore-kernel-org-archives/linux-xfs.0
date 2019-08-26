Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C304C3A5A4
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 01:40:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52A772173E
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 01:40:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbfHZBkQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 25 Aug 2019 21:40:16 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:46135 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726248AbfHZBkQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 25 Aug 2019 21:40:16 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 16BBC43E13E
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2019 11:40:12 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i23zO-0000rY-H4
        for linux-xfs@vger.kernel.org; Mon, 26 Aug 2019 11:40:10 +1000
Received: from dave by discord.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i23zO-0002v4-FD
        for linux-xfs@vger.kernel.org; Mon, 26 Aug 2019 11:40:10 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/3] xfs: add kmem_alloc_io()
Date:   Mon, 26 Aug 2019 11:40:07 +1000
Message-Id: <20190826014007.10877-4-david@fromorbit.com>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190826014007.10877-1-david@fromorbit.com>
References: <20190826014007.10877-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=FmdZ9Uzk2mMA:10 a=20KFwNOVAAAA:8
        a=TxqtpdE32HQVSh9t24MA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Memory we use to submit for IO needs strict alignment to the
underlying driver contraints. Worst case, this is 512 bytes. Given
that all allocations for IO are always a power of 2 multiple of 512
bytes, the kernel heap provides natural alignment for objects of
these sizes and that suffices.

Until, of course, memory debugging of some kind is turned on (e.g.
red zones, poisoning, KASAN) and then the alignment of the heap
objects is thrown out the window. Then we get weird IO errors and
data corruption problems because drivers don't validate alignment
and do the wrong thing when passed unaligned memory buffers in bios.

TO fix this, introduce kmem_alloc_io(), which will guaranteeat least
512 byte alignment of buffers for IO, even if memory debugging
options are turned on. It is assumed that the minimum allocation
size will be 512 bytes, and that sizes will be power of 2 mulitples
of 512 bytes.

Use this everywhere we allocate buffers for IO.

This no longer fails with log recovery errors when KASAN is enabled
due to the brd driver not handling unaligned memory buffers:

# mkfs.xfs -f /dev/ram0 ; mount /dev/ram0 /mnt/test

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/kmem.c            | 66 +++++++++++++++++++++++++++++-----------
 fs/xfs/kmem.h            |  1 +
 fs/xfs/xfs_buf.c         |  5 +--
 fs/xfs/xfs_log.c         |  5 +--
 fs/xfs/xfs_log_recover.c |  4 ++-
 fs/xfs/xfs_trace.h       |  1 +
 6 files changed, 60 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
index 0a78ef0588f9..638e37c7a1ad 100644
--- a/fs/xfs/kmem.c
+++ b/fs/xfs/kmem.c
@@ -30,30 +30,24 @@ kmem_alloc(size_t size, xfs_km_flags_t flags)
 	} while (1);
 }
 
-void *
-kmem_alloc_large(size_t size, xfs_km_flags_t flags)
+
+/*
+ * __vmalloc() will allocate data pages and auxillary structures (e.g.
+ * pagetables) with GFP_KERNEL, yet we may be under GFP_NOFS context here. Hence
+ * we need to tell memory reclaim that we are in such a context via
+ * PF_MEMALLOC_NOFS to prevent memory reclaim re-entering the filesystem here
+ * and potentially deadlocking.
+ */
+static void *
+__kmem_vmalloc(size_t size, xfs_km_flags_t flags)
 {
 	unsigned nofs_flag = 0;
 	void	*ptr;
-	gfp_t	lflags;
-
-	trace_kmem_alloc_large(size, flags, _RET_IP_);
-
-	ptr = kmem_alloc(size, flags | KM_MAYFAIL);
-	if (ptr)
-		return ptr;
+	gfp_t	lflags = kmem_flags_convert(flags);
 
-	/*
-	 * __vmalloc() will allocate data pages and auxillary structures (e.g.
-	 * pagetables) with GFP_KERNEL, yet we may be under GFP_NOFS context
-	 * here. Hence we need to tell memory reclaim that we are in such a
-	 * context via PF_MEMALLOC_NOFS to prevent memory reclaim re-entering
-	 * the filesystem here and potentially deadlocking.
-	 */
 	if (flags & KM_NOFS)
 		nofs_flag = memalloc_nofs_save();
 
-	lflags = kmem_flags_convert(flags);
 	ptr = __vmalloc(size, lflags, PAGE_KERNEL);
 
 	if (flags & KM_NOFS)
@@ -62,6 +56,44 @@ kmem_alloc_large(size_t size, xfs_km_flags_t flags)
 	return ptr;
 }
 
+/*
+ * Same as kmem_alloc_large, except we guarantee the buffer returned is aligned
+ * to the @align_mask. We only guarantee alignment up to page size, we'll clamp
+ * alignment at page size if it is larger. vmalloc always returns a PAGE_SIZE
+ * aligned region.
+ */
+void *
+kmem_alloc_io(size_t size, int align_mask, xfs_km_flags_t flags)
+{
+	void	*ptr;
+
+	trace_kmem_alloc_io(size, flags, _RET_IP_);
+
+	if (WARN_ON_ONCE(align_mask >= PAGE_SIZE))
+		align_mask = PAGE_SIZE - 1;
+
+	ptr = kmem_alloc(size, flags | KM_MAYFAIL);
+	if (ptr) {
+		if (!((uintptr_t)ptr & align_mask))
+			return ptr;
+		kfree(ptr);
+	}
+	return __kmem_vmalloc(size, flags);
+}
+
+void *
+kmem_alloc_large(size_t size, xfs_km_flags_t flags)
+{
+	void	*ptr;
+
+	trace_kmem_alloc_large(size, flags, _RET_IP_);
+
+	ptr = kmem_alloc(size, flags | KM_MAYFAIL);
+	if (ptr)
+		return ptr;
+	return __kmem_vmalloc(size, flags);
+}
+
 void *
 kmem_realloc(const void *old, size_t newsize, xfs_km_flags_t flags)
 {
diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
index 267655acd426..7e2605341c16 100644
--- a/fs/xfs/kmem.h
+++ b/fs/xfs/kmem.h
@@ -59,6 +59,7 @@ kmem_flags_convert(xfs_km_flags_t flags)
 }
 
 extern void *kmem_alloc(size_t, xfs_km_flags_t);
+extern void *kmem_alloc_io(size_t size, int align_mask, xfs_km_flags_t flags);
 extern void *kmem_alloc_large(size_t size, xfs_km_flags_t);
 extern void *kmem_realloc(const void *, size_t, xfs_km_flags_t);
 static inline void  kmem_free(const void *ptr)
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index ca0849043f54..0e8ff75b873d 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -353,7 +353,8 @@ xfs_buf_allocate_memory(
 	 */
 	size = BBTOB(bp->b_length);
 	if (size < PAGE_SIZE) {
-		bp->b_addr = kmem_alloc(size, KM_NOFS);
+		int align_mask = xfs_buftarg_dma_alignment(bp->b_target);
+		bp->b_addr = kmem_alloc_io(size, align_mask, KM_NOFS);
 		if (!bp->b_addr) {
 			/* low memory - use alloc_page loop instead */
 			goto use_alloc_page;
@@ -368,7 +369,7 @@ xfs_buf_allocate_memory(
 		}
 		bp->b_offset = offset_in_page(bp->b_addr);
 		bp->b_pages = bp->b_page_array;
-		bp->b_pages[0] = virt_to_page(bp->b_addr);
+		bp->b_pages[0] = kmem_to_page(bp->b_addr);
 		bp->b_page_count = 1;
 		bp->b_flags |= _XBF_KMEM;
 		return 0;
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 7fc3c1ad36bc..7ee186e664ed 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1404,6 +1404,7 @@ xlog_alloc_log(
 	 */
 	ASSERT(log->l_iclog_size >= 4096);
 	for (i = 0; i < log->l_iclog_bufs; i++) {
+		int align_mask = xfs_buftarg_dma_alignment(mp->m_logdev_targp);
 		size_t bvec_size = howmany(log->l_iclog_size, PAGE_SIZE) *
 				sizeof(struct bio_vec);
 
@@ -1415,8 +1416,8 @@ xlog_alloc_log(
 		iclog->ic_prev = prev_iclog;
 		prev_iclog = iclog;
 
-		iclog->ic_data = kmem_alloc_large(log->l_iclog_size,
-				KM_MAYFAIL);
+		iclog->ic_data = kmem_alloc_io(log->l_iclog_size, align_mask,
+						KM_MAYFAIL);
 		if (!iclog->ic_data)
 			goto out_free_iclog;
 #ifdef DEBUG
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 13d1d3e95b88..d68dfb7b1545 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -97,6 +97,8 @@ xlog_alloc_buffer(
 	struct xlog	*log,
 	int		nbblks)
 {
+	int align_mask = xfs_buftarg_dma_alignment(log->l_targ);
+
 	/*
 	 * Pass log block 0 since we don't have an addr yet, buffer will be
 	 * verified on read.
@@ -125,7 +127,7 @@ xlog_alloc_buffer(
 	if (nbblks > 1 && log->l_sectBBsize > 1)
 		nbblks += log->l_sectBBsize;
 	nbblks = round_up(nbblks, log->l_sectBBsize);
-	return kmem_alloc_large(BBTOB(nbblks), KM_MAYFAIL);
+	return kmem_alloc_io(BBTOB(nbblks), align_mask, KM_MAYFAIL);
 }
 
 /*
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 8bb8b4704a00..eaae275ed430 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3604,6 +3604,7 @@ DEFINE_EVENT(xfs_kmem_class, name, \
 	TP_PROTO(ssize_t size, int flags, unsigned long caller_ip), \
 	TP_ARGS(size, flags, caller_ip))
 DEFINE_KMEM_EVENT(kmem_alloc);
+DEFINE_KMEM_EVENT(kmem_alloc_io);
 DEFINE_KMEM_EVENT(kmem_alloc_large);
 DEFINE_KMEM_EVENT(kmem_realloc);
 DEFINE_KMEM_EVENT(kmem_zone_alloc);
-- 
2.23.0.rc1

