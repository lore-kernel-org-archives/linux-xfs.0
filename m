Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p42CYqnb231773 for <xfs@oss.sgi.com>; Mon, 2 May 2011 07:34:52 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9E37A1EC7B03
	for <xfs@oss.sgi.com>; Mon,  2 May 2011 05:38:27 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	1ctPhYicZykCol8u for <xfs@oss.sgi.com>;
	Mon, 02 May 2011 05:38:27 -0700 (PDT)
Date: Mon, 2 May 2011 22:38:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
Message-ID: <20110502123824.GB2978@dastard>
References: <20110427022655.GE12436@dastard>
	<alpine.DEB.2.01.1104270042510.18728@trent.utfs.org>
	<20110427102824.GI12436@dastard>
	<alpine.DEB.2.01.1104281008320.18728@trent.utfs.org>
	<20110428233751.GR12436@dastard>
	<alpine.DEB.2.01.1104291250480.18728@trent.utfs.org>
	<20110429201701.GA13166@x4.trippels.de>
	<alpine.DEB.2.01.1104291710340.18728@trent.utfs.org>
	<20110501080149.GD13542@dastard>
	<alpine.DEB.2.01.1105020210160.18728@trent.utfs.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.1105020210160.18728@trent.utfs.org>
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
To: Christian Kujau <lists@nerdbynature.de>
Cc: minchan.kim@gmail.com, LKML <linux-kernel@vger.kernel.org>, Markus Trippelsdorf <markus@trippelsdorf.de>, xfs@oss.sgi.com

On Mon, May 02, 2011 at 02:26:17AM -0700, Christian Kujau wrote:
> On Sun, 1 May 2011 at 18:01, Dave Chinner wrote:
> > I really don't know why the xfs inode cache is not being trimmed. I
> > really, really need to know if the XFS inode cache shrinker is
> > getting blocked or not running - do you have those sysrq-w traces
> > when near OOM I asked for a while back?
> 
> Here's another attempt at getting those:
> 
>   http://nerdbynature.de/bits/2.6.39-rc4/oom/
>   * messages-11.txt.gz & slabinfo-11.txt.bz2
>     - oom-killer at 00:05:04
>     - last sysrq-w to succeed at 00:05:03
> 
>   * messages-12.txt.gz & slabinfo-12.txt.bz2, along
>     with meminfo-post-oom-12.txt & sysrq-w_post-oom-12.jpg could
>     be more interesting:
>     - last sysrq-w to succeed at 01:27:08
>     - oom-killer at 01:27:11
> 
>    ...but after the OOM-killer was killing quite a few processes, MemFree
>    showed 511236 kB free memory, yet ssh logins were still being killed.
>    Finally I got a root shell on the box, issued sysrq-w again and even
>    executed /bin/sync, which came back. But looking at the logs now 
>    nothing went to the disk (/var/log resides on / which is a ext4 fs).
>    See sysrq-w_post-oom-12.jpg for a sysrq-w I took 2381s after boot time,
>    or 01:32 - syslog stopped on 01:27.

Same problem:

MemFree:          511236 kB
....
LowTotal:         759904 kB
LowFree:            3804 kB

i.e. that low memory is being exhausted by the slab cache, while
there is lots of free high memory, and the low memory zone is marked
as all unreclaimable....

The sysrq trace less than 1s before the first OOM shows this:

[c00770ec] __lock_acquire+0x43c/0x1818 (unreliable)
[c000a924] __switch_to+0x9c/0x128
[c0417580] schedule+0x274/0x8bc
[c0418128] schedule_timeout+0x16c/0x214
[c04172a0] io_schedule_timeout+0xb0/0x11c
[c00b153c] congestion_wait+0x8c/0xdc
[c00aa43c] kswapd+0x6d0/0x884
[c005e3d0] kthread+0x84/0x88
[c0010908] kernel_thread+0x4c/0x68

Background memory reclaim appears to be blocked by IO congestion....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
