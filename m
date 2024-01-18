Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8844F10E2
	for <linux-xfs@vger.kernel.org>; Thu, 18 Jan 2024 22:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705618201; cv=none; b=PiOHFDv84XXsYU4kC1jpWL+kEckp67SlPD0ZddpKEX4TeIRT0yo9iUHyzFENiZEHjlJ6GPcYazLJcO02+xbwctZdJY+Wv9Ti7tdUgM0t7ARq19SnlKraRkhdprtG3G3vIXw2FnomH7K7cKIHCdtgQ2O5IHGs6Ms+GHJErbZqCns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705618201; c=relaxed/simple;
	bh=cuehgRkx8xIKmHDBxKJld6yNwzFh9bj/fONamICZIcc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qOxjLm9IZnsK7sLTalPuMgeqxxQZf42Vvbgn/TTy97lTOrOtP8bBnigkPBDfS6DX5pt88acxY4X84MHzZf/RP4OKefETkujYB55LJRNnYNDlKoQ1k/IvdKmASU93wpvXgLT4gK2yypZOsEvgUPUtnbl8/h8SONV4VKykqS34Sds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d9lfkV5p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d9lfkV5p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F25C3C433F1;
	Thu, 18 Jan 2024 22:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705618201;
	bh=cuehgRkx8xIKmHDBxKJld6yNwzFh9bj/fONamICZIcc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d9lfkV5pD4aS9rm92L6gLWyaiZStH+/3c/DovltRulI3dhpymOKby1E5GBDV0X7LL
	 WIVkrQR3l+XOFnarsl0ED6zxrx2UaNrffIMsEzJ0tN/AGRzvZ/HGoq4rg9l0jj008C
	 3EEgz4n+gf7NA4zH+GG4YpSKS5EuaXJ++A82aVpeeXMfDvW7+SQBO76bRO3c0lLUsS
	 JJwOKo0HNVSZpD4Nys92o/0cd1JqjB+1aJEcW0oPiPN4prgo7PvT39zZg0OCRGzlRf
	 1TcTGTj6R+K4HvnD7/sJmPvfbWcvwPCXPUuiQxDWOFbo3VNlIECAjvlKXxF5pG85Qc
	 d6uxsgZYZ+b3Q==
Date: Thu, 18 Jan 2024 14:50:00 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, willy@infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH 02/12] xfs: convert kmem_alloc() to kmalloc()
Message-ID: <20240118225000.GE674499@frogsfrogsfrogs>
References: <20240115230113.4080105-1-david@fromorbit.com>
 <20240115230113.4080105-3-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240115230113.4080105-3-david@fromorbit.com>

