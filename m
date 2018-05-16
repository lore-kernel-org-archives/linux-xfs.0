Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:55918 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750937AbeEPSGU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 May 2018 14:06:20 -0400
Date: Wed, 16 May 2018 11:06:15 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 03/22] xfs: add helpers to collect and sift btree block
 pointers during repair
Message-ID: <20180516180615.GJ23858@magnolia>
References: <152642361893.1556.9335169821674946249.stgit@magnolia>
 <152642363794.1556.12771807615463619233.stgit@magnolia>
 <20180516075652.GR23861@dastard>
 <982db5b5-23a3-96e1-2e5b-87fae674f1f6@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <982db5b5-23a3-96e1-2e5b-87fae674f1f6@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On Wed, May 16, 2018 at 10:34:36AM -0700, Allison Henderson wrote:
> Ok, with the points Dave made:
> Reviewed by: Allison Henderson <allison.henderson@oracle.com>
> 
> On 05/16/2018 12:56 AM, Dave Chinner wrote:
> > On Tue, May 15, 2018 at 03:33:58PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Add some helpers to assemble a list of fs block extents.  Generally,
> > > repair functions will iterate the rmapbt to make a list (1) of all
> > > extents owned by the nominal owner of the metadata structure; then they
> > > will iterate all other structures with the same rmap owner to make a
> > > list (2) of active blocks; and finally we have a subtraction function to
> > > subtract all the blocks in (2) from (1), with the result that (1) is now
> > > a list of blocks that were owned by the old btree and must be disposed.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >   fs/xfs/scrub/repair.c |  207 +++++++++++++++++++++++++++++++++++++++++++++++++
> > >   fs/xfs/scrub/repair.h |   31 +++++++
> > >   2 files changed, 238 insertions(+)
> > > 
> > > 
> > > diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> > > index 72f04a717150..8e8ecddd7537 100644
> > > --- a/fs/xfs/scrub/repair.c
> > > +++ b/fs/xfs/scrub/repair.c
> > > @@ -361,3 +361,210 @@ xfs_repair_init_btblock(
> > >   	return 0;
> > >   }
> > > +
> > > +/* Collect a dead btree extent for later disposal. */
> > > +int
> > > +xfs_repair_collect_btree_extent(
> > > +	struct xfs_scrub_context	*sc,
> > > +	struct xfs_repair_extent_list	*exlist,
> > > +	xfs_fsblock_t			fsbno,
> > > +	xfs_extlen_t			len)
> > > +{
> > > +	struct xfs_repair_extent	*rex;
> > > +
> > > +	trace_xfs_repair_collect_btree_extent(sc->mp,
> > > +			XFS_FSB_TO_AGNO(sc->mp, fsbno),
> > > +			XFS_FSB_TO_AGBNO(sc->mp, fsbno), len);
> > > +
> > > +	rex = kmem_alloc(sizeof(struct xfs_repair_extent), KM_MAYFAIL);
> > > +	if (!rex)
> > > +		return -ENOMEM;
> > Is this in transaction context? Regardless, I think we need to run
> > the entire of scrub/repair in a memalloc_nofs_save() context so we
> > don't have memory reclaim recursion issues...
> > 
> > [...]
> > 
> > > +/* Compare two btree extents. */
> > > +static int
> > > +xfs_repair_btree_extent_cmp(
> > > +	void				*priv,
> > > +	struct list_head		*a,
> > > +	struct list_head		*b)
> > > +{
> > > +	struct xfs_repair_extent	*ap;
> > > +	struct xfs_repair_extent	*bp;
> > > +
> > > +	ap = container_of(a, struct xfs_repair_extent, list);
> > > +	bp = container_of(b, struct xfs_repair_extent, list);
> > > +
> > > +	if (ap->fsbno > bp->fsbno)
> > > +		return 1;
> > > +	else if (ap->fsbno < bp->fsbno)
> > > +		return -1;
> > No need for the else there.
> Well, I think he meant to return 0 in the case of ap->fsbno == bp->fsbno? 
> Am i reading that right?  caller expects 1 for greater than, -1 for less
> than and 0 on equivalence?

Correct.  I think Dave was pointing out that else-after-return is
unnecessary, since the following behaves equivalently:

if (a > b)
	return 1;
if (a < b)
	return -1;
return 0;

Note that gcc (7.3, anyway) generates the same asm for either version so
I assume this is mostly stylistic cleanup to make the comparisons line
up?  I don't have a preference either way. :)

--D

> > > +	return 0;
> > > +}
> > > +
> > > +/*
> > > + * Remove all the blocks mentioned in sublist from the extents in exlist.
> > > + *
> > > + * The intent is that callers will iterate the rmapbt for all of its records
> > > + * for a given owner to generate exlist; and iterate all the blocks of the
> > generate @exlist
> > 
> > > + * metadata structures that are not being rebuilt and have the same rmapbt
> > > + * owner to generate sublist.  This routine subtracts all the extents
> > generate @sublist.
> > 
> > > + * mentioned in sublist from all the extents linked in exlist, which leaves
> > > + * exlist as the list of blocks that are not accounted for, which we assume
> > > + * are the dead blocks of the old metadata structure.  The blocks mentioned in
> > > + * exlist can be reaped.
> > > + */
> > > +#define XFS_REPAIR_EXT_LEFT_CONTIG	(1 << 0)
> > > +#define XFS_REPAIR_EXT_RIGHT_CONTIG	(1 << 1)
> > > +int
> > > +xfs_repair_subtract_extents(
> > > +	struct xfs_scrub_context	*sc,
> > > +	struct xfs_repair_extent_list	*exlist,
> > > +	struct xfs_repair_extent_list	*sublist)
> > > +{
> > > +	struct list_head		*lp;
> > > +	struct xfs_repair_extent	*ex;
> > > +	struct xfs_repair_extent	*newex;
> > > +	struct xfs_repair_extent	*subex;
> > > +	xfs_fsblock_t			sub_fsb;
> > > +	xfs_extlen_t			sub_len;
> > > +	int				state;
> > > +	int				error = 0;
> > > +
> > > +	if (list_empty(&exlist->list) || list_empty(&sublist->list))
> > > +		return 0;
> > > +	ASSERT(!list_empty(&sublist->list));
> > > +
> > > +	list_sort(NULL, &exlist->list, xfs_repair_btree_extent_cmp);
> > > +	list_sort(NULL, &sublist->list, xfs_repair_btree_extent_cmp);
> > > +
> > > +	subex = list_first_entry(&sublist->list, struct xfs_repair_extent,
> > > +			list);
> > > +	lp = exlist->list.next;
> > > +	while (lp != &exlist->list) {
> > > +		ex = list_entry(lp, struct xfs_repair_extent, list);
> > > +
> > > +		/*
> > > +		 * Advance subex and/or ex until we find a pair that
> > > +		 * intersect or we run out of extents.
> > > +		 */
> > > +		while (subex->fsbno + subex->len <= ex->fsbno) {
> > > +			if (list_is_last(&subex->list, &sublist->list))
> > > +				goto out;
> > > +			subex = list_next_entry(subex, list);
> > > +		}
> > So this is a O(n^2) algorithm, right? How does it scale with large
> > extent lists? Given that these extents are dynamically allocated,
> > and we're already burning 16 bytes for a list head on each extent,
> > would it be better to use a smarter structure better suited for
> > exact lookups? e.g. an rbtree only takes an extra 8 bytes per
> > extent, and we get O(log N) searches on the inner loop here...
> > 
> > I guess this isn't necessary to fix right now, but I think it's
> > going to be an issue for maybe mark this down as "needing to be
> > fixed before removing EXPERIMENTAL tags"?
> > 
> > > +		if (subex->fsbno >= ex->fsbno + ex->len) {
> > > +			lp = lp->next;
> > > +			continue;
> > > +		}
> > > +
> > > +		/* trim subex to fit the extent we have */
> > > +		sub_fsb = subex->fsbno;
> > > +		sub_len = subex->len;
> > > +		if (subex->fsbno < ex->fsbno) {
> > > +			sub_len -= ex->fsbno - subex->fsbno;
> > > +			sub_fsb = ex->fsbno;
> > > +		}
> > > +		if (sub_len > ex->len)
> > > +			sub_len = ex->len;
> > > +
> > > +		state = 0;
> > > +		if (sub_fsb == ex->fsbno)
> > > +			state |= XFS_REPAIR_EXT_LEFT_CONTIG;
> > > +		if (sub_fsb + sub_len == ex->fsbno + ex->len)
> > > +			state |= XFS_REPAIR_EXT_RIGHT_CONTIG;
> > Ok, I think "CONTIG" is not the right word to use here. In the BMAP
> > btrees, the merge state flags were to tell us whether the edge of
> > the new extent is contiguous with the left and right extents in
> > the tree, not whether the new extents overlapped to the left/right
> > edges.
> > 
> > i.e. we're checking whether extent start/end overlaps are aligned
> > here, not whether they are contiguous with some other extent. So in
> > this case, I'd just name the variables "LEFT_ALIGNED" and
> > "RIGHT_ALIGNED" and drop all the namespace bits from them.
> > 
> > > +		switch (state) {
> > > +		case XFS_REPAIR_EXT_LEFT_CONTIG:
> > > +			/* Coincides with only the left. */
> > And by calling them aligned, the comments become redundant:
> > 
> > 		case LEFT_ALIGNED:
> > > +			ex->fsbno += sub_len;
> > > +			ex->len -= sub_len;
> > > +			break;
> > > +		case XFS_REPAIR_EXT_RIGHT_CONTIG:
> > > +			/* Coincides with only the right. */
> > > +			ex->len -= sub_len;
> > > +			lp = lp->next;
> > > +			break;
> > > +		case XFS_REPAIR_EXT_LEFT_CONTIG | XFS_REPAIR_EXT_RIGHT_CONTIG:
> > > +			/* Total overlap, just delete ex. */
> > > +			lp = lp->next;
> > > +			list_del(&ex->list);
> > > +			kmem_free(ex);
> > > +			break;
> > > +		case 0:
> > > +			/*
> > > +			 * Deleting from the middle: add the new right extent
> > > +			 * and then shrink the left extent.
> > > +			 */
> > > +			newex = kmem_alloc(sizeof(struct xfs_repair_extent),
> > > +					KM_MAYFAIL);
> > > +			if (!newex) {
> > > +				error = -ENOMEM;
> > > +				goto out;
> > > +			}
> > > +			INIT_LIST_HEAD(&newex->list);
> > > +			newex->fsbno = sub_fsb + sub_len;
> > > +			newex->len = ex->len - (sub_fsb - ex->fsbno) - sub_len;
> > so: new len = old len - (length of first extent) - length of overlap.
> > 
> > I think this is more obvious as "new len = old end - new start", i.e.:
> > 
> > 			newex->len = ex->fsbno + ex->len - newex->fsbno;
> > 
> > Cheers,
> > 
> > Dave.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
