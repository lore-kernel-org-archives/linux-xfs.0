Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3SJfxu7019476 for <xfs@oss.sgi.com>; Thu, 28 Apr 2011 14:42:00 -0500
Received: from mail.ud10.udmedia.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 846AA149DAB4
	for <xfs@oss.sgi.com>; Thu, 28 Apr 2011 12:45:30 -0700 (PDT)
Received: from mail.ud10.udmedia.de (ud10.udmedia.de [194.117.254.50]) by
	cuda.sgi.com with ESMTP id ongenQM63JMujZqW for
	<xfs@oss.sgi.com>; Thu, 28 Apr 2011 12:45:30 -0700 (PDT)
Date: Thu, 28 Apr 2011 21:45:28 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: 2.6.39-rc3, 2.6.39-rc4: XFS lockup - regression since 2.6.38
Message-ID: <20110428194528.GA1627@x4.trippels.de>
References: <20110423224403.5fd1136a@neptune.home>
	<20110427050850.GG12436@dastard>
	<20110427182622.05a068a2@neptune.home>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110427182622.05a068a2@neptune.home>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, xfs-masters@oss.sgi.com, Alex Elder <aelder@sgi.com>

On 2011.04.27 at 18:26 +0200, Bruno Pr=E9mont wrote:
> On Wed, 27 April 2011 Dave Chinner <david@fromorbit.com> wrote:
> > On Sat, Apr 23, 2011 at 10:44:03PM +0200, Bruno Pr=E9mont wrote:
> > > Running 2.6.39-rc3+ and now again on 2.6.39-rc4+ (I've not tested -rc1
> > > or -rc2) I've hit a "dying machine" where processes writing to disk e=
nd
> > > up in D state.
> > > From occurrence with -rc3+ I don't have logs as those never hit the d=
isk,
> > > for -rc4+ I have the following (sysrq+t was too big, what I have of it
> > > misses a dozen of kernel tasks - if needed, please ask):
> > > =

> > > The -rc4 kernel is at commit 584f79046780e10cb24367a691f8c28398a00e84
> > > (+ 1 patch of mine to stop disk on reboot),
> > > full dmesg available if needed; kernel config attached (only selected
> > > options). In case there is something I should do at next occurrence
> > > please tell. Unfortunately I have no trigger for it and it does not
> > > happen very often.
> > > =

> > > [    0.000000] Linux version 2.6.39-rc4-00120-g73b5b55 (kbuild@neptun=
e) (gcc version 4.4.5 (Gentoo 4.4.5 p1.2, pie-0.4.5) ) #12 Thu Apr 21 19:28=
:45 CEST 2011
> > > =

> > > =

> > > [32040.120055] INFO: task flush-8:0:1665 blocked for more than 120 se=
conds.
> > > [32040.120068] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" dis=
ables this message.
> > > [32040.120077] flush-8:0       D 00000000  4908  1665      2 0x000000=
00
> > > [32040.120099]  f55efb5c 00000046 00000000 00000000 00000000 00000001=
 e0382924 00000000
> > > [32040.120118]  f55efb0c f55efb5c 00000004 f629ba70 572f01a2 00001cfe=
 f629ba70 ffffffc0
> > > [32040.120135]  f55efc68 f55efb30 f889d7f8 f55efb20 00000000 f55efc68=
 e0382900 f55efc94
> > > [32040.120153] Call Trace:
> > > [32040.120220]  [<f889d7f8>] ? xfs_bmap_search_multi_extents+0x88/0xe=
0 [xfs]
> > > [32040.120239]  [<c109ce1d>] ? kmem_cache_alloc+0x2d/0x110
> > > [32040.120294]  [<f88c88ca>] ? xlog_space_left+0x2a/0xc0 [xfs]
> > > [32040.120346]  [<f88c85cb>] xlog_wait+0x4b/0x70 [xfs]
> > > [32040.120359]  [<c102ca00>] ? try_to_wake_up+0xc0/0xc0
> > > [32040.120411]  [<f88c948b>] xlog_grant_log_space+0x8b/0x240 [xfs]
> > > [32040.120464]  [<f88c936e>] ? xlog_grant_push_ail+0xbe/0xf0 [xfs]
> > > [32040.120516]  [<f88c99db>] xfs_log_reserve+0xab/0xb0 [xfs]
> > > [32040.120571]  [<f88d6dc8>] xfs_trans_reserve+0x78/0x1f0 [xfs]
> > =

> > Hmmmmm. That may be caused by the conversion of the xfsaild to a
> > work queue. Can you post the output of "xfs_info <mntpt>" and the
> > mount options (/proc/mounts) used on you system?

I may have hit the same problem today and managed to capture some sysrq-l
and sysrq-w output. =


The system was largely unusable during this incident. I could still
switch between X and the console (and press the sysrq key-combination),
but I couldn't run any commands in the terminal.


x4 ~ # xfs_info /
meta-data=3D/dev/root              isize=3D256    agcount=3D4, agsize=3D194=
9824 blks
         =3D                       sectsz=3D512   attr=3D2
data     =3D                       bsize=3D4096   blocks=3D7799296, imaxpct=
=3D25
         =3D                       sunit=3D128    swidth=3D128 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
log      =3Dinternal               bsize=3D4096   blocks=3D3808, version=3D2
         =3D                       sectsz=3D512   sunit=3D8 blks, lazy-coun=
t=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0

x4 ~ # xfs_info /var
meta-data=3D/dev/sda1              isize=3D256    agcount=3D4, agsize=3D128=
00000 blks
         =3D                       sectsz=3D4096  attr=3D2
