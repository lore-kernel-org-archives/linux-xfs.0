Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB8031F986;
	Tue, 22 Sep 2026 04:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790052362; cv=none; b=XfQowUtbm3EVyeZQDYDOV6irpev6JZiJ+QwHp5gODHG1JRovu7h/PojvHnvFAT1FbtKkOHel3qseCC0O79Ux7doip+YGcXTj41shi4iWY60NIqwi70y5L8jIQyoV4qTnmFGmgSt2fnv39atAkJYuA9+Ax7o5IkK+I7Rn2L7KeTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790052362; c=relaxed/simple;
	bh=I1rTznzVVK7o5N8KBNrrGuZizMVUhj+X/p3xdO9yA8k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O23/3rpp4S1+awRYXU5sliOlg6KMwTI7rEyDQxJuD14WnJs+TWf1fNTVdxy8mfFQRmWeE0xiZe5B53IU/QmippYvTipItkx5R/UM6WVWmaG/ok8HrCaBvAKPGYLkvQ7nlsTmHewSAs+b3OZpNiZAFf77sjFWHnY0j5dmyR58XXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iK4Fu6rf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iK4Fu6rf"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7066C1F000FF;
	Tue, 22 Sep 2026 04:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790052360;
	bh=9eYIs0LlONxdZNJ0OdUYipeTLJHGY3S9MMHWuhG6p5s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iK4Fu6rfcEQU6JOhegDUchXC9OJxoNiqgM3ve8PGASUUP/FhfVCE9qfLbtyGkJ1Ro
	 hR3z1GbKWwpxmjTP1Js+zWiS6ul8nrPUrhvq+8JUm3gCkF+IkjsvANqkewi7pOBLp8
	 Jl9XWa0VrRDDkdao4jAEQUI1P4+98TN55BoutPAC1C8A/+PGNtGCvmFKypqdbD9NrS
	 bnPN1ZQA3fDcx03taPNymvpYpfA9Gkm1wk4eThk8lb2XW33O3cRgkW82iyE5Id48XP
	 BzY6sSOvfPNSJ8sa07sh1GspYb3Za6KV41bZtptCJxHF+xStsBGUSQJ21IdK6yubjP
	 /78ytkuUOL5UQ==
Date: Mon, 21 Sep 2026 21:45:59 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: ebiggers@kernel.org, hch@lst.de, Carlos Maiolino <cem@kernel.org>,
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH v16 15/21] xfs: add fs-verity support
Message-ID: <20260922044559.GO2705364@frogsfrogsfrogs>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
 <20260918111539.1003439-16-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918111539.1003439-16-aalbersh@kernel.org>

