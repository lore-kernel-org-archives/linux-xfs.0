Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 22 Dec 2006 05:50:58 -0800 (PST)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBMDopqw006709
	for <xfs@oss.sgi.com>; Fri, 22 Dec 2006 05:50:53 -0800
Date: Fri, 22 Dec 2006 13:21:42 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Review: Clear unwritten flag on during partial page truncation
Message-ID: <20061222132142.GA23416@infradead.org>
References: <20061220062813.GU44411608@melbourne.sgi.com> <1166681818.5572.190.camel@edge>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1166681818.5572.190.camel@edge>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nscott@aconex.com>
Cc: David Chinner <dgc@sgi.com>, xfs-dev@sgi.com, xfs@oss.sgi.com

On Thu, Dec 21, 2006 at 05:16:58PM +1100, Nathan Scott wrote:
> On Wed, 2006-12-20 at 17:28 +1100, David Chinner wrote:
> > Hence the solution is to clear the private buffer flags in
> > xfs_vm_invalidatepage() so that when we extend the file the buffers
> > on the page are all consistent.
> > 
> > Patch below. Comments?
> 
> Looks good Dave, nice sleuthing.
> 
> In hindsight, it'd have been really good to have gone for the real
> BH_Unwritten flag upfront, and then being able to clear that inside
> discard_buffer (like was done for BH_Delay)... if we did that, then
> all this new code we're adding here (to just clear_buffer_unwritten,
> ultimately) and also the complete hack in xfs_count_page_state could
> be removed.  It still might be worth considering doing that, in case
> there's other hard-to-hit-but-not-yet-uncovered bugs lurking along
> the same lines.  But alot of effort, with the possibility of it not
> being merged at all, as it touches code outside XFS.  D'oh.

Getting code into buffer.c to fix this properly should be no problem
at all.  As usual we prefer to fix core code instead of working around
it.  This would also fix the data loss issue after we write through mmap
into an unwritten extent.

> 
> FWIW, GFS seems to have managed to do even worse here, and looks like
> they have dup'd big chunks of buffer.c ... has a discard_buffer() copy
> and invalidate_page and probably others which are closely derived from
> the equivalent buffer.c code ... guess those guys (hi Russell) could
> do some code rationalisation in this area too before they get bitten.

GFS has crap code, news at 11 ;-)
