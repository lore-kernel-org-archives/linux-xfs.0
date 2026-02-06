Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4217A2BE031
	for <linux-xfs@vger.kernel.org>; Fri,  6 Feb 2026 06:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770360225; cv=none; b=pudSV0UQbgfOMWiWNysZZIiLOGiDRQBZ+gVA9LwHrs4lZFAsbCyHWa7FS1McON5YQTpxvhYh+GWSlqirxWD8LJ8e02y/r91uya/PnSM/Ij46qTXNXJBwljcTA92Pk6b7qOne+FuJ0gUtapY9rOz09AnYWowZVxjs9jHuDVw5FaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770360225; c=relaxed/simple;
	bh=Y6BoXkelXg+QbvPXDrWAvJ+2cKJjOAV0VD4iCgij7Tw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HmJkwuinbTpxUILs9LMH3i/7p39A+BAeQBflF8PlbjDCPaMIhlgwtB5C4n+ZVqyIvK4IsMMkiRbhxmdQ2s2GYSbg9bPU+nxDKXp1lB0CGdTfeYZjDOJwfq+T3gPIU/2t6OjFzwRdoX3WcTruEFHvKVKlSlezaEWsIqyeDoaEC6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W8Hy+fb8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W8Hy+fb8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B38C116C6;
	Fri,  6 Feb 2026 06:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770360224;
	bh=Y6BoXkelXg+QbvPXDrWAvJ+2cKJjOAV0VD4iCgij7Tw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=W8Hy+fb8BEsu0K0X/evFrn9x7CP2+8rH+/zz2t4ynV/9OclAkReG7RKamsVgRBt6d
	 C6uEgbJlnKY1aebG1Vwl8sgNTLi1sNokPFxreXo/33qFJ6WZR/k3RQjXGKBYGl/wYA
	 u9ZutPjGPxlZT+7YSYF6tOszXMlK1jgfFMcBBTDNmlIGeo8Klvul3CIqI8bkNwI3e8
	 aP2C20xIZnpmRIqdL9SDUBQfHoP1G9nu3HhzFj65f6dkOBuGkmNxGj4RLJk0P48w35
	 bNGxnIRAu7ie2BOh9ZiW+lHuIvgGXKrPTzaQgdDeVCv7wRB0Hu9pE3djNts5TKRpNL
	 ZSB5TiC6cnZWQ==
Date: Thu, 5 Feb 2026 22:43:42 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: remove metafile inodes from the active inode
 stat
Message-ID: <20260206064342.GX7712@frogsfrogsfrogs>
References: <20260202141502.378973-1-hch@lst.de>
 <20260202141502.378973-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260202141502.378973-3-hch@lst.de>

