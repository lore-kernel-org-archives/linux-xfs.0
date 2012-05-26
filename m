Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4QJuvYb204104 for <xfs@oss.sgi.com>; Sat, 26 May 2012 14:56:57 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 1Oh9Un9OCib7IkKT
	for <xfs@oss.sgi.com>; Sat, 26 May 2012 12:56:56 -0700 (PDT)
Message-ID: <4FC13586.8060408@hardwarefreak.com>
Date: Sat, 26 May 2012 14:56:54 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: very slow file deletion on an SSD
References: <4FBF60D1.80104@gmail.com>
In-Reply-To: <4FBF60D1.80104@gmail.com>
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
To: Joe Landman <joe.landman@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, xfs@oss.sgi.com

On 5/25/2012 5:37 AM, Joe Landman wrote:
> Hi folks:

Hi Joe,

I may be all wet here, but this is the only thing that jumped out at me:

> meta-data=/dev/md20
> data     =                       sunit=8      swidth=56 blks
> log      =internal               sunit=8 blks

8*56KB (or 7*64KB) = 448KB write out

> [root@siFlash ~]# mdadm --detail /dev/md20
> /dev/md20:
>         Version : 1.2
>    Raid Devices : 8

>          Layout : left-symmetric
>      Chunk Size : 32K

7*32KB = 224KB stripe size

> All this said, deletes from this unit are taking 1-2 seconds per file ...

> Anything obvious that we are doing wrong?

Other than your XFS writeout being apparently twice the size of your
RAID stripe, nothing else stands out that I can see.  I'm not a block
layer expert.  And since mkfs.xfs came up with 448KB, apparently this
should be fine.  However, everything in the literature, and the experts
on this list, tells us to always precisely align XFS to the RAID stripe.
 That doesn't seem to be the case here.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
