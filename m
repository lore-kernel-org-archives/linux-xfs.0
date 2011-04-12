Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3C0qXq9120427 for <xfs@oss.sgi.com>; Mon, 11 Apr 2011 19:52:34 -0500
Received: from mx4-phx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3149B14BBBD0
	for <xfs@oss.sgi.com>; Mon, 11 Apr 2011 17:55:53 -0700 (PDT)
Received: from mx4-phx2.redhat.com (mx4-phx2.redhat.com [209.132.183.25]) by
	cuda.sgi.com with ESMTP id BOQQ6aRasqL7rAWQ for
	<xfs@oss.sgi.com>; Mon, 11 Apr 2011 17:55:53 -0700 (PDT)
Date: Mon, 11 Apr 2011 20:55:33 -0400 (EDT)
From: Lachlan McIlroy <lmcilroy@redhat.com>
Message-ID: <1246357909.27528.1302569733170.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1302489251-1512-1-git-send-email-david@fromorbit.com>
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
> From: Dave Chinner <dchinner@redhat.com>
> 
> When a multilevel bmbt split occurs, we can be asked to allocate
> blocks from an AG that has no space left available. In the case of
> an extent just being allocated, the first bmbt block allocation sees
> the firstblock parameter is set and does not set a minleft parameter
> for the allocation. The allocation also does not set the total
> number of blocks required by the allocation, either.
> 
> If the extent allocation used all the free space in the AG, the lack
> of a total allocation size results in a block being reserved for the
> AG freespace btree manipulations being used incorrectly.
> 
> Secondly, the allocation is only allowed to be allocated in the
> current AG (NEAR_BNO) because the low space algorithm has not been
> activated. As a result of this, the second block allocation in the
> split fails to find sufficient space in the current AG and fails,
> resulting in a dirty transaction cancellation and a filesytem
> shutdown.
> 
> There are two problems here - both pointed out by Lachlan McIlroy
> when we were first discussing a proposed fix for the problem (See
> http://oss.sgi.com/archives/xfs/2010-09/msg00438.html). Firstly,
> the missing args->total was causing the initial block to be
> allocated from the freespace reserve. Secondly that the NEAR_BNO
> allocation should probably be a START_BNO allocation to allow blocks
> to be taken from a higher numbered AG.
> 
> With these changes, the allocation failure goes away, but we trigger
> asserts in xfs_bmapi() that try to ensure that bmbt block
> allocations only occur in the same AG as the extent allocated,
> except if the low space algorithm is active. In this case, we don't
> need to activate the low space algorithm - if a START_BNO allocation
> fails with minleft = 0, then there is no space we can allocate at
> all, and hence the low space algorithm is no help. Therefore the
> asserts need modification reflect the new state of affairs.
> 
> This commit fixes the problem demonstrated by the test case in
> xfstests 250.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
> fs/xfs/xfs_bmap.c | 8 ++------
> fs/xfs/xfs_bmap_btree.c | 7 ++-----
> 2 files changed, 4 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
> index fa00788..50eed97 100644
> --- a/fs/xfs/xfs_bmap.c
> +++ b/fs/xfs/xfs_bmap.c
> @@ -4917,13 +4917,9 @@ error0:
> if (cur) {
> if (!error) {
> ASSERT(*firstblock == NULLFSBLOCK ||
> - XFS_FSB_TO_AGNO(mp, *firstblock) ==
> + XFS_FSB_TO_AGNO(mp, *firstblock) <=
> XFS_FSB_TO_AGNO(mp,
> - cur->bc_private.b.firstblock) ||
> - (flist->xbf_low &&
> - XFS_FSB_TO_AGNO(mp, *firstblock) <
> - XFS_FSB_TO_AGNO(mp,
> - cur->bc_private.b.firstblock)));
> + cur->bc_private.b.firstblock));
> *firstblock = cur->bc_private.b.firstblock;
> }
> xfs_btree_del_cursor(cur,

There's another ASSERT like this earlier in xfs_bmapi() after the call
to xfs_bmap_alloc() which may need the same attention.

> diff --git a/fs/xfs/xfs_bmap_btree.c b/fs/xfs/xfs_bmap_btree.c
> index 87d3c10..b2cdbfe 100644
> --- a/fs/xfs/xfs_bmap_btree.c
> +++ b/fs/xfs/xfs_bmap_btree.c
> @@ -518,10 +518,11 @@ xfs_bmbt_alloc_block(
> args.mp = cur->bc_mp;
> args.fsbno = cur->bc_private.b.firstblock;
> args.firstblock = args.fsbno;
> + args.total = 1;
> + args.type = XFS_ALLOCTYPE_START_BNO;
> 
> if (args.fsbno == NULLFSBLOCK) {
> args.fsbno = be64_to_cpu(start->l);
> - args.type = XFS_ALLOCTYPE_START_BNO;
> /*
> * Make sure there is sufficient room left in the AG to
> * complete a full tree split for an extent insert. If
> @@ -534,10 +535,6 @@ xfs_bmbt_alloc_block(
> * block allocation here and corrupt the filesystem.
> */
> args.minleft = xfs_trans_get_block_res(args.tp);
> - } else if (cur->bc_private.b.flist->xbf_low) {
> - args.type = XFS_ALLOCTYPE_START_BNO;
> - } else {
> - args.type = XFS_ALLOCTYPE_NEAR_BNO;
> }
> 
> args.minlen = args.maxlen = args.prod = 1;

I think that's exactly what I had in mind when we looked at this last
time but now I'm not so sure.  I think I understand now why there is a
requirement that all subsequent allocations must (read 'can') come from
the same AG.

The first time we try to allocate blocks we look for an AG with all the
space we need for the reservation to succeed.  If we don't find a single
AG that will satisfy the full request then we use the low space algorithm
and start from AG 0.  But if we do find such an AG with all the space we
need it should be fine to use NEAR_BNO on subsequent allocations because
the space is there, right?

If this logic fails to hold true then there are other problems we need to
deal with including;

If we've already allocated a block from AG N then all subsequent
allocations must come from AGs >= N to prevent locking issues.  If the
blocks we need are in AGs < N we're in trouble.  We need to fall back to
the low space algorithm and start from AG 0 but we can't do this if we 
have already allocated from AG N.

Also if we pass START_BNO to xfs_alloc_vextent() then it will fall
through to the ANY/START/FIRST_AG case and set flags to TRYLOCK.  It
will then scan AGs from N to the last AG and skip any that are already
locked.  It may skip AGs that have the space we need and we may get to
the last AG without finding all required blocks.

Then xfs_alloc_vextent() will loop through the AGs a second time if we
didn't get all we needed the first time but this time without the TRYLOCK.
This could result in locking AGs out of order.

So why is the extent allocation using all of the remaining blocks in the
AG and not leaving any for the split?  Are we not reserving the split
space with the conversion transaction?  Is it because the space needed
for splits is not accounted for when delayed allocations are reserved so
we oversubscribe ourselves?  Or are we not activating the low space
algorithm early enough?

I need to look at the code a bit more to understand all this.  The same
allocation logic appears to be used in xfs_bmap_extents_to_btree(),
xfs_bmap_local_to_extents() and xfs_bmap_btalloc() so maybe there's some
logic in the logic.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
