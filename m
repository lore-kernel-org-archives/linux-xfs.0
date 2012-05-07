Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q471e1Nn146289 for <xfs@oss.sgi.com>; Sun, 6 May 2012 20:40:01 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	BStcYXIaSU8rCe7y for <xfs@oss.sgi.com>;
	Sun, 06 May 2012 18:39:59 -0700 (PDT)
Date: Mon, 7 May 2012 11:39:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: suddenly slow writes on XFS Filesystem
Message-ID: <20120507013940.GX5091@dastard>
References: <4FA63DDA.9070707@profihost.ag>
	<201205061233.58496.Martin@lichtvoll.de>
	<4FA69CB0.8000008@hardwarefreak.com>
	<4FA6D016.6010702@profihost.ag>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FA6D016.6010702@profihost.ag>
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
To: Stefan Priebe <s.priebe@profihost.ag>
Cc: stan@hardwarefreak.com, xfs@oss.sgi.com

On Sun, May 06, 2012 at 09:25:10PM +0200, Stefan Priebe wrote:
> Am 06.05.2012 17:45, schrieb Stan Hoeppner:
> >On 5/6/2012 5:33 AM, Martin Steigerwald wrote:
> >>Am Sonntag, 6. Mai 2012 schrieb Stefan Priebe:
> >>>It is a raid 10 of 20 SATA Disks and i can only write to them with
> >>>about  700kb/s while doing random i/o. I tried vanilla Kernel 3.0.30
> >>>and 3.3.4 - no difference. Writing to another partition on another xfs
> >>>array works fine.
> >>
> >>Additionally what RAID is this? SoftRAID or some - which one? - hardware
> >>RAID controller? And what disks are used, whats the rpm of these?
> >
> >I doubt much of this stuff matters.  Stefan's filesystem is 96% full,
> >w/~200GB free.  This free space is likely heavily fragmented.  If he's
> >doing allocation in this fragmented free space I'd think that would
> >fully explain his write performance dropping off a cliff due to massive
> >head seeking.
> >
> Thanks Stan that's it. After deleting 200GB-300GB it's running fine again.
> 
> What is the general recommandation of free space?

Depends on the size of the filesystem. If you've got a 500TB
filesystem, then running at 98% full (10TB of free space) is not
going to be a big deal. But running at 98% full on a 5TB volume is a
big deal because there is relatively little freespace per AG and it
will get rapidly fragmented.

So for a 5TB volume, I' say don't run sustained operations at over
90% full. Going above this temporarily won't be a problem, but
staying at >95% full will definitely cause accelerated aging of the
filesystem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
