Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Jan 2007 23:41:36 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l0P7fRqw027409
	for <xfs@oss.sgi.com>; Wed, 24 Jan 2007 23:41:29 -0800
Date: Thu, 25 Jan 2007 18:40:18 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 1/2]: Fix BUG in cancel_dirty_pages on XFS
Message-ID: <20070125074018.GB33919298@melbourne.sgi.com>
References: <1169640835.6189.14.camel@twins> <45B7627B.8050202@yahoo.com.au> <20070124224654.GN33919298@melbourne.sgi.com> <45B7F5F9.2070308@yahoo.com.au> <20070125003536.GS33919298@melbourne.sgi.com> <45B7FE1C.3070807@yahoo.com.au> <20070125015204.GV33919298@melbourne.sgi.com> <45B80F65.6010206@yahoo.com.au> <20070125034227.GX33919298@melbourne.sgi.com> <45B83139.1040007@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45B83139.1040007@yahoo.com.au>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: David Chinner <dgc@sgi.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@osdl.org

On Thu, Jan 25, 2007 at 03:25:29PM +1100, Nick Piggin wrote:
> David Chinner wrote:
> >On Thu, Jan 25, 2007 at 01:01:09PM +1100, Nick Piggin wrote:
> >
> >>David Chinner wrote:
> 
> >>>No. The only thing that will happen here is that the direct read
> >>>will see _none_ of the write because the mmap write occurred during
> >>>the DIO read to a different set of pages in memory. There is no
> >>>"some" or "all" case here.
> >>
> >>But if the buffers get partially or completely written back in the
> >>meantime, then the DIO read could see that.
> >
> >
> >Only if you can dirty them and flush them to disk while the direct
> >read is waiting in the I/O queue (remember, the direct read flushes
> >dirty cached data before being issued). Given that we don't lock the
> >inode in the buffered I/O *writeback* path, we have to stop pages being
> >dirtied in the page cache up front so we don't have mmap writeback
> >over the top of the direct read.
> 
> However unlikely it may be, that is what I'm talking about in my "some"
> or "all" cases. Note that I'm not talking about a specific implementation
> (eg. XFS I guess avoids "some"), but just the possible scenarios.

Unfortunately, behaviour is different for different filesystems. I
can only answer for XFS, which is different to most of the other
filesystems in both locking and the way it treats the page cache.
IOWs, if you want to talk about details, then have to talk about
specific implementations because.....


> >Hence we have to prevent mmap for dirtying the same file offset we
> >are doing direct reads on until the direct read has been issued.
> >
> >i.e. we need a barrier.
> 
> So you need to eliminate the "some" case? Because of course "none" and
> "all" are unavoidable.

"all" is avoidable, too, once you've kicked the pages out of
the page cache - you just have to block the buffered read triggered
by refaulting the page will cause until the direct I/O completes.

> >>>IOWs, at a single point in time we have 2 different views
> >>>of the one file which are both apparently valid and that is what
> >>>we are trying to avoid. We have a coherency problem here which is
> >>>solved by forcing the mmap write to reread the data off disk....
> >>
> >>I don't see why the mmap write needs to reread data off disk. The
> >>data on disk won't get changed by the DIO read.
> >
> >
> >No, but the data _in memory_ will, and now when the direct read
> >completes it will data that is different to what is in the page
> >cache. For direct I/O we define the correct data to be what is on
> >disk, not what is in memory, so any time we bypass what is in
> >memory, we need to ensure that we prevent the data being changed
> >again in memory before we issue the disk I/O.
> 
> But when you drop your locks, before the direct IO read returns, some
> guy can mmap and dirty the pagecache anyway.
> By the time the read returns, the data is stale.

Only if we leave the page in the page cache. If we toss the page,
the time it takes to do the I/O for the page fault is enough for
the direct I/o to complete. Sure it's not an absolute guarantee,
but if you want an absolute guarantee:

> This obviously must be synchronised in
> userspace.

As I said earlier.....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
