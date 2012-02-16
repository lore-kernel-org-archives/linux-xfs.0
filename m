Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1G6gYhr234673 for <xfs@oss.sgi.com>; Thu, 16 Feb 2012 00:42:34 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	Hf0ZE5qfX2uKS80F for <xfs@oss.sgi.com>;
	Wed, 15 Feb 2012 22:42:32 -0800 (PST)
Date: Thu, 16 Feb 2012 17:42:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Transactional XFS?
Message-ID: <20120216064230.GZ14132@dastard>
References: <CAFLt3phWcaQ4K3OPSVUkyN0BXqh+jQgQbeA59Oav23aOPLYMYw@mail.gmail.com>
	<20120216002237.GW14132@dastard> <87k43nzj5e.fsf@flamingspork.com>
	<20120216014338.GX14132@dastard> <87ehtvz6bp.fsf@flamingspork.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87ehtvz6bp.fsf@flamingspork.com>
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
To: Stewart Smith <stewart@flamingspork.com>
Cc: Grozdan <neutrino8@gmail.com>, xfs@oss.sgi.com

On Thu, Feb 16, 2012 at 04:38:02PM +1100, Stewart Smith wrote:
> On Thu, 16 Feb 2012 12:43:38 +1100, Dave Chinner <david@fromorbit.com> wrote:
> > Oh, so making some set of random user changes to random user data
> > have ACID properties? That's what databases are for, isn't it?  :P
> 
> Yep :)
> 
> > I dont see us implementing anything like this in XFS anytime soon.
> > We are looking to add transaction grouping so that we can make
> > things that currently require multiple transactions (e.g. create a
> > file, add a default ACL) atomic, but I don't have any plans to
> > open the can of worms that is userspace controlled transactions any
> > time soon.
> 
> The worst part is working out the semantics as to not break existing apps
> (without completely sacrificing concurrency).

That doesn't seem like a show stopper to me.

The part that I see is that it is basically impossible to do
arbitrarily large transactions in a filesystem - they are limited by
the size of the log. e.g. you can't have a user transaction that
writes more data or modifies more data than the log allows in a
single checkpoint/transaction. e.g. you can't just overwrite a 100MB
file in a transaction and expect it to work. It might work if you've
got a 2GB log, but if you've only got a 10MB log, then that
overwrite transaction is full of fail.

It's issues that like that that doom the generic usefulness of
userspace controlled filesystem transactions as part of the normal
filesystem operation. If you need this sort of functionality, it has
to be layered over the top of the filesystem to avoid filesystem
atomicity limitations. i.e. another layer of tracking and
journalling. And at that point you're talking about implementing a
database on top of the filesystem in the filesystem....

> > We already have this upgrade rollback functionality in development
> > with none of that complexity - it uses filesystem snapshots so is
> > effectively filesystem independent and already works with yum and
> > btrfs. You don't need any special application support for this -
> > rollback from a failed upgrade is as simple as a reboot.
> 
> The downside being you also roll back your logs and any other changes
> made during that time. On the whole though, it's probably sufficient.

That, IMO, is one of the good things about it. You go back to a
pristine condition, but still have the failed upgrade image that you
can mount and debug. The logs and all the failed state is still
intact in the upgrade image, and when you are done debugging it you
can blow it away and try again....

> > Sure, Microsoft have been trying to make their filesystem a database
> > for years. It's theoretically possible, but in practice they've
> > fallen short in every attempt in the past 15 years.
> 
> err... try 20 years :)

Time gets aways from me these days ;)

> It's funny in a way, sqlite succeeds at effectively doing this for an
> awful large number of applications.

/me nods

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
