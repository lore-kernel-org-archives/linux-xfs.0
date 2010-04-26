Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3Q2f8UO051220 for <xfs@oss.sgi.com>; Sun, 25 Apr 2010 21:41:08 -0500
Received: from thunker.thunk.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1A19A8CAFC8
	for <xfs@oss.sgi.com>; Sun, 25 Apr 2010 19:43:10 -0700 (PDT)
Received: from thunker.thunk.org (thunk.org [69.25.196.29]) by cuda.sgi.com
	with ESMTP id DIDXTAb0DqQXYj0B for <xfs@oss.sgi.com>;
	Sun, 25 Apr 2010 19:43:10 -0700 (PDT)
Date: Sun, 25 Apr 2010 22:43:02 -0400
From: tytso@mit.edu
Subject: Re: [PATCH 3/4] writeback: pay attention to wbc->nr_to_write in
	write_cache_pages
Message-ID: <20100426024302.GC13043@thunk.org>
References: <1271731314-5893-1-git-send-email-david@fromorbit.com>
	<1271731314-5893-4-git-send-email-david@fromorbit.com>
	<20100425033315.GC667@thunk.org> <20100426014908.GD11437@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100426014908.GD11437@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Apr 26, 2010 at 11:49:08AM +1000, Dave Chinner wrote:
> 
> Yes, but that does not require a negative value to get right.  None
> of the code relies on negative nr_to_write values to do anything
> correctly, and all the termination checks are for wbc->nr_to-write
> <= 0. And the tracing shows it behaves correctly when
> wbc->nr_to_write = 0 on return. Requiring a negative number is not
> documented in any of the comments, write_cache_pages() does not
> return a negative number, etc, so I can't see why you think this is
> necessary....

In fs/fs-writeback.c, wb_writeback(), around line 774:

   		      wrote += MAX_WRITEBACK_PAGES - wbc.nr_to_write;

If we want "wrote" to be reflect accurately the number of pages that
the filesystem actually wrote, then if you write more pages than what
was requested by wbc.nr_to_write, then it needs to be negative.

> XFS put a workaround in for a different reason to ext4. ext4 put it
> in to improve delayed allocation by working with larger chunks of
> pages. XFS put it in to get large IOs to be issued through
> submit_bio(), not to help the allocator...

That's why I put in ext4 at least initially, yes.  I'm working on
rewriting the ext4_writepages() code to make this unnecessary....

However...

> And to be the nasty person to shoot down your modern hardware
> theory: nr_to_write = 1024 pages works just fine on my laptop (XFS
> on indilix SSD) as well as my big test server (XFS on 12 disk RAID0)
> The server gets 1.5GB/s with pretty much perfect IO patterns with
> the fixes I posted, unlike the mess of single page IOs that occurs
> without them....

Have you tested with multiple files that are subject to writeout at
the same time?  After all, if your I/O allocator does a great job of
keeping the files contiguous in chunks larger tham 4MB, then if you
have two or more files that need to be written out, the page allocator
will round robin between the two files in 4MB chunks, and that might
not be considered an ideal I/O pattern.

Regards,

					- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
