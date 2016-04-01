Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CD4637CB0
	for <xfs@oss.sgi.com>; Fri,  1 Apr 2016 01:48:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7F198304032
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2016 23:48:40 -0700 (PDT)
Received: from mail.kernel.org ([198.145.29.136]) by cuda.sgi.com with ESMTP
	id wI18ZGPbBA3EFUld (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 31 Mar 2016 23:48:38 -0700 (PDT)
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 921E820398
	for <xfs@oss.sgi.com>; Fri,  1 Apr 2016 06:48:37 +0000 (UTC)
Received: from mail-ob0-f177.google.com (mail-ob0-f177.google.com
	[209.85.214.177])
	(using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id 9BBCE2037C
	for <xfs@oss.sgi.com>; Fri,  1 Apr 2016 06:48:36 +0000 (UTC)
Received: by mail-ob0-f177.google.com with SMTP id fp4so40405669obb.2
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2016 23:48:36 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 31 Mar 2016 23:48:35 -0700
Message-ID: <CAF1ivSarZVXxAaSmKCQOLw1fy3+iAM8GWRjf7qqBHKABmNTFfQ@mail.gmail.com>
Subject: generic/027 possible deadlock
From: Ming Lin <mlin@kernel.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Is it known?

[  427.145528] run fstests generic/027 at 2016-03-31 22:48:31
[  427.583892] XFS (nvme0n1p2): Mounting V5 Filesystem
[  427.600853] XFS (nvme0n1p2): Ending clean mount
[  428.544208]
[  428.546684] ======================================================
[  428.553922] [ INFO: possible circular locking dependency detected ]
[  428.561162] 4.5.0+ #175 Tainted: G            E
[  428.566909] -------------------------------------------------------
[  428.574207] xfs_io/4733 is trying to acquire lock:
[  428.580045]  (&s->s_sync_lock){+.+.+.}, at: [<ffffffff811f8c32>]
sync_inodes_sb+0xc2/0x1d0
[  428.589375]
[  428.589375] but task is already holding lock:
[  428.597206]  (sb_internal#2){.+.+.+}, at: [<ffffffff811cf386>]
__sb_start_write+0x76/0xe0
[  428.606601]
[  428.606601] which lock already depends on the new lock.
[  428.606601]
[  428.617908]
[  428.617908] the existing dependency chain (in reverse order) is:
[  428.627562]
[  428.627562] -> #1 (sb_internal#2){.+.+.+}:
[  428.633501]        [<ffffffff810bb760>] lock_acquire+0x90/0xf0
[  428.640128]        [<ffffffff810b5d95>] percpu_down_read+0x45/0x90
[  428.647111]        [<ffffffff811cf3dc>] __sb_start_write+0xcc/0xe0
[  428.654103]        [<ffffffffc08d032f>] xfs_trans_alloc+0x1f/0x40 [xfs]
[  428.661541]        [<ffffffffc08c703e>] xfs_inactive_truncate+0x1e/0xf0 [xfs]
[  428.669504]        [<ffffffffc08c7d3e>] xfs_inactive+0xee/0x110 [xfs]
[  428.676764]        [<ffffffffc08ccc54>] xfs_fs_evict_inode+0x94/0xa0 [xfs]
[  428.684463]        [<ffffffff811e96a3>] evict+0xb3/0x190
[  428.690586]        [<ffffffff811e9ff3>] iput+0x133/0x1a0
[  428.696708]        [<ffffffff811f8cba>] sync_inodes_sb+0x14a/0x1d0
[  428.703701]        [<ffffffff811fee50>] sync_inodes_one_sb+0x10/0x20
[  428.710894]        [<ffffffff811cfdb9>] iterate_supers+0xa9/0x100
[  428.717803]        [<ffffffff811ff140>] sys_sync+0x30/0x90
[  428.724091]        [<ffffffff81770976>] entry_SYSCALL_64_fastpath+0x16/0x7a
[  428.731867]
[  428.731867] -> #0 (&s->s_sync_lock){+.+.+.}:
[  428.737895]        [<ffffffff810bb02e>] __lock_acquire+0x15be/0x1c60
[  428.745072]        [<ffffffff810bb760>] lock_acquire+0x90/0xf0
[  428.751717]        [<ffffffff8176d52f>] mutex_lock_nested+0x5f/0x400
[  428.758918]        [<ffffffff811f8c32>] sync_inodes_sb+0xc2/0x1d0
[  428.765834]        [<ffffffffc08cea93>] xfs_flush_inodes+0x23/0x30 [xfs]
[  428.773374]        [<ffffffffc08c6bb0>] xfs_create+0x530/0x5c0 [xfs]
[  428.780556]        [<ffffffffc08c32ce>] xfs_generic_create+0xbe/0x290 [xfs]
[  428.788358]        [<ffffffffc08c34cf>] xfs_vn_mknod+0xf/0x20 [xfs]
[  428.795455]        [<ffffffffc08c350e>] xfs_vn_create+0xe/0x10 [xfs]
[  428.802658]        [<ffffffff811d7c8d>] vfs_create+0xbd/0x120
[  428.809224]        [<ffffffff811db8b0>] path_openat+0x1070/0x1490
[  428.816137]        [<ffffffff811dcce9>] do_filp_open+0x79/0xd0
[  428.822795]        [<ffffffff811cb160>] do_sys_open+0x110/0x1f0
[  428.829539]        [<ffffffff811cb259>] SyS_open+0x19/0x20
[  428.835840]        [<ffffffff81770976>] entry_SYSCALL_64_fastpath+0x16/0x7a
[  428.843646]
[  428.843646] other info that might help us debug this:
[  428.843646]
[  428.854018]  Possible unsafe locking scenario:
[  428.854018]
[  428.861503]        CPU0                    CPU1
[  428.866845]        ----                    ----
[  428.872162]   lock(sb_internal#2);
[  428.876384]                                lock(&s->s_sync_lock);
[  428.883307]                                lock(sb_internal#2);
[  428.890064]   lock(&s->s_sync_lock);
[  428.894470]
[  428.894470]  *** DEADLOCK ***
[  428.894470]
[  428.902637] 4 locks held by xfs_io/4733:
[  428.907317]  #0:  (sb_writers#14){.+.+.+}, at: [<ffffffff811cf3dc>]
__sb_start_write+0xcc/0xe0
[  428.916833]  #1:  (&type->i_mutex_dir_key#6){+.+.+.}, at:
[<ffffffff811daceb>] path_openat+0x4ab/0x1490
[  428.927146]  #2:  (sb_internal#2){.+.+.+}, at: [<ffffffff811cf386>]
__sb_start_write+0x76/0xe0
[  428.936680]  #3:  (&type->s_umount_key#37){++++++}, at:
[<ffffffffc08cea87>] xfs_flush_inodes+0x17/0x30 [xfs]
[  428.947539]
[  428.947539] stack backtrace:
[  428.953478] CPU: 4 PID: 4733 Comm: xfs_io Tainted: G            E
4.5.0+ #175
[  428.961642] Hardware name: Dell Inc. OptiPlex 7010/0773VG, BIOS A12
01/10/2013
[  428.969724]  0000000000000000 ffff8800bd773908 ffffffff813816fc
ffffffff825d75b0
[  428.978044]  ffffffff825d75b0 ffff8800bd773948 ffffffff81141149
ffff8800bd773990
[  428.986352]  ffff8800bd9a4980 ffff8800bd9a5188 ffff8800bd9a5160
0000000000000003
[  428.994655] Call Trace:
[  428.997893]  [<ffffffff813816fc>] dump_stack+0x85/0xc9
[  429.003838]  [<ffffffff81141149>] print_circular_bug+0x1f9/0x207
[  429.010647]  [<ffffffff810bb02e>] __lock_acquire+0x15be/0x1c60
[  429.017288]  [<ffffffff810b341c>] ? finish_wait+0x5c/0x70
[  429.023510]  [<ffffffff810bb760>] lock_acquire+0x90/0xf0
[  429.029631]  [<ffffffff811f8c32>] ? sync_inodes_sb+0xc2/0x1d0
[  429.036214]  [<ffffffff8176d52f>] mutex_lock_nested+0x5f/0x400
[  429.042850]  [<ffffffff811f8c32>] ? sync_inodes_sb+0xc2/0x1d0
[  429.049406]  [<ffffffff811f75d5>] ? wb_wait_for_completion+0x75/0x80
[  429.056589]  [<ffffffff811f8c32>] sync_inodes_sb+0xc2/0x1d0
[  429.062970]  [<ffffffffc08cea93>] xfs_flush_inodes+0x23/0x30 [xfs]
[  429.069967]  [<ffffffffc08c6bb0>] xfs_create+0x530/0x5c0 [xfs]
[  429.076612]  [<ffffffff811e39a7>] ? __d_instantiate+0x87/0xf0
[  429.083160]  [<ffffffff8122ccde>] ? posix_acl_create+0xfe/0x150
[  429.089892]  [<ffffffffc08c32ce>] xfs_generic_create+0xbe/0x290 [xfs]
[  429.097146]  [<ffffffff81329a7b>] ? common_perm+0x1b/0x70
[  429.103369]  [<ffffffffc08c34cf>] xfs_vn_mknod+0xf/0x20 [xfs]
[  429.109927]  [<ffffffffc08c350e>] xfs_vn_create+0xe/0x10 [xfs]
[  429.116569]  [<ffffffff811d7c8d>] vfs_create+0xbd/0x120
[  429.122603]  [<ffffffff811db8b0>] path_openat+0x1070/0x1490
[  429.128984]  [<ffffffff811dcce9>] do_filp_open+0x79/0xd0
[  429.135109]  [<ffffffff8176ffa2>] ? _raw_spin_unlock+0x22/0x40
[  429.141756]  [<ffffffff811ec358>] ? __alloc_fd+0xf8/0x200
[  429.147971]  [<ffffffff811cb160>] do_sys_open+0x110/0x1f0
[  429.154170]  [<ffffffff811cb259>] SyS_open+0x19/0x20
[  429.159930]  [<ffffffff81770976>] entry_SYSCALL_64_fastpath+0x16/0x7a
[  440.468568] XFS (nvme0n1p2): Unmounting Filesystem

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
