Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAU4mqYj031026 for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 22:48:53 -0600
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A80CE13EFA57
	for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 20:50:34 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id WjwC4DiqXXtP3Hke
	for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 20:50:34 -0800 (PST)
Message-ID: <4CF48299.2030204@hardwarefreak.com>
Date: Mon, 29 Nov 2010 22:50:33 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS: performance
References: <AANLkTi=u8dX0ehPN3Rv3FQ+84htY3AYEv0eboGgC7_qi@mail.gmail.com>
	<20101129001112.GA28672@dastard>
	<AANLkTikom6jpkuZquTfinGpaqz4Gp0y8niYN7yWQgmzj@mail.gmail.com>
	<20101129015937.GB28672@dastard>
	<AANLkTikw086Z_66cz_U-EdFQx14TXP6XmiG-KyLN4BLo@mail.gmail.com>
	<AANLkTi=-y0v4MzyU+qWPmvazouDu0N3gqSvVTU1z4Gke@mail.gmail.com>
	<4CF33D0F.6080404@hardwarefreak.com>
	<20101130042913.GB3556@dastard>
In-Reply-To: <20101130042913.GB3556@dastard>
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
Cc: xfs@oss.sgi.com

Dave Chinner put forth on 11/29/2010 10:29 PM:
> On Sun, Nov 28, 2010 at 11:41:35PM -0600, Stan Hoeppner wrote:
>> Yclept Nemo put forth on 11/28/2010 9:57 PM:
>>> You mention an eight-core machine (8c?). Since I operate a dual-core
>>> system, would it make sense to increase my AG count slightly, to five
>>> or six?
>>
>> Dave didn't mention the disk configuration of his "workstation".  I'm
>> guessing he's got a local RAID setup with 8-16 drives.
> 
> 2 SSDs in RAID0.

>From an IOPs and throughput perspective, very similar to my guess.
Curious, are those Intel, OCZ, or other SSDs?  Which model,
specifically?  Benchmark data?  I ask as all the results I find on the
web for SSDs are from Windows 7 machines. :(  I like to see some Linux
results.

>> AG count has a
>> direct relationship to the storage hardware, not the number of CPUs
>> (cores) in the system.
> 
> Actually, I used 16 AGs because it's twice the number of CPU cores
> and I want to make sure that CPU parallel workloads (e.g. make -j 8)
> don't serialise on AG locks during allocation. IOWs, I laid it out
> that way precisely because of the number of CPUs in the system...

And that makes perfect sense, assuming you have a sufficiently speedy
storage device, which you do.

> And to point out the not-so-obvious, this is the _default layout_
> that mkfs.xfs in the debian squeeze installer came up with. IOWs,
> mkfs.xfs did exactly what I wanted without me having to tweak
> _anything_.

Forgive me for I've not looked at the code.  How exactly does mkfs.xfs
determine the AG count?  If you'd had a single 7.2k SATA drive instead
of 2 RAID0 SSDs, would it have still given you 16 AGs?  If so, I'd say
that's a bug.

>> If you have a 24 core system (2x Magny Cours)
>> and a single disk, creating an FS with 24 AGs will give you nothing, and
>> may actually impede performance due to all the extra head seeking across
>> those 24 AGs.
> 
> In that case, you are right. Single spindle SRDs go backwards in
> performance pretty quickly once you go over 4 AGs...

That was the point I was making originally.  AG count should be balanced
between storage device performance and number of cores, not strictly one
or the other.  True?  How does mkfs.xfs strike that balance?  Or does
it, if using defaults?

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
