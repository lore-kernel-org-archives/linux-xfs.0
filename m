Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 09 Jan 2007 03:58:40 -0800 (PST)
Received: from imr2.americas.sgi.com (imr2.americas.sgi.com [198.149.16.18])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l09BwZqw028773
	for <xfs@oss.sgi.com>; Tue, 9 Jan 2007 03:58:35 -0800
Message-ID: <45A38332.40506@sgi.com>
Date: Tue, 09 Jan 2007 11:57:38 +0000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: Review: fix mapping invalidation callouts
References: <20070108040309.GX33919298@melbourne.sgi.com> <20070108090916.GA17121@infradead.org> <20070108230429.GB33919298@melbourne.sgi.com>
In-Reply-To: <20070108230429.GB33919298@melbourne.sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-dev@sgi.com, xfs@oss.sgi.com

David Chinner wrote:
> On Mon, Jan 08, 2007 at 09:09:16AM +0000, Christoph Hellwig wrote:
> 
>>On Mon, Jan 08, 2007 at 03:03:09PM +1100, David Chinner wrote:
>>
>>>With the recent cancel_dirty_page() changes, a warning was
>>>added if we cancel a dirty page that is still mapped into
>>>the page tables.
>>>This happens in XFS from fs_tosspages() and fs_flushinval_pages()
>>>because they call truncate_inode_pages().
>>>
>>>truncate_inode_pages() does not invalidate existing page mappings;
>>>it is expected taht this is called only when truncating the file
>>>or destroying the inode and on both these cases there can be
>>>no mapped ptes. However, we call this when doing direct I/O writes
>>>to remove pages from the page cache. As a result, we can rip
>>>a page from the page cache that still has mappings attached.
>>>
>>>The correct fix is to use invalidate_inode_pages2_range() instead
>>>of truncate_inode_pages(). They essentially do the same thing, but
>>>the former also removes any pte mappings before removing the page
>>>from the page cache.
>>>
>>>Comments?
>>
>>Generally looks good.  But I feel a little cautios about changes in this
>>area, so we should throw all possible test loads at this before commiting
>>it.
> 
> 
> Yup - fsx is one test that I really want to hit with this. The guy that
> reported the initial problem has replied saying this patch fixes the
> warnings (good start ;), but I'll hold off pushing it for a little
> while to test it more. This (or something like it) will need to go
> into 2.6.20 before it is released so we've got limited time to
> test this one out....
> 

This patch fixes fs_tosspages() and fs_flushinval_pages() but will a
call to fs_flush_pages() with flags including B_INVAL work correctly?
I can't see any code that passes B_INVAL into fs_flush_pages() but it
should probably support it.
