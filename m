Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0ABE47CBF
	for <xfs@oss.sgi.com>; Wed,  3 Apr 2013 23:00:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E766A30404E
	for <xfs@oss.sgi.com>; Wed,  3 Apr 2013 21:00:44 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	NfNHYJo6a7iytoFw for <xfs@oss.sgi.com>;
	Wed, 03 Apr 2013 21:00:43 -0700 (PDT)
Date: Thu, 4 Apr 2013 15:00:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_iomap_write_unwritten stuck in congestion_wait?
Message-ID: <20130404040041.GB12011@dastard>
References: <CAH4wwdF+gQTnbUR89e2KCUUJfS_cT_09wzmS55vys5rfbStW7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAH4wwdF+gQTnbUR89e2KCUUJfS_cT_09wzmS55vys5rfbStW7Q@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Peter Watkins <treestem@gmail.com>
Cc: xfs@oss.sgi.com

On Wed, Apr 03, 2013 at 03:33:11PM -0400, Peter Watkins wrote:
> Hello,
> 
> Wondering if anyone has a suggestion for when
> xfs_iomap_write_unwritten gets into congestion_wait.

Do less IO?

> In this case the system has almost half of normal zone pages in
> NR_WRITEBACK with pretty much everybody held up in either
> congestion_wait or balance_dirty_pages.

Which is excessive - how are you getting to the point of having that
many pages under IO at once? Writeback depth is limited by the IO
elevator queue depths, so this shouldn't happen unless you've been
tweaking block device parameters (i.e. nr_requests/max_sectors_kb)...

> Since there are some free pages, seems like we'd be better off just
> using a little more memory to finish this IO and in turn reduce pages
> under write-back and add to free memory, rather than holding up here.
> So maybe PF_MEMALLOC?

Definitely not. Unwritten extent conversion can require hundreds of
kilobytes of memory to complete, so all this will do is trigger even
further exhaustion of memory reserves before we block on IO.

> It also looks like this path allocates log vectors with KM_SLEEP but
> lv_buf's with KM_SLEEP|KM_NOFS. Why is that?

The transaction commit is copying the changes made into separate
buffers to insert into the CIL for a later checkpoint to write to
disk. This is normal behaviour - we can sleep there, but we cannot
allow memory reclaim to recurse into the filesystem (for obvious
reasons).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