data     =3D                       bsize=3D4096   blocks=3D51200000, imaxpc=
t=3D25
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
log      =3Dinternal               bsize=3D4096   blocks=3D25000, version=
=3D2
         =3D                       sectsz=3D4096  sunit=3D1 blks, lazy-coun=
t=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0

x4 ~ # mount
rootfs on / type rootfs (rw)
/dev/root on / type xfs (rw,noatime,attr2,delaylog,logbsize=3D256k,sunit=3D=
1024,swidth=3D1024,noquota)
devtmpfs on /dev type devtmpfs (rw,relatime,size=3D4091272k,nr_inodes=3D102=
2818,mode=3D755)
proc on /proc type proc (rw,relatime)
sys on /sys type sysfs (rw,relatime)
devpts on /dev/pts type devpts (rw,relatime,mode=3D600)
none on /dev/shm type tmpfs (rw,relatime,size=3D409600k)
/dev/sda1 on /var type xfs (rw,noatime,attr2,delaylog,logbsize=3D256k,noquo=
ta)
/dev/sda2 on /music type xfs (rw,noatime,attr2,delaylog,noquota)
cgroup on /sys/fs/cgroup type cgroup (rw,relatime,cpu,release_agent=3D/sbin=
/rm_cgroup)


Apr 27 09:53:01 x4 kernel: rtc_cmos 00:03: setting system clock to 2011-04-=
27 07:52:58 UTC (1303890778)
Apr 27 09:53:01 x4 kernel: XFS (sdb2): Mounting Filesystem
Apr 27 09:53:01 x4 kernel: XFS (sdb2): Ending clean mount
Apr 27 09:53:01 x4 kernel: VFS: Mounted root (xfs filesystem) readonly on d=
evice 8:18.
Apr 27 09:53:01 x4 kernel: devtmpfs: mounted
Apr 27 09:53:01 x4 kernel: Freeing unused kernel memory: 596k freed
Apr 27 09:53:01 x4 kernel: XFS (sda1): Mounting Filesystem
Apr 27 09:53:01 x4 kernel: XFS (sda1): Ending clean mount
Apr 27 09:53:01 x4 kernel: XFS (sda2): Mounting Filesystem
Apr 27 09:53:01 x4 kernel: XFS (sda2): Ending clean mount
Apr 27 09:53:01 x4 kernel: ATL1E 0000:02:00.0: irq 40 for MSI/MSI-X
Apr 27 09:53:01 x4 kernel: ATL1E 0000:02:00.0: eth0: NIC Link is Up <100 Mb=
ps Full Duplex>
Apr 27 09:53:01 x4 kernel: ATL1E 0000:02:00.0: eth0: NIC Link is Up <100 Mb=
ps Full Duplex>
Apr 27 09:53:02 x4 kernel: Adding 2097148k swap on /var/tmp/swap/swapfile. =
 Priority:-1 extents:2 across:2679512k =

Apr 27 14:59:02 x4 kernel: usb 1-3: new high speed USB device number 5 usin=
g ehci_hcd
Apr 27 15:04:26 x4 kernel: usb 1-3: USB disconnect, device number 5
Apr 27 15:20:44 x4 kernel: usb 1-3: new high speed USB device number 6 usin=
g ehci_hcd
Apr 27 15:25:36 x4 kernel: usb 1-3: USB disconnect, device number 6
Apr 27 16:14:49 x4 kernel: usb 1-3: new high speed USB device number 7 usin=
g ehci_hcd
Apr 27 16:16:57 x4 kernel: usb 1-3: USB disconnect, device number 7
Apr 27 21:49:16 x4 kernel: chrome_sandbox (8376): /proc/8374/oom_adj is dep=
recated, please use /proc/8374/oom_score_adj instead.
Apr 27 22:40:49 x4 kernel: CE: hpet increased min_delta_ns to 20113 nsec
Apr 28 07:50:59 x4 kernel: usb 1-3: new high speed USB device number 8 usin=
g ehci_hcd
Apr 28 07:55:54 x4 kernel: usb 1-3: USB disconnect, device number 8
Apr 28 17:38:23 x4 kernel: kvm: 16389: cpu0 unhandled rdmsr: 0xc0010001
Apr 28 20:59:27 x4 kernel: SysRq : Show backtrace of all active CPUs
Apr 28 20:59:27 x4 kernel: CPU3:
Apr 28 20:59:27 x4 kernel: CPU 3 =

Apr 28 20:59:27 x4 kernel: Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc5=
 #4 System manufacturer System Product Name/M4A78T-E
Apr 28 20:59:27 x4 kernel: RIP: 0010:[<ffffffff81044962>]  [<ffffffff810449=
62>] default_idle+0x42/0x160
Apr 28 20:59:27 x4 kernel: RSP: 0018:ffff88021e94dea8  EFLAGS: 00000246
Apr 28 20:59:27 x4 kernel: RAX: 0000000000000000 RBX: 0000000000000004 RCX:=
 0000000000000020
Apr 28 20:59:27 x4 kernel: RDX: 0000000000000000 RSI: 0000000000000086 RDI:=
 ffffffff8180b8ec
Apr 28 20:59:27 x4 kernel: RBP: ffff88021e94dec8 R08: ffffffff816d1480 R09:=
 0000000000000001
Apr 28 20:59:27 x4 kernel: R10: 0000000000000000 R11: 0000000000000000 R12:=
 ffffffff8150d50e
Apr 28 20:59:27 x4 kernel: R13: ffff88021e952400 R14: ffffffff8109cc05 R15:=
 ffff88021e94de48
