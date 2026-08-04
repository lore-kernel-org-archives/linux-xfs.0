Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7689C3F5BEC;
	Tue,  4 Aug 2026 18:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785868063; cv=none; b=D8V3e56XTUPUk8BIKg7+wPiIb3e8aIzcu7mvjHo92aywGZClJNSOc/pteBkKgVK0hGv9bkA3OrAHQNtOqxUIgxXy5qIA8AI/tPW5fJQQ/027tzS73VZDM4hfg0QgHpN7fAmZ9wKxXVAUCdpoEA/sTnf3XUq2Fsk6Qyi0oJoD8+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785868063; c=relaxed/simple;
	bh=Iidv4SMnZDjuFwyv23A1IWyacYb7pIK4RptW6fi4czc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=msVP/l3TzazPJ+HJt2TZwiCnW0LMhGsu769W44PqKeIr6ilKnVS7dbfKW3s9zfIqaJr5R7eH0CA1Yz/uOs/++XNeQDFCFk5XSBdoIMrU6GcuJrh35q4QTud9xuLRWosYEO1lWNJQ25K+5GVZwuJiVMpF1yV+BW9/9lPhRqvPTZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PRfa3OCa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PRfa3OCa"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 074181F000E9;
	Tue,  4 Aug 2026 18:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785868061;
	bh=ZS/GlYTnQK5yougZZrLqepAErNkwEUMIDq85OusLBZo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PRfa3OCaA2/f74uUOp4i7hwZH5bvALHMcMadVxdRtZ6d57nV2Jwu80R8tW4esmb0s
	 TJTjRCA7tDVp3hGt5rb12T3gr4+pRJhIysuFMhdPNLVVAp9IDhN0tZ5YBbYMjNj+tm
	 BTFUDGzSMlNRIg4lb7Zewo7zLxIt7ueaSgki6AY5OmajV/CtsTsjdNUu7hbF2gtM11
	 B3+Ud5tPmOUG1DmCExF6BD4YO5lG7PFZuHdEcPbhObAmCLw0H1vfy0yVhjeJJwe30W
	 M6822BgcNGsiIlyf68JFqdgBKVD+ZneaiYLloiM2JPwUUh/lu32OoLzu7MkjHbiaxh
	 u7UYlmrLptrng==
Date: Tue, 4 Aug 2026 11:27:40 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v14 12/21] xfs: handle fsverity I/O in write/read path
Message-ID: <20260804182740.GN3556460@frogsfrogsfrogs>
References: <20260803200820.393203-1-aalbersh@kernel.org>
 <20260803200820.393203-13-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260803200820.393203-13-aalbersh@kernel.org>

