Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8OAn2Uk132464 for <xfs@oss.sgi.com>; Mon, 24 Sep 2012 05:49:02 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	oUUdWpAbzHmEu6Lh for <xfs@oss.sgi.com>;
	Mon, 24 Sep 2012 03:50:17 -0700 (PDT)
Date: Mon, 24 Sep 2012 20:50:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xlog_space_left: head behind tail ?
Message-ID: <20120924105000.GI20960@dastard>
References: <CAJzjPKm+g9g7qQrvQr+Jy2Gjbj5NZpRY2LyfMQQCi519uqGx=g@mail.gmail.com>
	<20120924072600.GE20960@dastard>
	<CAJzjPK=cvXZKdxhPeCjNO0QCGM7KRqJH8gy6B=EHH_xC-UkwkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJzjPK=cvXZKdxhPeCjNO0QCGM7KRqJH8gy6B=EHH_xC-UkwkQ@mail.gmail.com>
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
To: Gregory Machin <gdm@linuxpro.co.za>
Cc: xfs@oss.sgi.com

[ please leave the mailing list CC on responses. thanks. ]

[Fixed up the top posting mess, too]

On Mon, Sep 24, 2012 at 09:29:04PM +1200, Gregory Machin wrote:
> On Mon, Sep 24, 2012 at 7:26 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Mon, Sep 24, 2012 at 04:49:43PM +1200, Gregory Machin wrote:
> >> Hi.
> >>
> >> Since I started using Acronis backup software I have the following in my logs :
> >
> > What kernel?
>
> The Kernel : Linux nzhmlfpr04 2.6.32-279.5.2.el6.x86_64 #1 SMP Fri Aug
> 24 01:07:11 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux
> OS CentOS : 6.3

So, it doesn't have the fix. You'll have to upgrade to 3.4 or
backport the patch yourself.

> >> Sep 22 20:17:54 nzhmlfpr04 kernel: XFS (dm-3): xlog_space_left: head behind tail
> >                                           ^^^^
> >> Sep 22 20:17:54 nzhmlfpr04 kernel:  tail_cycle = 125, tail_bytes = 489472
> >> Sep 22 20:17:54 nzhmlfpr04 kernel:  GH   cycle = 125, GH   bytes = 468080
> >> Sep 22 20:19:07 nzhmlfpr04 kernel: XFS (snumbd11d): Corruption
> >                                           ^^^^^^^^^
> >> detected. Unmount and run xfs_repair
> >
> > Note the different device names the errors are for? So the log space
> > warnings are from different filesystems to the one that corruption
> > has been found on. IOWs, unrelated.
>
> There are 4 xfs filesystems mounted on that machine.

According to the logs, there are at least 5: dm-{2,3,4,5} and
snumbd11d.

> >> and what else
> >> could have cause the 2nd ?
> >
> > Don't know. There's no stack trace in the error message, so I don't
> > even know where it came from. have you modified the xfs_error_level
> > sysctl to turn off verbose reporting?
>
> sysctl.conf is default for CentOS.

So there's an error that isn't reporting a stack by default. That
means it is probably a directory read that is triggering it -
knowing what errors xfs_repair reported would help narrow it down.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
