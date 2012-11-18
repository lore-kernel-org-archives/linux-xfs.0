Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAIAMZgY130431 for <xfs@oss.sgi.com>; Sun, 18 Nov 2012 04:22:35 -0600
Received: from mail-ee0-f53.google.com (mail-ee0-f53.google.com
	[74.125.83.53]) by cuda.sgi.com with ESMTP id OIRk3a6B9noQ2ZoJ
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 18 Nov 2012 02:24:40 -0800 (PST)
Received: by mail-ee0-f53.google.com with SMTP id c50so2648523eek.26
	for <xfs@oss.sgi.com>; Sun, 18 Nov 2012 02:24:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPVoSvQATjAVu-D477mrr6K9d0FeY7sH27cH-zNBYMJcRoUY0Q@mail.gmail.com>
References: <CAPVoSvSM9=hictqwT2rzZA-fU_XSwd-_FRzW_J+HQYj7iohTWQ@mail.gmail.com>
	<20121029222613.GU29378@dastard>
	<CAPVoSvQATjAVu-D477mrr6K9d0FeY7sH27cH-zNBYMJcRoUY0Q@mail.gmail.com>
Date: Sun, 18 Nov 2012 11:24:39 +0100
Message-ID: <CAPVoSvRks32ZM7n6U8but-vEj622TEFqAFdxXqS_6mRxyv=0Ew@mail.gmail.com>
Subject: Re: Hang in XFS reclaim on 3.7.0-rc3
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
To: Dave Chinner <david@fromorbit.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Tue, Oct 30, 2012 at 9:37 PM, Torsten Kaiser
<just.for.lkml@googlemail.com> wrote:
> I will keep LOCKDEP enabled on that system, and if there really is
> another splat, I will report back here. But I rather doubt that this
> will be needed.

After the patch, I did not see this problem again, but today I found
another LOCKDEP report that also looks XFS related.
I found it twice in the logs, and as both were slightly different, I
will attach both versions.


