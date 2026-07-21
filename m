Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 342683358B0;
	Tue, 21 Jul 2026 03:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784604031; cv=none; b=bBArRVyVN80PCQmzfhfnK0VjU00cOxxEz14CJjEkW64yesqJYJ/QtLf7lWxpj1j6Lf/nbmZHkfRMpXE0lIdPPf4tzdwKDFywEKFaLOcOEXnmDwmmVOHO9sNEWpuSl/urRzPeoMZtuhDLw/HdAD3ZtDdHgxSbDVjuLdK8J1wqzCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784604031; c=relaxed/simple;
	bh=8W/xsJ91Ioqcn2ahZ8aWABxKDrVRJ6y4z9ZRfQGk21U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SAGyQbXAxkjnYhUV9XOMvwl96Ay0AFoEbNX2odNPwwtO8LWVXySZA/6uOPAFIhdulXgzg4zhNrGW4ast9RnCsOJ1NkwlAzZfWh0b7sNXLqJB6QJdG/R26wmk8I87JCwgAFoIcjKkchE6J6+EqvWB0OaInBs37xCUfxO3oN7tksQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HxFrhgOb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HxFrhgOb"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A7B8D1F000E9;
	Tue, 21 Jul 2026 03:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784604029;
	bh=VznCUXcv1BTlqNZqH5BmOoAJiQXiSMmFHEmqcwC2Zjc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HxFrhgOb+j3NYNTznp5is0jp5MnepbgIDC2Nj03feh3O8c1aRq8l6eDWOuTeIFwyo
	 Jlgp2ZEOwT+mFFIHHcgXQZB2a26CSCx7WXofHkX2DWGQm8cTknMvdRQaQ6gvPOu4g/
	 ALE7PqGdj42oloSUPoKOQJq+zZHt1wz8g4oFaZGRkfhTRMwDaiArOTqtxELkZxNS/Y
	 v4g9fEFmIiBO23svrIhb/bvuaN/ewUirEn3Qj73seDuz1qlb4za5Z5SWdxHXmLgAF2
	 HlGstm09rGcnXHBo0ycNmwZ/XXxBHQ+JX+I0/IeXrX1COidpmtqyoBlQSSEB3lGYsp
	 UQEUuLTFkgAWQ==
Date: Mon, 20 Jul 2026 20:20:27 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: brauner@kernel.org, hch@lst.de, dgc@kernel.org, jack@suse.cz,
	cem@kernel.org, axboe@kernel.dk, kbusch@kernel.org,
	ritesh.list@gmail.com, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH v4 4/6] xfs: generic AG set based steering
Message-ID: <20260721032027.GW7380@frogsfrogsfrogs>
References: <20260717125538.508925-1-joshi.k@samsung.com>
 <CGME20260717125636epcas5p2b68dd498717813e0b395b9d57d9d97df@epcas5p2.samsung.com>
 <20260717125538.508925-5-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717125538.508925-5-joshi.k@samsung.com>

On Fri, Jul 17, 2026 at 06:25:36PM +0530, Kanchan Joshi wrote:
> Improve allocator concurrency and reduce interleaving by introducing
> fixed sized AG set.
> Use low bits of the inode as a hash to select AG within the AG set.
> Overall, a file will try to use the same AG (and contiguity is maintained),
> but multiple files will be spread across all AGs in the target AG set.
> 
> Suggested-by: Dave Chinner <dgc@kernel.org>
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 38 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 38 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index d64defeda645..fd1a3aa4ad3f 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3192,6 +3192,36 @@ xfs_bmap_select_minlen(
>  	return args->maxlen;
>  }
>  
> +#define	GENERIC_AG_SET_SZ	(2)

What does this define?

> +
> +static inline xfs_agnumber_t
> +xfs_default_ag_set_size(
> +	struct xfs_inode	*ip)
> +{
> +	struct xfs_mount	*mp = ip->i_mount;
> +
> +	return min_t(xfs_agnumber_t, GENERIC_AG_SET_SZ, mp->m_sb.sb_agcount);

Because I'm not sure what it means on a single-AG filesystem.

> +}
> +
> +static xfs_agnumber_t
> +xfs_ag_to_ag_set(
> +	struct xfs_bmalloca	*ap,
> +	xfs_agnumber_t		base_agno)
> +{
> +	struct xfs_inode	*ip = ap->ip;
> +	struct xfs_mount	*mp = ip->i_mount;
> +	xfs_agnumber_t		set_size;
> +
> +	/* Apply fanning only for regular file data */
> +	if (!(ap->datatype & XFS_ALLOC_USERDATA))
> +		return base_agno;
> +
> +	set_size = xfs_default_ag_set_size(ip);
> +	/* Fan out within the AG set using low bits of the inode */
> +	return (base_agno + (XFS_INO_TO_AGINO(mp, I_INO(ip)) % set_size)) %
> +		mp->m_sb.sb_agcount;
> +}
> +
>  static int
>  xfs_bmap_btalloc_select_lengths(
>  	struct xfs_bmalloca	*ap,
> @@ -3587,8 +3617,16 @@ xfs_bmap_btalloc_best_length(
>  {
>  	xfs_extlen_t		blen = 0;
>  	int			error;
> +	xfs_agnumber_t		target_ag, start_ag;
>  
>  	ap->blkno = XFS_INODE_TO_FSB(ap->ip);
> +
> +	/* fan out initial AG across the generic AG set */
> +	start_ag = XFS_FSB_TO_AGNO(args->mp, ap->blkno);
> +	target_ag = xfs_ag_to_ag_set(ap, start_ag);
> +	if (target_ag != start_ag)
> +		ap->blkno = XFS_AGB_TO_FSB(args->mp, target_ag, 0);

/me wonders, if xfs_bmap_rtalloc looked at ap->blkno for a hint the way
that the data device allocator does, then would it be trivial to have
write streams on the rt device too?

I guess the tricky part would be figuring out what to do if you ever
want to switch a file between rt and data devices -- presumably you'd
just reset the write stream id to the default, but I guess you could
reject such a switch if the id had been set explicitly.

--D

> +
>  	if (!xfs_bmap_adjacent(ap))
>  		ap->eof = false;
>  
> -- 
> 2.25.1
> 
> 
