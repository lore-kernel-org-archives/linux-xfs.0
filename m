Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:3006 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750740AbeAOXtp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Jan 2018 18:49:45 -0500
Date: Tue, 16 Jan 2018 10:49:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 18/21] xfs: cross-reference the rmapbt data with the
 refcountbt
Message-ID: <20180115234928.GD16421@dastard>
References: <151398977028.18741.12031215574014508438.stgit@magnolia>
 <151398988306.18741.8223158735554937583.stgit@magnolia>
 <20180109212517.GM5602@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180109212517.GM5602@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 09, 2018 at 01:25:17PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Cross reference the refcount data with the rmap data to check that the
> number of rmaps for a given block match the refcount of that block, and
> that CoW blocks (which are owned entirely by the refcountbt) are tracked
> as well.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: streamline scrubber arguments, remove stack allocated objects
> ---
>  fs/xfs/scrub/refcount.c |  318 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 316 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
> index 700f8f1..df18e47 100644
> --- a/fs/xfs/scrub/refcount.c
> +++ b/fs/xfs/scrub/refcount.c
> @@ -50,6 +50,274 @@ xfs_scrub_setup_ag_refcountbt(
>  
>  /* Reference count btree scrubber. */
>  
> +/*
> + * Confirming Reference Counts via Reverse Mappings
> + *
> + * We want to count the reverse mappings overlapping a refcount record
> + * (bno, len, refcount), allowing for the possibility that some of the
> + * overlap may come from smaller adjoining reverse mappings, while some
> + * comes from single extents which overlap the range entirely.  The
> + * outer loop is as follows:
> + *
> + * 1. For all reverse mappings overlapping the refcount extent,
> + *    a. If a given rmap completely overlaps, mark it as seen.
> + *    b. Otherwise, record the fragment for later processing.
> + *
> + * Once we've seen all the rmaps, we know that for all blocks in the
> + * refcount record we want to find $refcount owners and we've already
> + * visited $seen extents that overlap all the blocks.  Therefore, we
> + * need to find ($refcount - $seen) owners for every block in the
> + * extent; call that quantity $target_nr.  Proceed as follows:
> + *
> + * 2. Pull the first $target_nr fragments from the list; all of them
> + *    should start at or before the start of the extent.
> + *    Call this subset of fragments the working set.
> + * 3. Until there are no more unprocessed fragments,
> + *    a. Find the shortest fragments in the set and remove them.
> + *    b. Note the block number of the end of these fragments.
> + *    c. Pull the same number of fragments from the list.  All of these
> + *       fragments should start at the block number recorded in the
> + *       previous step.
> + *    d. Put those fragments in the set.
> + * 4. Check that there are $target_nr fragments remaining in the list,
> + *    and that they all end at or beyond the end of the refcount extent.
> + *
> + * If the refcount is correct, all the check conditions in the algorithm
> + * should always hold true.  If not, the refcount is incorrect.

This needs a comment somewhere in here describing the order of
the records on the fragment list. AFAICT, it's ordered by start
bno, but I'm not 100% sure and it seems the code is dependent on
strict ordering of records the frag list....

.....

> +	} else {
> +		/*
> +		 * This rmap covers only part of the refcount record, so
> +		 * save the fragment for later processing.
> +		 */
> +		frag = kmem_alloc(sizeof(struct xfs_scrub_refcnt_frag),
> +				KM_MAYFAIL | KM_NOFS);
> +		if (!frag)
> +			return -ENOMEM;
> +		memcpy(&frag->rm, rec, sizeof(frag->rm));
> +		list_add_tail(&frag->list, &refchk->fragments);

I'm making the assumption here that we're seeing records in the
order they are in the rmap tree and that it's in increase startblock
order, hence the list is ordered that way....

> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * Given a bunch of rmap fragments, iterate through them, keeping
> + * a running tally of the refcount.  If this ever deviates from
> + * what we expect (which is the refcountbt's refcount minus the
> + * number of extents that totally covered the refcountbt extent),
> + * we have a refcountbt error.
> + */
> +STATIC void
> +xfs_scrub_refcountbt_process_rmap_fragments(
> +	struct xfs_scrub_refcnt_check	*refchk)
> +{
> +	struct list_head		worklist;
> +	struct xfs_scrub_refcnt_frag	*frag;
> +	struct xfs_scrub_refcnt_frag	*n;
> +	xfs_agblock_t			bno;
> +	xfs_agblock_t			rbno;
> +	xfs_agblock_t			next_rbno;
> +	xfs_nlink_t			nr;
> +	xfs_nlink_t			target_nr;
> +
> +	target_nr = refchk->refcount - refchk->seen;
> +	if (target_nr == 0)
> +		return;
> +
> +	/*
> +	 * There are (refchk->rc.rc_refcount - refchk->nr refcount)
> +	 * references we haven't found yet.  Pull that many off the
> +	 * fragment list and figure out where the smallest rmap ends
> +	 * (and therefore the next rmap should start).  All the rmaps
> +	 * we pull off should start at or before the beginning of the
> +	 * refcount record's range.
> +	 */
> +	INIT_LIST_HEAD(&worklist);
> +	rbno = NULLAGBLOCK;
> +	nr = 1;
> +
> +	/* Find all the rmaps that start at or before the refc extent. */
> +	list_for_each_entry_safe(frag, n, &refchk->fragments, list) {
> +		if (frag->rm.rm_startblock > refchk->bno)
> +			goto done;

.... and is where the code implies lowest to highest startblock
ordering on the frag list.

> +		bno = frag->rm.rm_startblock + frag->rm.rm_blockcount;
> +		if (rbno > bno)
> +			rbno = bno;

Can we put that check the other way around? we're looking for the
shortest/smallest end block, so

		if (bno < rbno)
			rbno = bno;

Makes a lot more sense to me.

> +		list_del(&frag->list);
> +		list_add_tail(&frag->list, &worklist);

list_move_tail()?

Ok, so we are moving fragments that start before the recount bno to
the work list.

> +		if (nr == target_nr)
> +			break;
> +		nr++;
> +	}
> +
> +	/*
> +	 * We should have found exactly $target_nr rmap fragments starting
> +	 * at or before the refcount extent.
> +	 */
> +	if (nr != target_nr)
> +		goto done;

ok. so on error we clean up and free the frag list and work list....

> +
> +	while (!list_empty(&refchk->fragments)) {
> +		/* Discard any fragments ending at rbno. */
> +		nr = 0;
> +		next_rbno = NULLAGBLOCK;
> +		list_for_each_entry_safe(frag, n, &worklist, list) {

Ok, this needs to be clearer than it's walking the working set
of fragments. I had to read this code several times before I worked
out this is where the "working set" was being processed....

> +			bno = frag->rm.rm_startblock + frag->rm.rm_blockcount;
> +			if (bno != rbno) {
> +				if (next_rbno > bno)
> +					next_rbno = bno;

Same comment here about being a next_rbno "smallest bno" variable.

> +				continue;
> +			}
> +			list_del(&frag->list);
> +			kmem_free(frag);
> +			nr++;
> +		}
> +
> +		/* Empty list?  We're done. */
> +		if (list_empty(&refchk->fragments))
> +			break;
> +
> +		/* Try to add nr rmaps starting at rbno to the worklist. */
> +		list_for_each_entry_safe(frag, n, &refchk->fragments, list) {
> +			bno = frag->rm.rm_startblock + frag->rm.rm_blockcount;
> +			if (frag->rm.rm_startblock != rbno)
> +				goto done;

definitely assuming the frag list is ordered here :P

> +			list_del(&frag->list);
> +			list_add_tail(&frag->list, &worklist);
> +			if (next_rbno > bno)
> +				next_rbno = bno;
> +			nr--;
> +			if (nr == 0)
> +				break;
> +		}

Ok, so if we get here with nr > 0, then we must have emptied the
fragment list onto the work list, right? At this point, the outer
loop will terminate. Don't we need to run the worklist processing
loop one last time?

> +		rbno = next_rbno;
> +	}

.....
> +/* Use the rmap entries covering this extent to verify the refcount. */
> +STATIC void
> +xfs_scrub_refcountbt_xref_rmap(
> +	struct xfs_scrub_context	*sc,
> +	xfs_agblock_t			bno,
> +	xfs_extlen_t			len,
> +	xfs_nlink_t			refcount)
> +{
> +	struct xfs_scrub_refcnt_check	refchk = {
> +		.sc = sc,
> +		.bno = bno,
> +		.len = len,
> +		.refcount = refcount,
> +		.seen = 0,
> +	};
> +	struct xfs_rmap_irec		low;
> +	struct xfs_rmap_irec		high;
> +	struct xfs_scrub_refcnt_frag	*frag;
> +	struct xfs_scrub_refcnt_frag	*n;
> +	int				error;
> +
> +	if (!sc->sa.rmap_cur)
> +		return;
> +
> +	/* Cross-reference with the rmapbt to confirm the refcount. */
> +	memset(&low, 0, sizeof(low));
> +	low.rm_startblock = bno;
> +	memset(&high, 0xFF, sizeof(high));
> +	high.rm_startblock = bno + len - 1;

This range query init feels like a familiar pattern now. Helper
function (separate patch)?

....

> +/* Make sure we have as many refc blocks as the rmap says. */
> +STATIC void
> +xfs_scrub_refcount_xref_rmap(
> +	struct xfs_scrub_context	*sc,
> +	struct xfs_owner_info		*oinfo,
> +	xfs_filblks_t			cow_blocks)
> +{
> +	xfs_extlen_t			refcbt_blocks = 0;
> +	xfs_filblks_t			blocks;
> +	int				error;
> +
> +	/* Check that we saw as many refcbt blocks as the rmap knows about. */
> +	error = xfs_btree_count_blocks(sc->sa.refc_cur, &refcbt_blocks);
> +	if (!xfs_scrub_btree_process_error(sc, sc->sa.refc_cur, 0, &error))
> +		return;
> +	error = xfs_scrub_count_rmap_ownedby_ag(sc, sc->sa.rmap_cur, oinfo,
> +			&blocks);
> +	if (xfs_scrub_should_check_xref(sc, &error, &sc->sa.rmap_cur) &&
> +	    blocks != refcbt_blocks)
> +		xfs_scrub_btree_xref_set_corrupt(sc, sc->sa.rmap_cur, 0);
> +
> +	if (!sc->sa.rmap_cur)
> +		return;
> +
> +	/* Check that we saw as many cow blocks as the rmap knows about. */
> +	xfs_rmap_ag_owner(oinfo, XFS_RMAP_OWN_COW);
> +	error = xfs_scrub_count_rmap_ownedby_ag(sc, sc->sa.rmap_cur, oinfo,
> +			&blocks);
> +	if (xfs_scrub_should_check_xref(sc, &error, &sc->sa.rmap_cur) &&
> +	    blocks != cow_blocks)
> +		xfs_scrub_btree_xref_set_corrupt(sc, sc->sa.rmap_cur, 0);

Bit of a landmine that this code changes the owner info structure
that was passed in....

> +}
> +
>  /* Scrub the refcount btree for some AG. */
>  int
>  xfs_scrub_refcountbt(
>  	struct xfs_scrub_context	*sc)
>  {
>  	struct xfs_owner_info		oinfo;
> +	xfs_agblock_t			cow_blocks = 0;
> +	int				error;
>  
>  	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_REFC);
> -	return xfs_scrub_btree(sc, sc->sa.refc_cur, xfs_scrub_refcountbt_rec,
> -			&oinfo, NULL);
> +	error = xfs_scrub_btree(sc, sc->sa.refc_cur, xfs_scrub_refcountbt_rec,
> +			&oinfo, &cow_blocks);
> +	if (error)
> +		return error;
> +
> +	if (sc->sa.rmap_cur)
> +		xfs_scrub_refcount_xref_rmap(sc, &oinfo, cow_blocks);

.... because that's not obvious in this code here if we add anymore
code after this call.

> +
> +	return error;

error is zero here, so "return 0" instead?

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
