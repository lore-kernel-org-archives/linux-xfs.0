Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qANLVeif119868
	for <linux-xfs@oss.sgi.com>; Fri, 23 Nov 2012 15:31:40 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	1p3VAZC901tFfj5Y for <linux-xfs@oss.sgi.com>;
	Fri, 23 Nov 2012 13:33:52 -0800 (PST)
Date: Sat, 24 Nov 2012 08:33:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: high load and xfsaild in d
Message-ID: <20121123213350.GL32450@dastard>
References: <sn23o9xkh3.ln2@goaway.wombat.san-francisco.ca.us>
	<20121123025624.GC32450@dastard>
	<uua3o9x9q5.ln2@goaway.wombat.san-francisco.ca.us>
	<20121123053913.GD32450@dastard>
	<fc25o9xgfg.ln2@goaway.wombat.san-francisco.ca.us>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <fc25o9xgfg.ln2@goaway.wombat.san-francisco.ca.us>
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

On Fri, Nov 23, 2012 at 12:19:59PM -0800, Keith Keller wrote:
> On 2012-11-23, Dave Chinner <david@fromorbit.com> wrote:
> >
> > Do whatever you want - you might be waiting a while for CentOS to
> > fix it, though, because they don't fix user reported bugs. They just
> > repackage whatever Red Hat releases as RHEL.
> 
> Yes, that's why I was asking--I was wondering whether it is safe to wait
> for what could be some time for a) RHEL to decide to patch (if they do
> so at all), b) RHEL to patch, and c) CentOS to patch.  IOW, is the high
> load the only likely symptom of the originail aild patch, or are there
> potentially other problems, such as performance degradation that I
> haven't seen yet, that would make waiting for CentOS unwise?

There is no side effect other than the load. There are not
performance issues with the ailds behaving like this.

> >> Do you know why I might not see this behavior on a different CentOS 6.x
> >> kernel?
> >> 
> >> Linux xxxxxx 2.6.32-279.5.2.el6.x86_64 #1 SMP Fri Aug 24 01:07:11 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux
> >
> > Because the log hang bug hadn't been fixed in that kernel.
> 
> This actually gives me some optimism that RHEL might introduce a new
> kernel sooner rather than later--that kernel wasn't all that long ago,
> and there have been quite a few (mostly unrelated) patches since.

Doubt it. Given that I'm the RHEL XFS maintainer....

> (That's why I was so surprised--I'm not used to the RHEL kernel moving
> so quickly!)

What, you're not used to having serious bugs fixed quickly? That's
why people pay for RHEL...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
