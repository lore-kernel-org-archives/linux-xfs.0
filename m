Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C19E7747F
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 01:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724723797; cv=none; b=WLqQ3DIuFrY/SwZPjqfLRGPqiNWVduA7B/LNe9nz5EywfnBi9ztZ9H4RSp1AIsNxxC7Mqppmg/nztuQEJYTTbe/X5IfdjisNe44oTCGS8HlIYkvmIN4posMsZLZe2k1sBAx4aatrQpiLn8SLWYSLRfJZ9RWzCxFUlx1eSnkR3c0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724723797; c=relaxed/simple;
	bh=KBGS+USkH7YTQMsPHEJvqawu07hD14aQxslz20TjMxY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fXyBm+2RStlJFhd1MyLgcoe9YlaqRiINHI4nNR8grT9eaRIPzgQ4YjHy6azic5R/v0HJBSsSGadTGVfx2DhlGi/+bCRGQ0tDZSzwF44n/WsaauMnyBNRPyM6P4emxzrD+tHvCzE+bsvK+7C4lJTmu9uLvRzlsscEB4FCZzi8rCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=r4XVlzoP; arc=none smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="r4XVlzoP"
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-27045e54272so3276182fac.0
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2024 18:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1724723795; x=1725328595; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=E5Y0aNumcPSsetrspRN/dHj/JjpZpq3pQZFX/8kFq+s=;
        b=r4XVlzoPvqVU3K9AOb0qkn2u2Nw56WVB7oyKoEhTwgwKvfJfFAxl/w7nf1wMOr/waI
         vSrVegVU205bhhSbNMZerwHPL5ezyh0FB/I4PeM3bKVyrO4VSBe7l0QhIXjfPgAXZxBQ
         RW31YvUMtmIW/SBii3DidUziQWOZArRJwDu6qFZTgmO9+4XjoolFUEJ27PHGG+l6BFGT
         wYY6YmOTYvkuTIz25KZ6oqPz/30UPhCzMLZg7R63hTq/6mIUBpnGd2Bm1ZdYTZ45/Vwi
         PkP8JkK9d75SKfHOg3CvtgssT2ra/7d/DlkLRrqRFxc2UxbuL6+RiMr/TNDW9l11YOUP
         e+GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724723795; x=1725328595;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E5Y0aNumcPSsetrspRN/dHj/JjpZpq3pQZFX/8kFq+s=;
        b=B/QyzPorvdzXGmMKr8K7Iz6XuH1Vg8FGAfGWfbezSt4yh/lPJI7/NLU0lhrSflkvNZ
         7VSxDyM1mmP0scKMBnjzYK9vsgFYLWtmoqVAoETJkOAOFqenbHsSATi8LYmES4DO5KDR
         B0mNmkhYcUDaJxT6oNhorPvmeix42ZsAChmbWEFv+JhlEYHQIVT0APkv92RcPjbgA/YK
         i1nolUYDCz/BAZUas2XL2HmxOvaE9Qrvf2Q9FlACD1Z4pWRQf/mgv15f1EGUb75Zi47a
         6b4//1jn2gWREuaNHcZypcpa8d7AxhO/ctUKmZp+41/cSt4iNT0nAXVziLPeHZ5ARYkU
         hvCA==
X-Forwarded-Encrypted: i=1; AJvYcCXH69y1xuU4X27A3UD3A8FbvJ1iUYRfFLnS3Uhi4RsdTyAkGmaB8TJZycm5qqbFlWZjo+KkpyXbmBE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy41WbhGsHRCkOHDxMwkfN+KakJMOTZO1yp/1dIF7C7dlXANRMt
	Y4hvLaD67DTCwa2lIIxv7HD63/yXixHWx3dASiX/4xgavWvvaVsWp1J0Fo7Xxrw=
X-Google-Smtp-Source: AGHT+IF9EDMO9daCR1ajssgUTxmc5WgZrVPRPOKXD1OIcIlr+3neUEuvipGaYWzfXxETbMjeionHVA==
X-Received: by 2002:a05:6870:170f:b0:26f:f1ea:6a71 with SMTP id 586e51a60fabf-273e64673bemr11942225fac.7.1724723794685;
        Mon, 26 Aug 2024 18:56:34 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-714342e2c83sm7616384b3a.133.2024.08.26.18.56.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2024 18:56:34 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1silRf-00E1Xq-1l;
	Tue, 27 Aug 2024 11:56:31 +1000
Date: Tue, 27 Aug 2024 11:56:31 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 21/26] xfs: make the RT allocator rtgroup aware
Message-ID: <Zs0yT0T8fnzQgDI3@dread.disaster.area>
References: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
 <172437088886.60592.11418423460788700576.stgit@frogsfrogsfrogs>
 <ZswLBVOUvwhJZInN@dread.disaster.area>
 <20240826194028.GE865349@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240826194028.GE865349@frogsfrogsfrogs>

