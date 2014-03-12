Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6C7ED7F62
	for <xfs@oss.sgi.com>; Wed, 12 Mar 2014 07:36:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 575488F808E
	for <xfs@oss.sgi.com>; Wed, 12 Mar 2014 05:36:00 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Vt0PTatzFRKWOCkO for
	<xfs@oss.sgi.com>; Wed, 12 Mar 2014 05:35:59 -0700 (PDT)
Date: Wed, 12 Mar 2014 08:35:32 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: merge xfs_bmap_free_item and xfs_extent_busy
Message-ID: <20140312123532.GA19329@bfoster.bfoster>
References: <20140307105535.GA7850@infradead.org>
	<20140311153135.GA37254@bfoster.bfoster>
	<20140312104058.GB4167@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140312104058.GB4167@infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, Mar 12, 2014 at 03:40:58AM -0700, Christoph Hellwig wrote:
> On Tue, Mar 11, 2014 at 11:31:38AM -0400, Brian Foster wrote:
> > > +		xfs_extent_busy_insert(tp, free);
> > > +		list_add(&free->list, &tp->t_busy);
> > 
> > If I follow correctly, the list_add() is removed from
> > xfs_extent_busy_insert() because we use the list field for the bmap
> > flist as well as the t_busy list.
> 
> Indeed.  And in the case of the normal bmap free path we just splice
> the list from the bmap flist into the transaction, so we remove the add
> inside xfs_extent_busy_insert and move it to the callers, so thast the
> bmap free path can batch it.
> 
> > It appears we've lost an error check associated with allocation failure
> > in xfs_freed_extent_alloc() (here and at other callers). The current
> > code looks like it handles this by marking the transaction as
> > synchronous. Have we avoided the need for this by using
> > kmem_zone_alloc()? I guess it looks like the sleep param will cause it
> > to continue to retry...
> 
> Indeed.  That's what the old bmap freelist path did, and for that case
> we can't really handle a failure as we are in a dirty transaction that
> we would have to abort.  For the old extent_busy structure the failure
> wasn't fatal, but we got rid of that allocation entirely for the fast
> path.
> 

Ok, thanks for the explanation.

> > > +struct xfs_freed_extent {
> > > +	struct rb_node	rb_node;	/* ag by-bno indexed search tree */
> > > +	struct list_head list;		/* transaction busy extent list */
> > > +	xfs_agnumber_t	agno;
> > > +	xfs_agblock_t	bno;
> > 
> > agbno?
> 
> Maybe that would be a bit more clear, although we use bno for an
> agblock_t in lots of places.
> 

Sure, bno is just a little less clear in the context of a struct being
modified/handled in different contexts.

> > > -	xfs_extent_busy_insert(cur->bc_tp, be32_to_cpu(agf->agf_seqno), bno, 1,
> > > -			      XFS_EXTENT_BUSY_SKIP_DISCARD);
> > > -	xfs_trans_agbtree_delta(cur->bc_tp, -1);
> > 
> > Was this supposed to go away?
> 
> The xfs_trans_agbtree_delta call wasn't supposed to go away.  Kinda
> surprised it still passed testing despite this.
> 
> > > -/*
> > >   * Add the extent to the list of extents to be free at transaction end.
> > >   * The list is maintained sorted (by block number).
> > >   */
> > 
> > This comment could be fixed now that the sort is deferred.
> 
> I'll fix it.
> 
> > > +STATIC int
> > > +xfs_freed_extent_cmp(
> > > +	void			*priv,
> > > +	struct list_head	*la,
> > > +	struct list_head	*lb)
> > > +{
> > > +	struct xfs_freed_extent *a =
> > > +		container_of(la, struct xfs_freed_extent, list);
> > > +	struct xfs_freed_extent *b =
> > > +		container_of(lb, struct xfs_freed_extent, list);
> > > +
> > > +	if (a->agno == b->agno)
> > > +		return a->bno - b->bno;
> > 
> > Could we just do a comparison here and return +/-1? 
> 
> Because we the compare callback returns an int, and type promotion in C
> will give us a wrong result if we "simplify" compare to 64-bit values.
> We already ran into this with the list_sort in xfs_buf.c.  I'll add a
> comment to explain it.
> 

Interesting. Well, I could still be missing something but fwiw my
concern here is that we're subtracting two unsigned 32-bit values. 

Brian

> 
> > > -	for (free = flist->xbf_first; free != NULL; free = next) {
> > > -		next = free->xbfi_next;
> > > -		if ((error = xfs_free_extent(ntp, free->xbfi_startblock,
> > > -				free->xbfi_blockcount))) {
> > > +
> > > +	list_for_each_entry(free, &flist->xbf_list, list) {
> > > +		error = __xfs_free_extent(ntp, free);
> > > +		if (error) {
> > >  			/*
> > >  			 * The bmap free list will be cleaned up at a
> > >  			 * higher level.  The EFI will be canceled when
> > 
> > So it seems like technically we could get away with still doing the list
> > migration here an extent at a time, but that would turn this code kind
> > of ugly (e.g., to remove each entry from xbf_list as we go).
> 
> And there's not point.
> 
> > Also, it appears we no longer do the xfs_extent_busy_insert() in this
> > path..?
> 
> It did before I messed up a rebase..
> 
> > >  void
> > >  xfs_extent_busy_insert(
> > >  	struct xfs_trans	*tp,
> > > -	xfs_agnumber_t		agno,
> > > -	xfs_agblock_t		bno,
> > > -	xfs_extlen_t		len,
> > > -	unsigned int		flags)
> > > +	struct xfs_freed_extent	*new)
> > >  {
> > 
> > tp is only used for the mount now, so we can probably replace tp with
> > mp.
> 
> I'll update it.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
