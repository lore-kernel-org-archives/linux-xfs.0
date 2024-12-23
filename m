Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28DBB1BEF82
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734990268; cv=none; b=mkW1OK8rPrRD22fU8uAJNnZP0tb4D/c74JISyoi7BS79omk/SgLWRnx97ksB354FDraJyaqA4l4szDblGFT2nj/MOThGzUa9iwBZvRt9WnglXLCJsgjv52wMHrKIBgGr05zNLjh2AS/k/jdUG42RNsqAnizy8oITIFMMrkb3MIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734990268; c=relaxed/simple;
	bh=9QCrWHGsZJa3B3SlkdMJlbDw/zYloxGmtzHE+XbuiB0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S9PItlwbaCHLz9Uri2aBE2ddFG+TPMy/2RzJlAU57+o1cr+/y226y/ZFgmaAUyhF8nzM9PAzXN63QQKbN5c8hfgPPbLwqtowoCQv/pqkbRx4pL5CzuAZQHxPK7IjeFy9yfqE4X2ppE1eevqF0zonZNcmfFyUkMXqKV0BYXii2oQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KxpjQfkE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KxpjQfkE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FED4C4CED3;
	Mon, 23 Dec 2024 21:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734990265;
	bh=9QCrWHGsZJa3B3SlkdMJlbDw/zYloxGmtzHE+XbuiB0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KxpjQfkE/ll/eVHm0DxIIsbDE5k42fqS0UXYrGicR4UcDnx4Zkx29UU5rXAlq9KhE
	 5/zDrxrdxmg82DbspjVX632zCYEN66s7bc+VFEPw2OWdG2VqJ+jPF4p8oE8mORFk+7
	 TJEC6g+aoCC5Ose4ti68c9ueiY7vgzcRyFpirGkZK5wi5Y6jeo73CGFHr3XN2Ab6op
	 feHC+58y3FN1eLG76I3oUccCeUHiwOFz4RMKxqfsNhsYgmOevM4Zz4Uhlk89tObXwA
	 fXgfqA/pIzINYcGij5axzIw8uSquvSt8pnJ1cIS766d+snOfncWo09LGwcxt2/8Mfa
	 72/3L6T4PMGmg==
Date: Mon, 23 Dec 2024 13:44:25 -0800
Subject: [PATCH 28/36] xfs: iget for metadata inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498940371.2293042.269440098958458524.stgit@frogsfrogsfrogs>
In-Reply-To: <173498939893.2293042.8029858406528247316.stgit@frogsfrogsfrogs>
References: <173498939893.2293042.8029858406528247316.stgit@frogsfrogsfrogs>
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

