Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBLFt97n018263 for <xfs@oss.sgi.com>; Sun, 21 Dec 2008 09:55:09 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D68E63BE5F
	for <xfs@oss.sgi.com>; Sun, 21 Dec 2008 07:55:07 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id WJ3aMvW2HBWHh0JM for <xfs@oss.sgi.com>;
	Sun, 21 Dec 2008 07:55:07 -0800 (PST)
Message-ID: <494E66D9.5030704@sandeen.net>
Date: Sun, 21 Dec 2008 09:55:05 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_repair problem.
References: <7bcfcfff0812210703r4bd889cave8e2d60c56587e3e@mail.gmail.com>
In-Reply-To: <7bcfcfff0812210703r4bd889cave8e2d60c56587e3e@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: David Bernick <dbernick@gmail.com>
Cc: xfs@oss.sgi.com

David Bernick wrote:
> I have a filesystem where an xfs_growfs went bad. We were adding
> storage to a pre-existing infrastructure and when growing, we received
> an error. 

The error you encountered would be worth mentioning in detail...

> SInce then, we've been unable to mount.
> 
> It's a large filesystem (see below) and the addition of the extra data
> has made it larger. We tried an xfs_repair but it died, as the machine
> only has 4GB RAM. 

Do you have the latest version of repair?  (xfs_repair -V; 2.10.2 is latest)

> We're going to put 32 GB in RAM and see if that
> helps. The original FS size is about 13T and the addition brought it
> to 29T.

on a 64-bit box I hope?  what kernel version?

> Since we've been unable to write or mount, we've "backed off" the
> addition and are left with our original, which we'd like to mount.

How did you back it off?  either the fs grew or it didn't; and you can't
shrink... so I guess it did not grow...

> We try to mount and get an error about the root inode not being
> readable. Makes sense as the root inode is null (according to xfs_db).
> 
> So before we run another big xfs_repair:
> 
> 1. What is the math of filesystems size, number of files and how much
> RAM is needed for such a task? Is 32 GB enough for 1/2 Billion files
> and 13 TB?
> 
> 2. Any way I can just find my rootino,rbmino,rsumino and put them in the DB?

I looked at the db output below & re-made a similar sparse fs:

[root tmp]# bc
3064987648*4096
12554189406208
quit
[root tmp]# mkfs.xfs -dfile,name=testfile,size=12554189406208
meta-data=testfile               isize=256    agcount=12,
agsize=268435455 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=3064987648, imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096
log      =internal log           bsize=4096   blocks=32768, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0
ls -lh [root tmp]# ls -l testfile
-rw-r--r-- 1 root root 12554189406208 Dec 21 09:51 testfile
[root tmp]# xfs_db testfile
xfs_db> sb 0
xfs_db> p
magicnum = 0x58465342
blocksize = 4096
dblocks = 3064987648
rblocks = 0
rextents = 0
uuid = 4b0451c8-5be4-452f-b161-a3ada3ec1a20
logstart = 1610612740
rootino = 128
rbmino = 129
rsumino = 130

so that's most likely what it should be.

> Any other advice?

post more details of how things actually fail and what happened...


> /proc/partitions:
>  253     0 13084291072 dm-0
> 

> 
> DB:

what db command?  printing sb 0 I assume but it' worth being explicit.

-Eric


> magicnum = 0x58465342
> blocksize = 4096
> dblocks = 3064987648
> rblocks = 0
> rextents = 0
> uuid = f086bb71-d67b-4cc1-b622-1f10349e6a49
> logstart = 1073741828
> rootino = null
> rbmino = null
> rsumino = null

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
