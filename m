Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0507UM5158255 for <xfs@oss.sgi.com>; Mon, 4 Jan 2010 18:07:30 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 48B43EC63BB
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2010 16:08:18 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	3KZL0I75DQj0tRVJ for <xfs@oss.sgi.com>;
	Mon, 04 Jan 2010 16:08:18 -0800 (PST)
Received: from discord (unverified [121.44.238.220])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	10928640-1927428
	for <xfs@oss.sgi.com>; Tue, 05 Jan 2010 10:38:17 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NRwy7-00069U-JE
	for xfs@oss.sgi.com; Tue, 05 Jan 2010 11:08:15 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NRwuQ-0007R9-2E
	for xfs@oss.sgi.com; Tue, 05 Jan 2010 11:04:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/3] xfs: Don't issue buffer IO direct from AIL push
Date: Tue,  5 Jan 2010 11:04:20 +1100
Message-Id: <1262649861-28530-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1262649861-28530-1-git-send-email-david@fromorbit.com>
References: <1262649861-28530-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

All buffers logged into the AIL are marked as delayed write.
When the AIL needs to push the buffer out, it issues an async write of the
buffer. This means that IO patterns are dependent on the order of
buffers in the AIL.

Instead of flushing the buffer, promote the buffer in the delayed
write list so that the next time the xfsbufd is run the buffer will
be flushed by the xfsbufd. Return the state to the xfsaild that the
buffer was promoted so that the xfsaild knows that it needs to cause
the xfsbufd to run to flush the buffers that were promoted.

Using the xfsbufd for issuing the IO allows us to dispatch all
buffer IO from the one queue. This means that we can make much more
enlightened decisions on what order to flush buffers to disk as
we don't have multiple places issuing IO. Optimisations to xfsbufd
will be in a future patch.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_buf.c    |   22 +++++++++
 fs/xfs/linux-2.6/xfs_buf.h    |   11 +++++
 fs/xfs/linux-2.6/xfs_trace.h  |    1 +
 fs/xfs/quota/xfs_dquot_item.c |   87 +++++------------------------------
 fs/xfs/quota/xfs_dquot_item.h |    4 --
 fs/xfs/xfs_buf_item.c         |   64 ++++++++++++++------------
 fs/xfs/xfs_inode_item.c       |   99 ++++++----------------------------------
 fs/xfs/xfs_inode_item.h       |    6 ---
 fs/xfs/xfs_trans_ail.c        |    7 +++
 9 files changed, 104 insertions(+), 197 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 759cbaf..aaefc33 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -1631,6 +1631,28 @@ xfs_buf_delwri_dequeue(
 	trace_xfs_buf_delwri_dequeue(bp, _RET_IP_);
 }
 
+/*
+ * If a delwri buffer needs to be pushed before it has aged out, then
+ * promote it to the head of the delwri queue so that it will be flushed
+ * on the next xfsbufd run.
+ */
+void
+xfs_buf_delwri_promote(
+	xfs_buf_t	*bp)
+{
+	struct list_head *dwq = &bp->b_target->bt_delwrite_queue;
+	spinlock_t	*dwlk = &bp->b_target->bt_delwrite_lock;
+	long		age = xfs_buf_age_centisecs * msecs_to_jiffies(10) + 1;
+
+	spin_lock(dwlk);
+	ASSERT(bp->b_flags & XBF_DELWRI);
+	ASSERT(bp->b_flags & _XBF_DELWRI_Q);
+	list_del(&bp->b_list);
+	list_add(&bp->b_list, dwq);
+	bp->b_queuetime = jiffies - age;
+	spin_unlock(dwlk);
+}
+
 STATIC void
 xfs_buf_runall_queues(
 	struct workqueue_struct	*queue)
diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
index a34c7b5..a7c6895 100644
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -261,6 +261,7 @@ extern int xfs_buf_ispin(xfs_buf_t *);
 
 /* Delayed Write Buffer Routines */
 extern void xfs_buf_delwri_dequeue(xfs_buf_t *);
+extern void xfs_buf_delwri_promote(xfs_buf_t *);
 
 /* Buffer Daemon Setup Routines */
 extern int xfs_buf_init(void);
