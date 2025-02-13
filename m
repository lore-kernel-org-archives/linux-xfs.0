Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B967F2753E3
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 23:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739487959; cv=none; b=laiA8huuKJxlkFjO7a+KPQE1rb7xxjyUZX8mssLG5NTE++iqJZYOZq74Rnqmkf125v3+/unxZYLf9o8Tkn/69jaQ3G2vCiLpi2qhIcAtggSqDw7Rx9jQW84/XphJn+Sb7je2SAh8BJXh0hXchp6oIsiMn94KNPSjwx41ad5bHVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739487959; c=relaxed/simple;
	bh=C52jo8U2c33k309bOa2cLCsB+tbLM0e5691sGyubmBk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kmLOh0cwb8G76pUzUqGEc38qAz0EkN5fgx6yBMKdenTOg3gmqgdrGSdha+w7Wg6jrSUyAnKaVEeD4PNJ3TiDA1dRnHFoutIP0NV/wnate4gLrupHh74/tVSG0kKgcsKO3RkUiy7IckES2BP0C80HKVxztBVQsGE18+JghvcCO6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KLTR9ZuP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KLTR9ZuP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27498C4CED1;
	Thu, 13 Feb 2025 23:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739487959;
	bh=C52jo8U2c33k309bOa2cLCsB+tbLM0e5691sGyubmBk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KLTR9ZuP2AXbDGL6/dyONkMT86WUD9gNFC6t10+OPoN5N8agZEXWyxvmqS3XIvJGn
	 dorgoFKGpR6Ii3mIqc2RTMMkJrQiHGXl1rMY3EtnRn6NVgABHyvt6Fz9QZ2ZOJzFaD
	 bcPUBMSrtww4818xtP01VG3rMCbgO1y/kNu3TglY9jLAn/+Sgr7mtWFXYx5W+doTt+
	 rmglWyn1fDWUNMNcMEN0eWI94XhgKbCifkq+R27dWdcAAeO9oCPsc1laoKQt/4+WZH
	 Isyx8ahIz785tsHcmVrCfkz2U0BQ2e+EoIb4ATcPQGzUdpoZszP7O6zD9JOaYoI3mo
	 EcxJHAzqY2kjQ==
Date: Thu, 13 Feb 2025 15:05:58 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 25/43] xfs: implement buffered writes to zoned RT devices
Message-ID: <20250213230558.GX21808@frogsfrogsfrogs>
References: <20250206064511.2323878-1-hch@lst.de>
 <20250206064511.2323878-26-hch@lst.de>
 <20250212005405.GH21808@frogsfrogsfrogs>
 <20250213053943.GA18867@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250213053943.GA18867@lst.de>

On Thu, Feb 13, 2025 at 06:39:43AM +0100, Christoph Hellwig wrote:
> On Tue, Feb 11, 2025 at 04:54:05PM -0800, Darrick J. Wong wrote:
> > Why do we reserve space *before* taking the iolock?  The non-zoned write
> > path reserves space through the transaction while holding the iolock.
> > Regular write attempts will drop the iolock on ENOSPC to push the
> > garbage collectors; why is this any different?
> > 
> > Is it because of the way the garbage collector works backwards from the
> > rmap to figure out what space to move?  And since the gc starts with a
> > zone and only then takes IOLOCKs, so must we?
> 
> Sorta.  GC stats based on a zone/rtgroup and then moves data elewhere.
> It only takes the iolock in the I/O completion path thanks the
> opportunistic write trick that only commit the write if the previous
> location hasn't changed.  If we now have the same inode waiting for
> space with the iolock held we very clearly deadlock there.
> generic/747 was written to test this.
> 
> > > (aka i_rwsem) already held, so a hacky deviation from the above
> > > scheme is needed.  In this case the space reservations is called with
> > > the iolock held, but is required not to block and can dip into the
> > > reserved block pool.  This can lead to -ENOSPC when truncating a
> > > file, which is unfortunate.  But fixing the calling conventions in
> > > the VFS is probably much easier with code requiring it already in
> > > mainline.
> > 
> > It /would/ be a lot more flexible if the rest of the filesystem could
> > provide its own locking like we do for read/write paths.
> 
> I've look into fixing this in the VFS.  Not entirely trivial but I'll
> hopefully get to it in the next few merge windows.  The big problem
> is that currently truncate as a data operation is overlayed onto
> ->setattr which also does tons of other things, so that will have to
> be sorted first.

