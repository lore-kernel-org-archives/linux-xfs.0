Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oANKiZDg005399 for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 14:44:35 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1BD291527628
	for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 12:46:11 -0800 (PST)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	mW8HJLYN8GP1vKX4 for <xfs@oss.sgi.com>;
	Tue, 23 Nov 2010 12:46:11 -0800 (PST)
Date: Wed, 24 Nov 2010 07:46:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Xfs delaylog hanged up
Message-ID: <20101123204609.GW22876@dastard>
References: <4CEAC412.9000406@shiftmail.org> <20101122232929.GJ13830@dastard>
	<4CEBA2D5.2020708@shiftmail.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4CEBA2D5.2020708@shiftmail.org>
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
To: Spelic <spelic@shiftmail.org>
Cc: xfs@oss.sgi.com

On Tue, Nov 23, 2010 at 12:17:41PM +0100, Spelic wrote:
> On 11/23/2010 12:29 AM, Dave Chinner wrote:
> >>16 disk MD raid-5
> >What is the storage hardware and the MD raid5 configuration?
> 
> Tyan motherboard with 5400 chipset
> dual Xeon E5420
> 
> 16 disks on this one:
> 05:00.0 RAID bus controller: 3ware Inc 9650SE SATA-II RAID PCIe (rev 01)
>         Subsystem: 3ware Inc 9650SE SATA-II RAID PCIe
>         Flags: bus master, fast devsel, latency 0, IRQ 16
>         Memory at ce000000 (64-bit, prefetchable) [size=32M]
>         Memory at d2600000 (64-bit, non-prefetchable) [size=4K]
>         I/O ports at 3000 [size=256]
>         [virtual] Expansion ROM at d26e0000 [disabled] [size=128K]
>         Capabilities: <access denied>
>         Kernel driver in use: 3w-9xxx
>         Kernel modules: 3w-9xxx

Hmmmm. We get plenty of reports about problems with 3ware RAID
controllers, many of which are RAID controller problems. Can you
make sure you are running the latest firmware on the controller?

> /# xfs_info /perftest/xfs/
> meta-data=/dev/mapper/perftestvg-xfslv isize=256    agcount=16,
> agsize=50331648 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=805306368, imaxpct=5
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=32768, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=0
> realtime =none                   extsz=4096   blocks=0, rtextents=0

Nothing unusual there.

I've been unable to reproduce the problem with your test case (been
running over night) on a 12-disk, 16TB dm RAID0 array, but I'll keep
trying to reproduce it for a while. I note that the load is
generating close to 10,000 iops on my test system, so it may very
well be triggering load related problems in your raid controller...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
