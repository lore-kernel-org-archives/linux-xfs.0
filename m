Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p440s05S047627 for <xfs@oss.sgi.com>; Tue, 3 May 2011 19:54:00 -0500
Received: from audible.transient.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id AA1DB1E1BFA2
	for <xfs@oss.sgi.com>; Tue,  3 May 2011 17:57:36 -0700 (PDT)
Received: from audible.transient.net (audible.transient.net [216.254.12.79])
	by cuda.sgi.com with SMTP id kJDXG7HSj19Tcr6z for
	<xfs@oss.sgi.com>; Tue, 03 May 2011 17:57:36 -0700 (PDT)
Date: Wed, 4 May 2011 00:57:36 +0000
From: Jamie Heilman <jamie@audible.transient.net>
Subject: Re: 2.6.39-rc3, 2.6.39-rc4: XFS lockup - regression since 2.6.38
Message-ID: <20110504005736.GA2958@cucamonga.audible.transient.net>
References: <20110423224403.5fd1136a@neptune.home>
	<20110427050850.GG12436@dastard>
	<20110427182622.05a068a2@neptune.home>
	<20110428194528.GA1627@x4.trippels.de>
	<20110429011929.GA13542@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110429011929.GA13542@dastard>
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
To: linux-kernel@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, xfs-masters@oss.sgi.com, Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>, Alex Elder <aelder@sgi.com>, Markus Trippelsdorf <markus@trippelsdorf.de>

Dave Chinner wrote:
> OK, so the common elements here appears to be root filesystems
> with small log sizes, which means they are tail pushing all the
> time metadata operations are in progress. Definitely seems like a
> race in the AIL workqueue trigger mechanism. I'll see if I can
> reproduce this and cook up a patch to fix it.

Is there value in continuing to post sysrq-w, sysrq-l, xfs_info, and
other assorted feedback wrt this issue?  I've had it happen twice now
myself in the past week or so, though I have no reliable reproduction
technique.  Just wondering if more data points will help isolate the
cause, and if so, how to be prepared to get them.

For whatever its worth, my last lockup was while running
2.6.39-rc5-00127-g1be6a1f with a preempt config without cgroups.

root@cucamonga:~# grep xfs /proc/mounts 
/dev/mapper/S-root / xfs rw,relatime,attr2,delaylog,noquota 0 0
/dev/mapper/S-var /var xfs rw,noatime,attr2,delaylog,inode64,noquota 0 0
root@cucamonga:~# xfs_info /var
meta-data=/dev/mapper/S-var      isize=256    agcount=4, agsize=6553600 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=26214400, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=12800, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
root@cucamonga:~# xfs_info /
meta-data=/dev/mapper/S-root     isize=256    agcount=4, agsize=524288 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=2097152, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

those are lvm volumes on top of a md raid1 partition, though from the
looks of everybody else's reports, that's not likely relevant.

sysctl-w and l follow:

