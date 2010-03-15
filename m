Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2F2XjE9004691 for <xfs@oss.sgi.com>; Sun, 14 Mar 2010 21:33:45 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B638819D2E21
	for <xfs@oss.sgi.com>; Sun, 14 Mar 2010 19:35:19 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	tcm4A4jha228Hw4S for <xfs@oss.sgi.com>;
	Sun, 14 Mar 2010 19:35:19 -0700 (PDT)
Received: from dastard (unverified [121.44.103.80])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	16902519-1927428
	for <xfs@oss.sgi.com>; Mon, 15 Mar 2010 13:05:18 +1030 (CDT)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1Nr09E-00015s-7Q
	for xfs@oss.sgi.com; Mon, 15 Mar 2010 13:35:16 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1Nr09B-0002pT-IZ
	for xfs@oss.sgi.com; Mon, 15 Mar 2010 13:35:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/9] xfs: Add inode pin counts to traces
Date: Mon, 15 Mar 2010 13:34:59 +1100
Message-Id: <1268620506-10799-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1268620506-10799-1-git-send-email-david@fromorbit.com>
References: <1268620506-10799-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

We don't record pin counts in inode events right now, and this makes
it difficult to track down problems related to pinning inodes. Add
the pin count to the inode trace class and add trace events for
pinning and unpinning inodes.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/linux-2.6/xfs_trace.h |    9 ++++++++-
 fs/xfs/xfs_inode.c           |    2 ++
 fs/xfs/xfs_inode_item.c      |    2 ++
 3 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_trace.h b/fs/xfs/linux-2.6/xfs_trace.h
index fcaa62f..6537185 100644
--- a/fs/xfs/linux-2.6/xfs_trace.h
+++ b/fs/xfs/linux-2.6/xfs_trace.h
@@ -562,18 +562,21 @@ DECLARE_EVENT_CLASS(xfs_inode_class,
 		__field(dev_t, dev)
 		__field(xfs_ino_t, ino)
 		__field(int, count)
+		__field(int, pincount)
 		__field(unsigned long, caller_ip)
 	),
 	TP_fast_assign(
 		__entry->dev = VFS_I(ip)->i_sb->s_dev;
 		__entry->ino = ip->i_ino;
 		__entry->count = atomic_read(&VFS_I(ip)->i_count);
+		__entry->pincount = atomic_read(&ip->i_pincount);
 		__entry->caller_ip = caller_ip;
 	),
-	TP_printk("dev %d:%d ino 0x%llx count %d caller %pf",
+	TP_printk("dev %d:%d ino 0x%llx count %d pincount %d caller %pf",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->count,
+		  __entry->pincount,
 		  (char *)__entry->caller_ip)
 )
 
@@ -583,6 +586,10 @@ DEFINE_EVENT(xfs_inode_class, name, \
 	TP_ARGS(ip, caller_ip))
 DEFINE_INODE_EVENT(xfs_ihold);
 DEFINE_INODE_EVENT(xfs_irele);
+DEFINE_INODE_EVENT(xfs_inode_pin);
+DEFINE_INODE_EVENT(xfs_inode_unpin);
+DEFINE_INODE_EVENT(xfs_inode_unpin_nowait);
+
 /* the old xfs_itrace_entry tracer - to be replaced by s.th. in the VFS */
 DEFINE_INODE_EVENT(xfs_inode);
 #define xfs_itrace_entry(ip)    \
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 0ffd564..8cd6e8d 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2449,6 +2449,8 @@ xfs_iunpin_nowait(
 {
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
 
+	trace_xfs_inode_unpin_nowait(ip, _RET_IP_);
+
 	/* Give the log a push to start the unpinning I/O */
 	xfs_log_force_lsn(ip->i_mount, ip->i_itemp->ili_last_lsn, 0);
 
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 32e4188..0347175 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -543,6 +543,7 @@ xfs_inode_item_pin(
 {
 	ASSERT(xfs_isilocked(iip->ili_inode, XFS_ILOCK_EXCL));
 
+	trace_xfs_inode_pin(iip->ili_inode, _RET_IP_);
 	atomic_inc(&iip->ili_inode->i_pincount);
 }
 
@@ -561,6 +562,7 @@ xfs_inode_item_unpin(
 {
 	struct xfs_inode	*ip = iip->ili_inode;
 
+	trace_xfs_inode_unpin(ip, _RET_IP_);
 	ASSERT(atomic_read(&ip->i_pincount) > 0);
 	if (atomic_dec_and_test(&ip->i_pincount))
 		wake_up(&ip->i_ipin_wait);
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
