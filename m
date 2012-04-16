Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3GDl2u5214359 for <xfs@oss.sgi.com>; Mon, 16 Apr 2012 08:47:02 -0500
Message-ID: <4F8C22D4.3040908@sgi.com>
Date: Mon, 16 Apr 2012 08:47:00 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 04/10] xfs: implement freezing by emptying the AIL
References: <20120327164400.967415009@bombadil.infradead.org>
	<20120327164644.830680325@bombadil.infradead.org>
In-Reply-To: <20120327164644.830680325@bombadil.infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 03/27/12 11:44, Christoph Hellwig wrote:
> Now that we write back all metadata either synchronously or through the AIL
> we can simply implement metadata freezing in terms of emptying the AIL.
>
> The implementation for this is fairly simply and straight-forward:  A new
> routine is added that increments a counter that tells xfsaild to not stop
> until the AIL is empty and then waits on a wakeup from
> xfs_trans_ail_delete_bulk to signal that the AIL is empty.
>
> As usual the devil is in the details, in this case the filesystem shutdown
> code.  Currently we are a bit sloppy there and do not continue ail pushing
> in that case, and thus never reach the code in the log item implementations
> that can unwind in case of a shutdown filesystem.  Also the code to
> abort inode and dquot flushes was rather sloppy before and did not remove
> the log items from the AIL, which had to be fixed as well.
>
> Also treat unmount the same way as freeze now, except that we still keep a
> synchronous inode reclaim pass to make sure we reclaim all clean inodes, too.
>
> As an upside we can now remove the radix tree based inode writeback and
> xfs_unmountfs_writesb.
>
> Signed-off-by: Christoph Hellwig<hch@lst.de>

Sorry for the empty email.

This series hangs my test boxes. This patch is the first indication of 
the hang. Reboot, and remove patch 4 and the test are successful.

The machine is still responsive. Only the SCRATCH filesystem from the 
test suite is hung.

Per Dave's observation, I added a couple inode reclaims to this patch 
and the test gets further (hangs on run 9 of test 068 rather than run 3).

The back traces are from a Linux 3.4-rc2 kernel with just patches 0-4 of 
this series applied. This traceback does not have extra inode reclaims. 
The hang is in test 068. I did an ls and sync to the filesystem, so I 
included their tracebacks as well.  live system.

I have looked at the remaining patches in the series, but have not 
reviewed them because they depend on this patch...

--Mark.
---

crash> bt -f 20050
PID: 20050  TASK: ffff88034a6943c0  CPU: 0   COMMAND: "fsstress"
  #0 [ffff88034aa93d18] __schedule at ffffffff81416e50
     ffff88034aa93d20: 0000000000000082 ffff88034aa92010
     ffff88034aa93d30: 0000000000012400 0000000000012400
     ffff88034aa93d40: 0000000000012400 0000000000012400
     ffff88034aa93d50: ffff88034aa93fd8 ffff88034aa93fd8
     ffff88034aa93d60: 0000000000012400 ffff88034a6943c0
     ffff88034aa93d70: ffffffff81813020 ffff88034a6a4060
     ffff88034aa93d80: 0000000000000029 ffff88034aa93df8
     ffff88034aa93d90: ffffffff811167fd 80000002b65ff065
     ffff88034aa93da0: ffff88035fc92478 ffff88034c33a018
     ffff88034aa93db0: 000000000060c048 ffffea000b847410
     ffff88034aa93dc0: ffff88034c6a5680 ffffea000b8473e0
     ffff88034aa93dd0: ffff88034c33a018 000000000060c048
     ffff88034aa93de0: ffff88034c6a5680 ffff88034b66a558
     ffff88034aa93df0: 0000000000000029 ffff88034aa93e38
     ffff88034aa93e00: ffffffff81116a1d ffff88034ad56080
     ffff88034aa93e10: ffff88034ad56080 ffff88034aa93ee8
     ffff88034aa93e20: 0000000000000000 ffff88034a6943c0
     ffff88034aa93e30: ffff88034a6943b0 ffff88034a694888
     ffff88034aa93e40: ffff88034aa93ee8 ffff88034a6943c0
     ffff88034aa93e50: ffff88034a6943c0 ffff88034aa93e68
     ffff88034aa93e60: ffffffff814171c4
  #1 [ffff88034aa93e60] schedule at ffffffff814171c4
     ffff88034aa93e68: ffff88034aa93ed8 ffffffff81040e39
  #2 [ffff88034aa93e70] do_wait at ffffffff81040e39
     ffff88034aa93e78: 0000000000000000 ffff88034a6943c0
     ffff88034aa93e88: ffff88034a6943c0 ffff88034aa93f10
     ffff88034aa93e98: ffff88034a6943c0 ffff88034aa93f30
     ffff88034aa93ea8: ffff88034a6948f0 ffffffffffffffea
     ffff88034aa93eb8: 0000000000000004 0000000000000000
     ffff88034aa93ec8: 0000000000000000 00007fff47fe1c2c
     ffff88034aa93ed8: ffff88034aa93f78 ffffffff81040f11
  #3 [ffff88034aa93ee0] sys_wait4 at ffffffff81040f11
     ffff88034aa93ee8: 0000000400000003 0000000000000000
     ffff88034aa93ef8: 0000000000000000 00007fff47fe1c2c
     ffff88034aa93f08: 0000000000000000 00007fff00000000
     ffff88034aa93f18: ffff88034a6943c0 ffffffff8103f510
     ffff88034aa93f28: ffff88034baa2098 ffff88034baa2098
     ffff88034aa93f38: 0000000000000000 00007fff47fe1c00
     ffff88034aa93f48: 0000000000000000 00007fff47fe1c2c
     ffff88034aa93f58: 00007fff47fe1b50 0000000000000003
     ffff88034aa93f68: 0000000000000000 00007fff47fe1c00
     ffff88034aa93f78: 0000000000000002 ffffffff8141fff9
  #4 [ffff88034aa93f80] system_call_fastpath at ffffffff8141fff9
     RIP: 00007fbe427e5244  RSP: 00007fff47fdfab0  RFLAGS: 00010246
     RAX: 000000000000003d  RBX: ffffffff8141fff9  RCX: 00007fff47fdfa50
     RDX: 0000000000000000  RSI: 00007fff47fe1c2c  RDI: ffffffffffffffff
     RBP: 0000000000000002   R8: 0000000000004e52   R9: 0000000000004e52
     R10: 0000000000000000  R11: 0000000000000246  R12: 00007fff47fe1c00
     R13: 0000000000000000  R14: 0000000000000003  R15: 00007fff47fe1b50
     ORIG_RAX: 000000000000003d  CS: 0033  SS: 002b

