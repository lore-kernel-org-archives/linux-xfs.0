Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B64A57F37
	for <xfs@oss.sgi.com>; Thu, 16 Jan 2014 13:51:59 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9EB228F804B
	for <xfs@oss.sgi.com>; Thu, 16 Jan 2014 11:51:56 -0800 (PST)
Received: from mail-pd0-f182.google.com (mail-pd0-f182.google.com
	[209.85.192.182]) by cuda.sgi.com with ESMTP id
	0QyJe0FEdKKBxlOv (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 16 Jan 2014 11:51:53 -0800 (PST)
Received: by mail-pd0-f182.google.com with SMTP id v10so3043990pde.27
	for <xfs@oss.sgi.com>; Thu, 16 Jan 2014 11:51:53 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 16 Jan 2014 11:51:52 -0800
Message-ID: <CALNbWOb8+85bKhyKkJ0qHw9FqK8ogW+ePOcUouE=_MBRukRmng@mail.gmail.com>
Subject: xfs: blocked for more than 120 seconds
From: Ivan Novick <inovick@gopivotal.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7014297895412544999=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============7014297895412544999==
Content-Type: multipart/alternative; boundary=bcaec544eeccccc06a04f01bc12c

--bcaec544eeccccc06a04f01bc12c
Content-Type: text/plain; charset=ISO-8859-1

Hello,

I am running a server with heavy workload on a XFS mount:
/dev/mapper/v2-d1 on /d/d1 type xfs (rw,nodev,noatime,inode64,allocsize=16m)
2.6.32-424.el6.x86_64 #1 SMP Mon Oct 14 20:11:50 EDT 2013 x86_64 x86_64
x86_64 GNU/Linux

We get errors in log indicating processes are blocked for more than 120
seconds.

1) Is this expected during heavy workload?
2) What would be the impact on the processes?  Are they basically hung in
userspace waiting for IO?
3) Is there anything we tune here?

Below is the output.

Cheers,
Ivan Novick

INFO: task flush-253:1:6882 blocked for more than 120 seconds.
      Tainted: P           ---------------    2.6.32-424.el6.x86_64 #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
flush-253:1   D 0000000000000000     0  6882      2 0x00000000
 ffff881011fa5690 0000000000000046 0000000000000000 ffff881013cba040
 0000000000000001 ffff88012a447d40 ffff881013cba040 ffff881016eb4830
 ffff881013cba5f8 ffff881011fa5fd8 000000000000fbc8 ffff881013cba5f8
Call Trace:
 [<ffffffff815289d3>] io_schedule+0x73/0xc0
 [<ffffffff81267d18>] get_request_wait+0x108/0x1d0
 [<ffffffff8109b4a0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff812618ce>] ? elv_merge+0x17e/0x1c0
 [<ffffffff81267e79>] blk_queue_bio+0x99/0x620
 [<ffffffff81266f00>] generic_make_request+0x240/0x5a0
 [<ffffffffa01c3f97>] ? dm_merge_bvec+0xc7/0x100 [dm_mod]
 [<ffffffff812672d0>] submit_bio+0x70/0x120
 [<ffffffffa03b9c53>] xfs_submit_ioend_bio+0x33/0x40 [xfs]
 [<ffffffffa03b9d2c>] xfs_submit_ioend+0xcc/0x140 [xfs]
 [<ffffffffa03ba678>] xfs_vm_writepage+0x308/0x590 [xfs]
 [<ffffffff81133967>] __writepage+0x17/0x40
 [<ffffffff81134c2d>] write_cache_pages+0x1fd/0x4c0
 [<ffffffff8100bdae>] ? call_function_single_interrupt+0xe/0x20
 [<ffffffff81133950>] ? __writepage+0x0/0x40
 [<ffffffff81134f14>] generic_writepages+0x24/0x30
 [<ffffffffa03b98ad>] xfs_vm_writepages+0x5d/0x80 [xfs]
 [<ffffffff81134f41>] do_writepages+0x21/0x40
 [<ffffffff811b52ad>] writeback_single_inode+0xdd/0x290
 [<ffffffff811b56ad>] writeback_sb_inodes+0xbd/0x170
 [<ffffffff811b580b>] writeback_inodes_wb+0xab/0x1b0
 [<ffffffff811b5c03>] wb_writeback+0x2f3/0x410
 [<ffffffff81528240>] ? thread_return+0x4e/0x76e
 [<ffffffff81084fb2>] ? del_timer_sync+0x22/0x30
 [<ffffffff811b5ec5>] wb_do_writeback+0x1a5/0x240
 [<ffffffff811b5fc3>] bdi_writeback_task+0x63/0x1b0
 [<ffffffff8109b327>] ? bit_waitqueue+0x17/0xd0
 [<ffffffff81143c40>] ? bdi_start_fn+0x0/0x100
 [<ffffffff81143cc6>] bdi_start_fn+0x86/0x100
 [<ffffffff81143c40>] ? bdi_start_fn+0x0/0x100
 [<ffffffff8109b0f6>] kthread+0x96/0xa0
 [<ffffffff8100c20a>] child_rip+0xa/0x20
 [<ffffffff8109b060>] ? kthread+0x0/0xa0
 [<ffffffff8100c200>] ? child_rip+0x0/0x20
INFO: task ivanserver:6969 blocked for more than 120 seconds.
      Tainted: P           ---------------    2.6.32-424.el6.x86_64 #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
ivanserver      D 0000000000000000     0  6969   6947 0x00000000
 ffff881f4ef179d8 0000000000000082 0000000000000000 000000000000000f
 0000000000000001 ffff8800622143c0 0000000000000001 ffff880062216840
 ffff881f4eeae638 ffff881f4ef17fd8 000000000000fbc8 ffff881f4eeae638
Call Trace:
 [<ffffffff815290e5>] schedule_timeout+0x215/0x2e0
 [<ffffffff8152a0e2>] __down+0x72/0xb0
 [<ffffffffa03bcaa5>] ? _xfs_buf_find+0xe5/0x230 [xfs]
 [<ffffffff810a1591>] down+0x41/0x50
 [<ffffffffa03bc911>] xfs_buf_lock+0x51/0x100 [xfs]
 [<ffffffffa03bcaa5>] _xfs_buf_find+0xe5/0x230 [xfs]
 [<ffffffffa03bd266>] ? _xfs_buf_read+0x46/0x60 [xfs]
 [<ffffffffa03bd266>] ? _xfs_buf_read+0x46/0x60 [xfs]
 [<ffffffffa03bcc24>] xfs_buf_get+0x34/0x1b0 [xfs]
 [<ffffffffa03bd2ac>] xfs_buf_read+0x2c/0x100 [xfs]
 [<ffffffffa03b2c37>] xfs_trans_read_buf+0x197/0x410 [xfs]
 [<ffffffffa0385af9>] xfs_da_do_buf+0x279/0x770 [xfs]
 [<ffffffffa03babcf>] ? xfs_buf_lru_add+0x6f/0x80 [xfs]
 [<ffffffffa03b3288>] ? xfs_trans_brelse+0xe8/0x130 [xfs]
 [<ffffffffa038606a>] xfs_da_read_buf+0x2a/0x30 [xfs]
 [<ffffffffa038c9e6>] ? xfs_dir2_leaf_getdents+0x266/0x780 [xfs]
 [<ffffffffa038c9e6>] xfs_dir2_leaf_getdents+0x266/0x780 [xfs]
 [<ffffffff8119f020>] ? filldir+0x0/0xe0
 [<ffffffffa03891e9>] xfs_readdir+0xf9/0x130 [xfs]
 [<ffffffff8119f020>] ? filldir+0x0/0xe0
 [<ffffffff8100bdae>] ? call_function_single_interrupt+0xe/0x20
 [<ffffffff8119f020>] ? filldir+0x0/0xe0
 [<ffffffffa03be619>] xfs_file_readdir+0x39/0x50 [xfs]
 [<ffffffff8119f2a0>] vfs_readdir+0xc0/0xe0
 [<ffffffff8118a5b0>] ? fget+0x30/0x80
 [<ffffffff8119f429>] sys_getdents+0x89/0xf0
 [<ffffffff8100bfbb>] ? device_not_available+0x1b/0x20
 [<ffffffff8100b072>] system_call_fastpath+0x16/0x1b
INFO: task ivanserver:6972 blocked for more than 120 seconds.
      Tainted: P           ---------------    2.6.32-424.el6.x86_64 #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
ivanserver      D 0000000000000008     0  6972   6948 0x00000000
 ffff88100f1219d8 0000000000000086 0000000000000000 000000000000000f
 0000000000000001 ffff8810788143c0 0000000000000001 ffff881078816840
 ffff88100fd62638 ffff88100f121fd8 000000000000fbc8 ffff88100fd62638
