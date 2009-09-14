Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8ELg1SV088142 for <xfs@oss.sgi.com>; Mon, 14 Sep 2009 16:42:01 -0500
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH] xfs: event tracing support
Date: Mon, 14 Sep 2009 16:40:57 -0500
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE83AC84@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <20090909172204.GA22353@infradead.org>
From: "Alex Elder" <aelder@sgi.com>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> Convert the old xfs tracing support that could only be used with the out
> of tree kdb and xfsidbg patches to use the generic event tracer.
...

Here's my review.  I've deleted most of the content, leaving the names
of the files that I have comments on, and including only the context
in question.  Hopefully that's not confusing.  In general, I like this
change, and like the flexibility of the generic tracing mechanism.

I don't see any outright errors, just have a few questions.  A bunch
of my comments here are "why are no longer tracing this information,"
but I also see that you've added and/or completed some tracing of
information that was not captured before.  There are some others where
you have some trivial macros that I'd just as soon see eliminated.

I have initiated some discussions internal to SGI about the impact of
this change and hope to have an answer about accepting this in the
next few days so we can get it in during this merge window if
possible.  No promises yet, but I'm working on it.

I have not tried using the code at all at this point, just did a
review.

					-Alex

> Index: xfs/fs/xfs/linux-2.6/xfs_buf.c
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/xfs_buf.c	2009-09-09 12:33:56.375253837 -0300
> +++ xfs/fs/xfs/linux-2.6/xfs_buf.c	2009-09-09 12:49:11.166254191 -0300
> @@ -279,7 +252,7 @@ _xfs_buf_initialize(
>  	init_waitqueue_head(&bp->b_waiters);
>  
>  	XFS_STATS_INC(xb_create);
> -	XB_TRACE(bp, "initialize", target);
> +	xfs_buftrace(bp, "initialize");
>  }
>  
>  /*

Is "target" no longer useful information?  (Why not xfs_buftrace_val()?)

> @@ -859,7 +832,7 @@ xfs_buf_rele(
>  {
>  	xfs_bufhash_t		*hash = bp->b_hash;
>  
> -	XB_TRACE(bp, "rele", bp->b_relse);
> +	xfs_buftrace(bp, "rele");
>  
>  	if (unlikely(!hash)) {
>  		ASSERT(!bp->b_relse);

Is "bp->b_relse" no longer useful information?  Always the same value
(it can be NULL for error paths)?

> @@ -1035,7 +1009,7 @@ xfs_buf_iodone_work(
>  	 */
>  	if ((bp->b_error == EOPNOTSUPP) &&
>  	    (bp->b_flags & (XBF_ORDERED|XBF_ASYNC)) == (XBF_ORDERED|XBF_ASYNC)) {
> -		XB_TRACE(bp, "ordered_retry", bp->b_iodone);
> +		xfs_buftrace(bp, "ordered_retry");
>  		bp->b_flags &= ~XBF_ORDERED;
>  		bp->b_flags |= _XFS_BARRIER_FAILED;
>  		xfs_buf_iorequest(bp);

Is "bp->b_iodone" no longer useful information?  Always the same
value?

Index: xfs/fs/xfs/linux-2.6/xfs_lrw.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_lrw.c	2009-09-09 12:33:56.410254105 -0300
+++ xfs/fs/xfs/linux-2.6/xfs_lrw.c	2009-09-09 12:49:11.187255959 -0300
> @@ -712,8 +651,6 @@ start:
>  	if ((ioflags & IO_ISDIRECT)) {
>  		if (mapping->nrpages) {
>  			WARN_ON(need_i_mutex == 0);
> -			xfs_inval_cached_trace(xip, pos, -1,
> -					(pos & PAGE_CACHE_MASK), -1);
>  			error = xfs_flushinval_pages(xip,
>  					(pos & PAGE_CACHE_MASK),
>  					-1, FI_REMAPF_LOCKED);

Why are you eliminating tracing of this event (here and elsewhere)?

> Index: xfs/fs/xfs/linux-2.6/xfs_super.c
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2009-09-09 12:33:56.419254483 -0300
> +++ xfs/fs/xfs/linux-2.6/xfs_super.c	2009-09-09 12:49:11.194307066 -0300
> @@ -67,6 +69,8 @@
>  #include <linux/freezer.h>
>  #include <linux/parser.h>
>  
> +
> +
>  static struct super_operations xfs_super_operations;
>  static kmem_zone_t *xfs_ioend_zone;
>  mempool_t *xfs_ioend_pool;

Pretty blanky.

> Index: xfs/fs/xfs/linux-2.6/xfs_trace.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ xfs/fs/xfs/linux-2.6/xfs_trace.h	2009-09-09 13:25:13.612256052 -0300
...
> +#define xfs_buf_item_trace(id, bip) \
> +	trace_xfs_buf_item((id), (bip));
> +
...
> +#define xfs_dqtrace_entry_ino(dqp, func, ip) \
> +	trace_xfs_dquot((dqp), (func), (ip));
> +#define xfs_dqtrace_entry(dqp, func) \
> +	trace_xfs_dquot((dqp), (func), NULL)

Get rid of these macros, just replace calls to them with the
"normally" spelled macros (trace_xfs_dquot(), trace_xfs_buf_item()).

> +#define DEFINE_LOCK_EVENT(name) \
> +TRACE_EVENT(name, \
> +	TP_PROTO(struct xfs_inode *ip, unsigned lock_flags, \
> +		 unsigned long caller_ip), \
> +	TP_ARGS(ip,  lock_flags, caller_ip), \
> +	TP_STRUCT__entry( \
> +		__field(dev_t, dev) \
> +		__field(xfs_ino_t, ino) \
> +		__field(int, lock_flags) \
> +		__field(unsigned long, caller_ip) \
> +	), \
> +	TP_fast_assign( \
> +		__entry->dev = VFS_I(ip)->i_sb->s_dev; \
> +		__entry->ino = ip->i_ino; \
> +		__entry->lock_flags = lock_flags; \
> +		__entry->caller_ip = caller_ip; \
> +	), \
> +	TP_printk("dev %d:%d ino 0x%llx flags %s caller %pf", \
> +		  MAJOR(__entry->dev), MINOR(__entry->dev), \
> +		  __entry->ino, \
> +		  __print_flags(__entry->lock_flags, "|", XFS_LOCK_FLAGS), \
> +		  (void *)__entry->caller_ip) \
> +)

Incorporate _RET_IP_ here rather than passing in caller_ip in all call
sites.

+/* XXX: make generic? */
+#define XFS_BUSY_STATES \
+	{ 0,	"found" }, \
+	{ 1,	"missing" }

How generic do you want to make it?  If the sense were inverted you
could use a Boolean value (i.e., __entry->found = true or false).

+#define xfs_trace_agf(mp, agf, flags) \
+	trace_xfs_agf(mp, agf, flags, _THIS_IP_)

Get rid of this macro, just replace calls to it with its "normal"
spelling (trace_xfs_agf()).  There's no reason you can't use _THIS_IP_
in the TRACE_EVENT() macro, right?

+#define xfs_trace_alloc_extent(args, str) \
+	trace_xfs_alloc_extent(args, str, _THIS_IP_)

Same as above.  Get rid of this macro and replace calls to it with its
"normal" spelling (trace_xfs_alloc_extent()).

> Index: xfs/fs/xfs/xfs_attr.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_attr.c	2009-09-09 12:33:56.494253909 -0300
> +++ xfs/fs/xfs/xfs_attr.c	2009-09-09 12:49:11.251256010 -0300
...
> @@ -1849,7 +1844,7 @@ xfs_attr_node_list(xfs_attr_list_context
>  			node = bp->data;
>  			switch (be16_to_cpu(node->hdr.info.magic)) {
>  			case XFS_DA_NODE_MAGIC:
> -				xfs_attr_trace_l_cn("wrong blk", context, node);
> +				trace_xfs_attr_list_wrong_blk(context);
>  				xfs_da_brelse(NULL, bp);
>  				bp = NULL;
>  				break;

Is "node" no longer useful information?

> @@ -1857,20 +1852,18 @@ xfs_attr_node_list(xfs_attr_list_context
>  				leaf = bp->data;
>  				if (cursor->hashval > be32_to_cpu(leaf->entries[
>  				    be16_to_cpu(leaf->hdr.count)-1].hashval)) {
> -					xfs_attr_trace_l_cl("wrong blk",
> -							   context, leaf);
> +					trace_xfs_attr_list_wrong_blk(context);
>  					xfs_da_brelse(NULL, bp);
>  					bp = NULL;
>  				} else if (cursor->hashval <=
>  					     be32_to_cpu(leaf->entries[0].hashval)) {
> -					xfs_attr_trace_l_cl("maybe wrong blk",
> -							   context, leaf);
> +					trace_xfs_attr_list_wrong_blk(context);
>  					xfs_da_brelse(NULL, bp);
>  					bp = NULL;
>  				}
> 				break;
...

Is "leaf" no longer useful information?

> Index: xfs/fs/xfs/xfs_bmap.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_bmap.c	2009-09-09 12:33:56.507254656 -0300
> +++ xfs/fs/xfs/xfs_bmap.c	2009-09-09 12:49:11.270256405 -0300
> @@ -398,6 +322,11 @@ xfs_bmap_disk_count_leaves(
>  	int			numrecs,
>  	int			*count);
>  
> +#define	xfs_trace_bmap_post_update(d, ip, i, w)	\
> +	trace_xfs_bmap_post_update(ip, i, w, d)
> +#define	xfs_trace_bmap_pre_update(d, ip, i, w)	\
> +	trace_xfs_bmap_pre_update(ip, i, w, d)
> +
>  /*
>   * Bmap internal routines.
>   */

Get rid of these macros, just replace calls to them with their
"normal" spelling (i.e., trace_xfs_bmap_...).

> Index: xfs/fs/xfs/xfs_dir2_block.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_dir2_block.c	2009-09-09 12:33:56.559253457 -0300
> +++ xfs/fs/xfs/xfs_dir2_block.c	2009-09-09 12:49:11.305256255 -0300
> @@ -897,7 +901,8 @@ xfs_dir2_leaf_to_block(
>  	int			to;		/* block/leaf to index */
>  	xfs_trans_t		*tp;		/* transaction pointer */
>  
> -	xfs_dir2_trace_args_bb("leaf_to_block", args, lbp, dbp);
> +	trace_xfs_dir2_leaf_to_block(args);
> +
>  	dp = args->dp;
>  	tp = args->trans;
>  	mp = dp->i_mount;

Are the disk address buffer pointers in traces like this one no longer
useful information?

> Index: xfs/fs/xfs/xfs_dir2_node.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_dir2_node.c	2009-09-09 12:33:56.568252927 -0300
> +++ xfs/fs/xfs/xfs_dir2_node.c	2009-09-09 12:49:11.312322867 -0300
> @@ -123,7 +123,8 @@ xfs_dir2_leaf_to_node(
>  	__be16			*to;		/* pointer to freespace entry */
>  	xfs_trans_t		*tp;		/* transaction pointer */
>  
> -	xfs_dir2_trace_args_b("leaf_to_node", args, lbp);
> +	trace_xfs_dir2_leaf_to_node(args);
> +
>  	dp = args->dp;
>  	mp = dp->i_mount;
>  	tp = args->trans;

Another disk address buffer pointer trace.  I'll refrain from
commenting on the others.

> Index: xfs/fs/xfs/xfs_dir2_sf.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_dir2_sf.c	2009-09-09 12:33:56.572253716 -0300
> +++ xfs/fs/xfs/xfs_dir2_sf.c	2009-09-09 12:49:11.317273917 -0300
> @@ -654,7 +656,8 @@ xfs_dir2_sf_create(
>  	xfs_dir2_sf_t	*sfp;		/* shortform structure */
>  	int		size;		/* directory size */
>  
> -	xfs_dir2_trace_args_i("sf_create", args, pino);
> +	trace_xfs_dir2_sf_create(args);
> +
>  	dp = args->dp;
>  
>  	ASSERT(dp != NULL);

Is the parent inode number no longer useful information?

> Index: xfs/fs/xfs/xfs_error.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_error.c	2009-09-09 12:33:56.585252928 -0300
> +++ xfs/fs/xfs/xfs_error.c	2009-09-09 12:49:11.322256465 -0300
> @@ -217,3 +217,19 @@ xfs_corruption_error(
>  		xfs_hex_dump(p, 16);
>  	xfs_error_report(tag, level, mp, fname, linenum, ra);
>  }
> +
> +/*
> + * Format fsblock number into a static buffer & return it.
> + */
> +char *xfs_fmtfsblock(xfs_fsblock_t bno)
> +{
> +	static char rval[50];

Why 50?  37 is enough for +/- 2^63, and 50 isn't really much better
than that for alignment or anything.  Not a big deal.

> Index: xfs/fs/xfs/xfs_rw.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_rw.c	2009-09-09 12:33:56.670252999 -0300
> +++ xfs/fs/xfs/xfs_rw.c	2009-09-09 12:49:11.379255905 -0300
> @@ -171,7 +172,6 @@ xfs_bioerror(
>  	 * No need to wait until the buffer is unpinned.
>  	 * We aren't flushing it.
>  	 */
> -	xfs_buftrace("XFS IOERROR", bp);
>  	XFS_BUF_ERROR(bp, EIO);
>  	/*
>  	 * We're calling biodone, so delete B_DONE flag. Either way
> @@ -205,7 +205,6 @@ xfs_bioerror_relse(
>  	ASSERT(XFS_BUF_IODONE_FUNC(bp) != xfs_buf_iodone_callbacks);
>  	ASSERT(XFS_BUF_IODONE_FUNC(bp) != xlog_iodone);
>  
> -	xfs_buftrace("XFS IOERRELSE", bp);
>  	fl = XFS_BUF_BFLAGS(bp);
>  	/*
>  	 * No need to wait until the buffer is unpinned.

Why are you dropping tracing of these cases?

> Index: xfs/fs/xfs/xfs_vnodeops.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_vnodeops.c	2009-09-09 12:33:56.685253443 -0300
> +++ xfs/fs/xfs/xfs_vnodeops.c	2009-09-09 12:49:11.390256538 -0300
> @@ -53,6 +53,7 @@
>  #include "xfs_log_priv.h"
>  #include "xfs_filestream.h"
>  #include "xfs_vnodeops.h"
> +#include "xfs_trace.h"
>  
>  int
>  xfs_setattr(
> @@ -1380,7 +1381,6 @@ xfs_lookup(
>  	if (error)
>  		goto out_free_name;
>  
> -	xfs_itrace_ref(*ipp);
>  	return 0;
>  
>  out_free_name:


Why are you dropping tracing where xfs_itrace_ref() and
xfs_itrace_exit() was being called (here and elsewhere)?
Other than the spots where xfs_itrace_exit_tag() was used.

> Index: xfs/fs/xfs/xfs_attr_leaf.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_attr_leaf.c	2009-09-09 12:33:56.691253788 -0300
> +++ xfs/fs/xfs/xfs_attr_leaf.c	2009-09-09 12:49:11.394257187 -0300
>  @@ -653,7 +654,6 @@ xfs_attr_shortform_list(xfs_attr_list_co
>  			XFS_CORRUPTION_ERROR("xfs_attr_shortform_list",
>  					     XFS_ERRLEVEL_LOW,
>  					     context->dp->i_mount, sfe);
> -			xfs_attr_trace_l_c("sf corrupted", context);
>  			kmem_free(sbuf);
>  			return XFS_ERROR(EFSCORRUPTED);
>  		}

Why are you dropping tracing of the returns from this function?  Too
much output?

> @@ -2323,7 +2321,7 @@ xfs_attr_leaf_list_int(xfs_dabuf_t *bp, 
>  	cursor = context->cursor;
>  	cursor->initted = 1;
>  
> -	xfs_attr_trace_l_cl("blk start", context, leaf);
> +	trace_xfs_attr_list_leaf(context);
>  
>  	/*
>  	 * Re-find our place in the leaf block if this is a new syscall.

Is "leaf" no longer useful information?

> @@ -2419,7 +2417,7 @@ xfs_attr_leaf_list_int(xfs_dabuf_t *bp, 
>  			break;
>  		cursor->offset++;
>  	}
> -	xfs_attr_trace_l_cl("blk end", context, leaf);
> +	trace_xfs_attr_list_leaf_end(context);
>  	return(retval);
>  }

Is "leaf" no longer useful information?
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
