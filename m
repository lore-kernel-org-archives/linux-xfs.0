Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3B2258CE7
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 01:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782784271; cv=none; b=J5cOeSgN7qXtHRYBFo/3h0gYkqpc3TsNqfgATSZi2DwfCncrKIugjtVTyF1ftwGuefLcrYEZESUpp2Cum1VZmiePcLtL24zd0BmTB9AwqRmbWtZnbGrNBqPYAtCx9bh9vIUkXMRLa+BPhVmmWuA3WZohTjbmDPIM8oXfA/00Xqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782784271; c=relaxed/simple;
	bh=MSE0b9A8iFwMHpwVEnyVEfFS2j+lNulwpgExXk5CpDQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mptcB/6/OODs5tE0vpN54iICaGu/O/38dwiU746c6I5axJmELakcO6GYxjRFJcAlgPBY2oH5XG1qctXg9rth/Vs9filA0fGVj/hvnmtPGF6im0dK/Ox8nWz0X2UdkcLbJqWVigfM330T6GPJJtLFIn/Qp2PN5MPsNfWJBbNpgB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A5bqTnLA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A5bqTnLA"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 292C01F000E9;
	Tue, 30 Jun 2026 01:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782784270;
	bh=pCxP5NvTFlq/IZ3BZzGc4glieCmj9xaMWbTh69EjNjk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=A5bqTnLAkiLq1VqVxPoWLbcc3RGZN7F7znUeAuFdDKsKpLJks7GF9dkl+Rgynb4/E
	 p4kGMS6fVCgZVaETcP3wHtoUAjpi1A0qNW0I7pOZIZOAs/Smg9XMSz/KeHtS7UIRuS
	 wTiuaDau2/cehY/wgkBZLl10kdjMhwa2F4PYPWKYx1s9m1BjHnbAFa6K+9pPD0rARb
	 YBn1mBn24eMFufCGt14KPf1uVBEwqqpwMxWThNS7YJY/nTD389CierJxwx8Xa5qQ1Z
	 yXmR4OLg7UlDVZn5y6Y1+YHbdRenx5toeMMYOIPVi7nKSent2wrUZgu1qLcnk3ipPi
	 TkOu7DlEH+4fw==
Date: Mon, 29 Jun 2026 18:51:09 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: simplify the failure path in
 xfs_buf_alloc_vmalloc
Message-ID: <20260630015109.GJ6078@frogsfrogsfrogs>
References: <20260617055814.3842058-1-hch@lst.de>
 <20260617055814.3842058-5-hch@lst.de>
 <ajkrJHFg4lYeWskS@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajkrJHFg4lYeWskS@nidhogg.toxiclabs.cc>

On Mon, Jun 22, 2026 at 02:34:10PM +0200, Carlos Maiolino wrote:
> On Wed, Jun 17, 2026 at 07:58:05AM +0200, Christoph Hellwig wrote:
> > Look at the __GFP_NORETRY flag set for readahead so that we don't
> > have to pass both the gfp_t and the flags in.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/xfs_buf.c | 7 +++----
> >  1 file changed, 3 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > index eea2a8757fe1..1ed9f01b3275 100644
> > --- a/fs/xfs/xfs_buf.c
> > +++ b/fs/xfs/xfs_buf.c
> > @@ -168,14 +168,13 @@ static int
> >  xfs_buf_alloc_vmalloc(
> >  	struct xfs_buf		*bp,
> >  	size_t			size,
> > -	gfp_t			gfp_mask,
> > -	xfs_buf_flags_t		flags)
> > +	gfp_t			gfp_mask)
> >  {
> >  	for (;;) {
> >  		bp->b_addr = __vmalloc(size, gfp_mask);
> >  		if (bp->b_addr)
> >  			break;
> > -		if (flags & XBF_READ_AHEAD)
> 
> My only concern is that looking at it now, isn't obvious why GRP_NORETRY
> has been set in the first place, perhaps worth adding a comment above
> it? Like:
> 		/* Set during readahead */

I think it's fine as-is, because the state of being in readahead is
something that the caller of xfs_buf_alloc_vmalloc knows, and doesn't
need to share with xfs_buf_alloc_vmalloc itself.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D


> > +		if (gfp_mask & __GFP_NORETRY)
> >  			return -ENOMEM;
> >  		XFS_STATS_INC(bp->b_mount, xb_page_retries);
> >  		memalloc_retry_wait(gfp_mask);
> > @@ -244,7 +243,7 @@ xfs_buf_alloc_backing_mem(
> >  				return 0;
> >  			trace_xfs_buf_backing_fallback(bp, _RET_IP_);
> >  		}
> > -		return xfs_buf_alloc_vmalloc(bp, size, gfp_mask, flags);
> > +		return xfs_buf_alloc_vmalloc(bp, size, gfp_mask);
> >  	}
> 
> Other than the above caveat:
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> 
> >  
> >  	/*
> > -- 
> > 2.53.0
> > 
> > 
> 
