Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 20 Aug 2007 13:54:30 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7KKsNbm006887
	for <xfs@oss.sgi.com>; Mon, 20 Aug 2007 13:54:24 -0700
Date: Mon, 20 Aug 2007 16:53:22 -0400
Message-Id: <200708202053.l7KKrMYv017763@dantu.rdu.redhat.com>
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 2/4] Fix mainline filesystems to handle ATTR_KILL_ bits correctly
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: v9fs-developer@lists.sourceforge.net, zippel@linux-m68k.org, dhowells@redhat.com, linux-cifs-client@lists.samba.org, codalist@TELEMANN.coda.cs.cmu.edu, joel.becker@oracle.com, linux-ext4@vger.kernel.org, fuse-devel@lists.sourceforge.net, cluster-devel@redhat.com, user-mode-linux-user@lists.sourceforge.net, mikulas@artax.karlin.mff.cuni.cz, wli@holomorphy.com, jffs-dev@axis.com, jfs-discussion@lists.sourceforge.net, ocfs2-devel@oss.oracle.com, reiserfs-devel@vger.kernel.org, bfennema@falcon.csc.calpoly.edu, xfs@oss.sgi.com

This should fix all of the filesystems in the mainline kernels to handle
ATTR_KILL_SUID and ATTR_KILL_SGID correctly. For most of them, this is
just a matter of making sure that they call generic_attrkill early in
the setattr inode op.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 arch/powerpc/platforms/cell/spufs/inode.c |    1 +
 fs/9p/vfs_inode.c                         |    1 +
 fs/affs/inode.c                           |    1 +
 fs/afs/inode.c                            |    3 +++
 fs/coda/inode.c                           |    1 +
 fs/configfs/inode.c                       |    4 +++-
 fs/ext2/inode.c                           |    1 +
 fs/ext3/inode.c                           |    5 ++++-
 fs/ext4/inode.c                           |    5 ++++-
 fs/fuse/dir.c                             |    2 ++
 fs/gfs2/ops_inode.c                       |    2 ++
 fs/hostfs/hostfs_kern.c                   |    2 ++
 fs/hpfs/inode.c                           |    1 +
 fs/hugetlbfs/inode.c                      |    5 ++++-
 fs/jffs2/fs.c                             |    1 +
 fs/jfs/acl.c                              |    2 ++
 fs/ocfs2/file.c                           |    2 ++
 fs/proc/base.c                            |    3 +++
 fs/proc/generic.c                         |    3 +++
 fs/proc/proc_sysctl.c                     |    3 +++
 fs/ramfs/file-nommu.c                     |    5 ++++-
 fs/reiserfs/inode.c                       |    6 +++++-
 fs/smbfs/inode.c                          |    2 ++
 fs/sysfs/inode.c                          |    5 ++++-
 fs/ufs/truncate.c                         |    5 ++++-
 fs/xfs/linux-2.6/xfs_iops.c               |    5 ++++-
 mm/shmem.c                                |    2 ++
 27 files changed, 69 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/platforms/cell/spufs/inode.c b/arch/powerpc/platforms/cell/spufs/inode.c
index b3d0dd1..66144a1 100644
--- a/arch/powerpc/platforms/cell/spufs/inode.c
+++ b/arch/powerpc/platforms/cell/spufs/inode.c
@@ -97,6 +97,7 @@ spufs_setattr(struct dentry *dentry, struct iattr *attr)
 {
 	struct inode *inode = dentry->d_inode;
 
+	generic_attrkill(inode->i_mode, attr);
 	if ((attr->ia_valid & ATTR_SIZE) &&
 	    (attr->ia_size != inode->i_size))
 		return -EINVAL;
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index e5c45ee..a90ebf1 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -756,6 +756,7 @@ static int v9fs_vfs_setattr(struct dentry *dentry, struct iattr *iattr)
 		return PTR_ERR(fid);
 
 	v9fs_blank_wstat(&wstat);
+	generic_attrkill(dentry->d_inode->i_mode, iattr);
 	if (iattr->ia_valid & ATTR_MODE)
 		wstat.mode = unixmode2p9mode(v9ses, iattr->ia_mode);
 
diff --git a/fs/affs/inode.c b/fs/affs/inode.c
index 4609a6c..e8dbedf 100644
--- a/fs/affs/inode.c
+++ b/fs/affs/inode.c
@@ -218,6 +218,7 @@ affs_notify_change(struct dentry *dentry, struct iattr *attr)
 
 	pr_debug("AFFS: notify_change(%lu,0x%x)\n",inode->i_ino,attr->ia_valid);
 
+	generic_attrkill(inode->i_mode, attr);
 	error = inode_change_ok(inode,attr);
 	if (error)
 		goto out;
diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index 84750c8..8c43c93 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -371,6 +371,9 @@ int afs_setattr(struct dentry *dentry, struct iattr *attr)
 	       vnode->fid.vid, vnode->fid.vnode, dentry->d_name.name,
 	       attr->ia_valid);
 
