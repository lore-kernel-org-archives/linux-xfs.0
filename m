Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4IAAFmM123117
	for <linux-xfs@oss.sgi.com>; Fri, 18 May 2012 05:10:15 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	EJ8aFnzfqXVyOF31 for <linux-xfs@oss.sgi.com>;
	Fri, 18 May 2012 03:10:13 -0700 (PDT)
Date: Fri, 18 May 2012 20:10:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Still seeing hangs in xlog_grant_log_space
Message-ID: <20120518101010.GW25351@dastard>
References: <CADLDEKuKLeYiqhQW0E9g_bS0VXoxPGPOck3N004Pxg4_Opbzow@mail.gmail.com>
	<20120427110922.GF9541@dastard>
	<CADLDEKtUHAGcOPT1jtcvyJVk+zsoL5_thYFtHJYs+w=6EGuVSA@mail.gmail.com>
	<CADLDEKs4YbNzj2c0HKHwSdUfKy0efdQRe1rOsWDkWUgd+BOGHw@mail.gmail.com>
	<20120507171908.GA16881@sgi.com>
	<CADLDEKvgT_FcGhJKoPaQv0mh_Jqdaqu8SYatc9xxU7vOY217YQ@mail.gmail.com>
	<loom.20120510T180646-433@post.gmane.org>
	<20120516184231.GK16099@sgi.com> <4FB3FA1D.6050102@canonical.com>
	<4FB41C1D.8000808@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FB41C1D.8000808@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: linux-xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, Chris J Arges <chris.j.arges@canonical.com>

On Wed, May 16, 2012 at 04:29:01PM -0500, Mark Tinguely wrote:
> On 05/16/12 14:03, Chris J Arges wrote:
> >On 05/16/2012 01:42 PM, Ben Myers wrote:
> >>Hey Chris,
> >>
> >>On Thu, May 10, 2012 at 04:11:27PM +0000, Chris J Arges wrote:
> >>><snip>
> >>>>Canonical attached them to the bug report that they filed yesterday:
> >>>>http://oss.sgi.com/bugzilla/show_bug.cgi?id=922
> >>>>
> >>>>...Juerg
> >>>>
> >>>
> >>>Hello,
> >>>I am able to reproduce this bug with the instructions posted in this bug. Let me
> >>>know what I can do to help.
> >>
> >>The bug shows:
> >>
> >>|This has been tested on the following kernels which all exhibit the same
> >>|failures:
> >>|- 3.2.0-24 (Ubuntu Precise)
> >>|- 3.4.0-rc4
> >>|- 3.0.29
> >>|- 3.1.10
> >>|- 3.2.15
> >>|- 3.3.2
> >>
> >>Can you find an older kernel that isn't broken?
> >>
> >
> >Sure, I can start digging further back.
> >Also 2.6.38-8-server was the original version that this bug was reported
> >on. So I can try testing circa 2.6.32 to see if that also fails.
> >--chris
> >
> >>-Ben
> >>
> >
> 
> What I know so far:
> I have log cleaner kicker added to xlog_grant_head_wake(). This

What's a "log cleaner"? I've never heard that term before use for
XFS, so I can only assume you are talking about waking the xfsaild.
If that's the case, can you just say "pushing the AIL" rather
than making up new terminology?

> kicker at best would prevent waiting for the next sync before
> starting the log cleaner.

Can you post the patch?

> I have one machine that has been running for 2 days without hanging.
> Actually, now I would prefer it to hurry up and hang.
> 
> Here is what see on the machine that is hung:
> 
> A few processes (4-5) are hung waiting to get space on the log.
> There isn't enough free space on the log for the first transaction
> and it waits. All other processes will have to wait behind the first
> process. 251,811 bytes of the original 589,842 bytes should still be
> free (if my hand free space calculations are correct).
> 
> The AIL is empty.

So the CIL has consumed ~50% of the log, and the background flusher
has not triggered? Why didn't the background CIL flush fire?

> There is nothing to clean. Any new transaction at
> this point will kick the cleaner, and it still can't start the first
> waiter, so it joins the wait list.

Assuming you mean the cleaner is the xfsaild, then if the AIL is
empty, waking the xfsaild will do nothing because there is nothing
for it to act on.

> The only XFS traffic at this point is inode reclaim worker. This is
> to be expected.
> 
> The CIL has entries, nothing is waiting on the CIL.
> xc_current_sequence = 117511 xc_push_seq = 117510. So there is
> nothing for the CIL worker to do.

It means that we're stalled on the CIL, not on the AIL. The question
is, as I asked above, why didn't the background flusher fire when
the last transaction completed and saw the CIL over the hard flush
threshold?

If you dump the CIL context structure, you can find out how much
space has been consumed by the items queued on the CIL.

> 
> 117511 is the largest sequence number that I have found so far in
> the xfs_log_item list. There are a few entries with smaller sequence
> numbers and the following strange entry:
> 
> 77th entry in the xfs_log_item list:
> 
> crash> struct xfs_log_item ffff88083222b5b8
> struct xfs_log_item {
>   li_ail = {
>     next = 0xffff88083222b5b0,

that points 8 bytes backwards.

>     prev = 0x0

And that indicates that this was never part of a log item as the
list head is always initialised.

>   },
>   li_lsn = 0,

never committed

>   li_desc = 0x9f5d9f5d,

that's supposed to be a pointer

>   li_mountp = 0xffff88083116e300,
>   li_ailp = 0x0,

Never initialised as a log item.

>   li_type = 0,

Impossible.

>   li_flags = 0,
>   li_bio_list = 0x0,
>   li_cb = 0,
>   li_ops = 0xffff88083105de00,
>   li_cil = {
>     next = 0xffff880832ad9f08,
>     prev = 0xffff880831751448
>   },
>   li_lv = 0xc788c788,

supposed to be a pointer

>   li_seq = -131906182637504

That's a pointer: 0xFFFF880832D71840

So this looks like it some form of memory corruption - either a use
after free, the memory has been been overwritten or the list has
been pointed off into lala land.

> Everything in this entry is bad except the li_cil.next and
> li_cil.prev. It looks like li_ail.next is really part of a list that
> starts at 0xffff88083222b5b0. The best explanation is a junk
> addresses was inserted into the li_cil chain.

It seems unlikely, but if you turn on kmemleak it might find a
memory leak or overwrite that is causing this.

> 
> This is a single data point which could be anything including bad
> hardware. I will continue to traverse this list until I can get the
> other box to hang. If someone want to traverse their xfs_log_item
> list ...

Given how little it looks like a log item, I'm not sure you can
follow those pointers - do they even link up with other log items?

Still, this doesn't explain the hang at all - the CIL forms a new
list every time a checkpoint occurs, and this corruption would cause
a crash trying to walk the li_lv list when pushed. So it comes back
to why hasn't the CIL been pushed? what does the CIL context
structure look like?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
