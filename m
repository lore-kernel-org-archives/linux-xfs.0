Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058E93ABD96
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 06:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785306913; cv=none; b=RZyp63dBcsBAPyiP9zhIMBLiseq+wv+ijCoDuSFDJTo2fR7mDNswVb3Ddx5VMJ5CLnxSOJYhHd6nPYGBJA2IwiTOhR8DXBccgnvuenZlgM3zAtsvQ486VboFU2d2s7AfAp84ktrg//y2Ij4nY83KPYDH2XrAHU3k6DhknXDshRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785306913; c=relaxed/simple;
	bh=IMyZWadIbq0fozciGhqESzByseyaEiUXdWXCTYreDgo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zty55xH2bItdqUJYXKJOuY93/I9FfqA39oUmG2UmT/gbHSi3Z/QEWnY44ygC0/7I8TqMu9IEil5vNQidX5g8FfGtb+PsaGqOdki33YxJO69bnDbf/ksWhzA9QjYbXv9SdVjZcZcEH4+PMPt2IF04moI5yUbkWFEMFznn7vrUNBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 82A8868AFE; Wed, 29 Jul 2026 08:35:06 +0200 (CEST)
Date: Wed, 29 Jul 2026 08:35:06 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, cem@kernel.org, darrick.wong@oracle.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: check v5 superblock features early
Message-ID: <20260729063506.GB8833@lst.de>
References: <20260728080435.1777362-1-hch@lst.de> <20260728152628.GN2901224@frogsfrogsfrogs> <20260728154207.GA10775@lst.de> <20260728154730.GS2901224@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728154730.GS2901224@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jul 28, 2026 at 08:47:30AM -0700, Darrick J. Wong wrote:
> On Tue, Jul 28, 2026 at 05:42:07PM +0200, Christoph Hellwig wrote:
> > On Tue, Jul 28, 2026 at 08:26:28AM -0700, Darrick J. Wong wrote:
> > > On Tue, Jul 28, 2026 at 10:04:35AM +0200, Christoph Hellwig wrote:
> > > > When working on a new features that reuses the existing pad in the
> > > > superblock, I noticed that mounting such a file system on an old kernel
> > > > logs a rather confusing warning:
> > > > 
> > > >     XFS (vdc): Metadir superblock padding fields must be zero.
> > > > 
> > > > This is because we only validate the various feature fields in v5
> > > > superblocks after the common superblock validation helper is called.
> > > > 
> > > > Fix this by calling the feature validation first.  To make this more
> > > > obvious, rename xfs_validate_sb_read to xfs_validate_sb_features and only
> > > > call it for v5 file systems.
> > > 
> > > Shouldn't it be called xfs_validate_v5_sb_features then?
> > > 
> > > Oh.  There's already a xfs_sb_validate_v5_features function that checks
> > > that the v4 feature bits are set correctly for a v5 filesystem, and it
> > > would be confusing to have both.
> > 
> > Or just stick to the old name :)
> > 
> > > Could we move the code in
> > > xfs_validate_sb_read into xfs_sb_validate_v5_features instead?
> > 
> > But yes, that does look sensible as well.
> > 
> > > If you do that, then xfs_sb_good_version will validate the feature bit
> > > recognition, which it doesn't do now.  I'm not sure what weird side
> > > effects might result from that though.
> > 
> > None in the kernel, but userspace has a lot more callers that need a
> > careful look.
> 
> I /think/ the only visible change to userspace is that the code in
> repair that checks v5 feature flag recognition now becomes defunct
> because libxfs_sb_good_version will catch it first.  But the
> xfs_validate_sb_read code will already log (more or less) the same
> complaint so I don't think it will have any real effect.

Yeah.  OTOH we now also add it to writes.

I think I'll reduce scope for this patch and drop the renaming
and just do the check earlier for a trivial backportable fix.

Then I'll add your above idea to my started work of refactoring the
sb verifier for reuse in xfs_repair for the next merge window or
whenver I get to it.

