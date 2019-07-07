Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ed1-f66.google.com ([209.85.208.66]:39249 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726529AbfGGPFV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 7 Jul 2019 11:05:21 -0400
Subject: Re: pagecache locking
References: <20190613183625.GA28171@kmo-pixel>
 <20190613235524.GK14363@dread.disaster.area>
 <CAHk-=whMHtg62J2KDKnyOTaoLs9GxcNz1hN9QKqpxoO=0bJqdQ@mail.gmail.com>
 <CAHk-=wgz+7O0pdn8Wfxc5EQKNy44FTtf4LAPO1WgCidNjxbWzg@mail.gmail.com>
 <20190617224714.GR14363@dread.disaster.area>
 <CAHk-=wiR3a7+b0cUN45hGp1dvFh=s1i1OkVhoP7CivJxKqsLFQ@mail.gmail.com>
 <CAOQ4uxjqQjrCCt=ixgdUYjBJvKLhw4R9NeMZOB_s2rrWvoDMBw@mail.gmail.com>
 <20190619103838.GB32409@quack2.suse.cz>
 <20190619223756.GC26375@dread.disaster.area>
 <3f394239-f532-23eb-9ff1-465f7d1f3cb4@gmail.com>
 <20190705233157.GD7689@dread.disaster.area>
From: Boaz Harrosh <openosd@gmail.com>
Message-ID: <b43e2707-89ec-3afa-8bca-37747ba6c944@gmail.com>
Date: Sun, 7 Jul 2019 18:05:16 +0300
MIME-Version: 1.0
In-Reply-To: <20190705233157.GD7689@dread.disaster.area>
Content-Type: text/plain; charset=utf-8
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, Kent Overstreet <kent.overstreet@gmail.com>, Dave Chinner <dchinner@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Matthew Wilcox <willy@infradead.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Josef Bacik <josef@toxicpanda.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>

On 06/07/2019 02:31, Dave Chinner wrote:

> 
> As long as the IO ranges to the same file *don't overlap*, it should
> be perfectly safe to take separate range locks (in read or write
> mode) on either side of the mmap_sem as non-overlapping range locks
> can be nested and will not self-deadlock.
> 
> The "recursive lock problem" still arises with DIO and page faults
> inside gup, but it only occurs when the user buffer range overlaps
> the DIO range to the same file. IOWs, the application is trying to
> do something that has an undefined result and is likely to result in
> data corruption. So, in that case I plan to have the gup page faults
> fail and the DIO return -EDEADLOCK to userspace....
> 

This sounds very cool. I now understand. I hope you put all the tools
for this in generic places so it will be easier to salvage.

One thing I will be very curious to see is how you teach lockdep
about the "range locks can be nested" thing. I know its possible,
other places do it, but its something I never understood.

> Cheers,
> Dave.

[ Ha one more question if you have time:

  In one of the mails, and you also mentioned it before, you said about
  the rw_read_lock not being able to scale well on mammoth machines
  over 10ns of cores (maybe you said over 20).
  I wonder why that happens. Is it because of the atomic operations,
  or something in the lock algorithm. In my theoretical understanding,
  as long as there are no write-lock-grabbers, why would the readers
  interfere with each other?
]

Thanks
Boaz
