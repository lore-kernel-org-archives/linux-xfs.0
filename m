Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ABBF4A3F1C
	for <linux-xfs@vger.kernel.org>; Mon,  5 Oct 2026 15:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791212731; cv=none; b=LxhYAJzuJLmt5yA4fS+ZkUxR9BnCufFHh7j6m+fImMn0cEZ9veWv8zg3vSOrHzEIZIFRnil4cZkgD3hQWXQi5rzYXrvgb9cNQm5tnxmx1YVozTzIDJEXPyoFNDIQ/xKPbW3p3qqaZXleMg7QfygfTC6+o7DM5vwGvRdlgtN08NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791212731; c=relaxed/simple;
	bh=LQhs+2eYwWkmtX2TKcwvAToDI2ZC0NalwrQrCng0Mxc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BeS8PKG3yREFUskmZNZnFr3kfb1TEea/JTJqX/i6tX/MZ/UhYQAzwimJgCTLIs64LdHK9P8B3hDrnQ6Hhfbul5efnRJC3lclRZ5XKvEi2XYwyKgznjiCbDwBJl2sNyZTLxaYPNeFhj5A+LiPprK+zdA2WH7ThNYVeiphABKtMGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C+ykDhXI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C+ykDhXI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04A371F00898;
	Mon,  5 Oct 2026 15:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791212729;
	bh=Vv1LN3S77sDxl0e/Sl7kkOKG5FyvuFPKy5/K0rFxBYs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=C+ykDhXI4PtSVDsk+wH/HSNRvIc1neM5tiA7xl5TLUN5D/jlfcsnuideSwTyUaE8j
	 pcAeCg7Gb8rP9R4/JgqQA9dEPHTY1BqR8TyH0FmfX5qpOW8I7gYno55gKBbPxUltfW
	 t4f7XUgMgb52uBiXXs5X3MN1O+pEeI2S74q6wsPk7T+Rn9SceGZOs0ThxltvV0A7ij
	 9GSA3c3BirGaKUVndB75fgj1L+lzFUQ0+PjsqlO/nYYLwmF2kcPQveppfPZfzefcBA
	 Mwko4xsBS1U5zyRm0Qcxxcm4hzrj7geSlv2sKgv+QlfALgm2nV86XuUfPOu1LnMhIM
	 XXY7aKc1oBm5A==
Date: Mon, 5 Oct 2026 17:05:22 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Hans Holmberg <hans.holmberg@wdc.com>
Cc: "Darrick J . Wong" <djwong@kernel.org>, 
	Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, 
	Damien Le Moal <dlemoal@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: don't let racing writers consume the free zones
 reserved for GC
Message-ID: <asO6DwuXVv1DqqKa@nidhogg.toxiclabs.cc>
References: <20261005115917.36378-1-hans.holmberg@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261005115917.36378-1-hans.holmberg@wdc.com>

On Mon, Oct 05, 2026 at 01:59:17PM +0200, Hans Holmberg wrote:
> xfs_try_open_zone() checks the free zone count to avoid grabbing zones
> required for GC forward progress, but does so without decreasing the
> counter, letting multiple user writers through to call xfs_open_zone()
> and collectively gobble up all free zones, stalling gc and eventually
> leading to user threads getting stuck waiting for free space.
> 
> Fold the check and the accounting into a single atomic claim in
> xfs_open_zone() instead.  The free zone count is decremented before the
> zone is looked up and given back if none could be grabbed, so the reserve
> can no longer be raced away.  User allocations only claim a zone if that
> leaves the reserve behind, while GC just needs one free zone and thus can
> still use the zones that are kept for it. Also add a warning if we end
> up not finding a free zone in the xarray, as this should never happen.
> 
> Fixes: 4e4d52075577 ("xfs: add the zoned space allocator")
> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>

