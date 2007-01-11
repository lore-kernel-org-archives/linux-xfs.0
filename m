Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 11 Jan 2007 00:01:36 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l0B81Sqw031720
	for <xfs@oss.sgi.com>; Thu, 11 Jan 2007 00:01:30 -0800
Date: Thu, 11 Jan 2007 19:00:32 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Review: fix mapping invalidation callouts
Message-ID: <20070111080032.GD33919298@melbourne.sgi.com>
References: <20070108040309.GX33919298@melbourne.sgi.com> <20070110062344.GR33919298@melbourne.sgi.com> <45A4A645.5010708@sgi.com> <20070111064958.GC33919298@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070111064958.GC33919298@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Lachlan McIlroy <lachlan@sgi.com>, xfs-dev@sgi.com, xfs@oss.sgi.com

On Thu, Jan 11, 2007 at 05:49:58PM +1100, David Chinner wrote:
> On Wed, Jan 10, 2007 at 08:39:33AM +0000, Lachlan McIlroy wrote:
> > David Chinner wrote:
> > >>+#define XFS_OFF_TO_PCSIZE(off)	\
> > >>+	(((off) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT)
> > >
> > >
> > >I don't think this is right.
> > >
> > >Assuming 4k page size, first = 2k, last = 6k will result in
> > >invalidating page indexes 1 and 2 i.e. offset 4k -> 12k. In fact,
> > >we want to invalidate pages 0 and 1.
> > >
> > >IOWs, I think it should be:
> > >
> > >+#define XFS_OFF_TO_PCINDEX(off)	((off) >> PAGE_CACHE_SHIFT)
> > >
> > >Comments?
> > >
> > 
> > Makes sense to me.
> 
> Yeah, you'd think so. The first xfsqa run I do -after- checking it in
> (been running for 24 hours) I get a stack dump with the warning
> in cancel_dirty_page(), so clearly this isn't right either. I'm
> not sure WTF is going on here.

Of course, I just realised that this is 2.6.19 that I'm testing
on (fmeh) and so the code is different - cancel-dirty_page()
doesn't exist in this tree, and the warning is coming from
invalidate_inode_pages2_range() because invalidate_complete_page2()
is returning an error for some reason.....

Looks like it's a partial page truncation problem.
invalidate_inode_pages2_range() fails on partial page truncation
when part of the page (i.e. a bufferhead) is dirty.

This looks like a _big_ mess.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
