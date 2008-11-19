Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAJ4nvcL029997 for <xfs@oss.sgi.com>; Tue, 18 Nov 2008 22:49:58 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EDFD3159E767
	for <xfs@oss.sgi.com>; Tue, 18 Nov 2008 20:49:23 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id 0P8uPXQSGkV3WAUo for <xfs@oss.sgi.com>;
	Tue, 18 Nov 2008 20:49:23 -0800 (PST)
Message-Id: <20081119044909.981142660@sandeen.net>
References: <20081119044401.573365619@sandeen.net>
Date: Tue, 18 Nov 2008 22:44:09 -0600
From: sandeen@sandeen.net
Subject: [patch 08/11] Hook up compat XFS_IOC_ATTRLIST_BY_HANDLE ioctl handler
Content-Disposition: inline; filename=compat_ioctl_attrlist
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
Cc: hch@infradead.org

Add a compat handler for XFS_IOC_ATTRLIST_BY_HANDLE

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
--

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl32.h
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.h
@@ -119,6 +119,18 @@ typedef struct compat_xfs_swapext
 
 #define XFS_IOC_SWAPEXT_32	_IOWR('X', 109, struct compat_xfs_swapext)
 
+typedef struct compat_xfs_fsop_attrlist_handlereq {
+	struct compat_xfs_fsop_handlereq hreq; /* handle interface structure */
+	struct xfs_attrlist_cursor	pos; /* opaque cookie, list offset */
+	__u32				flags;	/* which namespace to use */
+	__u32				buflen;	/* length of buffer supplied */
+	compat_uptr_t			buffer;	/* returned names */
+} _PACKED compat_xfs_fsop_attrlist_handlereq_t;
+
+/* Note: actually this is read/write */
+#define XFS_IOC_ATTRLIST_BY_HANDLE_32 \
+	_IOW ('X', 122, struct compat_xfs_fsop_attrlist_handlereq)
+
 #ifdef BROKEN_X86_ALIGNMENT
 /* on ia32 l_start is on a 32-bit boundary */
 typedef struct compat_xfs_flock64 {
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl32.c
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.c
@@ -45,6 +45,7 @@
 #include "xfs_dfrag.h"
 #include "xfs_vnodeops.h"
 #include "xfs_fsops.h"
+#include "xfs_attr.h"
 #include "xfs_ioctl32.h"
 
 #define  _NATIVE_IOC(cmd, type) \
@@ -360,6 +361,138 @@ xfs_ioctl32_fshandle_copyin(unsigned lon
 	return (unsigned long)p;
 }
 
+/*
+ * Convert userspace handle data into inode.
+ *
+ * We use the fact that all the fsop_handlereq ioctl calls have a data
+ * structure argument whose first component is always a xfs_fsop_handlereq_t,
+ * so we can pass that sub structure into this handy, shared routine.
+ *
+ * If no error, caller must always iput the returned inode.
+ */
+STATIC int
+xfs_vget_fsop_handlereq_compat(
+	xfs_mount_t		*mp,
+	struct inode		*parinode,	/* parent inode pointer    */
+	compat_xfs_fsop_handlereq_t	*hreq,
+	struct inode		**inode)
+{
+	void			__user *hanp;
+	size_t			hlen;
+	xfs_fid_t		*xfid;
+	xfs_handle_t		*handlep;
+	xfs_handle_t		handle;
+	xfs_inode_t		*ip;
+	xfs_ino_t		ino;
+	__u32			igen;
+	int			error;
+
+	/*
+	 * Only allow handle opens under a directory.
+	 */
+	if (!S_ISDIR(parinode->i_mode))
+		return XFS_ERROR(ENOTDIR);
+
+	hanp = compat_ptr(hreq->ihandle);
+	hlen = hreq->ihandlen;
+	handlep = &handle;
+
+	if (hlen < sizeof(handlep->ha_fsid) || hlen > sizeof(*handlep))
+		return XFS_ERROR(EINVAL);
+	if (copy_from_user(handlep, hanp, hlen))
+		return XFS_ERROR(EFAULT);
+	if (hlen < sizeof(*handlep))
+		memset(((char *)handlep) + hlen, 0, sizeof(*handlep) - hlen);
+	if (hlen > sizeof(handlep->ha_fsid)) {
+		if (handlep->ha_fid.fid_len !=
+		    (hlen - sizeof(handlep->ha_fsid) -
+		            sizeof(handlep->ha_fid.fid_len)) ||
+		    handlep->ha_fid.fid_pad)
+			return XFS_ERROR(EINVAL);
+	}
+
+	/*
+	 * Crack the handle, obtain the inode # & generation #
+	 */
+	xfid = (struct xfs_fid *)&handlep->ha_fid;
+	if (xfid->fid_len == sizeof(*xfid) - sizeof(xfid->fid_len)) {
+		ino  = xfid->fid_ino;
+		igen = xfid->fid_gen;
+	} else {
+		return XFS_ERROR(EINVAL);
+	}
+
+	/*
+	 * Get the XFS inode, building a Linux inode to go with it.
+	 */
+	error = xfs_iget(mp, NULL, ino, 0, XFS_ILOCK_SHARED, &ip, 0);
+	if (error)
+		return error;
+	if (ip == NULL)
+		return XFS_ERROR(EIO);
+	if (ip->i_d.di_gen != igen) {
+		xfs_iput_new(ip, XFS_ILOCK_SHARED);
+		return XFS_ERROR(ENOENT);
+	}
+
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+
+	*inode = VFS_I(ip);
+	return 0;
+}
+
+STATIC int
+xfs_attrlist_by_handle_compat(
+	void			__user *arg,
+	struct inode		*parinode)
+{
+	int			error;
+	attrlist_cursor_kern_t	*cursor;
+	compat_xfs_fsop_attrlist_handlereq_t al_hreq;
+	struct inode		*inode;
+	char			*kbuf;
+	xfs_mount_t		*mp = XFS_I(parinode)->i_mount;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -XFS_ERROR(EPERM);
+	if (copy_from_user(&al_hreq, arg,
+			   sizeof(compat_xfs_fsop_attrlist_handlereq_t)))
+		return -XFS_ERROR(EFAULT);
+	if (al_hreq.buflen > XATTR_LIST_MAX)
+		return -XFS_ERROR(EINVAL);
+
+	/*
+	 * Reject flags, only allow namespaces.
+	 */
+	if (al_hreq.flags & ~(ATTR_ROOT | ATTR_SECURE))
+		return -XFS_ERROR(EINVAL);
+
+	error = xfs_vget_fsop_handlereq_compat(mp, parinode, &al_hreq.hreq,
+					       &inode);
+	if (error)
+		goto out;
+
+	kbuf = kmalloc(al_hreq.buflen, GFP_KERNEL);
+	if (!kbuf)
+		goto out_vn_rele;
+
+	cursor = (attrlist_cursor_kern_t *)&al_hreq.pos;
+	error = xfs_attr_list(XFS_I(inode), kbuf, al_hreq.buflen,
+					al_hreq.flags, cursor);
+	if (error)
+		goto out_kfree;
+
+	if (copy_to_user(compat_ptr(al_hreq.buffer), kbuf, al_hreq.buflen))
+		error = -EFAULT;
+
+ out_kfree:
+	kfree(kbuf);
+ out_vn_rele:
+	iput(inode);
+ out:
+	return -error;
+}
+
 STATIC long
 xfs_compat_ioctl(
 	int		mode,
@@ -382,7 +515,6 @@ xfs_compat_ioctl(
 	case XFS_IOC_GETBMAPX:
 /* not handled
 	case XFS_IOC_FSSETDM_BY_HANDLE:
-	case XFS_IOC_ATTRLIST_BY_HANDLE:
 	case XFS_IOC_ATTRMULTI_BY_HANDLE:
 */
 	case XFS_IOC_FSCOUNTS:
@@ -456,6 +588,8 @@ xfs_compat_ioctl(
 		arg = xfs_ioctl32_fshandle_copyin(arg);
 		cmd = _NATIVE_IOC(cmd, struct xfs_fsop_handlereq);
 		break;
+	case XFS_IOC_ATTRLIST_BY_HANDLE_32:
+		return xfs_attrlist_by_handle_compat((void __user*)arg, inode);
 	default:
 		return -XFS_ERROR(ENOIOCTLCMD);
 	}

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
