Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:8106 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751296AbeFEEjU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jun 2018 00:39:20 -0400
Date: Tue, 5 Jun 2018 14:39:16 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] xfs: validate btree records on retreival
Message-ID: <20180605043916.GB10363@dastard>
References: <20180605024313.18737-1-david@fromorbit.com>
 <20180605024313.18737-4-david@fromorbit.com>
 <20180605040232.GC9437@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180605040232.GC9437@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jun 04, 2018 at 09:02:32PM -0700, Darrick J. Wong wrote:
> On Tue, Jun 05, 2018 at 12:43:13PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > So we don't check the validity of records as we walk the btree. When
> > there are corrupt records in the free space btree (e.g. zero
> > startblock/length or beyond EOAG) we just blindly use it and things
> > go bad from there. That leads to assert failures on debug kernels
> > like this:
....
> > @@ -222,12 +224,24 @@ xfs_alloc_get_rec(
> >  	if (error || !(*stat))
> >  		return error;
> >  	if (rec->alloc.ar_blockcount == 0)
> > -		return -EFSCORRUPTED;
> > +		goto out_bad_rec;
> >  
> >  	*bno = be32_to_cpu(rec->alloc.ar_startblock);
> >  	*len = be32_to_cpu(rec->alloc.ar_blockcount);
> >  
> > -	return error;
> > +	if (!xfs_verify_agbno(mp, agno, *bno) ||
> > +	    !xfs_verify_agbno(mp, agno, *bno + *len - 1))
> 
> What about overflows?

I guess that also means I have to add a (*bno > *bno + *len) check
because it's all unsigned, right?

....

> > +	xfs_inobt_btrec_to_irec(mp, rec, irec);
> > +
> > +	if (!xfs_verify_agino(mp, agno, irec->ir_startino))
> > +		goto out_bad_rec;
> > +	if (irec->ir_count < XFS_INODES_PER_HOLEMASK_BIT ||
> > +	    irec->ir_count > XFS_INODES_PER_CHUNK)
> > +		goto out_bad_rec;
> > +	if (irec->ir_freecount > XFS_INODES_PER_CHUNK)
> > +		goto out_bad_rec;
> > +
> > +	/* if there are no holes, return the first available offset */
> > +	if (!xfs_inobt_issparse(irec->ir_holemask))
> > +		realfree = irec->ir_free;
> > +	else
> > +		realfree = irec->ir_free & xfs_inobt_irec_to_allocmask(irec);
> > +	if (hweight64(realfree) != irec->ir_freecount)
> > +		goto out_bad_rec;
> 
> Hmmm... there's a fair amount of shared logic between this and
> xfs_scrub_iallocbt_rec().

Probably, I did just wrote the checks from first principles.

> Maybe the validation logic should be a new
> xfs_btree_ops->verify_rec() function so that we can trap bad records as
> they come in, and share the code with the btree scrubbers?

Yeah, that's kinda what I was thinking is the next step. i.e this
patch starts us down the road, and then we drive it inwards to
capture more and more of the places we access the raw record data.

> This also gets us to the broader question of where do we draw the line
> between hot-path verifiers and online fsck?  This code (and its
> counterparts through the rest of this patch) are very very similar to
> the existing scrub/ record checking code, and as the fuzz attacks become
> more sophisticated it makes more sense just to run online fsck.

The problem is that we don't know we have a corruption if we don't
do checks like these, and hence have no trigger to tell us that
we need to scrub. And given the number of "my freespace tree got
corrupted, do you have any idea why?" reports we get, we need
something like this at runtime.

The other thing I was considering is that we do these checks in the
buffer verifier - we're already checksumming the metadata, so it's
hot in cache. Hence the overhead of checking each record isn't going
to be that bad, and it protects searches as well. That will probably
be a more efficient approach and it matches the way we currently do
most of the validation.

I'd still like to get this patch in first and then have some time to
work out how best to optimise it.

> Then we
> gain the secondary side effect of pulling all of an AG's metadata into
> memory right then and there, which (at least on fast storage) won't be
> so painful.  Also if we know an AG is toast we could adapt xfs to handle
> offlining of bad AGs while we fix them.
> 
> The awkward part is that online fsck is far short of a full deck...

I think we should aim for a robust, efficient corruption detection
mechanism first - repair comes after detection :P

> >  	return 0;
> > +
> > +out_bad_rec:
> > +	xfs_warn(mp,
> > +		"%s Inode BTree record corruption in AG %d detected!",
> > +		cur->bc_btnum == XFS_BTNUM_INO ? "Used" : "Free", agno);
> > +	xfs_warn(mp,
> > +"start inode 0x%x, count 0x%x, free 0x%x freemask 0x%llx, holemask 0x%x",
> > +		irec->ir_startino, irec->ir_count, irec->ir_freecount,
> > +		irec->ir_free, irec->ir_holemask);
> 
> I've also been wondering given the insane amount of dmesg output from
> the dangerous_*repair xfstests if we should be turning these into
> tracepoints so that we don't hose the system when people feed us garbage
> filesystems.  The downside is that you'd then have to use ftrace to
> capture the exactly buffer we fell over on.

The problem is that won't help us with the on-off corruption issues
or the people who cannot supply us with a metadump or reproducable
test case. Perhaps these should be ratelimited?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
