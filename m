Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from smtp-out-no.shaw.ca ([64.59.134.9]:58802 "EHLO
        smtp-out-no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751712AbdEPCFU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 May 2017 22:05:20 -0400
From: Andrew Ryder <tireman@shaw.ca>
Subject: Re: xfsprogs 4.5 vs 4.10
References: <5997f5f5-372d-7ab6-429f-d690cf642f47@shaw.ca>
 <20170515115952.GA27809@bfoster.bfoster>
Message-ID: <69e6cb18-a0b1-00a5-8c09-65c768eda884@shaw.ca>
Date: Mon, 15 May 2017 22:10:11 -0400
MIME-Version: 1.0
In-Reply-To: <20170515115952.GA27809@bfoster.bfoster>
Content-Type: multipart/mixed;
 boundary="------------AF0F563E380276EB9C67B0D1"
Content-Language: en-GB
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

This is a multi-part message in MIME format.
--------------AF0F563E380276EB9C67B0D1
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

Hi Brian,

I'll start from the beginning.. I have a mdadm raid 5 array with 4 SATA 
disks  (2xST4000NC000 and 2xST2000NC000) that were attached to a 
RocketRaid 2722 controller in an Addonics tower all on the same PMP.

Something had a fit in there and knocked the RR driver offline taking 
out the array when I was adding data to the array.

I moved the disks off the array onto individual sata controllers on the 
system and finished my repairs from there as that setup has some kind of 
issue when I near 89% usage on the array.

I ended up with the xfs log and superblock being screwed up. I was 
running kernel 3.19.18 and upgraded to 4.6.7 in case there was some 
unknown bug hiding in there. I did all my repair work on 4.6.7 kernel.

I could not get the 4.5 tools to sort things out as the log was messed 
up (the log head/tail could not be found), and the superblock was messed 
up (if I remember right it was a metadata error).

I tried moving the log to an external setup, but xfs_db would complain 
about corruption at 0x0/0x200 in the superblock and not let me do this.

I upgraded to 4.10 tools with hope but no luck any which way. For some 
reason with 4.5 I could use the xfsrepair -L option and then re-run with 
xfsrepair and no -L option and it would do something with the log and 
superblock and I could mount the FS again. Doing that with 4.10 would 
not work at all.

I ended up downgrading to 4.5 tools again and doing the xfsrepair, 
xfsrepair -L and xfsrepair and I had success. I have no idea why, but it 
worked and everything is happy again. I'm on kernel 4.8.17 at the moment 
and so far so good with the drives nowhere near the highpoint card.

I've attached a printout of the superblock that was messed and as it is 
now as well as one of the xfsrepair straces. For whatever reason, when I 
went to pull the sb values for this e-mail I had 4.10 installed again 
from a system update and it kept segfalting.. going back to 4.5 worked.

If you need more I can dig through syslog and messages and see what I 
can pull out for you.

Andrew

On 05/15/2017 07:59 AM, Brian Foster wrote:
> On Sat, May 13, 2017 at 08:04:42PM -0400, Andrew Ryder wrote:
>> Hello,
>>
>> I went through a corruption issue on a v5 filesystem I have and the v4.5 of
>> the tools fixed the log but 4.10 would only complain about not being able to
>> fix it?
>>
>
> Can you provide details please?
>
> Brian
>
>> I can provide some background on the issue if that helps but I though it
>> might be worthwhile to mention the above..?
>>
>> Andrew
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--------------AF0F563E380276EB9C67B0D1
Content-Type: text/plain; charset=UTF-8;
 name="md2.sb.out"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="md2.sb.out"

magicnum = 0x58465342
blocksize = 4096
dblocks = 1465036800
rblocks = 0
rextents = 0
uuid = e6a93d7b-44e9-44d4-8ead-520574c585b3
logstart = 1073741832
rootino = 1024
rbmino = 1025
rsumino = 1026
rextsize = 1
agblocks = 45782272
agcount = 33
rbmblocks = 0
logblocks = 521728
versionnum = 0xb5b5
sectsize = 512
inodesize = 512
inopblock = 8
fname = "\000\000\000\000\000\000\000\000\000\000\000\000"
blocklog = 12
sectlog = 9
inodelog = 9
inopblog = 3
agblklog = 26
rextslog = 0
inprogress = 0
imax_pct = 5
icount = 2193280
ifree = 10398
fdblocks = 196575070
frextents = 0
uquotino = null
gquotino = null
qflags = 0
flags = 0
shared_vn = 0
inoalignmt = 4
unit = 128
width = 384
dirblklog = 0
logsectlog = 0
logsectsize = 0
logsunit = 32768
features2 = 0x18a
bad_features2 = 0x18a
features_compat = 0
features_ro_compat = 0x1
features_incompat = 0x1
features_log_incompat = 0
crc = 0xdfad83e7 (correct)
spino_align = 0
pquotino = null
lsn = 0x100000000
meta_uuid = 00000000-0000-0000-0000-000000000000

--------------AF0F563E380276EB9C67B0D1
Content-Type: text/plain; charset=UTF-8;
 name="sb.out.good"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="sb.out.good"

magicnum = 0x58465342
blocksize = 4096
dblocks = 1465036800
rblocks = 0
rextents = 0
uuid = e6a93d7b-44e9-44d4-8ead-520574c585b3
logstart = 1073741832
rootino = 1024
rbmino = 1025
rsumino = 1026
rextsize = 1
agblocks = 45782272
agcount = 33
rbmblocks = 0
logblocks = 521728
versionnum = 0xb5b5
sectsize = 512
inodesize = 512
inopblock = 8
fname = "\000\000\000\000\000\000\000\000\000\000\000\000"
blocklog = 12
sectlog = 9
inodelog = 9
inopblog = 3
agblklog = 26
rextslog = 0
inprogress = 0
imax_pct = 5
icount = 2193792
ifree = 10348
fdblocks = 195710374
frextents = 0
uquotino = null
gquotino = null
qflags = 0
flags = 0
shared_vn = 0
inoalignmt = 4
unit = 128
width = 384
dirblklog = 0
logsectlog = 0
logsectsize = 0
logsunit = 32768
features2 = 0x18a
bad_features2 = 0x18a
features_compat = 0
features_ro_compat = 0x1
features_incompat = 0x1
features_log_incompat = 0
crc = 0xa8542033 (correct)
spino_align = 0
pquotino = null
lsn = 0x1f00056cc0
meta_uuid = 00000000-0000-0000-0000-000000000000

--------------AF0F563E380276EB9C67B0D1
Content-Type: text/plain; charset=UTF-8;
 name="strace.2"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="strace.2"

execve("/sbin/xfs_repair", ["xfs_repair", "-L", "/dev/md2"], [/* 45 vars */]) = 0
brk(NULL)                               = 0x23b0000
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fba7739a000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=266558, ...}) = 0
mmap(NULL, 266558, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7fba77354000
close(3)                                = 0
open("/lib64/libxfs.so.0", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\340\363\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=427944, ...}) = 0
mmap(NULL, 2523896, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fba76f04000
mprotect(0x7fba76f68000, 2093056, PROT_NONE) = 0
mmap(0x7fba77167000, 24576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x63000) = 0x7fba77167000
close(3)                                = 0
open("/lib64/libxlog.so.0", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\260\21\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=22504, ...}) = 0
mmap(NULL, 2118192, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fba76cfc000
mprotect(0x7fba76d00000, 2097152, PROT_NONE) = 0
mmap(0x7fba76f00000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x4000) = 0x7fba76f00000
close(3)                                = 0
open("/lib64/libxcmd.so.0", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\240'\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=31064, ...}) = 0
mmap(NULL, 2132616, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fba76aec000
mprotect(0x7fba76af3000, 2093056, PROT_NONE) = 0
mmap(0x7fba76cf2000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x6000) = 0x7fba76cf2000
mmap(0x7fba76cf4000, 2696, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7fba76cf4000
close(3)                                = 0
open("/lib64/libuuid.so.1", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\20\26\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=18808, ...}) = 0
mmap(NULL, 2113944, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fba768e4000
mprotect(0x7fba768e8000, 2093056, PROT_NONE) = 0
mmap(0x7fba76ae7000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x3000) = 0x7fba76ae7000
close(3)                                = 0
open("/lib64/librt.so.1", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\20!\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=31400, ...}) = 0
mmap(NULL, 2128864, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fba766dc000
mprotect(0x7fba766e2000, 2097152, PROT_NONE) = 0
mmap(0x7fba768e2000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x6000) = 0x7fba768e2000
close(3)                                = 0
open("/lib64/libpthread.so.0", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\0a\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=133424, ...}) = 0
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fba77352000
mmap(NULL, 2208872, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fba764bc000
mprotect(0x7fba764d3000, 2093056, PROT_NONE) = 0
mmap(0x7fba766d2000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x16000) = 0x7fba766d2000
mmap(0x7fba766d4000, 13416, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7fba766d4000
close(3)                                = 0
open("/lib64/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\320\3\2\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=1644376, ...}) = 0
mmap(NULL, 3751256, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fba76124000
mprotect(0x7fba762ae000, 2097152, PROT_NONE) = 0
mmap(0x7fba764ae000, 24576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x18a000) = 0x7fba764ae000
mmap(0x7fba764b4000, 15704, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7fba764b4000
close(3)                                = 0
open("/lib64/libblkid.so.1", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\240\221\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=279216, ...}) = 0
mmap(NULL, 2379488, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fba75edc000
mprotect(0x7fba75f1c000, 2093056, PROT_NONE) = 0
mmap(0x7fba7611b000, 20480, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x3f000) = 0x7fba7611b000
mmap(0x7fba76120000, 3808, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7fba76120000
close(3)                                = 0
open("/lib64/libreadline.so.7", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0pp\1\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0555, st_size=309208, ...}) = 0
mmap(NULL, 2410600, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fba75c8c000
mprotect(0x7fba75ccf000, 2097152, PROT_NONE) = 0
mmap(0x7fba75ecf000, 36864, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x43000) = 0x7fba75ecf000
mmap(0x7fba75ed8000, 2152, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7fba75ed8000
close(3)                                = 0
open("/lib64/libncurses.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\220X\1\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=378584, ...}) = 0
mmap(NULL, 2476432, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fba75a2c000
mprotect(0x7fba75a83000, 2097152, PROT_NONE) = 0
mmap(0x7fba75c83000, 20480, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x57000) = 0x7fba75c83000
mmap(0x7fba75c88000, 2448, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7fba75c88000
close(3)                                = 0
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fba77350000
arch_prctl(ARCH_SET_FS, 0x7fba77351580) = 0
mprotect(0x7fba764ae000, 16384, PROT_READ) = 0
mprotect(0x7fba75c83000, 16384, PROT_READ) = 0
mprotect(0x7fba75ecf000, 8192, PROT_READ) = 0
mprotect(0x7fba76ae7000, 4096, PROT_READ) = 0
mprotect(0x7fba7611b000, 16384, PROT_READ) = 0
mprotect(0x7fba766d2000, 4096, PROT_READ) = 0
mprotect(0x7fba768e2000, 4096, PROT_READ) = 0
mprotect(0x7fba77167000, 8192, PROT_READ) = 0
mprotect(0x7fba76cf2000, 4096, PROT_READ) = 0
mprotect(0x7fba76f00000, 4096, PROT_READ) = 0
mprotect(0x641000, 4096, PROT_READ)     = 0
mprotect(0x7fba77396000, 4096, PROT_READ) = 0
munmap(0x7fba77354000, 266558)          = 0
set_tid_address(0x7fba77351850)         = 8468
set_robust_list(0x7fba77351860, 24)     = 0
rt_sigaction(SIGRTMIN, {sa_handler=0x7fba764c1ba8, sa_mask=[], sa_flags=SA_RESTORER|SA_SIGINFO, sa_restorer=0x7fba764cce20}, NULL, 8) = 0
rt_sigaction(SIGRT_1, {sa_handler=0x7fba764c1c30, sa_mask=[], sa_flags=SA_RESTORER|SA_RESTART|SA_SIGINFO, sa_restorer=0x7fba764cce20}, NULL, 8) = 0
rt_sigprocmask(SIG_UNBLOCK, [RTMIN RT_1], NULL, 8) = 0
getrlimit(RLIMIT_STACK, {rlim_cur=8192*1024, rlim_max=RLIM64_INFINITY}) = 0
brk(NULL)                               = 0x23b0000
brk(0x23d1000)                          = 0x23d1000
open("/usr/lib64/locale/locale-archive", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=3986544, ...}) = 0
mmap(NULL, 3986544, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7fba7565c000
close(3)                                = 0
open("/usr/share/locale/locale.alias", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=2997, ...}) = 0
read(3, "# Locale name alias data base.\n#"..., 4096) = 2997
read(3, "", 4096)                       = 0
close(3)                                = 0
open("/usr/share/locale/en_US.utf8/LC_MESSAGES/xfsprogs.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
open("/usr/share/locale/en_US/LC_MESSAGES/xfsprogs.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
open("/usr/share/locale/en.utf8/LC_MESSAGES/xfsprogs.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
open("/usr/share/locale/en/LC_MESSAGES/xfsprogs.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
getcwd("/sys/devices/virtual/block/md2/md", 4096) = 34
stat("/dev/md2", {st_mode=S_IFBLK|0660, st_rdev=makedev(9, 2), ...}) = 0
stat("/dev/md2", {st_mode=S_IFBLK|0660, st_rdev=makedev(9, 2), ...}) = 0
access("/proc/mounts", R_OK)            = 0
open("/proc/mounts", O_RDONLY|O_CLOEXEC) = 3
futex(0x7fba764b5268, FUTEX_WAKE_PRIVATE, 2147483647) = 0
fstat(3, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
read(3, "/dev/root / xfs rw,noatime,attr2"..., 1024) = 1024
stat("/", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
stat("/dev", {st_mode=S_IFDIR|0755, st_size=4160, ...}) = 0
stat("/proc", {st_mode=S_IFDIR|0555, st_size=0, ...}) = 0
stat("/run", {st_mode=S_IFDIR|0755, st_size=780, ...}) = 0
stat("/dev/mqueue", {st_mode=S_IFDIR|S_ISVTX|0777, st_size=40, ...}) = 0
stat("/dev/pts", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
stat("/dev/shm", {st_mode=S_IFDIR|S_ISVTX|0777, st_size=40, ...}) = 0
stat("/sys", {st_mode=S_IFDIR|0555, st_size=0, ...}) = 0
stat("/sys/kernel/debug", {st_mode=S_IFDIR|0700, st_size=0, ...}) = 0
stat("/sys/fs/pstore", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
stat("/sys/fs/cgroup", {st_mode=S_IFDIR|0755, st_size=140, ...}) = 0
stat("/sys/fs/cgroup/openrc", {st_mode=S_IFDIR|0555, st_size=0, ...}) = 0
stat("/sys/fs/cgroup/cpuset", {st_mode=S_IFDIR|0555, st_size=0, ...}) = 0
stat("/sys/fs/cgroup/cpu", {st_mode=S_IFDIR|0555, st_size=0, ...}) = 0
read(3, "atime,cpuacct 0 0\nfreezer /sys/f"..., 1024) = 889
stat("/sys/fs/cgroup/cpuacct", {st_mode=S_IFDIR|0555, st_size=0, ...}) = 0
stat("/sys/fs/cgroup/freezer", {st_mode=S_IFDIR|0555, st_size=0, ...}) = 0
stat("/proc/sys/fs/binfmt_misc", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
stat("/var/lib/nfs/rpc_pipefs", {st_mode=S_IFDIR|0555, st_size=0, ...}) = 0
stat("/proc/fs/nfsd", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
stat("/mnt/md4", {st_mode=S_IFDIR|0755, st_size=36, ...}) = 0
stat("/mnt/md1", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
stat("/mnt/md3", {st_mode=S_IFDIR|0775, st_size=4096, ...}) = 0
stat("/mnt/md5", {st_mode=S_IFDIR|0755, st_size=37, ...}) = 0
stat("/export/md1", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
stat("/export/md3", {st_mode=S_IFDIR|0775, st_size=4096, ...}) = 0
stat("/export/md4", {st_mode=S_IFDIR|0755, st_size=36, ...}) = 0
stat("/export/md5", {st_mode=S_IFDIR|0755, st_size=37, ...}) = 0
read(3, "", 1024)                       = 0
close(3)                                = 0
open("/dev/md2", O_RDONLY)              = 3
stat("/dev/md2", {st_mode=S_IFBLK|0660, st_rdev=makedev(9, 2), ...}) = 0
stat("/dev/md2", {st_mode=S_IFBLK|0660, st_rdev=makedev(9, 2), ...}) = 0
access("/proc/mounts", R_OK)            = 0
open("/proc/mounts", O_RDONLY|O_CLOEXEC) = 4
fstat(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
read(4, "/dev/root / xfs rw,noatime,attr2"..., 1024) = 1024
stat("/", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
stat("/dev", {st_mode=S_IFDIR|0755, st_size=4160, ...}) = 0
stat("/proc", {st_mode=S_IFDIR|0555, st_size=0, ...}) = 0
stat("/run", {st_mode=S_IFDIR|0755, st_size=780, ...}) = 0
stat("/dev/mqueue", {st_mode=S_IFDIR|S_ISVTX|0777, st_size=40, ...}) = 0
stat("/dev/pts", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
stat("/dev/shm", {st_mode=S_IFDIR|S_ISVTX|0777, st_size=40, ...}) = 0
stat("/sys", {st_mode=S_IFDIR|0555, st_size=0, ...}) = 0
stat("/sys/kernel/debug", {st_mode=S_IFDIR|0700, st_size=0, ...}) = 0
stat("/sys/fs/pstore", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
stat("/sys/fs/cgroup", {st_mode=S_IFDIR|0755, st_size=140, ...}) = 0
stat("/sys/fs/cgroup/openrc", {st_mode=S_IFDIR|0555, st_size=0, ...}) = 0
stat("/sys/fs/cgroup/cpuset", {st_mode=S_IFDIR|0555, st_size=0, ...}) = 0
stat("/sys/fs/cgroup/cpu", {st_mode=S_IFDIR|0555, st_size=0, ...}) = 0
read(4, "atime,cpuacct 0 0\nfreezer /sys/f"..., 1024) = 889
stat("/sys/fs/cgroup/cpuacct", {st_mode=S_IFDIR|0555, st_size=0, ...}) = 0
stat("/sys/fs/cgroup/freezer", {st_mode=S_IFDIR|0555, st_size=0, ...}) = 0
stat("/proc/sys/fs/binfmt_misc", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
stat("/var/lib/nfs/rpc_pipefs", {st_mode=S_IFDIR|0555, st_size=0, ...}) = 0
stat("/proc/fs/nfsd", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
stat("/mnt/md4", {st_mode=S_IFDIR|0755, st_size=36, ...}) = 0
stat("/mnt/md1", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
stat("/mnt/md3", {st_mode=S_IFDIR|0775, st_size=4096, ...}) = 0
stat("/mnt/md5", {st_mode=S_IFDIR|0755, st_size=37, ...}) = 0
stat("/export/md1", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
stat("/export/md3", {st_mode=S_IFDIR|0775, st_size=4096, ...}) = 0
stat("/export/md4", {st_mode=S_IFDIR|0755, st_size=36, ...}) = 0
stat("/export/md5", {st_mode=S_IFDIR|0755, st_size=37, ...}) = 0
read(4, "", 1024)                       = 0
close(4)                                = 0
open("/dev/md2", O_RDWR|O_EXCL|O_DIRECT) = 4
fstat(4, {st_mode=S_IFBLK|0660, st_rdev=makedev(9, 2), ...}) = 0
fstat(4, {st_mode=S_IFBLK|0660, st_rdev=makedev(9, 2), ...}) = 0
ioctl(4, BLKGETSIZE64, [6000790732800]) = 0
ioctl(4, BLKSSZGET, [512])              = 0
chdir("/sys/devices/virtual/block/md2/md") = 0
close(3)                                = 0
getrlimit(RLIMIT_FSIZE, {rlim_cur=RLIM64_INFINITY, rlim_max=RLIM64_INFINITY}) = 0
write(2, "Phase 1 - find and verify superb"..., 40Phase 1 - find and verify superblock...
) = 40
mmap(NULL, 528384, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fba772cf000
mmap(NULL, 528384, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fba7724e000
lseek(4, 0, SEEK_SET)                   = 0
read(4, "XFSB\0\0\20\0\0\0\0\0WR\260\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 524288) = 524288
munmap(0x7fba7724e000, 528384)          = 0
brk(0x2405000)                          = 0x2405000
lseek(4, 187524186112, SEEK_SET)        = 187524186112
read(4, "XFSB\0\0\20\0\0\0\0\0WR\260\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 131072) = 131072
lseek(4, 375048372224, SEEK_SET)        = 375048372224
read(4, "XFSB\0\0\20\0\0\0\0\0WR\260\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 131072) = 131072
lseek(4, 562572558336, SEEK_SET)        = 562572558336
read(4, "XFSB\0\0\20\0\0\0\0\0WR\260\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 131072) = 131072
lseek(4, 750096744448, SEEK_SET)        = 750096744448
read(4, "XFSB\0\0\20\0\0\0\0\0WR\260\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 131072) = 131072
lseek(4, 937620930560, SEEK_SET)        = 937620930560
read(4, "XFSB\0\0\20\0\0\0\0\0WR\260\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 131072) = 131072
lseek(4, 1125145116672, SEEK_SET)       = 1125145116672
read(4, "XFSB\0\0\20\0\0\0\0\0WR\260\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 131072) = 131072
lseek(4, 1312669302784, SEEK_SET)       = 1312669302784
read(4, "XFSB\0\0\20\0\0\0\0\0WR\260\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 131072) = 131072
lseek(4, 1500193488896, SEEK_SET)       = 1500193488896
read(4, "XFSB\0\0\20\0\0\0\0\0WR\260\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 131072) = 131072
lseek(4, 1687717675008, SEEK_SET)       = 1687717675008
read(4, "XFSB\0\0\20\0\0\0\0\0WR\260\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 131072) = 131072
lseek(4, 1875241861120, SEEK_SET)       = 1875241861120
read(4, "XFSB\0\0\20\0\0\0\0\0WR\260\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 131072) = 131072
lseek(4, 2062766047232, SEEK_SET)       = 2062766047232
read(4, "XFSB\0\0\20\0\0\0\0\0WR\260\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 131072) = 131072
lseek(4, 2250290233344, SEEK_SET)       = 2250290233344
read(4, "XFSB\0\0\20\0\0\0\0\0WR\260\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 131072) = 131072
lseek(4, 2437814419456, SEEK_SET)       = 2437814419456
read(4, "XFSB\0\0\20\0\0\0\0\0WR\260\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 131072) = 131072
lseek(4, 2625338605568, SEEK_SET)       = 2625338605568
read(4, "XFSB\0\0\20\0\0\0\0\0WR\260\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 131072) = 131072
lseek(4, 2812862791680, SEEK_SET)       = 2812862791680
read(4, "XFSB\0\0\20\0\0\0\0\0WR\260\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 131072) = 131072
lseek(4, 3000386977792, SEEK_SET)       = 3000386977792
read(4, "XFSB\0\0\20\0\0\0\0\0WR\260\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 131072) = 131072
lseek(4, 3187911163904, SEEK_SET)       = 3187911163904
read(4, "XFSB\0\0\20\0\0\0\0\0WR\260\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 131072) = 131072
lseek(4, 3375435350016, SEEK_SET)       = 3375435350016
read(4, "XFSB\0\0\20\0\0\0\0\0WR\260\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 131072) = 131072
lseek(4, 3562959536128, SEEK_SET)       = 3562959536128
read(4, "XFSB\0\0\20\0\0\0\0\0WR\260\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 131072) = 131072
lseek(4, 3750483722240, SEEK_SET)       = 3750483722240
read(4, "XFSB\0\0\20\0\0\0\0\0WR\260\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 131072) = 131072
lseek(4, 3938007908352, SEEK_SET)       = 3938007908352
read(4, "XFSB\0\0\20\0\0\0\0\0WR\260\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 131072) = 131072
lseek(4, 4125532094464, SEEK_SET)       = 4125532094464
read(4, "XFSB\0\0\20\0\0\0\0\0WR\260\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 131072) = 131072
lseek(4, 4313056280576, SEEK_SET)       = 4313056280576
read(4, "XFSB\0\0\20\0\0\0\0\0WR\260\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 131072) = 131072
lseek(4, 4500580466688, SEEK_SET)       = 4500580466688
read(4, "XFSB\0\0\20\0\0\0\0\0WR\260\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 131072) = 131072
lseek(4, 4688104652800, SEEK_SET)       = 4688104652800
read(4, "XFSB\0\0\20\0\0\0\0\0WR\260\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 131072) = 131072
lseek(4, 4875628838912, SEEK_SET)       = 4875628838912
read(4, "XFSB\0\0\20\0\0\0\0\0WR\260\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 131072) = 131072
lseek(4, 5063153025024, SEEK_SET)       = 5063153025024
read(4, "XFSB\0\0\20\0\0\0\0\0WR\260\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 131072) = 131072
lseek(4, 5250677211136, SEEK_SET)       = 5250677211136
read(4, "XFSB\0\0\20\0\0\0\0\0WR\260\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 131072) = 131072
lseek(4, 5438201397248, SEEK_SET)       = 5438201397248
read(4, "XFSB\0\0\20\0\0\0\0\0WR\260\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 131072) = 131072
lseek(4, 5625725583360, SEEK_SET)       = 5625725583360
read(4, "XFSB\0\0\20\0\0\0\0\0WR\260\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 131072) = 131072
lseek(4, 5813249769472, SEEK_SET)       = 5813249769472
read(4, "XFSB\0\0\20\0\0\0\0\0WR\260\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 131072) = 131072
lseek(4, 6000773955584, SEEK_SET)       = 6000773955584
read(4, "XFSB\0\0\20\0\0\0\0\0WR\260\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 131072) = 131072
munmap(0x7fba772cf000, 528384)          = 0
lseek(4, 0, SEEK_SET)                   = 0
read(4, "XFSB\0\0\20\0\0\0\0\0WR\260\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 32768) = 32768
fstat(4, {st_mode=S_IFBLK|0660, st_rdev=makedev(9, 2), ...}) = 0
pread64(4, "\300(\337*\0\352\377\377\370(\337*\0\352\377\3770)\337*\0\352\377\377h)\337*\0\352\377\377"..., 512, 6000790732288) = 512
open("/sys/devices/system/cpu/online", O_RDONLY|O_CLOEXEC) = 3
read(3, "0-31\n", 8192)                 = 5
close(3)                                = 0
rt_sigprocmask(SIG_BLOCK, [HUP ALRM], NULL, 8) = 0
mmap(NULL, 8392704, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS|MAP_STACK, -1, 0) = 0x7fba74e5b000
mprotect(0x7fba74e5b000, 4096, PROT_NONE) = 0
clone(child_stack=0x7fba7565af70, flags=CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|CLONE_SYSVSEM|CLONE_SETTLS|CLONE_PARENT_SETTID|CLONE_CHILD_CLEARTID, parent_tidptr=0x7fba7565b9d0, tls=0x7fba7565b700, child_tidptr=0x7fba7565b9d0) = 8470
write(2, "        - reporting progress in "..., 56        - reporting progress in intervals of 15 minutes
) = 56
sysinfo({uptime=1244, loads=[144896, 127456, 91808], totalram=67677233152, freeram=66634776576, sharedram=1163264, bufferram=7335936, totalswap=10737414144, freeswap=10737414144, procs=512, totalhigh=0, freehigh=0, mem_unit=1}) = 0
getrlimit(RLIMIT_AS, {rlim_cur=RLIM64_INFINITY, rlim_max=RLIM64_INFINITY}) = 0
mmap(NULL, 48795648, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fba71fd2000
write(2, "Phase 2 - using internal log\n", 29Phase 2 - using internal log
) = 29
write(2, "        - zero log...\n", 22        - zero log...
) = 22
pread64(4, "\376\355\272\276\0\0\0\1\0\0\0\2\0\0~\0\0\0\0\1\0\0\0\0\0\0\0\1\0\0\0\0"..., 512, 3000387010560) = 512
pread64(4, "\0\0\0\36\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 512, 3002524007936) = 512
pread64(4, "\376\355\272\276\0\0\0\1\0\0\0\2\0\0~\0\0\0\0\1\0\0\0\0\0\0\0\1\0\0\0\0"..., 512, 3000387010560) = 512
pread64(4, "\0\0\0\36\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 512, 3002524007936) = 512
pread64(4, "\0\0\0\36\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 512, 3001455508992) = 512
pread64(4, "\0\0\0\36\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 512, 3000921259520) = 512
pread64(4, "\0\0\0\36\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 512, 3000654134784) = 512
pread64(4, "\0\0\0\36\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 512, 3000520572416) = 512
pread64(4, "\0\0\0\36\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 512, 3000453791232) = 512
pread64(4, "\0\0\0\36\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 512, 3000420400640) = 512
pread64(4, "\0\0\0\36\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 512, 3000403705344) = 512
pread64(4, "\0\0\0\36\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 512, 3000395357696) = 512
pread64(4, "\0\0\0\36\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 512, 3000391183872) = 512
pread64(4, "\0\0\0\36\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 512, 3000389096960) = 512
pread64(4, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 512, 3000388053504) = 512
pread64(4, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 512, 3000388575232) = 512
pread64(4, "\0\0\0\36\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 512, 3000388835840) = 512
pread64(4, "\0\0\0\36\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 512, 3000388705280) = 512
pread64(4, "\0\0\0\36\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 512, 3000388640256) = 512
pread64(4, "\0\0\0\36\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 512, 3000388607488) = 512
pread64(4, "\0\0\0\36\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 512, 3000388591104) = 512
pread64(4, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 512, 3000388582912) = 512
pread64(4, "\0\0\0\36\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 512, 3000388587008) = 512
pread64(4, "\0\0\0\36\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 512, 3000388584960) = 512
pread64(4, "\0\0\0\36\0\0\0\10\252 \0\0nU\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 512, 3000388583936) = 512
pread64(4, "\376\355\272\276\0\0\0\36\0\0\0\2\0\0~\0\0\0\0\36\0\0\f\0\0\0\0\36\0\0\v\300"..., 512, 3000388583424) = 512
mmap(NULL, 1052672, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fba7724f000
pread64(4, "\376\355\272\276\0\0\0\36\0\0\0\2\0\0~\0\0\0\0\36\0?\254\0\0\0\0\36\0?\253\300"..., 524288, 3002523484160) = 524288
munmap(0x7fba7724f000, 1052672)         = 0
brk(0x24e6000)                          = 0x24e6000
pread64(4, 0x23c5200, 1048576, 3000387010560) = -1 EIO (Input/output error)
open("/usr/share/locale/en_US.utf8/LC_MESSAGES/libc.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
open("/usr/share/locale/en_US/LC_MESSAGES/libc.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
open("/usr/share/locale/en.utf8/LC_MESSAGES/libc.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
open("/usr/share/locale/en/LC_MESSAGES/libc.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
write(2, "xfs_repair: read failed: Input/o"..., 44xfs_repair: read failed: Input/output error
) = 44
write(2, "failed to find log head", 23failed to find log head) = 23
write(2, "\n", 1
)                       = 1
write(2, "zero_log: cannot find log head/t"..., 56zero_log: cannot find log head/tail (xlog_find_tail=-5)
) = 56
exit_group(2)                           = ?
+++ exited with 2 +++

--------------AF0F563E380276EB9C67B0D1--
