Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:38146 "EHLO
        mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751020AbcJDRjT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Oct 2016 13:39:19 -0400
Date: Tue, 4 Oct 2016 13:39:11 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
Message-ID: <1812816839.401734.1475602751170.JavaMail.zimbra@redhat.com>
In-Reply-To: <1937480340.100083.1475516965286.JavaMail.zimbra@redhat.com>
References: <CA+55aFxrqCng2Qxasc9pyMrKUGFjo==fEaFT1vkH9Lncte3RgQ@mail.gmail.com> <20160917190023.GA8039@ZenIV.linux.org.uk> <20160923190032.GA25771@ZenIV.linux.org.uk> <2131586457.763354.1475242373422.JavaMail.zimbra@redhat.com> <1415238593.811146.1475257337058.JavaMail.zimbra@redhat.com> <774397084.821469.1475260403929.JavaMail.zimbra@redhat.com> <20161003013737.GR19539@ZenIV.linux.org.uk> <1937480340.100083.1475516965286.JavaMail.zimbra@redhat.com>
Subject: local DoS - systemd hang or timeout (WAS: Re: [RFC][CFT]
 splice_read reworked)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel@vger.kernel.org, tj <tj@kernel.org>


> ----- Original Message -----
> > From: "Al Viro" <viro@ZenIV.linux.org.uk>
> > To: "CAI Qian" <caiqian@redhat.com>
> > Cc: "Linus Torvalds" <torvalds@linux-foundation.org>, "Dave Chinner"
> > <david@fromorbit.com>, "linux-xfs"
> > <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com, "Jens Axboe"
> > <axboe@kernel.dk>, "Nick Piggin" <npiggin@gmail.com>,
> > linux-fsdevel@vger.kernel.org
> > Sent: Sunday, October 2, 2016 9:37:37 PM
> > Subject: Re: [RFC][CFT] splice_read reworked
> > 
> > On Fri, Sep 30, 2016 at 02:33:23PM -0400, CAI Qian wrote:
> > 
> > OK, the immeditate trigger is
> > 	* sendfile() from something that uses seq_read to a regular file.
> > Does sb_start_write() around the call of do_splice_direct() (as always),
> > which ends up calling default_file_splice_read() (again, as usual), which
> > ends up calling ->read() of the source, i.e. seq_read().  No changes there.
> >  
> > 	* sb_start_write() can be called under ->i_mutex.  The latter is
> > on overlayfs inode, the former is done to upper layer in that overlayfs.
> > Nothing new, again.
> > 
> > 	* ->i_mutex can be taken under ->cred_guard_mutex.  Yes, it can -
> > in open_exec().  Again, no changes.
> > 
> > 	* ->cred_guard_mutex can be taken in ->show() of a seq_file,
> > namely /proc/*/auxv...  Argh, ->cred_guard_mutex whack-a-mole strikes
> > again...
> > 
> > OK, I think essentially the same warning had been triggerable since _way_
> > back.  All changes around splice have no effect on it.
> > 
> > Look: to get a deadlock we need
> > 	(1) sendfile from /proc/<pid>/auxv to a regular file on upper layer of
> > overlayfs requesting not to freeze the target.
> > 	(2) attempt to freeze it blocking until (1) is done.
> > 	(3) directory modification on overlayfs trying to request not to freeze
> > the upper layer and blocking until (2) is done.
> > 	(4) execve() in <pid> holding ->cred_guard_mutex, trying to open
> > something in overlayfs and getting blocked on directory lock, held by (3).
> > 
> > Now (1) gets around to reading from /proc/<pid>/auxv, which blocks on
> > ->cred_guard_mutex.  Mentioning of seq_read itself holding locks is
> > irrelevant;
> > what matters is that ->read() grabs ->cred_guard_mutex.
> > 
> > We used to have similar problems in /proc/*/environ and /proc/*/mem; looks
> > like /proc/*/environ needs to get the treatment similar to e268337dfe26 and
> > b409e578d9a4.
> > 
> You are right. This is also reproducible on v4.8 mainline.
Not sure if related, but right after this lockdep happened and trinity running by a
non-privileged user finished inside the container. The host's systemctl command just
hang or timeout which renders the whole system unusable.

# systemctl status docker
Failed to get properties: Connection timed out

