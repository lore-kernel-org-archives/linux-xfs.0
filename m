Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Jan 2007 06:11:26 -0800 (PST)
Received: from smtp104.mail.mud.yahoo.com (smtp104.mail.mud.yahoo.com [209.191.85.214])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l0OEBHqw016067
	for <xfs@oss.sgi.com>; Wed, 24 Jan 2007 06:11:18 -0800
Message-ID: <45B7627B.8050202@yahoo.com.au>
Date: Thu, 25 Jan 2007 00:43:23 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2]: Fix BUG in cancel_dirty_pages on XFS
References: <20070123223702.GF33919298@melbourne.sgi.com> <1169640835.6189.14.camel@twins>
In-Reply-To: <1169640835.6189.14.camel@twins>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@osdl.org

Peter Zijlstra wrote:
> On Wed, 2007-01-24 at 09:37 +1100, David Chinner wrote:
> 
>>With the recent changes to cancel_dirty_pages(), XFS will
>>dump warnings in the syslog because it can truncate_inode_pages()
>>on dirty mapped pages.
>>
>>I've determined that this is indeed correct behaviour for XFS
>>as this can happen in the case of races on mmap()d files with
>>direct I/O. In this case when we do a direct I/O read, we
>>flush the dirty pages to disk, then truncate them out of the
>>page cache. Unfortunately, between the flush and the truncate
>>the mmap could dirty the page again. At this point we toss a
>>dirty page that is mapped.
> 
> 
> This sounds iffy, why not just leave the page in the pagecache if its
> mapped anyway?

And why not just leave it in the pagecache and be done with it?

All you need is to do a writeout before a direct IO read, which is
what generic dio code does.

I guess you'll say that direct writes still need to remove pages,
but in that case you'll either have to live with some racyness
(which is what the generic code does), or have a higher level
synchronisation to prevent buffered + direct IO writes I suppose?

>>None of the existing functions for truncating pages or invalidating
>>pages work in this situation. Invalidating a page only works for
>>non-dirty pages with non-dirty buffers, and they only work for
>>whole pages and XFS requires partial page truncation.
>>
>>On top of that the page invalidation functions don't actually
>>call into the filesystem to invalidate the page and so the filesystem
>>can't actually invalidate the page properly (e.g. do stuff based on
>>private buffer head flags).
> 
> 
> Have you seen the new launder_page() a_op? called from
> invalidate_inode_pages2_range()

It would have been nice to make that one into a more potentially
useful generic callback.

But why was it introduced, exactly? I can't tell from the code or
the discussion why NFS couldn't start the IO, and signal the caller
to wait_on_page_writeback and retry? That seemed to me like the
convetional fix.

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
