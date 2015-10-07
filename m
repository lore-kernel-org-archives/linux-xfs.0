Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A1F4529E51
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 00:01:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 14AC5AC00A
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 22:01:34 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id MXVyXBBe3QP0Apvb (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2015 22:01:33 -0700 (PDT)
Subject: [PATCH 57/58] xfs: support XFS_XFLAG_REFLINK (and FS_NOCOW_FL) on
	reflink filesystems
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 06 Oct 2015 22:01:25 -0700
Message-ID: <20151007050125.30457.28287.stgit@birch.djwong.org>
In-Reply-To: <20151007045443.30457.47038.stgit@birch.djwong.org>
References: <20151007045443.30457.47038.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

Report the reflink/nocow flags as appropriate in the XFS-specific and
"standard" getattr ioctls.

Allow the user to clear the reflink flag (or set the nocow flag) if the
size is zero.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h |    1 +
 fs/xfs/xfs_inode.c     |   10 +++++++--
 fs/xfs/xfs_ioctl.c     |   15 +++++++++++++-
 fs/xfs/xfs_reflink.c   |   51 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_reflink.h   |    4 ++++
 5 files changed, 77 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index c63afd4..0dcffc8 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -67,6 +67,7 @@ struct fsxattr {
 #define XFS_XFLAG_EXTSZINHERIT	0x00001000	/* inherit inode extent size */
 #define XFS_XFLAG_NODEFRAG	0x00002000  	/* do not defragment */
 #define XFS_XFLAG_FILESTREAM	0x00004000	/* use filestream allocator */
+#define XFS_XFLAG_REFLINK	0x00008000	/* file is reflinked */
 #define XFS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this	*/
 
 /*
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 61a468b..297151a 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -610,7 +610,8 @@ __xfs_iflock(
 
 STATIC uint
 _xfs_dic2xflags(
-	__uint16_t		di_flags)
+	__uint16_t		di_flags,
+	__uint64_t		di_flags2)
 {
 	uint			flags = 0;
 
@@ -643,6 +644,8 @@ _xfs_dic2xflags(
 			flags |= XFS_XFLAG_NODEFRAG;
 		if (di_flags & XFS_DIFLAG_FILESTREAM)
 			flags |= XFS_XFLAG_FILESTREAM;
+		if (di_flags2 & XFS_DIFLAG2_REFLINK)
+			flags |= XFS_XFLAG_REFLINK;
 	}
 
 	return flags;
@@ -654,7 +657,7 @@ xfs_ip2xflags(
 {
 	xfs_icdinode_t		*dic = &ip->i_d;
 
-	return _xfs_dic2xflags(dic->di_flags) |
+	return _xfs_dic2xflags(dic->di_flags, dic->di_flags2) |
 				(XFS_IFORK_Q(ip) ? XFS_XFLAG_HASATTR : 0);
 }
 
@@ -662,7 +665,8 @@ uint
 xfs_dic2xflags(
 	xfs_dinode_t		*dip)
 {
-	return _xfs_dic2xflags(be16_to_cpu(dip->di_flags)) |
+	return _xfs_dic2xflags(be16_to_cpu(dip->di_flags),
+			       be64_to_cpu(dip->di_flags2)) |
 				(XFS_DFORK_Q(dip) ? XFS_XFLAG_HASATTR : 0);
 }
 
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 92aaca0..1dba30b 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -870,6 +870,10 @@ xfs_merge_ioc_xflags(
 		xflags |= XFS_XFLAG_NODUMP;
 	else
 		xflags &= ~XFS_XFLAG_NODUMP;
+	if (flags & FS_NOCOW_FL)
+		xflags &= ~XFS_XFLAG_REFLINK;
+	else
+		xflags |= XFS_XFLAG_REFLINK;
 
 	return xflags;
 }
@@ -1181,6 +1185,10 @@ xfs_ioctl_setattr(
 
 	trace_xfs_ioctl_setattr(ip);
 
+	code = xfs_reflink_check_flag_adjust(ip, &fa->fsx_xflags);
+	if (code)
+		return code;
+
 	code = xfs_ioctl_setattr_check_projid(ip, fa);
 	if (code)
 		return code;
@@ -1303,6 +1311,7 @@ xfs_ioc_getxflags(
 	unsigned int		flags;
 
 	flags = xfs_di2lxflags(ip->i_d.di_flags);
+	xfs_reflink_get_lxflags(ip, &flags);
 	if (copy_to_user(arg, &flags, sizeof(flags)))
 		return -EFAULT;
 	return 0;
@@ -1324,11 +1333,15 @@ xfs_ioc_setxflags(
 
 	if (flags & ~(FS_IMMUTABLE_FL | FS_APPEND_FL | \
 		      FS_NOATIME_FL | FS_NODUMP_FL | \
-		      FS_SYNC_FL))
+		      FS_SYNC_FL | FS_NOCOW_FL))
 		return -EOPNOTSUPP;
 
 	fa.fsx_xflags = xfs_merge_ioc_xflags(flags, xfs_ip2xflags(ip));
 
+	error = xfs_reflink_check_flag_adjust(ip, &fa.fsx_xflags);
+	if (error)
+		return error;
+
 	error = mnt_want_write_file(filp);
 	if (error)
 		return error;
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 92d8345..99635aa 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1892,3 +1892,54 @@ out:
 	trace_xfs_reflink_unshare_error(ip, error, _RET_IP_);
 	return error;
 }
+
+/**
+ * xfs_reflink_get_lxflags() - set reflink-related linux inode flags
+ *
+ * @ip: XFS inode
+ * @flags: Pointer to the user-visible inode flags
+ */
+void
+xfs_reflink_get_lxflags(
+	struct xfs_inode	*ip,		/* XFS inode */
+	unsigned int		*flags)		/* user flags */
+{
+	/*
+	 * If this is a reflink-capable filesystem and there are no shared
+	 * blocks, then this is a "nocow" file.
+	 */
+	if (!xfs_sb_version_hasreflink(&ip->i_mount->m_sb) ||
+	    xfs_is_reflink_inode(ip))
+		return;
+	*flags |= FS_NOCOW_FL;
+}
+
+/**
+ * xfs_reflink_check_flag_adjust() - The only change we allow to the inode
+ *				     reflink flag is to clear it when the
+ *				     fs supports reflink and the size is zero.
+ *
+ * @ip: XFS inode
+ * @xflags: XFS in-core inode flags
+ */
+int
+xfs_reflink_check_flag_adjust(
+	struct xfs_inode	*ip,
+	unsigned int		*xflags)
+{
+	unsigned int		chg;
+
+	chg = !!(*xflags & XFS_XFLAG_REFLINK) ^ !!xfs_is_reflink_inode(ip);
+
+	if (!chg)
+		return 0;
+	if (!xfs_sb_version_hasreflink(&ip->i_mount->m_sb))
+		return -EOPNOTSUPP;
+	if (i_size_read(VFS_I(ip)) != 0)
+		return -EINVAL;
+	if (*xflags & XFS_XFLAG_REFLINK) {
+		*xflags &= ~XFS_XFLAG_REFLINK;
+		return 0;
+	}
+	return 0;
+}
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index 4ce2cba6..4733bf1 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -54,4 +54,8 @@ extern int xfs_reflink(struct xfs_inode *src, xfs_off_t srcoff,
 extern int xfs_reflink_unshare(struct xfs_inode *ip, struct file *filp,
 		xfs_off_t offset, xfs_off_t len);
 
+extern void xfs_reflink_get_lxflags(struct xfs_inode *ip, unsigned int *flags);
+extern int xfs_reflink_check_flag_adjust(struct xfs_inode *ip,
+		unsigned int *xflags);
+
 #endif /* __XFS_REFLINK_H */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
