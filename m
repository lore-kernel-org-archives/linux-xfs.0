Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D74697F5D
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 23:34:47 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C410B8F8035
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 21:34:47 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	lcFirjKvl8yji8dO for <xfs@oss.sgi.com>;
	Wed, 11 Dec 2013 21:34:46 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Vqyv2-0000bq-Cd
	for xfs@oss.sgi.com; Thu, 12 Dec 2013 16:34:40 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Vqyv2-0003cj-Bf
	for xfs@oss.sgi.com; Thu, 12 Dec 2013 16:34:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/6] xfs: abort metadata writeback on permanent errors
Date: Thu, 12 Dec 2013 16:34:38 +1100
Message-Id: <1386826478-13846-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1386826478-13846-1-git-send-email-david@fromorbit.com>
References: <1386826478-13846-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

If we are doing aysnc writeback of metadata, we can get write errors
but have nobody to report them to. At the moment, we simply attempt
to reissue the write from io completion in the hope that it's a
transient error.

When it's not a transient error, the buffer is stuck forever in
this loop, and we cannot break out of it. Eventually, unmount will
hang because the AIL cannot be emptied and everything goes downhill
from them.

To solve this problem, only retry the write IO once before aborting
it. We don't throw the buffer away because some transient errors can
last minutes (e.g.  FC path failover) or even hours (thin
provisioned devices that have run out of backing space) before they
go away. Hence we really want to keep trying until we can't try any
more.

Because the buffer was not cleaned, however, it does not get removed
from the AIL and hence the next pass across the AIL will start IO on
it again. As such, we still get the "retry forever" semantics that
we currently have, but we allow other access to the buffer in the
mean time. Meanwhile the filesystem can continue to modify the
buffer and relog it, so the IO errors won't hang the log or the
filesystem.

