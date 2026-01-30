Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795E82FCBE3
	for <linux-xfs@vger.kernel.org>; Fri, 30 Jan 2026 16:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769792135; cv=none; b=ewhEMr5qM5AnuHIf7p4C/Z6g5X2x1tQr74S+RTy/P7CHEkAwPzA/d8Oadj+2kkjn0fD2P+5NM9Wd+UQqBMSCO/QiAxKGU1o2GS1MAvvmy4cxBREIFzW2YShYFF0HN4goaMaAlvPUEArPi7cvN8voJBDtUI/dgTaZHO7aC4iHac4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769792135; c=relaxed/simple;
	bh=unACMDs/mjky5L11S3jq42d2mErhwm9OujaOdSB+fu0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M8zD8anm2XPQu1GeUe0/wvLxysqxaACFUeICIR8+AxKY4Gq9iSQ1WVExE9+In8ZHJPxCZSyvhXucV27HaBwQLG8qyqIeRn8zZO7NJbnj0qou5f9otnDGLDEAMSTmeIAhr8rfnj3eHF3E6XfVSEFNzEEaOsuOVynZlUfuXkcH1Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vL/ONHEK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vL/ONHEK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14777C4CEF7;
	Fri, 30 Jan 2026 16:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769792135;
	bh=unACMDs/mjky5L11S3jq42d2mErhwm9OujaOdSB+fu0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vL/ONHEKBcNMXQZWBCog6BIVwdZPHetosFx/o0p4j/0f37sowI5DeUfCcoheRWaSv
	 54ytEOxCUruBjJPT4+PPO4ixxfvTEs5HhMj2u8slPAcvuYXnYjWLqWqSfsVNSvMT4b
	 Iuv6z3Bm+9UCVPESNnnAkzN0mQ/nuHvzU52DPjZQ5Pi4ad9DRZgyzxNf/J+jYFTscU
	 ogkaH3XL4ct6e6iJJog8Q4rhYw6wFKNyjBjnk8p4fn/o9YByw9Y3D0sZ2aOPgiUxNE
	 MXh3GODHLDHlZUEmnYeY9zcJynF6b5k92g+9Cz/eK0uvQFno9KfpOZe6yYvCMs36tT
	 VpFMYmjklMP5Q==
Date: Fri, 30 Jan 2026 08:55:34 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH] xfs: Use xarray to track SB UUIDs instead of plain array.
Message-ID: <20260130165534.GG7712@frogsfrogsfrogs>
References: <20260130154206.1368034-2-lukas@herbolt.com>
 <20260130154206.1368034-4-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260130154206.1368034-4-lukas@herbolt.com>

On Fri, Jan 30, 2026 at 04:42:08PM +0100, Lukas Herbolt wrote:
> Removing the plain array to track the UUIDs and switch
> xarray to make more readable.
> 
> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
> ---
>  fs/xfs/xfs_mount.c | 87 +++++++++++++++++++++++-----------------------
>  fs/xfs/xfs_mount.h |  3 +-
>  fs/xfs/xfs_super.c |  2 +-
>  3 files changed, 46 insertions(+), 46 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 0953f6ae94ab..35c0d411e0cb 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -42,18 +42,48 @@
>  #include "scrub/stats.h"
>  #include "xfs_zone_alloc.h"
>  
> -static DEFINE_MUTEX(xfs_uuid_table_mutex);
> -static int xfs_uuid_table_size;
> -static uuid_t *xfs_uuid_table;
> +static DEFINE_XARRAY_ALLOC(xfs_uuid_table);
> +
> +/*
> + * Helper fucntions to store UUID in xarray.
> + */
> +STATIC int
> +xfs_uuid_insert(uuid_t *uuid)
> +{
> +	uint32_t index = 0;
> +
> +	return xa_alloc(&xfs_uuid_table, &index, uuid,
> +			xa_limit_32b, GFP_KERNEL);
> +}
> +
> +STATIC uuid_t
> +*xfs_uuid_search(uuid_t *new_uuid)
> +{
> +	unsigned long index = 0;
> +	uuid_t *uuid = NULL;
> +
> +	xa_for_each(&xfs_uuid_table, index, uuid) {
> +		if (uuid_equal(uuid, new_uuid))
> +			return uuid;
> +	}
> +	return NULL;
> +}
> +
> +STATIC void
> +xfs_uuid_delete(uuid_t *uuid)
> +{
> +	unsigned long index = 0;
> +
> +	xa_for_each(&xfs_uuid_table, index, uuid) {
> +		xa_erase(&xfs_uuid_table, index);
> +	}

Why not store the xarray index in the xfs_mount so you can delete the
entry directly without having to walk the entire array?

And while I'm on about it ... if you're going to change data structures,
why not use rhashtable or something that can do a direct lookup?

> +}
>  
>  void
> -xfs_uuid_table_free(void)
> +xfs_uuid_table_destroy(void)
>  {
> -	if (xfs_uuid_table_size == 0)
> -		return;
> -	kfree(xfs_uuid_table);
> -	xfs_uuid_table = NULL;
> -	xfs_uuid_table_size = 0;
> +	ASSERT(xa_empty(&xfs_uuid_table));
> +	xa_destroy(&xfs_uuid_table);
>  }
>  
>  /*
> @@ -65,7 +95,6 @@ xfs_uuid_mount(
>  	struct xfs_mount	*mp)
>  {
>  	uuid_t			*uuid = &mp->m_sb.sb_uuid;
> -	int			hole, i;
>  
>  	/* Publish UUID in struct super_block */
>  	super_set_uuid(mp->m_super, uuid->b, sizeof(*uuid));
> @@ -78,29 +107,9 @@ xfs_uuid_mount(
>  		return -EINVAL;
>  	}
>  
> -	mutex_lock(&xfs_uuid_table_mutex);
> -	for (i = 0, hole = -1; i < xfs_uuid_table_size; i++) {
> -		if (uuid_is_null(&xfs_uuid_table[i])) {
> -			hole = i;
> -			continue;
> -		}
> -		if (uuid_equal(uuid, &xfs_uuid_table[i]))
> -			goto out_duplicate;
> -	}
> +	if (!xfs_uuid_search(uuid))
> +		return xfs_uuid_insert(uuid);

