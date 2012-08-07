Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q775tWUn007532 for <xfs@oss.sgi.com>; Tue, 7 Aug 2012 00:55:32 -0500
Received: from mail-qa0-f46.google.com (mail-qa0-f46.google.com
	[209.85.216.46]) by cuda.sgi.com with ESMTP id T4ZiBDkzUdJ5PxWX
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 06 Aug 2012 22:55:29 -0700 (PDT)
Received: by qadb17 with SMTP id b17so1863436qad.5
	for <xfs@oss.sgi.com>; Mon, 06 Aug 2012 22:55:28 -0700 (PDT)
MIME-Version: 1.0
From: "Guk-Bong, Kwon" <gbkwon@gmail.com>
Date: Tue, 7 Aug 2012 14:54:48 +0900
Message-ID: <CAJ-WH_z+6HhooORtMKeO2=kURyiWMcxk_5eUbeBSz3cAXgRRfQ@mail.gmail.com>
Subject: xfs hang when filesystem filled
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
To: xfs@oss.sgi.com

HI all

I tested xfs over nfs using bonnie++

xfs and nfs hang when xfs filesystem filled

What's the problem?


see below
--------------------------------

1. nfs server

    a. uname -a
        - Linux nfs_server 2.6.32.58 #1 SMP Thu Mar 22 13:33:34 KST 2012 x86_64
        Intel(R) Xeon(R) CPU E5606 @ 2.13GHz GenuineIntel GNU/Linux

    b. lvcreate -L 90G -n test ld1

    c. mkfs.xfs -i size=512 -l lazy-count=1 /dev/ld1/test

    d. mount /dev/ld1/test /test
        - cat /proc/mounts
================================================================================
/dev/ld1/test /test xfs rw,relatime,attr2,noquota 0 0
================================================================================
        - xfs_info /test
================================================================================
meta-data=/dev/ld1/test          isize=512    agcount=4, agsize=5898240 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=23592960, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=11520, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
================================================================================

    e. nfs export /test
        - "/test"
0.0.0.0/0.0.0.0(async,fsid=1342087477,insecure,no_root_squash,no_subtree_check,rw)
        - cat /var/lib/nfs/etab
================================================================================
/test   0.0.0.0/0.0.0.0(rw,async,wdelay,hide,nocrossmnt,insecure,no_root_squash,no_all_squash,no_subtree_check,secure_locks,acl,fsid=1342087477,anonuid=65534,anongid=65534)
================================================================================


2. nfs client

    a. uname -a
        - Linux c1 3.0.31 #2 SMP Wed May 16 11:53:45 KST 2012 x86_64
x86_64 x86_64 GNU/Linux

    b. mount nfs_server:/test /test/
        - cat /proc/mounts
================================================================================
nfs_server:/test/ /test nfs
rw,relatime,vers=3,rsize=1048576,wsize=1048576,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,mountaddr=192.168.100.137,mountvers=3,mountport=7446,mountproto=udp,local_lock=none,addr=192.168.100.137
0 0
================================================================================
    c. bonnie++ test
        - a lot of bonnie++ process
================================================================================
bonnie++ -s 0 -n 200:1024000:1024000 -r 32G -d /test/ -u 0 -g 0 -q &
================================================================================


3. server and client log when xfs and nfs hang up

    a. df -k
================================================================================
#df /test
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/mapper/ld1-test  94325760  94325740        20 100% /test
================================================================================

    b. nfs server messages
