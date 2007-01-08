Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 08 Jan 2007 01:21:16 -0800 (PST)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l089LAqw025065
	for <xfs@oss.sgi.com>; Mon, 8 Jan 2007 01:21:11 -0800
Date: Mon, 8 Jan 2007 09:09:16 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Review: fix mapping invalidation callouts
Message-ID: <20070108090916.GA17121@infradead.org>
References: <20070108040309.GX33919298@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070108040309.GX33919298@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev@sgi.com, xfs@oss.sgi.com

On Mon, Jan 08, 2007 at 03:03:09PM +1100, David Chinner wrote:
> With the recent cancel_dirty_page() changes, a warning was
> added if we cancel a dirty page that is still mapped into
> the page tables.
> This happens in XFS from fs_tosspages() and fs_flushinval_pages()
> because they call truncate_inode_pages().
> 
> truncate_inode_pages() does not invalidate existing page mappings;
> it is expected taht this is called only when truncating the file
> or destroying the inode and on both these cases there can be
> no mapped ptes. However, we call this when doing direct I/O writes
> to remove pages from the page cache. As a result, we can rip
> a page from the page cache that still has mappings attached.
> 
> The correct fix is to use invalidate_inode_pages2_range() instead
> of truncate_inode_pages(). They essentially do the same thing, but
> the former also removes any pte mappings before removing the page
> from the page cache.
> 
> Comments?

Generally looks good.  But I feel a little cautios about changes in this
area, so we should throw all possible test loads at this before commiting
it.
