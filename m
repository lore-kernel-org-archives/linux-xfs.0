Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EAB937F50
	for <xfs@oss.sgi.com>; Thu, 31 Jan 2013 00:13:34 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AB83E304059
	for <xfs@oss.sgi.com>; Wed, 30 Jan 2013 22:13:31 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	yjYl7lFWDtAqeKAa for <xfs@oss.sgi.com>;
	Wed, 30 Jan 2013 22:13:29 -0800 (PST)
Date: Thu, 31 Jan 2013 17:13:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] xfs: add agskip=value mount option
Message-ID: <20130131061321.GI32297@disturbed.disaster>
References: <20130129153914.801475275@sgi.com>
	<20130129153914.976867239@sgi.com>
	<20130130010430.GE7255@disturbed.disaster>
	<20130130233203.GP27055@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130130233203.GP27055@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: rjohnston@sgi.com, xfs@oss.sgi.com

On Wed, Jan 30, 2013 at 05:32:03PM -0600, Ben Myers wrote:
> Hey Dave,
> 
> On Wed, Jan 30, 2013 at 12:04:30PM +1100, Dave Chinner wrote:
> > On Tue, Jan 29, 2013 at 09:39:15AM -0600, rjohnston@sgi.com wrote:
> > > The agskip mount option specifies  the allocation group, (AG) for a new
> > > file, relative to the start of the last created file. agskip has the
> > > opposite effect of the rotorstep  system tunable  parameter.   Each
> > > new  file  to  be placed in the location lastAG + agskipValue,
> > > where lastAG is the allocation group of the last created file.
> > > 
> > > For example, agskip=3 means each new file will be  allocated  three  AGs  away
> > > from the starting AG of the most recently created file.
> >
> > Overall, I'm wondering if this is the right way to approach this
> > problem.
> 
> We'll have to make sure we all understand the problem we're trying to solve
> with this before going too far.

I'm in no doubt about what it is for - I know the exact history of
this patch and exactly what problems it was designed to solve
because....

> > It only really works correctly (in terms of distribution of
> > files/metadata) for fixed volume sizes (i.e. homogenous layouts) -
> > the common case where a skip is useful is after growing a filesystem
> > onto a new volume. It's rare that the new volume is the same as the
> > existing volumes, so it's hard to set a skip value that reliably
> > alternates between old and new volumes.
> 
> Based upon what I've read so far on the internal bug when this was introduced,
> this is more about being able to utilize all allocation groups in a filesystem
> with many concats.

... I was still at SGI when that bug was raised and the ag_skip
patch was written for the "Enhanced XFS" module in the NAS product
SGI was selling at the time. It was written as a quick stopgap by
the NAS product engineers to counter the problems being seen on that
product due to the nature of the "concat of stripes" storage
configuration that product used.

It was never was proposed as an upstream solution because I NACKed
it internally.  Indeed, at the time I was already well down the path
of fixing the problem in XFS in a much more capable way. i.e.  this
stuff:

http://oss.sgi.com/archives/xfs/2009-02/msg00250.html
http://oss.sgi.com/archives/xfs/2009-02/msg00253.html

And that was planned to replace the agskip hack in the next NAS
product release. Unfortunately, once I left SGI nobody picked up the
work I was doing and "Enhanced XFS" turned into a zombie.  Indeed,
agskip was posted back here in 2009 as part of the same code dump as
the above patches when the XFS group in Melbourne was let go:

http://oss.sgi.com/archives/xfs/2009-02/msg00252.html

There's a bit of history to this patch ;)

> It's not so much related to balance after growing a
> filesystem (which is another interesting problem).  The info should be added to
> this series and be reposted.

Actually, that was one of the problems the patch solved on the NAS
product. It was a secondary problem as growing wasn't a common
operation, but it was definitely a concern....

> > We talked about this allocation distribution problem last march when
> > we met at LSF, and I thought we agreed that pushing
> > agskip/agrotorstep mount options upstream was not the way we were
> > going to solve this problem after I outlined how I planned to solve
> > this problem.
> 
> If we can come up with something better, that's great.  But AFAICT the problem
> still needs to be addressed.  This is just one way to do it.

I'm not saynig that it doesn't need to be addressed. I'm just saying
the sam ething I said 5 years ago: there's no point pushing it into
mainline when far more comprehensive solution is just around the
corner....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
