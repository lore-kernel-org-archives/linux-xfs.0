Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7Q0kIbj236745 for <xfs@oss.sgi.com>; Tue, 25 Aug 2009 19:46:28 -0500
Received: from peace.netnation.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 82184153EF6B
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2009 17:47:00 -0700 (PDT)
Received: from peace.netnation.com (newpeace.netnation.com [204.174.223.7]) by
	cuda.sgi.com with ESMTP id reQBvJw8u0CEDOXt for
	<xfs@oss.sgi.com>; Tue, 25 Aug 2009 17:47:00 -0700 (PDT)
Date: Tue, 25 Aug 2009 17:46:58 -0700
From: Simon Kirby <sim@hostway.ca>
Subject: [2.6.30.4] XFS-related BUG and hang via shrink_icache_memory
Message-ID: <20090826004658.GA30929@hostway.ca>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, linux-kernel@vger.kernel.org

On an NFS storage server, we started using some XFS filesystems along
with many other EXT3 (on LVM on AOE).  The following bug has occurred
twice, with the machine hanging immediately after (console full of
scrolling oopses or bugs -- haven't seen it myself -- after this):

Aug 25 16:16:15 nas03 kernel: kernel BUG at lib/radix-tree.c:485!
Aug 25 16:16:15 nas03 kernel: CPU 1 
Aug 25 16:16:15 nas03 kernel: Pid: 417, comm: kswapd0 Not tainted 2.6.30.4-hw #1 PowerEdge 1950
Aug 25 16:16:15 nas03 kernel: RIP: 0010:[<ffffffff8046b4f2>]  [<ffffffff8046b4f2>] radix_tree_tag_set+0xa2/0xb0
Aug 25 16:16:15 nas03 kernel: RSP: 0018:ffff88022fb1dc78  EFLAGS: 00010246
Aug 25 16:16:15 nas03 kernel: RAX: 000000000000001e RBX: 0000000000000000 RCX: ffff8801d2f855c8
Aug 25 16:16:15 nas03 kernel: RDX: 0000000000000000 RSI: 000000000000009e RDI: ffff88022c704530
Aug 25 16:16:15 nas03 kernel: RBP: ffff88022fb1dc80 R08: 000000000000001e R09: 0000000000000000
Aug 25 16:16:15 nas03 kernel: R10: 0000000000000000 R11: 0000000000000001 R12: ffff8801385a6180
Aug 25 16:16:15 nas03 kernel: R13: ffff88022cb56800 R14: 000000000000000f R15: 0000000000000080
Aug 25 16:16:15 nas03 kernel: FS:  0000000000000000(0000) GS:ffff88002804d000(0000) knlGS:0000000000000000
Aug 25 16:16:15 nas03 kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug 25 16:16:15 nas03 kernel: CR2: 00007f759ae1dae0 CR3: 0000000000201000 CR4: 00000000000006e0
Aug 25 16:16:15 nas03 kernel:  ffff88022c7044f0 ffff88022fb1dcb0 ffffffff80439198 ffff88022fb1dcc0
Aug 25 16:16:15 nas03 kernel:  ffff8801385a6180 ffff8801385a6300 ffff88022fb1dd60 ffff88022fb1dcd0
Aug 25 16:16:15 nas03 kernel:  ffffffff80429cbb ffff88022fb1dce0 ffff8801385a6300 ffff88022fb1dcf0
Aug 25 16:16:15 nas03 kernel: Call Trace:
Aug 25 16:16:15 nas03 kernel:  [<ffffffff80439198>] xfs_inode_set_reclaim_tag+0x78/0xa0
Aug 25 16:16:15 nas03 kernel:  [<ffffffff80429cbb>] xfs_reclaim+0x5b/0xb0
Aug 25 16:16:15 nas03 kernel:  [<ffffffff80437ce8>] xfs_fs_destroy_inode+0x38/0x60
Aug 25 16:16:15 nas03 kernel:  [<ffffffff802c6e0e>] destroy_inode+0x2e/0x50
Aug 25 16:16:15 nas03 kernel:  [<ffffffff802c7206>] dispose_list+0x96/0x110
Aug 25 16:16:15 nas03 kernel:  [<ffffffff802c743e>] shrink_icache_memory+0x1be/0x2b0
Aug 25 16:16:15 nas03 kernel:  [<ffffffff80290d25>] shrink_slab+0x125/0x180
Aug 25 16:16:15 nas03 kernel:  [<ffffffff802915d9>] kswapd+0x3c9/0x5c0
Aug 25 16:16:15 nas03 kernel:  [<ffffffff8028ee80>] ? isolate_pages_global+0x0/0x290
Aug 25 16:16:15 nas03 kernel:  [<ffffffff80702e11>] ? thread_return+0x3f/0x63e
Aug 25 16:16:15 nas03 kernel:  [<ffffffff80256790>] ? autoremove_wake_function+0x0/0x40
Aug 25 16:16:15 nas03 kernel:  [<ffffffff80291210>] ? kswapd+0x0/0x5c0
Aug 25 16:16:15 nas03 kernel:  [<ffffffff8095c140>] ? early_idt_handler+0x0/0x71
Aug 25 16:16:15 nas03 kernel:  [<ffffffff8025637a>] kthread+0x5a/0x90
Aug 25 16:16:15 nas03 kernel:  [<ffffffff8020ce0a>] child_rip+0xa/0x20
Aug 25 16:16:15 nas03 kernel:  [<ffffffff8095c140>] ? early_idt_handler+0x0/0x71
Aug 25 16:16:15 nas03 kernel:  [<ffffffff80256320>] ? kthread+0x0/0x90
Aug 25 16:16:15 nas03 kernel:  [<ffffffff8020ce00>] ? child_rip+0x0/0x20
Aug 25 16:16:15 nas03 kernel: Code: 4d 85 d2 74 26 41 ff cb 75 c4 4d 85 d2 74 16 8b 47 04 8d 4b 15 ba 01 00 00 00 d3 e2 85 c2 75 05 09 d0 89 47 04 5b c9 4c 89 d0 c3 <0f> 0b eb fe 0f 0b eb fe 66 66 90 66 66 90 55 48 89 e5 41 57 41 


>>RIP; ffffffff8046b4f2 <radix_tree_tag_set+a2/b0>   <=====

>>RCX; ffff8801d2f855c8 <phys_startup_64+ffff8801d2d855c8/ffffffff80000000>
>>RDI; ffff88022c704530 <phys_startup_64+ffff88022c504530/ffffffff80000000>
>>RBP; ffff88022fb1dc80 <phys_startup_64+ffff88022f91dc80/ffffffff80000000>
>>R12; ffff8801385a6180 <phys_startup_64+ffff8801383a6180/ffffffff80000000>
>>R13; ffff88022cb56800 <phys_startup_64+ffff88022c956800/ffffffff80000000>

Trace; ffffffff80439198 <xfs_inode_set_reclaim_tag+78/a0>
Trace; ffffffff80429cbb <xfs_reclaim+5b/b0>
Trace; ffffffff80437ce8 <xfs_fs_destroy_inode+38/60>
Trace; ffffffff802c6e0e <destroy_inode+2e/50>
Trace; ffffffff802c7206 <dispose_list+96/110>
Trace; ffffffff802c743e <shrink_icache_memory+1be/2b0>
Trace; ffffffff80290d25 <shrink_slab+125/180>
Trace; ffffffff802915d9 <kswapd+3c9/5c0>
Trace; ffffffff8028ee80 <isolate_pages_global+0/290>
Trace; ffffffff80702e11 <thread_return+3f/63e>
Trace; ffffffff80256790 <autoremove_wake_function+0/40>
Trace; ffffffff80291210 <kswapd+0/5c0>
Trace; ffffffff8095c140 <early_idt_handler+0/71>
Trace; ffffffff8025637a <kthread+5a/90>
Trace; ffffffff8020ce0a <child_rip+a/20>
Trace; ffffffff8095c140 <early_idt_handler+0/71>
Trace; ffffffff80256320 <kthread+0/90>
Trace; ffffffff8020ce00 <child_rip+0/20>

Code;  ffffffff8046b4c7 <radix_tree_tag_set+77/b0>
0000000000000000 <_RIP>:
Code;  ffffffff8046b4c7 <radix_tree_tag_set+77/b0>
   0:   4d 85 d2                  test   %r10,%r10
Code;  ffffffff8046b4ca <radix_tree_tag_set+7a/b0>
   3:   74 26                     je     2b <_RIP+0x2b>
Code;  ffffffff8046b4cc <radix_tree_tag_set+7c/b0>
   5:   41 ff cb                  dec    %r11d
Code;  ffffffff8046b4cf <radix_tree_tag_set+7f/b0>
   8:   75 c4                     jne    ffffffffffffffce <_RIP+0xffffffffffffffce>
Code;  ffffffff8046b4d1 <radix_tree_tag_set+81/b0>
   a:   4d 85 d2                  test   %r10,%r10
Code;  ffffffff8046b4d4 <radix_tree_tag_set+84/b0>
   d:   74 16                     je     25 <_RIP+0x25>
Code;  ffffffff8046b4d6 <radix_tree_tag_set+86/b0>
   f:   8b 47 04                  mov    0x4(%rdi),%eax
Code;  ffffffff8046b4d9 <radix_tree_tag_set+89/b0>
  12:   8d 4b 15                  lea    0x15(%rbx),%ecx
Code;  ffffffff8046b4dc <radix_tree_tag_set+8c/b0>
  15:   ba 01 00 00 00            mov    $0x1,%edx
Code;  ffffffff8046b4e1 <radix_tree_tag_set+91/b0>
  1a:   d3 e2                     shl    %cl,%edx
Code;  ffffffff8046b4e3 <radix_tree_tag_set+93/b0>
  1c:   85 c2                     test   %eax,%edx
Code;  ffffffff8046b4e5 <radix_tree_tag_set+95/b0>
  1e:   75 05                     jne    25 <_RIP+0x25>
Code;  ffffffff8046b4e7 <radix_tree_tag_set+97/b0>
  20:   09 d0                     or     %edx,%eax
Code;  ffffffff8046b4e9 <radix_tree_tag_set+99/b0>
  22:   89 47 04                  mov    %eax,0x4(%rdi)
Code;  ffffffff8046b4ec <radix_tree_tag_set+9c/b0>
  25:   5b                        pop    %rbx
Code;  ffffffff8046b4ed <radix_tree_tag_set+9d/b0>
  26:   c9                        leaveq 
Code;  ffffffff8046b4ee <radix_tree_tag_set+9e/b0>
  27:   4c 89 d0                  mov    %r10,%rax
Code;  ffffffff8046b4f1 <radix_tree_tag_set+a1/b0>
  2a:   c3                        retq   
Code;  ffffffff8046b4f2 <radix_tree_tag_set+a2/b0>   <=====
  2b:   0f 0b                     ud2a      <=====
Code;  ffffffff8046b4f4 <radix_tree_tag_set+a4/b0>
  2d:   eb fe                     jmp    2d <_RIP+0x2d>
Code;  ffffffff8046b4f6 <radix_tree_tag_set+a6/b0>
  2f:   0f 0b                     ud2a   
Code;  ffffffff8046b4f8 <radix_tree_tag_set+a8/b0>
  31:   eb fe                     jmp    31 <_RIP+0x31>
Code;  ffffffff8046b4fa <radix_tree_tag_set+aa/b0>
  33:   66 66 90                  xchg   %ax,%ax
Code;  ffffffff8046b4fd <radix_tree_tag_set+ad/b0>
  36:   66 66 90                  xchg   %ax,%ax
Code;  ffffffff8046b500 <radix_tree_delete+0/270>
  39:   55                        push   %rbp
Code;  ffffffff8046b501 <radix_tree_delete+1/270>
  3a:   48 89 e5                  mov    %rsp,%rbp
Code;  ffffffff8046b504 <radix_tree_delete+4/270>
  3d:   41 57                     push   %r15
Code;  ffffffff8046b506 <radix_tree_delete+6/270>
  3f:   41                        rex.B

This is stock 2.6.30.4, x86_64, serving files over NFS.  Perhaps
something in the shrink_icache_memory path (which happens to get hit a
lot with our particular load patterns) isn't safe with XFS? 

I'm a bit low on sleep so I'm sure I'm missing some info.  Please ask. :)

Simon-

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
