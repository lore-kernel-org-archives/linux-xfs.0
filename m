Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE19A39B95D
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2026 09:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782119286; cv=none; b=eDi3K9FAaojIUVmaAW61j0Q0EfPqsrbYIgbOr7ls9Wq6mHFEU0iizKUHyAVE+kDJMTIdCEhItSxso/6rM/8zM77Xy/9KOJAxaaAlp6R1zIH6Nxz3kH03WmJv4NTL1+Y281onNYP7C3UGZMrbXCbPxjoZjXwdwoAjlFtneMxeYBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782119286; c=relaxed/simple;
	bh=rv5EkNLm4BIn4UtBw2S0zmKDqgPrh9mgLJQWaQQOFtE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h2oA6IscTQU/cCLEStdN71cYao+2dG2aHq1aVBiDoTK3cThRBN0cyIU5gpnLDGl6hJx+Efo3+r9h5eSYXY2X6gIhzgc/GjQ/0ZqiuTEwIjl2kMAD2dQGOJrWvmXKDjzxiZjGlAYbnxB9+RGa+ee+JQXagdGkxd7Urq+gWPm++fY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UBsFVQfk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UBsFVQfk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4896A1F000E9;
	Mon, 22 Jun 2026 09:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782119283;
	bh=D3ejF6EpYuZ4HwoCo9gWlxCVpPvCT+kzaHqJPbUccQ4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UBsFVQfkG7/F0a6g4T/VAx8gSM6D/FyqP+XlmcuYMT1qYrxXMKx9jw7WcMcwWOvkP
	 DLA+2icGGtFXL5wMBkX2gLXWVrsGOH1beBaGpkQWZ2trKma2rvTk2C1ohGmrAl0ZPD
	 AM4l81N4Rdi16iZkSq6sYLlta3DenR9MVOwFb2jUpJcI3JKI0vYYsO0+Nmn6rqrH7A
	 XWvtGI89IAICk/prqpILOJ5s33+cVps7dehC0yfbEkw6oW0RPglEXDYUbttIiVJ+Wh
	 eS5t8TE80ZcFD13iBVyKUT4dTPbGvyX2FkUotxUrV0rEedf7A/Fziaxn1vaIShMRAV
	 x11T4pJjbcLYw==
Date: Mon, 22 Jun 2026 11:07:58 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: Lukas Herbolt <lukas@herbolt.com>, hch@infradead.org, 
	aalbersh@redhat.com, linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>, 
	ailiopoulos@suse.com
Subject: Re: [PATCH 1/1] mkfs.xfs fix sunit size on 512e and 4kN disks.
Message-ID: <ajj5t_viQ7YiTLj5@nidhogg.toxiclabs.cc>
References: <20260219114405.31521-3-lukas@herbolt.com>
 <20260219114405.31521-6-lukas@herbolt.com>
 <ptb5fg2wmlanfsvwawgcye6a2ezevrdnxfq4oxhwoialvgfjld@is3nzrdegqzk>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ptb5fg2wmlanfsvwawgcye6a2ezevrdnxfq4oxhwoialvgfjld@is3nzrdegqzk>

On Mon, Jun 15, 2026 at 03:17:29PM +0200, Jan Kara wrote:
> On Thu 19-02-26 12:44:09, Lukas Herbolt wrote:
> > Creating of XFS on 4kN or 512e disk result in suboptimal LSU/LSUNIT.
> > As of now we check if the sectorsize is bigger than XLOG_HEADER_SIZE
> > and so we set lsu to blocksize. But we do not check the the size if
> > lsunit can be bigger to fit the disk geometry.
> > 
> > Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
> 
> During our performance testing we have noticed that this patch changes the
> size of log stripe unit on a disk behind megaraid_sas controller from 4k to
> 64k (which is understandable as the disk reports 64k minimum_io_size). This
> actually causes a performance regression (about 40%) for dbench with 1
> client as it is very fsync-heavy and thus commits lots of tiny transactions
> and with larger log blocks the logging overhead just seems larger. dbench
> is kind of pathological load but I assume other more relevant fsync
> intensive loads could experience a regression as well.
> 
> I think one of the reasons why 4k log IO actually ends up performing better
> with this disk is that the controller has a battery backed cache (a few GB
> large) and thus it's able to absorb smaller log writes and merge them into
> properly sized IO so larger half-empty log blocks are just pure overhead
> for it.

Sorry the late reply FWIW...

So those seems poorly designed writes which just happened to perform ok
by accident. Properly aligning it to 64k to match its min_io_size is the
right thing to do to avoid lots of RMW cycles for once. But I'm pretty
sure you already know that :)

> 
> This commit sadly doesn't contain any quantification how bad small log IO
> is for 4kN or 512e drives so that one could weight it against the
> regression for higher-end storage.
> Anyway, I'm not sure something needs to
> be done here as there likely isn't a value that works for everyone. I just
> wanted to provide a data point that this isn't a universal win and maybe it
> needs to be considered what's the most sensible default.

Well, I don't think 'fsync heavy' applications are the default, or if
they are, specially on high-end systems, then I'd argue the application
ought to know what it's doing. I do agree that's no universal win
anywhere and yet seem to fix the sunit to the hardware reported size is
the right thing to do here.

Perhaps you could leverage mkfs config files to set different default
configs where you folks believe fits better your usecase?

Cheers.

> 
> 
> > ---
> >  mkfs/xfs_mkfs.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > index b34407725f76..1b6334e9adce 100644
> > --- a/mkfs/xfs_mkfs.c
> > +++ b/mkfs/xfs_mkfs.c
> > @@ -3647,7 +3647,7 @@ check_lsunit:
> >  	else if (cfg->lsectorsize > XLOG_HEADER_SIZE)
> >  		lsu = cfg->blocksize; /* lsunit matches filesystem block size */
> >  
> > -	if (lsu) {
> > +	if (cli->lsu) {
> >  		/* verify if lsu is a multiple block size */
> >  		if (lsu % cfg->blocksize != 0) {
> >  			fprintf(stderr,
> > -- 
> > 2.53.0
> > 
> > >From 2771375662c9edce25d7268bc71cc6db35a0d5c7 Mon Sep 17 00:00:00 2001
> > From: Lukas Herbolt <lukas@herbolt.com>
> > Date: Fri, 26 Sep 2025 12:48:39 +0200
> > Subject: [PATCH 1/1] mkfs.xfs fix sunit size on 512e and 4kN disks.
> > 
> > Creating of XFS on 4kN or 512e disk result in suboptimal LSU/LSUNIT.
> > As of now we check if the sectorsize is bigger than XLOG_HEADER_SIZE
> > and so we set lsu to blocksize. But we do not check the the size if
> > lsunit can be bigger to fit the disk geometry.
> > 
> > Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
> > ---
> >  mkfs/xfs_mkfs.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > index b34407725f76..1b6334e9adce 100644
> > --- a/mkfs/xfs_mkfs.c
> > +++ b/mkfs/xfs_mkfs.c
> > @@ -3647,7 +3647,7 @@ check_lsunit:
> >  	else if (cfg->lsectorsize > XLOG_HEADER_SIZE)
> >  		lsu = cfg->blocksize; /* lsunit matches filesystem block size */
> >  
> > -	if (lsu) {
> > +	if (cli->lsu) {
> >  		/* verify if lsu is a multiple block size */
> >  		if (lsu % cfg->blocksize != 0) {
> >  			fprintf(stderr,
> > -- 
> > 2.53.0
> > 
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
