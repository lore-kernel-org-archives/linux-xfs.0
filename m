Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8O4QuH5162425 for <xfs@oss.sgi.com>; Thu, 23 Sep 2010 23:26:57 -0500
Received: from mx02.colomx.prod.int.phx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 17306E5E6EA
	for <xfs@oss.sgi.com>; Thu, 23 Sep 2010 21:40:28 -0700 (PDT)
Received: from mx02.colomx.prod.int.phx2.redhat.com (mx4-phx2.redhat.com
	[209.132.183.25]) by cuda.sgi.com with ESMTP id
	rKXZphlilrZchpkT for <xfs@oss.sgi.com>;
	Thu, 23 Sep 2010 21:40:28 -0700 (PDT)
Date: Fri, 24 Sep 2010 00:27:42 -0400 (EDT)
From: Lachlan McIlroy <lmcilroy@redhat.com>
Message-ID: <551219446.267321285302462350.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
In-Reply-To: <419117193.267231285302375889.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
Subject: Re: [PATCH] [RFC] xfs: prevent bmap btree from using alloc btree
	reserved blocks
MIME-Version: 1.0
Reply-To: Lachlan McIlroy <lmcilroy@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com


----- "Dave Chinner" <david@fromorbit.com> wrote:

> On Mon, Sep 20, 2010 at 01:25:49AM -0400, Lachlan McIlroy wrote:
> > Looks good, some questions inline.
> > ----- "Dave Chinner" <david@fromorbit.com> wrote:
> > > On Tue, Aug 24, 2010 at 11:45:33PM +1000, Dave Chinner wrote:
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > > 
> > > > Recently we've had WANT_CORRUPTED_GOTO filesystem shutdowns
> > > reported
> > > > on filesystems with large numbers of small AGs. RedHat QA found
> a
> > > > simple test case at:
> > > > 
> > > > https://bugzilla.redhat.com/show_bug.cgi?id=626244
> > > > 
> > > > Which was further refined to:
> > > > 
> > > > # mkfs.xfs -f -d agsize=16m,size=50g <dev>
> > > > # mount <dev> /mnt
> > > > # xfs_io -f -c 'resvsp 0 40G' /mnt/foo
> > > > 
> > > > The initial analysis is in the above bug. The fundamental
> problem
> > > is
> > > > that the data extent allocation is using all the free blocks in
> the
> > > > allocation group, and then the bmap btree block allocation is
> > > > dipping into the reserved block pool that each AG holds for
> > > > freespace btree manipulations. This results in failures when
> > > > multiple bmap btree blocks are needed for a multilevel split of
> the
> > > > bmap btree.
> > > > 
> > > > The reason this is occurring is that when we do a btree block
> > > > allocation after a data extent allocation we run down the path
> that
> > > > does not set up the minleft allocation parameter. That is, we
> allow
> > > > the btree block allocation to use up all the blocks in the
> current
> > > > AG if that is what will make the current allocation succeed.
> This
> > > > what we are supposed to only allow the low space allocation
> > > > algorithm to do, not a normal allocation. The result is that we
> can
> > > > allocate the first block from the AG freelist, and then the
> second
> > > > block allocation in the split will fail in the same AG because
> we
> > > do
> > > > not have a minleft parameter set and hence will not pass the
> checks
> > > > in xfs_alloc_fix_freelist() and hence the allocation will fail.
> > > > Further, because no minleft parameter is set, the btree block
> > > > allocation will not retry the allocation with different
> parameters
> > > > and (potentially) enable the low space algorithm.
> > 
> > I think the assumption here is that if the first btree block (with
> > minleft set) succeeds then all the required free blocks for further
> > btree allocations will be available if needed and allocations
> shouldn't
> > fail. 
> 
> Right, but I think that the blocks reserved for different trees are
> getting confused. That is, I think minleft is reserving space for
> bmap btree blocks, while XFS_MIN_FREELIST_PAG() is reserving the
> minimum necessary space for the freespace btree operations.

Yes that's my understanding too - minleft is for the bmap btree and
XFS_MIN_FREELIST_PAG() is for the freelist tree.  I can't see how
they are getting mixed up though.

