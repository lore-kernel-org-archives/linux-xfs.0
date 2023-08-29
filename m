Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B88AC71153
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Aug 2023 15:50:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232573AbjH2PuZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Aug 2023 11:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236304AbjH2PuN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2023 11:50:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2D43113
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2023 08:50:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7327C61309
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2023 15:50:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5FFDC433C8;
        Tue, 29 Aug 2023 15:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693324208;
        bh=DlzSYjY/Nr2rJHYLaJdWdZ1LI1krT1S3WpPbJkDqgU8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D3hAk8/led2qmbWtGa87dDqJg5vegbDb++qEw4n/M4nAhLUy3kcucDre3jEQTSQwL
         OLcupY46NqzmbWvC02LUWAr6OT1K501p+NwjE+QqKdv84PWg0UGY7LD014GW4a//Ta
         4SPM3wCGluz5li1hG6F/qeGsA33KUq9cWTlJVR/A0j0ZDpy6JdGK10HimJRfM6KjIg
         u3HKEqqws8Gg8uvxvuA1+Z2L8zSqvKz65YHGcLKxdLv6HG5QMn432FzAn8bRJqk9FH
         BE3OykGtoEa+41zbKh5ernA4xpMn2B+Js6YDqmH9WZOjPCHbdHpfjE8TW6zk1fI/2z
         zgKfwzrBjiEiQ==
Date:   Tue, 29 Aug 2023 08:50:08 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] [RFC] xfs: reduce AGF hold times during fstrim operations
Message-ID: <20230829155008.GD28186@frogsfrogsfrogs>
References: <20230829065710.938039-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230829065710.938039-1-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 29, 2023 at 04:57:10PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> fstrim will hold the AGF lock for as long as it takes to walk and
> discard all the free space in the AG that meets the userspace trim
> criteria.i For AGs with lots of free space extents (e.g. millions)
> or the underlying device is really slow at processing discard
> requests (e.g. Ceph RBD), this means the AGF hold time is often
> measured in minutes to hours, not a few milliseconds as we normal
> see with non-discard based operations.
> 
> THis can result in the entire filesystem hanging whilst the
> long-running fstrim is in progress. We can have transactions get
> stuck waiting for the AGF lock (data or metadata extent allocation
> and freeing), and then more transactions get stuck waiting on the
> locks those transactions hold. We can get to the point where fstrim
> blocks an extent allocation or free operation long enough that it
> ends up pinning the tail of the log and the log then runs out of
> space. At this point, every modification in the filesystem gets
> blocked. This includes read operations, if atime updates need to be
> made.
> 
> To fix this problem, we need to be able to discard free space
> extents safely without holding the AGF lock. Fortunately, we already
> do this with online discard via busy extents. We can makr free space

s/makr/mark/

> extents as "busy being discarded" under the AGF lock and then unlock
> the AGF, knowing that nobody will be able to allocate that free
> space extent until we remove it from the busy tree.
> 
> Modify xfs_trim_extents to use the same asynchronous discard
> mechanism backed by busy extents as is used with online discard.
> This results in the AGF only needing to be held for short periods of
> time and it is never held while we issue discards. Hence if discard
> submission gets throttled because it is slow and/or there are lots
> of them, we aren't preventing other operations from being performed
> on AGF while we wait for discards to complete...

Oh good, because FSTRIM is dog slow even when you don't have other
threads impatiently waiting on the AGF. :)

(Hello, QVO...)

> This is an RFC because it's just the patch I've written to implement
> the functionality and smoke test it. It isn't polished, I haven't
> broken it up into fine-grained patches, etc. It's just a chunk of
> code that fixes the problem so people can comment on the approach
> and maybe spot something wrong that I haven't. IOWs, I'm looking for
> comments on the functionality change, not the code itself....

