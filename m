Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAR7PwDE022476 for <xfs@oss.sgi.com>; Tue, 27 Nov 2012 01:25:58 -0600
Received: from fgwmail5.fujitsu.co.jp (fgwmail5.fujitsu.co.jp [192.51.44.35])
	by cuda.sgi.com with ESMTP id YDAim1H5RsmlxJiJ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 26 Nov 2012 23:28:07 -0800 (PST)
Received: from m3.gw.fujitsu.co.jp (unknown [10.0.50.73])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 9120E3EE081
	for <xfs@oss.sgi.com>; Tue, 27 Nov 2012 16:28:05 +0900 (JST)
Received: from smail (m3 [127.0.0.1])
	by outgoing.m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 6D30145DEB5
	for <xfs@oss.sgi.com>; Tue, 27 Nov 2012 16:28:05 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 5610A45DEB2
	for <xfs@oss.sgi.com>; Tue, 27 Nov 2012 16:28:05 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 3C6E11DB8038
	for <xfs@oss.sgi.com>; Tue, 27 Nov 2012 16:28:05 +0900 (JST)
Received: from g01jpexchkw02.g01.fujitsu.local
	(g01jpexchkw02.g01.fujitsu.local [10.0.194.41])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id EC15E1DB803B
	for <xfs@oss.sgi.com>; Tue, 27 Nov 2012 16:28:04 +0900 (JST)
Message-ID: <50B46B66.2040908@jp.fujitsu.com>
Date: Tue, 27 Nov 2012 16:27:34 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [BUG] xfs_quota: can't handle the users managed by LDAP
References: <50ADB27F.8070806@jp.fujitsu.com> <20121122233757.GY2591@dastard>
	<50B32CC1.3020907@jp.fujitsu.com> <50B4198E.7080408@jp.fujitsu.com>
	<20121127025728.GU32450@dastard>
In-Reply-To: <20121127025728.GU32450@dastard>
Content-Type: multipart/mixed; boundary="------------040503090304040803060904"
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
Cc: xfs ML <xfs@oss.sgi.com>

--------------040503090304040803060904
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

