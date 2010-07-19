Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6J0S0Yt174990 for <xfs@oss.sgi.com>; Sun, 18 Jul 2010 19:28:01 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 187E715F1BD8
	for <xfs@oss.sgi.com>; Sun, 18 Jul 2010 17:30:58 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	z305t4j2mBJIqudM for <xfs@oss.sgi.com>;
	Sun, 18 Jul 2010 17:30:58 -0700 (PDT)
Date: Mon, 19 Jul 2010 10:30:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/5] xfs: reclaim bug fixes
Message-ID: <20100719003056.GG23223@dastard>
References: <1279154300-2018-1-git-send-email-david@fromorbit.com>
	<20100716052329.GF29915@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100716052329.GF29915@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, Jul 16, 2010 at 01:23:29AM -0400, Christoph Hellwig wrote:
> On Thu, Jul 15, 2010 at 10:38:15AM +1000, Dave Chinner wrote:
> > The following patches fix excessive CPU consumption during inode
> > cache shrinking when filesystems have lots of allocation groups as
> > well as prevent a couple of lockdep reports that were found during
> > testing. Also included is a fix for a reclaim recursion deadlock
> > when allocating memory during inode initialisation.
> 
> Wa the overlap of patch 1 with the for-2.6.35 shrinker series
> intentional?  In addition to patch 1 patches 3 to 5 are also for-2.6.35
> material in my opinion.

I realised that we'd get a messy, messy conflict if I separated the
per-ag tree reclaim tracking from the shrinker patchset, so I
included it in that one as it was also part of fixing reported
XFS shrinker regressions to avoid such conflicts.

But yes, i think that all the lockdep fixes are probably 2.6.35
material.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
