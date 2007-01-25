Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Jan 2007 17:53:21 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l0P1rCqw017920
	for <xfs@oss.sgi.com>; Wed, 24 Jan 2007 17:53:14 -0800
Date: Thu, 25 Jan 2007 12:52:04 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 1/2]: Fix BUG in cancel_dirty_pages on XFS
Message-ID: <20070125015204.GV33919298@melbourne.sgi.com>
References: <20070123223702.GF33919298@melbourne.sgi.com> <1169640835.6189.14.camel@twins> <45B7627B.8050202@yahoo.com.au> <20070124224654.GN33919298@melbourne.sgi.com> <45B7F5F9.2070308@yahoo.com.au> <20070125003536.GS33919298@melbourne.sgi.com> <45B7FE1C.3070807@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45B7FE1C.3070807@yahoo.com.au>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: David Chinner <dgc@sgi.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@osdl.org

On Thu, Jan 25, 2007 at 11:47:24AM +1100, Nick Piggin wrote:
> David Chinner wrote:
> >On Thu, Jan 25, 2007 at 11:12:41AM +1100, Nick Piggin wrote:
> 
> >>... so surely if you do a direct read followed by a buffered read,
> >>you should *not* get the same data if there has been some activity
> >>to modify that part of the file in the meantime (whether that be a
> >>buffered or direct write).
> >
> >
> >Right. And that is what happens in XFS because it purges the
> >caches on direct I/O and forces data to be re-read from disk.
> 
> And that is critical for direct IO writes, of course.
> 
> >Effectively, if you are mixing direct I/O with other types of I/O
> >(buffered or mmap) then the application really needs to be certain
> >it is doing the right thing because there are races that can occur
> >below the filesystem. All we care about in the filesystem is that
> >what we cache is the same as what is on disk, and that implies that
> >direct I/O needs to purge the cache regardless of the state it is in....
> >
> >Hence we need to unmap pages and use truncate semantics on them to
> >ensure they are removed from the page cache....
> 
> OK, I understand that this does need to happen (at least for writes),
> so you need to fix it regardless of the DIO read issue.
> 
> But I'm just interested about DIO reads. I think you can get pretty
> reasonable semantics without discarding pagecache, but the semantics
> are weaker in one aspect.
> 
> DIO read
> 1. writeback page
> 2. read from disk
> 
> Now your read will pick up data no older than 1. And if a buffered
> write happens after 2, then there is no problem either.
> 
> So if you are doing a buffered write and DIO read concurrently, you
> want synchronisation so the buffered write happens either before 1
> or after 2 -- the DIO read will see either all or none of the write.
> 
> Supposing your pagecache isn't invalidated, then a buffered write
> (from mmap, if XFS doesn't allow write(2)) comes in between 1 and 2,
> then the DIO read will find either none, some, or all of that write.
>
> So I guess what you are preventing is the "some" case. Am I right?

No. The only thing that will happen here is that the direct read
will see _none_ of the write because the mmap write occurred during
the DIO read to a different set of pages in memory. There is no
"some" or "all" case here.

IOWs, at a single point in time we have 2 different views
of the one file which are both apparently valid and that is what
we are trying to avoid. We have a coherency problem here which is
solved by forcing the mmap write to reread the data off disk....

Look at it this way - direct I/O in XFS implies an I/O barrier
(similar to a memory barrier). Writing back and tossing out of the
page cache at the start of the direct IO gives us an I/O coherency
barrier - everything before the direct IO is sync'd to disk before
the direct IO can proceed, and everything after the direct IO has
started must be fetched from disk again.

Because mmap I/O doesn't necessarily need I/O to change the state
of a page (think of a read fault then a later write fault), to make
the I/O barrier work correctly with mmap() we need to ensure that
it will fault the page from disk again. We can only do that by
unmapping the pages before tossing them from the page cache.....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