PID: 20051  TASK: ffff88034e31e600  CPU: 3   COMMAND: "fsstress"
  #0 [ffff88034c5c1c08] __schedule at ffffffff81416e50
     ffff88034c5c1c10: 0000000000000086 ffff88034c5c0010
     ffff88034c5c1c20: 0000000000012400 0000000000012400
     ffff88034c5c1c30: 0000000000012400 0000000000012400
     ffff88034c5c1c40: ffff88034c5c1fd8 ffff88034c5c1fd8
     ffff88034c5c1c50: 0000000000012400 ffff88034e31e600
     ffff88034c5c1c60: ffff88034fa12580 8080808080808080
     ffff88034c5c1c70: fefefefefefefeff 000000010000002e
     ffff88034c5c1c80: ffff88034c312000 ffff88034c5c1cd8
     ffff88034c5c1c90: ffffffff8115a045 ffff8802b7ae1324
     ffff88034c5c1ca0: ffff88034f4b2ac0 ffff88034c5c1cd8
     ffff88034c5c1cb0: ffffffff811580c2 0000000000000041
     ffff88034c5c1cc0: 0000000000001051 0000000000000000
     ffff88034c5c1cd0: ffff88034c5c1db8 ffff88034c5c1d68
     ffff88034c5c1ce0: ffffffff8115c4a4 0000000000000000
     ffff88034c5c1cf0: ffff88034c5c1dc8 ffff88034c5c1d08
     ffff88034c5c1d00: ffffffff8116b49c ffff88034c5c1d28
     ffff88034c5c1d10: 0000000000000246 ffff88034c5c1d58
     ffff88034c5c1d20: ffff88034c5c1d88 0000000000013160
     ffff88034c5c1d30: ffff88034c5c1df8 ffff88034c5c1ed8
     ffff88034c5c1d40: 00000000001b90b8 ffff88034c5c1d58
     ffff88034c5c1d50: ffffffff814171c4
  #1 [ffff88034c5c1d50] schedule at ffffffff814171c4
     ffff88034c5c1d58: ffff88034c5c1de8 ffffffffa044d4b5
  #2 [ffff88034c5c1d60] xfs_file_aio_write at ffffffffa044d4b5 [xfs]
     ffff88034c5c1d68: ffff88034f4b2ac0 ffff8802b7ae11f8
     ffff88034c5c1d78: ffff8802b7ae10c0 0000000000000001
     ffff88034c5c1d88: 0000000000000000 ffff88034e31e600
     ffff88034c5c1d98: ffffffff8105e3e0 ffff88034be7aeb0
     ffff88034c5c1da8: ffff88034b84f918 0000000000017777
     ffff88034c5c1db8: ffff88034e3d46a0 ffff88034c5c1df8
     ffff88034c5c1dc8: ffff88034c5c1ed8 ffff88034f4b2ac0
     ffff88034c5c1dd8: ffff88034c5c1f48 0000000000000000
     ffff88034c5c1de8: ffff88034c5c1f08 ffffffff8114d3d9
  #3 [ffff88034c5c1df0] do_sync_write at ffffffff8114d3d9
     ffff88034c5c1df8: 0000000000000002 0000000000000001
     ffff88034c5c1e08: 0000000000000000 ffffffff00000001
     ffff88034c5c1e18: ffff88034f4b2ac0 0000000000000000
     ffff88034c5c1e28: 0000000000000000 0000000000000000
     ffff88034c5c1e38: 0000000000000000 ffff88034e31e600
     ffff88034c5c1e48: 0000000000000000 00000000001b90b8
     ffff88034c5c1e58: 0000000000000808 0000000000000098
     ffff88034c5c1e68: 0000000000017777 00000000000081b6
     ffff88034c5c1e78: 0000000000017777 0000000000000000
     ffff88034c5c1e88: 000000000019b7bd 0000000000001000
     ffff88034c5c1e98: ffff88034c5c1ea8 ffffffff811ffcd3
     ffff88034c5c1ea8: ffff88034c5c1ed8 ffffffff811db75d
     ffff88034c5c1eb8: 0000000000017777 ffff88034f4b2ac0
     ffff88034c5c1ec8: 0000000000000001 00007fbe3c000d10
     ffff88034c5c1ed8: 00007fbe3c000d10 0000000000017777
     ffff88034c5c1ee8: 0000000000017777 ffff88034f4b2ac0
     ffff88034c5c1ef8: ffff88034c5c1f48 00007fbe3c000d10
     ffff88034c5c1f08: ffff88034c5c1f38 ffffffff8114da0b
  #4 [ffff88034c5c1f10] vfs_write at ffffffff8114da0b
     ffff88034c5c1f18: ffff88034f4b2ac0 fffffffffffffff7
     ffff88034c5c1f28: 0000000000017777 00007fbe3c000d10
     ffff88034c5c1f38: ffff88034c5c1f78 ffffffff8114db60
  #5 [ffff88034c5c1f40] sys_write at ffffffff8114db60
     ffff88034c5c1f48: 00000000001b90b8 0000000000001000
     ffff88034c5c1f58: 00007fbe3c000d10 00007fff47fdfa20
     ffff88034c5c1f68: 0000000000000003 0000000000000085
     ffff88034c5c1f78: 0000000000017777 ffffffff8141fff9
  #6 [ffff88034c5c1f80] system_call_fastpath at ffffffff8141fff9
     RIP: 00007fbe427e46f0  RSP: 00007fff47fde6b8  RFLAGS: 00010246
     RAX: 0000000000000001  RBX: ffffffff8141fff9  RCX: 0000000000000000
     RDX: 0000000000017777  RSI: 00007fbe3c000d10  RDI: 0000000000000003
     RBP: 0000000000017777   R8: 0000000000000077   R9: 0000000000200000
     R10: 0000000000000000  R11: 0000000000000246  R12: 0000000000000085
     R13: 0000000000000003  R14: 00007fff47fdfa20  R15: 00007fbe3c000d10
     ORIG_RAX: 0000000000000001  CS: 0033  SS: 002b

