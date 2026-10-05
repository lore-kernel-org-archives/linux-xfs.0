Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7B3747CA6D
	for <linux-xfs@vger.kernel.org>; Mon,  5 Oct 2026 12:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791202477; cv=none; b=JlZTGNTaTbWOMtDoH25xSVG2vJjet4QOIEPS1NddadydAyaRbttrROxBLJUsiR80LkyYOTMhWHVlbvdpg86u6aejLh2VWMJglPUtClI5LD4//MtaPdmGT+Es73eH4AYnhedxx3oM4uJRjRov0jTL0qFhkXMuHd4PpFO/gzn3vZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791202477; c=relaxed/simple;
	bh=ZewqurpNKm1/I2xxts31i8QkdmU+iCf0GPJwmWx3bCU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TXkyQEjh7RiN5Mj97TW4bidwkXqlNIwOHDzDK98RqKn3UZU47LPqgnxvTyYBcY3g4iO+O98KVOGE0+kRjHeNh78lRqlP038Cvb3BorfUknmGOaEqfgJWGRJ6MMOYK8OfHXQGFTzgkKFjSDj3mufV4TvQTpvdNMvZ+6gqqZYVfps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MgfS35fI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MgfS35fI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A14661F000FF;
	Mon,  5 Oct 2026 12:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791202475;
	bh=aRrXArbWNCKob05LumCOLODHvIEjWeop0PYfcXgHXKg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MgfS35fId07zpwUj4TcbyzHVv3YRQScOG4rHL8ktYyGpSyv+4VEJRpUJLRqRdk0Xt
	 7vh0FWQ/UG8HM4jC7zlksalRqoNkKzOXL6OR0l0Wy56x5mpHiDFE43CDQYFRUNQj39
	 dcdsuwkNkqlIadBuMs2GeDjw2hXDoVJSKQrBU+irq71GZK9ww0NVI9QhYWDdI4FWX4
	 TziFJl90+gnQRs4CDz15kFnU2dKN6AblMrGWmYjlsitXvQrOylX8+yphOO1Nf8yj7l
	 K7y3/E0fYl+bqr+o431Bojuz8daOAsuLdMEiYbJwCUlumBAP/balDvTOFnuIiM27NU
	 ysclRAu0fgXJQ==
Date: Mon, 5 Oct 2026 14:14:31 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH 1/3] xfs: factor out xfs_dir2_sf_copy_entries helper
Message-ID: <asOUn3CDkcVWdCek@nidhogg.toxiclabs.cc>
References: <20261002211038.2139655-1-sandeen@redhat.com>
 <20261002211038.2139655-2-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261002211038.2139655-2-sandeen@redhat.com>

On Fri, Oct 02, 2026 at 04:08:09PM -0500, Eric Sandeen wrote:
> xfs_dir2_sf_toino8 and xfs_dir2_sf_toino64 share a dozen or so lines
> of copied code used to move short form directory entries; factor that
> out to eliminate cut and paste.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Looks good.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

