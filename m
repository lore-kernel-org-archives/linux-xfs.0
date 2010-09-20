Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8KJlDjC233997 for <xfs@oss.sgi.com>; Mon, 20 Sep 2010 14:47:13 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EE4991E6BF05
	for <xfs@oss.sgi.com>; Mon, 20 Sep 2010 12:48:05 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id NoWuKWTKk9efXC3e
	for <xfs@oss.sgi.com>; Mon, 20 Sep 2010 12:48:05 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 0CE076C015
	for <xfs@oss.sgi.com>; Mon, 20 Sep 2010 14:48:05 -0500 (CDT)
Message-ID: <4C97BA74.5030304@hardwarefreak.com>
Date: Mon, 20 Sep 2010 14:48:04 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Question regarding performance on big files.
References: <4C979439.7070906@opencubetech.com>
In-Reply-To: <4C979439.7070906@opencubetech.com>
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

Mathieu AVILA put forth on 9/20/2010 12:04 PM:
>  Hello XFS team,
> 
> I have run into trouble with XFS, but excuse me if this question has
> been asked a dozens times.
> 
> I'm am filling a very big file on a XFS filesystem on Linux that stands
> on a software RAID 0. Performance are very good until I get 2 "holes"
> during which my write stalls for a few seconds.
> Mkfs parameters:
> mkxfs.xfs -b size 4096 -s size 4096 -d agcount=2 -i size=2048
> The RAID0 is done a 2 SATA disks of 500 GB each.

What happens when you make the filesystem using defaults?

mkfs.xfs /dev/[device]

Not sure if it is related to your issue, but your manual agcount setting
seems really low.  agcount greatly affects parallelism.  With a manual
setting of 2, you're dictating serial read/write stream behavior to/from
each drive.  This is not good.

I have a server with a single 500GB SATA drive with two XFS filesystem
partitions for data, each of 100GB, and a 35GB EXT partition for the /
filesystem.  Over half the drive space is unallocated.  Yet each XFS
filesystem has 4 default allocation groups.  If I were to create two
more 100GB filesystems, I'd end up with 16 AGs for 400GB worth of XFS
filesystems on a single 500GB drive.

meta-data=/dev/sda6    isize=256    agcount=4, agsize=6103694 blks
         =             sectsz=512   attr=2
data     =             bsize=4096   blocks=24414775, imaxpct=25
         =             sunit=0      swidth=0 blks
naming   =version 2    bsize=4096
log      =internal     bsize=4096   blocks=11921, version=2
         =             sectsz=512   sunit=0 blks, lazy-count=0
realtime =none         extsz=4096   blocks=0, rtextents=0

My suggestion would be to create the filesystem using default values and
see what you get.  2.6.18 is rather old, and I don't know if XFS picks
up the mdraid config and uses that info accordingly.  Newer versions of
XFS do this automatically and correctly, so you don't need to manually
specify anything with mkfs.xfs.

If default mkfs values still yield issues/problems, remake the
filesystem specifying '-d sw=2' and retest.

You specified '-b size=4096'.  This is the default for block size so
there's no need to specify it.

You specified '-s size=4096'.  This needs to match the sector size of
the underlying physical disk, which is 512 bytes in your case.  This may
be part of your problem as well.

You specified '-d agcount=2'.  From man mkfs.xfs:

"The data section of the filesystem is divided into _value_ allocation
groups (default value is scaled automatically based on the underlying
device size)."

My guess is that mkfs.xfs with no manual agcount forced would yield
something like 32-40 allocations groups on your RAID0 1TB XFS
filesystem.  Theoretically, this should boost your performance 16-20
times over your current agcount setting of 2 allocation groups.  In
reality the boost won't be nearly that great, but your performance
should be greatly improved nonetheless.

-- 
Stan


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
