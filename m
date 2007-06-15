Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 14 Jun 2007 17:58:20 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5F0wGWt006912
	for <xfs@oss.sgi.com>; Thu, 14 Jun 2007 17:58:18 -0700
Date: Fri, 15 Jun 2007 10:58:11 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH, RFC] fix null files exposure growing via ftruncate
Message-ID: <20070615005811.GJ86004887@sgi.com>
References: <20070614063404.GW86004887@sgi.com> <20070614181446.GA16955@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070614181446.GA16955@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, Jun 14, 2007 at 07:14:46PM +0100, Christoph Hellwig wrote:
> On Thu, Jun 14, 2007 at 04:34:04PM +1000, David Chinner wrote:
> > Christoph,
> > 
> > Looking into the test 140 failure you reported, I realised that none
> > of the specific null files tests were being run automatically, which
> > is why I hadn't seen any of those failures (nor had the QA team).
> > That's being fixed.
> > 
> > I suspect that the test passes on Irix because of a coincidence
> > (the test sleeps for 10s and that is the default writeback
> > timeout for file data) which means when the filesystem is shut down
> > all the data is already on disk so it's not really testing
> > the NULL files fix.
> > 
> > The failure is due to the ftruncate() logging the new file size
> > before any data that had previously been written had hit the
> > disk. IOWs, it violates the data write/inode size update rule
> > that fixes the null files problem.
> > 
> > The fix here checks when growing the file as to whether it the disk
> > inode size is different to the in memory size. If they are
> > different, we have data that needs to be written to disk beyond the
> > existing on disk EOF. Hence to maintain ordering we need to flush
> > this data out before we log the changed file size.
> > 
> > I suspect the flush could be done more optimally - I've just done a
> > brute-force flush the entire file mod. Should we only flush from the
> > old di_size to the current i_size?
> > 
> > There may also be better ways to fix this. Any thoughts on
> > that?
> 
> Looks good enough for now, but I suspect just flushing from the old
> to the new size would be a quite nice performance improvement that's
> worth it.

Yeah, that's the way I was leaning. I'll mod the patch to do that and
repost. Thanks.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
