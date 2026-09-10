Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95670489FDA
	for <linux-xfs@vger.kernel.org>; Thu, 10 Sep 2026 16:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789058286; cv=none; b=XxjTe5JU0Ib1/3NUNOl1u5l79Y/hjQTrZRRGh9HP8HhlFYqw+V5B2HvugBXpRMRWtWVR+Edg++AYDjgtEQk8O02hjGz3G8Kue29BSe5KWsiPUSRv+b/fmh/mAuQX48BxSH/w/Cu0D3GSDzwe52bMk6Vrs5cn9glTClAhJbxDdKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789058286; c=relaxed/simple;
	bh=NdWErXk1OjcR5UjnHfSYoLmk3kUwvdq1Rr2SLPCBFC0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XBQN1DS5nzUNtmDIyYNiq7Wk9gpMOydqLrm07xzS6gUNR9wndKUVQHoF25osxOW5l28tXKvkYTyYmwKwFALoBjf69GQWptUWeErFMxRy5K89qtGyPfwAn4KyLEHGDJYfrQFr9ufkS7iEM/bT0fkOiQiWWooYYVeuQr+z1oG91hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S6BwrUdW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S6BwrUdW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F0A1F000FF;
	Thu, 10 Sep 2026 16:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789058285;
	bh=+Ahp1+5OJkFcWIe9R6Iim5vEke3LwmYCmeUj58HrHu8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=S6BwrUdW65LdMQ52DfN+GL6UtIa7uwimUIIlClnPjq3sGIRPlYZA/dzfbzLYQyFD0
	 M7VQpP8FHPU3UDP6V1qbHYUzx+6snsxPSw7CZXCPntX8xsyHSqpRwxN4d0S4oawc9f
	 wdAtN9lN7mWyzhwN/i1mDsMltcgZzNO0SU94HILOSNLExbfGq2nNwkH8hZGfHFD+yG
	 yNvt/QKf/Nip+zpmoHVDUQPpytEt10zPx2e8hfZUDW3XAGdr2I+mw+IDeD3HS6nLFZ
	 PRR/SfUYlmaH2rgk0onOIfyF3hVLCI6s51Pp9pC2QaoPnxPy0ZOFeOgU7nibkY2ZuL
	 gYQyw7S9xdPwQ==
Date: Thu, 10 Sep 2026 18:38:01 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@infradead.org, tytso@mit.edu, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 9/9] mkfs: allow specification of default options via
 configuration file
Message-ID: <aqLcwtqejOjhiNxb@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <178892910484.4047311.5337345469992668181.stgit@frogsfrogsfrogs>
 <178892910697.4047311.7950680370504292957.stgit@frogsfrogsfrogs>
 <aqKS26rODvx78JP6@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
 <20260910151705.GC6238@frogsfrogsfrogs>
 <aqLNT49FybG7qnp2@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
 <20260910160655.GD6238@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260910160655.GD6238@frogsfrogsfrogs>

On 2026-09-10 09:06:55, Darrick J. Wong wrote:
> On Thu, Sep 10, 2026 at 05:37:38PM +0200, Andrey Albershteyn wrote:
> > On 2026-09-10 08:17:05, Darrick J. Wong wrote:
> > > On Thu, Sep 10, 2026 at 01:23:09PM +0200, Andrey Albershteyn wrote:
> > > > On 2026-09-08 23:02:35, Darrick J. Wong wrote:
> > > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > > 
> > > > > Ted asked for the ability to set default mkfs options, but to retain the
> > > > > ability respecify options via a separate configuration file or cli
> > > > > options.  This would be useful for running fstests with the default
> > > > > featureset of (say) Linux 5.15 LTS, while still allowing individual
> > > > > testcases to provide their own overrides.  It's certainly less messy
> > > > > than what Ted does today, which is a bash script that copies the desired
> > > > > config file and changes things.
> > > > > 
> > > > > Cc: tytso@mit.edu
> > > > > Cc: hch@infradead.org
> > > > > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > > > > ---
> > > > >  man/man8/mkfs.xfs.8.in |   16 ++++-
> > > > >  mkfs/xfs_mkfs.c        |  158 ++++++++++++++++++++++++++++++++++++++++++------
> > > > >  2 files changed, 151 insertions(+), 23 deletions(-)
> > > > > 
> > > > > 
> > > > > diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
> > > > > index fb62d579a26a2d..d915e72330304b 100644
> > > > > --- a/man/man8/mkfs.xfs.8.in
> > > > > +++ b/man/man8/mkfs.xfs.8.in
> > > > > @@ -152,10 +152,22 @@ .SH OPTIONS
> > > > >  .BI \-c " configuration_file_option"
> > > > >  This option specifies the files that mkfs configuration will be obtained from.
> > > > >  The valid
> > > > > -.I configuration_file_option
> > > > > -is:
> > > > > +.I configuration_file_options
> > > > > +are:
> > > > >  .RS 1.2i
> > > > >  .TP
> > > > > +.BI defaults= name
> > > > > +Default configuration options will be sourced from the file specified by the
> > > > > +.I name
> > > > > +option string.
> > > > > +This option can be use either an absolute or relative path to the configuration
> > > > > +file to be read.
> > > > > +Sample configuration files can be found in @mkfs_cfg_dir@.
> > > > 
> > > > Shouldn't this also mention makecfg?
> > > 
> > > Err, what do you mean?  The patch adding makecfg to mkfs has its own
> > > manpage update:
> > 
> > I mean that there're sample configs or you can create one with
> > makecfg. Just a convenient reference to let users know about
> > possibility
> 
> Oh.  Yes.  I've rewritten this section to read:
> 
> "Default configuration options will be sourced from the file specified
> by the name option string. This option can be use either an absolute or
> relative path to the configuration file to be read. Options speci‐ fied
> through the default configuration file can be overridden by a
> configuration file specified via options= or by command line arguments,
> in that order.
> 
> "Sample configuration files can be found in @mkfs_cfg_dir@. This option
> also accepts configuration files generated by the makecfg suboption
> below, or by the makecfg subcommand of xfs_db and xfs_spaceman."
> 
> How does that sound?

sounds good :)

-- 
- Andrey