Call Trace:
 [<ffffffff815290e5>] schedule_timeout+0x215/0x2e0
 [<ffffffff8152a0e2>] __down+0x72/0xb0
 [<ffffffffa03bcaa5>] ? _xfs_buf_find+0xe5/0x230 [xfs]
 [<ffffffff810a1591>] down+0x41/0x50
 [<ffffffffa03bc911>] xfs_buf_lock+0x51/0x100 [xfs]
 [<ffffffffa03bcaa5>] _xfs_buf_find+0xe5/0x230 [xfs]
 [<ffffffffa03bd266>] ? _xfs_buf_read+0x46/0x60 [xfs]
 [<ffffffffa03bd266>] ? _xfs_buf_read+0x46/0x60 [xfs]
 [<ffffffffa03bcc24>] xfs_buf_get+0x34/0x1b0 [xfs]
 [<ffffffffa03bd2ac>] xfs_buf_read+0x2c/0x100 [xfs]
 [<ffffffffa03b2c37>] xfs_trans_read_buf+0x197/0x410 [xfs]
 [<ffffffffa0385af9>] xfs_da_do_buf+0x279/0x770 [xfs]
 [<ffffffffa03babcf>] ? xfs_buf_lru_add+0x6f/0x80 [xfs]
 [<ffffffffa03b3288>] ? xfs_trans_brelse+0xe8/0x130 [xfs]
 [<ffffffffa038606a>] xfs_da_read_buf+0x2a/0x30 [xfs]
 [<ffffffffa038c9e6>] ? xfs_dir2_leaf_getdents+0x266/0x780 [xfs]
 [<ffffffffa038c9e6>] xfs_dir2_leaf_getdents+0x266/0x780 [xfs]
 [<ffffffff8119f020>] ? filldir+0x0/0xe0
 [<ffffffffa03891e9>] xfs_readdir+0xf9/0x130 [xfs]
 [<ffffffff8119f020>] ? filldir+0x0/0xe0
 [<ffffffff8119f020>] ? filldir+0x0/0xe0
 [<ffffffffa03be619>] xfs_file_readdir+0x39/0x50 [xfs]
 [<ffffffff8119f2a0>] vfs_readdir+0xc0/0xe0
 [<ffffffff8119f429>] sys_getdents+0x89/0xf0
 [<ffffffff8100bfbb>] ? device_not_available+0x1b/0x20
 [<ffffffff8100b072>] system_call_fastpath+0x16/0x1b
INFO: task ivanserver:6985 blocked for more than 120 seconds.
      Tainted: P           ---------------    2.6.32-424.el6.x86_64 #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
ivanserver      D 0000000000000000     0  6985   6963 0x00000000
 ffff8810103ad9d8 0000000000000082 0000000000000000 000000000000000f
 0000000000000001 ffff8800622143c0 0000000000000001 ffff880062216840
 ffff88100e01e638 ffff8810103adfd8 000000000000fbc8 ffff88100e01e638
Call Trace:
 [<ffffffff815290e5>] schedule_timeout+0x215/0x2e0
 [<ffffffff8152a0e2>] __down+0x72/0xb0
 [<ffffffffa03bcaa5>] ? _xfs_buf_find+0xe5/0x230 [xfs]
 [<ffffffff810a1591>] down+0x41/0x50
 [<ffffffffa03bc911>] xfs_buf_lock+0x51/0x100 [xfs]
 [<ffffffffa03bcaa5>] _xfs_buf_find+0xe5/0x230 [xfs]
 [<ffffffffa03bd266>] ? _xfs_buf_read+0x46/0x60 [xfs]
 [<ffffffffa03bd266>] ? _xfs_buf_read+0x46/0x60 [xfs]
 [<ffffffffa03bcc24>] xfs_buf_get+0x34/0x1b0 [xfs]
 [<ffffffffa03bd2ac>] xfs_buf_read+0x2c/0x100 [xfs]
 [<ffffffffa03b2c37>] xfs_trans_read_buf+0x197/0x410 [xfs]
 [<ffffffffa0385af9>] xfs_da_do_buf+0x279/0x770 [xfs]
 [<ffffffffa03babcf>] ? xfs_buf_lru_add+0x6f/0x80 [xfs]
 [<ffffffffa03b3288>] ? xfs_trans_brelse+0xe8/0x130 [xfs]
 [<ffffffffa038606a>] xfs_da_read_buf+0x2a/0x30 [xfs]
 [<ffffffffa038c9e6>] ? xfs_dir2_leaf_getdents+0x266/0x780 [xfs]
 [<ffffffffa038c9e6>] xfs_dir2_leaf_getdents+0x266/0x780 [xfs]
 [<ffffffff8119f020>] ? filldir+0x0/0xe0
 [<ffffffffa03891e9>] xfs_readdir+0xf9/0x130 [xfs]
 [<ffffffff8119f020>] ? filldir+0x0/0xe0
 [<ffffffff8119f020>] ? filldir+0x0/0xe0
 [<ffffffffa03be619>] xfs_file_readdir+0x39/0x50 [xfs]
 [<ffffffff8119f2a0>] vfs_readdir+0xc0/0xe0
 [<ffffffff8119f429>] sys_getdents+0x89/0xf0
 [<ffffffff8100bfbb>] ? device_not_available+0x1b/0x20
 [<ffffffff8100b072>] system_call_fastpath+0x16/0x1b
INFO: task ivanserver:6989 blocked for more than 120 seconds.
      Tainted: P           ---------------    2.6.32-424.el6.x86_64 #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
ivanserver      D 0000000000000008     0  6989   6981 0x00000000
 ffff8810101279d8 0000000000000086 0000000000000000 000000000000000f
 0000000000000001 ffff8810788143c0 0000000000000001 ffff881078816840
 ffff8810252a4638 ffff881010127fd8 000000000000fbc8 ffff8810252a4638
Call Trace:
 [<ffffffff815290e5>] schedule_timeout+0x215/0x2e0
 [<ffffffff8152a0e2>] __down+0x72/0xb0
 [<ffffffffa03bcaa5>] ? _xfs_buf_find+0xe5/0x230 [xfs]
 [<ffffffff810a1591>] down+0x41/0x50
 [<ffffffffa03bc911>] xfs_buf_lock+0x51/0x100 [xfs]
 [<ffffffffa03bcaa5>] _xfs_buf_find+0xe5/0x230 [xfs]
 [<ffffffffa03bd266>] ? _xfs_buf_read+0x46/0x60 [xfs]
 [<ffffffffa03bd266>] ? _xfs_buf_read+0x46/0x60 [xfs]
 [<ffffffffa03bcc24>] xfs_buf_get+0x34/0x1b0 [xfs]
 [<ffffffffa03bd2ac>] xfs_buf_read+0x2c/0x100 [xfs]
 [<ffffffffa03b2c37>] xfs_trans_read_buf+0x197/0x410 [xfs]
 [<ffffffffa0385af9>] xfs_da_do_buf+0x279/0x770 [xfs]
 [<ffffffffa03babcf>] ? xfs_buf_lru_add+0x6f/0x80 [xfs]
 [<ffffffffa03b3288>] ? xfs_trans_brelse+0xe8/0x130 [xfs]
 [<ffffffffa038606a>] xfs_da_read_buf+0x2a/0x30 [xfs]
 [<ffffffffa038c9e6>] ? xfs_dir2_leaf_getdents+0x266/0x780 [xfs]
 [<ffffffffa038c9e6>] xfs_dir2_leaf_getdents+0x266/0x780 [xfs]
 [<ffffffff8119f020>] ? filldir+0x0/0xe0
 [<ffffffffa03891e9>] xfs_readdir+0xf9/0x130 [xfs]
 [<ffffffff8119f020>] ? filldir+0x0/0xe0
 [<ffffffff8119f020>] ? filldir+0x0/0xe0
 [<ffffffffa03be619>] xfs_file_readdir+0x39/0x50 [xfs]
 [<ffffffff8119f2a0>] vfs_readdir+0xc0/0xe0
 [<ffffffff8119f429>] sys_getdents+0x89/0xf0
 [<ffffffff8100bfbb>] ? device_not_available+0x1b/0x20
 [<ffffffff8100b072>] system_call_fastpath+0x16/0x1b
usxxnovicim1:Downloads novici$ cat dmesg.txt
INFO: task flush-253:1:6882 blocked for more than 120 seconds.
      Tainted: P           ---------------    2.6.32-424.el6.x86_64 #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
flush-253:1   D 0000000000000000     0  6882      2 0x00000000
 ffff881011fa5690 0000000000000046 0000000000000000 ffff881013cba040
 0000000000000001 ffff88012a447d40 ffff881013cba040 ffff881016eb4830
 ffff881013cba5f8 ffff881011fa5fd8 000000000000fbc8 ffff881013cba5f8
Call Trace:
 [<ffffffff815289d3>] io_schedule+0x73/0xc0
 [<ffffffff81267d18>] get_request_wait+0x108/0x1d0
 [<ffffffff8109b4a0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff812618ce>] ? elv_merge+0x17e/0x1c0
 [<ffffffff81267e79>] blk_queue_bio+0x99/0x620
 [<ffffffff81266f00>] generic_make_request+0x240/0x5a0
 [<ffffffffa01c3f97>] ? dm_merge_bvec+0xc7/0x100 [dm_mod]
 [<ffffffff812672d0>] submit_bio+0x70/0x120
 [<ffffffffa03b9c53>] xfs_submit_ioend_bio+0x33/0x40 [xfs]
 [<ffffffffa03b9d2c>] xfs_submit_ioend+0xcc/0x140 [xfs]
 [<ffffffffa03ba678>] xfs_vm_writepage+0x308/0x590 [xfs]
 [<ffffffff81133967>] __writepage+0x17/0x40
 [<ffffffff81134c2d>] write_cache_pages+0x1fd/0x4c0
 [<ffffffff8100bdae>] ? call_function_single_interrupt+0xe/0x20
 [<ffffffff81133950>] ? __writepage+0x0/0x40
 [<ffffffff81134f14>] generic_writepages+0x24/0x30
 [<ffffffffa03b98ad>] xfs_vm_writepages+0x5d/0x80 [xfs]
 [<ffffffff81134f41>] do_writepages+0x21/0x40
 [<ffffffff811b52ad>] writeback_single_inode+0xdd/0x290
 [<ffffffff811b56ad>] writeback_sb_inodes+0xbd/0x170
 [<ffffffff811b580b>] writeback_inodes_wb+0xab/0x1b0
 [<ffffffff811b5c03>] wb_writeback+0x2f3/0x410
 [<ffffffff81528240>] ? thread_return+0x4e/0x76e
 [<ffffffff81084fb2>] ? del_timer_sync+0x22/0x30
 [<ffffffff811b5ec5>] wb_do_writeback+0x1a5/0x240
 [<ffffffff811b5fc3>] bdi_writeback_task+0x63/0x1b0
 [<ffffffff8109b327>] ? bit_waitqueue+0x17/0xd0
 [<ffffffff81143c40>] ? bdi_start_fn+0x0/0x100
 [<ffffffff81143cc6>] bdi_start_fn+0x86/0x100
 [<ffffffff81143c40>] ? bdi_start_fn+0x0/0x100
 [<ffffffff8109b0f6>] kthread+0x96/0xa0
 [<ffffffff8100c20a>] child_rip+0xa/0x20
 [<ffffffff8109b060>] ? kthread+0x0/0xa0
 [<ffffffff8100c200>] ? child_rip+0x0/0x20
