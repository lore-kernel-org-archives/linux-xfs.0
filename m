Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Dec 2006 03:38:26 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kBLBcJqw030688
	for <xfs@oss.sgi.com>; Thu, 21 Dec 2006 03:38:21 -0800
Date: Thu, 21 Dec 2006 22:37:24 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Review: Clear unwritten flag on during partial page truncation
Message-ID: <20061221113724.GK33919298@melbourne.sgi.com>
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
> discard_buffer (like was done for BH_Delay)...  if we did that, then
> all this new code we're adding here (to just clear_buffer_unwritten,
> ultimately) and also the complete hack in xfs_count_page_state could
> be removed.  It still might be worth considering doing that, in case
> there's other hard-to-hit-but-not-yet-uncovered bugs lurking along
> the same lines.  But alot of effort, with the possibility of it not
> being merged at all, as it touches code outside XFS.  D'oh.

Yep, pretty much my thinking as well.

I forgot about that hack in xfs_count_page_state() - we should
be able to remove that with this change, right?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