>  fs/xfs/libxfs/xfs_dir2_sf.c | 68 ++++++++++++++++---------------------
>  1 file changed, 30 insertions(+), 38 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> index 0567cf8b9c1b..a8675a0d574e 100644
> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> @@ -1124,6 +1124,34 @@ xfs_dir2_sf_replace(
>  	return 0;
>  }
>  
> +static inline void
> +xfs_dir2_sf_copy_entries(
> +	struct xfs_mount	*mp,
> +	struct xfs_dir2_sf_hdr	*sfp,
> +	struct xfs_dir2_sf_hdr	*oldsfp)
> +{
> +	int			i;
> +	struct xfs_dir2_sf_entry *sfep;		/* new sf entry */
> +	struct xfs_dir2_sf_entry *oldsfep;	/* old sf entry */
> +
> +	/*
> +	 * Copy the entries field by field.
> +	 */
> +	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp),
> +		    oldsfep = xfs_dir2_sf_firstentry(oldsfp);
> +	     i < sfp->count;
> +	     i++, sfep = xfs_dir2_sf_nextentry(mp, sfp, sfep),
> +		  oldsfep = xfs_dir2_sf_nextentry(mp, oldsfp, oldsfep)) {
> +		sfep->namelen = oldsfep->namelen;
> +		memcpy(sfep->offset, oldsfep->offset, sizeof(sfep->offset));
> +		memcpy(sfep->name, oldsfep->name, sfep->namelen);
> +		xfs_dir2_sf_put_ino(mp, sfp, sfep,
> +				xfs_dir2_sf_get_ino(mp, oldsfp, oldsfep));
> +		xfs_dir2_sf_put_ftype(mp, sfep,
> +				xfs_dir2_sf_get_ftype(mp, oldsfep));
> +	}
> +}
> +
>  /*
>   * Convert from 8-byte inode numbers to 4-byte inode numbers.
>   * The last 8-byte inode number is gone, but the count is still 1.
> @@ -1136,11 +1164,8 @@ xfs_dir2_sf_toino4(
>  	struct xfs_mount	*mp = dp->i_mount;
>  	struct xfs_dir2_sf_hdr	*oldsfp = dp->i_df.if_data;
>  	char			*buf;		/* old dir's buffer */
> -	int			i;		/* entry index */
>  	int			newsize;	/* new inode size */
> -	xfs_dir2_sf_entry_t	*oldsfep;	/* old sf entry */
>  	int			oldsize;	/* old inode size */
> -	xfs_dir2_sf_entry_t	*sfep;		/* new sf entry */
>  	xfs_dir2_sf_hdr_t	*sfp;		/* new sf directory */
>  
>  	trace_xfs_dir2_sf_toino4(args);
> @@ -1171,22 +1196,7 @@ xfs_dir2_sf_toino4(
>  	sfp->count = oldsfp->count;
>  	sfp->i8count = 0;
>  	xfs_dir2_sf_put_parent_ino(sfp, xfs_dir2_sf_get_parent_ino(oldsfp));
> -	/*
> -	 * Copy the entries field by field.
> -	 */
> -	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp),
> -		    oldsfep = xfs_dir2_sf_firstentry(oldsfp);
> -	     i < sfp->count;
> -	     i++, sfep = xfs_dir2_sf_nextentry(mp, sfp, sfep),
> -		  oldsfep = xfs_dir2_sf_nextentry(mp, oldsfp, oldsfep)) {
> -		sfep->namelen = oldsfep->namelen;
> -		memcpy(sfep->offset, oldsfep->offset, sizeof(sfep->offset));
> -		memcpy(sfep->name, oldsfep->name, sfep->namelen);
> -		xfs_dir2_sf_put_ino(mp, sfp, sfep,
> -				xfs_dir2_sf_get_ino(mp, oldsfp, oldsfep));
> -		xfs_dir2_sf_put_ftype(mp, sfep,
> -				xfs_dir2_sf_get_ftype(mp, oldsfep));
> -	}
> +	xfs_dir2_sf_copy_entries(mp, sfp, oldsfp);
>  	/*
>  	 * Clean up the inode.
>  	 */
> @@ -1208,11 +1218,8 @@ xfs_dir2_sf_toino8(
>  	struct xfs_mount	*mp = dp->i_mount;
>  	struct xfs_dir2_sf_hdr	*oldsfp = dp->i_df.if_data;
>  	char			*buf;		/* old dir's buffer */
> -	int			i;		/* entry index */
>  	int			newsize;	/* new inode size */
> -	xfs_dir2_sf_entry_t	*oldsfep;	/* old sf entry */
>  	int			oldsize;	/* old inode size */
> -	xfs_dir2_sf_entry_t	*sfep;		/* new sf entry */
>  	xfs_dir2_sf_hdr_t	*sfp;		/* new sf directory */
>  
>  	trace_xfs_dir2_sf_toino8(args);
> @@ -1243,22 +1250,7 @@ xfs_dir2_sf_toino8(
>  	sfp->count = oldsfp->count;
>  	sfp->i8count = 1;
>  	xfs_dir2_sf_put_parent_ino(sfp, xfs_dir2_sf_get_parent_ino(oldsfp));
> -	/*
> -	 * Copy the entries field by field.
> -	 */
> -	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp),
> -		    oldsfep = xfs_dir2_sf_firstentry(oldsfp);
> -	     i < sfp->count;
> -	     i++, sfep = xfs_dir2_sf_nextentry(mp, sfp, sfep),
> -		  oldsfep = xfs_dir2_sf_nextentry(mp, oldsfp, oldsfep)) {
> -		sfep->namelen = oldsfep->namelen;
> -		memcpy(sfep->offset, oldsfep->offset, sizeof(sfep->offset));
> -		memcpy(sfep->name, oldsfep->name, sfep->namelen);
> -		xfs_dir2_sf_put_ino(mp, sfp, sfep,
> -				xfs_dir2_sf_get_ino(mp, oldsfp, oldsfep));
> -		xfs_dir2_sf_put_ftype(mp, sfep,
> -				xfs_dir2_sf_get_ftype(mp, oldsfep));
> -	}
> +	xfs_dir2_sf_copy_entries(mp, sfp, oldsfp);
>  	/*
>  	 * Clean up the inode.
>  	 */
> -- 
> 2.55.0
> 
> 
