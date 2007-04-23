Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Apr 2007 14:49:38 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3NLnZfB014590
	for <xfs@oss.sgi.com>; Mon, 23 Apr 2007 14:49:36 -0700
Date: Mon, 23 Apr 2007 22:22:01 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: review: allocate alloc args
Message-ID: <20070423212201.GB13572@infradead.org>
References: <20070419073216.GT48531920@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070419073216.GT48531920@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, Apr 19, 2007 at 05:32:16PM +1000, David Chinner wrote:
> 
> Save some stack space in the critical allocator paths
> by allocating the xfs_alloc_arg_t structures (104 bytes
> on 64bit, 88 bytes on 32bit systems) rather than placing
> them on the stack.
> 
> There can be more than one of these structures on the stack
> through the critical allocation path (e.g. xfs_bmap_btalloc()
> and xfs_alloc_fix_freelist()) so there are significant
> savings to be had here...

I don't like doing even more dynamic allocations that deep
down in the stack.  Can we try another approach and see if
we really need the full structure in all places but could
rather pass down a few arguments or a smaller structure instead?
I've done some work on that in the dir good with quite good results
a while ago (and yes, I need to bring it up to date and send it out)
