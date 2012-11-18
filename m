Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAIFRIQ6158733 for <xfs@oss.sgi.com>; Sun, 18 Nov 2012 09:27:18 -0600
Received: from mail-ee0-f53.google.com (mail-ee0-f53.google.com
	[74.125.83.53]) by cuda.sgi.com with ESMTP id 94C7txU81EOU0a6W
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 18 Nov 2012 07:29:23 -0800 (PST)
Received: by mail-ee0-f53.google.com with SMTP id c50so2739081eek.26
	for <xfs@oss.sgi.com>; Sun, 18 Nov 2012 07:29:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPVoSvRks32ZM7n6U8but-vEj622TEFqAFdxXqS_6mRxyv=0Ew@mail.gmail.com>
References: <CAPVoSvSM9=hictqwT2rzZA-fU_XSwd-_FRzW_J+HQYj7iohTWQ@mail.gmail.com>
	<20121029222613.GU29378@dastard>
	<CAPVoSvQATjAVu-D477mrr6K9d0FeY7sH27cH-zNBYMJcRoUY0Q@mail.gmail.com>
	<CAPVoSvRks32ZM7n6U8but-vEj622TEFqAFdxXqS_6mRxyv=0Ew@mail.gmail.com>
Date: Sun, 18 Nov 2012 16:29:22 +0100
Message-ID: <CAPVoSvSKn2FuBhMF+3U1ueuEzBqL4CFTYFGXqGczTa42PgMjRw@mail.gmail.com>
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

On Sun, Nov 18, 2012 at 11:24 AM, Torsten Kaiser
<just.for.lkml@googlemail.com> wrote:
> On Tue, Oct 30, 2012 at 9:37 PM, Torsten Kaiser
> <just.for.lkml@googlemail.com> wrote:
>> I will keep LOCKDEP enabled on that system, and if there really is
>> another splat, I will report back here. But I rather doubt that this
>> will be needed.
>
> After the patch, I did not see this problem again, but today I found
> another LOCKDEP report that also looks XFS related.
> I found it twice in the logs, and as both were slightly different, I
> will attach both versions.

