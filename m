Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1NGs56C072270 for <xfs@oss.sgi.com>; Wed, 23 Feb 2011 10:54:06 -0600
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A6B10149AFC5
	for <xfs@oss.sgi.com>; Wed, 23 Feb 2011 08:56:50 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 4GzhJNy6GDSw4W53
	for <xfs@oss.sgi.com>; Wed, 23 Feb 2011 08:56:50 -0800 (PST)
Message-ID: <4D653C51.3080209@hardwarefreak.com>
Date: Wed, 23 Feb 2011 10:56:49 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS corruption on 3ware RAID6-volume
References: <AANLkTinWByYooMnPL7BryPowDexBeiHJdh3aVh+fdm-a@mail.gmail.com>
In-Reply-To: <AANLkTinWByYooMnPL7BryPowDexBeiHJdh3aVh+fdm-a@mail.gmail.com>
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
To: Erik Gulliksson <erik@gulliksson.org>
Cc: xfs@oss.sgi.com

Erik Gulliksson put forth on 2/23/2011 7:27 AM:
> Dear XFS people,
> 
> I have bumped in to a corruption problem with one a XFS filesystems.
> The filesystem lives on a RAID6-volume on a 3ware 9650SE-24M8 with
> battery backup and writecache enabled. RAID6-configuration is 11 2.0TB
> WD15EARS disks and the volume is reported as OK by the RAID-card.

There is a reason WD has an enterprise line of drives for use in RAID
applications.  The EARS series, along with the entire WD desktop drive
series, are not suitable for use with hardware RAID controllers, mainly
because they don't support TLER.  The 2TB low RPM WD Green at Newegg is
$90.  The 2TB 7.2k RPM Enterprise RE4 is $270, exactly 3 times the
price.  Is your data, and reliable fast access to it, worth the extra
$1,980?

I think too many folks are blinded by low acquisition cost and thus
can't see the overall life cycle cost, or TCO, of their storage
infrastructure.

Please Google the XFS list archives for the horror story at UC Santa
Cruz WRT hardware arrays using the WD 2TB Green drives.  The sysop lost
12TB of a 60TB XFS filesystem, and damn near lost the entire 60TB, if
not for luck.  The lost 12TB of data was Ph. D. students' research data.
 That kind of data is definitely worth the extra $$ for the right type
of drives which would have avoided the problem.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
