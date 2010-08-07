Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o77Ne4FC220636 for <xfs@oss.sgi.com>; Sat, 7 Aug 2010 18:40:04 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C63DCC6869D
	for <xfs@oss.sgi.com>; Sat,  7 Aug 2010 16:48:46 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id SkmOzXYbK0G5FykX
	for <xfs@oss.sgi.com>; Sat, 07 Aug 2010 16:48:46 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id EA8026C33C
	for <xfs@oss.sgi.com>; Sat,  7 Aug 2010 18:40:23 -0500 (CDT)
Message-ID: <4C5DEFA1.4010506@hardwarefreak.com>
Date: Sat, 07 Aug 2010 18:43:29 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: How to track down abysmal performance ata - raid1 - crypto -
	vg/lv - xfs
References: <20100804085039.GA11671@infradead.org>	<20100804091317.GA27779@isilmar-3.linta.de>	<20100804092122.GA2998@infradead.org>	<20100804073546.GA7494@comet.dominikbrodowski.net>	<201008041116.09822@zmi.at>	<20100804102526.GB13766@isilmar-3.linta.de>	<20100804111803.GA32643@infradead.org>	<alpine.DEB.1.10.1008041351100.19930@uplift.swm.pp.se>	<20100805082438.0b476adb@notabene>	<4C5A774D.6000400@hardwarefreak.com>
	<20100807101349.GD7362@dastard>
In-Reply-To: <20100807101349.GD7362@dastard>
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

Dave Chinner put forth on 8/7/2010 5:13 AM:
> On Thu, Aug 05, 2010 at 03:33:17AM -0500, Stan Hoeppner wrote:
>> Neil Brown put forth on 8/4/2010 5:24 PM:
>>
>>> Both page-cache and read-ahead work at the filesystem level
>>
>> Are you referring to /sys/block/sdx/queue/read_ahead_kb?  I'm pretty sure this
>> works below the FS level and below the partition level.  This read_ahead works
>> at the block device level.  At least for individual or JBOD.
> 
> That number is used to initialise the default readahead value for
> any file descriptor opened on the filesystem. readahead is tracked
> per-fd at the page cache level, so is effectively at the filesystem
> level, not the block device.
> 
>> Are you saying this setting gets ignored by the kernel if/when mdadm, LVM,
>> and/or crypto are used?
> 
> Only the value from the block device the filesystem sits on is used.
> i.e. if you are using /dev/md0, then the filesystem uses the value
> from /sys/block/md0/queue/read_ahead_kb and ignores all the ones set
> on the /dev/sdX devices that make up /dev/md0.

Thanks for the clarification/education Dave.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
