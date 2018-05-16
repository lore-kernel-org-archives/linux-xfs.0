Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:37034 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750953AbeEPVXr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 May 2018 17:23:47 -0400
Date: Thu, 17 May 2018 07:23:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/22] xfs: add helpers to collect and sift btree block
 pointers during repair
Message-ID: <20180516212343.GV23861@dastard>
References: <152642361893.1556.9335169821674946249.stgit@magnolia>
 <152642363794.1556.12771807615463619233.stgit@magnolia>
 <20180516075652.GR23861@dastard>
 <982db5b5-23a3-96e1-2e5b-87fae674f1f6@oracle.com>
 <20180516180615.GJ23858@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180516180615.GJ23858@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Allison Henderson <allison.henderson@oracle.com>, linux-xfs@vger.kernel.org

On Wed, May 16, 2018 at 11:06:15AM -0700, Darrick J. Wong wrote:
> On Wed, May 16, 2018 at 10:34:36AM -0700, Allison Henderson wrote:
> > Ok, with the points Dave made:
> > Reviewed by: Allison Henderson <allison.henderson@oracle.com>
> > 
> > On 05/16/2018 12:56 AM, Dave Chinner wrote:
> > > On Tue, May 15, 2018 at 03:33:58PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > Add some helpers to assemble a list of fs block extents.  Generally,
> > > > repair functions will iterate the rmapbt to make a list (1) of all
> > > > extents owned by the nominal owner of the metadata structure; then they
> > > > will iterate all other structures with the same rmap owner to make a
> > > > list (2) of active blocks; and finally we have a subtraction function to
> > > > subtract all the blocks in (2) from (1), with the result that (1) is now
> > > > a list of blocks that were owned by the old btree and must be disposed.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > ---
> > > >   fs/xfs/scrub/repair.c |  207 +++++++++++++++++++++++++++++++++++++++++++++++++
> > > >   fs/xfs/scrub/repair.h |   31 +++++++
> > > >   2 files changed, 238 insertions(+)
> > > > 
> > > > 
> > > > diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> > > > index 72f04a717150..8e8ecddd7537 100644
> > > > --- a/fs/xfs/scrub/repair.c
> > > > +++ b/fs/xfs/scrub/repair.c
> > > > @@ -361,3 +361,210 @@ xfs_repair_init_btblock(
> > > >   	return 0;
> > > >   }
> > > > +
> > > > +/* Collect a dead btree extent for later disposal. */
> > > > +int
> > > > +xfs_repair_collect_btree_extent(
> > > > +	struct xfs_scrub_context	*sc,
> > > > +	struct xfs_repair_extent_list	*exlist,
> > > > +	xfs_fsblock_t			fsbno,
> > > > +	xfs_extlen_t			len)
> > > > +{
> > > > +	struct xfs_repair_extent	*rex;
> > > > +
> > > > +	trace_xfs_repair_collect_btree_extent(sc->mp,
> > > > +			XFS_FSB_TO_AGNO(sc->mp, fsbno),
> > > > +			XFS_FSB_TO_AGBNO(sc->mp, fsbno), len);
> > > > +
> > > > +	rex = kmem_alloc(sizeof(struct xfs_repair_extent), KM_MAYFAIL);
> > > > +	if (!rex)
> > > > +		return -ENOMEM;
> > > Is this in transaction context? Regardless, I think we need to run
> > > the entire of scrub/repair in a memalloc_nofs_save() context so we
> > > don't have memory reclaim recursion issues...
> > > 
> > > [...]
> > > 
> > > > +/* Compare two btree extents. */
> > > > +static int
> > > > +xfs_repair_btree_extent_cmp(
> > > > +	void				*priv,
> > > > +	struct list_head		*a,
> > > > +	struct list_head		*b)
> > > > +{
> > > > +	struct xfs_repair_extent	*ap;
> > > > +	struct xfs_repair_extent	*bp;
> > > > +
> > > > +	ap = container_of(a, struct xfs_repair_extent, list);
> > > > +	bp = container_of(b, struct xfs_repair_extent, list);
> > > > +
> > > > +	if (ap->fsbno > bp->fsbno)
> > > > +		return 1;
> > > > +	else if (ap->fsbno < bp->fsbno)
> > > > +		return -1;
> > > No need for the else there.
> > Well, I think he meant to return 0 in the case of ap->fsbno == bp->fsbno? 
> > Am i reading that right?  caller expects 1 for greater than, -1 for less
> > than and 0 on equivalence?
> 
> Correct.  I think Dave was pointing out that else-after-return is
> unnecessary, since the following behaves equivalently:
> 
> if (a > b)
> 	return 1;
> if (a < b)
> 	return -1;
> return 0;
> 
> Note that gcc (7.3, anyway) generates the same asm for either version so
> I assume this is mostly stylistic cleanup to make the comparisons line
> up?  I don't have a preference either way. :)

It's a style and maintenance thing. The else is redundant and could
lead to future confusion, so IMO it is best to leave it out....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
