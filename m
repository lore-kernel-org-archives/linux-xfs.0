Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p3F7PjTH050630 for <xfs@oss.sgi.com>; Fri, 15 Apr 2011 02:25:45 -0500
Received: from mx4-phx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 917ED3E2E60
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2011 00:29:07 -0700 (PDT)
Received: from mx4-phx2.redhat.com (mx4-phx2.redhat.com [209.132.183.25]) by
	cuda.sgi.com with ESMTP id osCRU7aFQUcACIMZ for
	<xfs@oss.sgi.com>; Fri, 15 Apr 2011 00:29:07 -0700 (PDT)
Date: Fri, 15 Apr 2011 03:29:02 -0400 (EDT)
From: Lachlan McIlroy <lmcilroy@redhat.com>
Message-ID: <1329918989.88946.1302852542103.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
In-Reply-To: <20110412065328.GG21395@dastard>
Subject: Re: [PATCH] xfs: fix bmbt block allocation failures
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

----- Original Message -----
> On Mon, Apr 11, 2011 at 08:55:33PM -0400, Lachlan McIlroy wrote:
> > ----- Original Message -----
> > > From: Dave Chinner <dchinner@redhat.com>
> > >
> > > When a multilevel bmbt split occurs, we can be asked to allocate
> > > blocks from an AG that has no space left available. In the case of
> > > an extent just being allocated, the first bmbt block allocation
> > > sees
> > > the firstblock parameter is set and does not set a minleft
> > > parameter
> > > for the allocation. The allocation also does not set the total
> > > number of blocks required by the allocation, either.
> > >
> > > If the extent allocation used all the free space in the AG, the
> > > lack
> > > of a total allocation size results in a block being reserved for
> > > the
> > > AG freespace btree manipulations being used incorrectly.
> > >
> > > Secondly, the allocation is only allowed to be allocated in the
> > > current AG (NEAR_BNO) because the low space algorithm has not been
> > > activated. As a result of this, the second block allocation in the
> > > split fails to find sufficient space in the current AG and fails,
> > > resulting in a dirty transaction cancellation and a filesytem
> > > shutdown.
> > >
> > > There are two problems here - both pointed out by Lachlan McIlroy
> > > when we were first discussing a proposed fix for the problem (See
> > > http://oss.sgi.com/archives/xfs/2010-09/msg00438.html). Firstly,
> > > the missing args->total was causing the initial block to be
> > > allocated from the freespace reserve. Secondly that the NEAR_BNO
> > > allocation should probably be a START_BNO allocation to allow
> > > blocks
> > > to be taken from a higher numbered AG.
> > >
> > > With these changes, the allocation failure goes away, but we
> > > trigger
> > > asserts in xfs_bmapi() that try to ensure that bmbt block
> > > allocations only occur in the same AG as the extent allocated,
> > > except if the low space algorithm is active. In this case, we
> > > don't
> > > need to activate the low space algorithm - if a START_BNO
> > > allocation
> > > fails with minleft = 0, then there is no space we can allocate at
> > > all, and hence the low space algorithm is no help. Therefore the
> > > asserts need modification reflect the new state of affairs.
> > >
> > > This commit fixes the problem demonstrated by the test case in
> > > xfstests 250.
> > >
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > > fs/xfs/xfs_bmap.c | 8 ++------
> > > fs/xfs/xfs_bmap_btree.c | 7 ++-----
> > > 2 files changed, 4 insertions(+), 11 deletions(-)
> > >
> > > diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
> > > index fa00788..50eed97 100644
> > > --- a/fs/xfs/xfs_bmap.c
> > > +++ b/fs/xfs/xfs_bmap.c
> > > @@ -4917,13 +4917,9 @@ error0:
> > > if (cur) {
> > > if (!error) {
> > > ASSERT(*firstblock == NULLFSBLOCK ||
> > > - XFS_FSB_TO_AGNO(mp, *firstblock) ==
> > > + XFS_FSB_TO_AGNO(mp, *firstblock) <=
> > > XFS_FSB_TO_AGNO(mp,
> > > - cur->bc_private.b.firstblock) ||
> > > - (flist->xbf_low &&
> > > - XFS_FSB_TO_AGNO(mp, *firstblock) <
> > > - XFS_FSB_TO_AGNO(mp,
> > > - cur->bc_private.b.firstblock)));
> > > + cur->bc_private.b.firstblock));
> > > *firstblock = cur->bc_private.b.firstblock;
> > > }
> > > xfs_btree_del_cursor(cur,
> >
> > There's another ASSERT like this earlier in xfs_bmapi() after the
> > call
> > to xfs_bmap_alloc() which may need the same attention.
> 
> No, it checks the allocated extent against any existing firstblock
> and has nothing to do with the the bmbt allocations during extent
> insertion.
> >
> > > diff --git a/fs/xfs/xfs_bmap_btree.c b/fs/xfs/xfs_bmap_btree.c
> > > index 87d3c10..b2cdbfe 100644
> > > --- a/fs/xfs/xfs_bmap_btree.c
> > > +++ b/fs/xfs/xfs_bmap_btree.c
> > > @@ -518,10 +518,11 @@ xfs_bmbt_alloc_block(
> > > args.mp = cur->bc_mp;
> > > args.fsbno = cur->bc_private.b.firstblock;
> > > args.firstblock = args.fsbno;
> > > + args.total = 1;
> > > + args.type = XFS_ALLOCTYPE_START_BNO;
> > >
> > > if (args.fsbno == NULLFSBLOCK) {
> > > args.fsbno = be64_to_cpu(start->l);
> > > - args.type = XFS_ALLOCTYPE_START_BNO;
> > > /*
> > > * Make sure there is sufficient room left in the AG to
> > > * complete a full tree split for an extent insert. If
> > > @@ -534,10 +535,6 @@ xfs_bmbt_alloc_block(
> > > * block allocation here and corrupt the filesystem.
> > > */
> > > args.minleft = xfs_trans_get_block_res(args.tp);
> > > - } else if (cur->bc_private.b.flist->xbf_low) {
> > > - args.type = XFS_ALLOCTYPE_START_BNO;
> > > - } else {
> > > - args.type = XFS_ALLOCTYPE_NEAR_BNO;
> > > }
> > >
> > > args.minlen = args.maxlen = args.prod = 1;
> >
> > I think that's exactly what I had in mind when we looked at this
> > last
> > time but now I'm not so sure. I think I understand now why there is
> > a
> > requirement that all subsequent allocations must (read 'can') come
> > from
> > the same AG.
> >
> > The first time we try to allocate blocks we look for an AG with all
> > the
> > space we need for the reservation to succeed.
> 
> Of course, that explains the near bno allocation them. It's
> basically saying "we only ever have a reservation for a freespace
> btree split in a single AG". Ok, so it seems we need to retain that,
> and the problem of not being able to allocate in the current AG is
> elsewhere.
> 
> Thanks for pointing that out to me, Lachlan - I should have realised
> that is what it was for in the first place.
> 
> > If we don't find a single
> > AG that will satisfy the full request then we use the low space
> > algorithm
> > and start from AG 0. But if we do find such an AG with all the space
> > we
> > need it should be fine to use NEAR_BNO on subsequent allocations
> > because
> > the space is there, right?
> 
> But for the case we are dealing with here - bmbt insertion after an
> allocation - we already have firstblock set and hence never traverse
> the args.fsbno == NULLFSBLOCK case as the cursor firstblock is
> always set to the block that has already been allocated. Hence we
> never hit the low space algorithm unless it was triggered by the
> extent allocation.
> 
> > If this logic fails to hold true then there are other problems we
> > need to
> > deal with including;
> >
> > If we've already allocated a block from AG N then all subsequent
> > allocations must come from AGs >= N to prevent locking issues. If
> > the
> > blocks we need are in AGs < N we're in trouble.
> 
> Agreed - this is what minleft is trying to avoid from happening
> ahead of the first allocations.
> 
> > We need to fall back to
> > the low space algorithm and start from AG 0 but we can't do this if
> > we
> > have already allocated from AG N.
> 
> Right, even the low space algorithm cannot avoid the need to avoid
> lock inversions in the AGs.
> 
> > Also if we pass START_BNO to xfs_alloc_vextent() then it will fall
> > through to the ANY/START/FIRST_AG case and set flags to TRYLOCK. It
> 
> That's not a problem.
> 
> > will then scan AGs from N to the last AG and skip any that are
> > already
> > locked. It may skip AGs that have the space we need and we may get
> > to
> > the last AG without finding all required blocks.
> 
> Sure, but....
> 
> > Then xfs_alloc_vextent() will loop through the AGs a second time if
> > we
> > didn't get all we needed the first time but this time without the
> > TRYLOCK.
> > This could result in locking AGs out of order.
> 
> It loops the second time from the start AG, not AG zero so we should
> not be locking AGs out of order.
> 
> > So why is the extent allocation using all of the remaining blocks in
> > the
> > AG and not leaving any for the split?
> 
> That's the big question, isn't it? I'll come back to this.
> 
> > Are we not reserving the split
> > space with the conversion transaction?
> 
> I don't think this is relevant - the problem is allocation, not
> extent conversion.
> 
> > Is it because the space needed
> > for splits is not accounted for when delayed allocations are
> > reserved so
> > we oversubscribe ourselves?
> 
> This is preallocation into a hole, so delalloc is not involved
> here.
> 
> > Or are we not activating the low space
> > algorithm early enough?
> 
> There's plenty of free space, just not in the AG _after_ the extent
> allocation, and so there's no reason to trigger the low space
> algorithm.
> 
> > I need to look at the code a bit more to understand all this. The
> > same
> > allocation logic appears to be used in xfs_bmap_extents_to_btree(),
> > xfs_bmap_local_to_extents() and xfs_bmap_btalloc() so maybe there's
> > some
> > logic in the logic.
> 
> I think they are all fine, now that I think I understand the reason
> for the logic - that we only reserve enough blocks in the
> transaction for freespace tree splits in a single AG. New blocks in
> the bmbt can be triggered when:
> 
> 1. extent conversion splits a record into two (or three)
> records.
> 2. extent removal split a record into two (punch a hole in
> the middle of an extent)
> 3. extent allocation inserts a new record
> 4. converting from extent to btree format
> 
> Note that the local to extent change is actually a data extent
> allocation (same as xfs_bmap_btalloc), not a bmbt allocation.
> 
> So, in the cases of #1 and #2, it is unlikely that there has been a
> previous allocation in the transaction, and so we take the first
> case of args.fsbno == NULLFSBLOCK to chose an AG with enough space
> for an entire bmbt split. Otherwise, it's the same case as #3 and
> #4.
> 
> In the case of #3 and #4, the reason for the bmbt allocation is that
> we have allocated a new extent, and as a result firstblock _will_ be
> set. Hence we should have either space in the AG available for the
> bmbt split _or_ the low space algorithm is active.
> 
> This problem case is that for #3/4 we can enter xfs_bmbt_alloc_block
> with the initial condition of firstblock set, not enough space in
> the current AG and the low space algorithm not active. For the test
> case (250), we still have lots of free space in the filesystem so we
> should not be activating the low space algorithm. That leaves the
> fact we are not leaving enough space in the AG for the bmbt split
> after the extent is allocated. AFAICT, this code in xfs_bmapi()
> handles it:
> 
> 4452 if (wr && *firstblock == NULLFSBLOCK) {
> 4453 if (XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_BTREE)
> 4454 minleft = be16_to_cpu(ifp->if_broot->bb_level) + 1;
> 4455 else
> 4456 minleft = 1;
> 4457 } else
> 4458 minleft = 0;
> 
> So it seems to me that in all cases the setting of minleft is
> correct, as are the fallbacks that clear minleft then set xbf_low in
> xfs_bmap_btalloc(). So I don't think the bug actually resides at the
> xfs-bmapi/bmbt level. The question I'm now trying to answer is how
> we can allocate the entire AG if minleft is actually set.
> 
> The answer, it appears, is in xfs_alloc_fix_minleft(). If we've
> allocated the largest extent possible, we'll have a situation where
> the only free space remaining is on the freelist. To use numbers
> relevant to the test case:
> 
> agsize = 4096 blocks (16MB)
> max ext len = 4096 - 8 blocks
> = 4088 blocks
> AGF freeblks = 4088
> AGF flcount = 4
> minleft = 2;
> 
> extent allocation length = 4088
> 
> diff = 4088 + 4 - 4088 - 2
> = 2
> 
> And because diff >= 0, xfs_alloc_fix_minleft() says that the extent
> length is OK and does not trim it. Then when we go to allocate bmbt
> blocks, args->total is not set so the first block is allocated from
> the free list, and the second then fails at the
> xfs_alloc_fix_freelist checks because we don't have space available
> in the AG....
> 
> IOWs, we've set minleft appropriately, but xfs_alloc_fix_minleft()
> assumes that the AGFL blocks are part of the space available for
> the allocation. This, it seems, is wrong. If minleft is set, then we
> are not allowing the allocation to dip into any reserves, so we
> should not be considering the freelist blocks as available for
> minleft reservations.
> 
> So, the patch below fixes the test 250 assert failure as well, and
> to me seems much more likely as the root cause of the bug.
> 
> What do you think, Lachlan?

I think you're onto something Dave and it makes a lot of sense.  It
would appear that the checks in xfs_alloc_fix_freelist() really only
apply when allocating extents and maybe should be skipped when
allocating the minleft blocks.  Oh, unless the low space algorithm is
being used.  I think args.total represents the full extent allocation
request and doesn't apply to minleft allocations so I don't think we
need that change to xfs_bmbt_alloc_block().  Is just the fix to
xfs_alloc_fix_minleft() enough here?

> 
> Cheers,
> 
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
> 
> 
> ---
> fs/xfs/xfs_alloc.c | 1 -
> fs/xfs/xfs_bmap_btree.c | 1 +
> 2 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
> index 27d64d7..8946464 100644
> --- a/fs/xfs/xfs_alloc.c
> +++ b/fs/xfs/xfs_alloc.c
> @@ -280,7 +280,6 @@ xfs_alloc_fix_minleft(
> return 1;
> agf = XFS_BUF_TO_AGF(args->agbp);
> diff = be32_to_cpu(agf->agf_freeblks)
> - + be32_to_cpu(agf->agf_flcount)
> - args->len - args->minleft;
> if (diff >= 0)
> return 1;
> diff --git a/fs/xfs/xfs_bmap_btree.c b/fs/xfs/xfs_bmap_btree.c
> index 87d3c10..470047e 100644
> --- a/fs/xfs/xfs_bmap_btree.c
> +++ b/fs/xfs/xfs_bmap_btree.c
> @@ -518,6 +518,7 @@ xfs_bmbt_alloc_block(
> args.mp = cur->bc_mp;
> args.fsbno = cur->bc_private.b.firstblock;
> args.firstblock = args.fsbno;
> + args.total = 1;
> 
> if (args.fsbno == NULLFSBLOCK) {
> args.fsbno = be64_to_cpu(start->l);
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
