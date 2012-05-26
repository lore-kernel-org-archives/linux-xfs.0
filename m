Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4QNIjrw244649 for <xfs@oss.sgi.com>; Sat, 26 May 2012 18:18:45 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	fK9HhkPv3HEbSYuA for <xfs@oss.sgi.com>;
	Sat, 26 May 2012 16:18:42 -0700 (PDT)
Date: Sun, 27 May 2012 09:18:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: very slow file deletion on an SSD
Message-ID: <20120526231838.GR25351@dastard>
References: <4FBF60D1.80104@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FBF60D1.80104@gmail.com>
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

On Fri, May 25, 2012 at 06:37:05AM -0400, Joe Landman wrote:
> Hi folks:
> 
>   Just ran into this (see posted output at bottom).  3.2.14 kernel,
> MD RAID 5, xfs file system.  Not sure (precisely) where the problem
> is, hence posting to both lists.
> 
>  [root@siFlash ~]# cat /proc/mdstat
> Personalities : [raid1] [raid6] [raid5] [raid4]
> md22 : active raid5 sdl[0] sds[7] sdx[6] sdu[5] sdk[4] sdz[3] sdw[2] sdr[1]
>       1641009216 blocks super 1.2 level 5, 32k chunk, algorithm 2
> [8/8] [UUUUUUUU]
> 
> md20 : active raid5 sdh[0] sdf[7] sdm[6] sdd[5] sdc[4] sde[3] sdi[2] sdg[1]
>       1641009216 blocks super 1.2 level 5, 32k chunk, algorithm 2
> [8/8] [UUUUUUUU]
> 
> md21 : active raid5 sdy[0] sdq[7] sdp[6] sdo[5] sdn[4] sdj[3] sdv[2] sdt[1]
>       1641009216 blocks super 1.2 level 5, 32k chunk, algorithm 2
> [8/8] [UUUUUUUU]
> 
> md0 : active raid1 sdb1[1] sda1[0]
>       93775800 blocks super 1.0 [2/2] [UU]
>       bitmap: 1/1 pages [4KB], 65536KB chunk
> 
> 
> md2* are SSD RAID5 arrays we are experimenting with.  Xfs file
> systems atop them:
> 
> [root@siFlash ~]# mount | grep md2
> /dev/md20 on /data/1 type xfs (rw)
> /dev/md21 on /data/2 type xfs (rw)
> /dev/md22 on /data/3 type xfs (rw)
> 
> vanilla mount options (following Dave Chinner's long standing advice)
> 
> meta-data=/dev/md20              isize=2048   agcount=32,
> agsize=12820392 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=410252304, imaxpct=5
>          =                       sunit=8      swidth=56 blks
> naming   =version 2              bsize=65536  ascii-ci=0
> log      =internal               bsize=4096   blocks=30720, version=2
>          =                       sectsz=512   sunit=8 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0

But you haven't followed my advice when it comes to using default
mkfs options, have you? You're running 2k inodes and 64k directory
block size, which is not exactly a common config

The question is, why do you have these options configured, and are
they responsible for things being slow?

> All this said, deletes from this unit are taking 1-2 seconds per file ...

Sounds like you might be hitting the synchronous xattr removal
problem that was recently fixed (as has been mentioned already), but
even so 2 IOs don't take 1-2s to do, unless the MD RAID5 barrier
implementation is really that bad. If you mount -o nobarrier, what
happens?

CHeers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