> Nov  6 21:57:09 thoregon kernel: [ 9941.104353] 3.7.0-rc4 #1 Not tainted
> Nov  6 21:57:09 thoregon kernel: [ 9941.104355] inconsistent
> {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
> Nov  6 21:57:09 thoregon kernel: [ 9941.104430]        CPU0
> Nov  6 21:57:09 thoregon kernel: [ 9941.104431]        ----
> Nov  6 21:57:09 thoregon kernel: [ 9941.104432]   lock(&(&ip->i_lock)->mr_lock);
> Nov  6 21:57:09 thoregon kernel: [ 9941.104433]   <Interrupt>
> Nov  6 21:57:09 thoregon kernel: [ 9941.104434]
> lock(&(&ip->i_lock)->mr_lock);
> Nov  6 21:57:09 thoregon kernel: [ 9941.104435]
> Nov  6 21:57:09 thoregon kernel: [ 9941.104435]  *** DEADLOCK ***

Sorry! Copied the wrong report. Your fix only landed in -rc5, so my
vanilla -rc4 did (also) report the old problem again.
And I copy&pasted that report instead of the second appearance of the
new problem.

Here is the correct second report of the sb_internal vs
ip->i_lock->mr_lock problem:
[110926.972477]
[110926.972482] =========================================================
[110926.972484] [ INFO: possible irq lock inversion dependency detected ]
[110926.972486] 3.7.0-rc4 #1 Not tainted
[110926.972487] ---------------------------------------------------------
[110926.972489] kswapd0/725 just changed the state of lock:
[110926.972490]  (sb_internal){.+.+.?}, at: [<ffffffff8122b268>]
xfs_trans_alloc+0x28/0x50
[110926.972499] but this lock took another, RECLAIM_FS-unsafe lock in the past:
[110926.972500]  (&(&ip->i_lock)->mr_lock/1){+.+.+.}
[110926.972500]
[110926.972500] and interrupts could create inverse lock ordering between them.
[110926.972500]
[110926.972503]
[110926.972503] other info that might help us debug this:
[110926.972504]  Possible interrupt unsafe locking scenario:
[110926.972504]
[110926.972505]        CPU0                    CPU1
[110926.972506]        ----                    ----
[110926.972507]   lock(&(&ip->i_lock)->mr_lock/1);
[110926.972509]                                local_irq_disable();
[110926.972509]                                lock(sb_internal);
[110926.972511]                                lock(&(&ip->i_lock)->mr_lock/1);
[110926.972512]   <Interrupt>
[110926.972513]     lock(sb_internal);
[110926.972514]
[110926.972514]  *** DEADLOCK ***
[110926.972514]
[110926.972516] 2 locks held by kswapd0/725:
[110926.972517]  #0:  (shrinker_rwsem){++++..}, at:
[<ffffffff810bbd22>] shrink_slab+0x32/0x1f0
[110926.972522]  #1:  (&type->s_umount_key#20){++++.+}, at:
[<ffffffff810f5a8e>] grab_super_passive+0x3e/0x90
[110926.972527]
[110926.972527] the shortest dependencies between 2nd lock and 1st lock:
[110926.972533]  -> (&(&ip->i_lock)->mr_lock/1){+.+.+.} ops: 58117 {
[110926.972536]     HARDIRQ-ON-W at:
[110926.972537]                       [<ffffffff8107f091>]
__lock_acquire+0x631/0x1c00
[110926.972540]                       [<ffffffff81080b55>]
lock_acquire+0x55/0x70
[110926.972542]                       [<ffffffff8106126a>]
down_write_nested+0x4a/0x70
[110926.972545]                       [<ffffffff811e8164>] xfs_ilock+0x84/0xb0
[110926.972548]                       [<ffffffff811f5194>]
xfs_create+0x1d4/0x5a0
[110926.972550]                       [<ffffffff811eca1a>]
xfs_vn_mknod+0x8a/0x1b0
[110926.972552]                       [<ffffffff811ecb6e>]
xfs_vn_create+0xe/0x10
[110926.972554]                       [<ffffffff81100332>] vfs_create+0x72/0xc0
[110926.972556]                       [<ffffffff81100b8e>]
do_last.isra.69+0x80e/0xc80
[110926.972558]                       [<ffffffff811010ab>]
path_openat.isra.70+0xab/0x490
[110926.972560]                       [<ffffffff8110184d>]
do_filp_open+0x3d/0xa0
[110926.972562]                       [<ffffffff810f2139>]
do_sys_open+0xf9/0x1e0
[110926.972565]                       [<ffffffff810f223c>] sys_open+0x1c/0x20
[110926.972567]                       [<ffffffff816b2d12>]
system_call_fastpath+0x16/0x1b
[110926.972570]     SOFTIRQ-ON-W at:
[110926.972571]                       [<ffffffff8107f0c7>]
__lock_acquire+0x667/0x1c00
[110926.972573]                       [<ffffffff81080b55>]
lock_acquire+0x55/0x70
[110926.972574]                       [<ffffffff8106126a>]
down_write_nested+0x4a/0x70
[110926.972576]                       [<ffffffff811e8164>] xfs_ilock+0x84/0xb0
[110926.972578]                       [<ffffffff811f5194>]
xfs_create+0x1d4/0x5a0
[110926.972580]                       [<ffffffff811eca1a>]
xfs_vn_mknod+0x8a/0x1b0
[110926.972581]                       [<ffffffff811ecb6e>]
xfs_vn_create+0xe/0x10
[110926.972583]                       [<ffffffff81100332>] vfs_create+0x72/0xc0
[110926.972585]                       [<ffffffff81100b8e>]
do_last.isra.69+0x80e/0xc80
[110926.972587]                       [<ffffffff811010ab>]
path_openat.isra.70+0xab/0x490
[110926.972589]                       [<ffffffff8110184d>]
do_filp_open+0x3d/0xa0
[110926.972591]                       [<ffffffff810f2139>]
do_sys_open+0xf9/0x1e0
[110926.972593]                       [<ffffffff810f223c>] sys_open+0x1c/0x20
[110926.972595]                       [<ffffffff816b2d12>]
system_call_fastpath+0x16/0x1b
[110926.972597]     RECLAIM_FS-ON-W at:
[110926.972598]                          [<ffffffff8108137e>]
mark_held_locks+0x7e/0x130
[110926.972600]                          [<ffffffff81081a63>]
lockdep_trace_alloc+0x63/0xc0
[110926.972601]                          [<ffffffff810e9dd5>]
kmem_cache_alloc+0x35/0xe0
[110926.972603]                          [<ffffffff810dba31>]
vm_map_ram+0x271/0x770
[110926.972606]                          [<ffffffff811e1316>]
_xfs_buf_map_pages+0x46/0xe0
[110926.972609]                          [<ffffffff811e222a>]
xfs_buf_get_map+0x8a/0x130
[110926.972610]                          [<ffffffff81233ab9>]
xfs_trans_get_buf_map+0xa9/0xd0
[110926.972613]                          [<ffffffff8121bced>]
xfs_ialloc_inode_init+0xcd/0x1d0
[110926.972616]                          [<ffffffff8121c25e>]
xfs_ialloc_ag_alloc+0x1be/0x560
[110926.972618]                          [<ffffffff8121da65>]
xfs_dialloc+0x185/0x2a0
[110926.972619]                          [<ffffffff8121f198>]
xfs_ialloc+0x58/0x650
[110926.972621]                          [<ffffffff811f3985>]
xfs_dir_ialloc+0x65/0x270
[110926.972623]                          [<ffffffff811f536c>]
xfs_create+0x3ac/0x5a0
[110926.972624]                          [<ffffffff811eca1a>]
xfs_vn_mknod+0x8a/0x1b0
[110926.972626]                          [<ffffffff811ecb6e>]
xfs_vn_create+0xe/0x10
[110926.972628]                          [<ffffffff81100332>]
vfs_create+0x72/0xc0
[110926.972630]                          [<ffffffff81100b8e>]
do_last.isra.69+0x80e/0xc80
[110926.972632]                          [<ffffffff811010ab>]
path_openat.isra.70+0xab/0x490
[110926.972634]                          [<ffffffff8110184d>]
do_filp_open+0x3d/0xa0
[110926.972636]                          [<ffffffff810f2139>]
do_sys_open+0xf9/0x1e0
[110926.972638]                          [<ffffffff810f223c>] sys_open+0x1c/0x20
[110926.972640]                          [<ffffffff816b2d12>]
system_call_fastpath+0x16/0x1b
[110926.972642]     INITIAL USE at:
[110926.972642]                      [<ffffffff8107ed49>]
__lock_acquire+0x2e9/0x1c00
[110926.972644]                      [<ffffffff81080b55>] lock_acquire+0x55/0x70
[110926.972646]                      [<ffffffff8106126a>]
down_write_nested+0x4a/0x70
[110926.972648]                      [<ffffffff811e8164>] xfs_ilock+0x84/0xb0
[110926.972650]                      [<ffffffff811f5194>] xfs_create+0x1d4/0x5a0
[110926.972651]                      [<ffffffff811eca1a>]
xfs_vn_mknod+0x8a/0x1b0
[110926.972653]                      [<ffffffff811ecb6e>] xfs_vn_create+0xe/0x10
[110926.972655]                      [<ffffffff81100332>] vfs_create+0x72/0xc0
[110926.972657]                      [<ffffffff81100b8e>]
do_last.isra.69+0x80e/0xc80
[110926.972659]                      [<ffffffff811010ab>]
path_openat.isra.70+0xab/0x490
[110926.972661]                      [<ffffffff8110184d>] do_filp_open+0x3d/0xa0
[110926.972663]                      [<ffffffff810f2139>] do_sys_open+0xf9/0x1e0
[110926.972664]                      [<ffffffff810f223c>] sys_open+0x1c/0x20
[110926.972666]                      [<ffffffff816b2d12>]
system_call_fastpath+0x16/0x1b
[110926.972668]   }
[110926.972669]   ... key      at: [<ffffffff825b4b81>] __key.41355+0x1/0x8
[110926.972672]   ... acquired at:
[110926.972672]    [<ffffffff81080b55>] lock_acquire+0x55/0x70
[110926.972674]    [<ffffffff8106126a>] down_write_nested+0x4a/0x70
[110926.972676]    [<ffffffff811e8164>] xfs_ilock+0x84/0xb0
[110926.972678]    [<ffffffff811f5194>] xfs_create+0x1d4/0x5a0
[110926.972679]    [<ffffffff811eca1a>] xfs_vn_mknod+0x8a/0x1b0
[110926.972681]    [<ffffffff811ecb6e>] xfs_vn_create+0xe/0x10
[110926.972683]    [<ffffffff81100332>] vfs_create+0x72/0xc0
[110926.972684]    [<ffffffff81100b8e>] do_last.isra.69+0x80e/0xc80
[110926.972686]    [<ffffffff811010ab>] path_openat.isra.70+0xab/0x490
[110926.972688]    [<ffffffff8110184d>] do_filp_open+0x3d/0xa0
[110926.972690]    [<ffffffff810f2139>] do_sys_open+0xf9/0x1e0
[110926.972692]    [<ffffffff810f223c>] sys_open+0x1c/0x20
[110926.972694]    [<ffffffff816b2d12>] system_call_fastpath+0x16/0x1b
[110926.972696]
[110926.972696] -> (sb_internal){.+.+.?} ops: 1710064 {
[110926.972699]    HARDIRQ-ON-R at:
[110926.972700]                     [<ffffffff8107ef6a>]
__lock_acquire+0x50a/0x1c00
[110926.972702]                     [<ffffffff81080b55>] lock_acquire+0x55/0x70
[110926.972704]                     [<ffffffff810f452b>]
__sb_start_write+0xab/0x190
[110926.972705]                     [<ffffffff8122b268>]
xfs_trans_alloc+0x28/0x50
[110926.972707]                     [<ffffffff811f5147>] xfs_create+0x187/0x5a0
[110926.972709]                     [<ffffffff811eca1a>] xfs_vn_mknod+0x8a/0x1b0
[110926.972711]                     [<ffffffff811ecb6e>] xfs_vn_create+0xe/0x10
[110926.972712]                     [<ffffffff81100332>] vfs_create+0x72/0xc0
[110926.972714]                     [<ffffffff81100b8e>]
do_last.isra.69+0x80e/0xc80
[110926.972716]                     [<ffffffff811010ab>]
path_openat.isra.70+0xab/0x490
[110926.972718]                     [<ffffffff8110184d>] do_filp_open+0x3d/0xa0
[110926.972720]                     [<ffffffff810f2139>] do_sys_open+0xf9/0x1e0
[110926.972722]                     [<ffffffff810f223c>] sys_open+0x1c/0x20
[110926.972724]                     [<ffffffff816b2d12>]
system_call_fastpath+0x16/0x1b
[110926.972726]    SOFTIRQ-ON-R at:
[110926.972727]                     [<ffffffff8107f0c7>]
__lock_acquire+0x667/0x1c00
[110926.972728]                     [<ffffffff81080b55>] lock_acquire+0x55/0x70
[110926.972730]                     [<ffffffff810f452b>]
__sb_start_write+0xab/0x190
[110926.972732]                     [<ffffffff8122b268>]
xfs_trans_alloc+0x28/0x50
[110926.972734]                     [<ffffffff811f5147>] xfs_create+0x187/0x5a0
[110926.972735]                     [<ffffffff811eca1a>] xfs_vn_mknod+0x8a/0x1b0
[110926.972737]                     [<ffffffff811ecb6e>] xfs_vn_create+0xe/0x10
[110926.972739]                     [<ffffffff81100332>] vfs_create+0x72/0xc0
[110926.972741]                     [<ffffffff81100b8e>]
do_last.isra.69+0x80e/0xc80
[110926.972743]                     [<ffffffff811010ab>]
path_openat.isra.70+0xab/0x490
[110926.972745]                     [<ffffffff8110184d>] do_filp_open+0x3d/0xa0
[110926.972747]                     [<ffffffff810f2139>] do_sys_open+0xf9/0x1e0
[110926.972749]                     [<ffffffff810f223c>] sys_open+0x1c/0x20
[110926.972750]                     [<ffffffff816b2d12>]
system_call_fastpath+0x16/0x1b
[110926.972752]    IN-RECLAIM_FS-R at:
[110926.972753]                        [<ffffffff8107efdf>]
__lock_acquire+0x57f/0x1c00
[110926.972755]                        [<ffffffff81080b55>]
lock_acquire+0x55/0x70
[110926.972757]                        [<ffffffff810f452b>]
__sb_start_write+0xab/0x190
[110926.972758]                        [<ffffffff8122b268>]
xfs_trans_alloc+0x28/0x50
[110926.972760]                        [<ffffffff811f3e54>]
xfs_free_eofblocks+0x104/0x250
[110926.972762]                        [<ffffffff811f4b29>]
xfs_inactive+0xa9/0x480
[110926.972763]                        [<ffffffff811efe00>]
xfs_fs_evict_inode+0x70/0x80
[110926.972765]                        [<ffffffff8110cb8f>] evict+0xaf/0x1b0
[110926.972768]                        [<ffffffff8110d219>]
dispose_list+0x39/0x50
[110926.972770]                        [<ffffffff8110dc73>]
prune_icache_sb+0x183/0x340
[110926.972772]                        [<ffffffff810f5bd3>]
prune_super+0xf3/0x1a0
[110926.972773]                        [<ffffffff810bbe0e>]
shrink_slab+0x11e/0x1f0
[110926.972775]                        [<ffffffff810be400>] kswapd+0x690/0xa10
[110926.972777]                        [<ffffffff8105c246>] kthread+0xd6/0xe0
[110926.972779]                        [<ffffffff816b2c6c>]
ret_from_fork+0x7c/0xb0
[110926.972781]    RECLAIM_FS-ON-R at:
[110926.972782]                        [<ffffffff8108137e>]
mark_held_locks+0x7e/0x130
[110926.972784]                        [<ffffffff81081a63>]
lockdep_trace_alloc+0x63/0xc0
[110926.972785]                        [<ffffffff810e9dd5>]
kmem_cache_alloc+0x35/0xe0
[110926.972787]                        [<ffffffff811f6d3f>]
kmem_zone_alloc+0x5f/0xe0
[110926.972789]                        [<ffffffff811f6dd8>]
kmem_zone_zalloc+0x18/0x50
[110926.972790]                        [<ffffffff8122b1e2>]
_xfs_trans_alloc+0x32/0x90
[110926.972792]                        [<ffffffff8122b278>]
xfs_trans_alloc+0x38/0x50
[110926.972794]                        [<ffffffff811f5147>]
xfs_create+0x187/0x5a0
[110926.972796]                        [<ffffffff811eca1a>]
xfs_vn_mknod+0x8a/0x1b0
[110926.972797]                        [<ffffffff811ecb6e>]
xfs_vn_create+0xe/0x10
[110926.972799]                        [<ffffffff81100332>] vfs_create+0x72/0xc0
[110926.972801]                        [<ffffffff81100b8e>]
do_last.isra.69+0x80e/0xc80
[110926.972803]                        [<ffffffff811010ab>]
path_openat.isra.70+0xab/0x490
[110926.972805]                        [<ffffffff8110184d>]
do_filp_open+0x3d/0xa0
[110926.972807]                        [<ffffffff810f2139>]
do_sys_open+0xf9/0x1e0
[110926.972809]                        [<ffffffff810f223c>] sys_open+0x1c/0x20
[110926.972811]                        [<ffffffff816b2d12>]
system_call_fastpath+0x16/0x1b
[110926.972813]    INITIAL USE at:
[110926.972814]                    [<ffffffff8107ed49>]
__lock_acquire+0x2e9/0x1c00
[110926.972815]                    [<ffffffff81080b55>] lock_acquire+0x55/0x70
[110926.972817]                    [<ffffffff810f452b>]
__sb_start_write+0xab/0x190
[110926.972819]                    [<ffffffff8122b268>]
xfs_trans_alloc+0x28/0x50
[110926.972820]                    [<ffffffff811f5147>] xfs_create+0x187/0x5a0
[110926.972822]                    [<ffffffff811eca1a>] xfs_vn_mknod+0x8a/0x1b0
[110926.972824]                    [<ffffffff811ecb6e>] xfs_vn_create+0xe/0x10
[110926.972826]                    [<ffffffff81100332>] vfs_create+0x72/0xc0
[110926.972827]                    [<ffffffff81100b8e>]
do_last.isra.69+0x80e/0xc80
[110926.972829]                    [<ffffffff811010ab>]
path_openat.isra.70+0xab/0x490
[110926.972831]                    [<ffffffff8110184d>] do_filp_open+0x3d/0xa0
[110926.972833]                    [<ffffffff810f2139>] do_sys_open+0xf9/0x1e0
[110926.972835]                    [<ffffffff810f223c>] sys_open+0x1c/0x20
[110926.972837]                    [<ffffffff816b2d12>]
system_call_fastpath+0x16/0x1b
[110926.972839]  }
[110926.972840]  ... key      at: [<ffffffff81c34e40>] xfs_fs_type+0x60/0x80
[110926.972842]  ... acquired at:
[110926.972843]    [<ffffffff8107df3b>] check_usage_forwards+0x10b/0x140
[110926.972845]    [<ffffffff8107e900>] mark_lock+0x190/0x2f0
[110926.972846]    [<ffffffff8107efdf>] __lock_acquire+0x57f/0x1c00
[110926.972848]    [<ffffffff81080b55>] lock_acquire+0x55/0x70
[110926.972850]    [<ffffffff810f452b>] __sb_start_write+0xab/0x190
[110926.972851]    [<ffffffff8122b268>] xfs_trans_alloc+0x28/0x50
[110926.972853]    [<ffffffff811f3e54>] xfs_free_eofblocks+0x104/0x250
[110926.972855]    [<ffffffff811f4b29>] xfs_inactive+0xa9/0x480
[110926.972856]    [<ffffffff811efe00>] xfs_fs_evict_inode+0x70/0x80
[110926.972858]    [<ffffffff8110cb8f>] evict+0xaf/0x1b0
[110926.972860]    [<ffffffff8110d219>] dispose_list+0x39/0x50
[110926.972861]    [<ffffffff8110dc73>] prune_icache_sb+0x183/0x340
[110926.972863]    [<ffffffff810f5bd3>] prune_super+0xf3/0x1a0
[110926.972865]    [<ffffffff810bbe0e>] shrink_slab+0x11e/0x1f0
[110926.972866]    [<ffffffff810be400>] kswapd+0x690/0xa10
[110926.972868]    [<ffffffff8105c246>] kthread+0xd6/0xe0
[110926.972870]    [<ffffffff816b2c6c>] ret_from_fork+0x7c/0xb0
[110926.972871]
[110926.972872]
[110926.972872] stack backtrace:
[110926.972874] Pid: 725, comm: kswapd0 Not tainted 3.7.0-rc4 #1
[110926.972875] Call Trace:
[110926.972878]  [<ffffffff8107de28>]
print_irq_inversion_bug.part.37+0x1e8/0x1f0
[110926.972880]  [<ffffffff8107df3b>] check_usage_forwards+0x10b/0x140
[110926.972883]  [<ffffffff8107e900>] mark_lock+0x190/0x2f0
[110926.972885]  [<ffffffff8107de30>] ?
print_irq_inversion_bug.part.37+0x1f0/0x1f0
[110926.972887]  [<ffffffff8107efdf>] __lock_acquire+0x57f/0x1c00
[110926.972889]  [<ffffffff81220424>] ? xfs_iext_bno_to_ext+0x84/0x160
[110926.972892]  [<ffffffff8120a0e3>] ? xfs_bmbt_get_all+0x13/0x20
[110926.972895]  [<ffffffff81201104>] ? xfs_bmap_search_multi_extents+0xa4/0x110
[110926.972897]  [<ffffffff81080b55>] lock_acquire+0x55/0x70
[110926.972899]  [<ffffffff8122b268>] ? xfs_trans_alloc+0x28/0x50
[110926.972901]  [<ffffffff810f452b>] __sb_start_write+0xab/0x190
[110926.972903]  [<ffffffff8122b268>] ? xfs_trans_alloc+0x28/0x50
[110926.972905]  [<ffffffff8122b268>] ? xfs_trans_alloc+0x28/0x50
[110926.972907]  [<ffffffff8122b268>] xfs_trans_alloc+0x28/0x50
[110926.972908]  [<ffffffff811f3e54>] xfs_free_eofblocks+0x104/0x250
[110926.972910]  [<ffffffff816b1efb>] ? _raw_spin_unlock_irq+0x2b/0x50
[110926.972912]  [<ffffffff811f4b29>] xfs_inactive+0xa9/0x480
[110926.972914]  [<ffffffff816b1efb>] ? _raw_spin_unlock_irq+0x2b/0x50
[110926.972916]  [<ffffffff811efe00>] xfs_fs_evict_inode+0x70/0x80
[110926.972918]  [<ffffffff8110cb8f>] evict+0xaf/0x1b0
[110926.972920]  [<ffffffff8110d219>] dispose_list+0x39/0x50
[110926.972922]  [<ffffffff8110dc73>] prune_icache_sb+0x183/0x340
[110926.972924]  [<ffffffff810f5bd3>] prune_super+0xf3/0x1a0
[110926.972926]  [<ffffffff810bbe0e>] shrink_slab+0x11e/0x1f0
[110926.972928]  [<ffffffff810be400>] kswapd+0x690/0xa10
[110926.972930]  [<ffffffff8105ca30>] ? __init_waitqueue_head+0x60/0x60
[110926.972932]  [<ffffffff810bdd70>] ? shrink_lruvec+0x540/0x540
[110926.972934]  [<ffffffff8105c246>] kthread+0xd6/0xe0
[110926.972936]  [<ffffffff816b1efb>] ? _raw_spin_unlock_irq+0x2b/0x50
[110926.972938]  [<ffffffff8105c170>] ? flush_kthread_worker+0xe0/0xe0
[110926.972940]  [<ffffffff816b2c6c>] ret_from_fork+0x7c/0xb0
[110926.972942]  [<ffffffff8105c170>] ? flush_kthread_worker+0xe0/0xe0

> Nov 17 14:07:38 thoregon kernel: [66571.610863]
> Nov 17 14:07:38 thoregon kernel: [66571.610869]
> =========================================================
> Nov 17 14:07:38 thoregon kernel: [66571.610870] [ INFO: possible irq
> lock inversion dependency detected ]
> Nov 17 14:07:38 thoregon kernel: [66571.610873] 3.7.0-rc5 #1 Not tainted
> Nov 17 14:07:38 thoregon kernel: [66571.610874]
> ---------------------------------------------------------
> Nov 17 14:07:38 thoregon kernel: [66571.610875] cc1/21330 just changed
> the state of lock:
> Nov 17 14:07:38 thoregon kernel: [66571.610877]
> (sb_internal){.+.+.?}, at: [<ffffffff8122b138>]
> xfs_trans_alloc+0x28/0x50
> Nov 17 14:07:38 thoregon kernel: [66571.610885] but this lock took
> another, RECLAIM_FS-unsafe lock in the past:
> Nov 17 14:07:38 thoregon kernel: [66571.610886]
> (&(&ip->i_lock)->mr_lock/1){+.+.+.}
> Nov 17 14:07:38 thoregon kernel: [66571.610886]
> Nov 17 14:07:39 thoregon kernel: [66571.610886] and interrupts could
> create inverse lock ordering between them.
> Nov 17 14:07:39 thoregon kernel: [66571.610886]
> Nov 17 14:07:39 thoregon kernel: [66571.610890]
> Nov 17 14:07:39 thoregon kernel: [66571.610890] other info that might
> help us debug this:
> Nov 17 14:07:39 thoregon kernel: [66571.610891]  Possible interrupt
> unsafe locking scenario:
> Nov 17 14:07:39 thoregon kernel: [66571.610891]
> Nov 17 14:07:39 thoregon kernel: [66571.610892]        CPU0
>         CPU1
> Nov 17 14:07:39 thoregon kernel: [66571.610893]        ----
>         ----
> Nov 17 14:07:39 thoregon kernel: [66571.610894]
> lock(&(&ip->i_lock)->mr_lock/1);
> Nov 17 14:07:39 thoregon kernel: [66571.610896]
>         local_irq_disable();
> Nov 17 14:07:39 thoregon kernel: [66571.610897]
>         lock(sb_internal);
> Nov 17 14:07:39 thoregon kernel: [66571.610898]
>         lock(&(&ip->i_lock)->mr_lock/1);
> Nov 17 14:07:39 thoregon kernel: [66571.610900]   <Interrupt>
> Nov 17 14:07:39 thoregon kernel: [66571.610901]     lock(sb_internal);
> Nov 17 14:07:39 thoregon kernel: [66571.610902]
> Nov 17 14:07:39 thoregon kernel: [66571.610902]  *** DEADLOCK ***
> Nov 17 14:07:39 thoregon kernel: [66571.610902]
> Nov 17 14:07:39 thoregon kernel: [66571.610904] 3 locks held by cc1/21330:
> Nov 17 14:07:39 thoregon kernel: [66571.610905]  #0:
> (&mm->mmap_sem){++++++}, at: [<ffffffff81029d8b>]
> __do_page_fault+0xfb/0x480
> Nov 17 14:07:39 thoregon kernel: [66571.610910]  #1:
> (shrinker_rwsem){++++..}, at: [<ffffffff810bbd02>]
> shrink_slab+0x32/0x1f0
> Nov 17 14:07:39 thoregon kernel: [66571.610915]  #2:
> (&type->s_umount_key#20){++++.+}, at: [<ffffffff810f5a7e>]
> grab_super_passive+0x3e/0x90
> Nov 17 14:07:39 thoregon kernel: [66571.610921]
> Nov 17 14:07:39 thoregon kernel: [66571.610921] the shortest
> dependencies between 2nd lock and 1st lock:
> Nov 17 14:07:39 thoregon kernel: [66571.610927]  ->
> (&(&ip->i_lock)->mr_lock/1){+.+.+.} ops: 169649 {
> Nov 17 14:07:39 thoregon kernel: [66571.610931]     HARDIRQ-ON-W at:
> Nov 17 14:07:39 thoregon kernel: [66571.610932]
> [<ffffffff8107f091>] __lock_acquire+0x631/0x1c00
> Nov 17 14:07:39 thoregon kernel: [66571.610935]
> [<ffffffff81080b55>] lock_acquire+0x55/0x70
> Nov 17 14:07:39 thoregon kernel: [66571.610937]
> [<ffffffff8106126a>] down_write_nested+0x4a/0x70
> Nov 17 14:07:39 thoregon kernel: [66571.610941]
> [<ffffffff811e8164>] xfs_ilock+0x84/0xb0
> Nov 17 14:07:39 thoregon kernel: [66571.610944]
> [<ffffffff811f51a4>] xfs_create+0x1d4/0x5a0
> Nov 17 14:07:39 thoregon kernel: [66571.610946]
> [<ffffffff811eca2a>] xfs_vn_mknod+0x8a/0x1b0
> Nov 17 14:07:39 thoregon kernel: [66571.610948]
> [<ffffffff811ecb7e>] xfs_vn_create+0xe/0x10
> Nov 17 14:07:39 thoregon kernel: [66571.610950]
> [<ffffffff81100322>] vfs_create+0x72/0xc0
> Nov 17 14:07:39 thoregon kernel: [66571.610953]
> [<ffffffff81100b7e>] do_last.isra.69+0x80e/0xc80
> Nov 17 14:07:39 thoregon kernel: [66571.610955]
> [<ffffffff8110109b>] path_openat.isra.70+0xab/0x490
> Nov 17 14:07:39 thoregon kernel: [66571.610957]
> [<ffffffff8110183d>] do_filp_open+0x3d/0xa0
> Nov 17 14:07:39 thoregon kernel: [66571.610959]
> [<ffffffff810f2129>] do_sys_open+0xf9/0x1e0
> Nov 17 14:07:39 thoregon kernel: [66571.610962]
> [<ffffffff810f222c>] sys_open+0x1c/0x20
> Nov 17 14:07:39 thoregon kernel: [66571.610964]
> [<ffffffff816b2e52>] system_call_fastpath+0x16/0x1b
> Nov 17 14:07:39 thoregon kernel: [66571.610967]     SOFTIRQ-ON-W at:
> Nov 17 14:07:39 thoregon kernel: [66571.610968]
> [<ffffffff8107f0c7>] __lock_acquire+0x667/0x1c00
> Nov 17 14:07:39 thoregon kernel: [66571.610970]
> [<ffffffff81080b55>] lock_acquire+0x55/0x70
> Nov 17 14:07:39 thoregon kernel: [66571.610972]
> [<ffffffff8106126a>] down_write_nested+0x4a/0x70
> Nov 17 14:07:39 thoregon kernel: [66571.610974]
> [<ffffffff811e8164>] xfs_ilock+0x84/0xb0
> Nov 17 14:07:39 thoregon kernel: [66571.610976]
> [<ffffffff811f51a4>] xfs_create+0x1d4/0x5a0
> Nov 17 14:07:39 thoregon kernel: [66571.610977]
> [<ffffffff811eca2a>] xfs_vn_mknod+0x8a/0x1b0
> Nov 17 14:07:39 thoregon kernel: [66571.610979]
> [<ffffffff811ecb7e>] xfs_vn_create+0xe/0x10
> Nov 17 14:07:39 thoregon kernel: [66571.610981]
> [<ffffffff81100322>] vfs_create+0x72/0xc0
> Nov 17 14:07:39 thoregon kernel: [66571.610983]
> [<ffffffff81100b7e>] do_last.isra.69+0x80e/0xc80
> Nov 17 14:07:39 thoregon kernel: [66571.610985]
> [<ffffffff8110109b>] path_openat.isra.70+0xab/0x490
> Nov 17 14:07:39 thoregon kernel: [66571.610987]
> [<ffffffff8110183d>] do_filp_open+0x3d/0xa0
> Nov 17 14:07:39 thoregon kernel: [66571.610989]
> [<ffffffff810f2129>] do_sys_open+0xf9/0x1e0
> Nov 17 14:07:39 thoregon kernel: [66571.610991]
> [<ffffffff810f222c>] sys_open+0x1c/0x20
> Nov 17 14:07:39 thoregon kernel: [66571.610993]
> [<ffffffff816b2e52>] system_call_fastpath+0x16/0x1b
> Nov 17 14:07:39 thoregon kernel: [66571.610995]     RECLAIM_FS-ON-W at:
> Nov 17 14:07:39 thoregon kernel: [66571.610996]
>   [<ffffffff8108137e>] mark_held_locks+0x7e/0x130
> Nov 17 14:07:39 thoregon kernel: [66571.610998]
>   [<ffffffff81081a63>] lockdep_trace_alloc+0x63/0xc0
> Nov 17 14:07:39 thoregon kernel: [66571.610999]
>   [<ffffffff810e9dc5>] kmem_cache_alloc+0x35/0xe0
> Nov 17 14:07:39 thoregon kernel: [66571.611002]
>   [<ffffffff810dba21>] vm_map_ram+0x271/0x770
> Nov 17 14:07:39 thoregon kernel: [66571.611004]
>   [<ffffffff811e12b6>] _xfs_buf_map_pages+0x46/0xe0
> Nov 17 14:07:39 thoregon kernel: [66571.611008]
>   [<ffffffff811e21ca>] xfs_buf_get_map+0x8a/0x130
> Nov 17 14:07:39 thoregon kernel: [66571.611009]
>   [<ffffffff81233989>] xfs_trans_get_buf_map+0xa9/0xd0
> Nov 17 14:07:39 thoregon kernel: [66571.611011]
>   [<ffffffff8121bc2d>] xfs_ialloc_inode_init+0xcd/0x1d0
> Nov 17 14:07:39 thoregon kernel: [66571.611015]
>   [<ffffffff8121c16f>] xfs_ialloc_ag_alloc+0x18f/0x500
> Nov 17 14:07:39 thoregon kernel: [66571.611017]
>   [<ffffffff8121d955>] xfs_dialloc+0x185/0x2a0
> Nov 17 14:07:39 thoregon kernel: [66571.611019]
>   [<ffffffff8121f068>] xfs_ialloc+0x58/0x650
> Nov 17 14:07:39 thoregon kernel: [66571.611021]
>   [<ffffffff811f3995>] xfs_dir_ialloc+0x65/0x270
> Nov 17 14:07:39 thoregon kernel: [66571.611023]
>   [<ffffffff811f537c>] xfs_create+0x3ac/0x5a0
> Nov 17 14:07:39 thoregon kernel: [66571.611024]
>   [<ffffffff811eca2a>] xfs_vn_mknod+0x8a/0x1b0
> Nov 17 14:07:39 thoregon kernel: [66571.611026]
>   [<ffffffff811ecb61>] xfs_vn_mkdir+0x11/0x20
> Nov 17 14:07:39 thoregon kernel: [66571.611028]
>   [<ffffffff8110016f>] vfs_mkdir+0x7f/0xd0
> Nov 17 14:07:39 thoregon kernel: [66571.611030]
>   [<ffffffff81101b83>] sys_mkdirat+0x43/0x80
> Nov 17 14:07:39 thoregon kernel: [66571.611032]
>   [<ffffffff81101bd4>] sys_mkdir+0x14/0x20
> Nov 17 14:07:39 thoregon kernel: [66571.611034]
>   [<ffffffff816b2e52>] system_call_fastpath+0x16/0x1b
> Nov 17 14:07:39 thoregon kernel: [66571.611036]     INITIAL USE at:
> Nov 17 14:07:39 thoregon kernel: [66571.611037]
> [<ffffffff8107ed49>] __lock_acquire+0x2e9/0x1c00
> Nov 17 14:07:39 thoregon kernel: [66571.611038]
> [<ffffffff81080b55>] lock_acquire+0x55/0x70
> Nov 17 14:07:39 thoregon kernel: [66571.611040]
> [<ffffffff8106126a>] down_write_nested+0x4a/0x70
> Nov 17 14:07:39 thoregon kernel: [66571.611042]
> [<ffffffff811e8164>] xfs_ilock+0x84/0xb0
> Nov 17 14:07:39 thoregon kernel: [66571.611044]
> [<ffffffff811f51a4>] xfs_create+0x1d4/0x5a0
> Nov 17 14:07:39 thoregon kernel: [66571.611046]
> [<ffffffff811eca2a>] xfs_vn_mknod+0x8a/0x1b0
> Nov 17 14:07:39 thoregon kernel: [66571.611047]
> [<ffffffff811ecb7e>] xfs_vn_create+0xe/0x10
> Nov 17 14:07:39 thoregon kernel: [66571.611049]
> [<ffffffff81100322>] vfs_create+0x72/0xc0
> Nov 17 14:07:39 thoregon kernel: [66571.611051]
> [<ffffffff81100b7e>] do_last.isra.69+0x80e/0xc80
> Nov 17 14:07:39 thoregon kernel: [66571.611053]
> [<ffffffff8110109b>] path_openat.isra.70+0xab/0x490
> Nov 17 14:07:39 thoregon kernel: [66571.611055]
> [<ffffffff8110183d>] do_filp_open+0x3d/0xa0
> Nov 17 14:07:39 thoregon kernel: [66571.611057]
> [<ffffffff810f2129>] do_sys_open+0xf9/0x1e0
> Nov 17 14:07:39 thoregon kernel: [66571.611059]
> [<ffffffff810f222c>] sys_open+0x1c/0x20
> Nov 17 14:07:39 thoregon kernel: [66571.611061]
> [<ffffffff816b2e52>] system_call_fastpath+0x16/0x1b
> Nov 17 14:07:39 thoregon kernel: [66571.611063]   }
> Nov 17 14:07:39 thoregon kernel: [66571.611064]   ... key      at:
> [<ffffffff825b4b81>] __key.41357+0x1/0x8
> Nov 17 14:07:39 thoregon kernel: [66571.611066]   ... acquired at:
> Nov 17 14:07:39 thoregon kernel: [66571.611067]
> [<ffffffff81080b55>] lock_acquire+0x55/0x70
> Nov 17 14:07:39 thoregon kernel: [66571.611069]
> [<ffffffff8106126a>] down_write_nested+0x4a/0x70
> Nov 17 14:07:39 thoregon kernel: [66571.611071]
> [<ffffffff811e8164>] xfs_ilock+0x84/0xb0
> Nov 17 14:07:39 thoregon kernel: [66571.611073]
> [<ffffffff811f51a4>] xfs_create+0x1d4/0x5a0
> Nov 17 14:07:39 thoregon kernel: [66571.611074]
> [<ffffffff811eca2a>] xfs_vn_mknod+0x8a/0x1b0
> Nov 17 14:07:39 thoregon kernel: [66571.611076]
> [<ffffffff811ecb7e>] xfs_vn_create+0xe/0x10
> Nov 17 14:07:39 thoregon kernel: [66571.611078]
> [<ffffffff81100322>] vfs_create+0x72/0xc0
> Nov 17 14:07:39 thoregon kernel: [66571.611080]
> [<ffffffff81100b7e>] do_last.isra.69+0x80e/0xc80
> Nov 17 14:07:39 thoregon kernel: [66571.611082]
> [<ffffffff8110109b>] path_openat.isra.70+0xab/0x490
> Nov 17 14:07:39 thoregon kernel: [66571.611084]
> [<ffffffff8110183d>] do_filp_open+0x3d/0xa0
> Nov 17 14:07:39 thoregon kernel: [66571.611086]
> [<ffffffff810f2129>] do_sys_open+0xf9/0x1e0
> Nov 17 14:07:39 thoregon kernel: [66571.611088]
> [<ffffffff810f222c>] sys_open+0x1c/0x20
> Nov 17 14:07:39 thoregon kernel: [66571.611090]
> [<ffffffff816b2e52>] system_call_fastpath+0x16/0x1b
> Nov 17 14:07:39 thoregon kernel: [66571.611091]
> Nov 17 14:07:39 thoregon kernel: [66571.611092] ->
> (sb_internal){.+.+.?} ops: 1341531 {
> Nov 17 14:07:39 thoregon kernel: [66571.611095]    HARDIRQ-ON-R at:
> Nov 17 14:07:39 thoregon kernel: [66571.611096]
> [<ffffffff8107ef6a>] __lock_acquire+0x50a/0x1c00
> Nov 17 14:07:39 thoregon kernel: [66571.611098]
> [<ffffffff81080b55>] lock_acquire+0x55/0x70
> Nov 17 14:07:39 thoregon kernel: [66571.611100]
> [<ffffffff810f451b>] __sb_start_write+0xab/0x190
> Nov 17 14:07:39 thoregon kernel: [66571.611102]
> [<ffffffff8122b138>] xfs_trans_alloc+0x28/0x50
> Nov 17 14:07:39 thoregon kernel: [66571.611104]
> [<ffffffff811f5157>] xfs_create+0x187/0x5a0
> Nov 17 14:07:39 thoregon kernel: [66571.611105]
> [<ffffffff811eca2a>] xfs_vn_mknod+0x8a/0x1b0
> Nov 17 14:07:39 thoregon kernel: [66571.611107]
> [<ffffffff811ecb7e>] xfs_vn_create+0xe/0x10
> Nov 17 14:07:39 thoregon kernel: [66571.611109]
> [<ffffffff81100322>] vfs_create+0x72/0xc0
> Nov 17 14:07:39 thoregon kernel: [66571.611111]
> [<ffffffff81100b7e>] do_last.isra.69+0x80e/0xc80
> Nov 17 14:07:39 thoregon kernel: [66571.611113]
> [<ffffffff8110109b>] path_openat.isra.70+0xab/0x490
> Nov 17 14:07:39 thoregon kernel: [66571.611115]
> [<ffffffff8110183d>] do_filp_open+0x3d/0xa0
> Nov 17 14:07:39 thoregon kernel: [66571.611117]
> [<ffffffff810f2129>] do_sys_open+0xf9/0x1e0
> Nov 17 14:07:39 thoregon kernel: [66571.611119]
> [<ffffffff810f222c>] sys_open+0x1c/0x20
> Nov 17 14:07:39 thoregon kernel: [66571.611121]
> [<ffffffff816b2e52>] system_call_fastpath+0x16/0x1b
> Nov 17 14:07:39 thoregon kernel: [66571.611123]    SOFTIRQ-ON-R at:
> Nov 17 14:07:39 thoregon kernel: [66571.611124]
> [<ffffffff8107f0c7>] __lock_acquire+0x667/0x1c00
> Nov 17 14:07:39 thoregon kernel: [66571.611126]
> [<ffffffff81080b55>] lock_acquire+0x55/0x70
> Nov 17 14:07:39 thoregon kernel: [66571.611128]
> [<ffffffff810f451b>] __sb_start_write+0xab/0x190
> Nov 17 14:07:39 thoregon kernel: [66571.611130]
> [<ffffffff8122b138>] xfs_trans_alloc+0x28/0x50
> Nov 17 14:07:39 thoregon kernel: [66571.611132]
> [<ffffffff811f5157>] xfs_create+0x187/0x5a0
> Nov 17 14:07:39 thoregon kernel: [66571.611133]
> [<ffffffff811eca2a>] xfs_vn_mknod+0x8a/0x1b0
> Nov 17 14:07:39 thoregon kernel: [66571.611135]
> [<ffffffff811ecb7e>] xfs_vn_create+0xe/0x10
> Nov 17 14:07:39 thoregon kernel: [66571.611137]
> [<ffffffff81100322>] vfs_create+0x72/0xc0
> Nov 17 14:07:39 thoregon kernel: [66571.611139]
> [<ffffffff81100b7e>] do_last.isra.69+0x80e/0xc80
> Nov 17 14:07:39 thoregon kernel: [66571.611141]
> [<ffffffff8110109b>] path_openat.isra.70+0xab/0x490
> Nov 17 14:07:39 thoregon kernel: [66571.611143]
> [<ffffffff8110183d>] do_filp_open+0x3d/0xa0
> Nov 17 14:07:39 thoregon kernel: [66571.611145]
> [<ffffffff810f2129>] do_sys_open+0xf9/0x1e0
> Nov 17 14:07:39 thoregon kernel: [66571.611147]
> [<ffffffff810f222c>] sys_open+0x1c/0x20
> Nov 17 14:07:39 thoregon kernel: [66571.611149]
> [<ffffffff816b2e52>] system_call_fastpath+0x16/0x1b
> Nov 17 14:07:39 thoregon kernel: [66571.611151]    IN-RECLAIM_FS-R at:
> Nov 17 14:07:39 thoregon kernel: [66571.611152]
> [<ffffffff8107efdf>] __lock_acquire+0x57f/0x1c00
> Nov 17 14:07:39 thoregon kernel: [66571.611154]
> [<ffffffff81080b55>] lock_acquire+0x55/0x70
> Nov 17 14:07:39 thoregon kernel: [66571.611156]
> [<ffffffff810f451b>] __sb_start_write+0xab/0x190
> Nov 17 14:07:39 thoregon kernel: [66571.611158]
> [<ffffffff8122b138>] xfs_trans_alloc+0x28/0x50
> Nov 17 14:07:39 thoregon kernel: [66571.611159]
> [<ffffffff811f3e64>] xfs_free_eofblocks+0x104/0x250
> Nov 17 14:07:39 thoregon kernel: [66571.611161]
> [<ffffffff811f4b39>] xfs_inactive+0xa9/0x480
> Nov 17 14:07:39 thoregon kernel: [66571.611163]
> [<ffffffff811efe10>] xfs_fs_evict_inode+0x70/0x80
> Nov 17 14:07:39 thoregon kernel: [66571.611165]
> [<ffffffff8110cb7f>] evict+0xaf/0x1b0
> Nov 17 14:07:39 thoregon kernel: [66571.611168]
> [<ffffffff8110d209>] dispose_list+0x39/0x50
> Nov 17 14:07:39 thoregon kernel: [66571.611170]
> [<ffffffff8110dc63>] prune_icache_sb+0x183/0x340
> Nov 17 14:07:39 thoregon kernel: [66571.611172]
> [<ffffffff810f5bc3>] prune_super+0xf3/0x1a0
> Nov 17 14:07:39 thoregon kernel: [66571.611173]
> [<ffffffff810bbdee>] shrink_slab+0x11e/0x1f0
> Nov 17 14:07:39 thoregon kernel: [66571.611175]
> [<ffffffff810be98f>] try_to_free_pages+0x21f/0x4e0
> Nov 17 14:07:39 thoregon kernel: [66571.611177]
> [<ffffffff810b5ec6>] __alloc_pages_nodemask+0x506/0x800
> Nov 17 14:07:39 thoregon kernel: [66571.611179]
> [<ffffffff810ce56e>] handle_pte_fault+0x5ae/0x7a0
> Nov 17 14:07:39 thoregon kernel: [66571.611182]
> [<ffffffff810cf769>] handle_mm_fault+0x1f9/0x2a0
> Nov 17 14:07:39 thoregon kernel: [66571.611184]
> [<ffffffff81029dfc>] __do_page_fault+0x16c/0x480
> Nov 17 14:07:39 thoregon kernel: [66571.611186]
> [<ffffffff8102a139>] do_page_fault+0x9/0x10
> Nov 17 14:07:39 thoregon kernel: [66571.611188]
> [<ffffffff816b287f>] page_fault+0x1f/0x30
> Nov 17 14:07:39 thoregon kernel: [66571.611190]    RECLAIM_FS-ON-R at:
> Nov 17 14:07:39 thoregon kernel: [66571.611191]
> [<ffffffff8108137e>] mark_held_locks+0x7e/0x130
> Nov 17 14:07:39 thoregon kernel: [66571.611193]
> [<ffffffff81081a63>] lockdep_trace_alloc+0x63/0xc0
> Nov 17 14:07:39 thoregon kernel: [66571.611195]
> [<ffffffff810e9dc5>] kmem_cache_alloc+0x35/0xe0
> Nov 17 14:07:39 thoregon kernel: [66571.611197]
> [<ffffffff811f6d4f>] kmem_zone_alloc+0x5f/0xe0
> Nov 17 14:07:39 thoregon kernel: [66571.611198]
> [<ffffffff811f6de8>] kmem_zone_zalloc+0x18/0x50
> Nov 17 14:07:39 thoregon kernel: [66571.611200]
> [<ffffffff8122b0b2>] _xfs_trans_alloc+0x32/0x90
> Nov 17 14:07:39 thoregon kernel: [66571.611202]
> [<ffffffff8122b148>] xfs_trans_alloc+0x38/0x50
> Nov 17 14:07:39 thoregon kernel: [66571.611204]
> [<ffffffff811f5157>] xfs_create+0x187/0x5a0
> Nov 17 14:07:39 thoregon kernel: [66571.611205]
> [<ffffffff811eca2a>] xfs_vn_mknod+0x8a/0x1b0
> Nov 17 14:07:39 thoregon kernel: [66571.611207]
> [<ffffffff811ecb7e>] xfs_vn_create+0xe/0x10
> Nov 17 14:07:39 thoregon kernel: [66571.611209]
> [<ffffffff81100322>] vfs_create+0x72/0xc0
> Nov 17 14:07:39 thoregon kernel: [66571.611211]
> [<ffffffff81100b7e>] do_last.isra.69+0x80e/0xc80
> Nov 17 14:07:39 thoregon kernel: [66571.611213]
> [<ffffffff8110109b>] path_openat.isra.70+0xab/0x490
> Nov 17 14:07:39 thoregon kernel: [66571.611215]
> [<ffffffff8110183d>] do_filp_open+0x3d/0xa0
> Nov 17 14:07:39 thoregon kernel: [66571.611217]
> [<ffffffff810f2129>] do_sys_open+0xf9/0x1e0
> Nov 17 14:07:39 thoregon kernel: [66571.611219]
> [<ffffffff810f222c>] sys_open+0x1c/0x20
> Nov 17 14:07:39 thoregon kernel: [66571.611221]
> [<ffffffff816b2e52>] system_call_fastpath+0x16/0x1b
> Nov 17 14:07:39 thoregon kernel: [66571.611223]    INITIAL USE at:
> Nov 17 14:07:39 thoregon kernel: [66571.611224]
> [<ffffffff8107ed49>] __lock_acquire+0x2e9/0x1c00
> Nov 17 14:07:39 thoregon kernel: [66571.611225]
> [<ffffffff81080b55>] lock_acquire+0x55/0x70
> Nov 17 14:07:39 thoregon kernel: [66571.611227]
> [<ffffffff810f451b>] __sb_start_write+0xab/0x190
> Nov 17 14:07:39 thoregon kernel: [66571.611229]
> [<ffffffff8122b138>] xfs_trans_alloc+0x28/0x50
> Nov 17 14:07:39 thoregon kernel: [66571.611231]
> [<ffffffff811f5157>] xfs_create+0x187/0x5a0
> Nov 17 14:07:39 thoregon kernel: [66571.611232]
> [<ffffffff811eca2a>] xfs_vn_mknod+0x8a/0x1b0
> Nov 17 14:07:39 thoregon kernel: [66571.611234]
> [<ffffffff811ecb7e>] xfs_vn_create+0xe/0x10
> Nov 17 14:07:39 thoregon kernel: [66571.611236]
> [<ffffffff81100322>] vfs_create+0x72/0xc0
> Nov 17 14:07:39 thoregon kernel: [66571.611238]
> [<ffffffff81100b7e>] do_last.isra.69+0x80e/0xc80
> Nov 17 14:07:39 thoregon kernel: [66571.611240]
> [<ffffffff8110109b>] path_openat.isra.70+0xab/0x490
> Nov 17 14:07:39 thoregon kernel: [66571.611242]
> [<ffffffff8110183d>] do_filp_open+0x3d/0xa0
> Nov 17 14:07:39 thoregon kernel: [66571.611244]
> [<ffffffff810f2129>] do_sys_open+0xf9/0x1e0
> Nov 17 14:07:39 thoregon kernel: [66571.611246]
> [<ffffffff810f222c>] sys_open+0x1c/0x20
> Nov 17 14:07:39 thoregon kernel: [66571.611248]
> [<ffffffff816b2e52>] system_call_fastpath+0x16/0x1b
> Nov 17 14:07:39 thoregon kernel: [66571.611250]  }
> Nov 17 14:07:39 thoregon kernel: [66571.611251]  ... key      at:
> [<ffffffff81c34e40>] xfs_fs_type+0x60/0x80
> Nov 17 14:07:39 thoregon kernel: [66571.611254]  ... acquired at:
> Nov 17 14:07:39 thoregon kernel: [66571.611254]
> [<ffffffff8107df3b>] check_usage_forwards+0x10b/0x140
> Nov 17 14:07:39 thoregon kernel: [66571.611256]
> [<ffffffff8107e900>] mark_lock+0x190/0x2f0
> Nov 17 14:07:39 thoregon kernel: [66571.611258]
> [<ffffffff8107efdf>] __lock_acquire+0x57f/0x1c00
> Nov 17 14:07:39 thoregon kernel: [66571.611260]
> [<ffffffff81080b55>] lock_acquire+0x55/0x70
> Nov 17 14:07:39 thoregon kernel: [66571.611261]
> [<ffffffff810f451b>] __sb_start_write+0xab/0x190
> Nov 17 14:07:39 thoregon kernel: [66571.611263]
> [<ffffffff8122b138>] xfs_trans_alloc+0x28/0x50
> Nov 17 14:07:39 thoregon kernel: [66571.611265]
> [<ffffffff811f3e64>] xfs_free_eofblocks+0x104/0x250
> Nov 17 14:07:39 thoregon kernel: [66571.611266]
> [<ffffffff811f4b39>] xfs_inactive+0xa9/0x480
> Nov 17 14:07:39 thoregon kernel: [66571.611268]
> [<ffffffff811efe10>] xfs_fs_evict_inode+0x70/0x80
> Nov 17 14:07:39 thoregon kernel: [66571.611270]
> [<ffffffff8110cb7f>] evict+0xaf/0x1b0
> Nov 17 14:07:39 thoregon kernel: [66571.611271]
> [<ffffffff8110d209>] dispose_list+0x39/0x50
> Nov 17 14:07:39 thoregon kernel: [66571.611273]
> [<ffffffff8110dc63>] prune_icache_sb+0x183/0x340
> Nov 17 14:07:39 thoregon kernel: [66571.611275]
> [<ffffffff810f5bc3>] prune_super+0xf3/0x1a0
> Nov 17 14:07:39 thoregon kernel: [66571.611277]
> [<ffffffff810bbdee>] shrink_slab+0x11e/0x1f0
> Nov 17 14:07:39 thoregon kernel: [66571.611278]
> [<ffffffff810be98f>] try_to_free_pages+0x21f/0x4e0
> Nov 17 14:07:39 thoregon kernel: [66571.611280]
> [<ffffffff810b5ec6>] __alloc_pages_nodemask+0x506/0x800
> Nov 17 14:07:39 thoregon kernel: [66571.611282]
> [<ffffffff810ce56e>] handle_pte_fault+0x5ae/0x7a0
> Nov 17 14:07:39 thoregon kernel: [66571.611284]
> [<ffffffff810cf769>] handle_mm_fault+0x1f9/0x2a0
> Nov 17 14:07:39 thoregon kernel: [66571.611286]
> [<ffffffff81029dfc>] __do_page_fault+0x16c/0x480
> Nov 17 14:07:39 thoregon kernel: [66571.611287]
> [<ffffffff8102a139>] do_page_fault+0x9/0x10
> Nov 17 14:07:39 thoregon kernel: [66571.611289]
> [<ffffffff816b287f>] page_fault+0x1f/0x30
> Nov 17 14:07:39 thoregon kernel: [66571.611291]
> Nov 17 14:07:39 thoregon kernel: [66571.611292]
> Nov 17 14:07:39 thoregon kernel: [66571.611292] stack backtrace:
> Nov 17 14:07:39 thoregon kernel: [66571.611294] Pid: 21330, comm: cc1
> Not tainted 3.7.0-rc5 #1
> Nov 17 14:07:39 thoregon kernel: [66571.611295] Call Trace:
> Nov 17 14:07:39 thoregon kernel: [66571.611298]  [<ffffffff8107de28>]
> print_irq_inversion_bug.part.37+0x1e8/0x1f0
> Nov 17 14:07:39 thoregon kernel: [66571.611300]  [<ffffffff8107df3b>]
> check_usage_forwards+0x10b/0x140
> Nov 17 14:07:39 thoregon kernel: [66571.611303]  [<ffffffff8107e900>]
> mark_lock+0x190/0x2f0
> Nov 17 14:07:39 thoregon kernel: [66571.611306]  [<ffffffff8150406e>]
> ? dm_request+0x2e/0x2a0
> Nov 17 14:07:39 thoregon kernel: [66571.611308]  [<ffffffff8107de30>]
> ? print_irq_inversion_bug.part.37+0x1f0/0x1f0
> Nov 17 14:07:39 thoregon kernel: [66571.611310]  [<ffffffff8107efdf>]
> __lock_acquire+0x57f/0x1c00
> Nov 17 14:07:39 thoregon kernel: [66571.611313]  [<ffffffff812202f4>]
> ? xfs_iext_bno_to_ext+0x84/0x160
> Nov 17 14:07:39 thoregon kernel: [66571.611316]  [<ffffffff8120a023>]
> ? xfs_bmbt_get_all+0x13/0x20
> Nov 17 14:07:39 thoregon kernel: [66571.611318]  [<ffffffff81200fb4>]
> ? xfs_bmap_search_multi_extents+0xa4/0x110
> Nov 17 14:07:39 thoregon kernel: [66571.611320]  [<ffffffff81080b55>]
> lock_acquire+0x55/0x70
> Nov 17 14:07:39 thoregon kernel: [66571.611322]  [<ffffffff8122b138>]
> ? xfs_trans_alloc+0x28/0x50
> Nov 17 14:07:39 thoregon kernel: [66571.611324]  [<ffffffff810f451b>]
> __sb_start_write+0xab/0x190
> Nov 17 14:07:39 thoregon kernel: [66571.611326]  [<ffffffff8122b138>]
> ? xfs_trans_alloc+0x28/0x50
> Nov 17 14:07:39 thoregon kernel: [66571.611328]  [<ffffffff8122b138>]
> ? xfs_trans_alloc+0x28/0x50
> Nov 17 14:07:39 thoregon kernel: [66571.611330]  [<ffffffff8122b138>]
> xfs_trans_alloc+0x28/0x50
> Nov 17 14:07:39 thoregon kernel: [66571.611332]  [<ffffffff811f3e64>]
> xfs_free_eofblocks+0x104/0x250
> Nov 17 14:07:39 thoregon kernel: [66571.611334]  [<ffffffff816b204b>]
> ? _raw_spin_unlock_irq+0x2b/0x50
> Nov 17 14:07:39 thoregon kernel: [66571.611336]  [<ffffffff811f4b39>]
> xfs_inactive+0xa9/0x480
> Nov 17 14:07:39 thoregon kernel: [66571.611337]  [<ffffffff816b204b>]
> ? _raw_spin_unlock_irq+0x2b/0x50
> Nov 17 14:07:39 thoregon kernel: [66571.611340]  [<ffffffff811efe10>]
> xfs_fs_evict_inode+0x70/0x80
> Nov 17 14:07:39 thoregon kernel: [66571.611342]  [<ffffffff8110cb7f>]
> evict+0xaf/0x1b0
> Nov 17 14:07:39 thoregon kernel: [66571.611344]  [<ffffffff8110d209>]
> dispose_list+0x39/0x50
> Nov 17 14:07:39 thoregon kernel: [66571.611346]  [<ffffffff8110dc63>]
> prune_icache_sb+0x183/0x340
> Nov 17 14:07:39 thoregon kernel: [66571.611347]  [<ffffffff810f5bc3>]
> prune_super+0xf3/0x1a0
> Nov 17 14:07:39 thoregon kernel: [66571.611349]  [<ffffffff810bbdee>]
> shrink_slab+0x11e/0x1f0
> Nov 17 14:07:39 thoregon kernel: [66571.611352]  [<ffffffff810be98f>]
> try_to_free_pages+0x21f/0x4e0
> Nov 17 14:07:39 thoregon kernel: [66571.611354]  [<ffffffff810b5ec6>]
> __alloc_pages_nodemask+0x506/0x800
> Nov 17 14:07:39 thoregon kernel: [66571.611356]  [<ffffffff810b9e40>]
> ? lru_deactivate_fn+0x1c0/0x1c0
> Nov 17 14:07:39 thoregon kernel: [66571.611358]  [<ffffffff810ce56e>]
> handle_pte_fault+0x5ae/0x7a0
> Nov 17 14:07:39 thoregon kernel: [66571.611360]  [<ffffffff810cf769>]
> handle_mm_fault+0x1f9/0x2a0
> Nov 17 14:07:39 thoregon kernel: [66571.611363]  [<ffffffff81029dfc>]
> __do_page_fault+0x16c/0x480
> Nov 17 14:07:39 thoregon kernel: [66571.611366]  [<ffffffff8129c7ad>]
> ? trace_hardirqs_off_thunk+0x3a/0x3c
> Nov 17 14:07:39 thoregon kernel: [66571.611368]  [<ffffffff8102a139>]
> do_page_fault+0x9/0x10
> Nov 17 14:07:39 thoregon kernel: [66571.611370]  [<ffffffff816b287f>]
> page_fault+0x1f/0x30

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
