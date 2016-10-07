Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx5-phx2.redhat.com ([209.132.183.37]:60089 "EHLO
        mx5-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755265AbcJGS4g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Oct 2016 14:56:36 -0400
Date: Fri, 7 Oct 2016 14:56:22 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
Message-ID: <1337864351.1107846.1475866582573.JavaMail.zimbra@redhat.com>
In-Reply-To: <1267347639.1072505.1475854075552.JavaMail.zimbra@redhat.com>
References: <CA+55aFxrqCng2Qxasc9pyMrKUGFjo==fEaFT1vkH9Lncte3RgQ@mail.gmail.com> <874538236.682217.1475693824077.JavaMail.zimbra@redhat.com> <20161005200522.GE19539@ZenIV.linux.org.uk> <119370333.805584.1475756417736.JavaMail.zimbra@redhat.com> <1860793605.807021.1475756759147.JavaMail.zimbra@redhat.com> <20161007070838.GA16260@quack2.suse.cz> <1720038662.1062048.1475851398433.JavaMail.zimbra@redhat.com> <1267347639.1072505.1475854075552.JavaMail.zimbra@redhat.com>
Subject: Re: local DoS - systemd hang or timeout (WAS: Re: [RFC][CFT]
 splice_read reworked)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>, tj <tj@kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, Dave Chinner <david@fromorbit.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel@vger.kernel.org, Dave Jones <davej@codemonkey.org.uk>



----- Original Message -----
> From: "CAI Qian" <caiqian@redhat.com>
> To: "Jan Kara" <jack@suse.cz>, "Miklos Szeredi" <miklos@szeredi.hu>, "tj" <tj@kernel.org>, "Al Viro"
> <viro@ZenIV.linux.org.uk>, "Linus Torvalds" <torvalds@linux-foundation.org>, "Dave Chinner" <david@fromorbit.com>
> Cc: "linux-xfs" <linux-xfs@vger.kernel.org>, "Jens Axboe" <axboe@kernel.dk>, "Nick Piggin" <npiggin@gmail.com>,
> linux-fsdevel@vger.kernel.org, "Dave Jones" <davej@codemonkey.org.uk>
> Sent: Friday, October 7, 2016 11:27:55 AM
> Subject: Re: local DoS - systemd hang or timeout (WAS: Re: [RFC][CFT] splice_read reworked)
> 
> 
> 
> > Hmm, this round of trinity triggered a different hang.
> This hang is reproducible so far with the command below on a overlayfs/xfs,
Another data point is that this hang can also be reproduced using device-mapper thinp
as the docker backend.
    CAI Qian

[12047.714409] INFO: task trinity-c0:3716 blocked for more than 120 seconds.
[12047.722033]       Not tainted 4.8.0-rc8-splice-fixw-proc+ #4
[12047.728354] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[12047.737107] trinity-c0      D ffff8804507dbd10 13552  3716   3713 0x00000084
[12047.744997]  ffff8804507dbd10 ffff8804240e9368 ffff880400000000 ffffffff81c0d540
[12047.753300]  ffff88044c430000 ffff8804507dc000 ffff8804240e9350 ffff8804507dbd40
[12047.761598]  ffff8804240e9368 ffff8804240e94d8 ffff8804507dbd28 ffffffff817cdaaf
[12047.769898] Call Trace:
[12047.772631]  [<ffffffff817cdaaf>] schedule+0x3f/0xa0
[12047.778174]  [<ffffffff817d24b7>] rwsem_down_read_failed+0x107/0x190
[12047.785303]  [<ffffffffa028ccca>] ? xfs_file_fsync+0xea/0x2e0 [xfs]
[12047.792309]  [<ffffffff813e2788>] call_rwsem_down_read_failed+0x18/0x30
[12047.799695]  [<ffffffff810f8b0b>] down_read_nested+0x5b/0x80
[12047.806029]  [<ffffffffa029d5fa>] ? xfs_ilock+0xfa/0x260 [xfs]
[12047.812554]  [<ffffffffa029d5fa>] xfs_ilock+0xfa/0x260 [xfs]
[12047.818887]  [<ffffffffa028ccca>] xfs_file_fsync+0xea/0x2e0 [xfs]
[12047.825693]  [<ffffffff812bdbbd>] vfs_fsync_range+0x3d/0xb0
[12047.831915]  [<ffffffff812bdc8d>] do_fsync+0x3d/0x70
[12047.837455]  [<ffffffff812bdf63>] SyS_fdatasync+0x13/0x20
[12047.843485]  [<ffffffff81003c9c>] do_syscall_64+0x6c/0x1e0
[12047.849609]  [<ffffffff817d4a3f>] entry_SYSCALL64_slow_path+0x25/0x25
[12047.856801] 1 lock held by trinity-c0/3716:
[12047.861470]  #0:  (&xfs_nondir_ilock_class){++++..}, at: [<ffffffffa029d5fa>] xfs_ilock+0xfa/0x260 [xfs]
[12047.872125] INFO: task trinity-c1:3717 blocked for more than 120 seconds.
[12047.879703]       Not tainted 4.8.0-rc8-splice-fixw-proc+ #4
[12047.886011] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[12047.894749] trinity-c1      D ffff8804507ffd10 13568  3717   3713 0x00000084
[12047.902645]  ffff8804507ffd10 ffff8804240e9368 ffff880400000000 ffff88046c9da000
[12047.910941]  ffff88044c434000 ffff880450800000 ffff8804240e9350 ffff8804507ffd40
[12047.919240]  ffff8804240e9368 ffff8804240e94d8 ffff8804507ffd28 ffffffff817cdaaf
[12047.927542] Call Trace:
[12047.930284]  [<ffffffff817cdaaf>] schedule+0x3f/0xa0
[12047.935826]  [<ffffffff817d24b7>] rwsem_down_read_failed+0x107/0x190
[12047.942933]  [<ffffffffa028ccca>] ? xfs_file_fsync+0xea/0x2e0 [xfs]
[12047.949930]  [<ffffffff813e2788>] call_rwsem_down_read_failed+0x18/0x30
[12047.957315]  [<ffffffff810f8b0b>] down_read_nested+0x5b/0x80
[12047.963647]  [<ffffffffa029d5fa>] ? xfs_ilock+0xfa/0x260 [xfs]
[12047.970171]  [<ffffffffa029d5fa>] xfs_ilock+0xfa/0x260 [xfs]
[12047.976506]  [<ffffffffa028ccca>] xfs_file_fsync+0xea/0x2e0 [xfs]
[12047.983310]  [<ffffffff812bdbbd>] vfs_fsync_range+0x3d/0xb0
[12047.989529]  [<ffffffff812bdc8d>] do_fsync+0x3d/0x70
[12047.995070]  [<ffffffff812bdf63>] SyS_fdatasync+0x13/0x20
[12048.001096]  [<ffffffff81003c9c>] do_syscall_64+0x6c/0x1e0
[12048.007217]  [<ffffffff817d4a3f>] entry_SYSCALL64_slow_path+0x25/0x25
[12048.014407] 1 lock held by trinity-c1/3717:
[12048.019085]  #0:  (&xfs_nondir_ilock_class){++++..}, at: [<ffffffffa029d5fa>] xfs_ilock+0xfa/0x260 [xfs]
[12048.029742] INFO: task trinity-c2:3718 blocked for more than 120 seconds.
[12048.037310]       Not tainted 4.8.0-rc8-splice-fixw-proc+ #4
[12048.043626] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[12048.052365] trinity-c2      D ffff8804586c7df8 13504  3718   3713 0x00000084
[12048.060261]  ffff8804586c7df8 0000000000000006 0000000000000000 ffff88046c9dc000
[12048.068565]  ffff88044c436000 ffff8804586c8000 ffff88044ec7e6f8 ffff88044c436000
[12048.076862]  0000000000000246 00000000ffffffff ffff8804586c7e10 ffffffff817cdaaf
[12048.085163] Call Trace:
[12048.087893]  [<ffffffff817cdaaf>] schedule+0x3f/0xa0
[12048.093434]  [<ffffffff817cdf18>] schedule_preempt_disabled+0x18/0x30
[12048.100627]  [<ffffffff817cf4df>] mutex_lock_nested+0x19f/0x450
[12048.107237]  [<ffffffff812a5313>] ? __fdget_pos+0x43/0x50
[12048.113262]  [<ffffffff812a5313>] __fdget_pos+0x43/0x50
[12048.119094]  [<ffffffff81297f53>] SyS_getdents+0x83/0x140
[12048.125120]  [<ffffffff81297cd0>] ? fillonedir+0x100/0x100
[12048.131243]  [<ffffffff81003c9c>] do_syscall_64+0x6c/0x1e0
[12048.137357]  [<ffffffff817d4a3f>] entry_SYSCALL64_slow_path+0x25/0x25
[12048.144546] 1 lock held by trinity-c2/3718:
[12048.149214]  #0:  (&f->f_pos_lock){+.+.+.}, at: [<ffffffff812a5313>] __fdget_pos+0x43/0x50
[12048.158495] INFO: task trinity-c3:3719 blocked for more than 120 seconds.
[12048.166071]       Not tainted 4.8.0-rc8-splice-fixw-proc+ #4
[12048.172388] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[12048.181120] trinity-c3      D ffff880450707c60 13552  3719   3713 0x00000084
[12048.189013]  ffff880450707c60 ffffffff00000000 ffff880400000000 ffff88046ca10000
[12048.197313]  ffff88044c432000 ffff880450708000 ffff8804240e9658 ffff8804240e9640
[12048.205612]  ffffffff00000000 ffff88044c432000 ffff880450707c78 ffffffff817cdaaf
[12048.213912] Call Trace:
[12048.216643]  [<ffffffff817cdaaf>] schedule+0x3f/0xa0
[12048.222183]  [<ffffffff817d2782>] rwsem_down_write_failed+0x242/0x4b0
[12048.229374]  [<ffffffff817d25ac>] ? rwsem_down_write_failed+0x6c/0x4b0
[12048.236662]  [<ffffffff813e27b7>] call_rwsem_down_write_failed+0x17/0x30
[12048.244144]  [<ffffffff817d1bff>] down_write+0x5f/0x80
[12048.249881]  [<ffffffff812ad021>] ? vfs_removexattr+0x61/0x120
[12048.256391]  [<ffffffff812ad021>] vfs_removexattr+0x61/0x120
[12048.262709]  [<ffffffff812ad135>] removexattr+0x55/0x80
[12048.268533]  [<ffffffff81402ff3>] ? __this_cpu_preempt_check+0x13/0x20
[12048.275811]  [<ffffffff810f8eae>] ? update_fast_ctr+0x4e/0x70
[12048.282225]  [<ffffffff810f8f57>] ? percpu_down_read+0x57/0x90
[12048.288728]  [<ffffffff81284be1>] ? __sb_start_write+0xd1/0xf0
[12048.295230]  [<ffffffff810cc367>] ? preempt_count_add+0x47/0xc0
[12048.301829]  [<ffffffff812a665f>] ? mnt_clone_write+0x3f/0x70
[12048.308242]  [<ffffffff812a8588>] ? __mnt_want_write_file+0x18/0x30
[12048.315238]  [<ffffffff812a85d0>] ? mnt_want_write_file+0x30/0x60
[12048.322039]  [<ffffffff812ae303>] SyS_fremovexattr+0x83/0xb0
[12048.328356]  [<ffffffff81003c9c>] do_syscall_64+0x6c/0x1e0
[12048.334478]  [<ffffffff817d4a3f>] entry_SYSCALL64_slow_path+0x25/0x25
[12048.341679] 2 locks held by trinity-c3/3719:
[12048.346454]  #0:  (sb_writers#8){.+.+.+}, at: [<ffffffff81284be1>] __sb_start_write+0xd1/0xf0
[12048.356042]  #1:  (&sb->s_type->i_mutex_key#14){+.+.+.}, at: [<ffffffff812ad021>] vfs_removexattr+0x61/0x120
[12048.367079] INFO: task trinity-c4:3720 blocked for more than 120 seconds.
[12048.374655]       Not tainted 4.8.0-rc8-splice-fixw-proc+ #4
[12048.380972] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[12048.389712] trinity-c4      D ffff88045072be08 13536  3720   3713 0x00000084
[12048.397606]  ffff88045072be08 0000000000000006 0000000000000000 ffff88046c9fe000
[12048.405902]  ffff880450720000 ffff88045072c000 ffff88044ec7e6f8 ffff880450720000
[12048.414205]  0000000000000246 00000000ffffffff ffff88045072be20 ffffffff817cdaaf
[12048.422505] Call Trace:
[12048.425235]  [<ffffffff817cdaaf>] schedule+0x3f/0xa0
[12048.430767]  [<ffffffff817cdf18>] schedule_preempt_disabled+0x18/0x30
[12048.437957]  [<ffffffff817cf4df>] mutex_lock_nested+0x19f/0x450
[12048.444565]  [<ffffffff812a5313>] ? __fdget_pos+0x43/0x50
[12048.450591]  [<ffffffff8117729f>] ? __audit_syscall_entry+0xaf/0x100
[12048.457675]  [<ffffffff812a5313>] __fdget_pos+0x43/0x50
[12048.463508]  [<ffffffff81298091>] SyS_getdents64+0x81/0x130
[12048.469720]  [<ffffffff81297a80>] ? iterate_dir+0x190/0x190
[12048.475939]  [<ffffffff81003c9c>] do_syscall_64+0x6c/0x1e0
[12048.482063]  [<ffffffff817d4a3f>] entry_SYSCALL64_slow_path+0x25/0x25
[12048.489243] 1 lock held by trinity-c4/3720:
[12048.493913]  #0:  (&f->f_pos_lock){+.+.+.}, at: [<ffffffff812a5313>] __fdget_pos+0x43/0x50
[12048.503182] INFO: task trinity-c5:3721 blocked for more than 120 seconds.
[12048.510757]       Not tainted 4.8.0-rc8-splice-fixw-proc+ #4
[12048.517071] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[12048.525812] trinity-c5      D ffff8804510a7e08 13552  3721   3713 0x00000084
[12048.533706]  ffff8804510a7e08 0000000000000006 0000000000000000 ffff88046c9fa000
[12048.542007]  ffff880450722000 ffff8804510a8000 ffff88044ec7e6f8 ffff880450722000
[12048.550310]  0000000000000246 00000000ffffffff ffff8804510a7e20 ffffffff817cdaaf
[12048.558610] Call Trace:
[12048.561339]  [<ffffffff817cdaaf>] schedule+0x3f/0xa0
[12048.566879]  [<ffffffff817cdf18>] schedule_preempt_disabled+0x18/0x30
[12048.574070]  [<ffffffff817cf4df>] mutex_lock_nested+0x19f/0x450
[12048.580677]  [<ffffffff812a5313>] ? __fdget_pos+0x43/0x50
[12048.586703]  [<ffffffff8117729f>] ? __audit_syscall_entry+0xaf/0x100
[12048.593796]  [<ffffffff812a5313>] __fdget_pos+0x43/0x50
[12048.599629]  [<ffffffff81298091>] SyS_getdents64+0x81/0x130
[12048.605849]  [<ffffffff81297a80>] ? iterate_dir+0x190/0x190
[12048.612069]  [<ffffffff81003c9c>] do_syscall_64+0x6c/0x1e0
[12048.618191]  [<ffffffff817d4a3f>] entry_SYSCALL64_slow_path+0x25/0x25
[12048.625382] 1 lock held by trinity-c5/3721:
[12048.630049]  #0:  (&f->f_pos_lock){+.+.+.}, at: [<ffffffff812a5313>] __fdget_pos+0x43/0x50
[12048.639329] INFO: task trinity-c6:3722 blocked for more than 120 seconds.
[12048.646903]       Not tainted 4.8.0-rc8-splice-fixw-proc+ #4
[12048.653219] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[12048.661958] trinity-c6      D ffff88044f0ebc50 12224  3722   3713 0x00000084
[12048.669849]  ffff88044f0ebc50 ffff8804240e9368 ffff880400000000 ffff88046c9fc000
[12048.678149]  ffff880450724000 ffff88044f0ec000 ffff8804240e9350 ffff88044f0ebc80
[12048.686448]  ffff8804240e9368 ffff8804240e92c0 ffff88044f0ebc68 ffffffff817cdaaf
[12048.694750] Call Trace:
[12048.697478]  [<ffffffff817cdaaf>] schedule+0x3f/0xa0
[12048.703018]  [<ffffffff817d24b7>] rwsem_down_read_failed+0x107/0x190
[12048.710126]  [<ffffffffa029d7d4>] ? xfs_ilock_attr_map_shared+0x34/0x40 [xfs]
[12048.718095]  [<ffffffff813e2788>] call_rwsem_down_read_failed+0x18/0x30
[12048.725479]  [<ffffffff810f8b0b>] down_read_nested+0x5b/0x80
[12048.731800]  [<ffffffffa029d5fa>] ? xfs_ilock+0xfa/0x260 [xfs]
[12048.738337]  [<ffffffffa029d5fa>] xfs_ilock+0xfa/0x260 [xfs]
[12048.744669]  [<ffffffffa029d7d4>] xfs_ilock_attr_map_shared+0x34/0x40 [xfs]
[12048.752457]  [<ffffffffa0280801>] xfs_attr_list_int+0x71/0x690 [xfs]
[12048.759555]  [<ffffffff810cba89>] ? __might_sleep+0x49/0x80
[12048.765792]  [<ffffffffa02abf2a>] xfs_vn_listxattr+0x7a/0xb0 [xfs]
[12048.772707]  [<ffffffffa02abcc0>] ? __xfs_xattr_put_listent+0xa0/0xa0 [xfs]
[12048.780480]  [<ffffffff812ad582>] vfs_listxattr+0x42/0x70
[12048.786517]  [<ffffffff812ad68e>] listxattr+0xde/0xf0
[12048.792156]  [<ffffffff812ae1f6>] SyS_flistxattr+0x56/0xa0
[12048.798271]  [<ffffffff81003c9c>] do_syscall_64+0x6c/0x1e0
[12048.804404]  [<ffffffff817d4a3f>] entry_SYSCALL64_slow_path+0x25/0x25
[12048.811595] 1 lock held by trinity-c6/3722:
[12048.816263]  #0:  (&xfs_nondir_ilock_class){++++..}, at: [<ffffffffa029d5fa>] xfs_ilock+0xfa/0x260 [xfs]
[12048.826935] INFO: task trinity-c7:3723 blocked for more than 120 seconds.
[12048.834516]       Not tainted 4.8.0-rc8-splice-fixw-proc+ #4
[12048.840832] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[12048.849572] trinity-c7      D ffff88044fc23c50 13552  3723   3713 0x00000084
[12048.857469]  ffff88044fc23c50 ffff8804240e9368 ffff880400000000 ffff88046c9f8000
[12048.865768]  ffff880450726000 ffff88044fc24000 ffff8804240e9350 ffff88044fc23c80
[12048.874067]  ffff8804240e9368 ffff8804240e92c0 ffff88044fc23c68 ffffffff817cdaaf
[12048.882370] Call Trace:
[12048.885100]  [<ffffffff817cdaaf>] schedule+0x3f/0xa0
[12048.890634]  [<ffffffff817d24b7>] rwsem_down_read_failed+0x107/0x190
[12048.897741]  [<ffffffffa029d7d4>] ? xfs_ilock_attr_map_shared+0x34/0x40 [xfs]
[12048.905707]  [<ffffffff813e2788>] call_rwsem_down_read_failed+0x18/0x30
[12048.913081]  [<ffffffff810f8b0b>] down_read_nested+0x5b/0x80
[12048.919412]  [<ffffffffa029d5fa>] ? xfs_ilock+0xfa/0x260 [xfs]
[12048.925937]  [<ffffffffa029d5fa>] xfs_ilock+0xfa/0x260 [xfs]
[12048.932267]  [<ffffffffa029d7d4>] xfs_ilock_attr_map_shared+0x34/0x40 [xfs]
[12048.940053]  [<ffffffffa0280801>] xfs_attr_list_int+0x71/0x690 [xfs]
[12048.947146]  [<ffffffff810cba89>] ? __might_sleep+0x49/0x80
[12048.953374]  [<ffffffffa02abf2a>] xfs_vn_listxattr+0x7a/0xb0 [xfs]
[12048.960288]  [<ffffffffa02abcc0>] ? __xfs_xattr_put_listent+0xa0/0xa0 [xfs]
[12048.968060]  [<ffffffff812ad582>] vfs_listxattr+0x42/0x70
[12048.974088]  [<ffffffff812ad602>] listxattr+0x52/0xf0
[12048.979726]  [<ffffffff812ae1f6>] SyS_flistxattr+0x56/0xa0
[12048.985849]  [<ffffffff81003c9c>] do_syscall_64+0x6c/0x1e0
[12048.991973]  [<ffffffff817d4a3f>] entry_SYSCALL64_slow_path+0x25/0x25
[12048.999162] 1 lock held by trinity-c7/3723:
[12049.003831]  #0:  (&xfs_nondir_ilock_class){++++..}, at: [<ffffffffa029d5fa>] xfs_ilock+0xfa/0x260 [xfs]
[12049.014481] INFO: task trinity-c8:3724 blocked for more than 120 seconds.
[12049.022072]       Not tainted 4.8.0-rc8-splice-fixw-proc+ #4
[12049.028389] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[12049.037130] trinity-c8      D ffff88044fc3fc60 13504  3724   3713 0x00000084
[12049.045023]  ffff88044fc3fc60 ffffffff00000000 ffff880400000000 ffff88046ca14000
[12049.053324]  ffff88044e540000 ffff88044fc40000 ffff8804240e9368 ffff8804240e9350
[12049.061623]  ffffffff00000000 ffff88044e540000 ffff88044fc3fc78 ffffffff817cdaaf
[12049.069924] Call Trace:
[12049.072654]  [<ffffffff817cdaaf>] schedule+0x3f/0xa0
[12049.078208]  [<ffffffff817d2782>] rwsem_down_write_failed+0x242/0x4b0
[12049.085408]  [<ffffffff817d25ac>] ? rwsem_down_write_failed+0x6c/0x4b0
[12049.092734]  [<ffffffffa028d7cc>] ? xfs_update_prealloc_flags+0x6c/0x100 [xfs]
[12049.100798]  [<ffffffff813e27b7>] call_rwsem_down_write_failed+0x17/0x30
[12049.108290]  [<ffffffff810f8c15>] down_write_nested+0x65/0x80
[12049.114742]  [<ffffffffa029d68e>] ? xfs_ilock+0x18e/0x260 [xfs]
[12049.121377]  [<ffffffffa029d68e>] xfs_ilock+0x18e/0x260 [xfs]
[12049.127819]  [<ffffffffa028d7cc>] xfs_update_prealloc_flags+0x6c/0x100 [xfs]
[12049.135714]  [<ffffffffa028da8e>] xfs_file_fallocate+0x22e/0x360 [xfs]
[12049.143004]  [<ffffffff810f8eae>] ? update_fast_ctr+0x4e/0x70
[12049.149435]  [<ffffffff810f8f57>] ? percpu_down_read+0x57/0x90
[12049.155958]  [<ffffffff81284be1>] ? __sb_start_write+0xd1/0xf0
[12049.162492]  [<ffffffff81284be1>] ? __sb_start_write+0xd1/0xf0
[12049.169016]  [<ffffffff8127e000>] vfs_fallocate+0x140/0x230
[12049.175249]  [<ffffffff8127eee4>] SyS_fallocate+0x44/0x70
[12049.181288]  [<ffffffff81003c9c>] do_syscall_64+0x6c/0x1e0
[12049.187423]  [<ffffffff817d4a3f>] entry_SYSCALL64_slow_path+0x25/0x25
[12049.194667] 5 locks held by trinity-c8/3724:
[12049.199429]  #0:  (sb_writers#8){.+.+.+}, at: [<ffffffff81284be1>] __sb_start_write+0xd1/0xf0
[12049.209024]  #1:  (&(&ip->i_iolock)->mr_lock){++++++}, at: [<ffffffffa029d654>] xfs_ilock+0x154/0x260 [xfs]
[12049.219990]  #2:  (&(&ip->i_mmaplock)->mr_lock){+++++.}, at: [<ffffffffa029d674>] xfs_ilock+0x174/0x260 [xfs]
[12049.231128]  #3:  (sb_internal){.+.+.+}, at: [<ffffffff81284b8b>] __sb_start_write+0x7b/0xf0
[12049.240620]  #4:  (&xfs_nondir_ilock_class){++++..}, at: [<ffffffffa029d68e>] xfs_ilock+0x18e/0x260 [xfs]
[12049.251383] INFO: task trinity-c9:3725 blocked for more than 120 seconds.
[12049.258959]       Not tainted 4.8.0-rc8-splice-fixw-proc+ #4
[12049.265287] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[12049.274027] trinity-c9      D ffff88044f043d30 13552  3725   3713 0x00000084
[12049.281922]  ffff88044f043d30 ffffffff00000000 ffff880400000000 ffff88046ca14000
[12049.290238]  ffff88044e542000 ffff88044f044000 ffff8804240e9658 ffff8804240e9640
[12049.298539]  ffffffff00000000 ffff88044e542000 ffff88044f043d48 ffffffff817cdaaf
[12049.306840] Call Trace:
[12049.309569]  [<ffffffff817cdaaf>] schedule+0x3f/0xa0
[12049.315122]  [<ffffffff817d2782>] rwsem_down_write_failed+0x242/0x4b0
[12049.322327]  [<ffffffff817d25ac>] ? rwsem_down_write_failed+0x6c/0x4b0
[12049.329625]  [<ffffffff813e27b7>] call_rwsem_down_write_failed+0x17/0x30
[12049.337118]  [<ffffffff817d1bff>] down_write+0x5f/0x80
[12049.342864]  [<ffffffff8127e413>] ? chmod_common+0x63/0x150
[12049.349096]  [<ffffffff8127e413>] chmod_common+0x63/0x150
[12049.355131]  [<ffffffff8117729f>] ? __audit_syscall_entry+0xaf/0x100
[12049.362236]  [<ffffffff810035cc>] ? syscall_trace_enter+0x1dc/0x390
[12049.369243]  [<ffffffff8127f5f2>] SyS_fchmod+0x52/0x80
[12049.374988]  [<ffffffff81003c9c>] do_syscall_64+0x6c/0x1e0
[12049.381124]  [<ffffffff817d4a3f>] entry_SYSCALL64_slow_path+0x25/0x25
[12049.388324] 2 locks held by trinity-c9/3725:
[12049.393100]  #0:  (sb_writers#8){.+.+.+}, at: [<ffffffff81284be1>] __sb_start_write+0xd1/0xf0
[12049.402705]  #1:  (&sb->s_type->i_mutex_key#14){+.+.+.}, at: [<ffffffff8127e413>] chmod_common+0x63/0x150
