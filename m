Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27E819049A;
	Fri,  2 May 2025 20:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746216257; cv=none; b=ewdYGskpMFPgxyt5wgAVB1W5YPXRVNOMaAqVkDEve70fdNczdKhRMUcIbJRjlZ/V2bnGUaJ6Yl1poV70lWb26ldVxherJcuxgzb19Seo/nNN8/xSs1ADPcP02SuOTt1WA4dO1Q3NLc90veOyIBr52EpqyfLcJLykMpsid/v7KMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746216257; c=relaxed/simple;
	bh=zHAzDksuhtyOMnpLkmQcgNJPZrdaq51FS+IDIZ5Noi0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=prTeLsidZvxUKFSIn1HOXPAmpsDgG/zYRuaEUoh+yyZENDcbpVtpeXkvTeQBEPTDrSXPeQODUR3MB8heYbrJSI8U/XyAiyM9dGLYUf/mh1a4r7VjNwOIj87pWRFcvDxXLZaeer0kowNwJc95d1DxoEz23VQY+jRU8KdP5Aeywbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NwkN4k6X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NwkN4k6X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5017BC4CEE4;
	Fri,  2 May 2025 20:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746216256;
	bh=zHAzDksuhtyOMnpLkmQcgNJPZrdaq51FS+IDIZ5Noi0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NwkN4k6Xx20U+Py3Z8BVrngKl0DeW+mpRV310vi2BtiMvuKBOl7P7xjbR8hQHLRwC
	 fEbQyUTMIH5S/1wpmWrsdVpNA1t4wMBfIT+1xaninTZ7j7hU7m/darJaidsaEvpY03
	 xYFtsG122Aw6l+6o8qgwEvcTd4NUaA03rJzfTaQD6ABgURrFsGVvHkCacj9DiUTgg5
	 zF0FMOXqcnlfOjdE8S4RKQ5gNsOl+X5B2BE1TUegbQ7XlZXfmnVuu+je9oEC5GyxY5
	 F6/nrsiYovIH0tesn+lHstBz+fKY8Q7kwnMpdXruOGTsniZb3N8YP0e9gQ4hH82w23
	 kB0aK8uYah/2Q==
Date: Fri, 2 May 2025 13:04:15 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Hans Holmberg <Hans.Holmberg@wdc.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Dave Chinner <david@fromorbit.com>, hch <hch@lst.de>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 2/2] xfs: add inode to zone caching for data placement
Message-ID: <20250502200415.GS25675@frogsfrogsfrogs>
References: <20250430084117.9850-1-hans.holmberg@wdc.com>
 <20250430084117.9850-3-hans.holmberg@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250430084117.9850-3-hans.holmberg@wdc.com>

On Wed, Apr 30, 2025 at 08:41:21AM +0000, Hans Holmberg wrote:
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

It seems like a decent idea to try to land random writes to the same
file in the same zone.  This helps us reduce seeking out of the zone on
subsequent reads, right?

If so, then I've understood the purpose, and:
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
