Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E4936B938
	for <linux-xfs@vger.kernel.org>; Thu,  8 Oct 2026 15:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791472610; cv=none; b=imprAbuGpwD1u0luqGICAFbgXqLg6AnrlgU3oqvX9uKiUrHdeRorUXBxXpYmXRNQqIj7oo60UwQy8ZnCrEcQdVSUgkanFAGVsFaI2k9+X4U4v7fbI4dA0iun6IXRPO/4W8Rlk/sZvarocRR+2J8GIyw/FysONDXudYbHj2WekCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791472610; c=relaxed/simple;
	bh=sD/1SGkMt3PzWIf4OmPOr7aDR5qyaDy+/L1BC9zco+8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tBZ+hCaetmvGnBhHIgXoJf0lKy6wrpgEbyITPWxN5ROWZLRfqRo+T/dN05KL8Xs3TdbwCrzjxXgAQOay93lewji2aH2Nnikhkgv9s/dqCAq602Lqc4EiZZdmSRH8cCIVaMOpY0DRL/hP7T4br3Ma2DNuCfvMJzoBsnNWkSo3l/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UwzsRcff; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UwzsRcff"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 246D91F000FF;
	Thu,  8 Oct 2026 15:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791472603;
	bh=+TZy5sIJ+UjSEeDVDuBJz979jlRqeksfbNdqkH1UMe8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UwzsRcffgVzs84IJ2Dk8najGoqWsyoV+2RC7ysEtjFVbW+MSzJtyluyAdGNanPSzf
	 lrVa9wofZNKnRDhBS67XsdhrAkh95/B+UpPmYPfMLd75LrAQPq5uFMffwPhHokL7ut
	 95GZ9HMgINeENOoL3HCxB8MyAxYIQUCdJHfO+DGnniGdaGa8vjwfbVuVuq737COy2+
	 oWc4Gpw/vmbqjUZ6cm/PDVWliTkTZNa72GV29FnbUdVCDyuvuLzOn7KsSbcaoDhiJX
	 zucFfXKbHy3G5AThFfDu0gSBUw6n70BlztLBUN7XmwsjuYTaZw8zyrYv9iBbDHQZOm
	 k0ITAIQDCAvQQ==
Date: Thu, 8 Oct 2026 08:16:42 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Pankaj Raghav <p.raghav@samsung.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, pankaj.raghav@linux.dev,
	John Garry <john.garry@linux.dev>, gost.dev@samsung.com
Subject: Re: [PATCH v3] xfs: don't limit software atomic writes by the group
 alignment
Message-ID: <20261008151642.GM2705364@frogsfrogsfrogs>
References: <20261008111147.3906817-1-p.raghav@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261008111147.3906817-1-p.raghav@samsung.com>

[update jogarry email addr]

On Thu, Oct 08, 2026 at 01:11:47PM +0200, Pankaj Raghav wrote:
> xfs_calc_group_awu_max() clamps the atomic write unit maximum to the
> greatest power-of-two factor of the group size when the device advertises
> atomic writes, so that allocations can be made naturally aligned for
> REQ_ATOMIC. But that value is the software limit: it is only used when
> reflink is enabled, and out of place writes through the COW fork have no
> alignment requirement.
> 
> Compute the software limit from the group size alone, and apply the
> alignment constraint in xfs_get_atomic_write_max_opt() instead, which is
> what reports the size that can be offloaded to the hardware.
> 
> Results on a 14TB device with 16k hardware atomic support with 16k
> blocksize:
> 
> Without patches:
> [nix-shell:~]# trace-cmd report
> cpus=16
> mount-617   [009]  1184.719159: xfs_calc_atomic_write_unit_max: dev 259:2 ag
> max_write 131072 max_ioend 4096 max_gsize 2 awu_max 2
> 
> [nix-shell:~]# ./statx /media/test/hello.txt
> /media/test/hello.txt:
>    stx_atomic_write_unit_min:            16384
>    stx_atomic_write_unit_max:            32768
>    stx_atomic_write_unit_max_opt:        16384
>    stx_atomic_write_segments_max:        1
> 
> With patches:
> [nix-shell:~]# trace-cmd report
> cpus=16
> mount-598   [005]   319.692000: xfs_calc_atomic_write_unit_max: dev 259:2 ag
> max_write 131072 max_ioend 4096 max_gsize 33554432 awu_max 4096
> 
> [nix-shell:~]# ./statx /media/test/hello.txt
> /media/test/hello.txt:
>    stx_atomic_write_unit_min:            16384
>    stx_atomic_write_unit_max:            67108864
>    stx_atomic_write_unit_max_opt:        16384
>    stx_atomic_write_segments_max:        1
> 
> Fixes: 0c438dcc3150 ("xfs: add xfs_calc_atomic_write_unit_max()")
> Assisted-by: LLM
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>

