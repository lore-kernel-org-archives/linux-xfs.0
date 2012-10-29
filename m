Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9TK1Rhm198159 for <xfs@oss.sgi.com>; Mon, 29 Oct 2012 15:01:27 -0500
Received: from mail-ee0-f53.google.com (mail-ee0-f53.google.com
	[74.125.83.53]) by cuda.sgi.com with ESMTP id V6XZWvovqvSfstCE
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 29 Oct 2012 13:03:16 -0700 (PDT)
Received: by mail-ee0-f53.google.com with SMTP id e51so2832746eek.26
	for <xfs@oss.sgi.com>; Mon, 29 Oct 2012 13:03:15 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 29 Oct 2012 21:03:15 +0100
Message-ID: <CAPVoSvSM9=hictqwT2rzZA-fU_XSwd-_FRzW_J+HQYj7iohTWQ@mail.gmail.com>
Subject: Hang in XFS reclaim on 3.7.0-rc3
From: Torsten Kaiser <just.for.lkml@googlemail.com>
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
Cc: Linux Kernel <linux-kernel@vger.kernel.org>

After experiencing a hang of all IO yesterday (
http://marc.info/?l=linux-kernel&m=135142236520624&w=2 ), I turned on
LOCKDEP after upgrading to -rc3.

I then tried to replicate the load that hung yesterday and got the
following lockdep report, implicating XFS instead of by stacking swap
onto dm-crypt and md.

Oct 29 20:27:11 thoregon kernel: [ 2675.571958] usb 7-2: USB
disconnect, device number 2
Oct 29 20:30:01 thoregon kernel: [ 2844.971913]
Oct 29 20:30:01 thoregon kernel: [ 2844.971920]
=================================
Oct 29 20:30:01 thoregon kernel: [ 2844.971921] [ INFO: inconsistent
lock state ]
Oct 29 20:30:01 thoregon kernel: [ 2844.971924] 3.7.0-rc3 #1 Not tainted
Oct 29 20:30:01 thoregon kernel: [ 2844.971925]
---------------------------------
Oct 29 20:30:01 thoregon kernel: [ 2844.971927] inconsistent
{RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
Oct 29 20:30:01 thoregon kernel: [ 2844.971929] kswapd0/725
[HC0[0]:SC0[0]:HE1:SE1] takes:
Oct 29 20:30:01 thoregon kernel: [ 2844.971931]
(&(&ip->i_lock)->mr_lock){++++?.}, at: [<ffffffff811e7ef4>]
xfs_ilock+0x84/0xb0
Oct 29 20:30:01 thoregon kernel: [ 2844.971941] {RECLAIM_FS-ON-W}
state was registered at:
Oct 29 20:30:01 thoregon kernel: [ 2844.971942]   [<ffffffff8108137e>]
mark_held_locks+0x7e/0x130
Oct 29 20:30:01 thoregon kernel: [ 2844.971947]   [<ffffffff81081a63>]
lockdep_trace_alloc+0x63/0xc0
Oct 29 20:30:01 thoregon kernel: [ 2844.971949]   [<ffffffff810e9dd5>]
kmem_cache_alloc+0x35/0xe0
Oct 29 20:30:01 thoregon kernel: [ 2844.971952]   [<ffffffff810dba31>]
vm_map_ram+0x271/0x770
Oct 29 20:30:01 thoregon kernel: [ 2844.971955]   [<ffffffff811e10a6>]
_xfs_buf_map_pages+0x46/0xe0
Oct 29 20:30:01 thoregon kernel: [ 2844.971959]   [<ffffffff811e1fba>]
xfs_buf_get_map+0x8a/0x130
Oct 29 20:30:01 thoregon kernel: [ 2844.971961]   [<ffffffff81233849>]
xfs_trans_get_buf_map+0xa9/0xd0
Oct 29 20:30:01 thoregon kernel: [ 2844.971964]   [<ffffffff8121e339>]
xfs_ifree_cluster+0x129/0x670
Oct 29 20:30:01 thoregon kernel: [ 2844.971967]   [<ffffffff8121f959>]
xfs_ifree+0xe9/0xf0
Oct 29 20:30:01 thoregon kernel: [ 2844.971969]   [<ffffffff811f4abf>]
xfs_inactive+0x2af/0x480
Oct 29 20:30:01 thoregon kernel: [ 2844.971972]   [<ffffffff811efb90>]
xfs_fs_evict_inode+0x70/0x80
Oct 29 20:30:01 thoregon kernel: [ 2844.971974]   [<ffffffff8110cb8f>]
evict+0xaf/0x1b0
Oct 29 20:30:01 thoregon kernel: [ 2844.971977]   [<ffffffff8110cd95>]
iput+0x105/0x210
Oct 29 20:30:01 thoregon kernel: [ 2844.971979]   [<ffffffff811070d0>]
dentry_iput+0xa0/0xe0
Oct 29 20:30:01 thoregon kernel: [ 2844.971981]   [<ffffffff81108310>]
dput+0x150/0x280
Oct 29 20:30:01 thoregon kernel: [ 2844.971983]   [<ffffffff811020fb>]
sys_renameat+0x21b/0x290
Oct 29 20:30:01 thoregon kernel: [ 2844.971986]   [<ffffffff81102186>]
sys_rename+0x16/0x20
Oct 29 20:30:01 thoregon kernel: [ 2844.971988]   [<ffffffff816b2292>]
system_call_fastpath+0x16/0x1b
Oct 29 20:30:01 thoregon kernel: [ 2844.971992] irq event stamp: 155377
Oct 29 20:30:01 thoregon kernel: [ 2844.971993] hardirqs last  enabled
at (155377): [<ffffffff816ae1ed>] mutex_trylock+0xfd/0x170
Oct 29 20:30:01 thoregon kernel: [ 2844.971997] hardirqs last disabled
at (155376): [<ffffffff816ae12e>] mutex_trylock+0x3e/0x170
Oct 29 20:30:01 thoregon kernel: [ 2844.971999] softirqs last  enabled
at (155368): [<ffffffff81042fb1>] __do_softirq+0x111/0x170
Oct 29 20:30:01 thoregon kernel: [ 2844.972002] softirqs last disabled
at (155353): [<ffffffff816b33bc>] call_softirq+0x1c/0x30
Oct 29 20:30:01 thoregon kernel: [ 2844.972004]
Oct 29 20:30:01 thoregon kernel: [ 2844.972004] other info that might
help us debug this:
Oct 29 20:30:01 thoregon kernel: [ 2844.972006]  Possible unsafe
locking scenario:
Oct 29 20:30:01 thoregon kernel: [ 2844.972006]
Oct 29 20:30:01 thoregon kernel: [ 2844.972007]        CPU0
Oct 29 20:30:01 thoregon kernel: [ 2844.972007]        ----
Oct 29 20:30:01 thoregon kernel: [ 2844.972008]   lock(&(&ip->i_lock)->mr_lock);
Oct 29 20:30:01 thoregon kernel: [ 2844.972009]   <Interrupt>
Oct 29 20:30:01 thoregon kernel: [ 2844.972010]
lock(&(&ip->i_lock)->mr_lock);
Oct 29 20:30:01 thoregon kernel: [ 2844.972012]
Oct 29 20:30:01 thoregon kernel: [ 2844.972012]  *** DEADLOCK ***
Oct 29 20:30:01 thoregon kernel: [ 2844.972012]
Oct 29 20:30:01 thoregon kernel: [ 2844.972013] 3 locks held by kswapd0/725:
Oct 29 20:30:01 thoregon kernel: [ 2844.972014]  #0:
(shrinker_rwsem){++++..}, at: [<ffffffff810bbd22>]
shrink_slab+0x32/0x1f0
Oct 29 20:30:01 thoregon kernel: [ 2844.972020]  #1:
(&type->s_umount_key#20){++++.+}, at: [<ffffffff810f5a8e>]
grab_super_passive+0x3e/0x90
Oct 29 20:30:01 thoregon kernel: [ 2844.972024]  #2:
(&pag->pag_ici_reclaim_lock){+.+...}, at: [<ffffffff811f263c>]
xfs_reclaim_inodes_ag+0xbc/0x4f0
Oct 29 20:30:01 thoregon kernel: [ 2844.972027]
Oct 29 20:30:01 thoregon kernel: [ 2844.972027] stack backtrace:
Oct 29 20:30:01 thoregon kernel: [ 2844.972029] Pid: 725, comm:
kswapd0 Not tainted 3.7.0-rc3 #1
Oct 29 20:30:01 thoregon kernel: [ 2844.972031] Call Trace:
Oct 29 20:30:01 thoregon kernel: [ 2844.972035]  [<ffffffff816a782c>]
print_usage_bug+0x1f5/0x206
Oct 29 20:30:01 thoregon kernel: [ 2844.972039]  [<ffffffff8100ed8a>]
? save_stack_trace+0x2a/0x50
Oct 29 20:30:01 thoregon kernel: [ 2844.972042]  [<ffffffff8107e9fd>]
mark_lock+0x28d/0x2f0
Oct 29 20:30:01 thoregon kernel: [ 2844.972044]  [<ffffffff8107de30>]
? print_irq_inversion_bug.part.37+0x1f0/0x1f0
Oct 29 20:30:01 thoregon kernel: [ 2844.972047]  [<ffffffff8107efdf>]
__lock_acquire+0x57f/0x1c00
Oct 29 20:30:01 thoregon kernel: [ 2844.972049]  [<ffffffff8107c899>]
? __lock_is_held+0x59/0x70
Oct 29 20:30:01 thoregon kernel: [ 2844.972051]  [<ffffffff81080b55>]
lock_acquire+0x55/0x70
Oct 29 20:30:01 thoregon kernel: [ 2844.972053]  [<ffffffff811e7ef4>]
? xfs_ilock+0x84/0xb0
Oct 29 20:30:01 thoregon kernel: [ 2844.972056]  [<ffffffff8106126a>]
down_write_nested+0x4a/0x70
Oct 29 20:30:01 thoregon kernel: [ 2844.972058]  [<ffffffff811e7ef4>]
? xfs_ilock+0x84/0xb0
Oct 29 20:30:01 thoregon kernel: [ 2844.972060]  [<ffffffff811e7ef4>]
xfs_ilock+0x84/0xb0
Oct 29 20:30:01 thoregon kernel: [ 2844.972063]  [<ffffffff811f1a76>]
xfs_reclaim_inode+0x136/0x340
Oct 29 20:30:01 thoregon kernel: [ 2844.972065]  [<ffffffff811f283f>]
xfs_reclaim_inodes_ag+0x2bf/0x4f0
Oct 29 20:30:01 thoregon kernel: [ 2844.972066]  [<ffffffff811f2660>]
? xfs_reclaim_inodes_ag+0xe0/0x4f0
Oct 29 20:30:01 thoregon kernel: [ 2844.972069]  [<ffffffff811f2bae>]
xfs_reclaim_inodes_nr+0x2e/0x40
Oct 29 20:30:01 thoregon kernel: [ 2844.972071]  [<ffffffff811ef480>]
xfs_fs_free_cached_objects+0x10/0x20
Oct 29 20:30:01 thoregon kernel: [ 2844.972073]  [<ffffffff810f5bf3>]
prune_super+0x113/0x1a0
Oct 29 20:30:01 thoregon kernel: [ 2844.972075]  [<ffffffff810bbe0e>]
shrink_slab+0x11e/0x1f0
Oct 29 20:30:01 thoregon kernel: [ 2844.972077]  [<ffffffff810be400>]
kswapd+0x690/0xa10
Oct 29 20:30:01 thoregon kernel: [ 2844.972080]  [<ffffffff8105ca30>]
? __init_waitqueue_head+0x60/0x60
Oct 29 20:30:01 thoregon kernel: [ 2844.972082]  [<ffffffff810bdd70>]
? shrink_lruvec+0x540/0x540
Oct 29 20:30:01 thoregon kernel: [ 2844.972084]  [<ffffffff8105c246>]
kthread+0xd6/0xe0
Oct 29 20:30:01 thoregon kernel: [ 2844.972087]  [<ffffffff816b148b>]
? _raw_spin_unlock_irq+0x2b/0x50
Oct 29 20:30:01 thoregon kernel: [ 2844.972089]  [<ffffffff8105c170>]
? flush_kthread_worker+0xe0/0xe0
Oct 29 20:30:01 thoregon kernel: [ 2844.972091]  [<ffffffff816b21ec>]
ret_from_fork+0x7c/0xb0
Oct 29 20:30:01 thoregon kernel: [ 2844.972093]  [<ffffffff8105c170>]
? flush_kthread_worker+0xe0/0xe0
Oct 29 20:30:01 thoregon cron[24374]: (root) CMD (test -x
/usr/sbin/run-crons && /usr/sbin/run-crons)

As kswapd got stuck yesterday, I think LOCKDEP found a real problem.

If you need more information, please ask. I will try to provide it.

Thanks,

Torsten

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
