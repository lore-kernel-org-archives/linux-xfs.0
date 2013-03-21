Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B096F7CBF
	for <xfs@oss.sgi.com>; Wed, 20 Mar 2013 20:01:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9CE76304048
	for <xfs@oss.sgi.com>; Wed, 20 Mar 2013 18:01:55 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	9worl2nN0xctq3LB for <xfs@oss.sgi.com>;
	Wed, 20 Mar 2013 18:01:53 -0700 (PDT)
Date: Thu, 21 Mar 2013 12:01:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Crash with 3.8.3 and TuxOnIce
Message-ID: <20130321010149.GF17758@dastard>
References: <CAEDdjHeo3Giv3Y8pLfYHSbJi07_dv7ywzinCSSkxUwBQe-1fsw@mail.gmail.com>
	<20130320004405.GC17758@dastard>
	<CAEDdjHc139n-FFrW34FLyfKsqFHBy0_LVcVT24aLyCpb4DC9dA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAEDdjHc139n-FFrW34FLyfKsqFHBy0_LVcVT24aLyCpb4DC9dA@mail.gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Pedro Ribeiro <pedrib@gmail.com>
Cc: xfs@oss.sgi.com

On Wed, Mar 20, 2013 at 06:01:35PM +0000, Pedro Ribeiro wrote:
> Thanks for the answer Dave.
> 
> Yes I would definitely say it's a ToI bug that perhaps has been dormant so
> far. Unfortunately the ToI developer is very busy at the moment, so I will
> have to debug and fix it myself.
> This problem did not occur with 3.7 and the ToI code did not change.
> 
> Do you have any idea where I can start looking for the XFS change in 3.8
> that triggered this behaviour in ToI? Or maybe it was a VFS change?

It's almost certainly an XFS change that triggered it, but it
indicates (once again) that the hibernate code is simply not
quiescing filesystems properly (i.e. by freezing them). The work
that caused this problem is stopped by the filesystem when it
is frozen, and started again when it is thawed...

> PS: the email definitely bounced back, most likely because imageshack is
> blocked on the sgi server:
> 
> Technical details of permanent failure:
> Google tried to deliver your message, but it was rejected by the server for
> the recipient domain oss.sgi.com by cuda-allmx.sgi.com. [192.48.176.16].
> 
> The error that the other server returned was:
> 554 rejecting banned content

IOWs, a stupid spam filter.

I'll see if I can get this fixed.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
