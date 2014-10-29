Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 694B77F3F
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 15:04:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 467FC304048
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 13:04:54 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	yc1wsYjYngahbMEA for <xfs@oss.sgi.com>;
	Wed, 29 Oct 2014 13:04:51 -0700 (PDT)
Date: Thu, 30 Oct 2014 06:59:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] repair: AGFL rebuild fails if btree split required
Message-ID: <20141029195939.GE13323@dastard>
References: <1414552144-12627-1-git-send-email-david@fromorbit.com>
	<1414552144-12627-3-git-send-email-david@fromorbit.com>
	<20141029192609.GB2084@bfoster.laptop>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141029192609.GB2084@bfoster.laptop>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: bvowk@box.com, xfs@oss.sgi.com

On Wed, Oct 29, 2014 at 03:26:10PM -0400, Brian Foster wrote:
> On Wed, Oct 29, 2014 at 02:09:04PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > In phase 5 we rebuild the freelist btrees, the AGF and the AGFL from
> > all the free space information we have gathered and resolved during
> > pahses 3 and 4. If the freespace information is laid out just right,
> > we end up having to allocate free space for the AGFL blocks.
> > 
> > If the size of the free space we allocate from is larger than the
> > space we need, then we have to insert the remainder back into the
> > freespace btree. For the by-size tree, this means we are likely to
> > be removing a record from one leaf, and then inserting the remainder
> > - a smaller size - into another leaf.
> > 
> > The issue is that the leaf blocks to the left of the original leaf
> > block we removed the extent record from are full and hence require a
> > split to insert the new record. That, of course, requires a free
> > block in the AGFL to allocate from, and now we have a chicken and
> > egg situation: there are no free blocks in the AGFL because we are
> > setting it up.
> > 
> > As a result, setting up the free list silently fails, leaving the
> > freespace btrees in an inconsistent state and the AGFL in question
> > empty. When the filesystem is next mounted, the first allocation
> > from that AGF results in attempting to fix the AGFL, and it then
> > does exactly the same thing as the repair code, fails to allocate a
> > block during the split and fails. This results in an immediate
> > shutdown because the transaction doing the allocation is dirty by
> > this stage.
> > 
> > The fix for the problem is to make repair handle rebulding the btree
> > differently. If we leave ispace for a couple of records in each
> > btree leaf and node, there is never a need for a split to occur when
> > initially setting up the AGFL. This results in repair doing the
> > right thing, and hence the runtime problems after mount don't occur.
> > Further, add error checking the the AGFL setup code and abort repair
> > if we have a failure to correctly set up the AGFL so we catch this
> > problem at repair time, not mount time...
> > 
> 
> Interesting problem, thanks for the breakdown. I suppose the only
> interesting side effect is that the alloc btrees might require a bit
> more space after repair than before. I wonder if we need to take that
> into consideration here for certain cases. E.g., does this have
> ramifications for running repair on a clean, but completely full fs, or
> should that be generally handled by the existence of reserved blocks?

In general, it shouldn't be an issue. It is extremely rare for a
free space btree to be entirely compact - it currently only happens
when repair runs, and the first insert at each leaf triggers splits
and so after a short runtime will no longer be compact. Hence it is
almost always going to be the case that the btree is smaller after
repair than it was before....

I can see that it might cause an issue at maximally sized
filesystems with worst case free space fragmentation, but given the
runtime of repair of such a filesystem is probably measured in
months and in hundreds of petabytes of RAM I'm not really concerned
about that right now.

> 
> A couple minor nits below...
> 
> > Reported-by: Barkley Vowk <bvowk@box.com>
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  repair/phase5.c | 44 +++++++++++++++++++++++++++++++++++---------
> >  1 file changed, 35 insertions(+), 9 deletions(-)
> > 
> > diff --git a/repair/phase5.c b/repair/phase5.c
> > index d6d3c6d..3d58936 100644
> > --- a/repair/phase5.c
> > +++ b/repair/phase5.c
> > @@ -335,11 +335,22 @@ finish_cursor(bt_status_t *curs)
> >  }
> >  
> >  /*
> > + * We need to leave some free records in the tree for the corner case of
> > + * setting up the AGFL. This may require allocation of blocks, and as
> > + * such can require insertion of new records into the tree (e.g. moving
> > + * a record in the by-count tree when a long extent is shortened). If we
> > + * pack the records into the leaves with no slack space, this requires a
> > + * leaf split to occur and a block to be allocated from the free list.
> > + * If we don't have any blocks on the free list (because we are setting
> > + * it up!), then we fail, and the filesystem will fail with the same
> > + * failure at runtime. Hence leave a couple of records slack space in
> > + * each block to allow immediate modification of the tree without
> > + * requiring splits to be done.
> > + *
> >   * XXX(hch): any reason we don't just look at mp->m_alloc_mxr?
> 
> I guess we could kill this comment now. ;)

Comment is still valid. I only fixed the bug - I didn't look into
why we aren't using mp->m_alloc_mxr instead of calculating the max
records value from first principles...

> > @@ -385,6 +392,13 @@ calculate_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
> >  	lptr->num_recs_tot = num_extents;
> >  	level = 1;
> >  
> > +#ifdef XR_BLD_FREE_TRACE
> > +	fprintf(stderr, "%s 0 %d %d %d %d\n", __func__,
> 
> What's the 0 for?

The btree level. 0 == leaf....

....
> > @@ -402,6 +416,14 @@ calculate_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
> >  			lptr->num_recs_pb = p_lptr->num_blocks
> >  					/ lptr->num_blocks;
> >  			lptr->num_recs_tot = p_lptr->num_blocks;
> > +#ifdef XR_BLD_FREE_TRACE
> > +			fprintf(stderr, "%s %d %d %d %d %d\n", __func__,
> > +					level,
> > +					lptr->num_blocks,

And as you can see in this hunk as we set up the nodes the level
is printed so we can see the config of each level as it is set up.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
