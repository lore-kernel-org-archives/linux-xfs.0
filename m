Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E234B80D6
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:04:21 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AA9DF30405F
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:04:21 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id biImQM2HaSqcwG5d (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:04:19 -0800 (PST)
Subject: [PATCH 71/76] xfs: support XFS_XFLAG_REFLINK (and FS_NOCOW_FL) on
	reflink filesystems
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:04:17 -0800
Message-ID: <20151219090417.12713.26824.stgit@birch.djwong.org>
In-Reply-To: <20151219085622.12713.88678.stgit@birch.djwong.org>
References: <20151219085622.12713.88678.stgit@birch.djwong.org>
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
Cc: xfs@oss.sgi.com

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
index 5c66459..913c015 100644
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
index 59964c3..79765e0 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -611,7 +611,8 @@ __xfs_iflock(
 
 STATIC uint
 _xfs_dic2xflags(
-	__uint16_t		di_flags)
+	__uint16_t		di_flags,
+	__uint64_t		di_flags2)
 {
 	uint			flags = 0;
 
@@ -644,6 +645,8 @@ _xfs_dic2xflags(
 			flags |= XFS_XFLAG_NODEFRAG;
 		if (di_flags & XFS_DIFLAG_FILESTREAM)
 			flags |= XFS_XFLAG_FILESTREAM;
+		if (di_flags2 & XFS_DIFLAG2_REFLINK)
+			flags |= XFS_XFLAG_REFLINK;
 	}
 
 	return flags;
@@ -655,7 +658,7 @@ xfs_ip2xflags(
 {
 	xfs_icdinode_t		*dic = &ip->i_d;
 
-	return _xfs_dic2xflags(dic->di_flags) |
+	return _xfs_dic2xflags(dic->di_flags, dic->di_flags2) |
 				(XFS_IFORK_Q(ip) ? XFS_XFLAG_HASATTR : 0);
 }
 
@@ -663,7 +666,8 @@ uint
 xfs_dic2xflags(
 	xfs_dinode_t		*dip)
 {
-	return _xfs_dic2xflags(be16_to_cpu(dip->di_flags)) |
+	return _xfs_dic2xflags(be16_to_cpu(dip->di_flags),
+			       be64_to_cpu(dip->di_flags2)) |
 				(XFS_DFORK_Q(dip) ? XFS_XFLAG_HASATTR : 0);
 }
 
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index cf712641..29dc36c 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -880,6 +880,10 @@ xfs_merge_ioc_xflags(
 		xflags |= XFS_XFLAG_NODUMP;
 	else
 		xflags &= ~XFS_XFLAG_NODUMP;
+	if (flags & FS_NOCOW_FL)
+		xflags &= ~XFS_XFLAG_REFLINK;
+	else
+		xflags |= XFS_XFLAG_REFLINK;
 
 	return xflags;
 }
@@ -1191,6 +1195,10 @@ xfs_ioctl_setattr(
 
 	trace_xfs_ioctl_setattr(ip);
 
+	code = xfs_reflink_check_flag_adjust(ip, &fa->fsx_xflags);
+	if (code)
+		return code;
+
 	code = xfs_ioctl_setattr_check_projid(ip, fa);
 	if (code)
 		return code;
@@ -1313,6 +1321,7 @@ xfs_ioc_getxflags(
 	unsigned int		flags;
 
 	flags = xfs_di2lxflags(ip->i_d.di_flags);
+	xfs_reflink_get_lxflags(ip, &flags);
 	if (copy_to_user(arg, &flags, sizeof(flags)))
 		return -EFAULT;
 	return 0;
@@ -1334,11 +1343,15 @@ xfs_ioc_setxflags(
 
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
index 04daa7c..299a957 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1649,3 +1649,54 @@ out_unlock:
 	trace_xfs_reflink_truncate_error(ip, error, _RET_IP_);
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
index b6d7ce6..15aa6b0 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -49,4 +49,8 @@ extern int xfs_reflink_unshare(struct xfs_inode *ip, struct file *filp,
 extern int xfs_reflink_truncate(struct xfs_inode *ip, struct file *filp,
 		xfs_off_t newsize);
 
+extern void xfs_reflink_get_lxflags(struct xfs_inode *ip, unsigned int *flags);
+extern int xfs_reflink_check_flag_adjust(struct xfs_inode *ip,
+		unsigned int *xflags);
+
 #endif /* __XFS_REFLINK_H */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
