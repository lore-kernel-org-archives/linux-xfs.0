Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D95312E75
	for <linux-xfs@vger.kernel.org>; Thu,  2 May 2024 04:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714623915; cv=none; b=Qo+Tpca9GbZSSRHD5vEVLmLm3t7+BZoURpC1HWVjvxTHUz2amoVKvLtlS4EqmOu/wlPfkW31jomu7iAi+jrBg82wfEL+DAaT1P1uHd7+K/CR7Qw7sFgVGURBGoQKZHXeB+YNib2IljPGFl7ipqRF2GxrGxZHftXHThyNpgzaCJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714623915; c=relaxed/simple;
	bh=irljqPnml+tIs9ZnSst+2TCLajYrlE++EYBCVGeoLyQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FxjigGw7qX7cfdyUY/IoVqO4JhRct98EQk0qwMH8I1M8Qk1deCle1jAkKr+5hTtwRBj1s0J1cbq8bmCaKn7ZU6z53yKb1Bo8L9aRP5Slw5yAVCOX565Vd4ZdNdnuyMUsINVAJwTzeD2MioLTwTj5Sxd0SRO7sKOSCj8ofxe8/U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BA1FE227A87; Thu,  2 May 2024 06:25:09 +0200 (CEST)
Date: Thu, 2 May 2024 06:25:09 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/16] xfs: optimize adding the first 8-byte inode to a
 shortform directory
Message-ID: <20240502042509.GD26601@lst.de>
References: <20240430124926.1775355-1-hch@lst.de> <20240430124926.1775355-15-hch@lst.de> <20240501215056.GD360919@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240501215056.GD360919@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, May 01, 2024 at 02:50:56PM -0700, Darrick J. Wong wrote:
> I noticed a few places where we pass offset == 0 here.  That's ok as a
> null value because the start of a shortform directory is always the
> header, correct?

The start of the "physical" layout has the header, but offset is the
"logic" d_offset offset.  The start of it it reserved for (but not
actually used by) the "." and ".." entries that will occupy the space
when converted out of the short form.  Probably also needs a comment.

> Ok, so this isn't needed anymore because the ino8 conversion now adds
> the new dirent?

Yes.

> > -		xfs_dir2_sf_toino8(args);
> > +		xfs_dir2_sf_toino8(args, 0);
> 
> This is a replace, so we pass 0 here effectively as a null value?

Exactly.

> > @@ -1250,6 +1275,17 @@ xfs_dir2_sf_toino8(
> >  				xfs_dir2_sf_get_ino(mp, oldsfp, oldsfep));
> >  		xfs_dir2_sf_put_ftype(mp, sfep,
> >  				xfs_dir2_sf_get_ftype(mp, oldsfep));
> > +
> > +		/*
> > +		 * If there is a new entry to add it once we reach the specified
> > +		 * offset.
> 
> It took me a minute of staring at the if test logic to figure out what
> we're doing here.  If, after, reformatting a directory entry, the next
> entry is the offset where _pick wants us to place the new dirent, we
> should jump sfep to the next entry, and then add the new entry.
> 
> Is that right?  And we can't simplify the logic to:
> 
> 	if (new_offset && new_offset = xfs_dir2_sf_get_offset(sfep))

== ?

> Because _pick might want us to add the entry at the end of the directory
> but we haven't incremented sfp->count yet, so the loop body will not be
> executed in that case.
> 
> Is it ever the case that the entry get added in the middle of a
> shortform directory?

Yes, that is the hard case.  There is no good reason to add it in
the middle, but we've encoded that the "logical" offset for a
shortform directly needs to fit into the physical size of a single
directory block when converted to block format in asserts and verifiers
and are stuck with it.  Otherwise we could have just always added it
at the end..

