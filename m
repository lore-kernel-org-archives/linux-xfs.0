Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAU7nVW2064883 for <xfs@oss.sgi.com>; Tue, 30 Nov 2010 01:49:31 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0258B1B4DB0
	for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 23:51:12 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	hFEF6VCWct2BT9JK for <xfs@oss.sgi.com>;
	Mon, 29 Nov 2010 23:51:12 -0800 (PST)
Date: Tue, 30 Nov 2010 18:51:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS: performance
Message-ID: <20101130075109.GN13830@dastard>
References: <AANLkTi=u8dX0ehPN3Rv3FQ+84htY3AYEv0eboGgC7_qi@mail.gmail.com>
	<20101129001112.GA28672@dastard>
	<AANLkTikom6jpkuZquTfinGpaqz4Gp0y8niYN7yWQgmzj@mail.gmail.com>
	<20101129015937.GB28672@dastard>
	<AANLkTikw086Z_66cz_U-EdFQx14TXP6XmiG-KyLN4BLo@mail.gmail.com>
	<AANLkTi=-y0v4MzyU+qWPmvazouDu0N3gqSvVTU1z4Gke@mail.gmail.com>
	<4CF33D0F.6080404@hardwarefreak.com>
	<20101130042913.GB3556@dastard>
	<4CF48299.2030204@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4CF48299.2030204@hardwarefreak.com>
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

On Mon, Nov 29, 2010 at 10:50:33PM -0600, Stan Hoeppner wrote:
> Dave Chinner put forth on 11/29/2010 10:29 PM:
> > On Sun, Nov 28, 2010 at 11:41:35PM -0600, Stan Hoeppner wrote:
> >> Yclept Nemo put forth on 11/28/2010 9:57 PM:
> >>> You mention an eight-core machine (8c?). Since I operate a dual-core
> >>> system, would it make sense to increase my AG count slightly, to five
> >>> or six?
> >>
> >> Dave didn't mention the disk configuration of his "workstation".  I'm
> >> guessing he's got a local RAID setup with 8-16 drives.
> > 
> > 2 SSDs in RAID0.
> 
> From an IOPs and throughput perspective, very similar to my guess.
> Curious, are those Intel, OCZ, or other SSDs?  Which model,
> specifically?  Benchmark data?  I ask as all the results I find on the
> web for SSDs are from Windows 7 machines. :(  I like to see some Linux
> results.

Cheap as it gets 120GB Sandforce 1200 drives. In RAID0, I'm getting about
450MB/s sequential write, a little more for read. I'm seeing up to
12-14k random 4k writes per drive through XFS. Other than that I
didn't bother with any more benchmarks because it was clearly Fast
Enough.

> > And to point out the not-so-obvious, this is the _default layout_
> > that mkfs.xfs in the debian squeeze installer came up with. IOWs,
> > mkfs.xfs did exactly what I wanted without me having to tweak
> > _anything_.
> 
> Forgive me for I've not looked at the code.  How exactly does mkfs.xfs
> determine the AG count?  If you'd had a single 7.2k SATA drive instead
> of 2 RAID0 SSDs, would it have still given you 16 AGs?  If so, I'd say
> that's a bug.

No, it detected the RAID configuration. 16 AGs is the default for a
RAID device, 4 AGs is used if RAID is not detected.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
