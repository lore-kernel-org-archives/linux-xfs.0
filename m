Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 22 Mar 2007 23:20:35 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l2N6KU6p021242
	for <xfs@oss.sgi.com>; Thu, 22 Mar 2007 23:20:32 -0700
Date: Fri, 23 Mar 2007 17:20:40 +1100
From: Timothy Shimmin <tes@sgi.com>
Subject: Re: XFS and write barriers.
Message-ID: <1755676AA526FF7790546385@timothy-shimmins-power-mac-g5.local>
In-Reply-To: <17923.11463.459927.628762@notabene.brown>
References: <17923.11463.459927.628762@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Neil Brown <neilb@suse.de>, xfs@oss.sgi.com

Hi Neil,


--On 23 March 2007 12:26:31 PM +1100 Neil Brown <neilb@suse.de> wrote:

>
> Hi,
>  I have two concerns related to XFS and write barrier support that I'm
>  hoping can be resolved.
>

1.
> Firstly in xfs_mountfs_check_barriers in fs/xfs/linux-2.6/xfs_super.c,
> it tests ....->queue->ordered to see if that is QUEUE_ORDERED_NONE.
> If it is, then barriers are disabled.
>
> I think this is a layering violation - xfs really has no business
> looking that deeply into the device.
> For dm and md devices, ->ordered is never used and so never set, so
> xfs will never use barriers on those devices (as the default value is
> 0 or NONE).  It is true that md and dm could set ->ordered to some
> non-zero value just to please XFS, but that would be telling a lie and
> there is no possible value that is relevant to a layered devices.
>
> I think this test should just be removed and the xfs_barrier_test
> should be the main mechanism for seeing if barriers work.
>
Oh okay.
This is all Christoph's (hch) code, so it would be good for him to comment here.
The external log and readonly tests can stay though.

2.
> Secondly, if a barrier write fails due to EOPNOTSUPP, it should be
> retried without the barrier (after possibly waiting for dependant
> requests to complete).  This is what other filesystems do, but I
> cannot find the code in xfs which does this.
> The approach taken by xfs_barrier_test seems to suggest that xfs does
> do this... could someone please point me to the code ?
>
You got me confused here.
I was wondering why the test write of the superblock (in xfs_barrier_test)
should be retried without barriers :)
But you were referring to the writing of the log buffers using barriers.
Yeah, if we get an EOPNOTSUPP AFAIK, we will report the error and shutdown
the filesystem (xlog_iodone()). This will happen when one of our (up to 8)
incore log buffers I/O completes and xlog_iodone handler is called.
I don't believe we have a notion of barrier'ness changing for us, and
we just test it at mount time.
Which bit of code led you to believe we do a retry?

> This is particularly important for md/raid1 as it is quite possible
> that barriers will be supported at first, but after a failure and
> different device on a different controller could be swapped in that
> does not support barriers.
>

Oh okay, I see. And then later one that supported them can be swapped back in?
So the other FSs are doing a sync'ed write out and then if there is an
EOPNOTSUPP they retry and disable barrier support henceforth?
Yeah, I guess we could do that in xlog_iodone() on failed completion and retry the write without
the ORDERED flag on EOPNOTSUPP error case (and turn off the flag).
Dave (dgc) can you see a problem with that?

> Thanks for your time,
Thanks for pointing it out.

--Tim