On Tue, Jan 16, 2024 at 09:59:40AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> kmem_alloc() is just a thin wrapper around kmalloc() these days.
> Convert everything to use kmalloc() so we can get rid of the
> wrapper.
> 
> Note: the transaction region allocation in xlog_add_to_transaction()
> can be a high order allocation. Converting it to use
> kmalloc(__GFP_NOFAIL) results in warnings in the page allocation
> code being triggered because the mm subsystem does not want us to
> use __GFP_NOFAIL with high order allocations like we've been doing
> with the kmem_alloc() wrapper for a couple of decades. Hence this
> specific case gets converted to xlog_kvmalloc() rather than
> kmalloc() to avoid this issue.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Pretty straightforward changeup,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/Makefile                   |  3 +--
>  fs/xfs/kmem.c                     | 30 ----------------------
>  fs/xfs/kmem.h                     | 42 -------------------------------
>  fs/xfs/libxfs/xfs_attr_leaf.c     |  7 +++---
>  fs/xfs/libxfs/xfs_btree_staging.c |  4 +--
>  fs/xfs/libxfs/xfs_da_btree.c      |  3 ++-
>  fs/xfs/libxfs/xfs_dir2.c          |  2 +-
>  fs/xfs/libxfs/xfs_dir2_block.c    |  2 +-
>  fs/xfs/libxfs/xfs_dir2_sf.c       |  8 +++---
>  fs/xfs/libxfs/xfs_inode_fork.c    | 15 +++++------
>  fs/xfs/xfs_attr_list.c            |  2 +-
>  fs/xfs/xfs_buf.c                  |  6 ++---
>  fs/xfs/xfs_buf_item_recover.c     |  2 +-
>  fs/xfs/xfs_filestream.c           |  2 +-
>  fs/xfs/xfs_inode_item_recover.c   |  3 ++-
>  fs/xfs/xfs_iwalk.c                |  2 +-
>  fs/xfs/xfs_log_recover.c          |  2 +-
>  fs/xfs/xfs_qm.c                   |  3 ++-
>  fs/xfs/xfs_rtalloc.c              |  2 +-
>  fs/xfs/xfs_super.c                |  2 +-
>  fs/xfs/xfs_trace.h                | 25 ------------------
>  21 files changed, 36 insertions(+), 131 deletions(-)
>  delete mode 100644 fs/xfs/kmem.c
> 
> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index fbe3cdc79036..35a23427055b 100644
> --- a/fs/xfs/Makefile
> +++ b/fs/xfs/Makefile
> @@ -92,8 +92,7 @@ xfs-y				+= xfs_aops.o \
>  				   xfs_symlink.o \
>  				   xfs_sysfs.o \
>  				   xfs_trans.o \
> -				   xfs_xattr.o \
> -				   kmem.o
> +				   xfs_xattr.o
>  
>  # low-level transaction/log code
>  xfs-y				+= xfs_log.o \
> diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
> deleted file mode 100644
> index c557a030acfe..000000000000
> --- a/fs/xfs/kmem.c
> +++ /dev/null
> @@ -1,30 +0,0 @@
> -// SPDX-License-Identifier: GPL-2.0
> -/*
> - * Copyright (c) 2000-2005 Silicon Graphics, Inc.
> - * All Rights Reserved.
> - */
> -#include "xfs.h"
> -#include "xfs_message.h"
> -#include "xfs_trace.h"
> -
> -void *
> -kmem_alloc(size_t size, xfs_km_flags_t flags)
> -{
> -	int	retries = 0;
> -	gfp_t	lflags = kmem_flags_convert(flags);
> -	void	*ptr;
> -
> -	trace_kmem_alloc(size, flags, _RET_IP_);
> -
> -	do {
> -		ptr = kmalloc(size, lflags);
> -		if (ptr || (flags & KM_MAYFAIL))
> -			return ptr;
> -		if (!(++retries % 100))
> -			xfs_err(NULL,
> -	"%s(%u) possible memory allocation deadlock size %u in %s (mode:0x%x)",
> -				current->comm, current->pid,
> -				(unsigned int)size, __func__, lflags);
> -		memalloc_retry_wait(lflags);
> -	} while (1);
> -}
> diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
> index bce31182c9e8..1343f1a6f99b 100644
> --- a/fs/xfs/kmem.h
> +++ b/fs/xfs/kmem.h
> @@ -15,48 +15,6 @@
>   * General memory allocation interfaces
>   */
>  
> -typedef unsigned __bitwise xfs_km_flags_t;
> -#define KM_NOFS		((__force xfs_km_flags_t)0x0004u)
> -#define KM_MAYFAIL	((__force xfs_km_flags_t)0x0008u)
> -#define KM_ZERO		((__force xfs_km_flags_t)0x0010u)
> -#define KM_NOLOCKDEP	((__force xfs_km_flags_t)0x0020u)
> -
> -/*
> - * We use a special process flag to avoid recursive callbacks into
> - * the filesystem during transactions.  We will also issue our own
> - * warnings, so we explicitly skip any generic ones (silly of us).
> - */
> -static inline gfp_t
> -kmem_flags_convert(xfs_km_flags_t flags)
> -{
> -	gfp_t	lflags;
> -
> -	BUG_ON(flags & ~(KM_NOFS | KM_MAYFAIL | KM_ZERO | KM_NOLOCKDEP));
> -
> -	lflags = GFP_KERNEL | __GFP_NOWARN;
> -	if (flags & KM_NOFS)
> -		lflags &= ~__GFP_FS;
> -
> -	/*
> -	 * Default page/slab allocator behavior is to retry for ever
> -	 * for small allocations. We can override this behavior by using
> -	 * __GFP_RETRY_MAYFAIL which will tell the allocator to retry as long
> -	 * as it is feasible but rather fail than retry forever for all
> -	 * request sizes.
> -	 */
> -	if (flags & KM_MAYFAIL)
> -		lflags |= __GFP_RETRY_MAYFAIL;
> -
> -	if (flags & KM_ZERO)
> -		lflags |= __GFP_ZERO;
> -
> -	if (flags & KM_NOLOCKDEP)
> -		lflags |= __GFP_NOLOCKDEP;
> -
> -	return lflags;
> -}
> -
> -extern void *kmem_alloc(size_t, xfs_km_flags_t);
>  static inline void  kmem_free(const void *ptr)
>  {
>  	kvfree(ptr);
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index ab4223bf51ee..033382cf514d 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -879,8 +879,7 @@ xfs_attr_shortform_to_leaf(
>  
>  	trace_xfs_attr_sf_to_leaf(args);
>  
> -	tmpbuffer = kmem_alloc(size, 0);
> -	ASSERT(tmpbuffer != NULL);
> +	tmpbuffer = kmalloc(size, GFP_KERNEL | __GFP_NOFAIL);
>  	memcpy(tmpbuffer, ifp->if_data, size);
>  	sf = (struct xfs_attr_sf_hdr *)tmpbuffer;
>  
> @@ -1059,7 +1058,7 @@ xfs_attr3_leaf_to_shortform(
>  
>  	trace_xfs_attr_leaf_to_sf(args);
>  
> -	tmpbuffer = kmem_alloc(args->geo->blksize, 0);
> +	tmpbuffer = kmalloc(args->geo->blksize, GFP_KERNEL | __GFP_NOFAIL);
>  	if (!tmpbuffer)
>  		return -ENOMEM;
>  
> @@ -1533,7 +1532,7 @@ xfs_attr3_leaf_compact(
>  
>  	trace_xfs_attr_leaf_compact(args);
>  
> -	tmpbuffer = kmem_alloc(args->geo->blksize, 0);
> +	tmpbuffer = kmalloc(args->geo->blksize, GFP_KERNEL | __GFP_NOFAIL);
>  	memcpy(tmpbuffer, bp->b_addr, args->geo->blksize);
>  	memset(bp->b_addr, 0, args->geo->blksize);
>  	leaf_src = (xfs_attr_leafblock_t *)tmpbuffer;
> diff --git a/fs/xfs/libxfs/xfs_btree_staging.c b/fs/xfs/libxfs/xfs_btree_staging.c
> index eff29425fd76..065e4a00a2f4 100644
> --- a/fs/xfs/libxfs/xfs_btree_staging.c
> +++ b/fs/xfs/libxfs/xfs_btree_staging.c
> @@ -139,7 +139,7 @@ xfs_btree_stage_afakeroot(
>  	ASSERT(!(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE));
>  	ASSERT(cur->bc_tp == NULL);
>  
> -	nops = kmem_alloc(sizeof(struct xfs_btree_ops), KM_NOFS);
> +	nops = kmalloc(sizeof(struct xfs_btree_ops), GFP_NOFS | __GFP_NOFAIL);
>  	memcpy(nops, cur->bc_ops, sizeof(struct xfs_btree_ops));
>  	nops->alloc_block = xfs_btree_fakeroot_alloc_block;
>  	nops->free_block = xfs_btree_fakeroot_free_block;
> @@ -220,7 +220,7 @@ xfs_btree_stage_ifakeroot(
>  	ASSERT(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE);
>  	ASSERT(cur->bc_tp == NULL);
>  
> -	nops = kmem_alloc(sizeof(struct xfs_btree_ops), KM_NOFS);
> +	nops = kmalloc(sizeof(struct xfs_btree_ops), GFP_NOFS | __GFP_NOFAIL);
>  	memcpy(nops, cur->bc_ops, sizeof(struct xfs_btree_ops));
>  	nops->alloc_block = xfs_btree_fakeroot_alloc_block;
>  	nops->free_block = xfs_btree_fakeroot_free_block;
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 73aae6543906..331b9251b185 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -2182,7 +2182,8 @@ xfs_da_grow_inode_int(
>  		 * If we didn't get it and the block might work if fragmented,
>  		 * try without the CONTIG flag.  Loop until we get it all.
>  		 */
> -		mapp = kmem_alloc(sizeof(*mapp) * count, 0);
> +		mapp = kmalloc(sizeof(*mapp) * count,
> +				GFP_KERNEL | __GFP_NOFAIL);
>  		for (b = *bno, mapi = 0; b < *bno + count; ) {
>  			c = (int)(*bno + count - b);
>  			nmap = min(XFS_BMAP_MAX_NMAP, c);
> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> index 54915a302e96..370d67300455 100644
> --- a/fs/xfs/libxfs/xfs_dir2.c
> +++ b/fs/xfs/libxfs/xfs_dir2.c
> @@ -333,7 +333,7 @@ xfs_dir_cilookup_result(
>  					!(args->op_flags & XFS_DA_OP_CILOOKUP))
>  		return -EEXIST;
>  
> -	args->value = kmem_alloc(len, KM_NOFS | KM_MAYFAIL);
> +	args->value = kmalloc(len, GFP_NOFS | __GFP_RETRY_MAYFAIL);
>  	if (!args->value)
>  		return -ENOMEM;
>  
> diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
> index 3c256d4cc40b..506c65caaec5 100644
> --- a/fs/xfs/libxfs/xfs_dir2_block.c
> +++ b/fs/xfs/libxfs/xfs_dir2_block.c
> @@ -1108,7 +1108,7 @@ xfs_dir2_sf_to_block(
>  	 * Copy the directory into a temporary buffer.
>  	 * Then pitch the incore inode data so we can make extents.
>  	 */
> -	sfp = kmem_alloc(ifp->if_bytes, 0);
> +	sfp = kmalloc(ifp->if_bytes, GFP_KERNEL | __GFP_NOFAIL);
>  	memcpy(sfp, oldsfp, ifp->if_bytes);
>  
>  	xfs_idata_realloc(dp, -ifp->if_bytes, XFS_DATA_FORK);
> diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> index e1f83fc7b6ad..7b1f41cff9e0 100644
> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> @@ -276,7 +276,7 @@ xfs_dir2_block_to_sf(
>  	 * format the data into.  Once we have formatted the data, we can free
>  	 * the block and copy the formatted data into the inode literal area.
>  	 */
> -	sfp = kmem_alloc(mp->m_sb.sb_inodesize, 0);
> +	sfp = kmalloc(mp->m_sb.sb_inodesize, GFP_KERNEL | __GFP_NOFAIL);
>  	memcpy(sfp, sfhp, xfs_dir2_sf_hdr_size(sfhp->i8count));
>  
>  	/*
> @@ -524,7 +524,7 @@ xfs_dir2_sf_addname_hard(
>  	 * Copy the old directory to the stack buffer.
>  	 */
>  	old_isize = (int)dp->i_disk_size;
> -	buf = kmem_alloc(old_isize, 0);
> +	buf = kmalloc(old_isize, GFP_KERNEL | __GFP_NOFAIL);
>  	oldsfp = (xfs_dir2_sf_hdr_t *)buf;
>  	memcpy(oldsfp, dp->i_df.if_data, old_isize);
>  	/*
> @@ -1151,7 +1151,7 @@ xfs_dir2_sf_toino4(
>  	 * Don't want xfs_idata_realloc copying the data here.
>  	 */
>  	oldsize = dp->i_df.if_bytes;
> -	buf = kmem_alloc(oldsize, 0);
> +	buf = kmalloc(oldsize, GFP_KERNEL | __GFP_NOFAIL);
>  	ASSERT(oldsfp->i8count == 1);
>  	memcpy(buf, oldsfp, oldsize);
>  	/*
> @@ -1223,7 +1223,7 @@ xfs_dir2_sf_toino8(
>  	 * Don't want xfs_idata_realloc copying the data here.
>  	 */
>  	oldsize = dp->i_df.if_bytes;
> -	buf = kmem_alloc(oldsize, 0);
> +	buf = kmalloc(oldsize, GFP_KERNEL | __GFP_NOFAIL);
>  	ASSERT(oldsfp->i8count == 0);
>  	memcpy(buf, oldsfp, oldsize);
>  	/*
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index f4569e18a8d0..f3cf7f933e15 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -50,7 +50,7 @@ xfs_init_local_fork(
>  		mem_size++;
>  
>  	if (size) {
> -		char *new_data = kmem_alloc(mem_size, KM_NOFS);
> +		char *new_data = kmalloc(mem_size, GFP_NOFS | __GFP_NOFAIL);
>  
>  		memcpy(new_data, data, size);
>  		if (zero_terminate)
> @@ -77,7 +77,7 @@ xfs_iformat_local(
>  	/*
>  	 * If the size is unreasonable, then something
>  	 * is wrong and we just bail out rather than crash in
> -	 * kmem_alloc() or memcpy() below.
> +	 * kmalloc() or memcpy() below.
>  	 */
>  	if (unlikely(size > XFS_DFORK_SIZE(dip, ip->i_mount, whichfork))) {
>  		xfs_warn(ip->i_mount,
> @@ -116,7 +116,7 @@ xfs_iformat_extents(
>  
>  	/*
>  	 * If the number of extents is unreasonable, then something is wrong and
> -	 * we just bail out rather than crash in kmem_alloc() or memcpy() below.
> +	 * we just bail out rather than crash in kmalloc() or memcpy() below.
>  	 */
>  	if (unlikely(size < 0 || size > XFS_DFORK_SIZE(dip, mp, whichfork))) {
>  		xfs_warn(ip->i_mount, "corrupt inode %llu ((a)extents = %llu).",
> @@ -205,7 +205,7 @@ xfs_iformat_btree(
>  	}
>  
>  	ifp->if_broot_bytes = size;
> -	ifp->if_broot = kmem_alloc(size, KM_NOFS);
> +	ifp->if_broot = kmalloc(size, GFP_NOFS | __GFP_NOFAIL);
>  	ASSERT(ifp->if_broot != NULL);
>  	/*
>  	 * Copy and convert from the on-disk structure
> @@ -399,7 +399,8 @@ xfs_iroot_realloc(
>  		 */
>  		if (ifp->if_broot_bytes == 0) {
>  			new_size = XFS_BMAP_BROOT_SPACE_CALC(mp, rec_diff);
> -			ifp->if_broot = kmem_alloc(new_size, KM_NOFS);
> +			ifp->if_broot = kmalloc(new_size,
> +						GFP_NOFS | __GFP_NOFAIL);
>  			ifp->if_broot_bytes = (int)new_size;
>  			return;
>  		}
> @@ -440,7 +441,7 @@ xfs_iroot_realloc(
>  	else
>  		new_size = 0;
>  	if (new_size > 0) {
> -		new_broot = kmem_alloc(new_size, KM_NOFS);
> +		new_broot = kmalloc(new_size, GFP_NOFS | __GFP_NOFAIL);
>  		/*
>  		 * First copy over the btree block header.
>  		 */
> @@ -488,7 +489,7 @@ xfs_iroot_realloc(
>   *
>   * If the amount of space needed has decreased below the size of the
>   * inline buffer, then switch to using the inline buffer.  Otherwise,
> - * use kmem_realloc() or kmem_alloc() to adjust the size of the buffer
> + * use krealloc() or kmalloc() to adjust the size of the buffer
>   * to what is needed.
>   *
>   * ip -- the inode whose if_data area is changing
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index e368ad671e26..5f7a44d21cc9 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -109,7 +109,7 @@ xfs_attr_shortform_list(
>  	 * It didn't all fit, so we have to sort everything on hashval.
>  	 */
>  	sbsize = sf->count * sizeof(*sbuf);
> -	sbp = sbuf = kmem_alloc(sbsize, KM_NOFS);
> +	sbp = sbuf = kmalloc(sbsize, GFP_NOFS | __GFP_NOFAIL);
>  
>  	/*
>  	 * Scan the attribute list for the rest of the entries, storing
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 710ea4c97122..c348af806616 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -325,14 +325,14 @@ xfs_buf_alloc_kmem(
>  	struct xfs_buf	*bp,
>  	xfs_buf_flags_t	flags)
>  {
> -	xfs_km_flags_t	kmflag_mask = KM_NOFS;
> +	gfp_t		gfp_mask = GFP_NOFS | __GFP_NOFAIL;
>  	size_t		size = BBTOB(bp->b_length);
>  
>  	/* Assure zeroed buffer for non-read cases. */
>  	if (!(flags & XBF_READ))
> -		kmflag_mask |= KM_ZERO;
> +		gfp_mask |= __GFP_ZERO;
>  
> -	bp->b_addr = kmem_alloc(size, kmflag_mask);
> +	bp->b_addr = kmalloc(size, gfp_mask);
>  	if (!bp->b_addr)
>  		return -ENOMEM;
>  
> diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
> index 43167f543afc..34776f4c05ac 100644
> --- a/fs/xfs/xfs_buf_item_recover.c
> +++ b/fs/xfs/xfs_buf_item_recover.c
> @@ -85,7 +85,7 @@ xlog_add_buffer_cancelled(
>  		return false;
>  	}
>  
> -	bcp = kmem_alloc(sizeof(struct xfs_buf_cancel), 0);
> +	bcp = kmalloc(sizeof(struct xfs_buf_cancel), GFP_KERNEL | __GFP_NOFAIL);
>  	bcp->bc_blkno = blkno;
>  	bcp->bc_len = len;
>  	bcp->bc_refcount = 1;
> diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
> index 2fc98d313708..e2a3c8d3fe4f 100644
> --- a/fs/xfs/xfs_filestream.c
> +++ b/fs/xfs/xfs_filestream.c
> @@ -313,7 +313,7 @@ xfs_filestream_create_association(
>  	 * we return a referenced AG, the allocation can still go ahead just
>  	 * fine.
>  	 */
> -	item = kmem_alloc(sizeof(*item), KM_MAYFAIL);
> +	item = kmalloc(sizeof(*item), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
>  	if (!item)
>  		goto out_put_fstrms;
>  
> diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
> index 144198a6b270..5d7b937179a0 100644
> --- a/fs/xfs/xfs_inode_item_recover.c
> +++ b/fs/xfs/xfs_inode_item_recover.c
> @@ -291,7 +291,8 @@ xlog_recover_inode_commit_pass2(
>  	if (item->ri_buf[0].i_len == sizeof(struct xfs_inode_log_format)) {
>  		in_f = item->ri_buf[0].i_addr;
>  	} else {
> -		in_f = kmem_alloc(sizeof(struct xfs_inode_log_format), 0);
> +		in_f = kmalloc(sizeof(struct xfs_inode_log_format),
> +				GFP_KERNEL | __GFP_NOFAIL);
>  		need_free = 1;
>  		error = xfs_inode_item_format_convert(&item->ri_buf[0], in_f);
>  		if (error)
> diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
> index 8dbb7c054b28..5dd622aa54c5 100644
> --- a/fs/xfs/xfs_iwalk.c
> +++ b/fs/xfs/xfs_iwalk.c
> @@ -160,7 +160,7 @@ xfs_iwalk_alloc(
>  
>  	/* Allocate a prefetch buffer for inobt records. */
>  	size = iwag->sz_recs * sizeof(struct xfs_inobt_rec_incore);
> -	iwag->recs = kmem_alloc(size, KM_MAYFAIL);
> +	iwag->recs = kmalloc(size, GFP_KERNEL | __GFP_RETRY_MAYFAIL);
>  	if (iwag->recs == NULL)
>  		return -ENOMEM;
>  
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 4a27ecdbb546..e3bd503edcab 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2161,7 +2161,7 @@ xlog_recover_add_to_trans(
>  		return 0;
>  	}
>  
> -	ptr = kmem_alloc(len, 0);
> +	ptr = xlog_kvmalloc(len);
>  	memcpy(ptr, dp, len);
>  	in_f = (struct xfs_inode_log_format *)ptr;
>  
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index b9d11376c88a..b130bf49013b 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -997,7 +997,8 @@ xfs_qm_reset_dqcounts_buf(
>  	if (qip->i_nblocks == 0)
>  		return 0;
>  
> -	map = kmem_alloc(XFS_DQITER_MAP_SIZE * sizeof(*map), 0);
> +	map = kmalloc(XFS_DQITER_MAP_SIZE * sizeof(*map),
> +			GFP_KERNEL | __GFP_NOFAIL);
>  
>  	lblkno = 0;
>  	maxlblkcnt = XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 8649d981a097..8a8d6197203e 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -903,7 +903,7 @@ xfs_growfs_rt(
>  	/*
>  	 * Allocate a new (fake) mount/sb.
>  	 */
> -	nmp = kmem_alloc(sizeof(*nmp), 0);
> +	nmp = kmalloc(sizeof(*nmp), GFP_KERNEL | __GFP_NOFAIL);
>  	/*
>  	 * Loop over the bitmap blocks.
>  	 * We will do everything one bitmap block at a time.
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index d0009430a627..7b1b29814be2 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1982,7 +1982,7 @@ static int xfs_init_fs_context(
>  {
>  	struct xfs_mount	*mp;
>  
> -	mp = kmem_alloc(sizeof(struct xfs_mount), KM_ZERO);
> +	mp = kzalloc(sizeof(struct xfs_mount), GFP_KERNEL | __GFP_NOFAIL);
>  	if (!mp)
>  		return -ENOMEM;
>  
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 0984a1c884c7..c7e57efe0356 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -4040,31 +4040,6 @@ TRACE_EVENT(xfs_pwork_init,
>  		  __entry->nr_threads, __entry->pid)
>  )
>  
> -DECLARE_EVENT_CLASS(xfs_kmem_class,
> -	TP_PROTO(ssize_t size, int flags, unsigned long caller_ip),
> -	TP_ARGS(size, flags, caller_ip),
> -	TP_STRUCT__entry(
> -		__field(ssize_t, size)
> -		__field(int, flags)
> -		__field(unsigned long, caller_ip)
> -	),
> -	TP_fast_assign(
> -		__entry->size = size;
> -		__entry->flags = flags;
> -		__entry->caller_ip = caller_ip;
> -	),
> -	TP_printk("size %zd flags 0x%x caller %pS",
> -		  __entry->size,
> -		  __entry->flags,
> -		  (char *)__entry->caller_ip)
> -)
> -
> -#define DEFINE_KMEM_EVENT(name) \
> -DEFINE_EVENT(xfs_kmem_class, name, \
> -	TP_PROTO(ssize_t size, int flags, unsigned long caller_ip), \
> -	TP_ARGS(size, flags, caller_ip))
> -DEFINE_KMEM_EVENT(kmem_alloc);
> -
>  TRACE_EVENT(xfs_check_new_dalign,
>  	TP_PROTO(struct xfs_mount *mp, int new_dalign, xfs_ino_t calc_rootino),
>  	TP_ARGS(mp, new_dalign, calc_rootino),
> -- 
> 2.43.0
> 
> 
