Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q05Md1gl224956 for <xfs@oss.sgi.com>; Thu, 5 Jan 2012 16:39:02 -0600
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id MWVequoMjrrFOtaF for <xfs@oss.sgi.com>;
	Thu, 05 Jan 2012 14:39:00 -0800 (PST)
Date: Thu, 5 Jan 2012 14:38:59 -0800
From: Mark Fasheh <mfasheh@suse.de>
Subject: Re: xfs-trace-ilock-more
Message-ID: <20120105223859.GJ11114@wotan.suse.de>
References: <20111214024040.GA17780@infradead.org>
	<20111214182750.GH11114@wotan.suse.de>
	<20111218202734.GB20799@infradead.org>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111218202734.GB20799@infradead.org>
Reply-To: Mark Fasheh <mfasheh@suse.de>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeff Mahoney <jeffm@suse.com>, xfs@oss.sgi.com

On Sun, Dec 18, 2011 at 03:27:34PM -0500, Christoph Hellwig wrote:
> Given that the patch is fairly clean can you send it to us for
> inclusion?

Here goes. I updated the patch for 3.2 and of course gave it a quick test.
	--Mark

--
Mark Fasheh

From: Mark Fasheh <mfasheh@suse.com>

[PATCH] xfs: add more ilock tracing

Let's get a trace of the amount of time spent in xfs_ilock(). This has
helped us (SUSE) in investigating read/write performance issues in the past
when ilock() contention has come up as a possibile issue.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 fs/xfs/xfs_iget.c  |   16 ++++++++++++----
 fs/xfs/xfs_trace.h |   13 ++++++++-----
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
index 0fa98b1..b83108b 100644
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -543,6 +543,8 @@ xfs_ilock(
 	xfs_inode_t		*ip,
 	uint			lock_flags)
 {
+	unsigned long start = jiffies;
+
 	/*
 	 * You can't set both SHARED and EXCL for the same lock,
 	 * and only XFS_IOLOCK_SHARED, XFS_IOLOCK_EXCL, XFS_ILOCK_SHARED,
@@ -564,7 +566,7 @@ xfs_ilock(
 	else if (lock_flags & XFS_ILOCK_SHARED)
 		mraccess_nested(&ip->i_lock, XFS_ILOCK_DEP(lock_flags));
 
-	trace_xfs_ilock(ip, lock_flags, _RET_IP_);
+	trace_xfs_ilock(ip, lock_flags, start, _RET_IP_);
 }
 
 /*
@@ -584,6 +586,8 @@ xfs_ilock_nowait(
 	xfs_inode_t		*ip,
 	uint			lock_flags)
 {
+	unsigned long start = jiffies;
+
 	/*
 	 * You can't set both SHARED and EXCL for the same lock,
 	 * and only XFS_IOLOCK_SHARED, XFS_IOLOCK_EXCL, XFS_ILOCK_SHARED,
@@ -609,7 +613,7 @@ xfs_ilock_nowait(
 		if (!mrtryaccess(&ip->i_lock))
 			goto out_undo_iolock;
 	}
-	trace_xfs_ilock_nowait(ip, lock_flags, _RET_IP_);
+	trace_xfs_ilock_nowait(ip, lock_flags, start, _RET_IP_);
 	return 1;
 
  out_undo_iolock:
@@ -638,6 +642,8 @@ xfs_iunlock(
 	xfs_inode_t		*ip,
 	uint			lock_flags)
 {
+	unsigned long start = jiffies;
+
 	/*
 	 * You can't set both SHARED and EXCL for the same lock,
 	 * and only XFS_IOLOCK_SHARED, XFS_IOLOCK_EXCL, XFS_ILOCK_SHARED,
@@ -671,7 +677,7 @@ xfs_iunlock(
 		xfs_trans_unlocked_item(ip->i_itemp->ili_item.li_ailp,
 					(xfs_log_item_t*)(ip->i_itemp));
 	}
-	trace_xfs_iunlock(ip, lock_flags, _RET_IP_);
+	trace_xfs_iunlock(ip, lock_flags, start, _RET_IP_);
 }
 
 /*
@@ -683,6 +689,8 @@ xfs_ilock_demote(
 	xfs_inode_t		*ip,
 	uint			lock_flags)
 {
+	unsigned long start = jiffies;
+
 	ASSERT(lock_flags & (XFS_IOLOCK_EXCL|XFS_ILOCK_EXCL));
 	ASSERT((lock_flags & ~(XFS_IOLOCK_EXCL|XFS_ILOCK_EXCL)) == 0);
 
@@ -691,7 +699,7 @@ xfs_ilock_demote(
 	if (lock_flags & XFS_IOLOCK_EXCL)
 		mrdemote(&ip->i_iolock);
 
-	trace_xfs_ilock_demote(ip, lock_flags, _RET_IP_);
+	trace_xfs_ilock_demote(ip, lock_flags, start, _RET_IP_);
 }
 
 #ifdef DEBUG
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 4940357..ef5523a 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -507,32 +507,35 @@ DEFINE_BUF_ITEM_EVENT(xfs_trans_binval);
 
 DECLARE_EVENT_CLASS(xfs_lock_class,
 	TP_PROTO(struct xfs_inode *ip, unsigned lock_flags,
-		 unsigned long caller_ip),
-	TP_ARGS(ip,  lock_flags, caller_ip),
+		 unsigned long start, unsigned long caller_ip),
+	TP_ARGS(ip,lock_flags, start, caller_ip),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_ino_t, ino)
 		__field(int, lock_flags)
+		__field(unsigned long, start)
 		__field(unsigned long, caller_ip)
 	),
 	TP_fast_assign(
 		__entry->dev = VFS_I(ip)->i_sb->s_dev;
 		__entry->ino = ip->i_ino;
 		__entry->lock_flags = lock_flags;
+		__entry->start = start;
 		__entry->caller_ip = caller_ip;
 	),
-	TP_printk("dev %d:%d ino 0x%llx flags %s caller %pf",
+	TP_printk("dev %d:%d ino 0x%llx flags %s wait %lu caller %pf",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __print_flags(__entry->lock_flags, "|", XFS_LOCK_FLAGS),
+		  (jiffies - __entry->start),
 		  (void *)__entry->caller_ip)
 )
 
 #define DEFINE_LOCK_EVENT(name) \
 DEFINE_EVENT(xfs_lock_class, name, \
 	TP_PROTO(struct xfs_inode *ip, unsigned lock_flags, \
-		 unsigned long caller_ip), \
-	TP_ARGS(ip,  lock_flags, caller_ip))
+		 unsigned long start, unsigned long caller_ip),	\
+	TP_ARGS(ip,  lock_flags, start, caller_ip))
 DEFINE_LOCK_EVENT(xfs_ilock);
 DEFINE_LOCK_EVENT(xfs_ilock_nowait);
 DEFINE_LOCK_EVENT(xfs_ilock_demote);
-- 
1.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
