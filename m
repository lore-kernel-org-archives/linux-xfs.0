Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q44GWhSU055698 for <xfs@oss.sgi.com>; Fri, 4 May 2012 11:32:43 -0500
Received: from smtp.pobox.com (b-pb-sasl-quonix.pobox.com [208.72.237.35]) by
	cuda.sgi.com with ESMTP id XVzdX6ArANfrGus1 for
	<xfs@oss.sgi.com>; Fri, 04 May 2012 09:32:42 -0700 (PDT)
Date: Fri, 4 May 2012 17:32:37 +0100
From: Brian Candler <B.Candler@pobox.com>
Subject: Re: Storage server, hung tasks and tracebacks
Message-ID: <20120504163237.GA6128@nsrc.org>
References: <20120502184450.GA2557@nsrc.org>
	<4FA27EF8.6040002@hardwarefreak.com> <20120503204157.GC4387@nsrc.org>
	<4FA3047D.8060908@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FA3047D.8060908@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

On Thu, May 03, 2012 at 05:19:41PM -0500, Stan Hoeppner wrote:
> Glad to hear you've got one running somewhat stable.  Could be a driver
> problem, but it's pretty rare for a SCSI driver to hard lock a box isn't
> it?

Yes, that bothers me too.

> Keep us posted.

Last night I fired up two more instances of bonnie++ on that box, so there
were four at once.  Going back to the box now, I find that they have all
hung :-(

They are stuck at:

    Delete files in random order...
    Stat files in random order...
    Stat files in random order...
    Stat files in sequential order...

respectively.

iostat 5 shows no activity. There are 9 hung processes:

$ uptime
 17:23:35 up 1 day, 20:39,  1 user,  load average: 9.04, 9.08, 8.91
$ ps auxwww | grep " D" | grep -v grep
root        35  1.5  0.0      0     0 ?        D    May02  42:10 [kswapd0]
root      1179  0.0  0.0      0     0 ?        D    May02   1:50 [xfsaild/md126]
root      3127  0.0  0.0  25096   312 ?        D    16:55   0:00 /usr/lib/postfix/master
tomi     29138  1.1  0.0 378860  3708 pts/1    D+   12:43   3:06 bonnie++ -d /disk/scratch/test -s 16384k -n 98:800k:500k:1000
tomi     29390  1.0  0.0 378860  3560 pts/3    D+   12:52   2:53 bonnie++ -d /disk/scratch/test -s 16384k -n 98:800k:500k:1000
tomi     30356  1.1  0.0 378860  3512 pts/2    D+   13:32   2:36 bonnie++ -d /disk/scratch/testb -s 16384k -n 98:800k:500k:1000
root     31075  0.0  0.0      0     0 ?        D    14:00   0:04 [kworker/0:0]
tomi     31796  0.6  0.0 378860  3864 pts/4    D+   14:30   1:05 bonnie++ -d /disk/scratch/testb -s 16384k -n 98:800k:500k:1000
root     31922  0.0  0.0      0     0 ?        D    14:35   0:00 [kworker/1:0]

dmesg shows hung tasks and backtraces, starting with:

[150927.599920] INFO: task kswapd0:35 blocked for more than 120 seconds.
[150927.600263] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[150927.600698] kswapd0         D ffffffff81806240     0    35      2 0x00000000
[150927.600704]  ffff880212389330 0000000000000046 ffff880212389320 ffffffff81082df5
[150927.600710]  ffff880212389fd8 ffff880212389fd8 ffff880212389fd8 0000000000013780
[150927.600715]  ffff8802121816f0 ffff88020e538000 ffff880212389320 ffff88020e538000
[150927.600719] Call Trace:
[150927.600728]  [<ffffffff81082df5>] ? __queue_work+0xe5/0x320
[150927.600733]  [<ffffffff8165a55f>] schedule+0x3f/0x60
[150927.600739]  [<ffffffff814e82c6>] md_flush_request+0x86/0x140
[150927.600745]  [<ffffffff8105f990>] ? try_to_wake_up+0x200/0x200
[150927.600756]  [<ffffffffa0010419>] raid0_make_request+0x119/0x1c0 [raid0]
...

Now, the only other thing I have found by googling is a suggestion that LSI
drivers lock up when there is any smart or hddtemp activity: see end of
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/906873

On this system the smartmontools package is installed, but I have not
configured it, and smartd is not running.  I don't have hddtemp installed
either.

I am completely at a loss with all this... I've never seen a Unix/Linux
system behave so unreliably.  One of the company's directors has reminded me
that we have a Windows storage server with 48 disks which has been running
without incident for the last 3 or 4 years, and I don't have a good answer
for that :-(

Regards,

Brian.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
