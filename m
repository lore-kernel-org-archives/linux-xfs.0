Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7EFA17F56
	for <xfs@oss.sgi.com>; Mon,  3 Jun 2013 03:09:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6FDA9304043
	for <xfs@oss.sgi.com>; Mon,  3 Jun 2013 01:09:15 -0700 (PDT)
Received: from mx4-phx2.redhat.com (mx4-phx2.redhat.com [209.132.183.25]) by
	cuda.sgi.com with ESMTP id E5mFwXcAcUzGb8Oh for
	<xfs@oss.sgi.com>; Mon, 03 Jun 2013 01:09:08 -0700 (PDT)
Date: Mon, 3 Jun 2013 04:09:06 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
Message-ID: <131268379.10596360.1370246946902.JavaMail.root@redhat.com>
In-Reply-To: <51895115.90108@sandeen.net>
References: <1871204531.7584919.1367826613792.JavaMail.root@redhat.com>
	<5187BEA5.4040107@sandeen.net>
	<647316680.8155487.1367913231441.JavaMail.root@redhat.com>
	<51895115.90108@sandeen.net>
Subject: Re: 3.9.0: XFS rootfs corruption
MIME-Version: 1.0
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


> since it's the root fs, you might need to do it from some sort of rescue
> shell, then just do xfs_metadump /dev/<device> <metadump filename>
> 
> the resulting file should compress further with something like bzip2.
Hmm, there is no such command in dracut rescue shell,
# xfs_metadump /dev/mapper/rhel_ibm--p720--01--lp4-root  metadump
sh: xfs_metadump: command not found
# xfs_<tab completion>
xfs_check   xfs_db      xfs_repair

Here were my other attempts to get it back again but seems destroy all the
previous transactions:
:/mnt# xfs_check /dev/mapper/rhel_ibm--p720--01--lp4-root
ERROR: The filesystem has valuable metadata changes in a log which needs to
be replayed.  Mount the filesystem to replay the log, and unmount it before
re-running xfs_check.  If you are unable to mount the filesystem, then use
the xfs_repair -L option to destroy the log and attempt a repair.
Note that destroying the log may cause corruption -- please attempt a mount
of the filesystem before doing this.
:/# mount /dev/mapper/rhel_ibm--p720--01--lp4-root /mnt2
[  675.871991] XFS (dm-1): Mounting Filesystem
[  675.982416] XFS (dm-1): Starting recovery (logdev: internal)
[  676.029790] XFS: Internal error XFS_WANT_CORRUPTED_RETURN at line 169 of file fs/xfs/xfs_dir2_data.c.  Caller 0xd000000001644f5c
[  676.029790] 
[  676.029801] CPU: 1 PID: 463 Comm: mount Tainted: GF            3.10.0-rc4 #1
[  676.029805] Call Trace:
[  676.029811] [c0000001f82a2b90] [c000000000014eac] .show_stack+0x7c/0x1f0 (unreliable)
[  676.029819] [c0000001f82a2c60] [c0000000007444fc] .dump_stack+0x28/0x3c
[  676.029846] [c0000001f82a2cd0] [d000000001600674] .xfs_error_report+0x54/0x70 [xfs]
[  676.029872] [c0000001f82a2d40] [d0000000016479f4] .__xfs_dir3_data_check+0x6c4/0x820 [xfs]
[  676.029898] [c0000001f82a2e40] [d000000001644f5c] .xfs_dir3_block_verify+0xbc/0xf0 [xfs]
[  676.029922] [c0000001f82a2ec0] [d00000000164510c] .xfs_dir3_block_write_verify+0x3c/0x1d0 [xfs]
[  676.029946] [c0000001f82a2f70] [d0000000015fdb74] ._xfs_buf_ioapply+0xd4/0x410 [xfs]
[  676.029968] [c0000001f82a30b0] [d0000000015fdfbc] .xfs_buf_iorequest+0x4c/0xe0 [xfs]
[  676.029991] [c0000001f82a3140] [d0000000015fe0b4] .xfs_bdstrat_cb+0x64/0x120 [xfs]
[  676.030014] [c0000001f82a31d0] [d0000000015fe2c4] .__xfs_buf_delwri_submit+0x154/0x2b0 [xfs]
[  676.030037] [c0000001f82a32b0] [d0000000015ff308] .xfs_buf_delwri_submit+0x38/0xd0 [xfs]
[  676.030062] [c0000001f82a3350] [d000000001662494] .xlog_recover_commit_trans+0xf4/0x1a0 [xfs]
[  676.030088] [c0000001f82a3410] [d00000000166279c] .xlog_recover_process_data+0x25c/0x370 [xfs]
[  676.030114] [c0000001f82a34e0] [d0000000016629f8] .xlog_do_recovery_pass+0x148/0x590 [xfs]
[  676.030139] [c0000001f82a3650] [d000000001662ed8] .xlog_do_log_recovery+0x98/0x110 [xfs]
[  676.030166] [c0000001f82a36e0] [d000000001662f70] .xlog_do_recover+0x20/0x160 [xfs]
[  676.030191] [c0000001f82a3770] [d000000001663148] .xlog_recover+0x98/0x110 [xfs]
[  676.030218] [c0000001f82a3800] [d00000000166d910] .xfs_log_mount+0xa0/0x1d0 [xfs]
[  676.030244] [c0000001f82a3890] [d000000001666dc8] .xfs_mountfs+0x3c8/0x780 [xfs]
[  676.030267] [c0000001f82a3940] [d000000001614c9c] .xfs_fs_fill_super+0x30c/0x3a0 [xfs]
[  676.030274] [c0000001f82a39e0] [c000000000214d58] .mount_bdev+0x258/0x2a0
[  676.030296] [c0000001f82a3ab0] [d000000001612758] .xfs_fs_mount+0x18/0x30 [xfs]
[  676.030302] [c0000001f82a3b20] [c000000000215be0] .mount_fs+0x70/0x230
[  676.030308] [c0000001f82a3be0] [c0000000002381c8] .vfs_kern_mount+0x58/0x130
[  676.030313] [c0000001f82a3c90] [c00000000023b390] .do_mount+0x2d0/0xb30
[  676.030319] [c0000001f82a3d70] [c00000000023bca0] .SyS_mount+0xb0/0x110
[  676.030324] [c0000001f82a3e30] [c000000000009e54] syscall_exit+0x0/0x98
[  676.030330] c0000001f9079000: 58 44 32 42 0a 68 02 d8 00 78 00 18 00 d8 00 18  XD2B.h...x......
[  676.030335] c0000001f9079010: 00 00 00 00 04 22 80 89 01 2e 00 01 e2 38 00 10  .....".......8..
[  676.030340] c0000001f9079020: 00 00 00 00 00 00 00 8f 02 2e 2e 67 67 65 00 20  ...........gge. 
[  676.030344] c0000001f9079030: 00 00 00 00 04 22 d0 8c 0c 74 6d 70 59 42 33 52  ....."...tmpYB3R
[  676.030350] XFS (dm-1): Internal error xfs_dir3_block_write_verify at line 109 of file fs/xfs/xfs_dir2_block.c.  Caller 0xd0000000015fdb74
[  676.030350] 
[  676.030357] CPU: 1 PID: 463 Comm: mount Tainted: GF            3.10.0-rc4 #1
[  676.030361] Call Trace:
[  676.030364] [c0000001f82a2c60] [c000000000014eac] .show_stack+0x7c/0x1f0 (unreliable)
[  676.030370] [c0000001f82a2d30] [c0000000007444fc] .dump_stack+0x28/0x3c
[  676.030392] [c0000001f82a2da0] [d000000001600674] .xfs_error_report+0x54/0x70 [xfs]
[  676.030415] [c0000001f82a2e10] [d00000000160070c] .xfs_corruption_error+0x7c/0xb0 [xfs]
[  676.030440] [c0000001f82a2ec0] [d00000000164521c] .xfs_dir3_block_write_verify+0x14c/0x1d0 [xfs]
[  676.030463] [c0000001f82a2f70] [d0000000015fdb74] ._xfs_buf_ioapply+0xd4/0x410 [xfs]
[  676.030485] [c0000001f82a30b0] [d0000000015fdfbc] .xfs_buf_iorequest+0x4c/0xe0 [xfs]
[  676.030509] [c0000001f82a3140] [d0000000015fe0b4] .xfs_bdstrat_cb+0x64/0x120 [xfs]
[  676.030532] [c0000001f82a31d0] [d0000000015fe2c4] .__xfs_buf_delwri_submit+0x154/0x2b0 [xfs]
[  676.030554] [c0000001f82a32b0] [d0000000015ff308] .xfs_buf_delwri_submit+0x38/0xd0 [xfs]
[  676.030580] [c0000001f82a3350] [d000000001662494] .xlog_recover_commit_trans+0xf4/0x1a0 [xfs]
[  676.030606] [c0000001f82a3410] [d00000000166279c] .xlog_recover_process_data+0x25c/0x370 [xfs]
[  676.030632] [c0000001f82a34e0] [d0000000016629f8] .xlog_do_recovery_pass+0x148/0x590 [xfs]
[  676.030658] [c0000001f82a3650] [d000000001662ed8] .xlog_do_log_recovery+0x98/0x110 [xfs]
[  676.030684] [c0000001f82a36e0] [d000000001662f70] .xlog_do_recover+0x20/0x160 [xfs]
[  676.030710] [c0000001f82a3770] [d000000001663148] .xlog_recover+0x98/0x110 [xfs]
[  676.030735] [c0000001f82a3800] [d00000000166d910] .xfs_log_mount+0xa0/0x1d0 [xfs]
[  676.030761] [c0000001f82a3890] [d000000001666dc8] .xfs_mountfs+0x3c8/0x780 [xfs]
[  676.030784] [c0000001f82a3940] [d000000001614c9c] .xfs_fs_fill_super+0x30c/0x3a0 [xfs]
[  676.030791] [c0000001f82a39e0] [c000000000214d58] .mount_bdev+0x258/0x2a0
[  676.030814] [c0000001f82a3ab0] [d000000001612758] .xfs_fs_mount+0x18/0x30 [xfs]
[  676.030820] [c0000001f82a3b20] [c000000000215be0] .mount_fs+0x70/0x230
[  676.030825] [c0000001f82a3be0] [c0000000002381c8] .vfs_kern_mount+0x58/0x130
[  676.030830] [c0000001f82a3c90] [c00000000023b390] .do_mount+0x2d0/0xb30
[  676.030835] [c0000001f82a3d70] [c00000000023bca0] .SyS_mount+0xb0/0x110
[  676.030840] [c0000001f82a3e30] [c000000000009e54] syscall_exit+0x0/0x98
[  676.030844] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  676.030849] XFS (dm-1): xfs_do_force_shutdown(0x8) called from line 1365 of file fs/xfs/xfs_buf.c.  Return address = 0xd0000000015fdba0
[  676.030855] XFS (dm-1): Corruption of in-memory data detected.  Shutting down filesystem
[  676.030859] XFS (dm-1): Please umount the filesystem and rectify the problem(s)
[  676.030866] XFS (dm-1): metadata I/O error: block 0x1cacb80 ("xlog_recover_iodone") error 5 numblks 16
[  676.030872] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd00000000165d600
[  676.030908] XFS (dm-1): metadata I/O error: block 0x1a14580 ("xlog_recover_iodone") error 117 numblks 8
[  676.030913] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd00000000165d600
[  676.049998] XFS (dm-1): log mount/recovery failed: error 117
[  676.050042] XFS (dm-1): log mount failed
mount: mount /dev/mapper/rhel_ibm--p720--01--lp4-root on /mnt2 failed: Structure needs cleaning
:/# xfs_repair -L  /dev/mapper/rhel_ibm--p720--01--lp4-root
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
ALERT: The filesystem has valuable metadata changes in a log which is being
destroyed because the -L option was used.
        - scan filesystem freespace and inode maps...