May  3 07:12:28 cucamonga kernel: SysRq : Show Blocked State
May  3 07:12:28 cucamonga kernel:   task                        PC stack   pid father
May  3 07:12:28 cucamonga kernel: mutt            D ffff88007bf89f40     0  2938   2921 0x00000000
May  3 07:12:28 cucamonga kernel:  ffff88007ac0fb28 0000000000000046 ffff88007ac0fae8 ffffffff81095066
May  3 07:12:28 cucamonga kernel:  ffff88007a8c4570 ffff88007ac0ffd8 00000000000112c0 ffff88007ac0ffd8
May  3 07:12:28 cucamonga kernel:  ffff88007f0dcbc0 ffff88007a8c4570 ffff88007ac0fbb8 ffffffff81098363
May  3 07:12:28 cucamonga kernel: Call Trace:
May  3 07:12:28 cucamonga kernel:  [<ffffffff81095066>] ? __pagevec_free+0x70/0x82
May  3 07:12:28 cucamonga kernel:  [<ffffffff81098363>] ? release_pages+0x181/0x193
May  3 07:12:28 cucamonga kernel:  [<ffffffffa007ef3c>] xlog_wait+0x5b/0x72 [xfs]
May  3 07:12:28 cucamonga kernel:  [<ffffffff8102e454>] ? try_to_wake_up+0x1bd/0x1bd
May  3 07:12:28 cucamonga kernel:  [<ffffffffa007ff60>] xlog_grant_log_space+0x129/0x3d6 [xfs]
May  3 07:12:28 cucamonga kernel:  [<ffffffffa008cc74>] ? xfs_ail_push+0x3c/0x6b [xfs]
May  3 07:12:28 cucamonga kernel:  [<ffffffffa0081e2c>] xfs_log_reserve+0xe5/0xee [xfs]
May  3 07:12:28 cucamonga kernel:  [<ffffffffa008b8ab>] xfs_trans_reserve+0xcf/0x19b [xfs]
May  3 07:12:28 cucamonga kernel:  [<ffffffffa008f7c4>] xfs_inactive+0x16a/0x39a [xfs]
May  3 07:12:28 cucamonga kernel:  [<ffffffffa009ab94>] xfs_fs_evict_inode+0xc7/0xcf [xfs]
May  3 07:12:28 cucamonga kernel:  [<ffffffff810de311>] evict+0x81/0x125
May  3 07:12:28 cucamonga kernel:  [<ffffffff810de53a>] iput+0x14b/0x153
May  3 07:12:28 cucamonga kernel:  [<ffffffff810db5b5>] dentry_kill+0x127/0x149
May  3 07:12:28 cucamonga kernel:  [<ffffffff810dbb1b>] dput+0xde/0xee
May  3 07:12:28 cucamonga kernel:  [<ffffffff810cc0e1>] fput+0x192/0x1aa
May  3 07:12:28 cucamonga kernel:  [<ffffffff810acb4b>] remove_vma+0x3c/0x64
May  3 07:12:28 cucamonga kernel:  [<ffffffff810adfa2>] exit_mmap+0xbe/0xd9
May  3 07:12:28 cucamonga kernel:  [<ffffffff8102fcfd>] mmput+0x5b/0x104
May  3 07:12:28 cucamonga kernel:  [<ffffffff81033976>] exit_mm+0x125/0x132
May  3 07:12:28 cucamonga kernel:  [<ffffffff810635a3>] ? acct_collect+0x176/0x182
May  3 07:12:28 cucamonga kernel:  [<ffffffff81034ebd>] do_exit+0x21d/0x70a
May  3 07:12:28 cucamonga kernel:  [<ffffffff810ca4b2>] ? fsnotify_modify+0x5f/0x67
May  3 07:12:28 cucamonga kernel:  [<ffffffffa03e7257>] ? kvm_on_user_return+0x4d/0x4f [kvm]
May  3 07:12:28 cucamonga kernel:  [<ffffffff8108e03f>] ? fire_user_return_notifiers+0x3c/0x65
May  3 07:12:28 cucamonga kernel:  [<ffffffff8103564d>] do_group_exit+0x76/0x9e
May  3 07:12:28 cucamonga kernel:  [<ffffffff8103568c>] sys_exit_group+0x17/0x17
May  3 07:12:28 cucamonga kernel:  [<ffffffff81334deb>] system_call_fastpath+0x16/0x1b
May  3 07:12:28 cucamonga kernel: kworker/1:0     D ffffffff81341180     0 24351      2 0x00000000
May  3 07:12:28 cucamonga kernel:  ffff8800046c1ca0 0000000000000046 ffff880000000000 0000000100000000
May  3 07:12:28 cucamonga kernel:  ffff88007c230ca0 ffff8800046c1fd8 00000000000112c0 ffff8800046c1fd8
May  3 07:12:28 cucamonga kernel:  ffff88007f0a3f20 ffff88007c230ca0 0000000000000000 0000000100000000
May  3 07:12:28 cucamonga kernel: Call Trace:
May  3 07:12:28 cucamonga kernel:  [<ffffffffa007ef3c>] xlog_wait+0x5b/0x72 [xfs]
May  3 07:12:28 cucamonga kernel:  [<ffffffff8102e454>] ? try_to_wake_up+0x1bd/0x1bd
May  3 07:12:28 cucamonga kernel:  [<ffffffffa007ff60>] xlog_grant_log_space+0x129/0x3d6 [xfs]
May  3 07:12:28 cucamonga kernel:  [<ffffffffa008cc74>] ? xfs_ail_push+0x3c/0x6b [xfs]
May  3 07:12:28 cucamonga kernel:  [<ffffffffa0081e2c>] xfs_log_reserve+0xe5/0xee [xfs]
May  3 07:12:28 cucamonga kernel:  [<ffffffffa008b8ab>] xfs_trans_reserve+0xcf/0x19b [xfs]
May  3 07:12:28 cucamonga kernel:  [<ffffffffa009c6aa>] ? xfs_reclaim_inode+0x23b/0x23b [xfs]
May  3 07:12:28 cucamonga kernel:  [<ffffffffa009c6aa>] ? xfs_reclaim_inode+0x23b/0x23b [xfs]
May  3 07:12:28 cucamonga kernel:  [<ffffffffa0075123>] xfs_fs_log_dummy+0x43/0x7f [xfs]
May  3 07:12:28 cucamonga kernel:  [<ffffffffa009c6ed>] xfs_sync_worker+0x43/0x69 [xfs]
May  3 07:12:28 cucamonga kernel:  [<ffffffff81047035>] process_one_work+0x179/0x295
May  3 07:12:28 cucamonga kernel:  [<ffffffff81048456>] worker_thread+0xd4/0x158
May  3 07:12:28 cucamonga kernel:  [<ffffffff81048382>] ? manage_workers.isra.23+0x170/0x170
May  3 07:12:28 cucamonga kernel:  [<ffffffff81048382>] ? manage_workers.isra.23+0x170/0x170
May  3 07:12:28 cucamonga kernel:  [<ffffffff8104b60c>] kthread+0x84/0x8c
May  3 07:12:28 cucamonga kernel:  [<ffffffff81335a54>] kernel_thread_helper+0x4/0x10
May  3 07:12:28 cucamonga kernel:  [<ffffffff8104b588>] ? kthread_worker_fn+0x116/0x116
May  3 07:12:28 cucamonga kernel:  [<ffffffff81335a50>] ? gs_change+0xb/0xb
May  3 07:12:28 cucamonga kernel: dpkg            D ffffffff81341180     0 28235  24677 0x00000000
May  3 07:12:28 cucamonga kernel:  ffff88001b70dc98 0000000000000082 0000000000000001 ffff880000000000
May  3 07:12:28 cucamonga kernel:  ffff88007f0a5eb0 ffff88001b70dfd8 00000000000112c0 ffff88001b70dfd8
May  3 07:12:28 cucamonga kernel:  ffffffff81499020 ffff88007f0a5eb0 ffff88001b70dc88 000000011b70dcc8
May  3 07:12:28 cucamonga kernel: Call Trace:
May  3 07:12:28 cucamonga kernel:  [<ffffffffa007ef3c>] xlog_wait+0x5b/0x72 [xfs]
May  3 07:12:28 cucamonga kernel:  [<ffffffff8102e454>] ? try_to_wake_up+0x1bd/0x1bd
May  3 07:12:28 cucamonga kernel:  [<ffffffffa008007e>] xlog_grant_log_space+0x247/0x3d6 [xfs]
May  3 07:12:28 cucamonga kernel:  [<ffffffffa008cc74>] ? xfs_ail_push+0x3c/0x6b [xfs]
May  3 07:12:28 cucamonga kernel:  [<ffffffffa0081e2c>] xfs_log_reserve+0xe5/0xee [xfs]
May  3 07:12:28 cucamonga kernel:  [<ffffffffa008b8ab>] xfs_trans_reserve+0xcf/0x19b [xfs]
May  3 07:12:28 cucamonga kernel:  [<ffffffffa008e390>] xfs_free_eofblocks+0x153/0x1e2 [xfs]
May  3 07:12:28 cucamonga kernel:  [<ffffffffa008f622>] xfs_release+0x178/0x1b0 [xfs]
May  3 07:12:28 cucamonga kernel:  [<ffffffffa00969e1>] xfs_file_release+0x15/0x19 [xfs]
May  3 07:12:28 cucamonga kernel:  [<ffffffff810cc04c>] fput+0xfd/0x1aa
May  3 07:12:28 cucamonga kernel:  [<ffffffff810c9120>] filp_close+0x6e/0x7a
May  3 07:12:28 cucamonga kernel:  [<ffffffff810c91d9>] sys_close+0xad/0xef
May  3 07:12:28 cucamonga kernel:  [<ffffffff81334deb>] system_call_fastpath+0x16/0x1b


