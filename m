Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o758VRqi074537 for <xfs@oss.sgi.com>; Thu, 5 Aug 2010 03:31:27 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 783E016A6D2A
	for <xfs@oss.sgi.com>; Thu,  5 Aug 2010 01:31:47 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id D6SMvevTanG2A2JJ
	for <xfs@oss.sgi.com>; Thu, 05 Aug 2010 01:31:47 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 40C306C014
	for <xfs@oss.sgi.com>; Thu,  5 Aug 2010 03:31:47 -0500 (CDT)
Message-ID: <4C5A774D.6000400@hardwarefreak.com>
Date: Thu, 05 Aug 2010 03:33:17 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: How to track down abysmal performance ata - raid1 - crypto -
	vg/lv - xfs
References: <20100804073546.GA7494@comet.dominikbrodowski.net>	<20100804085039.GA11671@infradead.org>	<20100804091317.GA27779@isilmar-3.linta.de>	<20100804092122.GA2998@infradead.org>	<20100804073546.GA7494@comet.dominikbrodowski.net>	<201008041116.09822@zmi.at>	<20100804102526.GB13766@isilmar-3.linta.de>	<20100804111803.GA32643@infradead.org>	<alpine.DEB.1.10.1008041351100.19930@uplift.swm.pp.se>
	<20100805082438.0b476adb@notabene>
In-Reply-To: <20100805082438.0b476adb@notabene>
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

Neil Brown put forth on 8/4/2010 5:24 PM:

> Both page-cache and read-ahead work at the filesystem level

Are you referring to /sys/block/sdx/queue/read_ahead_kb?  I'm pretty sure this
works below the FS level and below the partition level.  This read_ahead works
at the block device level.  At least for individual or JBOD.

Are you saying this setting gets ignored by the kernel if/when mdadm, LVM,
and/or crypto are used?

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
