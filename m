Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5MK5XCa120631 for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 15:05:33 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 96FE2174B28D
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 13:05:32 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	gDwSG0CXVPB8DyhQ for <xfs@oss.sgi.com>;
	Wed, 22 Jun 2011 13:05:32 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QZTg3-0007sX-7t
	for xfs@oss.sgi.com; Wed, 22 Jun 2011 20:05:31 +0000
Message-Id: <20110622200531.210341501@bombadil.infradead.org>
Date: Wed, 22 Jun 2011 16:01:33 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 4/4] xfs: improve sync behaviour in the fact of aggressive
	dirtying
References: <20110622200129.218994186@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-simplify-sync-2
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
in the ->sync_fs method, overriding the lifelock protection in the core
writeback code, and another issue is the lock less xfs_ioend_wait call,
which doesn't prevent new ioend from beeing queue up while waiting for
the count to reach zero.

This patch removes the XFS-internal sync calls and relies on the VFS
to do its work just like all other filesystems do, and instead of waiting
for pending ioends just flushes the workqueues used to process them.

With these fixes sync times with concurrent dirtiers are up to part
with other filesystems.

------------------------------ snip ------------------------------
#!/bin/sh

DEV=/dev/sda7
umount ${DEV}
mkfs.xfs -f {DEV}
mount ${DEV} /fs

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
--- xfs.orig/fs/xfs/linux-2.6/xfs_sync.c	2011-06-22 08:50:38.454850057 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_sync.c	2011-06-22 20:47:39.246005258 +0200
@@ -359,14 +359,16 @@ xfs_quiesce_data(
 {
 	int			error, error2 = 0;
 
-	/* push non-blocking */
-	xfs_sync_data(mp, 0);
 	xfs_qm_sync(mp, SYNC_TRYLOCK);
-
-	/* push and block till complete */
-	xfs_sync_data(mp, SYNC_WAIT);
 	xfs_qm_sync(mp, SYNC_WAIT);
 
+	/* flush all pending size updates and unwritten extent conversions */
+	flush_workqueue(mp->m_data_iodone_queue);
+	flush_workqueue(mp->m_unwritten_iodone_queue);
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
