Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C99F3DB33F
	for <linux-xfs@vger.kernel.org>; Wed,  7 Oct 2026 18:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791398452; cv=none; b=h3J/K5r6j2TrQeQcihAOF3KS8mmwnVrdj3hwpVcFehd7T2SeF+wzgUvhRmrwB/QInSXBX+LpT9UaTSsoHwgXVFZlxC3yJWMMx7gJWdbemcmqMQICiQ8IqK8Mx9JOOqpO09yFnfQNlmUlZlbvlIOw9cQfSycNMU63AFEE0gP9e74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791398452; c=relaxed/simple;
	bh=3kZI3eQoRHFs46/BRSB5gNIZXOoi82kvNfLKMq08Xt4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ERA2cWSh2zFrNos2j7dC419XJvM59YrnGy3EJWZxba44ck5zAhVeDIDnrcbAqvfcmC9i3DkGjSPkAtrQzWb9FWZt7BHhb4ymlOXFcmLf3VpE+ON0X/8NPR//Stm2WD+Zy11QfHXf+mopYF5AMeyG28riEIncRks9xGb47c3YVK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yyy93VTh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yyy93VTh"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 145591F000FF;
	Wed,  7 Oct 2026 18:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791398451;
	bh=W8HEI0mRk+Mp/cTxohNN+xhgkRxn1jlTalaTgfZ8RDc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Yyy93VThsT1+KsjmfNKJNDPzIvNliIbxGaXp26WSCqdHQJ10GcQw8vSndRW6EeYRh
	 c9E7zP31tUBUpIBJHVjO5GiRQlI0olKepsznarfRDypXc79WyiSeZS3TYoTfBmIzmO
	 0/JRSBII1B3fhsV0KhZzU73OS9fridJuWM1+uOeTKP+By6wS6wrjEcAe7ZzlD7JLqS
	 Y0FxAl1RlLOsWGIPnzkKaEjMw18bzHRqhgFW4hbSAOGA4jO083kJP7qSLYbvc0FibF
	 cMaPdzIo28s0HfU1PWzMFPb9tS0J8TMKLCMjdnFntHCtuKlqvFrzyIouROkyQj09j0
	 Uy/i6NsuZkSLw==
Date: Wed, 7 Oct 2026 11:40:50 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Pankaj Raghav <p.raghav@samsung.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, pankaj.raghav@linux.dev,
	John Garry <john.g.garry@oracle.com>, gost.dev@samsung.com
Subject: Re: [PATCH v2] xfs: don't limit software atomic writes by the group
 alignment
Message-ID: <20261007184050.GL2705364@frogsfrogsfrogs>
References: <20261007101425.3741087-1-p.raghav@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261007101425.3741087-1-p.raghav@samsung.com>

On Wed, Oct 07, 2026 at 12:14:25PM +0200, Pankaj Raghav wrote:
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
> ---
> Changes since v1:
> - Change opt to max_opt
> - Move xfs_inode_group_type helper to xfs_inode.h
> - Change commit message with the latest xfsprogs
> 
>  fs/xfs/xfs_inode.h |  9 +++++++++
>  fs/xfs/xfs_iops.c  | 21 ++++++++++++++++-----
>  fs/xfs/xfs_mount.c | 35 ++++++++++++++++++++++++-----------
>  fs/xfs/xfs_mount.h |  2 ++
>  4 files changed, 51 insertions(+), 16 deletions(-)
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
> index f67a541ef35a..6b28b9c7de84 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -642,19 +642,20 @@ xfs_get_atomic_write_max(
>  	 * then advertise a maximum size of whatever we can complete through
>  	 * that means.  Hardware support is reported via max_opt, not here.
>  	 */
> -	if (XFS_IS_REALTIME_INODE(ip))
> -		return XFS_FSB_TO_B(mp, mp->m_groups[XG_TYPE_RTG].awu_max);
> -	return XFS_FSB_TO_B(mp, mp->m_groups[XG_TYPE_AG].awu_max);
> +	return XFS_FSB_TO_B(mp, mp->m_groups[xfs_inode_group_type(ip)].awu_max);
>  }
>  
>  unsigned int
>  xfs_get_atomic_write_max_opt(
>  	struct xfs_inode	*ip)
>  {
> +	struct xfs_mount	*mp = ip->i_mount;
>  	unsigned int		awu_max = xfs_get_atomic_write_max(ip);
> +	xfs_extlen_t		align_max_fsb;
> +	unsigned int		max_opt;
>  
>  	/* if the max is 1x block, then just keep behaviour that opt is 0 */
> -	if (awu_max <= ip->i_mount->m_sb.sb_blocksize)
> +	if (awu_max <= mp->m_sb.sb_blocksize)
>  		return 0;
>  
>  	/*
> @@ -663,7 +664,17 @@ xfs_get_atomic_write_max_opt(
>  	 * less than our out of place write limit, but we don't want to exceed
>  	 * the awu_max.
>  	 */
> -	return min(awu_max, xfs_inode_buftarg(ip)->bt_awu_max);
> +	max_opt = min(awu_max, xfs_inode_buftarg(ip)->bt_awu_max);
> +
> +	/*
> +	 * REQ_ATOMIC writes also have to be naturally aligned on disk, so we
> +	 * cannot promise more than the largest extent that the allocator is
> +	 * able to align within a group.
> +	 */
> +	align_max_fsb = xfs_calc_group_awu_align_max(mp,
> +						xfs_inode_group_type(ip));
> +
> +	return min_t(xfs_fsize_t, max_opt, XFS_FSB_TO_B(mp, align_max_fsb));
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

Don't we need to retain the btp && btp->bt_awu_min > 0 test here?

Hmm.  I guess the caller effectively does this:

	const unsigned int	sw_awu_max =
		xfs_get_atomic_write_max(ip);

	/* if the max is 1x block, then just keep behaviour that opt is 0 */
	if (sw_awu_max <= ip->i_mount->m_sb.sb_blocksize)
		return 0;

	const unsigned int	hw_awu_max =
		xfs_inode_buftarg(ip)->bt_awu_max);
	const unsigned int	hw_align_max =
		xfs_calc_group_awu_align_max(mp,
					xfs_inode_group_type(ip));

	/*
	 * The optimal atomic write size is the minimum of the software
	 * fallback, the hardware capability, and the biggest aligned
	 * extent that the per-AG allocator can give us.
	 */
	return min3(sw_awu_max, hw_awu_max, XFS_FSB_TO_B(hw_align_max));

So no, we really don't need to check bt_awu_min?

I also sorta wish that third assignment had its own helper:

static inline unsigned int
xfs_get_atomic_hw_write_align(
	const struct xfs_inode	*ip)
{
	struct xfs_mount	*mp = ip->i_mount;

	return XFS_FSB_TO_B(mp, xfs_calc_group_awu_align_max(mp,
					xfs_inode_group_type(ip)));
}

But now I'm really just nitpicking. :P

--D

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
