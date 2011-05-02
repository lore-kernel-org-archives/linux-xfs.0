Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p429Mi0J224245 for <xfs@oss.sgi.com>; Mon, 2 May 2011 04:22:44 -0500
Received: from trent.utfs.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6013D1EC7317
	for <xfs@oss.sgi.com>; Mon,  2 May 2011 02:26:19 -0700 (PDT)
Received: from trent.utfs.org (trent.utfs.org [194.246.123.103]) by
	cuda.sgi.com with ESMTP id eidgDQApxYsU5oKf for
	<xfs@oss.sgi.com>; Mon, 02 May 2011 02:26:19 -0700 (PDT)
Date: Mon, 2 May 2011 02:26:17 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
In-Reply-To: <20110501080149.GD13542@dastard>
Message-ID: <alpine.DEB.2.01.1105020210160.18728@trent.utfs.org>
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

Here's another attempt at getting those:

  http://nerdbynature.de/bits/2.6.39-rc4/oom/
  * messages-11.txt.gz & slabinfo-11.txt.bz2
    - oom-killer at 00:05:04
    - last sysrq-w to succeed at 00:05:03

  * messages-12.txt.gz & slabinfo-12.txt.bz2, along
    with meminfo-post-oom-12.txt & sysrq-w_post-oom-12.jpg could
    be more interesting:
    - last sysrq-w to succeed at 01:27:08
    - oom-killer at 01:27:11

   ...but after the OOM-killer was killing quite a few processes, MemFree
   showed 511236 kB free memory, yet ssh logins were still being killed.
   Finally I got a root shell on the box, issued sysrq-w again and even
   executed /bin/sync, which came back. But looking at the logs now 
   nothing went to the disk (/var/log resides on / which is a ext4 fs).
   See sysrq-w_post-oom-12.jpg for a sysrq-w I took 2381s after boot time,
   or 01:32 - syslog stopped on 01:27.

I shall try again with netconsole loggin or something...

HTH & thanks for looking into this,
Christian.
-- 
BOFH excuse #176:

vapors from evaporating sticky-note adhesives

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
