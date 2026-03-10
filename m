Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97FF7376BEB
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 20:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773175764; cv=none; b=AwsmX8MXd0ojh1OuKYZihc244a+YcOiynfSB43Q9UUEjtpKOhw7R7JzE8/n+4PfzxSMIgGC9rYqgGd++/fbRe8tdixyz+Ir3bbpiL5Gsgt9FAAix/svJMsBjtBMxA3/PQpd/0rsIw0EjPVum2QaVp7z4F7UXycVsxCYJVtjU4t8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773175764; c=relaxed/simple;
	bh=2aPR+amkDM2tSSgH/XMIJFsR6/x/koeqKF3lDH48H8o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UYX1piHJNOq6gj9TM2qVne5x4fS6uuo8zBf3qZJCnVhSHTL1J2nhQ8GxsaSnImzZ4lSFT8HjZPBr95nIvGf60Tt7VES7ljWSE++H/M/O5RAYNX33KOe62xgHFVZNy1tKI2rsZgTReGiqZC9NPR+2p2zZBjM99lbuwXrzNyj3YDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fNH5c77G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fNH5c77G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F55C19423;
	Tue, 10 Mar 2026 20:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773175764;
	bh=2aPR+amkDM2tSSgH/XMIJFsR6/x/koeqKF3lDH48H8o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fNH5c77GPtnmmIb9UxbnklrS8OyZliGSyaPQvS369HOWPn1cLhmXgwSpcO5QhUXYI
	 s+b55lonjmd6hl2Om6wiSszTeQR23cinNhNBU4ZGtMi59meLa3HfM5nDugwhtFjXe8
	 1J0kkt0x+FeJos3AYEQWPXyu8ukngAdcvCo6NPkdTSz7tghPWJGlIHi9L5vGsDv+fH
	 pMefMOHDlu+RxS9NhnIxQGHhX9tPLx1awBQ7bymDOxEIaIKDzKuaYokJ5NVVNqBLD6
	 oetSurjnVGc897TybugOrcLi0iU1D3H7trbHywrJATNtmYI8GcUbKgTzUo2F/lX0MT
	 d6HtM4ZESFACw==
Date: Tue, 10 Mar 2026 13:49:23 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, hch@infradead.org
Subject: Re: [PATCH v3 REBASE] xfs: Use xarray to track SB UUIDs instead of
 plain array.
Message-ID: <20260310204923.GZ1105363@frogsfrogsfrogs>
References: <20260310123021.715566-2-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310123021.715566-2-lukas@herbolt.com>

