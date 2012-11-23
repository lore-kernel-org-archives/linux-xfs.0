Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAN2sMxX015418
	for <linux-xfs@oss.sgi.com>; Thu, 22 Nov 2012 20:54:22 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	cqvGz3XWOdYwyb5t for <linux-xfs@oss.sgi.com>;
	Thu, 22 Nov 2012 18:56:33 -0800 (PST)
Date: Fri, 23 Nov 2012 13:56:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: high load and xfsaild in d
Message-ID: <20121123025624.GC32450@dastard>
References: <sn23o9xkh3.ln2@goaway.wombat.san-francisco.ca.us>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <sn23o9xkh3.ln2@goaway.wombat.san-francisco.ca.us>
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
To: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Cc: linux-xfs@oss.sgi.com

On Thu, Nov 22, 2012 at 06:13:48PM -0800, Keith Keller wrote:
> Hello all,
> 
> I recently deployed a new CentOS 6.3 file server, and soon after I
> noticed that the load was consistenly at around 4, even with no obvious
> activity.  After checking around a bit, the only unusual thing I could
> find is that the xfsaild threads are all consistently in D state:
> 
> root      1744  0.0  0.0      0     0 ?        D    Nov16   7:46 [xfsaild/dm-2]
> root      1756  0.0  0.0      0     0 ?        D    Nov16   7:44 [xfsaild/dm-1]
> root      1759  0.0  0.0      0     0 ?        D    Nov16   7:57 [xfsaild/dm-3]
> root      1762  0.0  0.0      0     0 ?        D    Nov16   5:59 [xfsaild/dm-0]

That's a side effect of a minimal set of bug fixes that were needed
to avoid a load related log space hang. Those fixes disabled the
aild idling logic so the aild acts as a watchdog, so they wake up
every 50ms to check if there's anything to do. You'll find that
3.0.x stable kernels have the same behaviour.

The aild idling logic was re-enabled in mainstream kernels after the
root cause of the log space hangs was diagnosed and fixed, but I
can't see it ever being re-enabled in a CentOS 6.3 kernel....

Cheers,

Dave
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
