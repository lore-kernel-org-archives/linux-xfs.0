Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1042523372C
	for <linux-xfs@vger.kernel.org>; Sun, 15 Mar 2026 23:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773618591; cv=none; b=LITUXMV3GrCyMVANY7pzEzM93Wy0nPa/ov1ULDkEZMOMM8S30X+isFFJJPTz49lFO/UHOU5oWBjOrutu4RwVs30CJsMIA4Gdu5BclQfLWQ5s7EfPNDkxvjXbjg7jLHO97NNhQe+Q5VyXHbqXc2Wiy8WzsO6Tqa4Sze1a31CLnYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773618591; c=relaxed/simple;
	bh=os6GQYyZDVxvedY1mu0s/QO0QT6Kp4EXjoDywT00HRQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p/AAvQhpSuL9PhlI1eaBQ0amDr3aznO9MrkWY6D0rdz2XwNe7uq7Q2A/QAqdSxWQB1ffyNAYjyAFgCDE6fik+nJFB/wgz82JOnjio6WxV3FzswH/Ir/qqLgVJOlCD7zZCY/ftNHkl1CDr/spTGGVcYVherHpx87sjoAhs7pPpuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ssUd1Fl6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ssUd1Fl6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DEF5C2BC9E;
	Sun, 15 Mar 2026 23:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773618590;
	bh=os6GQYyZDVxvedY1mu0s/QO0QT6Kp4EXjoDywT00HRQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ssUd1Fl61dJu9PbDnSL72O1dBGLAUwQZI3pEe0kTEhR03lv1+aT3m8oEhfoXi2XFP
	 D9TOQeZVDlUkgcBGBW8BKumurDe6Z2fvOZK/AnWbeNMipUcvcTl3jICaPc8im4OF5x
	 plJ6kMoVsALtBB97VeMA0Uwr3c8SIgoaVpEAp+vXNadJhFUcIo3/0M0uIncf/D2L/c
	 mTuGz0hDU82fSwCiV01gKfUjjxGCfoP5zTSyCP7KPE33drcTnbymb4OxgLEBlNCUsN
	 IEWq4pqauZcgBnzGUlHyG7IC95zPzv3gE5aNoJtve0PICFWbfjbouu7ilL3vd9IQMg
	 eREccsS9mlfcg==
Date: Mon, 16 Mar 2026 10:49:44 +1100
From: Dave Chinner <dgc@kernel.org>
To: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
Cc: Lukas Herbolt <lukas@herbolt.com>, linux-xfs@vger.kernel.org,
	cem@kernel.org, hch@infradead.org, djwong@kernel.org,
	p.raghav@samsung.com
Subject: Re: [PATCH v11 2/2] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code base
Message-ID: <abdFmEn7lQKqqbv1@dread>
References: <20260309181235.428151-2-lukas@herbolt.com>
 <abCzhDSVmFx4PtWI@dread>
 <my5vghqmg4npgqpunilj3btbgrvr2s4dbqkm2j6cpw2l3tccrk@p3h3scnzwz6o>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <my5vghqmg4npgqpunilj3btbgrvr2s4dbqkm2j6cpw2l3tccrk@p3h3scnzwz6o>

On Thu, Mar 12, 2026 at 09:36:50PM +0000, Pankaj Raghav (Samsung) wrote:
> > > +
> > > +	len = round_up(offset + len, blksize) - round_down(offset, blksize);
> > > +	offset = round_down(offset, blksize);
> > > +	error = xfs_alloc_file_space(ip, offset, len, XFS_BMAPI_PREALLOC);
> > 
> > xfs_alloc_file_space() already rounds the offset down and the range
> > end upwards to block size boundaries (XFS_B_TO_FSBT() rounds down,
> > XFS_B_TO_FSB rounds up). There is no need to do it here.
> > 
> > > +
> > > +set_filesize:
> > > +	if (error)
> > > +		return error;
> > > +
> > > +	error = xfs_falloc_setsize(file, new_size);
> > > +	if (error)
> > > +		return error;
> > > +	if (need_convert)
> > > +		error = xfs_alloc_file_space(ip, offset, len,
> > > +				XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO);
> > > +	return error;
> > 
> > Honestly, this "prealloc, set file size, then convert and zero" thing
> > seems a bit ... clunky. 
> > 
> > I mean, this is trying to work around an issue with
> > xfs_falloc_setsize() operating on written extents beyond EOF to set
> > EOF. But why are we even using a generic truncate operation to set
> > the EOF when we have already done most of the complex truncate work
> > (exclusion, page cache invalidation, extent removal, etc) already?
> 
> I agree.
> 
> > 
> > My logic:
> > 
> > xfs_bmapi_write(off, len, XFS_BMAPI_ZERO) will allocate all the
> > holes and delalloc extents over the given range as written extents
> > that are initialised to contain zeroes.
> > 
> > xfs_bmapi_write(off, len, XFS_BMAPI_CONVERT) will convert all the
> > unwritten extents over a given range to written extents, but will
> > not touch the data in those extents.
> > 
> > xfs_bmapi_write(off, len, XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO) will
> > allocate holes and delalloc extents and convert unwritten extents
> > all to written extents, and it will write zeros to all of those
> > extents.
> > 
> > This latter case is exactly what we want, and if gives us zeroes on
> > disk to the end of the extent beyond the new EOF. i.e. we've
> > completed all the data IO, and so now all we need
> > to do is update the file size transactionally, just like we do in
> > IO completion.
> > 
> > Indeed, xfs_iomap_write_unwritten() integrates this size update
> > into post-IO unwritten extent conversion. i.e we already have code
> > that does exactly what we need, except for tweaking the
> > xfs_bmapi_write() flags for the zeroing behaviour we need.
> 
> This makes sense.
> 
> > 
> > So, a helper function in fs/xfs/xfs_bmap_util.c such as this:
> > 
> > /*
> >  * This function is used to allocate written extents over holes
> >  * and/or convert unwritten extents to written extents based on the
> >  * @flags passed to it.
> >  *
> >  * If @flags is zero, if will allocate written extents for holes and
> 
> s/zero/XFS_BMAPI_ZERO ?

No, I explicitly meant flags = 0.

> >  * delalloc extents across the range.
> >  *
> >  * If XFS_BMAPI_CONVERT is specified in @flags, then it will also do
> >  * conversion of unwritten extents in the range to written extents.
> >  *
> >  * If XFS_BMAPI_ZERO is specified in @flags, then both newly
> 
> s/XFS_BMAPI_ZERO/(XFS_BMAPI_ZERO | XFS_BMAPI_CONVERT) ?

No I explictly describing what happens when you do "flags |=
XFS_BMAPI_ZERO;" to any other xfs_bmapi_write() operation
flag specification.

i.e. XFS_BMAPI_ZERO is an optional behavioural modifier for
allocation and/or unwritten extent conversion operations. i.e all it
does is add initialisation of the new/modified extents to contain
real zeroes.

e.g. flags = 0 means "allocate holes/delalloc as uninitialised
written extents". flags = 0 | XFS_BMAPI_ZERO
means "allocate holes/delalloc and initialise them to contain
zeros". Unwritten extents will not be modified by either operation.

Cheers,

Dave.
-- 
Dave Chinner
dgc@kernel.org
