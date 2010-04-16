Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3GAkNVn242862 for <xfs@oss.sgi.com>; Fri, 16 Apr 2010 05:46:24 -0500
Received: from bork.lsof.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5EEF92C916E
	for <xfs@oss.sgi.com>; Fri, 16 Apr 2010 03:48:18 -0700 (PDT)
Received: from bork.lsof.org (bork.lsof.org [87.253.148.42]) by cuda.sgi.com
	with ESMTP id 16DpLIZdk8VeIBc4 for <xfs@oss.sgi.com>;
	Fri, 16 Apr 2010 03:48:18 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by bork.lsof.org (Postfix) with ESMTP id 460B1B8BD
	for <xfs@oss.sgi.com>; Fri, 16 Apr 2010 12:48:17 +0200 (CEST)
Received: from bork.lsof.org ([127.0.0.1])
	by localhost (bork.lsof.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Dg5YE5pT15Z5 for <xfs@oss.sgi.com>;
	Fri, 16 Apr 2010 12:48:13 +0200 (CEST)
Received: from bork.lsof.org (localhost [127.0.0.1])
	by bork.lsof.org (Postfix) with ESMTP id 33202B895
	for <xfs@oss.sgi.com>; Fri, 16 Apr 2010 12:48:13 +0200 (CEST)
Message-ID: <cone.1271414893.151380.55874.1001@bork.lsof.org>
From: Roel van Meer <rolek@bokxing.nl>
Subject: 2.6.32.11 hangs with xfstest 104
Date: Fri, 16 Apr 2010 12:48:13 +0200
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=_bork.lsof.org-1271414893-0000"
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
To: xfs@oss.sgi.com

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bork.lsof.org-1271414893-0000
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Hi list,

I've been running xfstests on a slackware linux server with kernel 
2.6.32.11.
I've noticed that xfstest # 104 reliably hangs the kernel. Attached are two 
call traces.

I'm now going to try the latest of the 2.6.3[34].x series, but in the 
meantime: any clues as whether or not this is a known problem?

Regards,

roel

--=_bork.lsof.org-1271414893-0000
Content-Description: calltrace0.txt
Content-Disposition: attachment;
  FILENAME="calltrace0.txt"
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

Apr 16 11:22:23 1a-server kernel: INFO: task xfsdatad/0:313 blocked for more than 120 seconds.
Apr 16 11:22:23 1a-server kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Apr 16 11:22:23 1a-server kernel: xfsdatad/0    D fc992921     0   313      2 0x00000000
Apr 16 11:22:23 1a-server kernel:  f7577490 00000046 00005085 fc992921 00000084 c2002060 45ccd0ea 00004fcc
Apr 16 11:22:23 1a-server kernel:  c16cf9c0 c16cf9c0 c16cf9c0 c1001842 f7577524 f7577638 c20069c0 e11a67dc
Apr 16 11:22:23 1a-server kernel:  001a67dc f6ffa740 f7577490 f6ffa740 f7577490 ffffffff ebcaa824 f7577490
Apr 16 11:22:23 1a-server kernel: Call Trace:
Apr 16 11:22:23 1a-server kernel:  [<c1001842>] ? __switch_to+0xd2/0x1b0
Apr 16 11:22:23 1a-server kernel:  [<c1497d35>] ? rwsem_down_failed_common+0x65/0x180
Apr 16 11:22:23 1a-server kernel:  [<c104a620>] ? worker_thread+0x0/0x1b0
Apr 16 11:22:23 1a-server kernel:  [<c1497e6a>] ? rwsem_down_write_failed+0x1a/0x30
Apr 16 11:22:23 1a-server kernel:  [<c1497ee2>] ? call_rwsem_down_write_failed+0x6/0x8
Apr 16 11:22:23 1a-server kernel:  [<c14975e2>] ? down_write+0x12/0x20
Apr 16 11:22:23 1a-server kernel:  [<c11f3028>] ? xfs_setfilesize+0x28/0x70
Apr 16 11:22:23 1a-server kernel:  [<c11f307d>] ? xfs_end_bio_written+0xd/0x20
Apr 16 11:22:23 1a-server kernel:  [<c104a70c>] ? worker_thread+0xec/0x1b0
Apr 16 11:22:23 1a-server kernel:  [<c11f3070>] ? xfs_end_bio_written+0x0/0x20
Apr 16 11:22:23 1a-server kernel:  [<c104da00>] ? autoremove_wake_function+0x0/0x40
Apr 16 11:22:23 1a-server kernel:  [<c104a620>] ? worker_thread+0x0/0x1b0
Apr 16 11:22:23 1a-server kernel:  [<c104d924>] ? kthread+0x74/0x80
Apr 16 11:22:23 1a-server kernel:  [<c104d8b0>] ? kthread+0x0/0x80
Apr 16 11:22:23 1a-server kernel:  [<c10037e7>] ? kernel_thread_helper+0x7/0x30
Apr 16 11:22:23 1a-server kernel: INFO: task flush-9:12:32697 blocked for more than 120 seconds.
Apr 16 11:22:23 1a-server kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Apr 16 11:22:23 1a-server kernel: flush-9:12    D 00000000     0 32697      2 0x00000000
Apr 16 11:22:23 1a-server kernel:  eb1f3870 00000046 c103321f 00000000 c20069c0 00000002 00000005 000069c0
Apr 16 11:22:23 1a-server kernel:  c16cf9c0 c16cf9c0 c16cf9c0 00000282 eb1f3904 eb1f3a18 c20069c0 00009120
Apr 16 11:22:23 1a-server kernel:  00000000 00000000 00000282 e685fba8 cf1f1560 e685fba8 eb1f3870 ebb089c0
Apr 16 11:22:23 1a-server kernel: Call Trace:
Apr 16 11:22:23 1a-server kernel:  [<c103321f>] ? check_preempt_wakeup+0x12f/0x240
Apr 16 11:22:23 1a-server kernel:  [<c11de418>] ? xlog_grant_log_space+0xc8/0x240
Apr 16 11:22:23 1a-server kernel:  [<c102d9c0>] ? default_wake_function+0x0/0x10
Apr 16 11:22:23 1a-server kernel:  [<c11e9fdf>] ? xfs_trans_reserve+0x7f/0x200
Apr 16 11:22:23 1a-server kernel:  [<c11d8baf>] ? xfs_iomap_write_allocate+0x12f/0x4a0
Apr 16 11:22:23 1a-server kernel:  [<c11d9cfb>] ? xfs_iomap+0x33b/0x410
Apr 16 11:22:23 1a-server kernel:  [<c11f3305>] ? xfs_map_blocks+0x35/0x40
Apr 16 11:22:23 1a-server kernel:  [<c11f46c4>] ? xfs_page_state_convert+0x394/0x820
Apr 16 11:22:23 1a-server kernel:  [<c1022aec>] ? kmap_atomic+0x1c/0x30
Apr 16 11:22:23 1a-server kernel:  [<c10228b4>] ? kunmap_atomic+0x54/0x70
Apr 16 11:22:23 1a-server kernel:  [<c1081df8>] ? find_get_pages_tag+0x38/0xd0
Apr 16 11:22:23 1a-server kernel:  [<c11f4c83>] ? xfs_vm_writepage+0x63/0x100
Apr 16 11:22:23 1a-server kernel:  [<c1088218>] ? __writepage+0x8/0x30
Apr 16 11:22:23 1a-server kernel:  [<c10885ae>] ? write_cache_pages+0x24e/0x3a0
Apr 16 11:22:23 1a-server kernel:  [<c1088210>] ? __writepage+0x0/0x30
Apr 16 11:22:23 1a-server kernel:  [<c1088720>] ? generic_writepages+0x20/0x30
Apr 16 11:22:23 1a-server kernel:  [<c11f33c0>] ? xfs_vm_writepages+0x0/0x50
Apr 16 11:22:23 1a-server kernel:  [<c108874a>] ? do_writepages+0x1a/0x30
Apr 16 11:22:23 1a-server kernel:  [<c10cba68>] ? writeback_single_inode+0x98/0x260
Apr 16 11:22:23 1a-server kernel:  [<c10cc268>] ? writeback_inodes_wb+0x268/0x3c0
Apr 16 11:22:23 1a-server kernel:  [<c10cc4ae>] ? wb_writeback+0xee/0x190
Apr 16 11:22:23 1a-server kernel:  [<c10cc745>] ? wb_do_writeback+0x165/0x180
Apr 16 11:22:23 1a-server kernel:  [<c10cc7a0>] ? bdi_writeback_task+0x40/0x70
Apr 16 11:22:23 1a-server kernel:  [<c1096240>] ? bdi_start_fn+0x0/0xa0
Apr 16 11:22:23 1a-server kernel:  [<c1096292>] ? bdi_start_fn+0x52/0xa0
Apr 16 11:22:23 1a-server kernel:  [<c1096240>] ? bdi_start_fn+0x0/0xa0
Apr 16 11:22:23 1a-server kernel:  [<c104d924>] ? kthread+0x74/0x80
Apr 16 11:22:23 1a-server kernel:  [<c104d8b0>] ? kthread+0x0/0x80
Apr 16 11:22:23 1a-server kernel:  [<c10037e7>] ? kernel_thread_helper+0x7/0x30
Apr 16 11:22:23 1a-server kernel: INFO: task xfssyncd:11167 blocked for more than 120 seconds.
Apr 16 11:22:23 1a-server kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Apr 16 11:22:23 1a-server kernel: xfssyncd      D 00000000     0 11167      2 0x00000000
Apr 16 11:22:23 1a-server kernel:  f74e8c10 00000046 000002d0 00000000 00000250 00000008 f76662c0 c11f269e
Apr 16 11:22:23 1a-server kernel:  c16cf9c0 c16cf9c0 c16cf9c0 00000000 f74e8ca4 f74e8db8 c20069c0 0085722b
Apr 16 11:22:23 1a-server kernel:  ebb089c0 ccc13400 00000282 e12edb7c cf1f14ac e12edb7c f74e8c10 ebb089c0
Apr 16 11:22:23 1a-server kernel: Call Trace:
Apr 16 11:22:23 1a-server kernel:  [<c11f269e>] ? kmem_zone_alloc+0x4e/0xb0
Apr 16 11:22:23 1a-server kernel:  [<c11de418>] ? xlog_grant_log_space+0xc8/0x240
Apr 16 11:22:23 1a-server kernel:  [<c102d9c0>] ? default_wake_function+0x0/0x10
Apr 16 11:22:23 1a-server kernel:  [<c11e9fdf>] ? xfs_trans_reserve+0x7f/0x200
Apr 16 11:22:23 1a-server kernel:  [<c11d8baf>] ? xfs_iomap_write_allocate+0x12f/0x4a0
Apr 16 11:22:23 1a-server kernel:  [<c12d1d4b>] ? scsi_io_completion+0x2cb/0x470
Apr 16 11:22:23 1a-server kernel:  [<c11d9cfb>] ? xfs_iomap+0x33b/0x410
Apr 16 11:22:23 1a-server kernel:  [<c11f3305>] ? xfs_map_blocks+0x35/0x40
Apr 16 11:22:23 1a-server kernel:  [<c11f46c4>] ? xfs_page_state_convert+0x394/0x820
Apr 16 11:22:23 1a-server kernel:  [<c1081df8>] ? find_get_pages_tag+0x38/0xd0
Apr 16 11:22:23 1a-server kernel:  [<c11f4c83>] ? xfs_vm_writepage+0x63/0x100
Apr 16 11:22:23 1a-server kernel:  [<c1088218>] ? __writepage+0x8/0x30
Apr 16 11:22:23 1a-server kernel:  [<c10885ae>] ? write_cache_pages+0x24e/0x3a0
Apr 16 11:22:23 1a-server kernel:  [<c1088210>] ? __writepage+0x0/0x30
Apr 16 11:22:23 1a-server kernel:  [<c1088720>] ? generic_writepages+0x20/0x30
Apr 16 11:22:23 1a-server kernel:  [<c11f33c0>] ? xfs_vm_writepages+0x0/0x50
Apr 16 11:22:23 1a-server kernel:  [<c108874a>] ? do_writepages+0x1a/0x30
Apr 16 11:22:23 1a-server kernel:  [<c10827e1>] ? __filemap_fdatawrite_range+0x71/0x90
Apr 16 11:22:23 1a-server kernel:  [<c1083323>] ? filemap_fdatawrite+0x23/0x30
Apr 16 11:22:23 1a-server kernel:  [<c11f76d3>] ? xfs_flush_pages+0x93/0xa0
Apr 16 11:22:23 1a-server kernel:  [<c10c3ffa>] ? igrab+0x2a/0x30
Apr 16 11:22:23 1a-server kernel:  [<c11fe85f>] ? xfs_sync_inode_data+0xbf/0xf0
Apr 16 11:22:23 1a-server kernel:  [<c11fe7a0>] ? xfs_sync_inode_data+0x0/0xf0
Apr 16 11:22:23 1a-server kernel:  [<c11fea30>] ? xfs_inode_ag_walk+0x50/0xa0
Apr 16 11:22:23 1a-server kernel:  [<c11fead5>] ? xfs_inode_ag_iterator+0x55/0x90
Apr 16 11:22:23 1a-server kernel:  [<c11fe7a0>] ? xfs_sync_inode_data+0x0/0xf0
Apr 16 11:22:23 1a-server kernel:  [<c11febf6>] ? xfs_sync_data+0x26/0x60
Apr 16 11:22:23 1a-server kernel:  [<c11fec48>] ? xfs_flush_inodes_work+0x18/0x40
Apr 16 11:22:23 1a-server kernel:  [<c11fe56d>] ? xfssyncd+0x10d/0x190
Apr 16 11:22:23 1a-server kernel:  [<c11fe460>] ? xfssyncd+0x0/0x190
Apr 16 11:22:23 1a-server kernel:  [<c104d924>] ? kthread+0x74/0x80
Apr 16 11:22:23 1a-server kernel:  [<c104d8b0>] ? kthread+0x0/0x80
Apr 16 11:22:23 1a-server kernel:  [<c10037e7>] ? kernel_thread_helper+0x7/0x30
Apr 16 11:22:23 1a-server kernel: INFO: task fsstress:11173 blocked for more than 120 seconds.
Apr 16 11:22:23 1a-server kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Apr 16 11:22:23 1a-server kernel: fsstress      D c11f6325     0 11173  11171 0x00000000
Apr 16 11:22:23 1a-server kernel:  f6f50b90 00200082 eb311900 c11f6325 00000020 00000000 f7324ae4 00000001
Apr 16 11:22:23 1a-server kernel:  c16cf9c0 c16cf9c0 c16cf9c0 04aae10c f6f50c24 f6f50d38 c20069c0 00000000
Apr 16 11:22:23 1a-server kernel:  00000000 00000003 00000000 0001c30c f74e8c3c 7fffffff cf2cdafc 7fffffff
Apr 16 11:22:23 1a-server kernel: Call Trace:
Apr 16 11:22:23 1a-server kernel:  [<c11f6325>] ? xfs_buf_iorequest+0x35/0x80
Apr 16 11:22:23 1a-server kernel:  [<c1496c15>] ? schedule_timeout+0x115/0x220
Apr 16 11:22:23 1a-server kernel:  [<c103321f>] ? check_preempt_wakeup+0x12f/0x240
Apr 16 11:22:23 1a-server kernel:  [<c149606b>] ? wait_for_common+0x8b/0x110
Apr 16 11:22:23 1a-server kernel:  [<c102d9c0>] ? default_wake_function+0x0/0x10
Apr 16 11:22:23 1a-server kernel:  [<c11fe436>] ? xfs_flush_inodes+0x56/0x80
Apr 16 11:22:23 1a-server kernel:  [<c11d939e>] ? xfs_iomap_write_delay+0x25e/0x370
Apr 16 11:22:23 1a-server kernel:  [<c1041b27>] ? lock_timer_base+0x27/0x60
Apr 16 11:22:23 1a-server kernel:  [<c11d9dc0>] ? xfs_iomap+0x400/0x410
Apr 16 11:22:23 1a-server kernel:  [<c11f3695>] ? __xfs_get_blocks+0xc5/0x300
Apr 16 11:22:23 1a-server kernel:  [<c11f3928>] ? xfs_get_blocks+0x28/0x30
Apr 16 11:22:23 1a-server kernel:  [<c10d22e7>] ? __block_prepare_write+0x1f7/0x3c0
Apr 16 11:22:23 1a-server kernel:  [<c10d253c>] ? block_write_begin+0x4c/0xf0
Apr 16 11:22:23 1a-server kernel:  [<c11f3900>] ? xfs_get_blocks+0x0/0x30
Apr 16 11:22:23 1a-server kernel:  [<c11f2c66>] ? xfs_vm_write_begin+0x46/0x50
Apr 16 11:22:23 1a-server kernel:  [<c11f3900>] ? xfs_get_blocks+0x0/0x30
Apr 16 11:22:23 1a-server kernel:  [<c108298e>] ? generic_file_buffered_write+0xee/0x270
Apr 16 11:22:23 1a-server kernel:  [<c11fb860>] ? xfs_write+0x7b0/0x900
Apr 16 11:22:23 1a-server kernel:  [<c12234ad>] ? blk_peek_request+0x1d/0x180
Apr 16 11:22:23 1a-server kernel:  [<c1223f62>] ? __blk_run_queue+0x72/0x110
Apr 16 11:22:23 1a-server kernel:  [<c11f7484>] ? xfs_file_aio_write+0x64/0x70
Apr 16 11:22:23 1a-server kernel:  [<c10b0fe5>] ? do_sync_write+0xd5/0x120
Apr 16 11:22:23 1a-server kernel:  [<c12d1d4b>] ? scsi_io_completion+0x2cb/0x470
Apr 16 11:22:23 1a-server kernel:  [<c104da00>] ? autoremove_wake_function+0x0/0x40
Apr 16 11:22:23 1a-server kernel:  [<c1017f1f>] ? ack_apic_level+0x6f/0x170
Apr 16 11:22:23 1a-server kernel:  [<c10b0f10>] ? do_sync_write+0x0/0x120
Apr 16 11:22:23 1a-server kernel:  [<c10b17af>] ? vfs_write+0x9f/0x160
Apr 16 11:22:23 1a-server kernel:  [<c10b1e61>] ? sys_write+0x41/0x70
Apr 16 11:22:23 1a-server kernel:  [<c1002d6d>] ? syscall_call+0x7/0xb
Apr 16 11:22:23 1a-server kernel: INFO: task fsstress:11174 blocked for more than 120 seconds.
Apr 16 11:22:23 1a-server kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Apr 16 11:22:23 1a-server kernel: fsstress      D ccc13400     0 11174  11171 0x00000000
Apr 16 11:22:23 1a-server kernel:  f6faa490 00200086 ebede300 ccc13400 00000001 f6ca7c60 f6ca7c60 00000000
Apr 16 11:22:23 1a-server kernel:  c16cf9c0 c16cf9c0 c16cf9c0 f6ca7cb0 f6faa524 f6faa638 c20069c0 00000000
Apr 16 11:22:23 1a-server kernel:  00000000 f6ca7c7c f6ca7c7c 00000000 00000000 fffeffff ccc135a0 f6faa490
Apr 16 11:22:23 1a-server kernel: Call Trace:
Apr 16 11:22:23 1a-server kernel:  [<c1497d35>] ? rwsem_down_failed_common+0x65/0x180
Apr 16 11:22:23 1a-server kernel:  [<c1497e9a>] ? rwsem_down_read_failed+0x1a/0x24
Apr 16 11:22:23 1a-server kernel:  [<c1497ed7>] ? call_rwsem_down_read_failed+0x7/0xc
Apr 16 11:22:23 1a-server kernel:  [<c14975ca>] ? down_read+0xa/0x10
Apr 16 11:22:23 1a-server kernel:  [<c11d0d02>] ? xfs_ialloc_ag_select+0xa2/0x2f0
Apr 16 11:22:23 1a-server kernel:  [<c1081eb5>] ? find_get_page+0x25/0x90
Apr 16 11:22:23 1a-server kernel:  [<c11d1372>] ? xfs_dialloc+0x422/0x950
Apr 16 11:22:23 1a-server kernel:  [<c11dda2a>] ? xlog_state_get_iclog_space+0x2a/0x210
Apr 16 11:22:23 1a-server kernel:  [<c11dda2a>] ? xlog_state_get_iclog_space+0x2a/0x210
Apr 16 11:22:23 1a-server kernel:  [<c123486c>] ? _atomic_dec_and_lock+0x3c/0x50
Apr 16 11:22:23 1a-server kernel:  [<c11d6722>] ? xfs_ialloc+0x62/0x670
Apr 16 11:22:23 1a-server kernel:  [<c11ed2b5>] ? xfs_dir_ialloc+0x85/0x2d0
Apr 16 11:22:23 1a-server kernel:  [<c11e9fdf>] ? xfs_trans_reserve+0x7f/0x200
Apr 16 11:22:23 1a-server kernel:  [<c11efffc>] ? xfs_create+0x3cc/0x5a0
Apr 16 11:22:23 1a-server kernel:  [<c11fa590>] ? xfs_vn_mknod+0x90/0x1a0
Apr 16 11:22:23 1a-server kernel:  [<c10b9f48>] ? vfs_create+0xb8/0x140
Apr 16 11:22:23 1a-server kernel:  [<c10b9515>] ? __lookup_hash+0xd5/0x120
Apr 16 11:22:23 1a-server kernel:  [<c10bce12>] ? do_filp_open+0x7a2/0x8c0
Apr 16 11:22:23 1a-server kernel:  [<c10af5be>] ? do_sys_open+0x5e/0x130
Apr 16 11:22:23 1a-server kernel:  [<c10af70c>] ? sys_open+0x2c/0x40
Apr 16 11:22:23 1a-server kernel:  [<c1002d6d>] ? syscall_call+0x7/0xb
Apr 16 11:22:23 1a-server kernel: INFO: task fsstress:11175 blocked for more than 120 seconds.
Apr 16 11:22:23 1a-server kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Apr 16 11:22:23 1a-server kernel: fsstress      D c149644f     0 11175  11171 0x00000000
Apr 16 11:22:23 1a-server kernel:  e11a67b0 00200082 e11a67b0 c149644f f6c9fc48 f6c9fc4c c123486c eb1d4840
Apr 16 11:22:23 1a-server kernel:  c16cf9c0 c16cf9c0 c16cf9c0 c16cf9c0 e11a6844 e11a6958 c20069c0 e11a6958
Apr 16 11:22:23 1a-server kernel:  c20069c0 00000000 00000000 00000001 00200292 fffeffff ccc135a0 e11a67b0
Apr 16 11:22:23 1a-server kernel: Call Trace:
Apr 16 11:22:23 1a-server kernel:  [<c149644f>] ? schedule+0x27f/0x830
Apr 16 11:22:23 1a-server kernel:  [<c123486c>] ? _atomic_dec_and_lock+0x3c/0x50
Apr 16 11:22:23 1a-server kernel:  [<c1497d35>] ? rwsem_down_failed_common+0x65/0x180
Apr 16 11:22:23 1a-server kernel:  [<c11def29>] ? xlog_state_sync+0x229/0x250
Apr 16 11:22:23 1a-server kernel:  [<c1497e9a>] ? rwsem_down_read_failed+0x1a/0x24
Apr 16 11:22:23 1a-server kernel:  [<c1497ed7>] ? call_rwsem_down_read_failed+0x7/0xc
Apr 16 11:22:23 1a-server kernel:  [<c14975ca>] ? down_read+0xa/0x10
Apr 16 11:22:23 1a-server kernel:  [<c11d0d02>] ? xfs_ialloc_ag_select+0xa2/0x2f0
Apr 16 11:22:23 1a-server kernel:  [<c11d1372>] ? xfs_dialloc+0x422/0x950
Apr 16 11:22:23 1a-server kernel:  [<c1001842>] ? __switch_to+0xd2/0x1b0
Apr 16 11:22:23 1a-server kernel:  [<c149644f>] ? schedule+0x27f/0x830
Apr 16 11:22:23 1a-server kernel:  [<c103321f>] ? check_preempt_wakeup+0x12f/0x240
Apr 16 11:22:23 1a-server kernel:  [<c11d6722>] ? xfs_ialloc+0x62/0x670
Apr 16 11:22:23 1a-server kernel:  [<c11dd3a9>] ? xlog_grant_push_ail+0x39/0x130
Apr 16 11:22:23 1a-server kernel:  [<c11ed2b5>] ? xfs_dir_ialloc+0x85/0x2d0
Apr 16 11:22:23 1a-server kernel:  [<c11e9fdf>] ? xfs_trans_reserve+0x7f/0x200
Apr 16 11:22:23 1a-server kernel:  [<c11efffc>] ? xfs_create+0x3cc/0x5a0
Apr 16 11:22:23 1a-server kernel:  [<c11fa590>] ? xfs_vn_mknod+0x90/0x1a0
Apr 16 11:22:23 1a-server kernel:  [<c10b9f48>] ? vfs_create+0xb8/0x140
Apr 16 11:22:23 1a-server kernel:  [<c10b9515>] ? __lookup_hash+0xd5/0x120
Apr 16 11:22:23 1a-server kernel:  [<c10bce12>] ? do_filp_open+0x7a2/0x8c0
Apr 16 11:22:23 1a-server kernel:  [<c11eb667>] ? xfs_trans_unlocked_item+0x47/0x70
Apr 16 11:22:23 1a-server kernel:  [<c10af5be>] ? do_sys_open+0x5e/0x130
Apr 16 11:22:23 1a-server kernel:  [<c10c6b23>] ? mntput_no_expire+0x13/0x80
Apr 16 11:22:23 1a-server kernel:  [<c10af70c>] ? sys_open+0x2c/0x40
Apr 16 11:22:23 1a-server kernel:  [<c1002d6d>] ? syscall_call+0x7/0xb
Apr 16 11:22:23 1a-server kernel: INFO: task fsstress:11187 blocked for more than 120 seconds.
Apr 16 11:22:23 1a-server kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Apr 16 11:22:23 1a-server kernel: fsstress      D c104da14     0 11187  11185 0x00000000
Apr 16 11:22:23 1a-server kernel:  f6faabd0 00200082 00000001 c104da14 00000000 f6c5bf9c c1023b2b 00000000
Apr 16 11:22:23 1a-server kernel:  c16cf9c0 c16cf9c0 c16cf9c0 00000000 f6faac64 f6faad78 c20069c0 00000000
Apr 16 11:22:23 1a-server kernel:  00000000 00000003 f6c120a8 00000000 cf049d70 c20069c0 f6faabd0 cf049d70
Apr 16 11:22:23 1a-server kernel: Call Trace:
Apr 16 11:22:23 1a-server kernel:  [<c104da14>] ? autoremove_wake_function+0x14/0x40
Apr 16 11:22:23 1a-server kernel:  [<c1023b2b>] ? __wake_up_common+0x4b/0x80
Apr 16 11:22:23 1a-server kernel:  [<c1496a92>] ? io_schedule+0x32/0x50
Apr 16 11:22:23 1a-server kernel:  [<c108207c>] ? sync_page+0x2c/0x40
Apr 16 11:22:23 1a-server kernel:  [<c1496eb2>] ? __wait_on_bit+0x42/0x70
Apr 16 11:22:23 1a-server kernel:  [<c1082050>] ? sync_page+0x0/0x40
Apr 16 11:22:23 1a-server kernel:  [<c10821eb>] ? wait_on_page_bit+0x5b/0x60
Apr 16 11:22:23 1a-server kernel:  [<c104da40>] ? wake_bit_function+0x0/0x60
Apr 16 11:22:23 1a-server kernel:  [<c1082673>] ? wait_on_page_writeback_range+0xa3/0x110
Apr 16 11:22:23 1a-server kernel:  [<c1083367>] ? filemap_write_and_wait+0x37/0x50
Apr 16 11:22:23 1a-server kernel:  [<c11f7761>] ? xfs_flushinval_pages+0x61/0x80
Apr 16 11:22:23 1a-server kernel:  [<c11fb617>] ? xfs_write+0x567/0x900
Apr 16 11:22:23 1a-server kernel:  [<c11f7484>] ? xfs_file_aio_write+0x64/0x70
Apr 16 11:22:23 1a-server kernel:  [<c10b0fe5>] ? do_sync_write+0xd5/0x120
Apr 16 11:22:23 1a-server kernel:  [<c104da00>] ? autoremove_wake_function+0x0/0x40
Apr 16 11:22:23 1a-server kernel:  [<c10b0f10>] ? do_sync_write+0x0/0x120
Apr 16 11:22:23 1a-server kernel:  [<c10b17af>] ? vfs_write+0x9f/0x160
Apr 16 11:22:23 1a-server kernel:  [<c10b0bfc>] ? vfs_llseek+0x3c/0x50
Apr 16 11:22:23 1a-server kernel:  [<c10b1e61>] ? sys_write+0x41/0x70
Apr 16 11:22:23 1a-server kernel:  [<c1002d6d>] ? syscall_call+0x7/0xb
Apr 16 11:22:23 1a-server kernel: INFO: task fsstress:11188 blocked for more than 120 seconds.
Apr 16 11:22:23 1a-server kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Apr 16 11:22:23 1a-server kernel: fsstress      D c13ce0a3     0 11188  11185 0x00000000
Apr 16 11:22:23 1a-server kernel:  eb1cc3d0 00200086 f6c120a8 c13ce0a3 00000000 cf372940 c11d9c13 cf0e1c54
Apr 16 11:22:23 1a-server kernel:  c16cf9c0 c16cf9c0 c16cf9c0 000001a1 eb1cc464 eb1cc578 c20069c0 00856c3a
Apr 16 11:22:23 1a-server kernel:  c1027517 8e249dde 8e249dde 00001359 00000000 fffeffff ccc135a0 eb1cc3d0
Apr 16 11:22:23 1a-server kernel: Call Trace:
Apr 16 11:22:23 1a-server kernel:  [<c13ce0a3>] ? md_make_request+0xa3/0x100
Apr 16 11:22:23 1a-server kernel:  [<c11d9c13>] ? xfs_iomap+0x253/0x410
Apr 16 11:22:23 1a-server kernel:  [<c1027517>] ? update_curr+0x87/0x140
Apr 16 11:22:23 1a-server kernel:  [<c1497d35>] ? rwsem_down_failed_common+0x65/0x180
Apr 16 11:22:23 1a-server kernel:  [<c1497e9a>] ? rwsem_down_read_failed+0x1a/0x24
Apr 16 11:22:23 1a-server kernel:  [<c1497ed7>] ? call_rwsem_down_read_failed+0x7/0xc
Apr 16 11:22:23 1a-server kernel:  [<c14975ca>] ? down_read+0xa/0x10
Apr 16 11:22:23 1a-server kernel:  [<c11d0d02>] ? xfs_ialloc_ag_select+0xa2/0x2f0
Apr 16 11:22:23 1a-server kernel:  [<c104a265>] ? __queue_work+0x25/0x40
Apr 16 11:22:23 1a-server kernel:  [<c104a304>] ? queue_work_on+0x34/0x50
Apr 16 11:22:23 1a-server kernel:  [<c11f2a20>] ? xfs_end_io_direct+0x0/0x80
Apr 16 11:22:23 1a-server kernel:  [<c11d1372>] ? xfs_dialloc+0x422/0x950
Apr 16 11:22:23 1a-server kernel:  [<c10d84cd>] ? dio_complete+0xcd/0xf0
Apr 16 11:22:23 1a-server kernel:  [<c10d92a6>] ? __blockdev_direct_IO+0xcd6/0xfa0
Apr 16 11:22:23 1a-server kernel:  [<c11d33cd>] ? xfs_iext_bno_to_ext+0xad/0x1f0
Apr 16 11:22:23 1a-server kernel:  [<c11d6722>] ? xfs_ialloc+0x62/0x670
Apr 16 11:22:23 1a-server kernel:  [<c11ed2b5>] ? xfs_dir_ialloc+0x85/0x2d0
Apr 16 11:22:23 1a-server kernel:  [<c11e9fdf>] ? xfs_trans_reserve+0x7f/0x200
Apr 16 11:22:23 1a-server kernel:  [<c11efffc>] ? xfs_create+0x3cc/0x5a0
Apr 16 11:22:23 1a-server kernel:  [<c11fa590>] ? xfs_vn_mknod+0x90/0x1a0
Apr 16 11:22:23 1a-server kernel:  [<c10b9f48>] ? vfs_create+0xb8/0x140
Apr 16 11:22:23 1a-server kernel:  [<c10b9515>] ? __lookup_hash+0xd5/0x120
Apr 16 11:22:23 1a-server kernel:  [<c10bce12>] ? do_filp_open+0x7a2/0x8c0
Apr 16 11:22:23 1a-server kernel:  [<c10af5be>] ? do_sys_open+0x5e/0x130
Apr 16 11:22:23 1a-server kernel:  [<c10c6b23>] ? mntput_no_expire+0x13/0x80
Apr 16 11:22:23 1a-server kernel:  [<c10af70c>] ? sys_open+0x2c/0x40
Apr 16 11:22:23 1a-server kernel:  [<c1002d6d>] ? syscall_call+0x7/0xb
Apr 16 11:22:23 1a-server kernel: INFO: task fsstress:11189 blocked for more than 120 seconds.
Apr 16 11:22:23 1a-server kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Apr 16 11:22:23 1a-server kernel: fsstress      D 00000000     0 11189  11185 0x00000000
Apr 16 11:22:23 1a-server kernel:  f74e40f0 00200082 c103321f 00000000 c20069c0 00000003 00000005 000069c0
Apr 16 11:22:23 1a-server kernel:  c16cf9c0 c16cf9c0 c16cf9c0 00200286 f74e4184 f74e4298 c20069c0 00021b4f
Apr 16 11:22:23 1a-server kernel:  00000000 00000000 00200286 eb2f1e0c cf1f1d1c eb2f1e0c f74e40f0 ebb089c0
Apr 16 11:22:23 1a-server kernel: Call Trace:
Apr 16 11:22:23 1a-server kernel:  [<c103321f>] ? check_preempt_wakeup+0x12f/0x240
Apr 16 11:22:23 1a-server kernel:  [<c11de418>] ? xlog_grant_log_space+0xc8/0x240
Apr 16 11:22:23 1a-server kernel:  [<c102d9c0>] ? default_wake_function+0x0/0x10
Apr 16 11:22:23 1a-server kernel:  [<c11e9fdf>] ? xfs_trans_reserve+0x7f/0x200
Apr 16 11:22:23 1a-server kernel:  [<c11eef44>] ? xfs_setattr+0x9a4/0xb90
Apr 16 11:22:23 1a-server kernel:  [<c10b92e7>] ? do_lookup+0x67/0x1c0
Apr 16 11:22:23 1a-server kernel:  [<c10c6b23>] ? mntput_no_expire+0x13/0x80
Apr 16 11:22:23 1a-server kernel:  [<c11fa06f>] ? xfs_vn_setattr+0xf/0x20
Apr 16 11:22:23 1a-server kernel:  [<c10c4895>] ? notify_change+0xe5/0x320
Apr 16 11:22:23 1a-server kernel:  [<c10b007c>] ? do_truncate+0x6c/0xa0
Apr 16 11:22:23 1a-server kernel:  [<c10b0471>] ? do_sys_truncate+0x1b1/0x1e0
Apr 16 11:22:23 1a-server kernel:  [<c1002d6d>] ? syscall_call+0x7/0xb
Apr 16 11:22:23 1a-server kernel: INFO: task fsstress:11201 blocked for more than 120 seconds.
Apr 16 11:22:23 1a-server kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Apr 16 11:22:23 1a-server kernel: fsstress      D c102727e     0 11201  11199 0x00000000
Apr 16 11:22:23 1a-server kernel:  eb2ee070 00200082 00200292 c102727e 00000000 00000000 18dfd059 000001a1
Apr 16 11:22:23 1a-server kernel:  c16cf9c0 c16cf9c0 c16cf9c0 c20065c0 eb2ee104 eb2ee218 c20069c0 00000003
Apr 16 11:22:23 1a-server kernel:  00000000 000031b3 f75774bc eb2ee09c 000031b3 7fffffff 7fffffff eb2ee070
Apr 16 11:22:23 1a-server kernel: Call Trace:
Apr 16 11:22:23 1a-server kernel:  [<c102727e>] ? __wake_up+0x3e/0x60
Apr 16 11:22:23 1a-server kernel:  [<c1496c15>] ? schedule_timeout+0x115/0x220
Apr 16 11:22:23 1a-server kernel:  [<c103321f>] ? check_preempt_wakeup+0x12f/0x240
Apr 16 11:22:23 1a-server kernel:  [<c14976f8>] ? __down+0x48/0x70
Apr 16 11:22:23 1a-server kernel:  [<c105204a>] ? down+0x3a/0x40
Apr 16 11:22:23 1a-server kernel:  [<c11f5bbd>] ? _xfs_buf_find+0xdd/0x1e0
Apr 16 11:22:23 1a-server kernel:  [<c11f269e>] ? kmem_zone_alloc+0x4e/0xb0
Apr 16 11:22:23 1a-server kernel:  [<c11f6bdb>] ? xfs_buf_get_flags+0x5b/0x140
Apr 16 11:22:23 1a-server kernel:  [<c11f6cdc>] ? xfs_buf_read_flags+0x1c/0x90
Apr 16 11:22:23 1a-server kernel:  [<c11ec421>] ? xfs_trans_read_buf+0x1e1/0x350
Apr 16 11:22:23 1a-server kernel:  [<c11a1ea4>] ? xfs_read_agf+0xa4/0x1d0
Apr 16 11:22:23 1a-server kernel:  [<c11a2007>] ? xfs_alloc_read_agf+0x37/0xc0
Apr 16 11:22:23 1a-server kernel:  [<c11a4784>] ? xfs_alloc_fix_freelist+0x434/0x4a0
Apr 16 11:22:23 1a-server kernel:  [<c11dd92b>] ? xlog_state_release_iclog+0x3b/0xd0
Apr 16 11:22:23 1a-server kernel:  [<c11dd9d1>] ? xfs_log_release_iclog+0x11/0x40
Apr 16 11:22:23 1a-server kernel:  [<c11eb1f7>] ? _xfs_trans_commit+0x237/0x350
Apr 16 11:22:23 1a-server kernel:  [<c11a48a1>] ? xfs_free_extent+0xb1/0x110
Apr 16 11:22:23 1a-server kernel:  [<c11ad27a>] ? xfs_bmap_finish+0x13a/0x180
Apr 16 11:22:23 1a-server kernel:  [<c11d4172>] ? xfs_itruncate_finish+0x282/0x3d0
Apr 16 11:22:23 1a-server kernel:  [<c11ee2e5>] ? xfs_free_eofblocks+0x2a5/0x2f0
Apr 16 11:22:23 1a-server kernel:  [<c11f75aa>] ? xfs_file_release+0xa/0x10
Apr 16 11:22:23 1a-server kernel:  [<c10b2317>] ? __fput+0xc7/0x1d0
Apr 16 11:22:23 1a-server kernel:  [<c10af527>] ? filp_close+0x47/0x80
Apr 16 11:22:23 1a-server kernel:  [<c10b0a1f>] ? sys_close+0x5f/0xb0
Apr 16 11:22:23 1a-server kernel:  [<c1002d6d>] ? syscall_call+0x7/0xb

--=_bork.lsof.org-1271414893-0000
Content-Description: calltrace1.txt
Content-Disposition: attachment;
  FILENAME="calltrace1.txt"
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

Apr 16 12:06:06 1a-server kernel: INFO: task fsstress:5854 blocked for more than 120 seconds.
Apr 16 12:06:06 1a-server kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Apr 16 12:06:06 1a-server kernel: fsstress      D c160463c     0  5854   5851 0x00000000
Apr 16 12:06:06 1a-server kernel:  f74f00b0 00200082 00000017 c160463c 00200046 00000051 00000017 00200046
Apr 16 12:06:06 1a-server kernel:  c16cf9c0 c16cf9c0 c16cf9c0 8d44f22b f74f0144 f74f0258 c20069c0 00000000
Apr 16 12:06:06 1a-server kernel:  00000000 0001a3e4 00000000 0001a3e4 c31c6b3c 7fffffff f6e89dec 7fffffff
Apr 16 12:06:06 1a-server kernel: Call Trace:
Apr 16 12:06:06 1a-server kernel:  [<c1496c15>] ? schedule_timeout+0x115/0x220
Apr 16 12:06:06 1a-server kernel:  [<c103321f>] ? check_preempt_wakeup+0x12f/0x240
Apr 16 12:06:06 1a-server kernel:  [<c149606b>] ? wait_for_common+0x8b/0x110
Apr 16 12:06:06 1a-server kernel:  [<c102d9c0>] ? default_wake_function+0x0/0x10
Apr 16 12:06:06 1a-server kernel:  [<c11fe436>] ? xfs_flush_inodes+0x56/0x80
Apr 16 12:06:06 1a-server kernel:  [<c11eff26>] ? xfs_create+0x2f6/0x5a0
Apr 16 12:06:06 1a-server kernel:  [<c11eb667>] ? xfs_trans_unlocked_item+0x47/0x70
Apr 16 12:06:06 1a-server kernel:  [<c11fa590>] ? xfs_vn_mknod+0x90/0x1a0
Apr 16 12:06:06 1a-server kernel:  [<c10b9f48>] ? vfs_create+0xb8/0x140
Apr 16 12:06:06 1a-server kernel:  [<c10b9515>] ? __lookup_hash+0xd5/0x120
Apr 16 12:06:06 1a-server kernel:  [<c10bce12>] ? do_filp_open+0x7a2/0x8c0
Apr 16 12:06:06 1a-server kernel:  [<c10af5be>] ? do_sys_open+0x5e/0x130
Apr 16 12:06:06 1a-server kernel:  [<c10af70c>] ? sys_open+0x2c/0x40
Apr 16 12:06:06 1a-server kernel:  [<c1002d6d>] ? syscall_call+0x7/0xb

--=_bork.lsof.org-1271414893-0000
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--=_bork.lsof.org-1271414893-0000--
