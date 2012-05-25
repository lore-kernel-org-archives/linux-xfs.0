Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4PGpxQJ142061 for <xfs@oss.sgi.com>; Fri, 25 May 2012 11:51:59 -0500
Date: Fri, 25 May 2012 11:57:19 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: very slow file deletion on an SSD
Message-ID: <20120525165719.GV16099@sgi.com>
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

Hey Joe,

On Fri, May 25, 2012 at 06:37:05AM -0400, Joe Landman wrote:
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
> 
> [root@siFlash ~]# mdadm --detail /dev/md20
> /dev/md20:
>         Version : 1.2
>   Creation Time : Sun Apr  1 19:36:39 2012
>      Raid Level : raid5
>      Array Size : 1641009216 (1564.99 GiB 1680.39 GB)
>   Used Dev Size : 234429888 (223.57 GiB 240.06 GB)
>    Raid Devices : 8
>   Total Devices : 8
>     Persistence : Superblock is persistent
> 
>     Update Time : Fri May 25 06:26:23 2012
>           State : clean
>  Active Devices : 8
> Working Devices : 8
>  Failed Devices : 0
>   Spare Devices : 0
> 
>          Layout : left-symmetric
>      Chunk Size : 32K
> 
>            Name : siFlash.sicluster:20
>            UUID : 2f023323:6ec29eb9:a943de06:f6e0c25d
>          Events : 296
> 
>     Number   Major   Minor   RaidDevice State
>        0       8      112        0      active sync   /dev/sdh
>        1       8       96        1      active sync   /dev/sdg
>        2       8      128        2      active sync   /dev/sdi
>        3       8       64        3      active sync   /dev/sde
>        4       8       32        4      active sync   /dev/sdc
>        5       8       48        5      active sync   /dev/sdd
>        6       8      192        6      active sync   /dev/sdm
>        7       8       80        7      active sync   /dev/sdf
> 
> All the SSDs are on deadline scheduler
> 
> [root@siFlash ~]# cat /sys/block/sd*/queue/scheduler | uniq
> noop [deadline] cfq
> 
> 
> All this said, deletes from this unit are taking 1-2 seconds per file ...
> 
> [root@siFlash ~]# strace -ttt -T rm -f /data/2/test/*
> 1337941514.040788 execve("/bin/rm", ["rm", "-f",
> "/data/2/test/2.8t-r.97.0", "/data/2/test/2.8t-r.98.0",
> "/data/2/test/2.8t-r.99.0", "/data/2/test/2.9.0"], [/* 40 vars */])
> = 0 <0.000552>
> 1337941514.041713 brk(0)                = 0x60d000 <0.000031>
> 1337941514.041927 mmap(NULL, 4096, PROT_READ|PROT_WRITE,
> MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f7bc2779000 <0.000032>
> 1337941514.042113 access("/etc/ld.so.preload", R_OK) = -1 ENOENT (No
> such file or directory) <0.000109>
> 1337941514.042395 open("/etc/ld.so.cache", O_RDONLY) = 3 <0.000050>
> 1337941514.042614 fstat(3, {st_mode=S_IFREG|0644, st_size=81118,
> ...}) = 0 <0.000102>
> 1337941514.042928 mmap(NULL, 81118, PROT_READ, MAP_PRIVATE, 3, 0) =
> 0x7f7bc2765000 <0.000042>
> 1337941514.043078 close(3)              = 0 <0.000019>
> 1337941514.043235 open("/lib64/libc.so.6", O_RDONLY) = 3 <0.000115>
> 1337941514.043477 read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\360\355\301W4\0\0\0"...,
> 832) = 832 <0.000039>
> 1337941514.043647 fstat(3, {st_mode=S_IFREG|0755, st_size=1908792,
> ...}) = 0 <0.000020>
> 1337941514.043860 mmap(0x3457c00000, 3733672, PROT_READ|PROT_EXEC,
> MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x3457c00000 <0.000085>
> 1337941514.044065 mprotect(0x3457d86000, 2097152, PROT_NONE) = 0 <0.000034>
> 1337941514.044191 mmap(0x3457f86000, 20480, PROT_READ|PROT_WRITE,
> MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x186000) = 0x3457f86000
> <0.000034>
> 1337941514.044388 mmap(0x3457f8b000, 18600, PROT_READ|PROT_WRITE,
> MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x3457f8b000
> <0.000085>
> 1337941514.044592 close(3)              = 0 <0.000058>
> 1337941514.044763 mmap(NULL, 4096, PROT_READ|PROT_WRITE,
> MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f7bc2764000 <0.000039>
> 1337941514.044893 mmap(NULL, 4096, PROT_READ|PROT_WRITE,
> MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f7bc2763000 <0.000020>
> 1337941514.044981 mmap(NULL, 4096, PROT_READ|PROT_WRITE,
> MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f7bc2762000 <0.000018>
> 1337941514.045076 arch_prctl(ARCH_SET_FS, 0x7f7bc2763700) = 0 <0.000018>
> 1337941514.045183 mprotect(0x3457f86000, 16384, PROT_READ) = 0 <0.000023>
> 1337941514.045270 mprotect(0x345761f000, 4096, PROT_READ) = 0 <0.000019>
> 1337941514.045350 munmap(0x7f7bc2765000, 81118) = 0 <0.000028>
> 1337941514.045619 brk(0)                = 0x60d000 <0.000017>
> 1337941514.045698 brk(0x62e000)         = 0x62e000 <0.000018>
> 1337941514.045803 open("/usr/lib/locale/locale-archive", O_RDONLY) =
> 3 <0.000028>
> 1337941514.045904 fstat(3, {st_mode=S_IFREG|0644, st_size=99158704,
> ...}) = 0 <0.000017>
> 1337941514.046012 mmap(NULL, 99158704, PROT_READ, MAP_PRIVATE, 3, 0)
> = 0x7f7bbc8d1000 <0.000020>
> 1337941514.046099 close(3)              = 0 <0.000017>
> 1337941514.046235 ioctl(0, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400
> opost isig icanon echo ...}) = 0 <0.000020>
> 1337941514.046373 newfstatat(AT_FDCWD, "/data/2/test/2.8t-r.97.0",
> {st_mode=S_IFREG|0600, st_size=1073741824, ...},
> AT_SYMLINK_NOFOLLOW) = 0 <0.000024>
> 1337941514.046504 unlinkat(AT_FDCWD, "/data/2/test/2.8t-r.97.0", 0)
> = 0 <1.357571>
> 1337941515.404257 newfstatat(AT_FDCWD, "/data/2/test/2.8t-r.98.0",
> {st_mode=S_IFREG|0600, st_size=1073741824, ...},
> AT_SYMLINK_NOFOLLOW) = 0 <0.000072>
> 1337941515.404485 unlinkat(AT_FDCWD, "/data/2/test/2.8t-r.98.0", 0)
> = 0 <1.608016>
> 1337941517.012706 newfstatat(AT_FDCWD, "/data/2/test/2.8t-r.99.0",
> {st_mode=S_IFREG|0600, st_size=1073741824, ...},
> AT_SYMLINK_NOFOLLOW) = 0 <0.000082>
> 1337941517.012957 unlinkat(AT_FDCWD, "/data/2/test/2.8t-r.99.0", 0)
> = 0 <1.133890>
> 1337941518.146983 newfstatat(AT_FDCWD, "/data/2/test/2.9.0",
> {st_mode=S_IFREG|0600, st_size=8589934592, ...},
> AT_SYMLINK_NOFOLLOW) = 0 <0.000023>
> 1337941518.147145 unlinkat(AT_FDCWD, "/data/2/test/2.9.0", 0) = 0 <0.938754>
> 1337941519.086125 close(0)              = 0 <0.000102>
> 1337941519.086357 close(1)              = 0 <0.000061>
> 1337941519.086540 close(2)              = 0 <0.000021>
> 1337941519.086694 exit_group(0)         = ?
> 
> Anything obvious that we are doing wrong?

There are a couple recent fixes related to discard that are probably
appropriate for 3.2-stable.

commit b1c770c273a4787069306fc82aab245e9ac72e9d
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Dec 21 00:07:42 2011 +0000

    xfs: fix endian conversion issue in discard code
    
    When finding the longest extent in an AG, we read the value directly
    out of the AGF buffer without endian conversion. This will give an
    incorrect length, resulting in FITRIM operations potentially not
    trimming everything that it should.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit a66d636385d621e98a915233250356c394a437de
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu Mar 22 05:15:12 2012 +0000

    xfs: fix fstrim offset calculations
    
    xfs_ioc_fstrim() doesn't treat the incoming offset and length
    correctly. It treats them as a filesystem block address, rather than
    a disk address. This is wrong because the range passed in is a
    linear representation, while the filesystem block address notation
    is a sparse representation. Hence we cannot convert the range direct
    to filesystem block units and then use that for calculating the
    range to trim.
    
    While this sounds dangerous, the problem is limited to calculating
    what AGs need to be trimmed. The code that calcuates the actual
    ranges to trim gets the right result (i.e. only ever discards free
    space), even though it uses the wrong ranges to limit what is
    trimmed. Hence this is not a bug that endangers user data.
    
    Fix this by treating the range as a disk address range and use the
    appropriate functions to convert the range into the desired formats
    for calculations.
    
    Further, fix the first free extent lookup (the longest) to actually
    find the largest free extent. Currently this lookup uses a <=
    lookup, which results in finding the extent to the left of the
    largest because we can never get an exact match on the largest
    extent. This is due to the fact that while we know it's size, we
    don't know it's location and so the exact match fails and we move
    one record to the left to get the next largest extent. Instead, use
    a >= search so that the lookup returns the largest extent regardless
    of the fact we don't get an exact match on it.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Ben Myers <bpm@sgi.com>

I'm not saying that they'll fix your problem, but you should consider giving
them a whirl.

Regards,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
