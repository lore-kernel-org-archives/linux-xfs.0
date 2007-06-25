Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 24 Jun 2007 22:45:46 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5P5jZdq017242
	for <xfs@oss.sgi.com>; Sun, 24 Jun 2007 22:45:41 -0700
Date: Mon, 25 Jun 2007 12:47:46 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Reducing memory requirements for high extent xfs files
Message-ID: <20070625024746.GJ86004887@sgi.com>
References: <200705301649.l4UGnckA027406@oss.sgi.com> <20070530225516.GB85884050@sgi.com> <4665E276.9020406@agami.com> <20070606013601.GR86004887@sgi.com> <4666EC56.9000606@agami.com> <20070606234723.GC86004887@sgi.com> <467C620E.4050005@agami.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <467C620E.4050005@agami.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Michael Nishimoto <miken@agami.com>
Cc: xfs@oss.sgi.com

On Fri, Jun 22, 2007 at 04:58:06PM -0700, Michael Nishimoto wrote:
> > > Also, should we consider a file with 1MB extents as
> > > fragmented?  A 100GB file with 1MB extents has 100k extents.
> >
> >Yes, that's fragmented - it has 4 orders of magnitude more extents
> >than optimal - and the extents are too small to allow reads or
> >writes to acheive full bandwidth on high end raid configs....
> 
> Fair enough, so multiply those numbers by 100 -- a 10TB file with 100MB
> extents.

If you've got 10TB of free space, the allocator should be doing a
better job than that ;)

> It seems to me that we can look at the negative effects of
> fragmentation in two ways here.  First, (regardless of size) if a file
> has a large number of extents, then it is too fragmented.  Second, if
> a file's extents are so small that we can't get full bandwidth, then it
> is too fragmented.

Yes, that is a fair observation.

The first case is really only a concern when the maximum extent size
(8GB on 4k fsb) becomes the limiting factor. That's at file sizes in
the hundreds of TB so we are not really in trouble there yet.

> If the second case were of primary concern, then it would be reasonable
> to have 1000s of extents as long as each of the extents were big enough
> to amortize disk latencies across a large amount of data.

*nod*

> We've been assuming that a good write is one which can send
> 2MB of data to a single drive; so with an 8+1 raid device, we need
> 16MB of write data to achieve high disk utilization.

Sure, and if you want really good write performance, you don't want
any seek between two lots of 16MB in the one file. which means that
the extent size really needs to be much larger than 16MB....

> In particular,
> there are flexibility advantages if high extent count files can
> still achieve good performance.

Sure. But there are many, many different options here that will
have an impact.

	- larger extent btree block size
	  	- reduces seeks to read the tree
	- btree defragmentation to reduce seek distance
	- smarter readahead to reduce I/O latency
	- special casing extent zero and the extents in that first block
	  to allow it to be brought in without the rest of the tree
	- critical block first retreival
	- demand paging
	
Of all of these options, demand paging is the most complex and
intrusive of the solutions. We should explore the simpler options
first to determine if they will solve your immediate problem.

FWIW, before we go changing any btree code, we really should
be unifying the various btree implementations in XFS.....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