Ok I finally get what's happening here so:
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
> Note: I cannot use min3 in xfs_get_atomic_write_max_opt because
> xfs_get_atomic_hw_write_align returns xfs_fsize_t.
> 
> Changes since v3:
> - Add xfs_get_atomic_hw_write_align wrapper.
> 
>  fs/xfs/xfs_inode.h |  9 +++++++++
>  fs/xfs/xfs_iops.c  | 30 ++++++++++++++++++++++++------
>  fs/xfs/xfs_mount.c | 35 ++++++++++++++++++++++++-----------
>  fs/xfs/xfs_mount.h |  2 ++
>  4 files changed, 59 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index ca96ba096359..64b47fa17b1a 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -353,6 +353,15 @@ static inline bool xfs_inode_has_bigrtalloc(const struct xfs_inode *ip)
>  	return XFS_IS_REALTIME_INODE(ip) && ip->i_mount->m_sb.sb_rextsize > 1;
>  }
>  
> +/*
> + * Return the type of the group that data for a given inode is allocated from.
> + */
> +static inline enum xfs_group_type
> +xfs_inode_group_type(const struct xfs_inode *ip)
> +{
> +	return XFS_IS_REALTIME_INODE(ip) ? XG_TYPE_RTG : XG_TYPE_AG;
> +}
> +
>  /*
>   * Return the buftarg used for data allocations on a given inode.
>   */
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index f67a541ef35a..d307ec97fac8 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -642,19 +642,30 @@ xfs_get_atomic_write_max(
>  	 * then advertise a maximum size of whatever we can complete through
>  	 * that means.  Hardware support is reported via max_opt, not here.
>  	 */
> -	if (XFS_IS_REALTIME_INODE(ip))
> -		return XFS_FSB_TO_B(mp, mp->m_groups[XG_TYPE_RTG].awu_max);
> -	return XFS_FSB_TO_B(mp, mp->m_groups[XG_TYPE_AG].awu_max);
> +	return XFS_FSB_TO_B(mp, mp->m_groups[xfs_inode_group_type(ip)].awu_max);
> +}
> +
> +static inline  xfs_fsize_t xfs_get_atomic_hw_write_align(
> +		const struct xfs_inode *ip)
> +{
> +	struct xfs_mount *mp = ip->i_mount;
> +
> +	return XFS_FSB_TO_B(
> +		mp, xfs_calc_group_awu_align_max(mp, xfs_inode_group_type(ip)));
>  }
>  
>  unsigned int
>  xfs_get_atomic_write_max_opt(
>  	struct xfs_inode	*ip)
>  {
> -	unsigned int		awu_max = xfs_get_atomic_write_max(ip);
> +	struct xfs_mount	*mp = ip->i_mount;
> +	unsigned int		max_opt;
> +	const unsigned int	sw_awu_max = xfs_get_atomic_write_max(ip);
> +	const unsigned int	hw_awu_max = xfs_inode_buftarg(ip)->bt_awu_max;
> +	const xfs_fsize_t	hw_align_max = xfs_get_atomic_hw_write_align(ip);
>  
>  	/* if the max is 1x block, then just keep behaviour that opt is 0 */
> -	if (awu_max <= ip->i_mount->m_sb.sb_blocksize)
> +	if (sw_awu_max <= mp->m_sb.sb_blocksize)
>  		return 0;
>  
>  	/*
> @@ -663,7 +674,14 @@ xfs_get_atomic_write_max_opt(
>  	 * less than our out of place write limit, but we don't want to exceed
>  	 * the awu_max.
>  	 */
> -	return min(awu_max, xfs_inode_buftarg(ip)->bt_awu_max);
> +	max_opt = min(sw_awu_max, hw_awu_max);
> +
> +	/*
> +	 * HW atomic writes also have to be naturally aligned on disk, so we
> +	 * cannot promise more than the largest extent that the allocator is
> +	 * able to align within a group.
> +	 */
> +	return min_t(xfs_fsize_t, max_opt, hw_align_max);
>  }
>  
>  static void
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index be90c7b03994..b7110b3d023b 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -674,15 +674,13 @@ static inline xfs_extlen_t xfs_calc_atomic_write_max(struct xfs_mount *mp)
>  }
>  
>  /*
> - * If the underlying device advertises atomic write support, limit the size of
> - * atomic writes to the greatest power-of-two factor of the group size so
> - * that every atomic write unit aligns with the start of every group.  This is
> - * required so that the allocations for an atomic write will always be
> - * aligned compatibly with the alignment requirements of the storage.
> + * The largest out of place write is the number of blocks that user files can
> + * allocate from any group.
>   *
> - * If the device doesn't advertise atomic writes, then there are no alignment
> - * restrictions and the largest out-of-place write we can do ourselves is the
> - * number of blocks that user files can allocate from any group.
> + * This is a software limit, so it deliberately does not take the alignment
> + * requirements of the storage into account. An atomic write that cannot be
> + * handed to the device as a single naturally aligned REQ_ATOMIC bio is
> + * completed through the COW fork instead, which has no such requirement.
>   */
>  static xfs_extlen_t
>  xfs_calc_group_awu_max(
> @@ -690,15 +688,30 @@ xfs_calc_group_awu_max(
>  	enum xfs_group_type	type)
>  {
>  	struct xfs_groups	*g = &mp->m_groups[type];
> -	struct xfs_buftarg	*btp = xfs_group_type_buftarg(mp, type);
>  
>  	if (g->blocks == 0)
>  		return 0;
> -	if (btp && btp->bt_awu_min > 0)
> -		return max_pow_of_two_factor(g->blocks);
>  	return rounddown_pow_of_two(g->blocks);
>  }
>  
> +/*
> + * Compute the largest atomic write unit for which the allocator can guarantee
> + * naturally aligned extents in this group type.
> + *
> + * Hardware atomic writes have to be naturally aligned on disk.
> + */
> +xfs_extlen_t
> +xfs_calc_group_awu_align_max(
> +	struct xfs_mount	*mp,
> +	enum xfs_group_type	type)
> +{
> +	struct xfs_groups	*g = &mp->m_groups[type];
> +
> +	if (g->blocks == 0)
> +		return 0;
> +	return max_pow_of_two_factor(g->blocks);
> +}
> +
>  /* Compute the maximum atomic write unit size for each section. */
>  static inline void
>  xfs_calc_atomic_write_unit_max(
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 894ff2f4ecbd..cbcfb89c67a4 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -820,6 +820,8 @@ static inline void xfs_mod_sb_delalloc(struct xfs_mount *mp, int64_t delta)
>  
>  int xfs_set_max_atomic_write_opt(struct xfs_mount *mp,
>  		unsigned long long new_max_bytes);
> +xfs_extlen_t xfs_calc_group_awu_align_max(struct xfs_mount *mp,
> +		enum xfs_group_type type);
>  
>  static inline struct xfs_buftarg *
>  xfs_group_type_buftarg(
> 
> base-commit: d10270a8e5fde59eb68921fddfe40c6c2a31a954
> -- 
> 2.51.2
> 
> 
