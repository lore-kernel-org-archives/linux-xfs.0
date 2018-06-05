Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:50655 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751396AbeFEFIQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jun 2018 01:08:16 -0400
Date: Tue, 5 Jun 2018 15:08:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] xfs: validate btree records on retreival
Message-ID: <20180605050813.GE10363@dastard>
References: <20180605024313.18737-1-david@fromorbit.com>
 <20180605024313.18737-4-david@fromorbit.com>
 <20180605040232.GC9437@magnolia>
 <20180605043916.GB10363@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180605043916.GB10363@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jun 05, 2018 at 02:39:16PM +1000, Dave Chinner wrote:
> On Mon, Jun 04, 2018 at 09:02:32PM -0700, Darrick J. Wong wrote:
> > On Tue, Jun 05, 2018 at 12:43:13PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > So we don't check the validity of records as we walk the btree. When
> > > there are corrupt records in the free space btree (e.g. zero
> > > startblock/length or beyond EOAG) we just blindly use it and things
> > > go bad from there. That leads to assert failures on debug kernels
> > > like this:
> ....
> > > @@ -222,12 +224,24 @@ xfs_alloc_get_rec(
> > >  	if (error || !(*stat))
> > >  		return error;
> > >  	if (rec->alloc.ar_blockcount == 0)
> > > -		return -EFSCORRUPTED;
> > > +		goto out_bad_rec;
> > >  
> > >  	*bno = be32_to_cpu(rec->alloc.ar_startblock);
> > >  	*len = be32_to_cpu(rec->alloc.ar_blockcount);
> > >  
> > > -	return error;
> > > +	if (!xfs_verify_agbno(mp, agno, *bno) ||
> > > +	    !xfs_verify_agbno(mp, agno, *bno + *len - 1))
> > 
> > What about overflows?
> 
> I guess that also means I have to add a (*bno > *bno + *len) check
> because it's all unsigned, right?
> 
> ....
> 
> > > +	xfs_inobt_btrec_to_irec(mp, rec, irec);
> > > +
> > > +	if (!xfs_verify_agino(mp, agno, irec->ir_startino))
> > > +		goto out_bad_rec;
> > > +	if (irec->ir_count < XFS_INODES_PER_HOLEMASK_BIT ||
> > > +	    irec->ir_count > XFS_INODES_PER_CHUNK)
> > > +		goto out_bad_rec;
> > > +	if (irec->ir_freecount > XFS_INODES_PER_CHUNK)
> > > +		goto out_bad_rec;
> > > +
> > > +	/* if there are no holes, return the first available offset */
> > > +	if (!xfs_inobt_issparse(irec->ir_holemask))
> > > +		realfree = irec->ir_free;
> > > +	else
> > > +		realfree = irec->ir_free & xfs_inobt_irec_to_allocmask(irec);
> > > +	if (hweight64(realfree) != irec->ir_freecount)
> > > +		goto out_bad_rec;
> > 
> > Hmmm... there's a fair amount of shared logic between this and
> > xfs_scrub_iallocbt_rec().
> 
> Probably, I did just wrote the checks from first principles.

xfs_scrub_iallocbt_rec() is a lot more heavyweight. It does a lot
more stuff that what I just added, but I'm not sure it will improve
runtime corruption dtection all that much more. i.e I feel like the
additional checking falls on the wrong side of the cost/benefit
line.

Yeah, I know that line is kinda blurry....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
