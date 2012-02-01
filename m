Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q11CWE0W248089 for <xfs@OSS.SGI.com>; Wed, 1 Feb 2012 06:32:15 -0600
Received: from woodbine.london.02.net (woodbine.london.02.net
	[87.194.255.145]) by cuda.sgi.com with ESMTP id
	l51DIt87SOM4UjEf for <xfs@OSS.SGI.com>;
	Wed, 01 Feb 2012 04:32:12 -0800 (PST)
Received: from ty.sabi.co.UK (87.194.99.40) by woodbine.london.02.net (8.5.140)
	id 4EEB647400CE5CDB for xfs@OSS.SGI.com; Wed, 1 Feb 2012 12:32:11 +0000
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.71 #1) id 1RsYY0-00086q-S1
	for <xfs@OSS.SGI.com>; Wed, 01 Feb 2012 11:40:20 +0000
MIME-Version: 1.0
Message-ID: <20265.9379.139218.148520@tree.ty.sabi.co.UK>
Date: Wed, 1 Feb 2012 11:40:19 +0000
Subject: Re: File system remain unresponsive until the system is rebooted.
In-Reply-To: <4F288561.5040803@hardwarefreak.com>
References: <CANs4eSBWLc4HxAbPZ8kOVOdJ7RKiA+-ai3Q2J+FAyuzHtUqfdg@mail.gmail.com>
	<20120131013124.GE9090@dastard>
	<CANs4eSBgmvJCR7vfFa1W5h8tUYFQi=LRPWDPQ1exB29D1o_RjA@mail.gmail.com>
	<4F27AE92.9060003@hardwarefreak.com>
	<20120131205014.GM9090@dastard>
	<4F288561.5040803@hardwarefreak.com>
From: pg_xf2@xf2.to.sabi.co.UK (Peter Grandi)
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
To: Linux fs XFS <xfs@oss.sgi.com>

[ ... ]

>>> We are using Amazon EC2 instances.

>>> [ ... ]  one of the the worst possible platforms for XFS.

>> I don't agree with you there. If the workload works best on
>> XFs, it doesn't matter what the underlying storage device is.
>> e.g. if it's a fsync heavy workload, it will still perform
>> better on XFS on EC2 than btrfs on EC2...

There are special cases, but =ABfsync heavy=BB is a bit of bad
example.

In general file system designs are not at all independent of the
expected storage platform, and some designs are far better than
others for specific storage platforms, and viceversa. This goes
all the way back to the 4BSD filesystem being specifically
optimized for rotational latency.

[ ... ]

>> You'd be wrong about that. There are as many good uses of
>> cloud services as there are bad ones,

VMs are not "cloud" services, those are more like remotely
hosted services, used via SOAP/REST. VMs are more like
colocation on the cheap.

>> yet the same decisions about storage need to be made even
>> when services are remotely hosted....

The basic problem with VM platforms is that they have completely
different latency (and somewhat different bandwidth) and
scheduling characteristics from "real" hardware, in particular
the relative costs of several operations are very different than
on "real" hardware, and the design tradeoffs that are good for
"real" hardware may not be relevant or may even be bad for VMs.

In addition VM "disks" can be implemented in crazy ways, like
with sparse files, and those impact severely achievable
performance levels.

> [ ... ] workloads that would require XFS, or benefit most from
> it, are probably going to need more guarantees WRT bandwidth
> and IOPS being available consistently, vs sharing said
> resources with other systems in the cloud infrastructure.

This is almost there, but =ABconsistently=BB is a bit of an
understatement. It is not just that in VMs resources are
shared and subject to externally induced loads.

What matters is that the storage layer performance envelope have
roughly the same tradeoffs as those for which a certain design
has been aimed at. Even differently shaped hardware, like flash
SSD, can have very different performance envelopes than rotating
disks, or sets of rotating disks. A VM running on its own on
a certain platform still has different latencies and tradeoffs
than the underlying platform.

> Additionally, you have driven the point home many times WRT
> tuning XFS to the underlying hardware, specifically stripe
> alignment.

That as usual only matters for RMW-oriented storage layers, and
we don't really know what storage layer EC2 uses (hopefully not
one with RMW problems as parity RAID is known to be quite ill
suited to VM disks).

[ ... ]

> [ ... ] EC2 is probably bad for the typical workloads where
> XFS best flexes its muscles.

That's probably a good point but not quite the apposite one
here.

In the case raised by the OP, he had a large delay and "forgot"
to say he was running the system under layers (of unknown
structure) of virtualization.

In that case the latency (and bandwidth) profiles of both the
computing and the storage platforms can be very different from
those XFS has been aimed at, and I would not be surprised by
starvation or locking problems. Eventually DaveC pointed out a
known locking one during 'growfs', so not dependent on the
latency profile of the platform.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