PID: 20052  TASK: ffff88034ad56080  CPU: 3   COMMAND: "fsstress"
  #0 [ffff88034a88fbb8] __schedule at ffffffff81416e50
     ffff88034a88fbc0: 0000000000000086 ffff88034a88e010
     ffff88034a88fbd0: 0000000000012400 0000000000012400
     ffff88034a88fbe0: 0000000000012400 0000000000012400
     ffff88034a88fbf0: ffff88034a88ffd8 ffff88034a88ffd8
     ffff88034a88fc00: 0000000000012400 ffff88034ad56080
     ffff88034a88fc10: ffff88034fa12580 0000000000000001
     ffff88034a88fc20: ffff88034a88fc60 ffffffff81075faa
     ffff88034a88fc30: ffff88034a88fcd0 ffffffff810017ef
     ffff88034a88fc40: ffff88034ad56080 ffff88034fa12bd8
     ffff88034a88fc50: 000000034a66e288 ffff88035fcd2478
     ffff88034a88fc60: ffff88034a88fc70 ffff88034ad566d8
     ffff88034a88fc70: ffff88034a88fca0 ffffffff81072d2f
     ffff88034a88fc80: ffff88034b65e2c8 ffff88034a88fcc8
     ffff88034a88fc90: ffffffff810732a8 ffff88035fcd2e40
     ffff88034a88fca0: ffff88034b65e2c8 ffff88035fc52478
     ffff88034a88fcb0: 0000000000000001 0000000000000001
     ffff88034a88fcc0: 0000000000000004 ffff88034a88fcf8
     ffff88034a88fcd0: 7fffffffffffffff ffff88034a88fe98
     ffff88034a88fce0: 7fffffffffffffff ffff88034ad56080
     ffff88034a88fcf0: 0000000000000000 ffff88034a88fd08
     ffff88034a88fd00: ffffffff814171c4
  #1 [ffff88034a88fd00] schedule at ffffffff814171c4
     ffff88034a88fd08: ffff88034a88fda8 ffffffff81415455
  #2 [ffff88034a88fd10] schedule_timeout at ffffffff81415455
     ffff88034a88fd18: ffff88035fc52400 0000000000000005
     ffff88034a88fd28: ffff88034a88fd58 ffffffff8106c2a1
     ffff88034a88fd38: ffff88034a88fd58 ffffffff81069895
     ffff88034a88fd48: ffff88035fc52400 ffff88034b65e280
     ffff88034a88fd58: ffff88034a88fd88 ffffffff81069918
     ffff88034a88fd68: ffff88034b65e280 ffff88035fc52400
     ffff88034a88fd78: 0000000000000000 7fffffffffffffff
     ffff88034a88fd88: ffff88034a88fe98 ffff88034a88fea0
     ffff88034a88fd98: ffff88034ad56080 0000000000000000
     ffff88034a88fda8: ffff88034a88fe38 ffffffff814166b7
  #3 [ffff88034a88fdb0] wait_for_common at ffffffff814166b7
     ffff88034a88fdb8: ffff88034a88fe08 ffff88034ad56080
     ffff88034a88fdc8: 0000000200000000 0000000000000002
     ffff88034a88fdd8: 0000000000000001 ffff88034ad56080
     ffff88034a88fde8: ffffffff810702d0 ffff88034a88fea8
     ffff88034a88fdf8: ffff88034a88fea8 0000000000000246
     ffff88034a88fe08: ffff88034a88fe18 ffff88034be7ac00
     ffff88034a88fe18: ffff88034a88fe58 ffff88034a88fe98
     ffff88034a88fe28: ffff88034a88ff6c ffffffff8117a4b0
     ffff88034a88fe38: ffff88034a88fe48 ffffffff81416828
  #4 [ffff88034a88fe40] wait_for_completion at ffffffff81416828
     ffff88034a88fe48: ffff88034a88fed8 ffffffff81174eaa
  #5 [ffff88034a88fe50] sync_inodes_sb at ffffffff81174eaa
     ffff88034a88fe58: 7fffffffffffffff ffff88034be7ac00
     ffff88034a88fe68: ffff88034b84fd90 0000000000000001
     ffff88034a88fe78: 0000000000000002 ffff88034a88fe80
     ffff88034a88fe88: ffff88034a88fe80 ffff88034a88fe98
     ffff88034a88fe98: 0000000000000000 0000000000010001
     ffff88034a88fea8: ffff88034a88fdf0 ffff88034a88fdf0
     ffff88034a88feb8: ffffffff8123fd64 ffff88034be7ac00
     ffff88034a88fec8: 0000000000000001 ffff88034b5a5000
     ffff88034a88fed8: ffff88034a88fef8 ffffffff8117a4a0
  #6 [ffff88034a88fee0] __sync_filesystem at ffffffff8117a4a0
     ffff88034a88fee8: ffff88034be7ac00 ffff88034be7ac68
     ffff88034a88fef8: ffff88034a88ff08 ffffffff8117a4c7
  #7 [ffff88034a88ff00] sync_one_sb at ffffffff8117a4c7
     ffff88034a88ff08: ffff88034a88ff48 ffffffff8115126b
  #8 [ffff88034a88ff10] iterate_supers at ffffffff8115126b
     ffff88034a88ff18: ffff88034a88ff48 ffff88034a88ff6c
     ffff88034a88ff28: 0000000051eb851f 0000000000000003
     ffff88034a88ff38: 0000000000000000 00007fff47fe1c00
     ffff88034a88ff48: ffff88034a88ff78 ffffffff8117a515
  #9 [ffff88034a88ff50] sys_sync at ffffffff8117a515
     ffff88034a88ff58: 0000000000000003 000000000000006c
     ffff88034a88ff68: 0000000100000003 0000000000000072
     ffff88034a88ff78: 0000000000000072 ffffffff8141fff9