Looks fine to me:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
> 
> Changes since v1:
> - Add a WARN_ON_ONCE when no free zone is found despite a successful claim
> 
>  fs/xfs/libxfs/xfs_zones.h |  6 ++++++
>  fs/xfs/xfs_zone_alloc.c   | 36 ++++++++++++++++++++++++++++++++----
>  2 files changed, 38 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_zones.h b/fs/xfs/libxfs/xfs_zones.h
> index c16089c9a652..1391d99b31de 100644
> --- a/fs/xfs/libxfs/xfs_zones.h
> +++ b/fs/xfs/libxfs/xfs_zones.h
> @@ -30,6 +30,12 @@ struct blk_zone;
>  #define XFS_OPEN_GC_ZONES	1U
>  #define XFS_MIN_OPEN_ZONES	(XFS_OPEN_GC_ZONES + 1U)
>  
> +/*
> + * Never open a zone for user data unless this many zones are free, so that GC
> + * can always open the target zone it needs to make forward progress.
> + */
> +#define XFS_MIN_FREE_GC_ZONES	(XFS_GC_ZONES - XFS_OPEN_GC_ZONES)
> +
>  /*
>   * For zoned devices that do not have a limit on the number of open zones, and
>   * for regular devices using the zoned allocator, use the most common SMR disks
> diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
> index 28c1e48909fa..be434eeccab2 100644
> --- a/fs/xfs/xfs_zone_alloc.c
> +++ b/fs/xfs/xfs_zone_alloc.c
> @@ -437,6 +437,26 @@ xfs_init_open_zone(
>  	return oz;
>  }
>  
> +/*
> + * Claim one of the free zones. User allocations may not dip into the pool
> + * reserved for guaranteeing GC forward progress.
> + */
> +static bool
> +xfs_claim_free_zone(
> +	struct xfs_zone_info	*zi,
> +	bool			is_gc)
> +{
> +	int			min_free = is_gc ? 1 : XFS_MIN_FREE_GC_ZONES;
> +	int			free = atomic_read(&zi->zi_nr_free_zones);
> +
> +	do {
> +		if (free < min_free)
> +			return false;
> +	} while (!atomic_try_cmpxchg(&zi->zi_nr_free_zones, &free, free - 1));
> +
> +	return true;
> +}
> +
>  /*
>   * Find a completely free zone, open it, and return a reference.
>   */
> @@ -450,6 +470,9 @@ xfs_open_zone(
>  	XA_STATE		(xas, &mp->m_groups[XG_TYPE_RTG].xa, 0);
>  	struct xfs_group	*xg;
>  
> +	if (!xfs_claim_free_zone(zi, is_gc))
> +		return NULL;
> +
>  	/*
>  	 * Pick the free zone with lowest index. Zones in the beginning of the
>  	 * address space typically provides higher bandwidth than those at the
> @@ -460,11 +483,19 @@ xfs_open_zone(
>  		if (atomic_inc_not_zero(&xg->xg_active_ref))
>  			goto found;
>  	xas_unlock(&xas);
> +
> +	/*
> +	 * We should not end up here as we claimed a free zone before looking
> +	 * through the free zone list. The free zone counter and the number
> +	 * of zones marked as free must be out of sync.
> +	 */
> +	WARN_ON_ONCE(1);
> +
> +	atomic_inc(&zi->zi_nr_free_zones);
>  	return NULL;
>  
>  found:
>  	xas_clear_mark(&xas, XFS_RTG_FREE);
> -	atomic_dec(&zi->zi_nr_free_zones);
>  	xas_unlock(&xas);
>  
>  	set_current_state(TASK_RUNNING);
> @@ -483,9 +514,6 @@ xfs_try_open_zone(
>  
>  	if (zi->zi_nr_open_zones >= mp->m_max_open_zones - XFS_OPEN_GC_ZONES)
>  		return NULL;
> -	if (atomic_read(&zi->zi_nr_free_zones) <
> -	    XFS_GC_ZONES - XFS_OPEN_GC_ZONES)
> -		return NULL;
>  
>  	/*
>  	 * Increment the open zone count to reserve our slot before dropping
> -- 
> 2.43.0
> 
> 
