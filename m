Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5NGPcqh036816 for <xfs@oss.sgi.com>; Tue, 23 Jun 2009 11:25:38 -0500
Received: from cobra.newdream.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A913C97E8B6
	for <xfs@oss.sgi.com>; Tue, 23 Jun 2009 09:34:25 -0700 (PDT)
Received: from cobra.newdream.net (cobra.newdream.net [66.33.216.30]) by
	cuda.sgi.com with ESMTP id xvHoSRmne5fL6RbB for
	<xfs@oss.sgi.com>; Tue, 23 Jun 2009 09:34:25 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by cobra.newdream.net (Postfix) with ESMTP id 1859ABCA63
	for <xfs@oss.sgi.com>; Tue, 23 Jun 2009 09:26:04 -0700 (PDT)
Date: Tue, 23 Jun 2009 09:26:04 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
Subject: inconsistent lock state on 2.6.30?
Message-ID: <Pine.LNX.4.64.0906230925420.20462@cobra.newdream.net>
MIME-Version: 1.0
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

Hi,

I have 6 machines using an XFS volume for logs, and strangely all 6 of 
them spit out the following at roughly the same time last night.  Most are 
around 50% full, all with a single directory full of large append-only 
files.  They're all running similar workloads, and are all nfs exported.

Is this a known issue?  If there's any other info that'd be helpful, let 
me know.

sage

