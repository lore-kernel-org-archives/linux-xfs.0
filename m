Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B7C3E7F69
	for <xfs@oss.sgi.com>; Thu,  9 Apr 2015 09:54:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8BEC0304039
	for <xfs@oss.sgi.com>; Thu,  9 Apr 2015 07:54:32 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id p5fhF5fxDe9okXJm (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 09 Apr 2015 07:54:30 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t39EsTkk013006
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Thu, 9 Apr 2015 10:54:30 -0400
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t39EsTom024684
	for <xfs@oss.sgi.com>; Thu, 9 Apr 2015 10:54:29 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2] xfs: use spin lock to prevent i_size race on dio write
	completion
Date: Thu,  9 Apr 2015 10:54:27 -0400
Message-Id: <1428591267-5689-1-git-send-email-bfoster@redhat.com>
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

XFS allows O_DIRECT writes to the same file to execute in parallel under
the shared iolock. If the write offset is beyond the inode size (not
appending), the write path cycles the exclusive iolock to check for
previously unexposed blocks that must be zeroed. If I/O is synchronous,
this has the side effect of waiting on all in-flight I/O to complete.

If writes occur slightly out of order, however, it's possible for even
O_SYNC|O_DIRECT writes to race to extend i_size in the end_io completion
handler. For example, this can be easily manufactured with an artificial
delay in xfs_end_io_direct_write():

	if (offset + size > i_size_read(inode)) {
		mdelay(...);
		...
	}

Execute the following commands in order, but in parallel such that they
both read the current i_size as 0 and delay to update it:

$ xfs_io -f -d -s -c "pwrite 4k 4k" /mnt/file
$ xfs_io -f -d -s -c "pwrite 0 4k" /mnt/file

Since the write at 4k passes through the delay first, it sets i_size to
8k. Shortly after, the write to 0 sets i_size to 4k:

$ ls -al /mnt/file
-rw-------. 1 root root 4096 Apr  4 06:48 /mnt/file

At this point, any further file extending writes consider the block at
EOF (4k) as stale data that must be zeroed:

$ xfs_io -f -d -s -c "pwrite 8k 4k" /mnt/file
$ ls -al /mnt/file
-rw-------. 1 root root 12288 Apr  4 06:51 /mnt/file
$ hexdump /mnt/file
0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
*
0001000 0000 0000 0000 0000 0000 0000 0000 0000
*
0002000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
*
0003000

The i_size update in xfs_end_io_direct_write() is a fundamental test/set
race across concurrent completions. We cannot use a generic spin lock in
this case because completion can run under wq or irq (aio) context and
is thus subject to deadlock. Therefore, create a new i_size_lock in the
xfs_inode that can be acquired in an irq safe manner. This lock is
purely to protect i_size updates under parallel dio, allowed under
IOLOCK_SHARED.

Acquire the lock on the submission side (xfs_file_aio_write_checks()) to
increase the odds that we have the most recent, stable i_size value for
the zero eof blocks check. Finally, wait for all dio to drain as part of
the zero eof blocks sequence to protect against in-flight aio and ensure
we have exclusive access to the inode before we check for blocks to
zero.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

v2:
- Use new, irq safe lock and acquire on submission side checks.
- Wait for in-flight aio on xfs_zero_eof() check sequence.
v1: http://oss.sgi.com/pipermail/xfs/2015-April/041286.html

Hi all,

This is v2 of the dio i_size race fix. Dave had discovered that the
original version had unsafe locking due to the possible irq context for
dio completion. I didn't have the appropriate lock debugging enabled in
my initial tests so I didn't detect it. It apparently also pointed out
that execution context management for dio completion is busted. E.g.,
it's possible to run transactions in irq context when we should defer
the transaction running cases to workqueue. I believe Dave is working on
a fix for that. This patch addresses those problems with v1 (not the
end_io ctx bug) and still survives the original reproducer, but
additional testing is ongoing...

My understanding is the associated rework should render this separate
and irq safe lock unnecessary for the race fix. E.g., locking is still
required, but that should only be the case in wq completion context. My
preference is to have isolated fixes for the race/data corruption and
completion context fixes such that we have backportable fixes for stable
kernels that might be affected by one or both bugs, or view the
priority/reproducibility differently. Whether that manifests as
something like this patch followed up by fixes to switch the lock or a
careful enough separation of independent fixes in a broader rework
series doesn't matter so much to me. Posting this for posterity if
nothing else and we'll see what falls out from the broader rework...
thanks.

