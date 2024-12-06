Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594141C548E
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528254; cv=none; b=ggnQbTmzAwdJfuTwkjI6JnIVFmT8tRbUfFgtkyPN/ZTtS6wUOPeiG/CCKVh0zad1KW3mpCOnfHFaySjy6Vt7N3H+heFnjlEL3jRO0xQVfI0suc6rAwim2z8uEWh/q6SnN4QagDQH5dg9wAooBrGilQsF+pgKyss3n5H9LCPES9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528254; c=relaxed/simple;
	bh=9QCrWHGsZJa3B3SlkdMJlbDw/zYloxGmtzHE+XbuiB0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D8wYN3P8MAiujry8D6cirwZ2+iMIPB7f0bEBnilwc73fddHaJg1v4o5xLmKQEt3bldKBoLpqDz8rBD1BhpVkD1hNp0EcQxcB23z4BXZV4VLH6ankk/mB1kkRadvqtPHpiCV4qAlapK0MpKs0EOqhc8Z5lmK1YnAYDbL+bNZ0wK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dmPJiS+v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dmPJiS+v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37023C4CED1;
	Fri,  6 Dec 2024 23:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733528254;
	bh=9QCrWHGsZJa3B3SlkdMJlbDw/zYloxGmtzHE+XbuiB0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dmPJiS+vgleclHu66cUieANv7OlIsE3xWGyDD6br6N5KMg+NF8MHFL+KpjPkWshkY
	 Be3VKT6wRUFVwfxQ/wrGhCS50V7b2ckpUMl350oCDgkDwYRXDmbUpHupoqbyLWIStY
	 ETt6ieOuM0U9BipuZlFzo0DltOXFfx4fX5MJhxMm0L1U90MEG4esoo8PZpJjKPzz4I
	 eQvuHOYFd4svGEPEQEe9iOT7+DLVkHzMfpKF6/+Z+kPiTDXE/Dtdxh+Mr8YNyB2Gbu
	 g0rUeUNELdCAl1qNDZ1qatw1AT660t6KPRLh1B/YM+lgdZ2DgrE3fF8mjrAMsu9D3b
	 K7BIYsoZr+eYQ==
Date: Fri, 06 Dec 2024 15:37:33 -0800
Subject: [PATCH 28/36] xfs: iget for metadata inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352747304.121772.2733366590661000896.stgit@frogsfrogsfrogs>
In-Reply-To: <173352746825.121772.11414387759505707402.stgit@frogsfrogsfrogs>
References: <173352746825.121772.11414387759505707402.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit df2e495bb92c84a401b6b90c835a9d1be84a3a0f

Create a xfs_trans_metafile_iget function for metadata inodes to ensure
that when we try to iget a metadata file, the inode is allocated and its
file mode matches the metadata file type the caller expects.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/libxfs.h         |    1 +
 include/xfs_inode.h      |    5 ++++
 libxfs/Makefile          |    1 +
 libxfs/inode.c           |   55 ++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/libxfs_api_defs.h |    5 ++++
 libxfs/xfs_metafile.h    |   16 +++++++++++++
 6 files changed, 83 insertions(+)
 create mode 100644 libxfs/xfs_metafile.h


diff --git a/include/libxfs.h b/include/libxfs.h
index fe8e6584f1caca..0356bc57b956a9 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -95,6 +95,7 @@ struct iomap;
 #include "xfs_btree_mem.h"
 #include "xfs_parent.h"
 #include "xfs_ag_resv.h"
+#include "xfs_metafile.h"
 
 #ifndef ARRAY_SIZE
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index e03521bc9aaaa2..6f2d23987d5f8a 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -210,6 +210,11 @@ static inline struct timespec64 inode_set_ctime_current(struct inode *inode)
 	return now;
 }
 
