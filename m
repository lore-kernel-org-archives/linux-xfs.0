Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:54248 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752013AbeENRjU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 May 2018 13:39:20 -0400
Subject: [PATCH 3/5 V2] xfs: implement online get/set fs label
References: <5957a0ff-0fd7-c1f3-2d44-86b825c2eb3b@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <6abac150-604e-b011-4d2d-1ee20fc56759@sandeen.net>
Date: Mon, 14 May 2018 12:39:19 -0500
MIME-Version: 1.0
In-Reply-To: <5957a0ff-0fd7-c1f3-2d44-86b825c2eb3b@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

The GET ioctl is trivial, just return the current label.

The SET ioctl is more involved:
It transactionally modifies the superblock to write a new filesystem
label to the primary super.

A new variant of xfs_sync_sb then writes the superblock buffer
immediately to disk so that the change is visible from userspace.

It then invalidates any page cache that userspace might have previously
read on the block device so that i.e. blkid can see the change
immediately, and updates all secondary superblocks as userspace relable
does.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2, rework the max length handling a bit, add comments re: userspace,
do the blkdev flush at the end, sleep for growfs lock, add locking around
getlabel, add define for max label length ...

 fs/xfs/libxfs/xfs_format.h |  7 +++-
 fs/xfs/libxfs/xfs_sb.c     | 30 +++++++++++++
 fs/xfs/libxfs/xfs_sb.h     |  1 +
 fs/xfs/xfs_ioctl.c         | 86 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 122 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 42956d8d95ed..c1cb29a5f4f6 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -98,6 +98,9 @@ struct xfs_ifork;
 	 XFS_SB_VERSION2_PROJID32BIT	| \
 	 XFS_SB_VERSION2_FTYPE)
 
+/* Maximum size of the xfs filesystem label, no terminating NULL */
+#define XFSLABEL_MAX			12
+
 /*
  * Superblock - in core version.  Must match the ondisk version below.
  * Must be padded to 64 bit alignment.
@@ -122,7 +125,7 @@ typedef struct xfs_sb {
 	uint16_t	sb_sectsize;	/* volume sector size, bytes */
 	uint16_t	sb_inodesize;	/* inode size, bytes */
 	uint16_t	sb_inopblock;	/* inodes per block */
-	char		sb_fname[12];	/* file system name */
+	char		sb_fname[XFSLABEL_MAX]; /* file system name */
 	uint8_t		sb_blocklog;	/* log2 of sb_blocksize */
 	uint8_t		sb_sectlog;	/* log2 of sb_sectsize */
 	uint8_t		sb_inodelog;	/* log2 of sb_inodesize */
