Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 25 Jul 2006 15:38:51 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6PMbtDW020869
	for <xfs@oss.sgi.com>; Tue, 25 Jul 2006 15:38:06 -0700
Date: Wed, 26 Jul 2006 08:37:09 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: review: increase bulkstat readahead window
Message-ID: <20060726083709.B2118045@wobbly.melbourne.sgi.com>
References: <20060725135004.E2116482@wobbly.melbourne.sgi.com> <20060725094004.GB29615@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060725094004.GB29615@infradead.org>; from hch@infradead.org on Tue, Jul 25, 2006 at 10:40:04AM +0100
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, cw@f00f.org
Cc: vapo@melbourne.sgi.com, xfs@oss.sgi.com

On Tue, Jul 25, 2006 at 10:40:04AM +0100, Christoph Hellwig wrote:
> On Tue, Jul 25, 2006 at 01:50:04PM +1000, Nathan Scott wrote:
> > .. it up front.  We don't want to get silly in sizing this buffer, 
> > though, as it needs to be a contiguous chunk of memory.  Here I've
> > increased it from 1 page to 4 pages, with some logic to halve the
> > size incrementally if we cant allocate that successfully (as we do
> > in one or two other places in XFS, for other things).
> 
> ok.  I wonder whether we should add a generic kmalloc_leastmost routine
> (with a name better than that of course..)

Yeah, Chris suggested the same thing - probably we should, since two
people suggested it now. :)  The XFS users I know of are the inode
hash, the dquot hash, and this bulkstat code.  Oh, and probably the
attr_multi ioctl code should use this for its buffer too.  If you can
suggest a good interface, I'll have at it.

Semi-related, I have another patch which instruments our local memory
allocation routines to add a KM_LARGE flag - I've been using this to
locate and annotate the few remaining places where we will do multi-
page allocations inside XFS... any interest in this patch?  I've been
tossing up whether or not to merge it (its debug only, so no runtime
cost is added for usual case), just so we can always easily see where
the large allocations are, and trap any inadvertantly introduced new
ones... thoughts?

cheers.

-- 
Nathan
