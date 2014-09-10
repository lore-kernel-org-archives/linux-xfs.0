Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 47B8B7F61
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2014 20:53:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B20BEAC004
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2014 18:53:37 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	kbSHjkiadBrRTO2f for <xfs@oss.sgi.com>;
	Tue, 09 Sep 2014 18:53:34 -0700 (PDT)
Date: Wed, 10 Sep 2014 11:53:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Corrupted files
Message-ID: <20140910015331.GJ20518@dastard>
References: <540F1B01.3020700@mygrande.net> <20140909220645.GH20518@dastard>
	<540FA586.9090308@mygrande.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <540FA586.9090308@mygrande.net>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Leslie Rhorer <lrhorer@mygrande.net>
Cc: xfs@oss.sgi.com

On Tue, Sep 09, 2014 at 08:12:38PM -0500, Leslie Rhorer wrote:
> On 9/9/2014 5:06 PM, Dave Chinner wrote:
> >Fristly, more infomration is required, namely versions and actual
> >error messages:
> 
> 	Indubitably:
> 
> RAID-Server:/# xfs_repair -V
> xfs_repair version 3.1.7
> RAID-Server:/# uname -r
> 3.2.0-4-amd64

Ok, so a relatively old xfs_repair. That's important - read on....

> 4.0 GHz FX-8350 eight core processor
> 
> RAID-Server:/# cat /proc/meminfo /proc/mounts /proc/partitions
> MemTotal:        8099916 kB
....
> /dev/md0 /RAID xfs
> rw,relatime,attr2,delaylog,sunit=2048,swidth=12288,noquota 0 0

FWIW, you don't need sunit=2048,swidth=12288 in the mount options -
they are stored on disk and the mount options are only necessray to
change the on-disk values.

> Personalities : [raid6] [raid5] [raid4] [raid1] [raid0]
> md10 : active raid0 sdf[0] sde[2] sdg[1]
>       4395021312 blocks super 1.2 512k chunks
> 
> md0 : active raid6 md10[12] sdc[13] sdk[10] sdj[11] sdi[15] sdh[8] sdd[9]
>       23441319936 blocks super 1.2 level 6, 1024k chunk, algorithm 2
> [8/7] [UUU_UUUU]
>       bitmap: 29/30 pages [116KB], 65536KB chunk
> 
> md3 : active (auto-read-only) raid1 sda3[0] sdb3[1]
>       12623744 blocks super 1.2 [3/2] [UU_]
>       bitmap: 1/1 pages [4KB], 65536KB chunk
> 
> md2 : active raid1 sda2[0] sdb2[1]
>       112239488 blocks super 1.2 [3/2] [UU_]
>       bitmap: 1/1 pages [4KB], 65536KB chunk
> 
> md1 : active raid1 sda1[0] sdb1[1]
>       96192 blocks [3/2] [UU_]
>       bitmap: 1/1 pages [4KB], 65536KB chunk
> 
> unused devices: <none>
> 
> 	Six of the drives are 4T spindles (a mixture of makes and models).
> The three drives comprising MD10 are WD 1.5T green drives.  These
> are in place to take over the function of one of the kicked 4T
> drives.  Md1, 2, and 3 are not data drives and are not suffering any
> issue.

Ok, that's creative. But when you need another drive in the array
and you don't have the right spares.... ;)

> 	I'm not sure what is meant by "write cache status" in this context.
> The machine has been rebooted more than once during recovery and the
> FS has been umounted and xfs_repair run several times.

Start here and read the next few entries:

http://xfs.org/index.php/XFS_FAQ#Q:_What_is_the_problem_with_the_write_cache_on_journaled_filesystems.3F

> 	I don't know for what the acronym BBWC stands.

"battery backed write cache". If you're not using a hardware RAID
controller, it's unlikely you have one. The difference between a
drive write cache and a BBWC is that the BBWC is non-volatile - it
does not get lost when power drops.

> RAID-Server:/# xfs_info /dev/md0
> meta-data=/dev/md0               isize=256    agcount=43,
> agsize=137356288 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=5860329984, imaxpct=5
>          =                       sunit=256    swidth=1536 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=521728, version=2
>          =                       sectsz=512   sunit=8 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0

Ok, that all looks pretty good, and the sunit/swidth match the mount
options you set so you definitely don't need the mount options...