On Mon, Aug 26, 2024 at 12:40:28PM -0700, Darrick J. Wong wrote:
> On Mon, Aug 26, 2024 at 02:56:37PM +1000, Dave Chinner wrote:
> > On Thu, Aug 22, 2024 at 05:26:38PM -0700, Darrick J. Wong wrote:
> > > From: Christoph Hellwig <hch@lst.de>
> > > 
> > > Make the allocator rtgroup aware by either picking a specific group if
> > > there is a hint, or loop over all groups otherwise.  A simple rotor is
> > > provided to pick the placement for initial allocations.
> > > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  fs/xfs/libxfs/xfs_bmap.c     |   13 +++++-
> > >  fs/xfs/libxfs/xfs_rtbitmap.c |    6 ++-
> > >  fs/xfs/xfs_mount.h           |    1 
> > >  fs/xfs/xfs_rtalloc.c         |   98 ++++++++++++++++++++++++++++++++++++++----
> > >  4 files changed, 105 insertions(+), 13 deletions(-)
> > > 
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > > index 126a0d253654a..88c62e1158ac7 100644
> > > --- a/fs/xfs/libxfs/xfs_bmap.c
> > > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > > @@ -3151,8 +3151,17 @@ xfs_bmap_adjacent_valid(
> > >  	struct xfs_mount	*mp = ap->ip->i_mount;
> > >  
> > >  	if (XFS_IS_REALTIME_INODE(ap->ip) &&
> > > -	    (ap->datatype & XFS_ALLOC_USERDATA))
> > > -		return x < mp->m_sb.sb_rblocks;
> > > +	    (ap->datatype & XFS_ALLOC_USERDATA)) {
> > > +		if (x >= mp->m_sb.sb_rblocks)
> > > +			return false;
> > > +		if (!xfs_has_rtgroups(mp))
> > > +			return true;
> > > +
> > > +		return xfs_rtb_to_rgno(mp, x) == xfs_rtb_to_rgno(mp, y) &&
> > > +			xfs_rtb_to_rgno(mp, x) < mp->m_sb.sb_rgcount &&
> > > +			xfs_rtb_to_rtx(mp, x) < mp->m_sb.sb_rgextents;
> > 
> > WHy do we need the xfs_has_rtgroups() check here? The new rtg logic will
> > return true for an old school rt device here, right?
> 
> The incore sb_rgextents is zero on !rtg filesystems, so we need the
> xfs_has_rtgroups.

Hmmm. Could we initialise it in memory only for !rtg filesystems,
and make sure we never write it back via a check in the
xfs_sb_to_disk() formatter function?

That would remove one of the problematic in-memory differences
between old skool rtdev setups and the new rtg-based setups...

> > > @@ -1835,9 +1908,16 @@ xfs_bmap_rtalloc(
> > >  	if (xfs_bmap_adjacent(ap))
> > >  		bno_hint = ap->blkno;
> > >  
> > > -	error = xfs_rtallocate(ap->tp, bno_hint, raminlen, ralen, prod,
> > > -			ap->wasdel, initial_user_data, &rtlocked,
> > > -			&ap->blkno, &ap->length);
> > > +	if (xfs_has_rtgroups(ap->ip->i_mount)) {
> > > +		error = xfs_rtallocate_rtgs(ap->tp, bno_hint, raminlen, ralen,
> > > +				prod, ap->wasdel, initial_user_data,
> > > +				&ap->blkno, &ap->length);
> > > +	} else {
> > > +		error = xfs_rtallocate_rtg(ap->tp, 0, bno_hint, raminlen, ralen,
> > > +				prod, ap->wasdel, initial_user_data,
> > > +				&rtlocked, &ap->blkno, &ap->length);
> > > +	}
> > 
> > The xfs_has_rtgroups() check is unnecessary.  The iterator in
> > xfs_rtallocate_rtgs() will do the right thing for the
> > !xfs_has_rtgroups() case - it'll set start_rgno = 0 and break out
> > after a single call to xfs_rtallocate_rtg() with rgno = 0.
> > 
> > Another thing that probably should be done here is push all the
> > constant value calculations a couple of functions down the stack to
> > where they are used. Then we only need to pass two parameters down
> > through the rg iterator here, not 11...
> 
> ..and pass the ap itself too, to remove three of the parameters?

Yeah, I was thinking that the iterator only needs the bno_hint
to determine which group to start iterating. Everything else is
derived from information in the ap structure and so doesn't need to
be calculated above the iterator.

Though we could just lift the xfs_rtalloc_args() up to this level
and stuff all the parameters into that structure and pass it down
instead (like we do with xfs_alloc_args for the btree allocator).
Then we only need to pass args through xfs_rtallocate(),
xfs_rtallocate_extent_near/size() and all the other helper
functions, too.

That's a much bigger sort of cleanup, though, but I think it would
be worth doing a some point because it would bring the rtalloc code
closer to how the btalloc code is structured. And, perhaps, allow us
to potentially share group selection and iteration code between
the bt and rt allocators in future...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
