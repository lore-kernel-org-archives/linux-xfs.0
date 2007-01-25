Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Jan 2007 16:36:55 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l0P0aiqw032573
	for <xfs@oss.sgi.com>; Wed, 24 Jan 2007 16:36:47 -0800
Date: Thu, 25 Jan 2007 11:35:36 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 1/2]: Fix BUG in cancel_dirty_pages on XFS
Message-ID: <20070125003536.GS33919298@melbourne.sgi.com>
References: <20070123223702.GF33919298@melbourne.sgi.com> <1169640835.6189.14.camel@twins> <45B7627B.8050202@yahoo.com.au> <20070124224654.GN33919298@melbourne.sgi.com> <45B7F5F9.2070308@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45B7F5F9.2070308@yahoo.com.au>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: David Chinner <dgc@sgi.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@osdl.org

On Thu, Jan 25, 2007 at 11:12:41AM +1100, Nick Piggin wrote:
> David Chinner wrote:
> >On Thu, Jan 25, 2007 at 12:43:23AM +1100, Nick Piggin wrote:
> 
> >>And why not just leave it in the pagecache and be done with it?
> >
> >
> >because what is in cache is then not coherent with what is on disk,
> >and a direct read is supposed to read the data that is present
> >in the file at the time it is issued. 
> 
> So after a writeout it will be coherent of course, so the point in
> question is what happens when someone comes in and dirties it at the
> worst possible moment? That relates to the paragraph below...
> 
> >>All you need is to do a writeout before a direct IO read, which is
> >>what generic dio code does.
> >
> >
> >No, that's not good enough - after writeout but before the
> >direct I/O read is issued a process can fault the page and dirty
> >it. If you do a direct read, followed by a buffered read you should
> >get the same data. The only way to guarantee this is to chuck out
> >any cached pages across the range of the direct I/O so they are
> >fetched again from disk on the next buffered I/O. i.e. coherent
> >at the time the direct I/O is issued.
> 
> ... so surely if you do a direct read followed by a buffered read,
> you should *not* get the same data if there has been some activity
> to modify that part of the file in the meantime (whether that be a
> buffered or direct write).

Right. And that is what happens in XFS because it purges the
caches on direct I/O and forces data to be re-read from disk.

Effectively, if you are mixing direct I/O with other types of I/O
(buffered or mmap) then the application really needs to be certain
it is doing the right thing because there are races that can occur
below the filesystem. All we care about in the filesystem is that
what we cache is the same as what is on disk, and that implies that
direct I/O needs to purge the cache regardless of the state it is in....

Hence we need to unmap pages and use truncate semantics on them to
ensure they are removed from the page cache....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