Apr 28 20:59:27 x4 kernel: FS:  00007f52065e3700(0000) GS:ffff88021fd80000(=
0000) knlGS:0000000000000000
Apr 28 20:59:27 x4 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Apr 28 20:59:27 x4 kernel: CR2: 00007f520612b7e0 CR3: 0000000110717000 CR4:=
 00000000000006e0
Apr 28 20:59:27 x4 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2:=
 0000000000000000
Apr 28 20:59:27 x4 kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:=
 0000000000000400
Apr 28 20:59:27 x4 kernel: Process kworker/0:1 (pid: 0, threadinfo ffff8802=
1e94c000, task ffff88021e8bec00)
Apr 28 20:59:27 x4 kernel: Stack:
Apr 28 20:59:27 x4 kernel: ffff88021e94dee4 ffffffff81725568 ffff88021e94c0=
00 0000000000000000
Apr 28 20:59:27 x4 kernel: ffff88021e94def8 ffffffff81044dd9 ffff88021e94de=
e8 0000000381094806
Apr 28 20:59:27 x4 kernel: ffff88021e94def8 ffff88021e94dfd8 ffff88021e94df=
28 ffffffff8103c126
Apr 28 20:59:27 x4 kernel: Call Trace:
Apr 28 20:59:27 x4 kernel: [<ffffffff81044dd9>] c1e_idle+0x59/0x100
Apr 28 20:59:27 x4 kernel: [<ffffffff8103c126>] cpu_idle+0x66/0xb0
Apr 28 20:59:27 x4 kernel: [<ffffffff8176e013>] start_secondary+0x18d/0x191
Apr 28 20:59:27 x4 kernel: Code: 00 00 66 66 66 66 90 65 48 8b 04 25 08 b7 =
00 00 83 a0 3c e0 ff ff fb 0f ae f0 48 8b 80 38 e0 ff ff a8 08 0f 85 12 01 =
00 00 fb f4 =

Apr 28 20:59:27 x4 kernel: Call Trace:
Apr 28 20:59:27 x4 kernel: [<ffffffff81044dd9>] c1e_idle+0x59/0x100
Apr 28 20:59:27 x4 kernel: [<ffffffff8103c126>] cpu_idle+0x66/0xb0
Apr 28 20:59:27 x4 kernel: [<ffffffff8176e013>] start_secondary+0x18d/0x191
Apr 28 20:59:27 x4 kernel: CPU0:
Apr 28 20:59:27 x4 kernel: ffff88021fc03ef0 ffff88021fc03f48 00000000000000=
46 0000000000000000
Apr 28 20:59:27 x4 kernel: 00000000ffffffff ffffffff81285150 ffff88021cd3be=
2c ffff88021fc03f38
Apr 28 20:59:27 x4 kernel: ffffffff81040c7c ffff88021fc03f58 ffffffff812851=
a4 ffffffff8150ea0c
Apr 28 20:59:27 x4 kernel: Call Trace:
Apr 28 20:59:27 x4 kernel: <IRQ>  [<ffffffff81285150>] ? __sysrq_swap_key_o=
ps+0xb0/0xb0
Apr 28 20:59:27 x4 kernel: [<ffffffff81040c7c>] ? show_stack+0x1c/0x20
Apr 28 20:59:27 x4 kernel: [<ffffffff812851a4>] ? showacpu+0x54/0x70
Apr 28 20:59:27 x4 kernel: [<ffffffff8150ea0c>] ? call_softirq+0x1c/0x26
Apr 28 20:59:27 x4 kernel: [<ffffffff810a1fdb>] ? generic_smp_call_function=
_interrupt+0x8b/0x190
Apr 28 20:59:27 x4 kernel: [<ffffffff81052f17>] ? smp_call_function_interru=
pt+0x27/0x40
Apr 28 20:59:27 x4 kernel: [<ffffffff8150e693>] ? call_function_interrupt+0=
x13/0x20
Apr 28 20:59:27 x4 kernel: <EOI>  [<ffffffff81116f41>] ? fget_light+0x1/0x1=
00
Apr 28 20:59:27 x4 kernel: [<ffffffff811281b1>] ? do_sys_poll+0x201/0x4e0
Apr 28 20:59:27 x4 kernel: [<ffffffff81126e70>] ? poll_select_copy_remainin=
g+0x140/0x140
Apr 28 20:59:27 x4 kernel: [<ffffffff81126f60>] ? __pollwait+0xf0/0xf0
Apr 28 20:59:27 x4 kernel: [<ffffffff81126f60>] ? __pollwait+0xf0/0xf0
Apr 28 20:59:27 x4 kernel: [<ffffffff81126f60>] ? __pollwait+0xf0/0xf0
Apr 28 20:59:27 x4 kernel: [<ffffffff81126f60>] ? __pollwait+0xf0/0xf0
Apr 28 20:59:27 x4 kernel: [<ffffffff81126f60>] ? __pollwait+0xf0/0xf0
Apr 28 20:59:27 x4 kernel: [<ffffffff811e3e11>] ? xfs_aio_write_newsize_upd=
ate+0x61/0x70
Apr 28 20:59:27 x4 kernel: [<ffffffff811bc5cc>] ? xfs_iunlock+0x12c/0x180
Apr 28 20:59:27 x4 kernel: [<ffffffff811e5389>] ? xfs_file_aio_write+0x269/=
0x310
Apr 28 20:59:27 x4 kernel: [<ffffffff811e53b1>] ? xfs_file_aio_write+0x291/=
0x310
Apr 28 20:59:27 x4 kernel: [<ffffffff81070a79>] ? console_unlock+0x199/0x1f0
Apr 28 20:59:27 x4 kernel: [<ffffffff8114c0f2>] ? fsnotify+0x1c2/0x2a0
Apr 28 20:59:27 x4 kernel: [<ffffffff81097901>] ? ktime_get_ts+0xb1/0xf0
Apr 28 20:59:27 x4 kernel: [<ffffffff811272fa>] ? poll_select_set_timeout+0=
x7a/0x90
Apr 28 20:59:27 x4 kernel: [<ffffffff81128576>] ? sys_poll+0x76/0x110
Apr 28 20:59:27 x4 kernel: [<ffffffff8150dc6b>] ? system_call_fastpath+0x16=
/0x1b
Apr 28 20:59:50 x4 kernel: SysRq : HELP : loglevel(0-9) reBoot Crash termin=
ate-all-tasks(E) memory-full-oom-kill(F) kill-all-tasks(I) thaw-filesystems=
(J) saK show-backtrace-all-active-cpus(L) show-memory-usage(M) nice-all-RT-=
tasks(N) show-registers(P) show-all-timers(Q) unRaw Sync show-task-states(T=
) Unmount force-fb(V) show-blocked-tasks(W) dump-ftrace-buffer(Z) =

