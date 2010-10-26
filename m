Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9Q7ChnT051635 for <xfs@oss.sgi.com>; Tue, 26 Oct 2010 02:12:44 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EDACB198A11E
	for <xfs@oss.sgi.com>; Tue, 26 Oct 2010 00:13:59 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	OPTq4LTi5nBfaShC for <xfs@oss.sgi.com>;
	Tue, 26 Oct 2010 00:13:59 -0700 (PDT)
Received: from dastard (unverified [121.44.196.177])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	44165888-1927428
	for <xfs@oss.sgi.com>; Tue, 26 Oct 2010 17:43:58 +1030 (CDT)
Received: from dave by dastard with local (Exim 4.71)
	(envelope-from <david@fromorbit.com>) id 1PAdjI-00060O-QR
	for xfs@oss.sgi.com; Tue, 26 Oct 2010 18:13:56 +1100
Date: Tue, 26 Oct 2010 18:13:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [bug, 2.6.37-current] Assertion failed: atomic_read(&pag->pag_ref)
	== 0
Message-ID: <20101026071356.GY32255@dastard>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

Folks,

Since themainline merge, I've been getting unmount failures during
shutdown that look like:

Unmounting local filesystems...done.
Shutting down LVM Volume Groups[ 7088.820123] Assertion failed: atomic_read(&pag->pag_ref) == 0, file: fs/xfs/xfs_mount.c, line: 259
[ 7088.821811] ------------[ cut here ]------------
[ 7088.822594] kernel BUG at fs/xfs/support/debug.c:108!
[ 7088.823383] invalid opcode: 0000 [#1] SMP 
[ 7088.824019] last sysfs file: /sys/devices/system/node/node0/cpumap
[ 7088.824045] CPU 1 
[ 7088.824045] Modules linked in:
[ 7088.824045] 
[ 7088.824045] Pid: 0, comm: kworker/0:0 Not tainted 2.6.36-dgc+ #587 /Bochs
[ 7088.824045] RIP: 0010:[<ffffffff814b74cf>]  [<ffffffff814b74cf>] assfail+0x1f/0x30
[ 7088.824045] RSP: 0018:ffff8800df003e50  EFLAGS: 00010286
[ 7088.824045] RAX: 0000000000000069 RBX: ffff88011760a400 RCX: 0000000000000001
[ 7088.824045] RDX: ffff88011b7742c0 RSI: 0000000000000001 RDI: 0000000000000246
[ 7088.824045] RBP: ffff8800df003e50 R08: 0000000000000001 R09: 0000000000000001
[ 7088.824045] R10: 0000000000000000 R11: 0000000000000001 R12: ffffffff81ef8f00
[ 7088.824045] R13: ffff880117118df8 R14: ffff8800df1cecf0 R15: ffff880116ebf6e8
[ 7088.824045] FS:  0000000000000000(0000) GS:ffff8800df000000(0000) knlGS:0000000000000000
[ 7088.824045] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 7088.824045] CR2: 00007ffd8c8b6990 CR3: 0000000001edb000 CR4: 00000000000006e0
[ 7088.824045] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 7088.824045] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 7088.824045] Process kworker/0:0 (pid: 0, threadinfo ffff88011b776000, task ffff88011b7742c0)
[ 7088.824045] Stack:
[ 7088.824045]  ffff8800df003e70 ffffffff81499007 ffff8800df003e70 ffff8800df1cecc0
[ 7088.824045] <0> ffff8800df003ed0 ffffffff810e900a 0000000000000001 000000000000000a
[ 7088.824045] <0> ffff880100000006 0000000000000202 0000000000000100 0000000000000048
[ 7088.824045] Call Trace:
[ 7088.824045]  <IRQ> 
[ 7088.824045]  [<ffffffff81499007>] __xfs_free_perag+0x37/0x50
[ 7088.824045]  [<ffffffff810e900a>] __rcu_process_callbacks+0x13a/0x3e0
[ 7088.824045]  [<ffffffff810e92d8>] rcu_process_callbacks+0x28/0x50
[ 7088.824045]  [<ffffffff8108848d>] __do_softirq+0xcd/0x290
[ 7088.824045]  [<ffffffff810a8808>] ? hrtimer_interrupt+0x138/0x250
[ 7088.824045]  [<ffffffff81037f5c>] call_softirq+0x1c/0x50
[ 7088.824045]  [<ffffffff810398dd>] do_softirq+0x9d/0xd0
[ 7088.824045]  [<ffffffff810881e5>] irq_exit+0x95/0xa0
[ 7088.824045]  [<ffffffff81b06380>] smp_apic_timer_interrupt+0x70/0x9b
[ 7088.824045]  [<ffffffff81037a13>] apic_timer_interrupt+0x13/0x20
[ 7088.824045]  <EOI> 
[ 7088.824045]  [<ffffffff81060f6b>] ? native_safe_halt+0xb/0x10
[ 7088.824045]  [<ffffffff810baded>] ? trace_hardirqs_on+0xd/0x10
[ 7088.824045]  [<ffffffff8103fd70>] default_idle+0x50/0xb0
[ 7088.824045]  [<ffffffff81035e28>] cpu_idle+0x78/0x100
[ 7088.824045]  [<ffffffff81af627b>] start_secondary+0x1ac/0x1b1
[ 7088.824045] Code: 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 0f 1f 44 00 00 31 c0 89 d1 48 89 f2 48 89 fe 48 c7 c7 08 38 df 81 e8 7b 34 64 00 <0f> 0b eb fe 66 66 66 66 2e  
[ 7088.824045] RIP  [<ffffffff814b74cf>] assfail+0x1f/0x30
[ 7088.824045]  RSP <ffff8800df003e50>
[ 7088.863091] ---[ end trace ec76f8135c3adba9 ]---

I'm not seeing failures during xfstests runs, it seems that dbench may be the
trigger.  Is anyone else seeing reference counting problems like this on the
current linus tree?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