+	/* FIXME: is this necessary? */
+	generic_attrkill(dentry->d_inode->i_mode, attr);
+
 	if (!(attr->ia_valid & (ATTR_SIZE | ATTR_MODE | ATTR_UID | ATTR_GID |
 				ATTR_MTIME))) {
 		_leave(" = 0 [unsupported]");
diff --git a/fs/coda/inode.c b/fs/coda/inode.c
index 342f4e0..7dec870 100644
--- a/fs/coda/inode.c
+++ b/fs/coda/inode.c
@@ -239,6 +239,7 @@ int coda_setattr(struct dentry *de, struct iattr *iattr)
 	memset(&vattr, 0, sizeof(vattr)); 
 
 	inode->i_ctime = CURRENT_TIME_SEC;
+	generic_attrkill(inode->i_mode, iattr);
 	coda_iattr_to_vattr(iattr, &vattr);
 	vattr.va_type = C_VNON; /* cannot set type */
 
diff --git a/fs/configfs/inode.c b/fs/configfs/inode.c
index dbd257d..d3d6637 100644
--- a/fs/configfs/inode.c
+++ b/fs/configfs/inode.c
@@ -59,7 +59,7 @@ int configfs_setattr(struct dentry * dentry, struct iattr * iattr)
 	struct inode * inode = dentry->d_inode;
 	struct configfs_dirent * sd = dentry->d_fsdata;
 	struct iattr * sd_iattr;
-	unsigned int ia_valid = iattr->ia_valid;
+	unsigned int ia_valid;
 	int error;
 
 	if (!sd)
@@ -67,6 +67,7 @@ int configfs_setattr(struct dentry * dentry, struct iattr * iattr)
 
 	sd_iattr = sd->s_iattr;
 
+	generic_attrkill(inode->i_mode, iattr);
 	error = inode_change_ok(inode, iattr);
 	if (error)
 		return error;
@@ -90,6 +91,7 @@ int configfs_setattr(struct dentry * dentry, struct iattr * iattr)
 
 	/* attributes were changed atleast once in past */
 
+	ia_valid = iattr->ia_valid;
 	if (ia_valid & ATTR_UID)
 		sd_iattr->ia_uid = iattr->ia_uid;
 	if (ia_valid & ATTR_GID)
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index c1dcb68..353472c 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1405,6 +1405,7 @@ int ext2_setattr(struct dentry *dentry, struct iattr *iattr)
 	struct inode *inode = dentry->d_inode;
 	int error;
 
+	generic_attrkill(inode->i_mode, iattr);
 	error = inode_change_ok(inode, iattr);
 	if (error)
 		return error;
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 2d6324a..cabb57b 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -2989,7 +2989,10 @@ int ext3_setattr(struct dentry *dentry, struct iattr *attr)
 {
 	struct inode *inode = dentry->d_inode;
 	int error, rc = 0;
-	const unsigned int ia_valid = attr->ia_valid;
+	unsigned int ia_valid;
+
+	generic_attrkill(inode->i_mode, attr);
+	ia_valid = attr->ia_valid;
 
 	error = inode_change_ok(inode, attr);
 	if (error)
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index a49bb00..c39f472 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3047,7 +3047,10 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 {
 	struct inode *inode = dentry->d_inode;
 	int error, rc = 0;
-	const unsigned int ia_valid = attr->ia_valid;
+	unsigned int ia_valid;
+
+	generic_attrkill(inode->i_mode, attr);
+	ia_valid = attr->ia_valid;
 
 	error = inode_change_ok(inode, attr);
 	if (error)
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index d1acab9..df6a911 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1005,6 +1005,8 @@ static int fuse_setattr(struct dentry *entry, struct iattr *attr)
 	struct fuse_attr_out outarg;
 	int err;
 
+	generic_attrkill(inode->i_mode, attr);
+
 	if (fc->flags & FUSE_DEFAULT_PERMISSIONS) {
 		err = inode_change_ok(inode, attr);
 		if (err)
diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index 5b8b994..f0d8532 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -994,6 +994,8 @@ static int gfs2_setattr(struct dentry *dentry, struct iattr *attr)
 	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
 		goto out;
 
+	generic_attrkill(inode->i_mode, attr);
+
 	error = inode_change_ok(inode, attr);
 	if (error)
 		goto out;
diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index 4880256..370f71e 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -821,6 +821,8 @@ int hostfs_setattr(struct dentry *dentry, struct iattr *attr)
 
 	int fd = HOSTFS_I(dentry->d_inode)->fd;
 
+	generic_attrkill(dentry->d_inode->i_mode, attr);
+
 	err = inode_change_ok(dentry->d_inode, attr);
 	if (err)
 		return err;
diff --git a/fs/hpfs/inode.c b/fs/hpfs/inode.c
index 85d3e1d..1387839 100644
--- a/fs/hpfs/inode.c
+++ b/fs/hpfs/inode.c
@@ -265,6 +265,7 @@ int hpfs_notify_change(struct dentry *dentry, struct iattr *attr)
 	struct inode *inode = dentry->d_inode;
 	int error=0;
 	lock_kernel();
+	generic_attrkill(inode->i_mode, attr);
 	if ( ((attr->ia_valid & ATTR_SIZE) && attr->ia_size > inode->i_size) ||
 	     (hpfs_sb(inode->i_sb)->sb_root == inode->i_ino) ) {
 		error = -EINVAL;
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index b35a298..fde0875 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -452,10 +452,13 @@ static int hugetlbfs_setattr(struct dentry *dentry, struct iattr *attr)
 {
 	struct inode *inode = dentry->d_inode;
 	int error;
-	unsigned int ia_valid = attr->ia_valid;
+	unsigned int ia_valid;
 
 	BUG_ON(!inode);
 
+	generic_attrkill(inode->i_mode, attr);
+	ia_valid = attr->ia_valid;
+
 	error = inode_change_ok(inode, attr);
 	if (error)
 		goto out;
diff --git a/fs/jffs2/fs.c b/fs/jffs2/fs.c
index 1d3b7a9..597f903 100644
--- a/fs/jffs2/fs.c
+++ b/fs/jffs2/fs.c
@@ -37,6 +37,7 @@ static int jffs2_do_setattr (struct inode *inode, struct iattr *iattr)
 	uint32_t alloclen;
 	int ret;
 	D1(printk(KERN_DEBUG "jffs2_setattr(): ino #%lu\n", inode->i_ino));
+	generic_attrkill(inode->i_mode, iattr);
 	ret = inode_change_ok(inode, iattr);
 	if (ret)
 		return ret;
diff --git a/fs/jfs/acl.c b/fs/jfs/acl.c
index 4d84bdc..1630ba0 100644
--- a/fs/jfs/acl.c
+++ b/fs/jfs/acl.c
@@ -227,6 +227,8 @@ int jfs_setattr(struct dentry *dentry, struct iattr *iattr)
 	struct inode *inode = dentry->d_inode;
 	int rc;
 
+	generic_attrkill(inode->i_mode, iattr);
+
 	rc = inode_change_ok(inode, iattr);
 	if (rc)
 		return rc;
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 0d9f96e..d48c83d 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -989,6 +989,8 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 	mlog_entry("(0x%p, '%.*s')\n", dentry,
 	           dentry->d_name.len, dentry->d_name.name);
 
+	generic_attrkill(inode->i_mode, attr);
+
 	if (attr->ia_valid & ATTR_MODE)
 		mlog(0, "mode change: %d\n", attr->ia_mode);
 	if (attr->ia_valid & ATTR_UID)
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 614851a..3b0f6c1 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -349,6 +349,9 @@ static int proc_setattr(struct dentry *dentry, struct iattr *attr)
 	int error;
 	struct inode *inode = dentry->d_inode;
 
+	/* FIXME: is this necessary? */
+	generic_attrkill(inode->i_mode, attr);
+
 	if (attr->ia_valid & ATTR_MODE)
 		return -EPERM;
 
diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 1bdb624..1e31ae7 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -239,6 +239,9 @@ static int proc_notify_change(struct dentry *dentry, struct iattr *iattr)
 	struct proc_dir_entry *de = PDE(inode);
 	int error;
 
+	/* FIXME: is this necessary? */
+	generic_attrkill(inode->i_mode, iattr);
+
 	error = inode_change_ok(inode, iattr);
 	if (error)
 		goto out;
diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 680c429..7b50364 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -425,6 +425,9 @@ static int proc_sys_setattr(struct dentry *dentry, struct iattr *attr)
 	struct inode *inode = dentry->d_inode;
 	int error;
 
+	/* FIXME: is this necessary */
+	generic_attrkill(inode->i_mode, attr);
+
 	if (attr->ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID))
 		return -EPERM;
 
diff --git a/fs/ramfs/file-nommu.c b/fs/ramfs/file-nommu.c
index 0989bc2..a3ff4b3 100644
--- a/fs/ramfs/file-nommu.c
+++ b/fs/ramfs/file-nommu.c
@@ -192,9 +192,12 @@ static int ramfs_nommu_resize(struct inode *inode, loff_t newsize, loff_t size)
 static int ramfs_nommu_setattr(struct dentry *dentry, struct iattr *ia)
 {
 	struct inode *inode = dentry->d_inode;
-	unsigned int old_ia_valid = ia->ia_valid;
+	unsigned int old_ia_valid;
 	int ret = 0;
 
+	generic_attrkill(inode->i_mode, ia);
+	old_ia_valid = ia->ia_valid;
+
 	/* POSIX UID/GID verification for setting inode attributes */
 	ret = inode_change_ok(inode, ia);
 	if (ret)
diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index 9525f9f..48db0df 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -3062,7 +3062,11 @@ int reiserfs_setattr(struct dentry *dentry, struct iattr *attr)
 {
 	struct inode *inode = dentry->d_inode;
 	int error;
-	unsigned int ia_valid = attr->ia_valid;
+	unsigned int ia_valid;
+
+	generic_attrkill(inode->i_mode, attr);
+	ia_valid = attr->ia_valid;
+
 	reiserfs_write_lock(inode->i_sb);
 	if (attr->ia_valid & ATTR_SIZE) {
 		/* version 2 items will be caught by the s_maxbytes check
diff --git a/fs/smbfs/inode.c b/fs/smbfs/inode.c
index ed851e6..98c4158 100644
--- a/fs/smbfs/inode.c
+++ b/fs/smbfs/inode.c
@@ -682,6 +682,8 @@ smb_notify_change(struct dentry *dentry, struct iattr *attr)
 	if (error)
 		goto out;
 
+	generic_attrkill(inode->i_mode, attr);
+
 	if ((error = inode_change_ok(inode, attr)) < 0)
 		goto out;
 
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 782c480..e9a6dfb 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -38,7 +38,7 @@ int sysfs_setattr(struct dentry * dentry, struct iattr * iattr)
 	struct inode * inode = dentry->d_inode;
 	struct sysfs_dirent * sd = dentry->d_fsdata;
 	struct iattr * sd_iattr;
-	unsigned int ia_valid = iattr->ia_valid;
+	unsigned int ia_valid;
 	int error;
 
 	if (!sd)
@@ -46,6 +46,9 @@ int sysfs_setattr(struct dentry * dentry, struct iattr * iattr)
 
 	sd_iattr = sd->s_iattr;
 
+	generic_attrkill(inode->i_mode, iattr);
+	ia_valid = iattr->ia_valid;
+
 	error = inode_change_ok(inode, iattr);
 	if (error)
 		return error;
diff --git a/fs/ufs/truncate.c b/fs/ufs/truncate.c
index 311ded3..28cb078 100644
--- a/fs/ufs/truncate.c
+++ b/fs/ufs/truncate.c
@@ -510,9 +510,12 @@ out:
 static int ufs_setattr(struct dentry *dentry, struct iattr *attr)
 {
 	struct inode *inode = dentry->d_inode;
-	unsigned int ia_valid = attr->ia_valid;
+	unsigned int ia_valid;
 	int error;
 
+	generic_attrkill(inode->i_mode, attr);
+	ia_valid = attr->ia_valid;
+
 	error = inode_change_ok(inode, attr);
 	if (error)
 		return error;
diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
index e0e06dd..cfbed9e 100644
--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
@@ -651,12 +651,15 @@ xfs_vn_setattr(
 	struct iattr	*attr)
 {
 	struct inode	*inode = dentry->d_inode;
-	unsigned int	ia_valid = attr->ia_valid;
+	unsigned int	ia_valid;
 	bhv_vnode_t	*vp = vn_from_inode(inode);
 	bhv_vattr_t	vattr = { 0 };
 	int		flags = 0;
 	int		error;
 
+	generic_attrkill(inode->i_mode, attr);
+	ia_valid = attr->ia_valid;
+
 	if (ia_valid & ATTR_UID) {
 		vattr.va_mask |= XFS_AT_UID;
 		vattr.va_uid = attr->ia_uid;
diff --git a/mm/shmem.c b/mm/shmem.c
index 29f8d07..de54808 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -718,6 +718,8 @@ static int shmem_notify_change(struct dentry *dentry, struct iattr *attr)
 	struct page *page = NULL;
 	int error;
 
+	generic_attrkill(inode->i_mode, attr);
+
 	if (S_ISREG(inode->i_mode) && (attr->ia_valid & ATTR_SIZE)) {
 		if (attr->ia_size < inode->i_size) {
 			/*
-- 
1.5.2.2
