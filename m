Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9VIM67x228059 for <xfs@oss.sgi.com>; Wed, 31 Oct 2012 13:22:06 -0500
Message-ID: <50916CBA.7050602@sgi.com>
Date: Wed, 31 Oct 2012 13:23:54 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: xfstest 179 ASSERT
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>, xfs-oss <xfs@oss.sgi.com>

OSS sources with the xfs: fix buffer shudown reference count mismatch
patch and xfstest 179.

xfstest 179 started to have various asserts starting with the "move the
workers" series, but mostly the b_hold count is zero assert.

Now that the b_hold count is fixed, the asert is:

XFS: Assertion failed: atomic_read(&pag->pag_ref) == 0,
file: /root/xfs/fs/xfs/xfs_mount.c, line: 273

PID: 6741   TASK: ffff880268f46540  CPU: 0   COMMAND: "umount"
  #0 [ffff88034bba1a70] machine_kexec at ffffffff8102a71d
  #1 [ffff88034bba1ae0] crash_kexec at ffffffff810a4703
  #2 [ffff88034bba1bb0] oops_end at ffffffff81432098
  #3 [ffff88034bba1be0] die at ffffffff81005763
  #4 [ffff88034bba1c10] do_trap at ffffffff814319b3
  #5 [ffff88034bba1c70] do_invalid_op at ffffffff81002f50
  #6 [ffff88034bba1d10] invalid_op at ffffffff8143a09e
     [exception RIP: assfail+29]
     RIP: ffffffffa038e7dd  RSP: ffff88034bba1dc8  RFLAGS: 00010292
     RAX: 0000000000000065  RBX: 0000000000000000  RCX: 0000000000000de5
     RDX: 0000000000002013  RSI: 0000000000000092  RDI: 0000000000000246
     RBP: ffff88034bba1dc8   R8: 0000000000000000   R9: 0000000000000000
     R10: 0000000000000352  R11: 0000000000000351  R12: ffff88034d8af1f8
     R13: ffff88034d8af000  R14: ffff88034d8af1e8  R15: ffff88034fbf28c0
     ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
  #7 [ffff88034bba1dd0] xfs_free_perag at ffffffffa03de5d8 [xfs]
  #8 [ffff88034bba1e10] xfs_unmountfs at ffffffffa03e08bc [xfs]
  #9 [ffff88034bba1e60] xfs_fs_put_super at ffffffffa0390e80 [xfs]
#10 [ffff88034bba1e80] generic_shutdown_super at ffffffff8114f37d
#11 [ffff88034bba1eb0] kill_block_super at ffffffff8114f42b
#12 [ffff88034bba1ed0] deactivate_locked_super at ffffffff8114f9e7
#13 [ffff88034bba1ef0] deactivate_super at ffffffff811502d9
#14 [ffff88034bba1f10] mntput_no_expire at ffffffff8116a821
#15 [ffff88034bba1f40] sys_umount at ffffffff8116bd21
#16 [ffff88034bba1f80] system_call_fastpath at ffffffff814390a9
     RIP: 00007f64a30cf5d7  RSP: 00007ffffe2f3798  RFLAGS: 00010202
     RAX: 00000000000000a6  RBX: ffffffff814390a9  RCX: 000000000000c0c8
     RDX: 0000000000000000  RSI: 0000000000000000  RDI: 00007f64a3c0e0f0
     RBP: 00007f64a3c0dff0   R8: 0000000000000000   R9: 00007f64a3a05435
     R10: 00007ffffe2f35c0  R11: 0000000000000246  R12: 00007f64a3c0e0f0
     R13: 00007f64a3c0e0d0  R14: 00007f64a3c0e0f0  R15: 0000000000000000
     ORIG_RAX: 00000000000000a6  CS: 0033  SS: 002b


mount perag information:
   m_perag_tree = {
     height = 0x1,
     gfp_mask = 0x20,
     rnode = 0xffff8803124bb4b1
   },
crash> radix_tree_node ffff8803124bb4b0
struct radix_tree_node {
   height = 0x1,
   count = 0x3,
   {
     parent = 0x0,
     callback_head = {
       next = 0x0,
       func = 0xffffffff812384b0 <radix_tree_node_rcu_free>
     }
   },
   slots = {0x0, 0xffff88034fd6f540, 0xffff88034fd6f840, 
0xffff88034fd6f240, 0x0,
  0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 
0x0, 0x0,
  0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 
0x0, 0x0,
  0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 
0x0, 0x0,
  0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0},
   tags = {{0x0}, {0x0}, {0x0}}
}

The inodes at 0xffff88034fd6f540, 0xffff88034fd6f840, 0xffff88034fd6f240
don't look valid.

I haven't spent much time on this.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