Apr 28 21:00:01 x4 kernel: SysRq : Show Blocked State
Apr 28 21:00:01 x4 kernel: task                        PC stack   pid father
Apr 28 21:00:01 x4 kernel: khugepaged      D 0000000107847b4d     0   557  =
    2 0x00000000
Apr 28 21:00:01 x4 kernel: ffff88021ea73800 0000000000000046 ffff88021ea736=
f0 ffff880000000000
Apr 28 21:00:01 x4 kernel: ffff88021ea73914 ffff88021ea73910 ffff88021ea737=
00 ffff88021ea73fd8
Apr 28 21:00:01 x4 kernel: 0000000000004000 ffff88021ea73fd8 ffff88021e8bec=
00 ffff88021ea5c200
Apr 28 21:00:01 x4 kernel: Call Trace:
Apr 28 21:00:01 x4 kernel: [<ffffffff81196965>] ? xfs_bmap_search_extents+0=
x65/0xd0
Apr 28 21:00:01 x4 kernel: [<ffffffff8119f8a7>] ? xfs_bmapi+0x2b7/0x1050
Apr 28 21:00:01 x4 kernel: [<ffffffff811c7956>] xlog_grant_log_space+0x616/=
0x6c0
Apr 28 21:00:01 x4 kernel: [<ffffffff8121d129>] ? random32+0x39/0x60
Apr 28 21:00:01 x4 kernel: [<ffffffff8106af80>] ? try_to_wake_up+0x380/0x380
Apr 28 21:00:01 x4 kernel: [<ffffffff811ca246>] xfs_log_reserve+0x176/0x1f0
Apr 28 21:00:01 x4 kernel: [<ffffffff811d622c>] xfs_trans_reserve+0x9c/0x200
Apr 28 21:00:01 x4 kernel: [<ffffffff811bc264>] ? xfs_ilock+0x114/0x150
Apr 28 21:00:01 x4 kernel: [<ffffffff811d9af8>] xfs_free_eofblocks+0x158/0x=
230
Apr 28 21:00:01 x4 kernel: [<ffffffff811db135>] xfs_inactive+0x105/0x430
Apr 28 21:00:01 x4 kernel: [<ffffffff811e935a>] xfs_fs_evict_inode+0xaa/0x1=
30
Apr 28 21:00:01 x4 kernel: [<ffffffff8112d895>] evict+0x85/0x170
Apr 28 21:00:01 x4 kernel: [<ffffffff8112d9be>] dispose_list+0x3e/0x50
Apr 28 21:00:01 x4 kernel: [<ffffffff8112e764>] shrink_icache_memory+0x184/=
0x350
Apr 28 21:00:01 x4 kernel: [<ffffffff810e492c>] shrink_slab+0x11c/0x180
Apr 28 21:00:01 x4 kernel: [<ffffffff810e7817>] try_to_free_pages+0x207/0x4=
90
Apr 28 21:00:01 x4 kernel: [<ffffffff810dd662>] __alloc_pages_nodemask+0x4b=
2/0x890
Apr 28 21:00:01 x4 kernel: [<ffffffff8107da70>] ? ftrace_raw_event_timer_cl=
ass+0xb0/0xb0
Apr 28 21:00:01 x4 kernel: [<ffffffff811101f5>] khugepaged_alloc_hugepage+0=
x55/0xf0
Apr 28 21:00:01 x4 kernel: [<ffffffff8108f3d0>] ? abort_exclusive_wait+0xb0=
/0xb0
Apr 28 21:00:01 x4 kernel: [<ffffffff81110855>] khugepaged+0x85/0x1140
Apr 28 21:00:01 x4 kernel: [<ffffffff8108f3d0>] ? abort_exclusive_wait+0xb0=
/0xb0
Apr 28 21:00:01 x4 kernel: [<ffffffff811107d0>] ? enabled_show+0x20/0x20
Apr 28 21:00:01 x4 kernel: [<ffffffff8108e85c>] kthread+0x8c/0xa0
Apr 28 21:00:01 x4 kernel: [<ffffffff8150e914>] kernel_thread_helper+0x4/0x=
10
Apr 28 21:00:01 x4 kernel: [<ffffffff8108e7d0>] ? kthread_flush_work_fn+0x2=
0/0x20
Apr 28 21:00:01 x4 kernel: [<ffffffff8150e910>] ? gs_change+0xb/0xb
Apr 28 21:00:01 x4 kernel: zsh             D 0000000000000000     0  1638  =
 1620 0x00000000