#10 [ffff88034a88ff80] system_call_fastpath at ffffffff8141fff9
     RIP: 00007fbe42532fe7  RSP: 00007fff47fde8e8  RFLAGS: 00010246
     RAX: 00000000000000a2  RBX: ffffffff8141fff9  RCX: 0000000000000000
     RDX: 0000000000000073  RSI: 000000003532c506  RDI: 0000000000000072
     RBP: 0000000000000072   R8: 0000000064264f93   R9: 00007fbe3c000078
     R10: 0000000000000000  R11: 0000000000000206  R12: 0000000000000072
     R13: 0000000100000003  R14: 000000000000006c  R15: 0000000000000003
     ORIG_RAX: 00000000000000a2  CS: 0033  SS: 002b

PID: 20089  TASK: ffff88034c5ca340  CPU: 2   COMMAND: "xfs_freeze"
  #0 [ffff88034aaafd18] __schedule at ffffffff81416e50
     ffff88034aaafd20: 0000000000000086 ffff88034aaae010
     ffff88034aaafd30: 0000000000012400 0000000000012400
     ffff88034aaafd40: 0000000000012400 0000000000012400
     ffff88034aaafd50: ffff88034aaaffd8 ffff88034aaaffd8
     ffff88034aaafd60: 0000000000012400 ffff88034c5ca340
     ffff88034aaafd70: ffff88034f9d6440 ffffffff810017ef
     ffff88034aaafd80: ffff88034c5ca340 ffff88034b5f49d8
     ffff88034aaafd90: 000000024b5f43c8 ffff88035fc92478
     ffff88034aaafda0: ffff88034aaafdb0 ffff88034c5ca998
     ffff88034aaafdb0: ffff88034aaafde0 ffffffff81072d2f
     ffff88034aaafdc0: ffff88034e603728 ffff88035fc92478
     ffff88034aaafdd0: ffff88034b5f43c8 ffff88034b5f43c8
     ffff88034aaafde0: ffff88034aaafe20 ffff88034bcfabc0
     ffff88034aaafdf0: ffff88035fc92400 ffff88034bbd3300
     ffff88034aaafe00: ffff88034bcfabc0 ffff88035fc92400
     ffff88034aaafe10: ffff88034b42a4c0 ffff88034aaafee8
     ffff88034aaafe20: 0000000000000000 ffff88034c5ca340
     ffff88034aaafe30: ffff88034c5ca330 ffff88034c5ca808
     ffff88034aaafe40: ffff88034aaafee8 ffff88034c5ca340
     ffff88034aaafe50: ffff88034c5ca340 ffff88034aaafe68
     ffff88034aaafe60: ffffffff814171c4
  #1 [ffff88034aaafe60] schedule at ffffffff814171c4
     ffff88034aaafe68: ffff88034aaafed8 ffffffff81040e39
  #2 [ffff88034aaafe70] do_wait at ffffffff81040e39
     ffff88034aaafe78: ffff88034b5f4380 ffff88034c5ca340
     ffff88034aaafe88: ffff88034c5ca340 ffff88034aaaff10
     ffff88034aaafe98: ffff88034c5ca340 0000000000000000
     ffff88034aaafea8: ffff88034c5ca870 ffffffffffffffea
     ffff88034aaafeb8: 0000000000000004 0000000000000000
     ffff88034aaafec8: 0000000000000000 00007fff7cd9c3c4
     ffff88034aaafed8: ffff88034aaaff78 ffffffff81040f11
  #3 [ffff88034aaafee0] sys_wait4 at ffffffff81040f11
     ffff88034aaafee8: 0000000400000003 0000000000000000
     ffff88034aaafef8: 0000000000000000 00007fff7cd9c3c4
     ffff88034aaaff08: 0000000000000000 ffffffff00000000
     ffff88034aaaff18: ffff88034c5ca340 ffffffff8103f510
     ffff88034aaaff28: ffff88034c1d1a98 ffff88034c1d1a98
     ffff88034aaaff38: 0000000000000000 00000000ffffffff
     ffff88034aaaff48: 00000000ffffffff 0000000000000000
     ffff88034aaaff58: 00000000ffffffff 00000000ffffffff
     ffff88034aaaff68: 0000000000000000 0000000000000000
     ffff88034aaaff78: 00007fff7cd9c3c4 ffffffff8141fff9
  #4 [ffff88034aaaff80] system_call_fastpath at ffffffff8141fff9
     RIP: 00007f9a536bd525  RSP: 00007fff7cd9c390  RFLAGS: 00000246
     RAX: 000000000000003d  RBX: ffffffff8141fff9  RCX: ffffffffffffffff
     RDX: 0000000000000000  RSI: 00007fff7cd9c3c4  RDI: ffffffffffffffff
     RBP: 00007fff7cd9c3c4   R8: 00000000006a33e0   R9: 00000000006a7390
     R10: 0000000000000000  R11: 0000000000000246  R12: 0000000000000000
     R13: 0000000000000000  R14: 00000000ffffffff  R15: 00000000ffffffff
     ORIG_RAX: 000000000000003d  CS: 0033  SS: 002b

