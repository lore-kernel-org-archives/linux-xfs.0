Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:52515 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726355AbeKBGnR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Nov 2018 02:43:17 -0400
Date: Fri, 2 Nov 2018 08:37:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: don't preempt writeback sequence on single page
 wb error
Message-ID: <20181101213740.GA19305@dastard>
References: <20181031140155.17996-1-bfoster@redhat.com>
 <20181031140155.17996-3-bfoster@redhat.com>
 <20181031230225.GX19305@dastard>
 <20181101141726.GA25816@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181101141726.GA25816@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Nov 01, 2018 at 10:17:26AM -0400, Brian Foster wrote:
> On Thu, Nov 01, 2018 at 10:02:25AM +1100, Dave Chinner wrote:
> > On Wed, Oct 31, 2018 at 10:01:55AM -0400, Brian Foster wrote:
> > > xfs_do_writepage() currently returns errors directly regardless of
> > > whether it is called via ->writepages() or ->writepage(). In the
> > > case of ->writepages(), an xfs_do_writepage() error return breaks
> > > the current writeback sequence in write_cache_pages(). This means
> > > that an integrity writeback (i.e., sync), for example, returns
> > > before all associated pages have been processed.
> > 
> > That sounds like a bug in write_cache_pages(). It sends pages
> > one at a time to the writepage context, and it is supposed to
> > iterate the entire range on a data sync operation. If you look at
> > the code, is clearly stopping at the first error.
> > 
> > IOWs, every filesystem that uses write_cache_pages() for data
> > integrity writes is broken in the same way.
> > 
> > And a quick look as fs specific writepages implementations indicates
> > that ext4_writepages() and ibtrfs's extent_write_cache_pages() have
> > the same issue.
> > 
> 
> I veered away from this approach initially because I didn't want to risk
> breaking behavior of other filesystems. I can revisit it if more
> appropriate and is broadly safe.

We should fix problems in the generic code if that's where the
problem lies. You can ignore filesystems with their own custom code,
though, because you are more likely to break them that generic
code...

> > > This can be problematic in cases like unmount. If the writeback
> > > doesn't process all delalloc pages before unmounting, we end up
> > > reclaiming inodes with non-zero delalloc block counts. In turn, this
> > > breaks block accounting and leaves the fs inconsistent.
> > 
> > XFS is probably the only filesystem that leaves detectable state
> > around and then detects and reports it....
> > 
> > > XFS explicitly discards delalloc blocks on such writepage failures
> > > to avoid this problem. This isn't terribly useful if we allow an
> > > integrity writeback to complete (and thus a filesystem to unmount)
> > > without addressing the entire set of dirty pages on an inode.
> > > Therefore, change ->writepage[s]() to track high level error state
> > > in the xfs_writepage_ctx structure and return it from the higher
> > > level operation callout rather than xfs_do_writepage(). This ensures
> > > that write_cache_pages() does not exit prematurely when called via
> > > ->writepages(), but both ->writepage() and ->writepages() still
> > > ultimately return an error for the higher level operation.
> > > 
> > > This patch introduces a subtle change in the behavior of background
> > > writeback in the event of persistent errors. The current behavior of
> > > returning an error preempts the background writeback. Writeback
> > > eventually comes around again and repeats the process for a few more
> > > pages (in practice) before it once again fails. This repeats over
> > > and over until the entire set of dirty pages is cleaned. This
> > > behavior results in a somewhat slower stream of "page discard"
> > > errors in the system log and dictates that many repeated fsync calls
> > > may be required before the entire data set is processed and mapping
> > > error consumed. With this change in place, background writeback
> > > executes on as many pages as necessary as if each page writeback
> > > were successful. The pages are cleaned immediately and significantly
> > > more page discard errors can be observed at once.
> > 
> > Yeah, this is a good change in behaviour, but I think the
> > implementation is wrong. write_cache_pages() needs to continue
> > iterating the range if WB_SYNC_ALL is set even when errors occur.
> > 
> 
> The other thing that comes to mind is that any time we have this kind of
> iterative/callback interface, it's usually appropriate to have some kind
> of means for the callback to signal the caller to stop processing. You
> could argue that right now write_cache_pages() works as expected,
> returning an error is that stop mechanism and XFS has the bug as it is
> the only filesystem that depends on completely processing integrity wbs
> for fs correctness (or we're all just using it wrong ;P, I haven't
> investigated enough yet to say one way or the other).

The comment on wcp error handling is enlightening:

		ret = (*writepage)(page, wbc, data);
		if (unlikely(ret)) {
			if (ret == AOP_WRITEPAGE_ACTIVATE) {
				unlock_page(page);
				ret = 0;
			} else {
				/*
				 * done_index is set past this page,
				 * so media errors will not choke
				 * background writeout for the entire
				 * file. This has consequences for
				 * range_cyclic semantics (ie. it may
				 * not be suitable for data integrity
				 * writeout).
				 */
				done_index = page->index + 1;
				done = 1;
				break;
			}
		}

"ie it may not be suitable for data integrity writeout"

In a nutshell. The current error handling behaviour is not suitable
for data integrity writeout, as your proposed patch has demonstrated.


> OTOH, we could maintain the ability to interrupt the scan with a magic
> error return or some such, that just may require a bit more care and
> attention across the set of existing callers. Thoughts?

I'm not sure why we'd want "stop on error" for data integrity
writeback given the problems you've pointed out.  For WB_SYNC_NONE
writeback, the current behaviour (stop on error) is fine, so i don't
see a big need to make unnecessary API changes here.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
