Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0PHB7OM053942 for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 11:11:07 -0600
Received: from saturn.retrosnub.co.uk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4381528FC9D
	for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 09:13:27 -0800 (PST)
Received: from saturn.retrosnub.co.uk (saturn.retrosnub.co.uk [178.18.118.26])
	by cuda.sgi.com with ESMTP id IfLaM4calL1Y0AO3 for
	<xfs@oss.sgi.com>; Tue, 25 Jan 2011 09:13:27 -0800 (PST)
Date: Tue, 25 Jan 2011 17:13:25 +0000 (GMT)
From: Malcolm Scott <lkml@malc.org.uk>
Subject: Re: [PATCH] Re: XFS deadlock in 2.6.37
In-Reply-To: <20110121052802.GA16267@dastard>
Message-ID: <alpine.DEB.2.00.1101251707300.29071@callisto.malc.org.uk>
References: <alpine.DEB.2.00.1101201702260.29071@callisto.malc.org.uk>
	<20110121052802.GA16267@dastard>
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Fri, 21 Jan 2011, Dave Chinner wrote:

> Looks like everything is hung up on the freelist lock. Can you
> test the patch below?

So far I haven't seen that crash after applying your patch; thanks.  (It 
previously took several days to occur on a busy box, though, so not 100% 
sure it's gone.)

However, there's now a new crash -- not sure how related this is but at 
some of the stack traces involve XFS.  Any ideas?

Unlike the last one, I could apparently recover the kernel with sysrq-i.

