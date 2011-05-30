Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4UA7PnM239393 for <xfs@oss.sgi.com>; Mon, 30 May 2011 05:07:25 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3898748D977
	for <xfs@oss.sgi.com>; Mon, 30 May 2011 03:07:23 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	XBpMpOW75HwZN1Pu for <xfs@oss.sgi.com>;
	Mon, 30 May 2011 03:07:23 -0700 (PDT)
Date: Mon, 30 May 2011 20:07:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [regression, 3.0-rc1] dentry cache growth during unlinks, XFS
	performance way down
Message-ID: <20110530100719.GE561@dastard>
References: <20110530020604.GC561@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110530020604.GC561@dastard>
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
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Mon, May 30, 2011 at 12:06:04PM +1000, Dave Chinner wrote:
.....
> Performance is now a very regular peak/trough patten with a period
> of about 20s, where the peak is about 80k unlinks/s, and the trough
> is around 20k unlinks/s. The runtime of the 50m inode delete has
> gone from around 10m on 2.6.39, to:
> 
> 11.71user 470.08system 15:07.91elapsed 53%CPU (0avgtext+0avgdata 133184maxresident)k
> 0inputs+0outputs (30major+497228minor)pagefaults 0swaps
> 11.50user 468.30system 15:14.35elapsed 52%CPU (0avgtext+0avgdata 133168maxresident)k
> 0inputs+0outputs (42major+497268minor)pagefaults 0swaps
> 11.34user 466.66system 15:26.04elapsed 51%CPU (0avgtext+0avgdata 133216maxresident)k
> 0inputs+0outputs (18major+497121minor)pagefaults 0swaps
> 12.14user 470.46system 15:26.60elapsed 52%CPU (0avgtext+0avgdata 133216maxresident)k
> 0inputs+0outputs (44major+497309minor)pagefaults 0swaps
> 12.06user 463.74system 15:28.84elapsed 51%CPU (0avgtext+0avgdata 133232maxresident)k
> 0inputs+0outputs (25major+497046minor)pagefaults 0swaps
> 11.37user 468.18system 15:29.07elapsed 51%CPU (0avgtext+0avgdata 133184maxresident)k
> 0inputs+0outputs (55major+497056minor)pagefaults 0swaps
> 11.69user 474.46system 15:47.45elapsed 51%CPU (0avgtext+0avgdata 133232maxresident)k
> 0inputs+0outputs (61major+497284minor)pagefaults 0swaps
> 11.32user 476.93system 16:05.14elapsed 50%CPU (0avgtext+0avgdata 133184maxresident)k
> 0inputs+0outputs (30major+497225minor)pagefaults 0swaps
> 
> About 16 minutes. I'm not sure yet whether this change of cache
> behaviour is the cause of the entire performance regression, but
> it's a good chance that it is a contributing factor.

I'm not sure about this one, now. I suspect I've got a repeat of a
recent "scrambled RAID controller" problem where it decided to
silently change the BBWC mode on all the LUNS. I've re-run the tests
on 2.6.39-rc4 where I know everything was running fine, and I'm
getting the same results as above and not what I was getting a month
ago.

[ one cold reset of the server and disk array later ]

Yeah, that appears to be the problem.

> Christoph, it appears that there is a significant increase in log
> forces during this unlink workload compared to 2.6.39, and that's
> possibly where the performance degradation is coming from. I'm going
> to have to bisect, I think.
> 
> The 8-way create rate for the 50m inodes is down by 10% as well, but I
> don't think that has anything to do with dentry cache behaviour -
> log write throughput is up by a factor of 3x over 2.6.39. Christoph,
> I think that this is once again due to an increase in log forces,
> but I need to do more analysis to be sure...

The increase in log forces was only a side effect of the slower IO
subsystem resulting in the AIL tail pushing hitting more pinned
buffers and issuing more log forces. Pretty much back to the same
level as previously with the reset raid array. False alarm.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
