Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F59C13F434
	for <linux-xfs@vger.kernel.org>; Thu, 10 Apr 2025 16:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744303552; cv=none; b=EFCrIeV3Dmd0I26PoB6oJvjOqMnb0QsUyQY0sgb9/lB/oYeD0awmC3Fs1du1stRB01W8D394j0Ez3m+LIwS+XrMp6dN4/wgZTysiuMPvBPMt8/N5VvPX0ZSfS0E0bjVs4k2TE4xZVLStt7zo41xJTVl8p9vxEmWyBeFLT2RPzTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744303552; c=relaxed/simple;
	bh=rR8yYuJN1aNVIkV9KvGush7LH3+3mLAR6MJ6lrGXHQs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ekJak5+kyHLapm2cMnPAKvgsdElHTAm4QUNGNZVERUTE9udX6yPf3uCYVm25OzKIA0Os84IZmodSR/wD/qtNx6w4kxCk7ojrgd/VNfs3e9xWDxAOenpWx5cdSNOWLB17CykMTC378Aeskazv/iVsinF4ceMLIPpquJnF26GebWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KjW09uFL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KjW09uFL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A249C4CEDD;
	Thu, 10 Apr 2025 16:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744303552;
	bh=rR8yYuJN1aNVIkV9KvGush7LH3+3mLAR6MJ6lrGXHQs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KjW09uFLrwsl4RLOy4XTb+aV/mBVEWLYbDKDNsGHwovVrrCddve3ifQbWT38EUVsM
	 4fFoGet+2lKNKaVKniDU+qpkH2D9yQy85OYMdEHL/CrHnyvhR+ew0kqU5C9yT2uRrM
	 uuEia6fgX57m5E4zB3ROaJ+WR6X2NaQ6CRy0bulYmTsJhk2jOG4vPVfJyvCrqbYFpP
	 C3gVY4T5mixY3flzGfCWRNJbg2V+3n4NDGfCIM+pkwDu//z4XOuwOo4YhRv4KxbEH3
	 Leu+geG6KVlHfG5YJ+5aCncH9pgAGodkI+SX0HAB3oL+a8+9vqnYvAV0xhB0/eELnF
	 Ts52dcQ78RV5g==
Date: Thu, 10 Apr 2025 09:45:51 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 30/45] xfs_mkfs: support creating zoned file systems
Message-ID: <20250410164551.GB6283@frogsfrogsfrogs>
References: <20250409075557.3535745-1-hch@lst.de>
 <20250409075557.3535745-31-hch@lst.de>
 <20250409185449.GF6283@frogsfrogsfrogs>
 <20250410064501.GE31075@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250410064501.GE31075@lst.de>

On Thu, Apr 10, 2025 at 08:45:01AM +0200, Christoph Hellwig wrote:
> On Wed, Apr 09, 2025 at 11:54:49AM -0700, Darrick J. Wong wrote:
> > > +	if (ioctl(fd, BLKRESETZONE, &range) < 0) {
> > > +		if (!quiet)
> > > +			printf(" FAILED\n");
> > 
> > Should we print /why/ the zone reset failed?
> 
> As in the errno value?  Sure.

Yes.

> > > +static int report_zones(const char *name, struct zone_info *zi)
> > > +{
> > > +	struct blk_zone_report *rep;
> > > +	size_t rep_size;
> > > +	struct stat st;
> > > +	unsigned int i, n = 0;
> > > +	uint64_t device_size;
> > > +	uint64_t sector = 0;
> > > +	bool found_seq = false;
> > > +	int ret = 0;
> > > +	int fd;
> > 
> > Nit: indenting
> 
> Fixed.
> 
> > > +		goto out_close;
> > > +
> > > +	if (ioctl(fd, BLKGETSIZE64, &device_size)) {
> > > +		ret = -EIO;
> > 
> > ret = errno; ?  But then...
> > 
> > > +		goto out_close;
> > > +	}
> > 
> > ...what's the point in returning errors if the caller never checks?
> 
> Heh, I'll look into that.
> 
> > > +	if (cli->xi->log.name && !cli->xi->log.isfile) {
> > > +		report_zones(cli->xi->log.name, &zt->log);
> > > +		if (zt->log.nr_zones) {
> > > +			fprintf(stderr,
> > > +_("Zoned devices not supported as log device!\n"));
> > 
> > Too bad, we really ought to be able to write logs to a zone device.
> > But that's not in scope here.
> 
> That is on my todo list, but I need to finish support for the zoned RT
> device first.

<nod>

> > 
> > > +			usage();
> > > +		}
> > > +	}
> > > +
> > > +	if (cli->rtstart) {
> > > +		if (cfg->rtstart) {
> > 
> > Er... why are we checking the variable that we set four lines down?
> > Is this supposed to be a check for external zoned rt devices?
> > 
> > > +			fprintf(stderr,
> > > +_("rtstart override not allowed on zoned devices.\n"));
> > > +			usage();
> > > +		}
> > > +		cfg->rtstart = getnum(cli->rtstart, &ropts, R_START) / 512;
> 
> For devices with hardware zones rtstart is already set when we get
> here and we don't want to allow overriding with the command line
> parameter as that won't work.

Oh, ok.  Maybe a comment?

		/*
		 * Device probing might already have set cfg->rtstart
		 * from the zone data.
		 */
		if (cfg->rtstart) {

--D

> > > +static void
> > > +validate_rtgroup_geometry(
> > > +	struct mkfs_params	*cfg)
> 
> > Hoisting this out probably should've been a separate patch.
> 
> Sure, I'll add a new one for the refactoring.
> 
> > <snip>
> > 
> > > diff --git a/repair/agheader.c b/repair/agheader.c
> > > index 5bb4e47e0c5b..048e6c3143b5 100644
> > > --- a/repair/agheader.c
> > > +++ b/repair/agheader.c
> > 
> > Should this be in a different patch?
> 
> Yes.
