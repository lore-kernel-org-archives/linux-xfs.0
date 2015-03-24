Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3A06A7F63
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 05:59:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 148438F8071
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 03:59:42 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	jFFHgAW8S0ttk6yd for <xfs@oss.sgi.com>;
	Tue, 24 Mar 2015 03:59:39 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1YaMYY-0002sc-4c
	for xfs@oss.sgi.com; Tue, 24 Mar 2015 21:59:34 +1100
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1YaMYY-00013M-3o
	for xfs@oss.sgi.com; Tue, 24 Mar 2015 21:59:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/5] xfs: add RENAME_WHITEOUT support
Date: Tue, 24 Mar 2015 21:59:31 +1100
Message-Id: <1427194771-3105-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1427194771-3105-1-git-send-email-david@fromorbit.com>
References: <1427194771-3105-1-git-send-email-david@fromorbit.com>
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

Whiteouts are used by overlayfs -  it has a crazy convention that a
whiteout is a character device inode with a major:minor of 0:0.
Because it's not documented anywhere, here's an example of what
RENAME_WHITEOUT does on ext4:

# echo foo > /mnt/scratch/foo
# echo bar > /mnt/scratch/bar
# ls -l /mnt/scratch
total 24
-rw-r--r-- 1 root root     4 Feb 11 20:22 bar
-rw-r--r-- 1 root root     4 Feb 11 20:22 foo
drwx------ 2 root root 16384 Feb 11 20:18 lost+found
# src/renameat2 -w /mnt/scratch/foo /mnt/scratch/bar
# ls -l /mnt/scratch
total 20
-rw-r--r-- 1 root root     4 Feb 11 20:22 bar
c--------- 1 root root  0, 0 Feb 11 20:23 foo
drwx------ 2 root root 16384 Feb 11 20:18 lost+found
# cat /mnt/scratch/bar
foo
#

In XFS rename terms, the operation that has been done is that source
(foo) has been moved to the target (bar), which is like a nomal
rename operation, but rather than the source being removed, it have
been replaced with a whiteout.

We can't allocate whiteout inodes within the rename transaction due
to allocation being a multi-commit transaction: rename needs to
be a single, atomic commit. Hence we have several options here, form
most efficient to least efficient:

    - use DT_WHT in the target dirent and do no whiteout inode
      allocation.  The main issue with this approach is that we need
      hooks in lookup to create a virtual chardev inode to present
      to userspace and in places where we might need to modify the
      dirent e.g. unlink.  Overlayfs also needs to be taught about
      DT_WHT. Most invasive change, lowest overhead.

    - create a special whiteout inode in the root directory (e.g. a
      ".wino" dirent) and then hardlink every new whiteout to it.
      This means we only need to create a single whiteout inode, and
      rename simply creates a hardlink to it. We can use DT_WHT for
      these, though using DT_CHR means we won't have to modify
      overlayfs, nor anything in userspace. Downside is we have to
      look up the whiteout inode on every operation and create it if
      it doesn't exist.

    - copy ext4: create a special whiteout chardev inode for every
      whiteout.  This is more complex than the above options because
      of the lack of atomicity between inode creation and the rename
      operation, requiring us to create a tmpfile inode and then
      linking it into the directory structure during the rename. At
      least with a tmpfile inode crashes between the create and
      rename doesn't leave unreferenced inodes or directory
      pollution around.

By far the simplest thing to do in the short term is to copy ext4.
While it is the most inefficient way of supporting whiteouts, but as
an initial implementation we can simply reuse existing functions and
add a small amount of extra code the the rename operation.