This is vanilla 2.6.30 (plus some btrfs stuff from Chris' tree).


[15995.062724] =================================
[15995.063830] [ INFO: inconsistent lock state ]
[15995.063830] 2.6.30 #19
[15995.063830] ---------------------------------
[15995.063830] inconsistent {RECLAIM_FS-ON-R} -> {IN-RECLAIM_FS-W} usage.
[15995.063830] kswapd0/290 [HC0[0]:SC0[0]:HE1:SE1] takes:
[15995.063830]  (&(&ip->i_lock)->mr_lock){++++-?}, at: 
[<ffffffff803af57a>] xfs_ilock+0x5b/0x79
[15995.063830] {RECLAIM_FS-ON-R} state was registered at:
[15995.063830]   [<ffffffff8025c283>] mark_held_locks+0x4d/0x6b
[15995.063830]   [<ffffffff8025c349>] lockdep_trace_alloc+0xa8/0xc3
[15995.063830]   [<ffffffff802ab830>] kmem_cache_alloc+0x1e/0x1af
[15995.063830]   [<ffffffff803c9b57>] kmem_zone_alloc+0x67/0xb2
[15995.063830]   [<ffffffff803a0e48>] xfs_da_buf_make+0x29/0x11a
[15995.063830]   [<ffffffff803a13bf>] xfs_da_do_buf+0x486/0x5e7
[15995.063830]   [<ffffffff803a1588>] xfs_da_read_buf+0x25/0x27
[15995.063830]   [<ffffffff803a6395>] xfs_dir2_leaf_lookup_int+0x53/0x23e
[15995.063830]   [<ffffffff803a6d6c>] xfs_dir2_leaf_lookup+0x21/0xb0
[15995.063830]   [<ffffffff803a3ed8>] xfs_dir_lookup+0xfc/0x153
[15995.063830]   [<ffffffff803c779d>] xfs_lookup+0x4b/0xae
[15995.063830]   [<ffffffff803d038f>] xfs_vn_lookup+0x3f/0x7e
[15995.063830]   [<ffffffff802b8e0f>] do_lookup+0xd7/0x1bb
[15995.063830]   [<ffffffff802bae82>] __link_path_walk+0x960/0xdea
[15995.063830]   [<ffffffff802bb510>] path_walk+0x69/0xd4
[15995.063830]   [<ffffffff802bb757>] do_path_lookup+0x180/0x1a0
[15995.063830]   [<ffffffff802bc182>] user_path_at+0x52/0x93
[15995.063830]   [<ffffffff802b454b>] vfs_fstatat+0x35/0x62
[15995.063830]   [<ffffffff802b465a>] vfs_stat+0x16/0x18
[15995.063830]   [<ffffffff802b4676>] sys_newstat+0x1a/0x3b
[15995.063830]   [<ffffffff8020bb2b>] system_call_fastpath+0x16/0x1b
[15995.063830]   [<ffffffffffffffff>] 0xffffffffffffffff
[15995.063830] irq event stamp: 3742269
[15995.063830] hardirqs last  enabled at (3742269): [<ffffffff8062372c>] 
_spin_unlock_irqrestore+0x3f/0x68
[15995.063830] hardirqs last disabled at (3742268): [<ffffffff80623a80>] 
_spin_lock_irqsave+0x19/0x7f
[15995.063830] softirqs last  enabled at (3742246): [<ffffffff80240850>] 
__do_softirq+0x1d9/0x1e5
[15995.063830] softirqs last disabled at (3742051): [<ffffffff8020ccbc>] 
call_softirq+0x1c/0x28
[15995.063830] 
[15995.063830] other info that might help us debug this:
[15995.063830] 2 locks held by kswapd0/290:
[15995.063830]  #0:  (shrinker_rwsem){++++..}, at: [<ffffffff8028d7f8>] 
shrink_slab+0x38/0x188
[15995.063830]  #1:  (iprune_mutex){+.+.-.}, at: [<ffffffff802c3a37>] 
shrink_icache_memory+0x4b/0x23b
[15995.063830] 
[15995.063830] stack backtrace:
[15995.063830] Pid: 290, comm: kswapd0 Not tainted 2.6.30 #19
[15995.063830] Call Trace:
[15995.063830]  [<ffffffff8025bced>] print_usage_bug+0x1b2/0x1c3
[15995.063830]  [<ffffffff8025c8ce>] ? check_usage_forwards+0x0/0x9c
[15995.063830]  [<ffffffff8025c0a3>] mark_lock+0x3a5/0x538
[15995.063830]  [<ffffffff8025d9c1>] __lock_acquire+0x80d/0x16a9
[15995.063830]  [<ffffffff8025c554>] ? trace_hardirqs_on+0xd/0xf
[15995.063830]  [<ffffffff8025e844>] ? __lock_acquire+0x1690/0x16a9
[15995.063830]  [<ffffffff803af44d>] ? xfs_iunlock+0x58/0x7d
[15995.063830]  [<ffffffff8025e953>] lock_acquire+0xf6/0x11a
[15995.063830]  [<ffffffff803af57a>] ? xfs_ilock+0x5b/0x79
[15995.063830]  [<ffffffff80252a9d>] down_write_nested+0x46/0x7a
[15995.063830]  [<ffffffff803af57a>] ? xfs_ilock+0x5b/0x79
[15995.063830]  [<ffffffff803af57a>] xfs_ilock+0x5b/0x79
[15995.063830]  [<ffffffff803c6167>] xfs_reclaim+0x5f/0xa9
[15995.063830]  [<ffffffff803d253e>] xfs_fs_destroy_inode+0x37/0x57
[15995.063830]  [<ffffffff802c38df>] destroy_inode+0x3a/0x4f
[15995.063830]  [<ffffffff802c39b8>] dispose_list+0xc4/0xf8
[15995.063830]  [<ffffffff802c3bf1>] shrink_icache_memory+0x205/0x23b
[15995.425900]  [<ffffffff8028d89f>] shrink_slab+0xdf/0x188
[15995.425900]  [<ffffffff8028e0f5>] kswapd+0x4fc/0x6b2
[15995.425900]  [<ffffffff80232c88>] ? finish_task_switch+0x3b/0xdc
[15995.425900]  [<ffffffff8028b834>] ? isolate_pages_global+0x0/0x208
[15995.425900]  [<ffffffff8024fcfc>] ? autoremove_wake_function+0x0/0x38
[15995.425900]  [<ffffffff8025c554>] ? trace_hardirqs_on+0xd/0xf
[15995.425900]  [<ffffffff8028dbf9>] ? kswapd+0x0/0x6b2
[15995.425900]  [<ffffffff8028dbf9>] ? kswapd+0x0/0x6b2
[15995.425900]  [<ffffffff8024f8bd>] kthread+0x56/0x83
[15995.425900]  [<ffffffff8020cbba>] child_rip+0xa/0x20
[15995.425900]  [<ffffffff8020c580>] ? restore_args+0x0/0x30
[15995.425900]  [<ffffffff8062064f>] ? __schedule+0xf9/0x948
[15995.425900]  [<ffffffff8024f867>] ? kthread+0x0/0x83
[15995.425900]  [<ffffffff8020cbb0>] ? child_rip+0x0/0x20


cosd0:/data/cosd0     1.4T  195G  1.2T  15% /data/cosd0
cosd1:/data/cosd1     1.4T  723G  666G  53% /data/cosd1
cosd2:/data/cosd2     1.4T  751G  638G  55% /data/cosd2
cosd3:/data/cosd3     1.4T  725G  664G  53% /data/cosd3
cosd4:/data/cosd4     1.4T  781G  608G  57% /data/cosd4
cosd5:/data/cosd5     1.4T  252G  1.2T  19% /data/cosd5


cephbooter:src 09:15 AM $ ls -alt /data/cosd0
total 204154544
-rw-r--r--  1 root root   857068389 Jun 23 09:15 cosd0.4933
drwxrwxrwx  3 sage root        4096 Jun 23 09:00 ./
-rw-r--r--  1 root root  8281922410 Jun 23 00:00 cosd0.2951
-rw-r--r--  1 root root    20940651 Jun 22 21:11 cosd0.2819
-rw-r--r--  1 root root  2147953265 Jun 22 21:06 cosd0.3540
-rw-r--r--  1 root root    20467667 Jun 22 14:33 cosd0.3011
-rw-r--r--  1 root root        8901 Jun 22 11:37 cosd0.5883
-rw-r--r--  1 root root     7908631 Jun 22 11:23 cosd0.2848
-rw-r--r--  1 root root    10024103 Jun 22 11:03 cosd0.2878
-rw-r--r--  1 root root     2938884 Jun 22 10:50 cosd0.2839
-rw-r--r--  1 root root     3638369 Jun 22 10:39 cosd0.2850
-rw-r--r--  1 root root     5417901 Jun 22 10:26 cosd0.333
-rw-r--r--  1 root root  4636354461 Jun 22 09:45 cosd0.17850
-rw-r--r--  1 root root    29435833 Jun 20 13:59 cosd0.17677
-rw-r--r--  1 root root 10219072349 Jun 19 18:12 cosd0.13757
-rw-r--r--  1 root root  1220088789 Jun 19 14:35 cosd0.13361
-rw-r--r--  1 root root  5797673581 Jun 19 13:08 cosd0.10750
-rw-r--r--  1 root root  4123582318 Jun 18 22:22 cosd0.8060
-rw-r--r--  1 root root   173783782 Jun 18 19:59 cosd0.6954
-rw-r--r--  1 root root  1882559844 Jun 18 18:59 cosd0.6835
-rw-r--r--  1 root root 17640663138 Jun 18 18:41 cosd0.5692
-rw-r--r--  1 root root 21234161287 Jun 18 16:46 cosd0.613
-rw-r--r--  1 root root  5092581694 Jun 18 11:41 cosd0.31060
-rw-r--r--  1 root root  2740724642 Jun 17 21:15 cosd0.30596
-rw-r--r--  1 root root   573749446 Jun 17 20:46 cosd0.27405
-rw-r--r--  1 root root 26034092104 Jun 17 20:38 cosd0.21811
-rw-r--r--  1 root root       12258 Jun 17 16:45 cosd0.21734
-rw-r--r--  1 root root  9433787740 Jun 17 16:42 cosd0.19147
-rw-r--r--  1 root root 10335461821 Jun 17 13:57 cosd0.17465
-rw-r--r--  1 root root       11907 Jun 17 12:49 cosd0.17388
-rw-r--r--  1 root root   142735251 Jun 17 12:48 cosd0.17068
-rw-r--r--  1 root root    50601869 Jun 17 10:33 cosd0.16835
-rw-------  1 root root        1368 Jun 16 16:36 v.osd0
-rw-r--r--  1 root root   128588033 Jun 16 16:36 cosd0.16239
-rw-r--r--  1 root root    24984315 Jun 16 15:25 cosd0.16107
-rw-r--r--  1 root root       11432 Jun 16 15:19 cosd0.15939
-rw-r--r--  1 root root   375887383 Jun 15 13:54 cosd0.14972
-rw-r--r--  1 root root   156713966 Jun 15 13:48 cosd0.14706
-rw-r--r--  1 root root   375892019 Jun 15 12:28 cosd0.14548
-rw-r--r--  1 root root     2907413 Jun 15 12:21 cosd0.14447
-rw-------  1 root root   757800910 Jun 15 10:39 v.osd0.core.13741
-rw-r--r--  1 root root   367661001 Jun 15 10:39 cosd0.13741
-rw-r--r--  1 root root 47206256640 Jun 15 10:04 cosd0.1996
-rw-r--r--  1 root root       10724 Jun 11 13:47 cosd0.1929
-rw-r--r--  1 root root  6873889489 Jun 11 13:44 cosd0.30383
-rw-r--r--  1 root root       10373 Jun 11 10:31 cosd0.30316
-rw-r--r--  1 root root    45594765 Jun 11 10:31 cosd0.29706
-rw-r--r--  1 root root   228800846 Jun 11 09:19 cosd0.6102
-rw-r--r--  1 root root   922173777 Jun 10 16:23 cosd0.4821
-rw-r--r--  1 root root    15951020 Jun 10 15:38 cosd0.4623
-rw-r--r--  1 root root    72318198 Jun 10 15:32 cosd0.3878
-rw-r--r--  1 root root        9780 Jun 10 15:03 cosd0.3806
-rw-r--r--  1 root root   140140785 Jun 10 15:02 cosd0.3248
-rw-r--r--  1 root root  1883700297 Jun 10 14:52 cosd0.1983
-rw-r--r--  1 root root        9426 Jun 10 14:06 cosd0.1904
-rw-r--r--  1 root root    41278924 Jun 10 14:05 cosd0.1569
-rw-r--r--  1 root root        9070 Jun 10 13:49 cosd0.1488
-rw-r--r--  1 root root    20299032 Jun 10 13:48 cosd0.1214
-rw-r--r--  1 root root     7905217 Jun 10 13:25 cosd0.991
-rw-r--r--  1 root root     6880684 Jun 10 13:23 cosd0.923
-rw-r--r--  1 root root        2761 Jun 10 13:21 cosd0.918
-rw-r--r--  1 root root    27545438 Jun 10 13:20 cosd0.865
-rw-r--r--  1 root root        8363 Jun 10 13:19 cosd0.798
-rw-r--r--  1 root root        8359 Jun 10 13:17 cosd0.538
-rw-r--r--  1 root root      776417 Jun 10 13:13 cosd0.318
-rw-r--r--  1 root root        2189 Jun 10 13:12 cosd0.32681
-rw-r--r--  1 root root        2071 Jun 10 13:11 cosd0.32576
-rw-r--r--  1 root root        1954 Jun 10 13:09 cosd0.32443
-rw-r--r--  1 root root    15686147 Jun 10 13:06 cosd0.32211
-rw-r--r--  1 root root    28463184 Jun 10 13:01 cosd0.31949
-rw-r--r--  1 root root        7547 Jun 10 12:57 cosd0.31788
-rw-r--r--  1 root root    67451634 Jun 10 12:56 cosd0.31393
-rw-r--r--  1 root root   920366392 Jun 10 12:37 cosd0.30258
-rw-r--r--  1 root root        7196 Jun 10 11:51 cosd0.30142
-rw-r--r--  1 root root     2982264 Jun 10 11:51 cosd0.29942
-rw-r--r--  1 root root   191239953 Jun 10 11:49 cosd0.29808
-rw-r--r--  1 root root 14460208356 Jun 10 07:33 cosd0.25902
-rw-r--r--  1 root root   980533105 Jun  9 21:20 cosd0.25460
drwxr-xr-x 16 root root        4096 Jun  7 22:27 ../
drwxr-xr-x  3 sage sage          17 Apr 23 12:34 mondata/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
