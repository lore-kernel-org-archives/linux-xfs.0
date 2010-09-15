Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8FDEcwk189318 for <xfs@oss.sgi.com>; Wed, 15 Sep 2010 08:14:39 -0500
Received: from kuber.nabble.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 15AD915E4DF5
	for <xfs@oss.sgi.com>; Wed, 15 Sep 2010 06:27:17 -0700 (PDT)
Received: from kuber.nabble.com (kuber.nabble.com [216.139.236.158]) by
	cuda.sgi.com with ESMTP id KwwvWGPcjbDFVSBz for
	<xfs@oss.sgi.com>; Wed, 15 Sep 2010 06:27:17 -0700 (PDT)
Received: from isper.nabble.com ([192.168.236.156])
	by kuber.nabble.com with esmtp (Exim 4.63)
	(envelope-from <lists@nabble.com>) id 1Ovrpe-0004ZW-EE
	for xfs@oss.sgi.com; Wed, 15 Sep 2010 06:15:26 -0700
Message-ID: <29718375.post@talk.nabble.com>
Date: Wed, 15 Sep 2010 06:15:26 -0700 (PDT)
From: pbrunnen <PBrunnen@bccnetworks.net>
Subject: Re: Now: Debian issues, WAS: XFS Filesystem not mounting
In-Reply-To: <4C9042D7.90001@hardwarefreak.com>
MIME-Version: 1.0
References: <29704010.post@talk.nabble.com> <20100914012151.GF411@dastard>
	<29705139.post@talk.nabble.com> <201009140740.14482@zmi.at>
	<20100914082504.4109712d@galadriel.home>
	<29708085.post@talk.nabble.com> <201009141603.24754@zmi.at>
	<4C8F9E29.2000803@hardwarefreak.com>
	<29710491.post@talk.nabble.com>
	<4C8FB8D6.6080603@hardwarefreak.com>
	<20100914223201.21c3bd0f@galadriel.home>
	<29714426.post@talk.nabble.com> <4C9042D7.90001@hardwarefreak.com>
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
To: xfs@oss.sgi.com



Stan Hoeppner wrote:
> 
> A single socket 12-core 2 GHz Opteron 6100 series on a SuperMicro mobo
> with quad DDR3 memory channels w/32 GB RAM, sitting on your desktop,
> would simply run circles around that old 2 rack 32P O2K system, probably
> 5 to 1 or greater in parallel linpack--for less than $2k.
> 
:-)  Now... not then.  We often forget how much has changed even over just
the last 10 years.




Dave Chinner wrote:
> 
> You must be doing it wrong, then.
> 
> # apt-cache search "^firmware-"
> ....
> 
> Pick the packages for your hardware, or just install the lot (which
> is what I normally do) and remake your initramfs. The firmware
> packages have the correct firmware versions the distro kernels
> expect.
> 
Hi Dave.

I have to agree with Stan...  I know about the firmware packages... but for
both the Broadcom BXN2 nics and the Q-Logic QLA23xx HBAs I have never gotten
the firmware bundle to work properly.  I always ended up with a 5min boot
delay as the modules couldn't find the firmware files.  So I build my own
modules with the blobs inside and life is good...

Thanks.  -Cheers, Peter.
-- 
View this message in context: http://old.nabble.com/XFS-Filesystem-not-mounting-tp29704010p29718375.html
Sent from the Xfs - General mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
