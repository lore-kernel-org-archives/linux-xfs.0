Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C62E86325
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 05:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739425190; cv=none; b=oh8vJtQTfuCZeVCZqiEsw++ToeuP3c1To1xGzRT7fVS1hT7dAw4PwI1WnV09nx1AXDjCR/IYoUL7IkC/gRitkK/Z+o8Pn7uikdwA3fJc2LQhbjnL6qr+Zpp5LRRAnpaeDrumZsAB7Z/rn+6CyK4r1XnUYFfynnWbXgE5+wO6yNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739425190; c=relaxed/simple;
	bh=2y1tMnX7zngvSL29/ZlX2OVD5ZMBr5c/4v554MP9RBw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cneqlrm0nZRCvAQD2CBkMVa/Ax5HXA4ALQh34ZZTA/2nxZn6NH2lHtmRGp0+yVv+VeN7EktFwqooESlbkQGn/viJU8telKJQu5L4C2lu0bjrgONnO3L2j3ws34uQmk7HjX06e3FBzXnvIFIGEpAyk9QdRMdrdJmmCzIG3nlMya4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3F20967373; Thu, 13 Feb 2025 06:39:44 +0100 (CET)
Date: Thu, 13 Feb 2025 06:39:43 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 25/43] xfs: implement buffered writes to zoned RT
 devices
Message-ID: <20250213053943.GA18867@lst.de>
References: <20250206064511.2323878-1-hch@lst.de> <20250206064511.2323878-26-hch@lst.de> <20250212005405.GH21808@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250212005405.GH21808@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Feb 11, 2025 at 04:54:05PM -0800, Darrick J. Wong wrote:
> Why do we reserve space *before* taking the iolock?  The non-zoned write
> path reserves space through the transaction while holding the iolock.
> Regular write attempts will drop the iolock on ENOSPC to push the
> garbage collectors; why is this any different?
> 
> Is it because of the way the garbage collector works backwards from the
> rmap to figure out what space to move?  And since the gc starts with a
> zone and only then takes IOLOCKs, so must we?

Sorta.  GC stats based on a zone/rtgroup and then moves data elewhere.
It only takes the iolock in the I/O completion path thanks the
opportunistic write trick that only commit the write if the previous
location hasn't changed.  If we now have the same inode waiting for
space with the iolock held we very clearly deadlock there.
generic/747 was written to test this.

> > (aka i_rwsem) already held, so a hacky deviation from the above
> > scheme is needed.  In this case the space reservations is called with
> > the iolock held, but is required not to block and can dip into the
> > reserved block pool.  This can lead to -ENOSPC when truncating a
> > file, which is unfortunate.  But fixing the calling conventions in
> > the VFS is probably much easier with code requiring it already in
> > mainline.
> 
> It /would/ be a lot more flexible if the rest of the filesystem could
> provide its own locking like we do for read/write paths.

I've look into fixing this in the VFS.  Not entirely trivial but I'll
hopefully get to it in the next few merge windows.  The big problem
is that currently truncate as a data operation is overlayed onto
->setattr which also does tons of other things, so that will have to
be sorted first.

> >  	struct xfs_writepage_ctx wpc = { };
> > +	int			error;
> >  
> > -	xfs_iflags_clear(XFS_I(mapping->host), XFS_ITRUNCATED);
> > +	xfs_iflags_clear(ip, XFS_ITRUNCATED);
> > +	if (xfs_is_zoned_inode(ip)) {
> > +		struct xfs_zoned_writepage_ctx xc = { };
> 
> I wonder if we could reduce stack usage here by declaring an onstack
> union of the two writepage_ctx objects?

I'll check if the compiler doesn't already do the right thing, but
if not just using and if / else should do the work in a cleaner way.

> > +	/*
> > +	 * For zoned file systems, zeroing the first and last block of a hole
> > +	 * punch requires allocating a new block to rewrite the remaining data
> > +	 * and new zeroes out of place.  Get a reservations for those before
> > +	 * taking the iolock.  Dip into the reserved pool because we are
> > +	 * expected to be able to punch a hole even on a completely full
> > +	 * file system.
> > +	 */
> > +	if (xfs_is_zoned_inode(ip) &&
> > +	    (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_ZERO_RANGE |
> > +		     FALLOC_FL_COLLAPSE_RANGE))) {
> 
> Are we expected to be able to zero-range/collapse-range even on a
> completely full filesystem as well?

I think there's a few xfstests that do at least.

> > +	 *  3) another thread does direct I/O on the range that the write fault
> > +	 *     happened on, which causes writeback of the dirty data.
> > +	 *  4) this then set the stale flag, which cuts the current iomap
> > +	 *     iteration short, causing the new call to ->iomap_begin that gets
> > +	 *     us here again, but now without a sufficient reservation.
> > +	 *
> > +	 * This is a very unusual I/O pattern, and nothing but generic/095 is
> > +	 * known to hit it. There's not really much we can do here, so turn this
> > +	 * into a short write.
> 
> So... buffered write racing with a directio write /and/ a write fault
> all collide?  Heh.

Yeah, funky xfstests :)  Note that we might be able to fix this by
only adding a delalloc reservation at the same time as dirtying the
folios.  In the current code that would be very nasy, but with the
infrastructure for the folio based bufferd write locking discussed
a while i might be more feasible.

> > +	 * Normally xfs_zoned_space_reserve is supposed to be called outside the
> > +	 * IOLOCK.  For truncate we can't do that since ->setattr is called with
> > +	 * it already held by the VFS.  So for now chicken out and try to
> > +	 * allocate space under it.
> > +	 *
> > +	 * To avoid deadlocks this means we can't block waiting for space, which
> > +	 * can lead to spurious -ENOSPC if there are no directly available
> > +	 * blocks.  We mitigate this a bit by allowing zeroing to dip into the
> > +	 * reserved pool, but eventually the VFS calling convention needs to
> > +	 * change.
> 
> I wonder, why isn't this a problem for COWing a shared EOF block when we
> increase the file size slightly?

The problem being that we need a space allocation for a write?  Well,
we'll need a space allocation for every write in an out of tree write
file system.  But -ENOSPC (or SIGBUS for the lovers of shared mmap
based I/O :)) on writes is very much expected.  On truncate a lot less
so.  In fact not dipping into the reserved pool here for example breaks
rocksdb workloads.

