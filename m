Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D25C39CD12
	for <linux-xfs@vger.kernel.org>; Thu, 10 Sep 2026 15:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789053430; cv=none; b=LVExcz1/2XkLFNntxAsskgPiebeHeaW8bAYUWw47DMrqu13JlNFRwC+UJXYj59Rv8G1/82lyJ0FPzRLrHN+yn4ElA/+MnDetFXO+YurosNN377r1oIzV1rTNF7sNs4zpWbCCCeXLHCi3RMo3ETKrPGm5HImKBuaTMgIsZY4Jov8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789053430; c=relaxed/simple;
	bh=IeE3mW96XskzlBP1HSqWjpGoig5E76D4WKQBBrb2i0k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b3CvCyZWXbwUJ+K+V7sUgvOW5xsf9rpAXrSwG6FkN6N+LUJkNDVz61CoMUpwGmc4Ek/NOWLkSP56ryf0qG0rrzRjwC7byajxghKZ/1INMbccI/pJa2athgasggFOYC0qbx/vbsW1ecEtmq8WoLWBU3V3uhJoYz+t2oM0WdzgW6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=REOgBYox; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="REOgBYox"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3031E1F000FF;
	Thu, 10 Sep 2026 15:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789053426;
	bh=TTH91LIPNrm+dcZGyy3XVERCc/qXpuAO0oBpTpeTDqw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=REOgBYoxoHHIFcCxVozj4+n4FFjr08Gya/R7vHpFCtAsxvSUY75CLhIcHi3drH0K4
	 QJUlJN+Axc76YwABLULgmwBi4e2iEBUl+eZf3mYPjyfwvTNeLxkzQfC2aDF97ATSqh
	 XUvSbawktPriJlxZ9V/09wBFx6eMx6TE81fFH4LqmlTbeKmCIUhWgI57AZ8TUU36Rz
	 hYsY6hiD1+J9rSF95xSV2Kugl8HaPGn1IcbH+6sd41HdPua0sJ6zedU8+BgJ2194Dt
	 S5ly5Bs1op6Eqp2tdgvzYLYagZfpO5oFJ0pz7TO3ncaBnw0eoqhBIFJUrag+QHOU8L
	 o4jenoFEdEtYw==
Date: Thu, 10 Sep 2026 08:17:05 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: hch@infradead.org, tytso@mit.edu, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 9/9] mkfs: allow specification of default options via
 configuration file
Message-ID: <20260910151705.GC6238@frogsfrogsfrogs>
References: <178892910484.4047311.5337345469992668181.stgit@frogsfrogsfrogs>
 <178892910697.4047311.7950680370504292957.stgit@frogsfrogsfrogs>
 <aqKS26rODvx78JP6@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqKS26rODvx78JP6@aalbersh-thinkpadx1carbongen13.rmtcz.csb>

On Thu, Sep 10, 2026 at 01:23:09PM +0200, Andrey Albershteyn wrote:
> On 2026-09-08 23:02:35, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Ted asked for the ability to set default mkfs options, but to retain the
> > ability respecify options via a separate configuration file or cli
> > options.  This would be useful for running fstests with the default
> > featureset of (say) Linux 5.15 LTS, while still allowing individual
> > testcases to provide their own overrides.  It's certainly less messy
> > than what Ted does today, which is a bash script that copies the desired
> > config file and changes things.
> > 
> > Cc: tytso@mit.edu
> > Cc: hch@infradead.org
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > ---
> >  man/man8/mkfs.xfs.8.in |   16 ++++-
> >  mkfs/xfs_mkfs.c        |  158 ++++++++++++++++++++++++++++++++++++++++++------
> >  2 files changed, 151 insertions(+), 23 deletions(-)
> > 
> > 
> > diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
> > index fb62d579a26a2d..d915e72330304b 100644
> > --- a/man/man8/mkfs.xfs.8.in
> > +++ b/man/man8/mkfs.xfs.8.in
> > @@ -152,10 +152,22 @@ .SH OPTIONS
> >  .BI \-c " configuration_file_option"
> >  This option specifies the files that mkfs configuration will be obtained from.
> >  The valid
> > -.I configuration_file_option
> > -is:
> > +.I configuration_file_options
> > +are:
> >  .RS 1.2i
> >  .TP
> > +.BI defaults= name
> > +Default configuration options will be sourced from the file specified by the
> > +.I name
> > +option string.
> > +This option can be use either an absolute or relative path to the configuration
> > +file to be read.
> > +Sample configuration files can be found in @mkfs_cfg_dir@.
> 
> Shouldn't this also mention makecfg?

Err, what do you mean?  The patch adding makecfg to mkfs has its own
manpage update:

https://lore.kernel.org/linux-xfs/178892910566.4047311.11716167302378334931.stgit@frogsfrogsfrogs/

diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
index c4dee4fe07ae83..fb62d579a26a2d 100644
--- a/man/man8/mkfs.xfs.8.in
+++ b/man/man8/mkfs.xfs.8.in
@@ -156,6 +156,13 @@ .SH OPTIONS
 is:
 .RS 1.2i
 .TP
+.BI makecfg= path
+Write a configuration file to the file specified by the
+.I path
+option string.
+This file can be re-read by mkfs.xfs for a future filesystem format attempt.
+This file will contain only user-visible features.
+.TP
 .BI options= name
 The configuration options will be sourced from the file specified by the
 .I name

Though perhaps it should mention that if you specify makecfg=foo, it
will create foo in the current directory, not @mkfs_cfg_dir@.  That's
inconsistent with options= and defaults= but I don't think very many
people will want "no path separators at all" to mean "write it to
/usr/lib/xfsprogs/mkfs".

<confused>

> Otherwise, looks good to me
> Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

Thanks!

--D
