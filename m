Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72FDC45348A;
	Tue, 31 Mar 2026 21:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774992560; cv=none; b=n5Jkjwv7tuaPV9Rflo4HgBuV8WmoEjY3/tt0jJAS1slFx84udEzgbqLzJVauYMuHLzIata1+HYxu0JEWDWyyUOxY7sENJ2DlK4XbBRBNMoAVuiJ1SCGzYTD70Lsar0/MhfvRsK97gU0LMReSbhz8Ga4wK0D/jcNwJ28Oa78CZUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774992560; c=relaxed/simple;
	bh=VduCrUW9uvCKE8r8y0eKlfmUscT23wW4YbfQYJ1RYFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ul7IHF0UjVSKlZVxxc+J83+g7Zv76JMm1EbkrnK/J+Qi+hphPtGjffyhikv5tSMnZeOuDclz7aI2U+86GfQdYOdrJpQ6Pkxmnb+zU/3G6CiROyttWo+lz4UErp575cdKG1bmGHCl+8XhK2HZG9KdTWGvn87pC9sYUNbaBqYe+cY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G6y64lP8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G6y64lP8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACB00C2BCB0;
	Tue, 31 Mar 2026 21:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774992560;
	bh=VduCrUW9uvCKE8r8y0eKlfmUscT23wW4YbfQYJ1RYFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G6y64lP8mQZ6S/71Uqa0HTKP4ECv52BZz5roQQjQHcWMSsNIGZxvtqxDsKJbEBsG5
	 Ssj6NhhhxyenorbOQBqmunisgN9PFruOMf7gGUvanPbW4HRXHyDIXViPVFLl/sZJBD
	 wbtZHYxzIeEFMTavYtCxs7roKs/+LeJxWgpRL0qYPwhr0bRtOBAhvhYFXVM6j4zL8h
	 UF9cq0p7wWqBa9eqSlVwxTruG1h4NQ/9uOrzS+a7hajAdcqQ/9hCsyppE8iOzF7oBk
	 lRdNDfl+t8zNw/ZOebPQfuNawKY1xjGCtYiVtv0HCMha8LmmOxF6aFMZGePRKLu72D
	 ubXZ0CNgkDRAQ==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	hch@lst.de,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	djwong@kernel.org
Subject: [PATCH v6 15/22] xfs: add fs-verity support
Date: Tue, 31 Mar 2026 23:28:16 +0200
Message-ID: <20260331212827.2631020-16-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260331212827.2631020-1-aalbersh@kernel.org>
References: <20260331212827.2631020-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add integration with fs-verity. XFS stores fs-verity descriptor and
Merkle tree in the inode data fork at first block aligned to 64k past
EOF.

The Merkle tree reading/writing is done through iomap interface. The
data itself is read to the inode's page cache. When XFS reads from this
region iomap doesn't call into fsverity to verify it against Merkle
tree. For data, verification is done at ioend completion in a workqueue.

When fs-verity is enabled on an inode, the XFS_IVERITY_CONSTRUCTION
flag is set meaning that the Merkle tree is being build. The
initialization ends with storing of verity descriptor and setting
inode on-disk flag (XFS_DIFLAG2_VERITY). Lastly, the
XFS_IVERITY_CONSTRUCTION is dropped and I_VERITY is set on inode.

The descriptor is stored in a new block aligned to 64k after the last
Merkle tree block. The size of the descriptor is stored at the end of
the last descriptor block (descriptor can be multiple blocks).

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/xfs_bmap_util.c |   8 +
 fs/xfs/xfs_fsverity.c  | 349 ++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_fsverity.h  |   2 +
 fs/xfs/xfs_message.c   |   4 +
 fs/xfs/xfs_message.h   |   1 +
 fs/xfs/xfs_mount.h     |   2 +
 fs/xfs/xfs_super.c     |   7 +
 7 files changed, 372 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 0ab00615f1ad..18348f4fd2aa 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -31,6 +31,7 @@
 #include "xfs_rtbitmap.h"
 #include "xfs_rtgroup.h"
 #include "xfs_zone_alloc.h"