agi_freecount 10, counted 8 in ag 1
sb_icount 149248, counted 149312
sb_ifree 216, counted 27
sb_fdblocks 10788304, counted 10784210
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
bad entry count in block 8388610 of directory inode 113571
bad entry count in block 8388610 of directory inode 1178385
bad entry count in block 8388610 of directory inode 1519037
        - agno = 1
bad entry count in block 8388610 of directory inode 67109016
bad entry count in block 8388610 of directory inode 67929825
bad entry count in block 8388610 of directory inode 69407749
bad entry count in block 8388610 of directory inode 69490381
bad entry count in block 8388610 of directory inode 69534546
bad entry count in block 8388610 of directory inode 69842112
        - agno = 2
bad entry count in block 8388610 of directory inode 134321722
bad entry count in block 8388610 of directory inode 144715871
        - agno = 3
bad entry count in block 8388610 of directory inode 201326727
bad entry count in block 8388610 of directory inode 201326754
bad entry count in block 8388610 of directory inode 201327172
bad entry count in block 8388610 of directory inode 201951914
bad entry count in block 8388610 of directory inode 202409289
bad entry count in block 8388610 of directory inode 206245507
bad entry count in block 8388610 of directory inode 206253502
bad entry count in block 8388610 of directory inode 206308010
bad entry count in block 8388610 of directory inode 206632072
bad entry count in block 8388610 of directory inode 212625436
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 3
        - agno = 2
        - agno = 1
entry "tmp.Iive34" at block 0 offset 2664 in directory inode 69369993 references free inode 69015237
	clearing inode number in entry at offset 2664...
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
rebuilding directory inode 113571
rebuilding directory inode 1178385
rebuilding directory inode 1519037
rebuilding directory inode 67109016
rebuilding directory inode 67929825
bad hash table for directory inode 69369993 (no data entry): rebuilding
rebuilding directory inode 69369993
rebuilding directory inode 69407749
rebuilding directory inode 69490381
rebuilding directory inode 69534546
rebuilding directory inode 69842112
rebuilding directory inode 134321722
rebuilding directory inode 134321726
rebuilding directory inode 136067648
rebuilding directory inode 144715871
rebuilding directory inode 201326727
rebuilding directory inode 201326754
rebuilding directory inode 201327172
rebuilding directory inode 201951914
rebuilding directory inode 202409289
rebuilding directory inode 206245507
rebuilding directory inode 206253502
rebuilding directory inode 206308010
rebuilding directory inode 206632072
rebuilding directory inode 212625436
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
done
:/# mount /dev/mapper/rhel_ibm--p720--01--lp4-root /mnt2
[  715.323289] XFS (dm-1): Mounting Filesystem
[  715.410055] XFS (dm-1): Ending clean mount
:/# umount /mnt2
:/# xfs_check /dev/mapper/rhel_ibm--p720--01--lp4-root

