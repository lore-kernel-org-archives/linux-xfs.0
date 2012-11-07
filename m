Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA7HHQIc163795 for <xfs@oss.sgi.com>; Wed, 7 Nov 2012 11:17:26 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id doGPCaON0cDAgj6W for
	<xfs@oss.sgi.com>; Wed, 07 Nov 2012 09:19:23 -0800 (PST)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id qA7HJM12007415
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 7 Nov 2012 12:19:23 -0500
Received: from bfoster.bfoster (dhcp-191-48.bos.redhat.com [10.16.191.48])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id qA7HJM8s013193
	for <xfs@oss.sgi.com>; Wed, 7 Nov 2012 12:19:22 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v7 06/10] xfs: add XFS_IOC_FREE_EOFBLOCKS ioctl
Date: Wed,  7 Nov 2012 12:21:12 -0500
Message-Id: <1352308874-64562-1-git-send-email-bfoster@redhat.com>
In-Reply-To: <1352213447-59791-1-git-send-email-bfoster@redhat.com>
References: <1352213447-59791-1-git-send-email-bfoster@redhat.com>
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
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---

v7:
- Added parens around the if flags check in xfs_icache_free_eofblocks().

 fs/xfs/xfs_fs.h     |   17 +++++++++++++++++
 fs/xfs/xfs_icache.c |   10 +++++++---
 fs/xfs/xfs_icache.h |    2 +-
 fs/xfs/xfs_ioctl.c  |   20 ++++++++++++++++++++
 4 files changed, 45 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
index c13fed8..26ff43a 100644
--- a/fs/xfs/xfs_fs.h
+++ b/fs/xfs/xfs_fs.h
@@ -339,6 +339,22 @@ typedef struct xfs_error_injection {
 
 
 /*
+ * Speculative preallocation trimming.
+ */
+#define XFS_EOFBLOCKS_VERSION		1
+struct xfs_eofblocks {
+	__u32		eof_version;
+	__u32		eof_flags;
+	__u64		pad[15];
+};
+
+/* eof_flags values */
+#define XFS_EOF_FLAGS_SYNC		(1 << 0) /* sync/wait mode scan */
+#define XFS_EOF_FLAGS_VALID	\
+	(XFS_EOF_FLAGS_SYNC)
+
+
+/*
  * The user-level Handle Request interface structure.
  */
 typedef struct xfs_fsop_handlereq {
@@ -456,6 +472,7 @@ typedef struct xfs_handle {
 /*	XFS_IOC_GETBIOSIZE ---- deprecated 47	   */
 #define XFS_IOC_GETBMAPX	_IOWR('X', 56, struct getbmap)
 #define XFS_IOC_ZERO_RANGE	_IOW ('X', 57, struct xfs_flock64)
+#define XFS_IOC_FREE_EOFBLOCKS	_IOR ('X', 58, struct xfs_eofblocks)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index b02a3df..b79aebe 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1206,11 +1206,15 @@ xfs_inode_free_eofblocks(
 int
 xfs_icache_free_eofblocks(
 	struct xfs_mount	*mp,
-	int			flags)
+	struct xfs_eofblocks	*eofb)
 {
-	ASSERT((flags & ~(SYNC_TRYLOCK|SYNC_WAIT)) == 0);
+	int flags = SYNC_TRYLOCK;
+
+	if (eofb && (eofb->eof_flags & XFS_EOF_FLAGS_SYNC))
+		flags = SYNC_WAIT;
+
 	return xfs_inode_ag_iterator_tag(mp, xfs_inode_free_eofblocks, flags,
-					 NULL, XFS_ICI_EOFBLOCKS_TAG);
+					 eofb, XFS_ICI_EOFBLOCKS_TAG);
 }
 
 void
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index abca9fb..23e9bf3 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -37,7 +37,7 @@ void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
 
 void xfs_inode_set_eofblocks_tag(struct xfs_inode *ip);
 void xfs_inode_clear_eofblocks_tag(struct xfs_inode *ip);
-int xfs_icache_free_eofblocks(struct xfs_mount *, int);
+int xfs_icache_free_eofblocks(struct xfs_mount *, struct xfs_eofblocks *);
 
 int xfs_sync_inode_grab(struct xfs_inode *ip);
 int xfs_inode_ag_iterator(struct xfs_mount *mp,
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index c1df3c6..5b20ab0 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -42,6 +42,7 @@
 #include "xfs_inode_item.h"
 #include "xfs_export.h"
 #include "xfs_trace.h"
+#include "xfs_icache.h"
 
 #include <linux/capability.h>
 #include <linux/dcache.h>
@@ -1602,6 +1603,25 @@ xfs_file_ioctl(
 		error = xfs_errortag_clearall(mp, 1);
 		return -error;
 
+	case XFS_IOC_FREE_EOFBLOCKS: {
+		struct xfs_eofblocks eofb;
+
+		if (copy_from_user(&eofb, arg, sizeof(eofb)))
+			return -XFS_ERROR(EFAULT);
+
+		if (eofb.eof_version != XFS_EOFBLOCKS_VERSION)
+			return -XFS_ERROR(EINVAL);
+
+		if (eofb.eof_flags & ~XFS_EOF_FLAGS_VALID)
+			return -XFS_ERROR(EINVAL);
+
+		if (memchr_inv(eofb.pad, 0, sizeof(eofb.pad)))
+			return -XFS_ERROR(EINVAL);
+
+		error = xfs_icache_free_eofblocks(mp, &eofb);
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
