Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C9C387CA0
	for <xfs@oss.sgi.com>; Mon, 18 Jul 2016 13:47:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 987098F8039
	for <xfs@oss.sgi.com>; Mon, 18 Jul 2016 11:47:49 -0700 (PDT)
Received: from mail-wm0-f44.google.com (mail-wm0-f44.google.com
	[74.125.82.44]) by cuda.sgi.com with ESMTP id A34ADFC3QSYGKce9
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 18 Jul 2016 11:01:12 -0700 (PDT)
Received: by mail-wm0-f44.google.com with SMTP id i5so128030235wmg.0
	for <xfs@oss.sgi.com>; Mon, 18 Jul 2016 11:01:12 -0700 (PDT)
Received: from alyakaslap (bzq-169-168-31-234.red.bezeqint.net.
	[31.168.169.234])
	by smtp.gmail.com with ESMTPSA id n9sm2442444wjk.9.2016.07.18.11.01.09
	for <xfs@oss.sgi.com>
	(version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Mon, 18 Jul 2016 11:01:09 -0700 (PDT)
Message-ID: <143E2E5E912B4C348E8C62AA987F0506@alyakaslap>
From: "Alex Lyakas" <alex@zadarastorage.com>
Subject: xfs_vm_releasepage() causing BUG at free_buffer_head()
Date: Mon, 18 Jul 2016 21:00:41 +0300
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Greetings XFS community,

We have hit the following BUG [1].

This is in free_buffer_head():
BUG_ON(!list_empty(&bh->b_assoc_buffers));

This is happening in a long-term mainline kernel 3.18.19.

Some googling revealed a possibly-related discussion at:
http://comments.gmane.org/gmane.linux.file-systems/105093
https://lkml.org/lkml/2016/5/30/1007
except that in our case I don't see the "WARN_ON_ONCE(delalloc)" triggered.

I have no idea what to do this, so reporting.

Thanks,
Alex.


[2540217.134291] ------------[ cut here ]------------
[2540217.135008] kernel BUG at fs/buffer.c:3339!
[2540217.135008] invalid opcode: 0000 [#1] PREEMPT SMP
[2540217.135008] CPU: 0 PID: 38 Comm: kswapd0 Tainted: G        WC OE 
3.18.19-zadara05 #1
[2540217.135008] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[2540217.135008] task: ffff8800db499440 ti: ffff880118934000 task.ti: 
ffff880118934000
[2540217.135008] RIP: 0010:[<ffffffff8121b117>]  [<ffffffff8121b117>] 
free_buffer_head+0x67/0x70
[2540217.135008] RSP: 0000:ffff880118937980  EFLAGS: 00010293
[2540217.135008] RAX: ffff8800a6b4e2b8 RBX: ffff8800a6b4e270 RCX: 
0000000000000000
[2540217.135008] RDX: 0000000000000000 RSI: 0000000000001000 RDI: 
ffff8800a6b4e270
[2540217.135008] RBP: ffff8801189379b8 R08: 0000000000000018 R09: 
ffff88001d9d32f8
[2540217.135008] R10: ffff880118937990 R11: ffffea00029ad380 R12: 
0000000000000001
[2540217.135008] R13: ffff88001d9d3388 R14: ffffea000166c920 R15: 
ffff880118937ab0
[2540217.135008] FS:  0000000000000000(0000) GS:ffff88011fc00000(0000) 
knlGS:0000000000000000
[2540217.135008] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[2540217.135008] CR2: 00007ff5ce91d77c CR3: 0000000115897000 CR4: 
00000000001406f0
[2540217.135008] Stack:
[2540217.135008]  ffffffff8121b25c ffff88001f035240 ffff8800a6b4e270 
0000000000000000
[2540217.135008]  ffff880118937e50 ffffea000166c900 ffff88001d9d31a8 
ffff8801189379f8
[2540217.135008]  ffffffffc0a8933b 0000000000000000 0000000000000000 
ffffffff811abc60
[2540217.135008] Call Trace:
[2540217.193019]  [<ffffffff8121b25c>] ? try_to_free_buffers+0x7c/0xc0
[2540217.193019]  [<ffffffffc0a8933b>] xfs_vm_releasepage+0x4b/0x120 [xfs]
[2540217.193019]  [<ffffffff811abc60>] ? page_get_anon_vma+0xb0/0xb0
[2540217.193019]  [<ffffffff811722f2>] try_to_release_page+0x32/0x50
[2540217.193019]  [<ffffffff8118596d>] shrink_page_list+0x8fd/0xad0
[2540217.193019]  [<ffffffff817173e9>] ? _raw_spin_unlock_irq+0x19/0x50
[2540217.193019]  [<ffffffff81186116>] shrink_inactive_list+0x1a6/0x550
[2540217.193019]  [<ffffffff81399119>] ? 
radix_tree_gang_lookup_tag+0x89/0xd0
[2540217.193019]  [<ffffffff81186e0d>] shrink_lruvec+0x58d/0x750
[2540217.193019]  [<ffffffff81187053>] shrink_zone+0x83/0x1d0
[2540217.193019]  [<ffffffff8118727b>] kswapd_shrink_zone+0xdb/0x1b0
[2540217.193019]  [<ffffffff811884fd>] kswapd+0x4ed/0x8f0
[2540217.193019]  [<ffffffff81188010>] ? 
mem_cgroup_shrink_node_zone+0x190/0x190
[2540217.193019]  [<ffffffff810911b9>] kthread+0xc9/0xe0
[2540217.193019]  [<ffffffff810910f0>] ? kthread_create_on_node+0x180/0x180
[2540217.193019]  [<ffffffff81717918>] ret_from_fork+0x58/0x90
[2540217.193019]  [<ffffffff810910f0>] ? kthread_create_on_node+0x180/0x180
[2540217.193019] Code: 04 fb 00 00 3d ff 0f 00 00 7f 19 65 ff 0c 25 20 b8 00 
00 74 07 5d c3 0f 1f 44 00 00 e8 34 6a 18 00 5d c3 90 e8 8b fa ff ff eb e0 
<0f> 0b 0f 1f 80 00 00 00 00 0f 1f 44 00 00 55 48 89 e5 41 57 45
[2540217.193019] RIP  [<ffffffff8121b117>] free_buffer_head+0x67/0x70
[2540217.193019]  RSP <ffff880118937980>
[2540217.218819] ---[ end trace ffb67f26b48f16a2 ]---


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