INFO: task nfsd:3923 blocked for more than 120 seconds.
[221162.675428] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[221162.691015]  ffff88030a5d79f0 0000000000000046 ffff88030a5d7980 ffff880002b97ff8
[221162.706250]  0000000000013a00 ffff880339cfad80 ffff880339cfb118 ffff88030a5d7fd8
[221162.721488]  ffff880339cfb120 0000000000013a00 ffff88030a5d6010 0000000000013a00
[221162.736739] Call Trace:
[221162.746904]  [<ffffffff815c9e87>] __mutex_lock_slowpath+0xf7/0x180
[221162.760862]  [<ffffffffa00bf23e>] ? exportfs_get_name+0x13e/0x160 [exportfs]
[221162.775580]  [<ffffffff815c9893>] mutex_lock+0x23/0x50
[221162.788271]  [<ffffffffa00bf452>] reconnect_path+0x1f2/0x300 [exportfs]
[221162.802483]  [<ffffffffa00bf7aa>] exportfs_decode_fh+0xea/0x940 [exportfs]
[221162.816907]  [<ffffffffa04907c0>] ? nfsd_acceptable+0x0/0x120 [nfsd]
[221162.830732]  [<ffffffffa03ea06f>] ? cache_check+0x6f/0x210 [sunrpc]
[221162.844380]  [<ffffffffa0496842>] ? exp_find_key+0x62/0xb0 [nfsd]
[221162.857770]  [<ffffffff8115399c>] ? kmem_cache_alloc_notrace+0x9c/0xb0
[221162.871504]  [<ffffffff812a741d>] ? aa_dup_task_context+0x3d/0x70
[221162.871509]  [<ffffffff812acf60>] ? apparmor_cred_prepare+0x40/0x60
[221162.871519]  [<ffffffffa0490ba4>] nfsd_set_fh_dentry+0x214/0x3d0 [nfsd]
[221162.871523]  [<ffffffff81112505>] ? __alloc_pages_slowpath+0x1c5/0x5c0
[221162.871530]  [<ffffffffa0490f25>] fh_verify+0x1c5/0x280 [nfsd]
[221162.871537]  [<ffffffffa04917a8>] nfsd_access+0x38/0x160 [nfsd]
[221162.871546]  [<ffffffffa049bf87>] nfsd3_proc_access+0x77/0xd0 [nfsd]
[221162.871556]  [<ffffffffa048d43e>] nfsd_dispatch+0xfe/0x250 [nfsd]
[221162.871571]  [<ffffffffa03df6c4>] svc_process_common+0x344/0x630 [sunrpc]
[221162.871576]  [<ffffffff8105c5f0>] ? default_wake_function+0x0/0x20
[221162.871582]  [<ffffffffa048dae0>] ? nfsd+0x0/0x170 [nfsd]
[221162.871593]  [<ffffffffa03dfac0>] svc_process+0x110/0x150 [sunrpc]
[221162.871600]  [<ffffffffa048dba5>] nfsd+0xc5/0x170 [nfsd]
[221162.871604]  [<ffffffff81085a56>] kthread+0x96/0xa0
[221162.871608]  [<ffffffff8100cf24>] kernel_thread_helper+0x4/0x10
[221162.871611]  [<ffffffff810859c0>] ? kthread+0x0/0xa0
[221162.871614]  [<ffffffff8100cf20>] ? kernel_thread_helper+0x0/0x10
[221162.871672] INFO: task php5-cgi:32524 blocked for more than 120 seconds.
[221162.871674] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[221162.871680]  ffff880057f4fc88 0000000000000086 ffff880057f4fbe8 ffffffff815c9160
[221162.871684]  0000000000013a00 ffff88002bc22d80 ffff88002bc23118 ffff880057f4ffd8
[221162.871687]  ffff88002bc23120 0000000000013a00 ffff880057f4e010 0000000000013a00
[221162.871691] Call Trace:
[221162.871695]  [<ffffffff815c9160>] ? io_schedule+0x90/0xc0
[221162.871700]  [<ffffffff8110b5a3>] ? wait_on_page_bit+0x73/0x80
[221162.871703]  [<ffffffff815c9e87>] __mutex_lock_slowpath+0xf7/0x180
[221162.871707]  [<ffffffff8108e281>] ? in_group_p+0x31/0x40
[221162.871710]  [<ffffffff815c9893>] mutex_lock+0x23/0x50
[221162.871713]  [<ffffffff8116f802>] do_lookup+0x102/0x180
[221162.871716]  [<ffffffff8116fb1d>] do_last+0x29d/0x420
[221162.871719]  [<ffffffff81171a13>] do_filp_open+0x203/0x5f0
[221162.871723]  [<ffffffff8112fc39>] ? handle_mm_fault+0x1b9/0x420
[221162.871728]  [<ffffffff8117d1fa>] ? alloc_fd+0x10a/0x150
[221162.871732]  [<ffffffff81160c79>] do_sys_open+0x69/0x150
[221162.871735]  [<ffffffff81160da0>] sys_open+0x20/0x30
[221162.871739]  [<ffffffff8100c102>] system_call_fastpath+0x16/0x1b
[221162.871743] INFO: task sshd:32537 blocked for more than 120 seconds.
[221162.871745] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[221162.871750]  ffff88007c09bc88 0000000000000082 ffff88007c09bbe8 ffffffff815c9160
[221162.871754]  0000000000013a00 ffff88027d098000 ffff88027d098398 ffff88007c09bfd8
[221162.871757]  ffff88027d0983a0 0000000000013a00 ffff88007c09a010 0000000000013a00
[221162.871761] Call Trace:
[221162.871763]  [<ffffffff815c9160>] ? io_schedule+0x90/0xc0
[221162.871767]  [<ffffffff8110b5a3>] ? wait_on_page_bit+0x73/0x80
[221162.871770]  [<ffffffff815c9e87>] __mutex_lock_slowpath+0xf7/0x180
[221162.871773]  [<ffffffff815c9893>] mutex_lock+0x23/0x50
[221162.871775]  [<ffffffff8116f802>] do_lookup+0x102/0x180
[221162.871778]  [<ffffffff8116fb1d>] do_last+0x29d/0x420
[221162.871781]  [<ffffffff81171a13>] do_filp_open+0x203/0x5f0
[221162.871784]  [<ffffffff8112fc39>] ? handle_mm_fault+0x1b9/0x420
[221162.871787]  [<ffffffff8117d1fa>] ? alloc_fd+0x10a/0x150
[221162.871790]  [<ffffffff81160c79>] do_sys_open+0x69/0x150
[221162.871793]  [<ffffffff81160da0>] sys_open+0x20/0x30
[221162.871796]  [<ffffffff8100c102>] system_call_fastpath+0x16/0x1b
[221162.871799] INFO: task sshd:32541 blocked for more than 120 seconds.
[221162.871801] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[221162.871806]  ffff880056c7fc88 0000000000000082 ffff880056c7fbe8 ffffffff00000000
[221162.871809]  0000000000013a00 ffff88027d09ad80 ffff88027d09b118 ffff880056c7ffd8
[221162.871813]  ffff88027d09b120 0000000000013a00 ffff880056c7e010 0000000000013a00
[221162.871816] Call Trace:
[221162.871819]  [<ffffffff815c9e87>] __mutex_lock_slowpath+0xf7/0x180
[221162.871822]  [<ffffffff815c9893>] mutex_lock+0x23/0x50
[221162.871825]  [<ffffffff8116f802>] do_lookup+0x102/0x180
[221162.871828]  [<ffffffff8116fb1d>] do_last+0x29d/0x420
[221162.871830]  [<ffffffff81171a13>] do_filp_open+0x203/0x5f0
[221162.871833]  [<ffffffff8112fc39>] ? handle_mm_fault+0x1b9/0x420
[221162.871836]  [<ffffffff8117d1fa>] ? alloc_fd+0x10a/0x150
[221162.871839]  [<ffffffff81160c79>] do_sys_open+0x69/0x150
[221162.871842]  [<ffffffff81160da0>] sys_open+0x20/0x30
[221162.871845]  [<ffffffff8100c102>] system_call_fastpath+0x16/0x1b
[221162.871849] INFO: task sshd:32547 blocked for more than 120 seconds.
[221162.871850] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[221162.871855]  ffff88009935bc88 0000000000000086 ffff88009935bbe8 ffffffff00000000
[221162.871859]  0000000000013a00 ffff8802279596c0 ffff880227959a58 ffff88009935bfd8
[221162.871862]  ffff880227959a60 0000000000013a00 ffff88009935a010 0000000000013a00
[221162.871865] Call Trace:
[221162.871868]  [<ffffffff815c9e87>] __mutex_lock_slowpath+0xf7/0x180
[221162.871871]  [<ffffffff815c9893>] mutex_lock+0x23/0x50
[221162.871874]  [<ffffffff8116f802>] do_lookup+0x102/0x180
[221162.871876]  [<ffffffff8116fb1d>] do_last+0x29d/0x420
[221162.871879]  [<ffffffff81171a13>] do_filp_open+0x203/0x5f0
[221162.871882]  [<ffffffff8112fc39>] ? handle_mm_fault+0x1b9/0x420
[221162.871885]  [<ffffffff8117d1fa>] ? alloc_fd+0x10a/0x150
[221162.871888]  [<ffffffff81160c79>] do_sys_open+0x69/0x150
[221162.871891]  [<ffffffff81160da0>] sys_open+0x20/0x30
[221162.871894]  [<ffffffff8100c102>] system_call_fastpath+0x16/0x1b
[221162.871896] INFO: task sshd:32548 blocked for more than 120 seconds.
[221162.871898] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[221162.871903]  ffff88006cabda98 0000000000000082 ffff88006cabda38 ffffffff811787d6
[221162.871906]  0000000000013a00 ffff880066494440 ffff8800664947d8 ffff88006cabdfd8
[221162.871910]  ffff8800664947e0 0000000000013a00 ffff88006cabc010 0000000000013a00
[221162.871913] Call Trace:
[221162.871916]  [<ffffffff811787d6>] ? __d_lookup+0x136/0x150
[221162.871919]  [<ffffffff815c9e87>] __mutex_lock_slowpath+0xf7/0x180
[221162.871922]  [<ffffffff815c9893>] mutex_lock+0x23/0x50
[221162.871925]  [<ffffffff8116f802>] do_lookup+0x102/0x180
[221162.871927]  [<ffffffff8116fb1d>] do_last+0x29d/0x420
[221162.871930]  [<ffffffff81171a13>] do_filp_open+0x203/0x5f0
[221162.871933]  [<ffffffff811627fa>] ? do_sync_read+0xda/0x120
[221162.871936]  [<ffffffff811174ed>] ? lru_cache_add_lru+0x2d/0x50
[221162.871941]  [<ffffffff8116ab1d>] open_exec+0x3d/0x110
[221162.871945]  [<ffffffff811af99d>] load_elf_binary+0xdcd/0xeb0
[221162.871948]  [<ffffffff811303c9>] ? get_user_pages+0x49/0x50
[221162.871951]  [<ffffffff8116979c>] ? get_arg_page+0x5c/0x100
[221162.871954]  [<ffffffff8116a042>] search_binary_handler+0xe2/0x300
[221162.871957]  [<ffffffff8116ae27>] do_execve+0x237/0x340
[221162.871961]  [<ffffffff8101474a>] sys_execve+0x4a/0x80
[221162.871964]  [<ffffffff8100c55c>] stub_execve+0x6c/0xc0
[221282.870468] INFO: task nfsd:3923 blocked for more than 120 seconds.
[221282.882094] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[221282.895378]  ffff88030a5d79f0 0000000000000046 ffff88030a5d7980 ffff880002b97ff8
[221282.908408]  0000000000013a00 ffff880339cfad80 ffff880339cfb118 ffff88030a5d7fd8
[221282.921529]  ffff880339cfb120 0000000000013a00 ffff88030a5d6010 0000000000013a00
[221282.921533] Call Trace:
[221282.921544]  [<ffffffff815c9e87>] __mutex_lock_slowpath+0xf7/0x180
[221282.921558]  [<ffffffffa00bf23e>] ? exportfs_get_name+0x13e/0x160 [exportfs]
[221282.921561]  [<ffffffff815c9893>] mutex_lock+0x23/0x50
[221282.921565]  [<ffffffffa00bf452>] reconnect_path+0x1f2/0x300 [exportfs]
[221282.921569]  [<ffffffffa00bf7aa>] exportfs_decode_fh+0xea/0x940 [exportfs]
[221282.921580]  [<ffffffffa04907c0>] ? nfsd_acceptable+0x0/0x120 [nfsd]
[221282.921600]  [<ffffffffa03ea06f>] ? cache_check+0x6f/0x210 [sunrpc]
[221282.921608]  [<ffffffffa0496842>] ? exp_find_key+0x62/0xb0 [nfsd]
[221282.921613]  [<ffffffff8115399c>] ? kmem_cache_alloc_notrace+0x9c/0xb0
[221282.921618]  [<ffffffff812a741d>] ? aa_dup_task_context+0x3d/0x70
[221282.921622]  [<ffffffff812acf60>] ? apparmor_cred_prepare+0x40/0x60
[221282.921629]  [<ffffffffa0490ba4>] nfsd_set_fh_dentry+0x214/0x3d0 [nfsd]
[221282.921633]  [<ffffffff81112505>] ? __alloc_pages_slowpath+0x1c5/0x5c0
[221282.921640]  [<ffffffffa0490f25>] fh_verify+0x1c5/0x280 [nfsd]
[221282.921647]  [<ffffffffa04917a8>] nfsd_access+0x38/0x160 [nfsd]
[221282.921655]  [<ffffffffa049bf87>] nfsd3_proc_access+0x77/0xd0 [nfsd]
[221282.921662]  [<ffffffffa048d43e>] nfsd_dispatch+0xfe/0x250 [nfsd]
[221282.921674]  [<ffffffffa03df6c4>] svc_process_common+0x344/0x630 [sunrpc]
[221282.921679]  [<ffffffff8105c5f0>] ? default_wake_function+0x0/0x20
[221282.921685]  [<ffffffffa048dae0>] ? nfsd+0x0/0x170 [nfsd]
[221282.921696]  [<ffffffffa03dfac0>] svc_process+0x110/0x150 [sunrpc]
[221282.921702]  [<ffffffffa048dba5>] nfsd+0xc5/0x170 [nfsd]
[221282.921707]  [<ffffffff81085a56>] kthread+0x96/0xa0
[221282.921711]  [<ffffffff8100cf24>] kernel_thread_helper+0x4/0x10
[221282.921714]  [<ffffffff810859c0>] ? kthread+0x0/0xa0
[221282.921717]  [<ffffffff8100cf20>] ? kernel_thread_helper+0x0/0x10
[221282.921755] INFO: task kworker/0:2:21740 blocked for more than 120 seconds.
[221282.921756] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[221282.921762]  ffff880345031ac0 0000000000000046 ffff880345031a10 ffffffff812db486
[221282.921765]  0000000000013a00 ffff88004c5bc440 ffff88004c5bc7d8 ffff880345031fd8
[221282.921768]  ffff88004c5bc7e0 0000000000013a00 ffff880345030010 0000000000013a00
[221282.921772] Call Trace:
[221282.921776]  [<ffffffff812db486>] ? rb_erase+0xd6/0x160
[221282.921782]  [<ffffffff815c9e87>] __mutex_lock_slowpath+0xf7/0x180
[221282.921787]  [<ffffffff81051ed2>] ? enqueue_entity+0x132/0x1b0
[221282.921789]  [<ffffffff815c9893>] mutex_lock+0x23/0x50
[221282.921825]  [<ffffffffa01400ca>] xfs_file_aio_write+0x4fa/0xac0 [xfs]
[221282.921829]  [<ffffffff8104ace0>] ? tg_nop+0x0/0x10
[221282.921832]  [<ffffffff81051cc8>] ? enqueue_sleeper+0x158/0x230
[221282.921836]  [<ffffffff811626da>] do_sync_write+0xda/0x120
[221282.921839]  [<ffffffff8105c2a3>] ? try_to_wake_up+0xc3/0x410
[221282.921844]  [<ffffffff81090749>] ? ktime_get_ts+0xa9/0xe0
[221282.921848]  [<ffffffff810aab5b>] do_acct_process+0x3fb/0x500
[221282.921851]  [<ffffffff810aacde>] acct_process+0x7e/0xb0
[221282.921854]  [<ffffffff81068fd5>] do_exit+0x2a5/0x400
[221282.921857]  [<ffffffff81081400>] ? worker_thread+0x0/0x410
[221282.921860]  [<ffffffff81085a4e>] kthread+0x8e/0xa0
[221282.921863]  [<ffffffff8100cf24>] kernel_thread_helper+0x4/0x10
[221282.921866]  [<ffffffff810859c0>] ? kthread+0x0/0xa0
[221282.921868]  [<ffffffff8100cf20>] ? kernel_thread_helper+0x0/0x10
[221282.921872] INFO: task kworker/3:0:16949 blocked for more than 120 seconds.
[221282.921873] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[221282.921879]  ffff88021acd9ac0 0000000000000046 0000000000000001 ffff88009e0d3a00
[221282.921882]  0000000000013a00 ffff8800020696c0 ffff880002069a58 ffff88021acd9fd8
[221282.921885]  ffff880002069a60 0000000000013a00 ffff88021acd8010 0000000000013a00
[221282.921889] Call Trace:
[221282.921892]  [<ffffffff815c9e87>] __mutex_lock_slowpath+0xf7/0x180
[221282.921895]  [<ffffffff815c9893>] mutex_lock+0x23/0x50
[221282.921915]  [<ffffffffa01400ca>] xfs_file_aio_write+0x4fa/0xac0 [xfs]
[221282.921919]  [<ffffffff81038649>] ? default_spin_lock_flags+0x9/0x10
[221282.921923]  [<ffffffff81013459>] ? sched_clock+0x9/0x10
[221282.921926]  [<ffffffff812db11d>] ? rb_insert_color+0x9d/0x160
[221282.921929]  [<ffffffff811626da>] do_sync_write+0xda/0x120
[221282.921932]  [<ffffffff8105c2a3>] ? try_to_wake_up+0xc3/0x410
[221282.921935]  [<ffffffff81090749>] ? ktime_get_ts+0xa9/0xe0
[221282.921938]  [<ffffffff810aab5b>] do_acct_process+0x3fb/0x500
[221282.921941]  [<ffffffff810aacde>] acct_process+0x7e/0xb0
[221282.921944]  [<ffffffff81068fd5>] do_exit+0x2a5/0x400
[221282.921947]  [<ffffffff81081400>] ? worker_thread+0x0/0x410
[221282.921950]  [<ffffffff81085a4e>] kthread+0x8e/0xa0
[221282.921952]  [<ffffffff8100cf24>] kernel_thread_helper+0x4/0x10
[221282.921955]  [<ffffffff810859c0>] ? kthread+0x0/0xa0
[221282.921958]  [<ffffffff8100cf20>] ? kernel_thread_helper+0x0/0x10
[221282.921961] INFO: task kworker/1:2:29640 blocked for more than 120 seconds.
[221282.921962] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[221282.921968]  ffff880144665ac0 0000000000000046 ffff880144665a10 ffffffff812db486
[221282.921971]  0000000000013a00 ffff8800025b96c0 ffff8800025b9a58 ffff880144665fd8
[221282.921974]  ffff8800025b9a60 0000000000013a00 ffff880144664010 0000000000013a00
[221282.921978] Call Trace:
[221282.921980]  [<ffffffff812db486>] ? rb_erase+0xd6/0x160
[221282.921984]  [<ffffffff815c9e87>] __mutex_lock_slowpath+0xf7/0x180
[221282.921987]  [<ffffffff815c9893>] mutex_lock+0x23/0x50
[221282.922007]  [<ffffffffa01400ca>] xfs_file_aio_write+0x4fa/0xac0 [xfs]
[221282.922010]  [<ffffffff812dcaf9>] ? put_dec+0x59/0x60
[221282.922030]  [<ffffffffa012c01b>] ? xfs_icsb_count+0x8b/0xc0 [xfs]
[221282.922034]  [<ffffffff81038649>] ? default_spin_lock_flags+0x9/0x10
[221282.922037]  [<ffffffff815caf4f>] ? _raw_spin_lock_irqsave+0x2f/0x40
[221282.922040]  [<ffffffff811626da>] do_sync_write+0xda/0x120
[221282.922044]  [<ffffffff81090749>] ? ktime_get_ts+0xa9/0xe0
[221282.922047]  [<ffffffff810aab5b>] do_acct_process+0x3fb/0x500
[221282.922050]  [<ffffffff810aacde>] acct_process+0x7e/0xb0
[221282.922053]  [<ffffffff81068fd5>] do_exit+0x2a5/0x400
[221282.922056]  [<ffffffff81081400>] ? worker_thread+0x0/0x410
[221282.922059]  [<ffffffff81085a4e>] kthread+0x8e/0xa0
[221282.922062]  [<ffffffff8100cf24>] kernel_thread_helper+0x4/0x10
[221282.922065]  [<ffffffff810859c0>] ? kthread+0x0/0xa0
[221282.922067]  [<ffffffff8100cf20>] ? kernel_thread_helper+0x0/0x10


-- 
Malcolm Scott

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
