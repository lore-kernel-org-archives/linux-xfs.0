Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx5-phx2.redhat.com ([209.132.183.37]:42343 "EHLO
        mx5-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752545AbcJES5K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Oct 2016 14:57:10 -0400
Date: Wed, 5 Oct 2016 14:57:04 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
Message-ID: <874538236.682217.1475693824077.JavaMail.zimbra@redhat.com>
In-Reply-To: <270577901.647921.1475682888765.JavaMail.zimbra@redhat.com>
References: <CA+55aFxrqCng2Qxasc9pyMrKUGFjo==fEaFT1vkH9Lncte3RgQ@mail.gmail.com> <20161003013737.GR19539@ZenIV.linux.org.uk> <1937480340.100083.1475516965286.JavaMail.zimbra@redhat.com> <1812816839.401734.1475602751170.JavaMail.zimbra@redhat.com> <20161004214219.GN4205@htj.duckdns.org> <1238277728.610186.1475676579513.JavaMail.zimbra@redhat.com> <20161005153014.GC26977@htj.duckdns.org> <270577901.647921.1475682888765.JavaMail.zimbra@redhat.com>
Subject: Re: local DoS - systemd hang or timeout (WAS: Re: [RFC][CFT]
 splice_read reworked)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: tj <tj@kernel.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel@vger.kernel.org



----- Original Message -----
> From: "CAI Qian" <caiqian@redhat.com>
> To: "tj" <tj@kernel.org>
> Cc: "Al Viro" <viro@ZenIV.linux.org.uk>, "Linus Torvalds" <torvalds@linux-foundation.org>, "Dave Chinner"
> <david@fromorbit.com>, "linux-xfs" <linux-xfs@vger.kernel.org>, "Jens Axboe" <axboe@kernel.dk>, "Nick Piggin"
> <npiggin@gmail.com>, linux-fsdevel@vger.kernel.org
> Sent: Wednesday, October 5, 2016 11:54:48 AM
> Subject: Re: local DoS - systemd hang or timeout (WAS: Re: [RFC][CFT] splice_read reworked)
> 
> 
> 
> ----- Original Message -----
> > From: "tj" <tj@kernel.org>
> > To: "CAI Qian" <caiqian@redhat.com>
> > Cc: "Al Viro" <viro@ZenIV.linux.org.uk>, "Linus Torvalds"
> > <torvalds@linux-foundation.org>, "Dave Chinner"
> > <david@fromorbit.com>, "linux-xfs" <linux-xfs@vger.kernel.org>, "Jens
> > Axboe" <axboe@kernel.dk>, "Nick Piggin"
> > <npiggin@gmail.com>, linux-fsdevel@vger.kernel.org
> > Sent: Wednesday, October 5, 2016 11:30:14 AM
> > Subject: Re: local DoS - systemd hang or timeout (WAS: Re: [RFC][CFT]
> > splice_read reworked)
> > 
> > Hello, CAI.
> > 
> > On Wed, Oct 05, 2016 at 10:09:39AM -0400, CAI Qian wrote:
> > > > This one seems to be the offender.  cgroup is trying to offline a
> > > > cpuset css, which takes place under cgroup_mutex.  The offlining ends
> > > > up trying to drain active usages of a sysctl table which apprently is
> > > > not happening.  Did something hang or crash while trying to generate
> > > > sysctl content?
> > >
> > > Hmm, I am not sure, since the trinity was running from an non-privileged
> > > user which can only read content from /proc or /sys.
> > 
> > So, userland, priviledged or not, can't cause this.  The ref is held
> > only while the kernel code is operating to generate content or
> > iterating, which shouldn't be affected by userland actions.  This is
> > caused by kernel code hanging or crashing while holding a ref.
> Right, the trinity calls many different random syscalls and options on those
> /proc/ and /sys/ files and generate lots of different errno. It is likely
> some of error-path out there causes hang or crash.
Tejun,

Not sure if this related, and there is always a lockdep regards procfs happened
below unless masking by other lockdep issues before the cgroup hang. Also, this
hang is always reproducible.

[ 4787.875980] 
[ 4787.877645] ======================================================
[ 4787.884540] [ INFO: possible circular locking dependency detected ]
[ 4787.891533] 4.8.0-rc8-usrns-scale+ #8 Tainted: G        W      
[ 4787.898138] -------------------------------------------------------
[ 4787.905130] trinity-c116/106905 is trying to acquire lock:
[ 4787.911251]  (&p->lock){+.+.+.}, at: [<ffffffff812aca8c>] seq_read+0x4c/0x3e0
[ 4787.919264] 
[ 4787.919264] but task is already holding lock:
[ 4787.925773]  (sb_writers#8){.+.+.+}, at: [<ffffffff81284367>] __sb_start_write+0xb7/0xf0
[ 4787.934854] 
[ 4787.934854] which lock already depends on the new lock.
[ 4787.934854] 
[ 4787.943981] 
[ 4787.943981] the existing dependency chain (in reverse order) is:
[ 4787.952333] 
-> #3 (sb_writers#8){.+.+.+}:
[ 4787.957050]        [<ffffffff810fd711>] __lock_acquire+0x3f1/0x7f0
[ 4787.963960]        [<ffffffff810fe166>] lock_acquire+0xd6/0x240
[ 4787.970577]        [<ffffffff810f769a>] percpu_down_read+0x4a/0xa0
[ 4787.977487]        [<ffffffff81284367>] __sb_start_write+0xb7/0xf0
[ 4787.984395]        [<ffffffff812a8974>] mnt_want_write+0x24/0x50
[ 4787.991110]        [<ffffffffa05049af>] ovl_want_write+0x1f/0x30 [overlay]
[ 4787.998799]        [<ffffffffa05070c2>] ovl_do_remove+0x42/0x4a0 [overlay]
[ 4788.006483]        [<ffffffffa0507536>] ovl_rmdir+0x16/0x20 [overlay]
[ 4788.013682]        [<ffffffff8128d357>] vfs_rmdir+0xb7/0x130
[ 4788.020009]        [<ffffffff81292ed3>] do_rmdir+0x183/0x1f0
[ 4788.026335]        [<ffffffff81293cf2>] SyS_unlinkat+0x22/0x30
[ 4788.032853]        [<ffffffff81003f8c>] do_syscall_64+0x6c/0x1e0
[ 4788.039576]        [<ffffffff817d927f>] return_from_SYSCALL_64+0x0/0x7a
[ 4788.046962] 
-> #2 (&sb->s_type->i_mutex_key#16){++++++}:
[ 4788.053140]        [<ffffffff810fd711>] __lock_acquire+0x3f1/0x7f0
[ 4788.060049]        [<ffffffff810fe166>] lock_acquire+0xd6/0x240
[ 4788.066664]        [<ffffffff817d60e7>] down_read+0x47/0x70
[ 4788.072893]        [<ffffffff8128ce79>] lookup_slow+0xc9/0x200
[ 4788.079410]        [<ffffffff81290b9c>] walk_component+0x1ec/0x310
[ 4788.086315]        [<ffffffff81290e5f>] link_path_walk+0x19f/0x5f0
[ 4788.093219]        [<ffffffff8129151d>] path_openat+0xdd/0xb80
[ 4788.099748]        [<ffffffff81293511>] do_filp_open+0x91/0x100
[ 4788.106362]        [<ffffffff81286f56>] do_open_execat+0x76/0x180
[ 4788.113186]        [<ffffffff8128747b>] open_exec+0x2b/0x50
[ 4788.119404]        [<ffffffff812ec61d>] load_elf_binary+0x28d/0x1120
[ 4788.126511]        [<ffffffff81288487>] search_binary_handler+0x97/0x1c0
[ 4788.134002]        [<ffffffff81289619>] do_execveat_common.isra.36+0x6a9/0x9f0
[ 4788.142071]        [<ffffffff81289c4a>] SyS_execve+0x3a/0x50
[ 4788.148398]        [<ffffffff81003f8c>] do_syscall_64+0x6c/0x1e0
[ 4788.155110]        [<ffffffff817d927f>] return_from_SYSCALL_64+0x0/0x7a
[ 4788.162502] 
-> #1 (&sig->cred_guard_mutex){+.+.+.}:
[ 4788.168179]        [<ffffffff810fd711>] __lock_acquire+0x3f1/0x7f0
[ 4788.175085]        [<ffffffff810fe166>] lock_acquire+0xd6/0x240
[ 4788.181712]        [<ffffffff817d4557>] mutex_lock_killable_nested+0x87/0x500
[ 4788.189695]        [<ffffffff81099599>] mm_access+0x29/0xa0
[ 4788.195924]        [<ffffffff81302b6c>] proc_pid_auxv+0x1c/0x70
[ 4788.202540]        [<ffffffff813039d0>] proc_single_show+0x50/0x90
[ 4788.209445]        [<ffffffff812acb48>] seq_read+0x108/0x3e0
[ 4788.215774]        [<ffffffff8127fb07>] __vfs_read+0x37/0x150
[ 4788.222198]        [<ffffffff81280d35>] vfs_read+0x95/0x140
[ 4788.228425]        [<ffffffff81282268>] SyS_read+0x58/0xc0
[ 4788.234557]        [<ffffffff81003f8c>] do_syscall_64+0x6c/0x1e0
[ 4788.241268]        [<ffffffff817d927f>] return_from_SYSCALL_64+0x0/0x7a
[ 4788.248660] 
-> #0 (&p->lock){+.+.+.}:
[ 4788.252987]        [<ffffffff810fc062>] validate_chain.isra.37+0xe72/0x1150
[ 4788.260769]        [<ffffffff810fd711>] __lock_acquire+0x3f1/0x7f0
[ 4788.267676]        [<ffffffff810fe166>] lock_acquire+0xd6/0x240
[ 4788.274302]        [<ffffffff817d3807>] mutex_lock_nested+0x77/0x430
[ 4788.281406]        [<ffffffff812aca8c>] seq_read+0x4c/0x3e0
[ 4788.287633]        [<ffffffff81316b39>] kernfs_fop_read+0x129/0x1b0
[ 4788.294659]        [<ffffffff8127fca3>] do_loop_readv_writev+0x83/0xc0
[ 4788.301954]        [<ffffffff812811a8>] do_readv_writev+0x218/0x240
[ 4788.308959]        [<ffffffff81281209>] vfs_readv+0x39/0x50
[ 4788.315188]        [<ffffffff812bc6b1>] default_file_splice_read+0x1a1/0x2b0
[ 4788.323070]        [<ffffffff812bc206>] do_splice_to+0x76/0x90
[ 4788.329587]        [<ffffffff812bc2db>] splice_direct_to_actor+0xbb/0x220
[ 4788.337173]        [<ffffffff812bc4d8>] do_splice_direct+0x98/0xd0
[ 4788.344078]        [<ffffffff81281dd1>] do_sendfile+0x1d1/0x3b0
[ 4788.350694]        [<ffffffff812829c9>] SyS_sendfile64+0xc9/0xd0
[ 4788.357405]        [<ffffffff81003f8c>] do_syscall_64+0x6c/0x1e0
[ 4788.364119]        [<ffffffff817d927f>] return_from_SYSCALL_64+0x0/0x7a
[ 4788.371511] 
[ 4788.371511] other info that might help us debug this:
[ 4788.371511] 
[ 4788.380443] Chain exists of:
  &p->lock --> &sb->s_type->i_mutex_key#16 --> sb_writers#8

[ 4788.389881]  Possible unsafe locking scenario:
[ 4788.389881] 
[ 4788.396497]        CPU0                    CPU1
[ 4788.401549]        ----                    ----
[ 4788.406614]   lock(sb_writers#8);
[ 4788.410352]                                lock(&sb->s_type->i_mutex_key#16);
[ 4788.418354]                                lock(sb_writers#8);
[ 4788.424902]   lock(&p->lock);
[ 4788.428229] 
[ 4788.428229]  *** DEADLOCK ***
[ 4788.428229] 
[ 4788.434836] 1 lock held by trinity-c116/106905:
[ 4788.439888]  #0:  (sb_writers#8){.+.+.+}, at: [<ffffffff81284367>] __sb_start_write+0xb7/0xf0
[ 4788.449473] 
[ 4788.449473] stack backtrace:
[ 4788.454334] CPU: 16 PID: 106905 Comm: trinity-c116 Tainted: G        W       4.8.0-rc8-usrns-scale+ #8
[ 4788.464719] Hardware name: Intel Corporation S2600WTT/S2600WTT, BIOS GRNDSDP1.86B.0044.R00.1501191641 01/19/2015
[ 4788.476076]  0000000000000086 00000000cbfc6314 ffff8803ce78b760 ffffffff813d5e93
[ 4788.484371]  ffffffff82a3fbd0 ffffffff82a94890 ffff8803ce78b7a0 ffffffff810fa6ec
[ 4788.492663]  ffff8803ce78b7e0 ffff8802ead08000 0000000000000001 ffff8802ead08ca0
[ 4788.500966] Call Trace:
[ 4788.503694]  [<ffffffff813d5e93>] dump_stack+0x85/0xc2
[ 4788.509426]  [<ffffffff810fa6ec>] print_circular_bug+0x1ec/0x260
[ 4788.516128]  [<ffffffff810fc062>] validate_chain.isra.37+0xe72/0x1150
[ 4788.523319]  [<ffffffff811d4491>] ? ___perf_sw_event+0x171/0x290
[ 4788.530022]  [<ffffffff810fd711>] __lock_acquire+0x3f1/0x7f0
[ 4788.536335]  [<ffffffff810fe166>] lock_acquire+0xd6/0x240
[ 4788.542359]  [<ffffffff812aca8c>] ? seq_read+0x4c/0x3e0
[ 4788.548188]  [<ffffffff812aca8c>] ? seq_read+0x4c/0x3e0
[ 4788.554019]  [<ffffffff817d3807>] mutex_lock_nested+0x77/0x430
[ 4788.560528]  [<ffffffff812aca8c>] ? seq_read+0x4c/0x3e0
[ 4788.566358]  [<ffffffff812aca8c>] seq_read+0x4c/0x3e0
[ 4788.571995]  [<ffffffff81316a10>] ? kernfs_fop_open+0x3a0/0x3a0
[ 4788.578600]  [<ffffffff81316b39>] kernfs_fop_read+0x129/0x1b0
[ 4788.585012]  [<ffffffff81316a10>] ? kernfs_fop_open+0x3a0/0x3a0
[ 4788.591617]  [<ffffffff8127fca3>] do_loop_readv_writev+0x83/0xc0
[ 4788.598318]  [<ffffffff81316a10>] ? kernfs_fop_open+0x3a0/0x3a0
[ 4788.604924]  [<ffffffff812811a8>] do_readv_writev+0x218/0x240
[ 4788.611347]  [<ffffffff813e9535>] ? push_pipe+0xd5/0x190
[ 4788.617278]  [<ffffffff813ecec0>] ? iov_iter_get_pages_alloc+0x250/0x400
[ 4788.624746]  [<ffffffff81281209>] vfs_readv+0x39/0x50
[ 4788.630381]  [<ffffffff812bc6b1>] default_file_splice_read+0x1a1/0x2b0
[ 4788.637668]  [<ffffffff8134ae20>] ? security_file_permission+0xa0/0xc0
[ 4788.644954]  [<ffffffff812bc206>] do_splice_to+0x76/0x90
[ 4788.650880]  [<ffffffff812bc2db>] splice_direct_to_actor+0xbb/0x220
[ 4788.657872]  [<ffffffff812bba80>] ? generic_pipe_buf_nosteal+0x10/0x10
[ 4788.665157]  [<ffffffff812bc4d8>] do_splice_direct+0x98/0xd0
[ 4788.671472]  [<ffffffff81281dd1>] do_sendfile+0x1d1/0x3b0
[ 4788.677499]  [<ffffffff812829c9>] SyS_sendfile64+0xc9/0xd0
[ 4788.683622]  [<ffffffff81003f8c>] do_syscall_64+0x6c/0x1e0
[ 4788.689744]  [<ffffffff817d927f>] entry_SYSCALL64_slow_path+0x25/0x25
