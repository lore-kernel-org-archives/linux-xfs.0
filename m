Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0NAi0JK089213 for <xfs@oss.sgi.com>; Mon, 23 Jan 2012 04:44:00 -0600
Received: from mail-ey0-f181.google.com (mail-ey0-f181.google.com
	[209.85.215.181]) by cuda.sgi.com with ESMTP id
	do0gT1v0DRC1wm7t for <xfs@oss.sgi.com>;
	Mon, 23 Jan 2012 02:43:59 -0800 (PST)
Received: by eaal1 with SMTP id l1so1578938eaa.26
	for <xfs@oss.sgi.com>; Mon, 23 Jan 2012 02:43:58 -0800 (PST)
Subject: Re: How to fix bad superblock or xfs_repair: error - read only 0 of
	512 bytes
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: multipart/mixed;
	boundary="Apple-Mail=_4840FB6A-E520-4F24-A8C5-D3E151150EB6"
From: Christian Kildau <lists@unixhosts.org>
In-Reply-To: <20120123043117.GH15102@dastard>
Date: Mon, 23 Jan 2012 11:43:55 +0100
Message-Id: <EFCDD721-8523-464C-83B7-7EE3AABF8CDD@unixhosts.org>
References: <CALx8gnT9tdPRGfVR0puoSVYz_MDDs4FtWtodST5x29GDnL3A_w@mail.gmail.com>
	<20120123043117.GH15102@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com


--Apple-Mail=_4840FB6A-E520-4F24-A8C5-D3E151150EB6
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

Sorry, heres the right strace:


--Apple-Mail=_4840FB6A-E520-4F24-A8C5-D3E151150EB6
Content-Disposition: attachment;
	filename=xfs_check.strace
Content-Type: application/octet-stream;
	x-unix-mode=0644;
	name="xfs_check.strace"
Content-Transfer-Encoding: 7bit