Apr 28 21:00:01 x4 kernel: ffff88020bdb5b78 0000000000000086 00000000000000=
00 ffff88021e957800
Apr 28 21:00:01 x4 kernel: ffff88021fc11740 0000000000000000 00000000000117=
40 ffff88020bdb5fd8
Apr 28 21:00:01 x4 kernel: 0000000000004000 ffff88020bdb5fd8 ffff88021e8bb6=
00 ffff88021e02a400
Apr 28 21:00:01 x4 kernel: Call Trace:
Apr 28 21:00:01 x4 kernel: [<ffffffff81061684>] ? __enqueue_entity+0x84/0x90
Apr 28 21:00:01 x4 kernel: [<ffffffff81052dd6>] ? native_smp_send_reschedul=
e+0x46/0x60
Apr 28 21:00:01 x4 kernel: [<ffffffff81060188>] ? resched_task+0x68/0x70
Apr 28 21:00:01 x4 kernel: [<ffffffff81064235>] ? check_preempt_curr+0x75/0=
xa0
Apr 28 21:00:01 x4 kernel: [<ffffffff811c7956>] xlog_grant_log_space+0x616/=
0x6c0
Apr 28 21:00:01 x4 kernel: [<ffffffff8121d129>] ? random32+0x39/0x60
Apr 28 21:00:01 x4 kernel: [<ffffffff8106af80>] ? try_to_wake_up+0x380/0x380
Apr 28 21:00:01 x4 kernel: [<ffffffff811ca246>] xfs_log_reserve+0x176/0x1f0
Apr 28 21:00:01 x4 kernel: [<ffffffff811d622c>] xfs_trans_reserve+0x9c/0x200
Apr 28 21:00:01 x4 kernel: [<ffffffff811d60b1>] ? xfs_trans_alloc+0xa1/0xb0
Apr 28 21:00:01 x4 kernel: [<ffffffff811dc813>] xfs_symlink+0x263/0x860
Apr 28 21:00:01 x4 kernel: [<ffffffff811bc5b9>] ? xfs_iunlock+0x119/0x180
Apr 28 21:00:01 x4 kernel: [<ffffffff811bc62e>] ? xfs_iunlock_map_shared+0x=
e/0x10
Apr 28 21:00:01 x4 kernel: [<ffffffff81128f24>] ? __d_instantiate+0x84/0x100
Apr 28 21:00:01 x4 kernel: [<ffffffff811295a9>] ? _d_rehash+0x49/0x50
Apr 28 21:00:01 x4 kernel: [<ffffffff8112b8c4>] ? d_rehash+0x34/0x40
Apr 28 21:00:01 x4 kernel: [<ffffffff811e7b26>] ? xfs_vn_lookup+0x86/0x90
Apr 28 21:00:01 x4 kernel: [<ffffffff811e8399>] xfs_vn_symlink+0x59/0xd0
Apr 28 21:00:01 x4 kernel: [<ffffffff81123d56>] vfs_symlink+0x76/0xc0
Apr 28 21:00:01 x4 kernel: [<ffffffff81123e96>] sys_symlinkat+0xf6/0x110
Apr 28 21:00:01 x4 kernel: [<ffffffff81123ec6>] sys_symlink+0x16/0x20
Apr 28 21:00:01 x4 kernel: [<ffffffff8150dc6b>] system_call_fastpath+0x16/0=
x1b
Apr 28 21:00:01 x4 kernel: zsh             D 0000000000000000     0  1640  =
 1548 0x00000004
Apr 28 21:00:01 x4 kernel: ffff88020bc63b78 0000000000000086 00000000000000=
01 ffffffff816efd20
Apr 28 21:00:01 x4 kernel: 0000000000000286 0000000000000000 ffff88021e9153=
30 ffff88020bc63fd8
Apr 28 21:00:01 x4 kernel: 0000000000004000 ffff88020bc63fd8 ffff88021e8bb6=
00 ffff88021b011e00
Apr 28 21:00:01 x4 kernel: Call Trace:
Apr 28 21:00:01 x4 kernel: [<ffffffff81127186>] ? poll_freewait+0x56/0xe0
Apr 28 21:00:01 x4 kernel: [<ffffffff81211d95>] ? cpumask_next_and+0x35/0x50
Apr 28 21:00:01 x4 kernel: [<ffffffff81060a05>] ? select_idle_sibling+0x95/=
0x150
Apr 28 21:00:01 x4 kernel: [<ffffffff811c7956>] xlog_grant_log_space+0x616/=
0x6c0
Apr 28 21:00:01 x4 kernel: [<ffffffff8121d129>] ? random32+0x39/0x60
Apr 28 21:00:01 x4 kernel: [<ffffffff8106af80>] ? try_to_wake_up+0x380/0x380
Apr 28 21:00:01 x4 kernel: [<ffffffff811ca246>] xfs_log_reserve+0x176/0x1f0
Apr 28 21:00:01 x4 kernel: [<ffffffff811d622c>] xfs_trans_reserve+0x9c/0x200
Apr 28 21:00:01 x4 kernel: [<ffffffff811d60b1>] ? xfs_trans_alloc+0xa1/0xb0
Apr 28 21:00:01 x4 kernel: [<ffffffff811dc813>] xfs_symlink+0x263/0x860
Apr 28 21:00:01 x4 kernel: [<ffffffff8112b485>] ? __d_lookup+0xb5/0x170
Apr 28 21:00:01 x4 kernel: [<ffffffff811e8399>] xfs_vn_symlink+0x59/0xd0
Apr 28 21:00:01 x4 kernel: [<ffffffff81123d56>] vfs_symlink+0x76/0xc0
Apr 28 21:00:01 x4 kernel: [<ffffffff81123e96>] sys_symlinkat+0xf6/0x110
Apr 28 21:00:01 x4 kernel: [<ffffffff81123ec6>] sys_symlink+0x16/0x20
Apr 28 21:00:01 x4 kernel: [<ffffffff8150dc6b>] system_call_fastpath+0x16/0=
x1b
Apr 28 21:00:01 x4 kernel: firefox-bin     D 0000000107830cf8     0 22133  =
    1 0x00000000
