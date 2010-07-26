Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6Q0Fxid086878 for <xfs@oss.sgi.com>; Sun, 25 Jul 2010 19:16:00 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 32D02132E727
	for <xfs@oss.sgi.com>; Sun, 25 Jul 2010 17:26:13 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	2PiBsrQBKsyjcC0K for <xfs@oss.sgi.com>;
	Sun, 25 Jul 2010 17:26:13 -0700 (PDT)
Date: Mon, 26 Jul 2010 10:18:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: bug and fun with XFS: unable to handle kernel NULL pointer
	dereference
Message-ID: <20100726001859.GD655@dastard>
References: <201007260019.51568@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201007260019.51568@zmi.at>
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
Cc: xfs@oss.sgi.com

On Mon, Jul 26, 2010 at 12:19:47AM +0200, Michael Monnerie wrote:
> I just enjoy an obviously broken XFS filesystem. It was a running 
> server, which I planned to migrate so I did "rsync -aHAX / 
> otherhost::rsyncmodule", and experienced a "killed". At that time I 
> thought it was a one time mistake, so restarted rsync, but Murphy made 
> it get killed again.
> 
> So I looked into dmesg, just to find this: It's the log of all messages, 
> so maybe twice the same, I copy everything for reference. See attachment 
> "xfs-bug.dmesg.txt".

The first occurrence is:

> Pid: 1809, comm: syslog-ng Not tainted 2.6.27.48-0.1-xen #1

That's an old kernel, and doesn't seem related to the rsync
triggered problem, even though it is the same oops signature.

> I started to look, and quickly found a funny problem: Once I mount that 
> partition, I cannot unmount it again:
> 
> # mount /disks/work/
> # umount /disks/work/
> umount: /disks/work: device is busy.
>         (In some cases useful info about processes that use
>          the device is found by lsof(8) or fuser(1))

Some other process has taken a reference to the fs, I'd say.
And if that process triggered an oops, then you'd see this.

> So I rebooted without mounting that partition, and 
> 
> # xfs_repair -n /dev/xvda2 [VERSION:3.1.2]
> xfs_repair: /lib64/libuuid.so.1: no version information available 
> (required by xfs_repair)                                                                                                                                          
> Phase 1 - find and verify superblock...                                                                                                                                                                                             
> Phase 2 - using internal log                                                                                                                                                                                                        
>         - scan filesystem freespace and inode maps...                                                                                                                                                                               
>         - found root inode chunk
> Phase 3 - for each AG...
>         - scan (but don't clear) agi unlinked lists...
>         - process known inodes and perform inode discovery...
>         - agno = 0
>         - agno = 1
> local inode 8636461 attr too small (size = 0, min size = 4)
> bad attribute fork in inode 8636461, would clear attr fork
> would have cleared inode 8636461

Corrupt attribute fork - matches with the oops signatures.  I'd
definitely consider upgrading your kernel as a first step...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
