Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4L2E5ju240721 for <xfs@oss.sgi.com>; Thu, 20 May 2010 21:14:07 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7C6D9141F342
	for <xfs@oss.sgi.com>; Thu, 20 May 2010 19:16:23 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	t7bjoUjDDLiVSuTV for <xfs@oss.sgi.com>;
	Thu, 20 May 2010 19:16:23 -0700 (PDT)
Date: Fri, 21 May 2010 12:16:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 07/12] xfs: Improve scalability of busy extent tracking
Message-ID: <20100521021619.GV8120@dastard>
References: <1274138668-1662-1-git-send-email-david@fromorbit.com>
	<1274138668-1662-8-git-send-email-david@fromorbit.com>
	<1274386538.2095.148.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1274386538.2095.148.camel@doink>
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

On Thu, May 20, 2010 at 03:15:38PM -0500, Alex Elder wrote:
> On Tue, 2010-05-18 at 09:24 +1000, Dave Chinner wrote:
> > When we free a metadata extent, we record it in the per-AG busy
> > extent array so that it is not re-used before the freeing
> > transaction hits the disk. This array is fixed size, so when it
> > overflows we make further allocation transactions synchronous
> > because we cannot track more freed extents until those transactions
> > hit the disk and are completed. Under heavy mixed allocation and
> > freeing workloads with large log buffers, we can overflow this array
> > quite easily.
> 
> . . .
> 
> This is a really good set of changes.  It might have been good
> to split into a few separate pieces:
> - Marking transactions synchronous rather than forcing the
>   log in some situations
> - Conversion from fixed array to dynamic rbtree
> - Drop the busy chunk stuff from the transaction code
> 
> But at this point that would be a lot of needless work.

Especially as I used to have it as three separate patches just like
this, and every time I modified the first patch it then took 15
minutes to fix all the conflicts generates in the other two. So,
no, I'm not going to split it.

