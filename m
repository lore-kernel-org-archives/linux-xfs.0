Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 02 Oct 2008 12:06:09 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m92J60fl018944
	for <xfs@oss.sgi.com>; Thu, 2 Oct 2008 12:06:02 -0700
Received: from mail1.g-b.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 713F94A7BBA
	for <xfs@oss.sgi.com>; Thu,  2 Oct 2008 12:07:37 -0700 (PDT)
Received: from mail1.g-b.net (mail1.g-b.net [64.191.66.247]) by cuda.sgi.com with ESMTP id 4d8W0DWBX3P0AZDu for <xfs@oss.sgi.com>; Thu, 02 Oct 2008 12:07:37 -0700 (PDT)
Received: from [192.168.10.1] (agraham [93.97.176.102])
	by mail1.g-b.net (8.13.8/8.13.8) with ESMTP id m92J7XqZ000726
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 2 Oct 2008 20:07:35 +0100
Message-ID: <48E51BF5.3080100@g-b.net>
Date: Thu, 02 Oct 2008 20:07:33 +0100
From: Albert Graham <albert.graham@g-b.net>
Reply-To: albert.graham@g-b.net
MIME-Version: 1.0
Subject: XFS Regression Issue in kernel 2.6.26.3
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi Guys,

I use Fedora 8 as my MythTV backend server which uses XFS, ISince upgrading from kernel-2.6.25 to kernel-2.6.26 I've 
been getting the following errors (see below).

This occurs on very light load (e.g. rsync from a remove server - via the internet), the only option is to reboot the 
server as the messages are constantly recursive once it starts.

Now, I know my kernel it tainted with the NVIDIA driver and this is not a problem with any previous kernel.

Please let me know if there is anything I can do to assist diagnosing this issue.

Albert.


  =======================
XFS internal error XFS_WANT_CORRUPTED_RETURN at line 280 of file fs/xfs/xfs_alloc.c.  Caller 0xf88e0018
Pid: 8025, comm: rsync Tainted: P          2.6.26.3-14.fc8PAE #1
  [<f8900a41>] xfs_error_report+0x2c/0x2e [xfs]
  [<f88de86c>] xfs_alloc_fixup_trees+0x264/0x273 [xfs]
  [<f88e0018>] ? xfs_alloc_ag_vextent_near+0x6e4/0x82b [xfs]
  [<f891c7c8>] ? xfs_trans_brelse+0x2a/0xaa [xfs]
  [<f88e0018>] xfs_alloc_ag_vextent_near+0x6e4/0x82b [xfs]
  [<f88e018f>] xfs_alloc_ag_vextent+0x30/0xec [xfs]
  [<f88e099d>] xfs_alloc_vextent+0x2e1/0x424 [xfs]
  [<f88eff14>] xfs_bmap_btalloc+0x835/0xa1a [xfs]
  [<f88f0101>] xfs_bmap_alloc+0x8/0xa [xfs]
  [<f88f07f2>] xfs_bmapi+0x6ef/0xff1 [xfs]
  [<f89116db>] ? xfs_log_reserve+0xa0/0xa8 [xfs]
  [<f890c630>] xfs_iomap_write_allocate+0x21d/0x33c [xfs]
  [<f890d2b2>] xfs_iomap+0x276/0x2ec [xfs]
  [<f8923b1c>] xfs_map_blocks+0x2b/0x60 [xfs]
  [<f8924ce1>] xfs_page_state_convert+0x2f1/0x59a [xfs]
  [<f89250bc>] xfs_vm_writepage+0x97/0xcb [xfs]
  [<c046a581>] __writepage+0xb/0x25
  [<c046aa45>] write_cache_pages+0x180/0x287
  [<c046a576>] ? __writepage+0x0/0x25
  [<c046ab69>] generic_writepages+0x1d/0x27
  [<f8923cd3>] xfs_vm_writepages+0x36/0x3b [xfs]
  [<f8923c9d>] ? xfs_vm_writepages+0x0/0x3b [xfs]
  [<c046ab96>] do_writepages+0x23/0x34
  [<c04a157e>] __writeback_siserve+0xa0/0xa8 [xfs]
  [<f890c630>] xfs_iomap_write_allocate+0x21d/0x33c [xfs]
  [<f890d2b2>] xfs_iomap+0x276/0x2ec [xfs]
  [<f8923b1c>] xfs_map_blocks+0x2b/0x60 [xfs]
  [<f8924ce1>] xfs_page_state_convert+0x2f1/0x59a [xfs]
  [<f89250bc>] xfs_vm_writepage+0x97/0xcb [xfs]
  [<c046a581>] __writepage+0xb/0x25
  [<c046aa45>] write_cache_pages+0x180/0x287
  [<c046a576>] ? __writepage+0x0/0x25
  [<c046ab69>] generic_writepages+0x1d/0x27
  [<f8923cd3>] xfs_vm_writepages+0x36/0x3b [xfs]
  [<f8923c9d>] ? xfs_vm_writepages+0x0/0x3b [xfs]
  [<c046ab96>] do_writepages+0x23/0x34
  [<c04a157e>] __writeback_single_inode+0x123/0x22a
  [<c04a19b3>] sync_sb_inodes+0x192/0x257
  [<c04a1d5a>] writeback_inodes+0x6a/0xb1
  [<c046b04e>] balance_dirty_pages_ratelimited_nr+0x12f/0x2a4
  [<c046623a>] generic_file_buffered_write+0x14f/0x4eb
  [<c0631e19>] ? _spin_unlock_bh+0xe/0x10
  [<c05bc7ca>] ? release_sock+0x85/0x8d
  [<f892a55a>] xfs_write+0x43a/0x692 [xfs]
  [<c05bc287>] ? sock_common_recvmsg+0x31/0x4a
  [<f89273b5>] xfs_file_aio_write+0x53/0x5b [xfs]
  [<c0488625>] do_sync_write+0xab/0xe9
  [<c043ec25>] ? getnstimeofday+0x3c/0xcb
  [<c043a24d>] ? autoremove_wake_function+0x0/0x33
  [<c04d3295>] ? security_file_permission+0xf/0x11
  [<c048857a>] ? do_sync_write+0x0/0xe9
  [<c0488d72>] vfs_write+0x8c/0x133
  [<c048938c>] sys_write+0x3b/0x60
  [<c0403b63>] sysenter_past_esp+0x78/0xb1
  [<c0630000>] ? cpufreq_cpu_callback+0x13/0x6b
  =======================