IOWs I don't have to wade through six patches of code golf just to
figure out what this does.  Much easier to review, thank you.

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_discard.c     | 274 ++++++++++++++++++++++++++++++++++++---
>  fs/xfs/xfs_extent_busy.c |  33 ++++-
>  fs/xfs/xfs_extent_busy.h |   4 +
>  3 files changed, 286 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
> index afc4c78b9eed..c2eec29c02d1 100644
> --- a/fs/xfs/xfs_discard.c
> +++ b/fs/xfs/xfs_discard.c
> @@ -1,6 +1,6 @@
>  // SPDX-License-Identifier: GPL-2.0
>  /*
> - * Copyright (C) 2010 Red Hat, Inc.
> + * Copyright (C) 2010, 2023 Red Hat, Inc.
>   * All Rights Reserved.
>   */
>  #include "xfs.h"
> @@ -19,21 +19,81 @@
>  #include "xfs_log.h"
>  #include "xfs_ag.h"
>  
> -STATIC int
> -xfs_trim_extents(
> +/*
> + * Notes on an efficient, low latency fstrim algorithm
> + *
> + * We need to walk the filesystem free space and issue discards on the free
> + * space that meet the search criteria (size and location). We cannot issue
> + * discards on extents that might be in use, or are so recently in use they are
> + * still marked as busy. To serialise against extent state changes whilst we are
> + * gathering extents to trim, we must hold the AGF lock to lock out other
> + * allocations and extent free operations that might change extent state.
> + *
> + * However, we cannot just hold the AGF for the entire AG free space walk whilst
> + * we issue discards on each free space that is found. Storage devices can have
> + * extremely slow discard implementations (e.g. ceph RBD) and so walking a
> + * couple of million free extents and issuing synchronous discards on each
> + * extent can take a *long* time. Whilst we are doing this walk, nothing else
> + * can access the AGF, and we can stall transactions and hence the log whilst
> + * modifications wait for the AGF lock to be released. This can lead hung tasks
> + * kicking the hung task timer and rebooting the system. This is bad.
> + *
> + * Hence we need to take a leaf from the bulkstat playbook. It takes the AGI
> + * lock, gathers a range of inode cluster buffers that are allocated, drops the
> + * AGI lock and then reads all the inode cluster buffers and processes them. It
> + * loops doing this, using a cursor to keep track of where it is up to in the AG
> + * for each iteration to restart the INOBT lookup from.
> + *
> + * We can't do this exactly with free space - once we drop the AGF lock, the
> + * state of the free extent is out of our control and we cannot run a discard
> + * safely on it in this situation. Unless, of course, we've marked the free
> + * extent as busy and undergoing a discard operation whilst we held the AGF
> + * locked.
> + *
> + * This is exactly how online discard works - free extents are marked busy when
> + * they are freed, and once the extent free has been committed to the journal,
> + * the busy extent record is marked as "undergoing discard" and the discard is
> + * then issued on the free extent. Once the discard completes, the busy extent
> + * record is removed and the extent is able to be allocated again.
> + *
> + * In the context of fstrim, if we find a free extent we need to discard, we
> + * don't have to discard it immediately. All we need to do it record that free
> + * extent as being busy and under discard, and all the allocation routines will
> + * now avoid trying to allocate it. Hence if we mark the extent as busy under
> + * the AGF lock, we can safely discard it without holding the AGF lock because
> + * nothing will attempt to allocate that free space until the discard completes.

...and if the cntbt search encounters a busy extent, it'll skip it.  I
think that means that two FITRIM invocations running in lockstep can
miss the extents being discarded by the other, right?

I think this can happen with your patch?

T0:				T1:
xfs_alloc_read_agf
walk cntbt,
    add free space to busy list
relse agf
issue discards

				xfs_alloc_read_agf
...still waiting...
				walk cntbt,
				    see all free space on busy list
				relse agf
...still waiting...
				"done" (despite discard in progress)

...still waiting...
io completion
done

Whereas currently I think T1 will stubbornly wait for the AGF and then
re-discard everything again.  I wonder, should FITRIM call
xfs_extent_busy_flush if it finds already-busy extents?

> + *
> + * Hence we can makr fstrim behave much more like bulkstat and online discard

s/makr/make/

> + * w.r.t. AG header locking. By keeping the batch size low, we can minimise the
> + * AGF lock holdoffs whilst still safely being able to issue discards similar to
> + * bulkstat. We can also issue discards asynchronously like we do with online

Can we rearrange that "Similar to bulkstat's inode batching behavior, we
can minimise the AGF lock holdoffs [hold times?] whilst safely issuing
discards."

My hot take on that sentence was "bulkstat doesn't do discards" :)

> + * discard, and so for fast devices fstrim will run much faster as we can
> + * pipeline the free extent search with in flight discard IO.
> + */
> +
> +struct xfs_trim_work {
> +	struct xfs_perag	*pag;
> +	struct list_head	busy_extents;
> +	uint64_t		blocks_trimmed;
> +	struct work_struct	discard_endio_work;
> +};
> +
> +static int
> +xfs_trim_gather_extents(
>  	struct xfs_perag	*pag,
>  	xfs_daddr_t		start,
>  	xfs_daddr_t		end,
>  	xfs_daddr_t		minlen,
> -	uint64_t		*blocks_trimmed)
> +	xfs_extlen_t		*longest,

What is this @longest value?  Is that a cursor for however far we've
walked through the cntbt?

> +	struct xfs_trim_work	*twork)
>  {
>  	struct xfs_mount	*mp = pag->pag_mount;
> -	struct block_device	*bdev = mp->m_ddev_targp->bt_bdev;
>  	struct xfs_btree_cur	*cur;
>  	struct xfs_buf		*agbp;
>  	struct xfs_agf		*agf;
>  	int			error;
>  	int			i;
> +	int			batch = 100;
>  
>  	/*
>  	 * Force out the log.  This means any transactions that might have freed
> @@ -50,17 +110,27 @@ xfs_trim_extents(
>  	cur = xfs_allocbt_init_cursor(mp, NULL, agbp, pag, XFS_BTNUM_CNT);
>  
>  	/*
> -	 * Look up the longest btree in the AGF and start with it.
> +	 * Look up the extent length requested in the AGF and start with it.
> +	 *
> +	 * XXX: continuations really want a lt lookup here, so we get the
> +	 * largest extent adjacent to the size finished off in the last batch.
> +	 * The ge search here results in the extent discarded in the last batch
> +	 * being discarded again before we move on to the smaller size...
>  	 */
> -	error = xfs_alloc_lookup_ge(cur, 0, be32_to_cpu(agf->agf_longest), &i);
> +	error = xfs_alloc_lookup_ge(cur, 0, *longest, &i);

Aha, it /is/ a cursor for the cntbt walk.  In that case, why not pass
around a xfs_alloc_rec_incore_t as the cursor, since cntbt lookups are
capable of searching by blockcount and startblock?

Then you'd initialize it with

struct xfs_alloc_rec_incore tcur = {
	.ar_blockcount = pag->pagf_longest;
};

and the XXX above turns into:

if (!tcur->ar_startblock)
	error = xfs_alloc_lookup_ge(cur, 0, tcur->ar_blockcount, &i);
else
	error = xfs_alloc_lookup_lt(cur, tcur->ar_startblock,
			tcur->ar_blockcount, &i);

>  	if (error)
>  		goto out_del_cursor;
> +	if (i == 0) {
> +		/* nothing of that length left in the AG, we are done */
> +		*longest = 0;
> +		goto out_del_cursor;
> +	}
>  
>  	/*
>  	 * Loop until we are done with all extents that are large
> -	 * enough to be worth discarding.
> +	 * enough to be worth discarding or we hit batch limits.
>  	 */
> -	while (i) {
> +	while (i && batch-- > 0) {
>  		xfs_agblock_t	fbno;
>  		xfs_extlen_t	flen;
>  		xfs_daddr_t	dbno;
> @@ -75,6 +145,20 @@ xfs_trim_extents(
>  		}
>  		ASSERT(flen <= be32_to_cpu(agf->agf_longest));
>  
> +		/*
> +		 * Keep going on this batch until we hit the record size
> +		 * changes. That way we will start the next batch with the new
> +		 * extent size and we don't get stuck on an extent size when
> +		 * there are more extents of that size than the batch size.
> +		 */
> +		if (batch == 0) {
> +			if (flen != *longest)
> +				break;
> +			batch++;

Hmm.  So if the cntbt records are:

[N1, 100000]
[N2, 1]
[N3, 1]
...
[N100001, 1]

Does that mean batch 1 is:

[N1, 100000]

and batch 2 is:

<100,000 single block extents>

(where presumably N1..N100001 do not overlap)?

That seems poorly balanced, especially for (bad) SSDs whose per-discard
runtime is y = mx + b with a small m and huge b.

(Yes I have an SSD like that...)

I think if you changed the cursor to a cntbt record, then you could
bound the batch size by number of blocks, or number of busy extents,
or both, right?

> +		} else {
> +			*longest = flen;
> +		}
> +
>  		/*
>  		 * use daddr format for all range/len calculations as that is
>  		 * the format the range/len variables are supplied in by
> @@ -88,6 +172,7 @@ xfs_trim_extents(
>  		 */
>  		if (dlen < minlen) {
>  			trace_xfs_discard_toosmall(mp, pag->pag_agno, fbno, flen);
> +			*longest = 0;
>  			break;
>  		}
>  
> @@ -110,29 +195,180 @@ xfs_trim_extents(
>  			goto next_extent;
>  		}
>  
> -		trace_xfs_discard_extent(mp, pag->pag_agno, fbno, flen);
> -		error = blkdev_issue_discard(bdev, dbno, dlen, GFP_NOFS);
> -		if (error)
> -			break;
> -		*blocks_trimmed += flen;
> -
> +		xfs_extent_busy_insert_discard(pag, fbno, flen,
> +				&twork->busy_extents);
> +		twork->blocks_trimmed += flen;
>  next_extent:
>  		error = xfs_btree_decrement(cur, 0, &i);
>  		if (error)
>  			break;
>  
> -		if (fatal_signal_pending(current)) {
> -			error = -ERESTARTSYS;
> -			break;
> -		}
> +		/*
> +		 * If there's no more records in the tree, we are done. Set
> +		 * longest to 0 to indicate to the caller that there is no more
> +		 * extents to search.
> +		 */
> +		if (i == 0)
> +			*longest = 0;
>  	}
>  
> +	/*
> +	 * If there was an error, release all the gathered busy extents because
> +	 * we aren't going to issue a discard on them any more. If we ran out of
> +	 * records, set *longest to zero to tell the caller there is nothing
> +	 * left in this AG.
> +	 */
> +	if (error)
> +		xfs_extent_busy_clear(pag->pag_mount, &twork->busy_extents,
> +				false);
>  out_del_cursor:
>  	xfs_btree_del_cursor(cur, error);
>  	xfs_buf_relse(agbp);
>  	return error;
>  }
>  
> +static void
> +xfs_trim_discard_endio_work(
> +	struct work_struct	*work)
> +{
> +	struct xfs_trim_work	*twork =
> +		container_of(work, struct xfs_trim_work, discard_endio_work);
> +	struct xfs_perag	*pag = twork->pag;
> +
> +	xfs_extent_busy_clear(pag->pag_mount, &twork->busy_extents, false);
> +	kmem_free(twork);
> +	xfs_perag_rele(pag);
> +}
> +
> +/*
> + * Queue up the actual completion to a thread to avoid IRQ-safe locking for
> + * pagb_lock.
> + */
> +static void
> +xfs_trim_discard_endio(
> +	struct bio		*bio)
> +{
> +	struct xfs_trim_work	*twork = bio->bi_private;
> +
> +	INIT_WORK(&twork->discard_endio_work, xfs_trim_discard_endio_work);
> +	queue_work(xfs_discard_wq, &twork->discard_endio_work);
> +	bio_put(bio);
> +}
> +
> +/*
> + * Walk the discard list and issue discards on all the busy extents in the
> + * list. We plug and chain the bios so that we only need a single completion
> + * call to clear all the busy extents once the discards are complete.
> + *
> + * XXX: This is largely a copy of xlog_discard_busy_extents(), opportunity for
> + * a common implementation there.

Indeed. :)

> + */
> +static int
> +xfs_trim_discard_extents(
> +	struct xfs_perag	*pag,
> +	struct xfs_trim_work	*twork)
> +{
> +	struct xfs_mount	*mp = pag->pag_mount;
> +	struct xfs_extent_busy	*busyp;
> +	struct bio		*bio = NULL;
> +	struct blk_plug		plug;
> +	int			error = 0;
> +
> +	blk_start_plug(&plug);
> +	list_for_each_entry(busyp, &twork->busy_extents, list) {
> +		trace_xfs_discard_extent(mp, busyp->agno, busyp->bno,
> +					 busyp->length);
> +
> +		error = __blkdev_issue_discard(mp->m_ddev_targp->bt_bdev,
> +				XFS_AGB_TO_DADDR(mp, busyp->agno, busyp->bno),
> +				XFS_FSB_TO_BB(mp, busyp->length),
> +				GFP_NOFS, &bio);
> +		if (error && error != -EOPNOTSUPP) {
> +			xfs_info(mp,
> +	 "discard failed for extent [0x%llx,%u], error %d",
> +				 (unsigned long long)busyp->bno,
> +				 busyp->length,
> +				 error);
> +			break;
> +		}
> +	}
> +
> +	if (bio) {
> +		bio->bi_private = twork;
> +		bio->bi_end_io = xfs_trim_discard_endio;
> +		submit_bio(bio);
> +	} else {
> +		xfs_trim_discard_endio_work(&twork->discard_endio_work);
> +	}
> +	blk_finish_plug(&plug);
> +
> +	return error;
> +}
> +
> +/*
> + * Iterate the free list gathering extents and discarding them. We need a cursor
> + * for the repeated iteration of gather/discard loop, so use the longest extent
> + * we found in the last batch as the key to start the next.
> + */
> +static int
> +xfs_trim_extents(
> +	struct xfs_perag	*pag,
> +	xfs_daddr_t		start,
> +	xfs_daddr_t		end,
> +	xfs_daddr_t		minlen,
> +	uint64_t		*blocks_trimmed)
> +{
> +	struct xfs_trim_work	*twork;
> +	xfs_extlen_t		longest = pag->pagf_longest;
> +	int			error = 0;
> +
> +	do {
> +		LIST_HEAD(extents);
> +
> +		twork = kzalloc(sizeof(*twork), GFP_KERNEL);
> +		if (!twork) {
> +			error = -ENOMEM;
> +			break;
> +		}
> +
> +		atomic_inc(&pag->pag_active_ref);
> +		twork->pag = pag;

twork->pag = xfs_perag_hold(pag); ?

> +		INIT_LIST_HEAD(&twork->busy_extents);
> +
> +		error = xfs_trim_gather_extents(pag, start, end, minlen,
> +				&longest, twork);
> +		if (error) {
> +			kfree(twork);
> +			xfs_perag_rele(pag);
> +			break;
> +		}
> +
> +		/*
> +		 * We hand the trim work to the discard function here so that
> +		 * the busy list can be walked when the discards complete and
> +		 * removed from the busy extent list. This allows the discards
> +		 * to run asynchronously with gathering the next round of
> +		 * extents to discard.
> +		 *
> +		 * However, we must ensure that we do not reference twork after
> +		 * this function call, as it may have been freed by the time it
> +		 * returns control to us.
> +		 */
> +		*blocks_trimmed += twork->blocks_trimmed;
> +		error = xfs_trim_discard_extents(pag, twork);
> +		if (error)
> +			break;
> +
> +		if (fatal_signal_pending(current)) {
> +			error = -ERESTARTSYS;
> +			break;
> +		}
> +	} while (longest != 0);
> +
> +	return error;
> +
> +}
> +
>  /*
>   * trim a range of the filesystem.
>   *
> diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
> index 7c2fdc71e42d..53c49b47daca 100644
> --- a/fs/xfs/xfs_extent_busy.c
> +++ b/fs/xfs/xfs_extent_busy.c
> @@ -19,13 +19,13 @@
>  #include "xfs_log.h"
>  #include "xfs_ag.h"
>  
> -void
> -xfs_extent_busy_insert(
> -	struct xfs_trans	*tp,
> +static void
> +xfs_extent_busy_insert_list(
>  	struct xfs_perag	*pag,
>  	xfs_agblock_t		bno,
>  	xfs_extlen_t		len,
> -	unsigned int		flags)
> +	unsigned int		flags,
> +	struct list_head	*busy_list)
>  {
>  	struct xfs_extent_busy	*new;
>  	struct xfs_extent_busy	*busyp;
> @@ -40,7 +40,7 @@ xfs_extent_busy_insert(
>  	new->flags = flags;
>  
>  	/* trace before insert to be able to see failed inserts */
> -	trace_xfs_extent_busy(tp->t_mountp, pag->pag_agno, bno, len);
> +	trace_xfs_extent_busy(pag->pag_mount, pag->pag_agno, bno, len);
>  
>  	spin_lock(&pag->pagb_lock);
>  	rbp = &pag->pagb_tree.rb_node;
> @@ -62,10 +62,31 @@ xfs_extent_busy_insert(
>  	rb_link_node(&new->rb_node, parent, rbp);
>  	rb_insert_color(&new->rb_node, &pag->pagb_tree);
>  
> -	list_add(&new->list, &tp->t_busy);
> +	list_add(&new->list, busy_list);
>  	spin_unlock(&pag->pagb_lock);
>  }
>  
> +void
> +xfs_extent_busy_insert(
> +	struct xfs_trans	*tp,
> +	struct xfs_perag	*pag,
> +	xfs_agblock_t		bno,
> +	xfs_extlen_t		len,
> +	unsigned int		flags)
> +{
> +	xfs_extent_busy_insert_list(pag, bno, len, flags, &tp->t_busy);
> +}
> +
> +void xfs_extent_busy_insert_discard(

Function name on newline.

> +	struct xfs_perag	*pag,
> +	xfs_agblock_t		bno,
> +	xfs_extlen_t		len,
> +	struct list_head	*busy_list)
> +{
> +	xfs_extent_busy_insert_list(pag, bno, len, XFS_EXTENT_BUSY_DISCARDED,
> +			busy_list);
> +}
> +
>  /*
>   * Search for a busy extent within the range of the extent we are about to
>   * allocate.  You need to be holding the busy extent tree lock when calling
> diff --git a/fs/xfs/xfs_extent_busy.h b/fs/xfs/xfs_extent_busy.h
> index c37bf87e6781..f99073208770 100644
> --- a/fs/xfs/xfs_extent_busy.h
> +++ b/fs/xfs/xfs_extent_busy.h
> @@ -35,6 +35,10 @@ void
>  xfs_extent_busy_insert(struct xfs_trans *tp, struct xfs_perag *pag,
>  	xfs_agblock_t bno, xfs_extlen_t len, unsigned int flags);
>  
> +void
> +xfs_extent_busy_insert_discard(struct xfs_perag *pag, xfs_agblock_t bno,
> +	xfs_extlen_t len, struct list_head *busy_list);
> +
>  void
>  xfs_extent_busy_clear(struct xfs_mount *mp, struct list_head *list,
>  	bool do_discard);
> -- 
> 2.40.1
> 
