Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p436XQv7003338 for <xfs@oss.sgi.com>; Tue, 3 May 2011 01:33:27 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DDC66157AC69
	for <xfs@oss.sgi.com>; Mon,  2 May 2011 23:37:02 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	mWJSq5a3kluJ4QJN for <xfs@oss.sgi.com>;
	Mon, 02 May 2011 23:37:02 -0700 (PDT)
Date: Tue, 3 May 2011 16:36:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
Message-ID: <20110503063657.GB9114@dastard>
References: <20110428233751.GR12436@dastard>
	<alpine.DEB.2.01.1104291250480.18728@trent.utfs.org>
	<20110429201701.GA13166@x4.trippels.de>
	<alpine.DEB.2.01.1104291710340.18728@trent.utfs.org>
	<20110501080149.GD13542@dastard>
	<alpine.DEB.2.01.1105012135260.18728@trent.utfs.org>
	<20110502121958.GA2978@dastard>
	<alpine.DEB.2.01.1105021247410.18728@trent.utfs.org>
	<20110503005114.GE2978@dastard>
	<alpine.DEB.2.01.1105022053210.18728@trent.utfs.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.1105022053210.18728@trent.utfs.org>
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

On Mon, May 02, 2011 at 09:04:40PM -0700, Christian Kujau wrote:
> On Tue, 3 May 2011 at 10:51, Dave Chinner wrote:
> > Can you run an event trace of all the XFS events during a find for
> > me? Don't do it over the entire subset of the filesystem - only
> 
> You mean "event tracing", as in Documentation/trace/events.txt. For 
> that I will have to enable CONFIG_FTRACE and CONFIG_FUNCTION_TRACER and 
> probably others, right?
> 
> Looking at http://lwn.net/Articles/341899, I see CONFIG_EVENT_TRACING 
> and the way to enable event tracing for "all events in fs/xfs" would be:
> 
>   echo 1 > /sys/kernel/debug/tracing/events/xfs/enable

Download trace-cmd and use that - more efficient and easier to
specify the events to record...

> > 100,000 inodes is sufficient (i.e. kill the find once the xfs inode
> > cache slab reaches 100k inodes. While still running the event trace,
> > can you then drop the caches (echo 3 > /proc/sys/vm/drop_caches) and
> > check that the xfs inode cache is emptied? If it isn't emptied, drop
> > caches again to see if that empties it. If you coul dthen post the
> > event trace, I might be able to see what is going strange with the
> > shrinker and/or reclaim.
> 
> Will try to do all that.
> 
> I wonder why nobody else is affected by this. Because nobody else runs 
> powerpc or UP any more? I'm sure other people's filesystems are way bigger 
> than mine, with much more inodes to cache...

XFS on uniprocessor, 32 bit, highmem system is pretty rare. Let
alone on an old powerpc platform. It's so far out in left field that
I'd expect the only test coverage we get is your laptop....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