# systemctl reboot (hang)

[ 5535.596651] INFO: task systemd-journal:1165 blocked for more than 120 seconds.
[ 5535.604728]       Tainted: G        W       4.8.0-rc8-fornext+ #1
[ 5535.611536] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 5535.620285] systemd-journal D ffff880466167ca8 12672  1165      1 0x00000000
[ 5535.628182]  ffff880466167ca8 ffff880466167cd0 0000000000000000 ffff88086c6e2000
[ 5535.636504]  ffff88045deb0000 ffff880466168000 ffffffff81deb380 ffff88045deb0000
[ 5535.644817]  0000000000000246 00000000ffffffff ffff880466167cc0 ffffffff817cdaaf
[ 5535.653131] Call Trace:
[ 5535.655874]  [<ffffffff817cdaaf>] schedule+0x3f/0xa0
[ 5535.661425]  [<ffffffff817cdf18>] schedule_preempt_disabled+0x18/0x30
[ 5535.668617]  [<ffffffff817cf4df>] mutex_lock_nested+0x19f/0x450
[ 5535.675237]  [<ffffffff81161d7e>] ? proc_cgroup_show+0x4e/0x300
[ 5535.681857]  [<ffffffff81252b01>] ? kmem_cache_alloc_trace+0x1d1/0x2e0
[ 5535.689162]  [<ffffffff81161d7e>] proc_cgroup_show+0x4e/0x300
[ 5535.695592]  [<ffffffff81302d40>] proc_single_show+0x50/0x90
[ 5535.701925]  [<ffffffff812ac983>] seq_read+0x113/0x3e0
[ 5535.707672]  [<ffffffff81280407>] __vfs_read+0x37/0x150
[ 5535.713521]  [<ffffffff81349ded>] ? security_file_permission+0x9d/0xc0
[ 5535.720819]  [<ffffffff812815ac>] vfs_read+0x8c/0x130
[ 5535.726472]  [<ffffffff81282ac8>] SyS_read+0x58/0xc0
[ 5535.732024]  [<ffffffff817d497c>] entry_SYSCALL_64_fastpath+0x1f/0xbd
[ 5535.739221] INFO: lockdep is turned off.
[ 5535.743649] INFO: task kworker/3:1:52401 blocked for more than 120 seconds.
[ 5535.751429]       Tainted: G        W       4.8.0-rc8-fornext+ #1
[ 5535.758239] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 5535.766989] kworker/3:1     D ffff8803b25bbca8 13368 52401      2 0x00000080
[ 5535.774904] Workqueue: cgroup_destroy css_release_work_fn
[ 5535.780940]  ffff8803b25bbca8 ffff8803b25bbcd0 0000000000000000 ffff88046ded2000
[ 5535.789254]  ffff88046af8a000 ffff8803b25bc000 ffffffff81deb380 ffff88046af8a000
[ 5535.797562]  0000000000000246 00000000ffffffff ffff8803b25bbcc0 ffffffff817cdaaf
[ 5535.805877] Call Trace:
[ 5535.808621]  [<ffffffff817cdaaf>] schedule+0x3f/0xa0
[ 5535.814177]  [<ffffffff817cdf18>] schedule_preempt_disabled+0x18/0x30
[ 5535.821379]  [<ffffffff817cf4df>] mutex_lock_nested+0x19f/0x450
[ 5535.828001]  [<ffffffff811586af>] ? css_release_work_fn+0x2f/0x110
[ 5535.834911]  [<ffffffff811586af>] css_release_work_fn+0x2f/0x110
[ 5535.841629]  [<ffffffff810bc83f>] process_one_work+0x1df/0x710
[ 5535.848159]  [<ffffffff810bc7c0>] ? process_one_work+0x160/0x710
[ 5535.854876]  [<ffffffff810bce9b>] worker_thread+0x12b/0x4a0
[ 5535.861119]  [<ffffffff810bcd70>] ? process_one_work+0x710/0x710
[ 5535.867847]  [<ffffffff810c3f7e>] kthread+0xfe/0x120
[ 5535.873404]  [<ffffffff817d40ec>] ? _raw_spin_unlock_irq+0x2c/0x60
[ 5535.880320]  [<ffffffff817d4baf>] ret_from_fork+0x1f/0x40
[ 5535.886369]  [<ffffffff810c3e80>] ? kthread_create_on_node+0x230/0x230
[ 5535.893675] INFO: lockdep is turned off.
[ 5535.898085] INFO: task kworker/45:4:146035 blocked for more than 120 seconds.
[ 5535.906059]       Tainted: G        W       4.8.0-rc8-fornext+ #1
[ 5535.912865] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 5535.921613] kworker/45:4    D ffff880853e9b950 14048 146035      2 0x00000080
[ 5535.929630] Workqueue: cgroup_destroy css_killed_work_fn
[ 5535.935582]  ffff880853e9b950 0000000000000000 0000000000000000 ffff88086c6da000
[ 5535.943882]  ffff88086c9e2000 ffff880853e9c000 ffff880853e9baa0 ffff88086c9e2000
[ 5535.952205]  ffff880853e9ba98 0000000000000001 ffff880853e9b968 ffffffff817cdaaf
[ 5535.960522] Call Trace:
[ 5535.963265]  [<ffffffff817cdaaf>] schedule+0x3f/0xa0
[ 5535.968817]  [<ffffffff817d33fb>] schedule_timeout+0x3db/0x6f0
[ 5535.975346]  [<ffffffff817cf055>] ? wait_for_completion+0x45/0x130
[ 5535.982256]  [<ffffffff817cf0d3>] wait_for_completion+0xc3/0x130
[ 5535.988972]  [<ffffffff810d1fd0>] ? wake_up_q+0x80/0x80
[ 5535.994804]  [<ffffffff8130de64>] drop_sysctl_table+0xc4/0xe0
[ 5536.001227]  [<ffffffff8130de17>] drop_sysctl_table+0x77/0xe0
[ 5536.007648]  [<ffffffff8130decd>] unregister_sysctl_table+0x4d/0xa0
[ 5536.014654]  [<ffffffff8130deff>] unregister_sysctl_table+0x7f/0xa0
[ 5536.021657]  [<ffffffff810f57f5>] unregister_sched_domain_sysctl+0x15/0x40
[ 5536.029344]  [<ffffffff810d7704>] partition_sched_domains+0x44/0x450
[ 5536.036447]  [<ffffffff817d0761>] ? __mutex_unlock_slowpath+0x111/0x1f0
[ 5536.043844]  [<ffffffff81167684>] rebuild_sched_domains_locked+0x64/0xb0
[ 5536.051336]  [<ffffffff8116789d>] update_flag+0x11d/0x210
[ 5536.057373]  [<ffffffff817cf61f>] ? mutex_lock_nested+0x2df/0x450
[ 5536.064186]  [<ffffffff81167acb>] ? cpuset_css_offline+0x1b/0x60
[ 5536.070899]  [<ffffffff810fce3d>] ? trace_hardirqs_on+0xd/0x10
[ 5536.077420]  [<ffffffff817cf61f>] ? mutex_lock_nested+0x2df/0x450
[ 5536.084234]  [<ffffffff8115a9f5>] ? css_killed_work_fn+0x25/0x220
[ 5536.091049]  [<ffffffff81167ae5>] cpuset_css_offline+0x35/0x60
[ 5536.097571]  [<ffffffff8115aa2c>] css_killed_work_fn+0x5c/0x220
[ 5536.104207]  [<ffffffff810bc83f>] process_one_work+0x1df/0x710
[ 5536.110736]  [<ffffffff810bc7c0>] ? process_one_work+0x160/0x710
[ 5536.117461]  [<ffffffff810bce9b>] worker_thread+0x12b/0x4a0
[ 5536.123697]  [<ffffffff810bcd70>] ? process_one_work+0x710/0x710
[ 5536.130426]  [<ffffffff810c3f7e>] kthread+0xfe/0x120
[ 5536.135991]  [<ffffffff817d4baf>] ret_from_fork+0x1f/0x40
[ 5536.142041]  [<ffffffff810c3e80>] ? kthread_create_on_node+0x230/0x230
[ 5536.149345] INFO: lockdep is turned off.
[ 5585.148183] perf: interrupt took too long (3146 > 3136), lowering kernel.perf_event_max_sample_rate to 63000
[ 5658.479538] INFO: task systemd:1 blocked for more than 120 seconds.
[ 5658.486551]       Tainted: G        W       4.8.0-rc8-fornext+ #1
[ 5658.493352] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 5658.502095] systemd         D ffff880468ccfca8 11952     1      0 0x00000000
[ 5658.509995]  ffff880468ccfca8 ffff880468ccfcd0 0000000000000000 ffff88046aa24000
[ 5658.518297]  ffff880468cd0000 ffff880468cd0000 ffffffff81deb380 ffff880468cd0000
[ 5658.526602]  0000000000000246 00000000ffffffff ffff880468ccfcc0 ffffffff817cdaaf
[ 5658.534909] Call Trace:
[ 5658.537645]  [<ffffffff817cdaaf>] schedule+0x3f/0xa0
[ 5658.543188]  [<ffffffff817cdf18>] schedule_preempt_disabled+0x18/0x30
[ 5658.550375]  [<ffffffff817cf4df>] mutex_lock_nested+0x19f/0x450
[ 5658.556987]  [<ffffffff81161d7e>] ? proc_cgroup_show+0x4e/0x300
[ 5658.563600]  [<ffffffff81252b01>] ? kmem_cache_alloc_trace+0x1d1/0x2e0
[ 5658.570887]  [<ffffffff81161d7e>] proc_cgroup_show+0x4e/0x300
[ 5658.577304]  [<ffffffff81302d40>] proc_single_show+0x50/0x90
[ 5658.583620]  [<ffffffff812ac983>] seq_read+0x113/0x3e0
[ 5658.589355]  [<ffffffff81280407>] __vfs_read+0x37/0x150
[ 5658.595189]  [<ffffffff81349ded>] ? security_file_permission+0x9d/0xc0
[ 5658.602480]  [<ffffffff812815ac>] vfs_read+0x8c/0x130
[ 5658.608117]  [<ffffffff81282ac8>] SyS_read+0x58/0xc0
[ 5658.613661]  [<ffffffff817d497c>] entry_SYSCALL_64_fastpath+0x1f/0xbd
[ 5658.620849] INFO: lockdep is turned off.
[ 5658.625282] INFO: task systemd-journal:1165 blocked for more than 120 seconds.
[ 5658.633346]       Tainted: G        W       4.8.0-rc8-fornext+ #1
[ 5658.640147] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 5658.648887] systemd-journal D ffff880466167ca8 12672  1165      1 0x00000000
[ 5658.656788]  ffff880466167ca8 ffff880466167cd0 0000000000000000 ffff88086c6e2000
[ 5658.665092]  ffff88045deb0000 ffff880466168000 ffffffff81deb380 ffff88045deb0000
[ 5658.673394]  0000000000000246 00000000ffffffff ffff880466167cc0 ffffffff817cdaaf
[ 5658.681690] Call Trace:
[ 5658.684419]  [<ffffffff817cdaaf>] schedule+0x3f/0xa0
[ 5658.689961]  [<ffffffff817cdf18>] schedule_preempt_disabled+0x18/0x30
[ 5658.697143]  [<ffffffff817cf4df>] mutex_lock_nested+0x19f/0x450
[ 5658.703766]  [<ffffffff81161d7e>] ? proc_cgroup_show+0x4e/0x300
[ 5658.710373]  [<ffffffff81252b01>] ? kmem_cache_alloc_trace+0x1d1/0x2e0
[ 5658.717661]  [<ffffffff81161d7e>] proc_cgroup_show+0x4e/0x300
[ 5658.724067]  [<ffffffff81302d40>] proc_single_show+0x50/0x90
[ 5658.730386]  [<ffffffff812ac983>] seq_read+0x113/0x3e0
[ 5658.736123]  [<ffffffff81280407>] __vfs_read+0x37/0x150
[ 5658.741957]  [<ffffffff81349ded>] ? security_file_permission+0x9d/0xc0
[ 5658.749244]  [<ffffffff812815ac>] vfs_read+0x8c/0x130
[ 5658.754884]  [<ffffffff81282ac8>] SyS_read+0x58/0xc0
[ 5658.760417]  [<ffffffff817d497c>] entry_SYSCALL_64_fastpath+0x1f/0xbd
[ 5658.767607] INFO: lockdep is turned off.
[ 5658.772016] INFO: task kworker/3:1:52401 blocked for more than 120 seconds.
[ 5658.779789]       Tainted: G        W       4.8.0-rc8-fornext+ #1
[ 5658.786582] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 5658.795322] kworker/3:1     D ffff8803b25bbca8 13368 52401      2 0x00000080
[ 5658.803224] Workqueue: cgroup_destroy css_release_work_fn
[ 5658.809261]  ffff8803b25bbca8 ffff8803b25bbcd0 0000000000000000 ffff88046ded2000
[ 5658.817567]  ffff88046af8a000 ffff8803b25bc000 ffffffff81deb380 ffff88046af8a000
[ 5658.825871]  0000000000000246 00000000ffffffff ffff8803b25bbcc0 ffffffff817cdaaf
[ 5658.834173] Call Trace:
[ 5658.836904]  [<ffffffff817cdaaf>] schedule+0x3f/0xa0
[ 5658.842447]  [<ffffffff817cdf18>] schedule_preempt_disabled+0x18/0x30
[ 5658.849638]  [<ffffffff817cf4df>] mutex_lock_nested+0x19f/0x450
[ 5658.856246]  [<ffffffff811586af>] ? css_release_work_fn+0x2f/0x110
[ 5658.863146]  [<ffffffff811586af>] css_release_work_fn+0x2f/0x110
[ 5658.869858]  [<ffffffff810bc83f>] process_one_work+0x1df/0x710
[ 5658.876370]  [<ffffffff810bc7c0>] ? process_one_work+0x160/0x710
[ 5658.883067]  [<ffffffff810bce9b>] worker_thread+0x12b/0x4a0
[ 5658.889287]  [<ffffffff810bcd70>] ? process_one_work+0x710/0x710
[ 5658.895991]  [<ffffffff810c3f7e>] kthread+0xfe/0x120
[ 5658.901538]  [<ffffffff817d40ec>] ? _raw_spin_unlock_irq+0x2c/0x60
[ 5658.908438]  [<ffffffff817d4baf>] ret_from_fork+0x1f/0x40
[ 5658.914466]  [<ffffffff810c3e80>] ? kthread_create_on_node+0x230/0x230
[ 5658.921745] INFO: lockdep is turned off.
[ 5658.926133] INFO: task kworker/45:4:146035 blocked for more than 120 seconds.
[ 5658.934099]       Tainted: G        W       4.8.0-rc8-fornext+ #1
[ 5658.940902] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 5658.949636] kworker/45:4    D ffff880853e9b950 14048 146035      2 0x00000080
[ 5658.957632] Workqueue: cgroup_destroy css_killed_work_fn
[ 5658.963574]  ffff880853e9b950 0000000000000000 0000000000000000 ffff88086c6da000
[ 5658.971877]  ffff88086c9e2000 ffff880853e9c000 ffff880853e9baa0 ffff88086c9e2000
[ 5658.980179]  ffff880853e9ba98 0000000000000001 ffff880853e9b968 ffffffff817cdaaf
[ 5658.988498] Call Trace:
[ 5658.991225]  [<ffffffff817cdaaf>] schedule+0x3f/0xa0
[ 5658.996768]  [<ffffffff817d33fb>] schedule_timeout+0x3db/0x6f0
[ 5659.003271]  [<ffffffff817cf055>] ? wait_for_completion+0x45/0x130
[ 5659.010161]  [<ffffffff817cf0d3>] wait_for_completion+0xc3/0x130
[ 5659.016871]  [<ffffffff810d1fd0>] ? wake_up_q+0x80/0x80
[ 5659.022706]  [<ffffffff8130de64>] drop_sysctl_table+0xc4/0xe0
[ 5659.029120]  [<ffffffff8130de17>] drop_sysctl_table+0x77/0xe0
[ 5659.035535]  [<ffffffff8130decd>] unregister_sysctl_table+0x4d/0xa0
[ 5659.042529]  [<ffffffff8130deff>] unregister_sysctl_table+0x7f/0xa0
[ 5659.049528]  [<ffffffff810f57f5>] unregister_sched_domain_sysctl+0x15/0x40
[ 5659.057203]  [<ffffffff810d7704>] partition_sched_domains+0x44/0x450
[ 5659.064297]  [<ffffffff817d0761>] ? __mutex_unlock_slowpath+0x111/0x1f0
[ 5659.071673]  [<ffffffff81167684>] rebuild_sched_domains_locked+0x64/0xb0
[ 5659.079144]  [<ffffffff8116789d>] update_flag+0x11d/0x210
[ 5659.085172]  [<ffffffff817cf61f>] ? mutex_lock_nested+0x2df/0x450
[ 5659.091964]  [<ffffffff81167acb>] ? cpuset_css_offline+0x1b/0x60
[ 5659.098668]  [<ffffffff810fce3d>] ? trace_hardirqs_on+0xd/0x10
[ 5659.105179]  [<ffffffff817cf61f>] ? mutex_lock_nested+0x2df/0x450
[ 5659.111982]  [<ffffffff8115a9f5>] ? css_killed_work_fn+0x25/0x220
[ 5659.118783]  [<ffffffff81167ae5>] cpuset_css_offline+0x35/0x60
[ 5659.125296]  [<ffffffff8115aa2c>] css_killed_work_fn+0x5c/0x220
[ 5659.131906]  [<ffffffff810bc83f>] process_one_work+0x1df/0x710
[ 5659.138417]  [<ffffffff810bc7c0>] ? process_one_work+0x160/0x710
[ 5659.145124]  [<ffffffff810bce9b>] worker_thread+0x12b/0x4a0
[ 5659.151345]  [<ffffffff810bcd70>] ? process_one_work+0x710/0x710
[ 5659.158044]  [<ffffffff810c3f7e>] kthread+0xfe/0x120
[ 5659.163586]  [<ffffffff817d4baf>] ret_from_fork+0x1f/0x40
[ 5659.169605]  [<ffffffff810c3e80>] ? kthread_create_on_node+0x230/0x230
[ 5659.176892] INFO: lockdep is turned off.
[ 5781.364367] INFO: task systemd:1 blocked for more than 120 seconds.
[ 5781.371373]       Tainted: G        W       4.8.0-rc8-fornext+ #1
[ 5781.378177] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 5781.386918] systemd         D ffff880468ccfca8 11952     1      0 0x00000000
[ 5781.394818]  ffff880468ccfca8 ffff880468ccfcd0 0000000000000000 ffff88046aa24000
[ 5781.403121]  ffff880468cd0000 ffff880468cd0000 ffffffff81deb380 ffff880468cd0000
[ 5781.411421]  0000000000000246 00000000ffffffff ffff880468ccfcc0 ffffffff817cdaaf
[ 5781.419725] Call Trace:
[ 5781.422460]  [<ffffffff817cdaaf>] schedule+0x3f/0xa0
[ 5781.428003]  [<ffffffff817cdf18>] schedule_preempt_disabled+0x18/0x30
[ 5781.435192]  [<ffffffff817cf4df>] mutex_lock_nested+0x19f/0x450
[ 5781.441801]  [<ffffffff81161d7e>] ? proc_cgroup_show+0x4e/0x300
[ 5781.448404]  [<ffffffff81252b01>] ? kmem_cache_alloc_trace+0x1d1/0x2e0
[ 5781.455691]  [<ffffffff81161d7e>] proc_cgroup_show+0x4e/0x300
[ 5781.462109]  [<ffffffff81302d40>] proc_single_show+0x50/0x90
[ 5781.468428]  [<ffffffff812ac983>] seq_read+0x113/0x3e0
[ 5781.474165]  [<ffffffff81280407>] __vfs_read+0x37/0x150
[ 5781.479991]  [<ffffffff81349ded>] ? security_file_permission+0x9d/0xc0
[ 5781.487277]  [<ffffffff812815ac>] vfs_read+0x8c/0x130
[ 5781.492914]  [<ffffffff81282ac8>] SyS_read+0x58/0xc0
[ 5781.498455]  [<ffffffff817d497c>] entry_SYSCALL_64_fastpath+0x1f/0xbd
[ 5781.505646] INFO: lockdep is turned off.
[ 5781.510085] INFO: task systemd-journal:1165 blocked for more than 120 seconds.
[ 5781.518146]       Tainted: G        W       4.8.0-rc8-fornext+ #1
[ 5781.524946] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 5781.533686] systemd-journal D ffff880466167ca8 12672  1165      1 0x00000000
[ 5781.541581]  ffff880466167ca8 ffff880466167cd0 0000000000000000 ffff88086c6e2000
[ 5781.549880]  ffff88045deb0000 ffff880466168000 ffffffff81deb380 ffff88045deb0000
[ 5781.558186]  0000000000000246 00000000ffffffff ffff880466167cc0 ffffffff817cdaaf
[ 5781.566493] Call Trace:
[ 5781.569222]  [<ffffffff817cdaaf>] schedule+0x3f/0xa0
[ 5781.574764]  [<ffffffff817cdf18>] schedule_preempt_disabled+0x18/0x30
[ 5781.581953]  [<ffffffff817cf4df>] mutex_lock_nested+0x19f/0x450
[ 5781.588559]  [<ffffffff81161d7e>] ? proc_cgroup_show+0x4e/0x300
[ 5781.595166]  [<ffffffff81252b01>] ? kmem_cache_alloc_trace+0x1d1/0x2e0
[ 5781.602451]  [<ffffffff81161d7e>] proc_cgroup_show+0x4e/0x300
[ 5781.608864]  [<ffffffff81302d40>] proc_single_show+0x50/0x90
[ 5781.615182]  [<ffffffff812ac983>] seq_read+0x113/0x3e0
[ 5781.620916]  [<ffffffff81280407>] __vfs_read+0x37/0x150
[ 5781.626749]  [<ffffffff81349ded>] ? security_file_permission+0x9d/0xc0
[ 5781.634035]  [<ffffffff812815ac>] vfs_read+0x8c/0x130
[ 5781.639673]  [<ffffffff81282ac8>] SyS_read+0x58/0xc0
[ 5781.645215]  [<ffffffff817d497c>] entry_SYSCALL_64_fastpath+0x1f/0xbd
[ 5781.652403] INFO: lockdep is turned off.
[ 5781.656811] INFO: task kworker/3:1:52401 blocked for more than 120 seconds.
[ 5781.664583]       Tainted: G        W       4.8.0-rc8-fornext+ #1
[ 5781.671383] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 5781.680121] kworker/3:1     D ffff8803b25bbca8 13368 52401      2 0x00000080
[ 5781.688021] Workqueue: cgroup_destroy css_release_work_fn
[ 5781.694057]  ffff8803b25bbca8 ffff8803b25bbcd0 0000000000000000 ffff88046ded2000
[ 5781.702356]  ffff88046af8a000 ffff8803b25bc000 ffffffff81deb380 ffff88046af8a000
[ 5781.710656]  0000000000000246 00000000ffffffff ffff8803b25bbcc0 ffffffff817cdaaf
[ 5781.718954] Call Trace:
[ 5781.721684]  [<ffffffff817cdaaf>] schedule+0x3f/0xa0
[ 5781.727224]  [<ffffffff817cdf18>] schedule_preempt_disabled+0x18/0x30
[ 5781.734414]  [<ffffffff817cf4df>] mutex_lock_nested+0x19f/0x450
[ 5781.741021]  [<ffffffff811586af>] ? css_release_work_fn+0x2f/0x110
[ 5781.747919]  [<ffffffff811586af>] css_release_work_fn+0x2f/0x110
[ 5781.754626]  [<ffffffff810bc83f>] process_one_work+0x1df/0x710
[ 5781.761137]  [<ffffffff810bc7c0>] ? process_one_work+0x160/0x710
[ 5781.767841]  [<ffffffff810bce9b>] worker_thread+0x12b/0x4a0
[ 5781.774061]  [<ffffffff810bcd70>] ? process_one_work+0x710/0x710
[ 5781.780765]  [<ffffffff810c3f7e>] kthread+0xfe/0x120
[ 5781.786304]  [<ffffffff817d40ec>] ? _raw_spin_unlock_irq+0x2c/0x60
[ 5781.793203]  [<ffffffff817d4baf>] ret_from_fork+0x1f/0x40
[ 5781.799229]  [<ffffffff810c3e80>] ? kthread_create_on_node+0x230/0x230
[ 5781.806514] INFO: lockdep is turned off.