PID: 20093  TASK: ffff88034b42a4c0  CPU: 1   COMMAND: "xfs_io"
  #0 [ffff88034c3abc98] __schedule at ffffffff81416e50
     ffff88034c3abca0: 0000000000000086 ffff88034c3aa010
     ffff88034c3abcb0: 0000000000012400 0000000000012400
     ffff88034c3abcc0: 0000000000012400 0000000000012400
     ffff88034c3abcd0: ffff88034c3abfd8 ffff88034c3abfd8
     ffff88034c3abce0: 0000000000012400 ffff88034b42a4c0
     ffff88034c3abcf0: ffff88034f99c300 ffff88034ddfd4d0
     ffff88034c3abd00: 00007f7d13560900 000000004c3abd38
     ffff88034c3abd10: ffffea000b862d18 0000000000000000
     ffff88034c3abd20: 000000004c3413f8 0000000000000200
     ffff88034c3abd30: ffff88034ae85b00 ffff880300000028
     ffff88034c3abd40: 0000000000000079 00007f7d13560000
     ffff88034c3abd50: ffffea000bcf5218 ffffea000b84ded0
     ffff88034c3abd60: 0000000000000000 0000000000000000
     ffff88034c3abd70: ffff88034c341978 ffff88034ae85b00
     ffff88034c3abd80: 0000000000000028 ffff88034c3abdf8
     ffff88034c3abd90: ffffffff811166c2 0000000000000000
     ffff88034c3abda0: ffff88034f4e70e8 ffff88034c3abde8
     ffff88034c3abdb0: 0000000000000002 ffff88034b42a4c0
     ffff88034c3abdc0: ffff88034be7ac68 ffff88034be7ac70
     ffff88034c3abdd0: ffffffffffffffff ffff88034c3abde8
     ffff88034c3abde0: ffffffff814171c4
  #1 [ffff88034c3abde0] schedule at ffffffff814171c4
     ffff88034c3abde8: ffff88034c3abe58 ffffffff81417de5
  #2 [ffff88034c3abdf0] rwsem_down_failed_common at ffffffff81417de5
     ffff88034c3abdf8: ffff88034be7ac78 ffff88034be7ac78
     ffff88034c3abe08: ffff88034b42a4c0 ffff880300000002
     ffff88034c3abe18: 00007f7d13560900 0000000000000000
     ffff88034c3abe28: ffff88034c3abf58 ffff88034be7ac00
     ffff88034c3abe38: 00007fffb132ee7c ffff88034be7ac68
     ffff88034c3abe48: 0000000000000003 00000000c0045878
     ffff88034c3abe58: ffff88034c3abe68 ffffffff81417e93
  #3 [ffff88034c3abe60] rwsem_down_write_failed at ffffffff81417e93
     ffff88034c3abe68: ffff88034c3abeb8 ffffffff8123fd93
  #4 [ffff88034c3abe70] call_rwsem_down_write_failed at ffffffff8123fd93
     ffff88034c3abe78: 0000000000000246 00007f7d135fef30
     ffff88034c3abe88: 000000000000000f 0000000000000003
     ffff88034c3abe98: 0000000000000015 ffff88035f054c00
     ffff88034c3abea8: ffff88034be7ac68 ffffffff81416110
  #5 [ffff88034c3abeb0] down_write at ffffffff81416110
     ffff88034c3abeb8: ffff88034c3abee8 ffffffff81150343
  #6 [ffff88034c3abec0] thaw_super at ffffffff81150343
     ffff88034c3abec8: 0000000000000000 ffff88034be7ac00
     ffff88034c3abed8: 00007fffb132ee7c 00007fffb132ee7c
     ffff88034c3abee8: ffff88034c3abf28 ffffffff8115efb8
  #7 [ffff88034c3abef0] do_vfs_ioctl at ffffffff8115efb8
     ffff88034c3abef8: 000000000087f38b 000000000087e00b
     ffff88034c3abf08: 000000000087e00b 0000000000000000
     ffff88034c3abf18: ffff88034bc6e280 00007fffb132ee7c
     ffff88034c3abf28: ffff88034c3abf78 ffffffff8115f139
  #8 [ffff88034c3abf30] sys_ioctl at ffffffff8115f139
     ffff88034c3abf38: 0000000000000000 00007fffb132eeb4
     ffff88034c3abf48: 0000000000000000 0000000000000001
     ffff88034c3abf58: 0000000000402090 000000000061e1d0
     ffff88034c3abf68: 000000000061e2e0 0000000000000000
     ffff88034c3abf78: 000000000061e300 ffffffff8141fff9
  #9 [ffff88034c3abf80] system_call_fastpath at ffffffff8141fff9
     RIP: 00007f7d135b6d07  RSP: 00007fffb132ee58  RFLAGS: 00010202
     RAX: 0000000000000010  RBX: ffffffff8141fff9  RCX: 0000000000776168
     RDX: 00007fffb132ee7c  RSI: ffffffffc0045878  RDI: 0000000000000003
     RBP: 000000000061e300   R8: 000000000000ffff   R9: 000000000000000f
     R10: 00007f7d135fef30  R11: 0000000000000246  R12: 0000000000000000
     R13: 000000000061e2e0  R14: 000000000061e1d0  R15: 0000000000402090
     ORIG_RAX: 0000000000000010  CS: 0033  SS: 002b

