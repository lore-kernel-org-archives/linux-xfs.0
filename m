Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 01 Oct 2008 17:47:52 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m920lnvK026995
	for <xfs@oss.sgi.com>; Wed, 1 Oct 2008 17:47:49 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1D1A41090FA8
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2008 17:49:23 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id nUwxACDmy8CvUu1m for <xfs@oss.sgi.com>; Wed, 01 Oct 2008 17:49:23 -0700 (PDT)
Date: Thu, 2 Oct 2008 10:45:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS filesystem corruption on the arm(el) architecture
Message-ID: <20081002004556.GB30001@disturbed>
References: <1222893502.5020.40.camel@moria>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222893502.5020.40.camel@moria>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Tobias Frost <tobi@coldtobi.de>
Cc: linux-kernel@vger.kernel.org, debian-arm@lists.debian.org, xfs@oss.sgi.com


Adding xfs@oss.sgi.com to the cc list so all the XFS folk see this.

On Wed, Oct 01, 2008 at 10:38:22PM +0200, Tobias Frost wrote:
> (Note: Please CC me, as I am NOT on the lkml!!)
>
> Some time ago, I discovered some problems with xfs. Unfortunatly, I had
> no time diving into it. However, some weeks ago some other people
> running debian on ARM machines confirmed the problem on their machines
> starting at [1], so I think it is appropitate to at least report it.  
> It has also been seen on 2.6.27-rc4  [2].
> 
> summary: the xfs partition corrupts almost immediatly after creation. I
> had the impression, that the first unlink (rm) causes the corruption,
> but this might be just an impression.
> 
> During the tests I made, I conserved a image of the corrupted filesystem
> which I can make available on request (it's 26 Mbyte, gzipped).
> 
> Please let me know how I can assist you in finding the problem. 
> 
> 
> [1] http://lists.debian.org/debian-arm/2008/08/msg00155.html
> [2] http://lists.debian.org/debian-arm/2008/08/msg00184.html
> 
> Best regards,
> Tobias Frost
> http://blog.coldtobi.de
> 
> PS: Thank you for your great work!
> 
> Some Logs (copies from the debian mailing list, so you don't have to
> follow the whole thread there:)
> 
> -I did test xfs on my Thecus 2100. I could reproduce the fs-corruption
> with xfs.
> The xfs was created freshly on the partition used to be swap. 
> The corruption occured after downloading the ltp from source-forge,
> untaring it and a attempted make
> (The make never completed, therefore I did not run the stress-tests of
> ltp)
> 
> Some infos:
> 
> thecus:~/#uname -a
> Linux thecus.coldtobi.ip 2.6.26-1-iop32x #1 Fri Aug 8 23:42:37 UTC 2008
> armv5tel GNU/Linux
> 
> thecus:~# dpkg -l xfsprogs
> +++-==============================================================
> ii  xfsprogs  2.9.8-1    Utilities for managing the XFS filesystem
> 
> 
> hecus:~#xfs_check /dev/md1 2>&1 | tee fsck.log -
> ERROR: The filesystem has valuable metadata changes in a log which needs
> to
> be replayed.  Mount the filesystem to replay the log, and unmount it
> before
> re-running xfs_check.  If you are unable to mount the filesystem, then
> use
> the xfs_repair -L option to destroy the log and attempt a repair.
> Note that destroying the log may cause corruption -- please attempt a
> mount
> of the filesystem before doing this.
> ERROR: The filesystem has valuable metadata changes in a log which needs
> to
> be replayed.  Mount the filesystem to replay the log, and unmount it
> before
> re-running xfs_check.  If you are unable to mount the filesystem, then
> use
> the xfs_repair -L option to destroy the log and attempt a repair.
> Note that destroying the log may cause corruption -- please attempt a
> mount
> of the filesystem before doing this.
> 
> thecus:~# mount -o ro /dev/md1 /tmp/tst/
> thecus:~# dmesg
> [43132282.570000] Filesystem "md1": Disabling barriers, not supported by
> the underlying device
> [43132282.590000] XFS mounting filesystem md1
> [43132283.600000] Starting XFS recovery on filesystem: md1 (logdev:
> internal)
> [43132283.620000] Filesystem "md1": XFS internal error
> xlog_valid_rec_header(1) at line 3471 of file fs/xfs/xfs_log_recover.c.
> Caller 0xbf24b298
> [43132283.640000] [<c00291e0>] (dump_stack+0x0/0x14) from [<bf232704>]
> (xfs_error_report+0x4c/0x5c [xfs])
> [43132283.650000] [<bf2326b8>] (xfs_error_report+0x0/0x5c [xfs]) from
> [<bf249fc4>] (xlog_valid_rec_header+0x150/0x184 [xfs])
> [43132283.660000]  r4:defc0000
> [43132283.660000] [<bf249e74>] (xlog_valid_rec_header+0x0/0x184 [xfs])
> from [<bf24b298>] (xlog_do_recovery_pass+0x21c/0x824 [xfs])
> [43132283.670000]  r5:defbc4a0 r4:00000000
> [43132283.680000] [<bf24b07c>] (xlog_do_recovery_pass+0x0/0x824 [xfs])
> from [<bf24b8ec>] (xlog_do_log_recovery+0x4c/0x98 [xfs])
> [43132283.690000] [<bf24b8a0>] (xlog_do_log_recovery+0x0/0x98 [xfs])
> from [<bf24b958>] (xlog_do_recover+0x20/0x124 [xfs])
> [43132283.700000]  r9:00000000 r8:df738400 r6:000008f8 r5:ce0512e0
> r4:000008f8
> [43132283.710000] [<bf24b938>] (xlog_do_recover+0x0/0x124 [xfs]) from
> [<bf24baf0>] (xlog_recover+0x94/0xbc [xfs])
> [43132283.720000]  r9:00000000 r8:df738400 r6:000008f8 r5:000001f0
> r4:ce0512e0
> [43132283.730000] [<bf24ba5c>] (xlog_recover+0x0/0xbc [xfs]) from
> [<bf2442b8>] (xfs_log_mount+0xe0/0x164 [xfs])
> [43132283.730000]  r7:00000000 r6:00000000 r4:001dc860
> [43132283.730000] [<bf2441d8>] (xfs_log_mount+0x0/0x164 [xfs]) from
> [<bf24db8c>] (xfs_mountfs+0x270/0x664 [xfs])
> [43132283.750000]  r8:df738420 r7:df738400 r6:00005000 r5:00000000
> r4:0003b90c
> [43132283.760000] [<bf24d91c>] (xfs_mountfs+0x0/0x664 [xfs]) from
> [<bf2554c4>] (xfs_mount+0x290/0x348 [xfs])
> [43132283.760000] [<bf255234>] (xfs_mount+0x0/0x348 [xfs]) from
> [<bf266854>] (xfs_fs_fill_super+0xbc/0x208 [xfs])
> [43132283.780000] [<bf266798>] (xfs_fs_fill_super+0x0/0x208 [xfs]) from
> [<c00946c4>] (get_sb_bdev+0xf4/0x14c)
> [43132283.790000] [<c00945d0>] (get_sb_bdev+0x0/0x14c) from [<bf264dd4>]
> (xfs_fs_get_sb+0x24/0x30 [xfs])
> [43132283.800000] [<bf264db0>] (xfs_fs_get_sb+0x0/0x30 [xfs]) from
> [<c00941d0>] (vfs_kern_mount+0xa0/0x140)
> [43132283.810000] [<c0094130>] (vfs_kern_mount+0x0/0x140) from
> [<c00942d0>] (do_kern_mount+0x40/0xdc)
> [43132283.820000] [<c0094290>] (do_kern_mount+0x0/0xdc) from
> [<c00ab0d0>] (do_new_mount+0x5c/0x8c)
> [43132283.830000]  r8:00000001 r7:00000040 r6:df0d1ef0 r5:dfe7b000
> r4:00000001
> [43132283.830000] [<c00ab074>] (do_new_mount+0x0/0x8c) from [<c00ab298>]
> (do_mount+0x198/0x1c0)
> [43132283.850000]  r7:df0d1ef0 r6:00000040 r5:00000001 r4:00000000
> [43132283.850000] [<c00ab100>] (do_mount+0x0/0x1c0) from [<c00ab34c>]
> (sys_mount+0x8c/0xd4)
> [43132283.860000] [<c00ab2c0>] (sys_mount+0x0/0xd4) from [<c0024a60>]
> (ret_fast_syscall+0x0/0x3c)
> [43132283.860000]  r7:00000015 r6:beb295c0 r5:beb29598 r4:00000000
> [43132283.870000] XFS: log mount/recovery failed: error 117
> [43132283.910000] XFS: log mount failed
> 
> thecus:~# xfs_repair /dev/md1
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>         - zero log...
> ERROR: The filesystem has valuable metadata changes in a log which needs
> to
> be replayed.  Mount the filesystem to replay the log, and unmount it
> before
> re-running xfs_repair.  If you are unable to mount the filesystem, then
> use
> the -L option to destroy the log and attempt a repair.
> Note that destroying the log may cause corruption -- please attempt a
> mount
> of the filesystem before doing this.
> thecus:~# xfs_repair -L /dev/md1
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>         - zero log...
> ALERT: The filesystem has valuable metadata changes in a log which is
> being
> destroyed because the -L option was used.
>         - scan filesystem freespace and inode maps...
>         - found root inode chunk
> Phase 3 - for each AG...
>         - scan and clear agi unlinked lists...
>         - process known inodes and perform inode discovery...
>         - agno = 0
>         - agno = 1
>         - agno = 2
>         - agno = 3
>         - process newly discovered inodes...
> Phase 4 - check for duplicate blocks...
>         - setting up duplicate extent list...
>         - check for inodes claiming duplicate blocks...
>         - agno = 0
>         - agno = 1
>         - agno = 2
>         - agno = 3
> Phase 5 - rebuild AG headers and trees...
>         - reset superblock...
> Phase 6 - check inode connectivity...
>         - resetting contents of realtime bitmap and summary inodes
>         - traversing filesystem ...
>         - traversal finished ...
>         - moving disconnected inodes to lost+found ...
> Phase 7 - verify and correct link counts...
> done
> 
> thecus:~# xfs_check /dev/md1 2>&1 | tee fsck.log -
> thecus:~# mount /dev/md1 /tmp/tst/
> thecus:~# dmesg
> [43132552.030000] Filesystem "md1": Disabling barriers, not supported by
> the underlying device
> [43132552.050000] XFS mounting filesystem md1
> [43132552.190000] Ending clean XFS mount for filesystem: md1
> 
> thecus:~# cd /tmp/tst
> thecus:/tmp/tst# rm -r ltp-full-20080731
> rm: cannot remove directory
> `ltp-full-20080731/testcases/kernel/syscalls': Directory not empty
> rm: cannot remove directory
> `ltp-full-20080731/testcases/ballista/ballista/outfiles': Directory not
> empty
> rm: cannot remove directory
> `ltp-full-20080731/testcases/open_posix_testsuite/conformance/interfaces': Directory not empty
> rm: cannot remove directory
> `ltp-full-20080731/testcases/network/rpc/rpc-tirpc-full-test-suite':
> Directory not empty
> rm: cannot remove directory
> `ltp-full-20080731/testcases/open_hpi_testsuite/utils/t/epath':
> Directory not empty
> thecus:/tmp/tst# rm -rf ltp-full-20080731
> rm: cannot remove directory
> `ltp-full-20080731/testcases/kernel/syscalls': Directory not empty
> rm: cannot remove directory
> `ltp-full-20080731/testcases/ballista/ballista/outfiles': Directory not
> empty
> rm: cannot remove directory
> `ltp-full-20080731/testcases/open_posix_testsuite/conformance/interfaces': Directory not empty
> rm: cannot remove directory
> `ltp-full-20080731/testcases/network/rpc/rpc-tirpc-full-test-suite':
> Directory not empty
> rm: cannot remove directory
> `ltp-full-20080731/testcases/open_hpi_testsuite/utils/t/epath':
> Directory not empty
> 
> thecus:~# dmesg
> [43132552.190000] Ending clean XFS mount for filesystem: md1
> [43132681.530000] 00000000: 58 46 53 42 00 00 10 00 00 00 00 00 00 07 72
> 10  XFSB..........r.
> [43132681.550000] Filesystem "md1": XFS internal error xfs_da_do_buf(2)
> at line 2085 of file fs/xfs/xfs_da_btree.c.  Caller 0xbf226cac
> [43132681.560000] [<c00291e0>] (dump_stack+0x0/0x14) from [<bf232704>]
> (xfs_error_report+0x4c/0x5c [xfs])
> [43132681.570000] [<bf2326b8>] (xfs_error_report+0x0/0x5c [xfs]) from
> [<bf232770>] (xfs_corruption_error+0x5c/0x68 [xfs])
> [43132681.580000]  r4:def2e400
> [43132681.580000] [<bf232714>] (xfs_corruption_error+0x0/0x68 [xfs])
> from [<bf226b00>] (xfs_da_do_buf+0x568/0x688 [xfs])
> [43132681.580000]  r6:bf226cac r5:00000000 r4:ce179438
> [43132681.600000] [<bf226598>] (xfs_da_do_buf+0x0/0x688 [xfs]) from
> [<bf226cac>] (xfs_da_read_buf+0x34/0x3c [xfs])
> [43132681.600000] [<bf226c78>] (xfs_da_read_buf+0x0/0x3c [xfs]) from
> [<bf22ccdc>] (xfs_dir2_leaf_getdents+0x484/0x8bc [xfs])
> [43132681.620000] [<bf22c858>] (xfs_dir2_leaf_getdents+0x0/0x8bc [xfs])
> from [<bf229200>] (xfs_readdir+0xcc/0xe0 [xfs])
> [43132681.620000] [<bf229134>] (xfs_readdir+0x0/0xe0 [xfs]) from
> [<bf25ff7c>] (xfs_file_readdir+0x144/0x194 [xfs])
> [43132681.640000] [<bf25fe38>] (xfs_file_readdir+0x0/0x194 [xfs]) from
> [<c009ee48>] (vfs_readdir+0x84/0xb8)
> [43132681.650000] [<c009edc4>] (vfs_readdir+0x0/0xb8) from [<c009eee8>]
> (sys_getdents64+0x6c/0xc0)
> [43132681.650000] [<c009ee7c>] (sys_getdents64+0x0/0xc0) from
> [<c0024a60>] (ret_fast_syscall+0x0/0x3c)
> [43132681.670000]  r7:000000d9 r6:0001ea84 r5:0001ea98 r4:00000000
> [43132682.010000] 00000000: 58 46 53 42 00 00 10 00 00 00 00 00 00 07 72
> 10  XFSB..........r.
> [43132682.030000] Filesystem "md1": XFS internal error xfs_da_do_buf(2)
> at line 2085 of file fs/xfs/xfs_da_btree.c.  Caller 0xbf226cac
> [43132682.040000] [<c00291e0>] (dump_stack+0x0/0x14) from [<bf232704>]
> (xfs_error_report+0x4c/0x5c [xfs])
> [43132682.050000] [<bf2326b8>] (xfs_error_report+0x0/0x5c [xfs]) from
> [<bf232770>] (xfs_corruption_error+0x5c/0x68 [xfs])
> [43132682.050000]  r4:def2e400
> [43132682.050000] [<bf232714>] (xfs_corruption_error+0x0/0x68 [xfs])
> from [<bf226b00>] (xfs_da_do_buf+0x568/0x688 [xfs])
> [43132682.080000]  r6:bf226cac r5:00000000 r4:ce179438
> [43132682.080000] [<bf226598>] (xfs_da_do_buf+0x0/0x688 [xfs]) from
> [<bf226cac>] (xfs_da_read_buf+0x34/0x3c [xfs])
> [43132682.090000] [<bf226c78>] (xfs_da_read_buf+0x0/0x3c [xfs]) from
> [<bf22ccdc>] (xfs_dir2_leaf_getdents+0x484/0x8bc [xfs])
> [43132682.100000] [<bf22c858>] (xfs_dir2_leaf_getdents+0x0/0x8bc [xfs])
> from [<bf229200>] (xfs_readdir+0xcc/0xe0 [xfs])
> [43132682.110000] [<bf229134>] (xfs_readdir+0x0/0xe0 [xfs]) from
> [<bf25ff7c>] (xfs_file_readdir+0x144/0x194 [xfs])
> [43132682.130000] [<bf25fe38>] (xfs_file_readdir+0x0/0x194 [xfs]) from
> [<c009ee48>] (vfs_readdir+0x84/0xb8)
> [43132682.140000] [<c009edc4>] (vfs_readdir+0x0/0xb8) from [<c009eee8>]
> (sys_getdents64+0x6c/0xc0)
> [43132682.150000] [<c009ee7c>] (sys_getdents64+0x0/0xc0) from
> [<c0024a60>] (ret_fast_syscall+0x0/0x3c)
> [43132682.150000]  r7:000000d9 r6:0001fdc4 r5:0001fdd8 r4:00000000
> [43132683.550000] 00000000: 58 46 53 42 00 00 10 00 00 00 00 00 00 07 72
> 10  XFSB..........r.
> [43132683.570000] Filesystem "md1": XFS internal error xfs_da_do_buf(2)
> at line 2085 of file fs/xfs/xfs_da_btree.c.  Caller 0xbf226cac
> [43132683.580000] [<c00291e0>] (dump_stack+0x0/0x14) from [<bf232704>]
> (xfs_error_report+0x4c/0x5c [xfs])
> [43132683.590000] [<bf2326b8>] (xfs_error_report+0x0/0x5c [xfs]) from
> [<bf232770>] (xfs_corruption_error+0x5c/0x68 [xfs])
> [43132683.610000]  r4:def2e400
> [43132683.610000] [<bf232714>] (xfs_corruption_error+0x0/0x68 [xfs])
> from [<bf226b00>] (xfs_da_do_buf+0x568/0x688 [xfs])
> [43132683.620000]  r6:bf226cac r5:00000000 r4:ce179438
> [43132683.620000] [<bf226598>] (xfs_da_do_buf+0x0/0x688 [xfs]) from
> [<bf226cac>] (xfs_da_read_buf+0x34/0x3c [xfs])
> [43132683.640000] [<bf226c78>] (xfs_da_read_buf+0x0/0x3c [xfs]) from
> [<bf22ccdc>] (xfs_dir2_leaf_getdents+0x484/0x8bc [xfs])
> [43132683.650000] [<bf22c858>] (xfs_dir2_leaf_getdents+0x0/0x8bc [xfs])
> from [<bf229200>] (xfs_readdir+0xcc/0xe0 [xfs])
> [43132683.650000] [<bf229134>] (xfs_readdir+0x0/0xe0 [xfs]) from
> [<bf25ff7c>] (xfs_file_readdir+0x144/0x194 [xfs])
> [43132683.670000] [<bf25fe38>] (xfs_file_readdir+0x0/0x194 [xfs]) from
> [<c009ee48>] (vfs_readdir+0x84/0xb8)
> [43132683.680000] [<c009edc4>] (vfs_readdir+0x0/0xb8) from [<c009eee8>]
> (sys_getdents64+0x6c/0xc0)
> [43132683.690000] [<c009ee7c>] (sys_getdents64+0x0/0xc0) from
> [<c0024a60>] (ret_fast_syscall+0x0/0x3c)
> [43132683.690000]  r7:000000d9 r6:0001fe04 r5:0001fe18 r4:00000000
> (..)
> 	Valid signature
> 
> 
> 
> 
> 
> 
> 
> 
> 



-- 
Dave Chinner
david@fromorbit.com
