Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 17 May 2008 11:22:18 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4HIMD63012861
	for <xfs@oss.sgi.com>; Sat, 17 May 2008 11:22:15 -0700
Received: from smtp1.betherenow.co.uk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 38DAA16DFC99
	for <xfs@oss.sgi.com>; Sat, 17 May 2008 11:23:01 -0700 (PDT)
Received: from smtp1.betherenow.co.uk (smtp1.betherenow.co.uk [87.194.0.68]) by cuda.sgi.com with SMTP id sc1Aa2Di2BZitwjg for <xfs@oss.sgi.com>; Sat, 17 May 2008 11:23:01 -0700 (PDT)
From: Alistair John Strachan <alistair@devzero.co.uk>
Subject: Re: XFS/md/blkdev warning (was Re: Linux 2.6.26-rc2)
Date: Sat, 17 May 2008 19:22:56 +0100
References: <alpine.LFD.1.10.0805120731480.3188@woody.linux-foundation.org> <alpine.LFD.1.10.0805120933310.3019@woody.linux-foundation.org> <20080512164920.GE16217@kernel.dk>
In-Reply-To: <20080512164920.GE16217@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805171922.56272.alistair@devzero.co.uk>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, xfs@oss.sgi.com, Neil Brown <neilb@suse.de>, Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org

(Added LKML CC)

On Monday 12 May 2008 17:49:20 Jens Axboe wrote:
> On Mon, May 12 2008, Linus Torvalds wrote:
> > On Mon, 12 May 2008, Alistair John Strachan wrote:
> > > I've been getting this since -rc1. It's still present in -rc2, so I
> > > thought I'd bug some people. Everything seems to be working fine.
> >
> > Hmm. The problem is that blk_remove_plug() does a non-atomic
> >
> > 	queue_flag_clear(QUEUE_FLAG_PLUGGED, q);
> >
> > without holding the queue lock.
> >
> > Now, sometimes that's ok, because of higher-level locking on the same
> > queue, so there is no possibility of any races.
> >
> > And yes, this comes through the raid5 layer, and yes, the raid layer
> > holds the 'device_lock' on the raid5_conf_t, so it's all safe from other
> > accesses by that raid5 configuration, but I wonder if at least in theory
> > somebody could access that same device directly.
> >
> > So I do suspect that this whole situation with md needs to be resolved
> > some way. Either the queue is already safe (because of md layer locking),
> > and in that case maybe the queue lock should be changed to point to that
> > md layer lock (or that sanity test simply needs to be removed). Or the
> > queue is unsafe (because non-md users can find it too), and we need to
> > fix the locking.
> >
> > Alternatively, we may just need to totally revert the thing that made the
> > bit operations non-atomic and depend on the locking. This was introduced
> > by Nick in commit 75ad23bc0fcb4f992a5d06982bf0857ab1738e9e ("block: make
> > queue flags non-atomic"), and maybe it simply isn't viable.
>
> There's been a proposed patch for at least a week, so Neil just needs to
> send it in...

(I could be perverting this report a bit by reporting something possibly not 
related, but I have a gut feeling about this..)

So I applied Neil's patch which is now upstream to 2.6.26-rc2 and the warning 
did go away. But I later found that I have another problem: if I copy more 
than my free memory's worth of data, my machine hangs mysteriously.

My guess is that when the kernel runs out of MemFree and starts reclaiming the 
cache, something is deadlocking somewhere. Just doing a:

cat /dev/zero >/path/to/file

Is enough to reproduce it. Doing this on my stacked XFS+md+libata causes a 
hang, but if I try to reproduce on the only other filesystem I have handy (a 
FUSE/ntfs-3g mounted NTFS partition) cache reclaim seems to work fine. Maybe 
this test is contrived in a million different ways, but it would seem to 
indicate the bug lies either in XFS or md.

I don't have any disks handy at the moment to try another filesystem on top of 
md (to eliminate md), and I've not yet tried enabling any kernel debugging 
options. When the machine hangs, all disk I/O stops permanently. No logging 
messages are shown.

Does anybody have any ideas about what to try or switch on to debug this 
problem?

-- 
Cheers,
Alistair.

137/1 Warrender Park Road, Edinburgh, UK.
