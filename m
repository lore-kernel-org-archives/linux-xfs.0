Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 08 Jan 2007 15:05:33 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l08N5Pqw019389
	for <xfs@oss.sgi.com>; Mon, 8 Jan 2007 15:05:28 -0800
Date: Tue, 9 Jan 2007 10:04:29 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Review: fix mapping invalidation callouts
Message-ID: <20070108230429.GB33919298@melbourne.sgi.com>
References: <20070108040309.GX33919298@melbourne.sgi.com> <20070108090916.GA17121@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070108090916.GA17121@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: David Chinner <dgc@sgi.com>, xfs-dev@sgi.com, xfs@oss.sgi.com

On Mon, Jan 08, 2007 at 09:09:16AM +0000, Christoph Hellwig wrote:
> On Mon, Jan 08, 2007 at 03:03:09PM +1100, David Chinner wrote:
> > With the recent cancel_dirty_page() changes, a warning was
> > added if we cancel a dirty page that is still mapped into
> > the page tables.
> > This happens in XFS from fs_tosspages() and fs_flushinval_pages()
> > because they call truncate_inode_pages().
> > 
> > truncate_inode_pages() does not invalidate existing page mappings;
> > it is expected taht this is called only when truncating the file
> > or destroying the inode and on both these cases there can be
> > no mapped ptes. However, we call this when doing direct I/O writes
> > to remove pages from the page cache. As a result, we can rip
> > a page from the page cache that still has mappings attached.
> > 
> > The correct fix is to use invalidate_inode_pages2_range() instead
> > of truncate_inode_pages(). They essentially do the same thing, but
> > the former also removes any pte mappings before removing the page
> > from the page cache.
> > 
> > Comments?
> 
> Generally looks good.  But I feel a little cautios about changes in this
> area, so we should throw all possible test loads at this before commiting
> it.

Yup - fsx is one test that I really want to hit with this. The guy that
reported the initial problem has replied saying this patch fixes the
warnings (good start ;), but I'll hold off pushing it for a little
while to test it more. This (or something like it) will need to go
into 2.6.20 before it is released so we've got limited time to
test this one out....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
