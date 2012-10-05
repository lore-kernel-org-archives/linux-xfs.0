Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q95EEBBF053239 for <xfs@oss.sgi.com>; Fri, 5 Oct 2012 09:14:11 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 6vfzRw3CDT0HsjJL for
	<xfs@oss.sgi.com>; Fri, 05 Oct 2012 07:15:37 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q95EFbIS011981
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 5 Oct 2012 10:15:37 -0400
Received: from bfoster.bfoster (dhcp-191-48.bos.redhat.com [10.16.191.48])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q95EFauR008181
	for <xfs@oss.sgi.com>; Fri, 5 Oct 2012 10:15:37 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v5 06/10] xfs: add XFS_IOC_FREE_EOFBLOCKS ioctl
Date: Fri,  5 Oct 2012 10:17:12 -0400
Message-Id: <1349446636-8611-7-git-send-email-bfoster@redhat.com>
In-Reply-To: <1349446636-8611-1-git-send-email-bfoster@redhat.com>
References: <1349446636-8611-1-git-send-email-bfoster@redhat.com>
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

The XFS_IOC_FREE_EOFBLOCKS ioctl allows users to invoke an EOFBLOCKS
scan. The xfs_eofblocks structure is defined to support the command
parameters (scan mode).

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_fs.h     |   15 +++++++++++++++
 fs/xfs/xfs_icache.c |    5 +++--
 fs/xfs/xfs_icache.h |    2 +-
 fs/xfs/xfs_ioctl.c  |   16 ++++++++++++++++
 4 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
index c13fed8..5f48b3e 100644
--- a/fs/xfs/xfs_fs.h
+++ b/fs/xfs/xfs_fs.h
@@ -339,6 +339,20 @@ typedef struct xfs_error_injection {
 
 
 /*
+ * Speculative preallocation trimming.
+ */
+#define XFS_EOFBLOCKS_VERSION		1
+struct xfs_eofblocks {
+	__u32		eof_version;
+	__u32		eof_flags;
+	unsigned char	pad[12];
+};
+
+/* eof_flags values */
+#define XFS_EOF_FLAGS_SYNC		0x01	/* sync/wait mode scan */
+
+
+/*
  * The user-level Handle Request interface structure.
  */
 typedef struct xfs_fsop_handlereq {
@@ -456,6 +470,7 @@ typedef struct xfs_handle {
 /*	XFS_IOC_GETBIOSIZE ---- deprecated 47	   */
 #define XFS_IOC_GETBMAPX	_IOWR('X', 56, struct getbmap)
 #define XFS_IOC_ZERO_RANGE	_IOW ('X', 57, struct xfs_flock64)
+#define XFS_IOC_FREE_EOFBLOCKS	_IOR ('X', 58, struct xfs_eofblocks)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index b02a3df..35efdda 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1206,11 +1206,12 @@ xfs_inode_free_eofblocks(
 int
 xfs_icache_free_eofblocks(
 	struct xfs_mount	*mp,
-	int			flags)
+	int			flags,
+	struct xfs_eofblocks	*eofb)
 {
 	ASSERT((flags & ~(SYNC_TRYLOCK|SYNC_WAIT)) == 0);
 	return xfs_inode_ag_iterator_tag(mp, xfs_inode_free_eofblocks, flags,
-					 NULL, XFS_ICI_EOFBLOCKS_TAG);
+					 eofb, XFS_ICI_EOFBLOCKS_TAG);
 }
 
 void
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index abca9fb..b46716c 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -37,7 +37,7 @@ void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
 
 void xfs_inode_set_eofblocks_tag(struct xfs_inode *ip);
 void xfs_inode_clear_eofblocks_tag(struct xfs_inode *ip);
-int xfs_icache_free_eofblocks(struct xfs_mount *, int);
+int xfs_icache_free_eofblocks(struct xfs_mount *, int, struct xfs_eofblocks *);
 
 int xfs_sync_inode_grab(struct xfs_inode *ip);
 int xfs_inode_ag_iterator(struct xfs_mount *mp,
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 0e0232c..ad4352f 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -42,6 +42,7 @@
 #include "xfs_inode_item.h"
 #include "xfs_export.h"
 #include "xfs_trace.h"
+#include "xfs_icache.h"
 
 #include <linux/capability.h>
 #include <linux/dcache.h>
@@ -1602,6 +1603,21 @@ xfs_file_ioctl(
 		error = xfs_errortag_clearall(mp, 1);
 		return -error;
 
+	case XFS_IOC_FREE_EOFBLOCKS: {
+		struct xfs_eofblocks eofb;
+		int flags;
+
+		if (copy_from_user(&eofb, arg, sizeof(eofb)))
+			return -XFS_ERROR(EFAULT);
+
+		if (eofb.eof_version != XFS_EOFBLOCKS_VERSION)
+			return -XFS_ERROR(EINVAL);
+
+		flags = (eofb.eof_flags & XFS_EOF_FLAGS_SYNC) ? SYNC_WAIT : SYNC_TRYLOCK;
+		error = xfs_icache_free_eofblocks(mp, flags, &eofb);
+		return -error;
+	}
+
 	default:
 		return -ENOTTY;
 	}
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