>>>>> Current xfs_quota (I pulled xfsprogs today) seems not be able to the users
>>>>> managed by LDAP. There is no patch since I'm not good at LDAP and don't know
>>>>> the root cause yet ;-(
>>>>>
>>>>> Step to reproduce(in this case, "sat" is the user managed by LDAP):
>>>>> ===============================================================================
>>>>> # uname -r
>>>>> 3.7.0-rc5
>>>>> # mount -o loop,usrquota xfs.img mnt
>>>>> # xfsprogs/quota/xfs_quota -xc "limit bsoft=10M bhard=10M sat" /dev/loop0
>>>>> xfs_quota: invalid user name: sat                                          # denied
>>>>> # su sat
>>>>> $                                                                          # But this user acutally exists.
>>>>> ===============================================================================
>>>>>
>>>>> The kernel is a bit old, but I suspect this is a userland problem.
>>>>
>>>> Yes, userland.
>>>>
>>>> However, xfs_quota is not supposed to know about LDAP, or NIS, or
>>>> any other user database. It uses the getpwnam() to convert the user
>>>> name to a UID, and that call is failing to find "sat". This is
>>>> supposed to work with LDAP (as mentioned in the man page), and if it
>>>> isn't it generally means something is broken with your LDAP setup
>>>> (/etc/nsswitch.conf not correct?) rather than there being something
>>>> wrong with xfs_quota....
>>>
>>> Probably this behaivor comes from the difference between the test machine
>>> and the build machine which I built the upstream xfsprogs.
>>>
>>> I made the following simple program which just calls getpwnam().
>>>
>>> ===============================================================================
>>> #include <sys/types.h>
>>> #include <pwd.h>
>>> #include <err.h>
>>> #include <stdio.h>
>>> #include <stdlib.h>
>>>
>>> int main(void)
>>> {
>>>         struct passwd *p;
>>>         if ((p = getpwnam("sat")) == NULL)
>>>                 err(EXIT_FAILURE, "getpwnam() failed.");
>>>         printf("name = %s, id = %d\n", p->pw_name, p->pw_uid);
>>>         exit(EXIT_SUCCESS);
>>> }
>>> ===============================================================================
>>>
>>> Here is the result of this problem at the test machine.
>>>
>>>  - SUCCEEDED: build at the test machine
>>>  - FAILED: built at the build machine
>>>
>>> I will build xfsprogs at the test machine and confirm whether this behavior
>>> (getpwnam() fails) happens or not again.
>>
>> I retried the step to reproduce and encountered the anotehr behavior with the
>> newest xfsprogs built at the test machine. In this test, getpwnam()
>> worked fine, but quota didn't work for LDAP user.
>>
>> test result("testquota" is local user and "sat" is LDAP user here):
>> ===============================================================================
>> # mount -t xfs -o loop,usrquota xfs.img mnt
>> # ~sat/src/xfsprogs/quota/xfs_quota -xc "report -h" /dev/loop0
>> User quota on /home/sat/work/xfs/mnt (/dev/loop0)
>>                         Blocks              
>> User ID      Used   Soft   Hard Warn/Grace   
>> ---------- --------------------------------- 
>> root            0      0      0  00 [------]    # There is no limit yet
>>
>> # ~sat/src/xfsprogs/quota/xfs_quota -xc "limit bsoft=10M bhard=10M testquota" /dev/loop0
>> # echo $?
>> 0
>> # ~sat/src/xfsprogs/quota/xfs_quota -xc "report -h" /dev/loop0
>> User quota on /home/sat/work/xfs/mnt (/dev/loop0)
>>                         Blocks              
>> User ID      Used   Soft   Hard Warn/Grace   
>> ---------- --------------------------------- 
>> root            0      0      0  00 [------]
>> testquota       0    10M    10M  00 [------]     # limit to local user works fine
>> # ~sat/src/xfsprogs/quota/xfs_quota -xc "limit bsoft=10M bhard=10M sat" /dev/loop0
>> # echo $?
>> 0
>> # ~sat/src/xfsprogs/quota/xfs_quota -xc "report -h" /dev/loop0
>> User quota on /home/sat/work/xfs/mnt (/dev/loop0)
>>                         Blocks              
>> User ID      Used   Soft   Hard Warn/Grace   
>> ---------- --------------------------------- 
>> root            0      0      0  00 [------]
>> testquota       0    10M    10M  00 [------]      # limit to LDAP user does not work although xfs_quota returns 0
>> ===============================================================================
>>
>> I tried it with real partition rather than loopback device, but the result
>> was the same.
> 
> Can you strace the limit set and report of the ldap user and attach
> it? that will tell us directly whether xfs_quota saw the ldap user
> or not as we'll see a quotactl() being issued.
> 
> Also, instead of using a user name, can you  find out the user ID of
> "sat" and use "report -U <uid + 1> -h" so avoid the getpwent lookup
> and just report raw quota ids?

I found the root cause is in my nsswitch.conf or LDAP config as
you said. I'm sorry.

I attached these files.

 - limit.log:  strace log about "limit" subcommand
 - report.log: strace log about "report -h -U" subcommand
 - report_without_U: strace log about "report -h" subcommand

command log:
===============================================================================
# id sat
uid=507(sat) gid=507(sat) groups=507(sat)
# mount -o loop,usrquota xfs.img mnt
# ~sat/src/xfsprogs/quota/xfs_quota -xc "report -h" /dev/loop0
User quota on /home/sat/work/xfs/mnt (/dev/loop0)
                        Blocks              
User ID      Used   Soft   Hard Warn/Grace   
---------- --------------------------------- 
root            0      0      0  00 [------] # no limit yet

# strace -o limit.log ~sat/src/xfsprogs/quota/xfs_quota -xc "limit bsoft=10M bhard=10M 507" /dev/loop0 
# echo $?
0
# strace -o report.log ~sat/src/xfsprogs/quota/xfs_quota -xc "report -U 508 -h" /dev/loop0
User quota on /home/sat/work/xfs/mnt (/dev/loop0)
                        Blocks              
User ID      Used   Soft   Hard Warn/Grace   
---------- --------------------------------- 
#0              0      0      0  00 [------]
#507            0    10M    10M  00 [------]   # sat(uid=507) is here!

# ~sat/src/xfsprogs/quota/xfs_quota -xc "report -h" /dev/loop0
User quota on /home/sat/work/xfs/mnt (/dev/loop0)
                        Blocks              
User ID      Used   Soft   Hard Warn/Grace   
---------- --------------------------------- 
root            0      0      0  00 [------]    # doesn't show correctly
===============================================================================

I also confirmed xfs_quota -xc "limit ... sat" works.

===============================================================================
# ~sat/src/xfsprogs/quota/xfs_quota -xc "report -h" /dev/loop0
User quota on /home/sat/work/xfs/mnt (/dev/loop0)
                        Blocks              
User ID      Used   Soft   Hard Warn/Grace   
---------- --------------------------------- 
root            0      0      0  00 [------]

# ~sat/src/xfsprogs/quota/xfs_quota -xc "limit bsoft=10M bhard=10M sat" /dev/loop0
# echo $?
0
# ~sat/src/xfsprogs/quota/xfs_quota -xc "report -h -U 508" /dev/loop0
User quota on /home/sat/work/xfs/mnt (/dev/loop0)
                        Blocks              
User ID      Used   Soft   Hard Warn/Grace   
---------- --------------------------------- 
#0              0      0      0  00 [------]
#507            0    10M    10M  00 [------]    # sat(uid=507) is here.

# ~sat/src/xfsprogs/quota/xfs_quota -xc "report -h" /dev/loop0
User quota on /home/sat/work/xfs/mnt (/dev/loop0)
                        Blocks              
User ID      Used   Soft   Hard Warn/Grace   
---------- --------------------------------- 
root            0      0      0  00 [------]    # doesn't show correctly
===============================================================================

So there is a problem in "report" subcommand. Refer to report_without_U.log,
I found "quotactl(Q_XGETQUOTA|GRPQUOTA, ...) is only called for local users
and it's because that getpwent() only returned only local users.

Thanks,
Satoru


--------------040503090304040803060904
Content-Type: text/plain; charset="Shift_JIS"; name="limit.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="limit.log"

execve("/home/sat/src/xfsprogs/quota/xfs_quota", ["/home/sat/src/xfsprogs/quota/xfs"..., "-xc", "limit bsoft=10M bhard=10M 507", "/dev/loop0"], [/* 31 vars */]) = 0
brk(0)                                  = 0x28a9000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f7adab02000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=101268, ...}) = 0
mmap(NULL, 101268, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f7adaae9000
close(3)                                = 0
open("/lib64/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0@\30\"\3118\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=2065560, ...}) = 0
mmap(0x38c9200000, 3892376, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x38c9200000
mprotect(0x38c93ac000, 2097152, PROT_NONE) = 0
mmap(0x38c95ac000, 24576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1ac000) = 0x38c95ac000
mmap(0x38c95b2000, 17560, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x38c95b2000
close(3)                                = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f7adaae8000
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f7adaae6000
arch_prctl(ARCH_SET_FS, 0x7f7adaae6740) = 0
mprotect(0x38c95ac000, 16384, PROT_READ) = 0
mprotect(0x612000, 4096, PROT_READ)     = 0
mprotect(0x38c8c1f000, 4096, PROT_READ) = 0
munmap(0x7f7adaae9000, 101268)          = 0
brk(0)                                  = 0x28a9000
brk(0x28ca000)                          = 0x28ca000
brk(0)                                  = 0x28ca000
access("/proc/self/mounts", R_OK)       = 0
open("/proc/self/mounts", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f7adab01000
read(3, "rootfs / rootfs rw 0 0\nproc /pro"..., 1024) = 1024
read(3, "es 0 0\ncgroup /sys/fs/cgroup/fre"..., 1024) = 990
stat("/home/sat/work/xfs/mnt", {st_mode=S_IFDIR|0755, st_size=6, ...}) = 0
close(3)                                = 0
munmap(0x7f7adab01000, 4096)            = 0
open("/etc/projects", O_RDONLY)         = -1 ENOENT (No such file or directory)
stat("/dev/loop0", {st_mode=S_IFBLK|0660, st_rdev=makedev(7, 0), ...}) = 0
quotactl(Q_XSETQLIM|USRQUOTA, "/dev/loop0", 507, {version=1, flags=XFS_USER_QUOTA, fieldmask=0xc, id=507, blk_hardlimit=20480, blk_softlimit=20480, ino_hardlimit=0, ino_softlimit=0, bcount=0, icount=0, ...}) = 0
exit_group(0)                           = ?
+++ exited with 0 +++

--------------040503090304040803060904
Content-Type: text/plain; charset="Shift_JIS"; name="report.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="report.log"

execve("/home/sat/src/xfsprogs/quota/xfs_quota", ["/home/sat/src/xfsprogs/quota/xfs"..., "-xc", "report -U 508 -h", "/dev/loop0"], [/* 31 vars */]) = 0
brk(0)                                  = 0x228b000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f7ca834b000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=101268, ...}) = 0
mmap(NULL, 101268, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f7ca8332000
close(3)                                = 0
open("/lib64/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0@\30\"\3118\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=2065560, ...}) = 0
mmap(0x38c9200000, 3892376, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x38c9200000
mprotect(0x38c93ac000, 2097152, PROT_NONE) = 0
mmap(0x38c95ac000, 24576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1ac000) = 0x38c95ac000
mmap(0x38c95b2000, 17560, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x38c95b2000
close(3)                                = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f7ca8331000
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f7ca832f000
arch_prctl(ARCH_SET_FS, 0x7f7ca832f740) = 0
mprotect(0x38c95ac000, 16384, PROT_READ) = 0
mprotect(0x612000, 4096, PROT_READ)     = 0
mprotect(0x38c8c1f000, 4096, PROT_READ) = 0
munmap(0x7f7ca8332000, 101268)          = 0
brk(0)                                  = 0x228b000
brk(0x22ac000)                          = 0x22ac000
brk(0)                                  = 0x22ac000
access("/proc/self/mounts", R_OK)       = 0
open("/proc/self/mounts", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f7ca834a000
read(3, "rootfs / rootfs rw 0 0\nproc /pro"..., 1024) = 1024
read(3, "es 0 0\ncgroup /sys/fs/cgroup/fre"..., 1024) = 990
stat("/home/sat/work/xfs/mnt", {st_mode=S_IFDIR|0755, st_size=6, ...}) = 0
close(3)                                = 0
munmap(0x7f7ca834a000, 4096)            = 0
open("/etc/projects", O_RDONLY)         = -1 ENOENT (No such file or directory)
stat("/dev/loop0", {st_mode=S_IFBLK|0660, st_rdev=makedev(7, 0), ...}) = 0
stat("/home/sat/work/xfs/mnt", {st_mode=S_IFDIR|0755, st_size=6, ...}) = 0
quotactl(Q_XQUOTASYNC|USRQUOTA, "/dev/loop0", 0, NULL) = 0
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 0, {version=1, flags=XFS_USER_QUOTA, fieldmask=0, id=0, blk_hardlimit=0, blk_softlimit=0, ino_hardlimit=0, ino_softlimit=0, bcount=0, icount=3, ...}) = 0
fstat(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 0), ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f7ca834a000
write(1, "User quota on /home/sat/work/xfs"..., 50) = 50
write(1, "                        Blocks  "..., 45) = 45
write(1, "User ID      Used   Soft   Hard "..., 46) = 46
write(1, "---------- ---------------------"..., 46) = 46
write(1, "#0              0      0      0 "..., 45) = 45
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 1, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 2, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 3, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 4, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 5, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 6, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 7, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 8, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 9, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 10, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 11, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 12, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 13, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 14, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 15, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 16, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 17, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 18, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 19, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 20, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 21, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 22, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 23, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 24, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 25, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 26, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 27, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 28, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 29, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 30, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 31, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 32, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 33, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 34, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 35, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 36, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 37, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 38, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 39, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 40, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 41, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 42, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 43, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 44, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 45, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 46, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 47, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 48, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 49, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 50, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 51, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 52, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 53, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 54, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 55, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 56, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 57, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 58, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 59, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 60, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 61, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 62, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 63, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 64, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 65, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 66, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 67, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 68, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 69, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 70, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 71, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 72, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 73, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 74, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 75, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 76, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 77, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 78, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 79, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 80, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 81, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 82, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 83, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 84, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 85, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 86, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 87, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 88, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 89, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 90, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 91, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 92, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 93, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 94, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 95, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 96, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 97, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 98, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 99, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 100, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 101, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 102, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 103, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 104, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 105, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 106, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 107, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 108, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 109, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 110, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 111, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 112, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 113, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 114, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 115, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 116, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 117, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 118, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 119, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 120, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 121, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 122, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 123, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 124, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 125, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 126, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 127, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 128, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 129, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 130, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 131, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 132, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 133, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 134, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 135, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 136, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 137, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 138, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 139, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 140, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 141, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 142, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 143, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 144, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 145, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 146, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 147, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 148, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 149, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 150, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 151, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 152, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 153, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 154, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 155, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 156, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 157, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 158, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 159, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 160, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 161, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 162, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 163, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 164, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 165, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 166, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 167, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 168, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 169, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 170, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 171, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 172, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 173, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 174, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 175, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 176, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 177, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 178, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 179, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 180, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 181, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 182, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 183, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 184, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 185, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 186, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 187, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 188, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 189, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 190, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 191, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 192, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 193, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 194, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 195, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 196, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 197, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 198, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 199, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 200, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 201, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 202, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 203, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 204, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 205, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 206, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 207, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 208, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 209, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 210, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 211, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 212, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 213, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 214, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 215, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 216, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 217, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 218, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 219, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 220, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 221, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 222, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 223, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 224, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 225, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 226, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 227, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 228, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 229, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 230, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 231, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 232, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 233, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 234, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 235, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 236, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 237, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 238, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 239, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 240, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 241, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 242, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 243, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 244, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 245, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 246, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 247, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 248, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 249, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 250, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 251, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 252, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 253, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 254, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 255, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 256, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 257, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 258, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 259, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 260, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 261, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 262, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 263, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 264, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 265, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 266, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 267, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 268, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 269, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 270, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 271, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 272, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 273, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 274, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 275, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 276, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 277, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 278, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 279, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 280, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 281, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 282, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 283, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 284, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 285, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 286, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 287, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 288, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 289, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 290, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 291, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 292, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 293, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 294, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 295, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 296, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 297, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 298, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 299, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 300, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 301, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 302, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 303, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 304, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 305, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 306, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 307, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 308, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 309, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 310, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 311, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 312, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 313, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 314, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 315, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 316, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 317, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 318, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 319, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 320, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 321, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 322, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 323, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 324, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 325, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 326, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 327, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 328, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 329, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 330, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 331, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 332, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 333, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 334, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 335, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 336, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 337, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 338, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 339, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 340, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 341, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 342, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 343, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 344, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 345, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 346, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 347, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 348, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 349, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 350, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 351, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 352, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 353, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 354, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 355, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 356, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 357, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 358, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 359, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 360, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 361, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 362, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 363, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 364, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 365, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 366, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 367, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 368, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 369, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 370, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 371, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 372, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 373, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 374, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 375, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 376, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 377, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 378, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 379, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 380, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 381, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 382, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 383, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 384, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 385, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 386, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 387, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 388, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 389, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 390, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 391, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 392, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 393, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 394, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 395, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 396, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 397, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 398, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 399, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 400, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 401, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 402, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 403, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 404, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 405, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 406, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 407, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 408, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 409, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 410, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 411, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 412, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 413, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 414, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 415, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 416, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 417, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 418, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 419, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 420, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 421, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 422, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 423, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 424, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 425, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 426, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 427, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 428, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 429, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 430, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 431, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 432, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 433, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 434, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 435, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 436, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 437, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 438, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 439, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 440, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 441, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 442, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 443, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 444, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 445, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 446, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 447, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 448, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 449, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 450, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 451, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 452, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 453, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 454, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 455, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 456, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 457, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 458, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 459, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 460, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 461, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 462, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 463, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 464, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 465, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 466, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 467, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 468, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 469, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 470, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 471, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 472, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 473, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 474, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 475, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 476, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 477, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 478, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 479, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 480, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 481, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 482, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 483, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 484, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 485, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 486, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 487, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 488, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 489, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 490, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 491, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 492, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 493, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 494, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 495, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 496, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 497, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 498, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 499, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 500, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 501, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 502, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 503, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 504, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 505, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 506, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 507, {version=1, flags=XFS_USER_QUOTA, fieldmask=0, id=507, blk_hardlimit=20480, blk_softlimit=20480, ino_hardlimit=0, ino_softlimit=0, bcount=0, icount=0, ...}) = 0
write(1, "#507            0    10M    10M "..., 45) = 45
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 508, 0x7fff5b1c9970) = -1 ENOENT (No such file or directory)
write(1, "\n", 1)                       = 1
stat("/home/sat/work/xfs/mnt", {st_mode=S_IFDIR|0755, st_size=6, ...}) = 0
quotactl(Q_XQUOTASYNC|GRPQUOTA, "/dev/loop0", 0, NULL) = 0
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 0, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 1, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 2, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 3, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 4, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 5, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 6, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 7, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 8, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 9, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 10, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 11, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 12, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 13, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 14, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 15, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 16, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 17, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 18, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 19, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 20, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 21, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 22, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 23, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 24, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 25, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 26, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 27, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 28, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 29, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 30, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 31, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 32, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 33, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 34, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 35, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 36, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 37, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 38, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 39, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 40, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 41, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 42, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 43, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 44, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 45, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 46, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 47, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 48, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 49, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 50, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 51, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 52, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 53, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 54, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 55, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 56, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 57, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 58, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 59, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 60, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 61, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 62, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 63, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 64, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 65, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 66, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 67, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 68, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 69, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 70, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 71, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 72, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 73, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 74, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 75, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 76, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 77, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 78, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 79, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 80, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 81, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 82, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 83, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 84, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 85, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 86, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 87, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 88, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 89, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 90, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 91, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 92, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 93, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 94, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 95, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 96, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 97, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 98, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 99, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 100, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 101, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 102, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 103, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 104, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 105, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 106, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 107, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 108, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 109, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 110, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 111, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 112, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 113, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 114, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 115, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 116, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 117, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 118, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 119, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 120, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 121, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 122, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 123, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 124, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 125, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 126, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 127, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 128, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 129, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 130, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 131, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 132, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 133, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 134, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 135, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 136, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 137, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 138, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 139, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 140, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 141, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 142, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 143, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 144, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 145, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 146, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 147, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 148, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 149, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 150, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 151, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 152, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 153, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 154, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 155, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 156, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 157, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 158, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 159, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 160, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 161, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 162, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 163, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 164, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 165, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 166, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 167, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 168, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 169, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 170, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 171, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 172, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 173, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 174, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 175, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 176, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 177, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 178, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 179, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 180, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 181, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 182, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 183, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 184, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 185, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 186, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 187, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 188, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 189, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 190, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 191, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 192, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 193, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 194, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 195, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 196, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 197, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 198, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 199, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 200, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 201, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 202, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 203, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 204, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 205, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 206, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 207, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 208, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 209, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 210, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 211, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 212, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 213, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 214, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 215, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 216, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 217, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 218, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 219, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 220, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 221, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 222, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 223, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 224, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 225, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 226, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 227, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 228, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 229, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 230, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 231, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 232, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 233, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 234, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 235, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 236, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 237, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 238, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 239, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 240, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 241, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 242, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 243, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 244, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 245, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 246, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 247, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 248, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 249, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 250, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 251, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 252, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 253, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 254, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 255, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 256, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 257, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 258, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 259, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 260, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 261, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 262, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 263, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 264, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 265, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 266, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 267, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 268, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 269, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 270, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 271, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 272, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 273, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 274, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 275, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 276, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 277, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 278, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 279, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 280, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 281, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 282, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 283, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 284, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 285, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 286, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 287, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 288, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 289, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 290, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 291, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 292, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 293, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 294, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 295, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 296, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 297, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 298, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 299, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 300, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 301, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 302, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 303, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 304, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 305, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 306, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 307, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 308, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 309, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 310, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 311, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 312, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 313, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 314, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 315, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 316, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 317, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 318, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 319, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 320, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 321, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 322, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 323, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 324, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 325, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 326, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 327, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 328, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 329, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 330, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 331, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 332, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 333, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 334, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 335, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 336, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 337, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 338, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 339, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 340, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 341, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 342, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 343, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 344, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 345, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 346, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 347, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 348, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 349, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 350, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 351, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 352, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 353, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 354, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 355, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 356, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 357, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 358, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 359, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 360, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 361, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 362, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 363, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 364, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 365, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 366, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 367, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 368, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 369, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 370, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 371, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 372, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 373, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 374, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 375, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 376, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 377, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 378, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 379, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 380, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 381, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 382, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 383, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 384, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 385, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 386, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 387, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 388, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 389, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 390, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 391, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 392, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 393, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 394, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 395, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 396, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 397, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 398, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 399, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 400, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 401, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 402, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 403, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 404, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 405, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 406, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 407, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 408, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 409, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 410, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 411, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 412, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 413, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 414, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 415, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 416, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 417, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 418, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 419, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 420, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 421, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 422, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 423, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 424, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 425, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 426, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 427, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 428, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 429, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 430, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 431, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 432, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 433, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 434, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 435, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 436, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 437, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 438, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 439, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 440, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 441, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 442, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 443, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 444, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 445, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 446, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 447, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 448, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 449, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 450, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 451, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 452, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 453, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 454, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 455, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 456, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 457, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 458, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 459, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 460, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 461, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 462, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 463, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 464, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 465, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 466, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 467, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 468, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 469, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 470, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 471, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 472, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 473, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 474, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 475, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 476, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 477, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 478, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 479, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 480, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 481, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 482, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 483, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 484, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 485, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 486, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 487, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 488, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 489, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 490, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 491, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 492, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 493, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 494, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 495, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 496, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 497, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 498, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 499, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 500, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 501, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 502, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 503, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 504, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 505, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 506, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 507, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 508, 0x7fff5b1c9970) = -1 ESRCH (No such process)
stat("/home/sat/work/xfs/mnt", {st_mode=S_IFDIR|0755, st_size=6, ...}) = 0
quotactl(Q_XQUOTASYNC|0x2 /* ???QUOTA */, "/dev/loop0", 0, NULL) = 0
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 0, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 1, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 2, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 3, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 4, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 5, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 6, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 7, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 8, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 9, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 10, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 11, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 12, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 13, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 14, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 15, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 16, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 17, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 18, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 19, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 20, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 21, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 22, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 23, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 24, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 25, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 26, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 27, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 28, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 29, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 30, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 31, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 32, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 33, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 34, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 35, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 36, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 37, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 38, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 39, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 40, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 41, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 42, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 43, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 44, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 45, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 46, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 47, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 48, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 49, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 50, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 51, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 52, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 53, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 54, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 55, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 56, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 57, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 58, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 59, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 60, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 61, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 62, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 63, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 64, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 65, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 66, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 67, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 68, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 69, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 70, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 71, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 72, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 73, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 74, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 75, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 76, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 77, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 78, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 79, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 80, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 81, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 82, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 83, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 84, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 85, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 86, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 87, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 88, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 89, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 90, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 91, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 92, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 93, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 94, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 95, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 96, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 97, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 98, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 99, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 100, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 101, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 102, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 103, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 104, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 105, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 106, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 107, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 108, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 109, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 110, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 111, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 112, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 113, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 114, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 115, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 116, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 117, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 118, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 119, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 120, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 121, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 122, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 123, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 124, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 125, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 126, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 127, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 128, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 129, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 130, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 131, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 132, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 133, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 134, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 135, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 136, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 137, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 138, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 139, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 140, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 141, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 142, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 143, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 144, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 145, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 146, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 147, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 148, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 149, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 150, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 151, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 152, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 153, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 154, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 155, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 156, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 157, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 158, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 159, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 160, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 161, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 162, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 163, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 164, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 165, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 166, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 167, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 168, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 169, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 170, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 171, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 172, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 173, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 174, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 175, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 176, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 177, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 178, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 179, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 180, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 181, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 182, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 183, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 184, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 185, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 186, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 187, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 188, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 189, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 190, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 191, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 192, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 193, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 194, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 195, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 196, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 197, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 198, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 199, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 200, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 201, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 202, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 203, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 204, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 205, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 206, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 207, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 208, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 209, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 210, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 211, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 212, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 213, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 214, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 215, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 216, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 217, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 218, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 219, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 220, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 221, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 222, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 223, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 224, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 225, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 226, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 227, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 228, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 229, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 230, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 231, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 232, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 233, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 234, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 235, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 236, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 237, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 238, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 239, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 240, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 241, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 242, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 243, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 244, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 245, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 246, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 247, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 248, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 249, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 250, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 251, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 252, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 253, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 254, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 255, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 256, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 257, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 258, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 259, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 260, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 261, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 262, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 263, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 264, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 265, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 266, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 267, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 268, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 269, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 270, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 271, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 272, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 273, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 274, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 275, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 276, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 277, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 278, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 279, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 280, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 281, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 282, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 283, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 284, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 285, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 286, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 287, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 288, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 289, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 290, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 291, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 292, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 293, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 294, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 295, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 296, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 297, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 298, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 299, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 300, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 301, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 302, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 303, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 304, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 305, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 306, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 307, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 308, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 309, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 310, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 311, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 312, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 313, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 314, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 315, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 316, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 317, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 318, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 319, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 320, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 321, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 322, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 323, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 324, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 325, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 326, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 327, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 328, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 329, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 330, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 331, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 332, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 333, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 334, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 335, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 336, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 337, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 338, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 339, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 340, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 341, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 342, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 343, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 344, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 345, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 346, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 347, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 348, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 349, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 350, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 351, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 352, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 353, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 354, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 355, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 356, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 357, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 358, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 359, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 360, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 361, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 362, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 363, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 364, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 365, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 366, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 367, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 368, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 369, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 370, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 371, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 372, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 373, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 374, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 375, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 376, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 377, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 378, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 379, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 380, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 381, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 382, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 383, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 384, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 385, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 386, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 387, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 388, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 389, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 390, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 391, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 392, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 393, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 394, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 395, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 396, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 397, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 398, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 399, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 400, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 401, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 402, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 403, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 404, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 405, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 406, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 407, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 408, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 409, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 410, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 411, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 412, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 413, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 414, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 415, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 416, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 417, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 418, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 419, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 420, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 421, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 422, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 423, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 424, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 425, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 426, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 427, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 428, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 429, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 430, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 431, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 432, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 433, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 434, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 435, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 436, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 437, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 438, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 439, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 440, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 441, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 442, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 443, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 444, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 445, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 446, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 447, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 448, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 449, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 450, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 451, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 452, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 453, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 454, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 455, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 456, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 457, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 458, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 459, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 460, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 461, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 462, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 463, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 464, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 465, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 466, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 467, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 468, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 469, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 470, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 471, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 472, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 473, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 474, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 475, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 476, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 477, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 478, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 479, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 480, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 481, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 482, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 483, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 484, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 485, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 486, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 487, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 488, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 489, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 490, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 491, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 492, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 493, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 494, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 495, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 496, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 497, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 498, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 499, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 500, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 501, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 502, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 503, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 504, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 505, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 506, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 507, 0x7fff5b1c9970) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/loop0", 508, 0x7fff5b1c9970) = -1 ESRCH (No such process)
exit_group(0)                           = ?
+++ exited with 0 +++

--------------040503090304040803060904
Content-Type: text/plain; charset="Shift_JIS"; name="report_without_U.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="report_without_U.log"

execve("/home/sat/src/xfsprogs/quota/xfs_quota", ["/home/sat/src/xfsprogs/quota/xfs"..., "-xc", "report -h", "/dev/loop0"], [/* 31 vars */]) = 0
brk(0)                                  = 0x1c46000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f851afef000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=101268, ...}) = 0
mmap(NULL, 101268, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f851afd6000
close(3)                                = 0
open("/lib64/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0@\30\"\3118\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=2065560, ...}) = 0
mmap(0x38c9200000, 3892376, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x38c9200000
mprotect(0x38c93ac000, 2097152, PROT_NONE) = 0
mmap(0x38c95ac000, 24576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1ac000) = 0x38c95ac000
mmap(0x38c95b2000, 17560, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x38c95b2000
close(3)                                = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f851afd5000
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f851afd3000
arch_prctl(ARCH_SET_FS, 0x7f851afd3740) = 0
mprotect(0x38c95ac000, 16384, PROT_READ) = 0
mprotect(0x612000, 4096, PROT_READ)     = 0
mprotect(0x38c8c1f000, 4096, PROT_READ) = 0
munmap(0x7f851afd6000, 101268)          = 0
brk(0)                                  = 0x1c46000
brk(0x1c67000)                          = 0x1c67000
brk(0)                                  = 0x1c67000
access("/proc/self/mounts", R_OK)       = 0
open("/proc/self/mounts", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f851afee000
read(3, "rootfs / rootfs rw 0 0\nproc /pro"..., 1024) = 1024
read(3, "es 0 0\ncgroup /sys/fs/cgroup/fre"..., 1024) = 990
stat("/home/sat/work/xfs/mnt", {st_mode=S_IFDIR|0755, st_size=6, ...}) = 0
close(3)                                = 0
munmap(0x7f851afee000, 4096)            = 0
open("/etc/projects", O_RDONLY)         = -1 ENOENT (No such file or directory)
stat("/dev/loop0", {st_mode=S_IFBLK|0660, st_rdev=makedev(7, 0), ...}) = 0
stat("/home/sat/work/xfs/mnt", {st_mode=S_IFDIR|0755, st_size=6, ...}) = 0
quotactl(Q_XQUOTASYNC|USRQUOTA, "/dev/loop0", 0, NULL) = 0
open("/etc/nsswitch.conf", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=1724, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f851afee000
read(3, "#\n# /etc/nsswitch.conf\n#\n# An ex"..., 4096) = 1724
read(3, "", 4096)                       = 0
close(3)                                = 0
munmap(0x7f851afee000, 4096)            = 0
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=101268, ...}) = 0
mmap(NULL, 101268, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f851afd6000
close(3)                                = 0
open("/lib64/libnss_files.so.2", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\260!\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=62464, ...}) = 0
mmap(NULL, 2148424, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f851adc6000
mprotect(0x7f851add2000, 2093056, PROT_NONE) = 0
mmap(0x7f851afd1000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0xb000) = 0x7f851afd1000
close(3)                                = 0
mprotect(0x7f851afd1000, 4096, PROT_READ) = 0
munmap(0x7f851afd6000, 101268)          = 0
open("/etc/passwd", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=2005, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f851afee000
lseek(3, 0, SEEK_CUR)                   = 0
read(3, "root:x:0:0:root:/root:/bin/bash\n"..., 4096) = 2005
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 0, {version=1, flags=XFS_USER_QUOTA, fieldmask=0, id=0, blk_hardlimit=0, blk_softlimit=0, ino_hardlimit=0, ino_softlimit=0, bcount=0, icount=3, ...}) = 0
fstat(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 0), ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f851afed000
write(1, "User quota on /home/sat/work/xfs"..., 50) = 50
write(1, "                        Blocks  "..., 45) = 45
write(1, "User ID      Used   Soft   Hard "..., 46) = 46
write(1, "---------- ---------------------"..., 46) = 46
write(1, "root            0      0      0 "..., 45) = 45
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 1, 0x7fffec596a90) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 2, 0x7fffec596a90) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 3, 0x7fffec596a90) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 4, 0x7fffec596a90) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 5, 0x7fffec596a90) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 6, 0x7fffec596a90) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 7, 0x7fffec596a90) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 8, 0x7fffec596a90) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 10, 0x7fffec596a90) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 11, 0x7fffec596a90) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 12, 0x7fffec596a90) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 13, 0x7fffec596a90) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 14, 0x7fffec596a90) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 99, 0x7fffec596a90) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 113, 0x7fffec596a90) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 170, 0x7fffec596a90) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 81, 0x7fffec596a90) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 173, 0x7fffec596a90) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 999, 0x7fffec596a90) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 998, 0x7fffec596a90) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 70, 0x7fffec596a90) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 32, 0x7fffec596a90) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 172, 0x7fffec596a90) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 38, 0x7fffec596a90) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 52, 0x7fffec596a90) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 89, 0x7fffec596a90) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 29, 0x7fffec596a90) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 65534, 0x7fffec596a90) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 74, 0x7fffec596a90) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 16, 0x7fffec596a90) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 72, 0x7fffec596a90) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 997, 0x7fffec596a90) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 42, 0x7fffec596a90) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 28, 0x7fffec596a90) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 55, 0x7fffec596a90) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 996, 0x7fffec596a90) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 107, 0x7fffec596a90) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 75, 0x7fffec596a90) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/loop0", 1000, 0x7fffec596a90) = -1 ENOENT (No such file or directory)
read(3, "", 4096)                       = 0
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 4
fstat(4, {st_mode=S_IFREG|0644, st_size=101268, ...}) = 0
mmap(NULL, 101268, PROT_READ, MAP_PRIVATE, 4, 0) = 0x7f851adad000
close(4)                                = 0
open("/lib64/libnss_sss.so.2", O_RDONLY|O_CLOEXEC) = 4
read(4, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0000\23\0\0\0\0\0\0"..., 832) = 832
fstat(4, {st_mode=S_IFREG|0755, st_size=26936, ...}) = 0
mmap(NULL, 2122480, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 4, 0) = 0x7f851aba6000
mprotect(0x7f851abab000, 2097152, PROT_NONE) = 0
mmap(0x7f851adab000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 4, 0x5000) = 0x7f851adab000
close(4)                                = 0
mprotect(0x7f851adab000, 4096, PROT_READ) = 0
munmap(0x7f851adad000, 101268)          = 0
getpid()                                = 4009
fstat(-1, 0x7fffec596870)               = -1 EBADF (Bad file descriptor)
socket(PF_FILE, SOCK_STREAM, 0)         = 4
fcntl(4, F_GETFL)                       = 0x2 (flags O_RDWR)
fcntl(4, F_SETFL, O_RDWR|O_NONBLOCK)    = 0
fcntl(4, F_GETFD)                       = 0
fcntl(4, F_SETFD, FD_CLOEXEC)           = 0
connect(4, {sa_family=AF_FILE, sun_path="/var/lib/sss/pipes/nss"}, 110) = 0
fstat(4, {st_mode=S_IFSOCK|0777, st_size=0, ...}) = 0
poll([{fd=4, events=POLLOUT}], 1, 300000) = 1 ([{fd=4, revents=POLLOUT}])
write(4, "\24\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0", 16) = 16
poll([{fd=4, events=POLLOUT}], 1, 300000) = 1 ([{fd=4, revents=POLLOUT}])
write(4, "\1\0\0\0", 4)                 = 4
poll([{fd=4, events=POLLIN}], 1, 300000) = 1 ([{fd=4, revents=POLLIN}])
read(4, "\24\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0", 16) = 16
poll([{fd=4, events=POLLIN}], 1, 300000) = 1 ([{fd=4, revents=POLLIN}])
read(4, "\1\0\0\0", 4)                  = 4
poll([{fd=4, events=POLLOUT}], 1, 300000) = 1 ([{fd=4, revents=POLLOUT}])
write(4, "\20\0\0\0\23\0\0\0\0\0\0\0\0\0\0\0", 16) = 16
poll([{fd=4, events=POLLIN}], 1, 300000) = 1 ([{fd=4, revents=POLLIN}])
read(4, "\20\0\0\0\23\0\0\0\0\0\0\0\0\0\0\0", 16) = 16
poll([{fd=4, events=POLLIN|POLLOUT}], 1, 300000) = 1 ([{fd=4, revents=POLLOUT}])
poll([{fd=4, events=POLLOUT}], 1, 300000) = 1 ([{fd=4, revents=POLLOUT}])
write(4, "\24\0\0\0\24\0\0\0\0\0\0\0\0\0\0\0", 16) = 16
poll([{fd=4, events=POLLOUT}], 1, 300000) = 1 ([{fd=4, revents=POLLOUT}])
write(4, "\0\1\0\0", 4)                 = 4
poll([{fd=4, events=POLLIN}], 1, 300000) = 1 ([{fd=4, revents=POLLIN}])
read(4, "\30\0\0\0\24\0\0\0\0\0\0\0\0\0\0\0", 16) = 16
poll([{fd=4, events=POLLIN}], 1, 300000) = 1 ([{fd=4, revents=POLLIN}])
read(4, "\0\0\0\0\0\0\0\0", 8)          = 8
lseek(3, 2005, SEEK_SET)                = 2005
close(3)                                = 0
munmap(0x7f851afee000, 4096)            = 0
poll([{fd=4, events=POLLIN|POLLOUT}], 1, 300000) = 1 ([{fd=4, revents=POLLOUT}])
poll([{fd=4, events=POLLOUT}], 1, 300000) = 1 ([{fd=4, revents=POLLOUT}])
write(4, "\20\0\0\0\25\0\0\0\0\0\0\0\0\0\0\0", 16) = 16
poll([{fd=4, events=POLLIN}], 1, 300000) = 1 ([{fd=4, revents=POLLIN}])
read(4, "\20\0\0\0\25\0\0\0\0\0\0\0\0\0\0\0", 16) = 16
write(1, "\n", 1)                       = 1
stat("/home/sat/work/xfs/mnt", {st_mode=S_IFDIR|0755, st_size=6, ...}) = 0
quotactl(Q_XQUOTASYNC|GRPQUOTA, "/dev/loop0", 0, NULL) = 0
open("/etc/group", O_RDONLY|O_CLOEXEC)  = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=853, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f851afee000
lseek(3, 0, SEEK_CUR)                   = 0
read(3, "root:x:0:\nbin:x:1:bin,daemon\ndae"..., 4096) = 853
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 0, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 1, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 2, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 3, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 4, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 5, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 6, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 7, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 8, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 9, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 10, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 12, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 14, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 15, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 20, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 30, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 39, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 40, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 50, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 54, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 55, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 63, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 99, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 100, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 113, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 22, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 35, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 170, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 11, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 33, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 18, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 19, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 81, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 173, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 999, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 998, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 997, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 70, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 32, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 172, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 38, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 52, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 90, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 89, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 29, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 65534, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 74, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 16, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 21, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 72, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 996, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 995, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 42, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 994, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 993, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 155, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 28, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 992, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 157, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 36, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 107, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 75, 0x7fffec596a90) = -1 ESRCH (No such process)
quotactl(Q_XGETQUOTA|GRPQUOTA, "/dev/loop0", 1000, 0x7fffec596a90) = -1 ESRCH (No such process)
read(3, "", 4096)                       = 0
poll([{fd=4, events=POLLIN|POLLOUT}], 1, 300000) = 1 ([{fd=4, revents=POLLOUT}])
poll([{fd=4, events=POLLOUT}], 1, 300000) = 1 ([{fd=4, revents=POLLOUT}])
write(4, "\20\0\0\0#\0\0\0\0\0\0\0\0\0\0\0", 16) = 16
poll([{fd=4, events=POLLIN}], 1, 300000) = 1 ([{fd=4, revents=POLLIN}])
read(4, "\20\0\0\0#\0\0\0\0\0\0\0\0\0\0\0", 16) = 16
poll([{fd=4, events=POLLIN|POLLOUT}], 1, 300000) = 1 ([{fd=4, revents=POLLOUT}])
poll([{fd=4, events=POLLOUT}], 1, 300000) = 1 ([{fd=4, revents=POLLOUT}])
write(4, "\24\0\0\0$\0\0\0\0\0\0\0\0\0\0\0", 16) = 16
poll([{fd=4, events=POLLOUT}], 1, 300000) = 1 ([{fd=4, revents=POLLOUT}])
write(4, "\0\1\0\0", 4)                 = 4
poll([{fd=4, events=POLLIN}], 1, 300000) = 1 ([{fd=4, revents=POLLIN}])
read(4, "\30\0\0\0$\0\0\0\0\0\0\0\0\0\0\0", 16) = 16
poll([{fd=4, events=POLLIN}], 1, 300000) = 1 ([{fd=4, revents=POLLIN}])
read(4, "\0\0\0\0\0\0\0\0", 8)          = 8
lseek(3, 853, SEEK_SET)                 = 853
close(3)                                = 0
munmap(0x7f851afee000, 4096)            = 0
poll([{fd=4, events=POLLIN|POLLOUT}], 1, 300000) = 1 ([{fd=4, revents=POLLOUT}])
poll([{fd=4, events=POLLOUT}], 1, 300000) = 1 ([{fd=4, revents=POLLOUT}])
write(4, "\20\0\0\0%\0\0\0\0\0\0\0\0\0\0\0", 16) = 16
poll([{fd=4, events=POLLIN}], 1, 300000) = 1 ([{fd=4, revents=POLLIN}])
read(4, "\20\0\0\0%\0\0\0\0\0\0\0\0\0\0\0", 16) = 16
stat("/home/sat/work/xfs/mnt", {st_mode=S_IFDIR|0755, st_size=6, ...}) = 0
quotactl(Q_XQUOTASYNC|0x2 /* ???QUOTA */, "/dev/loop0", 0, NULL) = 0
open("/etc/projid", O_RDONLY)           = -1 ENOENT (No such file or directory)
close(4)                                = 0
exit_group(0)                           = ?
+++ exited with 0 +++

--------------040503090304040803060904
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------040503090304040803060904--