INFO: task ivanserver:6969 blocked for more than 120 seconds.
      Tainted: P           ---------------    2.6.32-424.el6.x86_64 #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
ivanserver      D 0000000000000000     0  6969   6947 0x00000000
 ffff881f4ef179d8 0000000000000082 0000000000000000 000000000000000f
 0000000000000001 ffff8800622143c0 0000000000000001 ffff880062216840
 ffff881f4eeae638 ffff881f4ef17fd8 000000000000fbc8 ffff881f4eeae638
Call Trace:
 [<ffffffff815290e5>] schedule_timeout+0x215/0x2e0
 [<ffffffff8152a0e2>] __down+0x72/0xb0
 [<ffffffffa03bcaa5>] ? _xfs_buf_find+0xe5/0x230 [xfs]
 [<ffffffff810a1591>] down+0x41/0x50
 [<ffffffffa03bc911>] xfs_buf_lock+0x51/0x100 [xfs]
 [<ffffffffa03bcaa5>] _xfs_buf_find+0xe5/0x230 [xfs]
 [<ffffffffa03bd266>] ? _xfs_buf_read+0x46/0x60 [xfs]
 [<ffffffffa03bd266>] ? _xfs_buf_read+0x46/0x60 [xfs]
 [<ffffffffa03bcc24>] xfs_buf_get+0x34/0x1b0 [xfs]
 [<ffffffffa03bd2ac>] xfs_buf_read+0x2c/0x100 [xfs]
 [<ffffffffa03b2c37>] xfs_trans_read_buf+0x197/0x410 [xfs]
 [<ffffffffa0385af9>] xfs_da_do_buf+0x279/0x770 [xfs]
 [<ffffffffa03babcf>] ? xfs_buf_lru_add+0x6f/0x80 [xfs]
 [<ffffffffa03b3288>] ? xfs_trans_brelse+0xe8/0x130 [xfs]
 [<ffffffffa038606a>] xfs_da_read_buf+0x2a/0x30 [xfs]
 [<ffffffffa038c9e6>] ? xfs_dir2_leaf_getdents+0x266/0x780 [xfs]
 [<ffffffffa038c9e6>] xfs_dir2_leaf_getdents+0x266/0x780 [xfs]
 [<ffffffff8119f020>] ? filldir+0x0/0xe0
 [<ffffffffa03891e9>] xfs_readdir+0xf9/0x130 [xfs]
 [<ffffffff8119f020>] ? filldir+0x0/0xe0
 [<ffffffff8100bdae>] ? call_function_single_interrupt+0xe/0x20
 [<ffffffff8119f020>] ? filldir+0x0/0xe0
 [<ffffffffa03be619>] xfs_file_readdir+0x39/0x50 [xfs]
 [<ffffffff8119f2a0>] vfs_readdir+0xc0/0xe0
 [<ffffffff8118a5b0>] ? fget+0x30/0x80
 [<ffffffff8119f429>] sys_getdents+0x89/0xf0
 [<ffffffff8100bfbb>] ? device_not_available+0x1b/0x20
 [<ffffffff8100b072>] system_call_fastpath+0x16/0x1b
INFO: task ivanserver:6972 blocked for more than 120 seconds.
      Tainted: P           ---------------    2.6.32-424.el6.x86_64 #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
ivanserver      D 0000000000000008     0  6972   6948 0x00000000
 ffff88100f1219d8 0000000000000086 0000000000000000 000000000000000f
 0000000000000001 ffff8810788143c0 0000000000000001 ffff881078816840
 ffff88100fd62638 ffff88100f121fd8 000000000000fbc8 ffff88100fd62638
Call Trace:
 [<ffffffff815290e5>] schedule_timeout+0x215/0x2e0
 [<ffffffff8152a0e2>] __down+0x72/0xb0
 [<ffffffffa03bcaa5>] ? _xfs_buf_find+0xe5/0x230 [xfs]
 [<ffffffff810a1591>] down+0x41/0x50
 [<ffffffffa03bc911>] xfs_buf_lock+0x51/0x100 [xfs]
 [<ffffffffa03bcaa5>] _xfs_buf_find+0xe5/0x230 [xfs]
 [<ffffffffa03bd266>] ? _xfs_buf_read+0x46/0x60 [xfs]
 [<ffffffffa03bd266>] ? _xfs_buf_read+0x46/0x60 [xfs]
 [<ffffffffa03bcc24>] xfs_buf_get+0x34/0x1b0 [xfs]
 [<ffffffffa03bd2ac>] xfs_buf_read+0x2c/0x100 [xfs]
 [<ffffffffa03b2c37>] xfs_trans_read_buf+0x197/0x410 [xfs]
 [<ffffffffa0385af9>] xfs_da_do_buf+0x279/0x770 [xfs]
 [<ffffffffa03babcf>] ? xfs_buf_lru_add+0x6f/0x80 [xfs]
 [<ffffffffa03b3288>] ? xfs_trans_brelse+0xe8/0x130 [xfs]
 [<ffffffffa038606a>] xfs_da_read_buf+0x2a/0x30 [xfs]
 [<ffffffffa038c9e6>] ? xfs_dir2_leaf_getdents+0x266/0x780 [xfs]
 [<ffffffffa038c9e6>] xfs_dir2_leaf_getdents+0x266/0x780 [xfs]
 [<ffffffff8119f020>] ? filldir+0x0/0xe0
 [<ffffffffa03891e9>] xfs_readdir+0xf9/0x130 [xfs]
 [<ffffffff8119f020>] ? filldir+0x0/0xe0
 [<ffffffff8119f020>] ? filldir+0x0/0xe0
 [<ffffffffa03be619>] xfs_file_readdir+0x39/0x50 [xfs]
 [<ffffffff8119f2a0>] vfs_readdir+0xc0/0xe0
 [<ffffffff8119f429>] sys_getdents+0x89/0xf0
 [<ffffffff8100bfbb>] ? device_not_available+0x1b/0x20
 [<ffffffff8100b072>] system_call_fastpath+0x16/0x1b
INFO: task ivanserver:6985 blocked for more than 120 seconds.
      Tainted: P           ---------------    2.6.32-424.el6.x86_64 #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
ivanserver      D 0000000000000000     0  6985   6963 0x00000000
 ffff8810103ad9d8 0000000000000082 0000000000000000 000000000000000f
 0000000000000001 ffff8800622143c0 0000000000000001 ffff880062216840
 ffff88100e01e638 ffff8810103adfd8 000000000000fbc8 ffff88100e01e638
Call Trace:
 [<ffffffff815290e5>] schedule_timeout+0x215/0x2e0
 [<ffffffff8152a0e2>] __down+0x72/0xb0
 [<ffffffffa03bcaa5>] ? _xfs_buf_find+0xe5/0x230 [xfs]
 [<ffffffff810a1591>] down+0x41/0x50
 [<ffffffffa03bc911>] xfs_buf_lock+0x51/0x100 [xfs]
 [<ffffffffa03bcaa5>] _xfs_buf_find+0xe5/0x230 [xfs]
 [<ffffffffa03bd266>] ? _xfs_buf_read+0x46/0x60 [xfs]
 [<ffffffffa03bd266>] ? _xfs_buf_read+0x46/0x60 [xfs]
 [<ffffffffa03bcc24>] xfs_buf_get+0x34/0x1b0 [xfs]
 [<ffffffffa03bd2ac>] xfs_buf_read+0x2c/0x100 [xfs]
 [<ffffffffa03b2c37>] xfs_trans_read_buf+0x197/0x410 [xfs]
 [<ffffffffa0385af9>] xfs_da_do_buf+0x279/0x770 [xfs]
 [<ffffffffa03babcf>] ? xfs_buf_lru_add+0x6f/0x80 [xfs]
 [<ffffffffa03b3288>] ? xfs_trans_brelse+0xe8/0x130 [xfs]
 [<ffffffffa038606a>] xfs_da_read_buf+0x2a/0x30 [xfs]
 [<ffffffffa038c9e6>] ? xfs_dir2_leaf_getdents+0x266/0x780 [xfs]
 [<ffffffffa038c9e6>] xfs_dir2_leaf_getdents+0x266/0x780 [xfs]
 [<ffffffff8119f020>] ? filldir+0x0/0xe0
 [<ffffffffa03891e9>] xfs_readdir+0xf9/0x130 [xfs]
 [<ffffffff8119f020>] ? filldir+0x0/0xe0
 [<ffffffff8119f020>] ? filldir+0x0/0xe0
 [<ffffffffa03be619>] xfs_file_readdir+0x39/0x50 [xfs]
 [<ffffffff8119f2a0>] vfs_readdir+0xc0/0xe0
 [<ffffffff8119f429>] sys_getdents+0x89/0xf0
 [<ffffffff8100bfbb>] ? device_not_available+0x1b/0x20
 [<ffffffff8100b072>] system_call_fastpath+0x16/0x1b
INFO: task ivanserver:6989 blocked for more than 120 seconds.
      Tainted: P           ---------------    2.6.32-424.el6.x86_64 #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