Nov  6 21:57:09 thoregon kernel: [ 9941.104345]
Nov  6 21:57:09 thoregon kernel: [ 9941.104350]
=================================
Nov  6 21:57:09 thoregon kernel: [ 9941.104351] [ INFO: inconsistent
lock state ]
Nov  6 21:57:09 thoregon kernel: [ 9941.104353] 3.7.0-rc4 #1 Not tainted
Nov  6 21:57:09 thoregon kernel: [ 9941.104354]
---------------------------------
Nov  6 21:57:09 thoregon kernel: [ 9941.104355] inconsistent
{RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
Nov  6 21:57:09 thoregon kernel: [ 9941.104357] kswapd0/725
[HC0[0]:SC0[0]:HE1:SE1] takes:
Nov  6 21:57:09 thoregon kernel: [ 9941.104359]
(&(&ip->i_lock)->mr_lock){++++?.}, at: [<ffffffff811e8164>]
xfs_ilock+0x84/0xb0
Nov  6 21:57:09 thoregon kernel: [ 9941.104366] {RECLAIM_FS-ON-W}
state was registered at:
Nov  6 21:57:09 thoregon kernel: [ 9941.104367]   [<ffffffff8108137e>]
mark_held_locks+0x7e/0x130
Nov  6 21:57:09 thoregon kernel: [ 9941.104371]   [<ffffffff81081a63>]
lockdep_trace_alloc+0x63/0xc0
Nov  6 21:57:09 thoregon kernel: [ 9941.104373]   [<ffffffff810b5a55>]
__alloc_pages_nodemask+0x75/0x800
Nov  6 21:57:09 thoregon kernel: [ 9941.104375]   [<ffffffff810b6262>]
__get_free_pages+0x12/0x40
Nov  6 21:57:09 thoregon kernel: [ 9941.104377]   [<ffffffff8102d7f0>]
pte_alloc_one_kernel+0x10/0x20
Nov  6 21:57:09 thoregon kernel: [ 9941.104380]   [<ffffffff810cc3e6>]
__pte_alloc_kernel+0x16/0x90
Nov  6 21:57:09 thoregon kernel: [ 9941.104382]   [<ffffffff810d9f37>]
vmap_page_range_noflush+0x287/0x320
Nov  6 21:57:09 thoregon kernel: [ 9941.104385]   [<ffffffff810dbe54>]
vm_map_ram+0x694/0x770
Nov  6 21:57:09 thoregon kernel: [ 9941.104386]   [<ffffffff811e1316>]
_xfs_buf_map_pages+0x46/0xe0
Nov  6 21:57:09 thoregon kernel: [ 9941.104389]   [<ffffffff811e222a>]
xfs_buf_get_map+0x8a/0x130
Nov  6 21:57:09 thoregon kernel: [ 9941.104391]   [<ffffffff81233ab9>]
xfs_trans_get_buf_map+0xa9/0xd0
Nov  6 21:57:09 thoregon kernel: [ 9941.104393]   [<ffffffff8121e5a9>]
xfs_ifree_cluster+0x129/0x670
Nov  6 21:57:09 thoregon kernel: [ 9941.104396]   [<ffffffff8121fbc9>]
xfs_ifree+0xe9/0xf0
Nov  6 21:57:09 thoregon kernel: [ 9941.104398]   [<ffffffff811f4d2f>]
xfs_inactive+0x2af/0x480
Nov  6 21:57:09 thoregon kernel: [ 9941.104400]   [<ffffffff811efe00>]
xfs_fs_evict_inode+0x70/0x80
Nov  6 21:57:09 thoregon kernel: [ 9941.104402]   [<ffffffff8110cb8f>]
evict+0xaf/0x1b0
Nov  6 21:57:09 thoregon kernel: [ 9941.104405]   [<ffffffff8110cd95>]
iput+0x105/0x210
Nov  6 21:57:09 thoregon kernel: [ 9941.104406]   [<ffffffff81107ba0>]
d_delete+0x150/0x190
Nov  6 21:57:09 thoregon kernel: [ 9941.104408]   [<ffffffff810ff8a7>]
vfs_rmdir+0x107/0x120
Nov  6 21:57:09 thoregon kernel: [ 9941.104411]   [<ffffffff810ff9a4>]
do_rmdir+0xe4/0x130
Nov  6 21:57:09 thoregon kernel: [ 9941.104413]   [<ffffffff81101c01>]
sys_rmdir+0x11/0x20
Nov  6 21:57:09 thoregon kernel: [ 9941.104415]   [<ffffffff816b2d12>]
system_call_fastpath+0x16/0x1b
Nov  6 21:57:09 thoregon kernel: [ 9941.104417] irq event stamp: 18505
Nov  6 21:57:09 thoregon kernel: [ 9941.104418] hardirqs last  enabled
at (18505): [<ffffffff816aec5d>] mutex_trylock+0xfd/0x170
Nov  6 21:57:09 thoregon kernel: [ 9941.104421] hardirqs last disabled
at (18504): [<ffffffff816aeb9e>] mutex_trylock+0x3e/0x170
Nov  6 21:57:09 thoregon kernel: [ 9941.104423] softirqs last  enabled
at (18492): [<ffffffff81042fb1>] __do_softirq+0x111/0x170
Nov  6 21:57:09 thoregon kernel: [ 9941.104426] softirqs last disabled
at (18477): [<ffffffff816b3e3c>] call_softirq+0x1c/0x30
Nov  6 21:57:09 thoregon kernel: [ 9941.104428]
Nov  6 21:57:09 thoregon kernel: [ 9941.104428] other info that might
help us debug this:
Nov  6 21:57:09 thoregon kernel: [ 9941.104429]  Possible unsafe
locking scenario:
Nov  6 21:57:09 thoregon kernel: [ 9941.104429]
Nov  6 21:57:09 thoregon kernel: [ 9941.104430]        CPU0
Nov  6 21:57:09 thoregon kernel: [ 9941.104431]        ----
Nov  6 21:57:09 thoregon kernel: [ 9941.104432]   lock(&(&ip->i_lock)->mr_lock);
Nov  6 21:57:09 thoregon kernel: [ 9941.104433]   <Interrupt>
Nov  6 21:57:09 thoregon kernel: [ 9941.104434]
lock(&(&ip->i_lock)->mr_lock);
Nov  6 21:57:09 thoregon kernel: [ 9941.104435]
Nov  6 21:57:09 thoregon kernel: [ 9941.104435]  *** DEADLOCK ***
Nov  6 21:57:09 thoregon kernel: [ 9941.104435]
Nov  6 21:57:09 thoregon kernel: [ 9941.104437] 3 locks held by kswapd0/725:
Nov  6 21:57:09 thoregon kernel: [ 9941.104438]  #0:
(shrinker_rwsem){++++..}, at: [<ffffffff810bbd22>]
shrink_slab+0x32/0x1f0
Nov  6 21:57:09 thoregon kernel: [ 9941.104442]  #1:
(&type->s_umount_key#20){++++.+}, at: [<ffffffff810f5a8e>]
grab_super_passive+0x3e/0x90
Nov  6 21:57:09 thoregon kernel: [ 9941.104446]  #2:
(&pag->pag_ici_reclaim_lock){+.+...}, at: [<ffffffff811f28ac>]
xfs_reclaim_inodes_ag+0xbc/0x4f0
Nov  6 21:57:09 thoregon kernel: [ 9941.104449]
Nov  6 21:57:09 thoregon kernel: [ 9941.104449] stack backtrace:
Nov  6 21:57:09 thoregon kernel: [ 9941.104451] Pid: 725, comm:
kswapd0 Not tainted 3.7.0-rc4 #1
Nov  6 21:57:09 thoregon kernel: [ 9941.104452] Call Trace:
Nov  6 21:57:09 thoregon kernel: [ 9941.104456]  [<ffffffff816a829c>]
print_usage_bug+0x1f5/0x206
Nov  6 21:57:09 thoregon kernel: [ 9941.104460]  [<ffffffff8100ed8a>]
? save_stack_trace+0x2a/0x50
Nov  6 21:57:09 thoregon kernel: [ 9941.104462]  [<ffffffff8107e9fd>]
mark_lock+0x28d/0x2f0
Nov  6 21:57:09 thoregon kernel: [ 9941.104464]  [<ffffffff8107de30>]
? print_irq_inversion_bug.part.37+0x1f0/0x1f0
Nov  6 21:57:09 thoregon kernel: [ 9941.104466]  [<ffffffff8107efdf>]
__lock_acquire+0x57f/0x1c00
Nov  6 21:57:09 thoregon kernel: [ 9941.104468]  [<ffffffff8107c899>]
? __lock_is_held+0x59/0x70
Nov  6 21:57:09 thoregon kernel: [ 9941.104470]  [<ffffffff81080b55>]
lock_acquire+0x55/0x70
Nov  6 21:57:09 thoregon kernel: [ 9941.104472]  [<ffffffff811e8164>]
? xfs_ilock+0x84/0xb0
Nov  6 21:57:09 thoregon kernel: [ 9941.104476]  [<ffffffff8106126a>]
down_write_nested+0x4a/0x70
Nov  6 21:57:09 thoregon kernel: [ 9941.104477]  [<ffffffff811e8164>]
? xfs_ilock+0x84/0xb0
Nov  6 21:57:09 thoregon kernel: [ 9941.104479]  [<ffffffff811e8164>]
xfs_ilock+0x84/0xb0
Nov  6 21:57:09 thoregon kernel: [ 9941.104481]  [<ffffffff811f1ce6>]
xfs_reclaim_inode+0x136/0x340
Nov  6 21:57:09 thoregon kernel: [ 9941.104483]  [<ffffffff811f2aaf>]
xfs_reclaim_inodes_ag+0x2bf/0x4f0
Nov  6 21:57:09 thoregon kernel: [ 9941.104485]  [<ffffffff811f28d0>]
? xfs_reclaim_inodes_ag+0xe0/0x4f0
Nov  6 21:57:09 thoregon kernel: [ 9941.104487]  [<ffffffff811f2e1e>]
xfs_reclaim_inodes_nr+0x2e/0x40
Nov  6 21:57:09 thoregon kernel: [ 9941.104489]  [<ffffffff811ef6f0>]
xfs_fs_free_cached_objects+0x10/0x20
Nov  6 21:57:09 thoregon kernel: [ 9941.104491]  [<ffffffff810f5bf3>]
prune_super+0x113/0x1a0
Nov  6 21:57:09 thoregon kernel: [ 9941.104493]  [<ffffffff810bbe0e>]
shrink_slab+0x11e/0x1f0
Nov  6 21:57:09 thoregon kernel: [ 9941.104496]  [<ffffffff810be400>]
kswapd+0x690/0xa10
Nov  6 21:57:09 thoregon kernel: [ 9941.104498]  [<ffffffff8105ca30>]
? __init_waitqueue_head+0x60/0x60
Nov  6 21:57:09 thoregon kernel: [ 9941.104500]  [<ffffffff810bdd70>]
? shrink_lruvec+0x540/0x540
Nov  6 21:57:09 thoregon kernel: [ 9941.104502]  [<ffffffff8105c246>]
kthread+0xd6/0xe0
Nov  6 21:57:09 thoregon kernel: [ 9941.104504]  [<ffffffff816b1efb>]
? _raw_spin_unlock_irq+0x2b/0x50
Nov  6 21:57:09 thoregon kernel: [ 9941.104506]  [<ffffffff8105c170>]
? flush_kthread_worker+0xe0/0xe0
Nov  6 21:57:09 thoregon kernel: [ 9941.104508]  [<ffffffff816b2c6c>]
ret_from_fork+0x7c/0xb0
Nov  6 21:57:09 thoregon kernel: [ 9941.104510]  [<ffffffff8105c170>]
? flush_kthread_worker+0xe0/0xe0

Nov 17 14:07:38 thoregon kernel: [66571.610863]
Nov 17 14:07:38 thoregon kernel: [66571.610869]
=========================================================
Nov 17 14:07:38 thoregon kernel: [66571.610870] [ INFO: possible irq
lock inversion dependency detected ]
Nov 17 14:07:38 thoregon kernel: [66571.610873] 3.7.0-rc5 #1 Not tainted
Nov 17 14:07:38 thoregon kernel: [66571.610874]
---------------------------------------------------------
Nov 17 14:07:38 thoregon kernel: [66571.610875] cc1/21330 just changed
the state of lock:
Nov 17 14:07:38 thoregon kernel: [66571.610877]
(sb_internal){.+.+.?}, at: [<ffffffff8122b138>]
xfs_trans_alloc+0x28/0x50
Nov 17 14:07:38 thoregon kernel: [66571.610885] but this lock took
another, RECLAIM_FS-unsafe lock in the past:
Nov 17 14:07:38 thoregon kernel: [66571.610886]
(&(&ip->i_lock)->mr_lock/1){+.+.+.}
Nov 17 14:07:38 thoregon kernel: [66571.610886]
Nov 17 14:07:39 thoregon kernel: [66571.610886] and interrupts could
create inverse lock ordering between them.
Nov 17 14:07:39 thoregon kernel: [66571.610886]
Nov 17 14:07:39 thoregon kernel: [66571.610890]
Nov 17 14:07:39 thoregon kernel: [66571.610890] other info that might
help us debug this:
Nov 17 14:07:39 thoregon kernel: [66571.610891]  Possible interrupt
unsafe locking scenario:
Nov 17 14:07:39 thoregon kernel: [66571.610891]
Nov 17 14:07:39 thoregon kernel: [66571.610892]        CPU0
        CPU1
Nov 17 14:07:39 thoregon kernel: [66571.610893]        ----
        ----
Nov 17 14:07:39 thoregon kernel: [66571.610894]
lock(&(&ip->i_lock)->mr_lock/1);
Nov 17 14:07:39 thoregon kernel: [66571.610896]
        local_irq_disable();
Nov 17 14:07:39 thoregon kernel: [66571.610897]
        lock(sb_internal);
Nov 17 14:07:39 thoregon kernel: [66571.610898]
        lock(&(&ip->i_lock)->mr_lock/1);
Nov 17 14:07:39 thoregon kernel: [66571.610900]   <Interrupt>
Nov 17 14:07:39 thoregon kernel: [66571.610901]     lock(sb_internal);
Nov 17 14:07:39 thoregon kernel: [66571.610902]
Nov 17 14:07:39 thoregon kernel: [66571.610902]  *** DEADLOCK ***
Nov 17 14:07:39 thoregon kernel: [66571.610902]
Nov 17 14:07:39 thoregon kernel: [66571.610904] 3 locks held by cc1/21330:
Nov 17 14:07:39 thoregon kernel: [66571.610905]  #0:
(&mm->mmap_sem){++++++}, at: [<ffffffff81029d8b>]
__do_page_fault+0xfb/0x480
Nov 17 14:07:39 thoregon kernel: [66571.610910]  #1:
(shrinker_rwsem){++++..}, at: [<ffffffff810bbd02>]
shrink_slab+0x32/0x1f0
Nov 17 14:07:39 thoregon kernel: [66571.610915]  #2:
(&type->s_umount_key#20){++++.+}, at: [<ffffffff810f5a7e>]
grab_super_passive+0x3e/0x90
Nov 17 14:07:39 thoregon kernel: [66571.610921]
Nov 17 14:07:39 thoregon kernel: [66571.610921] the shortest
dependencies between 2nd lock and 1st lock:
Nov 17 14:07:39 thoregon kernel: [66571.610927]  ->
(&(&ip->i_lock)->mr_lock/1){+.+.+.} ops: 169649 {
Nov 17 14:07:39 thoregon kernel: [66571.610931]     HARDIRQ-ON-W at:
Nov 17 14:07:39 thoregon kernel: [66571.610932]
[<ffffffff8107f091>] __lock_acquire+0x631/0x1c00
Nov 17 14:07:39 thoregon kernel: [66571.610935]
[<ffffffff81080b55>] lock_acquire+0x55/0x70
Nov 17 14:07:39 thoregon kernel: [66571.610937]
[<ffffffff8106126a>] down_write_nested+0x4a/0x70
Nov 17 14:07:39 thoregon kernel: [66571.610941]
[<ffffffff811e8164>] xfs_ilock+0x84/0xb0
Nov 17 14:07:39 thoregon kernel: [66571.610944]
[<ffffffff811f51a4>] xfs_create+0x1d4/0x5a0
Nov 17 14:07:39 thoregon kernel: [66571.610946]
[<ffffffff811eca2a>] xfs_vn_mknod+0x8a/0x1b0
Nov 17 14:07:39 thoregon kernel: [66571.610948]
[<ffffffff811ecb7e>] xfs_vn_create+0xe/0x10
Nov 17 14:07:39 thoregon kernel: [66571.610950]
[<ffffffff81100322>] vfs_create+0x72/0xc0
Nov 17 14:07:39 thoregon kernel: [66571.610953]
[<ffffffff81100b7e>] do_last.isra.69+0x80e/0xc80
Nov 17 14:07:39 thoregon kernel: [66571.610955]
[<ffffffff8110109b>] path_openat.isra.70+0xab/0x490
Nov 17 14:07:39 thoregon kernel: [66571.610957]
[<ffffffff8110183d>] do_filp_open+0x3d/0xa0
Nov 17 14:07:39 thoregon kernel: [66571.610959]
[<ffffffff810f2129>] do_sys_open+0xf9/0x1e0
Nov 17 14:07:39 thoregon kernel: [66571.610962]
[<ffffffff810f222c>] sys_open+0x1c/0x20
Nov 17 14:07:39 thoregon kernel: [66571.610964]
[<ffffffff816b2e52>] system_call_fastpath+0x16/0x1b
Nov 17 14:07:39 thoregon kernel: [66571.610967]     SOFTIRQ-ON-W at:
Nov 17 14:07:39 thoregon kernel: [66571.610968]
[<ffffffff8107f0c7>] __lock_acquire+0x667/0x1c00
Nov 17 14:07:39 thoregon kernel: [66571.610970]
[<ffffffff81080b55>] lock_acquire+0x55/0x70
Nov 17 14:07:39 thoregon kernel: [66571.610972]
[<ffffffff8106126a>] down_write_nested+0x4a/0x70
Nov 17 14:07:39 thoregon kernel: [66571.610974]
[<ffffffff811e8164>] xfs_ilock+0x84/0xb0
Nov 17 14:07:39 thoregon kernel: [66571.610976]
[<ffffffff811f51a4>] xfs_create+0x1d4/0x5a0
Nov 17 14:07:39 thoregon kernel: [66571.610977]
[<ffffffff811eca2a>] xfs_vn_mknod+0x8a/0x1b0
Nov 17 14:07:39 thoregon kernel: [66571.610979]
[<ffffffff811ecb7e>] xfs_vn_create+0xe/0x10
Nov 17 14:07:39 thoregon kernel: [66571.610981]
[<ffffffff81100322>] vfs_create+0x72/0xc0
Nov 17 14:07:39 thoregon kernel: [66571.610983]
[<ffffffff81100b7e>] do_last.isra.69+0x80e/0xc80
Nov 17 14:07:39 thoregon kernel: [66571.610985]
[<ffffffff8110109b>] path_openat.isra.70+0xab/0x490
Nov 17 14:07:39 thoregon kernel: [66571.610987]
[<ffffffff8110183d>] do_filp_open+0x3d/0xa0
Nov 17 14:07:39 thoregon kernel: [66571.610989]
[<ffffffff810f2129>] do_sys_open+0xf9/0x1e0
Nov 17 14:07:39 thoregon kernel: [66571.610991]
[<ffffffff810f222c>] sys_open+0x1c/0x20
Nov 17 14:07:39 thoregon kernel: [66571.610993]
[<ffffffff816b2e52>] system_call_fastpath+0x16/0x1b
Nov 17 14:07:39 thoregon kernel: [66571.610995]     RECLAIM_FS-ON-W at:
Nov 17 14:07:39 thoregon kernel: [66571.610996]
  [<ffffffff8108137e>] mark_held_locks+0x7e/0x130
Nov 17 14:07:39 thoregon kernel: [66571.610998]
  [<ffffffff81081a63>] lockdep_trace_alloc+0x63/0xc0
Nov 17 14:07:39 thoregon kernel: [66571.610999]
  [<ffffffff810e9dc5>] kmem_cache_alloc+0x35/0xe0
Nov 17 14:07:39 thoregon kernel: [66571.611002]
  [<ffffffff810dba21>] vm_map_ram+0x271/0x770
Nov 17 14:07:39 thoregon kernel: [66571.611004]
  [<ffffffff811e12b6>] _xfs_buf_map_pages+0x46/0xe0
Nov 17 14:07:39 thoregon kernel: [66571.611008]
  [<ffffffff811e21ca>] xfs_buf_get_map+0x8a/0x130
Nov 17 14:07:39 thoregon kernel: [66571.611009]
  [<ffffffff81233989>] xfs_trans_get_buf_map+0xa9/0xd0
Nov 17 14:07:39 thoregon kernel: [66571.611011]
  [<ffffffff8121bc2d>] xfs_ialloc_inode_init+0xcd/0x1d0
Nov 17 14:07:39 thoregon kernel: [66571.611015]
  [<ffffffff8121c16f>] xfs_ialloc_ag_alloc+0x18f/0x500
Nov 17 14:07:39 thoregon kernel: [66571.611017]
  [<ffffffff8121d955>] xfs_dialloc+0x185/0x2a0
Nov 17 14:07:39 thoregon kernel: [66571.611019]
  [<ffffffff8121f068>] xfs_ialloc+0x58/0x650
Nov 17 14:07:39 thoregon kernel: [66571.611021]
  [<ffffffff811f3995>] xfs_dir_ialloc+0x65/0x270
Nov 17 14:07:39 thoregon kernel: [66571.611023]
  [<ffffffff811f537c>] xfs_create+0x3ac/0x5a0
Nov 17 14:07:39 thoregon kernel: [66571.611024]
  [<ffffffff811eca2a>] xfs_vn_mknod+0x8a/0x1b0
Nov 17 14:07:39 thoregon kernel: [66571.611026]
  [<ffffffff811ecb61>] xfs_vn_mkdir+0x11/0x20
Nov 17 14:07:39 thoregon kernel: [66571.611028]
  [<ffffffff8110016f>] vfs_mkdir+0x7f/0xd0
Nov 17 14:07:39 thoregon kernel: [66571.611030]
  [<ffffffff81101b83>] sys_mkdirat+0x43/0x80
Nov 17 14:07:39 thoregon kernel: [66571.611032]
  [<ffffffff81101bd4>] sys_mkdir+0x14/0x20
Nov 17 14:07:39 thoregon kernel: [66571.611034]
  [<ffffffff816b2e52>] system_call_fastpath+0x16/0x1b
Nov 17 14:07:39 thoregon kernel: [66571.611036]     INITIAL USE at:
Nov 17 14:07:39 thoregon kernel: [66571.611037]
[<ffffffff8107ed49>] __lock_acquire+0x2e9/0x1c00
Nov 17 14:07:39 thoregon kernel: [66571.611038]
[<ffffffff81080b55>] lock_acquire+0x55/0x70
Nov 17 14:07:39 thoregon kernel: [66571.611040]
[<ffffffff8106126a>] down_write_nested+0x4a/0x70
Nov 17 14:07:39 thoregon kernel: [66571.611042]
[<ffffffff811e8164>] xfs_ilock+0x84/0xb0
Nov 17 14:07:39 thoregon kernel: [66571.611044]
[<ffffffff811f51a4>] xfs_create+0x1d4/0x5a0
Nov 17 14:07:39 thoregon kernel: [66571.611046]
[<ffffffff811eca2a>] xfs_vn_mknod+0x8a/0x1b0
Nov 17 14:07:39 thoregon kernel: [66571.611047]
[<ffffffff811ecb7e>] xfs_vn_create+0xe/0x10
Nov 17 14:07:39 thoregon kernel: [66571.611049]
[<ffffffff81100322>] vfs_create+0x72/0xc0
Nov 17 14:07:39 thoregon kernel: [66571.611051]
[<ffffffff81100b7e>] do_last.isra.69+0x80e/0xc80
Nov 17 14:07:39 thoregon kernel: [66571.611053]
[<ffffffff8110109b>] path_openat.isra.70+0xab/0x490
Nov 17 14:07:39 thoregon kernel: [66571.611055]
[<ffffffff8110183d>] do_filp_open+0x3d/0xa0
Nov 17 14:07:39 thoregon kernel: [66571.611057]
[<ffffffff810f2129>] do_sys_open+0xf9/0x1e0
Nov 17 14:07:39 thoregon kernel: [66571.611059]
[<ffffffff810f222c>] sys_open+0x1c/0x20
Nov 17 14:07:39 thoregon kernel: [66571.611061]
[<ffffffff816b2e52>] system_call_fastpath+0x16/0x1b
Nov 17 14:07:39 thoregon kernel: [66571.611063]   }
Nov 17 14:07:39 thoregon kernel: [66571.611064]   ... key      at:
[<ffffffff825b4b81>] __key.41357+0x1/0x8
Nov 17 14:07:39 thoregon kernel: [66571.611066]   ... acquired at:
Nov 17 14:07:39 thoregon kernel: [66571.611067]
[<ffffffff81080b55>] lock_acquire+0x55/0x70
Nov 17 14:07:39 thoregon kernel: [66571.611069]
[<ffffffff8106126a>] down_write_nested+0x4a/0x70
Nov 17 14:07:39 thoregon kernel: [66571.611071]
[<ffffffff811e8164>] xfs_ilock+0x84/0xb0
Nov 17 14:07:39 thoregon kernel: [66571.611073]
[<ffffffff811f51a4>] xfs_create+0x1d4/0x5a0
Nov 17 14:07:39 thoregon kernel: [66571.611074]
[<ffffffff811eca2a>] xfs_vn_mknod+0x8a/0x1b0
Nov 17 14:07:39 thoregon kernel: [66571.611076]
[<ffffffff811ecb7e>] xfs_vn_create+0xe/0x10
Nov 17 14:07:39 thoregon kernel: [66571.611078]
[<ffffffff81100322>] vfs_create+0x72/0xc0
Nov 17 14:07:39 thoregon kernel: [66571.611080]
[<ffffffff81100b7e>] do_last.isra.69+0x80e/0xc80
Nov 17 14:07:39 thoregon kernel: [66571.611082]
[<ffffffff8110109b>] path_openat.isra.70+0xab/0x490
Nov 17 14:07:39 thoregon kernel: [66571.611084]
[<ffffffff8110183d>] do_filp_open+0x3d/0xa0
Nov 17 14:07:39 thoregon kernel: [66571.611086]
[<ffffffff810f2129>] do_sys_open+0xf9/0x1e0
Nov 17 14:07:39 thoregon kernel: [66571.611088]
[<ffffffff810f222c>] sys_open+0x1c/0x20
Nov 17 14:07:39 thoregon kernel: [66571.611090]
[<ffffffff816b2e52>] system_call_fastpath+0x16/0x1b
Nov 17 14:07:39 thoregon kernel: [66571.611091]
Nov 17 14:07:39 thoregon kernel: [66571.611092] ->
(sb_internal){.+.+.?} ops: 1341531 {
Nov 17 14:07:39 thoregon kernel: [66571.611095]    HARDIRQ-ON-R at:
Nov 17 14:07:39 thoregon kernel: [66571.611096]
[<ffffffff8107ef6a>] __lock_acquire+0x50a/0x1c00
Nov 17 14:07:39 thoregon kernel: [66571.611098]
[<ffffffff81080b55>] lock_acquire+0x55/0x70
Nov 17 14:07:39 thoregon kernel: [66571.611100]
[<ffffffff810f451b>] __sb_start_write+0xab/0x190
Nov 17 14:07:39 thoregon kernel: [66571.611102]
[<ffffffff8122b138>] xfs_trans_alloc+0x28/0x50
Nov 17 14:07:39 thoregon kernel: [66571.611104]
[<ffffffff811f5157>] xfs_create+0x187/0x5a0
Nov 17 14:07:39 thoregon kernel: [66571.611105]
[<ffffffff811eca2a>] xfs_vn_mknod+0x8a/0x1b0
Nov 17 14:07:39 thoregon kernel: [66571.611107]
[<ffffffff811ecb7e>] xfs_vn_create+0xe/0x10
Nov 17 14:07:39 thoregon kernel: [66571.611109]
[<ffffffff81100322>] vfs_create+0x72/0xc0
Nov 17 14:07:39 thoregon kernel: [66571.611111]
[<ffffffff81100b7e>] do_last.isra.69+0x80e/0xc80
Nov 17 14:07:39 thoregon kernel: [66571.611113]
[<ffffffff8110109b>] path_openat.isra.70+0xab/0x490
Nov 17 14:07:39 thoregon kernel: [66571.611115]
[<ffffffff8110183d>] do_filp_open+0x3d/0xa0
Nov 17 14:07:39 thoregon kernel: [66571.611117]
[<ffffffff810f2129>] do_sys_open+0xf9/0x1e0
Nov 17 14:07:39 thoregon kernel: [66571.611119]
[<ffffffff810f222c>] sys_open+0x1c/0x20
Nov 17 14:07:39 thoregon kernel: [66571.611121]
[<ffffffff816b2e52>] system_call_fastpath+0x16/0x1b
Nov 17 14:07:39 thoregon kernel: [66571.611123]    SOFTIRQ-ON-R at:
Nov 17 14:07:39 thoregon kernel: [66571.611124]
[<ffffffff8107f0c7>] __lock_acquire+0x667/0x1c00
Nov 17 14:07:39 thoregon kernel: [66571.611126]
[<ffffffff81080b55>] lock_acquire+0x55/0x70
Nov 17 14:07:39 thoregon kernel: [66571.611128]
[<ffffffff810f451b>] __sb_start_write+0xab/0x190
Nov 17 14:07:39 thoregon kernel: [66571.611130]
[<ffffffff8122b138>] xfs_trans_alloc+0x28/0x50
Nov 17 14:07:39 thoregon kernel: [66571.611132]
[<ffffffff811f5157>] xfs_create+0x187/0x5a0
Nov 17 14:07:39 thoregon kernel: [66571.611133]
[<ffffffff811eca2a>] xfs_vn_mknod+0x8a/0x1b0
Nov 17 14:07:39 thoregon kernel: [66571.611135]
[<ffffffff811ecb7e>] xfs_vn_create+0xe/0x10
Nov 17 14:07:39 thoregon kernel: [66571.611137]
[<ffffffff81100322>] vfs_create+0x72/0xc0
Nov 17 14:07:39 thoregon kernel: [66571.611139]
[<ffffffff81100b7e>] do_last.isra.69+0x80e/0xc80
Nov 17 14:07:39 thoregon kernel: [66571.611141]
[<ffffffff8110109b>] path_openat.isra.70+0xab/0x490
Nov 17 14:07:39 thoregon kernel: [66571.611143]
[<ffffffff8110183d>] do_filp_open+0x3d/0xa0
Nov 17 14:07:39 thoregon kernel: [66571.611145]
[<ffffffff810f2129>] do_sys_open+0xf9/0x1e0
Nov 17 14:07:39 thoregon kernel: [66571.611147]
[<ffffffff810f222c>] sys_open+0x1c/0x20
Nov 17 14:07:39 thoregon kernel: [66571.611149]
[<ffffffff816b2e52>] system_call_fastpath+0x16/0x1b
Nov 17 14:07:39 thoregon kernel: [66571.611151]    IN-RECLAIM_FS-R at:
Nov 17 14:07:39 thoregon kernel: [66571.611152]
[<ffffffff8107efdf>] __lock_acquire+0x57f/0x1c00
Nov 17 14:07:39 thoregon kernel: [66571.611154]
[<ffffffff81080b55>] lock_acquire+0x55/0x70
Nov 17 14:07:39 thoregon kernel: [66571.611156]
[<ffffffff810f451b>] __sb_start_write+0xab/0x190
Nov 17 14:07:39 thoregon kernel: [66571.611158]
[<ffffffff8122b138>] xfs_trans_alloc+0x28/0x50
Nov 17 14:07:39 thoregon kernel: [66571.611159]
[<ffffffff811f3e64>] xfs_free_eofblocks+0x104/0x250
Nov 17 14:07:39 thoregon kernel: [66571.611161]
[<ffffffff811f4b39>] xfs_inactive+0xa9/0x480
Nov 17 14:07:39 thoregon kernel: [66571.611163]
[<ffffffff811efe10>] xfs_fs_evict_inode+0x70/0x80
Nov 17 14:07:39 thoregon kernel: [66571.611165]
[<ffffffff8110cb7f>] evict+0xaf/0x1b0
Nov 17 14:07:39 thoregon kernel: [66571.611168]
[<ffffffff8110d209>] dispose_list+0x39/0x50
Nov 17 14:07:39 thoregon kernel: [66571.611170]
[<ffffffff8110dc63>] prune_icache_sb+0x183/0x340
Nov 17 14:07:39 thoregon kernel: [66571.611172]
[<ffffffff810f5bc3>] prune_super+0xf3/0x1a0
Nov 17 14:07:39 thoregon kernel: [66571.611173]
[<ffffffff810bbdee>] shrink_slab+0x11e/0x1f0
Nov 17 14:07:39 thoregon kernel: [66571.611175]
[<ffffffff810be98f>] try_to_free_pages+0x21f/0x4e0
Nov 17 14:07:39 thoregon kernel: [66571.611177]
[<ffffffff810b5ec6>] __alloc_pages_nodemask+0x506/0x800
Nov 17 14:07:39 thoregon kernel: [66571.611179]
[<ffffffff810ce56e>] handle_pte_fault+0x5ae/0x7a0
Nov 17 14:07:39 thoregon kernel: [66571.611182]
[<ffffffff810cf769>] handle_mm_fault+0x1f9/0x2a0
Nov 17 14:07:39 thoregon kernel: [66571.611184]
[<ffffffff81029dfc>] __do_page_fault+0x16c/0x480
Nov 17 14:07:39 thoregon kernel: [66571.611186]
[<ffffffff8102a139>] do_page_fault+0x9/0x10
Nov 17 14:07:39 thoregon kernel: [66571.611188]
[<ffffffff816b287f>] page_fault+0x1f/0x30
Nov 17 14:07:39 thoregon kernel: [66571.611190]    RECLAIM_FS-ON-R at:
Nov 17 14:07:39 thoregon kernel: [66571.611191]
[<ffffffff8108137e>] mark_held_locks+0x7e/0x130
Nov 17 14:07:39 thoregon kernel: [66571.611193]
[<ffffffff81081a63>] lockdep_trace_alloc+0x63/0xc0
Nov 17 14:07:39 thoregon kernel: [66571.611195]
[<ffffffff810e9dc5>] kmem_cache_alloc+0x35/0xe0
Nov 17 14:07:39 thoregon kernel: [66571.611197]
[<ffffffff811f6d4f>] kmem_zone_alloc+0x5f/0xe0
Nov 17 14:07:39 thoregon kernel: [66571.611198]
[<ffffffff811f6de8>] kmem_zone_zalloc+0x18/0x50
Nov 17 14:07:39 thoregon kernel: [66571.611200]
[<ffffffff8122b0b2>] _xfs_trans_alloc+0x32/0x90
Nov 17 14:07:39 thoregon kernel: [66571.611202]
[<ffffffff8122b148>] xfs_trans_alloc+0x38/0x50
Nov 17 14:07:39 thoregon kernel: [66571.611204]
[<ffffffff811f5157>] xfs_create+0x187/0x5a0
Nov 17 14:07:39 thoregon kernel: [66571.611205]
[<ffffffff811eca2a>] xfs_vn_mknod+0x8a/0x1b0
Nov 17 14:07:39 thoregon kernel: [66571.611207]
[<ffffffff811ecb7e>] xfs_vn_create+0xe/0x10
Nov 17 14:07:39 thoregon kernel: [66571.611209]
[<ffffffff81100322>] vfs_create+0x72/0xc0
Nov 17 14:07:39 thoregon kernel: [66571.611211]
[<ffffffff81100b7e>] do_last.isra.69+0x80e/0xc80
Nov 17 14:07:39 thoregon kernel: [66571.611213]
[<ffffffff8110109b>] path_openat.isra.70+0xab/0x490
Nov 17 14:07:39 thoregon kernel: [66571.611215]
[<ffffffff8110183d>] do_filp_open+0x3d/0xa0
Nov 17 14:07:39 thoregon kernel: [66571.611217]
[<ffffffff810f2129>] do_sys_open+0xf9/0x1e0
Nov 17 14:07:39 thoregon kernel: [66571.611219]
[<ffffffff810f222c>] sys_open+0x1c/0x20
Nov 17 14:07:39 thoregon kernel: [66571.611221]
[<ffffffff816b2e52>] system_call_fastpath+0x16/0x1b
Nov 17 14:07:39 thoregon kernel: [66571.611223]    INITIAL USE at:
Nov 17 14:07:39 thoregon kernel: [66571.611224]
[<ffffffff8107ed49>] __lock_acquire+0x2e9/0x1c00
Nov 17 14:07:39 thoregon kernel: [66571.611225]
[<ffffffff81080b55>] lock_acquire+0x55/0x70
Nov 17 14:07:39 thoregon kernel: [66571.611227]
[<ffffffff810f451b>] __sb_start_write+0xab/0x190
Nov 17 14:07:39 thoregon kernel: [66571.611229]
[<ffffffff8122b138>] xfs_trans_alloc+0x28/0x50
Nov 17 14:07:39 thoregon kernel: [66571.611231]
[<ffffffff811f5157>] xfs_create+0x187/0x5a0
Nov 17 14:07:39 thoregon kernel: [66571.611232]
[<ffffffff811eca2a>] xfs_vn_mknod+0x8a/0x1b0
Nov 17 14:07:39 thoregon kernel: [66571.611234]
[<ffffffff811ecb7e>] xfs_vn_create+0xe/0x10
Nov 17 14:07:39 thoregon kernel: [66571.611236]
[<ffffffff81100322>] vfs_create+0x72/0xc0
Nov 17 14:07:39 thoregon kernel: [66571.611238]
[<ffffffff81100b7e>] do_last.isra.69+0x80e/0xc80
Nov 17 14:07:39 thoregon kernel: [66571.611240]
[<ffffffff8110109b>] path_openat.isra.70+0xab/0x490
Nov 17 14:07:39 thoregon kernel: [66571.611242]
[<ffffffff8110183d>] do_filp_open+0x3d/0xa0
Nov 17 14:07:39 thoregon kernel: [66571.611244]
[<ffffffff810f2129>] do_sys_open+0xf9/0x1e0
Nov 17 14:07:39 thoregon kernel: [66571.611246]
[<ffffffff810f222c>] sys_open+0x1c/0x20
Nov 17 14:07:39 thoregon kernel: [66571.611248]
[<ffffffff816b2e52>] system_call_fastpath+0x16/0x1b
Nov 17 14:07:39 thoregon kernel: [66571.611250]  }
Nov 17 14:07:39 thoregon kernel: [66571.611251]  ... key      at:
[<ffffffff81c34e40>] xfs_fs_type+0x60/0x80
Nov 17 14:07:39 thoregon kernel: [66571.611254]  ... acquired at:
Nov 17 14:07:39 thoregon kernel: [66571.611254]
[<ffffffff8107df3b>] check_usage_forwards+0x10b/0x140
Nov 17 14:07:39 thoregon kernel: [66571.611256]
[<ffffffff8107e900>] mark_lock+0x190/0x2f0
Nov 17 14:07:39 thoregon kernel: [66571.611258]
[<ffffffff8107efdf>] __lock_acquire+0x57f/0x1c00
Nov 17 14:07:39 thoregon kernel: [66571.611260]
[<ffffffff81080b55>] lock_acquire+0x55/0x70
Nov 17 14:07:39 thoregon kernel: [66571.611261]
[<ffffffff810f451b>] __sb_start_write+0xab/0x190
Nov 17 14:07:39 thoregon kernel: [66571.611263]
[<ffffffff8122b138>] xfs_trans_alloc+0x28/0x50
Nov 17 14:07:39 thoregon kernel: [66571.611265]
[<ffffffff811f3e64>] xfs_free_eofblocks+0x104/0x250
Nov 17 14:07:39 thoregon kernel: [66571.611266]
[<ffffffff811f4b39>] xfs_inactive+0xa9/0x480
Nov 17 14:07:39 thoregon kernel: [66571.611268]
[<ffffffff811efe10>] xfs_fs_evict_inode+0x70/0x80
Nov 17 14:07:39 thoregon kernel: [66571.611270]
[<ffffffff8110cb7f>] evict+0xaf/0x1b0
Nov 17 14:07:39 thoregon kernel: [66571.611271]
[<ffffffff8110d209>] dispose_list+0x39/0x50
Nov 17 14:07:39 thoregon kernel: [66571.611273]
[<ffffffff8110dc63>] prune_icache_sb+0x183/0x340
Nov 17 14:07:39 thoregon kernel: [66571.611275]
[<ffffffff810f5bc3>] prune_super+0xf3/0x1a0
Nov 17 14:07:39 thoregon kernel: [66571.611277]
[<ffffffff810bbdee>] shrink_slab+0x11e/0x1f0
Nov 17 14:07:39 thoregon kernel: [66571.611278]
[<ffffffff810be98f>] try_to_free_pages+0x21f/0x4e0
Nov 17 14:07:39 thoregon kernel: [66571.611280]
[<ffffffff810b5ec6>] __alloc_pages_nodemask+0x506/0x800
Nov 17 14:07:39 thoregon kernel: [66571.611282]
[<ffffffff810ce56e>] handle_pte_fault+0x5ae/0x7a0
Nov 17 14:07:39 thoregon kernel: [66571.611284]
[<ffffffff810cf769>] handle_mm_fault+0x1f9/0x2a0
Nov 17 14:07:39 thoregon kernel: [66571.611286]
[<ffffffff81029dfc>] __do_page_fault+0x16c/0x480
Nov 17 14:07:39 thoregon kernel: [66571.611287]
[<ffffffff8102a139>] do_page_fault+0x9/0x10
Nov 17 14:07:39 thoregon kernel: [66571.611289]
[<ffffffff816b287f>] page_fault+0x1f/0x30
Nov 17 14:07:39 thoregon kernel: [66571.611291]
Nov 17 14:07:39 thoregon kernel: [66571.611292]
Nov 17 14:07:39 thoregon kernel: [66571.611292] stack backtrace:
Nov 17 14:07:39 thoregon kernel: [66571.611294] Pid: 21330, comm: cc1
Not tainted 3.7.0-rc5 #1
Nov 17 14:07:39 thoregon kernel: [66571.611295] Call Trace:
Nov 17 14:07:39 thoregon kernel: [66571.611298]  [<ffffffff8107de28>]
print_irq_inversion_bug.part.37+0x1e8/0x1f0
Nov 17 14:07:39 thoregon kernel: [66571.611300]  [<ffffffff8107df3b>]
check_usage_forwards+0x10b/0x140
Nov 17 14:07:39 thoregon kernel: [66571.611303]  [<ffffffff8107e900>]
mark_lock+0x190/0x2f0
Nov 17 14:07:39 thoregon kernel: [66571.611306]  [<ffffffff8150406e>]
? dm_request+0x2e/0x2a0
Nov 17 14:07:39 thoregon kernel: [66571.611308]  [<ffffffff8107de30>]
? print_irq_inversion_bug.part.37+0x1f0/0x1f0
Nov 17 14:07:39 thoregon kernel: [66571.611310]  [<ffffffff8107efdf>]
__lock_acquire+0x57f/0x1c00
Nov 17 14:07:39 thoregon kernel: [66571.611313]  [<ffffffff812202f4>]
? xfs_iext_bno_to_ext+0x84/0x160
Nov 17 14:07:39 thoregon kernel: [66571.611316]  [<ffffffff8120a023>]
? xfs_bmbt_get_all+0x13/0x20
Nov 17 14:07:39 thoregon kernel: [66571.611318]  [<ffffffff81200fb4>]
? xfs_bmap_search_multi_extents+0xa4/0x110
Nov 17 14:07:39 thoregon kernel: [66571.611320]  [<ffffffff81080b55>]
lock_acquire+0x55/0x70
Nov 17 14:07:39 thoregon kernel: [66571.611322]  [<ffffffff8122b138>]
? xfs_trans_alloc+0x28/0x50
Nov 17 14:07:39 thoregon kernel: [66571.611324]  [<ffffffff810f451b>]
__sb_start_write+0xab/0x190
Nov 17 14:07:39 thoregon kernel: [66571.611326]  [<ffffffff8122b138>]
? xfs_trans_alloc+0x28/0x50
Nov 17 14:07:39 thoregon kernel: [66571.611328]  [<ffffffff8122b138>]
? xfs_trans_alloc+0x28/0x50
Nov 17 14:07:39 thoregon kernel: [66571.611330]  [<ffffffff8122b138>]
xfs_trans_alloc+0x28/0x50
Nov 17 14:07:39 thoregon kernel: [66571.611332]  [<ffffffff811f3e64>]
xfs_free_eofblocks+0x104/0x250
Nov 17 14:07:39 thoregon kernel: [66571.611334]  [<ffffffff816b204b>]
? _raw_spin_unlock_irq+0x2b/0x50
Nov 17 14:07:39 thoregon kernel: [66571.611336]  [<ffffffff811f4b39>]
xfs_inactive+0xa9/0x480
Nov 17 14:07:39 thoregon kernel: [66571.611337]  [<ffffffff816b204b>]
? _raw_spin_unlock_irq+0x2b/0x50
Nov 17 14:07:39 thoregon kernel: [66571.611340]  [<ffffffff811efe10>]
xfs_fs_evict_inode+0x70/0x80
Nov 17 14:07:39 thoregon kernel: [66571.611342]  [<ffffffff8110cb7f>]
evict+0xaf/0x1b0
Nov 17 14:07:39 thoregon kernel: [66571.611344]  [<ffffffff8110d209>]
dispose_list+0x39/0x50
Nov 17 14:07:39 thoregon kernel: [66571.611346]  [<ffffffff8110dc63>]
prune_icache_sb+0x183/0x340
Nov 17 14:07:39 thoregon kernel: [66571.611347]  [<ffffffff810f5bc3>]
prune_super+0xf3/0x1a0
Nov 17 14:07:39 thoregon kernel: [66571.611349]  [<ffffffff810bbdee>]
shrink_slab+0x11e/0x1f0
Nov 17 14:07:39 thoregon kernel: [66571.611352]  [<ffffffff810be98f>]
try_to_free_pages+0x21f/0x4e0
Nov 17 14:07:39 thoregon kernel: [66571.611354]  [<ffffffff810b5ec6>]
__alloc_pages_nodemask+0x506/0x800
Nov 17 14:07:39 thoregon kernel: [66571.611356]  [<ffffffff810b9e40>]
? lru_deactivate_fn+0x1c0/0x1c0
Nov 17 14:07:39 thoregon kernel: [66571.611358]  [<ffffffff810ce56e>]
handle_pte_fault+0x5ae/0x7a0
Nov 17 14:07:39 thoregon kernel: [66571.611360]  [<ffffffff810cf769>]
handle_mm_fault+0x1f9/0x2a0
Nov 17 14:07:39 thoregon kernel: [66571.611363]  [<ffffffff81029dfc>]
__do_page_fault+0x16c/0x480
Nov 17 14:07:39 thoregon kernel: [66571.611366]  [<ffffffff8129c7ad>]
? trace_hardirqs_off_thunk+0x3a/0x3c
Nov 17 14:07:39 thoregon kernel: [66571.611368]  [<ffffffff8102a139>]
do_page_fault+0x9/0x10
Nov 17 14:07:39 thoregon kernel: [66571.611370]  [<ffffffff816b287f>]
page_fault+0x1f/0x30

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
