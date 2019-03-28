Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45662 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727374AbfC1QqI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Mar 2019 12:46:08 -0400
Date: Thu, 28 Mar 2019 12:46:05 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC PATCH] xfs: merge adjacent io completions of the same type
Message-ID: <20190328164605.GD17056@bfoster>
References: <20190327030550.GZ1183@magnolia>
 <20190327030634.GA1183@magnolia>
 <20190328141009.GB17056@bfoster>
 <20190328151744.GB18833@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190328151744.GB18833@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Thu, Mar 28, 2019 at 08:17:44AM -0700, Darrick J. Wong wrote:
> On Thu, Mar 28, 2019 at 10:10:10AM -0400, Brian Foster wrote:
> > On Tue, Mar 26, 2019 at 08:06:34PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > When we're processing an ioend on the list of io completions, check to
> > > see if the next items on the list are both adjacent and of the same
> > > type.  If so, we can merge the completions to reduce transaction
> > > overhead.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > 
> > I'm curious of the value of this one... what situations allow for
> > batching on the ioend completion side that we haven't already accounted
> > for in the ioend construction side?
> 
> I was skeptical too, but Dave (I think?) pointed out that writeback can
> split into 1GB chunks so it actually is possible to end up with adjacent
> ioends.  So I wrote this patch and added a tracepoint, and lo it
> actually did trigger when there's a lot of data to flush out, and we
> succeed at allocating a single extent for the entire delalloc reservation.
> 

That doesn't seem like a huge overhead to me, but I am curious where
that splitting logic is. Somewhere in the writeback code..? (I assume
Dave can chime in on some of this stuff if he's more familiar with
it..).

> > The latter already batches until we
> > cross a change in fork type, extent state, or a break in logical or
> > physical contiguity. The former looks like it follows similar logic for
> > merging with the exceptions of allowing for merges of physically
> > discontiguous extents and disallowing merges of those with different
> > append status. That seems like a smallish window of opportunity to me..
> > am I missing something?
> 
> Yep, it's a smallish window; small discontiguous writes don't benefit
> here at all.
> 

Ok. The whole append thing is somewhat dynamic/non-deterministic as
well, along with the fact that we're subject to completion/wq timing to
allow for this kind of batching to occur. E.g., if we're completing a
series of 1GB ioends, what are the odds the next ioend completes before
the current one starts in the wq? I'd guess not great, but tbh I have no
idea..

> > If that is the gist but there is enough benefit for the more lenient
> > merging, I also wonder whether it would be more efficient to try and
> > also accomplish that on the construction side rather than via completion
> > post-processing. For example, could we abstract a single ioend to cover
> > an arbitrary list of bio/page -> sector mappings with the same higher
> > level semantics? We already have a bio chaining mechanism, it's just
> > only used for when a bio is full. Could we reuse that for dealing with
> > physical discontiguity?
> 
> I suppose we could, though the bigger the ioend the longer it'll take to
> process responses.  Also, I think it's the case that if any of the bios
> fail then we treat all of the chained ones as failed?  (Meh, it's
> writeback, it's not like you get to know /which/ writes failed unless
> you do a stupid write()/fsync() dance...)
> 

This already seems to be the case to a large degree with our current
batching. That 1GB ioend above is already a fairly large bio chain, as I
think that a bio can't have more than 256 (BIO_MAX_PAGES) pages.

Eh, I guess my take is that this doesn't necessarily seem like an
unreasonable change and it's not like it's a huge amount of code, but it
does seem like potentially more standalone code than it's worth for
minimal benefit. It seems the amount of code and processing could be
reduced and benefit slightly increased by allocating fewer ioends in the
first place if this were pre-processed vs. post-processed. I'd prefer to
see more analysis of the potential benefits either way...

> The other thing is that directio completions look very similar to
> writeback completions, including the potential for having the thundering
> herds pounding on the ILOCK.  I was thinking about refactoring those to
> use the per-inode queue as a next step, though the directio completion
> paths are murky.
> 

Indeed, though we don't have the degree of submission batching taking
place for direct I/O. Perhaps it just depends more on the workload since
aio can presumably drive a deeper queue.

A couple things to note..

I vaguely recall that the dio completion code has a bit of a messy
history of being switched back and forth between using ioends or
bitmasks or whatever else to avoid ioend allocations. This doesn't rule
out potential new benefits of using ioends that might be achieved in
light of new features like reflink, but FWIW I'd be more skeptical of
refactors along those lines that don't come along with a measurable
benefit or solve a tangible problem.

Another thing to be aware of here is that the iomap code looks like it
already can invoke our callback in a wq and it may complete the aio as
soon as we return...

Brian

