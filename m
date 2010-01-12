Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0C556Un219889 for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 23:05:06 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9955A15B849
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 21:06:00 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	LZ5KQS4rJU6BTYaj for <xfs@oss.sgi.com>;
	Mon, 11 Jan 2010 21:06:00 -0800 (PST)
Received: from discord (unverified [121.44.168.156])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11526388-1927428
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2010 15:35:58 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NUYx2-0004hf-Ui
	for xfs@oss.sgi.com; Tue, 12 Jan 2010 16:05:56 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NUYt0-0003wK-DH
	for xfs@oss.sgi.com; Tue, 12 Jan 2010 16:01:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: xfs_swap_extents needs to handle dynamic fork offsets
Date: Tue, 12 Jan 2010 16:01:46 +1100
Message-Id: <1263272506-15085-1-git-send-email-david@fromorbit.com>
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

When swapping extents, we can corrupt inodes by swapping data forks
that are in incompatible formats.  This is caused by the two indoes
having different fork offsets due to the presence of an attribute
fork on an attr2 filesystem.  xfs_fsr tries to be smart about
setting the fork offset, but the trick it plays only works on attr1
(old fixed format attribute fork) filesystems.

Changing the way xfs_fsr sets up the attribute fork will prevent
this situation from ever occurring, so in the kernel code we can get
by with a preventative fix - check that the data fork in the
defragmented inode is in a format valid for the inode it is being
swapped into.  This will lead to files that will silently and
potentially repeatedly fail defragmentation, so issue a warning to
the log when this particular failure occurs to let us know that
xfs_fsr needs updating/fixing.

To help identify how to improve xfs_fsr to avoid this issue, add
trace points for the inodes being swapped so that we can determine
why the swap was rejected and to confirm that the code is making the
right decisions and modifications when swapping forks.

A further complication is even when the swap is allowed to proceed
when the fork offset is different between the two inodes then value
for the maximum number of extents the data fork can hold can be
wrong. Make sure these are also set correctly after the swap occurs.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_trace.h |   53 ++++++++++++++++
 fs/xfs/xfs_dfrag.c           |  140 +++++++++++++++++++++++++++++++++---------
 2 files changed, 163 insertions(+), 30 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_trace.h b/fs/xfs/linux-2.6/xfs_trace.h
index 058fff1..d4145bf 100644
--- a/fs/xfs/linux-2.6/xfs_trace.h
+++ b/fs/xfs/linux-2.6/xfs_trace.h
@@ -1441,6 +1441,59 @@ TRACE_EVENT(xfs_dir2_leafn_moveents,
 		  __entry->count)
 );
 
