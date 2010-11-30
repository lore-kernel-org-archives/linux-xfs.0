Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAU4RaNw025970 for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 22:27:37 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5A75E13FCABB
	for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 20:29:16 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	hMIetAXRHDsdZwIg for <xfs@oss.sgi.com>;
	Mon, 29 Nov 2010 20:29:16 -0800 (PST)
Date: Tue, 30 Nov 2010 15:29:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS: performance
Message-ID: <20101130042913.GB3556@dastard>
References: <AANLkTi=u8dX0ehPN3Rv3FQ+84htY3AYEv0eboGgC7_qi@mail.gmail.com>
	<20101129001112.GA28672@dastard>
	<AANLkTikom6jpkuZquTfinGpaqz4Gp0y8niYN7yWQgmzj@mail.gmail.com>
	<20101129015937.GB28672@dastard>
	<AANLkTikw086Z_66cz_U-EdFQx14TXP6XmiG-KyLN4BLo@mail.gmail.com>
	<AANLkTi=-y0v4MzyU+qWPmvazouDu0N3gqSvVTU1z4Gke@mail.gmail.com>
	<4CF33D0F.6080404@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4CF33D0F.6080404@hardwarefreak.com>
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

On Sun, Nov 28, 2010 at 11:41:35PM -0600, Stan Hoeppner wrote:
> Yclept Nemo put forth on 11/28/2010 9:57 PM:
> > You mention an eight-core machine (8c?). Since I operate a dual-core
> > system, would it make sense to increase my AG count slightly, to five
> > or six?
> 
> Dave didn't mention the disk configuration of his "workstation".  I'm
> guessing he's got a local RAID setup with 8-16 drives.

2 SSDs in RAID0.

> AG count has a
> direct relationship to the storage hardware, not the number of CPUs
> (cores) in the system.

Actually, I used 16 AGs because it's twice the number of CPU cores
and I want to make sure that CPU parallel workloads (e.g. make -j 8)
don't serialise on AG locks during allocation. IOWs, I laid it out
that way precisely because of the number of CPUs in the system...

And to point out the not-so-obvious, this is the _default layout_
that mkfs.xfs in the debian squeeze installer came up with. IOWs,
mkfs.xfs did exactly what I wanted without me having to tweak
_anything_.

> If you have a 24 core system (2x Magny Cours)
> and a single disk, creating an FS with 24 AGs will give you nothing, and
> may actually impede performance due to all the extra head seeking across
> those 24 AGs.

In that case, you are right. Single spindle SRDs go backwards in
performance pretty quickly once you go over 4 AGs...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
