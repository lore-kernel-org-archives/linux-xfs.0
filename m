Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 17 Jul 2008 10:46:03 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6HHja2L007064
	for <xfs@oss.sgi.com>; Thu, 17 Jul 2008 10:45:36 -0700
Received: from qw-out-1920.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 866F618EFFF9
	for <xfs@oss.sgi.com>; Thu, 17 Jul 2008 10:46:43 -0700 (PDT)
Received: from qw-out-1920.google.com (qw-out-1920.google.com [74.125.92.145]) by cuda.sgi.com with ESMTP id UR3y4aBZEO7jPE3H for <xfs@oss.sgi.com>; Thu, 17 Jul 2008 10:46:43 -0700 (PDT)
Received: by qw-out-1920.google.com with SMTP id 5so16397qwc.32
        for <xfs@oss.sgi.com>; Thu, 17 Jul 2008 10:46:43 -0700 (PDT)
Message-ID: <19f34abd0807171046j425bebc6m8d8eb80a641e0e5b@mail.gmail.com>
Date: Thu, 17 Jul 2008 19:46:42 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: latest -git: kernel BUG at fs/xfs/support/debug.c:54!
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Tim Shimmin <xfs-masters@oss.sgi.com>, xfs@oss.sgi.com
Cc: linux-kernel@vger.kernel.org, Johannes Weiner <hannes@saeurebad.de>

Hi,

I got this with an intentionally corrupted filesystem:

Filesystem "loop1": Disabling barriers, not supported by the underlying device
XFS mounting filesystem loop1
Ending clean XFS mount for filesystem: loop1
Device loop1 - bad inode magic/vsn daddr 9680 #30 (magic=4946)
------------[ cut here ]------------
kernel BUG at fs/xfs/support/debug.c:54!
invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Pid: 12849, comm: grep Not tainted (2.6.26-03414-g33af79d #43)
EIP: 0060:[<c0386d89>] EFLAGS: 00210246 CPU: 1
EIP is at cmn_err+0x99/0xa0
EAX: ed75e000 EBX: c089047c ECX: ed75e000 EDX: 00000000
ESI: 00000000 EDI: 00200286 EBP: ed75fbbc ESP: ed75fba4
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process grep (pid: 12849, ti=ed75e000 task=f1ee9fe0 task.ti=ed75e000)
Stack: c0855099 c0846a0d c0d0e8c0 00004946 df92a8f0 0000001e ed75fc2c c03540d4
       00000000 c089047c ed75fbfc 000025d0 00000000 0000001e 00004946 ed75fc54
       00000000 df92a8f0 df92abd8 000025d0 00000000 00000000 706f6f6c 00000031
Call Trace:
 [<c03540d4>] ? xfs_imap_to_bp+0x164/0x250
 [<c015ad76>] ? trace_hardirqs_on_caller+0x116/0x170
 [<c0354250>] ? xfs_itobp+0x90/0x180
 [<c0356e51>] ? xfs_iread+0xa1/0x280
 [<c034f216>] ? xfs_iget_core+0x1c6/0x6e0
 [<c034f82a>] ? xfs_iget+0xfa/0x170
 [<c0377546>] ? xfs_lookup+0xb6/0xc0
 [<c0382fba>] ? xfs_vn_lookup+0x4a/0x90
 [<c01ac110>] ? do_lookup+0x160/0x1b0
 [<c01adc38>] ? __link_path_walk+0x208/0xdc0
 [<c014f916>] ? up_read+0x16/0x30
 [<c034eabe>] ? xfs_iunlock+0xee/0x110
 [<c0382bdf>] ? xfs_vn_follow_link+0x3f/0x80
 [<c01ae327>] ? __link_path_walk+0x8f7/0xdc0
 [<c015906b>] ? trace_hardirqs_off+0xb/0x10
 [<c01ae844>] ? path_walk+0x54/0xb0
 [<c01aea45>] ? do_path_lookup+0x85/0x230
 [<c01af7a8>] ? __user_walk_fd+0x38/0x50
 [<c01a7fb1>] ? vfs_stat_fd+0x21/0x50
 [<c01590cd>] ? put_lock_stats+0xd/0x30
 [<c01bc81d>] ? mntput_no_expire+0x1d/0x110
 [<c01a8081>] ? vfs_stat+0x11/0x20
 [<c01a80a4>] ? sys_stat64+0x14/0x30
 [<c01a5a8f>] ? fput+0x1f/0x30
 [<c044a0f8>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c015ad76>] ? trace_hardirqs_on_caller+0x116/0x170
 [<c044a0f8>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c010407f>] ? sysenter_past_esp+0x78/0xc5
 =======================
Code: 04 e8 00 eb 3d 00 89 fa b8 40 4a 92 c0 e8 70 d0 3d 00 85 f6 74
15 83 c4 0c 5b 5e 5f 5d c3 8d 74 26 00 c6 81 c0 e8 d0 c0 00 eb bc <0f>
0b eb fe 90 90 90 55 b9 04 00 00 00 89 e5 57 89 c7 31 c0 f3
EIP: [<c0386d89>] cmn_err+0x99/0xa0 SS:ESP 0068:ed75fba4
Kernel panic - not syncing: Fatal exception


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
