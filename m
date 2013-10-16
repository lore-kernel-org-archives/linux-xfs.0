Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 65B357F3F
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 06:01:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3A36B304039
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 04:01:51 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	ojBcqB1pdlcNCcwp for <xfs@oss.sgi.com>;
	Wed, 16 Oct 2013 04:01:49 -0700 (PDT)
Date: Wed, 16 Oct 2013 22:01:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: A review of dm-writeboost
Message-ID: <20131016110146.GH4446@dastard>
References: <alpine.LRH.2.02.1310031719340.24440@file01.intranet.prod.int.rdu2.redhat.com>
	<52550841.5030001@gmail.com> <525BAB32.5050901@gmail.com>
	<alpine.LRH.2.02.1310151950530.4664@file01.intranet.prod.int.rdu2.redhat.com>
	<20131016060750.GE4446@dastard> <525E6BBE.40004@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <525E6BBE.40004@gmail.com>
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
To: Akira Hayakawa <ruby.wktk@gmail.com>
Cc: devel@driverdev.osuosl.org, thornber@redhat.com, snitzer@redhat.com, cesarb@cesarb.net, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, tj@kernel.org, dm-devel@redhat.com, mpatocka@redhat.com, agk@redhat.com, joe@perches.com, akpm@linux-foundation.org, ejt@redhat.com, dan.carpenter@oracle.com, m.chehab@samsung.com

On Wed, Oct 16, 2013 at 07:34:38PM +0900, Akira Hayakawa wrote:
> Dave
> 
> > Akira, can you please post the entire set of messages you are
> > getting when XFS showing problems? That way I can try to confirm
> > whether it's a regression in XFS or something else.
> 
> Environment:
> - The kernel version is 3.12-rc1
> - The debuggee is a KVM virtual machine equipped with 8 vcpus.
> - writeboost version is commit 236732eb84684e8473353812acb3302232e1eab0
>   You can clone it from https://github.com/akiradeveloper/dm-writeboost
> 
> Test:
> 1. Make a writeboost device with 3MB cache device and 3GB backing store
>    with default option (segment size order is 7 and RAM buffer is 2MB allocated).
> 2. start testing/1 script (compiling Ruby and make test after it)
> 3. set blockup variable to 1 via message interface few seconds later.
>    The writeboost device starts to return -EIO on all incoming requests.
>    I guess this behavior causes the problem.
> 
> In some case, XFS doesn't collapse after setting blockup to 1.
> When I set the variable to 1 about 10 or 20 seconds later,
> it didn't collapse but neatly stops the compile and
> after again I set it to 0, it restarts the compile.
> XFS does collapse (badly shutting down the filesystem as seen below) in some case
> but doesn't collapse in another case sounds to me that
> the former case runs into a very corner case bug.

XFS shuts down because you've returned EIO to a log IO. That's a
fatal error. If you do the same to an ext4 journal write, it will do
the equivalent of shut down (e.g. complain and turn read-only).

> The entire set of messages via virsh console is shown below.
> Some lines related to writeboost are all benign.
> The daemons are just stopping because blockup variable is 1.
> 
> [  146.284626] XFS (dm-3): metadata I/O error: block 0x300d91 ("xlog_iodone") error 5 numblks 64
> [  146.285825] XFS (dm-3): Log I/O Error Detected.  Shutting down filesystem
> [  146.286699] XFS (dm-3): Please umount the filesystem and rectify the problem(s)

What happened before this? Please attach the *full* log.

> [  146.560036] device-mapper: writeboost: err@modulator_proc() system is blocked up on I/O error. set blockup to 0 after checkup.
> [  147.244036] device-mapper: writeboost: err@migrate_proc() system is blocked up on I/O error. set blockup to 0 after checkup.
> [  172.052006] BUG: soft lockup - CPU#0 stuck for 23s! [script:3170]
> [  172.436003] BUG: soft lockup - CPU#4 stuck for 22s! [kworker/4:1:57]

These should be emitting a stack trace. Can you turn up the logging
level you are using so that they emit a full stack trace? The
messages are useless without the stack dump....

Also, 23 seconds before this timestamp is 149s, about 3s after the
XFS filesystem shut down, so it's not clear that the XFS shutdown is
related to the soft lockup yet. That's what we need the stack traces
for...

> [  180.560040] device-mapper: writeboost: err@recorder_proc() system is blocked up on I/O error. set blockup to 0 after checkup.
> [  180.561179] device-mapper: writeboost: err@sync_proc() system is blocked up on I/O error. set blockup to 0 after checkup.

What's with the 35s delay between these writeboost messages? Have
you only done a partial shutdown of the block device and it takes
This length of time for it to completely block IO?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
