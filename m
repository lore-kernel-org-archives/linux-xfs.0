Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4L4Bx55244228 for <xfs@oss.sgi.com>; Thu, 20 May 2010 23:12:00 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8E8E7A016B8
	for <xfs@oss.sgi.com>; Thu, 20 May 2010 21:15:34 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	KKSVEb9kvHwRTVCk for <xfs@oss.sgi.com>;
	Thu, 20 May 2010 21:15:34 -0700 (PDT)
Date: Fri, 21 May 2010 14:14:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Tuning XFS for real time audio on a laptop with encrypted LVM
Message-ID: <20100521041415.GW8120@dastard>
References: <AANLkTilJD2Jfr4W97BiAlyc_7C9jLEhEzuEWSDyVKXYP@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTilJD2Jfr4W97BiAlyc_7C9jLEhEzuEWSDyVKXYP@mail.gmail.com>
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
To: Pedro Ribeiro <pedrib@gmail.com>
Cc: xfs@oss.sgi.com

On Fri, May 21, 2010 at 03:16:15AM +0100, Pedro Ribeiro wrote:
> Hi all,
> 
> I was wondering what is the best scheduler for my use case given my
> current hardware.
> 
> I have a laptop with a fast Core 2 duo at 2.26 and a nice amount of
> ram (4GB) which I use primarily for real time audio (though without a
> -rt kernel). All my partitions are XFS under LVM which itself is
> contained on a LUKS partition (encrypted with AES 128).
> 
> CFQ currently does not perform very well and causes a lot of thrashing
> and high latencies when I/O usage is high. Changing it to the noop
> scheduler solves some of the problems and makes it more responsive.
> Still performance is a bit of a let down: it takes 1m30s to unpack the
> linux-2.6.34 tarball and a massive 2m30s to rm -r.
> I have lazy-count=1, noatime, logbufs=8, logbsize=256k and a 128m log.
> 
> Is there any tunable I should mess with to solve this?

Depends if you value your data or not. If you don't care about
corruption or data loss on sudden power loss (e.g. battery runs
flat), then add nobarrier to your mount options. Otherwise, you're
close to the best performance you are going to get on that hardware
with XFS.

> And what do you
> think of my scheduler change (I haven't tested it that much to be
> honest)?

I only ever use the noop scheduler with XFS these days. CFQ has been
a steaming pile of ever changing regressions for the past 4 or 5
kernel releases, so i stopped using it. Besides, XFS is often 10-15%
faster on no-op for the same workload, anyway...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
