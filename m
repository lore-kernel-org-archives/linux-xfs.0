Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3E3E629DF8
	for <xfs@oss.sgi.com>; Mon,  6 May 2013 14:55:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CEEDDAC003
	for <xfs@oss.sgi.com>; Mon,  6 May 2013 12:55:28 -0700 (PDT)
Received: from mail.ud10.udmedia.de (ud10.udmedia.de [194.117.254.50]) by
	cuda.sgi.com with ESMTP id pRU6TUQs5ZVqhJcm (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 06 May 2013 12:55:25 -0700 (PDT)
Date: Mon, 6 May 2013 21:55:21 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: Internal error xfs_sb_read_verify at line 726
Message-ID: <20130506195521.GB503@x4>
References: <20130506112717.GA502@x4> <5187E290.8090109@sandeen.net>
	<20130506183020.GA513@x4> <51880121.8000001@sandeen.net>
	<20130506192629.GA503@x4> <5188074F.2090500@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5188074F.2090500@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On 2013.05.06 at 14:41 -0500, Eric Sandeen wrote:
> On 5/6/13 2:26 PM, Markus Trippelsdorf wrote:
> > On 2013.05.06 at 14:14 -0500, Eric Sandeen wrote:
> >> On 5/6/13 1:30 PM, Markus Trippelsdorf wrote:
> >>> On 2013.05.06 at 12:04 -0500, Eric Sandeen wrote:
> >>>> On 5/6/13 6:27 AM, Markus Trippelsdorf wrote:
> >>>>> Today I accidentally tried to mount my backup disk at /dev/sdc instead
> >>>>> of /dev/sdc1 and this is what happened:
> >>>>>
> >>>>> ...
> >>>>> EXT4-fs (sdc): VFS: Can't find ext4 filesystem
> >>>>> FAT-fs (sdc): bogus number of reserved sectors
> >>>>> FAT-fs (sdc): Can't find a valid FAT filesystem
> >>>>> FAT-fs (sdc): bogus number of reserved sectors
> >>>>> FAT-fs (sdc): Can't find a valid FAT filesystem
> >>>>> ISOFS: Unable to identify CD-ROM format.
> >>>>> XFS (sdc): bad magic number
> >>>>> ffff8800db620000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >>>>> ffff8800db620010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >>>>> ffff8800db620020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >>>>> ffff8800db620030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >>>>> XFS (sdc): Internal error xfs_sb_read_verify at line 726 of file fs/xfs/xfs_mount.c.  Caller 0xffffffff8119e5cd
> >>>>
> >>>> This seems to be a recent regression.
> >>>>
> >>>> Comments above xfs_sb_quiet_read_verify() indicate that this behavior is
> >>>> to be avoided:
> >>>>
> >>>>  * We may be probed for a filesystem match, so we may not want to emit
> >>>>  * messages when the superblock buffer is not actually an XFS superblock.
> >>>>
> >>>> and it checks for proper magic prior to all the chattiness above int
> >>>> that function.
> >>>>
> >>>> The superblock read is suposed to choose whether to be noisy or not,
> >>>> in xfs_readsb():
> >>>>
> >>>
> >>> The following patch fixes the issue for me:
> >>>
> >>>
> >>> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> >>> index f6bfbd7..db8f27f 100644
> >>> --- a/fs/xfs/xfs_mount.c
> >>> +++ b/fs/xfs/xfs_mount.c
> >>> @@ -721,6 +721,11 @@ xfs_sb_read_verify(
> >>>  	}
> >>>  	error = xfs_sb_verify(bp);
> >>>  
> >>> +	if (error == XFS_ERROR(EWRONGFS)) {
> >>> +		xfs_buf_ioerror(bp, EWRONGFS);
> >>> +		return;
> >>> +	}
> >>> +
> >>>  out_error:
> >>>  	if (error) {
> >>>  		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
> >>
> >> That might make sense, I don't think we need the loudness for EWRONGFS
> >> no matter how we got there.  
> >>
> >> But:
> >>
> >> Out of curiosity, what was the actual mount command you used?  It seems like
> >> the auto-probing should have set the MS_SILENT flag to avoid this in
> >> the first place, i.e. we should have gone down the quiet path
> >> (xfs_sb_quiet_read_verify) and avoided this altogether.
> >>
> >> How do you reproduce this?
> > 
> > I power on the drive and simply run:
> > 
> >  # mount /dev/sdc /mnt
> 
> Interesting.  On my test box, that never even issues the mount syscall,
> because it uses blkid (I guess) to probe, and finds nothing.
> 
> Which util-linux do you have?

v2.21.2

> An strace -v of the mount command might be useful.

execve("/bin/mount", ["mount", "/dev/sdc", "/mnt"], [/* 44 vars */]) = 0
brk(0)                                  = 0x1ddc000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f3f5a3a5000
access("/etc/ld.so.preload", R_OK)      = 0
open("/etc/ld.so.preload", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=23, ...}) = 0
mmap(NULL, 23, PROT_READ|PROT_WRITE, MAP_PRIVATE, 3, 0) = 0x7f3f5a3a4000
close(3)                                = 0
open("/usr/lib/libamdlibm.so", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0@\245\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0644, st_size=699125, ...}) = 0
mmap(NULL, 2741432, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f3f59ee9000
mprotect(0x7f3f59f40000, 2097152, PROT_NONE) = 0
mmap(0x7f3f5a140000, 286720, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x57000) = 0x7f3f5a140000
mmap(0x7f3f5a186000, 1208, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f3f5a186000
close(3)                                = 0
munmap(0x7f3f5a3a4000, 23)              = 0
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=139673, ...}) = 0
mmap(NULL, 139673, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f3f5a382000
close(3)                                = 0
open("/lib/libblkid.so.1", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\0\0\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=155512, ...}) = 0
mmap(NULL, 157484, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f3f5a35b000
mmap(0x7f3f5a37e000, 16384, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x22000) = 0x7f3f5a37e000
close(3)                                = 0
open("/lib/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\200\33\2\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=9693409, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f3f5a35a000
mmap(NULL, 3594688, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f3f59b7b000
mprotect(0x7f3f59ce0000, 2093056, PROT_NONE) = 0
mmap(0x7f3f59edf000, 24576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x164000) = 0x7f3f59edf000
mmap(0x7f3f59ee5000, 14784, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f3f59ee5000
close(3)                                = 0
open("/lib/libuuid.so.1", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\0\0\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=16272, ...}) = 0
mmap(NULL, 18236, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f3f5a355000
mmap(0x7f3f5a359000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x3000) = 0x7f3f5a359000
close(3)                                = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f3f5a354000
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f3f5a352000
arch_prctl(ARCH_SET_FS, 0x7f3f5a352780) = 0
mprotect(0x7f3f59edf000, 16384, PROT_READ) = 0
mprotect(0x7f3f5a3a6000, 4096, PROT_READ) = 0
munmap(0x7f3f5a382000, 139673)          = 0
brk(0)                                  = 0x1ddc000
brk(0x1dfd000)                          = 0x1dfd000
open("/usr/lib/locale/locale-archive", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=1534640, ...}) = 0
mmap(NULL, 1534640, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f3f5a1db000
close(3)                                = 0
umask(022)                              = 022
open("/dev/null", O_RDWR)               = 3
close(3)                                = 0
getuid()                                = 0
geteuid()                               = 0
stat("/dev/sdc", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 32), ...}) = 0
readlink("/dev", 0x7fff283f5920, 4096)  = -1 EINVAL (Invalid argument)
readlink("/dev/sdc", 0x7fff283f5920, 4096) = -1 EINVAL (Invalid argument)
stat("/dev/sdc", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 32), ...}) = 0
rt_sigprocmask(SIG_BLOCK, ~[TRAP SEGV RTMIN RT_1], NULL, 8) = 0
open("/dev/sdc", O_RDONLY)              = 3
fadvise64(3, 0, 0, POSIX_FADV_RANDOM)   = 0
fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 32), ...}) = 0
uname({sys="Linux", node="x4", ...})    = 0
ioctl(3, BLKGETSIZE64, 1000204886016)   = 0
open("/sys/dev/block/8:32", O_RDONLY)   = 4
newfstatat(4, "partition", 0x7fff283f6490, 0) = -1 ENOENT (No such file or directory)
openat(4, "dm/uuid", O_RDONLY)          = -1 ENOENT (No such file or directory)
close(4)                                = 0
ioctl(3, CDROM_GET_CAPABILITY or SNDRV_SEQ_IOCTL_UNSUBSCRIBE_PORT, 0) = -1 ENOTTY (Inappropriate ioctl for device)
lseek(3, 1000204795904, SEEK_SET)       = 1000204795904
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 64) = 64
lseek(3, 1000204877824, SEEK_SET)       = 1000204877824
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 256) = 256
lseek(3, 0, SEEK_SET)                   = 0
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 256) = 256
lseek(3, 4096, SEEK_SET)                = 4096
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 256) = 256
lseek(3, 1000204885504, SEEK_SET)       = 1000204885504
read(3, "EFI PART\0\0\1\0\\\0\0\0\253 \1;\0\0\0\0\257mpt\0\0\0\0"..., 512) = 512
lseek(3, 1000204754432, SEEK_SET)       = 1000204754432
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 512) = 512
lseek(3, 1000204884992, SEEK_SET)       = 1000204884992
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 48) = 48
lseek(3, 1000204853760, SEEK_SET)       = 1000204853760
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0", 24) = 24
lseek(3, 1000204755456, SEEK_SET)       = 1000204755456
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0", 24) = 24
lseek(3, 1000204754944, SEEK_SET)       = 1000204754944
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0", 24) = 24
lseek(3, 1000204681728, SEEK_SET)       = 1000204681728
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0", 24) = 24
lseek(3, 1000204880384, SEEK_SET)       = 1000204880384
read(3, "\0\0\0\0", 4)                  = 4
lseek(3, 4096, SEEK_SET)                = 4096
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024) = 1024
lseek(3, 1000204881920, SEEK_SET)       = 1000204881920
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096) = 4096
lseek(3, 0, SEEK_SET)                   = 0
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024) = 1024
lseek(3, 1024, SEEK_SET)                = 1024
read(3, "\257=\306\17\203\204rG\216y=i\330G}\344\341Fx\2110\211\5E\211s\250\262\335\221A\370"..., 1024) = 1024
lseek(3, 1048576, SEEK_SET)             = 1048576
read(3, "XFSB\0\0\20\0\0\0\0\0\16\216\f\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024) = 1024
lseek(3, 3072, SEEK_SET)                = 3072
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024) = 1024
lseek(3, 7168, SEEK_SET)                = 7168
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024) = 1024
lseek(3, 15360, SEEK_SET)               = 15360
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024) = 1024
lseek(3, 31744, SEEK_SET)               = 31744
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024) = 1024
lseek(3, 64512, SEEK_SET)               = 64512
read(3, "\0\0\0\0\30\1\r\25\3dir\30\0\16\0\0\0\0\0\30\1\r\26\7dirname"..., 1024) = 1024
lseek(3, 8192, SEEK_SET)                = 8192
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024) = 1024
lseek(3, 65536, SEEK_SET)               = 65536
read(3, "IN\200\0\2\2\0\0\0\0\0\0\0\0\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024) = 1024
lseek(3, 32768, SEEK_SET)               = 32768
read(3, "XAGF\0\0\0\1\0\0\0\0\0c\320\231\0\0\22\321\0\0 \353\0\0\0\0\0\0\0\2"..., 1024) = 1024
lseek(3, 131072, SEEK_SET)              = 131072
read(3, "\0\0\0\0\0\v\311'\25%gconf-tree-zh_CN.xml\2\0"..., 41) = 41
lseek(3, 135168, SEEK_SET)              = 135168
read(3, ".schema\31H\213\205(\377\377\1\360\377\377\0(\0\0\1\331\27.dyngro"..., 41) = 41
lseek(3, 139264, SEEK_SET)              = 139264
read(3, "INA\300\2\1\0\0\0\0\3\350\0\0\3\350\0\0\0\3\0\0\0\0\0\0\0\0\0\0\0M"..., 41) = 41
lseek(3, 143360, SEEK_SET)              = 143360
read(3, "IN\241\377\2\1\0\0\0\0\0\0\0\0\0\0\0\0\0\16\0\0\0\0\0\0\0\0\0\0\0006"..., 41) = 41
lseek(3, 147456, SEEK_SET)              = 147456
read(3, "IN\201\244\2\2\0\0\0\0\0\0\0\0\0\0\0\0\0\16\0\0\0\0\0\0\0\0\0\0\0@"..., 41) = 41
lseek(3, 151552, SEEK_SET)              = 151552
read(3, "INA\355\2\1\0\0\0\0\0\0\0\0\0\0\0\0\0\2\0\0\0\0\0\0\0\0\0\0\0i"..., 41) = 41
lseek(3, 155648, SEEK_SET)              = 155648
read(3, "INA\355\2\1\0\0\0\0\0\0\0\0\0\0\0\0\0\2\0\0\0\0\0\0\0\0\0\0\0P"..., 41) = 41
lseek(3, 159744, SEEK_SET)              = 159744
read(3, "INA\355\2\1\0\0\0\0\3\350\0\0\3\350\0\0\0\2\0\0\0\0\0\0\0\0\0\0\0U"..., 41) = 41
lseek(3, 163840, SEEK_SET)              = 163840
read(3, "INA\355\2\2\0\0\0\0\3\350\0\0\0d\0\0\0\4\0\0\0\0\0\0\0\0\0\0\0\36"..., 41) = 41
lseek(3, 167936, SEEK_SET)              = 167936
read(3, "INA\355\2\1\0\0\0\0\3\350\0\0\3\350\0\0\0\2\0\0\0\0\0\0\0\0\0\0\0\32"..., 41) = 41
lseek(3, 172032, SEEK_SET)              = 172032
read(3, "INA\355\2\1\0\0\0\0\3\350\0\0\3\350\0\0\0\2\0\0\0\0\0\0\0\0\0\0\0\31"..., 41) = 41
lseek(3, 176128, SEEK_SET)              = 176128
read(3, "INA\355\2\1\0\0\0\0\3\350\0\0\0d\0\0\0\2\0\0\0\0\0\0\0\0\0\0\0\31"..., 41) = 41
lseek(3, 180224, SEEK_SET)              = 180224
read(3, "IN\201\244\2\2\0\0\0\0\3\350\0\0\3\350\0\0\0\16\0\0\0\0\0\0\0\0\0\0\0\34"..., 41) = 41
lseek(3, 184320, SEEK_SET)              = 184320
read(3, "INA\350\2\1\0\0\0\0\0\0\0\0\0#\0\0\0\3\0\0\0\0\0\0\0\0\0\0\0M"..., 41) = 41
lseek(3, 188416, SEEK_SET)              = 188416
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 41) = 41
lseek(3, 192512, SEEK_SET)              = 192512
read(3, "CI\201\244\2\2\1\330\377\377\rX\0\0\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0\2"..., 41) = 41
lseek(3, 196608, SEEK_SET)              = 196608
read(3, "\0\0\0\0\10\265\355\233\10patterns\0\0\0\0\0\2\0\0\0\0\0\20\245u\243"..., 41) = 41
lseek(3, 200704, SEEK_SET)              = 200704
read(3, "IN\201\244\2\2\0\0\0\0\0\0\0\0\0\0\0\0\0\2\0\0\0\0\0\0\0\0\0\0\0008"..., 41) = 41
lseek(3, 204800, SEEK_SET)              = 204800
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 41) = 41
lseek(3, 208896, SEEK_SET)              = 208896
read(3, "radient-select-next\")\n        (m"..., 41) = 41
lseek(3, 212992, SEEK_SET)              = 212992
read(3, " KDE4WorkspaceConfigVersion.cmak"..., 41) = 41
lseek(3, 217088, SEEK_SET)              = 217088
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 41) = 41
lseek(3, 221184, SEEK_SET)              = 221184
read(3, "\0\0\0\0\1%\24\245\23libvex_trc_values.h\0\0\2\0"..., 41) = 41
lseek(3, 225280, SEEK_SET)              = 225280
read(3, ";\n    template <\n        typenam"..., 41) = 41
lseek(3, 229376, SEEK_SET)              = 229376
read(3, "\0\0\0\0\30S\17\201\5omp.h\2\0\0\0\0\0\30S\17\202\vpmmintr"..., 41) = 41
lseek(3, 233472, SEEK_SET)              = 233472
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 41) = 41
lseek(3, 237568, SEEK_SET)              = 237568
read(3, "`Q\371\364\315\242\307T\254W\234*\342\225\3745s\224\330N\256\227\361\335\314ow\352;\33w\346"..., 41) = 41
lseek(3, 241664, SEEK_SET)              = 241664
read(3, "\246\250\355\371\203Z\357\240\thgz\24bbS3A(=@\251\221S\6\\\316\346P\246\312\375"..., 41) = 41
lseek(3, 245760, SEEK_SET)              = 245760
read(3, "\265P\212\3574F\4\31\1\202!\4\7\222\205\204\345\r\237\211\t\37\365\360)\0<\274\362\273z\320"..., 41) = 41
lseek(3, 249856, SEEK_SET)              = 249856
read(3, "sPPC.def\300\270\252\333\0\210\1\360\377\377\0(\0\1\30\202\27.Builti"..., 41) = 41
lseek(3, 253952, SEEK_SET)              = 253952
read(3, "bleCode.h.O9fYB4\0\0\0\0\0\0\1\360\0\0\0\0\0\1\27\257"..., 41) = 41
lseek(3, 258048, SEEK_SET)              = 258048
read(3, "ON_GENTOO \"/usr/bin/kconfig_comp"..., 41) = 41
lseek(3, 393216, SEEK_SET)              = 393216
read(3, "\0\0\0\0\3\0\1\0\0\0\0\0\0\0\0\0\0\0\0\0\3\0\2\0\0\0\0\0\0\0\0\0"..., 41) = 41
lseek(3, 397312, SEEK_SET)              = 397312
read(3, "\0\0\0\201\376\0\0\200\177w3\213T$\20\211\327\201\347\377\377\377\177\201\377\0\0\200\177w\0371"..., 41) = 41
lseek(3, 401408, SEEK_SET)              = 401408
read(3, "\n\n- Complex representations of i"..., 41) = 41
lseek(3, 405504, SEEK_SET)              = 405504
read(3, "taglib\n\n*acoustid-fingerprinter-"..., 41) = 41
lseek(3, 409600, SEEK_SET)              = 409600
read(3, " content=\"cluster software, Inte"..., 41) = 41
lseek(3, 413696, SEEK_SET)              = 413696
read(3, "sqlite\1\360\0\0\0\0\20[J\345\tsecmod.db\0\0\0\0\2\10"..., 41) = 41
lseek(3, 417792, SEEK_SET)              = 417792
read(3, "\0\35\324E\0\0\0\5\0\35\324d\0\0\0\5\0\35\341o\0\0\0\5\0\35\341\204\0\0\0\5"..., 41) = 41
lseek(3, 421888, SEEK_SET)              = 421888
read(3, "\10tgmath.h\0\0\0\0\0\0000\0\0\0\0\30 \r\223\vtmmintr"..., 41) = 41
lseek(3, 425984, SEEK_SET)              = 425984
read(3, " coder module is defined in this"..., 41) = 41
lseek(3, 430080, SEEK_SET)              = 430080
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 41) = 41
lseek(3, 434176, SEEK_SET)              = 434176
read(3, "ollowing disclaimer in the\n *   "..., 41) = 41
lseek(3, 438272, SEEK_SET)              = 438272
read(3, "he implied warranty of\n   MERCHA"..., 41) = 41
lseek(3, 442368, SEEK_SET)              = 442368
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 41) = 41
lseek(3, 446464, SEEK_SET)              = 446464
read(3, "r and have the text on the same "..., 41) = 41
lseek(3, 450560, SEEK_SET)              = 450560
read(3, "rs are strongly encouraged to\nco"..., 41) = 41
lseek(3, 454656, SEEK_SET)              = 454656
read(3, "he @code{gfc_error_flag_test} fu"..., 41) = 41
lseek(3, 458752, SEEK_SET)              = 458752
read(3, "amp{==|} and\n@samp{--|} mean @co"..., 41) = 41
lseek(3, 462848, SEEK_SET)              = 462848
read(3, "sed to variables), at the very b"..., 41) = 41
lseek(3, 466944, SEEK_SET)              = 466944
read(3, "structor} member.\n\n\n@subsection "..., 41) = 41
lseek(3, 471040, SEEK_SET)              = 471040
read(3, "-------\n\nFor specific bindings ("..., 41) = 41
lseek(3, 475136, SEEK_SET)              = 475136
read(3, "de{tb_uop_root}\nsymtree exactly "..., 41) = 41
lseek(3, 479232, SEEK_SET)              = 479232
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 41) = 41
lseek(3, 483328, SEEK_SET)              = 483328
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 41) = 41
lseek(3, 487424, SEEK_SET)              = 487424
read(3, "ta:\t0\nUndoDepth:\t12\nUpdateFlex:\t"..., 41) = 41
lseek(3, 491520, SEEK_SET)              = 491520
read(3, "mma_q\n#include <boost/math/speci"..., 41) = 41
lseek(3, 495616, SEEK_SET)              = 495616
read(3, "shing in size\n            // fas"..., 41) = 41
lseek(3, 499712, SEEK_SET)              = 499712
read(3, "the largest term in the\n        "..., 41) = 41
lseek(3, 503808, SEEK_SET)              = 503808
read(3, "       template <class RealType,"..., 41) = 41
lseek(3, 507904, SEEK_SET)              = 507904
read(3, ",\n               &r,\n           "..., 41) = 41
lseek(3, 512000, SEEK_SET)              = 512000
read(3, "      inline RealType find_degre"..., 41) = 41
lseek(3, 516096, SEEK_SET)              = 516096
read(3, " is %1%\", result, Policy());\n   "..., 41) = 41
lseek(3, 520192, SEEK_SET)              = 520192
read(3, "tion);\n         }\n         templ"..., 41) = 41
lseek(3, 0, SEEK_SET)                   = 0
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1377) = 1377
lseek(3, 8192, SEEK_SET)                = 8192
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1377) = 1377
lseek(3, 65536, SEEK_SET)               = 65536
read(3, "IN\200\0\2\2\0\0\0\0\0\0\0\0\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0\0"..., 1377) = 1377
lseek(3, 262144, SEEK_SET)              = 262144
read(3, "\0\1\251M\0\0\0&\0\1\251x\0\0\0\"\0\1\251\234\0\0\0\1\0\1\251\366\0\0\0\10"..., 1377) = 1377
lseek(3, 9728, SEEK_SET)                = 9728
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 512) = 512
lseek(3, 18944, SEEK_SET)               = 18944
read(3, "\274e\214\27\33\21\201\374\216\365\3717|\201\254\n\267[;)\354\231\343\272\315\4\276\3007\275\204\353"..., 512) = 512
lseek(3, 2048, SEEK_SET)                = 2048
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024) = 1024
lseek(3, 2097152, SEEK_SET)             = 2097152
read(3, "0\210\1\5G\366\7\2u\n\211\356^\342\2111\\\342b\34\3011y\253]$z\3070\354\24\271"..., 1024) = 1024
close(3)                                = 0
open("/etc/filesystems", O_RDONLY)      = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=399, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f3f5a3a4000
read(3, "# /etc/filesystems\n#\n# This file"..., 4096) = 399
close(3)                                = 0
munmap(0x7f3f5a3a4000, 4096)            = 0
open("/proc/filesystems", O_RDONLY)     = 3
fstat(3, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f3f5a3a4000
read(3, "nodev\tsysfs\nnodev\trootfs\nnodev\tb"..., 1024) = 213
stat("/sbin/mount.ext4", 0x7fff283f7550) = -1 ENOENT (No such file or directory)
stat("/sbin/fs.d/mount.ext4", 0x7fff283f7550) = -1 ENOENT (No such file or directory)
stat("/sbin/fs/mount.ext4", 0x7fff283f7550) = -1 ENOENT (No such file or directory)
stat("/usr/sbin/mount.ext4", 0x7fff283f7550) = -1 ENOENT (No such file or directory)
mount("/dev/sdc", "/mnt", "ext4", MS_MGC_VAL, NULL) = -1 EINVAL (Invalid argument)
stat("/sbin/mount.vfat", 0x7fff283f7550) = -1 ENOENT (No such file or directory)
stat("/sbin/fs.d/mount.vfat", 0x7fff283f7550) = -1 ENOENT (No such file or directory)
stat("/sbin/fs/mount.vfat", 0x7fff283f7550) = -1 ENOENT (No such file or directory)
stat("/usr/sbin/mount.vfat", 0x7fff283f7550) = -1 ENOENT (No such file or directory)
mount("/dev/sdc", "/mnt", "vfat", MS_MGC_VAL, NULL) = -1 EINVAL (Invalid argument)
stat("/sbin/mount.msdos", 0x7fff283f7550) = -1 ENOENT (No such file or directory)
stat("/sbin/fs.d/mount.msdos", 0x7fff283f7550) = -1 ENOENT (No such file or directory)
stat("/sbin/fs/mount.msdos", 0x7fff283f7550) = -1 ENOENT (No such file or directory)
stat("/usr/sbin/mount.msdos", 0x7fff283f7550) = -1 ENOENT (No such file or directory)
mount("/dev/sdc", "/mnt", "msdos", MS_MGC_VAL, NULL) = -1 EINVAL (Invalid argument)
stat("/sbin/mount.iso9660", 0x7fff283f7550) = -1 ENOENT (No such file or directory)
stat("/sbin/fs.d/mount.iso9660", 0x7fff283f7550) = -1 ENOENT (No such file or directory)
stat("/sbin/fs/mount.iso9660", 0x7fff283f7550) = -1 ENOENT (No such file or directory)
stat("/usr/sbin/mount.iso9660", 0x7fff283f7550) = -1 ENOENT (No such file or directory)
mount("/dev/sdc", "/mnt", "iso9660", MS_MGC_VAL, NULL) = -1 EINVAL (Invalid argument)
stat("/sbin/mount.xfs", 0x7fff283f7550) = -1 ENOENT (No such file or directory)
stat("/sbin/fs.d/mount.xfs", 0x7fff283f7550) = -1 ENOENT (No such file or directory)
stat("/sbin/fs/mount.xfs", 0x7fff283f7550) = -1 ENOENT (No such file or directory)
stat("/usr/sbin/mount.xfs", 0x7fff283f7550) = -1 ENOENT (No such file or directory)
mount("/dev/sdc", "/mnt", "xfs", MS_MGC_VAL, NULL) = -1 EINVAL (Invalid argument)
read(3, "", 1024)                       = 0
close(3)                                = 0
munmap(0x7f3f5a3a4000, 4096)            = 0
rt_sigprocmask(SIG_UNBLOCK, ~[TRAP SEGV RTMIN RT_1], NULL, 8) = 0
open("/usr/share/locale/locale.alias", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=2492, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f3f5a3a4000
read(3, "# Locale name alias data base.\n#"..., 4096) = 2492
read(3, "", 4096)                       = 0
close(3)                                = 0
munmap(0x7f3f5a3a4000, 4096)            = 0
open("/usr/share/locale/en_US.UTF-8/LC_MESSAGES/util-linux.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
open("/usr/share/locale/en_US.utf8/LC_MESSAGES/util-linux.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
open("/usr/share/locale/en_US/LC_MESSAGES/util-linux.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
open("/usr/share/locale/en.UTF-8/LC_MESSAGES/util-linux.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
open("/usr/share/locale/en.utf8/LC_MESSAGES/util-linux.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
open("/usr/share/locale/en/LC_MESSAGES/util-linux.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
write(2, "mount: you must specify the file"..., 43mount: you must specify the filesystem type) = 43
write(2, "\n", 1
)                       = 1
exit_group(32)                          = ?
+++ exited with 32 +++

-- 
Markus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
