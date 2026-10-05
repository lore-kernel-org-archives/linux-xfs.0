Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C2A4E80AD;
	Mon,  5 Oct 2026 17:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791220722; cv=none; b=pByAg/JDCEKwvO2Bph0Ivc6XSu9oHTDMYG3AEh8l+dA/yAv23v1yUH6hUmMPMcH3yaaFdoFecod8DQKTwZFKQ1zZ8dIJaWj1EKAhwFTlzXe1v9EYCc6TeHAumaSqb3BlFY9mt7/TNZ3CRwOdRPeImJN2cOOuu29c2Ah2MPU3vRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791220722; c=relaxed/simple;
	bh=p8y2SWLkQ0bsXNgah/d2jg4U+TCB44ub7sLKZF6IxnA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fcg0vcOE5iz6YPFr6vSQX9f4YlAJQWAL1w1iyqMOPTjvmBN2IHLmE+78m1qkw4kNUtLn2stvMlm24zqs+9E4Gu0mQvhIzVImwe0FkWbstUEuobirsnd2jD/6IsV23XcMijLv6fkZxudqJWpT479NUpXj2+nYnp/yK+KAtRKa5F4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VUEJgA4P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VUEJgA4P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02AB71F00898;
	Mon,  5 Oct 2026 17:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791220720;
	bh=g6msS6X1Nm9a4FfZxp/QaUWM7UJBVtBa+hinGO0mETc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VUEJgA4PKsah0xZT1lr870C9hqSqsRunnnz04WlLURfD/UJTmN2lwjvFaHrddePZ6
	 AqhbxYIsXMxfNHO7b+56xgy5Zo/jCpIrLLpnxjdp0ZdCdC7E8h0G2PzWnKJr6GB0EV
	 /c+uo8VabxCcfoNi/iFpE7WFI41xxZYVncIFZalb1AMdiDe3t3UosVDI5kc5UWCixe
	 3dwxa8cVGNKvsWJ4Tw+5i9b/BrMGdnLCshVqHpBLaWbukNMK45WiuXKIHH2gTvPzdh
	 M/GZGdStGehJ5buPe6Toee94Xfg0c7bp1TuXjTn/MhYrHixG6otjZ4wpts+PbgX4qA
	 qVxVficX6gx4Q==
Date: Mon, 5 Oct 2026 19:18:35 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: djwong@kernel.org, ebiggers@kernel.org, hch@lst.de, 
	Carlos Maiolino <cem@kernel.org>
Cc: fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH v17 15/21] xfs: add fs-verity support
Message-ID: <asPEIapeSklgcsUa@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20261002223705.2175542-1-aalbersh@kernel.org>
 <20261002223705.2175542-16-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261002223705.2175542-16-aalbersh@kernel.org>

On 2026-10-03 00:36:56, Andrey Albershteyn wrote:
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
>  fs/xfs/xfs_fsverity.c | 425 +++++++++++++++++++++++++++++++++++++++++-
>  fs/xfs/xfs_fsverity.h |   2 +
>  fs/xfs/xfs_message.c  |   4 +
>  fs/xfs/xfs_message.h  |   1 +
>  fs/xfs/xfs_mount.h    |   2 +
>  fs/xfs/xfs_super.c    |   7 +
>  6 files changed, 440 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_fsverity.c b/fs/xfs/xfs_fsverity.c
> index 976e05257bf9..8cffcafc19aa 100644
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
>  mempool_t xfs_fsverity_ioend_pool;
> @@ -51,3 +60,417 @@ xfs_fsverity_is_file_data(
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
> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> +	/*
> +	 * Serialize reading of inode->i_flags with xfs_scrub clearing of this
> +	 * flag if inode is corrupted.
> +	 */
> +	if (!(inode->i_flags & S_VERITY)) {
> +		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +		return -ENODATA;
> +	}
> +	error = xfs_bmap_last_extent(NULL, ip, XFS_DATA_FORK, &rec, &is_empty);
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
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
> +	truncate_inode_pages(VFS_I(ip)->i_mapping, XFS_ISIZE(ip));

Oh I haven't paid enough attention here, it has to be moved before
xfs_ilock(ip, XFS_MMAPLOCK_EXCL) not just before the lock, to exclude
ABBA with writeback/reclaim taking folio lock and waiting for trans
space.

I will send v18 if more feedback will arrive, otherwise, I can
resend just this patch (or could be fixed during merge?).

-- 
- Andrey
