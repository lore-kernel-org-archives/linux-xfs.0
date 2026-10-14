Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2700569F3B;
	Wed, 14 Oct 2026 17:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791999615; cv=none; b=nzwsQlwczHk+1nODzdcAcTdOg8C7vmxT8ZgAzaNr7V2tezfYgR9YckgGF7fR7pJr/wdgFhicaFWg3CpP2uLMlrtJRsniEXMzgi4wopzzoq6N+GLcGWOCPk3K6jdvO6tJoafQn24HqYB9QOVbDRhj+j21eA+vENAmxxqixtl+z/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791999615; c=relaxed/simple;
	bh=V1NgZBucpVKmjdcbReDBb0wzYyMz3EML6NvTRCMnGOQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qGxfJ9of9Jx5/4GV/vUibn7lb3LYXkjQZLinuce4KamxZt5FcH93KTtz0czAMmaZGV8riO9wYKIddldQXzhiNn4N/p0RBOTEdjeE1Az5aHIY15Gceif4qopiwLsenU8bQzOp0fRKGR9C9oGkOO+ZjN//0sBqXtw2DVjjSK7KZqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XqK83tFw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XqK83tFw"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 11C221F000C4;
	Wed, 14 Oct 2026 17:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791999604;
	bh=1M9V8qpwDA85gZ0Gd+KoH2lUopyXrJ73ugZU+Dk+X44=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XqK83tFw9hmFrWqfds4xQIUJxHgUrC1KTS0m3cR/nbvUhbAYbXvsKZ9s5+JPrtDJs
	 VcLTy0bwNi6dXesJcA7mlpY79INtbzScdRQB59w39ZJv9jMLPI/FLOYP99PAF+bhW9
	 5nwTyhaentFocFwkeDz0cVQY3zN+Z7PHdetQg1MeuBv41pfoNUHLBhYofSR/Be0XWI
	 X8AFOj2WFoVgbjhyqwP7IqfVj3hQKIBTH1HxgY4DSyUDGk6MM5ELRS79/Br1Op8xFK
	 TanbMFshhzJNnN6kRxyjEB3qbDBGiT/iOnayl3FkqySzgDMwJTNRSg++3LOVXwDv6s
	 kfm+oO7d9oCTA==
Date: Wed, 14 Oct 2026 10:40:03 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/12] xfs: only written file data blocks can be shared
Message-ID: <20261014174003.GI2705364@frogsfrogsfrogs>
References: <179186107061.1898400.3978552773417541744.stgit@frogsfrogsfrogs>
 <179186107268.1898400.2017479521256451856.stgit@frogsfrogsfrogs>
 <as83KAiPFgW0ZCSF@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <as83KAiPFgW0ZCSF@nidhogg.toxiclabs.cc>

On Wed, Oct 14, 2026 at 10:25:53AM +0200, Carlos Maiolino wrote:
> On Mon, Oct 12, 2026 at 11:06:46PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > LOLLM noticed that xchk_refcountbt_rmap_check (and its rt equivalent)
> > will count any rmap owner towards the shared count.  However, the only
> > blocks that can be shared between xfs files are written file data
> > blocks; and the only blocks that can have single-refcount entries are
> > COW staging extents.  Fix the checking code.
> > 
> > Cc: <stable@vger.kernel.org> # v4.16
> > Fixes: dbde19da963706 ("xfs: cross-reference the rmapbt data with the refcountbt")
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > Assisted-by: LOLLM # finding obvious bugs
> 
> This patch conflicts with Eric's:
> 
> 1d55a102780 xfs: re-use refcount scrub/repair code for rtrefcount
> 
> I'm just stripping off the rtrefcountbt part of this, the final result
> is here:
> 
> commit 634b63baf05062988456a0bd5df2696c14ea2949
> Author: Darrick J. Wong <djwong@kernel.org>
> Date:   Mon Oct 12 23:06:46 2026 -0700
> 
>     xfs: only written file data blocks can be shared

Yep, that looks good to me!

--D

> 
> 
> > ---
> >  fs/xfs/scrub/refcount.c   |   12 ++++++++++++
> >  fs/xfs/scrub/rtrefcount.c |   12 ++++++++++++
> >  2 files changed, 24 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
> > index f8c51d8fbb3da5..a900d13c9e27c0 100644
> > --- a/fs/xfs/scrub/refcount.c
> > +++ b/fs/xfs/scrub/refcount.c
> > @@ -129,6 +129,18 @@ xchk_refcountbt_rmap_check(
> >  		return 0;
> >  	}
> >  
> > +	/*
> > +	 * The refcount btree should only have records for written file data
> > +	 * blocks or for COW staging blocks.
> > +	 */
> > +	if ((XFS_RMAP_NON_INODE_OWNER(rec->rm_owner) &&
> > +	     rec->rm_owner != XFS_RMAP_OWN_COW) ||
> > +	    (rec->rm_flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK |
> > +			      XFS_RMAP_UNWRITTEN))) {
> > +		xchk_btree_xref_set_corrupt(refchk->sc, cur, 0);
> > +		return 0;
> > +	}
> > +
> >  	if (rec->rm_startblock <= refchk->bno && rm_last >= rc_last) {
> >  		/*
> >  		 * The rmap overlaps the refcount record, so we can confirm
> > diff --git a/fs/xfs/scrub/rtrefcount.c b/fs/xfs/scrub/rtrefcount.c
> > index 3d916d71a135dc..00da8e98506d63 100644
> > --- a/fs/xfs/scrub/rtrefcount.c
> > +++ b/fs/xfs/scrub/rtrefcount.c
> > @@ -144,6 +144,18 @@ xchk_rtrefcountbt_rmap_check(
> >  		return 0;
> >  	}
> >  
> > +	/*
> > +	 * The refcount btree should only have records for written file data
> > +	 * blocks or for COW staging blocks.
> > +	 */
> > +	if ((XFS_RMAP_NON_INODE_OWNER(rec->rm_owner) &&
> > +	     rec->rm_owner != XFS_RMAP_OWN_COW) ||
> > +	    (rec->rm_flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK |
> > +			      XFS_RMAP_UNWRITTEN))) {
> > +		xchk_btree_xref_set_corrupt(refchk->sc, cur, 0);
> > +		return 0;
> > +	}
> > +
> >  	if (rec->rm_startblock <= refchk->bno && rm_last >= rc_last) {
> >  		/*
> >  		 * The rmap overlaps the refcount record, so we can confirm
> > 
> > 
> 