Apr 28 21:00:01 x4 kernel: ffff8801a5dbfae8 0000000000000082 ffff8801a5dbfa=
18 ffffffff00000000
Apr 28 21:00:01 x4 kernel: ffff88021e904480 ffff88021d6700d0 ffff8801f9cbc2=
80 ffff8801a5dbffd8
Apr 28 21:00:01 x4 kernel: 0000000000004000 ffff8801a5dbffd8 ffff88021e8bbc=
00 ffff88021e957800
Apr 28 21:00:01 x4 kernel: Call Trace:
Apr 28 21:00:01 x4 kernel: [<ffffffff811a3383>] ? xfs_btree_is_lastrec+0x43=
/0x60
Apr 28 21:00:01 x4 kernel: [<ffffffff811a7d2c>] ? xfs_btree_insrec+0x2cc/0x=
580
Apr 28 21:00:01 x4 kernel: [<ffffffff811a2d54>] ? xfs_btree_setbuf+0x34/0xb0
Apr 28 21:00:01 x4 kernel: [<ffffffff811dd59f>] ? kmem_alloc+0x5f/0xe0
Apr 28 21:00:01 x4 kernel: [<ffffffff811c76aa>] xlog_grant_log_space+0x36a/=
0x6c0
Apr 28 21:00:01 x4 kernel: [<ffffffff8106af80>] ? try_to_wake_up+0x380/0x380
Apr 28 21:00:01 x4 kernel: [<ffffffff811ca246>] xfs_log_reserve+0x176/0x1f0
Apr 28 21:00:01 x4 kernel: [<ffffffff811d622c>] xfs_trans_reserve+0x9c/0x200
Apr 28 21:00:01 x4 kernel: [<ffffffff811d60b1>] ? xfs_trans_alloc+0xa1/0xb0
Apr 28 21:00:01 x4 kernel: [<ffffffff811d4937>] xfs_rename+0x147/0x750
Apr 28 21:00:01 x4 kernel: [<ffffffff811e7b96>] xfs_vn_rename+0x66/0x70
Apr 28 21:00:01 x4 kernel: [<ffffffff81124300>] vfs_rename+0x120/0x420
Apr 28 21:00:01 x4 kernel: [<ffffffff8111f2bb>] ? __lookup_hash+0x5b/0x140
Apr 28 21:00:01 x4 kernel: [<ffffffff81124807>] sys_renameat+0x207/0x230
Apr 28 21:00:01 x4 kernel: [<ffffffff8111737e>] ? fput+0x14e/0x1f0
Apr 28 21:00:01 x4 kernel: [<ffffffff81114eb6>] ? filp_close+0x66/0x90
Apr 28 21:00:01 x4 kernel: [<ffffffff8112484b>] sys_rename+0x1b/0x20
Apr 28 21:00:01 x4 kernel: [<ffffffff8150dc6b>] system_call_fastpath+0x16/0=
x1b
Apr 28 21:00:01 x4 kernel: firefox-bin     D 0000000107825ec6     0 23835  =
    1 0x00000000
Apr 28 21:00:01 x4 kernel: ffff8801b228fc98 0000000000000082 ffff8801b228fc=
b0 0000000000000000
Apr 28 21:00:01 x4 kernel: 0000000000000000 ffff8801b228fdd8 ffff8801b228fd=
d8 ffff8801b228ffd8
Apr 28 21:00:01 x4 kernel: 0000000000004000 ffff8801b228ffd8 ffff88021e8bbc=
00 ffff88021e953c00
Apr 28 21:00:01 x4 kernel: Call Trace:
Apr 28 21:00:01 x4 kernel: [<ffffffff8111f138>] ? acl_permission_check+0x38=
/0xe0
Apr 28 21:00:01 x4 kernel: [<ffffffff8150bfa6>] __mutex_lock_slowpath+0x116=
/0x1c0
Apr 28 21:00:01 x4 kernel: [<ffffffff8150bd52>] mutex_lock+0x22/0x40
Apr 28 21:00:01 x4 kernel: [<ffffffff811226bd>] do_last.isra.42+0x30d/0x8a0
Apr 28 21:00:01 x4 kernel: [<ffffffff8112088a>] ? path_init+0x30a/0x3e0
Apr 28 21:00:01 x4 kernel: [<ffffffff81122d14>] path_openat+0xc4/0x370
Apr 28 21:00:01 x4 kernel: [<ffffffff8112218f>] ? user_path_at+0x6f/0xa0
Apr 28 21:00:01 x4 kernel: [<ffffffff81123002>] do_filp_open+0x42/0xa0
Apr 28 21:00:01 x4 kernel: [<ffffffff811304cc>] ? alloc_fd+0xec/0x130
Apr 28 21:00:01 x4 kernel: [<ffffffff81114d07>] do_sys_open+0xf7/0x1d0
Apr 28 21:00:01 x4 kernel: [<ffffffff81114e00>] sys_open+0x20/0x30
Apr 28 21:00:01 x4 kernel: [<ffffffff8150dc6b>] system_call_fastpath+0x16/0=
x1b
Apr 28 21:00:01 x4 kernel: okular          D 000000010781eb7c     0 27510  =
    1 0x00000000
