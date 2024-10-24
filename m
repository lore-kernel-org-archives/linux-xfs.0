Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3826D19DF7A
	for <linux-xfs@vger.kernel.org>; Thu, 24 Oct 2024 17:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729789239; cv=none; b=ISt/SpCPfQYFnOKHhgj6Ai16aEHHV2dhPpUCvR+NUmAwzqlRK11VI8Ddv3N8yAmtBxBUmMjj1CojdQM1bV5ii+bZpw/TPUnTsW8zN8JcA6CK8KJP29yukrpIQDkKtUJ3NEAOokEMLMF3xsVJPiRWe7Pj+58YEHyCUhU18QoeZko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729789239; c=relaxed/simple;
	bh=T468k8Gntv5CO9HyBkzxOIuBOT0yvCW+i61Xcjd8vSc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CoZYUZmgpa9iG7QMrJfe1ky+tSSfxK/gEELxmuezaR9CtmKgE79VEgD8ORxNzreNLvRqpQKClvuN/0Mcie6NaYkrsiobk6WplYdr3SdNHN2Ft/p/i3/D0L3xGGbUV7O3jqKyHInSl1AC8rUNFjyBZuf05e3oa/20Eh12Zx9XVns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I7Imb5ap; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I7Imb5ap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFAA5C4CEC7;
	Thu, 24 Oct 2024 17:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729789238;
	bh=T468k8Gntv5CO9HyBkzxOIuBOT0yvCW+i61Xcjd8vSc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I7Imb5ap1bo4GAJEv4Q0jEQ+dbMuuKTG44p8jpakIRx9Wd4IkvkQWli0ELGGTrped
	 IABS4hFpgcSGkXkwjcJNIi7W2BfUwdW/eQkp06Syi4PiwHKM0o/MkFa4JGz35sclUy
	 iy1bGWPeBtk6bFyc9/mAaAgwppdhO4IBjaB5O17FdvNRUq8q+iJ4dpxC9XKBvj/vb5
	 f/SNAfyBLf71JvEtzxIT1SqkP5oe/ffgNGLJoulAhi0MGY88DkQtRyTWBQ+hZXiUdP
	 GpwYN+aZujQ8AvZ9XKh/FqICOij226EipTqaKvRmHHWMVLx7WmPu/yaGfjAKHDPtkW
	 x2xulffyQm7OA==
Date: Thu, 24 Oct 2024 10:00:38 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: allow sparse inode records at the end of runt
 AGs
Message-ID: <20241024170038.GJ21853@frogsfrogsfrogs>
References: <20241024025142.4082218-1-david@fromorbit.com>
 <20241024025142.4082218-3-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241024025142.4082218-3-david@fromorbit.com>

On Thu, Oct 24, 2024 at 01:51:04PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Due to the failure to correctly limit sparse inode chunk allocation
> in runt AGs, we now have many production filesystems with sparse
> inode chunks allocated across the end of the runt AG. xfs_repair
> or a growfs is needed to fix this situation, neither of which are
> particularly appealing.
> 
> The on disk layout from the metadump shows AG 12 as a runt that is
> 1031 blocks in length and the last inode chunk allocated on disk at
> agino 8192.

Does this problem also happen on non-runt AGs?  If the only free space
that could be turned into a sparse cluster is unaligned space at the
end of AG 0, would you still get the same corruption error?

--D

