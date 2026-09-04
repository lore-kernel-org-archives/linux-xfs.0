Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4613C5DC3;
	Fri,  4 Sep 2026 16:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788538337; cv=none; b=UP66B4KjLVHtV3R3FxeIDx9LavJgJ0bi18Hf45oy/x0iuK0LmcEYNMm0CMmv0M7nEPgiCnaroEqcTGW90iZcioXv5tc6TvS5jtrZDlznpM1Dpk5NEZArYzDXvjhmwkJ9N2DSVyXoo4VvNgllYbk9+Tj9iqKhys32wHzztPw0EXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788538337; c=relaxed/simple;
	bh=wckGhjhDpWxnS3MhTtvjB0ns+lwV68y9HTeuRkh+Jp0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=defxEqhayqdN5r4PuiN9BffoKhGncZiLYH/ZEDDf0wSTz0U5HtH3dvw+sD7qDTd/NmyW/9c7aGxObzn7XHPzP0Z2rO2PNQ70HEnlIbKwVeRH9ygjvsQFF8v6Yav8fy86ZJYRdah6cI31h28mY4EBhW4rZ7GpJqRT58iQBt0trCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JWUucCAM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JWUucCAM"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 76FEF1F00A3D;
	Fri,  4 Sep 2026 16:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788538331;
	bh=DMZeNDQrsJFzoQXXfxfPoFpaoUB4HPIqwgGO7jBQRWI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JWUucCAM71VSZVtT75rRUyxhn7P95tm89Wv6cgCNRMA8rz7MTMA6sl40RWTBqGUhZ
	 Wyb4H9QMPJMFpVwUgI0T7yP45SbDKNgCi2Bx/+0j91ScvG67TbSZyHd5S/hM3bNhi5
	 qsYGQynlgYg8cieTir2BGViKNkWyKInVFoRb7CR5JKm6C5vUrAyCXicvXeOG+nqe2I
	 JxniEAMvPB8auuJTl3NClvZBTy/vMXvaxzlfkJATMjZbuZ7x6Vo7KMOWLIwutNdaCL
	 eDcWTIxZzEGAHZ4jFHOItFkloIDEIgPcUZiUGbcWRZw0+PcVNv7JNvC96dzXOfRmsR
	 GBQVqqUnDe+0w==
Date: Fri, 4 Sep 2026 09:12:11 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: bail out on bitmap errors in xrep_agfl_fill
Message-ID: <20260904161211.GB1933798@frogsfrogsfrogs>
References: <178850312462.1198660.3332635535003842521.stgit@frogsfrogsfrogs>
 <178850312625.1198660.12540549019476735065.stgit@frogsfrogsfrogs>
 <app1di2UlKdSwH8r@andromeda.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <app1di2UlKdSwH8r@andromeda.toxiclabs.cc>

On Fri, Sep 04, 2026 at 09:38:59AM +0200, Carlos Maiolino wrote:
> On Thu, Sep 03, 2026 at 11:27:19PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > LOLLM also points out that the xagb_bitmap_set call in xrep_agfl_fill
> > can fail, but we don't check the result of xagb_bitmap_walk, so we
> > silently drop the error and proceed with inconsistent incore data.
> > That shouldn't be allowed.
> 
> Looks good.
> 
> > 
> > While we're at it, fix leaking the used_extents bitmap if the disunion
> > operation fails.
> 
> Smells this description belongs to the previous patch?

Yeah, that belongs in "xfs: snapshot old AGFL before rewriting it".
I'll move this sentence to there.

--D

> > 
> > Cc: <stable@vger.kernel.org> # v6.6
> > Fixes: 014ad53732d2ba ("xfs: use per-AG bitmaps to reap unused AG metadata blocks during repair")
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > Assisted-by: LOLLM # finding obvious bugs
> > ---
> >  fs/xfs/scrub/agheader_repair.c |    4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > 
> > diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> > index 46c95354ca6438..a66b611588c47f 100644
> > --- a/fs/xfs/scrub/agheader_repair.c
> > +++ b/fs/xfs/scrub/agheader_repair.c
> > @@ -699,7 +699,9 @@ xrep_agfl_init_header(
> >  	 */
> >  	xagb_bitmap_init(&af.used_extents);
> >  	af.agfl_bno = xfs_buf_to_agfl_bno(agfl_bp);
> > -	xagb_bitmap_walk(agfl_extents, xrep_agfl_fill, &af);
> > +	error = xagb_bitmap_walk(agfl_extents, xrep_agfl_fill, &af);
> > +	if (error && error != -ECANCELED)
> > +		goto err_undo;
> >  	error = xagb_bitmap_disunion(agfl_extents, &af.used_extents);
> >  	if (error)
> >  		goto err_undo;
> > 
> > 
> 
