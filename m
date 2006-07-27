Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 27 Jul 2006 16:19:24 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6RNIODW006209
	for <xfs@oss.sgi.com>; Thu, 27 Jul 2006 16:18:36 -0700
Date: Fri, 28 Jul 2006 09:17:35 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: review: increase bulkstat readahead window
Message-ID: <20060728091735.B2196410@wobbly.melbourne.sgi.com>
References: <20060725135004.E2116482@wobbly.melbourne.sgi.com> <20060725094004.GB29615@infradead.org> <20060726083709.B2118045@wobbly.melbourne.sgi.com> <20060726102551.GA9141@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060726102551.GA9141@infradead.org>; from hch@infradead.org on Wed, Jul 26, 2006 at 11:25:51AM +0100
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: cw@f00f.org, vapo@melbourne.sgi.com, xfs@oss.sgi.com

On Wed, Jul 26, 2006 at 11:25:51AM +0100, Christoph Hellwig wrote:
> Maybe we can start with a common XFS routine first:
> 
> kmem_alloc_greedy(size_t *size, size_t minsize, unsigned int flags)

Looks good, I'll create a patch & send out later today.  Actually,
we could say minsize is 1 page, and simplify - for our uses in XFS,
that will suffice... or dya want that extra parameter for the more
generic version later?

> > cost is added for usual case), just so we can always easily see where
> > the large allocations are, and trap any inadvertantly introduced new
> > ones... thoughts?
> 
> I'm happy with that flag, but I'd prefer it only allocations with
> KM_LARGE would go to vmalloc so that we can start to untangle the
> allocator wrapping mess.

Yep - that was the other reason why I started down that path - I'm not
convinced we really need the vmalloc calls anymore, we don't get near
the max slab cutoff on my i386 test box anyway, AFAICT.  Long term, we
should be removing the vmalloc call, but needs more beating to be sure
nothing can get there nowadays - ultimately we should just BUG_ON over
a max size (below the current vmalloc cutoff).

cheers.

-- 
Nathan
