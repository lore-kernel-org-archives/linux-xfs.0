Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Sep 2008 14:36:56 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8TLaqEp030787
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2008 14:36:53 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 43DC3494ED1
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2008 14:38:28 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id QeavPHr3zBJcdPqp for <xfs@oss.sgi.com>; Mon, 29 Sep 2008 14:38:28 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m8TLcRIF030186
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2008 23:38:27 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m8TLcR0U030184
	for xfs@oss.sgi.com; Mon, 29 Sep 2008 23:38:27 +0200
Date: Mon, 29 Sep 2008 23:38:27 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] reduce l_icloglock roundtrips
Message-ID: <20080929213827.GA30126@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
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


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_log.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_log.c	2008-09-29 10:54:19.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_log.c	2008-09-29 10:58:23.000000000 +0200
@@ -724,8 +724,8 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 		spin_lock(&log->l_icloglock);
 		iclog = log->l_iclog;
 		atomic_inc(&iclog->ic_refcnt);
-		spin_unlock(&log->l_icloglock);
 		xlog_state_want_sync(log, iclog);
+		spin_unlock(&log->l_icloglock);
 		error = xlog_state_release_iclog(log, iclog);
 
 		spin_lock(&log->l_icloglock);
@@ -762,9 +762,9 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 		spin_lock(&log->l_icloglock);
 		iclog = log->l_iclog;
 		atomic_inc(&iclog->ic_refcnt);
-		spin_unlock(&log->l_icloglock);
 
 		xlog_state_want_sync(log, iclog);
+		spin_unlock(&log->l_icloglock);
 		error =  xlog_state_release_iclog(log, iclog);
 
 		spin_lock(&log->l_icloglock);
@@ -1957,7 +1957,9 @@ xlog_write(xfs_mount_t *	mp,
 		if (iclog->ic_size - log_offset <= sizeof(xlog_op_header_t)) {
 		    xlog_state_finish_copy(log, iclog, record_cnt, data_cnt);
 		    record_cnt = data_cnt = 0;
+		    spin_lock(&log->l_icloglock);
 		    xlog_state_want_sync(log, iclog);
+		    spin_unlock(&log->l_icloglock);
 		    if (commit_iclog) {
 			ASSERT(flags & XLOG_COMMIT_TRANS);
 			*commit_iclog = iclog;
@@ -3166,7 +3168,7 @@ try_again:
 STATIC void
 xlog_state_want_sync(xlog_t *log, xlog_in_core_t *iclog)
 {
-	spin_lock(&log->l_icloglock);
+	ASSERT(spin_is_locked(&log->l_icloglock));
 
 	if (iclog->ic_state == XLOG_STATE_ACTIVE) {
 		xlog_state_switch_iclogs(log, iclog, 0);
@@ -3174,10 +3176,7 @@ xlog_state_want_sync(xlog_t *log, xlog_i
 		ASSERT(iclog->ic_state &
 			(XLOG_STATE_WANT_SYNC|XLOG_STATE_IOERROR));
 	}
-
-	spin_unlock(&log->l_icloglock);
-}	/* xlog_state_want_sync */
-
+}
 
 
 /*****************************************************************************