ivanserver      D 0000000000000008     0  6989   6981 0x00000000
 ffff8810101279d8 0000000000000086 0000000000000000 000000000000000f
 0000000000000001 ffff8810788143c0 0000000000000001 ffff881078816840
 ffff8810252a4638 ffff881010127fd8 000000000000fbc8 ffff8810252a4638
Call Trace:
 [<ffffffff815290e5>] schedule_timeout+0x215/0x2e0
 [<ffffffff8152a0e2>] __down+0x72/0xb0
 [<ffffffffa03bcaa5>] ? _xfs_buf_find+0xe5/0x230 [xfs]
 [<ffffffff810a1591>] down+0x41/0x50
 [<ffffffffa03bc911>] xfs_buf_lock+0x51/0x100 [xfs]
 [<ffffffffa03bcaa5>] _xfs_buf_find+0xe5/0x230 [xfs]
 [<ffffffffa03bd266>] ? _xfs_buf_read+0x46/0x60 [xfs]
 [<ffffffffa03bd266>] ? _xfs_buf_read+0x46/0x60 [xfs]
 [<ffffffffa03bcc24>] xfs_buf_get+0x34/0x1b0 [xfs]
 [<ffffffffa03bd2ac>] xfs_buf_read+0x2c/0x100 [xfs]
 [<ffffffffa03b2c37>] xfs_trans_read_buf+0x197/0x410 [xfs]
 [<ffffffffa0385af9>] xfs_da_do_buf+0x279/0x770 [xfs]
 [<ffffffffa03babcf>] ? xfs_buf_lru_add+0x6f/0x80 [xfs]
 [<ffffffffa03b3288>] ? xfs_trans_brelse+0xe8/0x130 [xfs]
 [<ffffffffa038606a>] xfs_da_read_buf+0x2a/0x30 [xfs]
 [<ffffffffa038c9e6>] ? xfs_dir2_leaf_getdents+0x266/0x780 [xfs]
 [<ffffffffa038c9e6>] xfs_dir2_leaf_getdents+0x266/0x780 [xfs]
 [<ffffffff8119f020>] ? filldir+0x0/0xe0
 [<ffffffffa03891e9>] xfs_readdir+0xf9/0x130 [xfs]
 [<ffffffff8119f020>] ? filldir+0x0/0xe0
 [<ffffffff8119f020>] ? filldir+0x0/0xe0
 [<ffffffffa03be619>] xfs_file_readdir+0x39/0x50 [xfs]
 [<ffffffff8119f2a0>] vfs_readdir+0xc0/0xe0
 [<ffffffff8119f429>] sys_getdents+0x89/0xf0
 [<ffffffff8100bfbb>] ? device_not_available+0x1b/0x20
 [<ffffffff8100b072>] system_call_fastpath+0x16/0x1b

--bcaec544eeccccc06a04f01bc12c
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hello,<div><br></div><div>I am running a server with heavy=
 workload on a XFS mount:</div><div><span style=3D"font-family:arial,sans-s=
erif;font-size:13.333333969116211px">/dev/mapper/v2-d1 on /d/d1 type xfs (r=
w,nodev,noatime,inode64,</span><span style=3D"font-family:arial,sans-serif;=
font-size:13.333333969116211px">allocsize=3D16m)</span><br>
</div><div><span style=3D"font-family:arial,sans-serif;font-size:13.3333339=
69116211px">2.6.32-424.el6.x86_64 #1 SMP Mon Oct 14 20:11:50 EDT 2013 x86_6=
4 x86_64 x86_64 GNU/Linux</span><span style=3D"font-family:arial,sans-serif=
;font-size:13.333333969116211px"><br>
</span></div><div><span style=3D"font-family:arial,sans-serif;font-size:13.=
333333969116211px"><br></span></div><div><span style=3D"font-family:arial,s=
ans-serif;font-size:13.333333969116211px">We get errors in log indicating p=
rocesses are </span><font face=3D"arial, sans-serif">blocked for more than =
120 seconds.</font></div>
<div><br></div><div>1) Is this expected during heavy workload?</div><div>2)=
 What would be the impact on the processes? =A0Are they basically hung in u=
serspace waiting for IO?</div><div>3) Is there anything we tune here?</div>
<div><br></div><div>Below is the output.</div><div><br></div><div>Cheers,</=
div><div>Ivan Novick</div><div><br></div><div><div><div>INFO: task flush-25=
3:1:6882 blocked for more than 120 seconds.</div><div>=A0 =A0 =A0 Tainted: =
P =A0 =A0 =A0 =A0 =A0 --------------- =A0 =A02.6.32-424.el6.x86_64 #1</div>
<div>&quot;echo 0 &gt; /proc/sys/kernel/hung_task_timeout_secs&quot; disabl=
es this message.</div><div>flush-253:1 =A0 D 0000000000000000 =A0 =A0 0 =A0=
6882 =A0 =A0 =A02 0x00000000</div><div>=A0ffff881011fa5690 0000000000000046=
 0000000000000000 ffff881013cba040</div>
<div>=A00000000000000001 ffff88012a447d40 ffff881013cba040 ffff881016eb4830=
</div><div>=A0ffff881013cba5f8 ffff881011fa5fd8 000000000000fbc8 ffff881013=
cba5f8</div><div>Call Trace:</div><div>=A0[&lt;ffffffff815289d3&gt;] io_sch=
edule+0x73/0xc0</div>
<div>=A0[&lt;ffffffff81267d18&gt;] get_request_wait+0x108/0x1d0</div><div>=
=A0[&lt;ffffffff8109b4a0&gt;] ? autoremove_wake_function+0x0/0x40</div><div=
>=A0[&lt;ffffffff812618ce&gt;] ? elv_merge+0x17e/0x1c0</div><div>=A0[&lt;ff=
ffffff81267e79&gt;] blk_queue_bio+0x99/0x620</div>
<div>=A0[&lt;ffffffff81266f00&gt;] generic_make_request+0x240/0x5a0</div><d=
iv>=A0[&lt;ffffffffa01c3f97&gt;] ? dm_merge_bvec+0xc7/0x100 [dm_mod]</div><=
div>=A0[&lt;ffffffff812672d0&gt;] submit_bio+0x70/0x120</div><div>=A0[&lt;f=
fffffffa03b9c53&gt;] xfs_submit_ioend_bio+0x33/0x40 [xfs]</div>
<div>=A0[&lt;ffffffffa03b9d2c&gt;] xfs_submit_ioend+0xcc/0x140 [xfs]</div><=
div>=A0[&lt;ffffffffa03ba678&gt;] xfs_vm_writepage+0x308/0x590 [xfs]</div><=
div>=A0[&lt;ffffffff81133967&gt;] __writepage+0x17/0x40</div><div>=A0[&lt;f=
fffffff81134c2d&gt;] write_cache_pages+0x1fd/0x4c0</div>
<div>=A0[&lt;ffffffff8100bdae&gt;] ? call_function_single_interrupt+0xe/0x2=
0</div><div>=A0[&lt;ffffffff81133950&gt;] ? __writepage+0x0/0x40</div><div>=
=A0[&lt;ffffffff81134f14&gt;] generic_writepages+0x24/0x30</div><div>=A0[&l=
t;ffffffffa03b98ad&gt;] xfs_vm_writepages+0x5d/0x80 [xfs]</div>
<div>=A0[&lt;ffffffff81134f41&gt;] do_writepages+0x21/0x40</div><div>=A0[&l=
t;ffffffff811b52ad&gt;] writeback_single_inode+0xdd/0x290</div><div>=A0[&lt=
;ffffffff811b56ad&gt;] writeback_sb_inodes+0xbd/0x170</div><div>=A0[&lt;fff=
fffff811b580b&gt;] writeback_inodes_wb+0xab/0x1b0</div>
<div>=A0[&lt;ffffffff811b5c03&gt;] wb_writeback+0x2f3/0x410</div><div>=A0[&=
lt;ffffffff81528240&gt;] ? thread_return+0x4e/0x76e</div><div>=A0[&lt;fffff=
fff81084fb2&gt;] ? del_timer_sync+0x22/0x30</div><div>=A0[&lt;ffffffff811b5=
ec5&gt;] wb_do_writeback+0x1a5/0x240</div>
<div>=A0[&lt;ffffffff811b5fc3&gt;] bdi_writeback_task+0x63/0x1b0</div><div>=
=A0[&lt;ffffffff8109b327&gt;] ? bit_waitqueue+0x17/0xd0</div><div>=A0[&lt;f=
fffffff81143c40&gt;] ? bdi_start_fn+0x0/0x100</div><div>=A0[&lt;ffffffff811=
43cc6&gt;] bdi_start_fn+0x86/0x100</div>
<div>=A0[&lt;ffffffff81143c40&gt;] ? bdi_start_fn+0x0/0x100</div><div>=A0[&=
lt;ffffffff8109b0f6&gt;] kthread+0x96/0xa0</div><div>=A0[&lt;ffffffff8100c2=
0a&gt;] child_rip+0xa/0x20</div><div>=A0[&lt;ffffffff8109b060&gt;] ? kthrea=
d+0x0/0xa0</div>
<div>=A0[&lt;ffffffff8100c200&gt;] ? child_rip+0x0/0x20</div><div>INFO: tas=
k ivanserver:6969 blocked for more than 120 seconds.</div><div>=A0 =A0 =A0 =
Tainted: P =A0 =A0 =A0 =A0 =A0 --------------- =A0 =A02.6.32-424.el6.x86_64=
 #1</div><div>&quot;echo 0 &gt; /proc/sys/kernel/hung_task_timeout_secs&quo=
