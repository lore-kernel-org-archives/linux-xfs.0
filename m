Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C4C568FCE;
	Wed, 14 Oct 2026 17:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791999638; cv=none; b=gVmx7gjuSLsbJkUJHwUgJ55ylO04VlTbAm7lJIfMeB2MIFvksZYbSn4MPv8J5/7BjBZfS38QUhHQyGMiZRtj14w8Fbv8PCu8EU4KnvPkQvQl3fbI6XywLN4C52Y/q4GMFu+EfvcuCUKr5zHtUronK1eyb65O31w1voielXlchQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791999638; c=relaxed/simple;
	bh=EFN5fhYtFv8eQ1nv3gRF+eJxkrWQ2A0xJ8uZ3ubwk7g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tL8K1fTMRAjBwtTydAjYm0eRGYvfqMSk8H0gg6gevVCD8JhJOyHPHYQkCX++zHWUVAokBbPnC0HmhD+3nZs1i2++GHdNjNTCWiH7VhdQbcJRE73Ey2EEcX3+rbqQ+pOPWywQA680NrQDyTYLPDf5BehGjfmAIl+gO1ZWQp0+FG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YbwK78QB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YbwK78QB"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 439531F000C4;
	Wed, 14 Oct 2026 17:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791999628;
	bh=4hD9uxZy9k0TlRrognYe0f6R0iLeWW7byAQClzTTp5c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YbwK78QBipzkZa+FpwXSV3337+QHsLz2Szfq1BclGYggYtlxWD667RrVxMcEdICj1
	 a2lM52rd/uIW/dn9JLRL0w5StL7WDHKYZYNwql8hY569XC44QOcVc6c/BR0plv6xZM
	 FGNFbE1u37RiJae0mMju9MjDNPnkcdQMXgtc+FJ6PM+NRBAUsrEpsFj+6K9JdyJPy0
	 QzeSr3RTpFCuaCP63j/EvHKbxluNVnG4+N6IQnMrShAJVAamUvNyxTI037zS8twe+F
	 EHQ07+y7ZRrwanUPsL0u8DPr7a5F3ILod4Q1Ds9sWrlD8zg9bQESN8UZlEt/4h6rQb
	 EZ8NVZlSawgUw==
Date: Wed, 14 Oct 2026 10:40:27 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/12] xfs: check for fragments when full-extent sharing
 matches
Message-ID: <20261014174027.GJ2705364@frogsfrogsfrogs>
References: <179186107061.1898400.3978552773417541744.stgit@frogsfrogsfrogs>
 <179186107290.1898400.11595388650663319200.stgit@frogsfrogsfrogs>
 <as84RR9BrH82CPMG@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <as84RR9BrH82CPMG@nidhogg.toxiclabs.cc>

On Wed, Oct 14, 2026 at 10:26:04AM +0200, Carlos Maiolino wrote:
> On Mon, Oct 12, 2026 at 11:07:01PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > LOLLM noticed that xchk_refcountbt_process_rmap_fragments returns early
> > if there are enough rmap records that overlap the space referenced by a
> > refcountbt record to match the refcount in that refcountbt record.
> > Unfortunately, it never checks the fragment list in this case, so it
> > won't find the discrepancy between the rmap and refcount btrees.
> > 
> > Cc: <stable@vger.kernel.org> # v4.16
> > Fixes: dbde19da963706 ("xfs: cross-reference the rmapbt data with the refcountbt")
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > Assisted-by: LOLLM # finding obvious bugs
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Same thing for this patch... Final patch is:
> 
> commit 95e213c1ddb40dfb0a8178ed35c9f29992a320e1
> Author: Darrick J. Wong <djwong@kernel.org>
> Date:   Mon Oct 12 23:07:01 2026 -0700
> 
>     xfs: check for fragments when full-extent sharing matches

Also looks good.

--D

> 
> > ---
> >  fs/xfs/scrub/refcount.c   |    5 ++++-
> >  fs/xfs/scrub/rtrefcount.c |    5 ++++-
> >  2 files changed, 8 insertions(+), 2 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
> > index a900d13c9e27c0..883c273cb9883f 100644
> > --- a/fs/xfs/scrub/refcount.c
> > +++ b/fs/xfs/scrub/refcount.c
> > @@ -185,8 +185,11 @@ xchk_refcountbt_process_rmap_fragments(
> >  	xfs_nlink_t			target_nr;
> >  
> >  	target_nr = refchk->refcount - refchk->seen;
> > -	if (target_nr == 0)
> > +	if (target_nr == 0) {
> > +		if (!list_empty(&refchk->fragments))
> > +			refchk->seen = 0;
> >  		return;
> > +	}
> >  
> >  	/*
> >  	 * There are (refchk->rc.rc_refcount - refchk->nr refcount)
> > diff --git a/fs/xfs/scrub/rtrefcount.c b/fs/xfs/scrub/rtrefcount.c
> > index 00da8e98506d63..c312096e410561 100644
> > --- a/fs/xfs/scrub/rtrefcount.c
> > +++ b/fs/xfs/scrub/rtrefcount.c
> > @@ -200,8 +200,11 @@ xchk_rtrefcountbt_process_rmap_fragments(
> >  	xfs_nlink_t			target_nr;
> >  
> >  	target_nr = refchk->refcount - refchk->seen;
> > -	if (target_nr == 0)
> > +	if (target_nr == 0) {
> > +		if (!list_empty(&refchk->fragments))
> > +			refchk->seen = 0;
> >  		return;
> > +	}
> >  
> >  	/*
> >  	 * There are (refchk->rc.rc_refcount - refchk->nr refcount)
> > 
> 
