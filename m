Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4E027A476
	for <linux-xfs@vger.kernel.org>; Mon,  2 Feb 2026 16:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770051047; cv=none; b=TUEXtIgC/WwUI1p/e6BnHq73bWFxplI1dJLdIcLY/xXKhk//hk68rXRcIHPWs4YK+UA1pk7VS+u1htCExWKe0pa/V6t6ltcCL2TEA6F3p8rxEntcIwnoBJwa+NtSG1WjZ6cxgJM8HlddWmggr6Rt0xts/y3lGHXvoWa5l7K1Wf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770051047; c=relaxed/simple;
	bh=sX9BRwUu4TgA1vsm9D6YMPtZ3wM9XnXdKLO05C6lCig=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ONz2U2uIVoDR+B1PfXRAOP+qrBAcCypqht3/vr0WNaZWNMcW2YU5cU621sJYaoAMZxhOZ5ikcGTXPFRaWc8wrMUrg0ZHqDjdMr3BGouV5Hqhe1M4XRJRuARx2iPWJaTG1IPI0Ajg+UvcCD4RKJRLFrZk3Ial9hctdeto4GCJRes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XqymtIm7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XqymtIm7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF8C1C19422;
	Mon,  2 Feb 2026 16:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770051046;
	bh=sX9BRwUu4TgA1vsm9D6YMPtZ3wM9XnXdKLO05C6lCig=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XqymtIm7MJ4n7C4aBBCu7y/mNIiHtZpNBZage0Npvf068e7SXVv/XG4Gwq5PMYqoD
	 en3D3wFCiTSFl49TWiM2kEi84PJQugLZFk7NgdVluH2O7AOWTiPJQ0T2E//uZPJ2eJ
	 j+sh2zKf/1B4BcJyPSMTOikDvvUBq7+YsQdmvkJmf+5CkjgzWfSmdrCz9o9rCZPE3a
	 0lXVB3CYMlbpdv24EjYjMUV6RfT3lZPlLzBF/gHzQVPQac4ekCbiAwSzNVIgirpa7C
	 HpTdmErhzmY/gvop7qpCMQ2HAHuGSWNAdKvf9qwIrxIvqVFlJCuktPk+oSf5AnD6Dw
	 rDeBCsHRjMh+A==
Date: Mon, 2 Feb 2026 17:50:41 +0100
From: Carlos Maiolino <cem@kernel.org>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, 
	ojaswin@linux.ibm.com, djwong@kernel.org, bfoster@redhat.com, david@fromorbit.com, 
	hsiangkao@linux.alibaba.com
Subject: Re: [RFC V3 2/3] xfs: Refactoring the nagcount and delta calculation
Message-ID: <aYDVGFsUCjJr9T9i@nidhogg.toxiclabs.cc>
References: <cover.1760640936.git.nirjhar.roy.lists@gmail.com>
 <b84a4243ee87e0f0519e8565b1da5b8579ed0f64.1760640936.git.nirjhar.roy.lists@gmail.com>
 <1659bd90-2fbc-42df-abbe-3da52402feb6@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1659bd90-2fbc-42df-abbe-3da52402feb6@gmail.com>


Hi!

On Mon, Feb 02, 2026 at 07:45:56PM +0530, Nirjhar Roy (IBM) wrote:
> 
> On 10/20/25 21:13, Nirjhar Roy (IBM) wrote:
> > Introduce xfs_growfs_compute_delta() to calculate the nagcount
> > and delta blocks and refactor the code from xfs_growfs_data_private().
> > No functional changes.
> > 
> > Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> > Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> 
> Hi Carlos, Darrick,
> 
> Can this be picked up? This is quite independent of the rest of the patches
> in this series.

If you tag a series as RFC, don't expect the maintainer to pick it up.

Please, re-send it again without the RFC tag. We don't have more
time for this merge window though, I'll pick it up for the next.

Cheers.

> 
> --NR
> 
> > ---
> >   fs/xfs/libxfs/xfs_ag.c | 28 ++++++++++++++++++++++++++++
> >   fs/xfs/libxfs/xfs_ag.h |  3 +++
> >   fs/xfs/xfs_fsops.c     | 17 ++---------------
> >   3 files changed, 33 insertions(+), 15 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> > index e6ba914f6d06..f2b35d59d51e 100644
> > --- a/fs/xfs/libxfs/xfs_ag.c
> > +++ b/fs/xfs/libxfs/xfs_ag.c
> > @@ -872,6 +872,34 @@ xfs_ag_shrink_space(
> >   	return err2;
> >   }
> > +void
> > +xfs_growfs_compute_deltas(
> > +	struct xfs_mount	*mp,
> > +	xfs_rfsblock_t		nb,
> > +	int64_t			*deltap,
> > +	xfs_agnumber_t		*nagcountp)
> > +{
> > +	xfs_rfsblock_t	nb_div, nb_mod;
> > +	int64_t		delta;
> > +	xfs_agnumber_t	nagcount;
> > +
> > +	nb_div = nb;
> > +	nb_mod = do_div(nb_div, mp->m_sb.sb_agblocks);
> > +	if (nb_mod && nb_mod >= XFS_MIN_AG_BLOCKS)
> > +		nb_div++;
> > +	else if (nb_mod)
> > +		nb = nb_div * mp->m_sb.sb_agblocks;
> > +
> > +	if (nb_div > XFS_MAX_AGNUMBER + 1) {
> > +		nb_div = XFS_MAX_AGNUMBER + 1;
> > +		nb = nb_div * mp->m_sb.sb_agblocks;
> > +	}
> > +	nagcount = nb_div;
> > +	delta = nb - mp->m_sb.sb_dblocks;
> > +	*deltap = delta;
> > +	*nagcountp = nagcount;
> > +}
> > +
> >   /*
> >    * Extent the AG indicated by the @id by the length passed in
> >    */
> > diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> > index 1f24cfa27321..f7b56d486468 100644
> > --- a/fs/xfs/libxfs/xfs_ag.h
> > +++ b/fs/xfs/libxfs/xfs_ag.h
> > @@ -331,6 +331,9 @@ struct aghdr_init_data {
> >   int xfs_ag_init_headers(struct xfs_mount *mp, struct aghdr_init_data *id);
> >   int xfs_ag_shrink_space(struct xfs_perag *pag, struct xfs_trans **tpp,
> >   			xfs_extlen_t delta);
> > +void
> > +xfs_growfs_compute_deltas(struct xfs_mount *mp, xfs_rfsblock_t nb,
> > +	int64_t *deltap, xfs_agnumber_t *nagcountp);
> >   int xfs_ag_extend_space(struct xfs_perag *pag, struct xfs_trans *tp,
> >   			xfs_extlen_t len);
> >   int xfs_ag_get_geometry(struct xfs_perag *pag, struct xfs_ag_geometry *ageo);
> > diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> > index 0ada73569394..8353e2f186f6 100644
> > --- a/fs/xfs/xfs_fsops.c
> > +++ b/fs/xfs/xfs_fsops.c
> > @@ -92,18 +92,17 @@ xfs_growfs_data_private(
> >   	struct xfs_growfs_data	*in)		/* growfs data input struct */
> >   {
> >   	xfs_agnumber_t		oagcount = mp->m_sb.sb_agcount;
> > +	xfs_rfsblock_t		nb = in->newblocks;
> >   	struct xfs_buf		*bp;
> >   	int			error;
> >   	xfs_agnumber_t		nagcount;
> >   	xfs_agnumber_t		nagimax = 0;
> > -	xfs_rfsblock_t		nb, nb_div, nb_mod;
> >   	int64_t			delta;
> >   	bool			lastag_extended = false;
> >   	struct xfs_trans	*tp;
> >   	struct aghdr_init_data	id = {};
> >   	struct xfs_perag	*last_pag;
> > -	nb = in->newblocks;
> >   	error = xfs_sb_validate_fsb_count(&mp->m_sb, nb);
> >   	if (error)
> >   		return error;
> > @@ -122,20 +121,8 @@ xfs_growfs_data_private(
> >   			mp->m_sb.sb_rextsize);
> >   	if (error)
> >   		return error;
> > +	xfs_growfs_compute_deltas(mp, nb, &delta, &nagcount);
> > -	nb_div = nb;
> > -	nb_mod = do_div(nb_div, mp->m_sb.sb_agblocks);
> > -	if (nb_mod && nb_mod >= XFS_MIN_AG_BLOCKS)
> > -		nb_div++;
> > -	else if (nb_mod)
> > -		nb = nb_div * mp->m_sb.sb_agblocks;
> > -
> > -	if (nb_div > XFS_MAX_AGNUMBER + 1) {
> > -		nb_div = XFS_MAX_AGNUMBER + 1;
> > -		nb = nb_div * mp->m_sb.sb_agblocks;
> > -	}
> > -	nagcount = nb_div;
> > -	delta = nb - mp->m_sb.sb_dblocks;
> >   	/*
> >   	 * Reject filesystems with a single AG because they are not
> >   	 * supported, and reject a shrink operation that would cause a
> 
> -- 
> Nirjhar Roy
> Linux Kernel Developer
> IBM, Bangalore
> 
> 