t; disables this message.</div>
<div>ivanserver =A0 =A0 =A0D 0000000000000000 =A0 =A0 0 =A06969 =A0 6947 0x=
00000000</div><div>=A0ffff881f4ef179d8 0000000000000082 0000000000000000 00=
0000000000000f</div><div>=A00000000000000001 ffff8800622143c0 0000000000000=
001 ffff880062216840</div>
<div>=A0ffff881f4eeae638 ffff881f4ef17fd8 000000000000fbc8 ffff881f4eeae638=
</div><div>Call Trace:</div><div>=A0[&lt;ffffffff815290e5&gt;] schedule_tim=
eout+0x215/0x2e0</div><div>=A0[&lt;ffffffff8152a0e2&gt;] __down+0x72/0xb0</=
div>
<div>=A0[&lt;ffffffffa03bcaa5&gt;] ? _xfs_buf_find+0xe5/0x230 [xfs]</div><d=
iv>=A0[&lt;ffffffff810a1591&gt;] down+0x41/0x50</div><div>=A0[&lt;ffffffffa=
03bc911&gt;] xfs_buf_lock+0x51/0x100 [xfs]</div><div>=A0[&lt;ffffffffa03bca=
a5&gt;] _xfs_buf_find+0xe5/0x230 [xfs]</div>
<div>=A0[&lt;ffffffffa03bd266&gt;] ? _xfs_buf_read+0x46/0x60 [xfs]</div><di=
v>=A0[&lt;ffffffffa03bd266&gt;] ? _xfs_buf_read+0x46/0x60 [xfs]</div><div>=
=A0[&lt;ffffffffa03bcc24&gt;] xfs_buf_get+0x34/0x1b0 [xfs]</div><div>=A0[&l=
t;ffffffffa03bd2ac&gt;] xfs_buf_read+0x2c/0x100 [xfs]</div>
<div>=A0[&lt;ffffffffa03b2c37&gt;] xfs_trans_read_buf+0x197/0x410 [xfs]</di=
v><div>=A0[&lt;ffffffffa0385af9&gt;] xfs_da_do_buf+0x279/0x770 [xfs]</div><=
div>=A0[&lt;ffffffffa03babcf&gt;] ? xfs_buf_lru_add+0x6f/0x80 [xfs]</div><d=
iv>
=A0[&lt;ffffffffa03b3288&gt;] ? xfs_trans_brelse+0xe8/0x130 [xfs]</div><div=
>=A0[&lt;ffffffffa038606a&gt;] xfs_da_read_buf+0x2a/0x30 [xfs]</div><div>=
=A0[&lt;ffffffffa038c9e6&gt;] ? xfs_dir2_leaf_getdents+0x266/0x780 [xfs]</d=
iv><div>
=A0[&lt;ffffffffa038c9e6&gt;] xfs_dir2_leaf_getdents+0x266/0x780 [xfs]</div=
><div>=A0[&lt;ffffffff8119f020&gt;] ? filldir+0x0/0xe0</div><div>=A0[&lt;ff=
ffffffa03891e9&gt;] xfs_readdir+0xf9/0x130 [xfs]</div><div>=A0[&lt;ffffffff=
8119f020&gt;] ? filldir+0x0/0xe0</div>
<div>=A0[&lt;ffffffff8100bdae&gt;] ? call_function_single_interrupt+0xe/0x2=
0</div><div>=A0[&lt;ffffffff8119f020&gt;] ? filldir+0x0/0xe0</div><div>=A0[=
&lt;ffffffffa03be619&gt;] xfs_file_readdir+0x39/0x50 [xfs]</div><div>=A0[&l=
t;ffffffff8119f2a0&gt;] vfs_readdir+0xc0/0xe0</div>
<div>=A0[&lt;ffffffff8118a5b0&gt;] ? fget+0x30/0x80</div><div>=A0[&lt;fffff=
fff8119f429&gt;] sys_getdents+0x89/0xf0</div><div>=A0[&lt;ffffffff8100bfbb&=
gt;] ? device_not_available+0x1b/0x20</div><div>=A0[&lt;ffffffff8100b072&gt=
;] system_call_fastpath+0x16/0x1b</div>
<div>INFO: task ivanserver:6972 blocked for more than 120 seconds.</div><di=
v>=A0 =A0 =A0 Tainted: P =A0 =A0 =A0 =A0 =A0 --------------- =A0 =A02.6.32-=
424.el6.x86_64 #1</div><div>&quot;echo 0 &gt; /proc/sys/kernel/hung_task_ti=
meout_secs&quot; disables this message.</div>
<div>ivanserver =A0 =A0 =A0D 0000000000000008 =A0 =A0 0 =A06972 =A0 6948 0x=
00000000</div><div>=A0ffff88100f1219d8 0000000000000086 0000000000000000 00=
0000000000000f</div><div>=A00000000000000001 ffff8810788143c0 0000000000000=
001 ffff881078816840</div>
<div>=A0ffff88100fd62638 ffff88100f121fd8 000000000000fbc8 ffff88100fd62638=
</div><div>Call Trace:</div><div>=A0[&lt;ffffffff815290e5&gt;] schedule_tim=
eout+0x215/0x2e0</div><div>=A0[&lt;ffffffff8152a0e2&gt;] __down+0x72/0xb0</=
div>
<div>=A0[&lt;ffffffffa03bcaa5&gt;] ? _xfs_buf_find+0xe5/0x230 [xfs]</div><d=
iv>=A0[&lt;ffffffff810a1591&gt;] down+0x41/0x50</div><div>=A0[&lt;ffffffffa=
03bc911&gt;] xfs_buf_lock+0x51/0x100 [xfs]</div><div>=A0[&lt;ffffffffa03bca=
a5&gt;] _xfs_buf_find+0xe5/0x230 [xfs]</div>
<div>=A0[&lt;ffffffffa03bd266&gt;] ? _xfs_buf_read+0x46/0x60 [xfs]</div><di=
v>=A0[&lt;ffffffffa03bd266&gt;] ? _xfs_buf_read+0x46/0x60 [xfs]</div><div>=
=A0[&lt;ffffffffa03bcc24&gt;] xfs_buf_get+0x34/0x1b0 [xfs]</div><div>=A0[&l=
t;ffffffffa03bd2ac&gt;] xfs_buf_read+0x2c/0x100 [xfs]</div>
<div>=A0[&lt;ffffffffa03b2c37&gt;] xfs_trans_read_buf+0x197/0x410 [xfs]</di=
v><div>=A0[&lt;ffffffffa0385af9&gt;] xfs_da_do_buf+0x279/0x770 [xfs]</div><=
div>=A0[&lt;ffffffffa03babcf&gt;] ? xfs_buf_lru_add+0x6f/0x80 [xfs]</div><d=
iv>
=A0[&lt;ffffffffa03b3288&gt;] ? xfs_trans_brelse+0xe8/0x130 [xfs]</div><div=
>=A0[&lt;ffffffffa038606a&gt;] xfs_da_read_buf+0x2a/0x30 [xfs]</div><div>=
=A0[&lt;ffffffffa038c9e6&gt;] ? xfs_dir2_leaf_getdents+0x266/0x780 [xfs]</d=
iv><div>
=A0[&lt;ffffffffa038c9e6&gt;] xfs_dir2_leaf_getdents+0x266/0x780 [xfs]</div=
><div>=A0[&lt;ffffffff8119f020&gt;] ? filldir+0x0/0xe0</div><div>=A0[&lt;ff=
ffffffa03891e9&gt;] xfs_readdir+0xf9/0x130 [xfs]</div><div>=A0[&lt;ffffffff=
8119f020&gt;] ? filldir+0x0/0xe0</div>
<div>=A0[&lt;ffffffff8119f020&gt;] ? filldir+0x0/0xe0</div><div>=A0[&lt;fff=
fffffa03be619&gt;] xfs_file_readdir+0x39/0x50 [xfs]</div><div>=A0[&lt;fffff=
fff8119f2a0&gt;] vfs_readdir+0xc0/0xe0</div><div>=A0[&lt;ffffffff8119f429&g=
t;] sys_getdents+0x89/0xf0</div>
<div>=A0[&lt;ffffffff8100bfbb&gt;] ? device_not_available+0x1b/0x20</div><d=
iv>=A0[&lt;ffffffff8100b072&gt;] system_call_fastpath+0x16/0x1b</div><div>I=
NFO: task ivanserver:6985 blocked for more than 120 seconds.</div><div>=A0 =
=A0 =A0 Tainted: P =A0 =A0 =A0 =A0 =A0 --------------- =A0 =A02.6.32-424.el=
6.x86_64 #1</div>
<div>&quot;echo 0 &gt; /proc/sys/kernel/hung_task_timeout_secs&quot; disabl=
es this message.</div><div>ivanserver =A0 =A0 =A0D 0000000000000000 =A0 =A0=
 0 =A06985 =A0 6963 0x00000000</div><div>=A0ffff8810103ad9d8 00000000000000=
