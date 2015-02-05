Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 010768010
	for <xfs@oss.sgi.com>; Thu,  5 Feb 2015 08:10:17 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6444DAC002
	for <xfs@oss.sgi.com>; Thu,  5 Feb 2015 06:10:15 -0800 (PST)
Received: from smtprelay.restena.lu (smtprelay.restena.lu [158.64.1.62]) by
	cuda.sgi.com with ESMTP id ooYOsRCDBGCXmeaN (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 05 Feb 2015 06:10:09 -0800 (PST)
Date: Thu, 5 Feb 2015 15:10:07 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
Subject: Re: XFS crashing system with general protection fault
Message-ID: <20150205151007.7c954c01@pluto.restena.lu>
In-Reply-To: <20150113081742.6c3a5823@pluto.restena.lu>
References: <20141224111403.54d7226b@neptune.home>
	<20141228115127.GN24183@dastard>
	<20141229084452.615e1900@pluto.restena.lu>
	<20150113081742.6c3a5823@pluto.restena.lu>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hi Dave,

New crash, new trace, this time on 3.18.2.
It looks like this time a NULL dereference happened prior to touched memory poison being detected.

Once again it's during normal system operation (no mount/umount activity)

Thanks,
Bruno


[1900296.667022] BUG: unable to handle kernel NULL pointer dereference at 0000000000000090
[1900296.676891] IP: [<ffffffff81248dd3>] xfs_iflush_int+0xf3/0x300
[1900296.686713] PGD 0 
[1900296.688909] Oops: 0000 [#1] SMP 
[1900296.694730] Modules linked in:
[1900296.698844] CPU: 6 PID: 627 Comm: xfsaild/sda3 Not tainted 3.18.2-x86_64 #2
[1900296.708850] Hardware name: HP ProLiant DL360 G6, BIOS P64 07/02/2013
[1900296.718759] task: ffff880213d64ba0 ti: ffff8800dab98000 task.ti: ffff8800dab98000
[1900296.728890] RIP: 0010:[<ffffffff81248dd3>]  [<ffffffff81248dd3>] xfs_iflush_int+0xf3/0x300
[1900296.740930] RSP: 0018:ffff8800dab9bc98  EFLAGS: 00010246
[1900296.748911] RAX: 0000000000009200 RBX: ffff880109bbfc00 RCX: 0000000000000000
[1900296.758972] RDX: 0000000000000000 RSI: ffff880101bded00 RDI: ffff880109bbfc00
[1900296.770792] RBP: ffff8800dab9bcd8 R08: 0000000000000064 R09: 0000000000000000
[1900296.780863] R10: ffff880101bde264 R11: ffff8802138c9030 R12: 0000000000000000
[1900296.790925] R13: ffff880101bded00 R14: ffff8802138c9030 R15: ffff8800da53d980
[1900296.800991] FS:  0000000000000000(0000) GS:ffff88021fb80000(0000) knlGS:0000000000000000
[1900296.812985] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[1900296.822809] CR2: 0000000000000090 CR3: 0000000001c15000 CR4: 00000000000007e0
[1900296.832867] Stack:
[1900296.835019]  0000000000000100 0000000002db13a8 ffff8800dab9bcd8 ffff880033d45c00
[1900296.846886]  ffff88021347c9d8 00000000000000a0 ffff880033d45ce4 ffff880109bbfc00
[1900296.857004]  ffff8800dab9bd58 ffffffff81249463 ffff8800dab9bd58 ffff880109bbfce4
[1900296.868898] Call Trace:
[1900296.872857]  [<ffffffff81249463>] xfs_iflush_cluster+0x1f3/0x3c0
[1900296.880947]  [<ffffffff8124c423>] xfs_iflush+0x113/0x220
[1900296.888930]  [<ffffffff8125b667>] xfs_inode_item_push+0xe7/0x130
[1900296.897040]  [<ffffffff81261c11>] xfsaild+0x1e1/0x480
[1900296.905014]  [<ffffffff81261a30>] ? xfs_trans_ail_cursor_first+0x90/0x90
[1900296.914972]  [<ffffffff810a0a74>] kthread+0xc4/0xe0
[1900296.922897]  [<ffffffff810a09b0>] ? kthread_create_on_node+0x170/0x170
[1900296.932865]  [<ffffffff817ab1ec>] ret_from_fork+0x7c/0xb0
[1900296.940858]  [<ffffffff810a09b0>] ? kthread_create_on_node+0x170/0x170
[1900296.949063] Code: 66 83 bb 16 01 00 00 ff 0f 84 fa 00 00 00 31 c9 4c 89 e2 4c 89 ee 48 89 df e8 6a 70 fe ff 80 bb 4a 01 00 00 00 0f 85 c5 00 00 00 <41> 8b 84 24 90 00 00 00 4c 89 e2 4c 89 ff 41 c7 84 24 90 00 00 
[1900296.977007] RIP  [<ffffffff81248dd3>] xfs_iflush_int+0xf3/0x300
[1900296.985144]  RSP <ffff8800dab9bc98>
[1900296.991019] CR2: 0000000000000090
[1900297.168094] ---[ end trace 66374290cbfacded ]---
[1900323.928915] ------------[ cut here ]------------
[1900323.934665] WARNING: CPU: 0 PID: 30642 at /data/kernel/linux-git/kernel/sched/core.c:1785 wake_up_process+0x3a/0x40()
[1900323.950510] Modules linked in:
[1900323.956328] CPU: 0 PID: 30642 Comm: collectd Tainted: G      D        3.18.2-x86_64 #2
[1900323.966535] Hardware name: HP ProLiant DL360 G6, BIOS P64 07/02/2013
[1900323.976465]  0000000000000009 ffff88012d68f6a8 ffffffff817a2753 000000000000009f
[1900323.986617]  0000000000000000 ffff88012d68f6e8 ffffffff81088a77 ffff88012d68f6d8
[1900323.998528]  ffff880213d64ba0 ffff880213626548 ffff880213626240 0000000000000016
[1900324.008572] Call Trace:
[1900324.012524]  [<ffffffff817a2753>] dump_stack+0x46/0x58
[1900324.020489]  [<ffffffff81088a77>] warn_slowpath_common+0x77/0xa0
[1900324.028603]  [<ffffffff81088b45>] warn_slowpath_null+0x15/0x20
[1900324.038478]  [<ffffffff810a894a>] wake_up_process+0x3a/0x40
[1900324.046479]  [<ffffffff81261f31>] xfs_ail_push+0x51/0x60
[1900324.054471]  [<ffffffff81261f7d>] xfs_ail_push_all+0x3d/0x50
[1900324.062520]  [<ffffffff812430cd>] xfs_reclaim_inodes_nr+0x1d/0x40
[1900324.072397]  [<ffffffff81250410>] xfs_fs_free_cached_objects+0x10/0x20
[1900324.080635]  [<ffffffff8114f4e1>] super_cache_scan+0x161/0x170
[1900324.090435]  [<ffffffff8110d3d2>] shrink_slab_node+0x112/0x1b0
[1900324.098535]  [<ffffffff8110ddb8>] shrink_slab+0x78/0x110
[1900324.106503]  [<ffffffff811108be>] do_try_to_free_pages+0x30e/0x450
[1900324.114636]  [<ffffffff810a896d>] ? default_wake_function+0xd/0x10
[1900324.124551]  [<ffffffff81110a87>] try_to_free_pages+0x87/0xa0
[1900324.132637]  [<ffffffff81107322>] __alloc_pages_nodemask+0x422/0x940
[1900324.142540]  [<ffffffff81107902>] alloc_kmem_pages+0x12/0x20
[1900324.150590]  [<ffffffff8111aaf3>] kmalloc_order+0x13/0x50
[1900324.158646]  [<ffffffff8113e021>] __kmalloc_track_caller+0xd1/0xe0
[1900324.168498]  [<ffffffff816b5d0c>] __kmalloc_reserve.isra.33+0x2c/0x80
[1900324.176678]  [<ffffffff816b6b13>] __alloc_skb+0x73/0x1b0
[1900324.184663]  [<ffffffff8113c1ef>] ? kmem_cache_free+0xef/0x120
[1900324.194522]  [<ffffffff816e5f39>] netlink_dump+0x219/0x290
[1900324.202525]  [<ffffffff816e61b7>] netlink_recvmsg+0x207/0x380
[1900324.210586]  [<ffffffff816acabe>] sock_recvmsg+0x6e/0x90
[1900324.218575]  [<ffffffff816bb1d2>] ? verify_iovec+0x42/0xd0
[1900324.226628]  [<ffffffff816ad9fd>] ___sys_recvmsg+0x10d/0x2b0
[1900324.234642]  [<ffffffff81166c50>] ? __fget_light+0x20/0x70
[1900324.242663]  [<ffffffff81166cae>] ? __fdget+0xe/0x10
[1900324.250604]  [<ffffffff816ad022>] ? sockfd_lookup_light+0x12/0x70
[1900324.258913]  [<ffffffff816af42d>] __sys_recvmsg+0x3d/0x80
[1900324.266830]  [<ffffffff816af47d>] SyS_recvmsg+0xd/0x20
[1900324.275712]  [<ffffffff817ab296>] system_call_fastpath+0x16/0x1b
[1900324.285568] ---[ end trace 66374290cbfacdee ]---
[1900324.291698] general protection fault: 0000 [#2] SMP 
[1900324.299630] Modules linked in:
[1900324.303688] CPU: 0 PID: 30642 Comm: collectd Tainted: G      D W      3.18.2-x86_64 #2
[1900324.315624] Hardware name: HP ProLiant DL360 G6, BIOS P64 07/02/2013
[1900324.325553] task: ffff8802146f4410 ti: ffff88012d68c000 task.ti: ffff88012d68c000
[1900324.335697] RIP: 0010:[<ffffffff810a86b9>]  [<ffffffff810a86b9>] try_to_wake_up+0x59/0x2b0
[1900324.347702] RSP: 0018:ffff88012d68f6b8  EFLAGS: 00010002
[1900324.355687] RAX: 6b6b6b6b6b6b6b6b RBX: ffff880213d64ba0 RCX: 0000000000010980
[1900324.365755] RDX: 0000000000010980 RSI: 0000000000000003 RDI: ffff880213d651b2
[1900324.377582] RBP: ffff88012d68f6f8 R08: 0000000000000001 R09: 0000000000000000
[1900324.387646] R10: 00000000000053f3 R11: 000000000002428e R12: ffff880213d651b2
[1900324.397710] R13: 0000000000000246 R14: 0000000000000000 R15: 0000000000010980
[1900324.407785] FS:  00007fc56de83700(0000) GS:ffff88021fa00000(0000) knlGS:0000000000000000
[1900324.419765] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[1900324.429582] CR2: ffffffffff600400 CR3: 00000001cdf91000 CR4: 00000000000007f0
[1900324.439669] Stack:
[1900324.441797]  0000000000010980 ffff880200000003 ffff880213626548 ffff880213d64ba0
[1900324.453678]  ffff880213626548 ffff880213626240 0000000000000016 00000000000000b5
[1900324.463803]  ffff88012d68f718 ffffffff810a8932 ffff88012d68f768 ffff8800022045f0
[1900324.475675] Call Trace:
[1900324.479623]  [<ffffffff810a8932>] wake_up_process+0x22/0x40
[1900324.487671]  [<ffffffff81261f31>] xfs_ail_push+0x51/0x60
[1900324.495654]  [<ffffffff81261f7d>] xfs_ail_push_all+0x3d/0x50
[1900324.503701]  [<ffffffff812430cd>] xfs_reclaim_inodes_nr+0x1d/0x40
[1900324.511820]  [<ffffffff81250410>] xfs_fs_free_cached_objects+0x10/0x20
[1900324.521782]  [<ffffffff8114f4e1>] super_cache_scan+0x161/0x170
[1900324.529862]  [<ffffffff8110d3d2>] shrink_slab_node+0x112/0x1b0
[1900324.539701]  [<ffffffff8110ddb8>] shrink_slab+0x78/0x110
[1900324.547684]  [<ffffffff811108be>] do_try_to_free_pages+0x30e/0x450
[1900324.555862]  [<ffffffff810a896d>] ? default_wake_function+0xd/0x10
[1900324.565725]  [<ffffffff81110a87>] try_to_free_pages+0x87/0xa0
[1900324.573795]  [<ffffffff81107322>] __alloc_pages_nodemask+0x422/0x940
[1900324.583737]  [<ffffffff81107902>] alloc_kmem_pages+0x12/0x20
[1900324.591778]  [<ffffffff8111aaf3>] kmalloc_order+0x13/0x50
[1900324.599784]  [<ffffffff8113e021>] __kmalloc_track_caller+0xd1/0xe0
[1900324.609676]  [<ffffffff816b5d0c>] __kmalloc_reserve.isra.33+0x2c/0x80
[1900324.617895]  [<ffffffff816b6b13>] __alloc_skb+0x73/0x1b0
[1900324.625853]  [<ffffffff8113c1ef>] ? kmem_cache_free+0xef/0x120
[1900324.635701]  [<ffffffff816e5f39>] netlink_dump+0x219/0x290
[1900324.643707]  [<ffffffff816e61b7>] netlink_recvmsg+0x207/0x380
[1900324.651798]  [<ffffffff816acabe>] sock_recvmsg+0x6e/0x90
[1900324.659764]  [<ffffffff816bb1d2>] ? verify_iovec+0x42/0xd0
[1900324.667797]  [<ffffffff816ad9fd>] ___sys_recvmsg+0x10d/0x2b0
[1900324.675828]  [<ffffffff81166c50>] ? __fget_light+0x20/0x70
[1900324.683882]  [<ffffffff81166cae>] ? __fdget+0xe/0x10
[1900324.691780]  [<ffffffff816ad022>] ? sockfd_lookup_light+0x12/0x70
[1900324.699923]  [<ffffffff816af42d>] __sys_recvmsg+0x3d/0x80
[1900324.707911]  [<ffffffff816af47d>] SyS_recvmsg+0xd/0x20
[1900324.715901]  [<ffffffff817ab296>] system_call_fastpath+0x16/0x1b
[1900324.725769] Code: c8 49 89 c5 48 8b 03 85 c6 0f 84 88 01 00 00 8b 4b 4c 49 c7 c7 80 09 01 00 85 c9 74 77 4c 89 fa 48 8b 43 08 48 89 d1 48 89 55 c0 <8b> 40 18 48 03 0c c5 40 df c8 81 48 89 cf 48 89 4d c8 e8 10 27 
[1900324.751937] RIP  [<ffffffff810a86b9>] try_to_wake_up+0x59/0x2b0
[1900324.761773]  RSP <ffff88012d68f6b8>
[1900324.765946] ---[ end trace 66374290cbfacdef ]---
[1900376.463556] ------------[ cut here ]------------
[1900376.469656] WARNING: CPU: 2 PID: 80 at /data/kernel/linux-git/kernel/sched/core.c:1785 wake_up_process+0x3a/0x40()
[1900376.485532] Modules linked in:
[1900376.489582] CPU: 2 PID: 80 Comm: kswapd0 Tainted: G      D W      3.18.2-x86_64 #2
[1900376.489583] Hardware name: HP ProLiant DL360 G6, BIOS P64 07/02/2013
[1900376.489585]  0000000000000009 ffff8800da0b7b98 ffffffff817a2753 0000000000005454
[1900376.489587]  0000000000000000 ffff8800da0b7bd8 ffffffff81088a77 ffff8800da0b7bc8
[1900376.489591]  ffff880213d64ba0 ffff880213626548 ffff880213626240 0000000000000016
[1900376.489591] Call Trace:
[1900376.489596]  [<ffffffff817a2753>] dump_stack+0x46/0x58
[1900376.489599]  [<ffffffff81088a77>] warn_slowpath_common+0x77/0xa0
[1900376.489601]  [<ffffffff81088b45>] warn_slowpath_null+0x15/0x20
[1900376.489604]  [<ffffffff810a894a>] wake_up_process+0x3a/0x40
[1900376.489608]  [<ffffffff81261f31>] xfs_ail_push+0x51/0x60
[1900376.489610]  [<ffffffff81261f7d>] xfs_ail_push_all+0x3d/0x50
[1900376.489613]  [<ffffffff812430cd>] xfs_reclaim_inodes_nr+0x1d/0x40
[1900376.489616]  [<ffffffff81250410>] xfs_fs_free_cached_objects+0x10/0x20
[1900376.489620]  [<ffffffff8114f4e1>] super_cache_scan+0x161/0x170
[1900376.489624]  [<ffffffff8110d3d2>] shrink_slab_node+0x112/0x1b0
[1900376.489627]  [<ffffffff8110ddb8>] shrink_slab+0x78/0x110
[1900376.489629]  [<ffffffff81110514>] kswapd_shrink_zone+0x104/0x1a0
[1900376.489633]  [<ffffffff81110fca>] kswapd+0x40a/0x750
[1900376.489635]  [<ffffffff81110bc0>] ? mem_cgroup_shrink_node_zone+0xa0/0xa0
[1900376.489639]  [<ffffffff810a0a74>] kthread+0xc4/0xe0
[1900376.489641]  [<ffffffff810a09b0>] ? kthread_create_on_node+0x170/0x170
[1900376.489643]  [<ffffffff817ab1ec>] ret_from_fork+0x7c/0xb0
[1900376.489645]  [<ffffffff810a09b0>] ? kthread_create_on_node+0x170/0x170
[1900376.489647] ---[ end trace 66374290cbfacdf0 ]---
[1900390.261491] =============================================================================
[1900390.272989] BUG task_struct (Tainted: G      D W     ): Poison overwritten
[1900390.283021] -----------------------------------------------------------------------------
[1900390.283021] 
[1900390.297056] INFO: 0xffff880213d651b3-0xffff880213d651b3. First byte 0x6d instead of 0x6b
[1900390.309044] INFO: Slab 0xffffea00084f5800 objects=16 used=16 fp=0x          (null) flags=0x8000000000004080
[1900390.323087] INFO: Object 0xffff880213d64ba0 @offset=19360 fp=0xffff880213d61e40
[1900390.323087] 
[1900390.336988] Bytes b4 ffff880213d64b90: 60 2d d6 13 02 88 ff ff 5a 5a 5a 5a 5a 5a 5a 5a  `-......ZZZZZZZZ
[1900390.350988] Object ffff880213d64ba0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900390.364943] Object ffff880213d64bb0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900390.377153] Object ffff880213d64bc0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900390.391099] Object ffff880213d64bd0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900390.405066] Object ffff880213d64be0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900390.419044] Object ffff880213d64bf0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900390.432991] Object ffff880213d64c00: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900390.445210] Object ffff880213d64c10: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900390.459163] Object ffff880213d64c20: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900390.473123] Object ffff880213d64c30: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900390.487075] Object ffff880213d64c40: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900390.501042] Object ffff880213d64c50: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900390.513244] Object ffff880213d64c60: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900390.527206] Object ffff880213d64c70: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900390.541176] Object ffff880213d64c80: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900390.555144] Object ffff880213d64c90: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900390.569103] Object ffff880213d64ca0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900390.583052] Object ffff880213d64cb0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900390.595260] Object ffff880213d64cc0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900390.609255] Object ffff880213d64cd0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900390.623179] Object ffff880213d64ce0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900390.637146] Object ffff880213d64cf0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900390.651113] Object ffff880213d64d00: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900390.663312] Object ffff880213d64d10: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900390.677284] Object ffff880213d64d20: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900390.691232] Object ffff880213d64d30: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900390.705203] Object ffff880213d64d40: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900390.719156] Object ffff880213d64d50: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900390.731391] Object ffff880213d64d60: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900390.745324] Object ffff880213d64d70: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900390.759288] Object ffff880213d64d80: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900390.773262] Object ffff880213d64d90: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900390.787213] Object ffff880213d64da0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900390.801170] Object ffff880213d64db0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900390.813385] Object ffff880213d64dc0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900390.827346] Object ffff880213d64dd0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900390.841301] Object ffff880213d64de0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900390.855267] Object ffff880213d64df0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900390.869232] Object ffff880213d64e00: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900390.881428] Object ffff880213d64e10: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900390.895400] Object ffff880213d64e20: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900390.909360] Object ffff880213d64e30: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900390.923345] Object ffff880213d64e40: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900390.937309] Object ffff880213d64e50: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900390.950489] Object ffff880213d64e60: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900390.964445] Object ffff880213d64e70: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900390.978414] Object ffff880213d64e80: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900390.992362] Object ffff880213d64e90: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.006345] Object ffff880213d64ea0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.020279] Object ffff880213d64eb0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.032508] Object ffff880213d64ec0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.046461] Object ffff880213d64ed0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.060418] Object ffff880213d64ee0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.074388] Object ffff880213d64ef0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.088338] Object ffff880213d64f00: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.100547] Object ffff880213d64f10: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.114503] Object ffff880213d64f20: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.128485] Object ffff880213d64f30: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.142435] Object ffff880213d64f40: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.156394] Object ffff880213d64f50: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.168595] Object ffff880213d64f60: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.182573] Object ffff880213d64f70: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.196528] Object ffff880213d64f80: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.210479] Object ffff880213d64f90: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.224449] Object ffff880213d64fa0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.238443] Object ffff880213d64fb0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.250607] Object ffff880213d64fc0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.264572] Object ffff880213d64fd0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.278542] Object ffff880213d64fe0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.292539] Object ffff880213d64ff0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.306447] Object ffff880213d65000: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.318685] Object ffff880213d65010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.332656] Object ffff880213d65020: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.346616] Object ffff880213d65030: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.360545] Object ffff880213d65040: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.374511] Object ffff880213d65050: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.386800] Object ffff880213d65060: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.400664] Object ffff880213d65070: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.414654] Object ffff880213d65080: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.428603] Object ffff880213d65090: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.442558] Object ffff880213d650a0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.456527] Object ffff880213d650b0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.468720] Object ffff880213d650c0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.482704] Object ffff880213d650d0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.496649] Object ffff880213d650e0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.510629] Object ffff880213d650f0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.524581] Object ffff880213d65100: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.536786] Object ffff880213d65110: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.550750] Object ffff880213d65120: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.564698] Object ffff880213d65130: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.578678] Object ffff880213d65140: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.592624] Object ffff880213d65150: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.604837] Object ffff880213d65160: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.618795] Object ffff880213d65170: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.632754] Object ffff880213d65180: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.646733] Object ffff880213d65190: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.660674] Object ffff880213d651a0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.674636] Object ffff880213d651b0: 6b 6b 6b 6d 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkmkkkkkkkkkkkk
[1900391.686848] Object ffff880213d651c0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.700807] Object ffff880213d651d0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.714769] Object ffff880213d651e0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.728730] Object ffff880213d651f0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.742705] Object ffff880213d65200: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.754900] Object ffff880213d65210: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.768859] Object ffff880213d65220: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.782824] Object ffff880213d65230: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.796782] Object ffff880213d65240: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.810754] Object ffff880213d65250: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.822948] Object ffff880213d65260: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.836917] Object ffff880213d65270: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.850870] Object ffff880213d65280: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.864832] Object ffff880213d65290: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.878800] Object ffff880213d652a0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.892752] Object ffff880213d652b0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.905128] Object ffff880213d652c0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.918925] Object ffff880213d652d0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.932889] Object ffff880213d652e0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.946849] Object ffff880213d652f0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.960806] Object ffff880213d65300: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1900391.973020] Object ffff880213d65310: 6b 6b 6b 6b 6b 6b 6b a5                          kkkkkkk.
[1900391.986850] Redzone ffff880213d65318: bb bb bb bb bb bb bb bb                          ........
[1900391.998959] Padding ffff880213d65328: 5a 5a 5a 5a 5a 5a 5a 5a                          ZZZZZZZZ
[1900392.011054] CPU: 1 PID: 340 Comm: httpd2-prefork Tainted: G    B D W      3.18.2-x86_64 #2
[1900392.024818] Hardware name: HP ProLiant DL360 G6, BIOS P64 07/02/2013
[1900392.033005]  ffff880213d64ba0 ffff88000ba37bf0 ffffffff817a2753 0000000000000000
[1900392.044871]  ffff88021685fc00 ffff88000ba37c30 ffffffff8113a248 0000000000000008
[1900392.055002]  ffff880200000001 ffff880213d651b4 ffff88021685fc00 000000000000006b
[1900392.066845] Call Trace:
[1900392.069074]  [<ffffffff817a2753>] dump_stack+0x46/0x58
[1900392.077023]  [<ffffffff8113a248>] print_trailer+0x148/0x200
[1900392.085059]  [<ffffffff8113a43f>] check_bytes_and_report+0xcf/0x110
[1900392.094981]  [<ffffffff8113afb7>] check_object+0x1d7/0x250
[1900392.103001]  [<ffffffff810866b5>] ? copy_process.part.52+0xc5/0x1600
[1900392.112932]  [<ffffffff817a0b92>] alloc_debug_processing+0x71/0x113
[1900392.121074]  [<ffffffff817a12b8>] __slab_alloc.constprop.69+0x46f/0x4c9
[1900392.131065]  [<ffffffff810866b5>] ? copy_process.part.52+0xc5/0x1600
[1900392.140982]  [<ffffffff8114dbd3>] ? get_empty_filp+0x53/0x170
[1900392.149052]  [<ffffffff8113baf8>] kmem_cache_alloc+0x78/0xa0
[1900392.157106]  [<ffffffff810866b5>] copy_process.part.52+0xc5/0x1600
[1900392.167003]  [<ffffffff8113bb17>] ? kmem_cache_alloc+0x97/0xa0
[1900392.175087]  [<ffffffff811671dd>] ? __alloc_fd+0x7d/0x120
[1900392.183099]  [<ffffffff81087d9b>] do_fork+0xcb/0x2b0
[1900392.191026]  [<ffffffff811672ab>] ? get_unused_fd_flags+0x2b/0x30
[1900392.199143]  [<ffffffff81154465>] ? __do_pipe_flags+0x65/0xb0
[1900392.209001]  [<ffffffff811672cf>] ? __fd_install+0x1f/0x60
[1900392.216983]  [<ffffffff81088001>] SyS_clone+0x11/0x20
[1900392.223163]  [<ffffffff817ab579>] stub_clone+0x69/0x90
[1900392.231126]  [<ffffffff817ab296>] ? system_call_fastpath+0x16/0x1b
[1900392.241021] FIX task_struct: Restoring 0xffff880213d651b3-0xffff880213d651b3=0x6b
[1900392.241021] 
[1900392.254988] FIX task_struct: Marking all objects used
[1900463.350910] INFO: rcu_sched detected stalls on CPUs/tasks:[1900463.350938] ------------[ cut here ]------------
[1900463.350946] WARNING: CPU: 6 PID: 0 at /data/kernel/linux-git/net/sched/sch_generic.c:303 dev_watchdog+0x23f/0x250()
[1900463.350946] NETDEV WATCHDOG: eth0 (bnx2): transmit queue 4 timed out
[1900463.350947] Modules linked in:
[1900463.350950] CPU: 6 PID: 0 Comm: swapper/6 Tainted: G    B D W      3.18.2-x86_64 #2
[1900463.350951] Hardware name: HP ProLiant DL360 G6, BIOS P64 07/02/2013
[1900463.350951]  0000000000000009 ffff88021fb83dc8 ffffffff817a2753 0000000000003232
[1900463.350953]  ffff88021fb83e18 ffff88021fb83e08 ffffffff81088a77 ffff88021fb95700
[1900463.350954]  0000000000000004 ffff8800df224000 0000000000000008 0000000000000006
[1900463.350956] Call Trace:
[1900463.350957]  <IRQ>  [<ffffffff817a2753>] dump_stack+0x46/0x58
[1900463.350960]  [<ffffffff81088a77>] warn_slowpath_common+0x77/0xa0
[1900463.350963]  [<ffffffff81088ae1>] warn_slowpath_fmt+0x41/0x50
[1900463.350964]  [<ffffffff812ed8b0>] ? fbcon_add_cursor_timer+0xf0/0xf0
[1900463.350968]  [<ffffffff816e374f>] dev_watchdog+0x23f/0x250
[1900463.350970]  [<ffffffff816e3510>] ? dev_graft_qdisc+0x80/0x80
[1900463.350971]  [<ffffffff810c98e8>] call_timer_fn.isra.36+0x18/0x80
[1900463.350974]  [<ffffffff810c9aea>] run_timer_softirq+0x19a/0x230
[1900463.350976]  [<ffffffff8108b71b>] __do_softirq+0xdb/0x1f0
[1900463.350978]  [<ffffffff8108ba3d>] irq_exit+0x9d/0xb0
[1900463.350980]  [<ffffffff8102e245>] smp_apic_timer_interrupt+0x45/0x60
[1900463.350982]  [<ffffffff817ac12a>] apic_timer_interrupt+0x6a/0x70
[1900463.350985]  <EOI>  [<ffffffff8168e5b5>] ? cpuidle_enter_state+0x55/0xc0
[1900463.350987]  [<ffffffff8168e5a7>] ? cpuidle_enter_state+0x47/0xc0
[1900463.350988]  [<ffffffff8168e6d2>] cpuidle_enter+0x12/0x20
[1900463.350990]  [<ffffffff810b8878>] cpu_startup_entry+0x258/0x2e0
[1900463.350993]  [<ffffffff8102ccf3>] start_secondary+0x183/0x190
[1900463.350995] ---[ end trace 66374290cbfacdf1 ]---
[1900463.350998] bnx2 0000:02:00.0 eth0: <--- start FTQ dump --->
[1900463.351001] bnx2 0000:02:00.0 eth0: RV2P_PFTQ_CTL 00010000
[1900463.351003] bnx2 0000:02:00.0 eth0: RV2P_TFTQ_CTL 00020000
[1900463.351005] bnx2 0000:02:00.0 eth0: RV2P_MFTQ_CTL 00004000
[1900463.351007] bnx2 0000:02:00.0 eth0: TBDR_FTQ_CTL 00004000
[1900463.351009] bnx2 0000:02:00.0 eth0: TDMA_FTQ_CTL 00010002
[1900463.351011] bnx2 0000:02:00.0 eth0: TXP_FTQ_CTL 00010000
[1900463.351013] bnx2 0000:02:00.0 eth0: TXP_FTQ_CTL 00010000
[1900463.351015] bnx2 0000:02:00.0 eth0: TPAT_FTQ_CTL 00010000
[1900463.351017] bnx2 0000:02:00.0 eth0: RXP_CFTQ_CTL 00008000
[1900463.351019] bnx2 0000:02:00.0 eth0: RXP_FTQ_CTL 00100000
[1900463.351021] bnx2 0000:02:00.0 eth0: COM_COMXQ_FTQ_CTL 00010000
[1900463.351023] bnx2 0000:02:00.0 eth0: COM_COMTQ_FTQ_CTL 00020000
[1900463.351025] bnx2 0000:02:00.0 eth0: COM_COMQ_FTQ_CTL 00010000
[1900463.351027] bnx2 0000:02:00.0 eth0: CP_CPQ_FTQ_CTL 00004000
[1900463.351028] bnx2 0000:02:00.0 eth0: CPU states:
[1900463.351035] bnx2 0000:02:00.0 eth0: 045000 mode b84c state 80001000 evt_mask 500 pc 8001294 pc 800128c instr 8e260000
[1900463.351042] bnx2 0000:02:00.0 eth0: 085000 mode b84c state 80005000 evt_mask 500 pc 8000a5c pc 8000a5c instr 38420001
[1900463.351049] bnx2 0000:02:00.0 eth0: 0c5000 mode b84c state 80001000 evt_mask 500 pc 8004c14 pc 8004c20 instr 10e00088
[1900463.351056] bnx2 0000:02:00.0 eth0: 105000 mode b8cc state 80000000 evt_mask 500 pc 8000aa0 pc 8000b2c instr 1040ffd9
[1900463.351063] bnx2 0000:02:00.0 eth0: 145000 mode b880 state 80000000 evt_mask 500 pc 800d19c pc 800aeb0 instr 3e00008
[1900463.351070] bnx2 0000:02:00.0 eth0: 185000 mode b8cc state 80000000 evt_mask 500 pc 8000c58 pc 8000c6c instr 8021
[1900463.351071] bnx2 0000:02:00.0 eth0: <--- end FTQ dump --->
[1900463.351072] bnx2 0000:02:00.0 eth0: <--- start TBDC dump --->
[1900463.351074] bnx2 0000:02:00.0 eth0: TBDC free cnt: 32
[1900463.351075] bnx2 0000:02:00.0 eth0: LINE     CID  BIDX   CMD  VALIDS
[1900463.351080] bnx2 0000:02:00.0 eth0: 00    000800  8728   00    [0]
[1900463.351085] bnx2 0000:02:00.0 eth0: 01    001100  4aa8   00    [0]
[1900463.351090] bnx2 0000:02:00.0 eth0: 02    001200  b950   00    [0]
[1900463.351094] bnx2 0000:02:00.0 eth0: 03    000800  2d50   00    [0]
[1900463.351099] bnx2 0000:02:00.0 eth0: 04    000800  e338   00    [0]
[1900463.351104] bnx2 0000:02:00.0 eth0: 05    1ffa80  ffb8   f7    [0]
[1900463.351108] bnx2 0000:02:00.0 eth0: 06    0ddf80  53c8   fe    [0]
[1900463.351113] bnx2 0000:02:00.0 eth0: 07    1ee780  ffe8   7f    [0]
[1900463.351118] bnx2 0000:02:00.0 eth0: 08    1f7b00  9f78   fd    [0]
[1900463.351122] bnx2 0000:02:00.0 eth0: 09    1ffe80  7978   fd    [0]
[1900463.351127] bnx2 0000:02:00.0 eth0: 0a    1ffa80  dff8   fa    [0]
[1900463.351131] bnx2 0000:02:00.0 eth0: 0b    0cfa00  fff8   ef    [0]
[1900463.351136] bnx2 0000:02:00.0 eth0: 0c    17e080  f7d0   fb    [0]
[1900463.351140] bnx2 0000:02:00.0 eth0: 0d    0e9e00  fe98   ff    [0]
[1900463.351145] bnx2 0000:02:00.0 eth0: 0e    1dff80  d7f0   dd    [0]
[1900463.351149] bnx2 0000:02:00.0 eth0: 0f    1fe580  ffb0   7f    [0]
[1900463.351154] bnx2 0000:02:00.0 eth0: 10    0fef80  f718   f5    [0]
[1900463.351159] bnx2 0000:02:00.0 eth0: 11    1ffa80  adf0   ff    [0]
[1900463.351163] bnx2 0000:02:00.0 eth0: 12    177780  fff8   ff    [0]
[1900463.351168] bnx2 0000:02:00.0 eth0: 13    1e7080  eeb8   fd    [0]
[1900463.351173] bnx2 0000:02:00.0 eth0: 14    1bf780  7bb0   7f    [0]
[1900463.351177] bnx2 0000:02:00.0 eth0: 15    1fbf80  bd38   fe    [0]
[1900463.351182] bnx2 0000:02:00.0 eth0: 16    0fec80  f568   ff    [0]
[1900463.351186] bnx2 0000:02:00.0 eth0: 17    0fff80  bf78   be    [0]
[1900463.351191] bnx2 0000:02:00.0 eth0: 18    1f7e80  dbf0   bc    [0]
[1900463.351196] bnx2 0000:02:00.0 eth0: 19    1fa580  7458   fd    [0]
[1900463.351200] bnx2 0000:02:00.0 eth0: 1a    1be780  fce8   cd    [0]
[1900463.351205] bnx2 0000:02:00.0 eth0: 1b    17cf80  be58   7d    [0]
[1900463.351209] bnx2 0000:02:00.0 eth0: 1c    177b00  6ff8   ff    [0]
[1900463.351214] bnx2 0000:02:00.0 eth0: 1d    1ff980  ffd8   fc    [0]
[1900463.351218] bnx2 0000:02:00.0 eth0: 1e    077d80  bb38   fe    [0]
[1900463.351223] bnx2 0000:02:00.0 eth0: 1f    1b7f80  9fb8   ff    [0]
[1900463.351224] bnx2 0000:02:00.0 eth0: <--- end TBDC dump --->
[1900463.351227] bnx2 0000:02:00.0 eth0: DEBUG: intr_sem[0] PCI_CMD[00100446]
[1900463.351230] bnx2 0000:02:00.0 eth0: DEBUG: PCI_PM[19002008] PCI_MISC_CFG[92000088]
[1900463.351233] bnx2 0000:02:00.0 eth0: DEBUG: EMAC_TX_STATUS[00000008] EMAC_RX_STATUS[00000000]
[1900463.351234] bnx2 0000:02:00.0 eth0: DEBUG: RPM_MGMT_PKT_CTRL[40000088]
[1900463.351236] bnx2 0000:02:00.0 eth0: DEBUG: HC_STATS_INTERRUPT_STATUS[01ee0011]
[1900463.351238] bnx2 0000:02:00.0 eth0: DEBUG: PBA[00000000]
[1900463.351239] bnx2 0000:02:00.0 eth0: <--- start MCP states dump --->
[1900463.351242] bnx2 0000:02:00.0 eth0: DEBUG: MCP_STATE_P0[0003610e] MCP_STATE_P1[0003600e]
[1900463.351246] bnx2 0000:02:00.0 eth0: DEBUG: MCP mode[0000b880] state[80000000] evt_mask[00000500]
[1900463.351250] bnx2 0000:02:00.0 eth0: DEBUG: pc[0800ad88] pc[08003d6c] instr[00021382]
[1900463.351251] bnx2 0000:02:00.0 eth0: DEBUG: shmem states:
[1900463.351255] bnx2 0000:02:00.0 eth0: DEBUG: drv_mb[01030003] fw_mb[00000003] link_status[0000006e]
[1900463.351257]  drv_pulse_mb[00007a69]
[1900463.351260] bnx2 0000:02:00.0 eth0: DEBUG: dev_info_signature[44564903] reset_type[01005254]
[1900463.351261]  condition[0003610e]
[1900463.351266] bnx2 0000:02:00.0 eth0: DEBUG: 000001c0: 01005254 42530083 0003610e 00000000
[1900463.351271] bnx2 0000:02:00.0 eth0: DEBUG: 000003cc: 44444444 44444444 44444444 00000a3c
[1900463.351276] bnx2 0000:02:00.0 eth0: DEBUG: 000003dc: 0ffeffff 0000ffff ffffffff ffffffff
[1900463.351281] bnx2 0000:02:00.0 eth0: DEBUG: 000003ec: 00000000 00000000 00000000 00000002
[1900463.351283] bnx2 0000:02:00.0 eth0: DEBUG: 0x3fc[0000ffff]
[1900463.351284] bnx2 0000:02:00.0 eth0: <--- end MCP states dump --->

[1900464.379743]  { 2} (detected by 5, t=8682 jiffies, g=55614734, c=55614733, q=43486)
[1900464.379747] Task dump for CPU 2:
[1900464.379748] kswapd0         R  running task        0    80      2 0x00000008
[1900464.379751]  ffff8800da0b7d28 ffffffff8110d3d2 ffff880212c8b8a8 0000000000000000
[1900464.379752]  0000000000000000 00000000000772da ffff8800da0b7d68 ffff8800da0b7d88
[1900464.379754]  0000000000000000 0000000000000020 0000000000183cd5 ffff880213626548
[1900464.379757] Call Trace:
[1900464.379766]  [<ffffffff8110d3d2>] ? shrink_slab_node+0x112/0x1b0
[1900464.379768]  [<ffffffff8110ddb8>] shrink_slab+0x78/0x110
[1900464.379770]  [<ffffffff81110514>] kswapd_shrink_zone+0x104/0x1a0
[1900464.379772]  [<ffffffff81110fca>] kswapd+0x40a/0x750
[1900464.379773]  [<ffffffff81110bc0>] ? mem_cgroup_shrink_node_zone+0xa0/0xa0
[1900464.379777]  [<ffffffff810a0a74>] kthread+0xc4/0xe0
[1900464.379779]  [<ffffffff810a09b0>] ? kthread_create_on_node+0x170/0x170
[1900464.379781]  [<ffffffff817ab1ec>] ret_from_fork+0x7c/0xb0
[1900464.379783]  [<ffffffff810a09b0>] ? kthread_create_on_node+0x170/0x170

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
