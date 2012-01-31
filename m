Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0VKoJkE099704 for <xfs@oss.sgi.com>; Tue, 31 Jan 2012 14:50:19 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	IB3CPQNWbI9fTQmW for <xfs@oss.sgi.com>;
	Tue, 31 Jan 2012 12:50:16 -0800 (PST)
Date: Wed, 1 Feb 2012 07:50:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: File system remain unresponsive until the system is rebooted.
Message-ID: <20120131205014.GM9090@dastard>
References: <CANs4eSBWLc4HxAbPZ8kOVOdJ7RKiA+-ai3Q2J+FAyuzHtUqfdg@mail.gmail.com>
	<20120131013124.GE9090@dastard>
	<CANs4eSBgmvJCR7vfFa1W5h8tUYFQi=LRPWDPQ1exB29D1o_RjA@mail.gmail.com>
	<4F27AE92.9060003@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F27AE92.9060003@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

On Tue, Jan 31, 2012 at 03:04:18AM -0600, Stan Hoeppner wrote:
> On 1/30/2012 11:04 PM, Supratik Goswami wrote:
> > We are using Amazon EC2 instances.
> 
>                ^^^^^^^^^^
> I'd have never thought I would see those words on this list, except
> maybe as a joke, or as an example of one of the the worst possible
> platforms for XFS.

I don't agree with you there. If the workload works best on XFs, it
doesn't matter what the underlying storage device is. e.g. if it's a
fsync heavy workload, it will still perform better on XFS on EC2
than btrfs on EC2...

> I wish EC2 had been asked about during the QA session after Dave's
> presentation.  I'm guessing some laughter would have been involved. ;)

You'd be wrong about that. There are as many good uses of cloud
services as there are bad ones, yet the same decisions about storage
need to be made even when services are remotely hosted....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
