Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3RAOuAS210317 for <xfs@oss.sgi.com>; Wed, 27 Apr 2011 05:24:57 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1BDB8133405C
	for <xfs@oss.sgi.com>; Wed, 27 Apr 2011 03:28:27 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	WBmy77RNNVdE2sIE for <xfs@oss.sgi.com>;
	Wed, 27 Apr 2011 03:28:27 -0700 (PDT)
Date: Wed, 27 Apr 2011 20:28:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
Message-ID: <20110427102824.GI12436@dastard>
References: <alpine.DEB.2.01.1104211841510.18728@trent.utfs.org>
	<20110424234655.GC12436@dastard>
	<alpine.DEB.2.01.1104242245090.18728@trent.utfs.org>
	<alpine.DEB.2.01.1104250015480.18728@trent.utfs.org>
	<20110427022655.GE12436@dastard>
	<alpine.DEB.2.01.1104270042510.18728@trent.utfs.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.1104270042510.18728@trent.utfs.org>
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
Cc: LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Wed, Apr 27, 2011 at 12:46:51AM -0700, Christian Kujau wrote:
> On Wed, 27 Apr 2011 at 12:26, Dave Chinner wrote:
> > What this shows is that VFS inode cache memory usage increases until
> > about the 550 sample mark before the VM starts to reclaim it with
> > extreme prejudice. At that point, I'd expect the XFS inode cache to
> > then shrink, and it doesn't. I've got no idea why the either the
> 
> Do you remember any XFS changes past 2.6.38 that could be related to 
> something like this?

There's plenty of changes that coul dbe the cause - we've changed
the inode reclaim to run in the background out of a workqueue as
well as via the shrinker, so it could even be workqueue starvation
causing the the problem...

hmmmm. Speaking of which - have you changed any of the XFS tunables
in /proc/sys/fs/xfs/ on your machine (specifically
xfssyncd_centisecs)?

> Bisecting is pretty slow on this machine. Could I somehow try to run 
> 2.6.39-rc4 but w/o the XFS changes merged after 2.6.38? (Does someone know 
> how to do this via git?)

Not easy because there are tree-wide changes that need to be
preserved (e.g. block layer plugging changes) while others around it
would need to be reverted....

> > Can you check if there are any blocked tasks nearing OOM (i.e. "echo
> > w > /proc/sysrq-trigger") so we can see if XFS inode reclaim is
> > stuck somewhere?
> 
> Will do, tomorrow.
> 
> Should I open a regression bug, so we don't loose track of this thing?

Whatever you want. 

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
