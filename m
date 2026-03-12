Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA63ADDCD
	for <linux-xfs@vger.kernel.org>; Thu, 12 Mar 2026 21:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773351421; cv=none; b=IqoP2/o6IEZL0jDYtZdC1ots4GW3L2Dpfzr2LfqG8fQY9rIRaThoym2kTzXSHOA0DbTxs+4KqSuUfcusuFmt40EUQ4dYG4Vp5qSDqQ7+f0dPcfa6paXO7ZW3d6tRvnRJ8KZQ0JZC3a8G2jcKwmwDxDkttusOpevJPfZsmpaGVsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773351421; c=relaxed/simple;
	bh=QVKUkrMFDrdcuRT/oiZM4Vf4aDv36ch0f0DQ40ieq3A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RcKWcirtx+qQXvxuuZllnbIa77ZrV/fCZFIb2McvstlkQI9zH9JejTVdtEkE/prfj1CT1f5vZKltKP6kZLvncCtD2G/IsuoWzCam4crNx8P8cUYVXHQNiLiYNJmFZES5K4VVWB2M0JOto1/UeQxTpR7mqHcaVARbFKwBE0LuyBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Z092evqH; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Z092evqH"
Date: Thu, 12 Mar 2026 21:36:50 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773351418;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UVnBgv0am1ycQfOqi2Ljv9rrGPieG8tLArTMrAoP+VQ=;
	b=Z092evqHyTwY6QqfiF9GICIRw3K9eKvEB3Pmfm7+O5+P2x+AvIL6+5YKrxw2UMGgdamXsY
	IS8ma9YpaDjPlzOsggmduesfuWioppVKzZs7TkSOANBYnn02BTxFoFlJ3jeFYmeHX+sqmj
	UlabCEGTyfMS+qllPLd2aMJVxTQ7tjA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: Dave Chinner <dgc@kernel.org>
Cc: Lukas Herbolt <lukas@herbolt.com>, linux-xfs@vger.kernel.org, 
	cem@kernel.org, hch@infradead.org, djwong@kernel.org, p.raghav@samsung.com
Subject: Re: [PATCH v11 2/2] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code base
Message-ID: <my5vghqmg4npgqpunilj3btbgrvr2s4dbqkm2j6cpw2l3tccrk@p3h3scnzwz6o>
References: <20260309181235.428151-2-lukas@herbolt.com>
 <abCzhDSVmFx4PtWI@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abCzhDSVmFx4PtWI@dread>
X-Migadu-Flow: FLOW_OUT

> > +
> > +	len = round_up(offset + len, blksize) - round_down(offset, blksize);
> > +	offset = round_down(offset, blksize);
> > +	error = xfs_alloc_file_space(ip, offset, len, XFS_BMAPI_PREALLOC);
> 
> xfs_alloc_file_space() already rounds the offset down and the range
> end upwards to block size boundaries (XFS_B_TO_FSBT() rounds down,
> XFS_B_TO_FSB rounds up). There is no need to do it here.
> 
> > +
> > +set_filesize:
> > +	if (error)
> > +		return error;
> > +
> > +	error = xfs_falloc_setsize(file, new_size);
> > +	if (error)
> > +		return error;
> > +	if (need_convert)
> > +		error = xfs_alloc_file_space(ip, offset, len,
> > +				XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO);
> > +	return error;
> 
> Honestly, this "prealloc, set file size, then convert and zero" thing
> seems a bit ... clunky. 
> 
> I mean, this is trying to work around an issue with
> xfs_falloc_setsize() operating on written extents beyond EOF to set
> EOF. But why are we even using a generic truncate operation to set
> the EOF when we have already done most of the complex truncate work
> (exclusion, page cache invalidation, extent removal, etc) already?

I agree.

> 
> My logic:
> 
> xfs_bmapi_write(off, len, XFS_BMAPI_ZERO) will allocate all the
> holes and delalloc extents over the given range as written extents
> that are initialised to contain zeroes.
> 
> xfs_bmapi_write(off, len, XFS_BMAPI_CONVERT) will convert all the
> unwritten extents over a given range to written extents, but will
> not touch the data in those extents.
> 
> xfs_bmapi_write(off, len, XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO) will
> allocate holes and delalloc extents and convert unwritten extents
> all to written extents, and it will write zeros to all of those
> extents.
> 
> This latter case is exactly what we want, and if gives us zeroes on
> disk to the end of the extent beyond the new EOF. i.e. we've
> completed all the data IO, and so now all we need
> to do is update the file size transactionally, just like we do in
> IO completion.
> 
> Indeed, xfs_iomap_write_unwritten() integrates this size update
> into post-IO unwritten extent conversion. i.e we already have code
> that does exactly what we need, except for tweaking the
> xfs_bmapi_write() flags for the zeroing behaviour we need.

This makes sense.

> 
> So, a helper function in fs/xfs/xfs_bmap_util.c such as this:
> 
> /*
>  * This function is used to allocate written extents over holes
>  * and/or convert unwritten extents to written extents based on the
>  * @flags passed to it.
>  *
>  * If @flags is zero, if will allocate written extents for holes and

s/zero/XFS_BMAPI_ZERO ?

>  * delalloc extents across the range.
>  *
>  * If XFS_BMAPI_CONVERT is specified in @flags, then it will also do
>  * conversion of unwritten extents in the range to written extents.
>  *
>  * If XFS_BMAPI_ZERO is specified in @flags, then both newly

s/XFS_BMAPI_ZERO/(XFS_BMAPI_ZERO | XFS_BMAPI_CONVERT) ?

>  * allocated extents and converted unwritten extents will be
>  * initialised to contain zeroes.
>  *
>  * If @update_isize is true, then if the range we are operating on
>  * extends beyond the current EOF, extend i_size to offset+len
>  * incrementally as extents in the range are allocated/converted.
>  */
> int
> xfs_bmap_alloc_or_convert_range(
> 	struct xfs_inode	*ip,
> 	xfs_off_t		offset,
> 	xfs_off_t		len,
> 	uint32_t		flags,
> 	bool			update_isize)
> {
> 	< guts of xfs_iomap_write_unwritten >
> }
> 
> Then xfs_iomap_write_unwritten() can be factored to a one-liner
> (or replaced altogether), and this new fallocate op pretty much
> becomes:
> 
> 	error = xfs_bmap_alloc_or_convert_range(ip, offset, len,
> 			XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO,
> 			new_size ? true : false);
> 
> The name of the function sucks but I can't think of anything better,
> so if you've got a better idea then change it. :)

Thanks for the explanation Dave! I can take a shot at your suggestion
unless @Lukas already started working on it?

-- 
Pankaj