@@ -424,6 +425,16 @@ extern void xfs_free_buftarg(struct xfs_mount *, struct xfs_buftarg *);
 extern void xfs_wait_buftarg(xfs_buftarg_t *);
 extern int xfs_setsize_buftarg(xfs_buftarg_t *, unsigned int, unsigned int);
 extern int xfs_flush_buftarg(xfs_buftarg_t *, int);
+
+/*
+ * run the xfsbufd on demand to age buffers. Use in combination with
+ * xfs_buf_delwri_promote() to flus delayed write buffers efficiently.
+ */
+static inline void xfs_flush_buftarg_delwri(xfs_buftarg_t *btp)
+{
+	wake_up_process(btp->bt_task);
+}
+
 #ifdef CONFIG_KDB_MODULES
 extern struct list_head *xfs_get_buftarg_list(void);
 #endif
diff --git a/fs/xfs/linux-2.6/xfs_trace.h b/fs/xfs/linux-2.6/xfs_trace.h
index 2b0819a..bba87b7 100644
--- a/fs/xfs/linux-2.6/xfs_trace.h
+++ b/fs/xfs/linux-2.6/xfs_trace.h
@@ -464,6 +464,7 @@ DEFINE_BUF_ITEM_EVENT(xfs_buf_item_unlock);
 DEFINE_BUF_ITEM_EVENT(xfs_buf_item_unlock_stale);
 DEFINE_BUF_ITEM_EVENT(xfs_buf_item_committed);
 DEFINE_BUF_ITEM_EVENT(xfs_buf_item_push);
+DEFINE_BUF_ITEM_EVENT(xfs_buf_item_pushbuf);
 DEFINE_BUF_ITEM_EVENT(xfs_trans_get_buf);
 DEFINE_BUF_ITEM_EVENT(xfs_trans_get_buf_recur);
 DEFINE_BUF_ITEM_EVENT(xfs_trans_getsb);
