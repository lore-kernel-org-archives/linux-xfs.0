Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:47814 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729426AbfHAIQE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Aug 2019 04:16:04 -0400
Date: Thu, 1 Aug 2019 01:16:03 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 11/24] xfs:: account for memory freed from metadata
 buffers
Message-ID: <20190801081603.GA10600@infradead.org>
References: <20190801021752.4986-1-david@fromorbit.com>
 <20190801021752.4986-12-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190801021752.4986-12-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org

> +
> +		/*
> +		 * Account for the buffer memory freed here so memory reclaim
> +		 * sees this and not just the xfs_buf slab entry being freed.
> +		 */
> +		if (current->reclaim_state)
> +			current->reclaim_state->reclaimed_pages += bp->b_page_count;
> +

I think this wants a mm-layer helper ala:

static inline void shrinker_mark_pages_reclaimed(unsigned long nr_pages)
{
	if (current->reclaim_state)
		current->reclaim_state->reclaimed_pages += nr_pages;
}

plus good documentation on when to use it.