XFS internal error XFS_WANT_CORRUPTED_RETURN at line 280 of file fs/xfs/xfs_alloc.c.  Caller 0xf88e0018
Pid: 8025, comm: rsync Tainted: P          2.6.26.3-14.fc8PAE #1
  [<f8900a41>] xfs_error_report+0x2c/0x2e [xfs]
  [<f88de86c>] xfs_alloc_fixup_trees+0x264/0x273 [xfs]
  [<f88e0018>] ? xfs_alloc_ag_vextent_near+0x6e4/0x82b [xfs]
  [<f891c7c8>] ? xfs_trans_brelse+0x2a/0xaa [xfs]
  [<f88e0018>] xfs_alloc_ag_vextent_near+0x6e4/0x82b [xfs]
  [<f88e018f>] xfs_alloc_ag_vextent+0x30/0xec [xfs]
  [<f88e099d>] xfs_alloc_vextent+0x2e1/0x424 [xfs]
  [<f88eff14>] xfs_bmap_btalloc+0x835/0xa1a [xfs]
  [<f88f0101>] xfs_bmap_alloc+0x8/0xa [xfs]
  [<f88f07f2>] xfs_bmapi+0x6ef/0xff1 [xfs]
  [<f89116db>] ? xfs_log_reserve+0xa0/0xa8 [xfs]
  [<f890c630>] xfs_iomap_write_allocate+0x21d/0x33c [xfs]
  [<f890d2b2>] xfs_iomap+0x276/0x2ec [xfs]
  [<f8923b1c>] xfs_map_blocks+0x2b/0x60 [xfs]
  [<f8924ce1>] xfs_page_state_convert+0x2f1/0x59a [xfs]
  [<f89250bc>] xfs_vm_writepage+0x97/0xcb [xfs]
  [<c046a581>] __writepage+0xb/0x25
  [<c046aa45>] write_cache_pages+0x180/0x287
  [<c046a576>] ? __writepage+0x0/0x25
  [<c046ab69>] generic_writepages+0x1d/0x27
  [<f8923cd3>] xfs_vm_writepages+0x36/0x3b [xfs]
  [<f8923c9d>] ? xfs_vm_writepages+0x0/0x3b [xfs]
  [<c046ab96>] do_writepages+0x23/0x34
  [<c04a157e>] __writeback_single_inode+0x123/0x22a
  [<c04a19b3>] sync_sb_inodes+0x192/0x257
  [<c04a1d5a>] writeback_inodes+0x6a/0xb1
  [<c046b04e>] balance_dirty_pages_ratelimited_nr+0x12f/0x2a4
  [<c046623a>] generic_file_buffered_write+0x14f/0x4eb
  [<c0631e19>] ? _spin_unlock_bh+0xe/0x10
  [<c05bc7ca>] ? release_sock+0x85/0x8d
  [<f892a55a>] xfs_write+0x43a/0x692 [xfs]
  [<c05bc287>] ? sock_common_recvmsg+0x31/0x4a
  [<f89273b5>] xfs_file_aio_write+0x53/0x5b [xfs]
  [<c0488625>] do_sync_write+0xab/0xe9
  [<c043ec25>] ? getnstimeofday+0x3c/0xcb
  [<c043a24d>] ? autoremove_wake_function+0x0/0x33
  [<c04d3295>] ? security_file_permission+0xf/0x11
  [<c048857a>] ? do_sync_write+0x0/0xe9
  [<c0488d72>] vfs_write+0x8c/0x133
  [<c048938c>] sys_write+0x3b/0x60
  [<c0403b63>] sysenter_past_esp+0x78/0xb1
  [<c0630000>] ? cpufreq_cpu_callback+0x13/0x6b
  =======================
