Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAQMnrQB017274 for <xfs@oss.sgi.com>; Wed, 26 Nov 2008 16:49:53 -0600
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4A4CA160748C
	for <xfs@oss.sgi.com>; Wed, 26 Nov 2008 14:49:51 -0800 (PST)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	mAIArUAoW5ooU9lH for <xfs@oss.sgi.com>;
	Wed, 26 Nov 2008 14:49:51 -0800 (PST)
Date: Thu, 27 Nov 2008 08:43:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Extreme slowness with xfs [WAS: Re: Slowness with new pc]
Message-ID: <20081126214308.GJ6291@disturbed>
References: <1226760254.5089.11.camel@chevrolet> <492B5684.2080107@sandeen.net>
	<1227647010.7992.34.camel@chevrolet>
	<200811261330.27328.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200811261330.27328.Martin@lichtvoll.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: xfs@oss.sgi.com

On Wed, Nov 26, 2008 at 01:30:26PM +0100, Martin Steigerwald wrote:
> I wonder whether XFS performance with barriers enabled can be improved? 

Not really. It requires fundamentally altering the way the
transaction system works, and that's no easy task. I have a few
things that I'm looking at, but nothing that would be considered
short-term....

> And whether XFS with disabled write cache (via hdparm) but without 
> barriers might even be *faster* than XFS with barriers... One thing to 
> test eventually.

Yes, it often is with SATA drives - it depends on the quality of
the NCQ implementation in the drive. For SCSI drives, no write
cache or barriers is almost always faster than using WC+barriers.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
