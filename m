Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C66A87CBD
	for <xfs@oss.sgi.com>; Tue,  3 May 2016 12:55:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7F390304043
	for <xfs@oss.sgi.com>; Tue,  3 May 2016 10:55:50 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id BdClaPF0reYvtNKG (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 03 May 2016 10:55:49 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id C0629C003308
	for <xfs@oss.sgi.com>; Tue,  3 May 2016 17:55:48 +0000 (UTC)
Received: from zion.usersys.redhat.com (dhcp-26-103.brq.redhat.com
	[10.34.26.103])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u43HtiDS016424
	for <xfs@oss.sgi.com>; Tue, 3 May 2016 13:55:47 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 3/7] xfs: add configurable error support to metadata buffers
Date: Tue,  3 May 2016 19:55:36 +0200
Message-Id: <1462298140-12411-4-git-send-email-cmaiolino@redhat.com>
In-Reply-To: <1462298140-12411-1-git-send-email-cmaiolino@redhat.com>
References: <1462298140-12411-1-git-send-email-cmaiolino@redhat.com>
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

With the error configuration handle for async metadata write errors
in place, we can now add initial support to the IO error processing
in xfs_buf_iodone_error().

Add an infrastructure function to look up the configuration handle,
and rearrange the error handling to prepare the way for different
error handling conigurations to be used.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_buf.h      |   1 +
 fs/xfs/xfs_buf_item.c | 112 ++++++++++++++++++++++++++++++--------------------
 fs/xfs/xfs_mount.h    |   3 ++
 fs/xfs/xfs_sysfs.c    |  17 ++++++++
 4 files changed, 88 insertions(+), 45 deletions(-)

diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 4eb89bd..adef116 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -183,6 +183,7 @@ typedef struct xfs_buf {
 	unsigned int		b_page_count;	/* size of page array */
 	unsigned int		b_offset;	/* page offset in first page */
 	int			b_error;	/* error code on I/O */
+	int			b_last_error;	/* previous async I/O error */
 	const struct xfs_buf_ops	*b_ops;
 
 #ifdef XFS_BUF_LOCK_TRACKING
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 99e91a0..3a30a88 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -1042,35 +1042,22 @@ xfs_buf_do_callbacks(
 	}
 }
 
