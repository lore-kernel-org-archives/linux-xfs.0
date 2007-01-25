Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Jan 2007 19:43:48 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l0P3hcqw007343
	for <xfs@oss.sgi.com>; Wed, 24 Jan 2007 19:43:41 -0800
Date: Thu, 25 Jan 2007 14:42:27 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 1/2]: Fix BUG in cancel_dirty_pages on XFS
Message-ID: <20070125034227.GX33919298@melbourne.sgi.com>
References: <20070123223702.GF33919298@melbourne.sgi.com> <1169640835.6189.14.camel@twins> <45B7627B.8050202@yahoo.com.au> <20070124224654.GN33919298@melbourne.sgi.com> <45B7F5F9.2070308@yahoo.com.au> <20070125003536.GS33919298@melbourne.sgi.com> <45B7FE1C.3070807@yahoo.com.au> <20070125015204.GV33919298@melbourne.sgi.com> <45B80F65.6010206@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45B80F65.6010206@yahoo.com.au>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: David Chinner <dgc@sgi.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@osdl.org

On Thu, Jan 25, 2007 at 01:01:09PM +1100, Nick Piggin wrote:
> David Chinner wrote:
> >On Thu, Jan 25, 2007 at 11:47:24AM +1100, Nick Piggin wrote:
> >
> >>David Chinner wrote:
> >>
> >>>On Thu, Jan 25, 2007 at 11:12:41AM +1100, Nick Piggin wrote:
> >>But I'm just interested about DIO reads. I think you can get pretty
> >>reasonable semantics without discarding pagecache, but the semantics
> >>are weaker in one aspect.
> >>
> >>DIO read
> >>1. writeback page
> >>2. read from disk
> >>
> >>Now your read will pick up data no older than 1. And if a buffered
> >>write happens after 2, then there is no problem either.
> >>
> >>So if you are doing a buffered write and DIO read concurrently, you
> >>want synchronisation so the buffered write happens either before 1
> >>or after 2 -- the DIO read will see either all or none of the write.
> >>
> >>Supposing your pagecache isn't invalidated, then a buffered write
> >>(from mmap, if XFS doesn't allow write(2)) comes in between 1 and 2,
> >>then the DIO read will find either none, some, or all of that write.
> >>
> >>So I guess what you are preventing is the "some" case. Am I right?
> >
> >
> >No. The only thing that will happen here is that the direct read
> >will see _none_ of the write because the mmap write occurred during
> >the DIO read to a different set of pages in memory. There is no
> >"some" or "all" case here.
> 
> But if the buffers get partially or completely written back in the
> meantime, then the DIO read could see that.

Only if you can dirty them and flush them to disk while the direct
read is waiting in the I/O queue (remember, the direct read flushes
dirty cached data before being issued). Given that we don't lock the
inode in the buffered I/O *writeback* path, we have to stop pages being
dirtied in the page cache up front so we don't have mmap writeback
over the top of the direct read.

Hence we have to prevent mmap for dirtying the same file offset we
are doing direct reads on until the direct read has been issued.

i.e. we need a barrier.

> >IOWs, at a single point in time we have 2 different views
> >of the one file which are both apparently valid and that is what
> >we are trying to avoid. We have a coherency problem here which is
> >solved by forcing the mmap write to reread the data off disk....
> 
> I don't see why the mmap write needs to reread data off disk. The
> data on disk won't get changed by the DIO read.

No, but the data _in memory_ will, and now when the direct read
completes it will data that is different to what is in the page
cache. For direct I/O we define the correct data to be what is on
disk, not what is in memory, so any time we bypass what is in
memory, we need to ensure that we prevent the data being changed
again in memory before we issue the disk I/O.

> >Look at it this way - direct I/O in XFS implies an I/O barrier
> >(similar to a memory barrier). Writing back and tossing out of the
> >page cache at the start of the direct IO gives us an I/O coherency
> >barrier - everything before the direct IO is sync'd to disk before
> >the direct IO can proceed, and everything after the direct IO has
> >started must be fetched from disk again.
> >
> >Because mmap I/O doesn't necessarily need I/O to change the state
> >of a page (think of a read fault then a later write fault), to make
> >the I/O barrier work correctly with mmap() we need to ensure that
> >it will fault the page from disk again. We can only do that by
> >unmapping the pages before tossing them from the page cache.....
> 
> OK, but direct IO *reads* do not conceptually invalidate pagecache
> sitting on top of those blocks. Pagecache becomes invalid when the
> page no longer represents the most uptodate copy of the data (eg.
> in the case of a direct IO write).

In theory, yes.

In practice, if you don't invalidate the page cache you have no
mechanism of synchronising mmap with direct I/O, and at that
point you have no coherency model that you can work with in
your filesystem. You have to be able to guarantee synchronisation
betwen the different methods that can dirty data before you
can give any guarantees about data coherency.....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