@@ -213,7 +216,7 @@ typedef struct xfs_dsb {
 	__be16		sb_sectsize;	/* volume sector size, bytes */
 	__be16		sb_inodesize;	/* inode size, bytes */
 	__be16		sb_inopblock;	/* inodes per block */
-	char		sb_fname[12];	/* file system name */
+	char		sb_fname[XFSLABEL_MAX]; /* file system name */
 	__u8		sb_blocklog;	/* log2 of sb_blocksize */
 	__u8		sb_sectlog;	/* log2 of sb_sectsize */
 	__u8		sb_inodelog;	/* log2 of sb_inodesize */
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index d9b94bd5f689..0bc0a40764e1 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -888,6 +888,36 @@ xfs_sync_sb(
 	return xfs_trans_commit(tp);
 }
 
+/*
+ * Same behavior as xfs_sync_sb, except that it is always synchronous and it
+ * also writes the superblock buffer to disk sector 0 immediately.
+ */
+int
+xfs_sync_sb_buf(
+	struct xfs_mount	*mp)
+{
+	struct xfs_trans	*tp;
+	int			error;
+
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_sb, 0, 0, 0, &tp);
+	if (error)
+		return error;
+
+	xfs_log_sb(tp);
+	xfs_trans_bhold(tp, mp->m_sb_bp);
+	xfs_trans_set_sync(tp);
+	error = xfs_trans_commit(tp);
+	if (error)
+		goto out;
+	/*
+	 * write out the sb buffer to get the changes to disk
+	 */
+	error = xfs_bwrite(mp->m_sb_bp);
+out:
+	xfs_buf_relse(mp->m_sb_bp);
+	return error;
+}
+
 int
 xfs_fs_geometry(
 	struct xfs_sb		*sbp,
diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
index 63dcd2a1a657..226827281760 100644
--- a/fs/xfs/libxfs/xfs_sb.h
+++ b/fs/xfs/libxfs/xfs_sb.h
@@ -29,6 +29,7 @@ extern int	xfs_initialize_perag_data(struct xfs_mount *, xfs_agnumber_t);
 
 extern void	xfs_log_sb(struct xfs_trans *tp);
 extern int	xfs_sync_sb(struct xfs_mount *mp, bool wait);
+extern int	xfs_sync_sb_buf(struct xfs_mount *mp);
 extern void	xfs_sb_mount_common(struct xfs_mount *mp, struct xfs_sb *sbp);
 extern void	xfs_sb_from_disk(struct xfs_sb *to, struct xfs_dsb *from);
 extern void	xfs_sb_to_disk(struct xfs_dsb *to, struct xfs_sb *from);
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 89fb1eb80aae..5e7116ff3dd3 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1811,6 +1811,88 @@ xfs_ioc_swapext(
 	return error;
 }
 
+static int
+xfs_ioc_getlabel(
+	struct xfs_mount	*mp,
+	char			__user *user_label)
+{
+	struct xfs_sb		*sbp = &mp->m_sb;
+	char			label[XFSLABEL_MAX + 1];
+
+	/* Paranoia */
+	BUILD_BUG_ON(sizeof(sbp->sb_fname) > FSLABEL_MAX);
+
+	spin_lock(&mp->m_sb_lock);
+	strncpy(label, sbp->sb_fname, sizeof(sbp->sb_fname));
+	spin_unlock(&mp->m_sb_lock);
+
+	/* xfs on-disk label is 12 chars, be sure we send a null to user */
+	label[XFSLABEL_MAX] = '\0';
+	if (copy_to_user(user_label, label, sizeof(sbp->sb_fname)))
+		return -EFAULT;
+	return 0;
+}
+
+static int
+xfs_ioc_setlabel(
+	struct file		*filp,
+	struct xfs_mount	*mp,
+	char			__user *newlabel)
+{
+	struct xfs_sb		*sbp = &mp->m_sb;
+	char			label[XFSLABEL_MAX + 1];
+	size_t			len;
+	int			error;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+	/*
+	 * The generic ioctl allows up to FSLABEL_MAX chars, but XFS is much
+	 * smaller, at 12 bytes.  We copy one more to be sure we find the
+	 * (required) NULL character to test the incoming label length.
+	 * NB: The on disk label doesn't need to be null terminated.
+	 */
+	if (copy_from_user(label, newlabel, XFSLABEL_MAX + 1))
+		return -EFAULT;
+	len = strnlen(label, XFSLABEL_MAX + 1);
+	if (len > sizeof(sbp->sb_fname))
+		return -EINVAL;
+
+	error = mnt_want_write_file(filp);
+	if (error)
+		return error;
+
+	spin_lock(&mp->m_sb_lock);
+	memset(sbp->sb_fname, 0, sizeof(sbp->sb_fname));
+	strncpy(sbp->sb_fname, label, sizeof(sbp->sb_fname));
+	spin_unlock(&mp->m_sb_lock);
+
+	/*
+	 * Now we do several things to satisfy userspace.
+	 * In addition to normal logging of the primary superblock, we also
+	 * immediately write these changes to sector zero for the primary, then
+	 * update all backup supers (as xfs_db does for a label change), then
+	 * invalidate the block device page cache.  This is so that any prior
+	 * buffered reads from userspace (i.e. from blkid) are invalidated,
+	 * and userspace will see the newly-written label.
+	 */
+	error = xfs_sync_sb_buf(mp);
+	if (error)
+		goto out;
+	/*
+	 * growfs also updates backup supers so lock against that.
+	 */
+	mutex_lock(&mp->m_growlock);
+	error = xfs_update_secondary_supers(mp);
+	mutex_unlock(&mp->m_growlock);
+
+	invalidate_bdev(mp->m_ddev_targp->bt_bdev);
+
+out:
+	mnt_drop_write_file(filp);
+	return error;
+}
+
 /*
  * Note: some of the ioctl's return positive numbers as a
  * byte count indicating success, such as readlink_by_handle.
@@ -1834,6 +1916,10 @@ xfs_file_ioctl(
 	switch (cmd) {
 	case FITRIM:
 		return xfs_ioc_trim(mp, arg);
+	case FS_IOC_GETFSLABEL:
+		return xfs_ioc_getlabel(mp, arg);
+	case FS_IOC_SETFSLABEL:
+		return xfs_ioc_setlabel(filp, mp, arg);
 	case XFS_IOC_ALLOCSP:
 	case XFS_IOC_FREESP:
 	case XFS_IOC_RESVSP:
-- 
2.17.0


