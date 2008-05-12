Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 12 May 2008 09:48:51 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4CGmea2028353
	for <xfs@oss.sgi.com>; Mon, 12 May 2008 09:48:43 -0700
Received: from kernel.dk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B9010158A65
	for <xfs@oss.sgi.com>; Mon, 12 May 2008 09:49:26 -0700 (PDT)
Received: from kernel.dk (brick.kernel.dk [87.55.233.238]) by cuda.sgi.com with ESMTP id 4l4q7iT5FnCTwXCo for <xfs@oss.sgi.com>; Mon, 12 May 2008 09:49:26 -0700 (PDT)
Date: Mon, 12 May 2008 18:49:20 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: XFS/md/blkdev warning (was Re: Linux 2.6.26-rc2)
Message-ID: <20080512164920.GE16217@kernel.dk>
References: <alpine.LFD.1.10.0805120731480.3188@woody.linux-foundation.org> <200805121726.15576.alistair@devzero.co.uk> <alpine.LFD.1.10.0805120933310.3019@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805120933310.3019@woody.linux-foundation.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alistair John Strachan <alistair@devzero.co.uk>, xfs@oss.sgi.com, Neil Brown <neilb@suse.de>, Nick Piggin <npiggin@suse.de>

On Mon, May 12 2008, Linus Torvalds wrote:
> 
> 
> On Mon, 12 May 2008, Alistair John Strachan wrote:
> >
> > I've been getting this since -rc1. It's still present in -rc2, so I thought 
> > I'd bug some people. Everything seems to be working fine.
> 
> Hmm. The problem is that blk_remove_plug() does a non-atomic 
> 
> 	queue_flag_clear(QUEUE_FLAG_PLUGGED, q);
> 
> without holding the queue lock.
> 
> Now, sometimes that's ok, because of higher-level locking on the same 
> queue, so there is no possibility of any races.
> 
> And yes, this comes through the raid5 layer, and yes, the raid layer holds 
> the 'device_lock' on the raid5_conf_t, so it's all safe from other 
> accesses by that raid5 configuration, but I wonder if at least in theory 
> somebody could access that same device directly.
> 
> So I do suspect that this whole situation with md needs to be resolved 
> some way. Either the queue is already safe (because of md layer locking), 
> and in that case maybe the queue lock should be changed to point to that 
> md layer lock (or that sanity test simply needs to be removed). Or the 
> queue is unsafe (because non-md users can find it too), and we need to fix 
> the locking.
> 
> Alternatively, we may just need to totally revert the thing that made the 
> bit operations non-atomic and depend on the locking. This was introduced 
> by Nick in commit 75ad23bc0fcb4f992a5d06982bf0857ab1738e9e ("block: make 
> queue flags non-atomic"), and maybe it simply isn't viable.

There's been a proposed patch for at least a week, so Neil just needs to
send it in...

-- 
Jens Axboe
