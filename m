Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx07-0014df02.pphosted.com ([62.209.51.100]:43092 "EHLO
        mx07-0014df02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726277AbeHXSOF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Aug 2018 14:14:05 -0400
Received: from pps.filterd (m0047765.ppops.net [127.0.0.1])
        by mx07-0014df02.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w7OEP9eM025484
        for <linux-xfs@vger.kernel.org>; Fri, 24 Aug 2018 16:39:03 +0200
Received: from esm2.gustaveroussy.fr ([194.167.112.34])
        by mx07-0014df02.pphosted.com with ESMTP id 2kxa2xafas-1
        for <linux-xfs@vger.kernel.org>; Fri, 24 Aug 2018 16:39:03 +0200
Received: from cpsure-proxyesm2.gustaveroussy.fr (localhost [127.0.0.1])
        by esm2.gustaveroussy.fr (CPSureProxy) with ESMTP id 80DE8A0071
        for <linux-xfs@vger.kernel.org>; Fri, 24 Aug 2018 16:39:01 +0200 (CEST)
Received: from 194.167.112.34 ([194.167.112.34])
          by cpsure-proxyesm2.gustaveroussy.fr (CpsureProxy SMTP Server ) with SMTP ID 870
          for <linux-xfs@vger.kernel.org>;
          Fri, 24 Aug 2018 16:39:01 +0200 (CEST)
Subject: Corrupted large file ?
Received: from SRV-CAS-01.intra.igr.fr (srv-ex-02-1.intra.igr.fr [31.10.10.105])
        by esm2.gustaveroussy.fr (CPSureProxy) with ESMTP id 5B9BCA0071
        for <linux-xfs@vger.kernel.org>; Fri, 24 Aug 2018 16:39:01 +0200 (CEST)
From: BOURSIN YANNICK <YANNICK.BOURSIN@gustaveroussy.fr>
Date: Fri, 24 Aug 2018 14:39:01 +0000
Message-ID: <F6BD1F63141BFD48924FAD7C646366FA02EC869C40@SRV-MBX-01.intra.igr.fr>
Content-Language: fr-FR
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

Hello Everybody,

                I am facing some issues with XFS. I do not really know what went wrong and how to diagnose the issue I'm having, but here are the symptoms:
. My kernel is: Linux proxmox1 4.13.13-2-pve #1 SMP PVE 4.13.13-32. It's a 40 cores server that features 160Tb storage (with RAID-6) and 384G RAM.                                                                                             
. /dev/sdb1 is a raid array that is roughly 128Tb big
. It contains mainly virtual machine disks for a proxmox instance
. After a regular halt / restart in which nothing was odd, I could not start anymore one of my VM, kvm timing out.
. Tried a few things, one of which was "head -n 1 <name of the image>.qcow2 . The image being a single 30Tb file.
. The console freezes after that. It seems that I cannot do anything with the qcow2 image. I tried to dd it into another file, but no change. After that, I tried rebooting again, and it told me upon process termination:

"echo 0" > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Print_req_error: I/O error, dev sdb, sector 241349552640
XFS (sdb1): metadata I/O error: block 0x38818de200 ("xfs_trans_read_buf_map") error 5 numblks 8

. Tried to run after that xfs_repair with default parameters on my /dev/sdb1. Nothing's getting out of that, it's almost like xfs_repair doesn't detect anything. It has ran 3 times now, always with the same output which you can see there:

root@proxmox1:~/xfsprogs-4.17.0# xfs_repair -e /dev/sdb1
Phase 1 - find and verify superblock...
        - reporting progress in intervals of 15 minutes
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - 15:30:39: scanning filesystem freespace - 128 of 128 allocation groups done
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - 15:30:39: scanning agi unlinked lists - 128 of 128 allocation groups done
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 15
        - agno = 30
        - agno = 60
        - agno = 45
        - agno = 75
        - agno = 90
        - agno = 105
        - agno = 120
        - agno = 31
        - agno = 46
        - agno = 76
        - agno = 91
        - agno = 106
        - agno = 61
        - agno = 47
        - agno = 121
        - agno = 32
        - agno = 48
        - agno = 77
        - agno = 92
        - agno = 49
        - agno = 33
        - agno = 78
        - agno = 62
        - agno = 34
        - agno = 50
        - agno = 63
        - agno = 35
        - agno = 51
        - agno = 36
        - agno = 93
        - agno = 79
        - agno = 64
        - agno = 37
        - agno = 94
        - agno = 95
        - agno = 65
        - agno = 52
        - agno = 53
        - agno = 66
        - agno = 38
        - agno = 96
        - agno = 54
        - agno = 67
        - agno = 39
        - agno = 55
        - agno = 40
        - agno = 68
        - agno = 56
        - agno = 97
        - agno = 57
        - agno = 69
        - agno = 80
        - agno = 81
        - agno = 98
        - agno = 82
        - agno = 70
        - agno = 122
        - agno = 123
        - agno = 83
        - agno = 58
        - agno = 71
        - agno = 84
        - agno = 99
        - agno = 100
        - agno = 72
        - agno = 85
        - agno = 124
        - agno = 59
        - agno = 73
        - agno = 101
        - agno = 74
        - agno = 86
        - agno = 102
        - agno = 125
        - agno = 87
        - agno = 103
        - agno = 88
        - agno = 126
        - agno = 104
        - agno = 127
        - agno = 41
        - agno = 42
        - agno = 43
        - agno = 44
        - agno = 89
        - agno = 16
        - agno = 17
        - agno = 18
        - agno = 19
        - agno = 20
        - agno = 21
        - agno = 22
        - agno = 23
        - agno = 24
        - agno = 25
        - agno = 26
        - agno = 27
        - agno = 28
        - agno = 29
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 107
        - agno = 108
        - agno = 109
        - agno = 110
        - agno = 111
        - agno = 112
        - agno = 113
        - agno = 114
        - agno = 115
        - agno = 116
        - agno = 117
        - agno = 118
        - agno = 119
        - 16:01:01: process known inodes and inode discovery - 8320 of 8320 inodes done
        - process newly discovered inodes...
        - 16:01:01: process newly discovered inodes - 128 of 128 allocation groups done
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - 16:01:01: setting up duplicate extent list - 128 of 128 allocation groups done
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 5
        - agno = 6
        - agno = 4
        - agno = 7
        - agno = 8
        - agno = 9
        - agno = 12
        - agno = 10
        - agno = 15
        - agno = 21
        - agno = 16
        - agno = 24
        - agno = 20
        - agno = 18
        - agno = 29
        - agno = 23
        - agno = 28
        - agno = 22
        - agno = 14
        - agno = 27
        - agno = 11
        - agno = 17
        - agno = 13
        - agno = 19
        - agno = 61
        - agno = 39
        - agno = 55
        - agno = 42
        - agno = 31
        - agno = 26
        - agno = 80
        - agno = 46
        - agno = 44
        - agno = 86
        - agno = 35
        - agno = 87
        - agno = 88
        - agno = 25
        - agno = 90
        - agno = 36
        - agno = 32
        - agno = 92
        - agno = 30
        - agno = 69
        - agno = 85
        - agno = 89
        - agno = 45
        - agno = 91
        - agno = 43
        - agno = 38
        - agno = 93
        - agno = 71
        - agno = 37
        - agno = 95
        - agno = 96
        - agno = 41
        - agno = 98
        - agno = 97
        - agno = 76
        - agno = 77
        - agno = 78
        - agno = 79
        - agno = 83
        - agno = 82
        - agno = 81
        - agno = 57
        - agno = 54
        - agno = 52
        - agno = 65
        - agno = 34
        - agno = 64
        - agno = 40
        - agno = 66
        - agno = 49
        - agno = 70
        - agno = 72
        - agno = 63
        - agno = 48
        - agno = 51
        - agno = 56
        - agno = 59
        - agno = 68
        - agno = 60
        - agno = 94
        - agno = 53
        - agno = 73
        - agno = 99
        - agno = 74
        - agno = 58
        - agno = 67
        - agno = 101
        - agno = 62
        - agno = 33
        - agno = 100
        - agno = 102
        - agno = 75
        - agno = 84
        - agno = 50
        - agno = 104
        - agno = 105
        - agno = 47
        - agno = 107
        - agno = 108
        - agno = 111
        - agno = 116
        - agno = 122
        - agno = 123
        - agno = 109
        - agno = 115
        - agno = 113
        - agno = 118
        - agno = 117
        - agno = 119
        - agno = 103
        - agno = 121
        - agno = 120
        - agno = 124
        - agno = 112
        - agno = 125
        - agno = 114
        - agno = 126
        - agno = 110
        - agno = 106
        - agno = 127
        - 16:01:11: check for inodes claiming duplicate blocks - 8320 of 8320 inodes done
Phase 5 - rebuild AG headers and trees...
        - 16:01:12: rebuild AG headers and trees - 128 of 128 allocation groups done
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
        - 16:01:13: verify and correct link counts - 128 of 128 allocation groups done
done
root@proxmox1:~/xfsprogs-4.17.0# echo $?
0


. I was willing to try xfs_scrub, but the kernel cannot do that apparently, so I did not run it at this point.
. Here is my dmesg output regarding XFS

root@proxmox1:~# dmesg | grep -i xfs
[    4.203326] SGI XFS with ACLs, security attributes, realtime, no debug enabled
[    4.219735] XFS (dm-0): Mounting V5 Filesystem
[    4.268027] XFS (dm-0): Ending clean mount
[    6.819537] XFS (sdb1): Mounting V5 Filesystem
[    7.654455] XFS (sdb1): Starting recovery (logdev: internal)
[    8.806812] XFS (sdb1): Ending recovery (logdev: internal)
[  229.712694] XFS (sdb1): Unmounting Filesystem
[  386.826450] XFS (sdb1): Mounting V5 Filesystem
[  387.397634] XFS (sdb1): Ending clean mount
[  503.408649] XFS (sdb1): Unmounting Filesystem


Here is the output of dmesg after a ls was blocked:


[ 3384.280537] INFO: task ls:21392 blocked for more than 120 seconds.
[ 3384.280592]       Not tainted 4.13.13-2-pve #1
[ 3384.280626] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this                                                                                              message.
[ 3384.280682] ls              D    0 21392   3298 0x00000004
[ 3384.280687] Call Trace:
[ 3384.280700]  __schedule+0x3cc/0x860
[ 3384.280788]  ? xfs_ilock_attr_map_shared+0x34/0x40 [xfs]
[ 3384.280796]  schedule+0x36/0x80
[ 3384.280800]  rwsem_down_read_failed+0x10a/0x170
[ 3384.280804]  call_rwsem_down_read_failed+0x18/0x30
[ 3384.280807]  ? call_rwsem_down_read_failed+0x18/0x30
[ 3384.280880]  ? xfs_trans_roll+0xc0/0xc0 [xfs]
[ 3384.280884]  down_read+0x20/0x40
[ 3384.280938]  xfs_ilock+0xe0/0x110 [xfs]
[ 3384.280984]  xfs_ilock_attr_map_shared+0x34/0x40 [xfs]
[ 3384.281017]  xfs_attr_get+0xb6/0x110 [xfs]
[ 3384.281068]  xfs_xattr_get+0x4b/0x70 [xfs]
[ 3384.281072]  __vfs_getxattr+0x57/0x70
[ 3384.281075]  vfs_getxattr+0x8d/0xa0
[ 3384.281078]  getxattr+0xb0/0x1a0
[ 3384.281083]  ? __check_object_size+0xb3/0x190
[ 3384.281087]  path_getxattr+0x6c/0xb0
[ 3384.281090]  SyS_lgetxattr+0x11/0x20
[ 3384.281094]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[ 3384.281097] RIP: 0033:0x7fd487e0634a
[ 3384.281099] RSP: 002b:00007ffed0bedb98 EFLAGS: 00000202 ORIG_RAX: 00000000000                                                                                             000c0
[ 3384.281103] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007fd487e0634a
[ 3384.281104] RDX: 00005638063a2ce0 RSI: 00007fd4880dc262 RDI: 00007ffed0bedc30
[ 3384.281106] RBP: 0000000000000000 R08: 00007fd4880b8c68 R09: 0000000000000110
[ 3384.281107] R10: 00000000000000ff R11: 0000000000000202 R12: 00007fd4884fb270
[ 3384.281109] R13: 00005638063a53c0 R14: 00005638063a2de0 R15: 0000000000000000


Here is a strace output when trying to "cat" into the qcow image:

root@proxmox1:~# strace cat /export/sdb1/brick/images/111/vm-111-disk-1.qcow2
execve("/bin/cat", ["cat", "/export/sdb1/brick/images/111/vm"...], [/* 16 vars */]) = 0
brk(NULL)                               = 0x561059d8c000
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
mmap(NULL, 12288, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f55cfb39000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=38304, ...}) = 0
mmap(NULL, 38304, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f55cfb2f000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\0\4\2\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=1689360, ...}) = 0
mmap(NULL, 3795296, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f55cf57a000
mprotect(0x7f55cf70f000, 2097152, PROT_NONE) = 0
mmap(0x7f55cf90f000, 24576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x195000) = 0x7f55cf90f000
mmap(0x7f55cf915000, 14688, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f55cf915000
close(3)                                = 0
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f55cfb2d000
arch_prctl(ARCH_SET_FS, 0x7f55cfb2d700) = 0
mprotect(0x7f55cf90f000, 16384, PROT_READ) = 0
mprotect(0x561058540000, 4096, PROT_READ) = 0
mprotect(0x7f55cfb3c000, 4096, PROT_READ) = 0
munmap(0x7f55cfb2f000, 38304)           = 0
brk(NULL)                               = 0x561059d8c000
brk(0x561059dad000)                     = 0x561059dad000
open("/usr/lib/locale/locale-archive", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=1679776, ...}) = 0
mmap(NULL, 1679776, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f55cf992000
close(3)                                = 0
fstat(1, {st_mode=S_IFCHR|0600, st_rdev=makedev(136, 2), ...}) = 0
open("/export/sdb1/brick/images/111/vm-111-disk-1.qcow2", O_RDONLY) = 3
fstat(3, {st_mode=S_IFREG|0600, st_size=32218780991488, ...}) = 0
fadvise64(3, 0, 0, POSIX_FADV_SEQUENTIAL) = 0
mmap(NULL, 139264, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f55cf970000
read(3,


Would you happen to have any clue on where to go from now ?

Thank you in advance for the time you'll offer me regarding this !

Kind regards,

Yannick Boursin
