Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43262C1AC
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jul 2024 02:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720491624; cv=none; b=Zbv0S07WZmvys8e33OhtHN8JyBzmah/7yqgLmnBZgehoO6Ip2XaE+wgVyHfO8JBpzov6hyfZD1ioNqZKo7pSuMd22/eml36aHE45PK11cHpO21y2cv1pxoH7fvtHOkUJE/EX/hEQgnhQaGvsfNEGzzGgmNdDkR0J2k1JqMMVH9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720491624; c=relaxed/simple;
	bh=f2pdLyELTL35+Ove7X5eP5MlfRXklHDVF/UZs69aGsQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OwIqB3AJztxpMni1CtlTI847/EVDkhpt9jyFybh5e6ExqyfUOPWcx+ps2xXZKzZbXm9q9y9NYAueHS51hdS4FR8mV9PdoHfkRgR1wyZNsXjGKv7zTSMD/rYMKy8l6BED3DJjdVDyfRS1njF0n92ULLQLPINpBt/mDLyAZ4elKHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=iVXZ9JP+; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="iVXZ9JP+"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1fb8781ef1bso9921835ad.3
        for <linux-xfs@vger.kernel.org>; Mon, 08 Jul 2024 19:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1720491621; x=1721096421; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ikjONYoSS1yg23CY1fI6Hhf6u4kBa19xSHAeqB4lLNY=;
        b=iVXZ9JP+pj8u3Pq5PA5Qxe6Sq1Ij5mRxwb6iGwDXJyN+sIdP6UjbsaGcUQpas8VNgT
         8H1wvuzdIBtHg+cvYOnh+moAljZ+Jd1uvsmT/qyPbdhllz7oRHTXSZMZjPspgOV8dyGO
         XjKvkdMLtkiRycGBGbuGBuxpd4nKNtUpesc2VrMER0iANpM0uF7/UvgKJ1fUPaz9io1x
         IDpX4avA6hPbVvz/3v9A7BAn2ntNxMYfL2CfDru8yIO0blVjFQcgXc0ta+9H8FxK/S4U
         7ulDIMVX5B0KTqBrZTiaQwue1EgYsPTiVm/eSD9mruzZ8GSz1PyN7gMkyRIVrOVuWPpy
         9tJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720491621; x=1721096421;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ikjONYoSS1yg23CY1fI6Hhf6u4kBa19xSHAeqB4lLNY=;
        b=NNhPHDt8YvBF+H7s45+KEFlJOMAdIGBxeObY8f5aXAkin+3LPW3iJWW3FJ4h6TEqPH
         Lc9Q37XGYgJmN+HrJzAb0PwhpjFUys2Y/YC/qd30O+/kQ+06wNeIcDUgTg/zpPTCU/tk
         QSANI8heoQc5O02yuPhNaKaaZ4Nmwt+pvGpe4R4DUZ8eWthZTA0q7mPDp3N3Aoi3rRhp
         JY4w8ytG+PA3QdJbCnaZ8kwp133rk8P8PyvtHRcP2BNyvMMpCeDr5U2OqBeld6slsRie
         QHyYuogUx7rVYxgOQoeNRoTU4A+EtOIS+nkYhfMSlEaeoXEliXcXDay46Lr9N+w4e+dv
         LPNQ==
X-Forwarded-Encrypted: i=1; AJvYcCUB/9C1caNyfNhcjfa4WjRZXPseReovmdyJckuUvpbt8AEYHk0IwY7NQm8jNc2/Ad5l2hvRYOnRMx8f9tP7TRRHYy8L9TJux7Lr
X-Gm-Message-State: AOJu0YxtVzWErHI/mzhoX1q3e85qkvYpG3+1wESBJAnMZo5PFQvIYCyL
	JxP5qJLyWbI9UHGqrEIyDwU/2E0FPMHYSTS/13Y39nzzm7sF4W9+4ejOz+w5Fic=
X-Google-Smtp-Source: AGHT+IGEv+EcUd9sFzBD0rjXoW08uVABlSEEbc01Tj8I9om4oauAXFWdGcnMDh5zI02mlnh5dc2Ibw==
X-Received: by 2002:a17:902:db0e:b0:1fb:59e6:b0e5 with SMTP id d9443c01a7336-1fbb6d03dfbmr13025525ad.19.1720491620303;
        Mon, 08 Jul 2024 19:20:20 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fbb6ab6ed6sm5134605ad.145.2024.07.08.19.20.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jul 2024 19:20:19 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sR0Sm-009C4S-2i;
	Tue, 09 Jul 2024 12:20:16 +1000