+#define XFS_SWAPEXT_INODES \
+	{ 0,	"target" }, \
+	{ 1,	"temp" }
+
+#define XFS_INODE_FORMAT_STR \
+	{ 0,	"invalid" }, \
+	{ 1,	"local" }, \
+	{ 2,	"extent" }, \
+	{ 3,	"btree" }
+
+DECLARE_EVENT_CLASS(xfs_swap_extent_class,
+	TP_PROTO(struct xfs_inode *ip, int which),
+	TP_ARGS(ip, which),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(int, which)
+		__field(xfs_ino_t, ino)
+		__field(int, format)
+		__field(int, nex)
+		__field(int, max_nex)
+		__field(int, broot_size)
+		__field(int, fork_off)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(ip)->i_sb->s_dev;
+		__entry->which = which;
+		__entry->ino = ip->i_ino;
+		__entry->format = ip->i_d.di_format;
+		__entry->nex = ip->i_d.di_nextents;
+		__entry->max_nex = ip->i_df.if_ext_max;
+		__entry->broot_size = ip->i_df.if_broot_bytes;
+		__entry->fork_off = XFS_IFORK_BOFF(ip);
+	),
+	TP_printk("dev %d:%d %s inode 0x%llx, %s format, num_extents %d, "
+		  "Max in-fork extents %d, broot size %d, fork offset %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __print_symbolic(__entry->which, XFS_SWAPEXT_INODES),
+		  __entry->ino,
+		  __print_symbolic(__entry->format, XFS_INODE_FORMAT_STR),
+		  __entry->nex,
+		  __entry->max_nex,
+		  __entry->broot_size,
+		  __entry->fork_off)
+)
+
+#define DEFINE_SWAPEXT_EVENT(name) \
+DEFINE_EVENT(xfs_swap_extent_class, name, \
+	TP_PROTO(struct xfs_inode *ip, int which), \
+	TP_ARGS(ip, which))
+
+DEFINE_SWAPEXT_EVENT(xfs_swap_extent_before);
+DEFINE_SWAPEXT_EVENT(xfs_swap_extent_after);
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH
diff --git a/fs/xfs/xfs_dfrag.c b/fs/xfs/xfs_dfrag.c
index d1483a4..f83d127 100644
--- a/fs/xfs/xfs_dfrag.c
+++ b/fs/xfs/xfs_dfrag.c
@@ -53,7 +53,7 @@ xfs_swapext(
 	xfs_swapext_t	*sxp)
 {
 	xfs_inode_t     *ip, *tip;
-	struct file	*file, *target_file;
+	struct file	*file, *tmp_file;
 	int		error = 0;
 
 	/* Pull information for the target fd */
@@ -68,56 +68,128 @@ xfs_swapext(
 		goto out_put_file;
 	}
 
-	target_file = fget((int)sxp->sx_fdtmp);
-	if (!target_file) {
+	tmp_file = fget((int)sxp->sx_fdtmp);
+	if (!tmp_file) {
 		error = XFS_ERROR(EINVAL);
 		goto out_put_file;
 	}
 
-	if (!(target_file->f_mode & FMODE_WRITE) ||
-	    (target_file->f_flags & O_APPEND)) {
+	if (!(tmp_file->f_mode & FMODE_WRITE) ||
+	    (tmp_file->f_flags & O_APPEND)) {
 		error = XFS_ERROR(EBADF);
-		goto out_put_target_file;
+		goto out_put_tmp_file;
 	}
 
 	if (IS_SWAPFILE(file->f_path.dentry->d_inode) ||
-	    IS_SWAPFILE(target_file->f_path.dentry->d_inode)) {
+	    IS_SWAPFILE(tmp_file->f_path.dentry->d_inode)) {
 		error = XFS_ERROR(EINVAL);
-		goto out_put_target_file;
+		goto out_put_tmp_file;
 	}
 
 	ip = XFS_I(file->f_path.dentry->d_inode);
-	tip = XFS_I(target_file->f_path.dentry->d_inode);
+	tip = XFS_I(tmp_file->f_path.dentry->d_inode);
 
 	if (ip->i_mount != tip->i_mount) {
 		error = XFS_ERROR(EINVAL);
-		goto out_put_target_file;
+		goto out_put_tmp_file;
 	}
 
 	if (ip->i_ino == tip->i_ino) {
 		error = XFS_ERROR(EINVAL);
-		goto out_put_target_file;
+		goto out_put_tmp_file;
 	}
 
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
 		error = XFS_ERROR(EIO);
-		goto out_put_target_file;
+		goto out_put_tmp_file;
 	}
 
 	error = xfs_swap_extents(ip, tip, sxp);
 
- out_put_target_file:
-	fput(target_file);
+ out_put_tmp_file:
+	fput(tmp_file);
  out_put_file:
 	fput(file);
  out:
 	return error;
 }
 
+/*
+ * We need to check that the format of the data fork in the temporary inode is
+ * valid for the target inode before doing the swap. This is not a problem with
+ * attr1 because of the fixed fok offset, but attr2 has a dynamically sized
+ * data fork depending on the space the attribute fork is taking so we can get
+ * invalid formats on the target inode.
+ *
+ * e.g. target has space for 7 extents in extent format, temp inode only has
+ * space for 6.  If we defragment down to 7 extents, then the tmp format is a
+ * btree, but when swapped it needs to be in extent format. Hence we can't just
+ * blindly swap data forks on attr2 filesystems.
+ *
+ * Note that we check the swap in both directions so that we don't end up with
+ * a corrupt temporary inode, either.
+ *
+ * Note that fixing the way xfs_fsr sets up the attribute fork in the source
+ * inode will prevent this situation from occurring, so all we do here is
+ * reject and log the attempt. basically we are putting the responsibility on
+ * userspace to get this right.
+ */
+static int
+xfs_swap_extents_check_format(
+	xfs_inode_t	*ip,	/* target inode */
+	xfs_inode_t	*tip)	/* tmp inode */
+{
+
+	/* Should never get a local format */
+	if (ip->i_d.di_format == XFS_DINODE_FMT_LOCAL ||
+	    tip->i_d.di_format == XFS_DINODE_FMT_LOCAL)
+		return EINVAL;
+
+	/*
+	 * if the target inode has less extents that then temporary inode then
+	 * why did userspace call us?
+	 */
+	if (ip->i_d.di_nextents < tip->i_d.di_nextents)
+		return EINVAL;
+
+	/*
+	 * if the target inode is in extent form and the temp inode is in btree
+	 * form then we will end up with the target inode in the wrong format
+	 * as we already know there are less extents in the temp inode.
+	 */
+	if (ip->i_d.di_format == XFS_DINODE_FMT_EXTENTS &&
+	    tip->i_d.di_format == XFS_DINODE_FMT_BTREE)
+		return EINVAL;
+
+	/* Check temp in extent form to max in target */
+	if (tip->i_d.di_format == XFS_DINODE_FMT_EXTENTS &&
+	    XFS_IFORK_NEXTENTS(tip, XFS_DATA_FORK) > ip->i_df.if_ext_max)
+		return EINVAL;
+
+	/* Check target in extent form to max in temp */
+	if (ip->i_d.di_format == XFS_DINODE_FMT_EXTENTS &&
+	    XFS_IFORK_NEXTENTS(ip, XFS_DATA_FORK) > tip->i_df.if_ext_max)
+		return EINVAL;
+
+	/* Check root block of temp in btree form to max in target */
+	if (tip->i_d.di_format == XFS_DINODE_FMT_BTREE &&
+	    XFS_IFORK_BOFF(ip) &&
+	    tip->i_df.if_broot_bytes > XFS_IFORK_BOFF(ip))
+		return EINVAL;
+
+	/* Check root block of target in btree form to max in temp */
+	if (ip->i_d.di_format == XFS_DINODE_FMT_BTREE &&
+	    XFS_IFORK_BOFF(tip) &&
+	    ip->i_df.if_broot_bytes > XFS_IFORK_BOFF(tip))
+		return EINVAL;
+
+	return 0;
+}
+
 int
 xfs_swap_extents(
-	xfs_inode_t	*ip,
-	xfs_inode_t	*tip,
+	xfs_inode_t	*ip,	/* target inode */
+	xfs_inode_t	*tip,	/* tmp inode */
 	xfs_swapext_t	*sxp)
 {
 	xfs_mount_t	*mp;
@@ -161,13 +233,6 @@ xfs_swap_extents(
 		goto out_unlock;
 	}
 
-	/* Should never get a local format */
-	if (ip->i_d.di_format == XFS_DINODE_FMT_LOCAL ||
-	    tip->i_d.di_format == XFS_DINODE_FMT_LOCAL) {
-		error = XFS_ERROR(EINVAL);
-		goto out_unlock;
-	}
-
 	if (VN_CACHED(VFS_I(tip)) != 0) {
 		error = xfs_flushinval_pages(tip, 0, -1,
 				FI_REMAPF_LOCKED);
@@ -189,13 +254,15 @@ xfs_swap_extents(
 		goto out_unlock;
 	}
 
-	/*
-	 * If the target has extended attributes, the tmp file
-	 * must also in order to ensure the correct data fork
-	 * format.
-	 */
-	if ( XFS_IFORK_Q(ip) != XFS_IFORK_Q(tip) ) {
-		error = XFS_ERROR(EINVAL);
+	trace_xfs_swap_extent_before(ip, 0);
+	trace_xfs_swap_extent_before(tip, 1);
+
+	/* check inode formats now that data is flushed */
+	error = xfs_swap_extents_check_format(ip, tip);
+	if (error) {
+		xfs_fs_cmn_err(CE_NOTE, mp,
+		    "%s: inode 0x%llx format is incompatible for exchanging.",
+				__FILE__, ip->i_ino);
 		goto out_unlock;
 	}
 
@@ -276,6 +343,16 @@ xfs_swap_extents(
 	*tifp = *tempifp;	/* struct copy */
 
 	/*
+	 * Fix the in-memory data fork values that are dependent on the fork
+	 * offset in the inode. We can't assume they remain the same as attr2
+	 * has dynamic fork offsets.
+	 */
+	ifp->if_ext_max = XFS_IFORK_SIZE(ip, XFS_DATA_FORK) /
+					(uint)sizeof(xfs_bmbt_rec_t);
+	tifp->if_ext_max = XFS_IFORK_SIZE(tip, XFS_DATA_FORK) /
+					(uint)sizeof(xfs_bmbt_rec_t);
+
+	/*
 	 * Fix the on-disk inode values
 	 */
 	tmp = (__uint64_t)ip->i_d.di_nblocks;
@@ -347,6 +424,9 @@ xfs_swap_extents(
 
 	error = xfs_trans_commit(tp, XFS_TRANS_SWAPEXT);
 
+	trace_xfs_swap_extent_after(ip, 0);
+	trace_xfs_swap_extent_after(tip, 1);
+
 out:
 	kmem_free(tempifp);
 	return error;
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