82 0000000000000000 000000000000000f</div>
<div>=A00000000000000001 ffff8800622143c0 0000000000000001 ffff880062216840=
</div><div>=A0ffff88100e01e638 ffff8810103adfd8 000000000000fbc8 ffff88100e=
01e638</div><div>Call Trace:</div><div>=A0[&lt;ffffffff815290e5&gt;] schedu=
le_timeout+0x215/0x2e0</div>
<div>=A0[&lt;ffffffff8152a0e2&gt;] __down+0x72/0xb0</div><div>=A0[&lt;fffff=
fffa03bcaa5&gt;] ? _xfs_buf_find+0xe5/0x230 [xfs]</div><div>=A0[&lt;fffffff=
f810a1591&gt;] down+0x41/0x50</div><div>=A0[&lt;ffffffffa03bc911&gt;] xfs_b=
uf_lock+0x51/0x100 [xfs]</div>
<div>=A0[&lt;ffffffffa03bcaa5&gt;] _xfs_buf_find+0xe5/0x230 [xfs]</div><div=
>=A0[&lt;ffffffffa03bd266&gt;] ? _xfs_buf_read+0x46/0x60 [xfs]</div><div>=
=A0[&lt;ffffffffa03bd266&gt;] ? _xfs_buf_read+0x46/0x60 [xfs]</div><div>=A0=
[&lt;ffffffffa03bcc24&gt;] xfs_buf_get+0x34/0x1b0 [xfs]</div>
<div>=A0[&lt;ffffffffa03bd2ac&gt;] xfs_buf_read+0x2c/0x100 [xfs]</div><div>=
=A0[&lt;ffffffffa03b2c37&gt;] xfs_trans_read_buf+0x197/0x410 [xfs]</div><di=
v>=A0[&lt;ffffffffa0385af9&gt;] xfs_da_do_buf+0x279/0x770 [xfs]</div><div>=
=A0[&lt;ffffffffa03babcf&gt;] ? xfs_buf_lru_add+0x6f/0x80 [xfs]</div>
<div>=A0[&lt;ffffffffa03b3288&gt;] ? xfs_trans_brelse+0xe8/0x130 [xfs]</div=
><div>=A0[&lt;ffffffffa038606a&gt;] xfs_da_read_buf+0x2a/0x30 [xfs]</div><d=
iv>=A0[&lt;ffffffffa038c9e6&gt;] ? xfs_dir2_leaf_getdents+0x266/0x780 [xfs]=
</div>
<div>=A0[&lt;ffffffffa038c9e6&gt;] xfs_dir2_leaf_getdents+0x266/0x780 [xfs]=
</div><div>=A0[&lt;ffffffff8119f020&gt;] ? filldir+0x0/0xe0</div><div>=A0[&=
lt;ffffffffa03891e9&gt;] xfs_readdir+0xf9/0x130 [xfs]</div><div>=A0[&lt;fff=
fffff8119f020&gt;] ? filldir+0x0/0xe0</div>
<div>=A0[&lt;ffffffff8119f020&gt;] ? filldir+0x0/0xe0</div><div>=A0[&lt;fff=
fffffa03be619&gt;] xfs_file_readdir+0x39/0x50 [xfs]</div><div>=A0[&lt;fffff=
fff8119f2a0&gt;] vfs_readdir+0xc0/0xe0</div><div>=A0[&lt;ffffffff8119f429&g=
t;] sys_getdents+0x89/0xf0</div>
<div>=A0[&lt;ffffffff8100bfbb&gt;] ? device_not_available+0x1b/0x20</div><d=
iv>=A0[&lt;ffffffff8100b072&gt;] system_call_fastpath+0x16/0x1b</div><div>I=
NFO: task ivanserver:6989 blocked for more than 120 seconds.</div><div>=A0 =
=A0 =A0 Tainted: P =A0 =A0 =A0 =A0 =A0 --------------- =A0 =A02.6.32-424.el=
6.x86_64 #1</div>
<div>&quot;echo 0 &gt; /proc/sys/kernel/hung_task_timeout_secs&quot; disabl=
es this message.</div><div>ivanserver =A0 =A0 =A0D 0000000000000008 =A0 =A0=
 0 =A06989 =A0 6981 0x00000000</div><div>=A0ffff8810101279d8 00000000000000=
