Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F19B17A2FC
	for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2026 21:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788472151; cv=none; b=au31B02b+PLZ7oQ/zVKFpXJC5wWkiDkLLXbmzSBT7Lh4L1xmtIhDYI4cf3MZl2okjLmPzBOISxX4P7T4MaFJ/UBzMbQbEF7obi6xrKGD8/7pnH+JTc/rjrH9KWH3nbNGonP5l7/xqcFc3LcvpniuIQKYBUevUXzNPFgGwUS+UT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788472151; c=relaxed/simple;
	bh=HiO+Rad5TDb3gkEyESoDGhZkE/Z0JiOp4ssXu3N8EvY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HjzCOUbODit9ooOJsMRaJZ7AIYT2pcWndpd4e4CiuJJ2KyQpz2k9F5H+ZmWkruImlvDDZzNfEOastIs6w9IMtZpo1j0R+FGqUD6z6v/xtp6AiUmSGc/ezQPawFibvhUJevIOuC/icx68TQnxZKtXJZWsFJn/rAVDZ7F7I4nEmKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YJYghB5E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YJYghB5E"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id ECD8D1F000E9;
	Thu,  3 Sep 2026 21:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788472150;
	bh=ShU8BcnUh1ydra72ygGKOA+mA8KEbS41yfhtE5RJ8b4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YJYghB5EjBzR7HhvDqC8kfdbztUmrAyOUnW50epsKLezrFA/ULm0v1QfsoCV4rZpY
	 J5QUDxDJUOSi31kjfVBq0ZGJUgV7+egbjyogTn53cQj8I2L+9WBXQUbc1B35V65X/9
	 6705tu2VT1zEGwS42h0f1D2V4Q7lnsXGdh41vOYddWq3OM7PClxKPzsQiV013BZzu6
	 HCZVtumsfSFvo2Kuwg1OunFvRi1SbC/ht5gaUAQ7x4AsAMmCQHAn3blaE0QUFeWaUP
	 d1yhwOrdOQXYV+221IvPUNXuAgaNoAbh1728sU7x3NP2Hl2FfU8qbEXF02sirdzj2y
	 bTSM/kO9KaBAQ==
Date: Thu, 3 Sep 2026 14:49:09 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] mkfs: print config file for a given mkfs
 configuration
Message-ID: <20260903214909.GW1933798@frogsfrogsfrogs>
References: <178821870568.2381199.9038448943413709082.stgit@frogsfrogsfrogs>
 <178821870627.2381199.2536649416350488195.stgit@frogsfrogsfrogs>
 <aplVuRd-qsqVFW0Q@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aplVuRd-qsqVFW0Q@aalbersh-thinkpadx1carbongen13.rmtcz.csb>

On Thu, Sep 03, 2026 at 01:14:01PM +0200, Andrey Albershteyn wrote:
> On 2026-08-31 16:27:05, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Add a -c makecfg= switch to mkfs to emit a mkfs.xfs configuration file
> > documenting the user-visible filesystem featuresets of the configured
> > filesystem.  This can be used to emit default configuration files as we
> > do once a year for each LTS.
> > 
> > Note that geometry information is not written to the configuration file.
> > 
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > ---
> >  libfrog/fsgeom.h       |    3 
> >  libfrog/fsgeom.c       |  376 ++++++++++++++++++++++++++++++++++++++++++++++++
> >  man/man8/mkfs.xfs.8.in |    6 +
> >  mkfs/xfs_mkfs.c        |   44 +++++-
> >  4 files changed, 428 insertions(+), 1 deletion(-)
> > 
> > ...
> > 
> > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > index 74bbb677eee2b6..212e17a354d8be 100644
> > --- a/mkfs/xfs_mkfs.c
> > +++ b/mkfs/xfs_mkfs.c
> > @@ -61,6 +61,7 @@ enum {
> >  
> >  enum {
> >  	C_OPTFILE = 0,
> > +	C_MAKECFG,
> >  	C_MAX_OPTS,
> >  };
> >  
> > @@ -312,6 +313,7 @@ static struct opt_params copts = {
> >  	.name = 'c',
> >  	.subopts = {
> >  		[C_OPTFILE] = "options",
> > +		[C_MAKECFG] = "makecfg",
> >  		[C_MAX_OPTS] = NULL,
> >  	},
> >  	.subopt_params = {
> > @@ -319,6 +321,10 @@ static struct opt_params copts = {
> >  		  .conflicts = { { NULL, LAST_CONFLICT } },
> >  		  .defaultval = SUBOPT_NEEDS_VAL,
> >  		},
> > +		{ .index = C_MAKECFG,
> > +		  .conflicts = { { NULL, LAST_CONFLICT } },
> > +		  .defaultval = 1,
> > +		},
> >  	},
> >  };
> >  
> > @@ -1072,6 +1078,7 @@ struct cli_params {
> >  
> >  	char	*cfgfile;
> >  	char	*protofile;
> > +	char	*makecfg;
> >  
> >  	enum fsprop_autofsck autofsck;
> >  
> > @@ -1207,7 +1214,7 @@ usage( void )
> >  {
> >  	fprintf(stderr, _("Usage: %s\n\
> >  /* blocksize */		[-b size=num]\n\
> > -/* config file */	[-c options=xxx]\n\
> > +/* config file */	[-c options=xxx,makecfg=0|1]\n\
> 
> Shouldn't this be makecfg=xxx?

I think they all should be "=path" because they take file paths
specifically.  I'll amend this patch to change this to

/* config file */  [-c options=path,makecfg=path]\n\

> Otherwise, looks good to me
> Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

Thanks for reviewing!  A Sashiko review (I can run that internally now)
generated some complaints about xfrog_write_mkfs_config not handling the
quota mkfs options on metadir filesystems, and that there are a couple
of V4 options that it should emit.  I'll resend the series with those
two pieces of new functionality.

--D

> -- 
> - Andrey
> 