+static inline bool inode_wrong_type(const struct inode *inode, umode_t mode)
+{
+	return (inode->i_mode ^ mode) & S_IFMT;
+}
+
 typedef struct xfs_inode {
 	struct cache_node	i_node;
 	struct xfs_mount	*i_mount;	/* fs mount struct ptr */
diff --git a/libxfs/Makefile b/libxfs/Makefile
index 470583006de69a..765c84a16408f8 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -55,6 +55,7 @@ HFILES = \
 	xfs_inode_buf.h \
 	xfs_inode_fork.h \
 	xfs_inode_util.h \
+	xfs_metafile.h \
 	xfs_parent.h \
 	xfs_quota_defs.h \
 	xfs_refcount.h \
diff --git a/libxfs/inode.c b/libxfs/inode.c
index 9230ad24a5cb6c..1eb0bccae48906 100644
--- a/libxfs/inode.c
+++ b/libxfs/inode.c
@@ -205,6 +205,61 @@ libxfs_iget(
 	return error;
 }
 
+/*
+ * Get a metadata inode.
+ *
+ * The metafile type must match the file mode exactly.
+ */
+int
+libxfs_trans_metafile_iget(
+	struct xfs_trans	*tp,
+	xfs_ino_t		ino,
+	enum xfs_metafile_type	metafile_type,
+	struct xfs_inode	**ipp)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_inode	*ip;
+	umode_t			mode;
+	int			error;
+
+	error = libxfs_iget(mp, tp, ino, 0, &ip);
+	if (error)
+		return error;
+
+	if (metafile_type == XFS_METAFILE_DIR)
+		mode = S_IFDIR;
+	else
+		mode = S_IFREG;
+	if (inode_wrong_type(VFS_I(ip), mode))
+		goto bad_rele;
+
+	*ipp = ip;
+	return 0;
+bad_rele:
+	libxfs_irele(ip);
+	return -EFSCORRUPTED;
+}
+
+/* Grab a metadata file if the caller doesn't already have a transaction. */
+int
+libxfs_metafile_iget(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino,
+	enum xfs_metafile_type	metafile_type,
+	struct xfs_inode	**ipp)
+{
+	struct xfs_trans	*tp;
+	int			error;
+
+	error = libxfs_trans_alloc_empty(mp, &tp);
+	if (error)
+		return error;
+
+	error = libxfs_trans_metafile_iget(tp, ino, metafile_type, ipp);
+	libxfs_trans_cancel(tp);
+	return error;
+}
+
 static void
 libxfs_idestroy(
 	struct xfs_inode	*ip)
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 92e26eebabfed8..fefae9256555a0 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -184,6 +184,7 @@
 #define xfs_iext_next			libxfs_iext_next
 #define xfs_ifork_zap_attr		libxfs_ifork_zap_attr
 #define xfs_imap_to_bp			libxfs_imap_to_bp
+
 #define xfs_initialize_perag		libxfs_initialize_perag
 #define xfs_initialize_perag_data	libxfs_initialize_perag_data
 #define xfs_init_local_fork		libxfs_init_local_fork
@@ -208,8 +209,12 @@
 #define xfs_log_calc_minimum_size	libxfs_log_calc_minimum_size
 #define xfs_log_get_max_trans_res	libxfs_log_get_max_trans_res
 #define xfs_log_sb			libxfs_log_sb
+
+#define xfs_metafile_iget		libxfs_metafile_iget
+#define xfs_trans_metafile_iget		libxfs_trans_metafile_iget
 #define xfs_mode_to_ftype		libxfs_mode_to_ftype
 #define xfs_mkdir_space_res		libxfs_mkdir_space_res
+
 #define xfs_parent_addname		libxfs_parent_addname
 #define xfs_parent_finish		libxfs_parent_finish
 #define xfs_parent_hashval		libxfs_parent_hashval
diff --git a/libxfs/xfs_metafile.h b/libxfs/xfs_metafile.h
new file mode 100644
index 00000000000000..60fe1890611277
--- /dev/null
+++ b/libxfs/xfs_metafile.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2018-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_METAFILE_H__
+#define __XFS_METAFILE_H__
+
+/* Code specific to kernel/userspace; must be provided externally. */
+
+int xfs_trans_metafile_iget(struct xfs_trans *tp, xfs_ino_t ino,
+		enum xfs_metafile_type metafile_type, struct xfs_inode **ipp);
+int xfs_metafile_iget(struct xfs_mount *mp, xfs_ino_t ino,
+		enum xfs_metafile_type metafile_type, struct xfs_inode **ipp);
+
+#endif /* __XFS_METAFILE_H__ */

