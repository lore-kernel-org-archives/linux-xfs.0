Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1614A689D
	for <linux-xfs@vger.kernel.org>; Thu, 10 Sep 2026 16:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789056417; cv=none; b=hj8qvOp8DCRszrycblKceeGaBXwtYUzHKXiv/eqDHG7ReNaGPTPqwFzvguYYuwxvSt7yU/28mj3ibZVXgINfrUopv4Jrm4aWJIsJpJg2x6IwC5uoACpgcf8tmrNtZ4Kh5XgmXCuZI/Ilr2g03+rcJsnYt1gB1ZAZQCCHSUtpvKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789056417; c=relaxed/simple;
	bh=oiqbnO/Vi7uJKLdRG3R3Dv824OoDwvf9j2gMp51kIzo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V1q9LTYazVTz75RmFDUDqhuH3cGseeFOhOhiT4vM/Q4zM9R8nhA58PoIBJOjTEvJw0/0soKOkjy1TLntpLklL3BlHvkXDZpRelbtsZ1dQxggonJFp0VSP3g0lHlaBCC/Ypfe2dQi5sN2ycuQWnUaTHbpKOgbd8/fDPHjSU486K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UPUd0QaJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UPUd0QaJ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1AEBD1F000FF;
	Thu, 10 Sep 2026 16:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789056416;
	bh=goRLLEV2GrbNz8iqQ6M8Oy57BO/KYCv/4IrIPHpP46w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UPUd0QaJEuJyQgUr9bFf7L3H3na/o+ZlRxy37325xWr9FN2Ju3IVlHpafC2ZWn88T
	 07bC2FAKyc3XqWo1/3ZMHvtwnCyszJ7AKG0dTdGRIM5wco1kCKBeHW5vZqbjmM06wK
	 Pqdfbpt7wDbQZzf8Ja3ehFd2XLXoGfP+HxMGIwWEeFzipqV5gUkV/1jDPmX/pGRRMu
	 rkF+SYZoC9sSNRCkP2YaBFNtjMwVUsxlXJjpkTdg/EkS3+DIrG5IpmDbUfpvE+V8d2
	 LFx1zIPWYTq8Unx5KXyUkduX4kW28EJpMjl1CcRBzrNXJ9FF0DnyrJkXgUnLFeHlnV
	 C15dw9z61ZkxA==
Date: Thu, 10 Sep 2026 09:06:55 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: hch@infradead.org, tytso@mit.edu, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 9/9] mkfs: allow specification of default options via
 configuration file
Message-ID: <20260910160655.GD6238@frogsfrogsfrogs>
References: <178892910484.4047311.5337345469992668181.stgit@frogsfrogsfrogs>
 <178892910697.4047311.7950680370504292957.stgit@frogsfrogsfrogs>
 <aqKS26rODvx78JP6@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
 <20260910151705.GC6238@frogsfrogsfrogs>
 <aqLNT49FybG7qnp2@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aqLNT49FybG7qnp2@aalbersh-thinkpadx1carbongen13.rmtcz.csb>

On Thu, Sep 10, 2026 at 05:37:38PM +0200, Andrey Albershteyn wrote:
> On 2026-09-10 08:17:05, Darrick J. Wong wrote:
> > On Thu, Sep 10, 2026 at 01:23:09PM +0200, Andrey Albershteyn wrote:
> > > On 2026-09-08 23:02:35, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > Ted asked for the ability to set default mkfs options, but to retain the
> > > > ability respecify options via a separate configuration file or cli
> > > > options.  This would be useful for running fstests with the default
> > > > featureset of (say) Linux 5.15 LTS, while still allowing individual
> > > > testcases to provide their own overrides.  It's certainly less messy
> > > > than what Ted does today, which is a bash script that copies the desired
> > > > config file and changes things.
> > > > 
> > > > Cc: tytso@mit.edu
> > > > Cc: hch@infradead.org
> > > > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > > > ---
> > > >  man/man8/mkfs.xfs.8.in |   16 ++++-
> > > >  mkfs/xfs_mkfs.c        |  158 ++++++++++++++++++++++++++++++++++++++++++------
> > > >  2 files changed, 151 insertions(+), 23 deletions(-)
> > > > 
> > > > 
> > > > diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
> > > > index fb62d579a26a2d..d915e72330304b 100644
> > > > --- a/man/man8/mkfs.xfs.8.in
> > > > +++ b/man/man8/mkfs.xfs.8.in
> > > > @@ -152,10 +152,22 @@ .SH OPTIONS
> > > >  .BI \-c " configuration_file_option"
> > > >  This option specifies the files that mkfs configuration will be obtained from.
> > > >  The valid
> > > > -.I configuration_file_option
> > > > -is:
> > > > +.I configuration_file_options
> > > > +are:
> > > >  .RS 1.2i
> > > >  .TP
> > > > +.BI defaults= name
> > > > +Default configuration options will be sourced from the file specified by the
> > > > +.I name
> > > > +option string.
> > > > +This option can be use either an absolute or relative path to the configuration
> > > > +file to be read.
> > > > +Sample configuration files can be found in @mkfs_cfg_dir@.
> > > 
> > > Shouldn't this also mention makecfg?
> > 
> > Err, what do you mean?  The patch adding makecfg to mkfs has its own
> > manpage update:
> 
> I mean that there're sample configs or you can create one with
> makecfg. Just a convenient reference to let users know about
> possibility

Oh.  Yes.  I've rewritten this section to read:

"Default configuration options will be sourced from the file specified
by the name option string. This option can be use either an absolute or
relative path to the configuration file to be read. Options speci‐ fied
through the default configuration file can be overridden by a
configuration file specified via options= or by command line arguments,
in that order.

"Sample configuration files can be found in @mkfs_cfg_dir@. This option
also accepts configuration files generated by the makecfg suboption
below, or by the makecfg subcommand of xfs_db and xfs_spaceman."

How does that sound?

--D

> -- 
> - Andrey
> 
