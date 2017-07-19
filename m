Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:37023 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751364AbdGSFyp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jul 2017 01:54:45 -0400
Received: by mail-wm0-f44.google.com with SMTP id g127so4556977wmd.0
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jul 2017 22:54:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170718225655.GO17762@dastard>
References: <CAH4CUCPgFnm0s07uEU3ke6V8cPtSvQxMLo60nemuuqGygmZRhA@mail.gmail.com>
 <20170718225655.GO17762@dastard>
From: Yaron Presente <yaron@zadarastorage.com>
Date: Wed, 19 Jul 2017 08:54:43 +0300
Message-ID: <CAH4CUCMR3uzmVboJ+EfqO3m=e3zzpqgfHs30WcqPysFaaNSugQ@mail.gmail.com>
Subject: Re: XFS group quota incorrectly "inherits" its hard limit from user 0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

Hi Dave,
Thanks for looking at this.

1. exact cmd is:
"xfs_quota -x -c "limit -u bhard=800000000 0" /export/share_3"   (I
changed the bhard value a little for readability)

2. I'm using xfsprogs version 3.1.9-01 (with some modifications but
not with regards to XFS quota)

3. strace output:

root@vsa-0000011e-vc-0:~# cat strace.txt
execve("/usr/sbin/xfs_quota", ["xfs_quota", "-x", "-c", "limit -u
bhard=800000000 0", "/export/share_3"], [/* 20 vars */]) = 0
brk(0)                                  = 0x2583000
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x7f15fefd3000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=40202, ...}) = 0
mmap(NULL, 40202, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f15fefc9000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0P
\2\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=1853216, ...}) = 0
mmap(NULL, 3961536, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0x7f15fe9eb000
mprotect(0x7f15feba9000, 2093056, PROT_NONE) = 0
mmap(0x7f15feda8000, 24576, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1bd000) = 0x7f15feda8000
mmap(0x7f15fedae000, 17088, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f15fedae000
close(3)                                = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x7f15fefc8000
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x7f15fefc6000
arch_prctl(ARCH_SET_FS, 0x7f15fefc6740) = 0
mprotect(0x7f15feda8000, 16384, PROT_READ) = 0
mprotect(0x612000, 4096, PROT_READ)     = 0
mprotect(0x7f15fefd5000, 4096, PROT_READ) = 0
munmap(0x7f15fefc9000, 40202)           = 0
brk(0)                                  = 0x2583000
brk(0x25a4000)                          = 0x25a4000
access("/proc/self/mounts", R_OK)       = 0
open("/proc/self/mounts", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x7f15fefd2000
read(3, "rootfs / rootfs rw 0 0\nsysfs /sy"..., 1024) = 1024
read(3, "pstore pstore rw,relatime 0 0\ncg"..., 1024) = 1024
read(3, "sync,noatime,wsync,attr2,discard"..., 1024) = 297
stat("/export/share_3", {st_mode=S_IFDIR|0777, st_size=6, ...}) = 0
close(3)                                = 0
munmap(0x7f15fefd2000, 4096)            = 0
open("/etc/projects", O_RDONLY)         = -1 ENOENT (No such file or directory)
stat("/export/share_3", {st_mode=S_IFDIR|0777, st_size=6, ...}) = 0
quotactl(Q_XSETQLIM|USRQUOTA, "/dev/dm-28", 0, {version=1,
flags=XFS_USER_QUOTA, fieldmask=0x8, id=0, blk_hardlimit=1562500,
blk_softlimit=0, ino_hardlimit=0, ino_softlimit=0, bcount=0, icount=0,
...}) = 0
exit_group(0)                           = ?
+++ exited with 0 +++

4. Here the whole sequence of commands that I use to reproduce this:

- xfs_quota -x -c "limit -u bhard=800000000 0" /export/share_3
- xfs_quota -x -c "limit -u bhard=1024000k 2001117" /export/share_3
- dd if=/dev/zero of=/export/share_3/f1 bs=1M count=1
        <=   creating a file as 'root'
- xfs_quota -x -c "report -L0 -U 2100000" /export/share_3

User quota on /export/share_3 (/dev/dm-28)
                               Blocks
User ID          Used       Soft       Hard    Warn/Grace
---------- --------------------------------------------------
#0                  1024          0     781252     00 [--------]
#2001117            0          0    1024000     00 [--------]

Group quota on /export/share_3 (/dev/dm-28)
                               Blocks
Group ID         Used       Soft       Hard    Warn/Grace
---------- --------------------------------------------------
#0                  1024          0          0     00 [--------]


- chown 2001117:2000514 /export/share_3/f1
          <= changing the file ownership
- xfs_quota -x -c "report -L0 -U 2100000" /export/share_3

User quota on /export/share_3 (/dev/dm-28)
                               Blocks
User ID          Used       Soft       Hard    Warn/Grace
---------- --------------------------------------------------
#0                  0               0     781252     00 [--------]
#2001117     1024          0    1024000     00 [--------]

Group quota on /export/share_3 (/dev/dm-28)
                               Blocks
Group ID         Used       Soft       Hard    Warn/Grace
---------- --------------------------------------------------
#0                  0              0          0          00 [--------]
#2000514    1024          0     781252     00 [--------]     <=== here
is the problem


Thanks,
Yaron


On Wed, Jul 19, 2017 at 1:56 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Wed, Jul 19, 2017 at 12:51:20AM +0300, Yaron Presente wrote:
>> Hi,
>> I'm running a Linux system with kernel version 3.18.19.
>> While experimenting with groups quota, I did the following steps:
>>
>> 1. Mounted XFS with both users and groups quota enabled
>> 2. Set user 0 (aka the SuperUser) hard limit to 800000 . I believe
>> that this has the same affect as using xfs_quota limit command with
>> "-d" (i.e. setting the default hard limit for users which don't have
>> their hard limit set explicitly)
>
> What is the exact command you used to do this, what version of the
> quota utils are you using, and what is the strace output of the
> command?
>
> -Dave.
>
>> 3. Set user 2001117 hard limit to 1024000 (I set a different limit
>> than user 0's on purpose, in order to show that the group hard limit
>> was not inherited from this user, but from user 0)
>> 4. Created a 1MB file that is owned by user 2001117 and group 2000514
>> 5. Group 2000514 which previously didn't have any hard limit defined
>> now "inherited" user 0 hard limit of 800000 .
>
>>
>> See output of xfs_quota below.
>> Thanks,
>> Yaron
>>
>>
>> Before creating the file:
>> ==================
>>
>> root@vsa-0000011e-vc-0:~# xfs_quota -x -c "report -L0 -U 2100000"
>> /export/share_3
>> User quota on /export/share_3 (/dev/dm-28)
>>                                Blocks
>> User ID          Used       Soft       Hard    Warn/Grace
>> ---------- --------------------------------------------------
>> #0                  0               0      800000      00  [--------]
>> #2001117       0               0     1024000     00 [--------]
>>
>> Group quota on /export/share_3 (/dev/dm-28)
>>                                Blocks
>> Group ID         Used       Soft       Hard    Warn/Grace
>> ---------- --------------------------------------------------
>> #0                  0               0          0          00 [--------]
>>
>> (group 2000514  is not listed since it does not have a hard limit and
>> its quota is not used by any file)
>>
>> After creating the file:
>> ================
>>
>> root@vsa-0000011e-vc-0:~# xfs_quota -x -c "report -L0 -U 2100000"
>> /export/share_3
>> User quota on /export/share_3 (/dev/dm-28)
>>                                Blocks
>> User ID          Used       Soft       Hard    Warn/Grace
>> ---------- --------------------------------------------------
>> #0                  0               0     800000      00  [--------]
>> #2001117      1024         0    1024000     00 [--------]
>>
>> Group quota on /export/share_3 (/dev/dm-28)
>>                                Blocks
>> Group ID         Used       Soft       Hard    Warn/Grace
>> ---------- --------------------------------------------------
>> #0                  0               0          0           00 [--------]
>> #2000514      1024         0      800000     00 [--------]
>>    <===   This is the problem. It's not clear where this hard limit
>> came from
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> --
> Dave Chinner
> david@fromorbit.com



-- 
Best Regards,

Yaron Presente
Engineering Manager,
Zadara Storage
Cell: 972-54-8161374
yaron@zadarastorage.com
Skype: yaron.zadara
Twitter: @ZadaraStorage
Website | Blog | LinkedIn | Facebook | Twitter | YouTube
Learn about our Cloud and On-Premise Storage-as-a-Service
