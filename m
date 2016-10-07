Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx5-phx2.redhat.com ([209.132.183.37]:54247 "EHLO
        mx5-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756713AbcJGP2N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Oct 2016 11:28:13 -0400
Date: Fri, 7 Oct 2016 11:27:55 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
Message-ID: <1267347639.1072505.1475854075552.JavaMail.zimbra@redhat.com>
In-Reply-To: <1720038662.1062048.1475851398433.JavaMail.zimbra@redhat.com>
References: <CA+55aFxrqCng2Qxasc9pyMrKUGFjo==fEaFT1vkH9Lncte3RgQ@mail.gmail.com> <270577901.647921.1475682888765.JavaMail.zimbra@redhat.com> <874538236.682217.1475693824077.JavaMail.zimbra@redhat.com> <20161005200522.GE19539@ZenIV.linux.org.uk> <119370333.805584.1475756417736.JavaMail.zimbra@redhat.com> <1860793605.807021.1475756759147.JavaMail.zimbra@redhat.com> <20161007070838.GA16260@quack2.suse.cz> <1720038662.1062048.1475851398433.JavaMail.zimbra@redhat.com>
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



> Hmm, this round of trinity triggered a different hang.
This hang is reproducible so far with the command below on a overlayfs/xfs,

$ trinity -g vfs --arch 64 --disable-fds=sockets --disable-fds=perf --disable-fds=epoll
  --disable-fds=eventfd --disable-fds=pseudo --disable-fds=timerfd --disable-fds=memfd
  --disable-fds=drm
> 
> [ 2094.403119] INFO: task trinity-c0:3126 blocked for more than 120 seconds.
> [ 2094.410705]       Not tainted 4.8.0-rc8-splice-fixw-proc+ #4
> [ 2094.417027] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
> this message.
> [ 2094.425770] trinity-c0      D ffff88044efc3d10 13472  3126   3124
> 0x00000084
> [ 2094.433659]  ffff88044efc3d10 ffffffff00000000 ffff880400000000
> ffff880822b5e000
> [ 2094.441965]  ffff88044c8b8000 ffff88044efc4000 ffff880443755670
> ffff880443755658
> [ 2094.450272]  ffffffff00000000 ffff88044c8b8000 ffff88044efc3d28
> ffffffff817cdaaf
> [ 2094.458572] Call Trace:
> [ 2094.461312]  [<ffffffff817cdaaf>] schedule+0x3f/0xa0
> [ 2094.466858]  [<ffffffff817d2782>] rwsem_down_write_failed+0x242/0x4b0
> [ 2094.474049]  [<ffffffff817d25ac>] ? rwsem_down_write_failed+0x6c/0x4b0
> [ 2094.481352]  [<ffffffff810fd5f2>] ? __lock_acquire+0x472/0x1990
> [ 2094.487964]  [<ffffffff813e27b7>] call_rwsem_down_write_failed+0x17/0x30
> [ 2094.495450]  [<ffffffff817d1bff>] down_write+0x5f/0x80
> [ 2094.501190]  [<ffffffff8127e301>] ? chown_common.isra.12+0x131/0x1e0
> [ 2094.508284]  [<ffffffff8127e301>] chown_common.isra.12+0x131/0x1e0
> [ 2094.515177]  [<ffffffff81284be1>] ? __sb_start_write+0xd1/0xf0
> [ 2094.521692]  [<ffffffff810cc367>] ? preempt_count_add+0x47/0xc0
> [ 2094.528304]  [<ffffffff812a665f>] ? mnt_clone_write+0x3f/0x70
> [ 2094.534723]  [<ffffffff8127faef>] SyS_fchown+0x8f/0xa0
> [ 2094.540463]  [<ffffffff81003c9c>] do_syscall_64+0x6c/0x1e0
> [ 2094.546588]  [<ffffffff817d4a3f>] entry_SYSCALL64_slow_path+0x25/0x25
> [ 2094.553784] 2 locks held by trinity-c0/3126:
> [ 2094.558552]  #0:  (sb_writers#14){.+.+.+}, at: [<ffffffff81284be1>]
> __sb_start_write+0xd1/0xf0
> [ 2094.568240]  #1:  (&sb->s_type->i_mutex_key#17){++++++}, at:
> [<ffffffff8127e301>] chown_common.isra.12+0x131/0x1e0
> [ 2094.579864] INFO: task trinity-c1:3127 blocked for more than 120 seconds.
> [ 2094.587442]       Not tainted 4.8.0-rc8-splice-fixw-proc+ #4
> [ 2094.593761] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
> this message.
> [ 2094.602503] trinity-c1      D ffff88045a1bbd10 13312  3127   3124
> 0x00000084
> [ 2094.610402]  ffff88045a1bbd10 ffff880443769fe8 ffff880400000000
> ffff88046cefe000
> [ 2094.618710]  ffff88044c8ba000 ffff88045a1bc000 ffff880443769fd0
> ffff88045a1bbd40
> [ 2094.627015]  ffff880443769fe8 ffff88044376a158 ffff88045a1bbd28
> ffffffff817cdaaf
> [ 2094.635321] Call Trace:
> [ 2094.638053]  [<ffffffff817cdaaf>] schedule+0x3f/0xa0
> [ 2094.643597]  [<ffffffff817d24b7>] rwsem_down_read_failed+0x107/0x190
> [ 2094.650726]  [<ffffffffa0322cca>] ? xfs_file_fsync+0xea/0x2e0 [xfs]
> [ 2094.657727]  [<ffffffff813e2788>] call_rwsem_down_read_failed+0x18/0x30
> [ 2094.665119]  [<ffffffff810f8b0b>] down_read_nested+0x5b/0x80
> [ 2094.671457]  [<ffffffffa03335fa>] ? xfs_ilock+0xfa/0x260 [xfs]
> [ 2094.677987]  [<ffffffffa03335fa>] xfs_ilock+0xfa/0x260 [xfs]
> [ 2094.684324]  [<ffffffffa0322cca>] xfs_file_fsync+0xea/0x2e0 [xfs]
> [ 2094.691133]  [<ffffffff812bdbbd>] vfs_fsync_range+0x3d/0xb0
> [ 2094.697354]  [<ffffffff812bdc8d>] do_fsync+0x3d/0x70
> [ 2094.702896]  [<ffffffff812bdf40>] SyS_fsync+0x10/0x20
> [ 2094.708528]  [<ffffffff81003c9c>] do_syscall_64+0x6c/0x1e0
> [ 2094.714652]  [<ffffffff817d4a3f>] entry_SYSCALL64_slow_path+0x25/0x25
> [ 2094.721844] 1 lock held by trinity-c1/3127:
> [ 2094.726515]  #0:  (&xfs_nondir_ilock_class){++++..}, at:
> [<ffffffffa03335fa>] xfs_ilock+0xfa/0x260 [xfs]
> [ 2094.737181] INFO: task trinity-c2:3128 blocked for more than 120 seconds.
> [ 2094.744751]       Not tainted 4.8.0-rc8-splice-fixw-proc+ #4
> [ 2094.751068] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
> this message.
> [ 2094.759810] trinity-c2      D ffff8804574f3df8 13472  3128   3124
> 0x00000084
> [ 2094.767692]  ffff8804574f3df8 0000000000000006 0000000000000000
> ffff8804569a4000
> [ 2094.776002]  ffff88044c8bc000 ffff8804574f4000 ffff8804622eb338
> ffff88044c8bc000
> [ 2094.784307]  0000000000000246 00000000ffffffff ffff8804574f3e10
> ffffffff817cdaaf
> [ 2094.792605] Call Trace:
> [ 2094.795340]  [<ffffffff817cdaaf>] schedule+0x3f/0xa0
> [ 2094.800886]  [<ffffffff817cdf18>] schedule_preempt_disabled+0x18/0x30
> [ 2094.808078]  [<ffffffff817cf4df>] mutex_lock_nested+0x19f/0x450
> [ 2094.814688]  [<ffffffff812a5313>] ? __fdget_pos+0x43/0x50
> [ 2094.820715]  [<ffffffff812a5313>] __fdget_pos+0x43/0x50
> [ 2094.826544]  [<ffffffff81297f53>] SyS_getdents+0x83/0x140
> [ 2094.832573]  [<ffffffff81297cd0>] ? fillonedir+0x100/0x100
> [ 2094.838699]  [<ffffffff81003c9c>] do_syscall_64+0x6c/0x1e0
> [ 2094.844822]  [<ffffffff817d4a3f>] entry_SYSCALL64_slow_path+0x25/0x25
> [ 2094.852013] 1 lock held by trinity-c2/3128:
> [ 2094.856682]  #0:  (&f->f_pos_lock){+.+.+.}, at: [<ffffffff812a5313>]
> __fdget_pos+0x43/0x50
> [ 2094.865969] INFO: task trinity-c3:3129 blocked for more than 120 seconds.
> [ 2094.873547]       Not tainted 4.8.0-rc8-splice-fixw-proc+ #4
> [ 2094.879864] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
> this message.
> [ 2094.888606] trinity-c3      D ffff880455ce3e08 13440  3129   3124
> 0x00000084
> [ 2094.896495]  ffff880455ce3e08 0000000000000006 0000000000000000
> ffff88045144e000
> [ 2094.904803]  ffff88044c8be000 ffff880455ce4000 ffff8804622eb338
> ffff88044c8be000
> [ 2094.913111]  0000000000000246 00000000ffffffff ffff880455ce3e20
> ffffffff817cdaaf
> [ 2094.921418] Call Trace:
> [ 2094.924152]  [<ffffffff817cdaaf>] schedule+0x3f/0xa0
> [ 2094.929695]  [<ffffffff817cdf18>] schedule_preempt_disabled+0x18/0x30
> [ 2094.936885]  [<ffffffff817cf4df>] mutex_lock_nested+0x19f/0x450
> [ 2094.943496]  [<ffffffff812a5313>] ? __fdget_pos+0x43/0x50
> [ 2094.949526]  [<ffffffff8117729f>] ? __audit_syscall_entry+0xaf/0x100
> [ 2094.956620]  [<ffffffff812a5313>] __fdget_pos+0x43/0x50
> [ 2094.962454]  [<ffffffff81298091>] SyS_getdents64+0x81/0x130
> [ 2094.968675]  [<ffffffff81297a80>] ? iterate_dir+0x190/0x190
> [ 2094.974895]  [<ffffffff81003c9c>] do_syscall_64+0x6c/0x1e0
> [ 2094.981019]  [<ffffffff817d4a3f>] entry_SYSCALL64_slow_path+0x25/0x25
> [ 2094.988204] 1 lock held by trinity-c3/3129:
> [ 2094.992872]  #0:  (&f->f_pos_lock){+.+.+.}, at: [<ffffffff812a5313>]
> __fdget_pos+0x43/0x50
> [ 2095.002158] INFO: task trinity-c4:3130 blocked for more than 120 seconds.
> [ 2095.009734]       Not tainted 4.8.0-rc8-splice-fixw-proc+ #4
> [ 2095.016052] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
> this message.
> [ 2095.024793] trinity-c4      D ffff880458997e28 13392  3130   3124
> 0x00000084
> [ 2095.032690]  ffff880458997e28 0000000000000006 0000000000000000
> ffff88046ca18000
> [ 2095.040995]  ffff880458998000 ffff880458998000 ffff8804622eb338
> ffff880458998000
> [ 2095.049342]  0000000000000246 00000000ffffffff ffff880458997e40
> ffffffff817cdaaf
> [ 2095.057650] Call Trace:
> [ 2095.060382]  [<ffffffff817cdaaf>] schedule+0x3f/0xa0
> [ 2095.065926]  [<ffffffff817cdf18>] schedule_preempt_disabled+0x18/0x30
> [ 2095.073118]  [<ffffffff817cf4df>] mutex_lock_nested+0x19f/0x450
> [ 2095.079728]  [<ffffffff812a5313>] ? __fdget_pos+0x43/0x50
> [ 2095.085757]  [<ffffffff812a5313>] __fdget_pos+0x43/0x50
> [ 2095.091589]  [<ffffffff812811dd>] SyS_lseek+0x1d/0xb0
> [ 2095.097229]  [<ffffffff81003c9c>] do_syscall_64+0x6c/0x1e0
> [ 2095.103355]  [<ffffffff817d4a3f>] entry_SYSCALL64_slow_path+0x25/0x25
> [ 2095.110547] 1 lock held by trinity-c4/3130:
> [ 2095.115216]  #0:  (&f->f_pos_lock){+.+.+.}, at: [<ffffffff812a5313>]
> __fdget_pos+0x43/0x50
> [ 2095.124507] INFO: task trinity-c5:3131 blocked for more than 120 seconds.
> [ 2095.132083]       Not tainted 4.8.0-rc8-splice-fixw-proc+ #4
> [ 2095.138402] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
> this message.
> [ 2095.147135] trinity-c5      D ffff88045a12bae0 13472  3131   3124
> 0x00000084
> [ 2095.155034]  ffff88045a12bae0 ffff880443769fe8 ffff880400000000
> ffff88046ca1a000
> [ 2095.163339]  ffff88045899a000 ffff88045a12c000 ffff880443769fd0
> ffff88045a12bb10
> [ 2095.171645]  ffff880443769fe8 0000000000000000 ffff88045a12baf8
> ffffffff817cdaaf
> [ 2095.179952] Call Trace:
> [ 2095.182684]  [<ffffffff817cdaaf>] schedule+0x3f/0xa0
> [ 2095.188230]  [<ffffffff817d24b7>] rwsem_down_read_failed+0x107/0x190
> [ 2095.195341]  [<ffffffffa03337d4>] ? xfs_ilock_attr_map_shared+0x34/0x40
> [xfs]
> [ 2095.203310]  [<ffffffff813e2788>] call_rwsem_down_read_failed+0x18/0x30
> [ 2095.210696]  [<ffffffff810f8b0b>] down_read_nested+0x5b/0x80
> [ 2095.217029]  [<ffffffffa03335fa>] ? xfs_ilock+0xfa/0x260 [xfs]
> [ 2095.223558]  [<ffffffffa03335fa>] xfs_ilock+0xfa/0x260 [xfs]
> [ 2095.229894]  [<ffffffffa03337d4>] xfs_ilock_attr_map_shared+0x34/0x40
> [xfs]
> [ 2095.237682]  [<ffffffffa02ccfaf>] xfs_attr_get+0xdf/0x1b0 [xfs]
> [ 2095.244312]  [<ffffffffa0341bfc>] xfs_xattr_get+0x4c/0x70 [xfs]
> [ 2095.250924]  [<ffffffff812ad269>] generic_getxattr+0x59/0x70
> [ 2095.257244]  [<ffffffff812acf9b>] vfs_getxattr+0x8b/0xb0
> [ 2095.263177]  [<ffffffffa0435bd6>] ovl_xattr_get+0x46/0x60 [overlay]
> [ 2095.270176]  [<ffffffffa04331aa>] ovl_other_xattr_get+0x1a/0x20 [overlay]
> [ 2095.277756]  [<ffffffff812ad269>] generic_getxattr+0x59/0x70
> [ 2095.284079]  [<ffffffff81345e9e>] cap_inode_need_killpriv+0x2e/0x40
> [ 2095.291078]  [<ffffffff81349a33>] security_inode_need_killpriv+0x33/0x50
> [ 2095.298560]  [<ffffffff812a2fb0>] dentry_needs_remove_privs+0x30/0x50
> [ 2095.305743]  [<ffffffff8127ea21>] do_truncate+0x51/0xc0
> [ 2095.311581]  [<ffffffff81284be1>] ? __sb_start_write+0xd1/0xf0
> [ 2095.318094]  [<ffffffff81284be1>] ? __sb_start_write+0xd1/0xf0
> [ 2095.324609]  [<ffffffff8127edde>] do_sys_ftruncate.constprop.15+0xfe/0x160
> [ 2095.332286]  [<ffffffff8127ee7e>] SyS_ftruncate+0xe/0x10
> [ 2095.338225]  [<ffffffff81003c9c>] do_syscall_64+0x6c/0x1e0
> [ 2095.344339]  [<ffffffff817d4a3f>] entry_SYSCALL64_slow_path+0x25/0x25
> [ 2095.351531] 2 locks held by trinity-c5/3131:
> [ 2095.356297]  #0:  (sb_writers#14){.+.+.+}, at: [<ffffffff81284be1>]
> __sb_start_write+0xd1/0xf0
> [ 2095.365983]  #1:  (&xfs_nondir_ilock_class){++++..}, at:
> [<ffffffffa03335fa>] xfs_ilock+0xfa/0x260 [xfs]
> [ 2095.376647] INFO: task trinity-c6:3132 blocked for more than 120 seconds.
> [ 2095.384216]       Not tainted 4.8.0-rc8-splice-fixw-proc+ #4
> [ 2095.390535] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
> this message.
> [ 2095.399275] trinity-c6      D ffff88044da5fd30 13312  3132   3124
> 0x00000084
> [ 2095.407177]  ffff88044da5fd30 ffffffff00000000 ffff880400000000
> ffff880459858000
> [ 2095.415485]  ffff88045899c000 ffff88044da60000 ffff880443755670
> ffff880443755658
> [ 2095.423789]  ffffffff00000000 ffff88045899c000 ffff88044da5fd48
> ffffffff817cdaaf
> [ 2095.432094] Call Trace:
> [ 2095.434825]  [<ffffffff817cdaaf>] schedule+0x3f/0xa0
> [ 2095.440372]  [<ffffffff817d2782>] rwsem_down_write_failed+0x242/0x4b0
> [ 2095.447565]  [<ffffffff817d25ac>] ? rwsem_down_write_failed+0x6c/0x4b0
> [ 2095.454854]  [<ffffffff813e27b7>] call_rwsem_down_write_failed+0x17/0x30
> [ 2095.462337]  [<ffffffff817d1bff>] down_write+0x5f/0x80
> [ 2095.468077]  [<ffffffff8127e413>] ? chmod_common+0x63/0x150
> [ 2095.474300]  [<ffffffff8127e413>] chmod_common+0x63/0x150
> [ 2095.480327]  [<ffffffff8117729f>] ? __audit_syscall_entry+0xaf/0x100
> [ 2095.487421]  [<ffffffff810035cc>] ? syscall_trace_enter+0x1dc/0x390
> [ 2095.494418]  [<ffffffff8127f5f2>] SyS_fchmod+0x52/0x80
> [ 2095.500155]  [<ffffffff81003c9c>] do_syscall_64+0x6c/0x1e0
> [ 2095.506270]  [<ffffffff817d4a3f>] entry_SYSCALL64_slow_path+0x25/0x25
> [ 2095.513452] 2 locks held by trinity-c6/3132:
> [ 2095.518217]  #0:  (sb_writers#14){.+.+.+}, at: [<ffffffff81284be1>]
> __sb_start_write+0xd1/0xf0
> [ 2095.527895]  #1:  (&sb->s_type->i_mutex_key#17){++++++}, at:
> [<ffffffff8127e413>] chmod_common+0x63/0x150
> [ 2095.538648] INFO: task trinity-c7:3133 blocked for more than 120 seconds.
> [ 2095.546227]       Not tainted 4.8.0-rc8-splice-fixw-proc+ #4
> [ 2095.552544] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
> this message.
> [ 2095.561288] trinity-c7      D ffff88044d393d10 13472  3133   3124
> 0x00000084
> [ 2095.569188]  ffff88044d393d10 ffff880443769fe8 ffff880400000000
> ffff88086ce68000
> [ 2095.577491]  ffff88045899e000 ffff88044d394000 ffff880443769fd0
> ffff88044d393d40
> [ 2095.585796]  ffff880443769fe8 ffff88044376a158 ffff88044d393d28
> ffffffff817cdaaf
> [ 2095.594103] Call Trace:
> [ 2095.596836]  [<ffffffff817cdaaf>] schedule+0x3f/0xa0
> [ 2095.602379]  [<ffffffff817d24b7>] rwsem_down_read_failed+0x107/0x190
> [ 2095.609491]  [<ffffffffa0322cca>] ? xfs_file_fsync+0xea/0x2e0 [xfs]
> [ 2095.616490]  [<ffffffff813e2788>] call_rwsem_down_read_failed+0x18/0x30
> [ 2095.623877]  [<ffffffff810f8b0b>] down_read_nested+0x5b/0x80
> [ 2095.630212]  [<ffffffffa03335fa>] ? xfs_ilock+0xfa/0x260 [xfs]
> [ 2095.636740]  [<ffffffffa03335fa>] xfs_ilock+0xfa/0x260 [xfs]
> [ 2095.643076]  [<ffffffffa0322cca>] xfs_file_fsync+0xea/0x2e0 [xfs]
> [ 2095.649889]  [<ffffffff812bdbbd>] vfs_fsync_range+0x3d/0xb0
> [ 2095.656109]  [<ffffffff812bdc8d>] do_fsync+0x3d/0x70
> [ 2095.661653]  [<ffffffff812bdf40>] SyS_fsync+0x10/0x20
> [ 2095.667291]  [<ffffffff81003c9c>] do_syscall_64+0x6c/0x1e0
> [ 2095.673417]  [<ffffffff817d4a3f>] entry_SYSCALL64_slow_path+0x25/0x25
> [ 2095.680610] 1 lock held by trinity-c7/3133:
> [ 2095.685281]  #0:  (&xfs_nondir_ilock_class){++++..}, at:
> [<ffffffffa03335fa>] xfs_ilock+0xfa/0x260 [xfs]
> [ 2095.695947] INFO: task trinity-c8:3135 blocked for more than 120 seconds.
> [ 2095.703530]       Not tainted 4.8.0-rc8-splice-fixw-proc+ #4
> [ 2095.709848] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
> this message.
> [ 2095.718590] trinity-c8      D ffff88044d3b3d10 12912  3135   3124
> 0x00000084
> [ 2095.726470]  ffff88044d3b3d10 ffff880443769fe8 ffff880400000000
> ffff88046ca30000
> [ 2095.734775]  ffff88044d3a8000 ffff88044d3b4000 ffff880443769fd0
> ffff88044d3b3d40
> [ 2095.743083]  ffff880443769fe8 ffff88044376a158 ffff88044d3b3d28
> ffffffff817cdaaf
> [ 2095.751387] Call Trace:
> [ 2095.754119]  [<ffffffff817cdaaf>] schedule+0x3f/0xa0
> [ 2095.759662]  [<ffffffff817d24b7>] rwsem_down_read_failed+0x107/0x190
> [ 2095.766772]  [<ffffffffa0322cca>] ? xfs_file_fsync+0xea/0x2e0 [xfs]
> [ 2095.773763]  [<ffffffff813e2788>] call_rwsem_down_read_failed+0x18/0x30
> [ 2095.781148]  [<ffffffff810f8b0b>] down_read_nested+0x5b/0x80
> [ 2095.787482]  [<ffffffffa03335fa>] ? xfs_ilock+0xfa/0x260 [xfs]
> [ 2095.794013]  [<ffffffffa03335fa>] xfs_ilock+0xfa/0x260 [xfs]
> [ 2095.800347]  [<ffffffffa0322cca>] xfs_file_fsync+0xea/0x2e0 [xfs]
> [ 2095.807155]  [<ffffffff812bdbbd>] vfs_fsync_range+0x3d/0xb0
> [ 2095.813377]  [<ffffffff812bdc8d>] do_fsync+0x3d/0x70
> [ 2095.818921]  [<ffffffff812bdf63>] SyS_fdatasync+0x13/0x20
> [ 2095.824949]  [<ffffffff81003c9c>] do_syscall_64+0x6c/0x1e0
> [ 2095.831074]  [<ffffffff817d4a3f>] entry_SYSCALL64_slow_path+0x25/0x25
> [ 2095.838261] 1 lock held by trinity-c8/3135:
> [ 2095.842930]  #0:  (&xfs_nondir_ilock_class){++++..}, at:
> [<ffffffffa03335fa>] xfs_ilock+0xfa/0x260 [xfs]
> [ 2095.853588] INFO: task trinity-c9:3136 blocked for more than 120 seconds.
> [ 2095.861167]       Not tainted 4.8.0-rc8-splice-fixw-proc+ #4
> [ 2095.867485] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
> this message.
> [ 2095.876228] trinity-c9      D ffff88045b3679e0 13328  3136   3124
> 0x00000084
> [ 2095.884111]  ffff88045b3679e0 ffff880443769fe8 ffff880400000000
> ffff88086ce56000
> [ 2095.892417]  ffff88044d3aa000 ffff88045b368000 ffff880443769fd0
> ffff88045b367a10
> [ 2095.900721]  ffff880443769fe8 ffff88044376a1e8 ffff88045b3679f8
> ffffffff817cdaaf
> [ 2095.909024] Call Trace:
> [ 2095.911761]  [<ffffffff817cdaaf>] schedule+0x3f/0xa0
> [ 2095.917305]  [<ffffffff817d24b7>] rwsem_down_read_failed+0x107/0x190
> [ 2095.924414]  [<ffffffffa0333790>] ? xfs_ilock_data_map_shared+0x30/0x40
> [xfs]
> [ 2095.932383]  [<ffffffff813e2788>] call_rwsem_down_read_failed+0x18/0x30
> [ 2095.939768]  [<ffffffff810f8b0b>] down_read_nested+0x5b/0x80
> [ 2095.946104]  [<ffffffffa03335fa>] ? xfs_ilock+0xfa/0x260 [xfs]
> [ 2095.952632]  [<ffffffffa03335fa>] xfs_ilock+0xfa/0x260 [xfs]
> [ 2095.958968]  [<ffffffffa0333790>] xfs_ilock_data_map_shared+0x30/0x40
> [xfs]
> [ 2095.966752]  [<ffffffffa03128c6>] __xfs_get_blocks+0x96/0x9d0 [xfs]
> [ 2095.973753]  [<ffffffff8126462e>] ?
> mem_cgroup_event_ratelimit.isra.39+0x3e/0xb0
> [ 2095.982012]  [<ffffffff8126e8e5>] ? mem_cgroup_commit_charge+0x95/0x110
> [ 2095.989413]  [<ffffffffa0313214>] xfs_get_blocks+0x14/0x20 [xfs]
> [ 2095.996122]  [<ffffffff812cca44>] do_mpage_readpage+0x474/0x800
> [ 2096.002745]  [<ffffffffa0313200>] ? __xfs_get_blocks+0x9d0/0x9d0 [xfs]
> [ 2096.010037]  [<ffffffff81402fd7>] ? debug_smp_processor_id+0x17/0x20
> [ 2096.017136]  [<ffffffff811f3565>] ? __lru_cache_add+0x75/0xb0
> [ 2096.023551]  [<ffffffff811f45fe>] ? lru_cache_add+0xe/0x10
> [ 2096.029678]  [<ffffffff812ccf0d>] mpage_readpages+0x13d/0x1b0
> [ 2096.036109]  [<ffffffffa0313200>] ? __xfs_get_blocks+0x9d0/0x9d0 [xfs]
> [ 2096.043420]  [<ffffffffa0313200>] ? __xfs_get_blocks+0x9d0/0x9d0 [xfs]
> [ 2096.050724]  [<ffffffffa0311f14>] xfs_vm_readpages+0x54/0x170 [xfs]
> [ 2096.057724]  [<ffffffff811f1a1d>] __do_page_cache_readahead+0x2ad/0x370
> [ 2096.065113]  [<ffffffff811f18ec>] ? __do_page_cache_readahead+0x17c/0x370
> [ 2096.072693]  [<ffffffff8117729f>] ? __audit_syscall_entry+0xaf/0x100
> [ 2096.079787]  [<ffffffff811f2014>] force_page_cache_readahead+0x94/0xf0
> [ 2096.087077]  [<ffffffff811f2168>] SyS_readahead+0xa8/0xc0
> [ 2096.093106]  [<ffffffff81003c9c>] do_syscall_64+0x6c/0x1e0
> [ 2096.099234]  [<ffffffff817d4a3f>] entry_SYSCALL64_slow_path+0x25/0x25
> [ 2096.106427] 1 lock held by trinity-c9/3136:
> [ 2096.111097]  #0:  (&xfs_nondir_ilock_class){++++..}, at:
> [<ffffffffa03335fa>] xfs_ilock+0xfa/0x260 [xfs]
>