<nod> That's going to be a long treewide change, I suspect.

> > >  	struct xfs_writepage_ctx wpc = { };
> > > +	int			error;
> > >  
> > > -	xfs_iflags_clear(XFS_I(mapping->host), XFS_ITRUNCATED);
> > > +	xfs_iflags_clear(ip, XFS_ITRUNCATED);
> > > +	if (xfs_is_zoned_inode(ip)) {
> > > +		struct xfs_zoned_writepage_ctx xc = { };
> > 
> > I wonder if we could reduce stack usage here by declaring an onstack
> > union of the two writepage_ctx objects?
> 
> I'll check if the compiler doesn't already do the right thing, but
> if not just using and if / else should do the work in a cleaner way.
> 
> > > +	/*
> > > +	 * For zoned file systems, zeroing the first and last block of a hole
> > > +	 * punch requires allocating a new block to rewrite the remaining data
> > > +	 * and new zeroes out of place.  Get a reservations for those before
> > > +	 * taking the iolock.  Dip into the reserved pool because we are
> > > +	 * expected to be able to punch a hole even on a completely full
> > > +	 * file system.
> > > +	 */
> > > +	if (xfs_is_zoned_inode(ip) &&
> > > +	    (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_ZERO_RANGE |
> > > +		     FALLOC_FL_COLLAPSE_RANGE))) {
> > 
> > Are we expected to be able to zero-range/collapse-range even on a
> > completely full filesystem as well?
> 
> I think there's a few xfstests that do at least.
> 
> > > +	 *  3) another thread does direct I/O on the range that the write fault
> > > +	 *     happened on, which causes writeback of the dirty data.
> > > +	 *  4) this then set the stale flag, which cuts the current iomap
> > > +	 *     iteration short, causing the new call to ->iomap_begin that gets
> > > +	 *     us here again, but now without a sufficient reservation.
> > > +	 *
> > > +	 * This is a very unusual I/O pattern, and nothing but generic/095 is
> > > +	 * known to hit it. There's not really much we can do here, so turn this
> > > +	 * into a short write.
> > 
> > So... buffered write racing with a directio write /and/ a write fault
> > all collide?  Heh.
> 
> Yeah, funky xfstests :)  Note that we might be able to fix this by
> only adding a delalloc reservation at the same time as dirtying the
> folios.  In the current code that would be very nasy, but with the
> infrastructure for the folio based bufferd write locking discussed
> a while i might be more feasible.

Hmm, let me think about that.

> > > +	 * Normally xfs_zoned_space_reserve is supposed to be called outside the
> > > +	 * IOLOCK.  For truncate we can't do that since ->setattr is called with
> > > +	 * it already held by the VFS.  So for now chicken out and try to
> > > +	 * allocate space under it.
> > > +	 *
> > > +	 * To avoid deadlocks this means we can't block waiting for space, which
> > > +	 * can lead to spurious -ENOSPC if there are no directly available
> > > +	 * blocks.  We mitigate this a bit by allowing zeroing to dip into the
> > > +	 * reserved pool, but eventually the VFS calling convention needs to
> > > +	 * change.
> > 
> > I wonder, why isn't this a problem for COWing a shared EOF block when we
> > increase the file size slightly?
> 
> The problem being that we need a space allocation for a write?  Well,
> we'll need a space allocation for every write in an out of tree write
> file system.  But -ENOSPC (or SIGBUS for the lovers of shared mmap
> based I/O :)) on writes is very much expected.  On truncate a lot less
> so.  In fact not dipping into the reserved pool here for example breaks
> rocksdb workloads.

It occurs to me that regular truncate-down on a shared block can also
return ENOSPC if the filesystem is completely out of space.  Though I
guess in that case, at least df will say that nearly zero space is
available, whereas for zoned storage we might have plenty of free space
that simply isn't available right now... right?

--D
