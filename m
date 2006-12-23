Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 22 Dec 2006 18:57:10 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kBN2v0qw012773
	for <xfs@oss.sgi.com>; Fri, 22 Dec 2006 18:57:02 -0800
Date: Sat, 23 Dec 2006 13:55:58 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Review: Clear unwritten flag on during partial page truncation
Message-ID: <20061223025558.GJ44411608@melbourne.sgi.com>
References: <20061220062813.GU44411608@melbourne.sgi.com> <1166681818.5572.190.camel@edge> <20061222132142.GA23416@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20061222132142.GA23416@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Nathan Scott <nscott@aconex.com>, David Chinner <dgc@sgi.com>, xfs-dev@sgi.com, xfs@oss.sgi.com

On Fri, Dec 22, 2006 at 01:21:42PM +0000, Christoph Hellwig wrote:
> On Thu, Dec 21, 2006 at 05:16:58PM +1100, Nathan Scott wrote:
> > On Wed, 2006-12-20 at 17:28 +1100, David Chinner wrote:
> > > Hence the solution is to clear the private buffer flags in
> > > xfs_vm_invalidatepage() so that when we extend the file the buffers
> > > on the page are all consistent.
> > > 
> > > Patch below. Comments?
> > 
> > Looks good Dave, nice sleuthing.
> > 
> > In hindsight, it'd have been really good to have gone for the real
> > BH_Unwritten flag upfront, and then being able to clear that inside
> > discard_buffer (like was done for BH_Delay)... if we did that, then
> > all this new code we're adding here (to just clear_buffer_unwritten,
> > ultimately) and also the complete hack in xfs_count_page_state could
> > be removed.  It still might be worth considering doing that, in case
> > there's other hard-to-hit-but-not-yet-uncovered bugs lurking along
> > the same lines.  But alot of effort, with the possibility of it not
> > being merged at all, as it touches code outside XFS.  D'oh.
> 
> Getting code into buffer.c to fix this properly should be no problem
> at all.  As usual we prefer to fix core code instead of working around
> it.  This would also fix the data loss issue after we write through mmap
> into an unwritten extent.

Ok, I'll work up a patch for it in the new year, Christoph.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
