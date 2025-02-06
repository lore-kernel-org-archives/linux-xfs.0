Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4321F5FA
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 20:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738872926; cv=none; b=eJ3pIuVPb64tWGl+mchcE3aZyy/FtWwtYU2aB+ZUbatEBNRcJtYb87h5us4/T8f0NhWjimAtslqAiTIY+4P17GN03RSuHSFUbynLev3cRvK8cRzSFlbgWFPWXcir89TPwrsNGda02WtujpRSjEZKOUHKQtlAv4T10SynaBnzjCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738872926; c=relaxed/simple;
	bh=K/lxSUdj/+Uyjal4AXly8Jfs1JM4sHlTXG0O8ihipE4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i2IwUbUE2mrq/wLyKr7DiYhmSR25xIT/aXxoSyweE5XbJanjxsRAAUeMoveooHGZCPQiBexWsO5wOi37r0WTP2RTODOJm6Rui3lfs2rvA/qUbHsgbC61A4MMNfSiR3ASDJN9A4JnAZrz0mBatFe8HnrutArbIm9CZdWCqNEJjjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FKvxNGtk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FKvxNGtk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BDFFC4CEDF;
	Thu,  6 Feb 2025 20:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738872925;
	bh=K/lxSUdj/+Uyjal4AXly8Jfs1JM4sHlTXG0O8ihipE4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FKvxNGtkI5ueKsqFheuXpZ8MNbZb9gALm2lHffh+QD1AEWzRCG8hCW2jC66ggwzLA
	 ffdyiITQLVJuYeZfXbVr8mT8SV/CcjCze6sgnhxuWMN/MdMmKc25E16lV5my2WOvMU
	 eOefAJkL2Yzgxev3KwKGrFTLErn5Yy1CtK0MA9GV4CULV2SZEVTzRZsWRyPH8keenf
	 Xmq/ZXe23XYBt8lFvAbzy0rMBd39jPU/6Gw5sxCP6AQAJEBFPyJibnzKVvw9XpOg9Y
	 SMPZujlv+WSXaNmWLVJPIwg+Qgbv6QltDYWoEW8pLUc+8M/7rfZLhLej52aBGYz4Xd
	 bAhXl30J2Iazw==
Date: Thu, 6 Feb 2025 12:15:25 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/43] xfs: trace in-memory freecounters
Message-ID: <20250206201525.GK21808@frogsfrogsfrogs>
References: <20250206064511.2323878-1-hch@lst.de>
 <20250206064511.2323878-10-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250206064511.2323878-10-hch@lst.de>