# cat sosreport.txt
+ cat /proc/self/mountinfo
1 1 0:1 / / rw shared:1 - rootfs rootfs rw
16 1 0:3 / /proc rw,nosuid,nodev,noexec,relatime shared:2 - proc proc rw
17 1 0:15 / /sys rw,nosuid,nodev,noexec,relatime shared:3 - sysfs sysfs rw
18 1 0:5 / /dev rw,nosuid shared:9 - devtmpfs devtmpfs rw,size=3995520k,nr_inodes=62430,mode=755
19 17 0:16 / /sys/kernel/security rw,nosuid,nodev,noexec,relatime shared:4 - securityfs securityfs rw
20 17 0:14 / /sys/fs/selinux rw,relatime shared:5 - selinuxfs selinuxfs rw
21 18 0:17 / /dev/shm rw,nosuid,nodev shared:10 - tmpfs tmpfs rw
22 18 0:10 / /dev/pts rw,nosuid,noexec,relatime shared:11 - devpts devpts rw,gid=5,mode=620,ptmxmode=000
23 1 0:18 / /run rw,nosuid,nodev shared:12 - tmpfs tmpfs rw,mode=755
24 17 0:19 / /sys/fs/cgroup rw,nosuid,nodev,noexec shared:6 - tmpfs tmpfs rw,mode=755
25 24 0:20 / /sys/fs/cgroup/systemd rw,nosuid,nodev,noexec,relatime shared:7 - cgroup cgroup rw,release_agent=/usr/lib/systemd/systemd-cgroups-agent,name=systemd
26 17 0:21 / /sys/fs/pstore rw,nosuid,nodev,noexec,relatime shared:8 - pstore pstore rw
27 24 0:22 / /sys/fs/cgroup/cpuset rw,nosuid,nodev,noexec,relatime shared:13 - cgroup cgroup rw,cpuset
28 24 0:23 / /sys/fs/cgroup/cpu,cpuacct rw,nosuid,nodev,noexec,relatime shared:14 - cgroup cgroup rw,cpuacct,cpu
29 24 0:24 / /sys/fs/cgroup/memory rw,nosuid,nodev,noexec,relatime shared:15 - cgroup cgroup rw,memory
30 24 0:25 / /sys/fs/cgroup/devices rw,nosuid,nodev,noexec,relatime shared:16 - cgroup cgroup rw,devices
31 24 0:26 / /sys/fs/cgroup/freezer rw,nosuid,nodev,noexec,relatime shared:17 - cgroup cgroup rw,freezer
32 24 0:27 / /sys/fs/cgroup/net_cls rw,nosuid,nodev,noexec,relatime shared:18 - cgroup cgroup rw,net_cls
33 24 0:28 / /sys/fs/cgroup/blkio rw,nosuid,nodev,noexec,relatime shared:19 - cgroup cgroup rw,blkio
34 24 0:29 / /sys/fs/cgroup/perf_event rw,nosuid,nodev,noexec,relatime shared:20 - cgroup cgroup rw,perf_event
+ cat /proc/mounts
rootfs / rootfs rw 0 0
proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
sysfs /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
devtmpfs /dev devtmpfs rw,nosuid,size=3995520k,nr_inodes=62430,mode=755 0 0
securityfs /sys/kernel/security securityfs rw,nosuid,nodev,noexec,relatime 0 0
selinuxfs /sys/fs/selinux selinuxfs rw,relatime 0 0
tmpfs /dev/shm tmpfs rw,nosuid,nodev 0 0
devpts /dev/pts devpts rw,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000 0 0
tmpfs /run tmpfs rw,nosuid,nodev,mode=755 0 0
tmpfs /sys/fs/cgroup tmpfs rw,nosuid,nodev,noexec,mode=755 0 0
cgroup /sys/fs/cgroup/systemd cgroup rw,nosuid,nodev,noexec,relatime,release_agent=/usr/lib/systemd/systemd-cgroups-agent,name=systemd 0 0
pstore /sys/fs/pstore pstore rw,nosuid,nodev,noexec,relatime 0 0
cgroup /sys/fs/cgroup/cpuset cgroup rw,nosuid,nodev,noexec,relatime,cpuset 0 0
cgroup /sys/fs/cgroup/cpu,cpuacct cgroup rw,nosuid,nodev,noexec,relatime,cpuacct,cpu 0 0
cgroup /sys/fs/cgroup/memory cgroup rw,nosuid,nodev,noexec,relatime,memory 0 0
cgroup /sys/fs/cgroup/devices cgroup rw,nosuid,nodev,noexec,relatime,devices 0 0
cgroup /sys/fs/cgroup/freezer cgroup rw,nosuid,nodev,noexec,relatime,freezer 0 0
cgroup /sys/fs/cgroup/net_cls cgroup rw,nosuid,nodev,noexec,relatime,net_cls 0 0
cgroup /sys/fs/cgroup/blkio cgroup rw,nosuid,nodev,noexec,relatime,blkio 0 0
cgroup /sys/fs/cgroup/perf_event cgroup rw,nosuid,nodev,noexec,relatime,perf_event 0 0
+ blkid
/dev/sda2: UUID="95fcda14-51a9-4097-b4eb-602525a97253" TYPE="xfs" 
/dev/sda3: UUID="PgGxRo-wpgn-fGKu-zdGI-81AV-E9sK-Pijtcg" TYPE="LVM2_member" 
/dev/mapper/rhel_ibm--p720--01--lp4-swap: UUID="2adeb69f-1393-491a-bc8c-427f3982494b" TYPE="ext4" 
/dev/mapper/rhel_ibm--p720--01--lp4-root: UUID="30931897-8173-4ad6-8005-5e6c973977eb" TYPE="xfs" 
+ blkid -o udev
ID_FS_UUID=95fcda14-51a9-4097-b4eb-602525a97253
ID_FS_UUID_ENC=95fcda14-51a9-4097-b4eb-602525a97253
ID_FS_TYPE=xfs

ID_FS_UUID=PgGxRo-wpgn-fGKu-zdGI-81AV-E9sK-Pijtcg
ID_FS_UUID_ENC=PgGxRo-wpgn-fGKu-zdGI-81AV-E9sK-Pijtcg
ID_FS_TYPE=LVM2_member

ID_FS_UUID=2adeb69f-1393-491a-bc8c-427f3982494b
ID_FS_UUID_ENC=2adeb69f-1393-491a-bc8c-427f3982494b
ID_FS_TYPE=ext4

ID_FS_UUID=30931897-8173-4ad6-8005-5e6c973977eb
ID_FS_UUID_ENC=30931897-8173-4ad6-8005-5e6c973977eb
ID_FS_TYPE=xfs
+ ls -l /dev/disk/by-id /dev/disk/by-path /dev/disk/by-uuid
/dev/disk/by-id:
total 0
lrwxrwxrwx 1 root 0 10 Jun  3 03:49 dm-name-rhel_ibm--p720--01--lp4-root -> ../../dm-1
lrwxrwxrwx 1 root 0 10 Jun  3 03:49 dm-name-rhel_ibm--p720--01--lp4-swap -> ../../dm-0
lrwxrwxrwx 1 root 0 10 Jun  3 03:49 dm-uuid-LVM-iLqOBO1yd7F60BDuy4rzDc22fi9RNRZTe3Q6gzBr9HzmDTEv78cn7FkLTLfzsUjZ -> ../../dm-1
lrwxrwxrwx 1 root 0 10 Jun  3 03:49 dm-uuid-LVM-iLqOBO1yd7F60BDuy4rzDc22fi9RNRZThiXYwcS7qFFTS8LMTzuJhE9GaB4itczs -> ../../dm-0
lrwxrwxrwx 1 root 0  9 Jun  3 03:49 scsi-SAIX_VDASD_00f6db0f00004c0000000136a3035480.3 -> ../../sda
lrwxrwxrwx 1 root 0 10 Jun  3 03:49 scsi-SAIX_VDASD_00f6db0f00004c0000000136a3035480.3-part1 -> ../../sda1
lrwxrwxrwx 1 root 0 10 Jun  3 03:49 scsi-SAIX_VDASD_00f6db0f00004c0000000136a3035480.3-part2 -> ../../sda2
lrwxrwxrwx 1 root 0 10 Jun  3 03:49 scsi-SAIX_VDASD_00f6db0f00004c0000000136a3035480.3-part3 -> ../../sda3