================================================================================
Aug  2 18:17:57 anystor1 kernel: INFO: task nfsd:2387 blocked for more
than 120 seconds.
Aug  2 18:17:57 anystor1 kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug  2 18:17:57 anystor1 kernel: nfsd          D ffff88042eedda00
0  2387      2 0x00000000
Aug  2 18:17:57 anystor1 kernel: ffff88042df493e0 0000000000000046
ffff880426a6cc00 ffff88042df494f4
Aug  2 18:17:57 anystor1 kernel: 000000000000c8e8 ffff88042df49fd8
ffff88042eedda00 ffff88043f872d00
Aug  2 18:17:57 anystor1 kernel: ffff88042eeddc70 000000018119ea84
000000002df494f8 0000000000000000
Aug  2 18:17:57 anystor1 kernel: Call Trace:
Aug  2 18:17:57 anystor1 kernel: [<ffffffff811710e0>] ? xfs_bmapi+0x880/0x1230
Aug  2 18:17:57 anystor1 kernel: [<ffffffff8135edad>] ?
schedule_timeout+0x1ed/0x250
Aug  2 18:17:57 anystor1 kernel: [<ffffffff8135dfc8>] ?
wait_for_common+0xe8/0x170
Aug  2 18:17:57 anystor1 kernel: [<ffffffff81038fb0>] ?
default_wake_function+0x0/0x10
Aug  2 18:17:57 anystor1 kernel: [<ffffffff811b7421>] ?
xfs_flush_inodes+0x61/0x90
Aug  2 18:17:57 anystor1 kernel: [<ffffffff81193163>] ?
xfs_iomap_write_delay+0x1a3/0x280
Aug  2 18:17:57 anystor1 kernel: [<ffffffff81193991>] ? xfs_iomap+0x2f1/0x300
Aug  2 18:17:57 anystor1 kernel: [<ffffffff811aba9f>] ?
__xfs_get_blocks+0x8f/0x220
Aug  2 18:17:57 anystor1 kernel: [<ffffffff810d0e0d>] ?
alloc_buffer_head+0x3d/0x50
Aug  2 18:17:57 anystor1 kernel: [<ffffffff810d1689>] ?
alloc_page_buffers+0x79/0xf0
Aug  2 18:17:57 anystor1 kernel: [<ffffffff810d3594>] ?
__block_prepare_write+0x294/0x580
Aug  2 18:17:57 anystor1 kernel: [<ffffffff811abc50>] ? xfs_get_blocks+0x0/0x10
Aug  2 18:17:57 anystor1 kernel: [<ffffffff810d39f5>] ?
block_write_begin+0x55/0xe0
Aug  2 18:17:57 anystor1 kernel: [<ffffffff811ad002>] ?
xfs_vm_write_begin+0x22/0x30
Aug  2 18:17:57 anystor1 kernel: [<ffffffff811abc50>] ? xfs_get_blocks+0x0/0x10
Aug  2 18:17:57 anystor1 kernel: [<ffffffff810770f4>] ?
generic_file_buffered_write+0x114/0x290
Aug  2 18:17:57 anystor1 kernel: [<ffffffff812dd970>] ?
dev_queue_xmit+0x110/0x4d0
Aug  2 18:17:57 anystor1 kernel: [<ffffffff811b41fc>] ? xfs_write+0x6cc/0x950
Aug  2 18:17:57 anystor1 kernel: [<ffffffff8107a979>] ?
free_one_page+0x1b9/0x320
Aug  2 18:17:57 anystor1 kernel: [<ffffffff812d76d9>] ?
skb_copy_datagram_iovec+0x49/0x230
Aug  2 18:17:57 anystor1 kernel: [<ffffffff8118c3ef>] ? xfs_iget+0x25f/0x4d0
Aug  2 18:17:57 anystor1 kernel: [<ffffffff811b00d0>] ?
xfs_file_aio_write+0x0/0x60
Aug  2 18:17:57 anystor1 kernel: [<ffffffff810ab9eb>] ?
do_sync_readv_writev+0xcb/0x110
Aug  2 18:17:57 anystor1 kernel: [<ffffffff81052cd0>] ?
autoremove_wake_function+0x0/0x30
Aug  2 18:17:57 anystor1 kernel: [<ffffffff810ab826>] ?
rw_copy_check_uvector+0x86/0x130
Aug  2 18:17:57 anystor1 kernel: [<ffffffff810ac0d2>] ?
do_readv_writev+0xe2/0x230
Aug  2 18:17:57 anystor1 kernel: [<ffffffff81145eb2>] ? nfsd_setuser+0x122/0x2b0
Aug  2 18:17:57 anystor1 kernel: [<ffffffff8113ea6c>] ?
nfsd_setuser_and_check_port+0x5c/0x70
Aug  2 18:17:57 anystor1 kernel: [<ffffffff8113f3a3>] ?
nfsd_permission+0xf3/0x170
Aug  2 18:17:57 anystor1 kernel: [<ffffffff811407a1>] ?
nfsd_vfs_write+0xe1/0x440
Aug  2 18:17:57 anystor1 kernel: [<ffffffff810a9e2b>] ?
__dentry_open+0x10b/0x300
Aug  2 18:17:57 anystor1 kernel: [<ffffffff81141187>] ? nfsd_open+0x147/0x1f0
Aug  2 18:17:57 anystor1 kernel: [<ffffffff811415fe>] ? nfsd_write+0xfe/0x110
Aug  2 18:17:57 anystor1 kernel: [<ffffffff81148ba6>] ?
nfsd3_proc_write+0xb6/0x160
Aug  2 18:17:57 anystor1 kernel: [<ffffffff8113b3ca>] ? nfsd_dispatch+0xba/0x270
Aug  2 18:17:57 anystor1 kernel: [<ffffffff81346f1a>] ? svc_process+0x4aa/0x800
Aug  2 18:17:57 anystor1 kernel: [<ffffffff81038fb0>] ?
default_wake_function+0x0/0x10
Aug  2 18:17:57 anystor1 kernel: [<ffffffff8113ba00>] ? nfsd+0x0/0x150
Aug  2 18:17:57 anystor1 kernel: [<ffffffff8113bacd>] ? nfsd+0xcd/0x150
Aug  2 18:17:57 anystor1 kernel: [<ffffffff810529d6>] ? kthread+0x96/0xb0
Aug  2 18:17:57 anystor1 kernel: [<ffffffff8100cc7a>] ? child_rip+0xa/0x20
Aug  2 18:17:57 anystor1 kernel: [<ffffffff8101ea10>] ?
lapic_next_event+0x0/0x20
Aug  2 18:17:57 anystor1 kernel: [<ffffffff81052940>] ? kthread+0x0/0xb0
Aug  2 18:17:57 anystor1 kernel: [<ffffffff8100cc70>] ? child_rip+0x0/0x20
Aug  2 18:17:58 anystor1 kernel: INFO: task nfsd:2403 blocked for more
than 120 seconds.
Aug  2 18:17:58 anystor1 kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug  2 18:17:58 anystor1 kernel: nfsd          D ffff88042d593840
0  2403      2 0x00000000
Aug  2 18:17:58 anystor1 kernel: ffff88042cfe3ad0 0000000000000046
0000000000000000 ffffffff8117a64b
Aug  2 18:17:58 anystor1 kernel: 000000000000c8e8 ffff88042cfe3fd8
ffff88042d593840 ffff88043f8d8b40
Aug  2 18:17:58 anystor1 kernel: ffff88042d593ab0 0000000500000286
000000010a5219d8 ffff8800282ac8e8
Aug  2 18:17:58 anystor1 kernel: Call Trace:
Aug  2 18:17:58 anystor1 kernel: [<ffffffff8117a64b>] ?
xfs_da_do_buf+0x52b/0x700
Aug  2 18:17:58 anystor1 kernel: [<ffffffff8135edad>] ?
schedule_timeout+0x1ed/0x250
Aug  2 18:17:58 anystor1 kernel: [<ffffffff8135dfc8>] ?
wait_for_common+0xe8/0x170
Aug  2 18:17:58 anystor1 kernel: [<ffffffff81038fb0>] ?
default_wake_function+0x0/0x10
Aug  2 18:17:58 anystor1 kernel: [<ffffffff811b7421>] ?
xfs_flush_inodes+0x61/0x90
Aug  2 18:17:58 anystor1 kernel: [<ffffffff811a83f8>] ? xfs_create+0x348/0x600
Aug  2 18:17:58 anystor1 kernel: [<ffffffff81145eb2>] ? nfsd_setuser+0x122/0x2b0
Aug  2 18:17:58 anystor1 kernel: [<ffffffff810b48cd>] ?
generic_permission+0x1d/0xc0
Aug  2 18:17:58 anystor1 kernel: [<ffffffff811b2b7d>] ? xfs_vn_mknod+0x8d/0x1e0
Aug  2 18:17:58 anystor1 kernel: [<ffffffff810b5daf>] ? vfs_create+0xef/0x160
Aug  2 18:17:58 anystor1 kernel: [<ffffffff811420eb>] ?
nfsd_create_v3+0x45b/0x580
Aug  2 18:17:58 anystor1 kernel: [<ffffffff81148a58>] ?
nfsd3_proc_create+0x118/0x1b0
Aug  2 18:17:58 anystor1 kernel: [<ffffffff8113b3ca>] ? nfsd_dispatch+0xba/0x270
Aug  2 18:17:58 anystor1 kernel: [<ffffffff81346f1a>] ? svc_process+0x4aa/0x800
Aug  2 18:17:58 anystor1 kernel: [<ffffffff81038fb0>] ?
default_wake_function+0x0/0x10
Aug  2 18:17:58 anystor1 kernel: [<ffffffff8113ba00>] ? nfsd+0x0/0x150
Aug  2 18:17:58 anystor1 kernel: [<ffffffff8113bacd>] ? nfsd+0xcd/0x150
Aug  2 18:17:58 anystor1 kernel: [<ffffffff810529d6>] ? kthread+0x96/0xb0
Aug  2 18:17:58 anystor1 kernel: [<ffffffff8100cc7a>] ? child_rip+0xa/0x20
Aug  2 18:17:58 anystor1 kernel: [<ffffffff8101ea10>] ?
lapic_next_event+0x0/0x20
Aug  2 18:17:58 anystor1 kernel: [<ffffffff81052940>] ? kthread+0x0/0xb0
Aug  2 18:17:58 anystor1 kernel: [<ffffffff8100cc70>] ? child_rip+0x0/0x20
Aug  2 18:17:58 anystor1 kernel: INFO: task xfssyncd:10318 blocked for
more than 120 seconds.
Aug  2 18:17:58 anystor1 kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug  2 18:17:58 anystor1 kernel: xfssyncd      D ffff8802ced4ab80
0 10318      2 0x00000000
Aug  2 18:17:58 anystor1 kernel: ffff880422d6d320 0000000000000046
0000000000000000 0000000000000286
Aug  2 18:17:58 anystor1 kernel: 000000000000c8e8 ffff880422d6dfd8
ffff88042c154920 ffff88043f8db840
Aug  2 18:17:58 anystor1 kernel: ffff88042c154b90 00000007811a4b83
000000010a5227ce ffff8800282ec8e8
Aug  2 18:17:58 anystor1 kernel: Call Trace:
Aug  2 18:17:58 anystor1 kernel: [<ffffffff811738ce>] ?
xfs_btree_is_lastrec+0x4e/0x60
Aug  2 18:17:58 anystor1 kernel: [<ffffffff8135edad>] ?
schedule_timeout+0x1ed/0x250
Aug  2 18:17:58 anystor1 kernel: [<ffffffff8135fcd1>] ? __down+0x61/0xa0
Aug  2 18:17:58 anystor1 kernel: [<ffffffff810572d6>] ? down+0x46/0x50
Aug  2 18:17:58 anystor1 kernel: [<ffffffff811af6a4>] ?
_xfs_buf_find+0x134/0x220
Aug  2 18:17:58 anystor1 kernel: [<ffffffff811af7fe>] ?
xfs_buf_get_flags+0x6e/0x190
Aug  2 18:17:58 anystor1 kernel: [<ffffffff811a525e>] ?
xfs_trans_get_buf+0x10e/0x160
Aug  2 18:17:58 anystor1 kernel: [<ffffffff81161954>] ?
xfs_alloc_fix_freelist+0x144/0x450
Aug  2 18:17:58 anystor1 kernel: [<ffffffff8119e597>] ?
xfs_icsb_disable_counter+0x17/0x160
Aug  2 18:17:58 anystor1 kernel: [<ffffffff8116d2f2>] ?
xfs_bmap_add_extent_delay_real+0x8d2/0x11a0
Aug  2 18:17:58 anystor1 kernel: [<ffffffff811a4b83>] ?
xfs_trans_log_buf+0x63/0xa0
Aug  2 18:17:58 anystor1 kernel: [<ffffffff8119e731>] ?
xfs_icsb_balance_counter_locked+0x31/0xf0
Aug  2 18:17:58 anystor1 kernel: [<ffffffff81161ed1>] ?
xfs_alloc_vextent+0x1b1/0x4c0
Aug  2 18:17:58 anystor1 kernel: [<ffffffff8116e946>] ?
xfs_bmap_btalloc+0x596/0xa70
Aug  2 18:17:58 anystor1 kernel: [<ffffffff8117125a>] ? xfs_bmapi+0x9fa/0x1230
Aug  2 18:17:58 anystor1 kernel: [<ffffffff811965f6>] ?
xlog_state_release_iclog+0x56/0xe0
Aug  2 18:17:58 anystor1 kernel: [<ffffffff811a3a0f>] ?
xfs_trans_reserve+0x9f/0x210
Aug  2 18:17:58 anystor1 kernel: [<ffffffff81192d0e>] ?
xfs_iomap_write_allocate+0x24e/0x3d0
Aug  2 18:17:58 anystor1 kernel: [<ffffffff811c29c0>] ? elv_insert+0xf0/0x260
Aug  2 18:17:58 anystor1 kernel: [<ffffffff8119396b>] ? xfs_iomap+0x2cb/0x300
Aug  2 18:17:58 anystor1 kernel: [<ffffffff811aba05>] ? xfs_map_blocks+0x25/0x30
Aug  2 18:17:58 anystor1 kernel: [<ffffffff811acb64>] ?
xfs_page_state_convert+0x414/0x6d0
Aug  2 18:17:58 anystor1 kernel: [<ffffffff811ad137>] ?
xfs_vm_writepage+0x77/0x130
Aug  2 18:17:58 anystor1 kernel: [<ffffffff8107c8ca>] ? __writepage+0xa/0x40
Aug  2 18:17:58 anystor1 kernel: [<ffffffff8107d0af>] ?
write_cache_pages+0x1df/0x3d0
Aug  2 18:17:58 anystor1 kernel: [<ffffffff8107c8c0>] ? __writepage+0x0/0x40
Aug  2 18:17:58 anystor1 kernel: [<ffffffff81076f4c>] ?
__filemap_fdatawrite_range+0x4c/0x60
Aug  2 18:17:58 anystor1 kernel: [<ffffffff811da3a1>] ?
radix_tree_gang_lookup+0x71/0xf0
Aug  2 18:17:58 anystor1 kernel: [<ffffffff811b029d>] ?
xfs_flush_pages+0xad/0xc0
Aug  2 18:17:58 anystor1 kernel: [<ffffffff811b795a>] ?
xfs_sync_inode_data+0xca/0xf0
Aug  2 18:17:58 anystor1 kernel: [<ffffffff811b7aa0>] ?
xfs_inode_ag_walk+0x80/0x140
Aug  2 18:17:58 anystor1 kernel: [<ffffffff811b7890>] ?
xfs_sync_inode_data+0x0/0xf0
Aug  2 18:17:58 anystor1 kernel: [<ffffffff811b7be8>] ?
xfs_inode_ag_iterator+0x88/0xd0
Aug  2 18:17:58 anystor1 kernel: [<ffffffff811b7890>] ?
xfs_sync_inode_data+0x0/0xf0
Aug  2 18:17:58 anystor1 kernel: [<ffffffff8135ed1d>] ?
schedule_timeout+0x15d/0x250
Aug  2 18:17:58 anystor1 kernel: [<ffffffff811b7f40>] ? xfs_sync_data+0x30/0x60
Aug  2 18:17:58 anystor1 kernel: [<ffffffff811b7f8e>] ?
xfs_flush_inodes_work+0x1e/0x50
Aug  2 18:17:58 anystor1 kernel: [<ffffffff811b726c>] ? xfssyncd+0x13c/0x1d0
Aug  2 18:17:58 anystor1 kernel: [<ffffffff811b7130>] ? xfssyncd+0x0/0x1d0
Aug  2 18:17:58 anystor1 kernel: [<ffffffff810529d6>] ? kthread+0x96/0xb0
Aug  2 18:17:58 anystor1 kernel: [<ffffffff8100cc7a>] ? child_rip+0xa/0x20
Aug  2 18:17:58 anystor1 kernel: [<ffffffff8101ea10>] ?
lapic_next_event+0x0/0x20
Aug  2 18:17:58 anystor1 kernel: [<ffffffff81052940>] ? kthread+0x0/0xb0
Aug  2 18:17:58 anystor1 kernel: [<ffffffff8100cc70>] ? child_rip+0x0/0x20
Aug  2 18:17:58 anystor1 kernel: INFO: task flush-254:16:24467 blocked
for more than 120 seconds.
Aug  2 18:17:58 anystor1 kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug  2 18:17:58 anystor1 kernel: flush-254:16  D 0000000000000002
0 24467      2 0x00000000
Aug  2 18:17:58 anystor1 kernel: ffff880109339ac0 0000000000000046
0000000000000000 ffff88043b404000
Aug  2 18:17:58 anystor1 kernel: 000000000000c8e8 ffff880109339fd8
ffff880358240000 ffff88043f872d00
Aug  2 18:17:58 anystor1 kernel: ffff880358240270 000000010267d800
000000010a52336b ffff88002822c8e8
Aug  2 18:17:58 anystor1 kernel: Call Trace:
Aug  2 18:17:58 anystor1 kernel: [<ffffffff81263464>] ?
scsi_request_fn+0xa4/0x430
Aug  2 18:17:58 anystor1 kernel: [<ffffffff81076120>] ? sync_page+0x0/0x70
Aug  2 18:17:58 anystor1 kernel: [<ffffffff8135eabd>] ? io_schedule+0x4d/0x70
Aug  2 18:17:58 anystor1 kernel: [<ffffffff81076155>] ? sync_page+0x35/0x70
Aug  2 18:17:58 anystor1 kernel: [<ffffffff8135eeba>] ?
__wait_on_bit_lock+0x4a/0xa0
Aug  2 18:17:58 anystor1 kernel: [<ffffffff810760fe>] ? __lock_page+0x5e/0x70
Aug  2 18:17:58 anystor1 kernel: [<ffffffff81052d00>] ?
wake_bit_function+0x0/0x30
Aug  2 18:17:58 anystor1 kernel: [<ffffffff8107e96a>] ?
pagevec_lookup_tag+0x1a/0x30
Aug  2 18:17:58 anystor1 kernel: [<ffffffff8107d094>] ?
write_cache_pages+0x1c4/0x3d0
Aug  2 18:17:58 anystor1 kernel: [<ffffffff8107c8c0>] ? __writepage+0x0/0x40
Aug  2 18:17:58 anystor1 kernel: [<ffffffff810caf22>] ?
writeback_single_inode+0xd2/0x390
Aug  2 18:17:58 anystor1 kernel: [<ffffffff810cbe1d>] ?
writeback_inodes_wb+0x40d/0x5f0
Aug  2 18:17:58 anystor1 kernel: [<ffffffff810cc11e>] ? wb_writeback+0x11e/0x1f0
Aug  2 18:17:58 anystor1 kernel: [<ffffffff810cc464>] ?
wb_do_writeback+0x184/0x190
Aug  2 18:17:58 anystor1 kernel: [<ffffffff810cc4ab>] ?
bdi_writeback_task+0x3b/0xc0
Aug  2 18:17:58 anystor1 kernel: [<ffffffff81089370>] ? bdi_start_fn+0x0/0xf0
Aug  2 18:17:58 anystor1 kernel: [<ffffffff810893ee>] ? bdi_start_fn+0x7e/0xf0
Aug  2 18:17:58 anystor1 kernel: [<ffffffff81089370>] ? bdi_start_fn+0x0/0xf0
Aug  2 18:17:58 anystor1 kernel: [<ffffffff810529d6>] ? kthread+0x96/0xb0
Aug  2 18:17:58 anystor1 kernel: [<ffffffff8100cc7a>] ? child_rip+0xa/0x20
Aug  2 18:17:58 anystor1 kernel: [<ffffffff8101ea10>] ?
lapic_next_event+0x0/0x20
Aug  2 18:17:58 anystor1 kernel: [<ffffffff81052940>] ? kthread+0x0/0xb0
Aug  2 18:17:58 anystor1 kernel: [<ffffffff8100cc70>] ? child_rip+0x0/0x20
Aug  2 18:19:58 anystor1 kernel: INFO: task nfsd:2377 blocked for more
than 120 seconds.
Aug  2 18:19:58 anystor1 kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug  2 18:19:58 anystor1 kernel: nfsd          D ffff88042eeda1c0
0  2377      2 0x00000000
Aug  2 18:19:58 anystor1 kernel: ffff88042e519938 0000000000000046
0000000000000000 0000000000000000
Aug  2 18:19:58 anystor1 kernel: 000000000000c8e8 ffff88042e519fd8
ffff88042eeda1c0 ffffffff814a7840
Aug  2 18:19:58 anystor1 kernel: ffff88042eeda430 0000000000000000
0000000000000000 0000000000000000
Aug  2 18:19:58 anystor1 kernel: Call Trace:
Aug  2 18:19:58 anystor1 kernel: [<ffffffff8135f2ae>] ?
__mutex_lock_slowpath+0xee/0x170
Aug  2 18:19:58 anystor1 kernel: [<ffffffff8135f0ea>] ? mutex_lock+0x1a/0x40
Aug  2 18:19:58 anystor1 kernel: [<ffffffff811b4014>] ? xfs_write+0x4e4/0x950
Aug  2 18:19:58 anystor1 kernel: [<ffffffff8107a979>] ?
free_one_page+0x1b9/0x320
Aug  2 18:19:58 anystor1 kernel: [<ffffffff8118c3ef>] ? xfs_iget+0x25f/0x4d0
Aug  2 18:19:58 anystor1 kernel: [<ffffffff811b00d0>] ?
xfs_file_aio_write+0x0/0x60
Aug  2 18:19:58 anystor1 kernel: [<ffffffff810ab9eb>] ?
do_sync_readv_writev+0xcb/0x110
Aug  2 18:19:58 anystor1 kernel: [<ffffffff81052cd0>] ?
autoremove_wake_function+0x0/0x30
Aug  2 18:19:58 anystor1 kernel: [<ffffffff810ab826>] ?
rw_copy_check_uvector+0x86/0x130
Aug  2 18:19:58 anystor1 kernel: [<ffffffff810ac0d2>] ?
do_readv_writev+0xe2/0x230
Aug  2 18:19:58 anystor1 kernel: [<ffffffff81145eb2>] ? nfsd_setuser+0x122/0x2b0
Aug  2 18:19:58 anystor1 kernel: [<ffffffff8113ea6c>] ?
nfsd_setuser_and_check_port+0x5c/0x70
Aug  2 18:19:58 anystor1 kernel: [<ffffffff8113f3a3>] ?
nfsd_permission+0xf3/0x170
Aug  2 18:19:58 anystor1 kernel: [<ffffffff811407a1>] ?
nfsd_vfs_write+0xe1/0x440
Aug  2 18:19:58 anystor1 kernel: [<ffffffff810a9e2b>] ?
__dentry_open+0x10b/0x300
Aug  2 18:19:58 anystor1 kernel: [<ffffffff81141187>] ? nfsd_open+0x147/0x1f0
Aug  2 18:19:58 anystor1 kernel: [<ffffffff811415fe>] ? nfsd_write+0xfe/0x110
Aug  2 18:19:58 anystor1 kernel: [<ffffffff81148ba6>] ?
nfsd3_proc_write+0xb6/0x160
Aug  2 18:19:58 anystor1 kernel: [<ffffffff8113b3ca>] ? nfsd_dispatch+0xba/0x270
Aug  2 18:19:58 anystor1 kernel: [<ffffffff81346f1a>] ? svc_process+0x4aa/0x800
Aug  2 18:19:58 anystor1 kernel: [<ffffffff81038fb0>] ?
default_wake_function+0x0/0x10
Aug  2 18:19:58 anystor1 kernel: [<ffffffff8113ba00>] ? nfsd+0x0/0x150
Aug  2 18:19:58 anystor1 kernel: [<ffffffff8113bacd>] ? nfsd+0xcd/0x150
Aug  2 18:19:58 anystor1 kernel: [<ffffffff810529d6>] ? kthread+0x96/0xb0
Aug  2 18:19:58 anystor1 kernel: [<ffffffff8100cc7a>] ? child_rip+0xa/0x20
Aug  2 18:19:58 anystor1 kernel: [<ffffffff8101ea10>] ?
lapic_next_event+0x0/0x20
Aug  2 18:19:58 anystor1 kernel: [<ffffffff81052940>] ? kthread+0x0/0xb0
Aug  2 18:19:58 anystor1 kernel: [<ffffffff8100cc70>] ? child_rip+0x0/0x20
Aug  2 18:19:58 anystor1 kernel: INFO: task nfsd:2387 blocked for more
than 120 seconds.
Aug  2 18:19:58 anystor1 kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug  2 18:19:58 anystor1 kernel: nfsd          D ffff88042eedda00
0  2387      2 0x00000000
Aug  2 18:19:58 anystor1 kernel: ffff88042df493e0 0000000000000046
ffff880426a6cc00 ffff88042df494f4
Aug  2 18:19:58 anystor1 kernel: 000000000000c8e8 ffff88042df49fd8
ffff88042eedda00 ffff88043f872d00
Aug  2 18:19:58 anystor1 kernel: ffff88042eeddc70 000000018119ea84
000000002df494f8 0000000000000000
Aug  2 18:19:58 anystor1 kernel: Call Trace:
Aug  2 18:19:58 anystor1 kernel: [<ffffffff811710e0>] ? xfs_bmapi+0x880/0x1230
Aug  2 18:19:58 anystor1 kernel: [<ffffffff8135edad>] ?
schedule_timeout+0x1ed/0x250
Aug  2 18:19:58 anystor1 kernel: [<ffffffff8135dfc8>] ?
wait_for_common+0xe8/0x170
Aug  2 18:19:58 anystor1 kernel: [<ffffffff81038fb0>] ?
default_wake_function+0x0/0x10
Aug  2 18:19:58 anystor1 kernel: [<ffffffff811b7421>] ?
xfs_flush_inodes+0x61/0x90
Aug  2 18:19:58 anystor1 kernel: [<ffffffff81193163>] ?
xfs_iomap_write_delay+0x1a3/0x280
Aug  2 18:19:58 anystor1 kernel: [<ffffffff81193991>] ? xfs_iomap+0x2f1/0x300
Aug  2 18:19:58 anystor1 kernel: [<ffffffff811aba9f>] ?
__xfs_get_blocks+0x8f/0x220
Aug  2 18:19:58 anystor1 kernel: [<ffffffff810d0e0d>] ?
alloc_buffer_head+0x3d/0x50
Aug  2 18:19:58 anystor1 kernel: [<ffffffff810d1689>] ?
alloc_page_buffers+0x79/0xf0
Aug  2 18:19:58 anystor1 kernel: [<ffffffff810d3594>] ?
__block_prepare_write+0x294/0x580
Aug  2 18:19:58 anystor1 kernel: [<ffffffff811abc50>] ? xfs_get_blocks+0x0/0x10
Aug  2 18:19:58 anystor1 kernel: [<ffffffff810d39f5>] ?
block_write_begin+0x55/0xe0
Aug  2 18:19:59 anystor1 kernel: [<ffffffff811ad002>] ?
xfs_vm_write_begin+0x22/0x30
Aug  2 18:19:59 anystor1 kernel: [<ffffffff811abc50>] ? xfs_get_blocks+0x0/0x10
Aug  2 18:19:59 anystor1 kernel: [<ffffffff810770f4>] ?
generic_file_buffered_write+0x114/0x290
Aug  2 18:19:59 anystor1 kernel: [<ffffffff812dd970>] ?
dev_queue_xmit+0x110/0x4d0
Aug  2 18:19:59 anystor1 kernel: [<ffffffff811b41fc>] ? xfs_write+0x6cc/0x950
Aug  2 18:19:59 anystor1 kernel: [<ffffffff8107a979>] ?
free_one_page+0x1b9/0x320
Aug  2 18:19:59 anystor1 kernel: [<ffffffff812d76d9>] ?
skb_copy_datagram_iovec+0x49/0x230
Aug  2 18:19:59 anystor1 kernel: [<ffffffff8118c3ef>] ? xfs_iget+0x25f/0x4d0
Aug  2 18:19:59 anystor1 kernel: [<ffffffff811b00d0>] ?
xfs_file_aio_write+0x0/0x60
Aug  2 18:19:59 anystor1 kernel: [<ffffffff810ab9eb>] ?
do_sync_readv_writev+0xcb/0x110
Aug  2 18:19:59 anystor1 kernel: [<ffffffff81052cd0>] ?
autoremove_wake_function+0x0/0x30
Aug  2 18:19:59 anystor1 kernel: [<ffffffff810ab826>] ?
rw_copy_check_uvector+0x86/0x130
Aug  2 18:19:59 anystor1 kernel: [<ffffffff810ac0d2>] ?
do_readv_writev+0xe2/0x230
Aug  2 18:19:59 anystor1 kernel: [<ffffffff81145eb2>] ? nfsd_setuser+0x122/0x2b0
Aug  2 18:19:59 anystor1 kernel: [<ffffffff8113ea6c>] ?
nfsd_setuser_and_check_port+0x5c/0x70
Aug  2 18:19:59 anystor1 kernel: [<ffffffff8113f3a3>] ?
nfsd_permission+0xf3/0x170
Aug  2 18:19:59 anystor1 kernel: [<ffffffff811407a1>] ?
nfsd_vfs_write+0xe1/0x440
Aug  2 18:19:59 anystor1 kernel: [<ffffffff810a9e2b>] ?
__dentry_open+0x10b/0x300
Aug  2 18:19:59 anystor1 kernel: [<ffffffff81141187>] ? nfsd_open+0x147/0x1f0
Aug  2 18:19:59 anystor1 kernel: [<ffffffff811415fe>] ? nfsd_write+0xfe/0x110
Aug  2 18:19:59 anystor1 kernel: [<ffffffff81148ba6>] ?
nfsd3_proc_write+0xb6/0x160
Aug  2 18:19:59 anystor1 kernel: [<ffffffff8113b3ca>] ? nfsd_dispatch+0xba/0x270
Aug  2 18:19:59 anystor1 kernel: [<ffffffff81346f1a>] ? svc_process+0x4aa/0x800
Aug  2 18:19:59 anystor1 kernel: [<ffffffff81038fb0>] ?
default_wake_function+0x0/0x10
Aug  2 18:19:59 anystor1 kernel: [<ffffffff8113ba00>] ? nfsd+0x0/0x150
Aug  2 18:19:59 anystor1 kernel: [<ffffffff8113bacd>] ? nfsd+0xcd/0x150
Aug  2 18:19:59 anystor1 kernel: [<ffffffff810529d6>] ? kthread+0x96/0xb0
Aug  2 18:19:59 anystor1 kernel: [<ffffffff8100cc7a>] ? child_rip+0xa/0x20
Aug  2 18:19:59 anystor1 kernel: [<ffffffff8101ea10>] ?
lapic_next_event+0x0/0x20
Aug  2 18:19:59 anystor1 kernel: [<ffffffff81052940>] ? kthread+0x0/0xb0
Aug  2 18:19:59 anystor1 kernel: [<ffffffff8100cc70>] ? child_rip+0x0/0x20
Aug  2 18:19:59 anystor1 kernel: INFO: task nfsd:2389 blocked for more
than 120 seconds.
Aug  2 18:19:59 anystor1 kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug  2 18:19:59 anystor1 kernel: nfsd          D ffff88042eede540
0  2389      2 0x00000000
Aug  2 18:19:59 anystor1 kernel: ffff88042d9653e0 0000000000000046
ffff880426afe000 ffff88042d9654f4
Aug  2 18:19:59 anystor1 kernel: 000000000000c8e8 ffff88042d965fd8
ffff88042eede540 ffff88043f8d8b40
Aug  2 18:19:59 anystor1 kernel: ffff88042eede7b0 000000058119ea84
000000002d9654f8 0000000000000000
Aug  2 18:19:59 anystor1 kernel: Call Trace:
Aug  2 18:19:59 anystor1 kernel: [<ffffffff811710e0>] ? xfs_bmapi+0x880/0x1230
Aug  2 18:19:59 anystor1 kernel: [<ffffffff8135edad>] ?
schedule_timeout+0x1ed/0x250
Aug  2 18:19:59 anystor1 kernel: [<ffffffff81035200>] ?
enqueue_task_fair+0x1b0/0x210
Aug  2 18:19:59 anystor1 kernel: [<ffffffff8135dfc8>] ?
wait_for_common+0xe8/0x170
Aug  2 18:19:59 anystor1 kernel: [<ffffffff81038fb0>] ?
default_wake_function+0x0/0x10
Aug  2 18:19:59 anystor1 kernel: [<ffffffff811b7421>] ?
xfs_flush_inodes+0x61/0x90
Aug  2 18:19:59 anystor1 kernel: [<ffffffff81193163>] ?
xfs_iomap_write_delay+0x1a3/0x280
Aug  2 18:19:59 anystor1 kernel: [<ffffffff81193991>] ? xfs_iomap+0x2f1/0x300
Aug  2 18:19:59 anystor1 kernel: [<ffffffff811aba9f>] ?
__xfs_get_blocks+0x8f/0x220
Aug  2 18:19:59 anystor1 kernel: [<ffffffff810d0e0d>] ?
alloc_buffer_head+0x3d/0x50
Aug  2 18:19:59 anystor1 kernel: [<ffffffff810d1689>] ?
alloc_page_buffers+0x79/0xf0
Aug  2 18:19:59 anystor1 kernel: [<ffffffff810d3594>] ?
__block_prepare_write+0x294/0x580
Aug  2 18:19:59 anystor1 kernel: [<ffffffff811abc50>] ? xfs_get_blocks+0x0/0x10
Aug  2 18:19:59 anystor1 kernel: [<ffffffff810d39f5>] ?
block_write_begin+0x55/0xe0
Aug  2 18:19:59 anystor1 kernel: [<ffffffff811ad002>] ?
xfs_vm_write_begin+0x22/0x30
Aug  2 18:19:59 anystor1 kernel: [<ffffffff811abc50>] ? xfs_get_blocks+0x0/0x10
Aug  2 18:19:59 anystor1 kernel: [<ffffffff810770f4>] ?
generic_file_buffered_write+0x114/0x290
Aug  2 18:19:59 anystor1 kernel: [<ffffffff811b41fc>] ? xfs_write+0x6cc/0x950
Aug  2 18:19:59 anystor1 kernel: [<ffffffff8107a979>] ?
free_one_page+0x1b9/0x320
Aug  2 18:19:59 anystor1 kernel: [<ffffffff8118c3ef>] ? xfs_iget+0x25f/0x4d0
Aug  2 18:19:59 anystor1 kernel: [<ffffffff811b00d0>] ?
xfs_file_aio_write+0x0/0x60
Aug  2 18:19:59 anystor1 kernel: [<ffffffff810ab9eb>] ?
do_sync_readv_writev+0xcb/0x110
Aug  2 18:19:59 anystor1 kernel: [<ffffffff81052cd0>] ?
autoremove_wake_function+0x0/0x30
Aug  2 18:19:59 anystor1 kernel: [<ffffffff810ab826>] ?
rw_copy_check_uvector+0x86/0x130
Aug  2 18:19:59 anystor1 kernel: [<ffffffff810ac0d2>] ?
do_readv_writev+0xe2/0x230
Aug  2 18:19:59 anystor1 kernel: [<ffffffff81145eb2>] ? nfsd_setuser+0x122/0x2b0
Aug  2 18:19:59 anystor1 kernel: [<ffffffff8113ea6c>] ?
nfsd_setuser_and_check_port+0x5c/0x70
Aug  2 18:19:59 anystor1 kernel: [<ffffffff8113f3a3>] ?
nfsd_permission+0xf3/0x170
Aug  2 18:19:59 anystor1 kernel: [<ffffffff811407a1>] ?
nfsd_vfs_write+0xe1/0x440
Aug  2 18:19:59 anystor1 kernel: [<ffffffff810a9e2b>] ?
__dentry_open+0x10b/0x300
Aug  2 18:19:59 anystor1 kernel: [<ffffffff81141187>] ? nfsd_open+0x147/0x1f0
Aug  2 18:19:59 anystor1 kernel: [<ffffffff811415fe>] ? nfsd_write+0xfe/0x110
Aug  2 18:19:59 anystor1 kernel: [<ffffffff81148ba6>] ?
nfsd3_proc_write+0xb6/0x160
Aug  2 18:19:59 anystor1 kernel: [<ffffffff8113b3ca>] ? nfsd_dispatch+0xba/0x270
Aug  2 18:19:59 anystor1 kernel: [<ffffffff81346f1a>] ? svc_process+0x4aa/0x800
Aug  2 18:19:59 anystor1 kernel: [<ffffffff81038fb0>] ?
default_wake_function+0x0/0x10
Aug  2 18:19:59 anystor1 kernel: [<ffffffff8113ba00>] ? nfsd+0x0/0x150
Aug  2 18:19:59 anystor1 kernel: [<ffffffff8113bacd>] ? nfsd+0xcd/0x150
Aug  2 18:19:59 anystor1 kernel: [<ffffffff810529d6>] ? kthread+0x96/0xb0
Aug  2 18:19:59 anystor1 kernel: [<ffffffff8100cc7a>] ? child_rip+0xa/0x20
Aug  2 18:19:59 anystor1 kernel: [<ffffffff8101ea10>] ?
lapic_next_event+0x0/0x20
Aug  2 18:19:59 anystor1 kernel: [<ffffffff81052940>] ? kthread+0x0/0xb0
Aug  2 18:19:59 anystor1 kernel: [<ffffffff8100cc70>] ? child_rip+0x0/0x20
Aug  2 18:19:59 anystor1 kernel: INFO: task nfsd:2395 blocked for more
than 120 seconds.
Aug  2 18:19:59 anystor1 kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug  2 18:19:59 anystor1 kernel: nfsd          D ffff88042d590b40
0  2395      2 0x00000000
Aug  2 18:19:59 anystor1 kernel: ffff88042d7a7ce8 0000000000000046
0000000000000000 ffff880109e0ab00
Aug  2 18:19:59 anystor1 kernel: 000000000000c8e8 ffff88042d7a7fd8
ffff88042d590b40 ffffffff814a7840
Aug  2 18:19:59 anystor1 kernel: ffff88042d590db0 000000002d97ac08
000000010a54da62 ffff88002820c8e8
Aug  2 18:19:59 anystor1 kernel: Call Trace:
Aug  2 18:19:59 anystor1 kernel: [<ffffffff810b48cd>] ?
generic_permission+0x1d/0xc0
Aug  2 18:19:59 anystor1 kernel: [<ffffffff8113f331>] ?
nfsd_permission+0x81/0x170
Aug  2 18:19:59 anystor1 kernel: [<ffffffff8135f2ae>] ?
__mutex_lock_slowpath+0xee/0x170
Aug  2 18:19:59 anystor1 kernel: [<ffffffff8135f0ea>] ? mutex_lock+0x1a/0x40
Aug  2 18:19:59 anystor1 kernel: [<ffffffff81141d81>] ?
nfsd_create_v3+0xf1/0x580
Aug  2 18:19:59 anystor1 kernel: [<ffffffff81148a58>] ?
nfsd3_proc_create+0x118/0x1b0
Aug  2 18:19:59 anystor1 kernel: [<ffffffff8113b3ca>] ? nfsd_dispatch+0xba/0x270
Aug  2 18:19:59 anystor1 kernel: [<ffffffff81346f1a>] ? svc_process+0x4aa/0x800
Aug  2 18:19:59 anystor1 kernel: [<ffffffff81038fb0>] ?
default_wake_function+0x0/0x10
Aug  2 18:19:59 anystor1 kernel: [<ffffffff8113ba00>] ? nfsd+0x0/0x150
Aug  2 18:19:59 anystor1 kernel: [<ffffffff8113bacd>] ? nfsd+0xcd/0x150
Aug  2 18:19:59 anystor1 kernel: [<ffffffff810529d6>] ? kthread+0x96/0xb0
Aug  2 18:19:59 anystor1 kernel: [<ffffffff8100cc7a>] ? child_rip+0xa/0x20
Aug  2 18:19:59 anystor1 kernel: [<ffffffff8101ea10>] ?
lapic_next_event+0x0/0x20
Aug  2 18:19:59 anystor1 kernel: [<ffffffff81052940>] ? kthread+0x0/0xb0
Aug  2 18:19:59 anystor1 kernel: [<ffffffff8100cc70>] ? child_rip+0x0/0x20
Aug  2 18:19:59 anystor1 kernel: INFO: task nfsd:2403 blocked for more
than 120 seconds.
Aug  2 18:19:59 anystor1 kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug  2 18:19:59 anystor1 kernel: nfsd          D ffff88042d593840
0  2403      2 0x00000000
Aug  2 18:19:59 anystor1 kernel: ffff88042cfe3ad0 0000000000000046
0000000000000000 ffffffff8117a64b
Aug  2 18:19:59 anystor1 kernel: 000000000000c8e8 ffff88042cfe3fd8
ffff88042d593840 ffff88043f8d8b40
Aug  2 18:19:59 anystor1 kernel: ffff88042d593ab0 0000000500000286
000000010a5219d8 ffff8800282ac8e8
Aug  2 18:19:59 anystor1 kernel: Call Trace:
Aug  2 18:19:59 anystor1 kernel: [<ffffffff8117a64b>] ?
xfs_da_do_buf+0x52b/0x700
Aug  2 18:19:59 anystor1 kernel: [<ffffffff8135edad>] ?
schedule_timeout+0x1ed/0x250
Aug  2 18:19:59 anystor1 kernel: [<ffffffff8135dfc8>] ?
wait_for_common+0xe8/0x170
Aug  2 18:19:59 anystor1 kernel: [<ffffffff81038fb0>] ?
default_wake_function+0x0/0x10
Aug  2 18:19:59 anystor1 kernel: [<ffffffff811b7421>] ?
xfs_flush_inodes+0x61/0x90
Aug  2 18:19:59 anystor1 kernel: [<ffffffff811a83f8>] ? xfs_create+0x348/0x600
Aug  2 18:19:59 anystor1 kernel: [<ffffffff81145eb2>] ? nfsd_setuser+0x122/0x2b0
Aug  2 18:19:59 anystor1 kernel: [<ffffffff810b48cd>] ?
generic_permission+0x1d/0xc0
Aug  2 18:19:59 anystor1 kernel: [<ffffffff811b2b7d>] ? xfs_vn_mknod+0x8d/0x1e0
Aug  2 18:19:59 anystor1 kernel: [<ffffffff810b5daf>] ? vfs_create+0xef/0x160
Aug  2 18:19:59 anystor1 kernel: [<ffffffff811420eb>] ?
nfsd_create_v3+0x45b/0x580
Aug  2 18:19:59 anystor1 kernel: [<ffffffff81148a58>] ?
nfsd3_proc_create+0x118/0x1b0
Aug  2 18:19:59 anystor1 kernel: [<ffffffff8113b3ca>] ? nfsd_dispatch+0xba/0x270
Aug  2 18:19:59 anystor1 kernel: [<ffffffff81346f1a>] ? svc_process+0x4aa/0x800
Aug  2 18:19:59 anystor1 kernel: [<ffffffff81038fb0>] ?
default_wake_function+0x0/0x10
Aug  2 18:19:59 anystor1 kernel: [<ffffffff8113ba00>] ? nfsd+0x0/0x150
Aug  2 18:19:59 anystor1 kernel: [<ffffffff8113bacd>] ? nfsd+0xcd/0x150
Aug  2 18:19:59 anystor1 kernel: [<ffffffff810529d6>] ? kthread+0x96/0xb0
Aug  2 18:19:59 anystor1 kernel: [<ffffffff8100cc7a>] ? child_rip+0xa/0x20
Aug  2 18:19:59 anystor1 kernel: [<ffffffff8101ea10>] ?
lapic_next_event+0x0/0x20
Aug  2 18:19:59 anystor1 kernel: [<ffffffff81052940>] ? kthread+0x0/0xb0
Aug  2 18:19:59 anystor1 kernel: [<ffffffff8100cc70>] ? child_rip+0x0/0x20
Aug  2 19:04:54 anystor1 kernel: nfsd: peername failed (err 107)!
Aug  2 19:04:54 anystor1 kernel: nfsd: peername failed (err 107)!
Aug  2 19:04:54 anystor1 kernel: nfsd: peername failed (err 107)!
Aug  2 19:04:54 anystor1 kernel: nfsd: peername failed (err 107)!
Aug  2 19:04:54 anystor1 kernel: nfsd: peername failed (err 107)!
Aug  2 19:04:54 anystor1 kernel: nfsd: peername failed (err 107)!
Aug  2 19:04:54 anystor1 kernel: nfsd: peername failed (err 107)!
Aug  2 19:04:54 anystor1 kernel: nfsd: peername failed (err 107)!
Aug  2 19:04:54 anystor1 kernel: nfsd: peername failed (err 107)!
Aug  2 19:04:54 anystor1 kernel: nfsd: peername failed (err 107)!
Aug  2 19:17:48 anystor1 kernel: __ratelimit: 12 callbacks suppressed
Aug  2 19:17:48 anystor1 kernel: nfsd: peername failed (err 107)!
Aug  2 19:17:48 anystor1 kernel: nfsd: peername failed (err 107)!
================================================================================

    c. nfs client messages

