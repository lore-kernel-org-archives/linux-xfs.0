Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4KKDM6R225668 for <xfs@oss.sgi.com>; Thu, 20 May 2010 15:13:23 -0500
Subject: Re: [PATCH 07/12] xfs: Improve scalability of busy extent tracking
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1274138668-1662-8-git-send-email-david@fromorbit.com>
References: <1274138668-1662-1-git-send-email-david@fromorbit.com>
	<1274138668-1662-8-git-send-email-david@fromorbit.com>
Date: Thu, 20 May 2010 15:15:38 -0500
Message-ID: <1274386538.2095.148.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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

On Tue, 2010-05-18 at 09:24 +1000, Dave Chinner wrote:
> When we free a metadata extent, we record it in the per-AG busy
> extent array so that it is not re-used before the freeing
> transaction hits the disk. This array is fixed size, so when it
> overflows we make further allocation transactions synchronous
> because we cannot track more freed extents until those transactions
> hit the disk and are completed. Under heavy mixed allocation and
> freeing workloads with large log buffers, we can overflow this array
> quite easily.

. . .

This is a really good set of changes.  It might have been good
to split into a few separate pieces:
- Marking transactions synchronous rather than forcing the
  log in some situations
- Conversion from fixed array to dynamic rbtree
- Drop the busy chunk stuff from the transaction code

But at this point that would be a lot of needless work.

Many of my remarks below are suggestions for changes to
comments.  But I do have a few things of more substance,
including some suggested changes and (unless I'm missing
something) a real bug.

					-Alex

> Further, the array is sparsely populated, which means that inserts
> need to search for a free slot, and array searches often have to
> search many more slots that are actually used to check all the
> busy extents. Quite inefficient, really.

. . .

> diff --git a/fs/xfs/xfs_ag.h b/fs/xfs/xfs_ag.h
> index abb8222..401f364 100644
> --- a/fs/xfs/xfs_ag.h
> +++ b/fs/xfs/xfs_ag.h

. . .

