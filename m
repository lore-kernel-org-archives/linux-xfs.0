Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Jan 2007 04:31:02 -0800 (PST)
Received: from amsfep18-int.chello.nl (amsfep17-int.chello.nl [213.46.243.15] (may be forged))
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0OCUlqw024860
	for <xfs@oss.sgi.com>; Wed, 24 Jan 2007 04:30:54 -0800
Subject: Re: [PATCH 1/2]: Fix BUG in cancel_dirty_pages on XFS
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20070123223702.GF33919298@melbourne.sgi.com>
References: <20070123223702.GF33919298@melbourne.sgi.com>
Content-Type: text/plain
Date: Wed, 24 Jan 2007 13:13:55 +0100
Message-Id: <1169640835.6189.14.camel@twins>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@osdl.org

On Wed, 2007-01-24 at 09:37 +1100, David Chinner wrote:
> With the recent changes to cancel_dirty_pages(), XFS will
> dump warnings in the syslog because it can truncate_inode_pages()
> on dirty mapped pages.
> 
> I've determined that this is indeed correct behaviour for XFS
> as this can happen in the case of races on mmap()d files with
> direct I/O. In this case when we do a direct I/O read, we
> flush the dirty pages to disk, then truncate them out of the
> page cache. Unfortunately, between the flush and the truncate
> the mmap could dirty the page again. At this point we toss a
> dirty page that is mapped.

This sounds iffy, why not just leave the page in the pagecache if its
mapped anyway?

> None of the existing functions for truncating pages or invalidating
> pages work in this situation. Invalidating a page only works for
> non-dirty pages with non-dirty buffers, and they only work for
> whole pages and XFS requires partial page truncation.
> 
> On top of that the page invalidation functions don't actually
> call into the filesystem to invalidate the page and so the filesystem
> can't actually invalidate the page properly (e.g. do stuff based on
> private buffer head flags).

Have you seen the new launder_page() a_op? called from
invalidate_inode_pages2_range()

> So that leaves us needing to use truncate semantics and the problem
> is that none of them unmap pages in a non-racy manner - if they
> unmap pages they do it separately to the truncate of the page,
> leading to races with mmap redirtying the page between the unmap and
> the truncate ofthe page.

Isn't there still a race where the page fault path doesn't yet lock the
page and can just reinsert it?

Nick's pagefault rework should rid us of this by always locking the page
in the fault path.

> Hence we need a truncate function that unmaps the pages while they
> are locked for truncate in a similar fashion to
> invalidate_inode_pages2_range(). The following patch (unchanged from
> the last time it was sent) does this. The XFS changes are in a
> second patch.
> 
> The patch has been test on ia64 and x86-64 via XFSQA and a lot
> of fsx mixing mmap and direct I/O operations.
> 
> Signed-off-by: Dave Chinner <dgc@sgi.com>
