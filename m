Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p44NCHPb097348 for <xfs@oss.sgi.com>; Wed, 4 May 2011 18:12:18 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DD318C49D0E
	for <xfs@oss.sgi.com>; Wed,  4 May 2011 16:15:53 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	iyxWRgsqRwJdUx7F for <xfs@oss.sgi.com>;
	Wed, 04 May 2011 16:15:53 -0700 (PDT)
Date: Thu, 5 May 2011 09:15:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
Message-ID: <20110504231549.GA25956@dastard>
References: <20110501080149.GD13542@dastard>
	<alpine.DEB.2.01.1105012135260.18728@trent.utfs.org>
	<20110502121958.GA2978@dastard>
	<alpine.DEB.2.01.1105021247410.18728@trent.utfs.org>
	<20110503005114.GE2978@dastard>
	<alpine.DEB.2.01.1105031345090.18728@trent.utfs.org>
	<alpine.DEB.2.01.1105031740460.18728@trent.utfs.org>
	<20110504073615.GD9114@dastard> <20110504111211.GF9114@dastard>
	<alpine.DEB.2.01.1105041205340.18728@trent.utfs.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.1105041205340.18728@trent.utfs.org>
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

On Wed, May 04, 2011 at 12:10:04PM -0700, Christian Kujau wrote:
> On Wed, 4 May 2011 at 21:12, Dave Chinner wrote:
> >> Ok, that will be helpful. Also helpful is that I've (FINALLY!)
> >> reproduced this myself, and i think i can now reproduce it at will
> >> on a highmem i686 machine. I'll look into it more later tonight....
> 
> I've tried to reproduce it on an SMP i686 with 1024MB RAM, but there was 
> no OOM there.
> 
> > And here's a patch for you to try. It fixes the problem on my test
> > machine.....
> 
> Excellent! After one run with that patch, the machine does not go OOM any 
> more when running du(1) over this XFS filesystem.

Ok, That is good to know that we are seeing the same problem ;)

I'll push the fix through the XFS tree to mainline. Thanks for all
your effort helping me understand and debug the problem, Christian.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