> > diff --git a/fs/xfs/xfs_ag.h b/fs/xfs/xfs_ag.h
> > index abb8222..401f364 100644
> > --- a/fs/xfs/xfs_ag.h
> > +++ b/fs/xfs/xfs_ag.h
> 
> . . .
> 
> > @@ -216,7 +222,8 @@ typedef struct xfs_perag {
> >  	xfs_agino_t	pagl_leftrec;
> >  	xfs_agino_t	pagl_rightrec;
> >  #ifdef __KERNEL__
> > -	spinlock_t	pagb_lock;	/* lock for pagb_list */
> > +	spinlock_t	pagb_lock;	/* lock for pagb_tree */
> > +	struct rb_root	pagb_tree;	/* ordered tree of busy extents */
> 
> I really think "pagb_busy" would be a better name.  The
> fact that it's a tree is immaterial--the role it plays
> is recording busy extents.

Redundant. "pagb" = per-ag-busy. And the use of {lock,tree} is consistent
here e.g. m_perag_{lock,tree} in the struct xfs_mount is the same...

> > + * xfs_alloc_busy_search - search for a busy extent
> > + */
> > +
> > +/*
> > + * Insert a new extent into the busy tree.
> > + *
> 
> Maybe not here, but I think a brief explanation of the
> per-ag busy extent tree might be in order.  For example,
> that it's indexed by start address of each extent.  It
> is also true that no range of addresses is represented
> by more than one entry in the tree, right?  I'm not
> sure what would be enough but I think a simple intro
> is helpful to give the reader some context.

Added.

> > + *					*** KABOOM! ***
> > + *					....
> > + *							log IO completes
> > + *							unbusy 1:91909
>                                              1:91909 ?????

That was cut'n'paste from the tracing logs that generated the
problem (i.e. ag 1, agbno 91909 was the problem busy extent),
and I forgot to replace that one with X...

> OK, now a little more substantive feedback.
> 
> As you search the red-black tree in xfs_alloc_busy_insert()
> (as well as xfs_alloc_busy_search()), once the value of
> match gets set to -1, it will never get set to anything
> else.  So once it's set, I'm not sure there's much point
> to any further descent into the tree--you found an
> overlapping extent in the busy tree, and it's from a
> different transaction, so you need to force the log and
> try again.

That was a result of - at one point - optimising the log force
as the transaction pointer contained the LSN of the commit, so the
log could be forced only to the commit it needed to. Hence all
overlapping extents needed to be searched to find the most recent.
At some point I'd like to get back to that, but I'll clean it up for
now.

> So I think the loop condition could be changed to drop
> out if match is negative (I'll show what I mean below).
> Doing that would also simplify some of the stuff inside
> the loop.
> 
> >  void
> > -xfs_alloc_mark_busy(xfs_trans_t *tp,
> > -		    xfs_agnumber_t agno,
> > -		    xfs_agblock_t bno,
> > -		    xfs_extlen_t len)
> > +xfs_alloc_busy_insert(
> > +	struct xfs_trans	*tp,
> > +	xfs_agnumber_t		agno,
> > +	xfs_agblock_t		bno,
> > +	xfs_extlen_t		len)
> >  {
> > -	xfs_perag_busy_t	*bsy;
> > +	struct xfs_busy_extent	*new;
> > +	struct xfs_busy_extent	*busyp;
> >  	struct xfs_perag	*pag;
> > -	int			n;
> > +	struct rb_node		**rbp;
> > +	struct rb_node		*parent;
> > +	xfs_agblock_t		uend, bend;
> 
> I can understand what "b" in "bend" might represent.  But
> what does "u" mean?

I just used the same variable names as in xfs_alloc_busy_search()
for consistency.  The meaning of the "u" in uend has been lost in
the mists of time - I think it might have meant "unbusy end" to go
with "busy end". I'll just inline them now, as they are only used
once each.

> > +		} else {
> > +			if (busyp->tid != new->tid)
> > +				match = -1;
> > +			else if (match >= 0)
> > +				match = 1;
> > +			break;
> 
>                   No need for the break here if you get rid
>                   of the reassignment of busyp to NULL (more
>                   on this below).

I'm going to leave it there as a defensive mechanism - the tree
pointer is not changed, so if we don't break we could end up with
endless loops down the track if loop termination conditions are
changed....

> Right now, the only way you exit this loop with busyp
> being non-null is if you exit due to new->bno == busyp->bno.
> But that's puzzling, because that suggests that the
> if (match > 0) test below would be dereferencing a null
> pointer (and maybe that means you haven't seen in your
> testing a case of reallocating an extent in the same
> transaction you freed it in?).

I've definitely seen the same extent being freed a second time,
but maybe not an overlapping extent. Definitely looks like a bug
though.

> In any case, what I wanted to say here is that it looks
> like you're nulling that pointer just so you can call
> kmem_free(busyp) at the end of the function in all cases.

No, I'm doing it so I can call kmem_free() ouside of the 
pagb_lock spin lock.

> > +	pag = xfs_perag_get(mp, agno);
> >  	spin_lock(&pag->pagb_lock);
> > -	list = pag->pagb_list;
> >  
> > -	trace_xfs_alloc_unbusy(tp->t_mountp, agno, idx, list[idx].busy_tp == tp);
> > -
> > -	if (list[idx].busy_tp == tp) {
> > -		list[idx].busy_tp = NULL;
> > -		pag->pagb_count--;
> > +	uend = bno + len - 1;
> > +	rbp = pag->pagb_tree.rb_node;
> > +
> > +	/* find closest start bno overlap */
> > +	while (rbp) {
> 
> Similar to above, once you've made the determination that
> there's either an overlapping match or an exact match,
> you can quit looking.  You aren't returning anything
> about the particular busy entry that matches, after all
> (though your tracing can yield a different result).

That's not true for this loop. When we clear a busy extent, the
debug code checks that it can find an exact match. Hence the search
cannot terminate on the first overlap it finds as it still needs to
try to find an exact bno match before terminating.

> 
>           while (!match && rbp) {
> 
> > +		busyp = rb_entry(rbp, struct xfs_busy_extent, rb_node);
> > +		bend = busyp->bno + busyp->length - 1;
> > +		if (bno < busyp->bno) {
> > +			/* may overlap, but exact start block is lower */
> > +			if (uend >= busyp->bno)
> > +				match = -1;
> > +			rbp = rbp->rb_left;
> > +		} else if (bno > busyp->bno) {
> > +			/* may overlap, but exact start block is higher */
> > +			if (bno <= bend)
> > +				match = -1;
> > +			rbp = rbp->rb_right;
> > +		} else {
> > +			/* bno matches busyp, length determines exact match */
> > +			match = (busyp->length == len) ? 1 : -1;
> > +			break;
> 
>           And as above, you could drop the break here.

In this case it's a valid termination - we've got an exact block
number match, so regardless of the length way we do not need to
search any further because we know for certain whether an exact
match exists in the tree.

> > -/*
> > - * If we find the extent in the busy list, force the log out to get the
> > - * extent out of the busy list so the caller can use it straight away.
> > - */
> > -STATIC void
> > -xfs_alloc_search_busy(xfs_trans_t *tp,
> > -		    xfs_agnumber_t agno,
> > -		    xfs_agblock_t bno,
> > -		    xfs_extlen_t len)
> 
> Are there any locking requirements for the clear (or insert)
> routine?

The tree is protected by the pagb_lock. Inserts and searches during
allocation are serialised by the AGF buffer lock (i.e. transaction
context). Removals (and searches during removal) are serialised by
the pagb_lock. Nothing has changed there.

FWIW, Alex, this code has been out there for some time now - could
you please attempt to review code before the last minute? Your
reviews are valuable and feedback like this while I was having
trouble with this code would have helped a great deal. However, now
I'm pressed for time to retest significant modifications right
before a merge deadline....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