PID: 20185  TASK: ffff88034c31c280  CPU: 1   COMMAND: "sync"
  #0 [ffff88034afe7b88] __schedule at ffffffff81416e50
     ffff88034afe7b90: 0000000000000086 ffff88034afe6010
     ffff88034afe7ba0: 0000000000012400 0000000000012400
     ffff88034afe7bb0: 0000000000012400 0000000000012400
     ffff88034afe7bc0: ffff88034afe7fd8 ffff88034afe7fd8
     ffff88034afe7bd0: 0000000000012400 ffff88034c31c280
     ffff88034afe7be0: ffff88034f99c300 ffff880300000028
     ffff88034afe7bf0: 000000000000013a 00007fae7b775000
     ffff88034afe7c00: 000000000bcdeb90 0000000000000000
     ffff88034afe7c10: 0000000100000000 ffff88034a979390
     ffff88034afe7c20: 000100004e702ef8 ffff88034b1e8720
     ffff88034afe7c30: 0000000000000028 ffff88034afe7ca8
     ffff88034afe7c40: ffffffff811166c2 ffff88034afe7c68
     ffff88034afe7c50: ffff88034b65e2c8 ffff88034afe7c98
     ffff88034afe7c60: ffffffff810732a8 ffff88035fc52e40
     ffff88034afe7c70: ffff88034b65e2c8 ffff88035fcd2478
     ffff88034afe7c80: 0000000000000001 0000000000000003
     ffff88034afe7c90: 0000000000000000 ffff88034afe7cc8
     ffff88034afe7ca0: 7fffffffffffffff ffff88034afe7e68
     ffff88034afe7cb0: 7fffffffffffffff ffff88034c31c280
     ffff88034afe7cc0: 0000000000000000 ffff88034afe7cd8
     ffff88034afe7cd0: ffffffff814171c4
  #1 [ffff88034afe7cd0] schedule at ffffffff814171c4
     ffff88034afe7cd8: ffff88034afe7d78 ffffffff81415455
  #2 [ffff88034afe7ce0] schedule_timeout at ffffffff81415455
     ffff88034afe7ce8: ffff88035fcd2400 0000000000000005
     ffff88034afe7cf8: ffff88034afe7d28 ffffffff8106c2a1
     ffff88034afe7d08: ffff88034afe7d28 ffffffff81069895
     ffff88034afe7d18: ffff88035fcd2400 ffff88034b65e280
     ffff88034afe7d28: ffff88034afe7d58 ffffffff81069918
     ffff88034afe7d38: ffff88034b65e280 ffff88035fcd2400
     ffff88034afe7d48: 0000000000000000 7fffffffffffffff
     ffff88034afe7d58: ffff88034afe7e68 ffff88034afe7e70
     ffff88034afe7d68: ffff88034c31c280 0000000000000000
     ffff88034afe7d78: ffff88034afe7e08 ffffffff814166b7
  #3 [ffff88034afe7d80] wait_for_common at ffffffff814166b7
     ffff88034afe7d88: ffff88034afe7dd8 ffff88034c31c280
     ffff88034afe7d98: 0000000200000000 0000000000000002
     ffff88034afe7da8: 0000000000000001 ffff88034c31c280
     ffff88034afe7db8: ffffffff810702d0 ffff88034afe7e78
     ffff88034afe7dc8: ffff88034afe7e78 0000000000000246
     ffff88034afe7dd8: ffff88034afe7de8 ffff88034a4c8000
     ffff88034afe7de8: ffff88034afe7e28 ffff88034afe7e68
     ffff88034afe7df8: 0000000000000000 ffffffff8117a4b0
     ffff88034afe7e08: ffff88034afe7e18 ffffffff81416828
  #4 [ffff88034afe7e10] wait_for_completion at ffffffff81416828
     ffff88034afe7e18: ffff88034afe7ea8 ffffffff81174c69
  #5 [ffff88034afe7e20] writeback_inodes_sb_nr at ffffffff81174c69
     ffff88034afe7e28: 000000000000ecde ffff88034a4c8000
     ffff88034afe7e38: 0000000000000000 0000000100000000
     ffff88034afe7e48: 0000000000000002 ffff88034baaa3d0
     ffff88034afe7e58: ffff88034a637ea8 ffff88034afe7e68
     ffff88034afe7e68: 0000000000000000 0000000000010001
     ffff88034afe7e78: ffff88034afe7dc0 ffff88034afe7dc0
     ffff88034afe7e88: 0000000000000017 0000000000000017
     ffff88034afe7e98: 0000000000000002 ffff88034a4c8000
     ffff88034afe7ea8: ffff88034afe7ed8 ffffffff8117522c
  #6 [ffff88034afe7eb0] writeback_inodes_sb at ffffffff8117522c
     ffff88034afe7eb8: ffff88034a4c8000 0000000000000000
     ffff88034afe7ec8: ffff88034eb38c00 ffff88034afe7f6c
     ffff88034afe7ed8: ffff88034afe7ef8 ffffffff8117a469
  #7 [ffff88034afe7ee0] __sync_filesystem at ffffffff8117a469
     ffff88034afe7ee8: ffff88034a4c8000 ffff88034a4c8068
     ffff88034afe7ef8: ffff88034afe7f08 ffffffff8117a4c7
  #8 [ffff88034afe7f00] sync_one_sb at ffffffff8117a4c7
     ffff88034afe7f08: ffff88034afe7f48 ffffffff8115126b
  #9 [ffff88034afe7f10] iterate_supers at ffffffff8115126b
     ffff88034afe7f18: ffff88034afe7f48 ffff88034afe7f6c
     ffff88034afe7f28: 0000000000401140 00007fffc53f4e70
     ffff88034afe7f38: 0000000000000000 0000000000000000
     ffff88034afe7f48: ffff88034afe7f78 ffffffff8117a4ff