On Tue, Mar 10, 2026 at 01:30:22PM +0100, Lukas Herbolt wrote:
> Removing the plain array to track the UUIDs and switch
> to xarray makes it more readable.
> 
> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
> ---
>  changes v3:
> 	fix locking/unlocking mistakes
> 	removing wrapper function xfs_uuid_insert()
> 	rebase xfs/for-next
> 
>  fs/xfs/xfs_mount.c | 76 ++++++++++++++++++++++------------------------
>  fs/xfs/xfs_mount.h |  3 ++
>  2 files changed, 40 insertions(+), 39 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 9c295abd0a0a..b183d04da998 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -44,17 +44,36 @@
>  #include "xfs_healthmon.h"
>  
>  static DEFINE_MUTEX(xfs_uuid_table_mutex);
> -static int xfs_uuid_table_size;
> -static uuid_t *xfs_uuid_table;
> +static DEFINE_XARRAY_ALLOC(xfs_uuid_table);
> +
> +static uuid_t *
> +xfs_uuid_search(
> +	uuid_t		*new_uuid)
> +{
> +	unsigned long	index = 0;
> +	uuid_t		*uuid;
> +
> +	xa_for_each(&xfs_uuid_table, index, uuid) {
> +		if (uuid_equal(uuid, new_uuid))
> +			return uuid;
> +	}
> +	return NULL;
> +}
> +
> +static void
> +xfs_uuid_delete(
> +	uuid_t		*uuid,
> +	unsigned int	index)
> +{
> +	ASSERT(uuid_equal(xa_load(&xfs_uuid_table, index), uuid));
> +	xa_erase(&xfs_uuid_table, index);
> +}
>  
>  void
>  xfs_uuid_table_free(void)
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
> @@ -66,7 +85,7 @@ xfs_uuid_mount(
>  	struct xfs_mount	*mp)
>  {
>  	uuid_t			*uuid = &mp->m_sb.sb_uuid;
> -	int			hole, i;
> +	int			ret;
>  
>  	/* Publish UUID in struct super_block */
>  	super_set_uuid(mp->m_super, uuid->b, sizeof(*uuid));
> @@ -80,30 +99,17 @@ xfs_uuid_mount(
>  	}
>  
>  	mutex_lock(&xfs_uuid_table_mutex);
> -	for (i = 0, hole = -1; i < xfs_uuid_table_size; i++) {
> -		if (uuid_is_null(&xfs_uuid_table[i])) {
> -			hole = i;
> -			continue;
> -		}
> -		if (uuid_equal(uuid, &xfs_uuid_table[i]))
> -			goto out_duplicate;
> -	}
> -
> -	if (hole < 0) {
> -		xfs_uuid_table = krealloc(xfs_uuid_table,
> -			(xfs_uuid_table_size + 1) * sizeof(*xfs_uuid_table),
> -			GFP_KERNEL | __GFP_NOFAIL);
> -		hole = xfs_uuid_table_size++;
> +	if (unlikely(xfs_uuid_search(uuid))) {
> +		xfs_warn(mp, "Filesystem has duplicate UUID %pU - can't mount",
> +				uuid);
> +		mutex_unlock(&xfs_uuid_table_mutex);
> +		return -EINVAL;
>  	}
> -	xfs_uuid_table[hole] = *uuid;
> -	mutex_unlock(&xfs_uuid_table_mutex);
>  
> -	return 0;
> -
> - out_duplicate:
> +	ret = xa_alloc(&xfs_uuid_table, &mp->m_uuid_table_index, uuid,
> +				xa_limit_32b, GFP_KERNEL);
>  	mutex_unlock(&xfs_uuid_table_mutex);
> -	xfs_warn(mp, "Filesystem has duplicate UUID %pU - can't mount", uuid);
> -	return -EINVAL;
> +	return ret;
>  }
>  
>  STATIC void
> @@ -111,22 +117,14 @@ xfs_uuid_unmount(
>  	struct xfs_mount	*mp)
>  {
>  	uuid_t			*uuid = &mp->m_sb.sb_uuid;
> -	int			i;
>  
>  	if (xfs_has_nouuid(mp))
>  		return;
>  
>  	mutex_lock(&xfs_uuid_table_mutex);
> -	for (i = 0; i < xfs_uuid_table_size; i++) {
> -		if (uuid_is_null(&xfs_uuid_table[i]))
> -			continue;
> -		if (!uuid_equal(uuid, &xfs_uuid_table[i]))
> -			continue;
> -		memset(&xfs_uuid_table[i], 0, sizeof(uuid_t));
> -		break;
> -	}
> -	ASSERT(i < xfs_uuid_table_size);
> +	xfs_uuid_delete(uuid, mp->m_uuid_table_index);
>  	mutex_unlock(&xfs_uuid_table_mutex);
> +	return;

Nit: no need to add a return; at the end of a void function.

With that fixed,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index ddd4028be8d6..d964bae096ef 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -346,6 +346,9 @@ typedef struct xfs_mount {
>  
>  	/* Private data referring to a health monitor object. */
>  	struct xfs_healthmon __rcu	*m_healthmon;
> +
> +	/* Index of uuid record in the uuid xarray. */
> +	unsigned int		m_uuid_table_index;
>  } xfs_mount_t;
>  
>  #define M_IGEO(mp)		(&(mp)->m_ino_geo)
> 
> base-commit: 54fcd2f95f8d216183965a370ec69e1aab14f5da
> -- 
> 2.53.0
> 
> 
