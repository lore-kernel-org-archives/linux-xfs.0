Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 17 Oct 2008 05:41:31 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9HCfPSm016888
	for <xfs@oss.sgi.com>; Fri, 17 Oct 2008 05:41:27 -0700
Received: from mail-gx0-f18.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 48C411B600ED
	for <xfs@oss.sgi.com>; Fri, 17 Oct 2008 05:43:07 -0700 (PDT)
Received: from mail-gx0-f18.google.com (mail-gx0-f18.google.com [209.85.217.18]) by cuda.sgi.com with ESMTP id K7nTjr0z2DNTP5hz for <xfs@oss.sgi.com>; Fri, 17 Oct 2008 05:43:07 -0700 (PDT)
Received: by gxk11 with SMTP id 11so927239gxk.20
        for <xfs@oss.sgi.com>; Fri, 17 Oct 2008 05:43:07 -0700 (PDT)
Message-ID: <a4423d670810170543vd6b4c39p44bf125610d8540@mail.gmail.com>
Date: Fri, 17 Oct 2008 16:43:07 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
Subject: BUG: sleeping function called from invalid context at kernel/rwsem.c:131 XFS? (was: Re: linux-next: Tree for October 17)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

It is SMP x86_64, rootfs is on XFS

[    4.419571] BUG: sleeping function called from invalid context at
kernel/rwsem.c:131
[    4.419576] in_atomic(): 1, irqs_disabled(): 0, pid: 1396, name: mkdir
[    4.419579] 2 locks held by mkdir/1396:
[    4.419581]  #0:  (&type->i_mutex_dir_key#2/1){--..}, at:
[<ffffffff802a895f>] lookup_create+0x2b/0x99
[    4.419594]  #1:  (&(&ip->i_lock)->mr_lock/1){--..}, at:
[<ffffffff8037d30f>] xfs_ilock+0x60/0x7e
[    4.419605] Pid: 1396, comm: mkdir Not tainted 2.6.27-next-20081017 #2
[    4.419608] Call Trace:
[    4.419614]  [<ffffffff80257a61>] ? __debug_show_held_locks+0x22/0x24
[    4.419620]  [<ffffffff802303ee>] __might_sleep+0x120/0x122
[    4.419625]  [<ffffffff8024e41d>] down_write_nested+0x2c/0x7b
[    4.419629]  [<ffffffff8037d30f>] xfs_ilock+0x60/0x7e
[    4.419633]  [<ffffffff8037d9b4>] xfs_iget_core+0x3cc/0x4f1
[    4.419637]  [<ffffffff802b2393>] ? iget_locked+0xf0/0x125
[    4.419641]  [<ffffffff8037dbc4>] xfs_iget+0xeb/0x197
[    4.419646]  [<ffffffff803933c6>] xfs_trans_iget+0xb4/0x126
[    4.419651]  [<ffffffff8038164b>] xfs_ialloc+0x9e/0x51e
[    4.419655]  [<ffffffff802304be>] ? get_parent_ip+0x11/0x41
[    4.419659]  [<ffffffff80393d5a>] xfs_dir_ialloc+0x78/0x26a
[    4.419663]  [<ffffffff8024e464>] ? down_write_nested+0x73/0x7b
[    4.419667]  [<ffffffff80395fbf>] xfs_mkdir+0x236/0x438
[    4.419673]  [<ffffffff8039fe54>] xfs_vn_mknod+0xe7/0x13b
[    4.419677]  [<ffffffff8039febb>] xfs_vn_mkdir+0x13/0x15
[    4.419681]  [<ffffffff802a9e1d>] vfs_mkdir+0x4b/0x8f
[    4.419685]  [<ffffffff802ab574>] sys_mkdirat+0xa7/0x101
[    4.419691]  [<ffffffff8054052c>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[    4.419695]  [<ffffffff802587b0>] ? trace_hardirqs_on_caller+0x12c/0x157
[    4.419700]  [<ffffffff80225010>] ? do_page_fault+0x394/0x884
[    4.419704]  [<ffffffff802ab5e6>] sys_mkdir+0x18/0x1a
[    4.419709]  [<ffffffff8020b8bb>] system_call_fastpath+0x16/0x1b
[    4.743247] dmesg used greatest stack depth: 2848 bytes left
[    5.930376] bnx2: eth0: using MSI
[    6.056409] BUG: sleeping function called from invalid context at
kernel/rwsem.c:131
[    6.056413] in_atomic(): 1, irqs_disabled(): 0, pid: 1782, name: dhcpcd
[    6.056416] 2 locks held by dhcpcd/1782:
[    6.056418]  #0:  (&type->i_mutex_dir_key#2){--..}, at:
[<ffffffff802aa763>] do_filp_open+0x178/0x7d5
[    6.056431]  #1:  (&(&ip->i_lock)->mr_lock/1){--..}, at:
[<ffffffff8037d30f>] xfs_ilock+0x60/0x7e
[    6.056443] Pid: 1782, comm: dhcpcd Not tainted 2.6.27-next-20081017 #2
[    6.056445] Call Trace:
[    6.056452]  [<ffffffff80257a61>] ? __debug_show_held_locks+0x22/0x24
[    6.056458]  [<ffffffff802303ee>] __might_sleep+0x120/0x122
[    6.056464]  [<ffffffff8024e41d>] down_write_nested+0x2c/0x7b
[    6.056468]  [<ffffffff8037d30f>] xfs_ilock+0x60/0x7e
[    6.056472]  [<ffffffff8037d9b4>] xfs_iget_core+0x3cc/0x4f1
[    6.056476]  [<ffffffff802b2393>] ? iget_locked+0xf0/0x125
[    6.056481]  [<ffffffff8037dbc4>] xfs_iget+0xeb/0x197
[    6.056486]  [<ffffffff803933c6>] xfs_trans_iget+0xb4/0x126
[    6.056491]  [<ffffffff8038164b>] xfs_ialloc+0x9e/0x51e
[    6.056495]  [<ffffffff802304be>] ? get_parent_ip+0x11/0x41
[    6.056499]  [<ffffffff80393d5a>] xfs_dir_ialloc+0x78/0x26a
[    6.056503]  [<ffffffff8024e464>] ? down_write_nested+0x73/0x7b
[    6.056508]  [<ffffffff80395b8a>] xfs_create+0x239/0x438
[    6.056512]  [<ffffffff80256ccd>] ? get_lock_stats+0x2d/0x5c
[    6.056518]  [<ffffffff8039fe3b>] xfs_vn_mknod+0xce/0x13b
[    6.056522]  [<ffffffff8039fecd>] xfs_vn_create+0x10/0x12
[    6.056526]  [<ffffffff802a9dab>] vfs_create+0x5d/0x84
[    6.056530]  [<ffffffff802aa839>] do_filp_open+0x24e/0x7d5
[    6.056534]  [<ffffffff802304be>] ? get_parent_ip+0x11/0x41
[    6.056539]  [<ffffffff80231ee1>] ? sub_preempt_count+0xb0/0xc4
[    6.056544]  [<ffffffff802b40a4>] ? alloc_fd+0x122/0x133
[    6.056549]  [<ffffffff8029ef42>] do_sys_open+0x58/0xdf
[    6.056553]  [<ffffffff8029effc>] sys_open+0x20/0x22
[    6.056561]  [<ffffffff8020b8bb>] system_call_fastpath+0x16/0x1b
[    9.098603] bnx2: eth0 NIC Copper Link is Up, 1000 Mbps full
duplex, receive & transmit flow control ON
[   17.899872] BUG: sleeping function called from invalid context at
kernel/rwsem.c:131
[   17.899876] in_atomic(): 1, irqs_disabled(): 0, pid: 1791, name:
dhcpcd-run-hook
[   17.899879] 2 locks held by dhcpcd-run-hook/1791:
[   17.899881]  #0:  (&type->i_mutex_dir_key#2){--..}, at:
[<ffffffff802aa763>] do_filp_open+0x178/0x7d5
[   17.899893]  #1:  (&(&ip->i_lock)->mr_lock/1){--..}, at:
[<ffffffff8037d30f>] xfs_ilock+0x60/0x7e
[   17.899905] Pid: 1791, comm: dhcpcd-run-hook Not tainted
2.6.27-next-20081017 #2
[   17.899907] Call Trace:
[   17.899914]  [<ffffffff80257a61>] ? __debug_show_held_locks+0x22/0x24
[   17.899920]  [<ffffffff802303ee>] __might_sleep+0x120/0x122
[   17.899926]  [<ffffffff8024e41d>] down_write_nested+0x2c/0x7b
[   17.899930]  [<ffffffff8037d30f>] xfs_ilock+0x60/0x7e
[   17.899934]  [<ffffffff8037d9b4>] xfs_iget_core+0x3cc/0x4f1
[   17.899939]  [<ffffffff802b2393>] ? iget_locked+0xf0/0x125
[   17.899943]  [<ffffffff8037dbc4>] xfs_iget+0xeb/0x197
[   17.899953]  [<ffffffff803933c6>] xfs_trans_iget+0xb4/0x126
[   17.899956]  [<ffffffff8038164b>] xfs_ialloc+0x9e/0x51e
[   17.899959]  [<ffffffff802304be>] ? get_parent_ip+0x11/0x41
[   17.899962]  [<ffffffff80393d5a>] xfs_dir_ialloc+0x78/0x26a
[   17.899965]  [<ffffffff8024e464>] ? down_write_nested+0x73/0x7b
[   17.899968]  [<ffffffff80395b8a>] xfs_create+0x239/0x438
[   17.899971]  [<ffffffff80256ccd>] ? get_lock_stats+0x2d/0x5c
[   17.899975]  [<ffffffff8039fe3b>] xfs_vn_mknod+0xce/0x13b
[   17.899978]  [<ffffffff8039fecd>] xfs_vn_create+0x10/0x12
[   17.899981]  [<ffffffff802a9dab>] vfs_create+0x5d/0x84
[   17.899984]  [<ffffffff802aa839>] do_filp_open+0x24e/0x7d5
[   17.899987]  [<ffffffff802304be>] ? get_parent_ip+0x11/0x41
[   17.899990]  [<ffffffff80231ee1>] ? sub_preempt_count+0xb0/0xc4
[   17.899993]  [<ffffffff802b40a4>] ? alloc_fd+0x122/0x133
[   17.899997]  [<ffffffff8029ef42>] do_sys_open+0x58/0xdf
[   17.900002]  [<ffffffff80241376>] ? sigprocmask+0x37/0xd7
[   17.900004]  [<ffffffff8029effc>] sys_open+0x20/0x22
[   17.900008]  [<ffffffff8020b8bb>] system_call_fastpath+0x16/0x1b
[   18.190958] Adding 3911788k swap on /dev/sda1.  Priority:-1
extents:1 across:3911788k
[   30.773375] CPA self-test:
[   30.780146]  4k 523088 large 0 gb 0 x
262144[ffff880000000000-ffff88003ffff000] miss 0
[   30.792087]  4k 523088 large 0 gb 0 x
262144[ffff880000000000-ffff88003ffff000] miss 0
[   30.803460]  4k 523088 large 0 gb 0 x
262144[ffff880000000000-ffff88003ffff000] miss 0
[   30.803463] ok.
[ 3846.588515] BUG: sleeping function called from invalid context at
kernel/rwsem.c:131
[ 3846.588519] in_atomic(): 1, irqs_disabled(): 0, pid: 2005, name: screen
[ 3846.588523] 2 locks held by screen/2005:
[ 3846.588524]  #0:  (&type->i_mutex_dir_key#2/1){--..}, at:
[<ffffffff802a895f>] lookup_create+0x2b/0x99
[ 3846.588538]  #1:  (&(&ip->i_lock)->mr_lock/1){--..}, at:
[<ffffffff8037d30f>] xfs_ilock+0x60/0x7e
[ 3846.588549] Pid: 2005, comm: screen Not tainted 2.6.27-next-20081017 #2
[ 3846.588552] Call Trace:
[ 3846.588559]  [<ffffffff80257a61>] ? __debug_show_held_locks+0x22/0x24
[ 3846.588565]  [<ffffffff802303ee>] __might_sleep+0x120/0x122
[ 3846.588570]  [<ffffffff8024e41d>] down_write_nested+0x2c/0x7b
[ 3846.588574]  [<ffffffff8037d30f>] xfs_ilock+0x60/0x7e
[ 3846.588578]  [<ffffffff8037d9b4>] xfs_iget_core+0x3cc/0x4f1
[ 3846.588582]  [<ffffffff802b2393>] ? iget_locked+0xf0/0x125
[ 3846.588586]  [<ffffffff8037dbc4>] xfs_iget+0xeb/0x197
[ 3846.588591]  [<ffffffff803933c6>] xfs_trans_iget+0xb4/0x126
[ 3846.588596]  [<ffffffff8038164b>] xfs_ialloc+0x9e/0x51e
[ 3846.588599]  [<ffffffff802304be>] ? get_parent_ip+0x11/0x41
[ 3846.588604]  [<ffffffff80393d5a>] xfs_dir_ialloc+0x78/0x26a
[ 3846.588607]  [<ffffffff8024e464>] ? down_write_nested+0x73/0x7b
[ 3846.588612]  [<ffffffff80395b8a>] xfs_create+0x239/0x438
[ 3846.588617]  [<ffffffff8039fe3b>] xfs_vn_mknod+0xce/0x13b
[ 3846.588621]  [<ffffffff802a9d29>] vfs_mknod+0x75/0x9a
[ 3846.588625]  [<ffffffff802ab76e>] sys_mknodat+0x186/0x1e5
[ 3846.588632]  [<ffffffff8054052c>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 3846.588636]  [<ffffffff802587b0>] ? trace_hardirqs_on_caller+0x12c/0x157
[ 3846.588640]  [<ffffffff802ab7e7>] sys_mknod+0x1a/0x1c
[ 3846.588644]  [<ffffffff8020b8bb>] system_call_fastpath+0x16/0x1b
