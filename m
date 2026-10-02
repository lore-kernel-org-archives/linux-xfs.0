Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9678E3C4555;
	Fri,  2 Oct 2026 22:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790980687; cv=none; b=CiwTDLMmgkl+iT1bnbCb0TrqkDknfLoOrCTzvNyEYgCl+7ZLdbSKM0+keyzWAWWLnhRn7n5wrlh8EwjadxfpHoBRKZysZj3FYLTLY4+rxQIQrlrZGViQGBtdutwEmYyuH/3agBcnYo2A/Fd/eg2qnPG2y8DXKJ5YKoqcFnndCyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790980687; c=relaxed/simple;
	bh=WsY0P/diqqHlOpAlCDPYIxY16IxVkU34e4+58ZeduDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r45vD9uyynm512aVrV1y9VUrWvrtOvBD1SeAADPN0GhNnN8ynBy/nncsZX5RNzzoeUgJcjqtz7xwqrwMgCn+NU+Rn+b24r2JDgjU9VmFjajfV8LTSIr7D0zG566kFkhRfrnWcPjyHwlz7mWMBEb60l9cra7E1QASBT6jl2o7Rv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AVUy08NT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AVUy08NT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C161F00893;
	Fri,  2 Oct 2026 22:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790980685;
	bh=9Fbq8b8IpWQabaz6UJinxCtNy9ARbxv8N6/UciwExZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AVUy08NTqCMEqoyYqkIV6fG+sMuvlNCAs/WHdaeQU12+EsG48t0bN7cuVScyhYlhK
	 Hqf7lq/Ll6Vh1A0XruvTh8nCDvsI6hB+nbvwMqvA6PHXukLdmPpg2QL3qFs6ZC/qc+
	 8G6rJC1yNexa4L+t5dEyiYkvELi8vphZ089aOFo5VDt5/u0RVY8je/94AxU7P6PeDF
	 0suuk+q8HFKNwTFjp59W4Wkn7xJ/zeCn6f7RxYXihK5Lysma8UV5ZcpGhsmT+ikD25
	 Wtr6MTM50IT+SSNyFhxWdMNYZh3SAmxTEXw7nUIBSUQsMzlaQ471K9kPBjmnGhaFhI
	 j0wp3QXQ8owAw==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: djwong@kernel.org,
	ebiggers@kernel.org,
	hch@lst.de,
	Carlos Maiolino <cem@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	david@fromorbit.com
Subject: [PATCH v17 15/21] xfs: add fs-verity support
Date: Sat,  3 Oct 2026 00:36:56 +0200
Message-ID: <20261002223705.2175542-16-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261002223705.2175542-1-aalbersh@kernel.org>
References: <20261002223705.2175542-1-aalbersh@kernel.org>
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

Pro-actively remove any unwritten extents as we use last extent to
locate descriptor.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_fsverity.c | 425 +++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_fsverity.h |   2 +
 fs/xfs/xfs_message.c  |   4 +
 fs/xfs/xfs_message.h  |   1 +
 fs/xfs/xfs_mount.h    |   2 +
 fs/xfs/xfs_super.c    |   7 +
 6 files changed, 440 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_fsverity.c b/fs/xfs/xfs_fsverity.c
index 976e05257bf9..8cffcafc19aa 100644
--- a/fs/xfs/xfs_fsverity.c
+++ b/fs/xfs/xfs_fsverity.c
@@ -6,13 +6,22 @@
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
-#include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_trace.h"
+#include "xfs_quota.h"
 #include "xfs_fsverity.h"
+#include "xfs_iomap.h"
+#include "xfs_error.h"
+#include "xfs_health.h"
+#include "xfs_bmap_util.h"
+#include "xfs_icache.h"
 #include <linux/fsverity.h>
 #include <linux/iomap.h>
+#include <linux/pagemap.h>
 
 struct kmem_cache *xfs_fsverity_ioend_cache;
 mempool_t xfs_fsverity_ioend_pool;
