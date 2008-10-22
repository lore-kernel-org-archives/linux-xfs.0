Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 22 Oct 2008 01:15:33 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9M8FUId012957
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 01:15:30 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0737B52B9C5
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 01:17:14 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id 1ukvtEjfFhXQ3Blt for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 01:17:14 -0700 (PDT)
Date: Wed, 22 Oct 2008 19:17:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH, RFC] Re: atime not written to disk
Message-ID: <20081022081710.GL18495@disturbed>
References: <48FD74CC.907@sgi.com> <48FD7B69.3090600@wm.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48FD7B69.3090600@wm.jp.nec.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Utako Kusaka <u-kusaka@wm.jp.nec.com>
Cc: Timothy Shimmin <tes@sgi.com>, xfs <xfs@oss.sgi.com>

On Tue, Oct 21, 2008 at 03:49:13PM +0900, Utako Kusaka wrote:
> Hi,
>
> Your problem seems the same as mine.
> http://oss.sgi.com/archives/xfs/2007-10/msg00168.html
>
> Utako.
>
> Timothy Shimmin wrote:
>> Hi,
>>
>> Before I investigate further ;-),
>> it appears that in XFS (seen in recent xfs-dev tree and on older issp release
>> on default mkfs/mount options),
>> that the atime is not being written out to disk in xfs,
>> at least, in the simple scenario below.
>>
>> emu:/home/tes # echo bill >/mnt/test/bill
>> emu:/home/tes # ls -l /mnt/test/bill
>> -rw-r--r-- 1 root root 5 2008-10-21 16:03 /mnt/test/bill
>> emu:/home/tes # ls -lu /mnt/test/bill
>> -rw-r--r-- 1 root root 5 2008-10-21 16:03 /mnt/test/bill
>>
>> ... wait a bit to change the atime...
>>
>> emu:/home/tes # cat /mnt/test/bill
>> bill
>> emu:/home/tes # ls -lu /mnt/test/bill
>> -rw-r--r-- 1 root root 5 2008-10-21 16:11 /mnt/test/bill
>>
>> emu:/home/tes # cd /
>> emu:/ # umount /mnt/test
>> emu:/ # mount /mnt/test
>> emu:/mnt/test # ls -lu /mnt/test/bill
>> -rw-r--r-- 1 root root 5 2008-10-21 16:03 /mnt/test/bill

As I mentioned on IRC, Tim, the following patch fixes the above test
case. It will make XFS behave like other filesystems w.r.t. atime,
instead of defaulting to relatime-like behaviour. This will have
performance impact unless ppl now add the relatime mount option.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com


XFS: Implement ->dirty_inode callout

Hook up ->dirty_inode so that when the VFS dirties an inode we
can mark the XFS inode as "dirty with unlogged changes". This
allows events such as touch_atime() to propagate the dirty state
right through to XFS so it gets written back to disk.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_aops.c  |    1 -
 fs/xfs/linux-2.6/xfs_iops.c  |   14 +++-----------
 fs/xfs/linux-2.6/xfs_super.c |   23 +++++++++++++++++++++++
 fs/xfs/xfs_inode_item.c      |   14 +++++++++-----
 4 files changed, 35 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index 8fbc97d..6f4ebd0 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -189,7 +189,6 @@ xfs_setfilesize(
 
 	if (ip->i_d.di_size < isize) {
 		ip->i_d.di_size = isize;
-		ip->i_update_core = 1;
 		ip->i_update_size = 1;
 		xfs_mark_inode_dirty_sync(ip);
 	}
diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
index 37bb101..b7deff9 100644
--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
@@ -117,19 +117,11 @@ xfs_ichgtime(
 	}
 
 	/*
-	 * We update the i_update_core field _after_ changing
-	 * the timestamps in order to coordinate properly with
-	 * xfs_iflush() so that we don't lose timestamp updates.
-	 * This keeps us from having to hold the inode lock
-	 * while doing this.  We use the SYNCHRONIZE macro to
-	 * ensure that the compiler does not reorder the update
-	 * of i_update_core above the timestamp updates above.
+	 * Update complete - now make sure everyone knows that the inode
+	 * is dirty.
 	 */
-	if (sync_it) {
-		SYNCHRONIZE();
-		ip->i_update_core = 1;
+	if (sync_it)
 		xfs_mark_inode_dirty_sync(ip);
-	}
 }
 
 /*
diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index 3ae8051..a5570b5 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -928,6 +928,28 @@ xfs_fs_inode_init_once(
 }
 
 /*
+ * Dirty the XFS inode when mark_inode_dirty_sync() is called so that
+ * we catch unlogged VFS level updates to the inode. Care must be taken
+ * here - the transaction code calls mark_inode_dirty_sync() to mark the
+ * VFS inode dirty in a transaction and clears the i_update_core field;
+ * it must clear the field after calling mark_inode_dirty_sync() to
+ * correctly indicate that the dirty state has been propagated into the
+ * inode log item.
+ *
+ * We need the barrier() to maintain correct ordering between unlogged
+ * updates and the transaction commit code that clears the i_update_core
+ * field. This requires all updates to be completed before marking the
+ * inode dirty.
+ */
+STATIC void
+xfs_fs_dirty_inode(
+	struct inode    *inode)
+{
+	barrier();
+	XFS_I(inode)->i_update_core = 1;
+}
+
+/*
  * Attempt to flush the inode, this will actually fail
  * if the inode is pinned, but we dirty the inode again
  * at the point when it is unpinned after a log write,
@@ -1712,6 +1734,7 @@ xfs_fs_get_sb(
 static struct super_operations xfs_super_operations = {
 	.alloc_inode		= xfs_fs_alloc_inode,
 	.destroy_inode		= xfs_fs_destroy_inode,
+	.dirty_inode		= xfs_fs_dirty_inode,
 	.write_inode		= xfs_fs_write_inode,
 	.clear_inode		= xfs_fs_clear_inode,
 	.put_super		= xfs_fs_put_super,
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index aa9bf05..89d480c 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -232,6 +232,15 @@ xfs_inode_item_format(
 	nvecs	     = 1;
 
 	/*
+	 * Make sure the linux inode is dirty. We do this before
+	 * clearing i_update_core as the VFS will call back into
+	 * XFS here and set i_update_core, so we need to dirty the
+	 * inode first so that the ordering of i_update_core and
+	 * unlogged modifications still works as described below.
+	 */
+	xfs_mark_inode_dirty_sync(ip);
+
+	/*
 	 * Clear i_update_core if the timestamps (or any other
 	 * non-transactional modification) need flushing/logging
 	 * and we're about to log them with the rest of the core.
@@ -275,11 +284,6 @@ xfs_inode_item_format(
 	 */
 	xfs_synchronize_atime(ip);
 
-	/*
-	 * make sure the linux inode is dirty
-	 */
-	xfs_mark_inode_dirty_sync(ip);
-
 	vecp->i_addr = (xfs_caddr_t)&ip->i_d;
 	vecp->i_len  = sizeof(xfs_dinode_core_t);
 	XLOG_VEC_SET_TYPE(vecp, XLOG_REG_TYPE_ICORE);