XFS internal error XFS_WANT_CORRUPTED_RETURN at line 280 of file fs/xfs/xfs_alloc.c.  Caller 0xf88e0018
Pid: 8025, comm: rsync Tainted: P          2.6.26.3-14.fc8PAE #1
  [<f8900a41>] xfs_error_report+0x2c/0x2e [xfs]
  [<f88de86c>] xfs_alloc_fixup_trees+0x264/0x273 [xfs]
  [<f88e0018>] ? xfs_alloc_ag_vextent_near+0x6e4/0x82b [xfs]
  [<f891c7c8>] ? xfs_trans_brelse+0x2a/0xaa [xfs]
  [<f88e0018>] xfs_alloc_ag_vextent_near+0x6e4/0x82b [xfs]
  [<f88e018f>] xfs_alloc_ag_vextent+0x30/0xec [xfs]
  [<f88e099d>] xfs_alloc_vextent+0x2e1/0x424 [xfs]
  [<f88eff14>] xfs_bmap_btalloc+0x835/0xa1a [xfs]
  [<f88f0101>] xfs_bmap_alloc+0x8/0xa [xfs]
  [<f88f07f2>] xfs_bmapi+0x6ef/0xff1 [xfs]
  [<f89116db>] ? xfs_log_reserve+0xa0/0xa8 [xfs]
  [<f890c630>] xfs_iomap_write_allocate+0x21d/0x33c [xfs]
  [<f890d2b2>] xfs_iomap+0x276/0x2ec [xfs]
  [<c043ec25>] ? getnstimeofday+0x3c/0xcb
  [<f8923b1c>] xfs_map_blocks+0x2b/0x60 [xfs]
  [<f8924ce1>] xfs_page_state_convert+0x2f1/0x59a [xfs]
  [<f89250bc>] xfs_vm_writepage+0x97/0xcb [xfs]
  [<c046a581>] __writepage+0xb/0x25
  [<c046aa45>] write_cache_pages+0x180/0x287
  [<c046a576>] ? __writepage+0x0/0x25
  [<c046ab69>] generic_writepages+0x1d/0x27
  [<f8923cd3>] xfs_vm_writepages+0x36/0x3b [xfs]
  [<f8923c9d>] ? xfs_vm_writepages+0x0/0x3b [xfs]
  [<c046ab96>] do_writepages+0x23/0x34
  [<c04a157e>] __writeback_single_inode+0x123/0x22a
  [<c04a19b3>] sync_sb_inodes+0x192/0x257
  [<c04a1d5a>] writeback_inodes+0x6a/0xb1
  [<c046b04e>] balance_dirty_pages_ratelimited_nr+0x12f/0x2a4
  [<c046623a>] generic_file_buffered_write+0x14f/0x4eb
  [<c0631e19>] ? _spin_unlock_bh+0xe/0x10
  [<c05bc7ca>] ? release_sock+0x85/0x8d
  [<f892a55a>] xfs_write+0x43a/0x692 [xfs]
  [<c05bc287>] ? sock_common_recvmsg+0x31/0x4a
  [<f89273b5>] xfs_file_aio_write+0x53/0x5b [xfs]
  [<c0488625>] do_sync_write+0xab/0xe9
  [<c043ec25>] ? getnstimeofday+0x3c/0xcb
  [<c043a24d>] ? autoremove_wake_function+0x0/0x33
  [<c04d3295>] ? security_file_permission+0xf/0x11
  [<c048857a>] ? do_sync_write+0x0/0xe9
  [<c0488d72>] vfs_write+0x8c/0x133
  [<c048938c>] sys_write+0x3b/0x60
  [<c0403b63>] sysenter_past_esp+0x78/0xb1
  [<c0630000>] ? cpufreq_cpu_callback+0x13/0x6b
