Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2118374186;
	Thu,  5 Mar 2026 09:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772701507; cv=none; b=lBOOIdob50oISlSYn4nRrw4pUDb1/WSaFaBq5FTRbwxUImrZ7/AZGVZuNi7Ukg9eaB7WhWP97zO5M26FzJGz0lwdZx51yqmTz1GaQ8dwoqfNVcOWaSZebMzEG9Y7rs+Wy6GMqXDKfRODaf6O4sWq0owmYxAw5Mq0vGiKbrL1WVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772701507; c=relaxed/simple;
	bh=ClNFD7uXVR2zd+ywIi5vyi3YiK5DG+nqhGlbvd8sLrQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T2XVDDdEhqlp4GUtW/g/iIx/Kk7m5Ob5Il4Q5jD/yYo0vD4U419rWkrJxmHueSS/Fr3jE0+dLVnXEYbtyyTCOyQCrzliqhkSeWW5F8HucAuyQNsq7vwy3XAXQbQV8/vS7Ix5iPPPPIo5vnFj1bCqg23LOo+4+kTb/rGoLbfXAKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aZhrWAW4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aZhrWAW4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C1E1C19425;
	Thu,  5 Mar 2026 09:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772701507;
	bh=ClNFD7uXVR2zd+ywIi5vyi3YiK5DG+nqhGlbvd8sLrQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aZhrWAW4DpAGLFX9GfVbibg5zID8EYSkTEIRQ95J/NrcPO5uOxo3Z8SBw9eQ85VjU
	 wHVs8VCUAdAuWXonGjyGYYjNo8xL5sYPNE0iYQ8+5otKl1Lg5S5TrswDTeCJqgT8ZT
	 THc6x80lmY3d/ytSxkPWEzXRXRKCDftAkoAYJ46iJLuFBGm2Aacm3OZkQtZDhHlb7l
	 sG11KKzKxUw3WWMJB3HVQoS1UhIC+LGMnGb1xb4R+a59ax/5l1ntSbdpFRf6YzWgha
	 k0dY688xWWLTrk5hbstEQ2rkhHOg7nJAyeHiuJvLQLqo2vePv76auo4dL4anDWclDp
	 2oBM2e/TVIIsA==
Date: Thu, 5 Mar 2026 10:05:03 +0100
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: don't clobber bi_status in xfs_zone_alloc_and_submit
Message-ID: <aalG6v8qM-FyvrW1@nidhogg.toxiclabs.cc>
References: <20260304185923.291592-1-agruenba@redhat.com>
 <20260304195303.GA57948@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304195303.GA57948@frogsfrogsfrogs>

On Wed, Mar 04, 2026 at 11:53:03AM -0800, Darrick J. Wong wrote:
> On Wed, Mar 04, 2026 at 07:59:20PM +0100, Andreas Gruenbacher wrote:
> > Function xfs_zone_alloc_and_submit() sets bio->bi_status and then it
> > calls bio_io_error() which overwrites that value again.  Fix that by
> > completing the bio separately after setting bio->bi_status.
> > 
> > Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> 
> Yeah, that make sense to me that we shouldn't override the value set in
> out_split_error.
> 
> Cc: <stable@vger.kernel.org> # v6.15
> Fixes: 4e4d5207557770 ("xfs: add the zoned space allocator")
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

I can add that at commit time, no need to send again Andreas.


For the patch itself:
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> --D
> 
> > ---
> >  fs/xfs/xfs_zone_alloc.c | 9 ++++++---
> >  1 file changed, 6 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
> > index e3d19b6dc64a..c3328b9dda37 100644
> > --- a/fs/xfs/xfs_zone_alloc.c
> > +++ b/fs/xfs/xfs_zone_alloc.c
> > @@ -862,7 +862,7 @@ xfs_zone_alloc_and_submit(
> >  	bool			is_seq;
> >  
> >  	if (xfs_is_shutdown(mp))
> > -		goto out_error;
> > +		goto out_io_error;
> >  
> >  	/*
> >  	 * If we don't have a locally cached zone in this write context, see if
> > @@ -875,7 +875,7 @@ xfs_zone_alloc_and_submit(
> >  select_zone:
> >  		*oz = xfs_select_zone(mp, write_hint, pack_tight);
> >  		if (!*oz)
> > -			goto out_error;
> > +			goto out_io_error;
> >  		xfs_set_cached_zone(ip, *oz);
> >  	}
> >  
> > @@ -902,7 +902,10 @@ xfs_zone_alloc_and_submit(
> >  
> >  out_split_error:
> >  	ioend->io_bio.bi_status = errno_to_blk_status(PTR_ERR(split));
> > -out_error:
> > +	bio_endio(&ioend->io_bio);
> > +	return;
> > +
> > +out_io_error:
> >  	bio_io_error(&ioend->io_bio);
> >  }
> >  
> > -- 
> > 2.52.0
> > 
> > 
