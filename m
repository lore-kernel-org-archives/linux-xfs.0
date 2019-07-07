Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:41716 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727438AbfGGX5F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 7 Jul 2019 19:57:05 -0400
Date: Mon, 8 Jul 2019 09:55:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: pagecache locking
Message-ID: <20190707235550.GG7689@dread.disaster.area>
References: <CAHk-=whMHtg62J2KDKnyOTaoLs9GxcNz1hN9QKqpxoO=0bJqdQ@mail.gmail.com>
 <CAHk-=wgz+7O0pdn8Wfxc5EQKNy44FTtf4LAPO1WgCidNjxbWzg@mail.gmail.com>
 <20190617224714.GR14363@dread.disaster.area>
 <CAHk-=wiR3a7+b0cUN45hGp1dvFh=s1i1OkVhoP7CivJxKqsLFQ@mail.gmail.com>
 <CAOQ4uxjqQjrCCt=ixgdUYjBJvKLhw4R9NeMZOB_s2rrWvoDMBw@mail.gmail.com>
 <20190619103838.GB32409@quack2.suse.cz>
 <20190619223756.GC26375@dread.disaster.area>
 <3f394239-f532-23eb-9ff1-465f7d1f3cb4@gmail.com>
 <20190705233157.GD7689@dread.disaster.area>
 <b43e2707-89ec-3afa-8bca-37747ba6c944@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b43e2707-89ec-3afa-8bca-37747ba6c944@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Boaz Harrosh <openosd@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, Kent Overstreet <kent.overstreet@gmail.com>, Dave Chinner <dchinner@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Matthew Wilcox <willy@infradead.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Josef Bacik <josef@toxicpanda.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>

On Sun, Jul 07, 2019 at 06:05:16PM +0300, Boaz Harrosh wrote:
> On 06/07/2019 02:31, Dave Chinner wrote:
> 
> > 
> > As long as the IO ranges to the same file *don't overlap*, it should
> > be perfectly safe to take separate range locks (in read or write
> > mode) on either side of the mmap_sem as non-overlapping range locks
> > can be nested and will not self-deadlock.
> > 
> > The "recursive lock problem" still arises with DIO and page faults
> > inside gup, but it only occurs when the user buffer range overlaps
> > the DIO range to the same file. IOWs, the application is trying to
> > do something that has an undefined result and is likely to result in
> > data corruption. So, in that case I plan to have the gup page faults
> > fail and the DIO return -EDEADLOCK to userspace....
> > 
> 
> This sounds very cool. I now understand. I hope you put all the tools
> for this in generic places so it will be easier to salvage.

That's the plan, though I'm not really caring about anything outside
XFS for the moment.

> One thing I will be very curious to see is how you teach lockdep
> about the "range locks can be nested" thing. I know its possible,
> other places do it, but its something I never understood.

The issue with lockdep is not nested locks, it's that there is no
concept of ranges. e.g.  This is fine:

P0				P1
read_lock(A, 0, 1000)
				read_lock(B, 0, 1000)
write_lock(B, 1001, 2000)
				write_lock(A, 1001, 2000)

Because the read/write lock ranges on file A don't overlap and so
can be held concurrently, similarly the ranges on file B. i.e. This
lock pattern does not result in deadlock.

However, this very similar lock pattern is not fine:

P0				P1
read_lock(A, 0, 1000)
				read_lock(B, 0, 1000)
write_lock(B, 500, 1500)
				write_lock(A, 900, 1900)

i.e. it's an ABBA deadlock because the lock ranges partially
overlap.

IOWs, the problem with lockdep is not nesting read lock or nesting
write locks (because that's valid, too), the problem is that it
needs to be taught about ranges. Once it knows about ranges, nested
read/write locking contexts don't require any special support...

As it is, tracking overlapping lock ranges in lockdep will be
interesting, given that I've been taking several thousand
non-overlapping range locks concurrently on a single file in my
testing. Tracking this sort of usage without completely killing the
machine looking for conflicts and order violations likely makes
lockdep validation of range locks a non-starter....

> [ Ha one more question if you have time:
> 
>   In one of the mails, and you also mentioned it before, you said about
>   the rw_read_lock not being able to scale well on mammoth machines
>   over 10ns of cores (maybe you said over 20).
>   I wonder why that happens. Is it because of the atomic operations,
>   or something in the lock algorithm. In my theoretical understanding,
>   as long as there are no write-lock-grabbers, why would the readers
>   interfere with each other?

Concurrent shared read lock/unlock are still atomic counting
operations.  Hence they bounce exclusive cachelines from CPU to
CPU...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