/dev/disk/by-path:
total 0
lrwxrwxrwx 1 root 0  9 Jun  3 03:49 scsi-0:0:1:0 -> ../../sda
lrwxrwxrwx 1 root 0 10 Jun  3 03:49 scsi-0:0:1:0-part1 -> ../../sda1
lrwxrwxrwx 1 root 0 10 Jun  3 03:49 scsi-0:0:1:0-part2 -> ../../sda2
lrwxrwxrwx 1 root 0 10 Jun  3 03:49 scsi-0:0:1:0-part3 -> ../../sda3

/dev/disk/by-uuid:
total 0
lrwxrwxrwx 1 root 0 10 Jun  3 03:49 2adeb69f-1393-491a-bc8c-427f3982494b -> ../../dm-0
lrwxrwxrwx 1 root 0 10 Jun  3 03:49 30931897-8173-4ad6-8005-5e6c973977eb -> ../../dm-1
lrwxrwxrwx 1 root 0 10 Jun  3 03:49 95fcda14-51a9-4097-b4eb-602525a97253 -> ../../sda2
+ cat /proc/cmdline
BOOT_IMAGE=/vmlinux-3.10.0-rc4 root=/dev/mapper/rhel_ibm--p720--01--lp4-root ro rd.lvm.lv=rhel_ibm-p720-01-lp4/swap rd.lvm.lv=rhel_ibm-p720-01-lp4/root rd.md=0 rd.dm=0 vconsole.keymap=us crashkernel=256M rd.luks=0
+ '[' -f /etc/cmdline ']'
+ for _i in '/etc/cmdline.d/*.conf'
+ '[' -f /etc/cmdline.d/90lvm.conf ']'
+ echo /etc/cmdline.d/90lvm.conf
/etc/cmdline.d/90lvm.conf
+ cat /etc/cmdline.d/90lvm.conf
 rd.lvm.lv=rhel_ibm-p720-01-lp4/root 
 rd.lvm.lv=rhel_ibm-p720-01-lp4/swap 
+ for _i in '/etc/conf.d/*.conf'
+ '[' -f /etc/conf.d/systemd.conf ']'
+ echo /etc/conf.d/systemd.conf
/etc/conf.d/systemd.conf
+ cat /etc/conf.d/systemd.conf
systemdutildir="/usr/lib/systemd"
systemdsystemunitdir="/usr/lib/systemd/system"
systemdsystemconfdir="/etc/systemd/system"
+ command -v lvm
+ lvm pvdisplay
  --- Physical volume ---
  PV Name               /dev/sda3
  VG Name               rhel_ibm-p720-01-lp4
  PV Size               99.51 GiB / not usable 3.00 MiB
  Allocatable           yes (but full)
  PE Size               4.00 MiB
  Total PE              25473
  Free PE               0
  Allocated PE          25473
  PV UUID               PgGxRo-wpgn-fGKu-zdGI-81AV-E9sK-Pijtcg
   
+ lvm vgdisplay
  --- Volume group ---
  VG Name               rhel_ibm-p720-01-lp4
  System ID             
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  4
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                3
  Open LV               0
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               99.50 GiB
  PE Size               4.00 MiB
  Total PE              25473
  Alloc PE / Size       25473 / 99.50 GiB
  Free  PE / Size       0 / 0   
  VG UUID               iLqOBO-1yd7-F60B-Duy4-rzDc-22fi-9RNRZT
   
+ lvm lvdisplay
  --- Logical volume ---
  LV Path                /dev/rhel_ibm-p720-01-lp4/swap
  LV Name                swap
  VG Name                rhel_ibm-p720-01-lp4
  LV UUID                hiXYwc-S7qF-FTS8-LMTz-uJhE-9GaB-4itczs
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                7.94 GiB
  Current LE             2032
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:0
   
  --- Logical volume ---
  LV Path                /dev/rhel_ibm-p720-01-lp4/home
  LV Name                home
  VG Name                rhel_ibm-p720-01-lp4
  LV UUID                wbhpwz-urNr-mQAs-I0WG-xpjE-aOq3-qM48yJ
  LV Write Access        read/write
  LV Status              NOT available
  LV Size                41.57 GiB
  Current LE             10641
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
   
  --- Logical volume ---
  LV Path                /dev/rhel_ibm-p720-01-lp4/root
  LV Name                root
  VG Name                rhel_ibm-p720-01-lp4
  LV UUID                e3Q6gz-Br9H-zmDT-Ev78-cn7F-kLTL-fzsUjZ
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                50.00 GiB
  Current LE             12800
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:1
   
+ command -v dmsetup
+ dmsetup ls --tree
rhel_ibm--p720--01--lp4-swap (253:0)
 `- (8:3)
rhel_ibm--p720--01--lp4-root (253:1)
 `- (8:3)
