Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8A1TjTU125211 for <xfs@oss.sgi.com>; Thu, 9 Sep 2010 20:29:45 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C8A055F6AE
	for <xfs@oss.sgi.com>; Thu,  9 Sep 2010 18:30:29 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	I3BKGQ0ihlrFC9JI for <xfs@oss.sgi.com>;
	Thu, 09 Sep 2010 18:30:29 -0700 (PDT)
Date: Fri, 10 Sep 2010 11:30:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS over LVM over md RAID
Message-ID: <20100910013026.GA24409@dastard>
References: <4C89668E.6010800@sauce.co.nz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C89668E.6010800@sauce.co.nz>
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
To: Richard Scobie <richard@sauce.co.nz>
Cc: xfs@oss.sgi.com

On Fri, Sep 10, 2010 at 10:58:22AM +1200, Richard Scobie wrote:
> Using the latest, stable versions of LVM2 and xfsprogs and the
> 2.6.35.4 kernel, I am setting up lvm on a 16 drive, 256k chunk md
> RAID6, which has been used to date with XFS directly on the RAID.
> 
> mkfs.xfs directly on the RAID gives:
> 
> meta-data=/dev/md8               isize=256    agcount=32,
> agsize=106814656 blks
>          =                       sectsz=4096  attr=2
> data     =                       bsize=4096   blocks=3418068864, imaxpct=5
>          =                       sunit=64     swidth=896 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> 
> which gives the correct sunit and swidth values for the array.
> 
> Creating an lv which uses the entire array and mkfs.xfs on that, gives:
> 
> meta-data=/dev/vg_local/Storage  isize=256    agcount=13,
> agsize=268435455 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=3418067968, imaxpct=5
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0

Hmmm - it's treating MD very differently to the LVM volume -
different numbers of AGs, different sunit/swdith. Did you
build xfsprogs yourself? Is it linked against libblkid or libdisk?

Or it might be that LVM is not exporting the characteristic of the
underlying volume. Can you check if there are different parameter
values exported by the two devices in /sys/block/<dev>/queue?

> Limited testing using dd and bonnie++ shows no difference in write
> performance whether I use sunit=64/swidth=896 or sunit=0/swidth=0 on
> the lv.

These benchmarks won't realy show any difference on an empty
filesystem. It will have an impact on how the filesystems age and
how well aligned the IO will be to the underlying device under more
complex workloads...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