> > Brian
> > 
> > >  fs/xfs/xfs_aops.c |   86 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> > >  1 file changed, 86 insertions(+)
> > > 
> > > diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> > > index f7a9bb661826..53afa2e6e3e7 100644
> > > --- a/fs/xfs/xfs_aops.c
> > > +++ b/fs/xfs/xfs_aops.c
> > > @@ -237,6 +237,7 @@ STATIC void
> > >  xfs_end_ioend(
> > >  	struct xfs_ioend	*ioend)
> > >  {
> > > +	struct list_head	ioend_list;
> > >  	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
> > >  	xfs_off_t		offset = ioend->io_offset;
> > >  	size_t			size = ioend->io_size;
> > > @@ -273,7 +274,89 @@ xfs_end_ioend(
> > >  done:
> > >  	if (ioend->io_append_trans)
> > >  		error = xfs_setfilesize_ioend(ioend, error);
> > > +	list_replace_init(&ioend->io_list, &ioend_list);
> > >  	xfs_destroy_ioend(ioend, error);
> > > +
> > > +	while (!list_empty(&ioend_list)) {
> > > +		ioend = list_first_entry(&ioend_list, struct xfs_ioend,
> > > +				io_list);
> > > +		list_del_init(&ioend->io_list);
> > > +		xfs_destroy_ioend(ioend, error);
> > > +	}
> > > +}
> > > +
> > > +/*
> > > + * We can merge two adjacent ioends if they have the same set of work to do.
> > > + */
> > > +static bool
> > > +xfs_ioend_can_merge(
> > > +	struct xfs_ioend	*ioend,
> > > +	int			ioend_error,
> > > +	struct xfs_ioend	*next)
> > > +{
> > > +	int			next_error;
> > > +
> > > +	next_error = blk_status_to_errno(next->io_bio->bi_status);
> > > +	if (ioend_error != next_error)
> > > +		return false;
> > > +	if ((ioend->io_fork == XFS_COW_FORK) ^ (next->io_fork == XFS_COW_FORK))
> > > +		return false;
> > > +	if ((ioend->io_state == XFS_EXT_UNWRITTEN) ^
> > > +	    (next->io_state == XFS_EXT_UNWRITTEN))
> > > +		return false;
> > > +	if (ioend->io_offset + ioend->io_size != next->io_offset)
> > > +		return false;
> > > +	if (xfs_ioend_is_append(ioend) != xfs_ioend_is_append(next))
> > > +		return false;
> > > +	return true;
> > > +}
> > > +
> > > +/* Try to merge adjacent completions. */
> > > +STATIC void
> > > +xfs_ioend_try_merge(
> > > +	struct xfs_ioend	*ioend,
> > > +	struct list_head	*more_ioends)
> > > +{
> > > +	struct xfs_ioend	*next_ioend;
> > > +	int			ioend_error;
> > > +	int			error;
> > > +
> > > +	if (list_empty(more_ioends))
> > > +		return;
> > > +
> > > +	ioend_error = blk_status_to_errno(ioend->io_bio->bi_status);
> > > +
> > > +	while (!list_empty(more_ioends)) {
> > > +		next_ioend = list_first_entry(more_ioends, struct xfs_ioend,
> > > +				io_list);
> > > +		if (!xfs_ioend_can_merge(ioend, ioend_error, next_ioend))
> > > +			break;
> > > +		list_move_tail(&next_ioend->io_list, &ioend->io_list);
> > > +		ioend->io_size += next_ioend->io_size;
> > > +		if (ioend->io_append_trans) {
> > > +			error = xfs_setfilesize_ioend(next_ioend, 1);
> > > +			ASSERT(error == 1);
> > > +		}
> > > +	}
> > > +}
> > > +
> > > +/* list_sort compare function for ioends */
> > > +static int
> > > +xfs_ioend_compare(
> > > +	void			*priv,
> > > +	struct list_head	*a,
> > > +	struct list_head	*b)
> > > +{
> > > +	struct xfs_ioend	*ia;
> > > +	struct xfs_ioend	*ib;
> > > +
> > > +	ia = container_of(a, struct xfs_ioend, io_list);
> > > +	ib = container_of(b, struct xfs_ioend, io_list);
> > > +	if (ia->io_offset < ib->io_offset)
> > > +		return -1;
> > > +	else if (ia->io_offset > ib->io_offset)
> > > +		return 1;
> > > +	return 0;
> > >  }
> > >  
> > >  /* Finish all pending io completions. */
> > > @@ -292,10 +375,13 @@ xfs_end_io(
> > >  	list_replace_init(&ip->i_iodone_list, &completion_list);
> > >  	spin_unlock_irqrestore(&ip->i_iodone_lock, flags);
> > >  
> > > +	list_sort(NULL, &completion_list, xfs_ioend_compare);
> > > +
> > >  	while (!list_empty(&completion_list)) {
> > >  		ioend = list_first_entry(&completion_list, struct xfs_ioend,
> > >  				io_list);
> > >  		list_del_init(&ioend->io_list);
> > > +		xfs_ioend_try_merge(ioend, &completion_list);
> > >  		xfs_end_ioend(ioend);
> > >  	}
> > >  }