> 	The system performs just fine, other than the aforementioned, with
> loads in excess of 3Gbps.  That is internal only.  The LAN link is
> ony 1Gbps, so no external request exceeds about 950Mbps.
> 
> >http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
> >
> >dmesg, in particular, should tell use what the corruption being
> >encountered is when stat fails.
> 
> RAID-Server:/# ls "/RAID/DVD/Big Sleep, The (1945)/VIDEO_TS/VTS_01_1.VOB"
> ls: cannot access /RAID/DVD/Big Sleep, The
> (1945)/VIDEO_TS/VTS_01_1.VOB: Structure needs cleaning
> RAID-Server:/# dmesg | tail -n 30
> ...
> [192173.363981] XFS (md0): corrupt dinode 41006, extent total = 1,
> nblocks = 0.
> [192173.363988] ffff8802338b8e00: 49 4e 81 b6 02 02 00 00 00 00 03
> e8 00 00 03 e8  IN..............
> [192173.363996] XFS (md0): Internal error xfs_iformat(1) at line 319
> of file /build/linux-eKuxrT/linux-3.2.60/fs/xfs/xfs_inode.c.  Caller
> 0xffffffffa0509318
> [192173.363999]
> [192173.364062] Pid: 10813, comm: ls Not tainted 3.2.0-4-amd64 #1
> Debian 3.2.60-1+deb7u3
> [192173.364065] Call Trace:
> [192173.364097]  [<ffffffffa04d3731>] ? xfs_corruption_error+0x54/0x6f [xfs]
> [192173.364134]  [<ffffffffa0509318>] ? xfs_iread+0x9f/0x177 [xfs]
> [192173.364170]  [<ffffffffa0508efa>] ? xfs_iformat+0xe3/0x462 [xfs]
> [192173.364204]  [<ffffffffa0509318>] ? xfs_iread+0x9f/0x177 [xfs]
> [192173.364240]  [<ffffffffa0509318>] ? xfs_iread+0x9f/0x177 [xfs]
> [192173.364268]  [<ffffffffa04d6ebe>] ? xfs_iget+0x37c/0x56c [xfs]
> [192173.364300]  [<ffffffffa04e13b4>] ? xfs_lookup+0xa4/0xd3 [xfs]
> [192173.364328]  [<ffffffffa04d9e5a>] ? xfs_vn_lookup+0x3f/0x7e [xfs]
> [192173.364344]  [<ffffffff81102de9>] ? d_alloc_and_lookup+0x3a/0x60
> [192173.364357]  [<ffffffff8110388d>] ? walk_component+0x219/0x406
> [192173.364370]  [<ffffffff81104721>] ? path_lookupat+0x7c/0x2bd
> [192173.364383]  [<ffffffff81036628>] ? should_resched+0x5/0x23
> [192173.364396]  [<ffffffff8134f144>] ? _cond_resched+0x7/0x1c
> [192173.364408]  [<ffffffff8110497e>] ? do_path_lookup+0x1c/0x87
> [192173.364420]  [<ffffffff81106407>] ? user_path_at_empty+0x47/0x7b
> [192173.364434]  [<ffffffff813533d8>] ? do_page_fault+0x30a/0x345
> [192173.364448]  [<ffffffff810d6a04>] ? mmap_region+0x353/0x44a
> [192173.364460]  [<ffffffff810fe45a>] ? vfs_fstatat+0x32/0x60
> [192173.364471]  [<ffffffff810fe590>] ? sys_newstat+0x12/0x2b
> [192173.364483]  [<ffffffff813509f5>] ? page_fault+0x25/0x30
> [192173.364495]  [<ffffffff81355452>] ? system_call_fastpath+0x16/0x1b
> [192173.364503] XFS (md0): Corruption detected. Unmount and run xfs_repair
> 
> 	That last line, by the way, is why I ran umount and xfs_repair.

Right, that's the correct thing to do, but sometimes there are
issues that repair doesn't handle properly. This *was* one of them,
and it was fixed by commit e1f43b4 ("repair: update extent count
after zapping duplicate blocks") which was added to xfs_repair
v3.1.8.

IOWs, upgrading xfsprogs to the latest release and re-running
xfs_repair should fix this error.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