On Mon, Feb 02, 2026 at 03:14:32PM +0100, Christoph Hellwig wrote:
> The active inode (or active vnode until recently) stat can get much larger
> than expected on file systems with a lot of metafile inodes like zoned
> file systems on SMR hard disks with 10.000s of rtg rmap inodes.
> 
> Remove all metafile inodes from the active counter to make it more useful
> to track actual workloads and add a separate counter for active metafile
> inodes.
> 
> This fixes xfs/177 on SMR hard drives.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok to me, though I wonder slightly about the atomicity of the
percpu counter inc/decrements.  But it's been that way for a long time
so

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_inode_buf.c |  4 ++++
>  fs/xfs/libxfs/xfs_metafile.c  |  5 +++++
>  fs/xfs/xfs_icache.c           |  5 ++++-
>  fs/xfs/xfs_stats.c            | 11 ++++++++---
>  fs/xfs/xfs_stats.h            |  3 ++-
>  5 files changed, 23 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index dcc9566ef5fe..91a499ced4e8 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -268,6 +268,10 @@ xfs_inode_from_disk(
>  	}
>  	if (xfs_is_reflink_inode(ip))
>  		xfs_ifork_init_cow(ip);
> +	if (xfs_is_metadir_inode(ip)) {
> +		XFS_STATS_DEC(ip->i_mount, xs_inodes_active);
> +		XFS_STATS_INC(ip->i_mount, xs_inodes_meta);
> +	}
>  	return 0;
>  
>  out_destroy_data_fork:
> diff --git a/fs/xfs/libxfs/xfs_metafile.c b/fs/xfs/libxfs/xfs_metafile.c
> index cf239f862212..71f004e9dc64 100644
> --- a/fs/xfs/libxfs/xfs_metafile.c
> +++ b/fs/xfs/libxfs/xfs_metafile.c
> @@ -61,6 +61,9 @@ xfs_metafile_set_iflag(
>  	ip->i_diflags2 |= XFS_DIFLAG2_METADATA;
>  	ip->i_metatype = metafile_type;
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> +
> +	XFS_STATS_DEC(ip->i_mount, xs_inodes_active);
> +	XFS_STATS_INC(ip->i_mount, xs_inodes_meta);
>  }
>  
>  /* Clear the metadata directory inode flag. */
> @@ -74,6 +77,8 @@ xfs_metafile_clear_iflag(
>  
>  	ip->i_diflags2 &= ~XFS_DIFLAG2_METADATA;
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> +	XFS_STATS_INC(ip->i_mount, xs_inodes_active);
> +	XFS_STATS_DEC(ip->i_mount, xs_inodes_meta);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index f76c6decdaa3..f2d4294efd37 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -172,7 +172,10 @@ __xfs_inode_free(
>  	/* asserts to verify all state is correct here */
>  	ASSERT(atomic_read(&ip->i_pincount) == 0);
>  	ASSERT(!ip->i_itemp || list_empty(&ip->i_itemp->ili_item.li_bio_list));
> -	XFS_STATS_DEC(ip->i_mount, xs_inodes_active);
> +	if (xfs_is_metadir_inode(ip))
> +		XFS_STATS_DEC(ip->i_mount, xs_inodes_meta);
> +	else
> +		XFS_STATS_DEC(ip->i_mount, xs_inodes_active);
>  
>  	call_rcu(&VFS_I(ip)->i_rcu, xfs_inode_free_callback);
>  }
> diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
> index bc4a5d6dc795..c13d600732c9 100644
> --- a/fs/xfs/xfs_stats.c
> +++ b/fs/xfs/xfs_stats.c
> @@ -59,7 +59,8 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
>  		{ "rtrefcntbt",		xfsstats_offset(xs_qm_dqreclaims)},
>  		/* we print both series of quota information together */
>  		{ "qm",			xfsstats_offset(xs_gc_read_calls)},
> -		{ "zoned",		xfsstats_offset(__pad1)},
> +		{ "zoned",		xfsstats_offset(xs_inodes_meta)},
> +		{ "metafile",		xfsstats_offset(xs_xstrat_bytes)},
>  	};
>  
>  	/* Loop over all stats groups */
> @@ -99,16 +100,20 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
>  
>  void xfs_stats_clearall(struct xfsstats __percpu *stats)
>  {
> +	uint32_t	xs_inodes_active, xs_inodes_meta;
>  	int		c;
> -	uint32_t	xs_inodes_active;
>  
>  	xfs_notice(NULL, "Clearing xfsstats");
>  	for_each_possible_cpu(c) {
>  		preempt_disable();
> -		/* save xs_inodes_active, it's a universal truth! */
> +		/*
> +		 * Save the active / meta inode counters, as they are stateful.
> +		 */
>  		xs_inodes_active = per_cpu_ptr(stats, c)->s.xs_inodes_active;
> +		xs_inodes_meta = per_cpu_ptr(stats, c)->s.xs_inodes_meta;
>  		memset(per_cpu_ptr(stats, c), 0, sizeof(*stats));
>  		per_cpu_ptr(stats, c)->s.xs_inodes_active = xs_inodes_active;
> +		per_cpu_ptr(stats, c)->s.xs_inodes_meta = xs_inodes_meta;
>  		preempt_enable();
>  	}
>  }
> diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
> index 64bc0cc18126..57c32b86c358 100644
> --- a/fs/xfs/xfs_stats.h
> +++ b/fs/xfs/xfs_stats.h
> @@ -142,7 +142,8 @@ struct __xfsstats {
>  	uint32_t		xs_gc_read_calls;
>  	uint32_t		xs_gc_write_calls;
>  	uint32_t		xs_gc_zone_reset_calls;
> -	uint32_t		__pad1;
> +/* Metafile counters */
> +	uint32_t		xs_inodes_meta;
>  /* Extra precision counters */
>  	uint64_t		xs_xstrat_bytes;
>  	uint64_t		xs_write_bytes;
> -- 
> 2.47.3
> 
> 
