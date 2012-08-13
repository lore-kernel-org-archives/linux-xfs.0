Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7DNuUCR073153 for <xfs@oss.sgi.com>; Mon, 13 Aug 2012 18:56:30 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	kdlMGc3E5BV9g4ir for <xfs@oss.sgi.com>;
	Mon, 13 Aug 2012 16:56:27 -0700 (PDT)
Date: Tue, 14 Aug 2012 09:56:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: howto keep xfs directory searches fast for a long time
Message-ID: <20120813235623.GJ2877@dastard>
References: <6344220.LKveJofnHA@saturn> <5028057F.3090007@hardwarefreak.com>
	<2561870.uQFC4XLYQm@saturn>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <2561870.uQFC4XLYQm@saturn>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: stan@hardwarefreak.com, xfs@oss.sgi.com

On Mon, Aug 13, 2012 at 06:44:34PM +0200, Michael Monnerie wrote:
> I guess the best I can do is run du/find every morning to pre-fill the 
> inode caches on that VM, so when someone connects the search runs fast.

You're doing it wrong. This is exactly what updatedb (run via cron)
and locate (the updatedb search tool) are designed for.

$ time locate xfs_admin
.....
real    0m0.618s
user    0m0.608s
sys     0m0.004s
$
$ time find / -name xfs_admin*
....
real    0m18.045s
user    0m2.936s
sys     0m9.293s
$ time find / -name xfs_admin* > /dev/null 2>&1

real    0m1.794s
user    0m0.688s
sys     0m1.068s
$ time find / -name xfs_admin* > /dev/null 2>&1

real    0m1.752s
user    0m0.724s
sys     0m0.984s
$ time find / -name xfs_admin* > /dev/null 2>&1

real    0m1.768s
user    0m0.732s
sys     0m0.996s

locate is 3x faster than even a cached find on a filesystem with a
million inodes in it and enough RAM to cache them all. And if you
have limited RAM, (i.e. cold cache) it is 30x faster than running
the find on a RAID0 of SSDs that can do > 90,000 random 4k read
IOPS. The differences for spinning rust will be much, much
greater...

Use the right tool for the job....

> The current VM shows this:
> 
> # df -i /disks/big1/
> Filesystem                    Inodes   IUsed      IFree IUse% Mounted on
> /dev/mapper/sp1--sha 1717934464 1255882 1716678582    1% /disks/big1
> # df /disks/big1/
> Filesystem               1K-blocks       Used  Available Use% Mounted on
> /dev/mapper/sp1--sha 8587585536 6004421384 2583164152  70% /disks/big1
> 
> So 6TB data in 1.3 mio inodes. The VM caches that easily, seems that's 
> the only real thing to optimize against.
> 
> http://xfs.org/index.php/XFS_FAQ#Q:_I_want_to_tune_my_XFS_filesystems_for_.3Csomething.3E

I appreciate the sentiment, but as the the person that wrote the
original entry and directs the most people to it, I'm probably just
going to remove this addition. The whole point of that FAQ is to
say "unless you *know* you have a problem, don't touch anything".

What you've added essentially says "if you *think* you might need
<something>, then do...". This train of thought is *exactly* what
the FAQ entry is advising *against* doing because in most cases what
people -think- they need is incorrect or misguided.

You've even provided a great example to emphasise the point the
entry is making - you need to understand the workload before
tweaking knobs. Your workload is occassional fast searches of files,
which is exactly what updatedb/locate provides without kernel
or filesystem tweaks...

> CFQ seems bad, but there's no documented way out of that.

If you know what CFQ is, then you know how to change it. If you
don't know what it is, then you don't know enough to make an
enlightened choice as a replacement. If you lacking knowledge of
basic storage concepts and setup, then you're reading the wrong
document. Google is only a browser tab away.

BTW, if you want to add "how to tune XFS" entries, then create a
completely new wiki page about it that first points in big red,
shiny letters that the above FAQ entry should be read first, and
that questions about optimising XFS for bonnie++ and other
benchmarks will be directed to /dev/null. Structure it to provide
information about the basics - alignment, striping, data layout,
metadata layout, RAID configurations, etc and how the different XFS
mkfs and mount options interact with the different storage
configurations.

If we are going to provide tuning guidelines on the XFS wiki, then
it needs to be structured, comprehensive and correct. If you want
random bits of marginally valid information abou ttuning XFS from
random websites around the web, Google is only a browser tab
away....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
