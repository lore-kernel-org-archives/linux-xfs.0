Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 16D657F80
	for <xfs@oss.sgi.com>; Sun,  1 Nov 2015 21:42:44 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 05C64304053
	for <xfs@oss.sgi.com>; Sun,  1 Nov 2015 19:42:44 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	zxUrE2eupmxVr3SI for <xfs@oss.sgi.com>;
	Sun, 01 Nov 2015 19:42:41 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Zt60k-00014q-AZ
	for xfs@oss.sgi.com; Mon, 02 Nov 2015 14:42:22 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1Zt60k-0000Sf-9p
	for xfs@oss.sgi.com; Mon, 02 Nov 2015 14:42:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 7/7] xfs: optimise away log forces on timestamp updates for
	fdatasync
Date: Mon,  2 Nov 2015 14:42:15 +1100
Message-Id: <1446435735-1526-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1446435735-1526-1-git-send-email-david@fromorbit.com>
References: <1446435735-1526-1-git-send-email-david@fromorbit.com>
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

xfs: timestamp updates cause excessive fdatasync log traffic

Sage Weil reported that a ceph test workload was writing to the
log on every fdatasync during an overwrite workload. Event tracing
showed that the only metadata modification being made was the
timestamp updates during the write(2) syscall, but fdatasync(2)
is supposed to ignore them. The key observation was that the
transactions in the log all looked like this:

INODE: #regs: 4   ino: 0x8b  flags: 0x45   dsize: 32

And contained a flags field of 0x45 or 0x85, and had data and
attribute forks following the inode core. This means that the
timestamp updates were triggering dirty relogging of previously
logged parts of the inode that hadn't yet been flushed back to
disk.

There are two parts to this problem. The first is that XFS relogs
dirty regions in subsequent transactions, so it carries around the
fields that have been dirtied since the last time the inode was
written back to disk, not since the last time the inode was forced
into the log.

The second part is that on v5 filesystems, the inode change count
update during inode dirtying also sets the XFS_ILOG_CORE flag, so
on v5 filesystems this makes a timestamp update dirty the entire
inode.

As a result when fdatasync is run, it looks at the dirty fields in
the inode, and sees more than just the timestamp flag, even though
the only metadata change since the last fdatasync was just the
timestamps. Hence we force the log on every subsequent fdatasync
even though it is not needed.

To fix this, add a new field to the inode log item that tracks
changes since the last time fsync/fdatasync forced the log to flush
the changes to the journal. This flag is updated when we dirty the
inode, but we do it before updating the change count so it does not
carry the "core dirty" flag from timestamp updates. The fields are
zeroed when the inode is marked clean (due to writeback/freeing) or
when an fsync/datasync forces the log. Hence if we only dirty the
timestamps on the inode between fsync/fdatasync calls, the fdatasync
will not trigger another log force.

Over 100 runs of the test program:

Ext4 baseline:
	runtime: 1.63s +/- 0.24s
	avg lat: 1.59ms +/- 0.24ms
	iops: ~2000

XFS, vanilla kernel:
        runtime: 2.45s +/- 0.18s
	avg lat: 2.39ms +/- 0.18ms
	log forces: ~400/s
	iops: ~1000

XFS, patched kernel:
        runtime: 1.49s +/- 0.26s
	avg lat: 1.46ms +/- 0.25ms
	log forces: ~30/s
	iops: ~1500

