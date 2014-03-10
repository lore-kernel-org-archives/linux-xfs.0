Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B34997F3F
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2014 05:55:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8E25B304062
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2014 03:55:31 -0700 (PDT)
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72]) by
	cuda.sgi.com with ESMTP id zNStTgKwvLqulQUY (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 10 Mar 2014 03:55:26 -0700 (PDT)
Subject: [3.14-rc5 xfs] Lockdep warning
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <201403101955.AAI04114.QJOFFFtHMSOLOV@I-love.SAKURA.ne.jp>
Date: Mon, 10 Mar 2014 19:55:19 +0900
Mime-Version: 1.0
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
To: david@fromorbit.com
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

I get below lockdep warning as of 1dc3217d on linux.git. I guess the situation
is same as of v3.14-rc6 because there is no changes in fs/xfs directory between
1dc3217d and v3.14-rc6. Also, the culprit commits were already backported to
RHEL7 beta somewhere between 3.10.0-90.el7 and 3.10.0-97.el7 .

[   95.858636] audit: type=1404 audit(1394466090.590:2): selinux=0 auid=4294967295 ses=4294967295

[   96.077814] ======================================================
[   96.078356] [ INFO: possible circular locking dependency detected ]
[   96.078748] 3.14.0-rc5+ #263 Not tainted
[   96.079008] -------------------------------------------------------
[   96.079182] systemd/1 is trying to acquire lock:
[   96.079214]  (&mm->mmap_sem){++++++}, at: [<ffffffff811bbd9f>] might_fault+0x5f/0xb0
[   96.079520]
but task is already holding lock:
[   96.079952]  (&(&ip->i_lock)->mr_lock){++++..}, at: [<ffffffffa020a432>] xfs_ilock+0x122/0x250 [xfs]
[   96.080061]
which lock already depends on the new lock.

[   96.080574]
the existing dependency chain (in reverse order) is:
[   96.080959]
-> #1 (&(&ip->i_lock)->mr_lock){++++..}:
[   96.081263]        [<ffffffff810de6a6>] __lock_acquire+0x3c6/0xb60
[   96.081310]        [<ffffffff810df632>] lock_acquire+0xa2/0x1d0
[   96.081497]        [<ffffffff810d80f7>] down_read_nested+0x57/0xa0
[   96.081541]        [<ffffffffa020a432>] xfs_ilock+0x122/0x250 [xfs]
[   96.081761]        [<ffffffffa020a590>] xfs_ilock_data_map_shared+0x30/0x40 [xfs]
[   96.081838]        [<ffffffffa01a3653>] __xfs_get_blocks+0xc3/0x7e0 [xfs]
[   96.082010]        [<ffffffffa01a3d81>] xfs_get_blocks+0x11/0x20 [xfs]
[   96.082152]        [<ffffffff81257817>] do_mpage_readpage+0x447/0x670
[   96.082200]        [<ffffffff81257b1b>] mpage_readpages+0xdb/0x130
[   96.082466]        [<ffffffffa01a1e3d>] xfs_vm_readpages+0x1d/0x20 [xfs]
[   96.082608]        [<ffffffff8119e672>] __do_page_cache_readahead+0x2c2/0x360
[   96.082659]        [<ffffffff8119ede1>] ra_submit+0x21/0x30
[   96.082848]        [<ffffffff81191fd5>] filemap_fault+0x395/0x440
[   96.082971]        [<ffffffff811bc3cf>] __do_fault+0x6f/0x530
[   96.083091]        [<ffffffff811c0642>] handle_mm_fault+0x492/0xee0
[   96.083258]        [<ffffffff816ab626>] __do_page_fault+0x196/0x5b0
[   96.083310]        [<ffffffff816aba71>] do_page_fault+0x31/0x70
[   96.083350]        [<ffffffff816a79f8>] page_fault+0x28/0x30
[   96.083538]        [<ffffffff81342def>] clear_user+0x2f/0x40
[   96.083579]        [<ffffffff81270db9>] padzero+0x29/0x40
[   96.083767]        [<ffffffff81271a16>] load_elf_binary+0x976/0xd80
[   96.083890]        [<ffffffff812173f4>] search_binary_handler+0x94/0x1b0
[   96.084160]        [<ffffffff81218a74>] do_execve_common.isra.26+0x654/0x8d0
[   96.084288]        [<ffffffff81218f69>] SyS_execve+0x29/0x30
[   96.084548]        [<ffffffff816b1959>] stub_execve+0x69/0xa0
[   96.084669]
-> #0 (&mm->mmap_sem){++++++}:
[   96.084863]        [<ffffffff810dd7a1>] validate_chain.isra.43+0x1131/0x11d0
[   96.086017]        [<ffffffff810de6a6>] __lock_acquire+0x3c6/0xb60
[   96.087062]        [<ffffffff810df632>] lock_acquire+0xa2/0x1d0
[   96.088117]        [<ffffffff811bbdcc>] might_fault+0x8c/0xb0
[   96.089183]        [<ffffffff81225e11>] filldir+0x91/0x120
[   96.090211]        [<ffffffffa01aeee8>] xfs_dir2_block_getdents+0x1e8/0x250 [xfs]
[   96.091289]        [<ffffffffa01af0cd>] xfs_readdir+0x11d/0x210 [xfs]
[   96.092331]        [<ffffffffa01b166b>] xfs_file_readdir+0x2b/0x40 [xfs]
[   96.093388]        [<ffffffff81225c58>] iterate_dir+0xa8/0xe0
[   96.094396]        [<ffffffff81226103>] SyS_getdents+0x93/0x120
[   96.095434]        [<ffffffff816b1329>] system_call_fastpath+0x16/0x1b
[   96.096443]
other info that might help us debug this:

[   96.098894]  Possible unsafe locking scenario:

[   96.099795]        CPU0                    CPU1
[   96.100234]        ----                    ----
[   96.100666]   lock(&(&ip->i_lock)->mr_lock);
[   96.101158]                                lock(&mm->mmap_sem);
[   96.101597]                                lock(&(&ip->i_lock)->mr_lock);
[   96.102030]   lock(&mm->mmap_sem);
[   96.102458]
 *** DEADLOCK ***

[   96.103750] 2 locks held by systemd/1:
[   96.104224]  #0:  (&type->i_mutex_dir_key#2){+.+.+.}, at: [<ffffffff81225c12>] iterate_dir+0x62/0xe0
[   96.104669]  #1:  (&(&ip->i_lock)->mr_lock){++++..}, at: [<ffffffffa020a432>] xfs_ilock+0x122/0x250 [xfs]
[   96.105135]
stack backtrace:
[   96.106039] CPU: 1 PID: 1 Comm: systemd Not tainted 3.14.0-rc5+ #263
[   96.106481] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 09/20/2012
[   96.106946]  ffffffff826a82a0 ffff880078427c08 ffffffff8169d6bd ffffffff826a82a0
[   96.107424]  ffff880078427c48 ffffffff81696ef2 ffff880078427c80 0000000000000001
[   96.107906]  ffff880078428cf8 0000000000000002 ffff880078428000 ffff880078428cf8
[   96.108421] Call Trace:
[   96.108964]  [<ffffffff8169d6bd>] dump_stack+0x4d/0x66
[   96.109459]  [<ffffffff81696ef2>] print_circular_bug+0x1f9/0x207
[   96.109949]  [<ffffffff810dd7a1>] validate_chain.isra.43+0x1131/0x11d0
[   96.110490]  [<ffffffff810de6a6>] __lock_acquire+0x3c6/0xb60
[   96.111040]  [<ffffffffa01ad0bc>] ? xfs_buf_read_map+0x2c/0x270 [xfs]
[   96.111556]  [<ffffffff810df632>] lock_acquire+0xa2/0x1d0
[   96.112097]  [<ffffffff811bbd9f>] ? might_fault+0x5f/0xb0
[   96.112610]  [<ffffffff811bbdcc>] might_fault+0x8c/0xb0
[   96.113119]  [<ffffffff811bbd9f>] ? might_fault+0x5f/0xb0
[   96.113660]  [<ffffffff81225e11>] filldir+0x91/0x120
[   96.114160]  [<ffffffffa01aeee8>] xfs_dir2_block_getdents+0x1e8/0x250 [xfs]
[   96.114668]  [<ffffffffa01af0cd>] xfs_readdir+0x11d/0x210 [xfs]
[   96.115166]  [<ffffffffa01b166b>] xfs_file_readdir+0x2b/0x40 [xfs]
[   96.115658]  [<ffffffff81225c58>] iterate_dir+0xa8/0xe0
[   96.116194]  [<ffffffff81226103>] SyS_getdents+0x93/0x120
[   96.116686]  [<ffffffff81225d80>] ? fillonedir+0xf0/0xf0
[   96.117198]  [<ffffffff816b1329>] system_call_fastpath+0x16/0x1b
[   99.855526] systemd-journald[426]: Vacuuming done, freed 0 bytes

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