+ cat /proc/mdstat
Personalities : 
unused devices: <none>
+ command -v journalctl
+ journalctl -ab --no-pager -o short-monotonic
-- Logs begin at Mon 2013-06-03 03:49:14 UTC, end at Mon 2013-06-03 03:49:17 UTC. --
[    0.788500] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd-journal[178]: Allowing runtime journal files to grow to 394.2M.
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Reserving 256MB of memory at 128MB for crashkernel (System RAM: 8192MB)
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Allocated 1048576 bytes for 1024 pacas at c000000007f00000
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Using pSeries machine description
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Page sizes from device-tree:
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: base_shift=12: shift=12, sllp=0x0000, avpnm=0x00000000, tlbiel=1, penc=0
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: base_shift=12: shift=16, sllp=0x0000, avpnm=0x00000000, tlbiel=1, penc=7
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: base_shift=12: shift=24, sllp=0x0000, avpnm=0x00000000, tlbiel=1, penc=56
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: base_shift=16: shift=16, sllp=0x0110, avpnm=0x00000000, tlbiel=1, penc=1
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: base_shift=16: shift=24, sllp=0x0110, avpnm=0x00000000, tlbiel=1, penc=8
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: base_shift=24: shift=24, sllp=0x0100, avpnm=0x00000001, tlbiel=0, penc=0
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: base_shift=34: shift=34, sllp=0x0120, avpnm=0x000007ff, tlbiel=0, penc=3
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Page orders: linear mapping = 24, virtual = 16, io = 12
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Using 1TB segments
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Found initrd at 0xc000000004e00000:0xc000000005742a84
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: bootconsole [udbg0] enabled
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Partition configured for 28 cpus.
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: CPU maps initialized for 4 threads per core
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel:  (thread shift is 2)
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Freed 983040 bytes for unused pacas
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Starting Linux PPC64 #1 SMP Mon Jun 3 00:01:47 EDT 2013
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: -----------------------------------------------------
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: ppc64_pft_size                = 0x1c
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: physicalMemorySize            = 0x200000000
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: htab_hash_mask                = 0x1fffff
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: -----------------------------------------------------
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Initializing cgroup subsys cpuset
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Initializing cgroup subsys cpu
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Initializing cgroup subsys cpuacct
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Linux version 3.10.0-rc4 (root@ibm-p720-01-lp4.rhts.eng.bos.redhat.com) (gcc version 4.8.0 20130419 (Red Hat 4.8.0-3) (GCC) ) #1 SMP Mon Jun 3 00:01:47 EDT 2013
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: [boot]0012 Setup Arch
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Node 0 Memory: 0x0-0x200000000
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: PPC64 nvram contains 15360 bytes
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Zone ranges:
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel:   DMA      [mem 0x00000000-0x1ffffffff]
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel:   Normal   empty
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Movable zone start for each node
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Early memory node ranges
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel:   node   0: [mem 0x00000000-0x1ffffffff]
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: On node 0 totalpages: 131072
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel:   DMA zone: 112 pages used for memmap
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel:   DMA zone: 0 pages reserved
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel:   DMA zone: 131072 pages, LIFO batch:1
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: [boot]0015 Setup Done
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: PERCPU: Embedded 2 pages/cpu @c000000001500000 s89088 r0 d41984 u131072
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: pcpu-alloc: s89088 r0 d41984 u131072 alloc=1*1048576
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: pcpu-alloc: [0] 00 01 02 03 04 05 06 07 [0] 08 09 10 11 12 13 14 15 
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: pcpu-alloc: [0] 16 17 18 19 20 21 22 23 [0] 24 25 26 27 -- -- -- -- 
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Built 1 zonelists in Node order, mobility grouping on.  Total pages: 130960
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Policy zone: DMA
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Kernel command line: BOOT_IMAGE=/vmlinux-3.10.0-rc4 root=/dev/mapper/rhel_ibm--p720--01--lp4-root ro rd.lvm.lv=rhel_ibm-p720-01-lp4/swap rd.lvm.lv=rhel_ibm-p720-01-lp4/root rd.md=0 rd.dm=0 vconsole.keymap=us crashkernel=256M rd.luks=0
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: PID hash table entries: 4096 (order: -1, 32768 bytes)
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Sorting __ex_table...
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: freeing bootmem node 0
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Memory: 7991040k/8388608k available (16256k kernel code, 397568k reserved, 1728k data, 3083k bss, 5632k init)
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: SLUB: HWalign=128, Order=0-3, MinObjects=0, CPUs=28, Nodes=256
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Hierarchical RCU implementation.
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: 	RCU restricting CPUs from NR_CPUS=1024 to nr_cpu_ids=28.
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: NR_IRQS:512 nr_irqs:512 16
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: pic: no ISA interrupt controller
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: time_init: decrementer frequency = 512.000000 MHz
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: time_init: processor frequency   = 3000.000000 MHz
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: clocksource: timebase mult[1f40000] shift[24] registered
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: clockevent: decrementer mult[83126e98] shift[32] cpu[0]
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Console: colour dummy device 80x25
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: console [hvc0] enabled, bootconsole disabled
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: allocated 2097152 bytes of page_cgroup
[    0.000000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.004360] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: pid_max: default: 32768 minimum: 301
[    0.004413] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Security Framework initialized
[    0.004423] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: SELinux:  Initializing.
[    0.004433] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: SELinux:  Starting in permissive mode
[    0.004602] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Dentry cache hash table entries: 1048576 (order: 7, 8388608 bytes)
[    0.006264] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Inode-cache hash table entries: 524288 (order: 6, 4194304 bytes)
[    0.007241] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Mount-cache hash table entries: 4096
[    0.008469] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Initializing cgroup subsys memory
[    0.008653] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Initializing cgroup subsys devices
[    0.008662] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Initializing cgroup subsys freezer
[    0.008666] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Initializing cgroup subsys net_cls
[    0.008669] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Initializing cgroup subsys blkio
[    0.008673] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Initializing cgroup subsys perf_event
[    0.008836] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: EEH: pSeries platform initialized
[    0.008840] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: POWER7 performance monitor hardware support registered
[    0.021453] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Brought up 28 CPUs
[    0.021470] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Node 0 CPUs: 0-27
[    0.021586] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Enabling Asymmetric SMT scheduling
[    0.024690] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: devtmpfs: initialized
[    0.062630] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: EEH: devices created
[    0.065559] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: atomic64 test passed
[    0.065748] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: NET: Registered protocol family 16
[    0.065799] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: EEH: No capable adapters found
[    0.065945] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: IBM eBus Device Driver
[    0.072208] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: PCI: Probing PCI hardware
[    0.072218] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: PCI: Probing PCI hardware done
[    0.072226] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: opal: Node not found
[    0.074665] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: bio: create slab <bio-0> at 0
[    0.075134] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: vgaarb: loaded
[    0.075288] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: SCSI subsystem initialized
[    0.075378] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: usbcore: registered new interface driver usbfs
[    0.075403] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: usbcore: registered new interface driver hub
[    0.075462] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: usbcore: registered new device driver usb
[    0.075943] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: NetLabel: Initializing
[    0.075949] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: NetLabel:  domain hash size = 128
[    0.075956] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: NetLabel:  protocols = UNLABELED CIPSOv4
[    0.075987] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: NetLabel:  unlabeled traffic allowed by default
[    0.076115] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Switching to clocksource timebase
[    0.098959] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: NET: Registered protocol family 2
[    0.099380] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: TCP established hash table entries: 65536 (order: 4, 1048576 bytes)
[    0.100592] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: TCP bind hash table entries: 65536 (order: 4, 1048576 bytes)
[    0.101581] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: TCP: Hash tables configured (established 65536 bind 65536)
[    0.101607] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: TCP: reno registered
[    0.101623] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: UDP hash table entries: 4096 (order: 1, 131072 bytes)
[    0.101795] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: UDP-Lite hash table entries: 4096 (order: 1, 131072 bytes)
[    0.102192] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: NET: Registered protocol family 1
[    0.102211] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: PCI: CLS 0 bytes, default 128
[    0.102300] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Unpacking initramfs...
[    0.519156] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Freeing initrd memory: 9472K (c000000004e00000 - c000000005740000)
[    0.519536] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: RTAS daemon started
[    0.543329] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: IOMMU table initialized, virtual merging enabled
[    0.543648] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: pseries_idle_driver registered
[    0.543923] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Initialise module verification
[    0.544030] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: audit: initializing netlink socket (disabled)
[    0.544056] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: type=2000 audit(1370231353.530:1): initialized
[    0.753238] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: HugeTLB registered 16 MB page size, pre-allocated 0 pages
[    0.753258] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: HugeTLB registered 16 GB page size, pre-allocated 0 pages
[    0.757129] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: VFS: Disk quotas dquot_6.5.2
[    0.757347] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Dquot-cache hash table entries: 8192 (order 0, 65536 bytes)
[    0.758599] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: msgmni has been set to 15756
[    0.758805] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: SELinux:  Registering netfilter hooks
[    0.759954] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: alg: No test for stdrng (krng)
[    0.759979] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: NET: Registered protocol family 38
[    0.759989] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Key type asymmetric registered
[    0.759996] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Asymmetric key parser 'x509' registered
[    0.760084] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.760222] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: io scheduler noop registered
[    0.760230] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: io scheduler deadline registered (default)
[    0.760305] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: io scheduler cfq registered
[    0.760470] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.760478] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: rpaphp: RPA HOT Plug PCI Controller Driver version: 0.1
[    0.761193] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.761764] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Linux agpgart interface v0.103
[    0.763936] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: loop: module loaded
[    0.763951] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: rdac: device handler registered
[    0.764109] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: hp_sw: device handler registered
[    0.764117] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: emc: device handler registered
[    0.764123] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: alua: device handler registered
[    0.764201] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: libphy: Fixed MDIO Bus: probed
[    0.764286] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.764307] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: ehci-pci: EHCI PCI platform driver
[    0.764328] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.764361] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: uhci_hcd: USB Universal Host Controller Interface driver
[    0.764496] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: usbcore: registered new interface driver usbserial
[    0.764517] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: usbcore: registered new interface driver usbserial_generic
[    0.764536] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: usbserial: USB Serial support registered for generic
[    0.764658] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: mousedev: PS/2 mouse device common for all mice
[    0.765043] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: rtc-generic rtc-generic: rtc core: registered rtc-generic as rtc0
[    0.765359] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: cpuidle: using governor ladder
[    0.765831] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: cpuidle: using governor menu
[    0.765847] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: hidraw: raw HID events driver (C) Jiri Kosina
[    0.765923] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: usbcore: registered new interface driver usbhid
[    0.765926] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: usbhid: USB HID core driver
[    0.765973] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: drop_monitor: Initializing network drop monitor service
[    0.766045] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: TCP: cubic registered
[    0.766049] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Initializing XFRM netlink socket
[    0.766149] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: NET: Registered protocol family 10
[    0.766358] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: NET: Registered protocol family 17
[    0.766411] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Running MSI bitmap self-tests ...
[    0.767492] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Loading module verification certificates
[    0.767510] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: X.509: Cert 0c13c183e928455e2f5c0b7b606a338a0d3028da is not yet valid
[    0.767515] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: MODSIGN: Problem loading in-kernel X.509 certificate (-129)
[    0.767525] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: registered taskstats version 1
[    0.767851] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: rtc-generic rtc-generic: setting system clock to 2013-06-03 03:49:14 UTC (1370231354)
[    0.768746] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Freeing unused kernel memory: 5632K (c000000000a60000 - c000000000fe0000)
[    0.779188] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: systemd 202 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX +IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ)
[    0.779254] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Running in initial RAM disk.
[    0.779607] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Set hostname to <ibm-p720-01-lp4.rhts.eng.bos.redhat.com>.
[    0.787752] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Expecting device dev-mapper-rhel_ibm\x2d\x2dp720\x2d\x2d01\x2d\x2dlp4\x2droot.device...
[    0.787992] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Expecting device dev-disk-by\x2duuid-95fcda14\x2d51a9\x2d4097\x2db4eb\x2d602525a97253.device...
[    0.788147] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Expecting device dev-mapper-rhel_ibm\x2d\x2dp720\x2d\x2d01\x2d\x2dlp4\x2dswap.device...
[    0.788297] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Starting Timers.
[    0.788446] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Reached target Timers.
[    0.788462] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Starting Journal Socket.
[    0.788682] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Listening on Journal Socket.
[    0.788955] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Starting dracut cmdline hook...
[    0.790075] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Started Load Kernel Modules.
[    0.790092] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Starting Journal Service...
[    0.791000] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Started Journal Service.
[    0.791274] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Starting udev Kernel Socket.
[    0.791458] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Listening on udev Kernel Socket.
[    0.791532] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Starting udev Control Socket.
[    0.791718] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Listening on udev Control Socket.
[    0.791733] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Starting Sockets.
[    0.791887] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Reached target Sockets.
[    0.791901] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Starting Swap.
[    0.792053] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Reached target Swap.
[    0.792068] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Starting Local File Systems.
[    0.792224] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Reached target Local File Systems.
[    0.791864] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd-journal[178]: Journal started
[    0.805628] ibm-p720-01-lp4.rhts.eng.bos.redhat.com dracut-cmdline[177]: dracut-6.93Server (Maipo) dracut-027-45.git20130430.el7
[    0.934170] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Started dracut cmdline hook.
[    0.934730] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Starting Setup Virtual Console...
[    0.935505] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Starting dracut pre-udev hook...
[    0.941679] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Started Setup Virtual Console.
[    0.957333] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Request for unknown module key 'Magrathea: Glacier signing key: 0c13c183e928455e2f5c0b7b606a338a0d3028da' err -11
[    0.957931] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: dm_mod: module verification failed: signature and/or required key missing - tainting kernel
[    0.958574] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: device-mapper: uevent: version 1.0.3
[    0.958683] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: device-mapper: ioctl: 4.24.0-ioctl (2013-01-15) initialised: dm-devel@redhat.com
[    0.960262] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Request for unknown module key 'Magrathea: Glacier signing key: 0c13c183e928455e2f5c0b7b606a338a0d3028da' err -11
[    0.960473] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Request for unknown module key 'Magrathea: Glacier signing key: 0c13c183e928455e2f5c0b7b606a338a0d3028da' err -11
[    0.960650] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Request for unknown module key 'Magrathea: Glacier signing key: 0c13c183e928455e2f5c0b7b606a338a0d3028da' err -11
[    0.974321] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Started dracut pre-udev hook.
[    0.974880] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Starting udev Kernel Device Manager...
[    0.977472] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Started udev Kernel Device Manager.
[    0.978018] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Started dracut pre-trigger hook.
[    0.978558] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Starting udev Coldplug all Devices...
[    0.982832] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd-udevd[275]: starting version 202
[    0.994254] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Started udev Coldplug all Devices.
[    0.995203] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Starting dracut initqueue hook...
[    0.996300] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Starting System Initialization.
[    0.997467] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Reached target System Initialization.
[    0.998328] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Starting Show Plymouth Boot Screen...
[    1.001736] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Request for unknown module key 'Magrathea: Glacier signing key: 0c13c183e928455e2f5c0b7b606a338a0d3028da' err -11
[    1.002251] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Request for unknown module key 'Magrathea: Glacier signing key: 0c13c183e928455e2f5c0b7b606a338a0d3028da' err -11
[    1.002530] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Request for unknown module key 'Magrathea: Glacier signing key: 0c13c183e928455e2f5c0b7b606a338a0d3028da' err -11
[    1.003372] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: ibmvscsi 30000002: SRP_VERSION: 16.a
[    1.003526] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: scsi0 : IBM POWER Virtual SCSI Adapter 1.5.9
[    1.003727] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: ibmvscsi 30000002: partner initialization complete
[    1.003786] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: ibmvscsi 30000002: host srp version: 16.a, host partition vios (1), OS 3, max io 1048576
[    1.003852] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: ibmvscsi 30000002: Client reserve enabled
[    1.003867] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: ibmvscsi 30000002: sent SRP login
[    1.003919] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: ibmvscsi 30000002: SRP_LOGIN succeeded
[    1.017643] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Reloading.
[    1.016835] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: scsi 0:0:1:0: Direct-Access     AIX      VDASD            0001 PQ: 0 ANSI: 3
[    1.042738] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Request for unknown module key 'Magrathea: Glacier signing key: 0c13c183e928455e2f5c0b7b606a338a0d3028da' err -11
[    1.042898] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Request for unknown module key 'Magrathea: Glacier signing key: 0c13c183e928455e2f5c0b7b606a338a0d3028da' err -11
[    1.043785] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: sd 0:0:1:0: [sda] 209715200 512-byte logical blocks: (107 GB/100 GiB)
[    1.043836] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: sd 0:0:1:0: [sda] Write Protect is off
[    1.043841] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: sd 0:0:1:0: [sda] Mode Sense: 17 00 00 08
[    1.043886] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: sd 0:0:1:0: [sda] Cache data unavailable
[    1.043896] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: sd 0:0:1:0: [sda] Assuming drive cache: write through
[    1.044193] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: sd 0:0:1:0: [sda] Cache data unavailable
[    1.044200] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: sd 0:0:1:0: [sda] Assuming drive cache: write through
[    1.062525] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel:  sda: sda1 sda2 sda3
[    1.062941] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: sd 0:0:1:0: [sda] Cache data unavailable
[    1.062946] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: sd 0:0:1:0: [sda] Assuming drive cache: write through
[    1.062951] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: sd 0:0:1:0: [sda] Attached SCSI disk
[    1.533971] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Started Show Plymouth Boot Screen.
[    1.534480] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Started Dispatch Password Requests to Console Directory Watch.
[    1.534947] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Starting Paths.
[    1.535413] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Reached target Paths.
[    1.535880] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Starting Forward Password Requests to Plymouth Directory Watch.
[    1.536347] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Started Forward Password Requests to Plymouth Directory Watch.
[    1.536812] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Starting Basic System.
[    1.537278] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Reached target Basic System.
[    1.578808] ibm-p720-01-lp4.rhts.eng.bos.redhat.com dracut-initqueue[288]: Scanning devices sda3  for LVM logical volumes rhel_ibm-p720-01-lp4/root rhel_ibm-p720-01-lp4/swap rhel_ibm-p720-01-lp4/swap rhel_ibm-p720-01-lp4/root
[    2.204698] ibm-p720-01-lp4.rhts.eng.bos.redhat.com dracut-initqueue[288]: inactive '/dev/rhel_ibm-p720-01-lp4/swap' [7.94 GiB] inherit
[    2.205127] ibm-p720-01-lp4.rhts.eng.bos.redhat.com dracut-initqueue[288]: inactive '/dev/rhel_ibm-p720-01-lp4/home' [41.57 GiB] inherit
[    2.205545] ibm-p720-01-lp4.rhts.eng.bos.redhat.com dracut-initqueue[288]: inactive '/dev/rhel_ibm-p720-01-lp4/root' [50.00 GiB] inherit
[    2.767245] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: bio: create slab <bio-1> at 1
[    3.062278] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Found device /dev/disk/by-uuid/30931897-8173-4ad6-8005-5e6c973977eb.
[    3.062838] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Found device /dev/disk/by-id/dm-uuid-LVM-iLqOBO1yd7F60BDuy4rzDc22fi9RNRZTe3Q6gzBr9HzmDTEv78cn7FkLTLfzsUjZ.
[    3.063381] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Found device /dev/disk/by-id/dm-name-rhel_ibm--p720--01--lp4-root.
[    3.063922] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Found device /dev/dm-1.
[    3.064461] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Found device /sys/devices/virtual/block/dm-1.
[    3.068665] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Started dracut initqueue hook.
[    3.069238] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Started dracut pre-mount hook.
[    3.069781] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Mounting /sysroot...
[    3.297432] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Request for unknown module key 'Magrathea: Glacier signing key: 0c13c183e928455e2f5c0b7b606a338a0d3028da' err -11
[    3.297881] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Request for unknown module key 'Magrathea: Glacier signing key: 0c13c183e928455e2f5c0b7b606a338a0d3028da' err -11
[    3.308481] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
[    3.387164] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: XFS (dm-1): Mounting Filesystem
[    3.529607] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: XFS (dm-1): Starting recovery (logdev: internal)
[    3.583037] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: XFS: Internal error XFS_WANT_CORRUPTED_RETURN at line 169 of file fs/xfs/xfs_dir2_data.c.  Caller 0xd000000001644f5c