On Thu, Feb 06, 2025 at 07:44:25AM +0100, Christoph Hellwig wrote:
> Add two tracepoints when the freecounter dips into the reserved pool
> and when it is entirely out of space.
> 
> This requires moving enum xfs_free_counter to xfs_types.h to avoid
> build failures in various sources files include xfs_trace.h, but
> that's probably the right place for it anyway.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yay finally!
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_types.h | 17 +++++++++++++++++
>  fs/xfs/xfs_mount.c        |  2 ++
>  fs/xfs/xfs_mount.h        | 13 -------------
>  fs/xfs/xfs_trace.h        | 36 ++++++++++++++++++++++++++++++++++++
>  4 files changed, 55 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> index ca2401c1facd..76f3c31573ec 100644
> --- a/fs/xfs/libxfs/xfs_types.h
> +++ b/fs/xfs/libxfs/xfs_types.h
> @@ -233,6 +233,23 @@ enum xfs_group_type {
>  	{ XG_TYPE_AG,	"ag" }, \
>  	{ XG_TYPE_RTG,	"rtg" }
>  
> +enum xfs_free_counter {
> +	/*
> +	 * Number of free blocks on the data device.
> +	 */
> +	XC_FREE_BLOCKS,
> +
> +	/*
> +	 * Number of free RT extents on the RT device.
> +	 */
> +	XC_FREE_RTEXTENTS,
> +	XC_FREE_NR,
> +};
> +
> +#define XFS_FREECOUNTER_STR \
> +	{ XC_FREE_BLOCKS,		"blocks" }, \
> +	{ XC_FREE_RTEXTENTS,		"rtextents" }
> +
>  /*
>   * Type verifier functions
>   */
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 65123f4ffc2a..1cce5ad0e7a4 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1347,6 +1347,7 @@ xfs_dec_freecounter(
>  		}
>  
>  		mp->m_resblks[ctr].avail = lcounter;
> +		trace_xfs_freecounter_reserved(mp, ctr, delta, _RET_IP_);
>  		spin_unlock(&mp->m_sb_lock);
>  	}
>  
> @@ -1354,6 +1355,7 @@ xfs_dec_freecounter(
>  	return 0;
>  
>  fdblocks_enospc:
> +	trace_xfs_freecounter_enospc(mp, ctr, delta, _RET_IP_);
>  	spin_unlock(&mp->m_sb_lock);
>  	return -ENOSPC;
>  }
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 2d0e34e517b1..d4a57e2fdcc5 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -105,19 +105,6 @@ struct xfs_groups {
>  	uint64_t		blkmask;
>  };
>  
> -enum xfs_free_counter {
> -	/*
> -	 * Number of free blocks on the data device.
> -	 */
> -	XC_FREE_BLOCKS,
> -
> -	/*
> -	 * Number of free RT extents on the RT device.
> -	 */
> -	XC_FREE_RTEXTENTS,
> -	XC_FREE_NR,
> -};
> -
>  /*
>   * The struct xfsmount layout is optimised to separate read-mostly variables
>   * from variables that are frequently modified. We put the read-mostly variables
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 7fdcb519cf2f..740e0a8c3eca 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -5668,6 +5668,42 @@ TRACE_EVENT(xfs_growfs_check_rtgeom,
>  );
>  #endif /* CONFIG_XFS_RT */
>  
> +TRACE_DEFINE_ENUM(XC_FREE_BLOCKS);
> +TRACE_DEFINE_ENUM(XC_FREE_RTEXTENTS);
> +
> +DECLARE_EVENT_CLASS(xfs_freeblocks_class,
> +	TP_PROTO(struct xfs_mount *mp, enum xfs_free_counter ctr,
> +		 uint64_t delta, unsigned long caller_ip),
> +	TP_ARGS(mp, ctr, delta, caller_ip),
> +	TP_STRUCT__entry(
> +		__field(dev_t, dev)
> +		__field(enum xfs_free_counter, ctr)
> +		__field(uint64_t, delta)
> +		__field(uint64_t, avail)
> +		__field(unsigned long, caller_ip)
> +	),
> +	TP_fast_assign(
> +		__entry->dev = mp->m_super->s_dev;
> +		__entry->ctr = ctr;
> +		__entry->delta = delta;
> +		__entry->avail = mp->m_resblks[ctr].avail;
> +		__entry->caller_ip = caller_ip;
> +	),
> +	TP_printk("dev %d:%d ctr %s delta %llu avail %llu caller %pS",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  __print_symbolic(__entry->ctr, XFS_FREECOUNTER_STR),
> +		  __entry->delta,
> +		  __entry->avail,
> +		  (char *)__entry->caller_ip)
> +)
> +#define DEFINE_FREEBLOCKS_RESV_EVENT(name) \
> +DEFINE_EVENT(xfs_freeblocks_class, name, \
> +	TP_PROTO(struct xfs_mount *mp, enum xfs_free_counter ctr, \
> +		 uint64_t delta, unsigned long caller_ip), \
> +	TP_ARGS(mp, ctr, delta, caller_ip))
> +DEFINE_FREEBLOCKS_RESV_EVENT(xfs_freecounter_reserved);
> +DEFINE_FREEBLOCKS_RESV_EVENT(xfs_freecounter_enospc);
> +
>  #endif /* _TRACE_XFS_H */
>  
>  #undef TRACE_INCLUDE_PATH
> -- 
> 2.45.2
> 
> 
