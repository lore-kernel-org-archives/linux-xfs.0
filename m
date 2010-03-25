Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2PNE2Cb171461 for <xfs@oss.sgi.com>; Thu, 25 Mar 2010 18:14:03 -0500
Received: from bifrost.lang.hm (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7AEE01A4D975
	for <xfs@oss.sgi.com>; Thu, 25 Mar 2010 16:15:43 -0700 (PDT)
Received: from bifrost.lang.hm (mail.lang.hm [64.81.33.126]) by cuda.sgi.com
	with ESMTP id 7sVY0Fzr2pAfgZoX for <xfs@oss.sgi.com>;
	Thu, 25 Mar 2010 16:15:43 -0700 (PDT)
Received: from asgard.lang.hm (asgard.lang.hm [10.0.0.100])
	by bifrost.lang.hm (8.13.4/8.13.4/Debian-3) with ESMTP id
	o2PNFgHF029132 for <xfs@oss.sgi.com>; Thu, 25 Mar 2010 15:15:43 -0800
Date: Thu, 25 Mar 2010 16:15:42 -0700 (PDT)
From: david@lang.hm
Subject: 128TB filesystem limit?
Message-ID: <alpine.DEB.2.00.1003251609160.12435@asgard.lang.hm>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

I'm working with a raid 0 (md) array on top of 10 16x1TB raid 6 hardware 
arrays.

fdisk -l shows me 10 drives like

WARNING: GPT (GUID Partition Table) detected on '/dev/sdk'! The util fdisk 
doesn't support GPT. Use GNU Parted.


Disk /dev/sdk: 13999.9 GB, 13999999025152 bytes
255 heads, 63 sectors/track, 1702069 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x00000000

    Device Boot      Start         End      Blocks   Id  System
/dev/sdk1               1      267350  2147483647+  ee  EFI GPT

and then the md0 device as

Disk /dev/md0: 139999.9 GB, 139999989596160 bytes
2 heads, 4 sectors/track, -1 cylinders
Units = cylinders of 8 * 512 = 4096 bytes
Disk identifier: 0x00000000

Disk /dev/md0 doesn't contain a valid partition table


I then did mkfs.xfs /dev/md0

but a df is showing me 128TB

is this just rounding error combined with the 1000=1k vs 1024=1k marketing 
stuff, or is there some limit I am bumping into here.

David Lang

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
