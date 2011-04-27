Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3RNrUwE237697 for <xfs@oss.sgi.com>; Wed, 27 Apr 2011 18:53:30 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E8554154B350
	for <xfs@oss.sgi.com>; Wed, 27 Apr 2011 16:57:02 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	HCvvg99zlN4tlqvk for <xfs@oss.sgi.com>;
	Wed, 27 Apr 2011 16:57:02 -0700 (PDT)
Date: Thu, 28 Apr 2011 09:56:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
Message-ID: <20110427235658.GJ12436@dastard>
References: <alpine.DEB.2.01.1104211841510.18728@trent.utfs.org>
	<20110424234655.GC12436@dastard>
	<alpine.DEB.2.01.1104242245090.18728@trent.utfs.org>
	<alpine.DEB.2.01.1104250015480.18728@trent.utfs.org>
	<20110427022655.GE12436@dastard>
	<alpine.DEB.2.01.1104270042510.18728@trent.utfs.org>
	<20110427102824.GI12436@dastard>
	<BANLkTimDoZueDWqB_LBndqPorCnTOZkNYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BANLkTimDoZueDWqB_LBndqPorCnTOZkNYQ@mail.gmail.com>
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
To: Minchan Kim <minchan.kim@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Thu, Apr 28, 2011 at 08:16:29AM +0900, Minchan Kim wrote:
> On Wed, Apr 27, 2011 at 7:28 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Wed, Apr 27, 2011 at 12:46:51AM -0700, Christian Kujau wrote:
> >> On Wed, 27 Apr 2011 at 12:26, Dave Chinner wrote:
> >> > What this shows is that VFS inode cache memory usage increases until
> >> > about the 550 sample mark before the VM starts to reclaim it with
> >> > extreme prejudice. At that point, I'd expect the XFS inode cache to
> >> > then shrink, and it doesn't. I've got no idea why the either the
> >>
> >> Do you remember any XFS changes past 2.6.38 that could be related to
> >> something like this?
> >
> > There's plenty of changes that coul dbe the cause - we've changed
> > the inode reclaim to run in the background out of a workqueue as
> > well as via the shrinker, so it could even be workqueue starvation
> > causing the the problem...
> 
> RCU free starvation is another possibility?
> https://lkml.org/lkml/2011/4/25/124

You know, I've been waching that thread with interest, but it didn't
seem to be related. However, now that I go look at the config file
provided, I see:

CONFIG_TINY_RCU=y
# CONFIG_SMP is not set
CONFIG_PREEMPT_NONE=y

which means it probably is the same rcu free starvation problem as
reported in that thread.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
