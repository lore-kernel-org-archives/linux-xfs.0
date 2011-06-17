Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5HDE4CV120006 for <xfs@oss.sgi.com>; Fri, 17 Jun 2011 08:14:04 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6952751E062
	for <xfs@oss.sgi.com>; Fri, 17 Jun 2011 06:14:03 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	7Y1cmsKDDtC7gpXm for <xfs@oss.sgi.com>;
	Fri, 17 Jun 2011 06:14:03 -0700 (PDT)
Date: Fri, 17 Jun 2011 09:14:01 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: improve sync behaviour in face of aggressive dirtying
Message-ID: <20110617131401.GC2141@infradead.org>
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
To: xfs@oss.sgi.com
Cc: Wu Fengguang <fengguang.wu@intel.com>

The following script from Wu Fengguang shows very bad behaviour in XFS
when aggressively dirtying data during a sync on XFS, with sync times
up to almost 10 times as long as ext4.

A large part of the issue is that XFS writes data out itself two times
in the ->sync_fs method, overriding the lifelock protection in the core
writeback code, and another issue is the lock-less xfs_ioend_wait call,
which doesn't prevent new ioend from beeing queue up while waiting for
the count to reach zero.

This patch removes the XFS-internal sync calls and relies on the VFS
to do it's work just like all other filesystems do, and just uses the
internal inode iterator to wait for pending ioends, but now with the
iolock held.  With this fix we improve the sync time quite a bit,
but we'll need further work split i_iocount between pending direct I/O
requests that are only relevant for truncate, and pending unwritten
extent conversion that matter for sync and fsync.

------------------------------ snip ------------------------------
#!/bin/sh

umount /dev/sda7
mkfs.xfs -f /dev/sda7
# mkfs.ext4 /dev/sda7
# mkfs.btrfs /dev/sda7
mount /dev/sda7 /fs

echo $((50<<20)) > /proc/sys/vm/dirty_bytes

pid=
for i in `seq 10`
do
	dd if=/dev/zero of=/fs/zero-$i bs=1M count=1000 &
	pid="$pid $!"
done

sleep 1

tic=$(date +'%s')
sync
tac=$(date +'%s')

echo
echo sync time: $((tac-tic))
egrep '(Dirty|Writeback|NFS_Unstable)' /proc/meminfo

pidof dd > /dev/null && { kill -9 $pid; echo sync NOT livelocked; }
------------------------------ snip ------------------------------

Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_sync.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_sync.c	2011-06-17 14:16:18.442399481 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_sync.c	2011-06-17 14:18:06.632394003 +0200
@@ -215,6 +215,19 @@ xfs_inode_ag_iterator(
 }
 
 STATIC int
+xfs_wait_ioend_cb(
+	struct xfs_inode	*ip,
+	struct xfs_perag	*pag,
+	int			flags)
+{
+	xfs_ilock(ip, XFS_IOLOCK_SHARED);
+	xfs_ioend_wait(ip);
+	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
+
+	return 0;
+}
+
+STATIC int
 xfs_sync_inode_data(
 	struct xfs_inode	*ip,
 	struct xfs_perag	*pag,
@@ -359,14 +372,15 @@ xfs_quiesce_data(
 {
 	int			error, error2 = 0;
 
-	/* push non-blocking */
-	xfs_sync_data(mp, 0);
 	xfs_qm_sync(mp, SYNC_TRYLOCK);
-
-	/* push and block till complete */
-	xfs_sync_data(mp, SYNC_WAIT);
 	xfs_qm_sync(mp, SYNC_WAIT);
 
+	/* wait for all pending unwritten extent conversions */
+	xfs_inode_ag_iterator(mp, xfs_wait_ioend_cb, 0);
+
+	/* force out the newly dirtied log buffers */
+	xfs_log_force(mp, XFS_LOG_SYNC);
+
 	/* write superblock and hoover up shutdown errors */
 	error = xfs_sync_fsdata(mp);
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
