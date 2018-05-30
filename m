Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:59216 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935672AbeE3GRU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 30 May 2018 02:17:20 -0400
Date: Wed, 30 May 2018 08:23:37 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 15/34] iomap: add an iomap-based readpage and readpages
        implementation
Message-ID: <20180530062337.GA25732@lst.de>
References: <20180523144357.18985-1-hch@lst.de> <20180523144357.18985-16-hch@lst.de> <20180530061146.GD30110@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180530061146.GD30110@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org

On Tue, May 29, 2018 at 11:11:46PM -0700, Darrick J. Wong wrote:
> > +		list_del(&page->lru);
> > +		if (!add_to_page_cache_lru(page, inode->i_mapping, page->index,
> > +				GFP_NOFS))
> 
> I'm curious about this line -- if add_to_page_cache_lru returns an
> error, why don't we want to send that back up the stack?  Is the idea
> that the page doesn't become uptodate and something else notices?   It
> seems a little odd that on error we just skip to the next page.
> 
> (If this /is/ correct then comment is needed here.)

readpages is only used for read-ahead, so the upper layers literally
don't care as long as we don't mess up the page refcount.  This logic
is taken straight from mpage_readpages, but I'll add a comment anyway.