@@ -51,3 +60,417 @@ xfs_fsverity_is_file_data(
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
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	/*
+	 * Serialize reading of inode->i_flags with xfs_scrub clearing of this
+	 * flag if inode is corrupted.
+	 */
+	if (!(inode->i_flags & S_VERITY)) {
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		return -ENODATA;
+	}
+	error = xfs_bmap_last_extent(NULL, ip, XFS_DATA_FORK, &rec, &is_empty);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	if (error)
+		return error;
+
+	if (is_empty)
+		return -ENODATA;
+
+	last_block_offset =
+		XFS_FSB_TO_B(mp, rec.br_startoff + rec.br_blockcount);
+	if (last_block_offset <= xfs_fsverity_metadata_offset(ip))
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
+	if (desc_pos < xfs_fsverity_metadata_offset(ip))
+		return -ERANGE;
+
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
+	unsigned int		blksize = ip->i_mount->m_sb.sb_blocksize;
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
+	xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
+	if (error) {
+		xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
+		return error;
+	}
+
+	truncate_inode_pages(VFS_I(ip)->i_mapping, XFS_ISIZE(ip));
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
+
+	/*
+	 * We remove post EOF data, no need to update i_size as fsverity
+	 * didn't move i_size in the first place
+	 */
+	error = xfs_itruncate_extents(&tp, ip, XFS_DATA_FORK, XFS_ISIZE(ip));
+	if (error)
+		goto err_cancel;
+
+	error = xfs_trans_commit(tp);
+	xfs_iunlock(ip, XFS_MMAPLOCK_EXCL | XFS_ILOCK_EXCL);
+	return error;
+err_cancel:
+	xfs_trans_cancel(tp);
+	xfs_iunlock(ip, XFS_MMAPLOCK_EXCL | XFS_ILOCK_EXCL);
+	return error;
+}
+
+static int
+xfs_fsverity_reset_inode(
+	struct xfs_inode	*ip)
+{
+	int			error;
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp;
+
+	error = xfs_fsverity_delete_metadata(ip);
+	if (error)
+		return error;
+
+	/*
+	 * First, let's clean in-memory fsverity flag and then reset it on the
+	 * disk
+	 */
+	inode_set_flags(VFS_I(ip), 0, S_VERITY);
+
+	/*
+	 * Set fsverity inode flag
+	 */
+	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_ichange,
+			0, 0, false, &tp);
+	if (error)
+		return error;
+
+	ip->i_diflags2 &= ~XFS_DIFLAG2_VERITY;
+
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	xfs_trans_set_sync(tp);
+
+	error = xfs_trans_commit(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	return error;
+}
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
+	if (IS_DAX(inode) || ip->i_diflags2 & XFS_DIFLAG2_DAX)
+		return -EINVAL;
+
+	/*
+	 * fs-verity stores the Merkle tree past EOF in units of the filesystem
+	 * block size, so it cannot support realtime files whose allocation unit
+	 * (extent size) is larger than the block size.
+	 */
+	if (xfs_inode_has_bigrtalloc(ip))
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
+		goto out_clear;
+
+	error = xfs_fsverity_delete_metadata(ip);
+	if (error)
+		goto out_clear;
+	return error;
+out_clear:
+	xfs_iflags_clear(ip, XFS_VERITY_CONSTRUCTION);
+	return error;
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
+	if (error)
+		goto out;
+
+	inode_set_flags(inode, S_VERITY, S_VERITY);
+
+	/*
+	 * Proactively remove unwritten extents left by COW preallocations and
+	 * write preallocation in the merkle tree holes and past descriptor,
+	 * and any delayed preallocations
+	 */
+	error = xfs_free_eofblocks(ip);
+out:
+	if (error) {
+		int	error2;
+
+		error2 = xfs_fsverity_reset_inode(ip);
+		if (error2)
+			xfs_alert(ip->i_mount,
+"ino 0x%llx failed to clean up new fsverity metadata, err %d",
+					I_INO(ip), error2);
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
+static inline bool
+xfs_fsverity_is_hashes_of_zeroed_blocks(
+	struct xfs_inode	*ip,
+	const void		*buf,
+	unsigned int		size,
+	const u8		*zero_digest,
+	unsigned int		digest_size)
+{
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
+	if (size != ip->i_mount->m_sb.sb_blocksize)
+		return false;
+	/*
+	 * First digest is zero_digest
+	 */
+	if (memcmp(buf, zero_digest, digest_size))
+		return false;
+	/*
+	 * Every digest is same as previous, thus all are
+	 * zero_digest
+	 */
+	return memcmp(buf + digest_size, buf, size - digest_size) == 0;
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
+
+	if (position + size > inode->i_sb->s_maxbytes)
+		return -EFBIG;
+
+	if (xfs_fsverity_is_hashes_of_zeroed_blocks(ip, buf, size, zero_digest,
+						    digest_size))
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
index 01269a828fc0..7a3aee6d45fc 100644
--- a/fs/xfs/xfs_fsverity.h
+++ b/fs/xfs/xfs_fsverity.h
@@ -7,9 +7,11 @@
 
 #include "xfs_platform.h"
 #include <linux/iomap.h>
+#include <linux/fsverity.h>
 #include <linux/mempool.h>
 
 #ifdef CONFIG_FS_VERITY
+extern const struct fsverity_operations xfs_fsverity_ops;
 int xfs_fsverity_init(void);
 void xfs_fsverity_exit(void);
 loff_t xfs_fsverity_metadata_offset(const struct xfs_inode *ip);
diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
index 0243e509a468..44b13d46049c 100644
--- a/fs/xfs/xfs_message.c
+++ b/fs/xfs/xfs_message.c
@@ -149,6 +149,10 @@ xfs_warn_experimental(
 			.opstate	= XFS_OPSTATE_WARNED_LARP,
 			.name		= "logged extended attributes",
 		},
+		[XFS_EXPERIMENTAL_FSVERITY] = {
+			.opstate	= XFS_OPSTATE_WARNED_FSVERITY,
+			.name		= "fsverity",
+		},
 	};
 	ASSERT(feat >= 0 && feat < XFS_EXPERIMENTAL_MAX);
 	BUILD_BUG_ON(ARRAY_SIZE(features) != XFS_EXPERIMENTAL_MAX);
diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
index 811b885f41c3..364fcc7e42b0 100644
--- a/fs/xfs/xfs_message.h
+++ b/fs/xfs/xfs_message.h
@@ -93,6 +93,7 @@ void xfs_buf_alert_ratelimited(struct xfs_buf *bp, const char *rlmsg,
 enum xfs_experimental_feat {
 	XFS_EXPERIMENTAL_SHRINK,
 	XFS_EXPERIMENTAL_LARP,
+	XFS_EXPERIMENTAL_FSVERITY,
 
 	XFS_EXPERIMENTAL_MAX,
 };
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 60cb54c1a5ec..a3074f060928 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -599,6 +599,8 @@ __XFS_HAS_FEAT(nouuid, NOUUID)
 #define XFS_OPSTATE_RESUMING_QUOTAON	18
 /* (Zoned) GC is in progress */
 #define XFS_OPSTATE_ZONEGC_RUNNING	20
+/* Kernel has logged a warning about fsverity support */
+#define XFS_OPSTATE_WARNED_FSVERITY	21
 
 #define __XFS_IS_OPSTATE(name, NAME) \
 static inline bool xfs_is_ ## name (struct xfs_mount *mp) \
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 7a8d071dbe56..560493e2b78c 100644
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
@@ -1736,6 +1737,9 @@ xfs_fs_fill_super(
 	sb->s_quota_types = QTYPE_MASK_USR | QTYPE_MASK_GRP | QTYPE_MASK_PRJ;
 #endif
 	sb->s_op = &xfs_super_operations;
+#ifdef CONFIG_FS_VERITY
+	sb->s_vop = &xfs_fsverity_ops;
+#endif
 
 	/*
 	 * Delay mount work if the debug hook is set. This is debug
@@ -1988,6 +1992,9 @@ xfs_fs_fill_super(
 	if (error)
 		goto out_filestream_unmount;
 
+	if (xfs_has_verity(mp))
+		xfs_warn_experimental(mp, XFS_EXPERIMENTAL_FSVERITY);
+
 	root = igrab(VFS_I(mp->m_rootip));
 	if (!root) {
 		error = -ENOENT;
-- 
2.54.0

