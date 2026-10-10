Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5252E1F0E;
	Sat, 10 Oct 2026 15:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791647196; cv=none; b=Uq1yFD6F5LkkHhPqpywGpXsMXQ4AzaUkH5EAkaijpH78VxGPmdK5X02bgRX8WoGb4oAkzzU8QY+uJCFeRSLLJPiPWbeM+bVO6mrzJQesjKuyQighArfHEOqfuiAlrqVf3kYDfbCTqog9U0tN/SUHBmQmAUHf4nb+Pw4BEx1eS94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791647196; c=relaxed/simple;
	bh=TG3AAH3YFMZI7OZCm+18Jwr3hbiwYxQUv37lOV22CAw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kJ359LdxgIVmYV+VAm4u4AN6phLpc/h+YUY4FPLb7h+vnswF275PDj95ZYVrP2B9jNpq1DzmUwpq6Yw1I6KW8ihp5eVib8YjZABE0QlSt9bpbZUiWMbNzfQU62YQPoOJDFzeAINjbA3MDf7mT/TuzptWj6pClJtJ9ljaZgX0yEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KZdK1E+r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KZdK1E+r"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 66BA31F000FF;
	Sat, 10 Oct 2026 15:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791647195;
	bh=JztK/9FUZ5g7r426UOBUWWeneqMyVfNpX7beCQH/4+I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KZdK1E+ruqoHOJSqhyPr5QDDSkzVGa1XFYgmZyeoR3FUPxxFkDluUJXFt3N62zBaw
	 oJJwSygPMJYPX9gTyQz8RqYDd0E2Ea4WQnF09UAmESkp2NNcab9tCtFn9MXZaXn0sA
	 lVfnl9KIUGIkM2DygmGbvJ5kQBcLNPQNM/Rf8yzGBMwp/Fb0ndl/9/nYkZw6YXdxZZ
	 7v2fkO1qdMkVTB+TEb1M8dPmlsGLA/n8B2fpHJbftGEwjYMTMLtZ0vdfXmIIt/CcVC
	 tHOi0XVFpc8/vrXhXKy+2I50jc/OB/piFON+Z6aq01R+mtoQHtLvFZjF++wf0eFyB0
	 qXmHvCgGRo9Aw==
Date: Sat, 10 Oct 2026 08:46:34 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/12] xfs: improve dirent bounds checking in scrub and
 repair
Message-ID: <20261010154634.GW2705364@frogsfrogsfrogs>
References: <179057612523.479634.11102922479483109602.stgit@frogsfrogsfrogs>
 <179057612639.479634.13348969749056583205.stgit@frogsfrogsfrogs>
 <aroLMeT0OiY37AnN@infradead.org>
 <20260929041222.GR2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260929041222.GR2705364@frogsfrogsfrogs>

On Mon, Sep 28, 2026 at 09:12:22PM -0700, Darrick J. Wong wrote:
> On Sun, Sep 27, 2026 at 11:37:37PM -0700, Christoph Hellwig wrote:
> > On Sun, Sep 27, 2026 at 11:16:20PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > LOLLM complains that we don't do enough bounds checking of the directory
> > > entries in directory blocks when we're looking for errors or trying to
> > > salvage entries.  Let's improve that with more detailed checks.
> > > 
> > > Cc: <stable@vger.kernel.org> # v4.16
> > > Fixes: ce92d29ddf9908 ("xfs: directory scrubber must walk through data block to offset")
> > > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > > Assisted-by: LOLLM # finding obvious bugs
> > > ---
> > >  fs/xfs/scrub/dir.c        |   56 +++++++++++++++++++++++++++++++++++++++++----
> > >  fs/xfs/scrub/dir_repair.c |   30 +++++++++++++++++++++++-
> > >  2 files changed, 79 insertions(+), 7 deletions(-)
> > > 
> > > 
> > > diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
> > > index a63eebf39fd496..dd21570378b281 100644
> > > --- a/fs/xfs/scrub/dir.c
> > > +++ b/fs/xfs/scrub/dir.c
> > > @@ -340,6 +340,7 @@ xchk_dir_rec(
> > >  	xfs_dahash_t			hash;
> > >  	struct xfs_dir3_icleaf_hdr	hdr;
> > >  	unsigned int			tag;
> > > +	bool				foundit = false;
> > >  	int				error;
> > >  
> > >  	ASSERT(blk->magic == XFS_DIR2_LEAF1_MAGIC ||
> > > @@ -390,22 +391,60 @@ xchk_dir_rec(
> > >  		xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
> > >  		goto out_relse;
> > >  	}
> > > -	for (;;) {
> > > +	while (iter_off < end) {
> > 
> > Nit: maybe move the iter_off initialization just above this for
> > clarify?
> 
> Ok.
> 
> > >  		struct xfs_dir2_data_entry	*dep = bp->b_addr + iter_off;
> > >  		struct xfs_dir2_data_unused	*dup = bp->b_addr + iter_off;
> > > +		unsigned int			advance;
> > >  
> > > -		if (iter_off >= end) {
> > > +		/* must have freetag */
> > > +		if (iter_off + offsetof(struct xfs_dir2_data_unused, length) >= end) {
> > 
> > Overly long line.
> 
> Will fix these.
> 
> 		/* must have freetag */
> 		advance = offsetof(struct xfs_dir2_data_unused, length);
> 		if (offset + advance >= end)
> 			break;
> 
> > In general it feels like the inner body would benefit from being
> > split into a helper for readability given how big it becomes.
> 
> I really wish C had a way to make it so that you could hoist just the
> *dirent walking code* whilst retaining the custom bits of functionality
> (each error handling, and finding dirents).  I don't know of a good way
> to do that in C that doesn't involve cpp.

I think I misinterpreted the feedback here -- I think hch wanted me to
break up the contents of the loop body, not the loop structure itself.
So, having broken out the "process dirent" and "process unused" logic
into smaller helper functions, the loop body remains compact.  The
bounds checking doesn't seriously complicate the helpers...

> > That would also ease deduplicating the xchk_fblock_set_corrupt calls.
> 
> I prefer to keep those separate because xchk_*_set_corrupt contains a
> tracepoint that captures the callsite, so you can use gdb or other tools
> to go find the exact line in the source code that set the corruption
> flag.

...and I don't have to deal with any of this ^^ rambling.

--D

> Originally I had a fugly macro that wrapped the exact metadata check so
> that we could stringify it and record that directly in the tracepoint
> buffer but enough people complained that I morphed it into what's there
> now.
> 
> --D
> 
