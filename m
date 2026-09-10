Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C01E3C584F;
	Thu, 10 Sep 2026 06:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789021639; cv=none; b=A+gRPZMbXczn907Wwy10uNO1VFGxB1hcppC/P+3Adq4pQy1PxegTkInZfaVRErQgVgx+2dIHILs6y7AKqp0IGPnGWwEOrwyMHTaqRgpohDhG2EUVEyTvbh+SiLlIrdzH8n8hu4397Ft0E/l+b+327CYo7Tjqrac5cpszlvQcv2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789021639; c=relaxed/simple;
	bh=6ALfx11zTl1d3VOOOPlF+PV+VUy+Z3ZCjmrjc7EuI8M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tpJfLBMLuhUdJUw19/YiHcSvKHOUxC5Ie539+A51zmLO7z3GsRLmAhpcRoYkDygFlyvqvr8RzNFfJMiS3JuWKsBhvaaWT7XpFdeji194PuIS1pHwTxUuoVIiTARyxvNYL6JMvrt1dYei2+4B25V8CwG+AU4EaVvijZhMfGsBhz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PvM3mb9a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PvM3mb9a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 794B31F00893;
	Thu, 10 Sep 2026 06:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789021638;
	bh=LmQPSlIMbNQbZmsXoI9th3BPOmA0NlJk3Q3TI/x65hU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PvM3mb9agP01/lQLKr4p91SLp5u+VQ8eds92E9c0+OUszvw9Y2KMGp6azJ2oU9NFZ
	 g1eU7hq/PuvgPAlFgvcH8FncsC6EGL6EtUe1+Q/Gojen5+nuEdK7XfWv529QXl4P2N
	 NKijP5GnrArOtmCjAFLlZG85HvP4JMWkCfOFKLjNsCv32cKaJBZwvMvOIZpWxlndKo
	 LQA2nNvgE2/x60f7tpNAm/AsFwddqHAtQqMRwEVn5qax96RlWi3thohHZQUYm/tkoy
	 ARYnQgC2R+5wJARjt1Xz8Drh5lY8cSgIOtHzVqRezawAzLOhBhuMGlT7uqoXjeStId
	 7R/8Qq2TrxQqw==
Date: Thu, 10 Sep 2026 08:27:13 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, dgc@kernel.org, floss@jetm.me, 
	stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: fix under-reservation of blocks when repairing
 sf directories
Message-ID: <aqJNVGbubjNJ9WG5@andromeda.toxiclabs.cc>
References: <178892936573.4057962.16225191041041958394.stgit@frogsfrogsfrogs>
 <178892936640.4057962.1916451282677820756.stgit@frogsfrogsfrogs>
 <20260910050031.GB26687@lst.de>
 <aqJANTuQQMEIqcmO@andromeda.toxiclabs.cc>
 <20260910060907.GC6253@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260910060907.GC6253@frogsfrogsfrogs>

On Wed, Sep 09, 2026 at 11:09:07PM -0700, Darrick J. Wong wrote:
> On Thu, Sep 10, 2026 at 07:31:37AM +0200, Carlos Maiolino wrote:
> > On Thu, Sep 10, 2026 at 07:00:31AM +0200, Christoph Hellwig wrote:
> > > On Tue, Sep 08, 2026 at 11:04:35PM -0700, Darrick J. Wong wrote:
> > > > +static inline unsigned int
> > > > +xrep_tempexch_estimate_sf_resblks(
> > > > +	struct xfs_scrub	*sc,
> > > > +	int			whichfork)
> > > > +{
> > > > +	if (whichfork == XFS_ATTR_FORK)
> > > > +		return sc->mp->m_attr_geo->fsbcount;
> > > > +	if (S_ISDIR(VFS_I(sc->ip)->i_mode))
> > > > +		return sc->mp->m_dir_geo->fsbcount;
> > > > +	return 1;
> > > 
> > > geo->fsbcount for attrs is a always 1 and a lot of code relies on that,
> > > so this feels a bit overcomplicated and misleading (but still correct).
> > > 
> > > What about the more usual:
> > > 
> > > 	if (S_ISDIR(VFS_I(sc->ip)->i_mode) && whichfork == XFS_DATA_FORK)
> > > 		return sc->mp->m_dir_geo->fsbcount;
> > > 	return 1;
> 
> I prefer not to leave a logic bomb in the scrub code in case we ever
> have multi-fsblock attr blocks.
> 
> Though I guess I'd be ok with
> 
> 	ASSERT(mp->m_attr_geo->fsbcount == 1);
> 
> 	if (S_ISDIR(VFS_I(sc->ip)->i_mode) && whichfork == XFS_DATA_FORK)
> 		return sc->mp->m_dir_geo->fsbcount;
> 	return 1;
> 
> or something like that?

That sounds good to me too.

Between all three I prefer the first explicit, self-documenting one, but
I have no strong feelings for any.

I agree about not leaving any magic numbers unchecked though.

> 
> > Either are fine to me so feel free to add:
> > 
> > Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> 
> But only if Carlos really wants me to add that.
> 
> --D
> 
> > 
> > > 
> > > ?
> > > 
> > > Otherwise looks good:
> > > 
> > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > 
> 
