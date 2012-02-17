Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1H4ePtH051845 for <xfs@oss.sgi.com>; Thu, 16 Feb 2012 22:40:25 -0600
Received: from kaylee.flamingspork.com (kaylee.flamingspork.com
	[74.207.245.61]) by cuda.sgi.com with ESMTP id 9dmwF67B61MMr69e
	for <xfs@oss.sgi.com>; Thu, 16 Feb 2012 20:40:24 -0800 (PST)
From: Stewart Smith <stewart@flamingspork.com>
Subject: Re: Transactional XFS?
In-Reply-To: <20120216064230.GZ14132@dastard>
References: <CAFLt3phWcaQ4K3OPSVUkyN0BXqh+jQgQbeA59Oav23aOPLYMYw@mail.gmail.com>
	<20120216002237.GW14132@dastard> <87k43nzj5e.fsf@flamingspork.com>
	<20120216014338.GX14132@dastard> <87ehtvz6bp.fsf@flamingspork.com>
	<20120216064230.GZ14132@dastard>
Date: Fri, 17 Feb 2012 15:40:21 +1100
Message-ID: <87vcn6xebu.fsf@flamingspork.com>
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

On Thu, 16 Feb 2012 17:42:30 +1100, Dave Chinner <david@fromorbit.com> wrote:
> > The worst part is working out the semantics as to not break existing apps
> > (without completely sacrificing concurrency).
> 
> That doesn't seem like a show stopper to me.
> 
> The part that I see is that it is basically impossible to do
> arbitrarily large transactions in a filesystem - they are limited by
> the size of the log. e.g. you can't have a user transaction that
> writes more data or modifies more data than the log allows in a
> single checkpoint/transaction. e.g. you can't just overwrite a 100MB
> file in a transaction and expect it to work. It might work if you've
> got a 2GB log, but if you've only got a 10MB log, then that
> overwrite transaction is full of fail.

We have this problem too. none of the solutions are particularly pretty,
and certainly do have a performance impact.

> It's issues that like that that doom the generic usefulness of
> userspace controlled filesystem transactions as part of the normal
> filesystem operation. If you need this sort of functionality, it has
> to be layered over the top of the filesystem to avoid filesystem
> atomicity limitations. i.e. another layer of tracking and
> journalling. And at that point you're talking about implementing a
> database on top of the filesystem in the filesystem....

As I said... it's tricky to solve all the problems :)
-- 
Stewart Smith

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
