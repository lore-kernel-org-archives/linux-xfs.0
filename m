Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:33287 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726410AbfFDGLM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 4 Jun 2019 02:11:12 -0400
Date: Tue, 4 Jun 2019 08:10:44 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 13/20] xfs: use bios directly to write log buffers
Message-ID: <20190604061044.GB14536@lst.de>
References: <20190603172945.13819-1-hch@lst.de> <20190603172945.13819-14-hch@lst.de> <20190604055408.GP29573@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190604055408.GP29573@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Tue, Jun 04, 2019 at 03:54:08PM +1000, Dave Chinner wrote:
> FWIW, what does ic_sema protect?  It looks to me like it just
> replaces the xfs_buf_lock(), and the only reason we were using that
> is to allow unmount to wait for iclogbuf IO completion. Can we just
> use a completion for this now?

We could, I just didn't want to change it cosmetically as that whole
pattern looks a little odd, and I'd like to spend some more time figuring
out what we could do better at a higher level.

> > -	struct xlog_in_core	*iclog = bp->b_log_item;
> > -	struct xlog		*l = iclog->ic_log;
> > +	struct xlog_in_core     *iclog =
> > +		container_of(work, struct xlog_in_core, ic_end_io_work);
> > +	struct xlog		*log = iclog->ic_log;
> >  	int			aborted = 0;
> > +	int			error;
> > +
> > +	if (is_vmalloc_addr(iclog->ic_data))
> > +		invalidate_kernel_vmap_range(iclog->ic_data, iclog->ic_io_size);
> 
> Do we need to invalidate here for write only operation?  It's only
> when we are bringing new data into memory we have to invalidate the
> range, right?  e.g. xfs_buf_bio_end_io() only does invalidation on
> read IO. 

True, we shouldn't eed this one.

> >  	for (i=0; i < log->l_iclog_bufs; i++) {
> 
> Fix the whitespace while you are touching this code?

Well, I usually do for everything I touch, but this line isn't
touched.  But I can do that anyway.

> > -		*iclogp = kmem_zalloc(sizeof(xlog_in_core_t), KM_MAYFAIL);
> > +		*iclogp = kmem_zalloc(struct_size(*iclogp, ic_bvec,
> > +				howmany(log->l_iclog_size, PAGE_SIZE)),
> > +				KM_MAYFAIL);
> 
> That's a bit of a mess - hard to read. It's times like this that I
> think generic helpers make the code worse rather than bettter.
> Perhaps some slightly different indenting to indicate that the
> howmany() function is actually a parameter of the struct_size()
> macro?
> 
> 		*iclogp = kmem_zalloc(struct_size(*iclogp, ic_bvec,
> 					howmany(log->l_iclog_size, PAGE_SIZE)),
> 				      KM_MAYFAIL);

I don't really find this any better.  Then again switching to make this
line based on iclog and only assigning iclogp later might be nicer.

> > +static void
> > +xlog_bio_end_io(
> > +	struct bio		*bio)
> > +{
> > +	struct xlog_in_core	*iclog = bio->bi_private;
> > +
> > +	queue_work(iclog->ic_log->l_mp->m_log_workqueue,
> > +		   &iclog->ic_end_io_work);
> > +}
> 
> Can we just put a pointer to the wq in the iclog? It only needs to
> be set up at init time, then this only needs to be
> 
> 	queue_work(iclog->ic_wq, &iclog->ic_end_io_work);

The workqueue pointer is moving to the xlog later in the series.
I don't really see any point to bloat every iclog with an extra
pointer.

> Aren't we're always going to be mapping the same pages to the same
> bio at the same offsets. The only thing that changes is the length
> of the bio and the sector it is addressed to. It seems kind of odd
> to have an inline data buffer, bio and biovec all pre-allocated, but
> then have to map them into exactly the same state for every IO we do
> with them...

We are, sort of.  The length of the actual data is different each
time, so we might not build up all bvecs, and the last one might
not be filled entirely.

> > +		xlog_state_done_syncing(iclog, XFS_LI_ABORTED);
> > +		up(&iclog->ic_sema);
> 
> Hmmm - this open codes the end io error completion. Might be wroth a
> comment indicating that this needs to be kept in sync with the io
> completion processing?

Ok.

> > +	u32			ic_size;
> > +	u32			ic_io_size;
> > +	u32			ic_offset;
> 
> Can we get a couple of comments here describing the difference
> between ic_size, ic_io_size and log->l_iclog_size so I don't have to
> go read all the code to find out what they are again in 6 months
> time?

Ok.
