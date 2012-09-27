Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8RHgsuR121764 for <xfs@oss.sgi.com>; Thu, 27 Sep 2012 12:42:54 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id jHWiWEEhoZV5Ntq6 for
	<xfs@oss.sgi.com>; Thu, 27 Sep 2012 10:44:13 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q8RHiD4w022937
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 27 Sep 2012 13:44:13 -0400
Received: from bfoster.bfoster ([10.16.225.83])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q8RHiD15026817
	for <xfs@oss.sgi.com>; Thu, 27 Sep 2012 13:44:13 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v4 6/8] xfs: add XFS_IOC_FREE_EOFBLOCKS ioctl
Date: Thu, 27 Sep 2012 13:45:50 -0400
Message-Id: <1348767952-24229-7-git-send-email-bfoster@redhat.com>
In-Reply-To: <1348767952-24229-1-git-send-email-bfoster@redhat.com>
References: <1348767952-24229-1-git-send-email-bfoster@redhat.com>
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
 fs/xfs/xfs_fs.h    |   14 ++++++++++++++
 fs/xfs/xfs_ioctl.c |   12 ++++++++++++
 2 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
index c13fed8..32bb2e8 100644
--- a/fs/xfs/xfs_fs.h
+++ b/fs/xfs/xfs_fs.h
@@ -339,6 +339,19 @@ typedef struct xfs_error_injection {
 
 
 /*
+ * Speculative preallocation trimming.
+ */
+struct xfs_eofblocks {
+	__u32		eof_flags;
+	__s32		version;
+	unsigned char	pad[12];
+};
+
+/* eof_flags values */
+#define XFS_EOF_FLAGS_FORCE		0x01	/* force/wait mode scan */
+
+
+/*
  * The user-level Handle Request interface structure.
  */
 typedef struct xfs_fsop_handlereq {
@@ -456,6 +469,7 @@ typedef struct xfs_handle {
 /*	XFS_IOC_GETBIOSIZE ---- deprecated 47	   */
 #define XFS_IOC_GETBMAPX	_IOWR('X', 56, struct getbmap)
 #define XFS_IOC_ZERO_RANGE	_IOW ('X', 57, struct xfs_flock64)
+#define XFS_IOC_FREE_EOFBLOCKS	_IOR ('X', 58, struct xfs_eofblocks)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 0e0232c..216ca7a 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1602,6 +1602,18 @@ xfs_file_ioctl(
 		error = xfs_errortag_clearall(mp, 1);
 		return -error;
 
+	case XFS_IOC_FREE_EOFBLOCKS: {
+		struct xfs_eofblocks eofb;
+		int flags;
+
+		if (copy_from_user(&eofb, arg, sizeof(eofb)))
+			return -XFS_ERROR(EFAULT);
+
+		flags = (eofb.eof_flags & XFS_EOF_FLAGS_FORCE) ? SYNC_WAIT : SYNC_TRYLOCK;
+		error = xfs_inodes_free_eofblocks(mp, flags);
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