[    3.583048] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: CPU: 0 PID: 399 Comm: mount Tainted: GF            3.10.0-rc4 #1
[    3.583052] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Call Trace:
[    3.583057] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: [c00000001be0ab90] [c000000000014eac] .show_stack+0x7c/0x1f0 (unreliable)
[    3.583064] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: [c00000001be0ac60] [c0000000007444fc] .dump_stack+0x28/0x3c
[    3.583091] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: [c00000001be0acd0] [d000000001600674] .xfs_error_report+0x54/0x70 [xfs]
[    3.583113] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: [c00000001be0ad40] [d0000000016479f4] .__xfs_dir3_data_check+0x6c4/0x820 [xfs]
[    3.583133] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: [c00000001be0ae40] [d000000001644f5c] .xfs_dir3_block_verify+0xbc/0xf0 [xfs]
[    3.583153] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: [c00000001be0aec0] [d00000000164510c] .xfs_dir3_block_write_verify+0x3c/0x1d0 [xfs]
[    3.583171] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: [c00000001be0af70] [d0000000015fdb74] ._xfs_buf_ioapply+0xd4/0x410 [xfs]
[    3.583188] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: [c00000001be0b0b0] [d0000000015fdfbc] .xfs_buf_iorequest+0x4c/0xe0 [xfs]
[    3.583206] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: [c00000001be0b140] [d0000000015fe0b4] .xfs_bdstrat_cb+0x64/0x120 [xfs]
[    3.583223] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: [c00000001be0b1d0] [d0000000015fe2c4] .__xfs_buf_delwri_submit+0x154/0x2b0 [xfs]
[    3.583240] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: [c00000001be0b2b0] [d0000000015ff308] .xfs_buf_delwri_submit+0x38/0xd0 [xfs]
[    3.583262] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: [c00000001be0b350] [d000000001662494] .xlog_recover_commit_trans+0xf4/0x1a0 [xfs]
[    3.583283] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: [c00000001be0b410] [d00000000166279c] .xlog_recover_process_data+0x25c/0x370 [xfs]
[    3.583305] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: [c00000001be0b4e0] [d0000000016629f8] .xlog_do_recovery_pass+0x148/0x590 [xfs]
[    3.583326] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: [c00000001be0b650] [d000000001662ed8] .xlog_do_log_recovery+0x98/0x110 [xfs]
[    3.583348] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: [c00000001be0b6e0] [d000000001662f70] .xlog_do_recover+0x20/0x160 [xfs]
[    3.583369] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: [c00000001be0b770] [d000000001663148] .xlog_recover+0x98/0x110 [xfs]
[    3.583392] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: [c00000001be0b800] [d00000000166d9a4] .xfs_log_mount+0x134/0x1d0 [xfs]
[    3.583414] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: [c00000001be0b890] [d000000001666dc8] .xfs_mountfs+0x3c8/0x780 [xfs]
[    3.583432] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: [c00000001be0b940] [d000000001614c9c] .xfs_fs_fill_super+0x30c/0x3a0 [xfs]
[    3.583439] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: [c00000001be0b9e0] [c000000000214d58] .mount_bdev+0x258/0x2a0
[    3.583458] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: [c00000001be0bab0] [d000000001612758] .xfs_fs_mount+0x18/0x30 [xfs]
[    3.583463] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: [c00000001be0bb20] [c000000000215be0] .mount_fs+0x70/0x230
[    3.583468] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: [c00000001be0bbe0] [c0000000002381c8] .vfs_kern_mount+0x58/0x130
[    3.583473] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: [c00000001be0bc90] [c00000000023b390] .do_mount+0x2d0/0xb30
[    3.583478] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: [c00000001be0bd70] [c00000000023bca0] .SyS_mount+0xb0/0x110
[    3.583483] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: [c00000001be0be30] [c000000000009e54] syscall_exit+0x0/0x98
[    3.583488] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: c0000001f907c000: 58 44 32 42 0a 68 02 d8 00 78 00 18 00 d8 00 18  XD2B.h...x......
[    3.583493] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: c0000001f907c010: 00 00 00 00 04 22 80 89 01 2e 00 01 e2 38 00 10  .....".......8..
[    3.583497] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: c0000001f907c020: 00 00 00 00 00 00 00 8f 02 2e 2e 67 67 65 00 20  ...........gge. 
[    3.583502] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: c0000001f907c030: 00 00 00 00 04 22 d0 8c 0c 74 6d 70 59 42 33 52  ....."...tmpYB3R
[    3.583507] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: XFS (dm-1): Internal error xfs_dir3_block_write_verify at line 109 of file fs/xfs/xfs_dir2_block.c.  Caller 0xd0000000015fdb74