May  3 07:22:26 cucamonga kernel: SysRq : Show backtrace of all active CPUs
May  3 07:22:26 cucamonga kernel: CPU1:
May  3 07:22:26 cucamonga kernel: CPU 1 
May  3 07:22:26 cucamonga kernel: Modules linked in: pci_slot fan cpufreq_stats cpufreq_powersave cpufreq_ondemand autofs4 cpufreq_conservative k
May  3 07:22:26 cucamonga kernel: 
May  3 07:22:26 cucamonga kernel: Pid: 0, comm: kworker/0:0 Not tainted 2.6.39-rc5-00127-g1be6a1f #1 Dell Inc. Precision WorkStation T3400  /0TP4
May  3 07:22:26 cucamonga kernel: RIP: 0010:[<ffffffff810081b2>]  [<ffffffff810081b2>] mwait_idle+0x7c/0x94
May  3 07:22:26 cucamonga kernel: RSP: 0018:ffff88007f0d1ee8  EFLAGS: 00000246
May  3 07:22:26 cucamonga kernel: RAX: 0000000000000000 RBX: ffffffff81592100 RCX: 0000000000000000
May  3 07:22:26 cucamonga kernel: RDX: 0000000000000000 RSI: 0000000000000003 RDI: ffff88007f0d0000
May  3 07:22:26 cucamonga kernel: RBP: ffff88007f0d1ee8 R08: 0000000000000000 R09: 0000000000000000
May  3 07:22:26 cucamonga kernel: R10: 0000000000000000 R11: ffff88007fb0dc50 R12: ffffffff8133468e
May  3 07:22:26 cucamonga kernel: R13: ffff88007f0d1e78 R14: 0000000000000086 R15: ffff88007fb11c00
May  3 07:22:26 cucamonga kernel: FS:  0000000000000000(0000) GS:ffff88007fb00000(0000) knlGS:0000000000000000
May  3 07:22:26 cucamonga kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
May  3 07:22:26 cucamonga kernel: CR2: 00007ffec6e368f0 CR3: 0000000004820000 CR4: 00000000000406f0
May  3 07:22:26 cucamonga kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
May  3 07:22:26 cucamonga kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
May  3 07:22:26 cucamonga kernel: Process kworker/0:0 (pid: 0, threadinfo ffff88007f0d0000, task ffff88007f0a3f20)
May  3 07:22:26 cucamonga kernel: Stack:
May  3 07:22:26 cucamonga kernel:  ffff88007f0d1f18 ffffffff810008ad ffff88007f0d1f08 57bb49c37cf88ea3
May  3 07:22:26 cucamonga kernel:  0000000000000001 0000000000000000 ffff88007f0d1f48 ffffffff81539e79
May  3 07:22:26 cucamonga kernel:  0000000000000000 3128fe8622c57963 0000000000000000 0000000000000000
May  3 07:22:26 cucamonga kernel: Call Trace:
May  3 07:22:26 cucamonga kernel:  [<ffffffff810008ad>] cpu_idle+0xa3/0xe9
May  3 07:22:26 cucamonga kernel:  [<ffffffff81539e79>] start_secondary+0x1bd/0x1c4
May  3 07:22:26 cucamonga kernel: Code: d2 65 48 8b 04 25 c8 b5 00 00 48 89 d1 48 2d c8 1f 00 00 0f 01 c8 0f ae f0 e8 52 fe ff ff 85 c0 75 0b 31 
May  3 07:22:26 cucamonga kernel: Call Trace:
May  3 07:22:26 cucamonga kernel:  [<ffffffff810008ad>] cpu_idle+0xa3/0xe9
May  3 07:22:26 cucamonga kernel:  [<ffffffff81539e79>] start_secondary+0x1bd/0x1c4
May  3 07:22:26 cucamonga kernel: CPU0:
May  3 07:22:26 cucamonga kernel:  ffff88007fa03ef0 ffff88007fa03f48 0000000000000046 ffff88007fa03f68
May  3 07:22:26 cucamonga kernel:  0000000000000001 ffff88007aabdc48 0000000000000001 ffff88007fa03f38
May  3 07:22:26 cucamonga kernel:  ffffffff810049a6 ffff88007fa03f58 ffffffff811acfb3 dead000000200200
May  3 07:22:26 cucamonga kernel: Call Trace:
May  3 07:22:26 cucamonga kernel:  <IRQ>  [<ffffffff810049a6>] ? show_stack+0x1c/0x1e
May  3 07:22:26 cucamonga kernel:  [<ffffffff811acfb3>] ? showacpu+0x4a/0x5d
May  3 07:22:26 cucamonga kernel:  [<ffffffff8105cb50>] ? generic_smp_call_function_single_interrupt+0xd3/0xf6
May  3 07:22:26 cucamonga kernel:  [<ffffffff81017a31>] ? smp_call_function_single_interrupt+0x18/0x27
May  3 07:22:26 cucamonga kernel:  [<ffffffff813357b3>] ? call_function_single_interrupt+0x13/0x20
May  3 07:22:26 cucamonga kernel:  <EOI>  [<ffffffff8133428c>] ? _raw_spin_unlock_irqrestore+0xd/0x30
May  3 07:22:26 cucamonga kernel:  [<ffffffff8104bc8c>] ? remove_wait_queue+0x51/0x56
May  3 07:22:26 cucamonga kernel:  [<ffffffff810d8c7d>] ? poll_freewait+0x3e/0xaa
May  3 07:22:26 cucamonga kernel:  [<ffffffff813338bd>] ? schedule_hrtimeout_range+0x13/0x15
May  3 07:22:26 cucamonga kernel:  [<ffffffff810d9457>] ? do_select+0x4df/0x4f4
May  3 07:22:26 cucamonga kernel:  [<ffffffff810d8ce9>] ? poll_freewait+0xaa/0xaa
May  3 07:22:26 cucamonga kernel:  [<ffffffff810d8db5>] ? __pollwait+0xcc/0xcc
May  3 07:22:26 cucamonga last message repeated 7 times
May  3 07:22:26 cucamonga kernel:  [<ffffffff810d95e3>] ? core_sys_select+0x177/0x216
May  3 07:22:26 cucamonga kernel:  [<ffffffff810c1f3c>] ? kmem_cache_free+0x79/0xbc
May  3 07:22:26 cucamonga kernel:  [<ffffffff812be2f9>] ? sock_destroy_inode+0x32/0x36
May  3 07:22:26 cucamonga kernel:  [<ffffffff81334274>] ? _raw_spin_unlock+0x23/0x2e
May  3 07:22:26 cucamonga kernel:  [<ffffffff810dbb0c>] ? dput+0xcf/0xee
May  3 07:22:26 cucamonga kernel:  [<ffffffff810d9713>] ? sys_select+0x91/0xb9
May  3 07:22:26 cucamonga kernel:  [<ffffffff810cada7>] ? sys_read+0x61/0x6e
May  3 07:22:26 cucamonga kernel:  [<ffffffff81334deb>] ? system_call_fastpath+0x16/0x1b


I have captures of my process list and slabinfo at the time of the lockup
too should they be useful.

-- 
Jamie Heilman                     http://audible.transient.net/~jamie/
"Most people wouldn't know music if it came up and bit them on the ass."
                                                        -Frank Zappa

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
