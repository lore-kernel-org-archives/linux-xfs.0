Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8JMKerE193751 for <xfs@oss.sgi.com>; Sat, 19 Sep 2009 17:20:42 -0500
Date: Sat, 19 Sep 2009 18:21:55 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: event tracing support
Message-ID: <20090919222155.GA1285@infradead.org>
References: <20090909172204.GA22353@infradead.org>
	<1AB9A794DBDDF54A8A81BE2296F7BDFE83AC84@cf--amer001e--3.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1AB9A794DBDDF54A8A81BE2296F7BDFE83AC84@cf--amer001e--3.americas.sgi.com>
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

On Mon, Sep 14, 2009 at 04:40:57PM -0500, Alex Elder wrote:
> >  	XFS_STATS_INC(xb_create);
> > -	XB_TRACE(bp, "initialize", target);
> > +	xfs_buftrace(bp, "initialize");
> >  }
> >  
> >  /*
> 
> Is "target" no longer useful information?  (Why not xfs_buftrace_val()?)

The target itself is not really useful information.  We still trace the
device it's on inside the tracer which is the most important
information.

> > @@ -859,7 +832,7 @@ xfs_buf_rele(
> >  {
> >  	xfs_bufhash_t		*hash = bp->b_hash;
> >  
> > -	XB_TRACE(bp, "rele", bp->b_relse);
> > +	xfs_buftrace(bp, "rele");
> >  
> >  	if (unlikely(!hash)) {
> >  		ASSERT(!bp->b_relse);
> 
> Is "bp->b_relse" no longer useful information?  Always the same value
> (it can be NULL for error paths)?

The function pointer values aren't too useful information in a user
trace, while previously they were a bit more useful using kdb.  If you
really want it I can add it back using the in-kernel symbol lookup so
that we'll actually get a useful name back.

> > @@ -1035,7 +1009,7 @@ xfs_buf_iodone_work(
> >  	 */
> >  	if ((bp->b_error == EOPNOTSUPP) &&
> >  	    (bp->b_flags & (XBF_ORDERED|XBF_ASYNC)) == (XBF_ORDERED|XBF_ASYNC)) {
> > -		XB_TRACE(bp, "ordered_retry", bp->b_iodone);
> > +		xfs_buftrace(bp, "ordered_retry");
> >  		bp->b_flags &= ~XBF_ORDERED;
> >  		bp->b_flags |= _XFS_BARRIER_FAILED;
> >  		xfs_buf_iorequest(bp);
> 
> Is "bp->b_iodone" no longer useful information?  Always the same
> value?

Same argument as above.

> Index: xfs/fs/xfs/linux-2.6/xfs_lrw.c
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/xfs_lrw.c	2009-09-09 12:33:56.410254105 -0300
> +++ xfs/fs/xfs/linux-2.6/xfs_lrw.c	2009-09-09 12:49:11.187255959 -0300
> > @@ -712,8 +651,6 @@ start:
> >  	if ((ioflags & IO_ISDIRECT)) {
> >  		if (mapping->nrpages) {
> >  			WARN_ON(need_i_mutex == 0);
> > -			xfs_inval_cached_trace(xip, pos, -1,
> > -					(pos & PAGE_CACHE_MASK), -1);
> >  			error = xfs_flushinval_pages(xip,
> >  					(pos & PAGE_CACHE_MASK),
> >  					-1, FI_REMAPF_LOCKED);
> 
> Why are you eliminating tracing of this event (here and elsewhere)?

It's moved into xfs_flushinval_pages from the callers.

> >  
> > +
> > +
> >  static struct super_operations xfs_super_operations;
> >  static kmem_zone_t *xfs_ioend_zone;
> >  mempool_t *xfs_ioend_pool;
> 
> Pretty blanky.

Fixed.

> > +#define xfs_dqtrace_entry_ino(dqp, func, ip) \
> > +	trace_xfs_dquot((dqp), (func), (ip));
> > +#define xfs_dqtrace_entry(dqp, func) \
> > +	trace_xfs_dquot((dqp), (func), NULL)
> 
> Get rid of these macros, just replace calls to them with the
> "normally" spelled macros (trace_xfs_dquot(), trace_xfs_buf_item()).

Yeah.  This will change a bit in the next repositing by switching to
the per-callsite tracepoints already used elsewhere in the patch.

> > +	), \
> > +	TP_printk("dev %d:%d ino 0x%llx flags %s caller %pf", \
> > +		  MAJOR(__entry->dev), MINOR(__entry->dev), \
> > +		  __entry->ino, \
> > +		  __print_flags(__entry->lock_flags, "|", XFS_LOCK_FLAGS), \
> > +		  (void *)__entry->caller_ip) \
> > +)
> 
> Incorporate _RET_IP_ here rather than passing in caller_ip in all call
> sites.

We can't.  We want the caller of the lock functions, not the caller of
the tracing handler which is either the lock function itself or some
garbage.  I hope to wotk with the trace infrastructure people to get
some nicer way to catch the caller ip, though..

> 
> +/* XXX: make generic? */
> +#define XFS_BUSY_STATES \
> +	{ 0,	"found" }, \
> +	{ 1,	"missing" }
> 
> How generic do you want to make it?  If the sense were inverted you
> could use a Boolean value (i.e., __entry->found = true or false).

Hmm, I could do it that way.  For now it's just found/missing, but we
could change it to a found true/false

> 
> +#define xfs_trace_agf(mp, agf, flags) \
> +	trace_xfs_agf(mp, agf, flags, _THIS_IP_)
> 
> Get rid of this macro, just replace calls to it with its "normal"
> spelling (trace_xfs_agf()).  There's no reason you can't use _THIS_IP_
> in the TRACE_EVENT() macro, right?

I can use it, but it gives the wrong result.  TRACE_EVENT expends to
an attachment point in the caller, and a function to do the tracing.
We only binary patch a call to the tracing function onto the callsite
if tracing is enabled - that way the overhead for tracing is low if
not dynamically enabled.

> > @@ -1849,7 +1844,7 @@ xfs_attr_node_list(xfs_attr_list_context
> >  			node = bp->data;
> >  			switch (be16_to_cpu(node->hdr.info.magic)) {
> >  			case XFS_DA_NODE_MAGIC:
> > -				xfs_attr_trace_l_cn("wrong blk", context, node);
> > +				trace_xfs_attr_list_wrong_blk(context);
> >  				xfs_da_brelse(NULL, bp);
> >  				bp = NULL;
> >  				break;
> 
> Is "node" no longer useful information?

I don't think it ever was.  What we do here is to walk the attr btree
to find our curosr position, and trace if we found a wrong entry in
the btree.  I can't see how we need additional information about the
exact node we ended up.  This trace point has been there since 1995 almost
unmodified and I can't remember anyone needing it - it's mostly left in
for completeness.

> Is "leaf" no longer useful information?

Same here.

> > +#define	xfs_trace_bmap_post_update(d, ip, i, w)	\
> > +	trace_xfs_bmap_post_update(ip, i, w, d)
> > +#define	xfs_trace_bmap_pre_update(d, ip, i, w)	\
> > +	trace_xfs_bmap_pre_update(ip, i, w, d)
> > +
> >  /*
> >   * Bmap internal routines.
> >   */
> 
> Get rid of these macros, just replace calls to them with their
> "normal" spelling (i.e., trace_xfs_bmap_...).

Yeah, this area also needs a bit more love anyway.

> > Index: xfs/fs/xfs/xfs_dir2_block.c
> > ===================================================================
> > --- xfs.orig/fs/xfs/xfs_dir2_block.c	2009-09-09 12:33:56.559253457 -0300
> > +++ xfs/fs/xfs/xfs_dir2_block.c	2009-09-09 12:49:11.305256255 -0300
> > @@ -897,7 +901,8 @@ xfs_dir2_leaf_to_block(
> >  	int			to;		/* block/leaf to index */
> >  	xfs_trans_t		*tp;		/* transaction pointer */
> >  
> > -	xfs_dir2_trace_args_bb("leaf_to_block", args, lbp, dbp);
> > +	trace_xfs_dir2_leaf_to_block(args);
> > +
> >  	dp = args->dp;
> >  	tp = args->trans;
> >  	mp = dp->i_mount;
> 
> Are the disk address buffer pointers in traces like this one no longer
> useful information?

We can't do anything with pointers to buffers in userspace - they are
usually gone by the time we read the trace (same for kdb without an
actualy crash).  Note that if you need them in a special case the
tracepoints allow attaching manually written tracing code easily without
modifying the xfs kernel module.  I will post some examples for that
after the merge window stress is over.

> > +++ xfs/fs/xfs/xfs_dir2_sf.c	2009-09-09 12:49:11.317273917 -0300
> > @@ -654,7 +656,8 @@ xfs_dir2_sf_create(
> >  	xfs_dir2_sf_t	*sfp;		/* shortform structure */
> >  	int		size;		/* directory size */
> >  
> > -	xfs_dir2_trace_args_i("sf_create", args, pino);
> > +	trace_xfs_dir2_sf_create(args);
> > +
> >  	dp = args->dp;
> >  
> >  	ASSERT(dp != NULL);
> 
> Is the parent inode number no longer useful information?

I don't think it ever was. 

> > Index: xfs/fs/xfs/xfs_error.c
> > ===================================================================
> > --- xfs.orig/fs/xfs/xfs_error.c	2009-09-09 12:33:56.585252928 -0300
> > +++ xfs/fs/xfs/xfs_error.c	2009-09-09 12:49:11.322256465 -0300
> > @@ -217,3 +217,19 @@ xfs_corruption_error(
> >  		xfs_hex_dump(p, 16);
> >  	xfs_error_report(tag, level, mp, fname, linenum, ra);
> >  }
> > +
> > +/*
> > + * Format fsblock number into a static buffer & return it.
> > + */
> > +char *xfs_fmtfsblock(xfs_fsblock_t bno)
> > +{
> > +	static char rval[50];
> 
> Why 50?  37 is enough for +/- 2^63, and 50 isn't really much better
> than that for alignment or anything.  Not a big deal.

This function was copied from xfsidbg.  No idea why it choses the magic
number..

> > Index: xfs/fs/xfs/xfs_rw.c
> > ===================================================================
> > --- xfs.orig/fs/xfs/xfs_rw.c	2009-09-09 12:33:56.670252999 -0300
> > +++ xfs/fs/xfs/xfs_rw.c	2009-09-09 12:49:11.379255905 -0300
> > @@ -171,7 +172,6 @@ xfs_bioerror(
> >  	 * No need to wait until the buffer is unpinned.
> >  	 * We aren't flushing it.
> >  	 */
> > -	xfs_buftrace("XFS IOERROR", bp);
> >  	XFS_BUF_ERROR(bp, EIO);
> >  	/*
> >  	 * We're calling biodone, so delete B_DONE flag. Either way
> > @@ -205,7 +205,6 @@ xfs_bioerror_relse(
> >  	ASSERT(XFS_BUF_IODONE_FUNC(bp) != xfs_buf_iodone_callbacks);
> >  	ASSERT(XFS_BUF_IODONE_FUNC(bp) != xlog_iodone);
> >  
> > -	xfs_buftrace("XFS IOERRELSE", bp);
> >  	fl = XFS_BUF_BFLAGS(bp);
> >  	/*
> >  	 * No need to wait until the buffer is unpinned.
> 
> Why are you dropping tracing of these cases?

> 
> Why are you dropping tracing where xfs_itrace_ref() and
> xfs_itrace_exit() was being called (here and elsewhere)?
> Other than the spots where xfs_itrace_exit_tag() was used.

These are replaced by the increased tracing in iget, instead of tracing
inodes sometimes in iget and then in the callers we now make sure to
trace all inodes in iget.


> 
> > Index: xfs/fs/xfs/xfs_attr_leaf.c
> > ===================================================================
> > --- xfs.orig/fs/xfs/xfs_attr_leaf.c	2009-09-09 12:33:56.691253788 -0300
> > +++ xfs/fs/xfs/xfs_attr_leaf.c	2009-09-09 12:49:11.394257187 -0300
> >  @@ -653,7 +654,6 @@ xfs_attr_shortform_list(xfs_attr_list_co
> >  			XFS_CORRUPTION_ERROR("xfs_attr_shortform_list",
> >  					     XFS_ERRLEVEL_LOW,
> >  					     context->dp->i_mount, sfe);
> > -			xfs_attr_trace_l_c("sf corrupted", context);
> >  			kmem_free(sbuf);
> >  			return XFS_ERROR(EFSCORRUPTED);
> >  		}
> 
> Why are you dropping tracing of the returns from this function?  Too
> much output?

This and the others are dropped because I really couldn't find a use
for it.  Many other attr tracepoints are pretty borderline, too - did
anyone on hte list ever use the attr tracing in kdb, btw?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
