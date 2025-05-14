Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA9A14900B;
	Wed, 14 May 2025 16:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747238729; cv=none; b=Ky5zwZ/n/31F+NHsqwImcDjmk8pIHjKRwezbPO3vWMHK9l4Iy7CzQQKenV3GKITamDOBDGQO9i72Nz7WuQ6/6UOQLAEaB654eyBinI+RVmzPO26AY8+0rNA08qBKtMaCOiNQbXiHuhVWjEeY81WrKT21FNwEKvcfIZnmb+MDqkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747238729; c=relaxed/simple;
	bh=9ia58EEPZmsQMmA96nqP1xtz6SuZMnnHYxUouZrqGNQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HoUlqSVKa0eM05grYrfk/jLNce3YuN6rwcJUdrDyCMci95+uuaEx4R2BrMPzzK+GrrpN5EzhnfDtMzSMiHMc2qgAiJof+h2er31Y+HRw/TlcqXtIbT1LDsSeqNRKPtJUhoMeqwwduBiNfZ1IVk64UF8wKppQ1I0omEznFW96U5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vCSeeZyH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vCSeeZyH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D6BAC4CEE3;
	Wed, 14 May 2025 16:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747238729;
	bh=9ia58EEPZmsQMmA96nqP1xtz6SuZMnnHYxUouZrqGNQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vCSeeZyHskG0dL2n3hM5Y1DzGiBc3u5SFPlO5g20sZC3JVrvr96qAFZm4norQpmxC
	 rKOkT7V3zhwfHZfHStkTFexIsEuC/ocGaaxZpD+FKr7ae34rW5rBVhpFgNgF7XExYO
	 Ly5+2gPj2i9DsZ7WaNYha6JYpHReu9Q6w97OS0d5IzDCovUY24H2FFcEzMOlHdjxxP
	 lstcUZ4zqR4HDDDdxvLvUJyRQFYX2QHvmu7320iiZzWOfT339dLinpXroJ28f2gX+M
	 9STDD0s7Q2np/HtR68GPFaTbZQxaVtYgKdKqL7Ei8TcZKxxgZlmfd9UI7K9F00EoNk
	 U2D7lgfTZMd2Q==
Date: Wed, 14 May 2025 09:05:28 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Hans Holmberg <Hans.Holmberg@wdc.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Dave Chinner <david@fromorbit.com>, hch <hch@lst.de>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] xfs: add inode to zone caching for data placement
Message-ID: <20250514160528.GM2701446@frogsfrogsfrogs>
References: <20250514104937.15380-1-hans.holmberg@wdc.com>
 <20250514104937.15380-3-hans.holmberg@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250514104937.15380-3-hans.holmberg@wdc.com>

On Wed, May 14, 2025 at 10:50:37AM +0000, Hans Holmberg wrote:
> Placing data from the same file in the same zone is a great heuristic
> for reducing write amplification and we do this already - but only
> for sequential writes.
> 
> To support placing data in the same way for random writes, reuse the
> xfs mru cache to map inodes to open zones on first write. If a mapping
> is present, use the open zone for data placement for this file until
> the zone is full.
> 
> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>