Date: Tue, 9 Jul 2024 12:20:16 +1000
From: Dave Chinner <david@fromorbit.com>
To: Krister Johansen <kjlx@templeofstupid.com>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, Gao Xiang <xiang@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 1/4] xfs: resurrect the AGFL reservation
Message-ID: <ZoyeYBW7CvWJdWsu@dread.disaster.area>
References: <cover.1718232004.git.kjlx@templeofstupid.com>
 <0dfbe8d00d2be53999b20e336641ba3d60306ffa.1718232004.git.kjlx@templeofstupid.com>
 <ZmuyFCG/jQrrRb6N@dread.disaster.area>
 <20240617234631.GC2044@templeofstupid.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240617234631.GC2044@templeofstupid.com>

[ Sorry for the long delay - PTO and then catchup time so I'm only
just getting back to this now. This is long, and I disappeared down
a rabbit hole in getting to the bottom of some of the code before I
even read the summary you wrote. I think I came up with solution
to your #4 proposal in the process... ]

On Mon, Jun 17, 2024 at 04:46:31PM -0700, Krister Johansen wrote:
> On Fri, Jun 14, 2024 at 12:59:32PM +1000, Dave Chinner wrote:
> > On Thu, Jun 13, 2024 at 01:27:26PM -0700, Krister Johansen wrote:
> > > Transactions that perform multiple allocations may inadvertently run out
> > > of space after the first allocation selects an AG that appears to have
> > > enough available space.  The problem occurs when the allocation in the
> > > transaction splits freespace b-trees but the second allocation does not
> > > have enough available space to refill the AGFL.  This results in an
> > > aborted transaction and a filesystem shutdown.  In this author's case,
> > > it's frequently encountered in the xfs_bmap_extents_to_btree path on a
> > > write to an AG that's almost reached its limits.
> > > 
> > > The AGFL reservation allows us to save some blocks to refill the AGFL to
> > > its minimum level in an Nth allocation, and to prevent allocations from
> > > proceeding when there's not enough reserved space to accommodate the
> > > refill.
> > > 
> > > This patch just brings back the reservation and does the plumbing.  The
> > > policy decisions about which allocations to allow will be in a
> > > subsequent patch.
> > > 
> > > This implementation includes space for the bnobt and cnobt in the
> > > reserve.  This was done largely because the AGFL reserve stubs appeared
> > > to already be doing it this way.
> > > 
> > > Signed-off-by: Krister Johansen <kjlx@templeofstupid.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_ag.h          |  2 ++
> > >  fs/xfs/libxfs/xfs_ag_resv.c     | 54 ++++++++++++++++++++++--------
> > >  fs/xfs/libxfs/xfs_ag_resv.h     |  4 +++
> > >  fs/xfs/libxfs/xfs_alloc.c       | 43 +++++++++++++++++++++++-
> > >  fs/xfs/libxfs/xfs_alloc.h       |  3 +-
> > >  fs/xfs/libxfs/xfs_alloc_btree.c | 59 +++++++++++++++++++++++++++++++++
> > >  fs/xfs/libxfs/xfs_alloc_btree.h |  5 +++
> > >  fs/xfs/libxfs/xfs_rmap_btree.c  |  5 +++
> > >  fs/xfs/scrub/fscounters.c       |  1 +
> > >  9 files changed, 161 insertions(+), 15 deletions(-)
> > > diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> > > index 35de09a2516c..40bff82f2b7e 100644
> > > --- a/fs/xfs/libxfs/xfs_ag.h
> > > +++ b/fs/xfs/libxfs/xfs_ag.h
> > > @@ -62,6 +62,8 @@ struct xfs_perag {
> > >  	struct xfs_ag_resv	pag_meta_resv;
> > >  	/* Blocks reserved for the reverse mapping btree. */
> > >  	struct xfs_ag_resv	pag_rmapbt_resv;
> > > +	/* Blocks reserved for the AGFL. */
> > > +	struct xfs_ag_resv	pag_agfl_resv;
> > 
> > Ok, so you're creating a new pool for the AGFL refills.
> 
> Sorry, I should have been clearer about what I was trying to do.  When I
> reviewed the patches[1] that created the rmapbt reservation, it looked
> like part of the justification for that work was that blocks from the
> agfl moving to other data structures, like the rmapbt, caused accounting
> inconsistencies.  I worried that if I just accounted for the AGFL blocks
> without also trying to track the agfl blocks in use by the bnobt and the
> cnobt then I'd be re-creating a problem similar to what the previous
> patch had tried to fix.

Ah. There's a key difference between bno/cnt btree blocks and rmapbt
blocks: bnobt/cntbt blocks are considered free space whilst rmapbt
blocks are considered used space.

The reason for this is that the free space btrees have a special
characteristic that only becomes obvious when someone points it out.

When the AG reaches a full state, there is no free space and the
free space btrees are empty. Hence as we slowly consume space in the
AG, the free space trees are shrinking and the record count
decreases and the btree blocks indexing that free space get released
as the index shrinks. Hence we don't have to account for those btree
blocks as used space because they have always been released back to the
free space btree by the time we get near ENOSPC. When we are near
ENOSPC, the btree is reduced to a single root block that we never
free. By the time we empty all the records in that root block, the
only free space remaining in the AG is the blocks on the AGFL
itself.

In comparison, the rmapbt does not shrink as the filesystem fills
up; it continues to grow as we add more used space records. hence we
have to account for the rmapbt records as used space, but to
guarantee we can always allocate a new rmapbt record near ENOSPC, we
have to guarantee that there are enough blocks to fill the AGFL for
any given rampbt insertion. Hence we need a reserve pool of free
space that ensures the free space btree can refill the AGFL blocks
that the rmapbt can consume during growth near ENOSPC.

The fact that we don't account for bnobt/cntbt blocks as used space
is also reflected in the behaviour of xfs_alloc_space_available()
when we are freeing extents. It does:

	if (flags & XFS_ALLOC_FLAG_FREEING)
		return true;

And so always allows extent freeing regardless of how little space
is remaining the AG and AGFL.

The reason for this is that freeing space when the AGFL is empty
will not require AGFL blocks to be consumed. The bnobt/cntbt root
blocks are completely empty, and so freeing the extent will simply
insert a new record into those blocks. No btree block allocation
will be required. Any AGFL refill after this point will have some
blocks that can be pulled from the free space btrees, hence the AGFL
being undersized does not matter and hence we never return ENOSPC
when freeing extents on a completely full AG.

The fundamental issue here is that the rmapbt and reflink
reservations mean ENOSPC (AG full) is now occurring while there is
still large amounts of space being free-but-reserved, and so the
assumption that bno/cnt trees will never split on allocation nor
grow when we free an extent when we are right at ENOSPC no longer
holds true. 

Hence the space we set aside for the AGFL for bno/cnt operation at
ENOSPC is no longer sufficient.....

> After reading the rest of your comments, it sounds like I didn't get
> this right and we should probably discuss which approach is best to
> take.
> 
> > > @@ -48,6 +50,8 @@ xfs_ag_resv_rmapbt_alloc(
> > >  
> > >  	args.len = 1;
> > >  	pag = xfs_perag_get(mp, agno);
> > > +	/* Transfer this reservation from the AGFL to RMAPBT */
> > > +	xfs_ag_resv_free_extent(pag, XFS_AG_RESV_AGFL, NULL, 1);
> > >  	xfs_ag_resv_alloc_extent(pag, XFS_AG_RESV_RMAPBT, &args);
> > >  	xfs_perag_put(pag);
> > >  }
> > 
> > I have no idea what this is accounting for or why it needs to be
> > done. Comments need to explain why, not repeat what the code is
> > doing.
> 
> Thanks, would something along the lines of the following been better?
> 
> /*
>  *
>  * The rmapbt has its own reservation separate from the AGFL.  In cases
>  * where an agfl block is destined for use in the rmapbt, ensure that it
>  * is counted against the rmapbt reservation instead of the agfl's.
>  */

Ok, I understand what you are trying to do, but given the above I'm
not sure this correct....

> > I can see why you might be trying to calculate the max number of
> > blocks in the btree - given worst case single block fragmentation,
> > half the space in the AG can be indexed by the free space btree.
> > That's a non-trivial number of records and a decent number of btree
> > blocks to index them, but even then I don't think it's a relevant
> > number to the AGFL reservation size.
> >
> > The minimum AGFL size is tiny - it's just enough blocks to cover a
> > full height split of each btree that sources blocks from the AGFL.
> > If you point xfs_db at a filesystem and run the btheight command
> > with the length of the AG as the record count, you'll get an idea
> > of the worst case btree heights in the filesystem.
> > 
> > On the workstation I'm typing this one, /home is 1.8TB, has 32 AGs
> > and has reflink and rmap enabled. 
> > 
> > The worst case btree heights for both the bno and cnt btrees is 4
> > levels, and the rmapbt is 5 levels at worst.  Hence for any given
> > allocation the worst case AGFL length is going to be ~15 blocks.
> > 
> > Then we need to consider how many times we might have to refill the
> > AGFL in a series of dependent allocations that might be forced into
> > the same AG. i.e. the bmbt splitting during record insertion after a
> > data extent allocation (which I think is the only case this matters)
> > 
> > The bmapbt for the above filesystem has a maximum height of 4
> > levels. Hence the worst case "data extent + bmbt split" allocation
> > is going to require 1 + ((max bmbt level - 1) + 1) block allocations
> > from the AG. i.e. (max bmbt level + 1) AGFL refills.
> > 
> > Hence to guarantee that we'd never run out of blocks on an
> > allocation requiring worst case btree splits on all btrees
> > on all allocations is ~75 blocks.
> 
> Just to make certain I understand, for each allocation the correct way
> to calculate the AGFL refill size would be to use the formula in
> xfs_alloc_min_freelist(), and assume that in the worst-case the level
> increments each time?

Not quite. Btrees don't work that way - once you split the root
block, it can't be split again until the root block fills. That
means we have to split the level below the root block enough times
to fill the root block. And that requires splitting the level below
that enough times to fill and split the second level enough times to
fill the root block. The number of inserts needed to split the root
block increases exponentially with the height of the tree.

Hence if we've got a height of 2 and 10 records/ptrs per leaf/node,
a full tree looks like this:

Level 1			0123456789
                        ||.......|
        /---------------/|.......\---------------\
        |                |                       |
Level 0	0123456789	 0123456789	.....	0123456789

If we do an insert anywhere we'll get a full height split and a new
root at level 2. Lets insert record A in the leaf at the left edge:

Level 2			01
                        ||
                /-------/\------\
                |               |
Level 1		0A1234		56789
                |||...	        ....|
        /-------/|\------\	....\------------\
        |        |        |                       |
Level 0	01234    A56789	 0123456789	.....	0123456789

It should be obvious now that a followup insertion anywhere in the
tree cannot split either the root node at level 2, nor the old root
node that was split in two at level 1.

Yes, we can still split at level 0, but that will only result in
nodes at level 1 getting updated, and only once they are full will
they start splitting at level 1. And then level 2 (the root) won't
split until level 1 has split enough to fill all the nodes in level
1.

What this means is that for any single insertion into a btree, the
worst case demand for new blocks is "current height + 1". In the
case of BMBT, INOBT and REFCOUNBT, we're typically only doing one or
two adjacent record insertions in a given operation, so only one
split will occur during the operation. The free space trees are
different, however.

When the first allocation occurs, we split the tree as per above
and that consumes (start height + 1) blocks from AGFL. We then
get the next BMBT allocation request (because it's doing a
multi-level split), and the best free space we find is, this time,
in the leaf at the right side of the tree. Hence we split that
block, but we don't need to split it's parent (level 1) block
because it has free space in it. Hence the second allocation has
a worst case block requirement of (start height - 1).

If we then do a third allocation (level 2 of the BMBT is splitting),
and that lands in the middle of the tree, we split that block. That
can be inserted into either of the level 1 blocks without causing a
split there, either. Hence a worst case block requirement for that
is also (start height - 1).

It's only once we've split enough blocks at (start height - 1) that
to fill both blocks at start height that we'll get a larger split.
We had ten blocks at level 0 to begin with, 11 after the first full
hieght split, so we need, at minimum, another 9 splits at level 0 to
fill level 1. This means we then have all the leaf blocks at either
5 or 6 records at the time the level 1 nodes fill. To then get
another insert into level 1 to split that, we need to fill a minimum
of -3 sibling- leaf blocks.

The reason we need to fill 3 leaf blocks and not 1 is that we shift
records between left and right siblings instead of splitting. i.e.
we steal space from a sibling in preference to splitting and
inserting a new record into the parent. Hence we only insert into
the parent when the insert node and both siblings are full
completely full.

When we look at a typical AG btree on a v5 filesystem, we have at
least 110 records/ptrs per block (1kB block size) so the minimum
number of record inserts needed before we need to split a parent
again after it was just split is at least 150 inserts.

Hence after a full height split, we are not going to split a node at
the old root level again until at least 150 inserts (1kB block size)
are done at the child level.

IOWs, we're never going to get two start height splits in a single
allocation chain. At most we are going to get one start height split
and then N (start height - 1) splits. That's the worst case AGFL we
need to consider, but such a split chain would be so infintesimally
probably that always reserving that amount of space in the AGFL is
just a waste of space because it will never, ever be used.

So the worst case AGFL requirement for a data extent allocation or
free will be:

	1. data extent - full free space tree split * 2 + rmapbt
	2. BMBT leaf split - (free space height - 2) * 2 + rmapbt
	3. BMBT node split - (free space height - 2) * 2 + rmapbt
	....
	N. BMBT root split - (free space height - 2) * 2 + rmapbt

So the maximum number of chained allocations is likely going to be
something like:

	(max AGFL for one allocation) +
	((max bmbt/refcountbt height) * (max agfl for dependent allocation))

Which is likely to be in the order of...

> > So I wouldn't expect the AGFL reserve pool to be any larger than a
> > couple of hundred blocks in the worst case.

... this.

That's a lot of space (close on 1MB at 4kB block size) per AG to
never be able to use for this exceedingly rare corner case
situation. However, let's get the calculation right first and then
see how it falls out in comparison to the amount of space we already
reserve for rmapbt, refcountbt and finobt. It may just be noise...

> > Which brings me to the next question: do we even need a reserve pool
> > for this? We know when we are doing such a dependent allocation
> > chain because args->minleft has to be set to ensure enough space
> > is left after the first allocation to allow all the remaining
> > allocations to succeed.
> > 
> > Perhaps we can to extend the minleft mechanism to indicate how many
> > dependent allocations are in this chain (we know the bmbt height,
> > too) and trigger the initial AGFL fill to handle multiple splits
> > when the AG reservations cause the AG to be "empty" when there's
> > actually still lots of free space in the AG?
> > 
> > Or maybe there's a simpler way? Just extend the RMAPBT reservation
> > slightly and use it for AGFL blocks whenever that reservation is
> > non-zero and causing ENOSPC for AGFL refills?
> > 
> > I'm not sure waht the best approach is here - even though I
> > suggested making use of reserve pools some time ago, looking at the
> > context and the maths again I'm not really sure that it is the only
> > (or best) approach to solving the issue...
> 
> I'd be happy to explore some of these alternate approaches.
> 
> One approach that I tried before the agfl reserved pool was to work out
> how much space would be needed for the next agfl refill by allowing
> xfs_alloc_min_freelist to tell me the need at level n+1.  From there, I
> required minleft > 0 allocations to have that additional space
> available.

Yes, that would mostly work, but the issue is that every allocation
that goes through xfs_bmapi_write() (essentially every data,
directory and xattr block allocation) have minleft set. And it
gets set on inode chunk allocation, too, because we need to have
space for inobt/finobt record insertion...

> It seemed like it was working, but broke the stripe
> alignment tests in generic/336.  The case where that test selects a
> really large extent size was failing because it was falling back to a
> minleft allocation and not getting proper stripe alignment.

It would have been falling back to an *minlen* allocation, not a
"minleft" allocation. Two very different things - minlen and maxlen
define the allowable size of allocated extent, minleft defines how
many blocks must remain free in the AG after the first allocation
succeeds.

> This was because I was effectively reserving additional space, but not
> subtracting that space from m_ag_max_usable.  The ag_resv code already
> does this, so I wondered if I might be acting like I was smarter than
> the experts and should try following the advice that was given.

Hmmmm. Subtracting space from mp->m_ag_max_usable might be a viable
option here - that's supposed to have an AGFL block reserve
component in it already.

[ And now we disappear down the rabbit hole. ]

Take a look at xfs_alloc_ag_max_usable(), which is used to set
mp->m_ag_max_usable:

	blocks = XFS_BB_TO_FSB(mp, XFS_FSS_TO_BB(mp, 4)); /* ag headers */
        blocks += XFS_ALLOCBT_AGFL_RESERVE;
        blocks += 3;                    /* AGF, AGI btree root blocks */
	....

There's a number of blocks reserved for the AGFL that aren't usable
already. What is that value for?

/*
 * The number of blocks per AG that we withhold from xfs_dec_fdblocks to
 * guarantee that we can refill the AGFL prior to allocating space in a nearly
 * full AG.  Although the space described by the free space btrees, the
 * blocks used by the freesp btrees themselves, and the blocks owned by the
 * AGFL are counted in the ondisk fdblocks, it's a mistake to let the ondisk
 * free space in the AG drop so low that the free space btrees cannot refill an
 * empty AGFL up to the minimum level.  Rather than grind through empty AGs
 * until the fs goes down, we subtract this many AG blocks from the incore
 * fdblocks to ensure user allocation does not overcommit the space the
 * filesystem needs for the AGFLs.  The rmap btree uses a per-AG reservation to
 * withhold space from xfs_dec_fdblocks, so we do not account for that here.
 */
#define XFS_ALLOCBT_AGFL_RESERVE        4

What is this magic number of 4, then?

Remember what I said above about the free space btree blocks being
accounted as free space and that freeing extents are always allowed
to go ahead, even when the AG is full?

This AGFL reserve is the minimum space needed for an extent free to
successfully refill the AGFL at ENOSPC to allow the extent free to
proceed. That is, both trees have a singel level, so a full height
split of either tree will require 2 blocks to be allocated. 2
freespace trees per AG, two blocks per tree, and so we need 4 blocks
per AG to ensure freeing extents at ENOSPC will always succeed.

This "magic 4" blocks isn't valid when we have rmapbt, recountbt, or
finobt reservations in the AG anymore, because ENOSPC can occur when
we still have multi-level bno/cnt btrees in the AG. That's the first
thing we need to fix.

This AGFL set aside is taken out of the global free space pool via
this function:

/*
 * Compute the number of blocks that we set aside to guarantee the ability to
 * refill the AGFL and handle a full bmap btree split.
 *
 * In order to avoid ENOSPC-related deadlock caused by out-of-order locking of
 * AGF buffer (PV 947395), we place constraints on the relationship among
 * actual allocations for data blocks, freelist blocks, and potential file data
 * bmap btree blocks. However, these restrictions may result in no actual space
 * allocated for a delayed extent, for example, a data block in a certain AG is
 * allocated but there is no additional block for the additional bmap btree
 * block due to a split of the bmap btree of the file. The result of this may
 * lead to an infinite loop when the file gets flushed to disk and all delayed
 * extents need to be actually allocated. To get around this, we explicitly set
 * aside a few blocks which will not be reserved in delayed allocation.
 *
 * For each AG, we need to reserve enough blocks to replenish a totally empty
 * AGFL and 4 more to handle a potential split of the file's bmap btree.
 */
unsigned int
xfs_alloc_set_aside(
        struct xfs_mount        *mp)
{
        return mp->m_sb.sb_agcount * (XFS_ALLOCBT_AGFL_RESERVE + 4);
}

But where did that magic number of "4 more to handle a potential
split of the file's bmap btree" come from?

Ah, a fix I made for a ENOSPC regression back in 2006:

+ * ..... Considering the minimum number of
+ * needed freelist blocks is 4 fsbs _per AG_, a potential split of file's bmap
+ * btree requires 1 fsb, so we set the number of set-aside blocks
+ * to 4 + 4*agcount.
+ */
+#define XFS_ALLOC_SET_ASIDE(mp)  (4 + ((mp)->m_sb.sb_agcount * 4))

That was fixing a regression caused by an ENOSPC deadlock bug fix
done for SGI PV 947395.

commit 96b336c71016a85cd193762199aa6f99f543b6fe
Author: Yingping Lu <yingping@sgi.com>
Date:   Tue May 23 19:28:08 2006 +0000

    In actual allocation of file system blocks and freeing extents, the transaction
    within each such operation may involve multiple locking of AGF buffer. While the
    freeing extent function has sorted the extents based on AGF number before entering
    into transaction, however, when the file system space is very limited, the allocation
    of space would try every AGF to get space allocated, this could potentially cause
    out-of-order locking, thus deadlock could happen. This fix mitigates the scarce space
    for allocation by setting aside a few blocks without reservation, and avoid deadlock
    by maintaining ascending order of AGF locking.
    Add a new flag XFS_ALLOC_FLAG_FREEING to indicate whether the caller is freeing or
    allocating. Add a field firstblock in structure xfs_alloc_arg to indicate whether
    this is the first allocation request.

Which included this:

+ * ...... Considering the minimum number of
+ * needed freelist blocks is 4 fsbs, a potential split of file's bmap
+ * btree requires 1 fsb, so we set the number of set-aside blocks to 8.
+*/
+#define SET_ASIDE_BLOCKS 8

<ding!>

Ah, now I get it. It's only taken me 18 years to really understand
how this value was originally derived and why it is wrong.

It assumed 4 blocks for the AGFL for the initial allocation to fill
and empty AGFL, and then 4 more blocks for the AGFL to allow a
refill for the subsequent BMBT block allocation to refill the AGFL.
IOWs, it wasn't reserving blocks for the BMBT itself, it was
reserving blocks for a second AGFL refill in the allocation chain....

Right, so I think what we need to change is XFS_ALLOCBT_AGFL_RESERVE
and xfs_alloc_set_aside() to reflect the worst case size of the free
space trees when we hit ENOSPC for user data, not a hard coded 4 + 4.

The worst case free space tree size is going to be single block free
records when all the per-ag reservations are at their maximum
values. So we need to calculate maximum reservation sizes for the
AG, then calculate how many btree blocks that will require to index
as single block free space extents, then calculate the hieght of the
btrees needs to index that. That gives us out "free space tree
height at ENOSPC", and then we can calculate how many AGFL blocks we
need at ENOSPC to handle a split of both trees. That value replaces
XFS_ALLOCBT_AGFL_RESERVE.

As for the BMBT split requiring more AGFL refills, we need to know
what the maximum BMBT height the fs supports is (I think we already
calculate that), and that then becomes the level we feed into the
"how many AGFL blocks do we need in a full height BMBT split
allocation chain. I did that math above, and that calculation
should replace the "+ 4" in xfs_alloc_set_aside(). I think that
ends up with the calculation being something like:

setaside = agcount * (number of dependent allocations *
			AGFL blocks for refill at ENOSPC)

I think we also need to make mp->m_ag_max_usable also take into
account the BMBT split related AGFL refills as xfs_alloc_set_aside()
as it only considers XFS_ALLOCBT_AGFL_RESERVE right now. That will
ensure we always have those blocks available for the AGFL.

> Let me try to summarize and make a few of these proposals more concrete
> and then we can discuss the tradeoffs.

Fair summary. this is already long, and I think what I discovered
above kinda comes under:

> 4. Implement a less ambitious AGFL reserve

That's what we did back in 2006 - we just carved out the smallest
amount of blocks we needed from the free space pool to ensure the
failing case worked.

> The draft in this thread tried to track all AGFL blocks from their
> allocation and continued to account for them during their lifetime in
> the bnobt and cnobt.  Instead of trying to build a reserve for all free
> space management blocks that aren't rmapbt, reduce the scope of the AGFL
> reserve to be just the number of blocks needed to satsify a single
> transaction with multiple allocations that occurs close to an AG's
> ENOSPC.

Yes, and that's what I suggest we extend xfs_alloc_set_aside() and
mp->m_ag_max_usable to encompass. That way we don't actually need to
track anything, the AGs will always have that space available to use
because mp->m_ag_max_usable prevents them from being used by
anything else.

> Do any of these approaches stand out as clearly better (or worse) to
> you?

I think I've convinced myself that we already use option 4 and the
accounting just needs extending to reserve the correct amount of
blocks...

> Thanks again for taking the time to read through these patches and
> provide feedback.  I appreciate all the comments, ideas, and
> explanations.

Don't thank me - I've got to thank you for taking the time and
effort to understand this complex code well enough to ask exactly
the right question.  It's not often that answering a question on how
to do something causes a whole bunch of not quite connected floating
pieces in my head to suddenly fall and land in exactly the right
places... :)

-Dave.
-- 
Dave Chinner
david@fromorbit.com