When we get full whiteout support in the VFS (via the dentry cache)
we can then look to supporting DT_WHT method outlined as the first
method of supporting whiteouts. But until then, we'll stick with
what overlayfs expects us to be: dumb and stupid.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode.c | 129 +++++++++++++++++++++++++++++++++++++++++++----------
 fs/xfs/xfs_iops.c  |   2 +-
 2 files changed, 107 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 1ea05be..7915f68 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2864,39 +2864,80 @@ out_trans_abort:
 }
 
 /*
+ * xfs_rename_alloc_whiteout()
+ *
+ * Return a referenced, unlinked, unlocked inode that that can be used as a
+ * whiteout in a rename transaction. We use a tmpfile inode here so that if we
+ * crash between allocating the inode and linking it into the rename transaction
+ * recovery will free the inode and we won't leak it.
+ */
+static int
+xfs_rename_alloc_whiteout(
+	struct xfs_inode	*dp,
+	struct xfs_inode	**wip)
+{
+	struct xfs_inode	*tmpfile;
+	int			error;
+
+	error = xfs_create_tmpfile(dp, NULL, S_IFCHR | WHITEOUT_MODE, &tmpfile);
+	if (error)
+		return error;
+
+	/* Satisfy xfs_bumplink that this is a real tmpfile */
+	xfs_finish_inode_setup(tmpfile);
+	VFS_I(tmpfile)->i_state |= I_LINKABLE;
+
+	*wip = tmpfile;
+	return 0;
+}
+
+/*
  * xfs_rename
  */
 int
 xfs_rename(
-	xfs_inode_t	*src_dp,
-	struct xfs_name	*src_name,
-	xfs_inode_t	*src_ip,
-	xfs_inode_t	*target_dp,
-	struct xfs_name	*target_name,
-	xfs_inode_t	*target_ip,
-	unsigned int	flags)
+	struct xfs_inode	*src_dp,
+	struct xfs_name		*src_name,
+	struct xfs_inode	*src_ip,
+	struct xfs_inode	*target_dp,
+	struct xfs_name		*target_name,
+	struct xfs_inode	*target_ip,
+	unsigned int		flags)
 {
-	xfs_trans_t	*tp = NULL;
-	xfs_mount_t	*mp = src_dp->i_mount;
-	int		new_parent;		/* moving to a new dir */
-	int		src_is_directory;	/* src_name is a directory */
-	int		error;
-	xfs_bmap_free_t free_list;
-	xfs_fsblock_t   first_block;
-	int		cancel_flags = 0;
-	xfs_inode_t	*inodes[__XFS_SORT_INODES];
-	int		num_inodes = __XFS_SORT_INODES;
-	int		spaceres;
+	struct xfs_mount	*mp = src_dp->i_mount;
+	struct xfs_trans	*tp;
+	struct xfs_bmap_free	free_list;
+	xfs_fsblock_t		first_block;
+	struct xfs_inode	*wip = NULL;		/* whiteout inode */
+	struct xfs_inode	*inodes[__XFS_SORT_INODES];
+	int			num_inodes = __XFS_SORT_INODES;
+	int			new_parent = (src_dp != target_dp);
+	int			src_is_directory = S_ISDIR(src_ip->i_d.di_mode);
+	int			cancel_flags = 0;
+	int			spaceres;
+	int			error;
 
 	trace_xfs_rename(src_dp, target_dp, src_name, target_name);
 
 	if ((flags & RENAME_EXCHANGE) && !target_ip)
 		return -EINVAL;
 
-	new_parent = (src_dp != target_dp);
-	src_is_directory = S_ISDIR(src_ip->i_d.di_mode);
+	/*
+	 * If we are doing a whiteout operation, allocate the whiteout inode
+	 * we will be placing at the target and ensure the type is set
+	 * appropriately.
+	 */
+	if (flags & RENAME_WHITEOUT) {
+		ASSERT(!(flags & (RENAME_NOREPLACE | RENAME_EXCHANGE)));
+		error = xfs_rename_alloc_whiteout(target_dp, &wip);
+		if (error)
+			return error;
+
+		/* setup target dirent info as whiteout */
+		src_name->type = XFS_DIR3_FT_CHRDEV;
+	}
 
-	xfs_sort_for_rename(src_dp, target_dp, src_ip, target_ip, NULL,
+	xfs_sort_for_rename(src_dp, target_dp, src_ip, target_ip, wip,
 				inodes, &num_inodes);
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_RENAME);
@@ -2936,6 +2977,8 @@ xfs_rename(
 	xfs_trans_ijoin(tp, src_ip, XFS_ILOCK_EXCL);
 	if (target_ip)
 		xfs_trans_ijoin(tp, target_ip, XFS_ILOCK_EXCL);
+	if (wip)
+		xfs_trans_ijoin(tp, wip, XFS_ILOCK_EXCL);
 
 	/*
 	 * If we are using project inheritance, we only allow renames
@@ -3085,17 +3128,55 @@ xfs_rename(
 			goto out_trans_abort;
 	}
 
-	error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
+	/*
+	 * For whiteouts, we only need to update the source dirent with the
+	 * inode number of the whiteout inode rather than removing it
+	 * altogether.
+	 */
+	if (wip) {
+		error = xfs_dir_replace(tp, src_dp, src_name, wip->i_ino,
 					&first_block, &free_list, spaceres);
+	} else
+		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
+					   &first_block, &free_list, spaceres);
 	if (error)
 		goto out_trans_abort;
 
+	/*
+	 * For whiteouts, we need to bump the link count on the whiteout inode.
+	 * This means that failures all the way up to this point leave the inode
+	 * on the unlinked list and so cleanup is a simple matter of dropping
+	 * the remaining reference to it. If we fail here after bumping the link
+	 * count, we're shutting down the filesystem so we'll never see the
+	 * intermediate state on disk.
+	 */
+	if (wip) {
+		ASSERT(wip->i_d.di_nlink == 0);
+		error = xfs_bumplink(tp, wip);
+		if (error)
+			goto out_trans_abort;
+		error = xfs_iunlink_remove(tp, wip);
+		if (error)
+			goto out_trans_abort;
+		xfs_trans_log_inode(tp, wip, XFS_ILOG_CORE);
+
+		/*
+		 * Now we have a real link, clear the "I'm a tmpfile" state
+		 * flag from the inode so it doesn't accidentally get misused in
+		 * future.
+		 */
+		VFS_I(wip)->i_state &= ~I_LINKABLE;
+	}
+
 	xfs_trans_ichgtime(tp, src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
 	if (new_parent)
 		xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
 
-	return xfs_finish_rename(tp, &free_list);
+	error = xfs_finish_rename(tp, &free_list);
+	if (wip)
+		IRELE(wip);
+	return error;
 
 out_trans_abort:
 	cancel_flags |= XFS_TRANS_ABORT;
@@ -3103,6 +3184,8 @@ out_bmap_cancel:
 	xfs_bmap_cancel(&free_list);
 out_trans_cancel:
 	xfs_trans_cancel(tp, cancel_flags);
+	if (wip)
+		IRELE(wip);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 695d857..8db469b 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -394,7 +394,7 @@ xfs_vn_rename(
 	struct xfs_name	oname;
 	struct xfs_name	nname;
 
-	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE))
+	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE | RENAME_WHITEOUT))
 		return -EINVAL;
 
 	/* if we are exchanging files, we need to set i_mode of both files */
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