Apr 28 21:00:01 x4 kernel: ffff8801a5e83a68 0000000000000086 ffff8801a5e839=
e8 ffff880100000000
Apr 28 21:00:01 x4 kernel: ffffffff81217681 ffff88021fd0dda8 ffff8801a5e83a=
80 ffff8801a5e83fd8
Apr 28 21:00:01 x4 kernel: 0000000000004000 ffff8801a5e83fd8 ffff88021e8bd4=
00 ffff88021ea5f800
Apr 28 21:00:01 x4 kernel: Call Trace:
Apr 28 21:00:01 x4 kernel: [<ffffffff81217681>] ? rb_insert_color+0xa1/0x140
Apr 28 21:00:01 x4 kernel: [<ffffffff810927a8>] ? enqueue_hrtimer+0x38/0xd0
Apr 28 21:00:01 x4 kernel: [<ffffffff81092ce0>] ? lock_hrtimer_base.isra.28=
+0x30/0x60
Apr 28 21:00:01 x4 kernel: [<ffffffff8109332d>] ? hrtimer_try_to_cancel+0x8=
d/0x120
Apr 28 21:00:01 x4 kernel: [<ffffffff811c7956>] xlog_grant_log_space+0x616/=
0x6c0
Apr 28 21:00:01 x4 kernel: [<ffffffff8121d129>] ? random32+0x39/0x60
Apr 28 21:00:01 x4 kernel: [<ffffffff8106af80>] ? try_to_wake_up+0x380/0x380
Apr 28 21:00:01 x4 kernel: [<ffffffff811ca246>] xfs_log_reserve+0x176/0x1f0
Apr 28 21:00:01 x4 kernel: [<ffffffff811d622c>] xfs_trans_reserve+0x9c/0x200
Apr 28 21:00:01 x4 kernel: [<ffffffff811d60b1>] ? xfs_trans_alloc+0xa1/0xb0
Apr 28 21:00:01 x4 kernel: [<ffffffff811daaba>] xfs_setattr+0x57a/0x770
Apr 28 21:00:01 x4 kernel: [<ffffffff811e817b>] xfs_vn_setattr+0x1b/0x20
Apr 28 21:00:01 x4 kernel: [<ffffffff8112f595>] notify_change+0x125/0x360
Apr 28 21:00:01 x4 kernel: [<ffffffff81113b29>] do_truncate+0x59/0x90
Apr 28 21:00:01 x4 kernel: [<ffffffff8112297f>] do_last.isra.42+0x5cf/0x8a0
Apr 28 21:00:01 x4 kernel: [<ffffffff81122d14>] path_openat+0xc4/0x370
Apr 28 21:00:01 x4 kernel: [<ffffffff8145f9dd>] ? sock_aio_read+0x2d/0x40
Apr 28 21:00:01 x4 kernel: [<ffffffff81123002>] do_filp_open+0x42/0xa0
Apr 28 21:00:01 x4 kernel: [<ffffffff811304cc>] ? alloc_fd+0xec/0x130
Apr 28 21:00:01 x4 kernel: [<ffffffff81114d07>] do_sys_open+0xf7/0x1d0
Apr 28 21:00:01 x4 kernel: [<ffffffff81114e00>] sys_open+0x20/0x30
Apr 28 21:00:01 x4 kernel: [<ffffffff8150dc6b>] system_call_fastpath+0x16/0=
x1b
Apr 28 21:00:01 x4 kernel: kworker/2:0     D 000000010781d02c     0  6304  =
    2 0x00000000
