Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39099441
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719883189; cv=none; b=p9ban4xz6w76MU3IzDaAcewAfbSet0YLA/sLMuPTqZNzcodhkaTRbxuH9yzkNapj0zRxl032DxOBwg+DnhUk9oW/uovsz0kZCVRRIETk1yeua6tmtcXmHfUAVVvBP6vMlShtZWfVTZQOLUM2QjbCiwG1JzagJaAw3DeqgF3m1Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719883189; c=relaxed/simple;
	bh=GcRYYGFQXLN5/jlpOA6ICl2ZgWjE1tbYwSZ+wRhGnwI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RgZtxBdOGTe4CfrC/6fb86DY2T3XPhFaTCkpd7z6qJTKvEyT20TbO42veFh9o2277mKohqBi71lX2OI7knqPanr2htpMuo+jBIwnOzXdgGg9ng0BdowzjQGi6Q8dQfMrBlJ1mJH//3THrcNa/1IcCssgf3P+0Y3XP+d1lpEHbRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PrCIFJmn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PrCIFJmn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 727A7C2BD10;
	Tue,  2 Jul 2024 01:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719883189;
	bh=GcRYYGFQXLN5/jlpOA6ICl2ZgWjE1tbYwSZ+wRhGnwI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PrCIFJmnbymZg31vf3/hpAx6ZQCBv7rboJ9CFXP3+Bb1PfGzUY+zO6GULxaEzOJPz
	 XlXhI96B6u8atCPFBd0MHKrTsX0hras2v52y5PsAQStd0OvsjnC0ilqAwLvPprRLt0
	 G7F7J+8/+9/OwkbVCnvJ1lDUSc/IRVD7Q7lXZ2iTnjJW0NaE/xE+SFf+Dr5b23HxpV
	 +iTAya6SZjb80Do/QWzLbnXTtjTaTNwu5Lt3l/7ctcsMTYezuoGtsijGV8CNat4Aby
	 X0Y6v+r1wdCXrKhbKn8F3vceSFDDbuepg4ueoV9Ln3iZwm4WYjCn9PGarPEEfRfQG/
	 j1PwL63Ge6s1g==
Date: Mon, 01 Jul 2024 18:19:49 -0700
Subject: [PATCH 09/12] xfs_repair: check parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com, hch@lst.de
Message-ID: <171988122305.2010218.16086560804318113038.stgit@frogsfrogsfrogs>
In-Reply-To: <171988122147.2010218.8997075209577453030.stgit@frogsfrogsfrogs>
References: <171988122147.2010218.8997075209577453030.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Use the parent pointer index that we constructed in the previous patch
to check that each file's parent pointer records exactly match the
directory entries that we recorded while walking directory entries.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfblob.c    |    9 +
 libxfs/xfblob.h    |    2 
 repair/Makefile    |    2 
 repair/listxattr.c |  271 +++++++++++++++++
 repair/listxattr.h |   15 +
 repair/phase6.c    |    2 
 repair/pptr.c      |  846 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 repair/pptr.h      |    2 
 8 files changed, 1149 insertions(+)
 create mode 100644 repair/listxattr.c
 create mode 100644 repair/listxattr.h


diff --git a/libxfs/xfblob.c b/libxfs/xfblob.c
index 7d8caaa4c164..00f8ed5e5a7b 100644
--- a/libxfs/xfblob.c
+++ b/libxfs/xfblob.c
@@ -145,3 +145,12 @@ xfblob_free(
 	xfile_discard(blob->xfile, cookie, sizeof(key) + key.xb_size);
 	return 0;
 }
+
+/* Drop all the blobs. */
+void
+xfblob_truncate(
+	struct xfblob	*blob)
+{
+	xfile_discard(blob->xfile, PAGE_SIZE, blob->last_offset - PAGE_SIZE);
+	blob->last_offset = PAGE_SIZE;
+}
diff --git a/libxfs/xfblob.h b/libxfs/xfblob.h
index 28bf4ab2898f..1939202e12db 100644
--- a/libxfs/xfblob.h
+++ b/libxfs/xfblob.h
@@ -21,4 +21,6 @@ int xfblob_store(struct xfblob *blob, xfblob_cookie *cookie, const void *ptr,
 		uint32_t size);
 int xfblob_free(struct xfblob *blob, xfblob_cookie cookie);
 
+void xfblob_truncate(struct xfblob *blob);
+
 #endif /* __XFS_SCRUB_XFBLOB_H__ */
diff --git a/repair/Makefile b/repair/Makefile
index a36a95e353a5..e7445d53e918 100644
--- a/repair/Makefile
+++ b/repair/Makefile
@@ -24,6 +24,7 @@ HFILES = \
 	err_protos.h \
 	globals.h \
 	incore.h \
+	listxattr.h \
 	pptr.h \
 	prefetch.h \
 	progress.h \
@@ -58,6 +59,7 @@ CFILES = \
 	incore_ext.c \
 	incore_ino.c \
 	init.c \
+	listxattr.c \
 	phase1.c \
 	phase2.c \
 	phase3.c \
