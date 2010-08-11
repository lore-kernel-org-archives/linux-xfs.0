Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7B08YS0110130
	for <linux-xfs@oss.sgi.com>; Tue, 10 Aug 2010 19:08:34 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 23A704A9701
	for <linux-xfs@oss.sgi.com>; Tue, 10 Aug 2010 17:08:57 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	QSu0CLcoR0964IvM for <linux-xfs@oss.sgi.com>;
	Tue, 10 Aug 2010 17:08:57 -0700 (PDT)
Date: Wed, 11 Aug 2010 10:08:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: observed significant performance improvement using "delaylog"
	in a real-world application
Message-ID: <20100811000854.GL26402@dastard>
References: <i3rt4t$46c$1@dough.gmane.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <i3rt4t$46c$1@dough.gmane.org>
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
To: Peter Niemayer <niemayer@isg.de>
Cc: linux-xfs@oss.sgi.com

On Tue, Aug 10, 2010 at 06:01:33PM +0200, Peter Niemayer wrote:
> Hi all,
> 
> we use XFS for a very I/O-intensive, in-house developed real-time
> database application, and whenever we see new or significantly
> changed file-systems becoming available, we run a benchmark using
> this application on a conserved, fixed real-world data set.
> 
> I'm pleased to state that using the experimental "delaylog" mount
> option (in vanilla linux-2.6.35) we measured a 17% performance
> increase
> for our benchmark scenario. (Other mount-options in use both before
> and after the "delaylog" option: noatime,nodiratime,nobarrier)

That's great to hear. One thing that you might want to try to
further improve performance is the logbsize=262144 option as well.
That will help flush log IO faster by doing less IOs.

Also, if your workload is doing lots of fsync calls, then the
optimisations I posted a few days ago should also help improve
delaylog throughput.

> That's a lot given that XFS was the fastest performing file-system
> for this application already.
> 
> It's also a promising result regarding stability, as several other
> tests (using e.g. reiser4 or ceph) in the past led to crashes in the
> same benchmark scenario.

That's definitely encouraging. ;)

> So thanks to all contributing developers for this significant optimization!

And thanks for the feedback.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
