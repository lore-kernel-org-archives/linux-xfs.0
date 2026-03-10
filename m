Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E94AB2F532C;
	Tue, 10 Mar 2026 14:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773154051; cv=none; b=AQ73KvzHtiN1En7VWBHRqb2bFSmNZFlS+G7iJyjl3+1prnQMGSp8M8IWDHdYIlddfrVmUBsQ5ttiAfN57ub6Eh5qZUpINZOvWgIVCHwQbcSd/b1/CReQ2bYXkRmIflcCoInoHl2vv0t4gU0mfKKMJSOUdp907NaCuh8mRSTGHYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773154051; c=relaxed/simple;
	bh=gvfSm4i/oaTuVOmrOf8+l4BKYsgyv93z3jwH5XnV6xM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LKlbetf3nokOO6UaSII73snSn4/EMezzboywtaT/BgBnJd9NdLXYNzQL5gsOXOse10/3budeT36KVW3+vtAzuuOzyfp5E702+Ad3wW6EVBy8WL+g4oW1bXUbnF++xIoaHrY82/Cd02l6fE+IDG3SWivA2wpQjbY7jLUBhGM9bBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QOIrZ1nI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QOIrZ1nI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89CDDC19423;
	Tue, 10 Mar 2026 14:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773154050;
	bh=gvfSm4i/oaTuVOmrOf8+l4BKYsgyv93z3jwH5XnV6xM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QOIrZ1nIRgAsqBM943rV1/s5MbTA2CR3Trdo3z4vY+QF5V8pi2gf3bTXCQH6YV6tD
	 yPsq/Q/MoHMoqjoq0a6GESv2cxtONIz0AeFfIRGHrbffXb32eIkuxnWur7t9eUvwnh
	 oVOpDR91IjbbbOh0x7izZF6C3kCqVegNVEWZzcATf3KIj53B01w/fi82gPIotqWc5L
	 /WVp8ynzh1NB9IBbAdfJq4un8UQOo1kN6qfl5YJ3gvOyL4smocgocJlzb2dpYyypBp
	 N+uMR6MsX+iv2PKFkxpA1wB5ep+LufzbtgpjOBB4ZO2FoQfH7kk33g0zgE7n3nu0RJ
	 dlppnlwVY6Pow==
Date: Tue, 10 Mar 2026 07:47:29 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 1/8] xfs: fix iomap hole map reporting for zoned zero
 range
Message-ID: <20260310144729.GL1105363@frogsfrogsfrogs>
References: <20260309134506.167663-1-bfoster@redhat.com>
 <20260309134506.167663-2-bfoster@redhat.com>
 <20260309171100.GL6033@frogsfrogsfrogs>
 <aa8PEP9EvKuXYhgO@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa8PEP9EvKuXYhgO@bfoster>

On Mon, Mar 09, 2026 at 02:18:56PM -0400, Brian Foster wrote:
> On Mon, Mar 09, 2026 at 10:11:00AM -0700, Darrick J. Wong wrote:
> > On Mon, Mar 09, 2026 at 09:44:59AM -0400, Brian Foster wrote:
> > > The hole mapping logic for zero range in zoned mode is not quite
> > > correct. It currently reports a hole whenever one exists in the data
> > > fork. If the first write to a sparse range has completed and not yet
> > > written back, the blocks exist in the COW fork as delalloc until
> > > writeback completes, at which point they are allocated and mapped
> > > into the data fork. If a zero range occurs on a range that has not
> > > yet populated the data fork, we will incorrectly report it as a
> > > hole.
> > > 
> > > Note that this currently functions correctly because we are bailed
> > > out by the pagecache flush in iomap_zero_range(). If a hole or
> > > unwritten mapping is reported with dirty pagecache, it assumes there
> > > is pending data, flushes to induce any pending block
> > > allocations/remaps, and retries the lookup. We want to remove this
> > > hack from iomap, however, so update iomap_begin() to only report a
> > > hole for zeroing when one exists in both forks.
> > > 
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > >  fs/xfs/xfs_iomap.c | 18 ++++++++++--------
> > >  1 file changed, 10 insertions(+), 8 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> > > index be86d43044df..8c3469d2c73e 100644
> > > --- a/fs/xfs/xfs_iomap.c
> > > +++ b/fs/xfs/xfs_iomap.c
> > > @@ -1651,14 +1651,6 @@ xfs_zoned_buffered_write_iomap_begin(
> > >  				&smap))
> > >  			smap.br_startoff = end_fsb; /* fake hole until EOF */
> > >  		if (smap.br_startoff > offset_fsb) {
> > > -			/*
> > > -			 * We never need to allocate blocks for zeroing a hole.
> > > -			 */
> > > -			if (flags & IOMAP_ZERO) {
> > > -				xfs_hole_to_iomap(ip, iomap, offset_fsb,
> > > -						smap.br_startoff);
> > > -				goto out_unlock;
> > > -			}
> > >  			end_fsb = min(end_fsb, smap.br_startoff);
> > >  		} else {
> > >  			end_fsb = min(end_fsb,
> > > @@ -1690,6 +1682,16 @@ xfs_zoned_buffered_write_iomap_begin(
> > >  	count_fsb = min3(end_fsb - offset_fsb, XFS_MAX_BMBT_EXTLEN,
> > >  			 XFS_B_TO_FSB(mp, 1024 * PAGE_SIZE));
> > >  
> > > +	/*
> > > +	 * When zeroing, don't allocate blocks for holes as they are already
> > > +	 * zeroes, but we need to ensure that no extents exist in both the data
> > > +	 * and COW fork to ensure this really is a hole.
> > 
> > But where is the cow fork check?  iomap_iter initializes srcmap to
> > IOMAP_HOLE, so if we end up here on an IOMAP_ZERO then we've scanned the
> > data fork and found no mapping.  But then we jump to out_unlock, which
> > means we don't actually look at ip->cowfp.
> > 
> 
> The COW fork is checked a few lines up from where this is added. If it
> finds blocks it exits out, if not it falls into this codepath for
> allocation into the fork (implying a hole).

Ah silly me falling off the end of the (diff) context window
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> 
> Brian
> 
> > <confused>
> > 
> > --D
> > 
> > > +	 */
> > > +	if ((flags & IOMAP_ZERO) && srcmap->type == IOMAP_HOLE) {
> > > +		xfs_hole_to_iomap(ip, iomap, offset_fsb, end_fsb);
> > > +		goto out_unlock;
> > > +	}
> > > +
> > >  	/*
> > >  	 * The block reservation is supposed to cover all blocks that the
> > >  	 * operation could possible write, but there is a nasty corner case
> > > -- 
> > > 2.52.0
> > > 
> > > 
> > 
> 
> 
