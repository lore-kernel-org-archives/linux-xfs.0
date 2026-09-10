Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8706E37FF6A;
	Thu, 10 Sep 2026 06:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789020552; cv=none; b=uIWUFkbn2VG6SjCT5iV4mCdbniZheum0hQgjRYMYX6KNBlw/OZX1dHCbmEs5asvEM5KAFZmS5hKNs3aNC8gwuu1OFDXfBOrBHYfXsgezQqslHXx4+Od7S8Rq9xegVssRGGUVAGnTU05ZT/+QsEsyiiCiR0SDLq7Iw4msk3Bz5Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789020552; c=relaxed/simple;
	bh=ghQPz6Q0lgcH5PJj72lYwgb8VnCyHxSfV3phXAsPD3w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jrFCLx9N8c+QkNZhI2s0zqZzooTGq8Ywv/y+NB6fyrbdZh4rHpmqvgELRAiaSizTwJ9Xtqe+nGysUbEu0KqSXzBfwfFsRn+r2qNz30wg+pxGXccOlWVeHH3lFZSUG0uDINJlphRM7DTyhzGMyQ8YrG5jLzYHReLZuz5Rd2cDro0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cxkNRFIy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cxkNRFIy"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 18F521F00893;
	Thu, 10 Sep 2026 06:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789020548;
	bh=EV5K19ueo41sbYsCt94LAb/In1aILOl8I2bF1SsUAHQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cxkNRFIySC2h4ZCxuYL/sXUAcrTvmaaAJ8xgjRYoKtHsnVcyNwiNCEXyEVg7BI3Rt
	 s4xiIc3p/trE6nbZgEh4NNu4Q9MykqHxcaz7GmcTDmB2virQECTQLZiqAtNnaM0rys
	 jWgrtsLvDQuUGwFtM1YoX098f5MW8sV3aFsQdNC1k9FXD+02HHDjrqbphjDvQ5oY7A
	 thXKZEPf+85kzFpmOMK9/YgykwUZGG5pON+y3UgplzovisQfZ+jLXYBDNnm6v+vOMd
	 cTX76DS7NDKwyzzB1DSj0TLBLxms3LTyB9HXSpWGXZoLw1rGjeMF4MMtj2TfC183bH
	 trcbITBpvDHPQ==
Date: Wed, 9 Sep 2026 23:09:07 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, dgc@kernel.org, floss@jetm.me,
	stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: fix under-reservation of blocks when repairing
 sf directories
Message-ID: <20260910060907.GC6253@frogsfrogsfrogs>
References: <178892936573.4057962.16225191041041958394.stgit@frogsfrogsfrogs>
 <178892936640.4057962.1916451282677820756.stgit@frogsfrogsfrogs>
 <20260910050031.GB26687@lst.de>
 <aqJANTuQQMEIqcmO@andromeda.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqJANTuQQMEIqcmO@andromeda.toxiclabs.cc>

On Thu, Sep 10, 2026 at 07:31:37AM +0200, Carlos Maiolino wrote:
> On Thu, Sep 10, 2026 at 07:00:31AM +0200, Christoph Hellwig wrote:
> > On Tue, Sep 08, 2026 at 11:04:35PM -0700, Darrick J. Wong wrote:
> > > +static inline unsigned int
> > > +xrep_tempexch_estimate_sf_resblks(
> > > +	struct xfs_scrub	*sc,
> > > +	int			whichfork)
> > > +{
> > > +	if (whichfork == XFS_ATTR_FORK)
> > > +		return sc->mp->m_attr_geo->fsbcount;
> > > +	if (S_ISDIR(VFS_I(sc->ip)->i_mode))
> > > +		return sc->mp->m_dir_geo->fsbcount;
> > > +	return 1;
> > 
> > geo->fsbcount for attrs is a always 1 and a lot of code relies on that,
> > so this feels a bit overcomplicated and misleading (but still correct).
> > 
> > What about the more usual:
> > 
> > 	if (S_ISDIR(VFS_I(sc->ip)->i_mode) && whichfork == XFS_DATA_FORK)
> > 		return sc->mp->m_dir_geo->fsbcount;
> > 	return 1;

I prefer not to leave a logic bomb in the scrub code in case we ever
have multi-fsblock attr blocks.

Though I guess I'd be ok with

	ASSERT(mp->m_attr_geo->fsbcount == 1);

	if (S_ISDIR(VFS_I(sc->ip)->i_mode) && whichfork == XFS_DATA_FORK)
		return sc->mp->m_dir_geo->fsbcount;
	return 1;

or something like that?

> Either are fine to me so feel free to add:
> 
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

But only if Carlos really wants me to add that.

--D

> 
> > 
> > ?
> > 
> > Otherwise looks good:
> > 
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > 
