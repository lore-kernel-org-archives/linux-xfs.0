Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A557D141995
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 15:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713367233; cv=none; b=YNsZ0BVInOp4EgdQaIP11xJert0zwPoV0vS5zO0yRyI/9yLZmRxVF5um1x4SX64baHicr9Q4JMvMsq2ziB4ZeV5QG8innygiJwx5SWhewsiDj5fem4i41kfnvBicFZ80DYZJdDndDoH7M3quRPucR2ox3gHwqm+70tmnwHs5K5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713367233; c=relaxed/simple;
	bh=B4xxCWU/05LmvlZvE9kJ81VzuEIHVgwCTPKrPudgD/8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NdMa7aoqp6CiZv2Y8nIzzPKrLFkgQ0FNAYvzKvOhLp11niqK1XeSGO3CkhScZy+aA12Ya+8YVM99f6hVw88iSYJltMIK2PBNw3lX61oazhcKOAhPCBQHFuwxS5M7mt7IhFO9GNGHAJxEwCJpdOQeeAwlJCWNf85YP2jfU+C5L4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n1CPk2BN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n1CPk2BN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3323FC3277B;
	Wed, 17 Apr 2024 15:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713367233;
	bh=B4xxCWU/05LmvlZvE9kJ81VzuEIHVgwCTPKrPudgD/8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=n1CPk2BNG+5uLTeowMvyYJLeyS8yzIR1VfncIrUTp+soyu080Az19lD9FooDxLHwM
	 vT3ddqz5K0HLCZk6FDnYnmOMSiNk2gEW+cGnZwDSmliIn4CmUR2NIukXCIAojKlLEq
	 CeCl5GKDUpq3esIluDjS5klNJvbAvV/MijzFY0WkuNpUrqcX/gilteem0dSFzRNYfH
	 /2mq6ObuZJvu0cKQX43lMLGRYxYqXN3ySHdoMiYwNbJTEtPHFasrQnV8LhIr+nzTgG
	 m2o8Y38WD67CEFrOowldZtFJkMH1KsiPRxEfVfgiDE38wA5GegKNOFtYz49Z4uHM48
	 nw5fxaARROXtA==
Date: Wed, 17 Apr 2024 08:20:32 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH v2 2/3] xfs_db: add helper for flist_find_type for
 clearer field matching
Message-ID: <20240417152032.GU11948@frogsfrogsfrogs>
References: <20240417125937.917910-1-aalbersh@redhat.com>
 <20240417125937.917910-3-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240417125937.917910-3-aalbersh@redhat.com>

On Wed, Apr 17, 2024 at 02:59:36PM +0200, Andrey Albershteyn wrote:
> Make flist_find_type() more readable by unloading field type
> matching to the helper.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>

Looks good now,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  db/flist.c | 60 ++++++++++++++++++++++++++++++++++--------------------
>  1 file changed, 38 insertions(+), 22 deletions(-)
> 
> diff --git a/db/flist.c b/db/flist.c
> index 0a6cc5fcee43..ab0a0f133804 100644
> --- a/db/flist.c
> +++ b/db/flist.c
> @@ -400,6 +400,40 @@ flist_split(
>  	return v;
>  }
>  
> +static flist_t *
> +flist_field_match(
> +	const field_t		*field,
> +	fldt_t			type,
> +	void			*obj,
> +	int			startoff)
> +{
> +	flist_t			*fl;
> +	int			count;
> +	const ftattr_t		*fa;
> +	flist_t			*nfl;
> +
> +	fl = flist_make(field->name);
> +	fl->fld = field;
> +	if (field->ftyp == type)
> +		return fl;
> +	count = fcount(field, obj, startoff);
> +	if (!count)
> +		goto out;
> +	fa = &ftattrtab[field->ftyp];
> +	if (!fa->subfld)
> +		goto out;
> +
> +	nfl = flist_find_ftyp(fa->subfld, type, obj, startoff);
> +	if (nfl) {
> +		fl->child = nfl;
> +		return fl;
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
> @@ -413,33 +447,15 @@ flist_find_ftyp(
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
> +		fl = flist_field_match(f, type, obj, startoff);
> +		if (fl)
>  			return fl;
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
