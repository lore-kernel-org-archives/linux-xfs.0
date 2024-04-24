Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00B2126F09
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713928543; cv=none; b=Dr36J2Bqr+IMkGYL8Z3FQZr/dsUNuvOc02WRfz9J4eciWAG8RsbhxiVhITTTlPsIA6CYBBohBz+3bXoVmgBZIAVIeqORl+pEt4NNwkD6WM8yAZKi4E9Y+dVejGE7OFm6aQg6OGv2LlzSUBAHPO1sUb2rmYsvrbgkfk+U3QZ2oO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713928543; c=relaxed/simple;
	bh=RyzuIacTfVrNqCPT5y0vCvldR2+n/Tq/1mkckxRhxws=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dxDB585hRT4u4YwFiZvvLmqs6L216KOvJ1Goy0pXL8JXEiftyIc+V+4Lbfr5C9Q/xuZcEANEfeM/7jk+D2rLBamK7sTwZRTsnJk76PzzfkR/My2RnjhMoP2U9HIpIYULhVIJJcZpWvP7/YsFyFX0nSq3tO8xXZ4lX9DVhyD1Ivg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cmJYQ83K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cmJYQ83K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79327C116B1;
	Wed, 24 Apr 2024 03:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713928543;
	bh=RyzuIacTfVrNqCPT5y0vCvldR2+n/Tq/1mkckxRhxws=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cmJYQ83KX8iNXG/lJFr5rB5ZD8F/bQFudUoZr5jusL3ZFnCiaG3rnyAiYAsHhbQQR
	 1A22ckpzlXaurmBIFzq3uLAncKcrSwS9gFCXDPcu4H/qAbFX3VW5OU4V8pLdIQF+lv
	 b8O1qj4vEaUEMbfwJgS/Tlpq7qU2Bz+feB4zAvx2judaDLcXPf7NhHDzv651NaTXRC
	 9JEWUicM0BPHU2rokowpAe0AF84Dp9SYu2z57gVSW7k7pKUceOrF/c9nomZ6cZy5X1
	 n6assVdrEe0R2aqWyFiKInyboH9CZX9qbN0WWXd7mI1lN931d7jqFNk6rH7FEoSWz7
	 kFdkCmYjzOcNw==
Date: Tue, 23 Apr 2024 20:15:42 -0700
Subject: [PATCH 12/30] xfs: add parent pointer validator functions
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 Christoph Hellwig <hch@lst.de>, catherine.hoang@oracle.com,
 allison.henderson@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392783469.1905110.16681359410330594594.stgit@frogsfrogsfrogs>
In-Reply-To: <171392783191.1905110.6347010840682949070.stgit@frogsfrogsfrogs>
References: <171392783191.1905110.6347010840682949070.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Allison Henderson <allison.henderson@oracle.com>

