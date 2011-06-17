Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5HF7xaY124214 for <xfs@oss.sgi.com>; Fri, 17 Jun 2011 10:07:59 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B9792166B851
	for <xfs@oss.sgi.com>; Fri, 17 Jun 2011 08:07:58 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id nNL4rMKLBWC7vH60 for <xfs@oss.sgi.com>;
	Fri, 17 Jun 2011 08:07:58 -0700 (PDT)
Message-ID: <4DFB6DCD.6060106@sandeen.net>
Date: Fri, 17 Jun 2011 10:07:57 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Warning: AG size is a multiple of stripe width?
References: <385532.69322.qm@web77719.mail.sg1.yahoo.com>
In-Reply-To: <385532.69322.qm@web77719.mail.sg1.yahoo.com>
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
To: Gim Leong Chin <chingimleong@yahoo.com.sg>
Cc: xfs@oss.sgi.com

On 6/17/11 6:36 AM, Gim Leong Chin wrote:
> Hi,
> 
> 
> I have a Sun workstation with eight Cheetah 15K.5 SAS 300 GB on RAID
> 1E (RAID 10) on LSI SAS3081E-R.
> 
> I am installing SLED 11 SP1 on it and I thought I will do a thorough
> optimization right down to the partition boundaries.
> 
> Since the default for XFS is to create four aggregation groups, and
> with the reasoning that Cheetah can do double the seeks of normal
> 7200 RPM drives, I have four aggregation groups per drive for a total

"Allocation groups" just FWIW :)

Probably no real reason to try to outfox the defaults by doubling
AGs though, at least at this point.

> of 16 for 70 GB /dev/sda2 partition, and eight per drive for total of
> 32 for /dev/sda3 partition (1011 GB).
> 
> I have aligned the partition start and end with the stripe width
> boundaries. The stripe size is 64 kB, stripe width is 4*64 kB = 256
> kB, in terms of 512 byte sectors:

> 
> 70 GB /
> 
> No      Start           End             Number
> 1       512             67109375        32 GB = 67108864 sectors = 131072 stripe sets
> 
> 2       67109376        213910015       70 GB = 146800640 sectors = 286720 stripe sets
> 
> 3       213910016       2335932415      Left = 2335932416 - 213910016 = 2122022400 sectors = 4144575 stripe sets
> 
> 
> When I do the following:
> 
> mkfs.xfs -f -b size=4k -d agcount=16,su=64k,sw=4 -i size=256,align=1,attr=2 -l version=2,su=64k,lazy-count=1 -n version=2 -s size=512 -L / /dev/sda2

You are restating many defaults here, I'm not sure why...

I would probably just drop the agcount specification and let mkfs do its own thing here; left to its own devices it will choose 4 AGs.

> Warning: AG size is a multiple of stripe width. This can cause
> performance problems by aligning all AGs on the same disk. To avoid
> this, run mkfs with an AG size that is one stripe unit smaller, for
> example 1146864

mkfs.xfs -f -b size=4k -d agsize=1146864b,su=64k,sw=4  ...

does work too, if you really want that many AGs for some reason:

meta-data=testfile               isize=256    agcount=16, agsize=1146864 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=18349824, imaxpct=25
         =                       sunit=16     swidth=64 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=8960, version=2
         =                       sectsz=512   sunit=16 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
