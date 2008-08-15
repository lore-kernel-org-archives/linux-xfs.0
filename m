Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 15 Aug 2008 15:26:49 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7FMQiYS023867
	for <xfs@oss.sgi.com>; Fri, 15 Aug 2008 15:26:45 -0700
Date: Fri, 15 Aug 2008 15:27:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [REVIEW] Prevent direct I/O from mapping extents beyond eof
Message-Id: <20080815152756.61aab5a7.akpm@linux-foundation.org>
In-Reply-To: <20080815220958.GB13770@infradead.org>
References: <48A50152.8020104@sgi.com>
	<20080815220958.GB13770@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: lachlan@sgi.com, xfs-dev@sgi.com, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Fri, 15 Aug 2008 18:09:58 -0400
Christoph Hellwig <hch@infradead.org> wrote:

> On Fri, Aug 15, 2008 at 02:08:50PM +1000, Lachlan McIlroy wrote:
> > With the help from some tracing I found that we try to map extents beyond
> > eof when doing a direct I/O read.  It appears that the way to inform the
> > generic direct I/O path (ie do_direct_IO()) that we have breached eof is
> > to return an unmapped buffer from xfs_get_blocks_direct().  This will cause
> > do_direct_IO() to jump to the hole handling code where is will check for
> > eof and then abort.
> >
> > This problem was found because a direct I/O read was trying to map beyond
> > eof and was encountering delayed allocations.  The delayed allocations beyond
> > eof are speculative allocations and they didn't get converted when the direct
> > I/O flushed the file because there was only enough space in the current AG
> > to convert and write out the dirty pages within eof.  Note that
> > xfs_iomap_write_allocate() wont necessarily convert all the delayed allocation
> > passed to it - it will return after allocating the first extent - so if the
> > delayed allocation extends beyond eof then it will stay that way.
> >
> > This change will detect a direct I/O read beyond eof:
> 
> The change looks good to me, but I really think the direct I/O could
> should never send down requests like this down to the filesystems.  akpm
> and -fsdevel Cc'ed.

Oh gee, I forget, and so many people have done drivebys on that code...

We _could_ add additional i_size checking into direct-io.c but bear in
mind that it would be best-effort unreliable stuff.  The code will
still be tripped up by concurrent extends and concurrent truncates.

So we'll still end up calling the fs for blocks outside i_size, only
less commonly.  I think.