Brian

 fs/xfs/xfs_aops.c  | 10 +++++++++-
 fs/xfs/xfs_file.c  | 22 ++++++++++++++++++----
 fs/xfs/xfs_inode.h |  1 +
 fs/xfs/xfs_super.c |  1 +
 4 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 3a9b7a1..f15184f 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1455,6 +1455,7 @@ xfs_end_io_direct_write(
 	struct inode		*inode = file_inode(iocb->ki_filp);
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
+	unsigned long		flags;
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return;
@@ -1463,10 +1464,17 @@ xfs_end_io_direct_write(
 	 * While the generic direct I/O code updates the inode size, it does
 	 * so only after the end_io handler is called, which means our
 	 * end_io handler thinks the on-disk size is outside the in-core
-	 * size.  To prevent this just update it a little bit earlier here.
+	 * size. To prevent this just update it a little bit earlier here.
+	 *
+	 * Take the irq-safe i_size_lock to prevent test/set races between
+	 * extending I/Os from either wq or irq context. This race can occur
+	 * when a non-appending extending (pos > i_size) write is submitted out
+	 * of offset order from an appending (pos == i_size) write.
 	 */
+	spin_lock_irqsave(&ip->i_size_lock, flags);
 	if (offset + size > i_size_read(inode))
 		i_size_write(inode, offset + size);
+	spin_unlock_irqrestore(&ip->i_size_lock, flags);
 
 	/*
 	 * For direct I/O we do not know if we need to allocate blocks or not,
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index dc5f609..6c3ff6d 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -553,6 +553,7 @@ xfs_file_aio_write_checks(
 	struct inode		*inode = file->f_mapping->host;
 	struct xfs_inode	*ip = XFS_I(inode);
 	int			error = 0;
+	unsigned long		flags;
 
 restart:
 	error = generic_write_checks(file, pos, count, S_ISBLK(inode->i_mode));
@@ -566,23 +567,36 @@ restart:
 	/*
 	 * If the offset is beyond the size of the file, we need to zero any
 	 * blocks that fall between the existing EOF and the start of this
-	 * write.  If zeroing is needed and we are currently holding the
-	 * iolock shared, we need to update it to exclusive which implies
-	 * having to redo all checks before.
+	 * write. That means we need a sane EOF with respect to any number of
+	 * sync or async writes that could be in-flight.
+	 *
+	 * First, grab the i_size_lock to increase the odds that we have the
+	 * latest size from updates on I/O completion side. All sync I/O occurs
+	 * under the shared iolock. Therefore, we cycle to the exclusive iolock
+	 * to wait for those to complete and block out any further I/O
+	 * submission. Async I/O can still be in flight as the iolock only
+	 * covers aio submission. Wait for that explicitly once we've got
+	 * IOLOCK_EXCL. Finally, the unlock/lock cycle means we must redo all of
+	 * the checks above.
 	 */
+	spin_lock_irqsave(&ip->i_size_lock, flags);
 	if (*pos > i_size_read(inode)) {
 		bool	zero = false;
 
+		spin_unlock_irqrestore(&ip->i_size_lock, flags);
 		if (*iolock == XFS_IOLOCK_SHARED) {
 			xfs_rw_iunlock(ip, *iolock);
 			*iolock = XFS_IOLOCK_EXCL;
 			xfs_rw_ilock(ip, *iolock);
+
+			inode_dio_wait(inode);
 			goto restart;
 		}
 		error = xfs_zero_eof(ip, *pos, i_size_read(inode), &zero);
 		if (error)
 			return error;
-	}
+	} else
+		spin_unlock_irqrestore(&ip->i_size_lock, flags);
 
 	/*
 	 * Updating the timestamps will grab the ilock again from
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 8f22d20..4bbc757 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -62,6 +62,7 @@ typedef struct xfs_inode {
 	/* Miscellaneous state. */
 	unsigned long		i_flags;	/* see defined flags below */
 	unsigned int		i_delayed_blks;	/* count of delay alloc blks */
+	spinlock_t		i_size_lock;	/* concurrent dio i_size lock */
 
 	xfs_icdinode_t		i_d;		/* most of ondisk inode */
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 8782b36..bcf1279 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -965,6 +965,7 @@ xfs_fs_inode_init_once(
 	/* xfs inode */
 	atomic_set(&ip->i_pincount, 0);
 	spin_lock_init(&ip->i_flags_lock);
+	spin_lock_init(&ip->i_size_lock);
 
 	mrlock_init(&ip->i_mmaplock, MRLOCK_ALLOW_EQUAL_PRI|MRLOCK_BARRIER,
 		     "xfsino", ip->i_ino);
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
