Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 25 Jul 2006 03:51:45 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6PAp7DY001440
	for <xfs@oss.sgi.com>; Tue, 25 Jul 2006 03:51:10 -0700
Date: Tue, 25 Jul 2006 10:40:04 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: review: increase bulkstat readahead window
Message-ID: <20060725094004.GB29615@infradead.org>
References: <20060725135004.E2116482@wobbly.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060725135004.E2116482@wobbly.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nathans@sgi.com>
Cc: vapo@melbourne.sgi.com, xfs@oss.sgi.com

On Tue, Jul 25, 2006 at 01:50:04PM +1000, Nathan Scott wrote:
> Hi all,
>     
> We limit the amount of bulkstat readahead we can issue based on 
> the size of the array of inode cluster records (irbuf), which we
> allocate on each bulkstat call.  Increasing the size of this array
> has shown noticable performance improvements, and given bulkstat
> is always called to scan the filesystem from one end to the other,
> we're going to have to issue that IO at some point, may as well do
> it up front.  We don't want to get silly in sizing this buffer, 
> though, as it needs to be a contiguous chunk of memory.  Here I've
> increased it from 1 page to 4 pages, with some logic to halve the
> size incrementally if we cant allocate that successfully (as we do
> in one or two other places in XFS, for other things).

ok.  I wonder whether we should add a generic kmalloc_leastmost routine
(with a name better than that of course..)