xfs_uuid_table_mutex went away, so what's protecting the lookup and
insert from racing to insert the same uuid twice?

--D

>  
> -	if (hole < 0) {
> -		xfs_uuid_table = krealloc(xfs_uuid_table,
> -			(xfs_uuid_table_size + 1) * sizeof(*xfs_uuid_table),
> -			GFP_KERNEL | __GFP_NOFAIL);
> -		hole = xfs_uuid_table_size++;
> -	}
> -	xfs_uuid_table[hole] = *uuid;
> -	mutex_unlock(&xfs_uuid_table_mutex);
> -
> -	return 0;
> -
> - out_duplicate:
> -	mutex_unlock(&xfs_uuid_table_mutex);
>  	xfs_warn(mp, "Filesystem has duplicate UUID %pU - can't mount", uuid);
>  	return -EINVAL;
>  }
> @@ -110,22 +119,12 @@ xfs_uuid_unmount(
>  	struct xfs_mount	*mp)
>  {
>  	uuid_t			*uuid = &mp->m_sb.sb_uuid;
> -	int			i;
>  
>  	if (xfs_has_nouuid(mp))
>  		return;
> +	xfs_uuid_delete(uuid);
> +	return;
>  
> -	mutex_lock(&xfs_uuid_table_mutex);
> -	for (i = 0; i < xfs_uuid_table_size; i++) {
> -		if (uuid_is_null(&xfs_uuid_table[i]))
> -			continue;
> -		if (!uuid_equal(uuid, &xfs_uuid_table[i]))
> -			continue;
> -		memset(&xfs_uuid_table[i], 0, sizeof(uuid_t));
> -		break;
> -	}
> -	ASSERT(i < xfs_uuid_table_size);
> -	mutex_unlock(&xfs_uuid_table_mutex);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index b871dfde372b..c3a5035c1fb6 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -689,7 +689,8 @@ xfs_daddr_to_agbno(struct xfs_mount *mp, xfs_daddr_t d)
>  	return (xfs_agblock_t) do_div(ld, mp->m_sb.sb_agblocks);
>  }
>  
> -extern void	xfs_uuid_table_free(void);
> +extern void xfs_uuid_table_destroy(void);
> +
>  uint64_t	xfs_default_resblks(struct xfs_mount *mp,
>  			enum xfs_free_counter ctr);
>  extern int	xfs_mountfs(xfs_mount_t *mp);
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index bc71aa9dcee8..fc9d2e5acf96 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -2723,7 +2723,7 @@ exit_xfs_fs(void)
>  	xfs_mru_cache_uninit();
>  	xfs_destroy_workqueues();
>  	xfs_destroy_caches();
> -	xfs_uuid_table_free();
> +	xfs_uuid_table_destroy();
>  }
>  
>  module_init(init_xfs_fs);
> 
> base-commit: 63804fed149a6750ffd28610c5c1c98cce6bd377
> -- 
> 2.52.0
> 
> 