diff --git a/fs/xfs/quota/xfs_dquot_item.c b/fs/xfs/quota/xfs_dquot_item.c
index d0d4a9a..bc7e00e 100644
--- a/fs/xfs/quota/xfs_dquot_item.c
+++ b/fs/xfs/quota/xfs_dquot_item.c
@@ -212,68 +212,33 @@ xfs_qm_dquot_logitem_pushbuf(
 	xfs_dquot_t	*dqp;
 	xfs_mount_t	*mp;
 	xfs_buf_t	*bp;
-	uint		dopush;
 
 	dqp = qip->qli_dquot;
 	ASSERT(XFS_DQ_IS_LOCKED(dqp));
 
 	/*
-	 * The qli_pushbuf_flag keeps others from
-	 * trying to duplicate our effort.
-	 */
-	ASSERT(qip->qli_pushbuf_flag != 0);
-	ASSERT(qip->qli_push_owner == current_pid());
-
-	/*
 	 * If flushlock isn't locked anymore, chances are that the
 	 * inode flush completed and the inode was taken off the AIL.
 	 * So, just get out.
 	 */
 	if (completion_done(&dqp->q_flush)  ||
 	    ((qip->qli_item.li_flags & XFS_LI_IN_AIL) == 0)) {
-		qip->qli_pushbuf_flag = 0;
 		xfs_dqunlock(dqp);
 		return;
 	}
 	mp = dqp->q_mount;
 	bp = xfs_incore(mp->m_ddev_targp, qip->qli_format.qlf_blkno,
-		    XFS_QI_DQCHUNKLEN(mp),
-		    XFS_INCORE_TRYLOCK);
-	if (bp != NULL) {
-		if (XFS_BUF_ISDELAYWRITE(bp)) {
-			dopush = ((qip->qli_item.li_flags & XFS_LI_IN_AIL) &&
-				  !completion_done(&dqp->q_flush));
-			qip->qli_pushbuf_flag = 0;
-			xfs_dqunlock(dqp);
-
-			if (XFS_BUF_ISPINNED(bp)) {
-				xfs_log_force(mp, (xfs_lsn_t)0,
-					      XFS_LOG_FORCE);
-			}
-			if (dopush) {
-				int	error;
-#ifdef XFSRACEDEBUG
-				delay_for_intr();
-				delay(300);
-#endif
-				error = xfs_bawrite(mp, bp);
-				if (error)
-					xfs_fs_cmn_err(CE_WARN, mp,
-	"xfs_qm_dquot_logitem_pushbuf: pushbuf error %d on qip %p, bp %p",
-							error, qip, bp);
-			} else {
-				xfs_buf_relse(bp);
-			}
-		} else {
-			qip->qli_pushbuf_flag = 0;
-			xfs_dqunlock(dqp);
-			xfs_buf_relse(bp);
-		}
+		    XFS_QI_DQCHUNKLEN(mp), XFS_INCORE_TRYLOCK);
+	if (!bp) {
+		xfs_dqunlock(dqp);
 		return;
 	}
 
-	qip->qli_pushbuf_flag = 0;
 	xfs_dqunlock(dqp);
+	if (XFS_BUF_ISDELAYWRITE(bp))
+		xfs_buf_delwri_promote(bp);
+	xfs_buf_relse(bp);
+	return;
 }
 
 /*
@@ -291,50 +256,24 @@ xfs_qm_dquot_logitem_trylock(
 	xfs_dq_logitem_t	*qip)
 {
 	xfs_dquot_t		*dqp;
-	uint			retval;
 
 	dqp = qip->qli_dquot;
 	if (atomic_read(&dqp->q_pincount) > 0)
-		return (XFS_ITEM_PINNED);
+		return XFS_ITEM_PINNED;
 
 	if (! xfs_qm_dqlock_nowait(dqp))
-		return (XFS_ITEM_LOCKED);
+		return XFS_ITEM_LOCKED;
 
-	retval = XFS_ITEM_SUCCESS;
 	if (!xfs_dqflock_nowait(dqp)) {
 		/*
-		 * The dquot is already being flushed.	It may have been
-		 * flushed delayed write, however, and we don't want to
-		 * get stuck waiting for that to complete.  So, we want to check
-		 * to see if we can lock the dquot's buffer without sleeping.
-		 * If we can and it is marked for delayed write, then we
-		 * hold it and send it out from the push routine.  We don't
-		 * want to do that now since we might sleep in the device
-		 * strategy routine.  We also don't want to grab the buffer lock
-		 * here because we'd like not to call into the buffer cache
-		 * while holding the AIL lock.
-		 * Make sure to only return PUSHBUF if we set pushbuf_flag
-		 * ourselves.  If someone else is doing it then we don't
-		 * want to go to the push routine and duplicate their efforts.
+		 * dquot has already been flushed to the backing buffer,
+		 * leave it locked, pushbuf routine will unlock it.
 		 */
-		if (qip->qli_pushbuf_flag == 0) {
-			qip->qli_pushbuf_flag = 1;
-			ASSERT(qip->qli_format.qlf_blkno == dqp->q_blkno);
-#ifdef DEBUG
-			qip->qli_push_owner = current_pid();
-#endif
-			/*
-			 * The dquot is left locked.
-			 */
-			retval = XFS_ITEM_PUSHBUF;
-		} else {
-			retval = XFS_ITEM_FLUSHING;
-			xfs_dqunlock_nonotify(dqp);
-		}
+		return XFS_ITEM_PUSHBUF;
 	}
 
 	ASSERT(qip->qli_item.li_flags & XFS_LI_IN_AIL);
-	return (retval);
+	return XFS_ITEM_SUCCESS;
 }
 
 