> 
> > But this clearly isn't holding true.
> 
> Right - I think that the bmap btree blocks are being taken from the
> freespace tree reserve because minleft is set to zero.

Okay, that shouldn't happen.  My understanding of minleft is that the
allocation is conditional on there being at least minleft blocks left
after the allocation (after taking into account the freelist tree
blocks) otherwise the allocation will not proceed.  Using a minleft of
0 means we can allocate the last available block in an AG while still
leaving XFS_MIN_FREELIST_PAG() blocks.

We have this condition in xfs_alloc_fix_freelist():

		need = XFS_MIN_FREELIST_PAG(pag, mp);
...
		    ((int)(pag->pagf_freeblks + pag->pagf_flcount -
			   need - args->total) < (int)args->minleft)) {

But I cannot see where args->total gets set.  I see it is initialised
to zero but shouldn't it be set to 1 for the block we need to allocate?
If this remains as zero then we could steal a block from the freespace
reserve by allowing an allocation to proceed when it shouldn't.  I think
this may be the source of the problem.

> 
> > Do we have multiple threads
> > allocating from the same AG stealing each other's minleft blocks?
> 
> No. The issue, I think, is that for this filesystem both
> XFS_MIN_FREELIST_PAG() and the bmap btree max split  are equal at 4
> blocks. Hence I think the first allocation is succeeding because
> minleft modifies the check that xfs_alloc_fix_freelist() does - it
> appears to allow dipping into XFS_MIN_FREELIST_PAG() when minleft ==
> XFS_MIN_FREELIST_PAG(). For the second block, minleft was zero,
> which means it couldn't dip into the reserve and hence failed
> without a fallback or checking another AG.

I don't see how it's dipping into the freelist reserve.  From what I
can see it sums up all the free blocks, subtracts the reserved space
that can't be used, subtracts the space for the current allocation and
if that leaves less than minleft left then fail.

So I think the logic should be - if minleft is > 0 and it fails then
try another AG.  If all AGs fail then restart with minleft == 0 and
if that fails try another AG again.  Well that's the case with
XFS_ALLOCTYPE_START_BNO.  With XFS_ALLOCTYPE_NEAR_BNO it wont try
other AGs and fails prematurely (but your fix prevents that).

I think that having minleft set for every allocation isn't that
important (well, it may improve the chances of getting most bmap btree
blocks in one AG if we can't find an AG to fit all of them in) but what
is important is retrying the allocation to give it a chance to succeed
in another AG.

So I think a one-liner to change XFS_ALLOCTYPE_NEAR_BNO to
XFS_ALLOCTYPE_START_BNO is all that's needed.  The condition
'(args.fsbno == NULLFSBLOCK && args.minleft)' still works because
minleft > 0 implies b.firstblock == NULLFSBLOCK and we can try the
allocation again from AG 0.  If minleft == 0 we've already locked an
AG and cannot restart from AG 0.

> 
> I think the way minleft affects xfs_alloc_fix_freelist() behaviour
> might be part of the problem - it seems wrong to me to let bmap
> btree blocks (which can be located in any AG) use blocks reserved
> for the freelists themselves. Could you have a look at this and let
> me know what you think?

Yeah it definitely seems wrong for the bmap btree to use freelist
blocks and it shouldn't happen.  If there's anyway we can catch/assert
that we should - just not sure how to.

> 
> > > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > > ---
> > > >  fs/xfs/xfs_bmap_btree.c |   51
> > > ++++++++++++++++++++++++++++++++++++++--------
> > > >  1 files changed, 42 insertions(+), 9 deletions(-)
> > > > 
> > > > diff --git a/fs/xfs/xfs_bmap_btree.c b/fs/xfs/xfs_bmap_btree.c
> > > > index 87d3c10..d5ef4e3 100644
> > > > --- a/fs/xfs/xfs_bmap_btree.c
> > > > +++ b/fs/xfs/xfs_bmap_btree.c
> > > > @@ -538,6 +538,25 @@ xfs_bmbt_alloc_block(
> > > >  		args.type = XFS_ALLOCTYPE_START_BNO;
> > > >  	} else {
> > > >  		args.type = XFS_ALLOCTYPE_NEAR_BNO;
> > 
> > Could we use XFS_ALLOCTYPE_START_BNO here so that it automatically
> tries other
> > AGs instead of doing it manually (like you've done below)?  It
> should even
> > restart from AG 0 if no other allocations have been done.
> > 
> > > > +
> > > > +		/*
> > > > +		 * we've come in here because this is the second or
> subsequent
> > > > +		 * btree block we need to allocate for the bmap btree
> > > > +		 * modification. If we've just emptied the AG and there are
> > > > +		 * only free list blocks left, we need to make sure that we
> > > > +		 * take into account the minleft value that was reserved on
> the
> > > > +		 * first allocation through here (the NULLFSBLOCK branch
> > > > +		 * above). In that case, minleft will already take into
> account
> > > > +		 * the maximum number of blocks needed for a btree split,
> and
> > > > +		 * the number of blocks already allocated is recorded in the
> > > > +		 * cursor. From that, we can work out exactly how much
> smaller
> > > > +		 * the minleft should be so that we don't select an AG that
> > > > +		 * does not have enough blocks available to continue the
> entire
> > > > +		 * btree split.
> > > > +		 */
> > > > +		args.minleft = XFS_BM_MAXLEVELS(args.mp,
> > > > +					(int)cur->bc_private.b.whichfork) - 1 -
> > > > +				cur->bc_private.b.allocated;
> > > >  	}
> > > >  
> > > >  	args.minlen = args.maxlen = args.prod = 1;
> > > > @@ -550,15 +569,29 @@ xfs_bmbt_alloc_block(
> > > >  	if (error)
> > > >  		goto error0;
> > > >  
> > > > -	if (args.fsbno == NULLFSBLOCK && args.minleft) {
> > > > -		/*
> > > > -		 * Could not find an AG with enough free space to satisfy
> > > > -		 * a full btree split.  Try again without minleft and if
> > > > -		 * successful activate the lowspace algorithm.
> > > > -		 */
> > > > -		args.fsbno = 0;
> > > > -		args.type = XFS_ALLOCTYPE_FIRST_AG;
> > > > -		args.minleft = 0;
> > > > +	while (args.fsbno == NULLFSBLOCK && args.minleft) {
> > > > +		if (cur->bc_private.b.firstblock == NULLFSBLOCK) {
> > 
> > Makes sense, need to check b_firstblock since minleft is always set
> now.
> > Do we still need the check for minleft here?  The only case I can
> see that
> > minleft would be 0 now is for the low space algorithm and there may
> be some
> > benefit it letting it try again.
> 
> Yes, I think that makes sense.
> 
> > 
> > > > +			/*
> > > > +			 * Could not find an AG with enough free space to satisfy
> > > > +			 * a full btree split.  Try again without minleft and if
> > > > +			 * successful activate the lowspace algorithm.
> > > > +			 */
> > > > +			args.type = XFS_ALLOCTYPE_FIRST_AG;
> > > > +			args.fsbno = 0;
> > > > +			args.minleft = 0;
> > > > +		} else {
> > 
> > Nice one, allow the allocator to hunt for btree blocks in later
> AGs.
> > 
> > > > +			/*
> > > > +			 * Failed to find enough space for a btree block after
> > > > +			 * a extent allocation has already occurred. Continue
> > > > +			 * searching other AGs that can hold the remaining
> > > > +			 * blocks. If we fail with minleft set, then clear it
> > > > +			 * and try again.
> > > > +			 */
> > > > +			args.type = XFS_ALLOCTYPE_START_AG;
> > > > +			args.fsbno = cur->bc_private.b.firstblock;
> > > > +			if (cur->bc_private.b.flist->xbf_low)
> > 
> > I don't think xbf_low can be set here - if it was set then minleft
> > would be 0 and we wouldn't have reached here.
> 
> True. I need to redo the loop termination if I'm going to let the
> minleft = 0 case retry allocation, in which case we could get here
> with xbf_low set...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
