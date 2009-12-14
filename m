Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBEMe1oM182747 for <xfs@oss.sgi.com>; Mon, 14 Dec 2009 16:40:01 -0600
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH 3/3] xfs: event tracing support
Date: Mon, 14 Dec 2009 16:40:36 -0600
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A684A@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <20091124235251.GA19841@infradead.org>
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

There is a problem with trace_xfs_bmap_insert().  It is
referenced once (in xfs_bmap_trace_exlist()), but never defined.
The reference does not match the prototype defined for the other
bmap tracepoints either.

Rather than trying to figure out what you intended I thought I'd
give you a chance to offer a fix.  If you do, please just send me
an update of that portion of the code if possible.  Meanwhile
I've commented out that reference and am going to try to complete
my review of this patch shortly.

Details are in the excerpts below.  I didn't add any commentary,
I'm just calling attention to the code I'm referring to.

					-Alex

> Convert the old xfs tracing support that could only be used with the out
> of tree kdb and xfsidbg patches to use the generic event tracer.
> 
> . . .
> 
>  70 files changed, 2148 insertions(+), 2563 deletions(-)
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> . . .
> 
> Index: linux-2.6/fs/xfs/linux-2.6/xfs_trace.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6/fs/xfs/linux-2.6/xfs_trace.h	2009-11-24 18:04:33.526006032 +0100
> @@ -0,0 +1,1368 @@
> +/*
> + * Copyright (c) 2009, Christoph Hellwig
> + * All Rights Reserved.
> . . .
> +
> +#define DEFINE_BMAP_EVENT(name) \
> +TRACE_EVENT(name, \
> +	TP_PROTO(struct xfs_inode *ip, xfs_extnum_t idx, int state, \
> +		 unsigned long caller_ip), \
> +	TP_ARGS(ip, idx, state, caller_ip), \
> +	TP_STRUCT__entry( \
> +		__field(dev_t, dev) \
> +		__field(xfs_ino_t, ino) \
> +		__field(xfs_extnum_t, idx) \
> +		__field(xfs_fileoff_t, startoff) \
> +		__field(xfs_fsblock_t, startblock) \
> +		__field(xfs_filblks_t, blockcount) \
> +		__field(xfs_exntst_t, state) \
> +		__field(int, bmap_state) \
> +		__field(unsigned long, caller_ip) \
> +	), \
> +	TP_fast_assign( \
> +		struct xfs_ifork	*ifp = (state & BMAP_ATTRFORK) ? \
> +						ip->i_afp : &ip->i_df; \
> +		struct xfs_bmbt_irec	r; \
> +	\
> +		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, idx), &r); \
> +		__entry->dev = VFS_I(ip)->i_sb->s_dev; \
> +		__entry->ino = ip->i_ino; \
> +		__entry->idx = idx; \
> +		__entry->startoff = r.br_startoff; \
> +		__entry->startblock = r.br_startblock; \
> +		__entry->blockcount = r.br_blockcount; \
> +		__entry->state = r.br_state; \
> +		__entry->bmap_state = state; \
> +		__entry->caller_ip = caller_ip; \
> +	), \
> +	TP_printk("dev %d:%d ino 0x%llx state %s idx %ld " \
> +		  "offset %lld block %s count %lld flag %d caller %pf", \
> +		  MAJOR(__entry->dev), MINOR(__entry->dev), \
> +		  __entry->ino, \
> +		  __print_flags(__entry->bmap_state, "|", XFS_BMAP_EXT_FLAGS), \
> +		  (long)__entry->idx, \
> +		  __entry->startoff, \
> +		  xfs_fmtfsblock(__entry->startblock), \
> +		  __entry->blockcount, \
> +		  __entry->state, \
> +		  (char *)__entry->caller_ip) \
> +)
> +
> +DEFINE_BMAP_EVENT(xfs_iext_remove);
> +DEFINE_BMAP_EVENT(xfs_bmap_pre_update);
> +DEFINE_BMAP_EVENT(xfs_bmap_post_update);
> +
> . . .
> 
> Index: linux-2.6/fs/xfs/xfs_bmap.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/xfs_bmap.c	2009-11-24 18:04:32.872254338 +0100
> +++ linux-2.6/fs/xfs/xfs_bmap.c	2009-11-24 18:04:33.590006432 +0100
> . . .
> @@ -4680,13 +4392,10 @@ xfs_bmap_trace_exlist(
>  	for (idx = 0; idx < cnt; idx++) {
>  		ep = xfs_iext_get_ext(ifp, idx);
>  		xfs_bmbt_get_all(ep, &s);
> -		XFS_BMAP_TRACE_INSERT("exlist", ip, idx, 1, &s, NULL,
> -			whichfork);
> +		trace_xfs_bmap_insert(ip, idx, &s, whichfork, "extlist");
>  	}
>  }
> -#endif
>  
> -#ifdef DEBUG
>  /*
>   * Validate that the bmbt_irecs being returned from bmapi are valid
>   * given the callers original parameters.  Specifically check the
> @@ -5435,7 +5144,8 @@ xfs_bunmapi(
> . . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
