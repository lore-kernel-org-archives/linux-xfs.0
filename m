Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 May 2007 07:55:38 -0700 (PDT)
Received: from mail.suse.cz (styx.suse.cz [82.119.242.94])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4UEtSWt018588
	for <xfs@oss.sgi.com>; Wed, 30 May 2007 07:55:30 -0700
Message-Id: <20070530143043.611931865@suse.cz>
References: <20070530125954.706423971@suse.cz>
Date: Wed, 30 May 2007 14:59:56 +0200
From: Michal Marek <mmarek@suse.cz>
Subject: [patch 2/3] Fix XFS_IOC_*_TO_HANDLE and XFS_IOC_{OPEN,READLINK}_BY_HANDLE in compat mode
Content-Disposition: inline; filename=xfs-compat-ioctl-fshandle.patch
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: linux-kernel@vger.kernel.org

32bit struct xfs_fsop_handlereq has different size and offsets (due to
pointers). TODO: case XFS_IOC_{FSSETDM,ATTRLIST,ATTRMULTI}_BY_HANDLE
still not handled.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 fs/xfs/linux-2.6/xfs_ioctl32.c |   63 +++++++++++++++++++++++++++++++++++++----
 1 file changed, 58 insertions(+), 5 deletions(-)

--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_ioctl32.c
+++ linux-2.6/fs/xfs/linux-2.6/xfs_ioctl32.c
@@ -139,6 +139,44 @@ xfs_ioctl32_bulkstat(
 }
 #endif
 
+typedef struct xfs_fsop_handlereq32 {
+	__u32		fd;		/* fd for FD_TO_HANDLE		*/
+	compat_uptr_t	path;		/* user pathname		*/
+	__u32		oflags;		/* open flags			*/
+	compat_uptr_t	ihandle;	/* user supplied handle		*/
+	__u32		ihandlen;	/* user supplied length		*/
+	compat_uptr_t	ohandle;	/* user buffer for handle	*/
+	compat_uptr_t	ohandlen;	/* user buffer length		*/
+} xfs_fsop_handlereq32_t;
+#define XFS_IOC_PATH_TO_FSHANDLE_32 _IOWR('X', 104, struct xfs_fsop_handlereq32)
+#define XFS_IOC_PATH_TO_HANDLE_32   _IOWR('X', 105, struct xfs_fsop_handlereq32)
+#define XFS_IOC_FD_TO_HANDLE_32	    _IOWR('X', 106, struct xfs_fsop_handlereq32)
+#define XFS_IOC_OPEN_BY_HANDLE_32   _IOWR('X', 107, struct xfs_fsop_handlereq32)
+#define XFS_IOC_READLINK_BY_HANDLE_32 _IOWR('X', 108, struct xfs_fsop_handlereq32)
+
+STATIC unsigned long xfs_ioctl32_fshandle(unsigned long arg)
+{
+	xfs_fsop_handlereq32_t __user *p32 = (void __user *)arg;
+	xfs_fsop_handlereq_t __user *p = compat_alloc_user_space(sizeof(*p));
+	u32 addr;
+
+	if (copy_in_user(&p->fd, &p32->fd, sizeof(__u32)) ||
+	    get_user(addr, &p32->path) ||
+	    put_user(compat_ptr(addr), &p->path) ||
+	    copy_in_user(&p->oflags, &p32->oflags, sizeof(__u32)) ||
+	    get_user(addr, &p32->ihandle) ||
+	    put_user(compat_ptr(addr), &p->ihandle) ||
+	    copy_in_user(&p->ihandlen, &p32->ihandlen, sizeof(__u32)) ||
+	    get_user(addr, &p32->ohandle) ||
+	    put_user(compat_ptr(addr), &p->ohandle) ||
+	    get_user(addr, &p32->ohandlen) ||
+	    put_user(compat_ptr(addr), &p->ohandlen))
+		return -EFAULT;
+
+	return (unsigned long)p;
+}
+
+
 STATIC long
 xfs_compat_ioctl(
 	int		mode,
@@ -164,12 +202,7 @@ xfs_compat_ioctl(
 	case XFS_IOC_GETBMAPA:
 	case XFS_IOC_GETBMAPX:
 /* not handled
-	case XFS_IOC_FD_TO_HANDLE:
-	case XFS_IOC_PATH_TO_HANDLE:
-	case XFS_IOC_PATH_TO_FSHANDLE:
-	case XFS_IOC_OPEN_BY_HANDLE:
 	case XFS_IOC_FSSETDM_BY_HANDLE:
-	case XFS_IOC_READLINK_BY_HANDLE:
 	case XFS_IOC_ATTRLIST_BY_HANDLE:
 	case XFS_IOC_ATTRMULTI_BY_HANDLE:
 */
@@ -226,6 +259,26 @@ xfs_compat_ioctl(
 		arg = xfs_ioctl32_bulkstat(arg);
 		break;
 #endif
+	case XFS_IOC_FD_TO_HANDLE_32:
+		arg = xfs_ioctl32_fshandle(arg);
+		cmd = XFS_IOC_FD_TO_HANDLE;
+		break;
+	case XFS_IOC_PATH_TO_HANDLE_32:
+		arg = xfs_ioctl32_fshandle(arg);
+		cmd = XFS_IOC_PATH_TO_HANDLE;
+		break;
+	case XFS_IOC_PATH_TO_FSHANDLE_32:
+		arg = xfs_ioctl32_fshandle(arg);
+		cmd = XFS_IOC_PATH_TO_FSHANDLE;
+		break;
+	case XFS_IOC_OPEN_BY_HANDLE_32:
+		arg = xfs_ioctl32_fshandle(arg);
+		cmd = XFS_IOC_OPEN_BY_HANDLE;
+		break;
+	case XFS_IOC_READLINK_BY_HANDLE_32:
+		arg = xfs_ioctl32_fshandle(arg);
+		cmd = XFS_IOC_READLINK_BY_HANDLE;
+		break;
 	default:
 		return -ENOIOCTLCMD;
 	}

-- 