diff --git a/repair/listxattr.c b/repair/listxattr.c
new file mode 100644
index 000000000000..2af77b7b2195
--- /dev/null
+++ b/repair/listxattr.c
@@ -0,0 +1,271 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "libxfs.h"
+#include "libxlog.h"
+#include "libfrog/bitmap.h"
+#include "repair/listxattr.h"
+
+/* Call a function for every entry in a shortform xattr structure. */
+STATIC int
+xattr_walk_sf(
+	struct xfs_inode		*ip,
+	xattr_walk_fn			attr_fn,
+	void				*priv)
+{
+	struct xfs_attr_sf_hdr		*hdr = ip->i_af.if_data;
+	struct xfs_attr_sf_entry	*sfe;
+	unsigned int			i;
+	int				error;
+
+	sfe = libxfs_attr_sf_firstentry(hdr);
+	for (i = 0; i < hdr->count; i++) {
+		error = attr_fn(ip, sfe->flags, sfe->nameval, sfe->namelen,
+				&sfe->nameval[sfe->namelen], sfe->valuelen,
+				priv);
+		if (error)
+			return error;
+
+		sfe = xfs_attr_sf_nextentry(sfe);
+	}
+
+	return 0;
+}
+
+/* Call a function for every entry in this xattr leaf block. */
+STATIC int
+xattr_walk_leaf_entries(
+	struct xfs_inode		*ip,
+	xattr_walk_fn			attr_fn,
+	struct xfs_buf			*bp,
+	void				*priv)
+{
+	struct xfs_attr3_icleaf_hdr	ichdr;
+	struct xfs_mount		*mp = ip->i_mount;
+	struct xfs_attr_leafblock	*leaf = bp->b_addr;
+	struct xfs_attr_leaf_entry	*entry;
+	unsigned int			i;
+	int				error;
+
+	libxfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &ichdr, leaf);
+	entry = xfs_attr3_leaf_entryp(leaf);
+
+	for (i = 0; i < ichdr.count; entry++, i++) {
+		void			*value;
+		unsigned char		*name;
+		unsigned int		namelen, valuelen;
+
+		if (entry->flags & XFS_ATTR_LOCAL) {
+			struct xfs_attr_leaf_name_local		*name_loc;
+
+			name_loc = xfs_attr3_leaf_name_local(leaf, i);
+			name = name_loc->nameval;
+			namelen = name_loc->namelen;
+			value = &name_loc->nameval[name_loc->namelen];
+			valuelen = be16_to_cpu(name_loc->valuelen);
+		} else {
+			struct xfs_attr_leaf_name_remote	*name_rmt;
+
+			name_rmt = xfs_attr3_leaf_name_remote(leaf, i);
+			name = name_rmt->name;
+			namelen = name_rmt->namelen;
+			value = NULL;
+			valuelen = be32_to_cpu(name_rmt->valuelen);
+		}
+
+		error = attr_fn(ip, entry->flags, name, namelen, value,
+				valuelen, priv);
+		if (error)
+			return error;
+
+	}
+
+	return 0;
+}
+
+/*
+ * Call a function for every entry in a leaf-format xattr structure.  Avoid
+ * memory allocations for the loop detector since there's only one block.
+ */
+STATIC int
+xattr_walk_leaf(
+	struct xfs_inode		*ip,
+	xattr_walk_fn			attr_fn,
+	void				*priv)
+{
+	struct xfs_buf			*leaf_bp;
+	int				error;
+
+	error = -libxfs_attr3_leaf_read(NULL, ip, ip->i_ino, 0, &leaf_bp);
+	if (error)
+		return error;
+
+	error = xattr_walk_leaf_entries(ip, attr_fn, leaf_bp, priv);
+	libxfs_trans_brelse(NULL, leaf_bp);
+	return error;
+}
+
+/* Find the leftmost leaf in the xattr dabtree. */
+STATIC int
+xattr_walk_find_leftmost_leaf(
+	struct xfs_inode		*ip,
+	struct bitmap			*seen_blocks,
+	struct xfs_buf			**leaf_bpp)
+{
+	struct xfs_da3_icnode_hdr	nodehdr;
+	struct xfs_mount		*mp = ip->i_mount;
+	struct xfs_da_intnode		*node;
+	struct xfs_da_node_entry	*btree;
+	struct xfs_buf			*bp;
+	//xfs_failaddr_t			fa;
+	xfs_dablk_t			blkno = 0;
+	unsigned int			expected_level = 0;
+	int				error;
+
+	for (;;) {
+		uint16_t		magic;
+
+		error = -libxfs_da3_node_read(NULL, ip, blkno, &bp,
+				XFS_ATTR_FORK);
+		if (error)
+			return error;
+
+		node = bp->b_addr;
+		magic = be16_to_cpu(node->hdr.info.magic);
+		if (magic == XFS_ATTR_LEAF_MAGIC ||
+		    magic == XFS_ATTR3_LEAF_MAGIC)
+			break;
+
+		error = EFSCORRUPTED;
+		if (magic != XFS_DA_NODE_MAGIC &&
+		    magic != XFS_DA3_NODE_MAGIC)
+			goto out_buf;
+
+		libxfs_da3_node_hdr_from_disk(mp, &nodehdr, node);
+
+		if (nodehdr.count == 0 || nodehdr.level >= XFS_DA_NODE_MAXDEPTH)
+			goto out_buf;
+
+		/* Check the level from the root node. */
+		if (blkno == 0)
+			expected_level = nodehdr.level - 1;
+		else if (expected_level != nodehdr.level)
+			goto out_buf;
+		else
+			expected_level--;
+
+		/* Remember that we've seen this node. */
+		error = -bitmap_set(seen_blocks, blkno, 1);
+		if (error)
+			goto out_buf;
+
+		/* Find the next level towards the leaves of the dabtree. */
+		btree = nodehdr.btree;
+		blkno = be32_to_cpu(btree->before);
+		libxfs_trans_brelse(NULL, bp);
+
+		/* Make sure we haven't seen this new block already. */
+		if (bitmap_test(seen_blocks, blkno, 1))
+			return EFSCORRUPTED;
+	}
+
+	error = EFSCORRUPTED;
+	if (expected_level != 0)
+		goto out_buf;
+
+	/* Remember that we've seen this leaf. */
+	error = -bitmap_set(seen_blocks, blkno, 1);
+	if (error)
+		goto out_buf;
+
+	*leaf_bpp = bp;
+	return 0;
+
+out_buf:
+	libxfs_trans_brelse(NULL, bp);
+	return error;
+}
+
+/* Call a function for every entry in a node-format xattr structure. */
+STATIC int
+xattr_walk_node(
+	struct xfs_inode		*ip,
+	xattr_walk_fn			attr_fn,
+	void				*priv)
+{
+	struct xfs_attr3_icleaf_hdr	leafhdr;
+	struct bitmap			*seen_blocks;
+	struct xfs_mount		*mp = ip->i_mount;
+	struct xfs_attr_leafblock	*leaf;
+	struct xfs_buf			*leaf_bp;
+	int				error;
+
+	bitmap_alloc(&seen_blocks);
+
+	error = xattr_walk_find_leftmost_leaf(ip, seen_blocks, &leaf_bp);
+	if (error)
+		goto out_bitmap;
+
+	for (;;) {
+		error = xattr_walk_leaf_entries(ip, attr_fn, leaf_bp,
+				priv);
+		if (error)
+			goto out_leaf;
+
+		/* Find the right sibling of this leaf block. */
+		leaf = leaf_bp->b_addr;
+		libxfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, leaf);
+		if (leafhdr.forw == 0)
+			goto out_leaf;
+
+		libxfs_trans_brelse(NULL, leaf_bp);
+
+		/* Make sure we haven't seen this new leaf already. */
+		if (bitmap_test(seen_blocks, leafhdr.forw, 1))
+			goto out_bitmap;
+
+		error = -libxfs_attr3_leaf_read(NULL, ip, ip->i_ino,
+				leafhdr.forw, &leaf_bp);
+		if (error)
+			goto out_bitmap;
+
+		/* Remember that we've seen this new leaf. */
+		error = -bitmap_set(seen_blocks, leafhdr.forw, 1);
+		if (error)
+			goto out_leaf;
+	}
+
+out_leaf:
+	libxfs_trans_brelse(NULL, leaf_bp);
+out_bitmap:
+	bitmap_free(&seen_blocks);
+	return error;
+}
+
+/* Call a function for every extended attribute in a file. */
+int
+xattr_walk(
+	struct xfs_inode	*ip,
+	xattr_walk_fn		attr_fn,
+	void			*priv)
+{
+	int			error;
+
+	if (!libxfs_inode_hasattr(ip))
+		return 0;
+
+	if (ip->i_af.if_format == XFS_DINODE_FMT_LOCAL)
+		return xattr_walk_sf(ip, attr_fn, priv);
+
+	/* attr functions require that the attr fork is loaded */
+	error = -libxfs_iread_extents(NULL, ip, XFS_ATTR_FORK);
+	if (error)
+		return error;
+
+	if (libxfs_attr_is_leaf(ip))
+		return xattr_walk_leaf(ip, attr_fn, priv);
+
+	return xattr_walk_node(ip, attr_fn, priv);
+}
diff --git a/repair/listxattr.h b/repair/listxattr.h
new file mode 100644
index 000000000000..2d26fce0f323
--- /dev/null
+++ b/repair/listxattr.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __REPAIR_LISTXATTR_H__
+#define __REPAIR_LISTXATTR_H__
+
+typedef int (*xattr_walk_fn)(struct xfs_inode *ip, unsigned int attr_flags,
+		const unsigned char *name, unsigned int namelen,
+		const void *value, unsigned int valuelen, void *priv);
+
+int xattr_walk(struct xfs_inode *ip, xattr_walk_fn attr_fn, void *priv);
+
+#endif /* __REPAIR_LISTXATTR_H__ */
diff --git a/repair/phase6.c b/repair/phase6.c
index fe56feb6ecef..ad067ba0ac87 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -3445,5 +3445,7 @@ _("        - resetting contents of realtime bitmap and summary inodes\n"));
 		}
 	}
 
