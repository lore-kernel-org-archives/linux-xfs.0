Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CEC7329E4D
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 00:01:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 511A8AC006
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 22:01:15 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id cDh1D75j0MvCTHDc (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2015 22:01:14 -0700 (PDT)
Subject: [PATCH 55/58] vfs: add a FALLOC_FL_UNSHARE mode to fallocate to
	unshare a range of blocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 06 Oct 2015 22:01:10 -0700
Message-ID: <20151007050110.30457.66869.stgit@birch.djwong.org>
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

Add a new mode to fallocate that unshares a range of blocks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/open.c                   |    5 +++++
 include/linux/falloc.h      |    3 ++-
 include/uapi/linux/falloc.h |   14 ++++++++++++++
 3 files changed, 21 insertions(+), 1 deletion(-)


diff --git a/fs/open.c b/fs/open.c
index b6f1e96..58e2b61 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -256,6 +256,11 @@ int vfs_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	    (mode & ~FALLOC_FL_INSERT_RANGE))
 		return -EINVAL;
 
+	/* Unshare range should only be used exclusively. */
+	if ((mode & FALLOC_FL_UNSHARE_RANGE) &&
+	    (mode & ~FALLOC_FL_UNSHARE_RANGE))
+		return -EINVAL;
+
 	if (!(file->f_mode & FMODE_WRITE))
 		return -EBADF;
 
diff --git a/include/linux/falloc.h b/include/linux/falloc.h
index 9961110..7494dc6 100644
--- a/include/linux/falloc.h
+++ b/include/linux/falloc.h
@@ -25,6 +25,7 @@ struct space_resv {
 					 FALLOC_FL_PUNCH_HOLE |		\
 					 FALLOC_FL_COLLAPSE_RANGE |	\
 					 FALLOC_FL_ZERO_RANGE |		\
-					 FALLOC_FL_INSERT_RANGE)
+					 FALLOC_FL_INSERT_RANGE |	\
+					 FALLOC_FL_UNSHARE_RANGE)
 
 #endif /* _FALLOC_H_ */
diff --git a/include/uapi/linux/falloc.h b/include/uapi/linux/falloc.h
index 3e445a7..a1c293b 100644
--- a/include/uapi/linux/falloc.h
+++ b/include/uapi/linux/falloc.h
@@ -58,4 +58,18 @@
  */
 #define FALLOC_FL_INSERT_RANGE		0x20
 
+/*
+ * FALLOC_FL_UNSHARE_RANGE is used to unshare shared blocks within the
+ * file size without overwriting any existing data. The purpose of this
+ * call is to preemptively reallocate any blocks that are subject to
+ * copy-on-write.
+ *
+ * Different filesystems may implement different limitations on the
+ * granularity of the operation. Most will limit operations to filesystem
+ * block size boundaries, but this boundary may be larger or smaller
+ * depending on the filesystem and/or the configuration of the filesystem
+ * or file.
+ */
+#define FALLOC_FL_UNSHARE_RANGE		0x40
+
 #endif /* _UAPI_FALLOC_H_ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
