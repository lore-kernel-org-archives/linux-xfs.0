Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p67B6hgS159859 for <xfs@oss.sgi.com>; Thu, 7 Jul 2011 06:06:43 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E708115ECD91
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2011 04:06:42 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	JDEFC7z5QFGgVjvW for <xfs@oss.sgi.com>;
	Thu, 07 Jul 2011 04:06:42 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QemPq-0003tG-4K
	for xfs@oss.sgi.com; Thu, 07 Jul 2011 11:06:42 +0000
Message-Id: <20110707110642.097790385@bombadil.infradead.org>
Date: Thu, 07 Jul 2011 07:05:43 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 08/28] xfs: improve sync behaviour in the face of aggressive
	dirtying
References: <20110707110535.205001532@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-simplify-sync
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

The following script from Wu Fengguang shows very bad behaviour in XFS
when aggressively dirtying data during a sync on XFS, with sync times
up to almost 10 times as long as ext4.

A large part of the issue is that XFS writes data out itself two times
in the ->sync_fs method, overriding the livelock protection in the core
writeback code, and another issue is the lock-less xfs_ioend_wait call,
which doesn't prevent new ioend from being queue up while waiting for
the count to reach zero.

This patch removes the XFS-internal sync calls and relies on the VFS
to do it's work just like all other filesystems do.  Note that the
i_iocount wait which is rather suboptimal is simply removed here.
We already do it in ->write_inode, which keeps the current supoptimal
behaviour.  We'll eventually need to remove that as well, but that's
material for a separate commit.

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

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Reviewed-by: Alex Elder <aelder@sgi.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>

Index: xfs/fs/xfs/linux-2.6/xfs_sync.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_sync.c	2011-06-29 11:26:14.109219361 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_sync.c	2011-06-29 11:37:20.642275110 +0200
@@ -359,14 +359,12 @@ xfs_quiesce_data(
 {
 	int			error, error2 = 0;
 
-	/* push non-blocking */
-	xfs_sync_data(mp, 0);
 	xfs_qm_sync(mp, SYNC_TRYLOCK);
-
-	/* push and block till complete */
-	xfs_sync_data(mp, SYNC_WAIT);
 	xfs_qm_sync(mp, SYNC_WAIT);
 
+	/* force out the newly dirtied log buffers */
+	xfs_log_force(mp, XFS_LOG_SYNC);
+
 	/* write superblock and hoover up shutdown errors */
 	error = xfs_sync_fsdata(mp);
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
