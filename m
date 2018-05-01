Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:41754 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751453AbeEAXEL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 1 May 2018 19:04:11 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 2020C32541C
        for <linux-xfs@vger.kernel.org>; Tue,  1 May 2018 18:02:57 -0500 (CDT)
Subject: [PATCH 4/5 V2] xfs: implement online get/set fs label
From: Eric Sandeen <sandeen@sandeen.net>
References: <eb592fc3-3165-5ec7-3896-b798fc7f6502@redhat.com>
 <698bd41a-9281-83a2-ff51-64547025442a@sandeen.net>
Message-ID: <2a638f02-ea72-0d5e-30a4-1d95cfe6ff69@sandeen.net>
Date: Tue, 1 May 2018 18:04:09 -0500
MIME-Version: 1.0
In-Reply-To: <698bd41a-9281-83a2-ff51-64547025442a@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

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

V2: rework the force-sb-to-disk approach, invalidate the whole block
device, and block waiting for the growfs lock.  Also remove too-long-label
printk.

Thanks to dchinner for the xfs_sync_sb_buf suggestion & framework.

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index d9b94bd..54992e8 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -888,6 +888,37 @@ struct xfs_perag *
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
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_sb, 0, 0,
+			XFS_TRANS_NO_WRITECOUNT, &tp);
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
index 63dcd2a..2268272 100644
--- a/fs/xfs/libxfs/xfs_sb.h
+++ b/fs/xfs/libxfs/xfs_sb.h
@@ -29,6 +29,7 @@ extern struct xfs_perag *xfs_perag_get_tag(struct xfs_mount *, xfs_agnumber_t,
 
 extern void	xfs_log_sb(struct xfs_trans *tp);
 extern int	xfs_sync_sb(struct xfs_mount *mp, bool wait);
+extern int	xfs_sync_sb_buf(struct xfs_mount *mp);
 extern void	xfs_sb_mount_common(struct xfs_mount *mp, struct xfs_sb *sbp);
 extern void	xfs_sb_from_disk(struct xfs_sb *to, struct xfs_dsb *from);
 extern void	xfs_sb_to_disk(struct xfs_dsb *to, struct xfs_sb *from);
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 89fb1eb..effb23a 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1811,6 +1811,72 @@ struct getfsmap_info {
 	return error;
 }
 
+static int
+xfs_ioc_getlabel(
+	struct xfs_mount	*mp,
+	char			__user *label)
+{
+	struct xfs_sb		*sbp = &mp->m_sb;
+
+	/* Paranoia */
+	BUILD_BUG_ON(sizeof(sbp->sb_fname) > FSLABEL_MAX);
+
+	if (copy_to_user(label, sbp->sb_fname, sizeof(sbp->sb_fname)))
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
+	char			label[FSLABEL_MAX];
+	size_t			len;
+	int			error;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (copy_from_user(label, newlabel, FSLABEL_MAX))
+		return -EFAULT;
+	/*
+	 * The generic ioctl allows up to FSLABEL_MAX chars, but XFS is much
+	 * smaller, at 12 bytes.
+	 * NB: The on disk label doesn't need to be null terminated.
+	 */
+	len = strnlen(label, FSLABEL_MAX);
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
+	/* Log primary superblock label changes & force to disk. */
+	error = xfs_sync_sb_buf(mp);
+	if (error)
+		goto out;
+
+	/* Invalidate any cached bdev page for userspace visibility. */
+	invalidate_bdev(mp->m_ddev_targp->bt_bdev);
+
+	/* Update the backup superblocks like userspace does. */
+	mutex_lock(&mp->m_growlock);
+	error = xfs_update_secondary_supers(mp, mp->m_sb.sb_agcount, 0);
+	mutex_unlock(&mp->m_growlock);
+out:
+	mnt_drop_write_file(filp);
+	return error;
+}
+
 /*
  * Note: some of the ioctl's return positive numbers as a
  * byte count indicating success, such as readlink_by_handle.
@@ -1834,6 +1900,10 @@ struct getfsmap_info {
 	switch (cmd) {
 	case FITRIM:
 		return xfs_ioc_trim(mp, arg);
+	case FS_IOC_GET_FSLABEL:
+		return xfs_ioc_getlabel(mp, arg);
+	case FS_IOC_SET_FSLABEL:
+		return xfs_ioc_setlabel(filp, mp, arg);
 	case XFS_IOC_ALLOCSP:
 	case XFS_IOC_FREESP:
 	case XFS_IOC_RESVSP:
