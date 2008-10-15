Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 14 Oct 2008 21:49:21 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9F4nISj032495
	for <xfs@oss.sgi.com>; Tue, 14 Oct 2008 21:49:18 -0700
Message-ID: <48F584B8.8060907@sgi.com>
Date: Wed, 15 Oct 2008 15:50:48 +1000
From: Peter Leckie <pleckie@sgi.com>
MIME-Version: 1.0
Subject: Re: crash with latest code drop.
References: <48F54C20.8060704@sgi.com> <20081015011857.GS10716@disturbed> <20081015022948.GA20966@infradead.org> <20081015031645.GA25906@disturbed> <20081015032431.GA7426@infradead.org> <20081015035116.GB25906@disturbed>
In-Reply-To: <20081015035116.GB25906@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, Peter Leckie <pleckie@sgi.com>, xfs@oss.sgi.com

Dave Chinner wrote:
> Update below.
>
> Cheers,
>
> Dave.
>   
The original patch appeared to fix the issue, however the latest one 
Oops as follows:


177 553s ...BUG: unable to handle kernel NULL pointer dereference at 
00000000000000e8
IP: [<ffffffff802a406e>] is_bad_inode+0x2/0x11
PGD 7b0fe067 PUD 4c414067 PMD 0
Oops: 0000 [1] SMP

Entering kdb (current=0xffff88007f15e190, pid 6915) on processor 1 Oops: 
<NULL>
due to oops @ 0xffffffff802a406e
     r15 = 0x0000000000000040      r14 = 0xffff88007e9ae608
     r13 = 0x0000000000000000      r12 = 0x000000000000000a
      bp = 0xffff8800375a8d68       bx = 0x0000000000000000
     r11 = 0x0000000000000001      r10 = 0x0000000000000085
      r9 = 0xffff880057cd3dc0       r8 = 0xffff88007b0cddf0
      ax = 0x0000000000000000       cx = 0x000000000000001b
      dx = 0x0000000000000084       si = 0xffff880057d0c248
      di = 0x0000000000000000  orig_ax = 0xffffffffffffffff
      ip = 0xffffffff802a406e       cs = 0x0000000000000010
   flags = 0x0000000000010246       sp = 0xffff88007b0cde10
      ss = 0x0000000000000018 &regs = 0xffff88007b0cdd78

[1]kdb> bt
Stack traceback for pid 6915
0xffff88007f15e190     6915     6735  1    1   R  0xffff88007f15e4f8 
*bulkstat_unlink
sp                ip                Function (args)
0xffff88007b0cddf8 0xffffffff802a406e is_bad_inode+0x2 (0x0)
0xffff88007b0cde20 0xffffffffa01f3615 [xfs]xfs_sync_inodes_ag+0xe6 
(0xffff88007e9ae608, invalid, invalid)
0xffff88007b0cde80 0xffffffffa01f3864 [xfs]xfs_sync_inodes+0x63 
(0xffff88007e9ae608, invalid)
0xffff88007b0cdec0 0xffffffffa01f392a [xfs]xfs_quiesce_data+0x13 
(0xffff88007e9ae608)
0xffff88007b0cdee0 0xffffffffa01f1800 [xfs]xfs_fs_sync_super+0x2b 
(0xffff88007b878730)
0xffff88007b0cdf40 0xffffffff80292fd2 sync_filesystems+0xae (invalid)
0xffff88007b0cdf60 0xffffffff802af48b do_sync+0x2f (0x1)
0xffff88007b0cdf70 0xffffffff802af4c4 sys_sync+0xe
bb_special_case: Invalid bb_reg_state.memory, missing trailing entries
bb_special_case: on transfer to int_with_check
  Assuming system_call_fastpath is 'pass through' with 6 register parameters
kdb_bb: 0xffffffff8020be0b [kernel]system_call_fastpath failed at 
0xffffffff8020be98

Using old style backtrace, unreliable with no arguments
sp                ip                Function (args)
0xffff88007b0cddf8 0xffffffff802a406e is_bad_inode+0x2
0xffff88007b0cde20 0xffffffffa01f3615 [xfs]xfs_sync_inodes_ag+0xe6
0xffff88007b0cde80 0xffffffffa01f3864 [xfs]xfs_sync_inodes+0x63
0xffff88007b0cdec0 0xffffffffa01f392a [xfs]xfs_quiesce_data+0x13
0xffff88007b0cdec8 0xffffffff802452b9 autoremove_wake_function
0xffff88007b0cdee0 0xffffffffa01f1800 [xfs]xfs_fs_sync_super+0x2b
0xffff88007b0cdf00 0xffffffff8043b871 __down_read+0x12
0xffff88007b0cdf10 0xffffffffa024d395 [ext3]ext3_sync_fs+0x46
0xffff88007b0cdf40 0xffffffff80292fd2 sync_filesystems+0xae
0xffff88007b0cdf60 0xffffffff802af48b do_sync+0x2f
0xffff88007b0cdf70 0xffffffff802af4c4 sys_sync+0xe

[1]kdb> id %ip
0xffffffff802a406e is_bad_inode+0x2:     cmpq   
$0xffffffff8045ce20,0xe8(%rdi)
0xffffffff802a4079 is_bad_inode+0xd:     sete   %al
0xffffffff802a407c is_bad_inode+0x10:    retq
0xffffffff802a407d make_bad_inode:         push   %rbx
0xffffffff802a407e make_bad_inode+0x1:     mov    %rdi,%rbx
0xffffffff802a4081 make_bad_inode+0x4:     callq  0xffffffff802a25d5 
remove_inode_hash
0xffffffff802a4086 make_bad_inode+0x9:     mov    0xf8(%rbx),%rdi
0xffffffff802a408d make_bad_inode+0x10:    movw   $0x8000,0xb2(%rbx)
0xffffffff802a4096 make_bad_inode+0x19:    callq  0xffffffff80237d6b 
current_fs_time
0xffffffff802a409b make_bad_inode+0x1e:    movq   
$0xffffffff8045ce20,0xe8(%rbx)
0xffffffff802a40a6 make_bad_inode+0x29:    mov    %rax,0x90(%rbx)
0xffffffff802a40ad make_bad_inode+0x30:    mov    %rdx,0x98(%rbx)
0xffffffff802a40b4 make_bad_inode+0x37:    mov    %rax,0x80(%rbx)
0xffffffff802a40bb make_bad_inode+0x3e:    mov    %rdx,0x88(%rbx)
0xffffffff802a40c2 make_bad_inode+0x45:    mov    %rax,0x70(%rbx)
0xffffffff802a40c6 make_bad_inode+0x49:    mov    %rdx,0x78(%rbx)


Thanks,
Pete
