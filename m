Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q75CYv5X206395 for <xfs@oss.sgi.com>; Sun, 5 Aug 2012 07:34:57 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id JKaerDgDgFqZmKXC
	for <xfs@oss.sgi.com>; Sun, 05 Aug 2012 05:34:56 -0700 (PDT)
Message-ID: <501E6872.6000503@hardwarefreak.com>
Date: Sun, 05 Aug 2012 07:34:58 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: xfs_growfs / planned resize / performance impact
References: <5017E426.2040709@profihost.ag> <501B4D7E.1000303@sandeen.net>
	<501B6B04.2090002@profihost.ag>
	(sfid-20120803_140801_426027_0A33D973)
	<201208051303.09337.Martin@lichtvoll.de>
In-Reply-To: <201208051303.09337.Martin@lichtvoll.de>
Reply-To: stan@hardwarefreak.com
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
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On 8/5/2012 6:03 AM, Martin Steigerwald wrote:

> Well the default was 16 AGs for volumes < 2 TiB AFAIR. And it has been 
> reduced to 4 for as I remember exactly performance reasons. Too many AGs 
> on a single device can incur too much parallelity. Thats at least is what 
> I have understood back then.

For striped md/RAID or LVM volumes mkfs.xfs will create 16 AGs by
default because it reads the configuration and finds a striped volume.
The theory here is that more AGs offers better performance in the
average case on a striped volume.

With hardware RAID or a single drive, or any storage configuration for
which mkfs.xfs is unable to query the parameters, mkfs.xfs creates 4 AGs
by default.  The 4 AG default has been with us for a very long time.  It
was never reduced.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
