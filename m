Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB2GBpd9032518 for <xfs@oss.sgi.com>; Tue, 2 Dec 2008 10:11:51 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 33C86164F2B3
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2008 08:11:51 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id insYWziRYCrnhPJF for
	<xfs@oss.sgi.com>; Tue, 02 Dec 2008 08:11:51 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat
	Linux)) id 1L7Xly-0007OP-OF
	for xfs@oss.sgi.com; Tue, 02 Dec 2008 16:06:50 +0000
Message-Id: <20081202160650.663976000@bombadil.infradead.org>
References: <20081202160430.775774000@bombadil.infradead.org>
Date: Tue, 02 Dec 2008 11:04:38 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [patch 08/22] reduce l_icloglock roundtrips
Content-Disposition: inline; filename=xfs-reduce-log-lock-roundtrips
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

All but one caller of xlog_state_want_sync drop and re-acquire
l_icloglock around the call to it, just so that xlog_state_want_sync can
acquire and drop it.

Move all lock operation out of l_icloglock and assert that the lock is
held when it is called.

Note that it would make sense to extende this scheme to
xlog_state_release_iclog, but the locking in there is more complicated
and we'd like to keep the atomic_dec_and_lock optmization for those
callers not having l_icloglock yet.

(First sent on Semptember 29th)


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs-master/fs/xfs/xfs_log.c
===================================================================
--- xfs-master.orig/fs/xfs/xfs_log.c	2008-12-02 11:07:00.000000000 +0100
+++ xfs-master/fs/xfs/xfs_log.c	2008-12-02 11:13:33.000000000 +0100
@@ -729,8 +729,8 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 		spin_lock(&log->l_icloglock);
 		iclog = log->l_iclog;
 		atomic_inc(&iclog->ic_refcnt);
-		spin_unlock(&log->l_icloglock);
 		xlog_state_want_sync(log, iclog);
+		spin_unlock(&log->l_icloglock);
 		error = xlog_state_release_iclog(log, iclog);
 
 		spin_lock(&log->l_icloglock);
@@ -767,9 +767,9 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 		spin_lock(&log->l_icloglock);
 		iclog = log->l_iclog;
 		atomic_inc(&iclog->ic_refcnt);
-		spin_unlock(&log->l_icloglock);
 
 		xlog_state_want_sync(log, iclog);
+		spin_unlock(&log->l_icloglock);
 		error =  xlog_state_release_iclog(log, iclog);
 
 		spin_lock(&log->l_icloglock);
@@ -1984,7 +1984,9 @@ xlog_write(xfs_mount_t *	mp,
 		if (iclog->ic_size - log_offset <= sizeof(xlog_op_header_t)) {
 		    xlog_state_finish_copy(log, iclog, record_cnt, data_cnt);
 		    record_cnt = data_cnt = 0;
+		    spin_lock(&log->l_icloglock);
 		    xlog_state_want_sync(log, iclog);
+		    spin_unlock(&log->l_icloglock);
 		    if (commit_iclog) {
 			ASSERT(flags & XLOG_COMMIT_TRANS);
 			*commit_iclog = iclog;
@@ -3193,7 +3195,7 @@ try_again:
 STATIC void
 xlog_state_want_sync(xlog_t *log, xlog_in_core_t *iclog)
 {
-	spin_lock(&log->l_icloglock);
+	ASSERT(spin_is_locked(&log->l_icloglock));
 
 	if (iclog->ic_state == XLOG_STATE_ACTIVE) {
 		xlog_state_switch_iclogs(log, iclog, 0);
@@ -3201,10 +3203,7 @@ xlog_state_want_sync(xlog_t *log, xlog_i
 		ASSERT(iclog->ic_state &
 			(XLOG_STATE_WANT_SYNC|XLOG_STATE_IOERROR));
 	}
-
-	spin_unlock(&log->l_icloglock);
-}	/* xlog_state_want_sync */
-
+}
 
 
 /*****************************************************************************

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
