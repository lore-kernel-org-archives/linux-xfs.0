Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2PNr1fF173249 for <xfs@oss.sgi.com>; Thu, 25 Mar 2010 18:53:02 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AD1D927917A
	for <xfs@oss.sgi.com>; Thu, 25 Mar 2010 16:54:37 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	k5im9C1vlGRmqfEP for <xfs@oss.sgi.com>;
	Thu, 25 Mar 2010 16:54:37 -0700 (PDT)
Date: Fri, 26 Mar 2010 10:54:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 128TB filesystem limit?
Message-ID: <20100325235433.GM3335@dastard>
References: <alpine.DEB.2.00.1003251609160.12435@asgard.lang.hm>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1003251609160.12435@asgard.lang.hm>
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
To: david@lang.hm
Cc: xfs@oss.sgi.com

On Thu, Mar 25, 2010 at 04:15:42PM -0700, david@lang.hm wrote:
> I'm working with a raid 0 (md) array on top of 10 16x1TB raid 6
> hardware arrays.
> 
> fdisk -l shows me 10 drives like
> 
> WARNING: GPT (GUID Partition Table) detected on '/dev/sdk'! The util
> fdisk doesn't support GPT. Use GNU Parted.
> 
> 
> Disk /dev/sdk: 13999.9 GB, 13999999025152 bytes
> 255 heads, 63 sectors/track, 1702069 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
> Disk identifier: 0x00000000
> 
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdk1               1      267350  2147483647+  ee  EFI GPT
> 
> and then the md0 device as
> 
> Disk /dev/md0: 139999.9 GB, 139999989596160 bytes
> 2 heads, 4 sectors/track, -1 cylinders
> Units = cylinders of 8 * 512 = 4096 bytes
> Disk identifier: 0x00000000
> 
> Disk /dev/md0 doesn't contain a valid partition table
> 
> 
> I then did mkfs.xfs /dev/md0
> 
> but a df is showing me 128TB

What is in /proc/partitions?

> is this just rounding error combined with the 1000=1k vs 1024=1k
> marketing stuff,

Probably.

> or is there some limit I am bumping into here.

Unlikely to be an XFS limit - I was doing some "what happens if"
testing on multi-PB sized XFS filesystems hosted on sparse files
a couple of days ago....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
