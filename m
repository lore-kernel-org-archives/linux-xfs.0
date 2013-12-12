Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C9B787F53
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 04:09:55 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6374FAC001
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 02:09:52 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	fguNxUKNFHpAnE3p for <xfs@oss.sgi.com>;
	Thu, 12 Dec 2013 02:09:50 -0800 (PST)
Date: Thu, 12 Dec 2013 21:09:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/6] xfs: don't try to mark uncached buffers stale on
	error.
Message-ID: <20131212100947.GW10988@dastard>
References: <1386826478-13846-1-git-send-email-david@fromorbit.com>
	<1386826478-13846-2-git-send-email-david@fromorbit.com>
	<52A98226.4020705@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52A98226.4020705@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: xfs@oss.sgi.com

On Thu, Dec 12, 2013 at 05:30:14PM +0800, Jeff Liu wrote:
> On 12/12 2013 13:34, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > fsstress failed during a shutdown with the following assert:
> Looks fsstress is always a good aid to make file system cry... :-P

Heh. That it is. :)


> I wonder if here the shutdown is simulated via xfstests/src/godown or not,
> but I can trigger another hang up issue with this patch via a test case
> below(80% reproducible, I also ran the test against the left patches in
> this series, this problem still exists):

I occassionally get that hang, too. It's a "once a month" type hang,
and I've never beenable to reproduce it reliably enough to debug.

> #!/bin/bash
> 
> mkfs.xfs -f /dev/sda7
> 
> for ((i=0;i<10;i++))
> do
>     mount /dev/sda7 /xfs
>     fsstress -d /xfs -n 1000 -p 100 >/dev/null 2>&1 &
>     sleep 10
>     godown /xfs
>     wait
>     killall -q fsstress
>     umount /xfs
> done
> 
> It seems there is no such kind of test cases in xfstestes for now, I'd
> write one if required.

nothing quite that generic - xfs/087 does a loop like that over
different log configurations, but that's testing log recovery more
than shutdown sanity. Adding that test would be a good idea - it's a
shame no other filesystem supports a shutdown like XFS does....

> The backtraces were shown as following:
> 
> [  365.987493] INFO: task fsstress:3215 blocked for more than 120 seconds.
> [  365.987499]       Tainted: PF          O 3.13.0-rc2+ #13
> [  365.987500] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  365.987502] fsstress        D ffff88026f254440     0  3215   3142 0x00000000
> [  365.987507]  ffff880253f19de0 0000000000000086 ffff880242071800 ffff880253f19fd8
> [  365.987512]  0000000000014440 0000000000014440 ffff880242071800 ffff880073694c00
> [  365.987515]  ffff880073694c80 ffff880073694c90 ffffffffffffffff 0000000000000292
> [  365.987519] Call Trace:
> [  365.987528]  [<ffffffff81718779>] schedule+0x29/0x70
> [  365.987560]  [<ffffffffa0c2a49d>] xlog_cil_force_lsn+0x18d/0x1e0 [xfs]
> [  365.987565]  [<ffffffff81097210>] ? wake_up_state+0x20/0x20
> [  365.987570]  [<ffffffff811e8770>] ? do_fsync+0x80/0x80
> [  365.987594]  [<ffffffffa0c28921>] _xfs_log_force+0x61/0x270 [xfs]
> [  365.987599]  [<ffffffff812b0610>] ? jbd2_log_wait_commit+0x110/0x180
> [  365.987603]  [<ffffffff810a83f0>] ? prepare_to_wait_event+0x100/0x100
> [  365.987607]  [<ffffffff811e8770>] ? do_fsync+0x80/0x80
> [  365.987629]  [<ffffffffa0c28b56>] xfs_log_force+0x26/0x80 [xfs]
> [  365.987648]  [<ffffffffa0bcf35d>] xfs_fs_sync_fs+0x2d/0x50 [xfs]
> [  365.987652]  [<ffffffff811e8790>] sync_fs_one_sb+0x20/0x30
> [  365.987656]  [<ffffffff811bcc32>] iterate_supers+0xb2/0x110
> [  365.987660]  [<ffffffff811e88c2>] sys_sync+0x62/0xa0
> [  365.987665]  [<ffffffff81724ced>] system_call_fastpath+0x1a/0x1f
> [  372.225302] XFS (sda7): xfs_log_force: error 5 returned.
> [  402.275608] XFS (sda7): xfs_log_force: error 5 returned.
> [  432.325929] XFS (sda7): xfs_log_force: error 5 returned.
> [  462.376239] XFS (sda7): xfs_log_force: error 5 returned.

So what we see here is that there is a race condition somewhere in
the shutdown code. The shutdown is supposed to wake everyone waiting
of the ic_force_wait wait queue on each iclog, but for some reason
that hasn't happened. The sleepers check for XLOG_STATE_IOERROR
(which is set during the force shutdown before we wake ic_force_wait
sleepers) before they go to sleep, so whatever the race is it isn't
immediately obvious to me.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