+	/* Check and repair directory parent pointers, if enabled. */
+	check_parent_ptrs(mp);
 	parent_ptr_free(mp);
 }
diff --git a/repair/pptr.c b/repair/pptr.c
index f8db57b2c6f6..bd9bb6f8bf36 100644
--- a/repair/pptr.c
+++ b/repair/pptr.c
@@ -7,8 +7,13 @@
 #include "libxfs/xfile.h"
 #include "libxfs/xfblob.h"
 #include "libfrog/platform.h"
+#include "libfrog/workqueue.h"
+#include "repair/globals.h"
 #include "repair/err_protos.h"
 #include "repair/slab.h"
+#include "repair/listxattr.h"
+#include "repair/threads.h"
+#include "repair/incore.h"
 #include "repair/pptr.h"
 #include "repair/strblobs.h"
 
@@ -62,6 +67,65 @@
  * to strings, which means that we can use the name cookie as a comparison key
  * instead of loading the full dentry name every time we want to perform a
  * comparison.
+ *
+ * Once we've finished with the forward scan, we get to work on the backwards
+ * scan.  Each AG is processed independently.  First, we sort the per-AG master
+ * records in order of child_agino, dir_ino, and name_cookie.  Each inode in
+ * the AG is then processed in numerical order.
+ *
+ * The first thing that happens to the file is that we read all the extended
+ * attributes to look for parent pointers.  Attributes that claim to be parent
+ * pointers but are obviously garbage are thrown away.  The rest of the ondisk
+ * parent pointers for that file are stored in memory like this:
+ *
+ *     (dir_ino*, dir_gen, name_cookie*)
+ *
+ * After loading the ondisk parent pointer name, we search the strblobs
+ * structure to see if it has already recorded the name.  If so, this value is
+ * used as the name cookie.  If the name has not yet been recorded, we flag the
+ * incore record for later deletion.
+ *
+ * When we've concluded the xattr scan, the per-file records are sorted in
+ * order of dir_ino and name_cookie.
+ *
+ * There are three possibilities here:
+ *
+ * A. The first record in the per-AG master index is an exact match for the
+ * first record in the per-file index.  Everything is consistent, and we can
+ * proceed with the lockstep scan detailed below.
+ *
+ * B. The per-AG master index cursor points to a higher inode number than the
+ * first inode we are scanning.  Delete the ondisk parent pointers
+ * corresponding to the per-file records until condition (B) is no longer true.
+ *
+ * C. The per-AG master index cursor instead points to a lower inode number
+ * than the one we are scanning.  This means that there exists a directory
+ * entry pointing at an inode that is free.  We supposedly already settled
+ * which inodes are free and which aren't, which means in-memory information is
+ * inconsistent.  Abort.
+ *
+ * Otherwise, we are ready to check the file parent pointers against the
+ * master.  If the ondisk directory metadata are all consistent, this recordset
+ * should correspond exactly to the subset of the master records with a
+ * child_agino matching the file that we're scanning.  We should be able to
+ * walk both sets in lockstep, and find one of the following outcomes:
+ *
+ * 1) The master index cursor is ahead of the ondisk index cursor.  This means
+ * that the inode has parent pointers that were not found during the dirent
+ * scan.  These should be deleted.
+ *
+ * 2) The ondisk index gets ahead of the master index.  This means that the
+ * dirent scan found parent pointers that are not attached to the inode.
+ * These should be added.
+ *
+ * 3) The parent_gen or (dirent) name are not consistent.  Update the parent
+ * pointer to the values that we found during the dirent scan.
+ *
+ * 4) Everything matches.  Move on to the next parent pointer.
+ *
+ * The current implementation does not try to rebuild directories from parent
+ * pointer information, as this requires a lengthy scan of the filesystem for
+ * each broken directory.
  */
 
 struct ag_pptr {
@@ -88,6 +152,24 @@ struct ag_pptr {
 /* This might be a duplicate due to dotdot reprocessing */
 #define AG_PPTR_POSSIBLE_DUP	(1U << 0)
 
+struct file_pptr {
+	/* parent directory handle */
+	xfs_ino_t		parent_ino;
+	uint32_t		parent_gen;
+
+	/* Is the name stored in the global nameblobs structure? */
+	unsigned int		name_in_nameblobs;
+
+	/* hash of the dirent name */
+	xfs_dahash_t		namehash;
+
+	/* parent pointer name length */
+	unsigned int		namelen;
+
+	/* cookie for the file dirent name */
+	xfblob_cookie		name_cookie;
+};
+
 struct ag_pptrs {
 	/* Lock to protect pptr_recs during the dirent scan. */
 	pthread_mutex_t		lock;
@@ -96,11 +178,99 @@ struct ag_pptrs {
 	struct xfs_slab		*pptr_recs;
 };
 
+struct file_scan {
+	struct ag_pptrs		*ag_pptrs;
+
+	/* cursor for comparing ag_pptrs.pptr_recs against file_pptrs_recs */
+	struct xfs_slab_cursor	*ag_pptr_recs_cur;
+
+	/* xfs_parent_rec records for a file that we're checking */
+	struct xfs_slab		*file_pptr_recs;
+
+	/* cursor for comparing file_pptr_recs against pptrs_recs */
+	struct xfs_slab_cursor	*file_pptr_recs_cur;
+
+	/* names associated with file_pptr_recs */
+	struct xfblob		*file_pptr_names;
+
+	/* Number of parent pointers recorded for this file. */
+	unsigned int		nr_file_pptrs;
+
+	/* Does this file have garbage xattrs with ATTR_PARENT set? */
+	bool			have_garbage;
+};
+
 /* Global names storage file. */
 static struct strblobs	*nameblobs;
 static pthread_mutex_t	names_mutex = PTHREAD_MUTEX_INITIALIZER;
 static struct ag_pptrs	*fs_pptrs;
 
+static int
+cmp_ag_pptr(
+	const void		*a,
+	const void		*b)
+{
+	const struct ag_pptr	*pa = a;
+	const struct ag_pptr	*pb = b;
+
+	if (pa->child_agino < pb->child_agino)
+		return -1;
+	if (pa->child_agino > pb->child_agino)
+		return 1;
+
+	if (pa->parent_ino < pb->parent_ino)
+		return -1;
+	if (pa->parent_ino > pb->parent_ino)
+		return 1;
+
+	if (pa->namehash < pb->namehash)
+		return -1;
+	if (pa->namehash > pb->namehash)
+		return 1;
+
+	if (pa->name_cookie < pb->name_cookie)
+		return -1;
+	if (pa->name_cookie > pb->name_cookie)
+		return 1;
+
+	return 0;
+}
+
+static int
+cmp_file_pptr(
+	const void		*a,
+	const void		*b)
+{
+	const struct file_pptr	*pa = a;
+	const struct file_pptr	*pb = b;
+
+	if (pa->parent_ino < pb->parent_ino)
+		return -1;
+	if (pa->parent_ino > pb->parent_ino)
+		return 1;
+
+	/*
+	 * Push the parent pointer names that we didn't find in the dirent scan
+	 * towards the end of the list so that we delete them as excess.
+	 */
+	if (!pa->name_in_nameblobs && pb->name_in_nameblobs)
+		return 1;
+	if (pa->name_in_nameblobs && !pb->name_in_nameblobs)
+		return -1;
+
+	if (pa->namehash < pb->namehash)
+		return -1;
+	if (pa->namehash > pb->namehash)
+		return 1;
+
+	if (pa->name_cookie < pb->name_cookie)
+		return -1;
+	if (pa->name_cookie > pb->name_cookie)
+		return 1;
+
+	return 0;
+}
+
 void
 parent_ptr_free(
 	struct xfs_mount	*mp)
@@ -221,3 +391,679 @@ add_parent_ptr(
 			(unsigned long long)ino,
 			(unsigned long long)ag_pptr.name_cookie);
 }
+
+/* Schedule this ATTR_PARENT extended attribute for deletion. */
+static void
+record_garbage_xattr(
+	struct xfs_inode	*ip,
+	struct file_scan	*fscan,
+	unsigned int		attr_filter,
+	const unsigned char	*name,
+	unsigned int		namelen,
+	const void		*value,
+	unsigned int		valuelen)
+{
+	if (no_modify) {
+		if (!fscan->have_garbage)
+			do_warn(
+ _("would delete garbage parent pointer extended attributes in ino %llu\n"),
+					(unsigned long long)ip->i_ino);
+		fscan->have_garbage = true;
+		return;
+	}
+
+	if (fscan->have_garbage)
+		return;
+	fscan->have_garbage = true;
+
+	do_warn(
+ _("deleting garbage parent pointer extended attributes in ino %llu\n"),
+			(unsigned long long)ip->i_ino);
+	/* XXX do the work */
+}
+
+/*
+ * Store this file parent pointer's name in the file scan namelist unless it's
+ * already in the global list.
+ */
+static int
+store_file_pptr_name(
+	struct file_scan		*fscan,
+	struct file_pptr		*file_pptr,
+	const struct xfs_name		*xname)
+{
+	int				error;
+
+	error = strblobs_lookup(nameblobs, &file_pptr->name_cookie,
+			xname->name, xname->len, file_pptr->namehash);
+	if (!error) {
+		file_pptr->name_in_nameblobs = true;
+		return 0;
+	}
+	if (error != ENOENT)
+		return error;
+
+	file_pptr->name_in_nameblobs = false;
+	return -xfblob_store(fscan->file_pptr_names, &file_pptr->name_cookie,
+			xname->name, xname->len);
+}
+
+/* Decide if this is a directory parent pointer and stash it if so. */
+static int
+examine_xattr(
+	struct xfs_inode	*ip,
+	unsigned int		attr_flags,
+	const unsigned char	*name,
+	unsigned int		namelen,
+	const void		*value,
+	unsigned int		valuelen,
+	void			*priv)
+{
+	struct file_pptr	file_pptr = {
+		.namelen	= namelen,
+	};
+	struct xfs_name		xname = {
+		.name		= name,
+		.len		= namelen,
+	};
+	struct xfs_mount	*mp = ip->i_mount;
+	struct file_scan	*fscan = priv;
+	int			error;
+
+	if (!(attr_flags & XFS_ATTR_PARENT))
+		return 0;
+
+	error = -libxfs_parent_from_attr(mp, attr_flags, name, namelen, value,
+			valuelen, &file_pptr.parent_ino, &file_pptr.parent_gen);
+	if (error)
+		goto corrupt;
+
+	file_pptr.namehash = libxfs_dir2_hashname(mp, &xname);
+
+	error = store_file_pptr_name(fscan, &file_pptr, &xname);
+	if (error)
+		do_error(
+ _("storing ino %llu parent pointer '%.*s' failed: %s\n"),
+				(unsigned long long)ip->i_ino,
+				namelen,
+				(const char *)name,
+				strerror(error));
+
+	error = -slab_add(fscan->file_pptr_recs, &file_pptr);
+	if (error)
+		do_error(_("storing ino %llu parent pointer rec failed: %s\n"),
+				(unsigned long long)ip->i_ino,
+				strerror(error));
+
+	dbg_printf(
+ _("%s: dp %llu gen 0x%x fname '%.*s' namelen %u namehash 0x%x ino %llu namecookie 0x%llx global? %d\n"),
+			__func__,
+			(unsigned long long)file_pptr.parent_ino,
+			file_pptr.parent_gen,
+			namelen,
+			(const char *)name,
+			namelen,
+			file_pptr.namehash,
+			(unsigned long long)ip->i_ino,
+			(unsigned long long)file_pptr.name_cookie,
+			file_pptr.name_in_nameblobs);
+
+	fscan->nr_file_pptrs++;
+	return 0;
+corrupt:
+	record_garbage_xattr(ip, fscan, attr_flags, name, namelen, value,
+			valuelen);
+	return 0;
+}
+
+/* Load a file parent pointer name from wherever we stored it. */
+static int
+load_file_pptr_name(
+	struct file_scan	*fscan,
+	const struct file_pptr	*file_pptr,
+	unsigned char		*name)
+{
+	if (file_pptr->name_in_nameblobs)
+		return strblobs_load(nameblobs, file_pptr->name_cookie,
+				name, file_pptr->namelen);
+
+	return -xfblob_load(fscan->file_pptr_names, file_pptr->name_cookie,
+			name, file_pptr->namelen);
+}
+
+/* Remove all pptrs from @ip. */
+static void
+clear_all_pptrs(
+	struct xfs_inode	*ip)
+{
+	if (no_modify) {
+		do_warn(_("would delete unlinked ino %llu parent pointers\n"),
+				(unsigned long long)ip->i_ino);
+		return;
+	}
+
+	do_warn(_("deleting unlinked ino %llu parent pointers\n"),
+			(unsigned long long)ip->i_ino);
+	/* XXX actually do the work */
+}
+
+/* Add @ag_pptr to @ip. */
+static void
+add_missing_parent_ptr(
+	struct xfs_inode	*ip,
+	struct file_scan	*fscan,
+	const struct ag_pptr	*ag_pptr)
+{
+	unsigned char		name[MAXNAMELEN];
+	int			error;
+
+	error = strblobs_load(nameblobs, ag_pptr->name_cookie, name,
+			ag_pptr->namelen);
+	if (error)
+		do_error(
+ _("loading missing name for ino %llu parent pointer (ino %llu gen 0x%x namecookie 0x%llx) failed: %s\n"),
+				(unsigned long long)ip->i_ino,
+				(unsigned long long)ag_pptr->parent_ino,
+				ag_pptr->parent_gen,
+				(unsigned long long)ag_pptr->name_cookie,
+				strerror(error));
+
+	if (no_modify) {
+		do_warn(
+ _("would add missing ino %llu parent pointer (ino %llu gen 0x%x name '%.*s')\n"),
+				(unsigned long long)ip->i_ino,
+				(unsigned long long)ag_pptr->parent_ino,
+				ag_pptr->parent_gen,
+				ag_pptr->namelen,
+				name);
+		return;
+	} else {
+		do_warn(
+ _("adding missing ino %llu parent pointer (ino %llu gen 0x%x name '%.*s')\n"),
+				(unsigned long long)ip->i_ino,
+				(unsigned long long)ag_pptr->parent_ino,
+				ag_pptr->parent_gen,
+				ag_pptr->namelen,
+				name);
+	}
+
+	/* XXX actually do the work */
+}
+
+/* Remove @file_pptr from @ip. */
+static void
+remove_incorrect_parent_ptr(
+	struct xfs_inode	*ip,
+	struct file_scan	*fscan,
+	const struct file_pptr	*file_pptr)
+{
+	unsigned char		name[MAXNAMELEN] = { };
+	int			error;
+
+	error = load_file_pptr_name(fscan, file_pptr, name);
+	if (error)
+		do_error(
+ _("loading incorrect name for ino %llu parent pointer (ino %llu gen 0x%x namecookie 0x%llx) failed: %s\n"),
+				(unsigned long long)ip->i_ino,
+				(unsigned long long)file_pptr->parent_ino,
+				file_pptr->parent_gen,
+				(unsigned long long)file_pptr->name_cookie,
+				strerror(error));
+
+	if (no_modify) {
+		do_warn(
+ _("would remove bad ino %llu parent pointer (ino %llu gen 0x%x name '%.*s')\n"),
+				(unsigned long long)ip->i_ino,
+				(unsigned long long)file_pptr->parent_ino,
+				file_pptr->parent_gen,
+				file_pptr->namelen,
+				name);
+		return;
+	}
+
+	do_warn(
+ _("removing bad ino %llu parent pointer (ino %llu gen 0x%x name '%.*s')\n"),
+			(unsigned long long)ip->i_ino,
+			(unsigned long long)file_pptr->parent_ino,
+			file_pptr->parent_gen,
+			file_pptr->namelen,
+			name);
+
+	/* XXX actually do the work */
+}
+
+/*
+ * We found parent pointers that point to the same inode and directory offset.
+ * Make sure they have the same generation number and dirent name.
+ */
+static void
+compare_parent_ptrs(
+	struct xfs_inode	*ip,
+	struct file_scan	*fscan,
+	const struct ag_pptr	*ag_pptr,
+	const struct file_pptr	*file_pptr)
+{
+	unsigned char		name1[MAXNAMELEN] = { };
+	unsigned char		name2[MAXNAMELEN] = { };
+	int			error;
+
+	error = strblobs_load(nameblobs, ag_pptr->name_cookie, name1,
+			ag_pptr->namelen);
+	if (error)
+		do_error(
+ _("loading master-list name for ino %llu parent pointer (ino %llu gen 0x%x namecookie 0x%llx namelen %u) failed: %s\n"),
+				(unsigned long long)ip->i_ino,
+				(unsigned long long)ag_pptr->parent_ino,
+				ag_pptr->parent_gen,
+				(unsigned long long)ag_pptr->name_cookie,
+				ag_pptr->namelen,
+				strerror(error));
+
+	error = load_file_pptr_name(fscan, file_pptr, name2);
+	if (error)
+		do_error(
+ _("loading file-list name for ino %llu parent pointer (ino %llu gen 0x%x namecookie 0x%llx namelen %u) failed: %s\n"),
+				(unsigned long long)ip->i_ino,
+				(unsigned long long)file_pptr->parent_ino,
+				file_pptr->parent_gen,
+				(unsigned long long)file_pptr->name_cookie,
+				ag_pptr->namelen,
+				strerror(error));
+
+	if (ag_pptr->parent_gen != file_pptr->parent_gen)
+		goto reset;
+	if (ag_pptr->namelen != file_pptr->namelen)
+		goto reset;
+	if (ag_pptr->namehash != file_pptr->namehash)
+		goto reset;
+	if (memcmp(name1, name2, ag_pptr->namelen))
+		goto reset;
+
+	return;
+
+reset:
+	if (no_modify) {
+		do_warn(
+ _("would update ino %llu parent pointer (ino %llu gen 0x%x name '%.*s') -> (ino %llu gen 0x%x name '%.*s')\n"),
+				(unsigned long long)ip->i_ino,
+				(unsigned long long)file_pptr->parent_ino,
+				file_pptr->parent_gen,
+				file_pptr->namelen,
+				name2,
+				(unsigned long long)ag_pptr->parent_ino,
+				ag_pptr->parent_gen,
+				ag_pptr->namelen,
+				name1);
+		return;
+	}
+
+	do_warn(
+ _("updating ino %llu parent pointer (ino %llu gen 0x%x name '%.*s') -> (ino %llu gen 0x%x name '%.*s')\n"),
+			(unsigned long long)ip->i_ino,
+			(unsigned long long)file_pptr->parent_ino,
+			file_pptr->parent_gen,
+			file_pptr->namelen,
+			name2,
+			(unsigned long long)ag_pptr->parent_ino,
+			ag_pptr->parent_gen,
+			ag_pptr->namelen,
+			name1);
+
+	/* XXX do the work */
+}
+
+static int
+cmp_file_to_ag_pptr(
+	const struct file_pptr	*fp,
+	const struct ag_pptr	*ap)
+{
+	/*
+	 * We finished iterating all the pptrs attached to the file before we
+	 * ran out of pptrs that we found in the directory scan.  Return 1 so
+	 * the caller adds the pptr from the dir scan.
+	 */
+	if (!fp)
+		return 1;
+
+	if (fp->parent_ino > ap->parent_ino)
+		return 1;
+	if (fp->parent_ino < ap->parent_ino)
+		return -1;
+
+	if (fp->namehash < ap->namehash)
+		return -1;
+	if (fp->namehash > ap->namehash)
+		return 1;
+
+	/*
+	 * If this parent pointer wasn't found in the dirent scan, we know it
+	 * should be removed.
+	 */
+	if (!fp->name_in_nameblobs)
+		return -1;
+
+	if (fp->name_cookie < ap->name_cookie)
+		return -1;
+	if (fp->name_cookie > ap->name_cookie)
+		return 1;
+
+	return 0;
+}
+
+/*
+ * If this parent pointer that we got via directory scan thinks it might be a
+ * duplicate, compare it to the previous pptr found by the directory scan.  If
+ * they are the same, then we got duplicate entries on account of dotdot
+ * reprocessing and we can ignore this one.
+ */
+static inline bool
+crosscheck_want_skip_dup(
+	const struct ag_pptr	*ag_pptr,
+	const struct ag_pptr	*prev_ag_pptr)
+{
+	if (!(ag_pptr->flags & AG_PPTR_POSSIBLE_DUP) || !prev_ag_pptr)
+		return false;
+
+	if (ag_pptr->parent_ino  == prev_ag_pptr->parent_ino &&
+	    ag_pptr->parent_gen  == prev_ag_pptr->parent_gen &&
+	    ag_pptr->namelen     == prev_ag_pptr->namelen &&
+	    ag_pptr->name_cookie == prev_ag_pptr->name_cookie &&
+	    ag_pptr->child_agino == prev_ag_pptr->child_agino)
+		return true;
+
+	return false;
+}
+
+/*
+ * Make sure that the parent pointers we observed match the ones ondisk.
+ *
+ * Earlier, we generated a master list of parent pointers for files in this AG
+ * based on what we saw during the directory walk at the start of phase 6.
+ * Now that we've read in all of this file's parent pointers, make sure the
+ * lists match.
+ */
+static void
+crosscheck_file_parent_ptrs(
+	struct xfs_inode	*ip,
+	struct file_scan	*fscan)
+{
+	struct ag_pptr		*ag_pptr, *prev_ag_pptr = NULL;
+	struct file_pptr	*file_pptr;
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
+	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
+	int			error;
+
+	ag_pptr = peek_slab_cursor(fscan->ag_pptr_recs_cur);
+
+	if (!ag_pptr || ag_pptr->child_agino > agino) {
+		/*
+		 * The cursor for the master pptr list has gone beyond this
+		 * file that we're scanning.  Evidently it has no parents at
+		 * all, so we better not have found any pptrs attached to the
+		 * file.
+		 */
+		if (fscan->nr_file_pptrs > 0)
+			clear_all_pptrs(ip);
+
+		return;
+	}
+
+	if (ag_pptr->child_agino < agino) {
+		/*
+		 * The cursor for the master pptr list is behind the file that
+		 * we're scanning.  This suggests that the incore inode tree
+		 * doesn't know about a file that is mentioned by a dirent.
+		 * At this point the inode liveness is supposed to be settled,
+		 * which means our incore information is inconsistent.
+		 */
+		do_error(
+ _("found dirent referring to ino %llu even though inobt scan moved on to ino %llu?!\n"),
+				(unsigned long long)XFS_AGINO_TO_INO(mp, agno,
+					ag_pptr->child_agino),
+				(unsigned long long)ip->i_ino);
+		/* does not return */
+	}
+
+	/*
+	 * The master pptr list cursor is pointing to the inode that we want
+	 * to check.  Sort the pptr records that we recorded from the ondisk
+	 * pptrs for this file, then set up for the comparison.
+	 */
+	qsort_slab(fscan->file_pptr_recs, cmp_file_pptr);
+
+	error = -init_slab_cursor(fscan->file_pptr_recs, cmp_file_pptr,
+			&fscan->file_pptr_recs_cur);
+	if (error)
+		do_error(_("init ino %llu parent pointer cursor failed: %s\n"),
+				(unsigned long long)ip->i_ino, strerror(error));
+
+	do {
+		int	cmp_result;
+
+		if (crosscheck_want_skip_dup(ag_pptr, prev_ag_pptr)) {
+			/*
+			 * This master parent pointer thinks it's a duplicate
+			 * and it matches the previous master parent pointer.
+			 * We don't want to add duplicate parent pointers, so
+			 * advance the master pptr cursor and loop again.
+			 */
+			dbg_printf(
+ _("%s: dp %llu dp_gen 0x%x namelen %u ino %llu namecookie 0x%llx (skip_dup)\n"),
+					__func__,
+					(unsigned long long)ag_pptr->parent_ino,
+					ag_pptr->parent_gen,
+					ag_pptr->namelen,
+					(unsigned long long)ip->i_ino,
+					(unsigned long long)ag_pptr->name_cookie);
+			prev_ag_pptr = ag_pptr;
+			advance_slab_cursor(fscan->ag_pptr_recs_cur);
+			ag_pptr = peek_slab_cursor(fscan->ag_pptr_recs_cur);
+			continue;
+		}
+		prev_ag_pptr = ag_pptr;
+
+		file_pptr = peek_slab_cursor(fscan->file_pptr_recs_cur);
+
+		dbg_printf(
+ _("%s: dp %llu dp_gen 0x%x namelen %u ino %llu namecookie 0x%llx (master)\n"),
+				__func__,
+				(unsigned long long)ag_pptr->parent_ino,
+				ag_pptr->parent_gen,
+				ag_pptr->namelen,
+				(unsigned long long)ip->i_ino,
+				(unsigned long long)ag_pptr->name_cookie);
+
+		if (file_pptr) {
+			dbg_printf(
+ _("%s: dp %llu dp_gen 0x%x namelen %u ino %llu namecookie 0x%llx (file)\n"),
+					__func__,
+					(unsigned long long)file_pptr->parent_ino,
+					file_pptr->parent_gen,
+					file_pptr->namelen,
+					(unsigned long long)ip->i_ino,
+					(unsigned long long)file_pptr->name_cookie);
+		} else {
+			dbg_printf(
+ _("%s: ran out of parent pointers for ino %llu (file)\n"),
+					__func__,
+					(unsigned long long)ip->i_ino);
+		}
+
+		cmp_result = cmp_file_to_ag_pptr(file_pptr, ag_pptr);
+		if (cmp_result > 0) {
+			/*
+			 * The master pptr list knows about pptrs that are not
+			 * in the ondisk metadata.  Add the missing pptr and
+			 * advance only the master pptr cursor.
+			 */
+			add_missing_parent_ptr(ip, fscan, ag_pptr);
+			advance_slab_cursor(fscan->ag_pptr_recs_cur);
+		} else if (cmp_result < 0) {
+			/*
+			 * The ondisk pptrs mention a link that is not in the
+			 * master list.  Delete the extra pptr and advance only
+			 * the file pptr cursor.
+			 */
+			remove_incorrect_parent_ptr(ip, fscan, file_pptr);
+			advance_slab_cursor(fscan->file_pptr_recs_cur);
+		} else {
+			/*
+			 * Exact match, make sure the parent_gen and dirent
+			 * name parts of the parent pointer match.  Move both
+			 * cursors forward.
+			 */
+			compare_parent_ptrs(ip, fscan, ag_pptr, file_pptr);
+			advance_slab_cursor(fscan->ag_pptr_recs_cur);
+			advance_slab_cursor(fscan->file_pptr_recs_cur);
+		}
+
+		ag_pptr = peek_slab_cursor(fscan->ag_pptr_recs_cur);
+	} while (ag_pptr && ag_pptr->child_agino == agino);
+
+	while ((file_pptr = pop_slab_cursor(fscan->file_pptr_recs_cur))) {
+		dbg_printf(
+ _("%s: dp %llu dp_gen 0x%x namelen %u ino %llu namecookie 0x%llx (excess)\n"),
+				__func__,
+				(unsigned long long)file_pptr->parent_ino,
+				file_pptr->parent_gen,
+				file_pptr->namelen,
+				(unsigned long long)ip->i_ino,
+				(unsigned long long)file_pptr->name_cookie);
+
+		/*
+		 * The master pptr list does not have any more pptrs for this
+		 * file, but we still have unprocessed ondisk pptrs.  Delete
+		 * all these ondisk pptrs.
+		 */
+		remove_incorrect_parent_ptr(ip, fscan, file_pptr);
+	}
+}
+
+/* Ensure this file's parent pointers match what we found in the dirent scan. */
+static void
+check_file_parent_ptrs(
+	struct xfs_inode	*ip,
+	struct file_scan	*fscan)
+{
+	int			error;
+
+	error = -init_slab(&fscan->file_pptr_recs, sizeof(struct file_pptr));
+	if (error)
+		do_error(_("init file parent pointer recs failed: %s\n"),
+				strerror(error));
+
+	fscan->have_garbage = false;
+	fscan->nr_file_pptrs = 0;
+
+	error = xattr_walk(ip, examine_xattr, fscan);
+	if (error && !no_modify)
+		do_error(_("ino %llu parent pointer scan failed: %s\n"),
+				(unsigned long long)ip->i_ino,
+				strerror(error));
+	if (error) {
+		do_warn(_("ino %llu parent pointer scan failed: %s\n"),
+				(unsigned long long)ip->i_ino,
+				strerror(error));
+		goto out_free;
+	}
+
+	crosscheck_file_parent_ptrs(ip, fscan);
+
+out_free:
+	free_slab(&fscan->file_pptr_recs);
+	xfblob_truncate(fscan->file_pptr_names);
+}
+
+/* Check all the parent pointers of files in this AG. */
+static void
+check_ag_parent_ptrs(
+	struct workqueue	*wq,
+	uint32_t		agno,
+	void			*arg)
+{
+	struct xfs_mount	*mp = wq->wq_ctx;
+	struct file_scan	fscan = {
+		.ag_pptrs	= &fs_pptrs[agno],
+	};
+	struct ag_pptrs		*ag_pptrs = &fs_pptrs[agno];
+	struct ino_tree_node	*irec;
+	char			*descr;
+	int			error;
+
+	qsort_slab(ag_pptrs->pptr_recs, cmp_ag_pptr);
+
+	error = -init_slab_cursor(ag_pptrs->pptr_recs, cmp_ag_pptr,
+			&fscan.ag_pptr_recs_cur);
+	if (error)
+		do_error(
+ _("init agno %u parent pointer slab cursor failed: %s\n"),
+				agno, strerror(error));
+
+	descr = kasprintf(GFP_KERNEL,
+			"xfs_repair (%s): file parent pointer names",
+			mp->m_fsname);
+	error = -xfblob_create(descr, &fscan.file_pptr_names);
+	kfree(descr);
+	if (error)
+		do_error(
+ _("init agno %u file parent pointer names failed: %s\n"),
+				agno, strerror(error));
+
+	for (irec = findfirst_inode_rec(agno);
+	     irec != NULL;
+	     irec = next_ino_rec(irec)) {
+		unsigned int	ino_offset;
+
+		for (ino_offset = 0;
+		     ino_offset < XFS_INODES_PER_CHUNK;
+		     ino_offset++) {
+			struct xfs_inode *ip;
+			xfs_ino_t	ino;
+
+			if (is_inode_free(irec, ino_offset))
+				continue;
+
+			ino = XFS_AGINO_TO_INO(mp, agno,
+					irec->ino_startnum + ino_offset);
+			error = -libxfs_iget(mp, NULL, ino, 0, &ip);
+			if (error && !no_modify)
+				do_error(
+ _("loading ino %llu for parent pointer check failed: %s\n"),
+						(unsigned long long)ino,
+						strerror(error));
+			if (error) {
+				do_warn(
+ _("loading ino %llu for parent pointer check failed: %s\n"),
+						(unsigned long long)ino,
+						strerror(error));
+				continue;
+			}
+
+			check_file_parent_ptrs(ip, &fscan);
+			libxfs_irele(ip);
+		}
+	}
+
+	xfblob_destroy(fscan.file_pptr_names);
+	free_slab_cursor(&fscan.ag_pptr_recs_cur);
+}
+
+/* Check all the parent pointers of all files in this filesystem. */
+void
+check_parent_ptrs(
+	struct xfs_mount	*mp)
+{
+	struct workqueue	wq;
+	xfs_agnumber_t		agno;
+
+	if (!xfs_has_parent(mp))
+		return;
+
+	create_work_queue(&wq, mp, ag_stride);
+
+	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++)
+		queue_work(&wq, check_ag_parent_ptrs, agno, NULL);
+
+	destroy_work_queue(&wq);
+}
diff --git a/repair/pptr.h b/repair/pptr.h
index 7522379423ff..65acff963a3f 100644
--- a/repair/pptr.h
+++ b/repair/pptr.h
@@ -12,4 +12,6 @@ void parent_ptr_init(struct xfs_mount *mp);
 void add_parent_ptr(xfs_ino_t ino, const unsigned char *fname,
 		struct xfs_inode *dp, bool possible_dup);
 
+void check_parent_ptrs(struct xfs_mount *mp);
+
 #endif /* __REPAIR_PPTR_H__ */

