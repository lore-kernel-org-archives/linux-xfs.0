Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1G5c6fb229272 for <xfs@oss.sgi.com>; Wed, 15 Feb 2012 23:38:06 -0600
Received: from kaylee.flamingspork.com (kaylee.flamingspork.com
	[74.207.245.61]) by cuda.sgi.com with ESMTP id 4UE39fnC91ibeU9D
	for <xfs@oss.sgi.com>; Wed, 15 Feb 2012 21:38:05 -0800 (PST)
From: Stewart Smith <stewart@flamingspork.com>
Subject: Re: Transactional XFS?
In-Reply-To: <20120216014338.GX14132@dastard>
References: <CAFLt3phWcaQ4K3OPSVUkyN0BXqh+jQgQbeA59Oav23aOPLYMYw@mail.gmail.com>
	<20120216002237.GW14132@dastard> <87k43nzj5e.fsf@flamingspork.com>
	<20120216014338.GX14132@dastard>
Date: Thu, 16 Feb 2012 16:38:02 +1100
Message-ID: <87ehtvz6bp.fsf@flamingspork.com>
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: Grozdan <neutrino8@gmail.com>, xfs@oss.sgi.com

On Thu, 16 Feb 2012 12:43:38 +1100, Dave Chinner <david@fromorbit.com> wrote:
> Oh, so making some set of random user changes to random user data
> have ACID properties? That's what databases are for, isn't it?  :P

Yep :)

> I dont see us implementing anything like this in XFS anytime soon.
> We are looking to add transaction grouping so that we can make
> things that currently require multiple transactions (e.g. create a
> file, add a default ACL) atomic, but I don't have any plans to
> open the can of worms that is userspace controlled transactions any
> time soon.

The worst part is working out the semantics as to not break existing apps
(without completely sacrificing concurrency).

> We already have this upgrade rollback functionality in development
> with none of that complexity - it uses filesystem snapshots so is
> effectively filesystem independent and already works with yum and
> btrfs. You don't need any special application support for this -
> rollback from a failed upgrade is as simple as a reboot.

The downside being you also roll back your logs and any other changes
made during that time. On the whole though, it's probably sufficient.

> Sure, Microsoft have been trying to make their filesystem a database
> for years. It's theoretically possible, but in practice they've
> fallen short in every attempt in the past 15 years.

err... try 20 years :)

It's funny in a way, sqlite succeeds at effectively doing this for an
awful large number of applications.

-- 
Stewart Smith

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
