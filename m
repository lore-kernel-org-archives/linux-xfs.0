Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B5A1CA84
	for <linux-xfs@vger.kernel.org>; Thu, 10 Apr 2025 06:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744267509; cv=none; b=OZwuBQ7kOJQwZI/W74vbzQxhiNcqB/YgRcpaHeq7xdHEIz+yFXfvOYEqoUYgLt1HmU8pw1DvXV+oa/WVCkDc8RVmSCnavXtlW0YQ7sBb61FUvGccQ/7ZBpim6ltodLuOu1CD+7fkOuvnsv7VgfLTFFJm2PPaX9i2w+4C6pCH7Aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744267509; c=relaxed/simple;
	bh=gIH3arGHT092EaiYTKWP137UT8ytHkE8DDwF5/SY6Gc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UrrLQ8ZQrm6qPVg+OX3S5Uvyt1Ggzv+8NvHAaLCAbabEOTwd7ZKSuFvUpDk5WCHNdlESuGYEjbWxnoMhvwWvaBzt4Ou1KfFqj6P1z4jdbHmlZnqUwohxm+vhvdS0MP4BqcZfUoXwgCAZwkesqweZGNTaPHDSvPr4Xid7783I5Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0C85D68C4E; Thu, 10 Apr 2025 08:45:03 +0200 (CEST)
Date: Thu, 10 Apr 2025 08:45:01 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 30/45] xfs_mkfs: support creating zoned file systems
Message-ID: <20250410064501.GE31075@lst.de>
References: <20250409075557.3535745-1-hch@lst.de> <20250409075557.3535745-31-hch@lst.de> <20250409185449.GF6283@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409185449.GF6283@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Apr 09, 2025 at 11:54:49AM -0700, Darrick J. Wong wrote:
> > +	if (ioctl(fd, BLKRESETZONE, &range) < 0) {
> > +		if (!quiet)
> > +			printf(" FAILED\n");
> 
> Should we print /why/ the zone reset failed?

As in the errno value?  Sure.

> > +static int report_zones(const char *name, struct zone_info *zi)
> > +{
> > +	struct blk_zone_report *rep;
> > +	size_t rep_size;
> > +	struct stat st;
> > +	unsigned int i, n = 0;
> > +	uint64_t device_size;
> > +	uint64_t sector = 0;
> > +	bool found_seq = false;
> > +	int ret = 0;
> > +	int fd;
> 
> Nit: indenting

Fixed.

> > +		goto out_close;
> > +
> > +	if (ioctl(fd, BLKGETSIZE64, &device_size)) {
> > +		ret = -EIO;
> 
> ret = errno; ?  But then...
> 
> > +		goto out_close;
> > +	}
> 
> ...what's the point in returning errors if the caller never checks?

Heh, I'll look into that.

> > +	if (cli->xi->log.name && !cli->xi->log.isfile) {
> > +		report_zones(cli->xi->log.name, &zt->log);
> > +		if (zt->log.nr_zones) {
> > +			fprintf(stderr,
> > +_("Zoned devices not supported as log device!\n"));
> 
> Too bad, we really ought to be able to write logs to a zone device.
> But that's not in scope here.

That is on my todo list, but I need to finish support for the zoned RT
device first.

> 
> > +			usage();
> > +		}
> > +	}
> > +
> > +	if (cli->rtstart) {
> > +		if (cfg->rtstart) {
> 
> Er... why are we checking the variable that we set four lines down?
> Is this supposed to be a check for external zoned rt devices?
> 
> > +			fprintf(stderr,
> > +_("rtstart override not allowed on zoned devices.\n"));
> > +			usage();
> > +		}
> > +		cfg->rtstart = getnum(cli->rtstart, &ropts, R_START) / 512;

For devices with hardware zones rtstart is already set when we get
here and we don't want to allow overriding with the command line
parameter as that won't work.

> > +static void
> > +validate_rtgroup_geometry(
> > +	struct mkfs_params	*cfg)

> Hoisting this out probably should've been a separate patch.

Sure, I'll add a new one for the refactoring.

> <snip>
> 
> > diff --git a/repair/agheader.c b/repair/agheader.c
> > index 5bb4e47e0c5b..048e6c3143b5 100644
> > --- a/repair/agheader.c
> > +++ b/repair/agheader.c
> 
> Should this be in a different patch?

Yes.