On Fri, Sep 18, 2026 at 01:15:27PM +0200, Andrey Albershteyn wrote:
> Add integration with fs-verity. XFS stores fs-verity descriptor and
> Merkle tree in the inode data fork at first block aligned to 64k past
> EOF.
> 
> The Merkle tree reading/writing is done through iomap interface. The
> data itself is read to the inode's page cache. When XFS reads from this
> region iomap doesn't call into fsverity to verify it against Merkle
> tree. For data, verification is done at ioend completion in a workqueue.
> 
> When fs-verity is enabled on an inode, the XFS_IVERITY_CONSTRUCTION
> flag is set meaning that the Merkle tree is being build. The
> initialization ends with storing of verity descriptor and setting
> inode on-disk flag (XFS_DIFLAG2_VERITY). Lastly, the
> XFS_IVERITY_CONSTRUCTION is dropped and I_VERITY is set on inode.
> 
> The descriptor is stored in a new block aligned to 64k after the last
> Merkle tree block. The size of the descriptor is stored at the end of
> the last descriptor block (descriptor can be multiple blocks).
> 
> Pro-actively remove any unwritten extents as we use last extent to
> locate descriptor.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_fsverity.c | 363 +++++++++++++++++++++++++++++++++++++++++-
>  fs/xfs/xfs_fsverity.h |   2 +
>  fs/xfs/xfs_message.c  |   4 +
>  fs/xfs/xfs_message.h  |   1 +
>  fs/xfs/xfs_mount.h    |   2 +
>  fs/xfs/xfs_super.c    |   7 +
>  6 files changed, 378 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_fsverity.c b/fs/xfs/xfs_fsverity.c
> index 525855fdd30d..e62c9a5d0e1d 100644
> --- a/fs/xfs/xfs_fsverity.c
> +++ b/fs/xfs/xfs_fsverity.c
> @@ -6,13 +6,22 @@
>  #include "xfs_fs.h"
>  #include "xfs_shared.h"
>  #include "xfs_format.h"
> -#include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
>  #include "xfs_inode.h"
> +#include "xfs_log_format.h"
> +#include "xfs_trans.h"
> +#include "xfs_trace.h"
> +#include "xfs_quota.h"
>  #include "xfs_fsverity.h"
> +#include "xfs_iomap.h"
> +#include "xfs_error.h"
> +#include "xfs_health.h"
> +#include "xfs_bmap_util.h"
> +#include "xfs_icache.h"
>  #include <linux/fsverity.h>
>  #include <linux/iomap.h>
> +#include <linux/pagemap.h>
>  
>  struct kmem_cache *xfs_fsverity_ioend_cache;
>  
> @@ -31,3 +40,355 @@ xfs_fsverity_is_file_data(
>  	return fsverity_active(VFS_IC(ip)) &&
>  			offset < xfs_fsverity_metadata_offset(ip);
>  }
> +
> +/*
> + * Retrieve the verity descriptor.
> + */
> +static int
> +xfs_fsverity_get_descriptor(
> +	struct inode		*inode,
> +	void			*buf,
> +	size_t			buf_size)
> +{
> +	struct xfs_inode	*ip = XFS_I(inode);
> +	struct xfs_mount	*mp = ip->i_mount;
> +	__be32			d_desc_size;
> +	u32			desc_size;
> +	u64			desc_size_pos;
> +	int			error;
> +	u64			desc_pos;
> +	struct xfs_bmbt_irec	rec;
> +	int			is_empty;
> +	uint32_t		blocksize = i_blocksize(VFS_I(ip));
> +	xfs_fileoff_t		last_block_offset;
> +
> +	ASSERT(inode->i_flags & S_VERITY);
> +	xfs_ilock(ip, XFS_ILOCK_SHARED);
> +	error = xfs_bmap_last_extent(NULL, ip, XFS_DATA_FORK, &rec, &is_empty);
> +	xfs_iunlock(ip, XFS_ILOCK_SHARED);
> +	if (error)
> +		return error;
> +
> +	if (is_empty)
> +		return -ENODATA;
> +
> +	last_block_offset =
> +		XFS_FSB_TO_B(mp, rec.br_startoff + rec.br_blockcount);
> +	if (last_block_offset <= xfs_fsverity_metadata_offset(ip))
> +		return -ENODATA;
> +
> +	desc_size_pos = last_block_offset - sizeof(__be32);
> +	error = fsverity_pagecache_read(inode, (char *)&d_desc_size,
> +			sizeof(d_desc_size), desc_size_pos);
> +	if (error)
> +		return error;
> +
> +	desc_size = be32_to_cpu(d_desc_size);
> +	if (XFS_IS_CORRUPT(mp, desc_size > FS_VERITY_MAX_DESCRIPTOR_SIZE))
> +		return -ERANGE;
> +	if (XFS_IS_CORRUPT(mp, desc_size > desc_size_pos))
> +		return -ERANGE;
> +
> +	if (!buf_size)
> +		return desc_size;
> +
> +	if (XFS_IS_CORRUPT(mp, desc_size > buf_size))
> +		return -ERANGE;
> +
> +	desc_pos = round_down(desc_size_pos - desc_size, blocksize);
> +	if (desc_pos < xfs_fsverity_metadata_offset(ip))
> +		return -ERANGE;
> +
> +	error = fsverity_pagecache_read(inode, buf, desc_size, desc_pos);
> +	if (error)
> +		return error;
> +
> +	return desc_size;
> +}
> +
> +static int
> +xfs_fsverity_write_descriptor(
> +	struct file		*file,
> +	const void		*desc,
> +	u32			desc_size,
> +	u64			merkle_tree_size)
> +{
> +	int			error;
> +	struct inode		*inode = file_inode(file);
> +	struct xfs_inode	*ip = XFS_I(inode);
> +	unsigned int		blksize = ip->i_mount->m_sb.sb_blocksize;
> +	u64			tree_last_block =
> +			xfs_fsverity_metadata_offset(ip) + merkle_tree_size;
> +	u64			desc_pos =
> +			round_up(tree_last_block, XFS_FSVERITY_START_ALIGN);
> +	u64			desc_end = desc_pos + desc_size;
> +	__be32			desc_size_disk = cpu_to_be32(desc_size);
> +	u64			desc_size_pos =
> +			round_up(desc_end + sizeof(desc_size_disk), blksize) -
> +			sizeof(desc_size_disk);
> +
> +	error = iomap_fsverity_write(file, desc_size_pos, sizeof(__be32),
> +			(const void *)&desc_size_disk,
> +			&xfs_buffered_write_iomap_ops,
> +			&xfs_iomap_write_ops);
> +	if (error)
> +		return error;
> +
> +	return iomap_fsverity_write(file, desc_pos, desc_size, desc,
> +			&xfs_buffered_write_iomap_ops,
> +			&xfs_iomap_write_ops);
> +}
> +
> +/*
> + * Try to remove all the fsverity metadata after a failed enablement.
> + */
> +static int
> +xfs_fsverity_delete_metadata(
> +	struct xfs_inode	*ip)
> +{
> +	struct xfs_trans	*tp;
> +	struct xfs_mount	*mp = ip->i_mount;
> +	int			error;
> +
> +	xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
> +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
> +	if (error) {
> +		xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
> +		return error;
> +	}
> +
> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(tp, ip, 0);
> +
> +	truncate_inode_pages(VFS_I(ip)->i_mapping, XFS_ISIZE(ip));
> +
> +	/*
> +	 * We remove post EOF data, no need to update i_size as fsverity
> +	 * didn't move i_size in the first place
> +	 */
> +	error = xfs_itruncate_extents(&tp, ip, XFS_DATA_FORK, XFS_ISIZE(ip));
> +	if (error)
> +		goto err_cancel;
> +
> +	error = xfs_trans_commit(tp);
> +	xfs_iunlock(ip, XFS_MMAPLOCK_EXCL | XFS_ILOCK_EXCL);
> +	return error;
> +err_cancel:
> +	xfs_trans_cancel(tp);
> +	xfs_iunlock(ip, XFS_MMAPLOCK_EXCL | XFS_ILOCK_EXCL);
> +	return error;
> +}
> +
> +
> +/*
> + * Prepare to enable fsverity by clearing old metadata.
> + */
> +static int
> +xfs_fsverity_begin_enable(
> +	struct file		*filp)
> +{
> +	struct inode		*inode = file_inode(filp);
> +	struct xfs_inode	*ip = XFS_I(inode);
> +	int			error;
> +
> +	xfs_assert_ilocked(ip, XFS_IOLOCK_EXCL);
> +
> +	if (IS_DAX(inode) || ip->i_diflags2 & XFS_DIFLAG2_DAX)
> +		return -EINVAL;
> +
> +	if (inode->i_size > XFS_FSVERITY_LARGEST_FILE)
> +		return -EFBIG;
> +
> +	/*
> +	 * Flush pagecache before building Merkle tree. Inode is locked and no
> +	 * further writes will happen to the file except fsverity metadata
> +	 */
> +	error = filemap_write_and_wait(inode->i_mapping);
> +	if (error)
> +		return error;
> +
> +	if (xfs_iflags_test_and_set(ip, XFS_VERITY_CONSTRUCTION))
> +		return -EBUSY;
> +
> +	error = xfs_qm_dqattach(ip);
> +	if (error)
> +		goto out_clear;
> +
> +	error = xfs_fsverity_delete_metadata(ip);
> +	if (error)
> +		goto out_clear;
> +	return error;
> +out_clear:
> +	xfs_iflags_clear(ip, XFS_VERITY_CONSTRUCTION);
> +	return error;
> +}
> +
> +/*
> + * Complete (or fail) the process of enabling fsverity.
> + */
> +static int
> +xfs_fsverity_end_enable(
> +	struct file		*file,
> +	const void		*desc,
> +	size_t			desc_size,
> +	u64			merkle_tree_size)
> +{
> +	struct inode		*inode = file_inode(file);
> +	struct xfs_inode	*ip = XFS_I(inode);
> +	struct xfs_mount	*mp = ip->i_mount;
> +	struct xfs_trans	*tp;
> +	int			error = 0;
> +	loff_t			range_start = xfs_fsverity_metadata_offset(ip);
> +
> +	xfs_assert_ilocked(ip, XFS_IOLOCK_EXCL);
> +
> +	/* fs-verity failed, just cleanup */
> +	if (desc == NULL) {
> +		error = xfs_fsverity_delete_metadata(ip);
> +		goto out;
> +	}
> +
> +	error = xfs_fsverity_write_descriptor(file, desc, desc_size,
> +			merkle_tree_size);
> +	if (error)
> +		goto out;
> +
> +	/*
> +	 * Wait for Merkle tree get written to disk before setting on-disk inode
> +	 * flag and clearing XFS_VERITY_CONSTRUCTION
> +	 */
> +	error = filemap_write_and_wait_range(inode->i_mapping, range_start,
> +			LLONG_MAX);
> +	if (error)
> +		goto out;
> +
> +	/*
> +	 * Set fsverity inode flag
> +	 */
> +	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_ichange,
> +			0, 0, false, &tp);
> +	if (error)
> +		goto out;
> +
> +	/*
> +	 * Ensure that we've persisted the verity information before we enable
> +	 * it on the inode and tell the caller we have sealed the inode.
> +	 */
> +	ip->i_diflags2 |= XFS_DIFLAG2_VERITY;
> +
> +	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> +	xfs_trans_set_sync(tp);
> +
> +	error = xfs_trans_commit(tp);
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +	if (error)
> +		goto out;
> +
> +	inode_set_flags(inode, S_VERITY, S_VERITY);
> +
> +	/*
> +	 * Proactively remove unwritten extents left by COW preallocations and
> +	 * write preallocation in the merkle tree holes and past descriptor,
> +	 * and any delayed preallocations
> +	 */
> +	error = xfs_free_eofblocks(ip);
> +out:
> +	if (error) {
> +		int	error2;
> +
> +		error2 = xfs_fsverity_delete_metadata(ip);
> +		if (error2)
> +			xfs_alert(ip->i_mount,
> +"ino 0x%llx failed to clean up new fsverity metadata, err %d",
> +					I_INO(ip), error2);

We just set S_VERITY on the VFS inoe, but then xfs_free_eofblocks fails.
Should we clear S_VERITY?

Does xfs_fsverity_delete_metadata need to clear XFS_DIFLAG2_VERITY?

> +	}
> +
> +	xfs_iflags_clear(ip, XFS_VERITY_CONSTRUCTION);
> +	return error;
> +}
> +
> +/*
> + * Retrieve a merkle tree block.
> + */
> +static struct page *
> +xfs_fsverity_read_merkle(
> +	struct inode		*inode,
> +	pgoff_t			index)
> +{
> +	index += xfs_fsverity_metadata_offset(XFS_I(inode)) >> PAGE_SHIFT;
> +
> +	return generic_read_merkle_tree_page(inode, index);
> +}
> +
> +/*
> + * Retrieve a merkle tree block.
> + */
> +static void
> +xfs_fsverity_readahead_merkle_tree(
> +	struct inode		*inode,
> +	pgoff_t			index,
> +	unsigned long		nr_pages)
> +{
> +	index += xfs_fsverity_metadata_offset(XFS_I(inode)) >> PAGE_SHIFT;
> +
> +	generic_readahead_merkle_tree(inode, index, nr_pages);
> +}
> +
> +/*
> + * Write a merkle tree block.
> + */
> +static int
> +xfs_fsverity_write_merkle(
> +	struct file		*file,
> +	const void		*buf,
> +	u64			pos,
> +	unsigned int		size,
> +	const u8		*zero_digest,
> +	unsigned int		digest_size)
> +{
> +	struct inode		*inode = file_inode(file);
> +	struct xfs_inode	*ip = XFS_I(inode);
> +	loff_t			position = pos +
> +		xfs_fsverity_metadata_offset(ip);
> +
> +	if (position + size > inode->i_sb->s_maxbytes)
> +		return -EFBIG;
> +
> +	/*
> +	 * If this is a block full of hashes of zeroed blocks, don't bother
> +	 * storing the block. We can synthesize them later.
> +	 *
> +	 * However, do this only in case Merkle tree block == fs block size.
> +	 * Iomap synthesizes these blocks based on holes in the merkle tree. We
> +	 * won't be able to tell if something need to be synthesizes for the
> +	 * range in the fs block. For example, for 4k filesystem block
> +	 *
> +	 *	[ 1k | zero hashes | zero hashes | 1k ]
> +	 *
> +	 * Iomap won't know about these empty blocks.
> +	 */
> +	if (size == ip->i_mount->m_sb.sb_blocksize &&
> +			/*
> +			 * First digest is zero_digest
> +			 */
> +			memcmp(buf, zero_digest, digest_size) == 0 &&
> +			/*
> +			 * Every digest is same as previous, thus all are
> +			 * zero_digest
> +			 */
> +			memcmp(buf + digest_size, buf, size - digest_size) == 0)

Weird indentation in this very long if test.  Please just put that in a
separate helper:

static inline bool
xfs_fsverity_is_hashes_of_zeroed_blocks(...)
{
	/*
	 * If this is a block full of hashes of zeroed blocks, don't bother
	 * storing the block. We can synthesize them later.
	 *
	 * However, do this only in case Merkle tree block == fs block size.
	 * Iomap synthesizes these blocks based on holes in the merkle tree. We
	 * won't be able to tell if something need to be synthesizes for the
	 * range in the fs block. For example, for 4k filesystem block
	 *
	 *	[ 1k | zero hashes | zero hashes | 1k ]
	 *
	 * Iomap won't know about these empty blocks.
	 */
	if (size != ip->i_mount->m_sb.sb_blocksize)
		return false;
	/*
	 * First digest is zero_digest
	 */
	if (memcmp(buf, zero_digest, digest_size))
		return false;
	/*
	 * Every digest is same as previous, thus all are
	 * zero_digest
	 */
	return memcmp(buf + digest_size, buf, size - digest_size) == 0;
}

(Don't you need to compare all the hash slots in the buffer??)

Now the callsite becomes this, which I think is cleaner:

	if (xfs_fsverity_is_hashes_of_zeroed_blocks(ip, buf...))
		return 0;

--D

> +		return 0;
> +
> +	return iomap_fsverity_write(file, position, size, buf,
> +			&xfs_buffered_write_iomap_ops,
> +			&xfs_iomap_write_ops);
> +}
> +
> +const struct fsverity_operations xfs_fsverity_ops = {
> +	.begin_enable_verity		= xfs_fsverity_begin_enable,
> +	.end_enable_verity		= xfs_fsverity_end_enable,
> +	.get_verity_descriptor		= xfs_fsverity_get_descriptor,
> +	.read_merkle_tree_page		= xfs_fsverity_read_merkle,
> +	.readahead_merkle_tree		= xfs_fsverity_readahead_merkle_tree,
> +	.write_merkle_tree_block	= xfs_fsverity_write_merkle,
> +};
> diff --git a/fs/xfs/xfs_fsverity.h b/fs/xfs/xfs_fsverity.h
> index 836e3a4eb194..9290dbf576f8 100644
> --- a/fs/xfs/xfs_fsverity.h
> +++ b/fs/xfs/xfs_fsverity.h
> @@ -7,8 +7,10 @@
>  
>  #include "xfs_platform.h"
>  #include <linux/iomap.h>
> +#include <linux/fsverity.h>
>  
>  #ifdef CONFIG_FS_VERITY
> +extern const struct fsverity_operations xfs_fsverity_ops;
>  loff_t xfs_fsverity_metadata_offset(const struct xfs_inode *ip);
>  bool xfs_fsverity_is_file_data(const struct xfs_inode *ip, loff_t offset);
>  #else
> diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
> index 0243e509a468..44b13d46049c 100644
> --- a/fs/xfs/xfs_message.c
> +++ b/fs/xfs/xfs_message.c
> @@ -149,6 +149,10 @@ xfs_warn_experimental(
>  			.opstate	= XFS_OPSTATE_WARNED_LARP,
>  			.name		= "logged extended attributes",
>  		},
> +		[XFS_EXPERIMENTAL_FSVERITY] = {
> +			.opstate	= XFS_OPSTATE_WARNED_FSVERITY,
> +			.name		= "fsverity",
> +		},
>  	};
>  	ASSERT(feat >= 0 && feat < XFS_EXPERIMENTAL_MAX);
>  	BUILD_BUG_ON(ARRAY_SIZE(features) != XFS_EXPERIMENTAL_MAX);
> diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
> index 811b885f41c3..364fcc7e42b0 100644
> --- a/fs/xfs/xfs_message.h
> +++ b/fs/xfs/xfs_message.h
> @@ -93,6 +93,7 @@ void xfs_buf_alert_ratelimited(struct xfs_buf *bp, const char *rlmsg,
>  enum xfs_experimental_feat {
>  	XFS_EXPERIMENTAL_SHRINK,
>  	XFS_EXPERIMENTAL_LARP,
> +	XFS_EXPERIMENTAL_FSVERITY,
>  
>  	XFS_EXPERIMENTAL_MAX,
>  };
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 60cb54c1a5ec..a3074f060928 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -599,6 +599,8 @@ __XFS_HAS_FEAT(nouuid, NOUUID)
>  #define XFS_OPSTATE_RESUMING_QUOTAON	18
>  /* (Zoned) GC is in progress */
>  #define XFS_OPSTATE_ZONEGC_RUNNING	20
> +/* Kernel has logged a warning about fsverity support */
> +#define XFS_OPSTATE_WARNED_FSVERITY	21
>  
>  #define __XFS_IS_OPSTATE(name, NAME) \
>  static inline bool xfs_is_ ## name (struct xfs_mount *mp) \
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index aca50130625e..c5075474cd8c 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -30,6 +30,7 @@
>  #include "xfs_filestream.h"
>  #include "xfs_quota.h"
>  #include "xfs_sysfs.h"
> +#include "xfs_fsverity.h"
>  #include "xfs_ondisk.h"
>  #include "xfs_rmap_item.h"
>  #include "xfs_refcount_item.h"
> @@ -1736,6 +1737,9 @@ xfs_fs_fill_super(
>  	sb->s_quota_types = QTYPE_MASK_USR | QTYPE_MASK_GRP | QTYPE_MASK_PRJ;
>  #endif
>  	sb->s_op = &xfs_super_operations;
> +#ifdef CONFIG_FS_VERITY
> +	sb->s_vop = &xfs_fsverity_ops;
> +#endif
>  
>  	/*
>  	 * Delay mount work if the debug hook is set. This is debug
> @@ -1988,6 +1992,9 @@ xfs_fs_fill_super(
>  	if (error)
>  		goto out_filestream_unmount;
>  
> +	if (xfs_has_verity(mp))
> +		xfs_warn_experimental(mp, XFS_EXPERIMENTAL_FSVERITY);
> +
>  	root = igrab(VFS_I(mp->m_rootip));
>  	if (!root) {
>  		error = -ENOENT;
> -- 
> 2.54.0
> 
> 