On Mon, Aug 03, 2026 at 10:08:02PM +0200, Andrey Albershteyn wrote:
> For write/writeback set IOMAP_F_FSVERITY flag telling iomap to not
> update inode size and to not skip folios beyond EOF.
> 
> Initiate fsverity writeback with IOMAP_F_FSVERITY set to tell iomap
> should not skip folio that is dirty beyond EOF.
> 
> In read path let iomap know that we are reading fsverity metadata. So,
> treat holes in the tree as request to synthesize tree blocks and hole
> after descriptor as end of the fsverity region.
> 
> Introduce a new inode flag meaning that merkle tree is being build on
> the inode.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> ---
>  fs/xfs/Makefile          |  1 +
>  fs/xfs/libxfs/xfs_bmap.c | 11 +++++++++++
>  fs/xfs/xfs_aops.c        | 37 +++++++++++++++++++++++++++++++------
>  fs/xfs/xfs_fsverity.c    | 22 ++++++++++++++++++++++
>  fs/xfs/xfs_fsverity.h    | 20 ++++++++++++++++++++
>  fs/xfs/xfs_inode.h       |  6 ++++++
>  fs/xfs/xfs_iomap.c       | 29 +++++++++++++++++++++++------
>  7 files changed, 114 insertions(+), 12 deletions(-)
>  create mode 100644 fs/xfs/xfs_fsverity.c
>  create mode 100644 fs/xfs/xfs_fsverity.h
> 
> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index 399a207f2d0e..dd712c521862 100644
> --- a/fs/xfs/Makefile
> +++ b/fs/xfs/Makefile
> @@ -150,6 +150,7 @@ xfs-$(CONFIG_XFS_POSIX_ACL)	+= xfs_acl.o
>  xfs-$(CONFIG_SYSCTL)		+= xfs_sysctl.o
>  xfs-$(CONFIG_COMPAT)		+= xfs_ioctl32.o
>  xfs-$(CONFIG_EXPORTFS_BLOCK_OPS)	+= xfs_pnfs.o
> +xfs-$(CONFIG_FS_VERITY)		+= xfs_fsverity.o
>  
>  # notify failure
>  ifeq ($(CONFIG_MEMORY_FAILURE),y)
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index d64defeda645..cc48f6e20e80 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -41,6 +41,8 @@
>  #include "xfs_inode_util.h"
>  #include "xfs_rtgroup.h"
>  #include "xfs_zone_alloc.h"
> +#include "xfs_fsverity.h"
> +#include <linux/fsverity.h>
>  
>  struct kmem_cache		*xfs_bmap_intent_cache;
>  
> @@ -4402,6 +4404,10 @@ xfs_bmapi_convert_one_delalloc(
>  	 * the extent.  Just return the real extent at this offset.
>  	 */
>  	if (!isnullstartblock(bma.got.br_startblock)) {
> +		if (xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION) &&
> +		    XFS_FSB_TO_B(mp, bma.got.br_startoff) >=
> +			    xfs_fsverity_metadata_offset(ip))
> +			flags |= IOMAP_F_FSVERITY;
>  		xfs_bmbt_to_iomap(ip, iomap, &bma.got, 0, flags,
>  				xfs_iomap_inode_sequence(ip, flags));
>  		if (seq)
> @@ -4449,6 +4455,11 @@ xfs_bmapi_convert_one_delalloc(
>  	XFS_STATS_ADD(mp, xs_xstrat_bytes, XFS_FSB_TO_B(mp, bma.length));
>  	XFS_STATS_INC(mp, xs_xstrat_quick);
>  
> +	if (xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION) &&
> +	    XFS_FSB_TO_B(mp, bma.got.br_startoff) >=
> +		    xfs_fsverity_metadata_offset(ip))
> +		flags |= IOMAP_F_FSVERITY;
> +
>  	ASSERT(!isnullstartblock(bma.got.br_startblock));
>  	xfs_bmbt_to_iomap(ip, iomap, &bma.got, 0, flags,
>  				xfs_iomap_inode_sequence(ip, flags));
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 76918bd15ca8..b8813e577285 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -23,6 +23,7 @@
>  #include "xfs_ioend.h"
>  #include "xfs_zone_alloc.h"
>  #include "xfs_rtgroup.h"
> +#include "xfs_fsverity.h"
>  
>  struct xfs_writepage_ctx {
>  	struct iomap_writepage_ctx ctx;
> @@ -172,12 +173,16 @@ xfs_map_blocks(
>  	int			retries = 0;
>  	int			error = 0;
>  	unsigned int		*seq;
> +	unsigned int		iomap_flags = 0;
>  
>  	if (xfs_is_shutdown(mp))
>  		return -EIO;
>  
>  	XFS_ERRORTAG_DELAY(mp, XFS_ERRTAG_WB_DELAY_MS);
>  
> +	if (xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION))
> +		iomap_flags |= IOMAP_F_FSVERITY;
> +
>  	/*
>  	 * COW fork blocks can overlap data fork blocks even if the blocks
>  	 * aren't shared.  COW I/O always takes precedent, so we must always
> @@ -265,7 +270,8 @@ xfs_map_blocks(
>  	    isnullstartblock(imap.br_startblock))
>  		goto allocate_blocks;
>  
> -	xfs_bmbt_to_iomap(ip, &wpc->iomap, &imap, 0, 0, XFS_WPC(wpc)->data_seq);
> +	xfs_bmbt_to_iomap(ip, &wpc->iomap, &imap, 0, iomap_flags,
> +			  XFS_WPC(wpc)->data_seq);
>  	trace_xfs_map_blocks_found(ip, offset, count, whichfork, &imap);
>  	return 0;
>  allocate_blocks:
> @@ -412,12 +418,16 @@ xfs_zoned_map_blocks(
>  	xfs_filblks_t		count_fsb;
>  	struct xfs_bmbt_irec	imap, del;
>  	struct xfs_iext_cursor	icur;
> +	u16			iomap_flags = 0;
>  
>  	if (xfs_is_shutdown(mp))
>  		return -EIO;
>  
>  	XFS_ERRORTAG_DELAY(mp, XFS_ERRTAG_WB_DELAY_MS);
>  
> +	if (xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION))
> +		iomap_flags |= IOMAP_F_FSVERITY;
> +
>  	/*
>  	 * All dirty data must be covered by delalloc extents.  But truncate can
>  	 * remove delalloc extents underneath us or reduce their size.
> @@ -441,7 +451,7 @@ xfs_zoned_map_blocks(
>  		imap.br_startblock = HOLESTARTBLOCK;
>  		imap.br_state = XFS_EXT_NORM;
>  		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> -		xfs_bmbt_to_iomap(ip, &wpc->iomap, &imap, 0, 0, 0);
> +		xfs_bmbt_to_iomap(ip, &wpc->iomap, &imap, 0, iomap_flags, 0);
>  		return 0;
>  	}
>  	end_fsb = min(end_fsb, imap.br_startoff + imap.br_blockcount);
> @@ -454,11 +464,10 @@ xfs_zoned_map_blocks(
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  
>  	wpc->iomap.type = IOMAP_MAPPED;
> -	wpc->iomap.flags = IOMAP_F_DIRTY;

Uh, what's this?

>  	wpc->iomap.bdev = mp->m_rtdev_targp->bt_bdev;
>  	wpc->iomap.offset = offset;
>  	wpc->iomap.length = XFS_FSB_TO_B(mp, count_fsb);
> -	wpc->iomap.flags = IOMAP_F_ANON_WRITE;

because we blow away IOMAP_F_DIRTY here??

This just looks wrong and in need of fixing ASAP.  Unless the DIRTY flag
truly isn't necessary?  I would think we'd need that since we're writing
to a new mapping and need a metadata flush...?

> +	wpc->iomap.flags = iomap_flags | IOMAP_F_ANON_WRITE;

Because afaict the correct post-patch code should be:

	wpc->iomap.flags = iomap_flags | IOMAP_F_ANON_WRITE |
					 IOMAP_F_DIRTY;

The rest of the patch looks ok to me.

--D

>  
>  	trace_xfs_zoned_map_blocks(ip, offset, wpc->iomap.length);
>  	return 0;
> @@ -504,6 +513,22 @@ static const struct iomap_writeback_ops xfs_zoned_writeback_ops = {
>  	.writeback_submit	= xfs_zoned_writeback_submit,
>  };
>  
> +static int
> +xfs_iomap_writepages(
> +	struct xfs_inode		*ip,
> +	struct iomap_writepage_ctx	*ctx)
> +{
> +	/*
> +	 * Writeback does not work for folios past EOF, let it know that
> +	 * I/O happens for fsverity metadata and this restriction need
> +	 * to be skipped
> +	 */
> +	if (xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION))
> +		ctx->iomap.flags |= IOMAP_F_FSVERITY;
> +
> +	return iomap_writepages(ctx);
> +}
> +
>  STATIC int
>  xfs_vm_writepages(
>  	struct address_space	*mapping,
> @@ -523,7 +548,7 @@ xfs_vm_writepages(
>  		};
>  		int				error;
>  
> -		error = iomap_writepages(&xc.ctx);
> +		error = xfs_iomap_writepages(ip, &xc.ctx);
>  		if (xc.open_zone)
>  			xfs_open_zone_put(xc.open_zone);
>  		return error;
> @@ -536,7 +561,7 @@ xfs_vm_writepages(
>  			},
>  		};
>  
> -		return iomap_writepages(&wpc.ctx);
> +		return xfs_iomap_writepages(ip, &wpc.ctx);
>  	}
>  }
>  
> diff --git a/fs/xfs/xfs_fsverity.c b/fs/xfs/xfs_fsverity.c
> new file mode 100644
> index 000000000000..d86009629b56
> --- /dev/null
> +++ b/fs/xfs/xfs_fsverity.c
> @@ -0,0 +1,22 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2026 Red Hat, Inc.
> + */
> +#include "xfs_platform.h"
> +#include "xfs_fs.h"
> +#include "xfs_shared.h"
> +#include "xfs_format.h"
> +#include "xfs_log_format.h"
> +#include "xfs_trans_resv.h"
> +#include "xfs_mount.h"
> +#include "xfs_inode.h"
> +#include "xfs_fsverity.h"
> +#include <linux/fsverity.h>
> +#include <linux/iomap.h>
> +
> +loff_t
> +xfs_fsverity_metadata_offset(
> +	const struct xfs_inode	*ip)
> +{
> +	return round_up(i_size_read(VFS_IC(ip)), XFS_FSVERITY_START_ALIGN);
> +}
> diff --git a/fs/xfs/xfs_fsverity.h b/fs/xfs/xfs_fsverity.h
> new file mode 100644
> index 000000000000..5771db2cd797
> --- /dev/null
> +++ b/fs/xfs/xfs_fsverity.h
> @@ -0,0 +1,20 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2026 Red Hat, Inc.
> + */
> +#ifndef __XFS_FSVERITY_H__
> +#define __XFS_FSVERITY_H__
> +
> +#include "xfs_platform.h"
> +
> +#ifdef CONFIG_FS_VERITY
> +loff_t xfs_fsverity_metadata_offset(const struct xfs_inode *ip);
> +#else
> +static inline loff_t xfs_fsverity_metadata_offset(const struct xfs_inode *ip)
> +{
> +	WARN_ON_ONCE(1);
> +	return ULLONG_MAX;
> +}
> +#endif	/* CONFIG_FS_VERITY */
> +
> +#endif	/* __XFS_FSVERITY_H__ */
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 34c1038ebfcd..17ce083591f4 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -419,6 +419,12 @@ static inline bool xfs_inode_can_sw_atomic_write(const struct xfs_inode *ip)
>   */
>  #define XFS_IREMAPPING		(1U << 15)
>  
> +/*
> + * fs-verity's Merkle tree is under construction. The file is read-only, the
> + * only writes happening are for the fsverity metadata.
> + */
> +#define XFS_VERITY_CONSTRUCTION	(1U << 16)
> +
>  /* All inode state flags related to inode reclaim. */
>  #define XFS_ALL_IRECLAIM_FLAGS	(XFS_IRECLAIMABLE | \
>  				 XFS_IRECLAIM | \
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 225c3de88d03..a4d565661989 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -32,6 +32,8 @@
>  #include "xfs_rtbitmap.h"
>  #include "xfs_icache.h"
>  #include "xfs_zone_alloc.h"
> +#include "xfs_fsverity.h"
> +#include <linux/fsverity.h>
>  
>  #define XFS_ALLOC_ALIGN(mp, off) \
>  	(((off) >> mp->m_allocsize_log) << mp->m_allocsize_log)
> @@ -883,6 +885,9 @@ xfs_direct_write_iomap_begin(
>  	if (flags & IOMAP_ATOMIC)
>  		iomap_flags |= IOMAP_F_ATOMIC_BIO;
>  
> +	if (xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION))
> +		iomap_flags |= IOMAP_F_FSVERITY;
> +
>  	/*
>  	 * COW writes may allocate delalloc space or convert unwritten COW
>  	 * extents, so we need to make sure to take the lock exclusively here.
> @@ -1589,7 +1594,8 @@ xfs_zoned_buffered_write_iomap_begin(
>  	loff_t			count,
>  	unsigned		flags,
>  	struct iomap		*iomap,
> -	struct iomap		*srcmap)
> +	struct iomap		*srcmap,
> +	u16			iomap_flags)
>  {
>  	struct iomap_iter	*iter =
>  		container_of(iomap, struct iomap_iter, iomap);
> @@ -1599,7 +1605,6 @@ xfs_zoned_buffered_write_iomap_begin(
>  	struct xfs_mount	*mp = ip->i_mount;
>  	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
>  	xfs_fileoff_t		end_fsb = xfs_iomap_end_fsb(mp, offset, count);
> -	u16			iomap_flags = IOMAP_F_SHARED;
>  	unsigned int		lockmode = XFS_ILOCK_EXCL;
>  	xfs_filblks_t		count_fsb;
>  	xfs_extlen_t		indlen;
> @@ -1662,7 +1667,8 @@ xfs_zoned_buffered_write_iomap_begin(
>  				smap.br_startoff + smap.br_blockcount);
>  			xfs_trim_extent(&smap, offset_fsb,
>  					end_fsb - offset_fsb);
> -			error = xfs_bmbt_to_iomap(ip, srcmap, &smap, flags, 0,
> +			error = xfs_bmbt_to_iomap(ip, srcmap, &smap, flags,
> +					iomap_flags,
>  					xfs_iomap_inode_sequence(ip, 0));
>  			if (error)
>  				goto out_unlock;
> @@ -1672,6 +1678,8 @@ xfs_zoned_buffered_write_iomap_begin(
>  	if (!ip->i_cowfp)
>  		xfs_ifork_init_cow(ip);
>  
> +	iomap_flags |= IOMAP_F_SHARED;
> +
>  	if (!xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb, &icur, &got))
>  		got.br_startoff = end_fsb;
>  	if (got.br_startoff <= offset_fsb) {
> @@ -1803,9 +1811,12 @@ xfs_buffered_write_iomap_begin(
>  	if (xfs_is_shutdown(mp))
>  		return -EIO;
>  
> +	if (xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION))
> +		iomap_flags |= IOMAP_F_FSVERITY;
> +
>  	if (xfs_is_zoned_inode(ip))
>  		return xfs_zoned_buffered_write_iomap_begin(inode, offset,
> -				count, flags, iomap, srcmap);
> +				count, flags, iomap, srcmap, iomap_flags);
>  
>  	/* we can't use delayed allocations when using extent size hints */
>  	if (xfs_get_extsz_hint(ip))
> @@ -2191,12 +2202,17 @@ xfs_read_iomap_begin(
>  	bool			shared = false;
>  	unsigned int		lockmode = XFS_ILOCK_SHARED;
>  	u64			seq;
> +	unsigned int		iomap_flags = 0;
>  
>  	ASSERT(!(flags & (IOMAP_WRITE | IOMAP_ZERO)));
>  
>  	if (xfs_is_shutdown(mp))
>  		return -EIO;
>  
> +	if (fsverity_active(inode) &&
> +	    (offset >= xfs_fsverity_metadata_offset(ip)))
> +		iomap_flags |= IOMAP_F_FSVERITY;
> +
>  	error = xfs_ilock_for_iomap(ip, flags, &lockmode);
>  	if (error)
>  		return error;
> @@ -2210,8 +2226,9 @@ xfs_read_iomap_begin(
>  	if (error)
>  		return error;
>  	trace_xfs_iomap_found(ip, offset, length, XFS_DATA_FORK, &imap);
> -	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags,
> -				 shared ? IOMAP_F_SHARED : 0, seq);
> +	iomap_flags |= shared ? IOMAP_F_SHARED : 0;
> +
> +	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags, iomap_flags, seq);
>  }
>  
>  const struct iomap_ops xfs_read_iomap_ops = {
> -- 
> 2.54.0
> 
> 