86 0000000000000000 000000000000000f</div>
<div>=A00000000000000001 ffff8810788143c0 0000000000000001 ffff881078816840=
</div><div>=A0ffff8810252a4638 ffff881010127fd8 000000000000fbc8 ffff881025=
2a4638</div><div>Call Trace:</div><div>=A0[&lt;ffffffff815290e5&gt;] schedu=
le_timeout+0x215/0x2e0</div>
<div>=A0[&lt;ffffffff8152a0e2&gt;] __down+0x72/0xb0</div><div>=A0[&lt;fffff=
fffa03bcaa5&gt;] ? _xfs_buf_find+0xe5/0x230 [xfs]</div><div>=A0[&lt;fffffff=
f810a1591&gt;] down+0x41/0x50</div><div>=A0[&lt;ffffffffa03bc911&gt;] xfs_b=
uf_lock+0x51/0x100 [xfs]</div>
<div>=A0[&lt;ffffffffa03bcaa5&gt;] _xfs_buf_find+0xe5/0x230 [xfs]</div><div=
>=A0[&lt;ffffffffa03bd266&gt;] ? _xfs_buf_read+0x46/0x60 [xfs]</div><div>=
=A0[&lt;ffffffffa03bd266&gt;] ? _xfs_buf_read+0x46/0x60 [xfs]</div><div>=A0=
[&lt;ffffffffa03bcc24&gt;] xfs_buf_get+0x34/0x1b0 [xfs]</div>
<div>=A0[&lt;ffffffffa03bd2ac&gt;] xfs_buf_read+0x2c/0x100 [xfs]</div><div>=
=A0[&lt;ffffffffa03b2c37&gt;] xfs_trans_read_buf+0x197/0x410 [xfs]</div><di=
v>=A0[&lt;ffffffffa0385af9&gt;] xfs_da_do_buf+0x279/0x770 [xfs]</div><div>=
=A0[&lt;ffffffffa03babcf&gt;] ? xfs_buf_lru_add+0x6f/0x80 [xfs]</div>
<div>=A0[&lt;ffffffffa03b3288&gt;] ? xfs_trans_brelse+0xe8/0x130 [xfs]</div=
><div>=A0[&lt;ffffffffa038606a&gt;] xfs_da_read_buf+0x2a/0x30 [xfs]</div><d=
iv>=A0[&lt;ffffffffa038c9e6&gt;] ? xfs_dir2_leaf_getdents+0x266/0x780 [xfs]=
</div>
<div>=A0[&lt;ffffffffa038c9e6&gt;] xfs_dir2_leaf_getdents+0x266/0x780 [xfs]=
</div><div>=A0[&lt;ffffffff8119f020&gt;] ? filldir+0x0/0xe0</div><div>=A0[&=
lt;ffffffffa03891e9&gt;] xfs_readdir+0xf9/0x130 [xfs]</div><div>=A0[&lt;fff=
fffff8119f020&gt;] ? filldir+0x0/0xe0</div>
<div>=A0[&lt;ffffffff8119f020&gt;] ? filldir+0x0/0xe0</div><div>=A0[&lt;fff=
fffffa03be619&gt;] xfs_file_readdir+0x39/0x50 [xfs]</div><div>=A0[&lt;fffff=
fff8119f2a0&gt;] vfs_readdir+0xc0/0xe0</div><div>=A0[&lt;ffffffff8119f429&g=
t;] sys_getdents+0x89/0xf0</div>
<div>=A0[&lt;ffffffff8100bfbb&gt;] ? device_not_available+0x1b/0x20</div><d=
iv>=A0[&lt;ffffffff8100b072&gt;] system_call_fastpath+0x16/0x1b</div><div>u=
sxxnovicim1:Downloads novici$ cat dmesg.txt=A0</div><div>INFO: task flush-2=
53:1:6882 blocked for more than 120 seconds.</div>
<div>=A0 =A0 =A0 Tainted: P =A0 =A0 =A0 =A0 =A0 --------------- =A0 =A02.6.=
32-424.el6.x86_64 #1</div><div>&quot;echo 0 &gt; /proc/sys/kernel/hung_task=
_timeout_secs&quot; disables this message.</div><div>flush-253:1 =A0 D 0000=
000000000000 =A0 =A0 0 =A06882 =A0 =A0 =A02 0x00000000</div>
<div>=A0ffff881011fa5690 0000000000000046 0000000000000000 ffff881013cba040=
</div><div>=A00000000000000001 ffff88012a447d40 ffff881013cba040 ffff881016=
eb4830</div><div>=A0ffff881013cba5f8 ffff881011fa5fd8 000000000000fbc8 ffff=
881013cba5f8</div>
<div>Call Trace:</div><div>=A0[&lt;ffffffff815289d3&gt;] io_schedule+0x73/0=
xc0</div><div>=A0[&lt;ffffffff81267d18&gt;] get_request_wait+0x108/0x1d0</d=
iv><div>=A0[&lt;ffffffff8109b4a0&gt;] ? autoremove_wake_function+0x0/0x40</=
div>
<div>=A0[&lt;ffffffff812618ce&gt;] ? elv_merge+0x17e/0x1c0</div><div>=A0[&l=
t;ffffffff81267e79&gt;] blk_queue_bio+0x99/0x620</div><div>=A0[&lt;ffffffff=
81266f00&gt;] generic_make_request+0x240/0x5a0</div><div>=A0[&lt;ffffffffa0=
1c3f97&gt;] ? dm_merge_bvec+0xc7/0x100 [dm_mod]</div>
<div>=A0[&lt;ffffffff812672d0&gt;] submit_bio+0x70/0x120</div><div>=A0[&lt;=
ffffffffa03b9c53&gt;] xfs_submit_ioend_bio+0x33/0x40 [xfs]</div><div>=A0[&l=
t;ffffffffa03b9d2c&gt;] xfs_submit_ioend+0xcc/0x140 [xfs]</div><div>=A0[&lt=
;ffffffffa03ba678&gt;] xfs_vm_writepage+0x308/0x590 [xfs]</div>
<div>=A0[&lt;ffffffff81133967&gt;] __writepage+0x17/0x40</div><div>=A0[&lt;=
ffffffff81134c2d&gt;] write_cache_pages+0x1fd/0x4c0</div><div>=A0[&lt;fffff=
fff8100bdae&gt;] ? call_function_single_interrupt+0xe/0x20</div><div>=A0[&l=
t;ffffffff81133950&gt;] ? __writepage+0x0/0x40</div>
<div>=A0[&lt;ffffffff81134f14&gt;] generic_writepages+0x24/0x30</div><div>=
=A0[&lt;ffffffffa03b98ad&gt;] xfs_vm_writepages+0x5d/0x80 [xfs]</div><div>=
=A0[&lt;ffffffff81134f41&gt;] do_writepages+0x21/0x40</div><div>=A0[&lt;fff=
fffff811b52ad&gt;] writeback_single_inode+0xdd/0x290</div>
<div>=A0[&lt;ffffffff811b56ad&gt;] writeback_sb_inodes+0xbd/0x170</div><div=
>=A0[&lt;ffffffff811b580b&gt;] writeback_inodes_wb+0xab/0x1b0</div><div>=A0=
[&lt;ffffffff811b5c03&gt;] wb_writeback+0x2f3/0x410</div><div>=A0[&lt;fffff=
fff81528240&gt;] ? thread_return+0x4e/0x76e</div>
<div>=A0[&lt;ffffffff81084fb2&gt;] ? del_timer_sync+0x22/0x30</div><div>=A0=
[&lt;ffffffff811b5ec5&gt;] wb_do_writeback+0x1a5/0x240</div><div>=A0[&lt;ff=
ffffff811b5fc3&gt;] bdi_writeback_task+0x63/0x1b0</div><div>=A0[&lt;fffffff=
f8109b327&gt;] ? bit_waitqueue+0x17/0xd0</div>
<div>=A0[&lt;ffffffff81143c40&gt;] ? bdi_start_fn+0x0/0x100</div><div>=A0[&=
lt;ffffffff81143cc6&gt;] bdi_start_fn+0x86/0x100</div><div>=A0[&lt;ffffffff=
81143c40&gt;] ? bdi_start_fn+0x0/0x100</div><div>=A0[&lt;ffffffff8109b0f6&g=
t;] kthread+0x96/0xa0</div>
<div>=A0[&lt;ffffffff8100c20a&gt;] child_rip+0xa/0x20</div><div>=A0[&lt;fff=
fffff8109b060&gt;] ? kthread+0x0/0xa0</div><div>=A0[&lt;ffffffff8100c200&gt=
;] ? child_rip+0x0/0x20</div><div>INFO: task ivanserver:6969 blocked for mo=
re than 120 seconds.</div>
<div>=A0 =A0 =A0 Tainted: P =A0 =A0 =A0 =A0 =A0 --------------- =A0 =A02.6.=
32-424.el6.x86_64 #1</div><div>&quot;echo 0 &gt; /proc/sys/kernel/hung_task=
_timeout_secs&quot; disables this message.</div><div>ivanserver =A0 =A0 =A0=
D 0000000000000000 =A0 =A0 0 =A06969 =A0 6947 0x00000000</div>
<div>=A0ffff881f4ef179d8 0000000000000082 0000000000000000 000000000000000f=
</div><div>=A00000000000000001 ffff8800622143c0 0000000000000001 ffff880062=
216840</div><div>=A0ffff881f4eeae638 ffff881f4ef17fd8 000000000000fbc8 ffff=
881f4eeae638</div>
<div>Call Trace:</div><div>=A0[&lt;ffffffff815290e5&gt;] schedule_timeout+0=
x215/0x2e0</div><div>=A0[&lt;ffffffff8152a0e2&gt;] __down+0x72/0xb0</div><d=
iv>=A0[&lt;ffffffffa03bcaa5&gt;] ? _xfs_buf_find+0xe5/0x230 [xfs]</div><div=
>=A0[&lt;ffffffff810a1591&gt;] down+0x41/0x50</div>
<div>=A0[&lt;ffffffffa03bc911&gt;] xfs_buf_lock+0x51/0x100 [xfs]</div><div>=
=A0[&lt;ffffffffa03bcaa5&gt;] _xfs_buf_find+0xe5/0x230 [xfs]</div><div>=A0[=
&lt;ffffffffa03bd266&gt;] ? _xfs_buf_read+0x46/0x60 [xfs]</div><div>=A0[&lt=
;ffffffffa03bd266&gt;] ? _xfs_buf_read+0x46/0x60 [xfs]</div>
<div>=A0[&lt;ffffffffa03bcc24&gt;] xfs_buf_get+0x34/0x1b0 [xfs]</div><div>=
=A0[&lt;ffffffffa03bd2ac&gt;] xfs_buf_read+0x2c/0x100 [xfs]</div><div>=A0[&=
lt;ffffffffa03b2c37&gt;] xfs_trans_read_buf+0x197/0x410 [xfs]</div><div>=A0=
[&lt;ffffffffa0385af9&gt;] xfs_da_do_buf+0x279/0x770 [xfs]</div>
<div>=A0[&lt;ffffffffa03babcf&gt;] ? xfs_buf_lru_add+0x6f/0x80 [xfs]</div><=
div>=A0[&lt;ffffffffa03b3288&gt;] ? xfs_trans_brelse+0xe8/0x130 [xfs]</div>=
<div>=A0[&lt;ffffffffa038606a&gt;] xfs_da_read_buf+0x2a/0x30 [xfs]</div><di=
v>
=A0[&lt;ffffffffa038c9e6&gt;] ? xfs_dir2_leaf_getdents+0x266/0x780 [xfs]</d=
iv><div>=A0[&lt;ffffffffa038c9e6&gt;] xfs_dir2_leaf_getdents+0x266/0x780 [x=
fs]</div><div>=A0[&lt;ffffffff8119f020&gt;] ? filldir+0x0/0xe0</div><div>=
=A0[&lt;ffffffffa03891e9&gt;] xfs_readdir+0xf9/0x130 [xfs]</div>
<div>=A0[&lt;ffffffff8119f020&gt;] ? filldir+0x0/0xe0</div><div>=A0[&lt;fff=
fffff8100bdae&gt;] ? call_function_single_interrupt+0xe/0x20</div><div>=A0[=
&lt;ffffffff8119f020&gt;] ? filldir+0x0/0xe0</div><div>=A0[&lt;ffffffffa03b=
e619&gt;] xfs_file_readdir+0x39/0x50 [xfs]</div>
<div>=A0[&lt;ffffffff8119f2a0&gt;] vfs_readdir+0xc0/0xe0</div><div>=A0[&lt;=
ffffffff8118a5b0&gt;] ? fget+0x30/0x80</div><div>=A0[&lt;ffffffff8119f429&g=
t;] sys_getdents+0x89/0xf0</div><div>=A0[&lt;ffffffff8100bfbb&gt;] ? device=
_not_available+0x1b/0x20</div>
<div>=A0[&lt;ffffffff8100b072&gt;] system_call_fastpath+0x16/0x1b</div><div=
>INFO: task ivanserver:6972 blocked for more than 120 seconds.</div><div>=
=A0 =A0 =A0 Tainted: P =A0 =A0 =A0 =A0 =A0 --------------- =A0 =A02.6.32-42=
4.el6.x86_64 #1</div>
<div>&quot;echo 0 &gt; /proc/sys/kernel/hung_task_timeout_secs&quot; disabl=
es this message.</div><div>ivanserver =A0 =A0 =A0D 0000000000000008 =A0 =A0=
 0 =A06972 =A0 6948 0x00000000</div><div>=A0ffff88100f1219d8 00000000000000=
86 0000000000000000 000000000000000f</div>
<div>=A00000000000000001 ffff8810788143c0 0000000000000001 ffff881078816840=
</div><div>=A0ffff88100fd62638 ffff88100f121fd8 000000000000fbc8 ffff88100f=
d62638</div><div>Call Trace:</div><div>=A0[&lt;ffffffff815290e5&gt;] schedu=
le_timeout+0x215/0x2e0</div>
<div>=A0[&lt;ffffffff8152a0e2&gt;] __down+0x72/0xb0</div><div>=A0[&lt;fffff=
fffa03bcaa5&gt;] ? _xfs_buf_find+0xe5/0x230 [xfs]</div><div>=A0[&lt;fffffff=
f810a1591&gt;] down+0x41/0x50</div><div>=A0[&lt;ffffffffa03bc911&gt;] xfs_b=
uf_lock+0x51/0x100 [xfs]</div>
<div>=A0[&lt;ffffffffa03bcaa5&gt;] _xfs_buf_find+0xe5/0x230 [xfs]</div><div=
>=A0[&lt;ffffffffa03bd266&gt;] ? _xfs_buf_read+0x46/0x60 [xfs]</div><div>=
=A0[&lt;ffffffffa03bd266&gt;] ? _xfs_buf_read+0x46/0x60 [xfs]</div><div>=A0=
[&lt;ffffffffa03bcc24&gt;] xfs_buf_get+0x34/0x1b0 [xfs]</div>
<div>=A0[&lt;ffffffffa03bd2ac&gt;] xfs_buf_read+0x2c/0x100 [xfs]</div><div>=
=A0[&lt;ffffffffa03b2c37&gt;] xfs_trans_read_buf+0x197/0x410 [xfs]</div><di=
v>=A0[&lt;ffffffffa0385af9&gt;] xfs_da_do_buf+0x279/0x770 [xfs]</div><div>=
=A0[&lt;ffffffffa03babcf&gt;] ? xfs_buf_lru_add+0x6f/0x80 [xfs]</div>
<div>=A0[&lt;ffffffffa03b3288&gt;] ? xfs_trans_brelse+0xe8/0x130 [xfs]</div=
><div>=A0[&lt;ffffffffa038606a&gt;] xfs_da_read_buf+0x2a/0x30 [xfs]</div><d=
iv>=A0[&lt;ffffffffa038c9e6&gt;] ? xfs_dir2_leaf_getdents+0x266/0x780 [xfs]=
</div>
<div>=A0[&lt;ffffffffa038c9e6&gt;] xfs_dir2_leaf_getdents+0x266/0x780 [xfs]=
</div><div>=A0[&lt;ffffffff8119f020&gt;] ? filldir+0x0/0xe0</div><div>=A0[&=
lt;ffffffffa03891e9&gt;] xfs_readdir+0xf9/0x130 [xfs]</div><div>=A0[&lt;fff=
fffff8119f020&gt;] ? filldir+0x0/0xe0</div>
<div>=A0[&lt;ffffffff8119f020&gt;] ? filldir+0x0/0xe0</div><div>=A0[&lt;fff=
fffffa03be619&gt;] xfs_file_readdir+0x39/0x50 [xfs]</div><div>=A0[&lt;fffff=
fff8119f2a0&gt;] vfs_readdir+0xc0/0xe0</div><div>=A0[&lt;ffffffff8119f429&g=
t;] sys_getdents+0x89/0xf0</div>
<div>=A0[&lt;ffffffff8100bfbb&gt;] ? device_not_available+0x1b/0x20</div><d=
iv>=A0[&lt;ffffffff8100b072&gt;] system_call_fastpath+0x16/0x1b</div><div>I=
NFO: task ivanserver:6985 blocked for more than 120 seconds.</div><div>=A0 =
=A0 =A0 Tainted: P =A0 =A0 =A0 =A0 =A0 --------------- =A0 =A02.6.32-424.el=
6.x86_64 #1</div>
<div>&quot;echo 0 &gt; /proc/sys/kernel/hung_task_timeout_secs&quot; disabl=
es this message.</div><div>ivanserver =A0 =A0 =A0D 0000000000000000 =A0 =A0=
 0 =A06985 =A0 6963 0x00000000</div><div>=A0ffff8810103ad9d8 00000000000000=
