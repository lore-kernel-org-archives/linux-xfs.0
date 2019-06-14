Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:60257 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725777AbfFNAgV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jun 2019 20:36:21 -0400
Date: Fri, 14 Jun 2019 10:35:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: pagecache locking (was: bcachefs status update) merged)
Message-ID: <20190614003518.GL14363@dread.disaster.area>
References: <20190610191420.27007-1-kent.overstreet@gmail.com>
 <CAHk-=wi0iMHcO5nsYug06fV3-8s8fz7GDQWCuanefEGq6mHH1Q@mail.gmail.com>
 <20190611011737.GA28701@kmo-pixel>
 <20190611043336.GB14363@dread.disaster.area>
 <20190612162144.GA7619@kmo-pixel>
 <20190612230224.GJ14308@dread.disaster.area>
 <20190613183625.GA28171@kmo-pixel>
 <AE838C22-1A11-4F93-AB88-80CF009BD301@dilger.ca>
 <20190613212112.GB28171@kmo-pixel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190613212112.GB28171@kmo-pixel>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Andreas Dilger <adilger@dilger.ca>, Linus Torvalds <torvalds@linux-foundation.org>, Dave Chinner <dchinner@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Matthew Wilcox <willy@infradead.org>, Amir Goldstein <amir73il@gmail.com>, Jan Kara <jack@suse.cz>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Josef Bacik <josef@toxicpanda.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>

On Thu, Jun 13, 2019 at 05:21:12PM -0400, Kent Overstreet wrote:
> On Thu, Jun 13, 2019 at 03:13:40PM -0600, Andreas Dilger wrote:
> > There are definitely workloads that require multiple threads doing non-overlapping
> > writes to a single file in HPC.  This is becoming an increasingly common problem
> > as the number of cores on a single client increase, since there is typically one
> > thread per core trying to write to a shared file.  Using multiple files (one per
> > core) is possible, but that has file management issues for users when there are a
> > million cores running on the same job/file (obviously not on the same client node)
> > dumping data every hour.
> 
> Mixed buffered and O_DIRECT though? That profile looks like just buffered IO to
> me.
> 
> > We were just looking at this exact problem last week, and most of the threads are
> > spinning in grab_cache_page_nowait->add_to_page_cache_lru() and set_page_dirty()
> > when writing at 1.9GB/s when they could be writing at 5.8GB/s (when threads are
> > writing O_DIRECT instead of buffered).  Flame graph is attached for 16-thread case,
> > but high-end systems today easily have 2-4x that many cores.
> 
> Yeah I've been spending some time on buffered IO performance too - 4k page
> overhead is a killer.
> 
> bcachefs has a buffered write path that looks up multiple pages at a time and
> locks them, and then copies the data to all the pages at once (I stole the idea
> from btrfs). It was a very significant performance increase.

Careful with that - locking multiple pages is also a deadlock vector
that triggers unexpectedly when something conspires to lock pages in
non-ascending order. e.g.

64081362e8ff mm/page-writeback.c: fix range_cyclic writeback vs writepages deadlock

The fs/iomap.c code avoids this problem by mapping the IO first,
then iterating pages one at a time until the mapping is consumed,
then it gets another mapping. It also avoids needing to put a page
array on stack....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