Apr 28 21:00:01 x4 kernel: ffff880165afdc60 0000000000000046 00000000000000=
00 0000000000000000
Apr 28 21:00:01 x4 kernel: 0000000000000000 0000000000000000 00000000000000=
01 ffff880165afdfd8
Apr 28 21:00:01 x4 kernel: 0000000000004000 ffff880165afdfd8 ffff88021e8bd4=
00 ffff88021e091800
Apr 28 21:00:01 x4 kernel: Call Trace:
Apr 28 21:00:01 x4 kernel: [<ffffffff811c7956>] xlog_grant_log_space+0x616/=
0x6c0
Apr 28 21:00:01 x4 kernel: [<ffffffff8121d129>] ? random32+0x39/0x60
Apr 28 21:00:01 x4 kernel: [<ffffffff8106af80>] ? try_to_wake_up+0x380/0x380
Apr 28 21:00:01 x4 kernel: [<ffffffff811ca246>] xfs_log_reserve+0x176/0x1f0
Apr 28 21:00:01 x4 kernel: [<ffffffff811d622c>] xfs_trans_reserve+0x9c/0x200
Apr 28 21:00:01 x4 kernel: [<ffffffff811eb0f0>] ? xfs_sync_inode_attr+0xf0/=
0xf0
Apr 28 21:00:01 x4 kernel: [<ffffffff811b9913>] xfs_fs_log_dummy+0x43/0x90
Apr 28 21:00:01 x4 kernel: [<ffffffff811eb16c>] xfs_sync_worker+0x7c/0x80
Apr 28 21:00:01 x4 kernel: [<ffffffff8108947e>] process_one_work+0x11e/0x4c0
Apr 28 21:00:01 x4 kernel: [<ffffffff81089dfe>] worker_thread+0x15e/0x340
Apr 28 21:00:01 x4 kernel: [<ffffffff81089ca0>] ? manage_workers.isra.28+0x=
220/0x220
Apr 28 21:00:01 x4 kernel: [<ffffffff8108e85c>] kthread+0x8c/0xa0
Apr 28 21:00:01 x4 kernel: [<ffffffff8150e914>] kernel_thread_helper+0x4/0x=
10
Apr 28 21:00:01 x4 kernel: [<ffffffff8108e7d0>] ? kthread_flush_work_fn+0x2=
0/0x20
Apr 28 21:00:01 x4 kernel: [<ffffffff8150e910>] ? gs_change+0xb/0xb
Apr 28 21:00:01 x4 kernel: procmail        D 000000010782a122     0 24304  =
24249 0x00000000
Apr 28 21:00:01 x4 kernel: ffff8801234a3a78 0000000000000086 00000000000000=
02 ffff880200000000
Apr 28 21:00:01 x4 kernel: 00000000ffffffff 0000000000000001 00000000000000=
08 ffff8801234a3fd8
Apr 28 21:00:01 x4 kernel: 0000000000004000 ffff8801234a3fd8 ffff88021e8bd4=
00 ffff88021ea5f200
Apr 28 21:00:01 x4 kernel: Call Trace:
Apr 28 21:00:01 x4 kernel: [<ffffffff811c7956>] xlog_grant_log_space+0x616/=
0x6c0
Apr 28 21:00:01 x4 kernel: [<ffffffff8121d129>] ? random32+0x39/0x60
Apr 28 21:00:01 x4 kernel: [<ffffffff8106af80>] ? try_to_wake_up+0x380/0x380
Apr 28 21:00:01 x4 kernel: [<ffffffff811ca246>] xfs_log_reserve+0x176/0x1f0
Apr 28 21:00:01 x4 kernel: [<ffffffff811d622c>] xfs_trans_reserve+0x9c/0x200
Apr 28 21:00:01 x4 kernel: [<ffffffff811d60b1>] ? xfs_trans_alloc+0xa1/0xb0
Apr 28 21:00:01 x4 kernel: [<ffffffff811db77e>] xfs_create+0x1be/0x5d0
Apr 28 21:00:01 x4 kernel: [<ffffffff8112b8c4>] ? d_rehash+0x34/0x40
Apr 28 21:00:01 x4 kernel: [<ffffffff8112b485>] ? __d_lookup+0xb5/0x170
Apr 28 21:00:01 x4 kernel: [<ffffffff811e825d>] xfs_vn_mknod+0x6d/0x110
Apr 28 21:00:01 x4 kernel: [<ffffffff811e8330>] xfs_vn_create+0x10/0x20
Apr 28 21:00:01 x4 kernel: [<ffffffff81122365>] vfs_create+0x85/0xd0
Apr 28 21:00:01 x4 kernel: [<ffffffff81122a23>] do_last.isra.42+0x673/0x8a0
Apr 28 21:00:01 x4 kernel: [<ffffffff81120703>] ? path_init+0x183/0x3e0
Apr 28 21:00:01 x4 kernel: [<ffffffff81122d14>] path_openat+0xc4/0x370
Apr 28 21:00:01 x4 kernel: [<ffffffff8112218f>] ? user_path_at+0x6f/0xa0
Apr 28 21:00:01 x4 kernel: [<ffffffff81123002>] do_filp_open+0x42/0xa0
Apr 28 21:00:01 x4 kernel: [<ffffffff811304cc>] ? alloc_fd+0xec/0x130
Apr 28 21:00:01 x4 kernel: [<ffffffff81114d07>] do_sys_open+0xf7/0x1d0
Apr 28 21:00:01 x4 kernel: [<ffffffff81114e00>] sys_open+0x20/0x30
Apr 28 21:00:01 x4 kernel: [<ffffffff8150dc6b>] system_call_fastpath+0x16/0=
x1b
Apr 28 21:00:01 x4 kernel: bogofilter      D 000000010784819c     0 27492  =
27491 0x00000000
Apr 28 21:00:01 x4 kernel: ffff8801aeacfdc8 0000000000000082 ffff88021dabc0=
0d ffff880200000000
Apr 28 21:00:01 x4 kernel: ffff88021ebd5a00 000000000000002f ffff8801aeacfd=
78 ffff8801aeacffd8
Apr 28 21:00:01 x4 kernel: 0000000000004000 ffff8801aeacffd8 ffffffff816c70=
20 ffff88021ebd5a00
Apr 28 21:00:01 x4 kernel: Call Trace:
Apr 28 21:00:01 x4 kernel: [<ffffffff8111f0b9>] ? nameidata_drop_rcu_last+0=
x89/0xd0
Apr 28 21:00:01 x4 kernel: [<ffffffff81121601>] ? path_lookupat+0xd1/0x7c0
Apr 28 21:00:01 x4 kernel: [<ffffffff8150bfa6>] __mutex_lock_slowpath+0x116=
/0x1c0
Apr 28 21:00:01 x4 kernel: [<ffffffff8150bd52>] mutex_lock+0x22/0x40
Apr 28 21:00:01 x4 kernel: [<ffffffff8112315c>] lookup_create+0x2c/0xc0
Apr 28 21:00:01 x4 kernel: [<ffffffff81123669>] sys_mkdirat+0x59/0x110
Apr 28 21:00:01 x4 kernel: [<ffffffff811152dd>] ? generic_file_llseek+0x4d/=
0x60
Apr 28 21:00:01 x4 kernel: [<ffffffff81123738>] sys_mkdir+0x18/0x20
Apr 28 21:00:01 x4 kernel: [<ffffffff8150dc6b>] system_call_fastpath+0x16/0=
x1b

-- =

Markus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
