Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:36584 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729449AbfHAJWo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Aug 2019 05:22:44 -0400
Date: Thu, 1 Aug 2019 19:21:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 11/24] xfs:: account for memory freed from metadata
 buffers
Message-ID: <20190801092133.GK7777@dread.disaster.area>
References: <20190801021752.4986-1-david@fromorbit.com>
 <20190801021752.4986-12-david@fromorbit.com>
 <20190801081603.GA10600@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190801081603.GA10600@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org

On Thu, Aug 01, 2019 at 01:16:03AM -0700, Christoph Hellwig wrote:
> > +
> > +		/*
> > +		 * Account for the buffer memory freed here so memory reclaim
> > +		 * sees this and not just the xfs_buf slab entry being freed.
> > +		 */
> > +		if (current->reclaim_state)
> > +			current->reclaim_state->reclaimed_pages += bp->b_page_count;
> > +
> 
> I think this wants a mm-layer helper ala:
> 
> static inline void shrinker_mark_pages_reclaimed(unsigned long nr_pages)
> {
> 	if (current->reclaim_state)
> 		current->reclaim_state->reclaimed_pages += nr_pages;
> }
> 
> plus good documentation on when to use it.

Sure, but that's something for patch 6, not this one :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
