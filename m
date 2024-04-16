Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC5744377
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 20:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713300829; cv=none; b=c+WS9V9OqGUVCFZxwYPzd0lWiadV3wGVABhvtkD7dFgzJh/8KE143n2uzPiEtQdgooDxcXktMyJ8ONNvawxCOJn8TdvXiR7AZ3qrFs0FHpZBQvgTsz65OVludht8pZjvJdbcux/pZen7J9LmXH0CB6PjeOgsorihD5oXb7AI2BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713300829; c=relaxed/simple;
	bh=yKehmMPK4HEkCO0aRqndlcpvCDi1C4zJMpKy+mlA/Mc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D+ApBdkfhxjMThzZMxx4vSu6PjuBQAcTdpCGz69Jb0jyTCtzwR6QJaVQxXDdn2r/Qf2K5q2yon79WHAbbOBqRCMFJExKEsJmeArORw1nqTL3rjngSWd6EPVWv8bDSbdbJqRjPtkq9/JSFGHXayEB/noks3C/XEE9dvtKGQlw+9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wk/72Jf+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wk/72Jf+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0723C113CE;
	Tue, 16 Apr 2024 20:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713300828;
	bh=yKehmMPK4HEkCO0aRqndlcpvCDi1C4zJMpKy+mlA/Mc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Wk/72Jf+F4EQSvv5xzzhFfesKwpjJme9YRs+idqtKfUIhgnT2ukNoE50Ct35gvYws
	 jReM0DtSudL2HaWb1QWdASNpwv+n+DYDAtqasV+M+AchcF9wgPj7RWFrmSunAlFHJM
	 2+xbpvUoZdWn2KqjlSto+ifniAz5KdC2tCmYDaJgl2BRRwUDqa3h7jEko/aqc6AguB
	 dm2VVjRBoFl8peMJEQ2Z3T8QCYdDKBu5HHnwQV6FwlvF25YfhoJ4qe7PERSW69BA2D
	 rnebQsw5NMoD2HKA4Y3GEtqC9O6a4+R2jFcsoPmYKXn0HLkv0ToGogsQtWt1pzBr5L
	 wn7Y66tqC3AcA==
Date: Tue, 16 Apr 2024 13:53:48 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 2/2] xfs_db: add helper for flist_find_type for clearer
 field matching
Message-ID: <20240416205348.GE11948@frogsfrogsfrogs>
References: <20240416202841.725706-2-aalbersh@redhat.com>
 <20240416202841.725706-4-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240416202841.725706-4-aalbersh@redhat.com>

On Tue, Apr 16, 2024 at 10:28:42PM +0200, Andrey Albershteyn wrote:
> Make flist_find_type() more readable by unloading field type
> matching to the helper.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> ---
>  db/flist.c | 59 ++++++++++++++++++++++++++++++++++--------------------
>  1 file changed, 37 insertions(+), 22 deletions(-)
> 
> diff --git a/db/flist.c b/db/flist.c
> index 0a6cc5fcee43..18052a744a65 100644
> --- a/db/flist.c
> +++ b/db/flist.c
> @@ -400,6 +400,40 @@ flist_split(
>  	return v;
>  }
>  
> +flist_t *
> +flist_field_match(

Is this function going to be used outside of this module, or should it
be declared static?

> +	const field_t		*field,
> +	fldt_t			type,
> +	void			*obj,
> +	int			startoff)
> +{
> +	flist_t			*fl;
> +	int			count;
> +	const ftattr_t		*fa;
> +
> +	fl = flist_make(field->name);
> +	fl->fld = field;
> +	if (field->ftyp == type)
> +		return fl;
> +	count = fcount(field, obj, startoff);
> +	if (!count)
> +		goto out;
> +	fa = &ftattrtab[field->ftyp];
> +	if (fa->subfld) {

You could do:

	if (!fa->subfld)
		goto out;

	nfl = flist_find_ftyp(...);

to reduce the indenting here.  But I think you were trying to make
before and after as identical as possible, right?

> +		flist_t *nfl;
> +
> +		nfl = flist_find_ftyp(fa->subfld, type, obj, startoff);
> +		if (nfl) {
> +			fl->child = nfl;
> +			return fl;
> +		}
> +	}
> +
> +out:
> +	flist_free(fl);
> +	return NULL;
> +}
> +
>  /*
>   * Given a set of fields, scan for a field of the given type.
>   * Return an flist leading to the first found field
> @@ -413,33 +447,14 @@ flist_find_ftyp(
>  	void		*obj,
>  	int		startoff)
>  {
> -	flist_t	*fl;
>  	const field_t	*f;
> -	int		count;
> -	const ftattr_t  *fa;
> +	flist_t		*fl;
>  
>  	for (f = fields; f->name; f++) {
> -		fl = flist_make(f->name);
> -		fl->fld = f;
> -		if (f->ftyp == type)
> +		if ((fl = flist_field_match(f, type, obj, startoff)) != NULL)
>  			return fl;

Normally these days we expand assign-and-check when not in a loop
control test:

		fl = flist_field_match(...);
		if (fl)
			return fl;

But those last two comments merely reflect my style preference; the
question I care most about is the one about the static attribute.

--D

> -		count = fcount(f, obj, startoff);
> -		if (!count) {
> -			flist_free(fl);
> -			continue;
> -		}
> -		fa = &ftattrtab[f->ftyp];
> -		if (fa->subfld) {
> -			flist_t *nfl;
> -
> -			nfl = flist_find_ftyp(fa->subfld, type, obj, startoff);
> -			if (nfl) {
> -				fl->child = nfl;
> -				return fl;
> -			}
> -		}
> -		flist_free(fl);
>  	}
> +
>  	return NULL;
>  }
>  
> -- 
> 2.42.0
> 
> 
