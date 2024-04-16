Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F297464
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713230951; cv=none; b=k5FHXD9sinH7qBY2Y1KpcmTeurblETsOCify4QoccHfkxE3dKx5BJAZ2R/+A6J6lHIG6NDcjVWt5Zd88sdNuPpiybyxyhsC+by25AxCMXQKEJBUy1RRjKWDFRDKDdkUWiTJy5LO88zB9kGK1nbPkoLa5ednYu5K+r3G+LkyMzyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713230951; c=relaxed/simple;
	bh=qga8tiq+VW0gsNAPrQm2yrT9BIVDQizCN1GzBp+ujX0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IWJq5le+jh84yVFxnorYjYNyaq/g0ouhTK3gBKYqgzf4tAQTLasKBbnjgJ5cghcIv17KcnSgEQupVrvUnVvqq8XjY1EHAVMZz96DQe9JkK8SAz18+6HLt7ESI2fEWGwg3iR35v8EGbr3t0HnRFfQcskS6ljc1CW0y1BCTPi6zmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rH1QaXrz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rH1QaXrz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF344C113CC;
	Tue, 16 Apr 2024 01:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713230950;
	bh=qga8tiq+VW0gsNAPrQm2yrT9BIVDQizCN1GzBp+ujX0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rH1QaXrz5RDe6dILvgNeMkH81O5LDo7PrD8BlogJk4wH+dNf8gtRbPobDhNAs73Rr
	 746/koXGKBzQRkiVZRS9lk2lRC+DlqQq2wQLpGipotLRl/vx/m9BxZoB10HaiWAjX+
	 IoZec9wxO6zmhzB2VpWX5HP6kUaDGn4oQiuKUR3/fF0Z5wSYXGqXiKySUbhxdYM09P
	 9M/GeDPOeAWUNtAJVDI4Gnirvm45hmvi6YqMJU7rqA2hSu9bRhj+jhjuFh6vsrfair
	 CcKz3WVXfLrxL8SHfUDMRbmNIeER9s8F33nx7HssATPoi3jxivMXCpg3uMy6z1DJ6Z
	 AEOTRc1pztr3A==
Date: Mon, 15 Apr 2024 18:29:10 -0700
Subject: [PATCH 12/31] xfs: add parent pointer validator functions
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 Christoph Hellwig <hch@lst.de>, allison.henderson@oracle.com,
 hch@infradead.org, linux-xfs@vger.kernel.org, catherine.hoang@oracle.com,
 hch@lst.de
Message-ID: <171323027981.251715.16181429944291541550.stgit@frogsfrogsfrogs>
In-Reply-To: <171323027704.251715.12000080989736970684.stgit@frogsfrogsfrogs>
References: <171323027704.251715.12000080989736970684.stgit@frogsfrogsfrogs>
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
index 4e1eb3b6dbc45..4956ea9a307b8 100644
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
index 78c87c405e33c..93524efa6e56c 100644
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
index 0000000000000..5961fa8c85615
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
index 0000000000000..ef8aff8607801
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
index f52529cccc393..dbc9a21fced5c 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -27,6 +27,7 @@
 #include "xfs_error.h"
 #include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
+#include "xfs_parent.h"
 
 struct kmem_cache		*xfs_attri_cache;
 struct kmem_cache		*xfs_attrd_cache;
@@ -969,6 +970,15 @@ xfs_attri_validate_value_iovec(
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
 

