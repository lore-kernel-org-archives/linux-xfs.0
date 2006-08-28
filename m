Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 28 Aug 2006 14:40:17 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7SLdrDW004636
	for <xfs@oss.sgi.com>; Mon, 28 Aug 2006 14:39:54 -0700
Date: Mon, 28 Aug 2006 21:38:39 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: review: change default realtime extsize
Message-ID: <20060828203839.GA719@infradead.org>
References: <20060828133132.A3124842@wobbly.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060828133132.A3124842@wobbly.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nathans@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, Aug 28, 2006 at 01:31:32PM +1000, Nathan Scott wrote:
> Hi,
> 
> While testing something else recently, I noticed we were always
> creating a large number of unwritten extents during page cache
> writout to the realtime subvolume.  It turned out to be because
> of the way we are typically called with page sized allocation
> requests, but we always allocate much more than a page.  Back
> when realtime subvols could only use direct I/O this was fine
> (apps typically used larger IO sizes) but now its not so good.
> 
> These larger allocations are ending up meaning we need to do many
> additional unwritten extent conversions (i.e. more transactions,
> and more log traffic), which we can easily avoid.  Since we have
> a default 4K filesystem blocksize on the data device, there would
> seem to be no harm in matching that on the realtime subvolume, by
> default.  This simple mkfs tweak does just that...

That description makes sense, and given that the one-liner diff is
obviously correct.  ACK from me.
