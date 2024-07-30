Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759021361
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299966; cv=none; b=cnBRli1DH6Br3FoynOKAY+FuDRcJs0DT04GX41VDWohkwb8H+TTMBY+bikXT7xY/7kfLlA/+jMYzvNwO8VX3N75iKR2H7MnjJsd7XQFfOvwliTEV0hn7ynl1tsvJed5ZIc2LTpxzW3QV4o9nTw8W5o1gcsH8YJEjcVNZLpG9p0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299966; c=relaxed/simple;
	bh=MKa1Le1cKv9Q8IEIAFIP0M+NPQijZpleg8tdJoWfSjA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QsU3FqsSmtdfNQWh22jmRkFisjP8tm3uXJpGDppkHz/xpRjinkefN4NzCBFK/3C5Ul/jaKjWc9lvKMtyYQT8wyDZklAfgPLreiMFRNrsKFY79JMMx5oGdkp/HdrAi8IglzALF0rqwMX6VzicYD0rN8n1VObmvjxuPs4AUSEUroQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p890uh6t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p890uh6t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0454C32786;
	Tue, 30 Jul 2024 00:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299966;
	bh=MKa1Le1cKv9Q8IEIAFIP0M+NPQijZpleg8tdJoWfSjA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=p890uh6tWm9Ou0dseCAwx1o/IVcpC/n/H+egofu6yBt3CmhIWR1XOfXXNk3aS2ZhR
	 riAvk12XjDIf20Nhw6INlJ8cTPdgz2jTjMJav+eI8qHijWoQ+YO7qZmVOiwkhYWPN5
	 Ph//vq6DGiG1mn7IjuLe0h0I+c0ktBhGggal3QZf/Hd+9DjNrf+VGwZslOuX/v60m/
	 9UmM3l3mbw0o91kbv+BroOpAjWYmbH+uF3o5mbIqQK2FF7DHXEkM8LbWQGN1LsugnG
	 Eh1dhvFUD+vJPRcHYPLbCZ2uS+fVc768SrSJJeoLPKH65s4nY7FFLZhSC/1YYk/IKr
	 O7Kr5HBtQQCtw==
Date: Mon, 29 Jul 2024 17:39:25 -0700
Subject: [PATCH 060/115] xfs: add parent pointer validator functions
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229843288.1338752.5025682908444979644.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
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

Source kernel commit: a08d6729637428b6ef8c6a5a94d8c6db7b805a44

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
 libxfs/Makefile     |    2 +
 libxfs/xfs_attr.c   |    5 +++
 libxfs/xfs_parent.c |   89 +++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_parent.h |   15 +++++++++
 4 files changed, 111 insertions(+)
 create mode 100644 libxfs/xfs_parent.c
 create mode 100644 libxfs/xfs_parent.h


diff --git a/libxfs/Makefile b/libxfs/Makefile
index e3fa18fee..2a5cead9a 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -50,6 +50,7 @@ HFILES = \
 	xfs_ialloc_btree.h \
 	xfs_inode_buf.h \
 	xfs_inode_fork.h \
+	xfs_parent.h \
 	xfs_quota_defs.h \
 	xfs_refcount.h \
 	xfs_refcount_btree.h \
@@ -102,6 +103,7 @@ CFILES = buf_mem.c \
 	xfs_inode_fork.c \
 	xfs_ialloc_btree.c \
 	xfs_log_rlimit.c \
+	xfs_parent.c \
 	xfs_refcount.c \
 	xfs_refcount_btree.c \
 	xfs_rmap.c \
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index c67cdc77a..345132921 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -25,6 +25,7 @@
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
 #include "defer_item.h"
+#include "xfs_parent.h"
 
 struct kmem_cache		*xfs_attr_intent_cache;
 
@@ -1567,6 +1568,10 @@ xfs_attr_namecheck(
 	if (length >= MAXNAMELEN)
 		return false;
 
+	/* Parent pointers have their own validation. */
+	if (attr_flags & XFS_ATTR_PARENT)
+		return xfs_parent_namecheck(attr_flags, name, length);
+
 	/* There shouldn't be any nulls here */
 	return !memchr(name, 0, length);
 }
diff --git a/libxfs/xfs_parent.c b/libxfs/xfs_parent.c
new file mode 100644
index 000000000..50da527b6
--- /dev/null
+++ b/libxfs/xfs_parent.c
@@ -0,0 +1,89 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2022-2024 Oracle.
+ * All rights reserved.
+ */
+#include "libxfs_priv.h"
+#include "xfs_fs.h"
+#include "xfs_format.h"
+#include "xfs_da_format.h"
+#include "xfs_log_format.h"
+#include "xfs_shared.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_inode.h"
+#include "xfs_trace.h"
+#include "xfs_trans.h"
+#include "xfs_da_btree.h"
+#include "xfs_attr.h"
+#include "xfs_dir2.h"
+#include "xfs_dir2_priv.h"
+#include "xfs_attr_sf.h"
+#include "xfs_bmap.h"
+#include "xfs_defer.h"
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
diff --git a/libxfs/xfs_parent.h b/libxfs/xfs_parent.h
new file mode 100644
index 000000000..ef8aff860
--- /dev/null
+++ b/libxfs/xfs_parent.h
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