+#include <linux/fsverity.h>
 
 /* Kernel only BMAP related definitions and functions */
 
@@ -553,6 +554,13 @@ xfs_can_free_eofblocks(
 	if (last_fsb <= end_fsb)
 		return false;
 
+	/*
+	 * Nothing to clean on fsverity inodes as they don't use prealloc and
+	 * there no delalloc as only written data is fsverity metadata
+	 */
+	if (IS_VERITY(VFS_I(ip)))
+		return false;
+
 	/*
 	 * Check if there is an post-EOF extent to free.  If there are any
 	 * delalloc blocks attached to the inode (data fork delalloc
diff --git a/fs/xfs/xfs_fsverity.c b/fs/xfs/xfs_fsverity.c
index b983e20bb5e1..5a6a48fcf843 100644
--- a/fs/xfs/xfs_fsverity.c
+++ b/fs/xfs/xfs_fsverity.c
@@ -4,14 +4,26 @@
  */
 #include "xfs_platform.h"
 #include "xfs_format.h"
-#include "xfs_inode.h"
 #include "xfs_shared.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
 #include "xfs_fsverity.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_inode.h"
+#include "xfs_log_format.h"
+#include "xfs_bmap_util.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_trace.h"
+#include "xfs_quota.h"
 #include "xfs_fsverity.h"
+#include "xfs_iomap.h"
+#include "xfs_error.h"
+#include "xfs_health.h"
 #include <linux/fsverity.h>
 #include <linux/iomap.h>
+#include <linux/pagemap.h>
 
 loff_t
 xfs_fsverity_metadata_offset(
@@ -28,3 +40,338 @@ xfs_fsverity_is_file_data(
 	return fsverity_active(VFS_IC(ip)) &&
 			offset < xfs_fsverity_metadata_offset(ip);
 }
+
+/*
+ * Retrieve the verity descriptor.
+ */
+static int
+xfs_fsverity_get_descriptor(
+	struct inode		*inode,
+	void			*buf,
+	size_t			buf_size)
+{
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	__be32			d_desc_size;
+	u32			desc_size;
+	u64			desc_size_pos;
+	int			error;
+	u64			desc_pos;
+	struct xfs_bmbt_irec	rec;
+	int			is_empty;
+	uint32_t		blocksize = i_blocksize(VFS_I(ip));
+	xfs_fileoff_t		last_block_offset;
+
+	ASSERT(inode->i_flags & S_VERITY);
+	error = xfs_bmap_last_extent(NULL, ip, XFS_DATA_FORK, &rec, &is_empty);
+	if (error)
+		return error;
+
+	if (is_empty)
+		return -ENODATA;
+
+	last_block_offset =
+		XFS_FSB_TO_B(mp, rec.br_startoff + rec.br_blockcount);
+	if (last_block_offset < xfs_fsverity_metadata_offset(ip))
+		return -ENODATA;
+
+	desc_size_pos = last_block_offset - sizeof(__be32);
+	error = fsverity_pagecache_read(inode, (char *)&d_desc_size,
+			sizeof(d_desc_size), desc_size_pos);
+	if (error)
+		return error;
+
+	desc_size = be32_to_cpu(d_desc_size);
+	if (XFS_IS_CORRUPT(mp, desc_size > FS_VERITY_MAX_DESCRIPTOR_SIZE))
+		return -ERANGE;
+	if (XFS_IS_CORRUPT(mp, desc_size > desc_size_pos))
+		return -ERANGE;
+
+	if (!buf_size)
+		return desc_size;
+
+	if (XFS_IS_CORRUPT(mp, desc_size > buf_size))
+		return -ERANGE;
+
+	desc_pos = round_down(desc_size_pos - desc_size, blocksize);
+	error = fsverity_pagecache_read(inode, buf, desc_size, desc_pos);
+	if (error)
+		return error;
+
+	return desc_size;
+}
+
+static int
+xfs_fsverity_write_descriptor(
+	struct file		*file,
+	const void		*desc,
+	u32			desc_size,
+	u64			merkle_tree_size)
+{
+	int			error;
+	struct inode		*inode = file_inode(file);
+	struct xfs_inode	*ip = XFS_I(inode);
+	unsigned int		blksize = ip->i_mount->m_attr_geo->blksize;
+	u64			tree_last_block =
+			xfs_fsverity_metadata_offset(ip) + merkle_tree_size;
+	u64			desc_pos =
+			round_up(tree_last_block, XFS_FSVERITY_START_ALIGN);
+	u64			desc_end = desc_pos + desc_size;
+	__be32			desc_size_disk = cpu_to_be32(desc_size);
+	u64			desc_size_pos =
+			round_up(desc_end + sizeof(desc_size_disk), blksize) -
+			sizeof(desc_size_disk);
+
+	error = iomap_fsverity_write(file, desc_size_pos, sizeof(__be32),
+			(const void *)&desc_size_disk,
+			&xfs_buffered_write_iomap_ops,
+			&xfs_iomap_write_ops);
+	if (error)
+		return error;
+
+	return iomap_fsverity_write(file, desc_pos, desc_size, desc,
+			&xfs_buffered_write_iomap_ops,
+			&xfs_iomap_write_ops);
+}
+
+/*
+ * Try to remove all the fsverity metadata after a failed enablement.
+ */
+static int
+xfs_fsverity_delete_metadata(
+	struct xfs_inode	*ip)
+{
+	struct xfs_trans	*tp;
+	struct xfs_mount	*mp = ip->i_mount;
+	int			error;
+
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
+	if (error)
+		return error;
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
+
+	/*
+	 * We removing post EOF data, no need to update i_size as fsverity
+	 * didn't move i_size in the first place
+	 */
+	error = xfs_itruncate_extents(&tp, ip, XFS_DATA_FORK, XFS_ISIZE(ip));
+	if (error)
+		goto err_cancel;
+
+	error = xfs_trans_commit(tp);
+	if (error)
+		goto err_cancel;
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+
+	return error;
+
+err_cancel:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_cancel(tp);
+	return error;
+}
+
+
+/*
+ * Prepare to enable fsverity by clearing old metadata.
+ */
+static int
+xfs_fsverity_begin_enable(
+	struct file		*filp)
+{
+	struct inode		*inode = file_inode(filp);
+	struct xfs_inode	*ip = XFS_I(inode);
+	int			error;
+
+	xfs_assert_ilocked(ip, XFS_IOLOCK_EXCL);
+
+	if (IS_DAX(inode))
+		return -EINVAL;
+
+	if (inode->i_size > XFS_FSVERITY_LARGEST_FILE)
+		return -EFBIG;
+
+	/*
+	 * Flush pagecache before building Merkle tree. Inode is locked and no
+	 * further writes will happen to the file except fsverity metadata
+	 */
+	error = filemap_write_and_wait(inode->i_mapping);
+	if (error)
+		return error;
+
+	if (xfs_iflags_test_and_set(ip, XFS_VERITY_CONSTRUCTION))
+		return -EBUSY;
+
+	error = xfs_qm_dqattach(ip);
+	if (error)
+		return error;
+
+	return xfs_fsverity_delete_metadata(ip);
+}
+
+/*
+ * Complete (or fail) the process of enabling fsverity.
+ */
+static int
+xfs_fsverity_end_enable(
+	struct file		*file,
+	const void		*desc,
+	size_t			desc_size,
+	u64			merkle_tree_size)
+{
+	struct inode		*inode = file_inode(file);
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp;
+	int			error = 0;
+	loff_t			range_start = xfs_fsverity_metadata_offset(ip);
+
+	xfs_assert_ilocked(ip, XFS_IOLOCK_EXCL);
+
+	/* fs-verity failed, just cleanup */
+	if (desc == NULL)
+		goto out;
+
+	error = xfs_fsverity_write_descriptor(file, desc, desc_size,
+			merkle_tree_size);
+	if (error)
+		goto out;
+
+	/*
+	 * Wait for Merkle tree get written to disk before setting on-disk inode
+	 * flag and clearing XFS_VERITY_CONSTRUCTION
+	 */
+	error = filemap_write_and_wait_range(inode->i_mapping, range_start,
+			LLONG_MAX);
+	if (error)
+		goto out;
+
+	/*
+	 * Proactively drop any delayed allocations in COW fork, the fsverity
+	 * files are read-only
+	 */
+	if (xfs_is_cow_inode(ip))
+		xfs_bmap_punch_delalloc_range(ip, XFS_COW_FORK, 0, LLONG_MAX,
+				NULL);
+
+	/*
+	 * Set fsverity inode flag
+	 */
+	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_ichange,
+			0, 0, false, &tp);
+	if (error)
+		goto out;
+
+	/*
+	 * Ensure that we've persisted the verity information before we enable
+	 * it on the inode and tell the caller we have sealed the inode.
+	 */
+	ip->i_diflags2 |= XFS_DIFLAG2_VERITY;
+
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	xfs_trans_set_sync(tp);
+
+	error = xfs_trans_commit(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+
+	if (!error)
+		inode->i_flags |= S_VERITY;
+
+out:
+	if (error) {
+		int	error2;
+
+		error2 = xfs_fsverity_delete_metadata(ip);
+		if (error2)
+			xfs_alert(ip->i_mount,
+"ino 0x%llx failed to clean up new fsverity metadata, err %d",
+					ip->i_ino, error2);
+	}
+
+	xfs_iflags_clear(ip, XFS_VERITY_CONSTRUCTION);
+	return error;
+}
+
+/*
+ * Retrieve a merkle tree block.
+ */
+static struct page *
+xfs_fsverity_read_merkle(
+	struct inode		*inode,
+	pgoff_t			index)
+{
+	index += xfs_fsverity_metadata_offset(XFS_I(inode)) >> PAGE_SHIFT;
+
+	return generic_read_merkle_tree_page(inode, index);
+}
+
+/*
+ * Retrieve a merkle tree block.
+ */
+static void
+xfs_fsverity_readahead_merkle_tree(
+	struct inode		*inode,
+	pgoff_t			index,
+	unsigned long		nr_pages)
+{
+	index += xfs_fsverity_metadata_offset(XFS_I(inode)) >> PAGE_SHIFT;
+
+	generic_readahead_merkle_tree(inode, index, nr_pages);
+}
+
+/*
+ * Write a merkle tree block.
+ */
+static int
+xfs_fsverity_write_merkle(
+	struct file		*file,
+	const void		*buf,
+	u64			pos,
+	unsigned int		size,
+	const u8		*zero_digest,
+	unsigned int		digest_size)
+{
+	struct inode		*inode = file_inode(file);
+	struct xfs_inode	*ip = XFS_I(inode);
+	loff_t			position = pos +
+		xfs_fsverity_metadata_offset(ip);
+	const char		*p;
+	unsigned int		i;
+
+	if (position + size > inode->i_sb->s_maxbytes)
+		return -EFBIG;
+
+	/*
+	 * If this is a block full of hashes of zeroed blocks, don't bother
+	 * storing the block. We can synthesize them later.
+	 *
+	 * However, do this only in case Merkle tree block == fs block size.
+	 * Iomap synthesizes these blocks based on holes in the merkle tree. We
+	 * won't be able to tell if something need to be synthesizes for the
+	 * range in the fs block. For example, for 4k filesystem block
+	 *
+	 *	[ 1k | zero hashes | zero hashes | 1k ]
+	 *
+	 * Iomap won't know about these empty blocks.
+	 */
+	for (i = 0, p = buf; i < size; i += digest_size, p += digest_size)
+		if (memcmp(p, zero_digest, digest_size))
+			break;
+	if (i == size && size == ip->i_mount->m_sb.sb_blocksize)
+		return 0;
+
+	return iomap_fsverity_write(file, position, size, buf,
+			&xfs_buffered_write_iomap_ops,
+			&xfs_iomap_write_ops);
+}
+
+const struct fsverity_operations xfs_fsverity_ops = {
+	.begin_enable_verity		= xfs_fsverity_begin_enable,
+	.end_enable_verity		= xfs_fsverity_end_enable,
+	.get_verity_descriptor		= xfs_fsverity_get_descriptor,
+	.read_merkle_tree_page		= xfs_fsverity_read_merkle,
+	.readahead_merkle_tree		= xfs_fsverity_readahead_merkle_tree,
+	.write_merkle_tree_block	= xfs_fsverity_write_merkle,
+};
diff --git a/fs/xfs/xfs_fsverity.h b/fs/xfs/xfs_fsverity.h
index ec77ba571106..6a981e20a75b 100644
--- a/fs/xfs/xfs_fsverity.h
+++ b/fs/xfs/xfs_fsverity.h
@@ -6,8 +6,10 @@
 #define __XFS_FSVERITY_H__
 
 #include "xfs_platform.h"
+#include <linux/fsverity.h>
 
 #ifdef CONFIG_FS_VERITY
+extern const struct fsverity_operations xfs_fsverity_ops;
 loff_t xfs_fsverity_metadata_offset(const struct xfs_inode *ip);
 bool xfs_fsverity_is_file_data(const struct xfs_inode *ip, loff_t offset);
 #else
diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
index fd297082aeb8..9818d8f8f239 100644
--- a/fs/xfs/xfs_message.c
+++ b/fs/xfs/xfs_message.c
@@ -153,6 +153,10 @@ xfs_warn_experimental(
 			.opstate	= XFS_OPSTATE_WARNED_ZONED,
 			.name		= "zoned RT device",
 		},
+		[XFS_EXPERIMENTAL_FSVERITY] = {
+			.opstate	= XFS_OPSTATE_WARNED_FSVERITY,
+			.name		= "fsverity",
+		},
 	};
 	ASSERT(feat >= 0 && feat < XFS_EXPERIMENTAL_MAX);
 	BUILD_BUG_ON(ARRAY_SIZE(features) != XFS_EXPERIMENTAL_MAX);
diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
index 49b0ef40d299..083403944f11 100644
--- a/fs/xfs/xfs_message.h
+++ b/fs/xfs/xfs_message.h
@@ -94,6 +94,7 @@ enum xfs_experimental_feat {
 	XFS_EXPERIMENTAL_SHRINK,
 	XFS_EXPERIMENTAL_LARP,
 	XFS_EXPERIMENTAL_ZONED,
+	XFS_EXPERIMENTAL_FSVERITY,
 
 	XFS_EXPERIMENTAL_MAX,
 };
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 07f6aa3c3f26..84d7cfb5e2c7 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -583,6 +583,8 @@ __XFS_HAS_FEAT(nouuid, NOUUID)
 #define XFS_OPSTATE_WARNED_ZONED	19
 /* (Zoned) GC is in progress */
 #define XFS_OPSTATE_ZONEGC_RUNNING	20
+/* Kernel has logged a warning about fsverity support */
+#define XFS_OPSTATE_WARNED_FSVERITY	21
 
 #define __XFS_IS_OPSTATE(name, NAME) \
 static inline bool xfs_is_ ## name (struct xfs_mount *mp) \
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index f8de44443e81..d9d442009610 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -30,6 +30,7 @@
 #include "xfs_filestream.h"
 #include "xfs_quota.h"
 #include "xfs_sysfs.h"
+#include "xfs_fsverity.h"
 #include "xfs_ondisk.h"
 #include "xfs_rmap_item.h"
 #include "xfs_refcount_item.h"
@@ -1686,6 +1687,9 @@ xfs_fs_fill_super(
 	sb->s_quota_types = QTYPE_MASK_USR | QTYPE_MASK_GRP | QTYPE_MASK_PRJ;
 #endif
 	sb->s_op = &xfs_super_operations;
+#ifdef CONFIG_FS_VERITY
+	sb->s_vop = &xfs_fsverity_ops;
+#endif
 
 	/*
 	 * Delay mount work if the debug hook is set. This is debug
@@ -1939,6 +1943,9 @@ xfs_fs_fill_super(
 	if (error)
 		goto out_filestream_unmount;
 
+	if (xfs_has_verity(mp))
+		xfs_warn_experimental(mp, XFS_EXPERIMENTAL_FSVERITY);
+
 	root = igrab(VFS_I(mp->m_rootip));
 	if (!root) {
 		error = -ENOENT;
-- 
2.51.2