================================================================================
Aug  2 18:15:53 c1 kernel: INFO: task bonnie++:8007 blocked for more
than 120 seconds.
Aug  2 18:15:53 c1 kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug  2 18:15:53 c1 kernel: bonnie++        D 0000000000000001     0
8007  29681 0x00000000
Aug  2 18:15:53 c1 kernel: INFO: task bonnie++:8014 blocked for more
than 120 seconds.
Aug  2 18:15:53 c1 kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug  2 18:15:53 c1 kernel: bonnie++        D 0000000000000001     0
8014   6567 0x00000000
Aug  2 18:16:41 c1 kernel: nfs: server nfs_server not responding, still trying
Aug  2 18:16:41 c1 kernel: nfs: server nfs_server not responding, still trying
Aug  2 18:16:44 c1 kernel: nfs: server nfs_server not responding, still trying
Aug  2 18:17:53 c1 kernel: INFO: task bonnie++:8007 blocked for more
than 120 seconds.
Aug  2 18:17:53 c1 kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug  2 18:17:53 c1 kernel: bonnie++        D 0000000000000001     0
8007  29681 0x00000000
Aug  2 18:17:53 c1 kernel: INFO: task bonnie++:8014 blocked for more
than 120 seconds.
Aug  2 18:17:53 c1 kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug  2 18:17:53 c1 kernel: bonnie++        D 0000000000000001     0
8014   6567 0x00000000
Aug  2 18:19:53 c1 kernel: INFO: task bonnie++:8007 blocked for more
than 120 seconds.
Aug  2 18:19:53 c1 kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug  2 18:19:53 c1 kernel: bonnie++        D 0000000000000001     0
8007  29681 0x00000000
Aug  2 18:19:53 c1 kernel: INFO: task bonnie++:8014 blocked for more
than 120 seconds.
Aug  2 18:19:53 c1 kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug  2 18:19:53 c1 kernel: bonnie++        D 0000000000000001     0
8014   6567 0x00000000
Aug  2 18:21:53 c1 kernel: INFO: task bonnie++:8007 blocked for more
than 120 seconds.
Aug  2 18:21:53 c1 kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug  2 18:21:53 c1 kernel: bonnie++        D 0000000000000001     0
8007  29681 0x00000000
Aug  2 18:21:53 c1 kernel: INFO: task bonnie++:8014 blocked for more
than 120 seconds.
Aug  2 18:21:53 c1 kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug  2 18:21:53 c1 kernel: bonnie++        D 0000000000000001     0
8014   6567 0x00000000
Aug  2 18:23:53 c1 kernel: INFO: task bonnie++:8007 blocked for more
than 120 seconds.
Aug  2 18:23:53 c1 kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug  2 18:23:53 c1 kernel: bonnie++        D 0000000000000001     0
8007  29681 0x00000000
Aug  2 18:23:53 c1 kernel: INFO: task bonnie++:8014 blocked for more
than 120 seconds.
Aug  2 18:23:53 c1 kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug  2 18:23:53 c1 kernel: bonnie++        D 0000000000000001     0
8014   6567 0x00000000
Aug  2 19:03:49 c1 kernel: nfs: server nfs_server OK
Aug  2 19:03:49 c1 kernel: nfs: server nfs_server OK
Aug  2 19:06:54 c1 kernel: nfs: server nfs_server not responding, still trying
Aug  2 19:06:54 c1 kernel: nfs: server nfs_server not responding, still trying
================================================================================

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
