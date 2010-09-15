Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8F0hlXU156811 for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 19:43:47 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 531C61D88E09
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 17:44:35 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	LqYp6cfLXiP7yo5c for <xfs@oss.sgi.com>;
	Tue, 14 Sep 2010 17:44:35 -0700 (PDT)
Date: Wed, 15 Sep 2010 10:44:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Now: Debian issues, WAS: XFS Filesystem not mounting
Message-ID: <20100915004431.GM15695@dastard>
References: <29704010.post@talk.nabble.com> <20100914012151.GF411@dastard>
	<29705139.post@talk.nabble.com> <201009140740.14482@zmi.at>
	<20100914082504.4109712d@galadriel.home>
	<29708085.post@talk.nabble.com> <201009141603.24754@zmi.at>
	<4C8F9E29.2000803@hardwarefreak.com>
	<29710491.post@talk.nabble.com>
	<4C8FB8D6.6080603@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C8FB8D6.6080603@hardwarefreak.com>
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

On Tue, Sep 14, 2010 at 01:03:02PM -0500, Stan Hoeppner wrote:
> pbrunnen put forth on 9/14/2010 11:35 AM:
> > 3) I understand the ideology and legal reasons debian removes firmware blobs
> > (broadcom anyone) from their kernel modules...  but this is always a real
> > pain.  I end up monkeying about with the initrd image to get the firmware
> > blobs in... and often I just recompile with the blobs and forget it.
> 
> Ran into this long ago, and it's one of the reasons I roll my own.  I
> include the big blob in my kernels.  For _all_ the driver blobs it only
> adds a couple hundred KB to the kernel image, and it's more than worth
> the memory consumption to gain the reduced PITA factor.

You must be doing it wrong, then.

# apt-cache search "^firmware-"
....

Pick the packages for your hardware, or just install the lot (which
is what I normally do) and remake your initramfs. The firmware
packages have the correct firmware versions the distro kernels
expect.

If you run custom kernels, the after building it without the
firmware built in, just run 'make firmware_install' before building
your new initramfs and everything will just work fine.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