Reported-by: Sage Weil <sage@redhat.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_file.c        | 21 ++++++++++++++++-----
 fs/xfs/xfs_inode.c       |  2 ++
 fs/xfs/xfs_inode_item.c  |  1 +
 fs/xfs/xfs_inode_item.h  |  1 +
 fs/xfs/xfs_trans_inode.c |  9 +++++++++
 5 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 0045b0a..39743ef 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -242,19 +242,30 @@ xfs_file_fsync(
 	}
 
 	/*
-	 * All metadata updates are logged, which means that we just have
-	 * to flush the log up to the latest LSN that touched the inode.
+	 * All metadata updates are logged, which means that we just have to
+	 * flush the log up to the latest LSN that touched the inode. If we have
+	 * concurrent fsync/fdatasync() calls, we need them to all block on the
+	 * log force before we clear the ili_fsync_fields field. This ensures
+	 * that we don't get a racing sync operation that does not wait for the
+	 * metadata to hit the journal before returning. If we race with
+	 * clearing the ili_fsync_fields, then all that will happen is the log
+	 * force will do nothing as the lsn will already be on disk. We can't
+	 * race with setting ili_fsync_fields because that is done under
+	 * XFS_ILOCK_EXCL, and that can't happen because we hold the lock shared
+	 * until after the ili_fsync_fields is cleared.
 	 */
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 	if (xfs_ipincount(ip)) {
 		if (!datasync ||
-		    (ip->i_itemp->ili_fields & ~XFS_ILOG_TIMESTAMP))
+		    (ip->i_itemp->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP))
 			lsn = ip->i_itemp->ili_last_lsn;
 	}
-	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 
-	if (lsn)
+	if (lsn) {
 		error = _xfs_log_force_lsn(mp, lsn, XFS_LOG_SYNC, &log_flushed);
+		ip->i_itemp->ili_fsync_fields = 0;
+	}
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 
 	/*
 	 * If we only have a single device, and the log force about was
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index a0f2bae..8ee3939 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2365,6 +2365,7 @@ retry:
 
 			iip->ili_last_fields = iip->ili_fields;
 			iip->ili_fields = 0;
+			iip->ili_fsync_fields = 0;
 			iip->ili_logged = 1;
 			xfs_trans_ail_copy_lsn(mp->m_ail, &iip->ili_flush_lsn,
 						&iip->ili_item.li_lsn);
@@ -3560,6 +3561,7 @@ xfs_iflush_int(
 	 */
 	iip->ili_last_fields = iip->ili_fields;
 	iip->ili_fields = 0;
+	iip->ili_fsync_fields = 0;
 	iip->ili_logged = 1;
 
 	xfs_trans_ail_copy_lsn(mp->m_ail, &iip->ili_flush_lsn,
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 62bd80f..d14b12b 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -719,6 +719,7 @@ xfs_iflush_abort(
 		 * attempted.
 		 */
 		iip->ili_fields = 0;
+		iip->ili_fsync_fields = 0;
 	}
 	/*
 	 * Release the inode's flush lock since we're done with it.
diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
index 488d812..4c7722e 100644
--- a/fs/xfs/xfs_inode_item.h
+++ b/fs/xfs/xfs_inode_item.h
@@ -34,6 +34,7 @@ typedef struct xfs_inode_log_item {
 	unsigned short		ili_logged;	   /* flushed logged data */
 	unsigned int		ili_last_fields;   /* fields when flushed */
 	unsigned int		ili_fields;	   /* fields to be logged */
+	unsigned int		ili_fsync_fields;  /* logged since last fsync */
 } xfs_inode_log_item_t;
 
 static inline int xfs_inode_clean(xfs_inode_t *ip)
diff --git a/fs/xfs/xfs_trans_inode.c b/fs/xfs/xfs_trans_inode.c
index 17280cd..b97f1df 100644
--- a/fs/xfs/xfs_trans_inode.c
+++ b/fs/xfs/xfs_trans_inode.c
@@ -108,6 +108,15 @@ xfs_trans_log_inode(
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
 	/*
+	 * Record the specific change for fdatasync optimisation. This
+	 * allows fdatasync to skip log forces for inodes that are only
+	 * timestamp dirty. We do this before the change count so that
+	 * the core being logged in this case does not impact on fdatasync
+	 * behaviour.
+	 */
+	ip->i_itemp->ili_fsync_fields |= flags;
+
+	/*
 	 * First time we log the inode in a transaction, bump the inode change
 	 * counter if it is configured for this to occur. We don't use
 	 * inode_inc_version() because there is no need for extra locking around
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
