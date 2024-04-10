Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9DA621
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 00:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712710630; cv=none; b=pjnuZ7Pk1RU8N1oStIseA9Y9pHkU+f6ICxy3f/2q7RL1Kzu2MjrXTjuCtUeIWT/MdwNI/dThIRgWXpusI03HpJWLvDB3WKCM9HoeaJ/6AdPvagmmv1RsUoy3fqMvfJ/H9jwtYrzxl6IL97YfdKg4cMJRYKn/JUO/DfeG/+1E1xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712710630; c=relaxed/simple;
	bh=2bfXFWlsjbj/ImpomT59XFmKbdXrV0bnE0TJlxM9LLc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YnFpWQeEKUVCp8dtYEkHl+GtjB40Q4hBMEHOmb13nmcwB9Aliu1EJXDv4h5ECn0aeFDw9sfSqIA1c6gOA0kdUgXt1l6PNSH6xrVls/BKTnYSnsXGt6j51h6nZ9pYB8Ibp7a5UzvryXXGTrhiuxpABxvT83GjitlfRRih3T3hNdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Db++LntY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Db++LntY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 247B1C433C7;
	Wed, 10 Apr 2024 00:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712710630;
	bh=2bfXFWlsjbj/ImpomT59XFmKbdXrV0bnE0TJlxM9LLc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Db++LntYQ5fKpKW2TdS0GWClgydiH9m7bqRBo/nHFovfeKbdJXsn3sc5+rbMSnHXk
	 QyexJVC7y2rux1DVkui+oMASHFpnMJFs6Uu+n0+c/zmLKXaayV7aXK7d2DULhXoWZf
	 tKVVI7DzYQxpA1gBCTOuw+ZMZ0QiKqY3ju571qeuwTbfyq4Q09m+pYooAHV2akWJ02
	 Co58ldx9ZGH2zIrhjB0IbuSMHUstMu/okmU/WytwAx1Z3g7R/2Xycg3t+MKueX4qtX
	 e6Sp6yVovAYNmD4+zej+Ic49KZ0ImQWZhvpY8eSUC5QmkBBx+LhxFAULhKecriIPWv
	 YKsAivLvGOfkQ==
Date: Tue, 09 Apr 2024 17:57:09 -0700
Subject: [PATCH 14/32] xfs: add parent pointer validator functions
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <171270969790.3631889.2339349798519269452.stgit@frogsfrogsfrogs>
In-Reply-To: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
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

Attribute names of parent pointers are not strings.  So we need to
modify attr_namecheck to verify parent pointer records when the
XFS_ATTR_PARENT flag is set.  At the same time, we need to validate attr
values during log recovery if the xattr is really a parent pointer.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: move functions to xfs_parent.c, adjust for new disk format]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile            |    1 
 fs/xfs/libxfs/xfs_attr.c   |    5 ++
 fs/xfs/libxfs/xfs_parent.c |   92 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_parent.h |   15 +++++++
 fs/xfs/xfs_attr_item.c     |   15 +++++++
 5 files changed, 128 insertions(+)
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
index 6e47c493bf9e2..41de6a135d907 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -26,6 +26,7 @@
 #include "xfs_trace.h"
 #include "xfs_attr_item.h"
 #include "xfs_xattr.h"
+#include "xfs_parent.h"
 
 struct kmem_cache		*xfs_attr_intent_cache;
 
@@ -1570,6 +1571,10 @@ xfs_attr_namecheck(
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
index be8660a0b55ff..84c63b9668ad9 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -27,6 +27,7 @@
 #include "xfs_error.h"
 #include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
+#include "xfs_parent.h"
 
 struct kmem_cache		*xfs_attri_cache;
 struct kmem_cache		*xfs_attrd_cache;
@@ -1055,6 +1056,13 @@ xlog_recover_attri_commit_pass2(
 		}
 
 		attr_value = item->ri_buf[i].i_addr;
+		if ((attri_formatp->alfi_attr_filter & XFS_ATTR_PARENT) &&
+		    !xfs_parent_valuecheck(mp, attr_value, value_len)) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					item->ri_buf[i].i_addr,
+					item->ri_buf[i].i_len);
+			return -EFSCORRUPTED;
+		}
 		i++;
 	}
 
@@ -1067,6 +1075,13 @@ xlog_recover_attri_commit_pass2(
 		}
 
 		attr_new_value = item->ri_buf[i].i_addr;
+		if ((attri_formatp->alfi_attr_filter & XFS_ATTR_PARENT) &&
+		    !xfs_parent_valuecheck(mp, attr_new_value, new_value_len)) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					item->ri_buf[i].i_addr,
+					item->ri_buf[i].i_len);
+			return -EFSCORRUPTED;
+		}
 		i++;
 	}
 