Now when we are pushing the AIL, we can see all these "permanent IO
error" buffers and we can issue a warning about failures before we
retry the IO. We can also catch these buffers when unmounting an
issue a corruption warning, too.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c      | 10 ++++++++--
 fs/xfs/xfs_buf.h      |  6 +++++-
 fs/xfs/xfs_buf_item.c | 21 +++++++++++++++++++--
 3 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 27dc152..402e050 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1153,7 +1153,7 @@ xfs_bwrite(
 	ASSERT(xfs_buf_islocked(bp));
 
 	bp->b_flags |= XBF_WRITE;
-	bp->b_flags &= ~(XBF_ASYNC | XBF_READ | _XBF_DELWRI_Q);
+	bp->b_flags &= ~(XBF_ASYNC | XBF_READ | _XBF_DELWRI_Q | XBF_WRITE_FAIL);
 
 	xfs_bdstrat_cb(bp);
 
@@ -1525,6 +1525,12 @@ xfs_wait_buftarg(
 			struct xfs_buf *bp;
 			bp = list_first_entry(&dispose, struct xfs_buf, b_lru);
 			list_del_init(&bp->b_lru);
+			if (bp->b_flags & XBF_WRITE_FAIL) {
+				xfs_alert(btp->bt_mount,
+"Corruption Alert: Buffer at block 0x%llx had permanent write failures!\n"
+"Please run xfs_repair to determine the extent of the problem.",
+					(long long)bp->b_bn);
+			}
 			xfs_buf_rele(bp);
 		}
 		if (loop++ != 0)
@@ -1798,7 +1804,7 @@ __xfs_buf_delwri_submit(
 
 	blk_start_plug(&plug);
 	list_for_each_entry_safe(bp, n, io_list, b_list) {
-		bp->b_flags &= ~(_XBF_DELWRI_Q | XBF_ASYNC);
+		bp->b_flags &= ~(_XBF_DELWRI_Q | XBF_ASYNC | XBF_WRITE_FAIL);
 		bp->b_flags |= XBF_WRITE;
 
 		if (!wait) {
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index e656833..614097e 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -45,6 +45,7 @@ typedef enum {
 #define XBF_ASYNC	 (1 << 4) /* initiator will not wait for completion */
 #define XBF_DONE	 (1 << 5) /* all pages in the buffer uptodate */
 #define XBF_STALE	 (1 << 6) /* buffer has been staled, do not find it */
+#define XBF_WRITE_FAIL	 (1 << 24)/* async writes have failed on this buffer */
 
 /* I/O hints for the BIO layer */
 #define XBF_SYNCIO	 (1 << 10)/* treat this buffer as synchronous I/O */
@@ -70,6 +71,7 @@ typedef unsigned int xfs_buf_flags_t;
 	{ XBF_ASYNC,		"ASYNC" }, \
 	{ XBF_DONE,		"DONE" }, \
 	{ XBF_STALE,		"STALE" }, \
+	{ XBF_WRITE_FAIL,	"WRITE_FAIL" }, \
 	{ XBF_SYNCIO,		"SYNCIO" }, \
 	{ XBF_FUA,		"FUA" }, \
 	{ XBF_FLUSH,		"FLUSH" }, \
@@ -80,6 +82,7 @@ typedef unsigned int xfs_buf_flags_t;
 	{ _XBF_DELWRI_Q,	"DELWRI_Q" }, \
 	{ _XBF_COMPOUND,	"COMPOUND" }
 
+
 /*
  * Internal state flags.
  */
@@ -301,7 +304,8 @@ extern void xfs_buf_terminate(void);
 
 #define XFS_BUF_ZEROFLAGS(bp) \
 	((bp)->b_flags &= ~(XBF_READ|XBF_WRITE|XBF_ASYNC| \
-			    XBF_SYNCIO|XBF_FUA|XBF_FLUSH))
+			    XBF_SYNCIO|XBF_FUA|XBF_FLUSH| \
+			    XBF_WRITE_FAIL))
 
 void xfs_buf_stale(struct xfs_buf *bp);
 #define XFS_BUF_UNSTALE(bp)	((bp)->b_flags &= ~XBF_STALE)
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index a64f67b..2227b9b 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -496,6 +496,14 @@ xfs_buf_item_unpin(
 	}
 }
 
+/*
+ * Buffer IO error rate limiting. Limit it to no more than 10 messages per 30
+ * seconds so as to not spam logs too much on repeated detection of the same
+ * buffer being bad..
+ */
+
+DEFINE_RATELIMIT_STATE(xfs_buf_write_fail_rl_state, 30 * HZ, 10);
+
 STATIC uint
 xfs_buf_item_push(
 	struct xfs_log_item	*lip,
@@ -524,6 +532,14 @@ xfs_buf_item_push(
 
 	trace_xfs_buf_item_push(bip);
 
+	/* has a previous flush failed due to IO errors? */
+	if ((bp->b_flags & XBF_WRITE_FAIL) &&
+	    ___ratelimit(&xfs_buf_write_fail_rl_state, "XFS:")) {
+		xfs_warn(bp->b_target->bt_mount,
+"Detected failing async write on buffer block 0x%llx. Retrying async write.\n",
+			 (long long)bp->b_bn);
+	}
+
 	if (!xfs_buf_delwri_queue(bp, buffer_list))
 		rval = XFS_ITEM_FLUSHING;
 	xfs_buf_unlock(bp);
@@ -1096,8 +1112,9 @@ xfs_buf_iodone_callbacks(
 
 		xfs_buf_ioerror(bp, 0); /* errno of 0 unsets the flag */
 
-		if (!XFS_BUF_ISSTALE(bp)) {
-			bp->b_flags |= XBF_WRITE | XBF_ASYNC | XBF_DONE;
+		if (!(bp->b_flags & (XBF_STALE|XBF_WRITE_FAIL))) {
+			bp->b_flags |= XBF_WRITE | XBF_ASYNC |
+				       XBF_DONE | XBF_WRITE_FAIL;
 			xfs_buf_iorequest(bp);
 		} else {
 			xfs_buf_relse(bp);
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