execve("/usr/sbin/xfs_check", ["xfs_check", "/dev/sde"], [/* 20 vars */]) = 0
brk(0)                                  = 0x13b9000
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f3935828000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=23783, ...}) = 0
mmap(NULL, 23783, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f3935822000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0 \24\2\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=1689912, ...}) = 0
mmap(NULL, 3806024, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f3935268000
mprotect(0x7f39353ff000, 2097152, PROT_NONE) = 0
mmap(0x7f39355ff000, 20480, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x197000) = 0x7f39355ff000
mmap(0x7f3935604000, 21320, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f3935604000
close(3)                                = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f3935821000
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f393581f000
arch_prctl(ARCH_SET_FS, 0x7f393581f720) = 0
mprotect(0x7f39355ff000, 16384, PROT_READ) = 0
mprotect(0x619000, 4096, PROT_READ)     = 0
mprotect(0x7f393582a000, 4096, PROT_READ) = 0
munmap(0x7f3935822000, 23783)           = 0
getpid()                                = 11387
rt_sigaction(SIGCHLD, {0x40f0e0, ~[RTMIN RT_1], SA_RESTORER, 0x7f393529e430}, NULL, 8) = 0
geteuid()                               = 0
brk(0)                                  = 0x13b9000
brk(0x13da000)                          = 0x13da000
getppid()                               = 11386
stat("/home/mrkofee", {st_mode=S_IFDIR|S_ISGID|0770, st_size=4096, ...}) = 0
stat(".", {st_mode=S_IFDIR|S_ISGID|0770, st_size=4096, ...}) = 0
open("/usr/sbin/xfs_check", O_RDONLY)   = 3
fcntl(3, F_DUPFD, 10)                   = 10
close(3)                                = 0
fcntl(10, F_SETFD, FD_CLOEXEC)          = 0
rt_sigaction(SIGINT, NULL, {SIG_DFL, [], 0}, 8) = 0
rt_sigaction(SIGINT, {0x40f0e0, ~[RTMIN RT_1], SA_RESTORER, 0x7f393529e430}, NULL, 8) = 0
rt_sigaction(SIGQUIT, NULL, {SIG_DFL, [], 0}, 8) = 0
rt_sigaction(SIGQUIT, {SIG_DFL, ~[RTMIN RT_1], SA_RESTORER, 0x7f393529e430}, NULL, 8) = 0
rt_sigaction(SIGTERM, NULL, {SIG_DFL, [], 0}, 8) = 0
rt_sigaction(SIGTERM, {SIG_DFL, ~[RTMIN RT_1], SA_RESTORER, 0x7f393529e430}, NULL, 8) = 0
read(10, "#!/bin/sh -f\n#\n# Copyright (c) 2"..., 8192) = 698
stat("/usr/local/sbin/xfs_db", 0x7fff67038140) = -1 ENOENT (No such file or directory)
stat("/usr/local/bin/xfs_db", 0x7fff67038140) = -1 ENOENT (No such file or directory)
stat("/usr/sbin/xfs_db", {st_mode=S_IFREG|0755, st_size=438344, ...}) = 0
clone(child_stack=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x7f393581f9f0) = 11388
wait4(-1, xfs_check: error - read only 0 of 512 bytes
[{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0, NULL) = 11388
--- SIGCHLD (Child exited) @ 0 (0) ---
rt_sigreturn(0x11)                      = 11388
exit_group(0)                           = ?

--Apple-Mail=_4840FB6A-E520-4F24-A8C5-D3E151150EB6
Content-Disposition: attachment;
	filename=xfs_repair.strace
Content-Type: application/octet-stream;
	x-unix-mode=0644;
	name="xfs_repair.strace"
Content-Transfer-Encoding: 7bit

execve("/sbin/xfs_repair", ["xfs_repair", "/dev/sde"], [/* 20 vars */]) = 0
brk(0)                                  = 0x846000
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fe7a0405000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=23783, ...}) = 0
mmap(NULL, 23783, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7fe7a03ff000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/x86_64-linux-gnu/libuuid.so.1", O_RDONLY) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0p\25\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0644, st_size=18896, ...}) = 0
mmap(NULL, 2113944, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fe79ffe2000
mprotect(0x7fe79ffe6000, 2093056, PROT_NONE) = 0
mmap(0x7fe7a01e5000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x3000) = 0x7fe7a01e5000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/x86_64-linux-gnu/librt.so.1", O_RDONLY) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\200!\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0644, st_size=31752, ...}) = 0
mmap(NULL, 2128984, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fe79fdda000
mprotect(0x7fe79fde1000, 2093056, PROT_NONE) = 0
mmap(0x7fe79ffe0000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x6000) = 0x7fe79ffe0000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/x86_64-linux-gnu/libpthread.so.0", O_RDONLY) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\240k\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=135217, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fe7a03fe000
mmap(NULL, 2212888, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fe79fbbd000
mprotect(0x7fe79fbd5000, 2093056, PROT_NONE) = 0
mmap(0x7fe79fdd4000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x17000) = 0x7fe79fdd4000
mmap(0x7fe79fdd6000, 13336, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7fe79fdd6000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0 \24\2\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=1689912, ...}) = 0
mmap(NULL, 3806024, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fe79f81b000
mprotect(0x7fe79f9b2000, 2097152, PROT_NONE) = 0
mmap(0x7fe79fbb2000, 20480, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x197000) = 0x7fe79fbb2000
mmap(0x7fe79fbb7000, 21320, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7fe79fbb7000
close(3)                                = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fe7a03fd000
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fe7a03fb000
arch_prctl(ARCH_SET_FS, 0x7fe7a03fb760) = 0
mprotect(0x7fe79fbb2000, 16384, PROT_READ) = 0
mprotect(0x7fe79fdd4000, 4096, PROT_READ) = 0
mprotect(0x7fe79ffe0000, 4096, PROT_READ) = 0
mprotect(0x7fe7a01e5000, 4096, PROT_READ) = 0
mprotect(0x671000, 4096, PROT_READ)     = 0
mprotect(0x7fe7a0407000, 4096, PROT_READ) = 0
munmap(0x7fe7a03ff000, 23783)           = 0
set_tid_address(0x7fe7a03fba30)         = 11699
set_robust_list(0x7fe7a03fba40, 0x18)   = 0
futex(0x7fff0d90d54c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 1, NULL, 7fe7a03fb760) = -1 EAGAIN (Resource temporarily unavailable)
rt_sigaction(SIGRTMIN, {0x7fe79fbc3680, [], SA_RESTORER|SA_SIGINFO, 0x7fe79fbccc10}, NULL, 8) = 0
rt_sigaction(SIGRT_1, {0x7fe79fbc3710, [], SA_RESTORER|SA_RESTART|SA_SIGINFO, 0x7fe79fbccc10}, NULL, 8) = 0
rt_sigprocmask(SIG_UNBLOCK, [RTMIN RT_1], NULL, 8) = 0
getrlimit(RLIMIT_STACK, {rlim_cur=8192*1024, rlim_max=RLIM_INFINITY}) = 0
brk(0)                                  = 0x846000
brk(0x867000)                           = 0x867000
open("/usr/lib/locale/locale-archive", O_RDONLY) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=2919792, ...}) = 0
mmap(NULL, 2919792, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7fe79f552000
close(3)                                = 0
getcwd("/home/mrkofee", 4096)           = 14
stat("/dev/sde", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 64), ...}) = 0
stat("/dev/sde", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 64), ...}) = 0
ustat(0x840, 0x7fff0d90bf80)            = -1 EINVAL (Invalid argument)
open("/dev/sde", O_RDONLY)              = 3
stat("/dev/sde", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 64), ...}) = 0
stat("/dev/sde", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 64), ...}) = 0
ustat(0x840, 0x7fff0d90bf80)            = -1 EINVAL (Invalid argument)
open("/dev/sde", O_RDWR|O_EXCL|O_DIRECT) = 4
fstat(4, {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 64), ...}) = 0
fstat(4, {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 64), ...}) = 0
ioctl(4, BLKGETSIZE64, 0x7fff0d90c0f0)  = 0
ioctl(4, BLKSSZGET, 0x6732e0)           = 0
chdir("/home/mrkofee")                  = 0
brk(0x888000)                           = 0x888000
close(3)                                = 0
getrlimit(RLIMIT_FSIZE, {rlim_cur=RLIM_INFINITY, rlim_max=RLIM_INFINITY}) = 0
time(NULL)                              = 1327315350
time(NULL)                              = 1327315350
open("/usr/share/locale/locale.alias", O_RDONLY) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=2570, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fe79f551000
read(3, "# Locale name alias data base.\n#"..., 4096) = 2570
read(3, "", 4096)                       = 0
close(3)                                = 0
munmap(0x7fe79f551000, 4096)            = 0
open("/usr/share/locale/en_US/LC_MESSAGES/xfsprogs.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
open("/usr/share/locale/en/LC_MESSAGES/xfsprogs.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
open("/usr/share/locale-langpack/en_US/LC_MESSAGES/xfsprogs.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
open("/usr/share/locale-langpack/en/LC_MESSAGES/xfsprogs.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
write(2, "Phase 1 - find and verify superb"..., 40Phase 1 - find and verify superblock...
) = 40
mmap(NULL, 528384, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fe79f4d1000
mmap(NULL, 528384, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fe79f450000
lseek(4, 0, SEEK_SET)                   = 0
read(4, "XFSB\0\0\20\0\0\0\0\0\25\325\17f\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 524288) = 524288
munmap(0x7fe79f450000, 528384)          = 0
brk(0x8be000)                           = 0x8be000
lseek(4, 375075479552, SEEK_SET)        = 375075479552
read(4, "XFSB\0\0\20\0\0\0\0\0\25\325\17f\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 131072) = 131072
lseek(4, 750150959104, SEEK_SET)        = 750150959104
read(4, "XFSB\0\0\20\0\0\0\0\0\25\325\17f\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 131072) = 131072
lseek(4, 1125226438656, SEEK_SET)       = 1125226438656
read(4, "XFSB\0\0\20\0\0\0\0\0\25\325\17f\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 131072) = 131072
munmap(0x7fe79f4d1000, 528384)          = 0
time(NULL)                              = 1327315350
pread(4, "XFSB\0\0\20\0\0\0\0\0\25\325\17f\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 32768, 0) = 32768
pread(4, "", 512, 1500301909504)        = 0
write(2, "xfs_repair: error - read only 0 "..., 45xfs_repair: error - read only 0 of 512 bytes
) = 45
exit_group(1)                           = ?

--Apple-Mail=_4840FB6A-E520-4F24-A8C5-D3E151150EB6
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii



All other output was correct!



On Jan 23, 2012, at 5:31 AM, Dave Chinner wrote:

> On Sat, Jan 21, 2012 at 11:29:15AM +0100, Christian Kildau wrote:
>> Sorry if this message appears twice!
>> 
>> 
>> 
>> Hello,
>> 
>> I'm having some very serious issues with XFS after upgrading from a
>> Linux Distro running Ubuntu 2.6.32 to 3.2.
>> 
>> It seems like my filesystems are damaged after attaching them to a
>> Linux 3.2 server. I am also no longer able to mount the hdd on the old
>> server that is still running 2.6.32!
> 
> I take it that you are using external storage of some kind? Can you
> describe it?
> 
>> (I created the xfs filesystem on the entire hdd, not on a partition,
>> so /dev/sdd is not a typo)
>> 
>> $ sudo mount -t xfs /dev/sdd /media/
>> mount: /dev/sdd: can't read superblock
>> (dmesg)
>> [236659.912663] attempt to access beyond end of device
>> [236659.912667] sdd: rw=32, want=2930277168, limit=2930275055
>> [236659.912670] XFS (sdd): last sector read failed
> 
> So XFS has asked to read 2113 sectors beyond the size of the device
> that the kernel is reporting. What is the output of
> /proc/partitions?
> 
>> $ sudo xfs_check /dev/sdd
>> xfs_check: error - read only 0 of 512 bytes
>> 
>> $ sudo xfs_repair /dev/sdd
>> Phase 1 - find and verify superblock...
>> xfs_repair: error - read only 0 of 512 bytes
> 
> So both buffered and direct IO to the first block in the block
> device are failing. I'd say your problems have nothing to do with
> XFS. However, can you strace them and find out what the error that
> is occuring actually is?
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com


--Apple-Mail=_4840FB6A-E520-4F24-A8C5-D3E151150EB6
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--Apple-Mail=_4840FB6A-E520-4F24-A8C5-D3E151150EB6--