-/*
- * This is the iodone() function for buffers which have had callbacks
- * attached to them by xfs_buf_attach_iodone().  It should remove each
- * log item from the buffer's list and call the callback of each in turn.
- * When done, the buffer's fsprivate field is set to NULL and the buffer
- * is unlocked with a call to iodone().
- */
-void
-xfs_buf_iodone_callbacks(
+static bool
+xfs_buf_iodone_callback_error(
 	struct xfs_buf		*bp)
 {
 	struct xfs_log_item	*lip = bp->b_fspriv;
 	struct xfs_mount	*mp = lip->li_mountp;
 	static ulong		lasttime;
 	static xfs_buftarg_t	*lasttarg;
-
-	if (likely(!bp->b_error))
-		goto do_callbacks;
+	struct xfs_error_cfg	*cfg;
 
 	/*
 	 * If we've already decided to shutdown the filesystem because of
 	 * I/O errors, there's no point in giving this a retry.
 	 */
-	if (XFS_FORCED_SHUTDOWN(mp)) {
-		xfs_buf_stale(bp);
-		bp->b_flags |= XBF_DONE;
-		trace_xfs_buf_item_iodone(bp, _RET_IP_);
-		goto do_callbacks;
-	}
+	if (XFS_FORCED_SHUTDOWN(mp))
+		goto out_stale;
 
 	if (bp->b_target != lasttarg ||
 	    time_after(jiffies, (lasttime + 5*HZ))) {
@@ -1079,45 +1066,80 @@ xfs_buf_iodone_callbacks(
 	}
 	lasttarg = bp->b_target;
 
+	/* synchronous writes will have callers process the error */
+	if (!(bp->b_flags & XBF_ASYNC))
+		goto out_stale;
+
+	trace_xfs_buf_item_iodone_async(bp, _RET_IP_);
+	ASSERT(bp->b_iodone != NULL);
+
 	/*
 	 * If the write was asynchronous then no one will be looking for the
-	 * error.  Clear the error state and write the buffer out again.
-	 *
-	 * XXX: This helps against transient write errors, but we need to find
-	 * a way to shut the filesystem down if the writes keep failing.
-	 *
-	 * In practice we'll shut the filesystem down soon as non-transient
-	 * errors tend to affect the whole device and a failing log write
-	 * will make us give up.  But we really ought to do better here.
+	 * error.  If this is the first failure of this type, clear the error
+	 * state and write the buffer out again. This means we always retry an
+	 * async write failure at least once, but we also need to set the buffer
+	 * up to behave correctly now for repeated failures.
 	 */
-	if (bp->b_flags & XBF_ASYNC) {
-		ASSERT(bp->b_iodone != NULL);
-
-		trace_xfs_buf_item_iodone_async(bp, _RET_IP_);
+	cfg = xfs_error_get_cfg(mp, XFS_ERR_METADATA, bp->b_error);
+	if (!(bp->b_flags & (XBF_STALE|XBF_WRITE_FAIL)) ||
+	     bp->b_last_error != bp->b_error) {
+		bp->b_flags |= (XBF_WRITE | XBF_ASYNC |
+			        XBF_DONE | XBF_WRITE_FAIL);
+		bp->b_last_error = bp->b_error;
+		xfs_buf_ioerror(bp, 0);
+		xfs_buf_submit(bp);
+		return true;
+	}
 
-		xfs_buf_ioerror(bp, 0); /* errno of 0 unsets the flag */
+	/*
+	 * Repeated failure on an async write. Take action according to the
+	 * error configuration we have been set up to use.
+	 */
+	if (!cfg->max_retries)
+		goto permanent_error;
 
-		if (!(bp->b_flags & (XBF_STALE|XBF_WRITE_FAIL))) {
-			bp->b_flags |= XBF_WRITE | XBF_ASYNC |
-				       XBF_DONE | XBF_WRITE_FAIL;
-			xfs_buf_submit(bp);
-		} else {
-			xfs_buf_relse(bp);
-		}
-
-		return;
-	}
+	/* still a transient error, higher layers will retry */
+	xfs_buf_ioerror(bp, 0);
+	xfs_buf_relse(bp);
+	return true;
 
 	/*
-	 * If the write of the buffer was synchronous, we want to make
-	 * sure to return the error to the caller of xfs_bwrite().
+	 * Permanent error - we need to trigger a shutdown if we haven't already
+	 * to indicate that inconsistency will result from this action.
 	 */
+permanent_error:
+	xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
+out_stale:
 	xfs_buf_stale(bp);
 	bp->b_flags |= XBF_DONE;
-
 	trace_xfs_buf_error_relse(bp, _RET_IP_);
+	return false;
+}
+
+/*
+ * This is the iodone() function for buffers which have had callbacks attached
+ * to them by xfs_buf_attach_iodone(). We need to iterate the items on the
+ * callback list, mark the buffer as having no more callbacks and then push the
+ * buffer through IO completion processing.
+ */
+void
+xfs_buf_iodone_callbacks(
+	struct xfs_buf		*bp)
+{
+	/*
+	 * If there is an error, process it. Some errors require us
+	 * to run callbacks after failure processing is done so we
+	 * detect that and take appropriate action.
+	 */
+	if (bp->b_error && xfs_buf_iodone_callback_error(bp))
+		return;
+
+	/*
+	 * Successful IO or permanent error. Either way, we can clear the
+	 * retry state here in preparation for the next error that may occur.
+	 */
+	bp->b_last_error = 0;
 
-do_callbacks:
 	xfs_buf_do_callbacks(bp);
 	bp->b_fspriv = NULL;
 	bp->b_iodone = NULL;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 352a5c8..0c5a976 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -387,4 +387,7 @@ extern void	xfs_set_low_space_thresholds(struct xfs_mount *);
 int	xfs_zero_extent(struct xfs_inode *ip, xfs_fsblock_t start_fsb,
 			xfs_off_t count_fsb);
 
+struct xfs_error_cfg * xfs_error_get_cfg(struct xfs_mount *mp,
+		int error_class, int error);
+
 #endif	/* __XFS_MOUNT_H__ */
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index 7180cff..0a9adcd 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -447,3 +447,20 @@ xfs_error_sysfs_del(
 	xfs_sysfs_del(&mp->m_error_meta_kobj);
 	xfs_sysfs_del(&mp->m_error_kobj);
 }
+
+struct xfs_error_cfg *
+xfs_error_get_cfg(
+	struct xfs_mount	*mp,
+	int			error_class,
+	int			error)
+{
+	struct xfs_error_cfg	*cfg;
+
+	switch (error) {
+	default:
+		cfg = &mp->m_error_cfg[error_class][XFS_ERR_DEFAULT];
+		break;
+	}
+
+	return cfg;
+}
-- 
2.4.11

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
