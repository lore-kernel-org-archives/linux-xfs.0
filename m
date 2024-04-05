Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62AED200CB
	for <linux-xfs@vger.kernel.org>; Fri,  5 Apr 2024 17:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712336449; cv=none; b=dsIr+stjwf6SESv3vJeR/36y/EtGGQ3tmdIoFik6wTJQR21HaopCO2cvzdmbodQaTgGfu7yxMv592qZrWVrIr/YBAqzEnDaGxzPYhGBiIsqF4atQZFtQzP+UnsNpcYtk/vVDkrTotAYiYtcHopbdBp0qRvsPv95i60n1bIwP6dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712336449; c=relaxed/simple;
	bh=RTC6AQxraLfmouVsgkeIm6SjU4zd28XmNMJ3IvK9jQ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a3czQ6iW/smXIzyAbDrPXliijRZpo8jxRcIJftnhhMY2q45UG6jk+fIwYpIxOn9aR6xgGM1BrdQvvVejONPmKpf0MgFLM9tBiEznBphVUTEyGyx6RxBHray+7fl9TIHHKTMw1by6NZsj1BoSNF84WOaSOYg1lXl80OPY5BFU7pE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0902068D07; Fri,  5 Apr 2024 19:00:43 +0200 (CEST)
Date: Fri, 5 Apr 2024 19:00:42 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, chandanbabu@kernel.org,
	david@fromorbit.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix error returns from xfs_bmapi_write
Message-ID: <20240405170042.GA15760@lst.de>
References: <20240405051929.191633-1-hch@lst.de> <20240405160742.GB6390@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240405160742.GB6390@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Apr 05, 2024 at 09:07:42AM -0700, Darrick J. Wong wrote:
> > --- a/fs/xfs/xfs_iomap.c
> > +++ b/fs/xfs/xfs_iomap.c
> > @@ -321,14 +321,6 @@ xfs_iomap_write_direct(
> >  	if (error)
> >  		goto out_unlock;
> >  
> > -	/*
> > -	 * Copy any maps to caller's array and return any error.
> > -	 */
> > -	if (nimaps == 0) {
> > -		error = -ENOSPC;
> > -		goto out_unlock;
> > -	}
> 
> Can xfs_bmapi_write return ENOSR here such that it leaks out to
> userspace?

It shouldn't because we invalidated all pages before, although I guess
if we race badly enough with page_mkwrite new a new delalloc region
could have been created and merged with one before the write and then if
the file system was fragmented to death we could hit the case where
we hit ENOSR now (and the wrong ENOSPC before).

That being said handling the error everywhere doesn't really scale.
I've actually looked into not converting the entire delalloc extent
(which btw is behavior that goes back to the initial commit of delalloc
support in XFS), but that quickly ran into asserts in the low-level
xfs_bmap.c.  I plan to get back into it because it feels like the
right thing to do outside of the buffered writeback code, and whatever
lingering problem I found there needs attention.  But for now I'd
rather keep this fix as minimally invasive as it gets.

> > --- a/fs/xfs/xfs_reflink.c
> > +++ b/fs/xfs/xfs_reflink.c
> > @@ -430,13 +430,6 @@ xfs_reflink_fill_cow_hole(
> >  	if (error)
> >  		return error;
> >  
> > -	/*
> > -	 * Allocation succeeded but the requested range was not even partially
> > -	 * satisfied?  Bail out!
> > -	 */
> > -	if (nimaps == 0)
> > -		return -ENOSPC;
> 
> Hmm.  xfs_find_trim_cow_extent returns with @found==false if a delalloc
> reservation appeared in the cow fork while we weren't holding the ILOCK.
> So shouldn't this xfs_bmapi_write call also handle ENOSR?

Probably.  Incremental patch, though.

> > -		/*
> > -		 * Allocation succeeded but the requested range was not even
> > -		 * partially satisfied?  Bail out!
> > -		 */
> > -		if (nimaps == 0)
> > -			return -ENOSPC;
> 
> This xfs_bmapi_write call converts delalloc reservations to unwritten
> mappings, which means that should catch ENOSR and just run around the
> loop again, right?

Probably..

