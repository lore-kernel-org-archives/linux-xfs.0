Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAN5bHMT030321
	for <linux-xfs@oss.sgi.com>; Thu, 22 Nov 2012 23:37:17 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	UqJujsa3zasSs1eL for <linux-xfs@oss.sgi.com>;
	Thu, 22 Nov 2012 21:39:29 -0800 (PST)
Date: Fri, 23 Nov 2012 16:39:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: high load and xfsaild in d
Message-ID: <20121123053913.GD32450@dastard>
References: <sn23o9xkh3.ln2@goaway.wombat.san-francisco.ca.us>
	<20121123025624.GC32450@dastard>
	<uua3o9x9q5.ln2@goaway.wombat.san-francisco.ca.us>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <uua3o9x9q5.ln2@goaway.wombat.san-francisco.ca.us>
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

On Thu, Nov 22, 2012 at 08:34:06PM -0800, Keith Keller wrote:
> On 2012-11-23, Dave Chinner <david@fromorbit.com> wrote:
> > That's a side effect of a minimal set of bug fixes that were needed
> > to avoid a load related log space hang. Those fixes disabled the
> > aild idling logic so the aild acts as a watchdog, so they wake up
> > every 50ms to check if there's anything to do. You'll find that
> > 3.0.x stable kernels have the same behaviour.
> >
> > The aild idling logic was re-enabled in mainstream kernels after the
> > root cause of the log space hangs was diagnosed and fixed, but I
> > can't see it ever being re-enabled in a CentOS 6.3 kernel....
> 
> Thanks for the clarification, Dave.  It sounds like I would need to
> either wait for this fix to hit the CentOS release kernel, or compile my
> own.

Do whatever you want - you might be waiting a while for CentOS to
fix it, though, because they don't fix user reported bugs. They just
repackage whatever Red Hat releases as RHEL.

TANSTAAFL.

> Do you know why I might not see this behavior on a different CentOS 6.x
> kernel?
> 
> Linux xxxxxx 2.6.32-279.5.2.el6.x86_64 #1 SMP Fri Aug 24 01:07:11 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux

Because the log hang bug hadn't been fixed in that kernel.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
