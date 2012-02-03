Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q13K2Ro5157161
	for <linux-xfs@oss.sgi.com>; Fri, 3 Feb 2012 14:02:31 -0600
Received: from crunch.scalableinformatics.com
	(173-10-54-97-Michigan.hfc.comcastbusiness.net [173.10.54.97])
	by cuda.sgi.com with ESMTP id GhmCFlrEtacJBaiU (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for
	<linux-xfs@oss.sgi.com>; Fri, 03 Feb 2012 12:02:20 -0800 (PST)
Received: from crunch.scalableinformatics.com (localhost [127.0.0.1])
	by crunch.scalableinformatics.com (Postfix) with ESMTP id 8245980ABED3
	for <linux-xfs@oss.sgi.com>; Fri,  3 Feb 2012 15:02:22 -0500 (EST)
Received: from [192.168.5.53] (eng [70.88.96.213])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by crunch.scalableinformatics.com (Postfix) with ESMTPSA id
	54928805A118
	for <linux-xfs@oss.sgi.com>; Fri,  3 Feb 2012 15:02:22 -0500 (EST)
Message-ID: <4F2C3D46.1010509@scalableinformatics.com>
Date: Fri, 03 Feb 2012 15:02:14 -0500
From: Joe Landman <landman@scalableinformatics.com>
MIME-Version: 1.0
Subject: A corruption that seems to span a few kernels
Reply-To: landman@scalableinformatics.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-xfs@oss.sgi.com

XFS file system, built using a 2.6.32.41 kernel.  External journals.

repair the file system, mount, turn on gluster (3.2.5), do a find, and 
get a corruption.  Actually it looks like xfs_repair doesn't fix the 
problem.

Rinse repeat, reproduce.  Works (procedure to generate the corruption) 
in 2.6.32.41.scalable, 2.6.39.1, 3.2.2

[  428.457044] XFS (sdc2): corrupt dinode 54105173, extent total = 1, 
nblocks = 0.
[  428.464596] ffff880bde999500: 49 4e 81 a4 01 02 00 01 00 00 04 65 00 
00 07 df  IN.........e....
[  428.473587] XFS (sdc2): Internal error xfs_iformat(1) at line 319 of 
file fs/xfs/xfs_inode.c.  Caller 0xffffffff8127b738
[  428.473589]
[  428.486388] Pid: 7562, comm: glusterfsd Not tainted 3.2.2.scalable #1
[  428.493014] Call Trace:
[  428.495544]  [<ffffffff812361aa>] xfs_error_report+0x3a/0x40
[  428.501391]  [<ffffffff8127b738>] ? xfs_iread+0x118/0x1a0
[  428.506894]  [<ffffffff81236208>] xfs_corruption_error+0x58/0x80
[  428.513027]  [<ffffffff8127b4b1>] xfs_iformat+0x401/0x570
[  428.518491]  [<ffffffff8127b738>] ? xfs_iread+0x118/0x1a0
[  428.524003]  [<ffffffff8127b738>] xfs_iread+0x118/0x1a0
[  428.529292]  [<ffffffff8123aba3>] xfs_iget+0x2d3/0x8b0
[  428.534537]  [<ffffffff8123a252>] ? xfs_iunlock+0x92/0x130
[  428.540122]  [<ffffffff81246c68>] xfs_lookup+0xb8/0x140
[  428.545413]  [<ffffffff8123fc59>] xfs_vn_lookup+0x59/0xa0
[  428.550922]  [<ffffffff8113f545>] ? d_alloc+0x75/0x90
[  428.556034]  [<ffffffff81134d14>] d_alloc_and_lookup+0x44/0x80
[  428.561976]  [<ffffffff81135213>] do_lookup+0x243/0x350
[  428.567326]  [<ffffffff8113867a>] path_lookupat+0xea/0x740
[  428.572942]  [<ffffffff8124fea2>] ? xfs_attr_get+0xb2/0xc0
[  428.578489]  [<ffffffff81138d00>] do_path_lookup+0x30/0xc0
[  428.584089]  [<ffffffff81139974>] user_path_at_empty+0x54/0xa0
[  428.589984]  [<ffffffff8111cf42>] ? kmem_cache_free+0x22/0x120
[  428.595932]  [<ffffffff81137901>] ? putname+0x31/0x50
[  428.601091]  [<ffffffff8113997f>] ? user_path_at_empty+0x5f/0xa0
[  428.607190]  [<ffffffff811399cc>] user_path_at+0xc/0x10
[  428.612586]  [<ffffffff8112ef46>] vfs_fstatat+0x46/0x80
[  428.617868]  [<ffffffff8112efe9>] vfs_lstat+0x19/0x20
[  428.623068]  [<ffffffff8112f00f>] sys_newlstat+0x1f/0x50
[  428.628626]  [<ffffffff8109e2bd>] ? audit_syscall_entry+0x16d/0x1d0
[  428.635009]  [<ffffffff8153f752>] system_call_fastpath+0x16/0x1b
[  428.641352] XFS (sdc2): Corruption detected. Unmount and run xfs_repair

[root@jr4-3 ~]# /etc/init.d/glusterd stop
Stopping glusterd:                                         [  OK  ]
[root@jr4-3 ~]# umount /data/brick-sdc2
[root@jr4-3 ~]# nohup xfs_repair -vvv -l /dev/md1 /dev/sdc2 > 
/tmp/out2.sdc 2>&1 &
[1] 7689

xfs_repair runs.  File system becomes normal.  Can reboot or remain in 
the same system.  Select any of the kernels.  Mount the file system.

I haven't checked whether this only happens with Gluster yet or not, 
working on it next ... will do the find w/o gluster on the backing 
store.  See if it croaks.

Currently booted into 3.2.2, can boot into something else.

Any hints?  I can reproduce it quite well, and xfs_repair seems to work 
... (repeated passes don't seem to help).

[root@jr4-3 ~]# grep "corrupt dinode 54105173" /var/log/messages
Feb  2 23:08:46 jr4-3 kernel: [ 1548.511502] Filesystem "sdc2": corrupt 
dinode 54105173, extent total = 1, nblocks = 0.  Unmount and run xfs_repair.
Feb  2 23:13:32 jr4-3 kernel: [ 1834.627251] Filesystem "sdc2": corrupt 
dinode 54105173, extent total = 1, nblocks = 0.  Unmount and run xfs_repair.
Feb  2 23:37:44 jr4-3 kernel: [ 3286.598877] Filesystem "sdc2": corrupt 
dinode 54105173, extent total = 1, nblocks = 0.  Unmount and run xfs_repair.
Feb  3 00:07:43 jr4-3 kernel: [ 5085.429344] Filesystem "sdc2": corrupt 
dinode 54105173, extent total = 1, nblocks = 0.  Unmount and run xfs_repair.
Feb  3 00:37:44 jr4-3 kernel: [ 6886.552328] Filesystem "sdc2": corrupt 
dinode 54105173, extent total = 1, nblocks = 0.  Unmount and run xfs_repair.
Feb  3 01:07:43 jr4-3 kernel: [ 8686.384728] Filesystem "sdc2": corrupt 
dinode 54105173, extent total = 1, nblocks = 0.  Unmount and run xfs_repair.
Feb  3 01:37:47 jr4-3 kernel: [10490.113301] Filesystem "sdc2": corrupt 
dinode 54105173, extent total = 1, nblocks = 0.  Unmount and run xfs_repair.
Feb  3 02:07:46 jr4-3 kernel: [12289.248980] Filesystem "sdc2": corrupt 
dinode 54105173, extent total = 1, nblocks = 0.  Unmount and run xfs_repair.
Feb  3 02:37:43 jr4-3 kernel: [14086.210521] Filesystem "sdc2": corrupt 
dinode 54105173, extent total = 1, nblocks = 0.  Unmount and run xfs_repair.
Feb  3 03:07:45 jr4-3 kernel: [15888.798065] Filesystem "sdc2": corrupt 
dinode 54105173, extent total = 1, nblocks = 0.  Unmount and run xfs_repair.
Feb  3 03:37:43 jr4-3 kernel: [17686.388882] Filesystem "sdc2": corrupt 
dinode 54105173, extent total = 1, nblocks = 0.  Unmount and run xfs_repair.
Feb  3 04:04:06 jr4-3 kernel: [19269.902522] Filesystem "sdc2": corrupt 
dinode 54105173, extent total = 1, nblocks = 0.  Unmount and run xfs_repair.
Feb  3 04:08:04 jr4-3 kernel: [19507.447343] Filesystem "sdc2": corrupt 
dinode 54105173, extent total = 1, nblocks = 0.  Unmount and run xfs_repair.
Feb  3 04:38:11 jr4-3 kernel: [21314.248443] Filesystem "sdc2": corrupt 
dinode 54105173, extent total = 1, nblocks = 0.  Unmount and run xfs_repair.
Feb  3 05:07:43 jr4-3 kernel: [23086.714157] Filesystem "sdc2": corrupt 
dinode 54105173, extent total = 1, nblocks = 0.  Unmount and run xfs_repair.
Feb  3 05:37:43 jr4-3 kernel: [24886.444238] Filesystem "sdc2": corrupt 
dinode 54105173, extent total = 1, nblocks = 0.  Unmount and run xfs_repair.
Feb  3 06:07:43 jr4-3 kernel: [26686.740589] Filesystem "sdc2": corrupt 
dinode 54105173, extent total = 1, nblocks = 0.  Unmount and run xfs_repair.
Feb  3 06:37:45 jr4-3 kernel: [28488.946147] Filesystem "sdc2": corrupt 
dinode 54105173, extent total = 1, nblocks = 0.  Unmount and run xfs_repair.
Feb  3 07:07:42 jr4-3 kernel: [30286.417803] Filesystem "sdc2": corrupt 
dinode 54105173, extent total = 1, nblocks = 0.  Unmount and run xfs_repair.
Feb  3 07:37:42 jr4-3 kernel: [32085.847705] Filesystem "sdc2": corrupt 
dinode 54105173, extent total = 1, nblocks = 0.  Unmount and run xfs_repair.
Feb  3 08:08:01 jr4-3 kernel: [33904.979795] Filesystem "sdc2": corrupt 
dinode 54105173, extent total = 1, nblocks = 0.  Unmount and run xfs_repair.
Feb  3 08:37:46 jr4-3 kernel: [35690.043019] Filesystem "sdc2": corrupt 
dinode 54105173, extent total = 1, nblocks = 0.  Unmount and run xfs_repair.
Feb  3 08:47:19 jr4-3 kernel: [36263.597170] Filesystem "sdc2": corrupt 
dinode 54105173, extent total = 1, nblocks = 0.  Unmount and run xfs_repair.
Feb  3 09:07:42 jr4-3 kernel: [37486.293617] Filesystem "sdc2": corrupt 
dinode 54105173, extent total = 1, nblocks = 0.  Unmount and run xfs_repair.
Feb  3 09:37:42 jr4-3 kernel: [39285.987621] Filesystem "sdc2": corrupt 
dinode 54105173, extent total = 1, nblocks = 0.  Unmount and run xfs_repair.
Feb  3 10:07:42 jr4-3 kernel: [41086.440845] Filesystem "sdc2": corrupt 
dinode 54105173, extent total = 1, nblocks = 0.  Unmount and run xfs_repair.
Feb  3 10:37:55 jr4-3 kernel: [42899.537075] Filesystem "sdc2": corrupt 
dinode 54105173, extent total = 1, nblocks = 0.  Unmount and run xfs_repair.
Feb  3 11:08:24 jr4-3 kernel: [  988.628970] Filesystem "sdc2": corrupt 
dinode 54105173, extent total = 1, nblocks = 0.  Unmount and run xfs_repair.
Feb  3 13:08:20 jr4-3 kernel: [ 2531.085884] Filesystem "sdc2": corrupt 
dinode 54105173, extent total = 1, nblocks = 0.  Unmount and run xfs_repair.
Feb  3 13:10:13 jr4-3 kernel: [ 2643.954262] Filesystem "sdc2": corrupt 
dinode 54105173, extent total = 1, nblocks = 0.  Unmount and run xfs_repair.
Feb  3 08:38:20 jr4-3 kernel: [  428.457044] XFS (sdc2): corrupt dinode 
54105173, extent total = 1, nblocks = 0.


Any clues/hints/suggestions?  Zero out that dinode (and if so, how?) 
Let me know if you want any additional information from this system.

Its a large RAID6, with battery backed ECC cache.  No disk events reported.

This appeared after finishing the xfs_repair

[root@jr4-3 ~]# [ 1102.898890] scsi_verify_blk_ioctl: 56 callbacks 
suppressed
[ 1102.904486] xfs_repair: sending ioctl 1261 to a partition!
[ 1102.910286] xfs_repair: sending ioctl 1261 to a partition!


Output from xfs_repair below.  Notes are in phase 3 and 4

phase 3:
data fork in regular inode 54105173 claims used block 6745835296

phase 4:
data fork in regular inode 54105173 claims used block 6745835296

xfs_repair doesn't seem to fix this, as a second pass through still 
indicates a problem.

First pass:

[root@jr4-3 ~]# cat !$
cat /tmp/out2.sdc
Phase 1 - find and verify superblock...
         - max_mem = 37094007, icount = 5448960, imem = 21285, dblock = 
4391112384, dmem = 2144097
         - block cache size set to 4359824 entries
Phase 2 - using external log on /dev/md1
         - zero log...
zero_log: head block 48836 tail block 48836
         - scan filesystem freespace and inode maps...
         - found root inode chunk
libxfs_bcache: 0x6814c0
Max supported entries = 4359824
Max utilized entries = 3278
Active entries = 3278
Hash table size = 544978
Hits = 0
Misses = 3278
Hit ratio =  0.00
MRU 0 entries =   3278 (100%)
MRU 1 entries =      0 (  0%)
MRU 2 entries =      0 (  0%)
MRU 3 entries =      0 (  0%)
MRU 4 entries =      0 (  0%)
MRU 5 entries =      0 (  0%)
MRU 6 entries =      0 (  0%)
MRU 7 entries =      0 (  0%)
MRU 8 entries =      0 (  0%)
MRU 9 entries =      0 (  0%)
MRU 10 entries =      0 (  0%)
MRU 11 entries =      0 (  0%)
MRU 12 entries =      0 (  0%)
MRU 13 entries =      0 (  0%)
MRU 14 entries =      0 (  0%)
MRU 15 entries =      0 (  0%)
Hash buckets with   0 entries 541912 (  0%)
Hash buckets with   1 entries   2903 ( 88%)
Hash buckets with   2 entries    129 (  7%)
Hash buckets with   3 entries     21 (  1%)
Hash buckets with   4 entries     11 (  1%)
Hash buckets with   5 entries      2 (  0%)
Phase 3 - for each AG...
         - scan and clear agi unlinked lists...
         - process known inodes and perform inode discovery...
         - agno = 0
data fork in regular inode 54105173 claims used block 6745835296
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
         - agno = 15
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
         - agno = 30
         - agno = 31
         - process newly discovered inodes...
libxfs_bcache: 0x6814c0
Max supported entries = 4359824
Max utilized entries = 1052814
Active entries = 1052814
Hash table size = 544978
Hits = 302945
Misses = 1052814
Hit ratio = 22.35
MRU 0 entries = 851716 ( 80%)
MRU 1 entries =   6724 (  0%)
MRU 2 entries =  68352 (  6%)
MRU 3 entries = 108276 ( 10%)
MRU 4 entries =   5278 (  0%)
MRU 5 entries =      0 (  0%)
MRU 6 entries =  12339 (  1%)
MRU 7 entries =     16 (  0%)
MRU 8 entries =      0 (  0%)
MRU 9 entries =      0 (  0%)
MRU 10 entries =      0 (  0%)
MRU 11 entries =      3 (  0%)
MRU 12 entries =    110 (  0%)
MRU 13 entries =      0 (  0%)
MRU 14 entries =      0 (  0%)
MRU 15 entries =      0 (  0%)
Hash buckets with   0 entries 206656 (  0%)
Hash buckets with   1 entries  86130 (  8%)
Hash buckets with   2 entries  71589 ( 13%)
Hash buckets with   3 entries  20312 (  5%)
Hash buckets with   4 entries  99262 ( 37%)
Hash buckets with   5 entries  25665 ( 12%)
Hash buckets with   6 entries  21611 ( 12%)
Hash buckets with   7 entries   3104 (  2%)
Hash buckets with   8 entries  10077 (  7%)
Hash buckets with   9 entries    535 (  0%)
Hash buckets with  10 entries     35 (  0%)
Hash buckets with  11 entries      2 (  0%)
Phase 4 - check for duplicate blocks...
         - setting up duplicate extent list...
         - check for inodes claiming duplicate blocks...
         - agno = 0
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
         - agno = 14
         - agno = 15
         - agno = 18
         - agno = 16
         - agno = 20
         - agno = 22
         - agno = 19
         - agno = 25
         - agno = 26
         - agno = 21
         - agno = 29
         - agno = 24
         - agno = 31
         - agno = 17
         - agno = 27
         - agno = 28
         - agno = 23
         - agno = 30
         - agno = 13
data fork in regular inode 54105173 claims used block 6745835296
libxfs_bcache: 0x6814c0
Max supported entries = 4359824
Max utilized entries = 1052814
Active entries = 1052814
Hash table size = 544978
Hits = 646498
Misses = 1052814
Hit ratio = 38.04
MRU 0 entries = 1052701 ( 99%)
MRU 1 entries =      0 (  0%)
MRU 2 entries =      0 (  0%)
MRU 3 entries =      0 (  0%)
MRU 4 entries =      0 (  0%)
MRU 5 entries =      0 (  0%)
MRU 6 entries =      0 (  0%)
MRU 7 entries =      0 (  0%)
MRU 8 entries =      0 (  0%)
MRU 9 entries =      0 (  0%)
MRU 10 entries =      0 (  0%)
MRU 11 entries =      3 (  0%)
MRU 12 entries =    110 (  0%)
MRU 13 entries =      0 (  0%)
MRU 14 entries =      0 (  0%)
MRU 15 entries =      0 (  0%)
Hash buckets with   0 entries 206656 (  0%)
Hash buckets with   1 entries  86130 (  8%)
Hash buckets with   2 entries  71589 ( 13%)
Hash buckets with   3 entries  20312 (  5%)
Hash buckets with   4 entries  99262 ( 37%)
Hash buckets with   5 entries  25665 ( 12%)
Hash buckets with   6 entries  21611 ( 12%)
Hash buckets with   7 entries   3104 (  2%)
Hash buckets with   8 entries  10077 (  7%)
Hash buckets with   9 entries    535 (  0%)
Hash buckets with  10 entries     35 (  0%)
Hash buckets with  11 entries      2 (  0%)
Phase 5 - rebuild AG headers and trees...
         - agno = 0
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
         - agno = 15
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
         - agno = 30
         - agno = 31
         - reset superblock...
libxfs_bcache: 0x6814c0
Max supported entries = 4359824
Max utilized entries = 1052814
Active entries = 1052814
Hash table size = 544978
Hits = 649707
Misses = 1052814
Hit ratio = 38.16
MRU 0 entries = 1052701 ( 99%)
MRU 1 entries =      0 (  0%)
MRU 2 entries =      0 (  0%)
MRU 3 entries =      0 (  0%)
MRU 4 entries =      0 (  0%)
MRU 5 entries =      0 (  0%)
MRU 6 entries =      0 (  0%)
MRU 7 entries =      0 (  0%)
MRU 8 entries =      0 (  0%)
MRU 9 entries =      0 (  0%)
MRU 10 entries =      0 (  0%)
MRU 11 entries =      3 (  0%)
MRU 12 entries =    110 (  0%)
MRU 13 entries =      0 (  0%)
MRU 14 entries =      0 (  0%)
MRU 15 entries =      0 (  0%)
Hash buckets with   0 entries 206656 (  0%)
Hash buckets with   1 entries  86130 (  8%)
Hash buckets with   2 entries  71589 ( 13%)
Hash buckets with   3 entries  20312 (  5%)
Hash buckets with   4 entries  99262 ( 37%)
Hash buckets with   5 entries  25665 ( 12%)
Hash buckets with   6 entries  21611 ( 12%)
Hash buckets with   7 entries   3104 (  2%)
Hash buckets with   8 entries  10077 (  7%)
Hash buckets with   9 entries    535 (  0%)
Hash buckets with  10 entries     35 (  0%)
Hash buckets with  11 entries      2 (  0%)
Phase 6 - check inode connectivity...
         - resetting contents of realtime bitmap and summary inodes
         - traversing filesystem ...
         - agno = 0
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
         - agno = 15
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
         - agno = 30
         - agno = 31
         - traversal finished ...
         - moving disconnected inodes to lost+found ...
libxfs_bcache: 0x6814c0
Max supported entries = 4359824
Max utilized entries = 1052845
Active entries = 1052845
Hash table size = 544978
Hits = 1854913
Misses = 1052845
Hit ratio = 63.79
MRU 0 entries = 1016092 ( 96%)
MRU 1 entries =      0 (  0%)
MRU 2 entries =      0 (  0%)
MRU 3 entries =      3 (  0%)
MRU 4 entries =    141 (  0%)
MRU 5 entries =      0 (  0%)
MRU 6 entries =      0 (  0%)
MRU 7 entries =  11363 (  1%)
MRU 8 entries =  25246 (  2%)
MRU 9 entries =      0 (  0%)
MRU 10 entries =      0 (  0%)
MRU 11 entries =      0 (  0%)
MRU 12 entries =      0 (  0%)
MRU 13 entries =      0 (  0%)
MRU 14 entries =      0 (  0%)
MRU 15 entries =      0 (  0%)
Hash buckets with   0 entries 206646 (  0%)
Hash buckets with   1 entries  86134 (  8%)
Hash buckets with   2 entries  71593 ( 13%)
Hash buckets with   3 entries  20312 (  5%)
Hash buckets with   4 entries  99256 ( 37%)
Hash buckets with   5 entries  25670 ( 12%)
Hash buckets with   6 entries  21614 ( 12%)
Hash buckets with   7 entries   3104 (  2%)
Hash buckets with   8 entries  10077 (  7%)
Hash buckets with   9 entries    535 (  0%)
Hash buckets with  10 entries     35 (  0%)
Hash buckets with  11 entries      2 (  0%)
Phase 7 - verify and correct link counts...
libxfs_bcache: 0x6814c0
Max supported entries = 4359824
Max utilized entries = 1052845
Active entries = 1052845
Hash table size = 544978
Hits = 1854913
Misses = 1052845
Hit ratio = 63.79
MRU 0 entries = 1016092 ( 96%)
MRU 1 entries =      0 (  0%)
MRU 2 entries =      0 (  0%)
MRU 3 entries =      3 (  0%)
MRU 4 entries =    141 (  0%)
MRU 5 entries =      0 (  0%)
MRU 6 entries =      0 (  0%)
MRU 7 entries =  11363 (  1%)
MRU 8 entries =  25246 (  2%)
MRU 9 entries =      0 (  0%)
MRU 10 entries =      0 (  0%)
MRU 11 entries =      0 (  0%)
MRU 12 entries =      0 (  0%)
MRU 13 entries =      0 (  0%)
MRU 14 entries =      0 (  0%)
MRU 15 entries =      0 (  0%)
Hash buckets with   0 entries 206646 (  0%)
Hash buckets with   1 entries  86134 (  8%)
Hash buckets with   2 entries  71593 ( 13%)
Hash buckets with   3 entries  20312 (  5%)
Hash buckets with   4 entries  99256 ( 37%)
Hash buckets with   5 entries  25670 ( 12%)
Hash buckets with   6 entries  21614 ( 12%)
Hash buckets with   7 entries   3104 (  2%)
Hash buckets with   8 entries  10077 (  7%)
Hash buckets with   9 entries    535 (  0%)
Hash buckets with  10 entries     35 (  0%)
Hash buckets with  11 entries      2 (  0%)

         XFS_REPAIR Summary    Fri Feb  3 08:49:34 2012

Phase		Start		End		Duration
Phase 1:	02/03 08:43:06	02/03 08:43:06	
Phase 2:	02/03 08:43:06	02/03 08:43:11	5 seconds
Phase 3:	02/03 08:43:11	02/03 08:48:48	5 minutes, 37 seconds
Phase 4:	02/03 08:48:48	02/03 08:49:26	38 seconds
Phase 5:	02/03 08:49:26	02/03 08:49:27	1 second
Phase 6:	02/03 08:49:27	02/03 08:49:33	6 seconds
Phase 7:	02/03 08:49:33	02/03 08:49:33	

Total run time: 6 minutes, 27 seconds
done


Second pass:

[root@jr4-3 ~]# cat /tmp/out3.sdc
Phase 1 - find and verify superblock...
         - max_mem = 37094007, icount = 5448960, imem = 21285, dblock = 
4391112384, dmem = 2144097
         - block cache size set to 4359824 entries
Phase 2 - using external log on /dev/md1
         - zero log...
zero_log: head block 2 tail block 2
         - scan filesystem freespace and inode maps...
         - found root inode chunk
libxfs_bcache: 0x6814c0
Max supported entries = 4359824
Max utilized entries = 3240
Active entries = 3240
Hash table size = 544978
Hits = 0
Misses = 3240
Hit ratio =  0.00
MRU 0 entries =   3240 (100%)
MRU 1 entries =      0 (  0%)
MRU 2 entries =      0 (  0%)
MRU 3 entries =      0 (  0%)
MRU 4 entries =      0 (  0%)
MRU 5 entries =      0 (  0%)
MRU 6 entries =      0 (  0%)
MRU 7 entries =      0 (  0%)
MRU 8 entries =      0 (  0%)
MRU 9 entries =      0 (  0%)
MRU 10 entries =      0 (  0%)
MRU 11 entries =      0 (  0%)
MRU 12 entries =      0 (  0%)
MRU 13 entries =      0 (  0%)
MRU 14 entries =      0 (  0%)
MRU 15 entries =      0 (  0%)
Hash buckets with   0 entries 541938 (  0%)
Hash buckets with   1 entries   2881 ( 88%)
Hash buckets with   2 entries    127 (  7%)
Hash buckets with   3 entries     23 (  2%)
Hash buckets with   4 entries      9 (  1%)
Phase 3 - for each AG...
         - scan and clear agi unlinked lists...
         - process known inodes and perform inode discovery...
         - agno = 0
data fork in regular inode 54105173 claims used block 6745835296
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
         - agno = 15
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
         - agno = 30
         - agno = 31
         - process newly discovered inodes...
libxfs_bcache: 0x6814c0
Max supported entries = 4359824
Max utilized entries = 1052776
Active entries = 1052776
Hash table size = 544978
Hits = 302945
Misses = 1052776
Hit ratio = 22.35
MRU 0 entries = 851678 ( 80%)
MRU 1 entries =   6724 (  0%)
MRU 2 entries =  68352 (  6%)
MRU 3 entries = 107924 ( 10%)
MRU 4 entries =   5314 (  0%)
MRU 5 entries =      0 (  0%)
MRU 6 entries =  12655 (  1%)
MRU 7 entries =     16 (  0%)
MRU 8 entries =      0 (  0%)
MRU 9 entries =      0 (  0%)
MRU 10 entries =      0 (  0%)
MRU 11 entries =      3 (  0%)
MRU 12 entries =    110 (  0%)
MRU 13 entries =      0 (  0%)
MRU 14 entries =      0 (  0%)
MRU 15 entries =      0 (  0%)
Hash buckets with   0 entries 206666 (  0%)
Hash buckets with   1 entries  86129 (  8%)
Hash buckets with   2 entries  71585 ( 13%)
Hash buckets with   3 entries  20311 (  5%)
Hash buckets with   4 entries  99263 ( 37%)
Hash buckets with   5 entries  25662 ( 12%)
Hash buckets with   6 entries  21611 ( 12%)
Hash buckets with   7 entries   3103 (  2%)
Hash buckets with   8 entries  10076 (  7%)
Hash buckets with   9 entries    535 (  0%)
Hash buckets with  10 entries     35 (  0%)
Hash buckets with  11 entries      2 (  0%)
Phase 4 - check for duplicate blocks...
         - setting up duplicate extent list...
         - check for inodes claiming duplicate blocks...
         - agno = 0
         - agno = 2
         - agno = 5
         - agno = 7
         - agno = 1
         - agno = 3
         - agno = 4
         - agno = 11
         - agno = 8
         - agno = 14
         - agno = 15
         - agno = 9
         - agno = 17
         - agno = 18
         - agno = 19
         - agno = 10
         - agno = 21
         - agno = 22
         - agno = 23
         - agno = 24
         - agno = 6
         - agno = 12
         - agno = 25
         - agno = 27
         - agno = 26
         - agno = 20
         - agno = 28
         - agno = 16
         - agno = 31
         - agno = 13
         - agno = 29
         - agno = 30
data fork in regular inode 54105173 claims used block 6745835296
libxfs_bcache: 0x6814c0
Max supported entries = 4359824
Max utilized entries = 1052776
Active entries = 1052776
Hash table size = 544978
Hits = 646498
Misses = 1052776
Hit ratio = 38.05
MRU 0 entries = 1052663 ( 99%)
MRU 1 entries =      0 (  0%)
MRU 2 entries =      0 (  0%)
MRU 3 entries =      0 (  0%)
MRU 4 entries =      0 (  0%)
MRU 5 entries =      0 (  0%)
MRU 6 entries =      0 (  0%)
MRU 7 entries =      0 (  0%)
MRU 8 entries =      0 (  0%)
MRU 9 entries =      0 (  0%)
MRU 10 entries =      0 (  0%)
MRU 11 entries =      3 (  0%)
MRU 12 entries =    110 (  0%)
MRU 13 entries =      0 (  0%)
MRU 14 entries =      0 (  0%)
MRU 15 entries =      0 (  0%)
Hash buckets with   0 entries 206666 (  0%)
Hash buckets with   1 entries  86129 (  8%)
Hash buckets with   2 entries  71585 ( 13%)
Hash buckets with   3 entries  20311 (  5%)
Hash buckets with   4 entries  99263 ( 37%)
Hash buckets with   5 entries  25662 ( 12%)
Hash buckets with   6 entries  21611 ( 12%)
Hash buckets with   7 entries   3103 (  2%)
Hash buckets with   8 entries  10076 (  7%)
Hash buckets with   9 entries    535 (  0%)
Hash buckets with  10 entries     35 (  0%)
Hash buckets with  11 entries      2 (  0%)
Phase 5 - rebuild AG headers and trees...
         - agno = 0
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
         - agno = 15
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
         - agno = 30
         - agno = 31
         - reset superblock...
libxfs_bcache: 0x6814c0
Max supported entries = 4359824
Max utilized entries = 1052776
Active entries = 1052776
Hash table size = 544978
Hits = 649707
Misses = 1052776
Hit ratio = 38.16
MRU 0 entries = 1052663 ( 99%)
MRU 1 entries =      0 (  0%)
MRU 2 entries =      0 (  0%)
MRU 3 entries =      0 (  0%)
MRU 4 entries =      0 (  0%)
MRU 5 entries =      0 (  0%)
MRU 6 entries =      0 (  0%)
MRU 7 entries =      0 (  0%)
MRU 8 entries =      0 (  0%)
MRU 9 entries =      0 (  0%)
MRU 10 entries =      0 (  0%)
MRU 11 entries =      3 (  0%)
MRU 12 entries =    110 (  0%)
MRU 13 entries =      0 (  0%)
MRU 14 entries =      0 (  0%)
MRU 15 entries =      0 (  0%)
Hash buckets with   0 entries 206666 (  0%)
Hash buckets with   1 entries  86129 (  8%)
Hash buckets with   2 entries  71585 ( 13%)
Hash buckets with   3 entries  20311 (  5%)
Hash buckets with   4 entries  99263 ( 37%)
Hash buckets with   5 entries  25662 ( 12%)
Hash buckets with   6 entries  21611 ( 12%)
Hash buckets with   7 entries   3103 (  2%)
Hash buckets with   8 entries  10076 (  7%)
Hash buckets with   9 entries    535 (  0%)
Hash buckets with  10 entries     35 (  0%)
Hash buckets with  11 entries      2 (  0%)
Phase 6 - check inode connectivity...
         - resetting contents of realtime bitmap and summary inodes
         - traversing filesystem ...
         - agno = 0
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
         - agno = 15
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
         - agno = 30
         - agno = 31
         - traversal finished ...
         - moving disconnected inodes to lost+found ...
libxfs_bcache: 0x6814c0
Max supported entries = 4359824
Max utilized entries = 1052807
Active entries = 1052807
Hash table size = 544978
Hits = 1854913
Misses = 1052807
Hit ratio = 63.79
MRU 0 entries = 1016054 ( 96%)
MRU 1 entries =      0 (  0%)
MRU 2 entries =      0 (  0%)
MRU 3 entries =      3 (  0%)
MRU 4 entries =    141 (  0%)
MRU 5 entries =      0 (  0%)
MRU 6 entries =      0 (  0%)
MRU 7 entries =  11363 (  1%)
MRU 8 entries =  25246 (  2%)
MRU 9 entries =      0 (  0%)
MRU 10 entries =      0 (  0%)
MRU 11 entries =      0 (  0%)
MRU 12 entries =      0 (  0%)
MRU 13 entries =      0 (  0%)
MRU 14 entries =      0 (  0%)
MRU 15 entries =      0 (  0%)
Hash buckets with   0 entries 206656 (  0%)
Hash buckets with   1 entries  86133 (  8%)
Hash buckets with   2 entries  71589 ( 13%)
Hash buckets with   3 entries  20311 (  5%)
Hash buckets with   4 entries  99257 ( 37%)
Hash buckets with   5 entries  25667 ( 12%)
Hash buckets with   6 entries  21614 ( 12%)
Hash buckets with   7 entries   3103 (  2%)
Hash buckets with   8 entries  10076 (  7%)
Hash buckets with   9 entries    535 (  0%)
Hash buckets with  10 entries     35 (  0%)
Hash buckets with  11 entries      2 (  0%)
Phase 7 - verify and correct link counts...
libxfs_bcache: 0x6814c0
Max supported entries = 4359824
Max utilized entries = 1052807
Active entries = 1052807
Hash table size = 544978
Hits = 1854913
Misses = 1052807
Hit ratio = 63.79
MRU 0 entries = 1016054 ( 96%)
MRU 1 entries =      0 (  0%)
MRU 2 entries =      0 (  0%)
MRU 3 entries =      3 (  0%)
MRU 4 entries =    141 (  0%)
MRU 5 entries =      0 (  0%)
MRU 6 entries =      0 (  0%)
MRU 7 entries =  11363 (  1%)
MRU 8 entries =  25246 (  2%)
MRU 9 entries =      0 (  0%)
MRU 10 entries =      0 (  0%)
MRU 11 entries =      0 (  0%)
MRU 12 entries =      0 (  0%)
MRU 13 entries =      0 (  0%)
MRU 14 entries =      0 (  0%)
MRU 15 entries =      0 (  0%)
Hash buckets with   0 entries 206656 (  0%)
Hash buckets with   1 entries  86133 (  8%)
Hash buckets with   2 entries  71589 ( 13%)
Hash buckets with   3 entries  20311 (  5%)
Hash buckets with   4 entries  99257 ( 37%)
Hash buckets with   5 entries  25667 ( 12%)
Hash buckets with   6 entries  21614 ( 12%)
Hash buckets with   7 entries   3103 (  2%)
Hash buckets with   8 entries  10076 (  7%)
Hash buckets with   9 entries    535 (  0%)
Hash buckets with  10 entries     35 (  0%)
Hash buckets with  11 entries      2 (  0%)

         XFS_REPAIR Summary    Fri Feb  3 09:00:02 2012

Phase		Start		End		Duration
Phase 1:	02/03 08:53:37	02/03 08:53:37	
Phase 2:	02/03 08:53:37	02/03 08:53:38	1 second
Phase 3:	02/03 08:53:38	02/03 08:59:16	5 minutes, 38 seconds
Phase 4:	02/03 08:59:16	02/03 08:59:54	38 seconds
Phase 5:	02/03 08:59:54	02/03 08:59:55	1 second
Phase 6:	02/03 08:59:55	02/03 09:00:01	6 seconds
Phase 7:	02/03 09:00:01	02/03 09:00:01	

Total run time: 6 minutes, 24 seconds
done



-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics Inc.
email: landman@scalableinformatics.com
web  : http://scalableinformatics.com
        http://scalableinformatics.com/sicluster
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