Odd, did my rvb from last time get dropped?  This doesn't look like a
huge change to me...

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_mount.h      |   1 +
>  fs/xfs/xfs_zone_alloc.c | 109 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 110 insertions(+)
> 
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index e5192c12e7ac..f90c0a16766f 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -230,6 +230,7 @@ typedef struct xfs_mount {
>  	bool			m_update_sb;	/* sb needs update in mount */
>  	unsigned int		m_max_open_zones;
>  	unsigned int		m_zonegc_low_space;
> +	struct xfs_mru_cache	*m_zone_cache;  /* Inode to open zone cache */
>  
>  	/*
>  	 * Bitsets of per-fs metadata that have been checked and/or are sick.
> diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
> index d509e49b2aaa..80add26c0111 100644
> --- a/fs/xfs/xfs_zone_alloc.c
> +++ b/fs/xfs/xfs_zone_alloc.c
> @@ -24,6 +24,7 @@
>  #include "xfs_zone_priv.h"
>  #include "xfs_zones.h"
>  #include "xfs_trace.h"
> +#include "xfs_mru_cache.h"
>  
>  void
>  xfs_open_zone_put(
> @@ -796,6 +797,100 @@ xfs_submit_zoned_bio(
>  	submit_bio(&ioend->io_bio);
>  }
>  
> +/*
> + * Cache the last zone written to for an inode so that it is considered first
> + * for subsequent writes.
> + */
> +struct xfs_zone_cache_item {
> +	struct xfs_mru_cache_elem	mru;
> +	struct xfs_open_zone		*oz;
> +};
> +
> +static inline struct xfs_zone_cache_item *
> +xfs_zone_cache_item(struct xfs_mru_cache_elem *mru)
> +{
> +	return container_of(mru, struct xfs_zone_cache_item, mru);
> +}
> +
> +static void
> +xfs_zone_cache_free_func(
> +	void				*data,
> +	struct xfs_mru_cache_elem	*mru)
> +{
> +	struct xfs_zone_cache_item	*item = xfs_zone_cache_item(mru);
> +
> +	xfs_open_zone_put(item->oz);
> +	kfree(item);
> +}
> +
> +/*
> + * Check if we have a cached last open zone available for the inode and
> + * if yes return a reference to it.
> + */
> +static struct xfs_open_zone *
> +xfs_cached_zone(
> +	struct xfs_mount		*mp,
> +	struct xfs_inode		*ip)
> +{
> +	struct xfs_mru_cache_elem	*mru;
> +	struct xfs_open_zone		*oz;
> +
> +	mru = xfs_mru_cache_lookup(mp->m_zone_cache, ip->i_ino);
> +	if (!mru)
> +		return NULL;
> +	oz = xfs_zone_cache_item(mru)->oz;
> +	if (oz) {
> +		/*
> +		 * GC only steals open zones at mount time, so no GC zones
> +		 * should end up in the cache.
> +		 */
> +		ASSERT(!oz->oz_is_gc);
> +		ASSERT(atomic_read(&oz->oz_ref) > 0);
> +		atomic_inc(&oz->oz_ref);
> +	}
> +	xfs_mru_cache_done(mp->m_zone_cache);
> +	return oz;
> +}
> +
> +/*
> + * Update the last used zone cache for a given inode.
> + *
> + * The caller must have a reference on the open zone.
> + */
> +static void
> +xfs_zone_cache_create_association(
> +	struct xfs_inode		*ip,
> +	struct xfs_open_zone		*oz)
> +{
> +	struct xfs_mount		*mp = ip->i_mount;
> +	struct xfs_zone_cache_item	*item = NULL;
> +	struct xfs_mru_cache_elem	*mru;
> +
> +	ASSERT(atomic_read(&oz->oz_ref) > 0);
> +	atomic_inc(&oz->oz_ref);
> +
> +	mru = xfs_mru_cache_lookup(mp->m_zone_cache, ip->i_ino);
> +	if (mru) {
> +		/*
> +		 * If we have an association already, update it to point to the
> +		 * new zone.
> +		 */
> +		item = xfs_zone_cache_item(mru);
> +		xfs_open_zone_put(item->oz);
> +		item->oz = oz;
> +		xfs_mru_cache_done(mp->m_zone_cache);
> +		return;
> +	}
> +
> +	item = kmalloc(sizeof(*item), GFP_KERNEL);
> +	if (!item) {
> +		xfs_open_zone_put(oz);
> +		return;
> +	}
> +	item->oz = oz;
> +	xfs_mru_cache_insert(mp->m_zone_cache, ip->i_ino, &item->mru);
> +}
> +
>  void
>  xfs_zone_alloc_and_submit(
>  	struct iomap_ioend	*ioend,
> @@ -819,11 +914,16 @@ xfs_zone_alloc_and_submit(
>  	 */
>  	if (!*oz && ioend->io_offset)
>  		*oz = xfs_last_used_zone(ioend);
> +	if (!*oz)
> +		*oz = xfs_cached_zone(mp, ip);
> +
>  	if (!*oz) {
>  select_zone:
>  		*oz = xfs_select_zone(mp, write_hint, pack_tight);
>  		if (!*oz)
>  			goto out_error;
> +
> +		xfs_zone_cache_create_association(ip, *oz);
>  	}
>  
>  	alloc_len = xfs_zone_alloc_blocks(*oz, XFS_B_TO_FSB(mp, ioend->io_size),
> @@ -1211,6 +1311,14 @@ xfs_mount_zones(
>  	error = xfs_zone_gc_mount(mp);
>  	if (error)
>  		goto out_free_zone_info;
> +
> +	/*
> +	 * Set up a mru cache to track inode to open zone for data placement
> +	 * purposes. The magic values for group count and life time is the
> +	 * same as the defaults for file streams, which seems sane enough.
> +	 */
> +	xfs_mru_cache_create(&mp->m_zone_cache, mp,
> +			5000, 10, xfs_zone_cache_free_func);
>  	return 0;
>  
>  out_free_zone_info:
> @@ -1224,4 +1332,5 @@ xfs_unmount_zones(
>  {
>  	xfs_zone_gc_unmount(mp);
>  	xfs_free_zone_info(mp->m_zone_info);
> +	xfs_mru_cache_destroy(mp->m_zone_cache);
>  }
> -- 
> 2.34.1
> 
