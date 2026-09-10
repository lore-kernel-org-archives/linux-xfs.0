Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 426BC4A68AC
	for <linux-xfs@vger.kernel.org>; Thu, 10 Sep 2026 15:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789054663; cv=none; b=P1lTr9Z1z5PrdXCfT9qWTrr2F6OcPxjgYCFyQjKDR3gaG/DuhE+LKl2pJpl9NKddpY/YEZLZjtv7s9Q/xRV3jp63RasgsyuvV577OoMknNVwGlqmuNpLchZ5/wKswOj8OisolHNOCozhqVrpP5OqdULMw+ORdblxfIv7pUsVQqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789054663; c=relaxed/simple;
	bh=gid9xCHUJmrLU+1oOMGANRrgtxARKQdjjl+c1F867W4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nCitjbCeZSkLoScH76M+EdLNK1XqpVmccmGZBZ2y8taQNDNcGPKEuVnN9QnxwM4j0j41W+SoutCPEewL+Hhw1Tz4zDWXdxLXZxDwInfiVbBNajhlLmj10L/i44qbsqBYGZ7zh2NqgH+bLexgqn66Mp7ZqairFhW5/Ptp567oVB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FoN96qri; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FoN96qri"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A81501F000FF;
	Thu, 10 Sep 2026 15:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789054661;
	bh=bdhCt2yXWlly0nM382tvMy8r/GBMQfEMqlyCC3Pktz0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FoN96qriJ5kMpqL//1YVuLJEQ68RAZbYXZaruS+3aLmCyx73zc8l9Wf4qyNYmauwW
	 oSk+XDUOhjlkrCffQCY8E2tD2cFXHunH7Li/86zu+XqQZg0LAA+AGTMwKHvuH4HIiP
	 NnIHeEQlE6hLoU2+d5DyiHoZMMeaqPtsK9ZZoHODc2OslvgEfW9c0jr3h2BcaWJ/qi
	 wYy+Dke0Qhb0uKevPqMP9pZHH5vTIzr4gQBZ5f12HIK49tKwy1OoIefDQ7fyFC1dt2
	 jFDgACE0XiPhc9YYu5k4xJrXOOs8ELp4+BgEqcLnhS2e0FlBTr8J7RzEPC38/IA1Ps
	 /Jfqovp+JdngQ==
Date: Thu, 10 Sep 2026 17:37:38 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@infradead.org, tytso@mit.edu, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 9/9] mkfs: allow specification of default options via
 configuration file
Message-ID: <aqLNT49FybG7qnp2@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <178892910484.4047311.5337345469992668181.stgit@frogsfrogsfrogs>
 <178892910697.4047311.7950680370504292957.stgit@frogsfrogsfrogs>
 <aqKS26rODvx78JP6@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
 <20260910151705.GC6238@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260910151705.GC6238@frogsfrogsfrogs>

On 2026-09-10 08:17:05, Darrick J. Wong wrote:
> On Thu, Sep 10, 2026 at 01:23:09PM +0200, Andrey Albershteyn wrote:
> > On 2026-09-08 23:02:35, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Ted asked for the ability to set default mkfs options, but to retain the
> > > ability respecify options via a separate configuration file or cli
> > > options.  This would be useful for running fstests with the default
> > > featureset of (say) Linux 5.15 LTS, while still allowing individual
> > > testcases to provide their own overrides.  It's certainly less messy
> > > than what Ted does today, which is a bash script that copies the desired
> > > config file and changes things.
> > > 
> > > Cc: tytso@mit.edu
> > > Cc: hch@infradead.org
> > > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > > ---
> > >  man/man8/mkfs.xfs.8.in |   16 ++++-
> > >  mkfs/xfs_mkfs.c        |  158 ++++++++++++++++++++++++++++++++++++++++++------
> > >  2 files changed, 151 insertions(+), 23 deletions(-)
> > > 
> > > 
> > > diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
> > > index fb62d579a26a2d..d915e72330304b 100644
> > > --- a/man/man8/mkfs.xfs.8.in
> > > +++ b/man/man8/mkfs.xfs.8.in
> > > @@ -152,10 +152,22 @@ .SH OPTIONS
> > >  .BI \-c " configuration_file_option"
> > >  This option specifies the files that mkfs configuration will be obtained from.
> > >  The valid
> > > -.I configuration_file_option
> > > -is:
> > > +.I configuration_file_options
> > > +are:
> > >  .RS 1.2i
> > >  .TP
> > > +.BI defaults= name
> > > +Default configuration options will be sourced from the file specified by the
> > > +.I name
> > > +option string.
> > > +This option can be use either an absolute or relative path to the configuration
> > > +file to be read.
> > > +Sample configuration files can be found in @mkfs_cfg_dir@.
> > 
> > Shouldn't this also mention makecfg?
> 
> Err, what do you mean?  The patch adding makecfg to mkfs has its own
> manpage update:

I mean that there're sample configs or you can create one with
makecfg. Just a convenient reference to let users know about
possibility

-- 
- Andrey
