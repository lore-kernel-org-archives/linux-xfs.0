Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8E7DFPW114043 for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 02:13:15 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AF75E17EF916
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 00:14:01 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	SykCqWUE3xbLaDVj for <xfs@oss.sgi.com>;
	Tue, 14 Sep 2010 00:14:01 -0700 (PDT)
Date: Tue, 14 Sep 2010 17:13:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/4] xfs: convert buffer cache hash to rbtree
Message-ID: <20100914071358.GA15695@dastard>
References: <1283958778-28610-1-git-send-email-david@fromorbit.com>
	<1283958778-28610-5-git-send-email-david@fromorbit.com>
	<1284396829.2404.52.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1284396829.2404.52.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, Sep 13, 2010 at 11:53:49AM -0500, Alex Elder wrote:
> On Thu, 2010-09-09 at 01:12 +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The buffer cache hash is starting to show typical hash scalability
> > problems.  large scale testing is showing the number of cached items
> > growing far larger than the hash can efficiently handle. Hence we
> > need to move to a self-scaling cache indexing mechanism.
> > 
> > I have selected rbtrees for indexing becuse they can have O(log n)
> > search scalability, and insert and remove cost is not excessive,
> > even on large trees. Hence we should be able to cache large numbers
> > of buffers without incurring the excessive cache miss search
> > penalties that the hash is imposing on us.
> > 
> > To ensure we still have parallel access to the cache, we need
> > multiple trees. Rather than hashing the buffers by disk address to
> > select a tree, it seems more sensible to separate trees by typical
> > access patterns. Most operations use buffers from within a single AG
> > at a time, so rather than searching lots of different lists,
> > separate the buffer indexes out into per-AG rbtrees. This means that
> > searches during metadata operation have a much higher chance of
> > hitting cache resident nodes, and that updates of the tree are less
> > likely to disturb trees being accessed on other CPUs doing
> > independent operations.
> 
> I found a bug in this, and have a bunch of other less
> important comments for you to consider.  I haven't spent
> any time contemplating your decision to use RB trees on
> AG's but it seems quite reasonable.
> 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/linux-2.6/xfs_buf.c   |  139 +++++++++++++++++++++--------------------
> >  fs/xfs/linux-2.6/xfs_buf.h   |   14 ++--
> >  fs/xfs/linux-2.6/xfs_super.c |    6 +-
> >  fs/xfs/xfs_ag.h              |    4 +
> >  fs/xfs/xfs_mount.c           |    4 +-
> >  5 files changed, 87 insertions(+), 80 deletions(-)
> > 
> > diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
> > index b2b5dea..facd37e 100644
> > --- a/fs/xfs/linux-2.6/xfs_buf.c
> > +++ b/fs/xfs/linux-2.6/xfs_buf.c
> 
> . . .
> 
> > @@ -432,14 +434,36 @@ _xfs_buf_find(
> >  	ASSERT(!(range_length < (1 << btp->bt_sshift)));
> >  	ASSERT(!(range_base & (xfs_off_t)btp->bt_smask));
> >  
> > -	hash = &btp->bt_hash[hash_long((unsigned long)ioff, btp->bt_hashshift)];
> > -
> > -	spin_lock(&hash->bh_lock);
> > -
> > -	list_for_each_entry_safe(bp, n, &hash->bh_list, b_hash_list) {
> > -		ASSERT(btp == bp->b_target);
> > -		if (bp->b_file_offset == range_base &&
> > -		    bp->b_buffer_length == range_length) {
> > +	/* get tree root */
> > +	pag = xfs_perag_get(btp->bt_mp, xfs_daddr_to_agno(btp->bt_mp, ioff));
> > +
> > +	/* walk tree */
> > +	spin_lock(&pag->pagbuf_lock);
> > +	rbp = &pag->pagbuf_tree.rb_node;
> > +	parent = NULL;
> 
> Could drop the above assignment and change the while
> statement to read:  while ((parent = *rbp)) {
> (I know that leads to a mildly controversial style.)

That doesn't work. When we walk off the end of the tree, *rbp ==
NULL, but we need parent to point to the previous node we searched,
as that is where we will insert the new node. The above code would
change it so that on a search miss parent == NULL as well, which
would panic or corrupt the tree on insert.

> > +	bp = NULL;
> > +	while (*rbp) {
> > +		parent = *rbp;
> > +		bp = rb_entry(parent, struct xfs_buf, b_rbnode);
> 
> Below here you might as well make use of the
> value of "parent" in places where (*rbp) is used.
> I realize you're just mimicking what's in the
> rbtree.h file though...

And the same code that is in xfs_alloc.c for the busy extent list.
I'd prefer to keep the code in a common form.

> If the result seems to
> read funny, maybe you could rename "parent" to
> be "entry" or something.

If we fall through to the insert case, it is the parent node
we insert at. Hence parent is appropriate....

> Here's the BUG:
> 
> > +		if (bp->b_file_offset < range_base)
> > +			rbp = &(*rbp)->rb_left;
> > +		else if (bp->b_file_offset > range_base)
> > +			rbp = &(*rbp)->rb_right;
> 
> Your comparisons here are reversed. 

Hmmm, yes, good catch, but I don't think it matters because the
left/right node relationship of the rbtree is maintained through
rotations. Hence as long as we always search the same way as we do
for insert, then we will always find the node we are looking for
in the same number of steps.

Having just tested it, there is zero difference in performance,
cache behaviour or CPU uasge. I'll swap it anyway, as it makes more
sense to order the tree as people expect....

> In other words,
> I believe it should be:
> 
> 	if (range_base < bp->b_file_offset)	
> 		rbp = &parent->rb_left;
> 	else if (range_base > bp->b_file_offset)
> 		rbp = &parent->rb_right;
> 
> Maybe it mostly works in the order you have it,
> but I'm pretty sure it's wrong. (The "continue
> searching to the right" below would be wrong though.)

Once again, as long as we always do things the same way (i.e.
duplicate entries are always stored on the same side) it doesn't
matter if we chose to continue the search to the left or right....

> > +		else {
> > +			/*
> > +			 * found a block offset match. If the range doesn't
> > +			 * match, the only way this is allowed is if the buffer
> > +			 * in the cache is stale and the transaction that made
> > +			 * it stale has not yet committed. i.e. we are
> > +			 * reallocating a busy extent. Skip this buffer and
> > +			 * continue searching to the right for an exact match.
> > +			 */
> > +			if (bp->b_buffer_length != range_length) {
> > +				ASSERT(bp->b_flags & XBF_STALE);
> 
> This assertion is new.  I trust it's correct, but
> maybe it should go in separately (first).

It's there to ensure that my assumption about why we can get
duplicates in the rbtree is correct. In a hash, duplicate keys are
not a big deal, and I want to ensure i understand why they are
occurring. I'd prefer to leave it in this patch...

> > +				rbp = &(*rbp)->rb_right;
> > +				continue;
> > +			}
> >  			atomic_inc(&bp->b_hold);
> >  			goto found;
> >  		}
> 
> When I first read the next hunk I thought you were
> mistakenly not dropping the perag reference.  Later
> I realized it was intentional--that the buffer holds
> a reference on the perag until it (the buffer) is
> released.  This is a minor point but I think it would
> be helpful to see a comment explaining that.

Ok.

> >  xfs_buf_rele(
> >  	xfs_buf_t		*bp)
> >  {
> > -	xfs_bufhash_t		*hash = bp->b_hash;
> > +	struct xfs_perag	*pag = bp->b_pag;
> >  
> >  	trace_xfs_buf_rele(bp, _RET_IP_);
> >  
> > -	if (unlikely(!hash)) {
> > +	if (!pag) {
> 
> I know this is not related to your change, but I'm
> curious whether this can even happen, and if so, when?

All the uncached buffers obtained through xfs_buf_get_uncached() and
xfs_buf_read_uncached() still use xfs_brelse()/xfs_buf_rele() to
drop references.


> >  void
> >  xfs_wait_buftarg(
> > -	xfs_buftarg_t	*btp)
> > +	struct xfs_buftarg	*btp)
> >  {
> > -	xfs_bufhash_t	*hash;
> > -	uint		i;
> > +	struct xfs_perag	*pag;
> > +	uint			i;
> >  
> > -	for (i = 0; i < (1 << btp->bt_hashshift); i++) {
> > -		hash = &btp->bt_hash[i];
> > -		spin_lock(&hash->bh_lock);
> > -		while (!list_empty(&hash->bh_list)) {
> > -			spin_unlock(&hash->bh_lock);
> > +	for (i = 0; i < btp->bt_mp->m_sb.sb_agcount; i++) {
> > +		pag = xfs_perag_get(btp->bt_mp, i);
> > +		spin_lock(&pag->pagbuf_lock);
> > +		while (rb_first(&pag->pagbuf_tree)) {
> > +			spin_unlock(&pag->pagbuf_lock);
> >  			delay(100);
> > -			spin_lock(&hash->bh_lock);
> > +			spin_lock(&pag->pagbuf_lock);
> >  		}
> > -		spin_unlock(&hash->bh_lock);
> > +		spin_unlock(&pag->pagbuf_lock);
> > +		xfs_perag_put(pag);
> >  	}
> >  }
> 
> This suggestion is again not related to your change, but...
> Would this basic structure (not tested) be better than
> the above?
> 
> 	int more;
> 
> 	do {
> 		more = 0;
> 		for (i = 0; i < btp->bt_mp->m_sb.sb_agcount; i++) {
> 			pag = xfs_perag_get(btp->bt_mp, i);
> 			spin_lock(&pag->pagbuf_lock);
> 			if (rb_first(&pag->pagbuf_tree))
> 				more++;
> 			spin_unlock(&pag->pagbuf_lock);
> 			xfs_perag_put(pag);
> 		}
> 		if (more)
> 			delay(100);
> 	} while (more);

Once we've found one AG that we have to wait for, checking the
rest to see if we have to do a wait is unnecessary. We may as well
wait first, then continue.


> >  
> >  /*
> > - *	Allocate buffer hash table for a given target.
> > - *	For devices containing metadata (i.e. not the log/realtime devices)
> > - *	we need to allocate a much larger hash table.
> 
> . . . 
> 
> > @@ -1645,6 +1643,12 @@ xfs_alloc_buftarg(
> >  
> >  	btp = kmem_zalloc(sizeof(*btp), KM_SLEEP);
> >  
> > +	/*
> > +	 * The buftarg cache should never be used by external devices.
> 
> I suggest that "buftarg cache" is not a good name for the
> (now per-AG) buffer cache.

That's already gone.

> 
> > +	 * Ensure we catch any users with extreme prejudice.
> > +	 */
> > +	btp->bt_mp = external ? NULL : mp;
> > +
> >  	btp->bt_dev =  bdev->bd_dev;
> >  	btp->bt_bdev = bdev;
> >  	if (xfs_setsize_buftarg_early(btp, bdev))
> > @@ -1653,7 +1657,6 @@ xfs_alloc_buftarg(
> >  		goto error;
> >  	if (xfs_alloc_delwrite_queue(btp, fsname))
> >  		goto error;
> > -	xfs_alloc_bufhash(btp, external);
> >  	return btp;
> >  
> >  error:
> > diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
> > index 802dc5e..3797ee8 100644
> > --- a/fs/xfs/linux-2.6/xfs_buf.h
> > +++ b/fs/xfs/linux-2.6/xfs_buf.h
> . . .
> > @@ -171,8 +170,8 @@ typedef struct xfs_buf {
> >  	wait_queue_head_t	b_waiters;	/* unpin waiters */
> >  	struct list_head	b_list;
> >  	xfs_buf_flags_t		b_flags;	/* status flags */
> > -	struct list_head	b_hash_list;	/* hash table list */
> > -	xfs_bufhash_t		*b_hash;	/* hash table list start */
> > +	struct rb_node		b_rbnode;	/* rbtree node */
> > +	struct xfs_perag	*b_pag;		/* rbtree root */
> 
> Rather, "contains rbtree root" (in the comment).
> 
> >  	xfs_buftarg_t		*b_target;	/* buffer target (device) */
> >  	atomic_t		b_hold;		/* reference count */
> >  	xfs_daddr_t		b_bn;		/* block number for I/O */
> 
> . . . 
> 
> > diff --git a/fs/xfs/xfs_ag.h b/fs/xfs/xfs_ag.h
> > index 4917d4e..e01d4cf 100644
> > --- a/fs/xfs/xfs_ag.h
> > +++ b/fs/xfs/xfs_ag.h
> > @@ -230,6 +230,10 @@ typedef struct xfs_perag {
> >  	rwlock_t	pag_ici_lock;	/* incore inode lock */
> >  	struct radix_tree_root pag_ici_root;	/* incore inode cache root */
> >  	int		pag_ici_reclaimable;	/* reclaimable inodes */
> > +
> > +	/* buffer cache index */
> > +	spinlock_t	pagbuf_lock;	/* lock for pagbuf_tree */
> > +	struct rb_root	pagbuf_tree;	/* ordered tree of active buffers */
> 
> I know it's in some way consistent with the rest of the
> naming scheme for fields in this structure, maybe these
> could be named pag_buf_lock and pag_buf_tree.  (The rest
> of the fields here have a sort of strange convention and
> maybe they've got strong enough history that they should
> be left alone.)

OK. I'll change if to pag_buf_...

FYI:
pagi = per-ag AGI data
pagf = per-ag AGF data
pagb = per-ag busy extent
pagl = per-ag inode lookup
pag_ici = per-ag inode cache index

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
