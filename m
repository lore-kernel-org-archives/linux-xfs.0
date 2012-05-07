Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q471rQYx148547 for <xfs@oss.sgi.com>; Sun, 6 May 2012 20:53:26 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	oQ4fvWCYTMBCf0dD for <xfs@oss.sgi.com>;
	Sun, 06 May 2012 18:53:24 -0700 (PDT)
Date: Mon, 7 May 2012 11:53:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Storage server, hung tasks and tracebacks
Message-ID: <20120507015322.GY5091@dastard>
References: <20120502184450.GA2557@nsrc.org>
	<4FA27EF8.6040002@hardwarefreak.com>
	<20120503204157.GC4387@nsrc.org>
	<4FA3047D.8060908@hardwarefreak.com>
	<20120504163237.GA6128@nsrc.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120504163237.GA6128@nsrc.org>
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
To: Brian Candler <B.Candler@pobox.com>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, xfs@oss.sgi.com

On Fri, May 04, 2012 at 05:32:37PM +0100, Brian Candler wrote:
> On Thu, May 03, 2012 at 05:19:41PM -0500, Stan Hoeppner wrote:
> > Glad to hear you've got one running somewhat stable.  Could be a driver
> > problem, but it's pretty rare for a SCSI driver to hard lock a box isn't
> > it?

No. The hardware does something bad to the PCI bus, or DMAs
something over kernel memory, or won't de-assert and interrupt line,
or .... and the system will hard hang. Hell, if it just stops and
you run out of memory because IO is needed to clean and free memory,
then system can hang there as well....

> > Keep us posted.
> 
> Last night I fired up two more instances of bonnie++ on that box, so there
> were four at once.  Going back to the box now, I find that they have all
> hung :-(
> 
> They are stuck at:
> 
>     Delete files in random order...
>     Stat files in random order...
>     Stat files in random order...
>     Stat files in sequential order...
> 
> respectively.
> 
> iostat 5 shows no activity. There are 9 hung processes:
> 
> $ uptime
>  17:23:35 up 1 day, 20:39,  1 user,  load average: 9.04, 9.08, 8.91
> $ ps auxwww | grep " D" | grep -v grep
> root        35  1.5  0.0      0     0 ?        D    May02  42:10 [kswapd0]
> root      1179  0.0  0.0      0     0 ?        D    May02   1:50 [xfsaild/md126]
> root      3127  0.0  0.0  25096   312 ?        D    16:55   0:00 /usr/lib/postfix/master
> tomi     29138  1.1  0.0 378860  3708 pts/1    D+   12:43   3:06 bonnie++ -d /disk/scratch/test -s 16384k -n 98:800k:500k:1000
> tomi     29390  1.0  0.0 378860  3560 pts/3    D+   12:52   2:53 bonnie++ -d /disk/scratch/test -s 16384k -n 98:800k:500k:1000
> tomi     30356  1.1  0.0 378860  3512 pts/2    D+   13:32   2:36 bonnie++ -d /disk/scratch/testb -s 16384k -n 98:800k:500k:1000
> root     31075  0.0  0.0      0     0 ?        D    14:00   0:04 [kworker/0:0]
> tomi     31796  0.6  0.0 378860  3864 pts/4    D+   14:30   1:05 bonnie++ -d /disk/scratch/testb -s 16384k -n 98:800k:500k:1000
> root     31922  0.0  0.0      0     0 ?        D    14:35   0:00 [kworker/1:0]
> 
> dmesg shows hung tasks and backtraces, starting with:
> 
> [150927.599920] INFO: task kswapd0:35 blocked for more than 120 seconds.
> [150927.600263] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [150927.600698] kswapd0         D ffffffff81806240     0    35      2 0x00000000
> [150927.600704]  ffff880212389330 0000000000000046 ffff880212389320 ffffffff81082df5
> [150927.600710]  ffff880212389fd8 ffff880212389fd8 ffff880212389fd8 0000000000013780
> [150927.600715]  ffff8802121816f0 ffff88020e538000 ffff880212389320 ffff88020e538000
> [150927.600719] Call Trace:
> [150927.600728]  [<ffffffff81082df5>] ? __queue_work+0xe5/0x320
> [150927.600733]  [<ffffffff8165a55f>] schedule+0x3f/0x60
> [150927.600739]  [<ffffffff814e82c6>] md_flush_request+0x86/0x140
> [150927.600745]  [<ffffffff8105f990>] ? try_to_wake_up+0x200/0x200
> [150927.600756]  [<ffffffffa0010419>] raid0_make_request+0x119/0x1c0 [raid0]

That's most likely a hardware or driver problem - the IO request
queue is full which means that IO completions are not occurring or
being delayed excessively. The problem is below the level of the
filesystem....

> I am completely at a loss with all this... I've never seen a Unix/Linux
> system behave so unreliably.

If you are buying bottom of the barrel hardware, then you get the
reliability that you pay for. Spend a few more dollars and buy
something that is properly engineered - you've wasted more money
trying to diagnose this problem that you would have saved by being
cheap hardware....

> One of the company's directors has reminded me
> that we have a Windows storage server with 48 disks which has been running
> without incident for the last 3 or 4 years, and I don't have a good answer
> for that :-(

If you buy bottom of the barrel hardware for Windows servers, then
you'll get similar results, only they'll be much harder to diagnose.
Software can't fix busted hardware...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
