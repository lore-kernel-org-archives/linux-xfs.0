Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9D0CunD016104 for <xfs@oss.sgi.com>; Fri, 12 Oct 2012 19:12:57 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	s6WaZtjkvzxJLfjU for <xfs@oss.sgi.com>;
	Fri, 12 Oct 2012 17:14:29 -0700 (PDT)
Date: Sat, 13 Oct 2012 11:14:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: File system corruption
Message-ID: <20121013001425.GN2739@dastard>
References: <5077077A.3040608@crossroads.com> <20121011210741.GC2739@dastard>
	<50789076.7040402@crossroads.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50789076.7040402@crossroads.com>
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
To: Wayne Walker <wwalker@crossroads.com>
Cc: xfs@oss.sgi.com

[cc'd the list again so everyone can see what is happening]

On Fri, Oct 12, 2012 at 04:49:42PM -0500, Wayne Walker wrote:
> On 10/11/2012 04:07 PM, Dave Chinner wrote:
> <snip>
> >Ok, so having looked at the stack trace, the AGF block taht was read
> >contained zeros, not valid metadata, which is why the allocation
> >failed.
> >
> >Can you remake the filesystem at will? If so, can you run mkfs.xfs
> >as per above, then run the following command?
> >
> ># echo 3 > /proc/sys/vm/drop_caches
> ># for i in `seq 0 4`; do
> >>xfs_db -l /dev/sda5 -c "sb $i" -c p -c "agf $i" -c p /dev/sde1
> >>done
> >So that we can see what mkfs put on disk? Can you then mount the
> >filesystem, unmount it again, and run the same commands? Then mount
> >the filesystem, run the copy/sync to trigger the error, then unmount
> >and run the commands again?
> >
> >What I'm interested in if whether xfs_db sees the AGF (which ever
> >one it is) as zero, or whether only the kernel is seeing that.
> 
> Thank you for the help.  I believe this has everything you asked for Dave.
....
> bash-4.1# uname -a
> Linux t30-2.commstor.crossroads.com 2.6.32-71.29.1.el6.x86_64 #1 SMP
> Mon Jun 27 19:49:27 BST 2011 x86_64 x86_64 x86_64 GNU/Linux
> bash-4.1# /sbin/mkfs.xfs -f -l logdev=/dev/sda5 -b size=4096 -d
> su=1024k,sw=4 /dev/sde1
> meta-data=/dev/sde1              isize=256    agcount=5,
> agsize=268435200 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=1183011584, imaxpct=5
>          =                       sunit=256    swidth=1024 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =/dev/sda5              bsize=4096   blocks=97280, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> bash-4.1# echo 3 > /proc/sys/vm/drop_caches
> bash-4.1# for i in `seq 0 4`; do xfs_db -l /dev/sda5 -c "sb $i" -c p
> -c "agf $i" -c p /dev/sde1; done
> magicnum = 0x58465342
> blocksize = 4096
.....

All superblocks and AGF headers look good.

> bash-4.1# mount -t xfs -o defaults,noatime,logdev=/dev/sda5
> /dev/sde1 /dtfs_data/data1
> bash-4.1# cp random_data.1G /dtfs_data/data1/foo2
> bash-4.1# sync
> bash-4.1# cp random_data.1G /dtfs_data/data1/foo3
> bash-4.1# sync
> bash-4.1# dmesg | tail -100
.....
> Filesystem "sde1": Disabling barriers, not supported with external
> log device
> XFS mounting filesystem sde1
> Ending clean XFS mount for filesystem: sde1
> ffff881808615200: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> ................
> Filesystem "sde1": XFS internal error xfs_alloc_read_agf at line
> 2157 of file fs/xfs/xfs_alloc.c.  Caller 0xffffffffa01d7989
.....
> bash-4.1# umount /dtfs_data/data1
> bash-4.1# echo 3 > /proc/sys/vm/drop_caches
> bash-4.1# for i in `seq 0 4`; do xfs_db -l /dev/sda5 -c "sb $i" -c p
> -c "agf $i" -c p /dev/sde1; done
> xfs_db: cannot init perag data (117)

xfs_db sees the corruption, too. What is corrupted?

> magicnum = 0x58465342
> blocksize = 4096
> dblocks = 1183011584

sb 0 is fine.

> magicnum = 0x58414746
> versionnum = 1
> seqno = 0

AGF 0 is fine.

So are SB/AGF 1.

> magicnum = 0
> blocksize = 0
> dblocks = 0

SB 2 is zeroed.

> magicnum = 0
> versionnum = 0
> seqno = 0

AGF 2 is zeroed.

> magicnum = 0x58465342
> blocksize = 4096
> dblocks = 1183011584

And SB/AGF 3 and 4 are ok, too.

So, the filesystem headers just beyond the 2TB offset are zero.
That tends to point to a block device problem, as an offset of 2TB
is where a 32 bit sector count will overflow (i.e. 2^32). Next step
is to run blktrace/blkparse on the cp workload that generates the
error to see if anything actually writes to the 2TB offset region,
and if so, where it comes from.

Probably best to compress the resultant blkparse output file - it
might be quite large but the text will compress well.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
