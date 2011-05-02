Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p424u3Ql210425 for <xfs@oss.sgi.com>; Sun, 1 May 2011 23:56:04 -0500
Received: from trent.utfs.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 117EB1647674
	for <xfs@oss.sgi.com>; Sun,  1 May 2011 21:59:37 -0700 (PDT)
Received: from trent.utfs.org (trent.utfs.org [194.246.123.103]) by
	cuda.sgi.com with ESMTP id wDMYbSVuHuIYYzFf for
	<xfs@oss.sgi.com>; Sun, 01 May 2011 21:59:37 -0700 (PDT)
Date: Sun, 1 May 2011 21:59:35 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
In-Reply-To: <20110501080149.GD13542@dastard>
Message-ID: <alpine.DEB.2.01.1105012135260.18728@trent.utfs.org>
References: <alpine.DEB.2.01.1104242245090.18728@trent.utfs.org>
	<alpine.DEB.2.01.1104250015480.18728@trent.utfs.org>
	<20110427022655.GE12436@dastard>
	<alpine.DEB.2.01.1104270042510.18728@trent.utfs.org>
	<20110427102824.GI12436@dastard>
	<alpine.DEB.2.01.1104281008320.18728@trent.utfs.org>
	<20110428233751.GR12436@dastard>
	<alpine.DEB.2.01.1104291250480.18728@trent.utfs.org>
	<20110429201701.GA13166@x4.trippels.de>
	<alpine.DEB.2.01.1104291710340.18728@trent.utfs.org>
	<20110501080149.GD13542@dastard>
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: minchan.kim@gmail.com, LKML <linux-kernel@vger.kernel.org>, Markus Trippelsdorf <markus@trippelsdorf.de>, xfs@oss.sgi.com

On Sun, 1 May 2011 at 18:01, Dave Chinner wrote:
> I really don't know why the xfs inode cache is not being trimmed. I
> really, really need to know if the XFS inode cache shrinker is
> getting blocked or not running - do you have those sysrq-w traces
> when near OOM I asked for a while back?

I tried to generate those via /proc/sysrq-trigger (don't have a F13/Print 
Screen key), but the OOM killer kicks in prett fast - so fast thay my 
debug script, trying to generate sysrq-w every second was too late and the 
machine was already dead:

   http://nerdbynature.de/bits/2.6.39-rc4/oom/
   * messages-10.txt.gz
   * slabinfo-10.txt.bz2

Timeline:
  - du(1) started at 12:25:16 (and immediately listed
    as "blocked" task)
  - the last sysrq-w succeeded at 12:38:05, listing kswapd0
  - du invoked oom-killer at 12:38:06

I'll keep trying...

> scan only scanned 516 pages. I can't see it freeing many inodes
> (there's >600,000 of them in memory) based on such a low page scan
> number.

Not sure if this is related...this XFS filesytem I'm running du(1) on is 
~1 TB in size, with 918K allocated inodes, if df(1) is correct:

# df -hi /mnt/backup/
Filesystem            Inodes   IUsed   IFree IUse% Mounted on
/dev/mapper/wdc1         37M    918K     36M    3% /mnt/backup

> Maybe you should tweak /proc/sys/vm/vfs_cache_pressure to make it
> reclaim vfs structures more rapidly. It might help

/proc/sys/vm/vfs_cache_pressure is currently set to '100'. You mean I 
should increase it? To..150? 200? 1000?

Thanks,
Christian.
-- 
BOFH excuse #347:

The rubber band broke

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
