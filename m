Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 29 Aug 2007 19:32:00 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7U2Vn4p021941
	for <xfs@oss.sgi.com>; Wed, 29 Aug 2007 19:31:56 -0700
Message-ID: <46D6279F.40601@sgi.com>
Date: Thu, 30 Aug 2007 12:12:47 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
MIME-Version: 1.0
Subject: [PATCH] log replay should not overwrite newer ondisk inodes
Content-Type: multipart/mixed;
 boundary="------------080903080506070106090000"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

This is a multi-part message in MIME format.
--------------080903080506070106090000
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Log replay of clustered inodes currently ignores the flushiter
field in the inode that is used to determine if the on-disk inode
is more up to date than the copy in the log.  As a result during
log replay the newer inode is being overwritten with an older
version and file size updates are being lost.

I haven't handled the case of the flushiter counter overflowing
but that shouldn't be a problem in this case.  The log buffer
contains newly created inodes so their flushiter values will be 0
and the on-disk inodes should not be much greater.

Lachlan

--------------080903080506070106090000
Content-Type: text/x-patch;
 name="xfs_log_recover.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="xfs_log_recover.diff"

--- fs/xfs/xfs_log_recover.c_1.322	2007-08-27 17:45:45.000000000 +1000
+++ fs/xfs/xfs_log_recover.c	2007-08-30 11:50:44.000000000 +1000
@@ -1866,6 +1866,27 @@ xlog_recover_do_inode_buffer(
 }
 
 /*
+ * Check if we need to recover an inode from a buffer
+ */
+int
+xfs_recover_inode(
+	char	*dest,
+	char	*src)
+{
+	xfs_dinode_t	*dip = (xfs_dinode_t *)dest;
+	xfs_dinode_t	*dilp = (xfs_dinode_t*)src;
+
+	if ((be16_to_cpu(dip->di_core.di_magic) == XFS_DINODE_MAGIC) &&
+		(be16_to_cpu(dilp->di_core.di_magic) == XFS_DINODE_MAGIC) &&
+		(be16_to_cpu(dilp->di_core.di_flushiter) <
+			be16_to_cpu(dip->di_core.di_flushiter))) {
+		return 1;
+	}
+
+	return 0;
+}
+
+/*
  * Perform a 'normal' buffer recovery.  Each logged region of the
  * buffer should be copied over the corresponding region in the
  * given buffer.  The bitmap in the buf log format structure indicates
@@ -1917,6 +1938,13 @@ xlog_recover_do_reg_buffer(
 					       -1, 0, XFS_QMOPT_DOWARN,
 					       "dquot_buf_recover");
 		}
+		/*
+		 * Sanity check if this is an inode buffer.
+		 */
+		if (!error)
+			error = xfs_recover_inode(xfs_buf_offset(bp,
+					(uint)bit << XFS_BLI_SHIFT),
+					item->ri_buf[i].i_addr);
 		if (!error)
 			memcpy(xfs_buf_offset(bp,
 				(uint)bit << XFS_BLI_SHIFT),	/* dest */

--------------080903080506070106090000--
