Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4341Hdb258218 for <xfs@oss.sgi.com>; Mon, 2 May 2011 23:01:17 -0500
Received: from trent.utfs.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 95E7C11C6221
	for <xfs@oss.sgi.com>; Mon,  2 May 2011 21:04:53 -0700 (PDT)
Received: from trent.utfs.org (trent.utfs.org [194.246.123.103]) by
	cuda.sgi.com with ESMTP id oMgu2lNO4gvFFolF for
	<xfs@oss.sgi.com>; Mon, 02 May 2011 21:04:53 -0700 (PDT)
Date: Mon, 2 May 2011 21:04:40 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
In-Reply-To: <20110503005114.GE2978@dastard>
Message-ID: <alpine.DEB.2.01.1105022053210.18728@trent.utfs.org>
References: <20110427102824.GI12436@dastard>
	<alpine.DEB.2.01.1104281008320.18728@trent.utfs.org>
	<20110428233751.GR12436@dastard>
	<alpine.DEB.2.01.1104291250480.18728@trent.utfs.org>
	<20110429201701.GA13166@x4.trippels.de>
	<alpine.DEB.2.01.1104291710340.18728@trent.utfs.org>
	<20110501080149.GD13542@dastard>
	<alpine.DEB.2.01.1105012135260.18728@trent.utfs.org>
	<20110502121958.GA2978@dastard>
	<alpine.DEB.2.01.1105021247410.18728@trent.utfs.org>
	<20110503005114.GE2978@dastard>
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

On Tue, 3 May 2011 at 10:51, Dave Chinner wrote:
> Can you run an event trace of all the XFS events during a find for
> me? Don't do it over the entire subset of the filesystem - only

You mean "event tracing", as in Documentation/trace/events.txt. For 
that I will have to enable CONFIG_FTRACE and CONFIG_FUNCTION_TRACER and 
probably others, right?

Looking at http://lwn.net/Articles/341899, I see CONFIG_EVENT_TRACING 
and the way to enable event tracing for "all events in fs/xfs" would be:

  echo 1 > /sys/kernel/debug/tracing/events/xfs/enable

> 100,000 inodes is sufficient (i.e. kill the find once the xfs inode
> cache slab reaches 100k inodes. While still running the event trace,
> can you then drop the caches (echo 3 > /proc/sys/vm/drop_caches) and
> check that the xfs inode cache is emptied? If it isn't emptied, drop
> caches again to see if that empties it. If you coul dthen post the
> event trace, I might be able to see what is going strange with the
> shrinker and/or reclaim.

Will try to do all that.

I wonder why nobody else is affected by this. Because nobody else runs 
powerpc or UP any more? I'm sure other people's filesystems are way bigger 
than mine, with much more inodes to cache...

Thanks for your time,
Christian. 
-- 
BOFH excuse #136:

Daemons loose in system.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