82 0000000000000000 000000000000000f</div>
<div>=A00000000000000001 ffff8800622143c0 0000000000000001 ffff880062216840=
</div><div>=A0ffff88100e01e638 ffff8810103adfd8 000000000000fbc8 ffff88100e=
01e638</div><div>Call Trace:</div><div>=A0[&lt;ffffffff815290e5&gt;] schedu=
le_timeout+0x215/0x2e0</div>
<div>=A0[&lt;ffffffff8152a0e2&gt;] __down+0x72/0xb0</div><div>=A0[&lt;fffff=
fffa03bcaa5&gt;] ? _xfs_buf_find+0xe5/0x230 [xfs]</div><div>=A0[&lt;fffffff=
f810a1591&gt;] down+0x41/0x50</div><div>=A0[&lt;ffffffffa03bc911&gt;] xfs_b=
uf_lock+0x51/0x100 [xfs]</div>
<div>=A0[&lt;ffffffffa03bcaa5&gt;] _xfs_buf_find+0xe5/0x230 [xfs]</div><div=
>=A0[&lt;ffffffffa03bd266&gt;] ? _xfs_buf_read+0x46/0x60 [xfs]</div><div>=
=A0[&lt;ffffffffa03bd266&gt;] ? _xfs_buf_read+0x46/0x60 [xfs]</div><div>=A0=
[&lt;ffffffffa03bcc24&gt;] xfs_buf_get+0x34/0x1b0 [xfs]</div>
<div>=A0[&lt;ffffffffa03bd2ac&gt;] xfs_buf_read+0x2c/0x100 [xfs]</div><div>=
=A0[&lt;ffffffffa03b2c37&gt;] xfs_trans_read_buf+0x197/0x410 [xfs]</div><di=
v>=A0[&lt;ffffffffa0385af9&gt;] xfs_da_do_buf+0x279/0x770 [xfs]</div><div>=
=A0[&lt;ffffffffa03babcf&gt;] ? xfs_buf_lru_add+0x6f/0x80 [xfs]</div>
<div>=A0[&lt;ffffffffa03b3288&gt;] ? xfs_trans_brelse+0xe8/0x130 [xfs]</div=
><div>=A0[&lt;ffffffffa038606a&gt;] xfs_da_read_buf+0x2a/0x30 [xfs]</div><d=
iv>=A0[&lt;ffffffffa038c9e6&gt;] ? xfs_dir2_leaf_getdents+0x266/0x780 [xfs]=
</div>
<div>=A0[&lt;ffffffffa038c9e6&gt;] xfs_dir2_leaf_getdents+0x266/0x780 [xfs]=
</div><div>=A0[&lt;ffffffff8119f020&gt;] ? filldir+0x0/0xe0</div><div>=A0[&=
lt;ffffffffa03891e9&gt;] xfs_readdir+0xf9/0x130 [xfs]</div><div>=A0[&lt;fff=
fffff8119f020&gt;] ? filldir+0x0/0xe0</div>
<div>=A0[&lt;ffffffff8119f020&gt;] ? filldir+0x0/0xe0</div><div>=A0[&lt;fff=
fffffa03be619&gt;] xfs_file_readdir+0x39/0x50 [xfs]</div><div>=A0[&lt;fffff=
fff8119f2a0&gt;] vfs_readdir+0xc0/0xe0</div><div>=A0[&lt;ffffffff8119f429&g=
t;] sys_getdents+0x89/0xf0</div>
<div>=A0[&lt;ffffffff8100bfbb&gt;] ? device_not_available+0x1b/0x20</div><d=
iv>=A0[&lt;ffffffff8100b072&gt;] system_call_fastpath+0x16/0x1b</div><div>I=
NFO: task ivanserver:6989 blocked for more than 120 seconds.</div><div>=A0 =
=A0 =A0 Tainted: P =A0 =A0 =A0 =A0 =A0 --------------- =A0 =A02.6.32-424.el=
6.x86_64 #1</div>
<div>&quot;echo 0 &gt; /proc/sys/kernel/hung_task_timeout_secs&quot; disabl=
es this message.</div><div>ivanserver =A0 =A0 =A0D 0000000000000008 =A0 =A0=
 0 =A06989 =A0 6981 0x00000000</div><div>=A0ffff8810101279d8 00000000000000=
86 0000000000000000 000000000000000f</div>
<div>=A00000000000000001 ffff8810788143c0 0000000000000001 ffff881078816840=
</div><div>=A0ffff8810252a4638 ffff881010127fd8 000000000000fbc8 ffff881025=
2a4638</div><div>Call Trace:</div><div>=A0[&lt;ffffffff815290e5&gt;] schedu=
le_timeout+0x215/0x2e0</div>
<div>=A0[&lt;ffffffff8152a0e2&gt;] __down+0x72/0xb0</div><div>=A0[&lt;fffff=
fffa03bcaa5&gt;] ? _xfs_buf_find+0xe5/0x230 [xfs]</div><div>=A0[&lt;fffffff=
f810a1591&gt;] down+0x41/0x50</div><div>=A0[&lt;ffffffffa03bc911&gt;] xfs_b=
uf_lock+0x51/0x100 [xfs]</div>
<div>=A0[&lt;ffffffffa03bcaa5&gt;] _xfs_buf_find+0xe5/0x230 [xfs]</div><div=
>=A0[&lt;ffffffffa03bd266&gt;] ? _xfs_buf_read+0x46/0x60 [xfs]</div><div>=
=A0[&lt;ffffffffa03bd266&gt;] ? _xfs_buf_read+0x46/0x60 [xfs]</div><div>=A0=
[&lt;ffffffffa03bcc24&gt;] xfs_buf_get+0x34/0x1b0 [xfs]</div>
<div>=A0[&lt;ffffffffa03bd2ac&gt;] xfs_buf_read+0x2c/0x100 [xfs]</div><div>=
=A0[&lt;ffffffffa03b2c37&gt;] xfs_trans_read_buf+0x197/0x410 [xfs]</div><di=
v>=A0[&lt;ffffffffa0385af9&gt;] xfs_da_do_buf+0x279/0x770 [xfs]</div><div>=
=A0[&lt;ffffffffa03babcf&gt;] ? xfs_buf_lru_add+0x6f/0x80 [xfs]</div>
<div>=A0[&lt;ffffffffa03b3288&gt;] ? xfs_trans_brelse+0xe8/0x130 [xfs]</div=
><div>=A0[&lt;ffffffffa038606a&gt;] xfs_da_read_buf+0x2a/0x30 [xfs]</div><d=
iv>=A0[&lt;ffffffffa038c9e6&gt;] ? xfs_dir2_leaf_getdents+0x266/0x780 [xfs]=
</div>
<div>=A0[&lt;ffffffffa038c9e6&gt;] xfs_dir2_leaf_getdents+0x266/0x780 [xfs]=
</div><div>=A0[&lt;ffffffff8119f020&gt;] ? filldir+0x0/0xe0</div><div>=A0[&=
lt;ffffffffa03891e9&gt;] xfs_readdir+0xf9/0x130 [xfs]</div><div>=A0[&lt;fff=
fffff8119f020&gt;] ? filldir+0x0/0xe0</div>
<div>=A0[&lt;ffffffff8119f020&gt;] ? filldir+0x0/0xe0</div><div>=A0[&lt;fff=
fffffa03be619&gt;] xfs_file_readdir+0x39/0x50 [xfs]</div><div>=A0[&lt;fffff=
fff8119f2a0&gt;] vfs_readdir+0xc0/0xe0</div><div>=A0[&lt;ffffffff8119f429&g=
t;] sys_getdents+0x89/0xf0</div>
<div>=A0[&lt;ffffffff8100bfbb&gt;] ? device_not_available+0x1b/0x20</div><d=
iv>=A0[&lt;ffffffff8100b072&gt;] system_call_fastpath+0x16/0x1b</div></div>=
</div></div>

--bcaec544eeccccc06a04f01bc12c--


--===============7014297895412544999==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7014297895412544999==--
