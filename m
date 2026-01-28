Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4B132ED24
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 11:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769600237; cv=none; b=N0LNU1cEOCB8zaccXjwqzjojjcSeC8ykTa036RauCZRVLWj/kgXmwLzX36twlnP4bnZCDMVxoDG3cPCQX9o9iz3ri7sSRrcJUNkd0TiFSiUVa7y4znnYpsm8XbeuSx/fYi2ABx3elp54pB5Cd+WXo6lk2NHUA5Cci+zdpNJ3Bec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769600237; c=relaxed/simple;
	bh=IDV2JCcFQhS0wi8x8CyPVA9EwdGEsTJwOpt89SyyLwI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qw12ooJuJEFjsYL6idin7+Fo3ingtK8uwR26QJfrMRe8oz514XDW5Xub5elc3KMHPxFeZSlyOdqbKgWbZPG65zGA+66ac/I6f32zIpP5sI1BQi5dP+77DpYLphrZsaWocAiJkstRAogrUiOa2W1zZ7tFT1wRV368vLXTMj42K/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A/2/6tMX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A/2/6tMX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EF40C16AAE;
	Wed, 28 Jan 2026 11:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769600237;
	bh=IDV2JCcFQhS0wi8x8CyPVA9EwdGEsTJwOpt89SyyLwI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=A/2/6tMXX7lMdZ2nUILV0q6sO1uuox67lOUiPPXa/jAdIpj+6rZJEs5rl4Ao1RQC5
	 JM41xH2hCJCH1q67QXWMIPfGeIjDhcniHENcPU/LGCuQV6F928Dt1Rv9/FMIZSBzRn
	 OyJsVdMc/rWsnXXf4tqGF+TekmI4Xv9/SetnOpGVKqCcl6uvYKPQxRZzALmlhFABgd
	 kwMUrKOL9ydoeRz2Xi4C5l56H59jn2qXymJzNa/AbDbpOhGJnFjKa6xM9pPhVWp64I
	 r9xl117hp61xsXYNrph5/9R+vJZoAM1qpPa9fMJF0gLp9v1r0tZzSTxUS1j1vcwCUp
	 rzm0+fAnKFpjw==
Date: Wed, 28 Jan 2026 12:37:13 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Hans Holmberg <hans.holmberg@wdc.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/10] xfs: add sysfs stats for zoned GC
Message-ID: <aXn0tIFdDhYe32u2@nidhogg.toxiclabs.cc>
References: <20260127160619.330250-1-hch@lst.de>
 <20260127160619.330250-11-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127160619.330250-11-hch@lst.de>

On Tue, Jan 27, 2026 at 05:05:50PM +0100, Christoph Hellwig wrote:
> Add counters of read, write and zone_reset operations as well as
> GC written bytes to sysfs.  This way they can be easily used for
> monitoring tools and test cases.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>


Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/xfs_stats.c   | 7 ++++++-
>  fs/xfs/xfs_stats.h   | 6 ++++++
>  fs/xfs/xfs_zone_gc.c | 7 +++++++
>  3 files changed, 19 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
> index 9781222e0653..6d7f98afa31a 100644
> --- a/fs/xfs/xfs_stats.c
> +++ b/fs/xfs/xfs_stats.c
> @@ -24,6 +24,7 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
>  	uint64_t	xs_write_bytes = 0;
>  	uint64_t	xs_read_bytes = 0;
>  	uint64_t	defer_relog = 0;
> +	uint64_t	xs_gc_write_bytes = 0;
>  
>  	static const struct xstats_entry {
>  		char	*desc;
> @@ -57,7 +58,8 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
>  		{ "rtrmapbt_mem",	xfsstats_offset(xs_rtrefcbt_2)	},
>  		{ "rtrefcntbt",		xfsstats_offset(xs_qm_dqreclaims)},
>  		/* we print both series of quota information together */
> -		{ "qm",			xfsstats_offset(xs_xstrat_bytes)},
> +		{ "qm",			xfsstats_offset(xs_gc_read_calls)},
> +		{ "zoned",		xfsstats_offset(__pad1)},
>  	};
>  
>  	/* Loop over all stats groups */
> @@ -77,6 +79,7 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
>  		xs_write_bytes += per_cpu_ptr(stats, i)->s.xs_write_bytes;
>  		xs_read_bytes += per_cpu_ptr(stats, i)->s.xs_read_bytes;
>  		defer_relog += per_cpu_ptr(stats, i)->s.defer_relog;
> +		xs_gc_write_bytes += per_cpu_ptr(stats, i)->s.xs_read_bytes;
>  	}
>  
>  	len += scnprintf(buf + len, PATH_MAX-len, "xpc %llu %llu %llu\n",
> @@ -89,6 +92,8 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
>  #else
>  		0);
>  #endif
> +	len += scnprintf(buf + len, PATH_MAX-len, "gc xpc %llu\n",
> +			xs_gc_write_bytes);
>  
>  	return len;
>  }
> diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
> index 15ba1abcf253..16dbbc0b72db 100644
> --- a/fs/xfs/xfs_stats.h
> +++ b/fs/xfs/xfs_stats.h
> @@ -138,10 +138,16 @@ struct __xfsstats {
>  	uint32_t		xs_qm_dqwants;
>  	uint32_t		xs_qm_dquot;
>  	uint32_t		xs_qm_dquot_unused;
> +/* Zone GC counters */
> +	uint32_t		xs_gc_read_calls;
> +	uint32_t		xs_gc_write_calls;
> +	uint32_t		xs_gc_zone_reset_calls;
> +	uint32_t		__pad1;
>  /* Extra precision counters */
>  	uint64_t		xs_xstrat_bytes;
>  	uint64_t		xs_write_bytes;
>  	uint64_t		xs_read_bytes;
> +	uint64_t		xs_gc_write_bytes;
>  	uint64_t		defer_relog;
>  };
>  
> diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
> index 570102184904..4bb647d3be41 100644
> --- a/fs/xfs/xfs_zone_gc.c
> +++ b/fs/xfs/xfs_zone_gc.c
> @@ -712,6 +712,8 @@ xfs_zone_gc_start_chunk(
>  	data->scratch_head = (data->scratch_head + len) % data->scratch_size;
>  	data->scratch_available -= len;
>  
> +	XFS_STATS_INC(mp, xs_gc_read_calls);
> +
>  	WRITE_ONCE(chunk->state, XFS_GC_BIO_NEW);
>  	list_add_tail(&chunk->entry, &data->reading);
>  	xfs_zone_gc_iter_advance(iter, irec.rm_blockcount);
> @@ -815,6 +817,9 @@ xfs_zone_gc_write_chunk(
>  		return;
>  	}
>  
> +	XFS_STATS_INC(mp, xs_gc_write_calls);
> +	XFS_STATS_ADD(mp, xs_gc_write_bytes, chunk->len);
> +
>  	WRITE_ONCE(chunk->state, XFS_GC_BIO_NEW);
>  	list_move_tail(&chunk->entry, &data->writing);
>  
> @@ -911,6 +916,8 @@ xfs_submit_zone_reset_bio(
>  		return;
>  	}
>  
> +	XFS_STATS_INC(mp, xs_gc_zone_reset_calls);
> +
>  	bio->bi_iter.bi_sector = xfs_gbno_to_daddr(&rtg->rtg_group, 0);
>  	if (!bdev_zone_is_seq(bio->bi_bdev, bio->bi_iter.bi_sector)) {
>  		/*
> -- 
> 2.47.3
> 
> 
