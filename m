Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:27719 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754013AbeFRF5Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jun 2018 01:57:16 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1fUnA9-0003he-8Q
        for linux-xfs@vger.kernel.org; Mon, 18 Jun 2018 15:57:13 +1000
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1fUnA9-0006F3-6z
        for linux-xfs@vger.kernel.org; Mon, 18 Jun 2018 15:57:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] xfs: zero length symlinks are not valid
Date: Mon, 18 Jun 2018 15:57:10 +1000
Message-Id: <20180618055711.23391-2-david@fromorbit.com>
In-Reply-To: <20180618055711.23391-1-david@fromorbit.com>
References: <20180618055711.23391-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

A log recovery failure has been reproduced where a symlink inode has
a zero length in extent form. It was caused by a shutdown during a
combined fstress+fsmark workload.

The underlying problem is the issue in xfs_inactive_symlink(): the
inode is unlocked between the symlink inactivation/truncation and
the inode being freed. This opens a window for the inode to be
written to disk before it xfs_ifree() removes it from the unlinked
list, marks it free in the inobt and zeros the mode.

For shortform inodes, the fix is simple. xfs_ifree() clears the data
fork state, so there's no need to do it in xfs_inactive_symlink().
This means the shortform fork verifier will not see a zero length
data fork as it mirrors the inode size through to xfs_ifree()), and
hence if the inode gets written back and the fork verifiers are run
they will still see a fork that matches the on-disk inode size.

For extent form (remote) symlinks, it is a little more tricky. Here
we explicitly set the inode size to zero, so the above race can lead
to zero length symlinks on disk. Because the inode is unlinked at
this point (i.e. on the unlinked list) and unreferenced, it can
never be seen again by a user. Hence when we set the inode size to
zeor, also change the type to S_IFREG. xfs_ifree() expects S_IFREG
inodes to be of zero length, and so this avoids all the problems of
zero length symlinks ever hitting the disk. It also avoids the
problem of needing to handle zero length symlink inodes in log
recovery to replay the extent free intents and the remaining
deferops to free the extents the symlink used.

Also add a couple of asserts to warn us if zero length symlinks end
up in either the symlink create or inactivation paths.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_symlink_remote.c | 14 +++++++++----
 fs/xfs/xfs_symlink.c               | 33 +++++++++++++++---------------
 2 files changed, 27 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
index 95374ab2dee7..77d80106f989 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.c
+++ b/fs/xfs/libxfs/xfs_symlink_remote.c
@@ -199,7 +199,10 @@ xfs_symlink_local_to_remote(
 					ifp->if_bytes - 1);
 }
 
-/* Verify the consistency of an inline symlink. */
+/*
+ * Verify the in-memory consistency of an inline symlink data fork. This
+ * does not do on-disk format checks.
+ */
 xfs_failaddr_t
 xfs_symlink_shortform_verify(
 	struct xfs_inode	*ip)
@@ -215,9 +218,12 @@ xfs_symlink_shortform_verify(
 	size = ifp->if_bytes;
 	endp = sfp + size;
 
-	/* Zero length symlinks can exist while we're deleting a remote one. */
-	if (size == 0)
-		return NULL;
+	/*
+	 * Zero length symlinks should never occur in memory as they are
+	 * never alllowed to exist on disk.
+	 */
+	if (!size)
+		return __this_address;
 
 	/* No negative sizes or overly long symlink targets. */
 	if (size < 0 || size > XFS_SYMLINK_MAXLEN)
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 3783afcb68d2..e0c2d460ba67 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -194,6 +194,7 @@ xfs_symlink(
 	pathlen = strlen(target_path);
 	if (pathlen >= XFS_SYMLINK_MAXLEN)      /* total string too long */
 		return -ENAMETOOLONG;
+	ASSERT(pathlen > 0);
 
 	udqp = gdqp = NULL;
 	prid = xfs_get_initial_prid(dp);
@@ -395,6 +396,12 @@ xfs_symlink(
 
 /*
  * Free a symlink that has blocks associated with it.
+ *
+ * Note: zero length symlinks are not allowed to exist. When we set the size to
+ * zero, also change it to a regular file so that it does not get written to
+ * disk as a zero length symlink. The inode is on the unlinked list already, so
+ * userspace cannot find this inode anymore, so this change is not user visible
+ * but allows us to catch corrupt zero-length symlinks in the verifiers.
  */
 STATIC int
 xfs_inactive_symlink_rmt(
@@ -431,13 +438,14 @@ xfs_inactive_symlink_rmt(
 	xfs_trans_ijoin(tp, ip, 0);
 
 	/*
-	 * Lock the inode, fix the size, and join it to the transaction.
-	 * Hold it so in the normal path, we still have it locked for
-	 * the second transaction.  In the error paths we need it
+	 * Lock the inode, fix the size, turn it into a regular file and join it
+	 * to the transaction.  Hold it so in the normal path, we still have it
+	 * locked for the second transaction.  In the error paths we need it
 	 * held so the cancel won't rele it, see below.
 	 */
 	size = (int)ip->i_d.di_size;
 	ip->i_d.di_size = 0;
+	VFS_I(ip)->i_mode = (VFS_I(ip)->i_mode & ~S_IFMT) | S_IFREG;
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	/*
 	 * Find the block(s) so we can inval and unmap them.
@@ -523,17 +531,10 @@ xfs_inactive_symlink(
 		return -EIO;
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-
-	/*
-	 * Zero length symlinks _can_ exist.
-	 */
 	pathlen = (int)ip->i_d.di_size;
-	if (!pathlen) {
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		return 0;
-	}
+	ASSERT(pathlen);
 
-	if (pathlen < 0 || pathlen > XFS_SYMLINK_MAXLEN) {
+	if (pathlen <= 0 || pathlen > XFS_SYMLINK_MAXLEN) {
 		xfs_alert(mp, "%s: inode (0x%llx) bad symlink length (%d)",
 			 __func__, (unsigned long long)ip->i_ino, pathlen);
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
@@ -541,12 +542,12 @@ xfs_inactive_symlink(
 		return -EFSCORRUPTED;
 	}
 
+	/*
+	 * Inline fork state gets removed by xfs_difree() so we have nothing to
+	 * do here in that case.
+	 */
 	if (ip->i_df.if_flags & XFS_IFINLINE) {
-		if (ip->i_df.if_bytes > 0) 
-			xfs_idata_realloc(ip, -(ip->i_df.if_bytes),
-					  XFS_DATA_FORK);
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		ASSERT(ip->i_df.if_bytes == 0);
 		return 0;
 	}
 
-- 
2.17.0

