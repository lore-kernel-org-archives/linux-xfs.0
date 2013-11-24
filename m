Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CD17E7F52
	for <xfs@oss.sgi.com>; Sun, 24 Nov 2013 08:04:17 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9F125304070
	for <xfs@oss.sgi.com>; Sun, 24 Nov 2013 06:04:14 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 1ekYRJNpLyNf5t4Q (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 24 Nov 2013 06:04:13 -0800 (PST)
Date: Sun, 24 Nov 2013 06:04:13 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: inode_permission NULL pointer dereference in 3.13-rc1
Message-ID: <20131124140413.GA19271@infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org
Cc: xfs@oss.sgi.com

Seems I can reproduce this by doing a full xfstests run and then
shutting down the VM.  Doesn't seem to happen with the XFS tree
which is still based on 3.12-rc1.


[ ok ] Deactivating swap...done.
[ ok ] Unmounting local filesystems...done.
[ 3387.907240] BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
[ 3387.909554] IP: [<ffffffff81194475>] inode_permission+0x5/0x50
[ 3387.910409] PGD 75a3e067 PUD 18f99067 PMD 0 
[ 3387.910409] Oops: 0000 [#1] SMP 
[ 3387.910409] Modules linked in:
[ 3387.910409] CPU: 2 PID: 10493 Comm: startpar Not tainted 3.13.0-rc1+ #38
[ 3387.910409] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[ 3387.910409] task: ffff880075a0a090 ti: ffff880077322000 task.ti: ffff880077322000
[ 3387.910409] RIP: 0010:[<ffffffff81194475>]  [<ffffffff81194475>] inode_permission+0x5/0x50
[ 3387.910409] RSP: 0018:ffff880077323cc8  EFLAGS: 00010246
[ 3387.910409] RAX: ffff880075a0a090 RBX: ffff880068d29021 RCX: ffff88007d029818
[ 3387.910409] RDX: 0000000000000002 RSI: 0000000000000081 RDI: 0000000000000000
[ 3387.910409] RBP: ffff880077323d78 R08: 0000000000000007 R09: 0000000000000001
[ 3387.910409] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880077323e40
[ 3387.910409] R13: ffff880077323f24 R14: ffff880075a0a090 R15: ffff880077323e40
[ 3387.910409] FS:  00007f8c9142a700(0000) GS:ffff88007fd00000(0000) knlGS:0000000000000000
[ 3387.910409] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 3387.910409] CR2: 0000000000000028 CR3: 000000003b264000 CR4: 00000000000006e0
[ 3387.910409] Stack:
[ 3387.910409]  ffff880077323d78 ffffffff8119493e ffff880077323cf8 ffffffff810dafdd
[ 3387.910409]  ffff880077323e40 ffff880075a0a090 ffff880077323d08 ffff880075a0a090
[ 3387.910409]  ffff880077323d78 0000000000000246 ffffffff8119850c 00000000ffffff9c
[ 3387.910409] Call Trace:
[ 3387.910409]  [<ffffffff8119493e>] ? link_path_walk+0x21e/0x880
[ 3387.910409]  [<ffffffff810dafdd>] ? trace_hardirqs_on_caller+0x10d/0x1d0
[ 3387.910409]  [<ffffffff8119850c>] ? path_openat+0x7c/0x670
[ 3387.910409]  [<ffffffff8119852f>] path_openat+0x9f/0x670
[ 3387.910409]  [<ffffffff81198ece>] do_filp_open+0x3e/0xa0
[ 3387.910409]  [<ffffffff811a670e>] ? __alloc_fd+0xce/0x120
[ 3387.910409]  [<ffffffff81187e5c>] do_sys_open+0x13c/0x230
[ 3387.910409]  [<ffffffff810dafdd>] ? trace_hardirqs_on_caller+0x10d/0x1d0
[ 3387.910409]  [<ffffffff81187f6d>] SyS_open+0x1d/0x20
[ 3387.910409]  [<ffffffff81c567f9>] system_call_fastpath+0x16/0x1b
[ 3387.910409] Code: 75 e8 4c 89 e7 e8 6c 97 ab 00 4c 89 e7 66 83 4b 02 01 e8 3f 9e ab 00 8b 75 e8 eb a9 66 2e 0f 1f 84 00 00 00 00 00 55 40 f6 c6 02 <48> 8b 47 28 48 89 e5 75 07 e8 6d ff ff ff 5d c3 f6 40 50 01 0f 
[ 3387.910409] RIP  [<ffffffff81194475>] inode_permission+0x5/0x50
[ 3387.910409]  RSP <ffff880077323cc8>
[ 3387.910409] CR2: 0000000000000028
[ 3387.962220] ---[ end trace 548499e322d1b19e ]---
[ 3387.964470] BUG: unable to handle kernel Killed NULL pointer dereference at 0000000000000028
[ 3387.967117] IP: [<ffffffff81194475>] inode_permission+0x5/0x50
[ 3387.967740] PGD 7d750067 PUD 7d753067 PMD 0 
[ 3387.967740] Oops: 0000 [#2] SMP 
[ 3387.967740] Modules linked in:
[ 3387.967740] CPU: 1 PID: 1 Comm: init Tainted: G      D 3.13.0-rc1+ #38
[ 3387.967740] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[ 3387.967740] task: ffff88007d4a4010 ti: ffff88007d4a6000 task.ti: ffff88007d4a6000
[ 3387.967740] RIP: 0010:[<ffffffff81194475>]  [<ffffffff81194475>] inode_permission+0x5/0x50
[ 3387.967740] RSP: 0018:ffff88007d4a7c38  EFLAGS: 00010246
[ 3387.967740] RAX: ffff88007d4a4010 RBX: ffff880005544021 RCX: ffff88007d029818
[ 3387.967740] RDX: 0000000000000002 RSI: 0000000000000081 RDI: 0000000000000000
[ 3387.967740] RBP: ffff88007d4a7ce8 R08: 0000000000000002 R09: 0000000000000001
[ 3387.967740] R10: ffff88007d4a4010 R11: 0000000000000000 R12: ffff88007d4a7dc0
[ 3387.967740] R13: 0000000000000041 R14: ffff88007d4a4010 R15: ffff88007d4a7dc0
[ 3387.967740] FS:  00007f72034b87a0(0000) GS:ffff88007fc80000(0000) knlGS:0000000000000000
[ 3387.967740] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3387.967740] CR2: 0000000000000028 CR3: 000000007ba97000 CR4: 00000000000006e0
[ 3387.967740] Stack:
[ 3387.967740]  ffff88007d4a7ce8 ffffffff8119493e ffffffff811a1970 ffff88007d4a7dc0
[ 3387.967740]  ffffffff82225000 ffff88007d4a4010 0000000000000246 ffff88007d4a4010
[ 3387.967740]  ffff88007d4a7ce8 0000000000000246 ffffffff8119594e ffffffff8116333e
[ 3387.967740] Call Trace:
[ 3387.967740]  [<ffffffff8119493e>] ? link_path_walk+0x21e/0x880
[ 3387.967740]  [<ffffffff811a1970>] ? __d_lookup_rcu+0x1f0/0x1f0
[ 3387.967740]  [<ffffffff8119594e>] ? path_lookupat+0x2e/0x740
[ 3387.967740]  [<ffffffff8116333e>] ? might_fault+0x3e/0x90
[ 3387.967740]  [<ffffffff81195976>] path_lookupat+0x56/0x740
[ 3387.967740]  [<ffffffff8116333e>] ? might_fault+0x3e/0x90
[ 3387.967740]  [<ffffffff810db0ad>] ? trace_hardirqs_on+0xd/0x10
[ 3387.967740]  [<ffffffff811942fb>] ? getname_flags+0x2b/0x110
[ 3387.967740]  [<ffffffff8116333e>] ? might_fault+0x3e/0x90
[ 3387.967740]  [<ffffffff8119608e>] filename_lookup.isra.55+0x2e/0x80
[ 3387.967740]  [<ffffffff81198dc8>] user_path_at_empty+0x58/0xa0
[ 3387.967740]  [<ffffffff81c5250e>] ? __do_page_fault+0x3be/0x550
[ 3387.967740]  [<ffffffff8104fe08>] ? __restore_xstate_sig+0x228/0x530
[ 3387.967740]  [<ffffffff81198e1c>] user_path_at+0xc/0x10
[ 3387.967740]  [<ffffffff8118daaa>] vfs_fstatat+0x4a/0xa0
[ 3387.967740]  [<ffffffff8118db36>] vfs_stat+0x16/0x20
[ 3387.967740]  [<ffffffff8118dc55>] SyS_newstat+0x15/0x30
[ 3387.967740]  [<ffffffff81703b84>] ? lockdep_sys_exit_thunk+0x35/0x67
[ 3387.967740]  [<ffffffff81703b0e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 3387.967740]  [<ffffffff81c567f9>] system_call_fastpath+0x16/0x1b
[ 3387.967740] Code: 75 e8 4c 89 e7 e8 6c 97 ab 00 4c 89 e7 66 83 4b 02 01 e8 3f 9e ab 00 8b 75 e8 eb a9 66 2e 0f 1f 84 00 00 00 00 00 55 40 f6 c6 02 <48> 8b 47 28 48 89 e5 75 07 e8 6d ff ff ff 5d c3 f6 40 50 01 0f 
[ 3387.967740] RIP  [<ffffffff81194475>] inode_permission+0x5/0x50
[ 3387.967740]  RSP <ffff88007d4a7c38>
[ 3387.967740] CR2: 0000000000000028
[ 3388.034797] ---[ end trace 548499e322d1b19f ]---
[ 3388.036021] Kernel panic - not syncing: Attempted to kill init!
exitcode=0x00000009
[ 3388.036021] 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