diff --git a/fs/xfs/quota/xfs_dquot_item.h b/fs/xfs/quota/xfs_dquot_item.h
index 5a63253..5acae2a 100644
--- a/fs/xfs/quota/xfs_dquot_item.h
+++ b/fs/xfs/quota/xfs_dquot_item.h
@@ -27,10 +27,6 @@ typedef struct xfs_dq_logitem {
 	xfs_log_item_t		 qli_item;	   /* common portion */
 	struct xfs_dquot	*qli_dquot;	   /* dquot ptr */
 	xfs_lsn_t		 qli_flush_lsn;	   /* lsn at last flush */
-	unsigned short		 qli_pushbuf_flag; /* 1 bit used in push_ail */
-#ifdef DEBUG
-	uint64_t		 qli_push_owner;
-#endif
 	xfs_dq_logformat_t	 qli_format;	   /* logged structure */
 } xfs_dq_logitem_t;
 
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index a30f7e9..0f30250 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -467,8 +467,10 @@ xfs_buf_item_unpin_remove(
 /*
  * This is called to attempt to lock the buffer associated with this
  * buf log item.  Don't sleep on the buffer lock.  If we can't get
- * the lock right away, return 0.  If we can get the lock, pull the
- * buffer from the free list, mark it busy, and return 1.
+ * the lock right away, return 0.  If we can get the lock, take a
+ * reference to the buffer. If this is a delayed write buffer that
+ * needs AIL help to be written back, invoke the pushbuf routine
+ * rather than the normal success path.
  */
 STATIC uint
 xfs_buf_item_trylock(
@@ -477,24 +479,18 @@ xfs_buf_item_trylock(
 	xfs_buf_t	*bp;
 
 	bp = bip->bli_buf;
-
-	if (XFS_BUF_ISPINNED(bp)) {
+	if (XFS_BUF_ISPINNED(bp))
 		return XFS_ITEM_PINNED;
-	}
-
-	if (!XFS_BUF_CPSEMA(bp)) {
+	if (!XFS_BUF_CPSEMA(bp))
 		return XFS_ITEM_LOCKED;
-	}
 
-	/*
-	 * Remove the buffer from the free list.  Only do this
-	 * if it's on the free list.  Private buffers like the
-	 * superblock buffer are not.
-	 */
+	/* take a reference to the buffer.  */
 	XFS_BUF_HOLD(bp);
 
 	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
 	trace_xfs_buf_item_trylock(bip);
+	if (XFS_BUF_ISDELAYWRITE(bp))
+		return XFS_ITEM_PUSHBUF;
 	return XFS_ITEM_SUCCESS;
 }
 
@@ -626,11 +622,9 @@ xfs_buf_item_committed(
 }
 
 /*
- * This is called to asynchronously write the buffer associated with this
- * buf log item out to disk. The buffer will already have been locked by
- * a successful call to xfs_buf_item_trylock().  If the buffer still has
- * B_DELWRI set, then get it going out to disk with a call to bawrite().
- * If not, then just release the buffer.
+ * The buffer is locked, but is not a delayed write buffer. This happens
+ * if we race with IO completion and hence we don't want to try to write it
+ * again. Just release the buffer.
  */
 STATIC void
 xfs_buf_item_push(
@@ -642,17 +636,29 @@ xfs_buf_item_push(
 	trace_xfs_buf_item_push(bip);
 
 	bp = bip->bli_buf;
+	ASSERT(!XFS_BUF_ISDELAYWRITE(bp));
+	xfs_buf_relse(bp);
+}
 
-	if (XFS_BUF_ISDELAYWRITE(bp)) {
-		int	error;
-		error = xfs_bawrite(bip->bli_item.li_mountp, bp);
-		if (error)
-			xfs_fs_cmn_err(CE_WARN, bip->bli_item.li_mountp,
-			"xfs_buf_item_push: pushbuf error %d on bip %p, bp %p",
-					error, bip, bp);
-	} else {
-		xfs_buf_relse(bp);
-	}
+/*
+ * The buffer is locked and is a delayed write buffer. Promote the buffer
+ * in the delayed write queue as the caller knows that they must invoke
+ * the xfsbufd to get this buffer written. We have to unlock the buffer
+ * to allow the xfsbufd to write it, too.
+ */
+STATIC void
+xfs_buf_item_pushbuf(
+	xfs_buf_log_item_t	*bip)
+{
+	xfs_buf_t	*bp;
+
+	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
+	trace_xfs_buf_item_pushbuf(bip);
+
+	bp = bip->bli_buf;
+	ASSERT(XFS_BUF_ISDELAYWRITE(bp));
+	xfs_buf_delwri_promote(bp);
+	xfs_buf_relse(bp);
 }
 
 /* ARGSUSED */
@@ -677,7 +683,7 @@ static struct xfs_item_ops xfs_buf_item_ops = {
 	.iop_committed	= (xfs_lsn_t(*)(xfs_log_item_t*, xfs_lsn_t))
 					xfs_buf_item_committed,
 	.iop_push	= (void(*)(xfs_log_item_t*))xfs_buf_item_push,
-	.iop_pushbuf	= NULL,
+	.iop_pushbuf	= (void(*)(xfs_log_item_t*))xfs_buf_item_pushbuf,
 	.iop_committing = (void(*)(xfs_log_item_t*, xfs_lsn_t))
 					xfs_buf_item_committing
 };
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index beb7d9f..0c4e719 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -602,33 +602,20 @@ xfs_inode_item_trylock(
 
 	if (!xfs_iflock_nowait(ip)) {
 		/*
-		 * If someone else isn't already trying to push the inode
-		 * buffer, we get to do it.
+		 * inode has already been flushed to the backing buffer,
+		 * leave it locked in shared mode, pushbuf routine will
+		 * unlock it.
 		 */
-		if (iip->ili_pushbuf_flag == 0) {
-			iip->ili_pushbuf_flag = 1;
-#ifdef DEBUG
-			iip->ili_push_owner = current_pid();
-#endif
-			/*
-			 * Inode is left locked in shared mode.
-			 * Pushbuf routine gets to unlock it.
-			 */
-			return XFS_ITEM_PUSHBUF;
-		} else {
-			/*
-			 * We hold the AIL lock, so we must specify the
-			 * NONOTIFY flag so that we won't double trip.
-			 */
-			xfs_iunlock(ip, XFS_ILOCK_SHARED|XFS_IUNLOCK_NONOTIFY);
-			return XFS_ITEM_FLUSHING;
-		}
-		/* NOTREACHED */
+		return XFS_ITEM_PUSHBUF;
 	}
 
 	/* Stale items should force out the iclog */
 	if (ip->i_flags & XFS_ISTALE) {
 		xfs_ifunlock(ip);
+		/*
+		 * we hold the AIL lock - notify the unlock routine of this
+		 * so it doesn't try to get the lock again.
+		 */
 		xfs_iunlock(ip, XFS_ILOCK_SHARED|XFS_IUNLOCK_NONOTIFY);
 		return XFS_ITEM_PINNED;
 	}
@@ -746,11 +733,8 @@ xfs_inode_item_committed(
  * This gets called by xfs_trans_push_ail(), when IOP_TRYLOCK
  * failed to get the inode flush lock but did get the inode locked SHARED.
  * Here we're trying to see if the inode buffer is incore, and if so whether it's
- * marked delayed write. If that's the case, we'll initiate a bawrite on that
- * buffer to expedite the process.
- *
- * We aren't holding the AIL lock (or the flush lock) when this gets called,
- * so it is inherently race-y.
+ * marked delayed write. If that's the case, we'll promote it and that will
+ * allow the caller to write the buffer by triggering the xfsbufd to run.
  */
 STATIC void
 xfs_inode_item_pushbuf(
@@ -759,26 +743,16 @@ xfs_inode_item_pushbuf(
 	xfs_inode_t	*ip;
 	xfs_mount_t	*mp;
 	xfs_buf_t	*bp;
-	uint		dopush;
 
 	ip = iip->ili_inode;
-
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED));
 
 	/*
-	 * The ili_pushbuf_flag keeps others from
-	 * trying to duplicate our effort.
-	 */
-	ASSERT(iip->ili_pushbuf_flag != 0);
-	ASSERT(iip->ili_push_owner == current_pid());
-
-	/*
 	 * If a flush is not in progress anymore, chances are that the
 	 * inode was taken off the AIL. So, just get out.
 	 */
 	if (completion_done(&ip->i_flush) ||
 	    ((iip->ili_item.li_flags & XFS_LI_IN_AIL) == 0)) {
-		iip->ili_pushbuf_flag = 0;
 		xfs_iunlock(ip, XFS_ILOCK_SHARED);
 		return;
 	}
@@ -787,54 +761,12 @@ xfs_inode_item_pushbuf(
 	bp = xfs_incore(mp->m_ddev_targp, iip->ili_format.ilf_blkno,
 		    iip->ili_format.ilf_len, XFS_INCORE_TRYLOCK);
 
-	if (bp != NULL) {
-		if (XFS_BUF_ISDELAYWRITE(bp)) {
-			/*
-			 * We were racing with iflush because we don't hold
-			 * the AIL lock or the flush lock. However, at this point,
-			 * we have the buffer, and we know that it's dirty.
-			 * So, it's possible that iflush raced with us, and
-			 * this item is already taken off the AIL.
-			 * If not, we can flush it async.
-			 */
-			dopush = ((iip->ili_item.li_flags & XFS_LI_IN_AIL) &&
-				  !completion_done(&ip->i_flush));
-			iip->ili_pushbuf_flag = 0;
-			xfs_iunlock(ip, XFS_ILOCK_SHARED);
-
-			trace_xfs_inode_item_push(bp, _RET_IP_);
-
-			if (XFS_BUF_ISPINNED(bp)) {
-				xfs_log_force(mp, (xfs_lsn_t)0,
-					      XFS_LOG_FORCE);
-			}
-			if (dopush) {
-				int	error;
-				error = xfs_bawrite(mp, bp);
-				if (error)
-					xfs_fs_cmn_err(CE_WARN, mp,
-		"xfs_inode_item_pushbuf: pushbuf error %d on iip %p, bp %p",
-							error, iip, bp);
-			} else {
-				xfs_buf_relse(bp);
-			}
-		} else {
-			iip->ili_pushbuf_flag = 0;
-			xfs_iunlock(ip, XFS_ILOCK_SHARED);
-			xfs_buf_relse(bp);
-		}
-		return;
-	}
-	/*
-	 * We have to be careful about resetting pushbuf flag too early (above).
-	 * Even though in theory we can do it as soon as we have the buflock,
-	 * we don't want others to be doing work needlessly. They'll come to
-	 * this function thinking that pushing the buffer is their
-	 * responsibility only to find that the buffer is still locked by
-	 * another doing the same thing
-	 */
-	iip->ili_pushbuf_flag = 0;
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+	if (!bp)
+		return;
+	if (XFS_BUF_ISDELAYWRITE(bp))
+		xfs_buf_delwri_promote(bp);
+	xfs_buf_relse(bp);
 	return;
 }
 
@@ -938,7 +870,6 @@ xfs_inode_item_init(
 	/*
 	   We have zeroed memory. No need ...
 	   iip->ili_extents_buf = NULL;
-	   iip->ili_pushbuf_flag = 0;
 	 */
 
 	iip->ili_format.ilf_type = XFS_LI_INODE;
diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
index cc8df1a..9a46795 100644
--- a/fs/xfs/xfs_inode_item.h
+++ b/fs/xfs/xfs_inode_item.h
@@ -144,12 +144,6 @@ typedef struct xfs_inode_log_item {
 						      data exts */
 	struct xfs_bmbt_rec	*ili_aextents_buf; /* array of logged
 						      attr exts */
-	unsigned int            ili_pushbuf_flag;  /* one bit used in push_ail */
-
-#ifdef DEBUG
-	uint64_t                ili_push_owner;    /* one who sets pushbuf_flag
-						      above gets to push the buf */
-#endif
 #ifdef XFS_TRANS_DEBUG
 	int			ili_root_size;
 	char			*ili_orig_root;
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 063dfbd..feb779a 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -253,6 +253,7 @@ xfsaild_push(
 	int		flush_log, count, stuck;
 	xfs_mount_t	*mp = ailp->xa_mount;
 	struct xfs_ail_cursor	*cur = &ailp->xa_cursors;
+	int		push_xfsbufd = 0;
 
 	spin_lock(&ailp->xa_lock);
 	xfs_trans_ail_cursor_init(ailp, cur);
@@ -308,6 +309,7 @@ xfsaild_push(
 			XFS_STATS_INC(xs_push_ail_pushbuf);
 			IOP_PUSHBUF(lip);
 			last_pushed_lsn = lsn;
+			push_xfsbufd = 1;
 			break;
 
 		case XFS_ITEM_PINNED:
@@ -374,6 +376,11 @@ xfsaild_push(
 		xfs_log_force(mp, (xfs_lsn_t)0, XFS_LOG_FORCE);
 	}
 
+	if (push_xfsbufd) {
+		/* we've got delayed write buffers to flush */
+		xfs_flush_buftarg_delwri(mp->m_ddev_targp);
+	}
+
 	if (!count) {
 		/* We're past our target or empty, so idle */
 		last_pushed_lsn = 0;
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