#10 [ffff88034afe7f50] sys_sync at ffffffff8117a4ff
     ffff88034afe7f58: 0000000000000000 0000000000000000
     ffff88034afe7f68: 00000000c53f4e70 00007fffc53f4e78
     ffff88034afe7f78: 0000000000000001 ffffffff8141fff9
#11 [ffff88034afe7f80] system_call_fastpath at ffffffff8141fff9
     RIP: 00007fae7b70bfe7  RSP: 00007fffc53f4d48  RFLAGS: 00010206
     RAX: 00000000000000a2  RBX: ffffffff8141fff9  RCX: 0000000000000000
     RDX: 00007fae7b9a913c  RSI: 0000000000000001  RDI: 0000000000000000
     RBP: 0000000000000001   R8: 00007fae7b773a70   R9: 0000000000000000
     R10: 00007fffc53f4b20  R11: 0000000000000206  R12: 00007fffc53f4e78
     R13: 00000000c53f4e70  R14: 0000000000000000  R15: 0000000000000000
     ORIG_RAX: 00000000000000a2  CS: 0033  SS: 002b

PID: 20110  TASK: ffff88034a4820c0  CPU: 2   COMMAND: "ls"
  #0 [ffff88034a855c78] __schedule at ffffffff81416e50
     ffff88034a855c80: 0000000000000086 ffff88034a854010
     ffff88034a855c90: 0000000000012400 0000000000012400
     ffff88034a855ca0: 0000000000012400 0000000000012400
     ffff88034a855cb0: ffff88034a855fd8 ffff88034a855fd8
     ffff88034a855cc0: 0000000000012400 ffff88034a4820c0
     ffff88034a855cd0: ffff88034f9d6440 ffffea000b3d3f38
     ffff88034a855ce0: ffff88034e3c8d98 0000000000629db8
     ffff88034a855cf0: 8000000336121067 ffff88034a855d08
     ffff88034a855d00: ffffffff810fb108 ffff88034a855d38
     ffff88034a855d10: ffffffff8111ec05 ffff88034ddb2148
     ffff88034a855d20: ffff88034e3c8d98 ffffea000b3d3f38
     ffff88034a855d30: ffff88034ddb2148 ffff88034a855d88
     ffff88034a855d40: ffffffff811113a5 ffffea000b907f20
     ffff88034a855d50: ffff88034b4f54c0 ffffea000b907f20
     ffff88034a855d60: 0000000000000000 0000000000000000
     ffff88034a855d70: ffff88034e3c8d98 ffff88034ddb2148
     ffff88034a855d80: 0000000000000246 ffff88034a855dc8
     ffff88034a855d90: ffff88034f4e7000 ffff88034a855dd8
     ffff88034a855da0: 0000000000000024 ffff88034f4e7000
     ffff88034a855db0: ffff88034a855f38 ffff88034a855dc8
     ffff88034a855dc0: ffffffff814171c4
  #1 [ffff88034a855dc0] schedule at ffffffff814171c4
     ffff88034a855dc8: ffff88034a855e28 ffffffffa0499fb5
  #2 [ffff88034a855dd0] xfs_trans_alloc at ffffffffa0499fb5 [xfs]
     ffff88034a855dd8: 0000000000000000 ffff88034a4820c0
     ffff88034a855de8: ffffffff8105e3e0 ffff88034b84f918
     ffff88034a855df8: ffff88034be7aeb0 ffffffff81116a1d
     ffff88034a855e08: ffff88034a855f28 0000000000000001
     ffff88034a855e18: ffff8802b7822538 ffff8802b7822400
     ffff88034a855e28: ffff88034a855e58 ffffffffa0457aa2
  #3 [ffff88034a855e30] xfs_fs_dirty_inode at ffffffffa0457aa2 [xfs]
     ffff88034a855e38: 0000000000000001 ffff8802b7822538
     ffff88034a855e48: 000000004f872c1b 0000000016880b81
     ffff88034a855e58: ffff88034a855e98 ffffffff811753da
  #4 [ffff88034a855e60] __mark_inode_dirty at ffffffff811753da
     ffff88034a855e68: ffff8802b7822400 ffff8802b7822538
     ffff88034a855e78: ffff88034e3d46a0 000000004f872c1b
     ffff88034a855e88: 0000000016880b81 ffff88034a855f38
     ffff88034a855e98: ffff88034a855ee8 ffffffff811662db
  #5 [ffff88034a855ea0] touch_atime at ffffffff811662db
     ffff88034a855ea8: 000000004f872c1b 0000000016880b81
     ffff88034a855eb8: 000000004f872c1b 0000000016880b81
     ffff88034a855ec8: 0000000000000000 ffff88034be12ac0
     ffff88034a855ed8: ffff8802b7822538 ffffffff8115f5e0
     ffff88034a855ee8: ffff88034a855f28 ffffffff8115f934
  #6 [ffff88034a855ef0] vfs_readdir at ffffffff8115f934
     ffff88034a855ef8: ffff8802b78225d8 0000000000621db8
     ffff88034a855f08: ffff88034be12ac0 0000000000008000
     ffff88034a855f18: 0000000000000000 0000000000621d90
     ffff88034a855f28: ffff88034a855f78 ffffffff8115f9c3
  #7 [ffff88034a855f30] sys_getdents64 at ffffffff8115f9c3
     ffff88034a855f38: 0000000000621e10 0000000000621de8
     ffff88034a855f48: ffffffea00007fa8 ffffffff81418635
     ffff88034a855f58: 0000000000000001 0000000000621d90
     ffff88034a855f68: ffffffffffffff08 00007f2450c587a0
     ffff88034a855f78: 0000000000621db8 ffffffff8141fff9
  #8 [ffff88034a855f80] system_call_fastpath at ffffffff8141fff9
     RIP: 00007f244ff7ad9a  RSP: 00007fffed07c030  RFLAGS: 00010202
     RAX: 00000000000000d9  RBX: ffffffff8141fff9  RCX: 0000000000629db0
     RDX: 0000000000008000  RSI: 0000000000621db8  RDI: 0000000000000003
     RBP: 0000000000621db8   R8: 00007f2450248e80   R9: 00007f2450248ed8
     R10: 00007fffed07bee0  R11: 0000000000000246  R12: 00007f2450c587a0
     R13: ffffffffffffff08  R14: 0000000000621d90  R15: 0000000000000001
     ORIG_RAX: 00000000000000d9  CS: 0033  SS: 002b

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
