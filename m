Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o77ADVrW193170 for <xfs@oss.sgi.com>; Sat, 7 Aug 2010 05:13:31 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8190149F79F
	for <xfs@oss.sgi.com>; Sat,  7 Aug 2010 03:13:52 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	jn9ILX9FggwIjGmK for <xfs@oss.sgi.com>;
	Sat, 07 Aug 2010 03:13:52 -0700 (PDT)
Date: Sat, 7 Aug 2010 20:13:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: How to track down abysmal performance ata - raid1 - crypto -
	vg/lv - xfs
Message-ID: <20100807101349.GD7362@dastard>
References: <20100804085039.GA11671@infradead.org>
	<20100804091317.GA27779@isilmar-3.linta.de>
	<20100804092122.GA2998@infradead.org>
	<20100804073546.GA7494@comet.dominikbrodowski.net>
	<201008041116.09822@zmi.at>
	<20100804102526.GB13766@isilmar-3.linta.de>
	<20100804111803.GA32643@infradead.org>
	<alpine.DEB.1.10.1008041351100.19930@uplift.swm.pp.se>
	<20100805082438.0b476adb@notabene>
	<4C5A774D.6000400@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C5A774D.6000400@hardwarefreak.com>
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

On Thu, Aug 05, 2010 at 03:33:17AM -0500, Stan Hoeppner wrote:
> Neil Brown put forth on 8/4/2010 5:24 PM:
> 
> > Both page-cache and read-ahead work at the filesystem level
> 
> Are you referring to /sys/block/sdx/queue/read_ahead_kb?  I'm pretty sure this
> works below the FS level and below the partition level.  This read_ahead works
> at the block device level.  At least for individual or JBOD.

That number is used to initialise the default readahead value for
any file descriptor opened on the filesystem. readahead is tracked
per-fd at the page cache level, so is effectively at the filesystem
level, not the block device.

> Are you saying this setting gets ignored by the kernel if/when mdadm, LVM,
> and/or crypto are used?

Only the value from the block device the filesystem sits on is used.
i.e. if you are using /dev/md0, then the filesystem uses the value
from /sys/block/md0/queue/read_ahead_kb and ignores all the ones set
on the /dev/sdX devices that make up /dev/md0.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
