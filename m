Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE3624E4AF
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 01:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769564445; cv=none; b=gD96iuHGdYFP4RV/0OJ8vvYwOeCA/+iVBhlZvhgCn/eo1LMdEmMSlaVp3sMT4ZmWjflXAKnCk7TPBU2fg7vOhQ27cypy8DkKwjErvLhtWR7aDvOiLK/YHtvGmnnyis9X1V95uvgez3fd3ICyj6HRPx2hB+qn+WSHyGJ8kcZKdKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769564445; c=relaxed/simple;
	bh=cX71sceLLxxtosveaKlm9PJogSoOKTuCuorcox3FBnk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qv/OvsTCHiTfsxf+q17Tuwb4NeUzXBkhubpKgMl4pJJXseJOK/XWQXKGBjFB4Q8VALjiYlMjk0SCNyHdidhYrwMCVkrp4hcMmunFeM2VUmZTc3OGFHLnGaIQ2Hvo8zDdGW0LqKMDd452Rqyoy2m2KdmAt+zVm432loDwhi/gKVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F7C0cOyE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F7C0cOyE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0642FC116C6;
	Wed, 28 Jan 2026 01:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769564445;
	bh=cX71sceLLxxtosveaKlm9PJogSoOKTuCuorcox3FBnk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F7C0cOyEQx03xrsSA12/XGo25wBSFY89WHMPZtTPoimGYTgnxaxQebG4lMr+vM20K
	 MUtu+feuvaOGkWnISrrQUPD1m+phSsIttrvNT+6oCSGNbOUlB4b3mjZnrw25SZDWlQ
	 KRH0tNy5vceqjtUTbYtNnCvI6pusMEtasnaq2pzm4fvOPmGyWexOWHKbd2v4/NUnAf
	 oJ4DOXjfgVJ5b3+ifdnIiX25kDWtZ2DFqiHQ5afS31sKAlk36dahkMd7sQXHt/ESAX
	 bO2DtdTVv+oOvX2Hz1pZlJ7BVwlgzW01RYXKv8G4AaKqL2WerCMIbOcLwqzwu8vHge
	 JqZAVes9QrcNw==
Date: Tue, 27 Jan 2026 17:40:44 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/10] xfs: add sysfs stats for zoned GC
Message-ID: <20260128014044.GJ5945@frogsfrogsfrogs>
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

+1 for observability
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

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
