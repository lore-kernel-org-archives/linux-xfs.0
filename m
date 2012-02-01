Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q11NtAq7018044 for <xfs@oss.sgi.com>; Wed, 1 Feb 2012 17:55:10 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	AHXgIJ59GJ3PsNIO for <xfs@oss.sgi.com>;
	Wed, 01 Feb 2012 15:55:08 -0800 (PST)
Date: Thu, 2 Feb 2012 10:55:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: File system remain unresponsive until the system is rebooted.
Message-ID: <20120201235501.GX9090@dastard>
References: <CANs4eSBWLc4HxAbPZ8kOVOdJ7RKiA+-ai3Q2J+FAyuzHtUqfdg@mail.gmail.com>
	<20120131013124.GE9090@dastard>
	<CANs4eSBgmvJCR7vfFa1W5h8tUYFQi=LRPWDPQ1exB29D1o_RjA@mail.gmail.com>
	<4F27AE92.9060003@hardwarefreak.com>
	<20120131205014.GM9090@dastard>
	<4F288561.5040803@hardwarefreak.com>
	<20265.9379.139218.148520@tree.ty.sabi.co.UK>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20265.9379.139218.148520@tree.ty.sabi.co.UK>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Peter Grandi <pg_xf2@xf2.to.sabi.co.UK>
Cc: Linux fs XFS <xfs@oss.sgi.com>

On Wed, Feb 01, 2012 at 11:40:19AM +0000, Peter Grandi wrote:
> [ ... ]
> =

> >>> We are using Amazon EC2 instances.
> =

> >>> [ ... ]  one of the the worst possible platforms for XFS.
> =

> >> I don't agree with you there. If the workload works best on
> >> XFs, it doesn't matter what the underlying storage device is.
> >> e.g. if it's a fsync heavy workload, it will still perform
> >> better on XFS on EC2 than btrfs on EC2...
> =

> There are special cases, but =ABfsync heavy=BB is a bit of bad
> example.

It's actually a really good example of where XFS will be better
than other filesystems.  Why? Because XFS does less log IO due to
aggregation of log writes during concurrent fsyncs. The more latency
there is on a log write, the more aggregation that occurs.  On a
platform where the IO subsystem is going to give you unpredictable
IO latencies, that's exactly what want.

Sure, it was designed to optimise spinning rust performance, but
that same design is also optimal for virtual devices with
unpredictable IO latency...

> In general file system designs are not at all independent of the
> expected storage platform, and some designs are far better than
> others for specific storage platforms, and viceversa.

Sure, but filesystems also have inherent capabilities that are
independent of the underlying storage. In these cases, the
underlying storage really doesn't matter if the filesystem can't do
what the application needs.  Allocation parallelism, CPU
parallelism, minimal concurrent fsync latency, etc are all
characteristics of filesystems that are independent of the
underlying storage. If you need those characteristics in your
remotely hosted VMs, then XFS is what you want regardless of how
much storage capability you buy for those VMs....

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
