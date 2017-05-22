Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52952 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933452AbdEVS3N (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 May 2017 14:29:13 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BBD17368E4
        for <linux-xfs@vger.kernel.org>; Mon, 22 May 2017 18:29:12 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9C55660F85
        for <linux-xfs@vger.kernel.org>; Mon, 22 May 2017 18:29:12 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: use atomic to provide buffer I/O accounting serialization
Date: Mon, 22 May 2017 14:29:11 -0400
Message-Id: <1495477751-3742-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

We've had user reports of unmount hangs in xfs_wait_buftarg() that
analysis shows is due to btp->bt_io_count == -1. bt_io_count
represents the count of in-flight asynchronous buffers and thus
should always be >= 0. xfs_wait_buftarg() waits for this value to
stabilize to zero in order to ensure that all untracked (with
respect to the lru) buffers have completed I/O processing before
unmount proceeds to tear down in-core data structures.

The value of -1 implies an I/O accounting decrement race. Indeed,
the fact that xfs_buf_ioacct_dec() is called from xfs_buf_rele()
(where the buffer lock is no longer held) means that bp->b_flags can
be updated from an unsafe context. While a user-level reproducer is
currently not available, some intrusive hacks to run racing buffer
lookups/ioacct/releases from multiple threads was used to
successfully manufacture this problem.

Existing callers do not expect to acquire the buffer lock from
xfs_buf_rele(). Therefore, we can not safely update ->b_flags from
this context. To close the race, replace the in-flight buffer flag
with a per-buffer atomic for tracking accounting against the
buftarg. This field resides in a hole in the existing data structure
and thus does not increase the size of xfs_buf.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_buf.c | 13 +++++--------
 fs/xfs/xfs_buf.h |  5 ++---
 2 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index ba036c1..f0172d8 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -97,12 +97,12 @@ static inline void
 xfs_buf_ioacct_inc(
 	struct xfs_buf	*bp)
 {
-	if (bp->b_flags & (XBF_NO_IOACCT|_XBF_IN_FLIGHT))
+	if (bp->b_flags & XBF_NO_IOACCT)
 		return;
 
 	ASSERT(bp->b_flags & XBF_ASYNC);
-	bp->b_flags |= _XBF_IN_FLIGHT;
-	percpu_counter_inc(&bp->b_target->bt_io_count);
+	if (atomic_add_unless(&bp->b_in_flight, 1, 1))
+		percpu_counter_inc(&bp->b_target->bt_io_count);
 }
 
 /*
@@ -113,11 +113,8 @@ static inline void
 xfs_buf_ioacct_dec(
 	struct xfs_buf	*bp)
 {
-	if (!(bp->b_flags & _XBF_IN_FLIGHT))
-		return;
-
-	bp->b_flags &= ~_XBF_IN_FLIGHT;
-	percpu_counter_dec(&bp->b_target->bt_io_count);
+	if (atomic_dec_if_positive(&bp->b_in_flight) == 0)
+		percpu_counter_dec(&bp->b_target->bt_io_count);
 }
 
 /*
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 8d1d44f..f351fc1 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -63,7 +63,6 @@ typedef enum {
 #define _XBF_KMEM	 (1 << 21)/* backed by heap memory */
 #define _XBF_DELWRI_Q	 (1 << 22)/* buffer on a delwri queue */
 #define _XBF_COMPOUND	 (1 << 23)/* compound buffer */
-#define _XBF_IN_FLIGHT	 (1 << 25) /* I/O in flight, for accounting purposes */
 
 typedef unsigned int xfs_buf_flags_t;
 
@@ -84,8 +83,7 @@ typedef unsigned int xfs_buf_flags_t;
 	{ _XBF_PAGES,		"PAGES" }, \
 	{ _XBF_KMEM,		"KMEM" }, \
 	{ _XBF_DELWRI_Q,	"DELWRI_Q" }, \
-	{ _XBF_COMPOUND,	"COMPOUND" }, \
-	{ _XBF_IN_FLIGHT,	"IN_FLIGHT" }
+	{ _XBF_COMPOUND,	"COMPOUND" }
 
 
 /*
@@ -207,6 +205,7 @@ typedef struct xfs_buf {
 	int			b_retries;
 	unsigned long		b_first_retry_time; /* in jiffies */
 	int			b_last_error;
+	atomic_t		b_in_flight;
 
 	const struct xfs_buf_ops	*b_ops;
 
-- 
2.7.4

