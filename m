Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBE2egN1184144 for <xfs@oss.sgi.com>; Tue, 13 Dec 2011 20:40:42 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8C5D257CCBB
	for <xfs@oss.sgi.com>; Tue, 13 Dec 2011 18:40:41 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	4msDz4JX6SqnoTvE for <xfs@oss.sgi.com>;
	Tue, 13 Dec 2011 18:40:41 -0800 (PST)
Date: Tue, 13 Dec 2011 21:40:40 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: xfs-trace-ilock-more
Message-ID: <20111214024040.GA17780@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: mfasheh@suse.de
Cc: xfs@oss.sgi.com

Can you explain the story behid this patch in SLES11SP1?


---
From: Mark Fasheh <mfasheh@suse.de>
Date: Mon Oct  3 12:39:07 PDT 2011
Subject: xfs: add more ilock tracing
Patch-mainline: Never

Lets get a trace of the amount of time spent in xfs_ilock().

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
Index: linux-2.6.32-xfs-tracing/fs/xfs/linux-2.6/xfs_trace.h
===================================================================
--- linux-2.6.32-xfs-tracing.orig/fs/xfs/linux-2.6/xfs_trace.h
+++ linux-2.6.32-xfs-tracing/fs/xfs/linux-2.6/xfs_trace.h
@@ -453,24 +453,27 @@ DEFINE_BUF_ITEM_EVENT(xfs_trans_binval);
 #define DEFINE_LOCK_EVENT(name) \
 TRACE_EVENT(name, \
 	TP_PROTO(struct xfs_inode *ip, unsigned lock_flags, \
-		 unsigned long caller_ip), \
-	TP_ARGS(ip,  lock_flags, caller_ip), \
+		 unsigned long start, unsigned long caller_ip), \
+	TP_ARGS(ip,  lock_flags, start, caller_ip),		\
 	TP_STRUCT__entry( \
 		__field(dev_t, dev) \
 		__field(xfs_ino_t, ino) \
 		__field(int, lock_flags) \
+		__field(unsigned long, start) \
 		__field(unsigned long, caller_ip) \
 	), \
 	TP_fast_assign( \
 		__entry->dev = VFS_I(ip)->i_sb->s_dev; \
 		__entry->ino = ip->i_ino; \
 		__entry->lock_flags = lock_flags; \
+		__entry->start = start;		  \
 		__entry->caller_ip = caller_ip; \
 	), \
-	TP_printk("dev %d:%d ino 0x%llx flags %s caller %pf", \
+	TP_printk("dev %d:%d ino 0x%llx flags %s wait %lu caller %pf", \
 		  MAJOR(__entry->dev), MINOR(__entry->dev), \
 		  __entry->ino, \
 		  __print_flags(__entry->lock_flags, "|", XFS_LOCK_FLAGS), \
+		  (jiffies - __entry->start), \
 		  (void *)__entry->caller_ip) \
 )
 
Index: linux-2.6.32-xfs-tracing/fs/xfs/xfs_iget.c
===================================================================
--- linux-2.6.32-xfs-tracing.orig/fs/xfs/xfs_iget.c
+++ linux-2.6.32-xfs-tracing/fs/xfs/xfs_iget.c
@@ -590,6 +590,8 @@ xfs_ilock(
 	xfs_inode_t		*ip,
 	uint			lock_flags)
 {
+	unsigned long start = jiffies;
+
 	/*
 	 * You can't set both SHARED and EXCL for the same lock,
 	 * and only XFS_IOLOCK_SHARED, XFS_IOLOCK_EXCL, XFS_ILOCK_SHARED,
@@ -611,7 +613,7 @@ xfs_ilock(
 	else if (lock_flags & XFS_ILOCK_SHARED)
 		mraccess_nested(&ip->i_lock, XFS_ILOCK_DEP(lock_flags));
 
-	trace_xfs_ilock(ip, lock_flags, _RET_IP_);
+	trace_xfs_ilock(ip, lock_flags, start, _RET_IP_);
 }
 
 /*
@@ -631,6 +633,8 @@ xfs_ilock_nowait(
 	xfs_inode_t		*ip,
 	uint			lock_flags)
 {
+	unsigned long start = jiffies;
+
 	/*
 	 * You can't set both SHARED and EXCL for the same lock,
 	 * and only XFS_IOLOCK_SHARED, XFS_IOLOCK_EXCL, XFS_ILOCK_SHARED,
@@ -656,7 +660,7 @@ xfs_ilock_nowait(
 		if (!mrtryaccess(&ip->i_lock))
 			goto out_undo_iolock;
 	}
-	trace_xfs_ilock_nowait(ip, lock_flags, _RET_IP_);
+	trace_xfs_ilock_nowait(ip, lock_flags, start, _RET_IP_);
 	return 1;
 
  out_undo_iolock:
@@ -684,7 +688,10 @@ void
 xfs_iunlock(
 	xfs_inode_t		*ip,
 	uint			lock_flags)
+
 {
+	unsigned long start = jiffies;
+
 	/*
 	 * You can't set both SHARED and EXCL for the same lock,
 	 * and only XFS_IOLOCK_SHARED, XFS_IOLOCK_EXCL, XFS_ILOCK_SHARED,
@@ -718,7 +725,7 @@ xfs_iunlock(
 		xfs_trans_unlocked_item(ip->i_itemp->ili_item.li_ailp,
 					(xfs_log_item_t*)(ip->i_itemp));
 	}
-	trace_xfs_iunlock(ip, lock_flags, _RET_IP_);
+	trace_xfs_iunlock(ip, lock_flags, start, _RET_IP_);
 }
 
 /*
@@ -730,6 +737,8 @@ xfs_ilock_demote(
 	xfs_inode_t		*ip,
 	uint			lock_flags)
 {
+	unsigned long start = jiffies;
+
 	ASSERT(lock_flags & (XFS_IOLOCK_EXCL|XFS_ILOCK_EXCL));
 	ASSERT((lock_flags & ~(XFS_IOLOCK_EXCL|XFS_ILOCK_EXCL)) == 0);
 
@@ -738,7 +747,7 @@ xfs_ilock_demote(
 	if (lock_flags & XFS_IOLOCK_EXCL)
 		mrdemote(&ip->i_iolock);
 
-	trace_xfs_ilock_demote(ip, lock_flags, _RET_IP_);
+	trace_xfs_ilock_demote(ip, lock_flags, start, _RET_IP_);
 }
 
 #ifdef DEBUG

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
