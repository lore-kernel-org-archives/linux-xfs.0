Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAQ3KVgJ000835 for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 21:20:31 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 39B4815FCD6A
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 19:20:29 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id CnUzr6RpJQtCMSy4 for <xfs@oss.sgi.com>;
	Tue, 25 Nov 2008 19:20:29 -0800 (PST)
Message-Id: <20081126032029.090219414@sandeen.net>
References: <20081126032005.639750968@sandeen.net>
Date: Tue, 25 Nov 2008 21:20:15 -0600
From: sandeen@sandeen.net
Subject: [patch 10/12] Hook up compat XFS_IOC_ATTRMULTI_BY_HANDLE ioctl handler
Content-Disposition: inline; filename=compat_ioctl_attrmulti
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

Add a compat handler for XFS_IOC_ATTRMULTI_BY_HANDLE

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
--

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl32.c	2008-11-24 17:00:31.318000883 -0600
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.c	2008-11-24 17:09:25.537064541 -0600
@@ -477,6 +477,93 @@ xfs_compat_attrlist_by_handle(
 	return -error;
 }
 
+STATIC int
+xfs_compat_attrmulti_by_handle(
+	xfs_mount_t				*mp,
+	void					__user *arg,
+	struct inode				*parinode)
+{
+	int					error;
+	compat_xfs_attr_multiop_t		*ops;
+	compat_xfs_fsop_attrmulti_handlereq_t	am_hreq;
+	struct inode				*inode;
+	unsigned int				i, size;
+	char					*attr_name;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -XFS_ERROR(EPERM);
+	if (copy_from_user(&am_hreq, arg,
+			   sizeof(compat_xfs_fsop_attrmulti_handlereq_t)))
+		return -XFS_ERROR(EFAULT);
+
+	error = xfs_vget_fsop_handlereq_compat(mp, parinode, &am_hreq.hreq,
+					       &inode);
+	if (error)
+		goto out;
+
+	error = E2BIG;
+	size = am_hreq.opcount * sizeof(compat_xfs_attr_multiop_t);
+	if (!size || size > 16 * PAGE_SIZE)
+		goto out_vn_rele;
+
+	error = ENOMEM;
+	ops = kmalloc(size, GFP_KERNEL);
+	if (!ops)
+		goto out_vn_rele;
+
+	error = EFAULT;
+	if (copy_from_user(ops, compat_ptr(am_hreq.ops), size))
+		goto out_kfree_ops;
+
+	attr_name = kmalloc(MAXNAMELEN, GFP_KERNEL);
+	if (!attr_name)
+		goto out_kfree_ops;
+
+
+	error = 0;
+	for (i = 0; i < am_hreq.opcount; i++) {
+		ops[i].am_error = strncpy_from_user(attr_name,
+				compat_ptr(ops[i].am_attrname),
+				MAXNAMELEN);
+		if (ops[i].am_error == 0 || ops[i].am_error == MAXNAMELEN)
+			error = -ERANGE;
+		if (ops[i].am_error < 0)
+			break;
+
+		switch (ops[i].am_opcode) {
+		case ATTR_OP_GET:
+			ops[i].am_error = xfs_attrmulti_attr_get(inode,
+					attr_name,
+					compat_ptr(ops[i].am_attrvalue),
+					&ops[i].am_length, ops[i].am_flags);
+			break;
+		case ATTR_OP_SET:
+			ops[i].am_error = xfs_attrmulti_attr_set(inode,
+					attr_name,
+					compat_ptr(ops[i].am_attrvalue),
+					ops[i].am_length, ops[i].am_flags);
+			break;
+		case ATTR_OP_REMOVE:
+			ops[i].am_error = xfs_attrmulti_attr_remove(inode,
+					attr_name, ops[i].am_flags);
+			break;
+		default:
+			ops[i].am_error = EINVAL;
+		}
+	}
+
+	if (copy_to_user(compat_ptr(am_hreq.ops), ops, size))
+		error = XFS_ERROR(EFAULT);
+
+	kfree(attr_name);
+ out_kfree_ops:
+	kfree(ops);
+ out_vn_rele:
+	iput(inode);
+ out:
+	return -error;
+}
+
 STATIC long
 xfs_compat_ioctl(
 	xfs_inode_t	*ip,
@@ -500,10 +587,7 @@ xfs_compat_ioctl(
 	case XFS_IOC_GETBMAP:
 	case XFS_IOC_GETBMAPA:
 	case XFS_IOC_GETBMAPX:
-/* not handled
-	case XFS_IOC_FSSETDM_BY_HANDLE:
-	case XFS_IOC_ATTRMULTI_BY_HANDLE:
-*/
+/*	case XFS_IOC_FSSETDM_BY_HANDLE: not handled */
 	case XFS_IOC_FSCOUNTS:
 	case XFS_IOC_SET_RESBLKS:
 	case XFS_IOC_GET_RESBLKS:
@@ -611,6 +695,8 @@ xfs_compat_ioctl(
 	}
 	case XFS_IOC_ATTRLIST_BY_HANDLE_32:
 		return xfs_compat_attrlist_by_handle(mp, arg, inode);
+	case XFS_IOC_ATTRMULTI_BY_HANDLE_32:
+		return xfs_compat_attrmulti_by_handle(mp, arg, inode);
 	default:
 		return -XFS_ERROR(ENOIOCTLCMD);
 	}
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl32.h	2008-11-24 17:00:31.316000972 -0600
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.h	2008-11-24 17:09:25.537064541 -0600
@@ -135,6 +135,26 @@ typedef struct compat_xfs_fsop_attrlist_
 #define XFS_IOC_ATTRLIST_BY_HANDLE_32 \
 	_IOW('X', 122, struct compat_xfs_fsop_attrlist_handlereq)
 
+/* am_opcodes defined in xfs_fs.h */
+typedef struct compat_xfs_attr_multiop {
+	__u32		am_opcode;
+	__s32		am_error;
+	compat_uptr_t	am_attrname;
+	compat_uptr_t	am_attrvalue;
+	__u32		am_length;
+	__u32		am_flags;
+} compat_xfs_attr_multiop_t;
+
+typedef struct compat_xfs_fsop_attrmulti_handlereq {
+	struct compat_xfs_fsop_handlereq hreq; /* handle interface structure */
+	__u32				opcount;/* count of following multiop */
+	/* ptr to compat_xfs_attr_multiop */
+	compat_uptr_t			ops; /* attr_multi data */
+} compat_xfs_fsop_attrmulti_handlereq_t;
+
+#define XFS_IOC_ATTRMULTI_BY_HANDLE_32 \
+	_IOW('X', 123, struct compat_xfs_fsop_attrmulti_handlereq)
+
 #ifdef BROKEN_X86_ALIGNMENT
 /* on ia32 l_start is on a 32-bit boundary */
 typedef struct compat_xfs_flock64 {
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2008-11-24 17:00:05.410001335 -0600
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c	2008-11-24 17:00:31.892147627 -0600
@@ -491,7 +491,7 @@ xfs_attrlist_by_handle(
 	return -error;
 }
 
-STATIC int
+int
 xfs_attrmulti_attr_get(
 	struct inode		*inode,
 	char			*name,
@@ -520,7 +520,7 @@ xfs_attrmulti_attr_get(
 	return error;
 }
 
-STATIC int
+int
 xfs_attrmulti_attr_set(
 	struct inode		*inode,
 	char			*name,
@@ -550,7 +550,7 @@ xfs_attrmulti_attr_set(
 	return error;
 }
 
-STATIC int
+int
 xfs_attrmulti_attr_remove(
 	struct inode		*inode,
 	char			*name,
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl.h	2008-11-24 17:00:05.410001335 -0600
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.h	2008-11-24 17:00:31.909000874 -0600
@@ -44,4 +44,27 @@ xfs_readlink_by_handle(
 	xfs_mount_t		*mp,
 	xfs_fsop_handlereq_t	*hreq,
 	struct inode		*parinode);
+
+extern int
+xfs_attrmulti_attr_get(
+	struct inode		*inode,
+	char			*name,
+	char			__user *ubuf,
+	__uint32_t		*len,
+	__uint32_t		flags);
+
+extern int
+	xfs_attrmulti_attr_set(
+	struct inode		*inode,
+	char			*name,
+	const char		__user *ubuf,
+	__uint32_t		len,
+	__uint32_t		flags);
+
+extern int
+xfs_attrmulti_attr_remove(
+	struct inode		*inode,
+	char			*name,
+	__uint32_t		flags);
+
 #endif

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
