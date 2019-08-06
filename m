Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:52906 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726092AbfHFFvl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Aug 2019 01:51:41 -0400
Date: Mon, 5 Aug 2019 22:51:40 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 11/24] xfs:: account for memory freed from metadata
 buffers
Message-ID: <20190806055139.GA25736@infradead.org>
References: <20190801021752.4986-1-david@fromorbit.com>
 <20190801021752.4986-12-david@fromorbit.com>
 <20190801081603.GA10600@infradead.org>
 <20190801092133.GK7777@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190801092133.GK7777@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org

On Thu, Aug 01, 2019 at 07:21:33PM +1000, Dave Chinner wrote:
> > static inline void shrinker_mark_pages_reclaimed(unsigned long nr_pages)
> > {
> > 	if (current->reclaim_state)
> > 		current->reclaim_state->reclaimed_pages += nr_pages;
> > }
> > 
> > plus good documentation on when to use it.
> 
> Sure, but that's something for patch 6, not this one :)

Sounds good, I just skimmend through the XFS patches.  While we are at
it:  there is a double : in the subject line.
