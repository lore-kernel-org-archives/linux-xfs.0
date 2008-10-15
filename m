Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 14 Oct 2008 17:47:52 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9F0lojG028718
	for <xfs@oss.sgi.com>; Tue, 14 Oct 2008 17:47:50 -0700
Message-ID: <48F54C20.8060704@sgi.com>
Date: Wed, 15 Oct 2008 11:49:20 +1000
From: Peter Leckie <pleckie@sgi.com>
MIME-Version: 1.0
Subject: crash with latest code drop.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

Hi Dave and list, I hit the following crash with the latest code drop 
that was pushed in yesterday
while running test 177 in a loop, after 4-5 loops it crashed as follows:
"<0>general protection fault: 0000 [1] SMP"


[1]kdb> bt
Stack traceback for pid 5425
0xffff88007b9b38d0     5425     5242  1    1   R  0xffff88007b9b3c38 *sync
sp                ip                Function (args)
0xffff88006c45fde8 0xffffffff80320990 radix_tree_tagged+0xa 
(0x6b6b6b6b6b6b6b73, 0x0)
0xffff88006c45fe10 0xffffffffa01f36c6 [xfs]xfs_sync_inodes_ag+0x197 
(0xffff88007d4025c8, invalid, invalid)
0xffff88006c45fe80 0xffffffffa01f38d1 [xfs]xfs_sync_inodes+0x63 
(0xffff88007d4025c8, invalid)
0xffff88006c45fec0 0xffffffffa01f3997 [xfs]xfs_quiesce_data+0x13 
(0xffff88007d4025c8)
0xffff88006c45fee0 0xffffffffa01f1800 [xfs]xfs_fs_sync_super+0x2b 
(0xffff88007d9f10b8)
0xffff88006c45ff40 0xffffffff80292fd2 sync_filesystems+0xae (invalid)
0xffff88006c45ff60 0xffffffff802af48b do_sync+0x2f (0x1)
0xffff88006c45ff70 0xffffffff802af4c4 sys_sync+0xe
bb_special_case: Invalid bb_reg_state.memory, missing trailing entries
bb_special_case: on transfer to int_with_check
  Assuming system_call_fastpath is 'pass through' with 6 register parameters
kdb_bb: 0xffffffff8020be0b [kernel]system_call_fastpath failed at 
0xffffffff8020be98

Using old style backtrace, unreliable with no arguments
sp                ip                Function (args)
0xffff88006c45fdb0 0xffffffffa01f369a [xfs]xfs_sync_inodes_ag+0x16b
0xffff88006c45fde8 0xffffffff80320990 radix_tree_tagged+0xa
0xffff88006c45fe10 0xffffffffa01f36c6 [xfs]xfs_sync_inodes_ag+0x197
0xffff88006c45fe80 0xffffffffa01f38d1 [xfs]xfs_sync_inodes+0x63
0xffff88006c45fec0 0xffffffffa01f3997 [xfs]xfs_quiesce_data+0x13
0xffff88006c45fec8 0xffffffff802452b9 autoremove_wake_function
0xffff88006c45fee0 0xffffffffa01f1800 [xfs]xfs_fs_sync_super+0x2b
0xffff88006c45ff00 0xffffffff8043b871 __down_read+0x12
0xffff88006c45ff10 0xffffffffa024d395 [ext3]ext3_sync_fs+0x46
0xffff88006c45ff40 0xffffffff80292fd2 sync_filesystems+0xae
0xffff88006c45ff60 0xffffffff802af48b do_sync+0x2f
0xffff88006c45ff70 0xffffffff802af4c4 sys_sync+0xe


[1]kdb> rd
     r15 = 0x0000000000000002      r14 = 0x0000000000000000
     r13 = 0x000000000000000a      r12 = 0x0000000000000040
      bp = 0xffff88003793a9d8       bx = 0xffff880055c10250
     r11 = 0x0000000000000001      r10 = 0xffff880055d0ade8
      r9 = 0x000000000002309f       r8 = 0xffffffffa01f369a
      ax = 0x0000000000200000       cx = 0x0000000000000015
      dx = 0x0000000000000000       si = 0x0000000000000000
      di = 0x6b6b6b6b6b6b6b73  orig_ax = 0xffffffffffffffff
      ip = 0xffffffff80320990       cs = 0x0000000000000010
   flags = 0x0000000000010206       sp = 0xffff88006c45fe00
      ss = 0x0000000000000018 &regs = 0xffff88006c45fd68


[1]kdb> id %ip
0xffffffff80320990 radix_tree_tagged+0xa:     and    0x4(%rdi),%eax
0xffffffff80320993 radix_tree_tagged+0xd:     retq
0xffffffff80320994 radix_tree_callback:         cmp    $0x7,%rsi
0xffffffff80320998 radix_tree_callback+0x4:     push   %rbx
0xffffffff80320999 radix_tree_callback+0x5:     je     
0xffffffff803209a1 radix_tree_callback+0xd
0xffffffff8032099b radix_tree_callback+0x7:     cmp    $0x17,%rsi
0xffffffff8032099f radix_tree_callback+0xb:     jne    
0xffffffff803209e1 radix_tree_callback+0x4d
0xffffffff803209a1 radix_tree_callback+0xd:     movslq %edx,%rax
0xffffffff803209a4 radix_tree_callback+0x10:    mov    
3961501(%rip),%rdx             # 0xffffffff806e7c48 _cpu_pda
0xffffffff803209ab radix_tree_callback+0x17:    mov    
$0xffffffff80796480,%rbx
0xffffffff803209b2 radix_tree_callback+0x1e:    mov    (%rdx,%rax,8),%rax
0xffffffff803209b6 radix_tree_callback+0x22:    add    0x8(%rax),%rbx
0xffffffff803209ba radix_tree_callback+0x26:    jmp    
0xffffffff803209db radix_tree_callback+0x47
0xffffffff803209bc radix_tree_callback+0x28:    cltq
0xffffffff803209be radix_tree_callback+0x2a:    mov    
5545627(%rip),%rdi             # 0xffffffff8086a860 __key.8127
0xffffffff803209c5 radix_tree_callback+0x31:    mov    (%rbx,%rax,8),%rsi



The back trace is a little busted xfs_sync_inodes_ag appears to be calling:
xfs_sync_inodes_ag->xfs_flush_pages->mapping_tagged->radix_tree_tagged()
 
The poison appears to be from the i_mapping pointer in the linux inode 
and it crashes
in radix_tree_tagged() after following &mapping->page_tree.

Any insight into the possible causes for this crash would be much 
appreciated as this crash may be related to
another issue I'm looking at where sync fails to write out a deleted 
inode due to missing XFS_DINODE_MAGIC.

Thanks,

Pete