> $ xfs_db -c "agi 12" -c "p length" -c "p newino"a \
> > -c "convert agno 12 agino 8192 agbno" \
> > -c "a free_root" -c p /mnt/scratch/t.img
> length = 1031
> newino = 8192
> 0x400 (1024)
> magic = 0x46494233
> level = 0
> numrecs = 3
> leftsib = null
> rightsib = null
> bno = 62902208
> lsn = 0xb5500001849
> uuid = e941c927-8697-4c16-a828-bc98e3878f7d
> owner = 12
> crc = 0xfe0a5c41 (correct)
> recs[1-3] = [startino,holemask,count,freecount,free]
> 1:[128,0,64,11,0xc1ff00]
> 2:[256,0,64,3,0xb]
> 3:[8192,0xff00,32,32,0xffffffffffffffff]
> 
> The agbno of the inode chunk is 0x400 (1024), but there are only 7
> blocks from there to the end of the AG. No inode cluster should have
> been allocated there, but the bug fixed in the previous commit
> allowed that. We can see from the finobt record #3 that there is a
> sparse inode record at agbno 1024 that is for 32 inodes - 4 blocks
> worth of inodes. Hence we have a valid inode cluster from agbno
> 1024-1027 on disk, and we are trying to allocation inodes from it.
> 
> This is due to the sparse inode feature requiring sb->sb_spino_align
> being set to the inode cluster size, whilst the sb->sb_inoalignmt is
> set to the full chunk size.  The args.max_agbno bug in sparse inode
> alignment allows an inode cluster at the start of the irec which is
> sb_spino_align aligned and sized, but the remainder of the irec to
> be beyond EOAG.
> 
> There is actually nothing wrong with having a sparse inode cluster
> that ends up overlapping the end of the runt AG - it just means that
> attempts to make it non-sparse will fail because there's no
> contiguous space available to fill out the chunk. However, we can't
> even get that far because xfs_inobt_get_rec() will validate the
> irec->ir_startino and xfs_verify_agino() will fail on an irec that
> spans beyond the end of the AG:
> 
> XFS (loop0): finobt record corruption in AG 12 detected at xfs_inobt_check_irec+0x44/0xb0!
> XFS (loop0): start inode 0x2000, count 0x20, free 0x20 freemask 0xffffffffffffffff, holemask 0xff00
> 
> Hence the actual maximum agino we could allocate is the size of the
> AG rounded down by the size of of an inode cluster, not the size of
> a full inode chunk. Modify __xfs_agino_range() code to take this
> sparse inode case into account and hence allow us of the already
> allocated sparse inode chunk at the end of a runt AG.
> 
> That change, alone, however, is not sufficient, as
> xfs_inobt_get_rec() hard codes the maximum inode number in the chunk
> and attempts to verify the last inode number in the chunk.  This
> fails because the of the sparse inode record is beyond the end of
> the AG. Hence we have to look at the hole mask in the sparse inode
> record to determine where the highest allocated inode is. We then
> use the calculated high inode number to determine if the allocated
> sparse inode cluster fits within the AG.
> 
> With this, inode allocation on a sparse inode cluster at the end
> of a runt AG now succeeds. Hence any filesystem that has allocated a
> cluster in this location will no longer fail allocation and issue
> corruption warnings.
> 
> Fixes: 56d1115c9bc7 ("xfs: allocate sparse inode chunks on full chunk allocation failure")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_ag.c     | 47 ++++++++++++++++++++++++++++++--------
>  fs/xfs/libxfs/xfs_ialloc.c | 20 +++++++++++++---
>  2 files changed, 54 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index 5ca8d0106827..33290af6ab01 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -238,15 +238,36 @@ xfs_ag_block_count(
>  			mp->m_sb.sb_dblocks);
>  }
>  
> -/* Calculate the first and last possible inode number in an AG. */
> +/*
> + * Calculate the first and last possible inode number in an AG.
> + *
> + * Due to a bug in sparse inode allocation for the runt AG at the end of the
> + * filesystem, we can have a valid sparse inode chunk on disk that spans beyond
> + * the end of the AG. Sparse inode chunks have special alignment - the full
> + * chunk must always be naturally aligned, and the regions that are allocated
> + * sparsely are cluster sized and aligned.
> + *
> + * The result of this is that for sparse inode setups, sb->sb_inoalignmt is
> + * always the size of the chunk, and that means M_IGEO(mp)->cluster_align isn't
> + * actually cluster alignment, it is chunk alignment. That means a sparse inode
> + * cluster that overlaps the end of the AG can never be valid based on "cluster
> + * alignment" even though all the inodes allocated within the sparse chunk at
> + * within the valid bounds of the AG and so can be used.
> + *
> + * Hence for the runt AG, the valid maximum inode number is based on sparse
> + * inode cluster alignment (sb->sb_spino_align) and not the "cluster alignment"
> + * value.
> + */
>  static void
>  __xfs_agino_range(
>  	struct xfs_mount	*mp,
> +	xfs_agnumber_t		agno,
>  	xfs_agblock_t		eoag,
>  	xfs_agino_t		*first,
>  	xfs_agino_t		*last)
>  {
>  	xfs_agblock_t		bno;
> +	xfs_agblock_t		end_align;
>  
>  	/*
>  	 * Calculate the first inode, which will be in the first
> @@ -259,7 +280,12 @@ __xfs_agino_range(
>  	 * Calculate the last inode, which will be at the end of the
>  	 * last (aligned) cluster that can be allocated in the AG.
>  	 */
> -	bno = round_down(eoag, M_IGEO(mp)->cluster_align);
> +	if (xfs_has_sparseinodes(mp) && agno == mp->m_sb.sb_agcount - 1)
> +		end_align = mp->m_sb.sb_spino_align;
> +	else
> +		end_align = M_IGEO(mp)->cluster_align;
> +
> +	bno = round_down(eoag, end_align);
>  	*last = XFS_AGB_TO_AGINO(mp, bno) - 1;
>  }
>  
> @@ -270,7 +296,8 @@ xfs_agino_range(
>  	xfs_agino_t		*first,
>  	xfs_agino_t		*last)
>  {
> -	return __xfs_agino_range(mp, xfs_ag_block_count(mp, agno), first, last);
> +	return __xfs_agino_range(mp, agno, xfs_ag_block_count(mp, agno),
> +			first, last);
>  }
>  
>  int
> @@ -284,7 +311,7 @@ xfs_update_last_ag_size(
>  		return -EFSCORRUPTED;
>  	pag->block_count = __xfs_ag_block_count(mp, prev_agcount - 1,
>  			mp->m_sb.sb_agcount, mp->m_sb.sb_dblocks);
> -	__xfs_agino_range(mp, pag->block_count, &pag->agino_min,
> +	__xfs_agino_range(mp, pag->pag_agno, pag->block_count, &pag->agino_min,
>  			&pag->agino_max);
>  	xfs_perag_rele(pag);
>  	return 0;
> @@ -345,8 +372,8 @@ xfs_initialize_perag(
>  		pag->block_count = __xfs_ag_block_count(mp, index, new_agcount,
>  				dblocks);
>  		pag->min_block = XFS_AGFL_BLOCK(mp);
> -		__xfs_agino_range(mp, pag->block_count, &pag->agino_min,
> -				&pag->agino_max);
> +		__xfs_agino_range(mp, pag->pag_agno, pag->block_count,
> +				&pag->agino_min, &pag->agino_max);
>  	}
>  
>  	index = xfs_set_inode_alloc(mp, new_agcount);
> @@ -932,8 +959,8 @@ xfs_ag_shrink_space(
>  
>  	/* Update perag geometry */
>  	pag->block_count -= delta;
> -	__xfs_agino_range(pag->pag_mount, pag->block_count, &pag->agino_min,
> -				&pag->agino_max);
> +	__xfs_agino_range(mp, pag->pag_agno, pag->block_count,
> +				&pag->agino_min, &pag->agino_max);
>  
>  	xfs_ialloc_log_agi(*tpp, agibp, XFS_AGI_LENGTH);
>  	xfs_alloc_log_agf(*tpp, agfbp, XFS_AGF_LENGTH);
> @@ -1003,8 +1030,8 @@ xfs_ag_extend_space(
>  
>  	/* Update perag geometry */
>  	pag->block_count = be32_to_cpu(agf->agf_length);
> -	__xfs_agino_range(pag->pag_mount, pag->block_count, &pag->agino_min,
> -				&pag->agino_max);
> +	__xfs_agino_range(pag->pag_mount, pag->pag_agno, pag->block_count,
> +				&pag->agino_min, &pag->agino_max);
>  	return 0;
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 6258527315f2..d68b53334990 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -108,22 +108,36 @@ xfs_inobt_rec_freecount(
>  	return hweight64(realfree);
>  }
>  
> +/* Compute the highest allocated inode in an incore inode record. */
> +static xfs_agino_t
> +xfs_inobt_rec_highino(
> +	const struct xfs_inobt_rec_incore	*irec)
> +{
> +	if (xfs_inobt_issparse(irec->ir_holemask))
> +		return xfs_highbit64(xfs_inobt_irec_to_allocmask(irec));
> +	return XFS_INODES_PER_CHUNK;
> +}
> +
>  /* Simple checks for inode records. */
>  xfs_failaddr_t
>  xfs_inobt_check_irec(
>  	struct xfs_perag			*pag,
>  	const struct xfs_inobt_rec_incore	*irec)
>  {
> +	xfs_agino_t	high_ino = xfs_inobt_rec_highino(irec);
> +
>  	/* Record has to be properly aligned within the AG. */
>  	if (!xfs_verify_agino(pag, irec->ir_startino))
>  		return __this_address;
> -	if (!xfs_verify_agino(pag,
> -				irec->ir_startino + XFS_INODES_PER_CHUNK - 1))
> +
> +	if (!xfs_verify_agino(pag, irec->ir_startino + high_ino - 1))
>  		return __this_address;
> +
>  	if (irec->ir_count < XFS_INODES_PER_HOLEMASK_BIT ||
>  	    irec->ir_count > XFS_INODES_PER_CHUNK)
>  		return __this_address;
> -	if (irec->ir_freecount > XFS_INODES_PER_CHUNK)
> +
> +	if (irec->ir_freecount > irec->ir_count)
>  		return __this_address;
>  
>  	if (xfs_inobt_rec_freecount(irec) != irec->ir_freecount)
> -- 
> 2.45.2
> 
> 
