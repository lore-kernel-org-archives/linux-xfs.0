Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48046 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755680AbcI3DFw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 23:05:52 -0400
Subject: [PATCH 02/63] vfs: add a FALLOC_FL_UNSHARE mode to fallocate to
 unshare a range of blocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 29 Sep 2016 20:05:48 -0700
Message-ID: <147520474825.29434.11791614565389664342.stgit@birch.djwong.org>
In-Reply-To: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Add a new fallocate mode flag that explicitly unshares blocks on
filesystems that support such features.  The new flag can only
be used with an allocate-mode fallocate call.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/open.c                   |    5 +++++
 include/linux/falloc.h      |    3 ++-
 include/uapi/linux/falloc.h |   18 ++++++++++++++++++
 3 files changed, 25 insertions(+), 1 deletion(-)


diff --git a/fs/open.c b/fs/open.c
index 4fd6e25..d58525d 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -256,6 +256,11 @@ int vfs_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	    (mode & ~FALLOC_FL_INSERT_RANGE))
 		return -EINVAL;
 
+	/* Unshare range should only be used with allocate mode. */
+	if ((mode & FALLOC_FL_UNSHARE_RANGE) &&
+	    (mode & ~(FALLOC_FL_UNSHARE_RANGE | FALLOC_FL_KEEP_SIZE)))
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
index 3e445a7..b075f60 100644
--- a/include/uapi/linux/falloc.h
+++ b/include/uapi/linux/falloc.h
@@ -58,4 +58,22 @@
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
+ *
+ * This flag can only be used with allocate-mode fallocate, which is
+ * to say that it cannot be used with the punch, zero, collapse, or
+ * insert range modes.
+ */
+#define FALLOC_FL_UNSHARE_RANGE		0x40
+
 #endif /* _UAPI_FALLOC_H_ */