The attr name of a parent pointer is a string, and the attr value of a
parent pointer is (more or less) a file handle.  So we need to modify
attr_namecheck to verify the parent pointer name, and add a
xfs_parent_valuecheck function to sanitize the handle.  At the same
time, we need to validate attr values during log recovery if the xattr
is really a parent pointer.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: move functions to xfs_parent.c, adjust for new disk format]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/Makefile            |    1 
 fs/xfs/libxfs/xfs_attr.c   |    5 ++
 fs/xfs/libxfs/xfs_parent.c |   92 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_parent.h |   15 +++++++
 fs/xfs/xfs_attr_item.c     |   10 +++++
 5 files changed, 123 insertions(+)
 create mode 100644 fs/xfs/libxfs/xfs_parent.c
 create mode 100644 fs/xfs/libxfs/xfs_parent.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 4e1eb3b6dbc4..4956ea9a307b 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -42,6 +42,7 @@ xfs-y				+= $(addprefix libxfs/, \
 				   xfs_inode_buf.o \
 				   xfs_log_rlimit.o \
 				   xfs_ag_resv.o \
+				   xfs_parent.o \
 				   xfs_rmap.o \
 				   xfs_rmap_btree.o \
 				   xfs_refcount.o \
diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 78c87c405e33..93524efa6e56 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -26,6 +26,7 @@
 #include "xfs_trace.h"
 #include "xfs_attr_item.h"
 #include "xfs_xattr.h"
+#include "xfs_parent.h"
 
 struct kmem_cache		*xfs_attr_intent_cache;
 
@@ -1568,6 +1569,10 @@ xfs_attr_namecheck(
 	if (length >= MAXNAMELEN)
 		return false;
 
+	/* Parent pointers have their own validation. */
+	if (attr_flags & XFS_ATTR_PARENT)
+		return xfs_parent_namecheck(attr_flags, name, length);
+
 	/* There shouldn't be any nulls here */
 	return !memchr(name, 0, length);
 }
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
new file mode 100644
index 000000000000..5961fa8c8561
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -0,0 +1,92 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2022-2024 Oracle.
+ * All rights reserved.
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_format.h"
+#include "xfs_da_format.h"
+#include "xfs_log_format.h"
+#include "xfs_shared.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_inode.h"
+#include "xfs_error.h"
+#include "xfs_trace.h"
+#include "xfs_trans.h"
+#include "xfs_da_btree.h"
+#include "xfs_attr.h"
+#include "xfs_dir2.h"
+#include "xfs_dir2_priv.h"
+#include "xfs_attr_sf.h"
+#include "xfs_bmap.h"
+#include "xfs_defer.h"
+#include "xfs_log.h"
+#include "xfs_xattr.h"
+#include "xfs_parent.h"
+#include "xfs_trans_space.h"
+
+/*
+ * Parent pointer attribute handling.
+ *
+ * Because the attribute name is a filename component, it will never be longer
+ * than 255 bytes and must not contain nulls or slashes.  These are roughly the
+ * same constraints that apply to attribute names.
+ *
+ * The attribute value must always be a struct xfs_parent_rec.  This means the
+ * attribute will never be in remote format because 12 bytes is nowhere near
+ * xfs_attr_leaf_entsize_local_max() (~75% of block size).
+ *
+ * Creating a new parent attribute will always create a new attribute - there
+ * should never, ever be an existing attribute in the tree for a new inode.
+ * ENOSPC behavior is problematic - creating the inode without the parent
+ * pointer is effectively a corruption, so we allow parent attribute creation
+ * to dip into the reserve block pool to avoid unexpected ENOSPC errors from
+ * occurring.
+ */
+
+/* Return true if parent pointer attr name is valid. */
+bool
+xfs_parent_namecheck(
+	unsigned int			attr_flags,
+	const void			*name,
+	size_t				length)
+{
+	/*
+	 * Parent pointers always use logged operations, so there should never
+	 * be incomplete xattrs.
+	 */
+	if (attr_flags & XFS_ATTR_INCOMPLETE)
+		return false;
+
+	return xfs_dir2_namecheck(name, length);
+}
+
+/* Return true if parent pointer attr value is valid. */
+bool
+xfs_parent_valuecheck(
+	struct xfs_mount		*mp,
+	const void			*value,
+	size_t				valuelen)
+{
+	const struct xfs_parent_rec	*rec = value;
+
+	if (!xfs_has_parent(mp))
+		return false;
+
+	/* The xattr value must be a parent record. */
+	if (valuelen != sizeof(struct xfs_parent_rec))
+		return false;
+
+	/* The parent record must be local. */
+	if (value == NULL)
+		return false;
+
+	/* The parent inumber must be valid. */
+	if (!xfs_verify_dir_ino(mp, be64_to_cpu(rec->p_ino)))
+		return false;
+
+	return true;
+}
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
new file mode 100644
index 000000000000..ef8aff860780
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -0,0 +1,15 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2022-2024 Oracle.
+ * All Rights Reserved.
+ */
+#ifndef	__XFS_PARENT_H__
+#define	__XFS_PARENT_H__
+
+/* Metadata validators */
+bool xfs_parent_namecheck(unsigned int attr_flags, const void *name,
+		size_t length);
+bool xfs_parent_valuecheck(struct xfs_mount *mp, const void *value,
+		size_t valuelen);
+
+#endif /* __XFS_PARENT_H__ */
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 2898eeb16366..2b10ac4c5fce 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -27,6 +27,7 @@
 #include "xfs_error.h"
 #include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
+#include "xfs_parent.h"
 
 struct kmem_cache		*xfs_attri_cache;
 struct kmem_cache		*xfs_attrd_cache;
@@ -973,6 +974,15 @@ xfs_attri_validate_value_iovec(
 		return NULL;
 	}
 
+	if ((attri_formatp->alfi_attr_filter & XFS_ATTR_PARENT) &&
+	    !xfs_parent_valuecheck(mp, iovec->i_addr, value_len)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				attri_formatp, sizeof(*attri_formatp));
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				iovec->i_addr, iovec->i_len);
+		return NULL;
+	}
+
 	return iovec->i_addr;
 }
 

