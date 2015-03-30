Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 601387F37
	for <xfs@oss.sgi.com>; Mon, 30 Mar 2015 02:29:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3E9A6304032
	for <xfs@oss.sgi.com>; Mon, 30 Mar 2015 00:29:21 -0700 (PDT)
Received: from mail-wi0-f180.google.com (mail-wi0-f180.google.com
	[209.85.212.180]) by cuda.sgi.com with ESMTP id
	uyg61HhesCh6SHk2 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 30 Mar 2015 00:29:18 -0700 (PDT)
Received: by wixm2 with SMTP id m2so79045273wix.0
	for <xfs@oss.sgi.com>; Mon, 30 Mar 2015 00:29:18 -0700 (PDT)
Message-ID: <5518FB4A.4070200@monom.org>
Date: Mon, 30 Mar 2015 09:29:14 +0200
From: Daniel Wagner <wagi@monom.org>
MIME-Version: 1.0
Subject: deadlock between &type->i_mutex_dir_key#4 and &xfs_dir_ilock_class
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
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Hi,

Just my test box booted 4.0.0-rc6 and I was greeted by:


[Mar30 10:10] ======================================================
[  +0.000043] [ INFO: possible circular locking dependency detected ]
[  +0.000045] 4.0.0-rc6 #32 Not tainted
[  +0.000027] -------------------------------------------------------
[  +0.000042] ls/1709 is trying to acquire lock:
[  +0.000034]  (&mm->mmap_sem){++++++}, at: [<ffffffff811e62cf>] might_fault+0x5f/0xb0
[  +0.000083] 
but task is already holding lock:
[  +0.000043]  (&xfs_dir_ilock_class){.+.+..}, at: [<ffffffffa0424902>] xfs_ilock+0xc2/0x130 [xfs]
[  +0.000110] 
which lock already depends on the new lock.

[  +0.000058] 
the existing dependency chain (in reverse order) is:
[  +0.000049] 
-> #2 (&xfs_dir_ilock_class){.+.+..}:
[  +0.000054]        [<ffffffff810ef987>] lock_acquire+0xc7/0x160
[  +0.000048]        [<ffffffff810e7797>] down_read_nested+0x57/0xa0
[  +0.000048]        [<ffffffffa0424902>] xfs_ilock+0xc2/0x130 [xfs]
[  +0.000071]        [<ffffffffa04249e8>] xfs_ilock_attr_map_shared+0x38/0x50 [xfs]
[  +0.000076]        [<ffffffffa03d64bc>] xfs_attr_get+0xdc/0x1b0 [xfs]
[  +0.000062]        [<ffffffffa043287d>] xfs_xattr_get+0x3d/0x80 [xfs]
[  +0.000073]        [<ffffffff812650ff>] generic_getxattr+0x4f/0x70
[  +0.000052]        [<ffffffff8135a802>] inode_doinit_with_dentry+0x172/0x6a0
[  +0.000054]        [<ffffffff8135b91c>] selinux_d_instantiate+0x1c/0x20
[  +0.000049]        [<ffffffff8134ef9b>] security_d_instantiate+0x1b/0x30
[  +0.000050]        [<ffffffff8125770d>] d_splice_alias+0x9d/0x360
[  +0.000047]        [<ffffffffa0422922>] xfs_vn_lookup+0x92/0xd0 [xfs]
[  +0.000071]        [<ffffffff81244d0d>] lookup_real+0x1d/0x70
[  +0.000045]        [<ffffffff81245902>] __lookup_hash+0x42/0x60
[  +0.000045]        [<ffffffff81248141>] link_path_walk+0x411/0x1450
[  +0.000046]        [<ffffffff81249237>] path_init+0xb7/0x710
[  +0.000043]        [<ffffffff8124cf96>] path_openat+0x76/0x670
[  +0.000042]        [<ffffffff8124ebe9>] do_filp_open+0x49/0xd0
[  +0.000044]        [<ffffffff812394cb>] do_sys_open+0x13b/0x250
[  +0.000044]        [<ffffffff812395fe>] SyS_open+0x1e/0x20
[  +0.000041]        [<ffffffff817e7589>] system_call_fastpath+0x12/0x17
[  +0.000047] 
-> #1 (&isec->lock){+.+.+.}:
[  +0.000045]        [<ffffffff810ef987>] lock_acquire+0xc7/0x160
[  +0.000045]        [<ffffffff817e273d>] mutex_lock_nested+0x7d/0x450
[  +0.000045]        [<ffffffff8135a755>] inode_doinit_with_dentry+0xc5/0x6a0
[  +0.000050]        [<ffffffff8135b91c>] selinux_d_instantiate+0x1c/0x20
[  +0.001072]        [<ffffffff8134ef9b>] security_d_instantiate+0x1b/0x30
[  +0.001056]        [<ffffffff81255454>] d_instantiate+0x54/0x80
[  +0.001052]        [<ffffffff811d24bc>] __shmem_file_setup+0xdc/0x250
[  +0.001059]        [<ffffffff811d5fd8>] shmem_zero_setup+0x28/0x70
[  +0.001074]        [<ffffffff811f2168>] mmap_region+0x5d8/0x5f0
[  +0.001045]        [<ffffffff811f249b>] do_mmap_pgoff+0x31b/0x400
[  +0.001040]        [<ffffffff811d6540>] vm_mmap_pgoff+0xb0/0xf0
[  +0.001015]        [<ffffffff811f07e6>] SyS_mmap_pgoff+0x116/0x2b0
[  +0.001009]        [<ffffffff8101bc12>] SyS_mmap+0x22/0x30
[  +0.001000]        [<ffffffff817e7589>] system_call_fastpath+0x12/0x17
[  +0.000991] 
-> #0 (&mm->mmap_sem){++++++}:
[  +0.001902]        [<ffffffff810ee958>] __lock_acquire+0x2048/0x2050
[  +0.000968]        [<ffffffff810ef987>] lock_acquire+0xc7/0x160
[  +0.000941]        [<ffffffff811e62fc>] might_fault+0x8c/0xb0
[  +0.000937]        [<ffffffff81251ac2>] filldir+0x92/0x120
[  +0.000950]        [<ffffffffa04157d9>] xfs_dir2_block_getdents.isra.11+0x1b9/0x210 [xfs]
[  +0.000994]        [<ffffffffa04159a8>] xfs_readdir+0x178/0x1c0 [xfs]
[  +0.000986]        [<ffffffffa041758b>] xfs_file_readdir+0x2b/0x30 [xfs]
[  +0.000985]        [<ffffffff8125189a>] iterate_dir+0x9a/0x140
[  +0.000956]        [<ffffffff81251db4>] SyS_getdents+0x94/0x120
[  +0.000942]        [<ffffffff817e7589>] system_call_fastpath+0x12/0x17
[  +0.000949] 
other info that might help us debug this:

[  +0.002781] Chain exists of:
  &mm->mmap_sem --> &isec->lock --> &xfs_dir_ilock_class

[  +0.002801]  Possible unsafe locking scenario:

[  +0.001860]        CPU0                    CPU1
[  +0.000927]        ----                    ----
[  +0.000926]   lock(&xfs_dir_ilock_class);
[  +0.000918]                                lock(&isec->lock);
[  +0.000935]                                lock(&xfs_dir_ilock_class);
[  +0.000941]   lock(&mm->mmap_sem);
[  +0.000926] 
 *** DEADLOCK ***

[  +0.002726] 2 locks held by ls/1709:
[  +0.000909]  #0:  (&type->i_mutex_dir_key#4){+.+.+.}, at: [<ffffffff81251861>] iterate_dir+0x61/0x140
[  +0.000995]  #1:  (&xfs_dir_ilock_class){.+.+..}, at: [<ffffffffa0424902>] xfs_ilock+0xc2/0x130 [xfs]
[  +0.001019] 
stack backtrace:
[  +0.001923] CPU: 32 PID: 1709 Comm: ls Not tainted 4.0.0-rc6 #32
[  +0.000979] Hardware name: Dell Inc. PowerEdge R820/066N7P, BIOS 2.0.20 01/16/2014
[  +0.000997]  0000000000000000 00000000c4a0aaca ffff881faea3bb18 ffffffff817dd7b1
[  +0.001034]  0000000000000000 ffffffff82897000 ffff881faea3bb68 ffffffff810ead5d
[  +0.001018]  ffff881fac919ea8 ffff881faea3bbc8 ffff881faea3bb68 ffff881fac919e70
[  +0.001026] Call Trace:
[  +0.001003]  [<ffffffff817dd7b1>] dump_stack+0x4c/0x65
[  +0.001019]  [<ffffffff810ead5d>] print_circular_bug+0x1cd/0x230
[  +0.001027]  [<ffffffff810ee958>] __lock_acquire+0x2048/0x2050
[  +0.001067]  [<ffffffff810ef987>] lock_acquire+0xc7/0x160
[  +0.001036]  [<ffffffff811e62cf>] ? might_fault+0x5f/0xb0
[  +0.001040]  [<ffffffff811e62fc>] might_fault+0x8c/0xb0
[  +0.001051]  [<ffffffff811e62cf>] ? might_fault+0x5f/0xb0
[  +0.001027]  [<ffffffff81251ac2>] filldir+0x92/0x120
[  +0.001043]  [<ffffffffa04157d9>] xfs_dir2_block_getdents.isra.11+0x1b9/0x210 [xfs]
[  +0.001080]  [<ffffffffa04159a8>] xfs_readdir+0x178/0x1c0 [xfs]
[  +0.001030]  [<ffffffff817e2483>] ? mutex_lock_killable_nested+0x2a3/0x4e0
[  +0.001067]  [<ffffffffa041758b>] xfs_file_readdir+0x2b/0x30 [xfs]
[  +0.001049]  [<ffffffff8125189a>] iterate_dir+0x9a/0x140
[  +0.001044]  [<ffffffff81251db4>] SyS_getdents+0x94/0x120
[  +0.001034]  [<ffffffff81251a30>] ? fillonedir+0xf0/0xf0
[  +0.001038]  [<ffffffff817e7589>] system_call_fastpath+0x12/0x17


I tried to find out if this was reported before but I
haven't found anything. If I missed it I am sorry for the noise.

cheers,
daniel

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