> @@ -216,7 +222,8 @@ typedef struct xfs_perag {
>  	xfs_agino_t	pagl_leftrec;
>  	xfs_agino_t	pagl_rightrec;
>  #ifdef __KERNEL__
> -	spinlock_t	pagb_lock;	/* lock for pagb_list */
> +	spinlock_t	pagb_lock;	/* lock for pagb_tree */
> +	struct rb_root	pagb_tree;	/* ordered tree of busy extents */

I really think "pagb_busy" would be a better name.  The
fact that it's a tree is immaterial--the role it plays
is recording busy extents.

>  
>  	atomic_t        pagf_fstrms;    /* # of filestreams active in this AG */
>  
> @@ -226,7 +233,6 @@ typedef struct xfs_perag {
>  	int		pag_ici_reclaimable;	/* reclaimable inodes */
>  #endif
>  	int		pagb_count;	/* pagb slots in use */
> -	xfs_perag_busy_t pagb_list[XFS_PAGB_NUM_SLOTS];	/* unstable blocks */
>  } xfs_perag_t;
>  
>  /*
> diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
> index 94cddbf..f8d592b 100644
> --- a/fs/xfs/xfs_alloc.c
> +++ b/fs/xfs/xfs_alloc.c

. . .

> @@ -540,9 +538,16 @@ xfs_alloc_ag_vextent(
>  				be32_to_cpu(agf->agf_length));
>  			xfs_alloc_log_agf(args->tp, args->agbp,
>  						XFS_AGF_FREEBLKS);
> -			/* search the busylist for these blocks */
> -			xfs_alloc_search_busy(args->tp, args->agno,
> -					args->agbno, args->len);
> +			/*
> +			 * Search the busylist for these blocks and mark the
> +			 * transaction as synchronous if blocks are found. This
> +			 * avoids the need to block in due to a synchronous log

                                      ...need to block on a...

> +			 * force to ensure correct ordering as the synchronous
> +			 * transaction will guarantee that for us.
> +			 */
> +			if (xfs_alloc_busy_search(args->mp, args->agno,
> +						args->agbno, args->len))
> +				xfs_trans_set_sync(args->tp);
>  		}
>  		if (!args->isfl)
>  			xfs_trans_mod_sb(args->tp,

. . .

> @@ -1993,10 +1998,17 @@ xfs_alloc_get_freelist(
>  	 * and remain there until the freeing transaction is committed to
>  	 * disk.  Now that we have allocated blocks, this list must be
>  	 * searched to see if a block is being reused.  If one is, then
> -	 * the freeing transaction must be pushed to disk NOW by forcing
> -	 * to disk all iclogs up that transaction's LSN.
> -	 */
> -	xfs_alloc_search_busy(tp, be32_to_cpu(agf->agf_seqno), bno, 1);
> +	 * the freeing transaction must be pushed to disk before this
> +	 * transaction.
> +	 *
> +	 * We do this by setting the current transaction

Funny formatting of the comment here (whatever).  (Here begins
a bunch of things related to spelling and wording in comments.)

> +	 * to a sync transaction which guarantees that the freeing transaction
> +	 * is on disk before this transaction. This is done instead of a
> +	 * synchronous log force here so that we don't sit and wait with
> +	 * the AGF locked in the transaction during the log force.
> +	 */
> +	if (xfs_alloc_busy_search(mp, be32_to_cpu(agf->agf_seqno), bno, 1))
> +		xfs_trans_set_sync(tp);
>  	return 0;
>  }
>  

. . .

> @@ -2479,127 +2491,273 @@ error0:
>   * list is reused, the transaction that freed it must be forced to disk
>   * before continuing to use the block.
>   *
> - * xfs_alloc_mark_busy - add to the per-ag busy list
> - * xfs_alloc_clear_busy - remove an item from the per-ag busy list
> + * xfs_alloc_busy_insert - add to the per-ag busy list
> + * xfs_alloc_busy_clear - remove an item from the per-ag busy list

To me, the name xfs_alloc_busy_remove matches the _insert name better.

> + * xfs_alloc_busy_search - search for a busy extent
> + */
> +
> +/*
> + * Insert a new extent into the busy tree.
> + *

Maybe not here, but I think a brief explanation of the
per-ag busy extent tree might be in order.  For example,
that it's indexed by start address of each extent.  It
is also true that no range of addresses is represented
by more than one entry in the tree, right?  I'm not
sure what would be enough but I think a simple intro
is helpful to give the reader some context.

> + * This is straight forward, except that we can get overlaps with existing busy
> + * extents, and even duplicate busy extents. There are two main cases we have
> + * to handle here.
> + *
> + * The first case is a transaction that triggers a "free - allocate - free"
> + * cycle. This can occur during btree manipulations as a btree block is freed
> + * to the freelist, then allocated from the free list, then freed again. In
> + * this case, the second extnet free is what triggers the duplicate and as such

                  ...second extent free...

> + * the transaction IDs should match. Because the extent was allocated in this
> + * transaction, the transaction must be marked as synchronous. This is true for
> + * all cases where the free/alloc/free occurs in the one transaction, hence the
> + * addition of the ASSERT(tp->t_flags & XFS_TRANS_SYNC) to this case. This
> + * serves to catch violations of the second case quite effectively.
> + *

The next paragraph should be rewritten.  I think it's unclear and
confusing.  Here are a few suggestions.

> + * The second case is where the free/alloc/free occur in different
> + * transactions. In this case, we can't mark the extent busy immediately

                ... In this case, the re-allocating thread can't...

> + * because it is already tracked in a transaction that may be committing.  When
> + * the log commit completes, the busy extent will be removed from the tree. If

  ... the first log commit completes,...

> + * we allow this busy insert to continue using that busy extent structure, it

     ... allow this second busy insert ...

> + * can be freed before this transaction is safely in the log.  Hence our only
> + * option in this case is to force the log to remove the existing busy extent
> + * from the list before we insert the new one with the current transaction ID.

. . .

> + *					*** KABOOM! ***
> + *					....
> + *							log IO completes
> + *							unbusy 1:91909
                                             1:91909 ?????
> + *			checkpoint completes
> + *
> + * By issuing a log force in thread 3 @ "KABOOM", the thread will block until
> + * the checkpoint completes, and the busy extent it matched will have been
> + * removed from the tree when it is woken. Hence it can then continue safely.

. . .

> + * Future: for delayed logging, we could avoid the log force is the extent was

                                                      ... force if ...

> + * first freed in the current checkpoint sequence. This, however, requires the
> + * ability to pin the current checkpoint in memory until this transaction
> + * commits to ensure that both the original free and the current one combine
> + * logically into the one checkpoint. If the checkpoint sequences are
> + * different, however, we still need to wait on a log force.
>   */

OK, now a little more substantive feedback.

As you search the red-black tree in xfs_alloc_busy_insert()
(as well as xfs_alloc_busy_search()), once the value of
match gets set to -1, it will never get set to anything
else.  So once it's set, I'm not sure there's much point
to any further descent into the tree--you found an
overlapping extent in the busy tree, and it's from a
different transaction, so you need to force the log and
try again.

So I think the loop condition could be changed to drop
out if match is negative (I'll show what I mean below).
Doing that would also simplify some of the stuff inside
the loop.

>  void
> -xfs_alloc_mark_busy(xfs_trans_t *tp,
> -		    xfs_agnumber_t agno,
> -		    xfs_agblock_t bno,
> -		    xfs_extlen_t len)
> +xfs_alloc_busy_insert(
> +	struct xfs_trans	*tp,
> +	xfs_agnumber_t		agno,
> +	xfs_agblock_t		bno,
> +	xfs_extlen_t		len)
>  {
> -	xfs_perag_busy_t	*bsy;
> +	struct xfs_busy_extent	*new;
> +	struct xfs_busy_extent	*busyp;
>  	struct xfs_perag	*pag;
> -	int			n;
> +	struct rb_node		**rbp;
> +	struct rb_node		*parent;
> +	xfs_agblock_t		uend, bend;

I can understand what "b" in "bend" might represent.  But
what does "u" mean?

> +	int			match;
>  
> -	pag = xfs_perag_get(tp->t_mountp, agno);
> -	spin_lock(&pag->pagb_lock);
>  
> -	/* search pagb_list for an open slot */
> -	for (bsy = pag->pagb_list, n = 0;
> -	     n < XFS_PAGB_NUM_SLOTS;
> -	     bsy++, n++) {
> -		if (bsy->busy_tp == NULL) {
> -			break;
> -		}
> +	new = kmem_zalloc(sizeof(struct xfs_busy_extent), KM_MAYFAIL);
> +	if (!new) {
> +		/*
> +		 * No Memory!  Since it is now not possible to track the free
> +		 * block, make this a synchronous transaction to insure that
> +		 * the block is not reused before this transaction commits.
> +		 */
> +		trace_xfs_alloc_busy(tp, agno, bno, len, 1);
> +		xfs_trans_set_sync(tp);
> +		return;
>  	}
>  
> -	trace_xfs_alloc_busy(tp->t_mountp, agno, bno, len, n);
> +	new->agno = agno;
> +	new->bno = bno;
> +	new->length = len;
> +	new->tid = xfs_log_get_trans_ident(tp);
>  
> -	if (n < XFS_PAGB_NUM_SLOTS) {
> -		bsy = &pag->pagb_list[n];
> -		pag->pagb_count++;
> -		bsy->busy_start = bno;
> -		bsy->busy_length = len;
> -		bsy->busy_tp = tp;
> -		xfs_trans_add_busy(tp, agno, n);
> -	} else {
> +	INIT_LIST_HEAD(&new->list);
> +
> +	/* trace before insert to be able to see failed inserts */
> +	trace_xfs_alloc_busy(tp, agno, bno, len, 0);
> +
> +	pag = xfs_perag_get(tp->t_mountp, new->agno);
> +	uend = bno + len - 1;
> +restart:
> +	spin_lock(&pag->pagb_lock);
> +	rbp = &pag->pagb_tree.rb_node;
> +	parent = NULL;
> +	busyp = NULL;
> +	match = 0;
> +	while (*rbp) {

          while (match >= 0 && *rbp) {

(Or possibly just break out of the loop below whenever
match gets assigned -1.)

> +		parent = *rbp;
> +		busyp = rb_entry(parent, struct xfs_busy_extent, rb_node);
> +		bend = busyp->bno + busyp->length - 1;

         No need to compute this here.  Compute it where it's needed,
         or just do it inline.

> +
> +		if (new->bno < busyp->bno) {
> +			/* may overlap, but exact start block is lower */
> +			rbp = &(*rbp)->rb_left;
> +			if (uend >= busyp->bno) {
> +				if (busyp->tid != new->tid)
> +					match = -1;

                         Mentioned above--could possibly just break
                         here instead.  Outside the loop, you could
                         check for *rbp != NULL rather than match < 0.

> +				else if (match >= 0)
> +					match = 1;

                                  match = busyp->tid == new->tid ? 1 :
-1;

> +			}
> +		} else if (new->bno > busyp->bno) {
> +			/* may overlap, but exact start block is higher */
> +			rbp = &(*rbp)->rb_right;
> +			if (bno <= bend) {

                          if (bno <= busyp->bno + busyp->length - 1) {

> +				if (busyp->tid != new->tid)
> +					match = -1;
> +				else if (match >= 0)
> +					match = 1;
> +			}
> +		} else {
> +			if (busyp->tid != new->tid)
> +				match = -1;
> +			else if (match >= 0)
> +				match = 1;
> +			break;

                  No need for the break here if you get rid
                  of the reassignment of busyp to NULL (more
                  on this below).

> +		}
> +		busyp = NULL;
> +	}

Right now, the only way you exit this loop with busyp
being non-null is if you exit due to new->bno == busyp->bno.
But that's puzzling, because that suggests that the
if (match > 0) test below would be dereferencing a null
pointer (and maybe that means you haven't seen in your
testing a case of reallocating an extent in the same
transaction you freed it in?).

In any case, what I wanted to say here is that it looks
like you're nulling that pointer just so you can call
kmem_free(busyp) at the end of the function in all cases.
Instead, I think you should just free busyp in the one
case you know you need to--when the starting addresses
of the new and existing busy extents match.  Then drop
the assignment of NULL to busyp.

> +	if (match < 0) {
> +		/* overlap marked busy in different transaction */
> +		spin_unlock(&pag->pagb_lock);
> +		xfs_log_force(tp->t_mountp, XFS_LOG_SYNC);
> +		goto restart;
> +	}
> +	if (match > 0) {
>  		/*
> -		 * The busy list is full!  Since it is now not possible to
> -		 * track the free block, make this a synchronous transaction
> -		 * to insure that the block is not reused before this
> -		 * transaction commits.
> +		 * overlap marked busy in same transaction. Update if exact
> +		 * start block match, otherwise combine the busy extents into
> +		 * a single range.
>  		 */
> -		xfs_trans_set_sync(tp);
> +		if (busyp->bno == new->bno) {

         Dereferencing a null pointer here?

> +			busyp->length = max(busyp->length, new->length);
> +			spin_unlock(&pag->pagb_lock);
> +			ASSERT(tp->t_flags & XFS_TRANS_SYNC);
> +			xfs_perag_put(pag);
> +			kmem_free(new);
> +			return;
> +		}
> +		rb_erase(&busyp->rb_node, &pag->pagb_tree);
> +		new->length = max(busyp->bno + busyp->length,
> +					new->bno + new->length) -
> +				min(busyp->bno, new->bno);
> +		new->bno = min(busyp->bno, new->bno);
>  	}
>  
> +	rb_link_node(&new->rb_node, parent, rbp);
> +	rb_insert_color(&new->rb_node, &pag->pagb_tree);
> +
> +	list_add(&new->list, &tp->t_busy);
>  	spin_unlock(&pag->pagb_lock);
>  	xfs_perag_put(pag);
> +	kmem_free(busyp);

      Move this call up to the only place that needs it.

>  }
>  
> -void
> -xfs_alloc_clear_busy(xfs_trans_t *tp,
> -		     xfs_agnumber_t agno,
> -		     int idx)
> +/*
> + * Search for a busy extent within the range of the extent we are about to
> + * allocate.  You need to be holding the busy extent tree lock when calling
> + * xfs_alloc_busy_search(). This function returns 0 for no overlapping busy
> + * extent, -1 for an overlapping but not exact busy extent, and 1 for an exact
> + * match. This is done so that a non-zero return indicates an overlap that
> + * will require a synchronous transaction, but it can still be
> + * used to distinguish between a partial or exact match.
> + */
> +static int
> +xfs_alloc_busy_search(
> +	struct xfs_mount	*mp,
> +	xfs_agnumber_t		agno,
> +	xfs_agblock_t		bno,
> +	xfs_extlen_t		len)
>  {
>  	struct xfs_perag	*pag;
> -	xfs_perag_busy_t	*list;
> +	struct rb_node		*rbp;
> +	xfs_agblock_t		uend, bend;
> +	struct xfs_busy_extent	*busyp;
> +	int			match = 0;
>  
> -	ASSERT(idx < XFS_PAGB_NUM_SLOTS);
> -	pag = xfs_perag_get(tp->t_mountp, agno);
> +	pag = xfs_perag_get(mp, agno);
>  	spin_lock(&pag->pagb_lock);
> -	list = pag->pagb_list;
>  
> -	trace_xfs_alloc_unbusy(tp->t_mountp, agno, idx, list[idx].busy_tp == tp);
> -
> -	if (list[idx].busy_tp == tp) {
> -		list[idx].busy_tp = NULL;
> -		pag->pagb_count--;
> +	uend = bno + len - 1;
> +	rbp = pag->pagb_tree.rb_node;
> +
> +	/* find closest start bno overlap */
> +	while (rbp) {

Similar to above, once you've made the determination that
there's either an overlapping match or an exact match,
you can quit looking.  You aren't returning anything
about the particular busy entry that matches, after all
(though your tracing can yield a different result).

          while (!match && rbp) {

> +		busyp = rb_entry(rbp, struct xfs_busy_extent, rb_node);
> +		bend = busyp->bno + busyp->length - 1;
> +		if (bno < busyp->bno) {
> +			/* may overlap, but exact start block is lower */
> +			if (uend >= busyp->bno)
> +				match = -1;
> +			rbp = rbp->rb_left;
> +		} else if (bno > busyp->bno) {
> +			/* may overlap, but exact start block is higher */
> +			if (bno <= bend)
> +				match = -1;
> +			rbp = rbp->rb_right;
> +		} else {
> +			/* bno matches busyp, length determines exact match */
> +			match = (busyp->length == len) ? 1 : -1;
> +			break;

          And as above, you could drop the break here.

> +		}
>  	}
> -
>  	spin_unlock(&pag->pagb_lock);
> +	trace_xfs_alloc_busysearch(mp, agno, bno, len, !!match);
>  	xfs_perag_put(pag);
> +	return match;
>  }
>  
> -
> -/*
> - * If we find the extent in the busy list, force the log out to get the
> - * extent out of the busy list so the caller can use it straight away.
> - */
> -STATIC void
> -xfs_alloc_search_busy(xfs_trans_t *tp,
> -		    xfs_agnumber_t agno,
> -		    xfs_agblock_t bno,
> -		    xfs_extlen_t len)

Are there any locking requirements for the clear (or insert)
routine?

> +void
> +xfs_alloc_busy_clear(
> +	struct xfs_mount	*mp,
> +	struct xfs_busy_extent	*busyp)
>  {
>  	struct xfs_perag	*pag;
> -	xfs_perag_busy_t	*bsy;
> -	xfs_agblock_t		uend, bend;
> -	xfs_lsn_t		lsn = 0;
> -	int			cnt;
>  
> -	pag = xfs_perag_get(tp->t_mountp, agno);
> -	spin_lock(&pag->pagb_lock);
> -	cnt = pag->pagb_count;
> +	trace_xfs_alloc_unbusy(mp, busyp->agno, busyp->bno,
> +						busyp->length);
>  
> -	/*
> -	 * search pagb_list for this slot, skipping open slots. We have to
> -	 * search the entire array as there may be multiple overlaps and
> -	 * we have to get the most recent LSN for the log force to push out
> -	 * all the transactions that span the range.
> -	 */
> -	uend = bno + len - 1;
> -	for (cnt = 0; cnt < pag->pagb_count; cnt++) {
> -		bsy = &pag->pagb_list[cnt];
> -		if (!bsy->busy_tp)
> -			continue;
> -
> -		bend = bsy->busy_start + bsy->busy_length - 1;
> -		if (bno > bend || uend < bsy->busy_start)
> -			continue;
> -
> -		/* (start1,length1) within (start2, length2) */
> -		if (XFS_LSN_CMP(bsy->busy_tp->t_commit_lsn, lsn) > 0)
> -			lsn = bsy->busy_tp->t_commit_lsn;
> -	}
> +	ASSERT(xfs_alloc_busy_search(mp, busyp->agno, busyp->bno,
> +						busyp->length) == 1);
> +
> +	list_del_init(&busyp->list);
> +
> +	pag = xfs_perag_get(mp, busyp->agno);
> +	spin_lock(&pag->pagb_lock);
> +	rb_erase(&busyp->rb_node, &pag->pagb_tree);
>  	spin_unlock(&pag->pagb_lock);
>  	xfs_perag_put(pag);
> -	trace_xfs_alloc_busysearch(tp->t_mountp, agno, bno, len, lsn);
>  
> -	/*
> -	 * If a block was found, force the log through the LSN of the
> -	 * transaction that freed the block
> -	 */
> -	if (lsn)
> -		xfs_log_force_lsn(tp->t_mountp, lsn, XFS_LOG_SYNC);
> +	kmem_free(busyp);
>  }

. . .

The rest is all fine.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