[    3.583513] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: CPU: 0 PID: 399 Comm: mount Tainted: GF            3.10.0-rc4 #1
[    3.583517] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: Call Trace:
[    3.583520] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: [c00000001be0ac60] [c000000000014eac] .show_stack+0x7c/0x1f0 (unreliable)
[    3.583525] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: [c00000001be0ad30] [c0000000007444fc] .dump_stack+0x28/0x3c
[    3.583542] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: [c00000001be0ada0] [d000000001600674] .xfs_error_report+0x54/0x70 [xfs]
[    3.583560] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: [c00000001be0ae10] [d00000000160070c] .xfs_corruption_error+0x7c/0xb0 [xfs]
[    3.583581] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: [c00000001be0aec0] [d00000000164521c] .xfs_dir3_block_write_verify+0x14c/0x1d0 [xfs]
[    3.583598] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: [c00000001be0af70] [d0000000015fdb74] ._xfs_buf_ioapply+0xd4/0x410 [xfs]
[    3.583615] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: [c00000001be0b0b0] [d0000000015fdfbc] .xfs_buf_iorequest+0x4c/0xe0 [xfs]
[    3.583632] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: [c00000001be0b140] [d0000000015fe0b4] .xfs_bdstrat_cb+0x64/0x120 [xfs]
[    3.583649] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: [c00000001be0b1d0] [d0000000015fe2c4] .__xfs_buf_delwri_submit+0x154/0x2b0 [xfs]
[    3.583667] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: [c00000001be0b2b0] [d0000000015ff308] .xfs_buf_delwri_submit+0x38/0xd0 [xfs]
[    3.583688] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: [c00000001be0b350] [d000000001662494] .xlog_recover_commit_trans+0xf4/0x1a0 [xfs]
[    3.583710] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: [c00000001be0b410] [d00000000166279c] .xlog_recover_process_data+0x25c/0x370 ]
[    3.583752] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: [c00000001be0b650] [d000000001662ed8] .xlog_do_log_recovery+0x98/0x110 [xfs]
[    3.583774] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: [c00000001be0b6e0] [d000000001662f70] .xlog_do_recover+0x20/0x160 [xfs]
[    3.583795] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: [c00000001be0b770] [d000000001663148] .xlog_recover+0x98/0x110 [xfs]
[    3.583817] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: [c00000001be0b800] [d00000000166d9a4] .xfs_log_mount+0x134/0x1d0 [xfs]
[    3.583839] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: [c00000001be0b890] [d000000001666dc8] .xfs_mountfs+0x3c8/0x780 [xfs]
[    3.583857] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: [c00000001be0b940] [d000000001614c9c] .xfs_fs_fill_super+0x30c/0x3a0 [xfs]
[    3.583863] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: [c00000001be0b9e0] [c000000000214d58] .mount_bdev+0x258/0x2a0
[    3.583880] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: [c00000001be0bab0] [d000000001612758] .xfs_fs_mount+0x18/0x30 [xfs]
[    3.583886] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: [c00000001be0bb20] [c000000000215be0] .mount_fs+0x70/0x230
[    3.583890] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: [c00000001be0bbe0] [c0000000002381c8] .vfs_kern_mount+0x58/0x130
[    3.583895] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: [c00000001be0bc90] [c00000000023b390] .do_mount+0x2d0/0xb30
[    3.583900] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: [c00000001be0bd70] [c00000000023bca0] .SyS_mount+0xb0/0x110
[    3.583905] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: [c00000001be0be30] [c000000000009e54] syscall_exit+0x0/0x98
[    3.583909] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[    3.583913] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: XFS (dm-1): xfs_do_force_shutdown(0x8) called from line 1365 of file fs/xfs/xfs_buf.c.  Return address = 0xd0000000015fdba0
[    3.583918] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: XFS (dm-1): Corruption of in-memory data detected.  Shutting down filesystem
[    3.583922] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: XFS (dm-1): Please umount the filesystem and rectify the problem(s)
[    3.583929] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: XFS (dm-1): metadata I/O error: block 0x1cacb80 ("xlog_recover_iodone") error 5 numblks 16
[    3.583934] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd00000000165d600
[    3.583969] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: XFS (dm-1): metadata I/O error: block 0x1a14580 ("xlog_recover_iodone") error 117 numblks 8
[    3.583975] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd00000000165d600
[    3.597774] ibm-p720-01-lp4.rhts.eng.bos.redhat.com mount[399]: mount: mount /dev/mapper/rhel_ibm--p720--01--lp4-root on /sysroot failed: Structure needs cleaning
[    3.598253] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: sysroot.mount mount process exited, code=exited status=32
[    3.598739] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Failed to mount /sysroot.
[    3.599240] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Dependency failed for Initrd Root File System.
[    3.599969] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Dependency failed for Reload Configuration from the Real Root.
[    3.600981] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Triggering OnFailure= dependencies of initrd-parse-etc.service.
[    3.601932] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Triggering OnFailure= dependencies of initrd-root-fs.target.
[    3.602389] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: MESSAGE=Unit sysroot.mount entered failed state.
[    3.602845] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Stopping dracut initqueue hook...
[    3.603298] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Stopped dracut initqueue hook.
[    3.603752] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Stopped target Initrd File Systems.
[    3.604207] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Stopping Basic System.
[    3.604660] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Stopped Show Plymouth Boot Screen.
[    3.605113] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Stopping Journal Service...
[    3.605525] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd-journal[178]: Journal stopped
[    3.609824] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd-journal[417]: Allowing runtime journal files to grow to 394.2M.
[    3.603202] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: XFS (dm-1): log mount/recovery failed: error 117
[    3.603241] ibm-p720-01-lp4.rhts.eng.bos.redhat.com kernel: XFS (dm-1): log mount failed
[    3.605676] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Starting Emergency Shell...
[    3.607284] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Starting Journal Service...
[    3.607513] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Stopped udev Kernel Device Manager.
[    3.607563] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Stopping dracut pre-udev hook...
[    3.607578] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Stopped dracut pre-udev hook.
[    3.607628] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Stopping dracut cmdline hook...
[    3.607641] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Stopped dracut cmdline hook.
[    3.607690] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Stopping udev Kernel Socket.
[    3.607742] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Closed udev Kernel Socket.
[    3.607757] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Stopping udev Control Socket.
[    3.607805] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Closed udev Control Socket.
[    3.611362] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd-journald[178]: Received SIGTERM
[    3.612376] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Starting Journal Service...
[    3.612900] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd[1]: Started Journal Service.
[    3.610950] ibm-p720-01-lp4.rhts.eng.bos.redhat.com systemd-journal[417]: Journal started

CAI Qian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
