Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pANGUeiD223686 for <xfs@oss.sgi.com>; Wed, 23 Nov 2011 10:30:40 -0600
Date: Wed, 23 Nov 2011 10:30:46 -0600
From: Ben Myers <bpm@sgi.com>
Subject: [REVIEW] xfssyncd lost wakes circa 2.6.32
Message-ID: <20111123163046.GQ29840@sgi.com>
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
To: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, Alex Elder <elder@linux.com>
Cc: ataschner@novell.com, nfbrown@suse.com, xfs@oss.sgi.com

Hi,

I'd like to request a review for this patch.  This is related to ENOSPC
condition and also project quotas, where we call xfs_flush_inodes from
xfs_iomap_write_delay.  Neil and Andreas did some very heavy lifting on
this bug (suse 722910) and found that there is a repeatable ~30ish
second delay in xfs_write that is related to xfssyncd at ENOSPC.  From
there I captured the interaction in this trace:

Nov 22 15:06:39 nfs4 kernel: [  478.757337] 5571: xfs_flush_inodes (sdb1) start
Nov 22 15:06:39 nfs4 kernel: [  478.757338] 5571: xfs_syncd_queue_work (sdb1) start
Nov 22 15:06:39 nfs4 kernel: [  478.757341] 5571: xfs_syncd_queue_work (sdb1) end
Nov 22 15:06:39 nfs4 kernel: [  478.757344] 1767: xfssyncd awake
Nov 22 15:06:39 nfs4 kernel: [  478.757346] 1767: xfs_flush_inodes_work (sdb1) start
Nov 22 15:06:39 nfs4 kernel: [  478.757352] 1767: xfs_flush_inodes_work (sdb1) end
Nov 22 15:06:40 nfs4 kernel: [  478.757357] 5571: xfs_flush_inodes (sdb1) end
Nov 22 15:06:40 nfs4 kernel: [  478.757367] 5571: xfs_flush_inodes (sdb1) start
Nov 22 15:06:40 nfs4 kernel: [  478.757368] 5571: xfs_syncd_queue_work (sdb1) start
Nov 22 15:06:40 nfs4 kernel: [  478.757370] 5571: xfs_syncd_queue_work (sdb1) end
Nov 22 15:06:40 nfs4 kernel: [  478.757394] 1767: xfssyncd go to sleep
Nov 22 15:06:40 nfs4 kernel: [  508.708008] 830: xfssyncd awake
Nov 22 15:06:40 nfs4 kernel: [  508.708011] 830 xfs_sync_worker (sda3) start
Nov 22 15:06:40 nfs4 kernel: [  508.708016] 830 xfs_sync_worker (sda3) end
Nov 22 15:06:40 nfs4 kernel: [  508.708018] 830: xfssyncd go to sleep
Nov 22 15:06:40 nfs4 kernel: [  514.664300] 1767: xfssyncd awake
Nov 22 15:06:40 nfs4 kernel: [  514.664303] 1767: xfs_flush_inodes_work (sdb1) start
Nov 22 15:06:40 nfs4 kernel: [  514.664317] 1767: xfs_flush_inodes_work (sdb1) end
Nov 22 15:06:40 nfs4 kernel: [  514.664322] 1767 xfs_sync_worker (sdb1) start
Nov 22 15:06:40 nfs4 kernel: [  514.664324] 5571: xfs_flush_inodes (sdb1) end
Nov 22 15:06:40 nfs4 kernel: [  514.664330] 1767 xfs_sync_worker (sdb1) end
Nov 22 15:06:40 nfs4 kernel: [  514.664332] 1767: xfssyncd go to sleep
Nov 22 15:06:40 nfs4 kernel: [  514.664349] 5091ef25 35s 907016877s
                                            ^^^ xid  ^^^^^^ service time delay in nfsd_vfs_write

Note that xfssyncd was going to sleep at 478.757394, even though work
had just been queued.  It looks to me like xfs_syncd_queue_work can try
to wake xfssyncd when it's already running, and xfssyncd can
subsequently go back to sleep, holding off the xfs_flush_inodes_work
until the timer pops again.  David has already rewritten this subsystem
using work queues, but I'd rather fix this very specific issue for
support purposes than backport a new implementation.

To fix this we need to check m_sync_list under lock and only sleep if it
is empty.  Also set TASK_INTERRUPTIBLE before the check so that if we're
woken we won't sleep either.  This is discussed here:

http://www.linuxjournal.com/node/8144/print

I'm also adding work items to the tail of the temp list so that they are
processed in the order they were added.  My testing of this patch shows
that the ~30s delay is gone, but I did see a ~2s delay in there
occasionally.

Thanks!
-Ben

Index: linux/fs/xfs/linux-2.6/xfs_sync.c
===================================================================
--- linux.orig/fs/xfs/linux-2.6/xfs_sync.c
+++ linux/fs/xfs/linux-2.6/xfs_sync.c
@@ -620,13 +620,25 @@ xfssyncd(
 	set_freezable();
 	timeleft = xfs_syncd_centisecs * msecs_to_jiffies(10);
 	for (;;) {
-		timeleft = schedule_timeout_interruptible(timeleft);
-		/* swsusp */
-		try_to_freeze();
-		if (kthread_should_stop() && list_empty(&mp->m_sync_list))
+		set_current_state(TASK_INTERRUPTIBLE);
+		spin_lock(&mp->m_sync_lock);
+
+		if (list_empty(&mp->m_sync_list) && !kthread_should_stop()) {
+			spin_unlock(&mp->m_sync_lock);
+
+			timeleft = schedule_timeout_interruptible(timeleft);
+			/* swsusp */
+			try_to_freeze();
+
+			spin_lock(&mp->m_sync_lock);
+		}
+		set_current_state(TASK_RUNNING);
+
+		if (kthread_should_stop() && list_empty(&mp->m_sync_list)) {
+			spin_unlock(&mp->m_sync_lock);
 			break;
+		}
 
-		spin_lock(&mp->m_sync_lock);
 		/*
 		 * We can get woken by laptop mode, to do a sync -
 		 * that's the (only!) case where the list would be
@@ -641,7 +653,7 @@ xfssyncd(
 					&mp->m_sync_list);
 		}
 		list_for_each_entry_safe(work, n, &mp->m_sync_list, w_list)
-			list_move(&work->w_list, &tmp);
+			list_move_tail(&work->w_list, &tmp);
 		spin_unlock(&mp->m_sync_lock);
 
 		list_for_each_entry_safe(work, n, &tmp, w_list) {


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
