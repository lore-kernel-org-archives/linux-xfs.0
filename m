Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Jul 2008 04:51:07 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6LBp4tI023206
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 04:51:05 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 28792190F946
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 04:52:13 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id AHu878E1aMsDZoEF for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 04:52:13 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] XFS: Kill xfs_vtoi()
Date: Mon, 21 Jul 2008 21:52:10 +1000
Message-Id: <1216641130-22725-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Dave Chinner <david@fromorbit.com>

xfs_vtoi() is redundant and only unsed in small sections
of code. Replace them with widely used XFS_I() inline and
kill xfs_vtoi().

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_aops.c  |    3 +--
 fs/xfs/linux-2.6/xfs_vnode.h |    4 ++--
 fs/xfs/xfs_acl.c             |   16 ++++++++--------
 fs/xfs/xfs_inode.h           |    5 -----
 4 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index 0b211cb..2ebbc7c 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -73,7 +73,6 @@ xfs_page_trace(
 	unsigned long	pgoff)
 {
 	xfs_inode_t	*ip;
-	bhv_vnode_t	*vp = vn_from_inode(inode);
 	loff_t		isize = i_size_read(inode);
 	loff_t		offset = page_offset(page);
 	int		delalloc = -1, unmapped = -1, unwritten = -1;
@@ -81,7 +80,7 @@ xfs_page_trace(
 	if (page_has_buffers(page))
 		xfs_count_page_state(page, &delalloc, &unmapped, &unwritten);
 
-	ip = xfs_vtoi(vp);
+	ip = XFS_I(inode);
 	if (!ip->i_rwtrace)
 		return;
 
diff --git a/fs/xfs/linux-2.6/xfs_vnode.h b/fs/xfs/linux-2.6/xfs_vnode.h
index 96e4a7b..953100a 100644
--- a/fs/xfs/linux-2.6/xfs_vnode.h
+++ b/fs/xfs/linux-2.6/xfs_vnode.h
@@ -90,9 +90,9 @@ extern bhv_vnode_t	*vn_hold(bhv_vnode_t *);
 #if defined(XFS_INODE_TRACE)
 #define VN_HOLD(vp)		\
 	((void)vn_hold(vp),	\
-	  xfs_itrace_hold(xfs_vtoi(vp), __FILE__, __LINE__, (inst_t *)__return_address))
+	  xfs_itrace_hold(XFS_I(vp), __FILE__, __LINE__, (inst_t *)__return_address))
 #define VN_RELE(vp)		\
-	  (xfs_itrace_rele(xfs_vtoi(vp), __FILE__, __LINE__, (inst_t *)__return_address), \
+	  (xfs_itrace_rele(XFS_I(vp), __FILE__, __LINE__, (inst_t *)__return_address), \
 	   iput(vn_to_inode(vp)))
 #else
 #define VN_HOLD(vp)		((void)vn_hold(vp))
diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 3e4648a..fdeca54 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -239,7 +239,7 @@ xfs_acl_vget(
 			goto out;
 		}
 		if (kind == _ACL_TYPE_ACCESS)
-			xfs_acl_sync_mode(xfs_vtoi(vp)->i_d.di_mode, xfs_acl);
+			xfs_acl_sync_mode(XFS_I(vp)->i_d.di_mode, xfs_acl);
 		error = -posix_acl_xfs_to_xattr(xfs_acl, ext_acl, size);
 	}
 out:
@@ -259,7 +259,7 @@ xfs_acl_vremove(
 	VN_HOLD(vp);
 	error = xfs_acl_allow_set(vp, kind);
 	if (!error) {
-		error = xfs_attr_remove(xfs_vtoi(vp),
+		error = xfs_attr_remove(XFS_I(vp),
 						kind == _ACL_TYPE_DEFAULT?
 						SGI_ACL_DEFAULT: SGI_ACL_FILE,
 						ATTR_ROOT);
@@ -372,7 +372,7 @@ xfs_acl_allow_set(
 		return ENOTDIR;
 	if (vp->i_sb->s_flags & MS_RDONLY)
 		return EROFS;
-	if (xfs_vtoi(vp)->i_d.di_uid != current->fsuid && !capable(CAP_FOWNER))
+	if (XFS_I(vp)->i_d.di_uid != current->fsuid && !capable(CAP_FOWNER))
 		return EPERM;
 	return 0;
 }
@@ -576,7 +576,7 @@ xfs_acl_get_attr(
 
 	ASSERT((flags & ATTR_KERNOVAL) ? (aclp == NULL) : 1);
 	flags |= ATTR_ROOT;
-	*error = xfs_attr_get(xfs_vtoi(vp),
+	*error = xfs_attr_get(XFS_I(vp),
 					kind == _ACL_TYPE_ACCESS ?
 					SGI_ACL_FILE : SGI_ACL_DEFAULT,
 					(char *)aclp, &len, flags);
@@ -615,7 +615,7 @@ xfs_acl_set_attr(
 		INT_SET(newace->ae_perm, ARCH_CONVERT, ace->ae_perm);
 	}
 	INT_SET(newacl->acl_cnt, ARCH_CONVERT, aclp->acl_cnt);
-	*error = xfs_attr_set(xfs_vtoi(vp),
+	*error = xfs_attr_set(XFS_I(vp),
 				kind == _ACL_TYPE_ACCESS ?
 				SGI_ACL_FILE: SGI_ACL_DEFAULT,
 				(char *)newacl, len, ATTR_ROOT);
@@ -639,7 +639,7 @@ xfs_acl_vtoacl(
 		if (error)
 			access_acl->acl_cnt = XFS_ACL_NOT_PRESENT;
 		else /* We have a good ACL and the file mode, synchronize. */
-			xfs_acl_sync_mode(xfs_vtoi(vp)->i_d.di_mode, access_acl);
+			xfs_acl_sync_mode(XFS_I(vp)->i_d.di_mode, access_acl);
 	}
 
 	if (default_acl) {
@@ -734,7 +734,7 @@ xfs_acl_setmode(
 	 * mode.  The m:: bits take precedence over the g:: bits.
 	 */
 	iattr.ia_valid = ATTR_MODE;
-	iattr.ia_mode = xfs_vtoi(vp)->i_d.di_mode;
+	iattr.ia_mode = XFS_I(vp)->i_d.di_mode;
 	iattr.ia_mode &= ~(S_IRWXU|S_IRWXG|S_IRWXO);
 	ap = acl->acl_entry;
 	for (i = 0; i < acl->acl_cnt; ++i) {
@@ -764,7 +764,7 @@ xfs_acl_setmode(
 	if (gap && nomask)
 		iattr.ia_mode |= gap->ae_perm << 3;
 
-	return xfs_setattr(xfs_vtoi(vp), &iattr, 0, sys_cred);
+	return xfs_setattr(XFS_I(vp), &iattr, 0, sys_cred);
 }
 
 /*
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index ebaea3b..87efb75 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -261,11 +261,6 @@ static inline struct xfs_inode *XFS_I(struct inode *inode)
 	return (struct xfs_inode *)inode->i_private;
 }
 
-static inline struct xfs_inode *xfs_vtoi(bhv_vnode_t *vp)
-{
-	return XFS_I((struct inode *)vp);
-}
-
 /* convert from xfs inode to vfs inode */
 static inline struct inode *VFS_I(struct xfs_inode *ip)
 {
-- 
1.5.6
