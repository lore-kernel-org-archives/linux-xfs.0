Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Aug 2007 17:05:42 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7O05a4p020884
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 17:05:39 -0700
Date: Fri, 24 Aug 2007 10:05:23 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 6/17] move v_trace from bhv_vnode to xfs_inode
Message-ID: <20070824000523.GA72985246@sgi.com>
References: <20070823193834.GG8050@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070823193834.GG8050@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Thu, Aug 23, 2007 at 09:38:34PM +0200, Christoph Hellwig wrote:
> struct bhv_vnode is on it's way out, so move the trace buffer to the
> XFS inode.  Note that this makes the tracing macros rather misnamed,
> but this kind of fallout will be fixed up incrementally later on.
....

> @@ -197,11 +192,11 @@ vn_hold(
>  #ifdef	XFS_VNODE_TRACE
>  
>  #define KTRACE_ENTER(vp, vk, s, line, ra)			\
> -	ktrace_enter(	(vp)->v_trace,				\
> +	ktrace_enter(	(ip)->i_trace,				\
>  /*  0 */		(void *)(__psint_t)(vk),		\
>  /*  1 */		(void *)(s),				\
>  /*  2 */		(void *)(__psint_t) line,		\
> -/*  3 */		(void *)(__psint_t)(vn_count(vp)),	\
> +/*  3 */		NULL,					\

given that vn_count() returns the linux inode i_count, shouldn't
we put that here as well rather than killing it? It is sometimes
useful to see what is happening with the reference count in the
traces....

> +#ifdef	XFS_VNODE_TRACE
> +	ip->i_trace = ktrace_alloc(VNODE_TRACE_SIZE, KM_SLEEP);
> +#endif

At some point we need to change that define as well. More
cosmetic stuff, though.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
