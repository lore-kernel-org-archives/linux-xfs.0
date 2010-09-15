Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8F2rtHN161184 for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 21:53:55 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3CF411E66EC2
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 19:54:44 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id j0MhkZEs0Q3D8Sap
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 19:54:44 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id C16946C04C
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 21:54:43 -0500 (CDT)
Message-ID: <4C903573.3090502@hardwarefreak.com>
Date: Tue, 14 Sep 2010 21:54:43 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Now: Debian issues, WAS: XFS Filesystem not mounting
References: <29704010.post@talk.nabble.com>
	<20100914012151.GF411@dastard>	<29705139.post@talk.nabble.com>
	<201009140740.14482@zmi.at>	<20100914082504.4109712d@galadriel.home>	<29708085.post@talk.nabble.com>
	<201009141603.24754@zmi.at>	<4C8F9E29.2000803@hardwarefreak.com>	<29710491.post@talk.nabble.com>	<4C8FB8D6.6080603@hardwarefreak.com>
	<20100915004431.GM15695@dastard>
In-Reply-To: <20100915004431.GM15695@dastard>
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

Dave Chinner put forth on 9/14/2010 7:44 PM:

> You must be doing it wrong, then.
> 
> # apt-cache search "^firmware-"
> ....
> 
> Pick the packages for your hardware, or just install the lot (which
> is what I normally do) and remake your initramfs. The firmware
> packages have the correct firmware versions the distro kernels
> expect.

IIRC it's a bit more complex than this Dave, unfortunately.  The
firmware issues in Debian almost always revolve around NICs and
free/non-free blobs.  The most recent example was the RTL8111/8168 blob
relating to the 2.6.32-trunk kernel, IIRC.

People upgraded their Debian kernels and their NICs didn't work
afterward, because the Debian team had changed the blob from free to
non-free.  Non-free blobs aren't installed automatically, so as soon as
they rebooted after installing the kernel image and initrd, they had no
network access.  If one didn't already have the firmware files on the
machine, many didn't IIRC, there was no way to grab them from the
mirrors as the NIC was offline--instant catch 22.

This caused one heck of a row on debian-user--because Realtek eth chips
are everywhere--that lasted over two weeks IIRC.  There was no clear cut
easily findable Debian documentation on how to remedy this.  Many, many
OPs ran out an bought Intel NICs so they wouldn't have to fight this and
could get back up quickly, and so they'd (hopefully) never have to deal
with something like this again.

All of this, AIUI, because Debian and the upstream didn't get the right
"free" documentation in time from Realtek.  All other Realtek firmware
was free AFAIK, always has been AFAIK, and there'd never been an issue.
 This Debian kernel upgrade snafu caused a lot of pain for a lot of OPs,
needlessly.  Many defected to Ubuntu over this single issue, curse words
flying and all.

> If you run custom kernels, the after building it without the
> firmware built in, just run 'make firmware_install' before building
> your new initramfs and everything will just work fine.

This assumes one is using kernel.org source, correct, not Debian kernel
source?  Yes, then it should work fine.  I believe it's a bit more
complex with Debian kernel source due to the way free/non-free
drivers/blobs are handled by Debian.  Which is a shame really, because
myself and many others really really like Debian.  I still do.  I just
mitigate or work around these types of issues myself. :)

As I previously stated, I build in the firmware blobs.  I also build in
all device drivers the system will need, and thus I don't use an initrd,
ever.  In fact, I've never used modules, and thus I remove loadable
module support from the kernel to save space.  Most of my kernel images
run about 1.5 MB with a system map of 500 KB.  I'm always looking for
things to leave out that aren't needed to decrease kernel size.  And
yes, I still use LILO--til they pry it from my cold dead hands. :)

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
