Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 29 Jul 2008 18:38:16 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6U1cEwZ009861
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 18:38:14 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6DB54ED090D
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 18:39:26 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id 1h59Ma1tvQ7aaFYU for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 18:39:26 -0700 (PDT)
Date: Wed, 30 Jul 2008 11:39:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 08/21] make btree tracing generic
Message-ID: <20080730013920.GI13395@disturbed>
References: <20080729193044.GI19104@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729193044.GI19104@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Tue, Jul 29, 2008 at 09:30:44PM +0200, Christoph Hellwig wrote:
> make the existing bmap btree tracing generic so that it applies to all
> btree types.
> 
> Some fragments lifted from a patch by Dave Chinner.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6-xfs/fs/xfs/xfs_btree.h
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_btree.h	2008-07-29 16:23:23.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_btree.h	2008-07-29 16:52:06.000000000 +0200
> @@ -190,6 +190,25 @@ struct xfs_btree_ops {
>  
>  	/* get inode rooted btree root */
>  	struct xfs_btree_block *(*get_root_from_inode)(struct xfs_btree_cur *);
> +
> +	/* btree tracing */
> +#ifdef XFS_BTREE_TRACE
> +	void		(*trace_enter)(struct xfs_btree_cur *, const char *,
> +				       char *, int, int, __psunsigned_t,
> +				       __psunsigned_t, __psunsigned_t,
> +				       __psunsigned_t, __psunsigned_t,
> +				       __psunsigned_t, __psunsigned_t,
> +				       __psunsigned_t, __psunsigned_t,
> +				       __psunsigned_t, __psunsigned_t);

Would it be better to use a 'trace args' structure here rather
than passing a heap of parameters? memset(args, 0,...) rather than
passing a whole heap of zeros in most cases seems like a better
approach to me, esp. as they all get cast to (void *) anyway....

> +static void
> +xfsidb_btree_trace_record(

shouldn't these all use "xfsidbg" prefixes?

Otherwise looks ok.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
