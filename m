Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 83DDD7F55
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 12:49:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 23B87AC02B
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 10:49:44 -0700 (PDT)
Received: from mga11.intel.com ([192.55.52.93]) by cuda.sgi.com with ESMTP id
	LNB7PL7Zr2DeKyKK for <xfs@oss.sgi.com>;
	Fri, 02 Oct 2015 10:49:42 -0700 (PDT)
Date: Fri, 2 Oct 2015 11:49:41 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: two failing xfstests using xfs (no DAX)
Message-ID: <20151002174941.GA25082@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="x+6KMIRAuhnl3hBn"
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Recently I've been trying to get a stable baseline for my DAX testing using
various filesystems, and in doing so I noticed a pair of tests that were
behaving badly when run on XFS without DAX.  These test failures happen in
both v4.2 and v4.3-rc3, though the signatures may vary a bit.

My testing setup is a kvm virtual machine with 8 GiB of its 16GiB of memory
reserved for PMEM using the mmap parameter (memmap=8G!8G) and with the
CONFIG_X86_PMEM_LEGACY config option enabled.  I've attached my full kernel
config to this mail.

The first test failure is generic/299, which consistently deadlocks in the XFS
code in both v4.2 and v4.3-rc3.  The stack traces presented in dmesg via "echo
w > /proc/sysrq-trigger" are consistent between these two kernel versions, and
can be found in the "generic_299.deadlock" attachment.

The second test failure is xfs/083, which in v4.2 seems to fail with an XFS
assertion (I have XFS_DEBUG turned on):

XFS: Assertion failed: fs_is_ok, file: fs/xfs/libxfs/xfs_dir2_data.c, line: 168

In v4.3, though, this same test seems to create some random memory corruption
in XFS.  I've hit at least two failure signatures that look nothing alike
except they both look like somebody corrupted memory.

I've attached logs of all three of these failures to this mail.

Because of all the attachments I decided not to spam the fsdevel or
linux-kernel mailing lists - please let me know if this was correct, or if
there is a better way of sending along logs with bug reports.

Thanks,
- Ross

--x+6KMIRAuhnl3hBn
Content-Type: application/x-troff-man
Content-Disposition: attachment; filename="xfs_083_v4.2"
Content-Transfer-Encoding: quoted-printable

[   61.646296] run fstests xfs/083 at 2015-10-02 11:18:43=0A[   61.788054] =
XFS (pmem0p2): Unmounting Filesystem=0A[   61.806414] XFS (pmem0p2): Mounti=
ng V4 Filesystem=0A[   61.807365] XFS (pmem0p2): Ending clean mount=0A[   9=
6.039579] XFS (pmem0p2): Unmounting Filesystem=0A[   96.050021] XFS (pmem0p=
2): Mounting V4 Filesystem=0A[   96.051525] XFS (pmem0p2): Ending clean mou=
nt=0A[   96.091192] XFS (pmem0p2): Unmounting Filesystem=0A[   96.195197] X=
FS (pmem0p2): Mounting V4 Filesystem=0A[   96.195969] XFS (pmem0p2): Ending=
 clean mount=0A[   96.221388] XFS: Assertion failed: fs_is_ok, file: fs/xfs=
/libxfs/xfs_dir2_data.c, line: 168=0A[   96.221403] ------------[ cut here =
]------------=0A[   96.221405] kernel BUG at fs/xfs/xfs_message.c:106!=0A[ =
  96.221406] invalid opcode: 0000 [#1] SMP =0A[   96.221407] Modules linked=
 in: nd_pmem nd_btt=0A[   96.221410] CPU: 2 PID: 430 Comm: kworker/2:2 Not =
tainted 4.2.0 #4=0A[   96.221411] Hardware name: QEMU Standard PC (i440FX +=
 PIIX, 1996), BIOS 1.7.5-20140709_153950- 04/01/2014=0A[   96.221416] Workq=
ueue: xfs-buf/pmem0p2 xfs_buf_ioend_work=0A[   96.221417] task: ffff88040e1=
80000 ti: ffff88040d020000 task.ti: ffff88040d020000=0A[   96.221418] RIP: =
0010:[<ffffffff8141bfc0>]  [<ffffffff8141bfc0>] assfail+0x20/0x30=0A[   96.=
221421] RSP: 0018:ffff88040d023ce8  EFLAGS: 00010246=0A[   96.221421] RAX: =
0000000000000000 RBX: ffff88040fb8a000 RCX: 000000000000004f=0A[   96.22142=
2] RDX: 0000000000000000 RSI: ffff88043fc8ec98 RDI: ffff88043fc8ec98=0A[   =
96.221423] RBP: ffff88040d023ce8 R08: 000000000000000a R09: 000000000000fff=
e=0A[   96.221424] R10: 00000000000002c4 R11: 0000000000000006 R12: ffff880=
1fb951000=0A[   96.221425] R13: 0000000000000000 R14: ffff8801fb951004 R15:=
 ffff8801fb9513a0=0A[   96.221426] FS:  0000000000000000(0000) GS:ffff88043=
fc80000(0000) knlGS:0000000000000000=0A[   96.221427] CS:  0010 DS: 0000 ES=
: 0000 CR0: 0000000080050033=0A[   96.221428] CR2: 0000000000926108 CR3: 00=
0000040e2c3000 CR4: 00000000000406e0=0A[   96.221430] Stack:=0A[   96.22143=
1]  ffff88040d023d78 ffffffff813e33d1 0000000000000370 ffffffff81a4c5c0=0A[=
   96.221433]  0000000700000013 0000000000000000 ffff8801fb952000 ffff88041=
0e93960=0A[   96.221434]  ffff88040d023d58 ffff8800af460d40 ffff88043fc96f8=
0 00000000875e94dd=0A[   96.221436] Call Trace:=0A[   96.221440]  [<fffffff=
f813e33d1>] __xfs_dir3_data_check+0x4b1/0x6e0=0A[   96.221442]  [<ffffffff8=
1404025>] ? xfs_buf_ioend_work+0x15/0x20=0A[   96.221444]  [<ffffffff813e36=
73>] xfs_dir3_data_verify+0x73/0x80=0A[   96.221446]  [<ffffffff813e38f7>] =
xfs_dir3_data_reada_verify+0x77/0x80=0A[   96.221447]  [<ffffffff81403f55>]=
 xfs_buf_ioend+0x85/0x140=0A[   96.221448]  [<ffffffff81404025>] xfs_buf_io=
end_work+0x15/0x20=0A[   96.221451]  [<ffffffff810b626b>] process_one_work+=
0x14b/0x3d0=0A[   96.221453]  [<ffffffff810b682e>] worker_thread+0x4e/0x450=
=0A[   96.221455]  [<ffffffff810b67e0>] ? rescuer_thread+0x2f0/0x2f0=0A[   =
96.221456]  [<ffffffff810b67e0>] ? rescuer_thread+0x2f0/0x2f0=0A[   96.2214=
58]  [<ffffffff810bbc68>] kthread+0xd8/0xf0=0A[   96.221459]  [<ffffffff810=
bbb90>] ? kthread_create_on_node+0x1a0/0x1a0=0A[   96.221463]  [<ffffffff81=
96b71f>] ret_from_fork+0x3f/0x70=0A[   96.221464]  [<ffffffff810bbb90>] ? k=
thread_create_on_node+0x1a0/0x1a0=0A[   96.221465] Code: 66 66 2e 0f 1f 84 =
00 00 00 00 00 66 66 66 66 90 55 48 89 f1 41 89 d0 48 c7 c6 70 37 d0 81 48 =
89 fa 31 ff 48 89 e5 e8 c0 fa ff ff <0f> 0b 66 66 66 66 66 2e 0f 1f 84 00 0=
0 00 00 00 66 66 66 66 90 =0A[   96.221480] RIP  [<ffffffff8141bfc0>] assfa=
il+0x20/0x30=0A[   96.221482]  RSP <ffff88040d023ce8>=0A[   96.221483] ---[=
 end trace 2fb10e14adb739fa ]---=0A[   96.221501] BUG: unable to handle ker=
nel paging request at ffffffffffffffd8=0A[   96.221502] IP: [<ffffffff810bc=
250>] kthread_data+0x10/0x20=0A[   96.221504] PGD 200f067 PUD 2011067 PMD 0=
 =0A[   96.221505] Oops: 0000 [#2] SMP =0A[   96.221506] Modules linked in:=
 nd_pmem nd_btt=0A[   96.221508] CPU: 2 PID: 430 Comm: kworker/2:2 Tainted:=
 G      D         4.2.0 #4=0A[   96.221509] Hardware name: QEMU Standard PC=
 (i440FX + PIIX, 1996), BIOS 1.7.5-20140709_153950- 04/01/2014=0A[   96.221=
514] task: ffff88040e180000 ti: ffff88040d020000 task.ti: ffff88040d020000=
=0A[   96.221515] RIP: 0010:[<ffffffff810bc250>]  [<ffffffff810bc250>] kthr=
ead_data+0x10/0x20=0A[   96.221517] RSP: 0018:ffff88040d023968  EFLAGS: 000=
10096=0A[   96.221518] RAX: 0000000000000000 RBX: 0000000000000002 RCX: 000=
0000000000006=0A[   96.221519] RDX: 0000000000000006 RSI: 0000000000000002 =
RDI: ffff88040e180000=0A[   96.221520] RBP: ffff88040d023968 R08: ffff88040=
e180090 R09: 0000000000000280=0A[   96.221522] R10: ffff88043fc9be00 R11: f=
fffea0002ebc580 R12: 0000000000016f80=0A[   96.221523] R13: ffff88040e18000=
0 R14: 0000000000000002 R15: 0000000000000000=0A[   96.221525] FS:  0000000=
000000000(0000) GS:ffff88043fc80000(0000) knlGS:0000000000000000=0A[   96.2=
21526] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033=0A[   96.221527] C=
R2: 0000000000000028 CR3: 000000040e2c3000 CR4: 00000000000406e0=0A[   96.2=
21528] Stack:=0A[   96.221529]  ffff88040d023988 ffffffff810b6cb5 ffff88040=
d023988 ffff88043fc96f80=0A[   96.221531]  ffff88040d0239d8 ffffffff819673e=
4 ffff8800baf16680 ffff88040e180000=0A[   96.221533]  ffff88040d0239d8 ffff=
88040d024000 ffff88040d023a30 ffff88040d023a30=0A[   96.221535] Call Trace:=
=0A[   96.221537]  [<ffffffff810b6cb5>] wq_worker_sleeping+0x15/0xa0=0A[   =
96.221538]  [<ffffffff819673e4>] __schedule+0x6d4/0x8c0=0A[   96.221540]  [=
<ffffffff81967607>] schedule+0x37/0x80=0A[   96.221542]  [<ffffffff810a0d81=
>] do_exit+0x721/0xa10=0A[   96.221544]  [<ffffffff8101812e>] oops_end+0x9e=
/0xd0=0A[   96.221546]  [<ffffffff8101859b>] die+0x4b/0x70=0A[   96.221548]=
  [<ffffffff81014e49>] do_trap+0x139/0x140=0A[   96.221550]  [<ffffffff8101=
52f8>] do_error_trap+0xa8/0x170=0A[   96.221552]  [<ffffffff8141bfc0>] ? as=
sfail+0x20/0x30=0A[   96.221553]  [<ffffffff81015820>] do_invalid_op+0x20/0=
x30=0A[   96.221554]  [<ffffffff8196cc8e>] invalid_op+0x1e/0x30=0A[   96.22=
1556]  [<ffffffff8141bfc0>] ? assfail+0x20/0x30=0A[   96.221557]  [<fffffff=
f8141bfc0>] ? assfail+0x20/0x30=0A[   96.221559]  [<ffffffff813e33d1>] __xf=
s_dir3_data_check+0x4b1/0x6e0=0A[   96.221560]  [<ffffffff81404025>] ? xfs_=
buf_ioend_work+0x15/0x20=0A[   96.221562]  [<ffffffff813e3673>] xfs_dir3_da=
ta_verify+0x73/0x80=0A[   96.221563]  [<ffffffff813e38f7>] xfs_dir3_data_re=
ada_verify+0x77/0x80=0A[   96.221565]  [<ffffffff81403f55>] xfs_buf_ioend+0=
x85/0x140=0A[   96.221566]  [<ffffffff81404025>] xfs_buf_ioend_work+0x15/0x=
20=0A[   96.221568]  [<ffffffff810b626b>] process_one_work+0x14b/0x3d0=0A[ =
  96.221569]  [<ffffffff810b682e>] worker_thread+0x4e/0x450=0A[   96.221571=
]  [<ffffffff810b67e0>] ? rescuer_thread+0x2f0/0x2f0=0A[   96.221572]  [<ff=
ffffff810b67e0>] ? rescuer_thread+0x2f0/0x2f0=0A[   96.221573]  [<ffffffff8=
10bbc68>] kthread+0xd8/0xf0=0A[   96.221574]  [<ffffffff810bbb90>] ? kthrea=
d_create_on_node+0x1a0/0x1a0=0A[   96.221576]  [<ffffffff8196b71f>] ret_fro=
m_fork+0x3f/0x70=0A[   96.221577]  [<ffffffff810bbb90>] ? kthread_create_on=
_node+0x1a0/0x1a0=0A[   96.221578] Code: c4 08 44 89 e8 5b 41 5c 41 5d 5d c=
3 4c 89 e7 e8 67 f4 fd ff eb 88 0f 1f 44 00 00 66 66 66 66 90 48 8b 87 28 0=
4 00 00 55 48 89 e5 <48> 8b 40 d8 5d c3 66 2e 0f 1f 84 00 00 00 00 00 66 66=
 66 66 90 =0A[   96.221593] RIP  [<ffffffff810bc250>] kthread_data+0x10/0x2=
0=0A[   96.221594]  RSP <ffff88040d023968>=0A[   96.221595] CR2: ffffffffff=
ffffd8=0A[   96.221596] ---[ end trace 2fb10e14adb739fb ]---=0A[   96.22159=
7] Fixing recursive fault but reboot is needed!=0A[  156.232007] INFO: rcu_=
sched detected stalls on CPUs/tasks:=0A[  156.232013] 	2: (0 ticks this GP)=
 idle=3D595/140000000000000/0 softirq=3D7861/7861 fqs=3D249 =0A[  156.23201=
4] 	(detected by 5, t=3D60011 jiffies, g=3D10668, c=3D10667, q=3D0)=0A[  15=
6.232016] Task dump for CPU 2:=0A[  156.232017] kworker/2:2     D ffff88040=
e56cc00     0   430      0 0x00000080=0A[  156.232025]  ffff88043fc96780 00=
00000000000080 ffff88040d023df8 ffffffff81404025=0A[  156.232027]  ffff8804=
0d023e48 ffffffff810b626b ffff88043fc96780 00ff880400000000=0A[  156.232029=
]  0000000000000008 ffff88040e56cc00 ffff88040e56cc30 ffff88043fc96780=0A[ =
 156.232030] Call Trace:=0A[  156.232036]  [<ffffffff81404025>] ? xfs_buf_i=
oend_work+0x15/0x20=0A[  156.232039]  [<ffffffff810b626b>] ? process_one_wo=
rk+0x14b/0x3d0=0A[  156.232041]  [<ffffffff810b682e>] ? worker_thread+0x4e/=
0x450=0A[  156.232043]  [<ffffffff810b67e0>] ? rescuer_thread+0x2f0/0x2f0=
=0A[  156.232044]  [<ffffffff810b67e0>] ? rescuer_thread+0x2f0/0x2f0=0A[  1=
56.232046]  [<ffffffff810bbc68>] ? kthread+0xd8/0xf0=0A[  156.232047]  [<ff=
ffffff810bbb90>] ? kthread_create_on_node+0x1a0/0x1a0=0A[  156.232051]  [<f=
fffffff8196b71f>] ? ret_from_fork+0x3f/0x70=0A[  156.232052]  [<ffffffff810=
bbb90>] ? kthread_create_on_node+0x1a0/0x1a0=0A[  156.232053] rcu_sched kth=
read starved for 59232 jiffies! g10668 c10667 f0x0=0A
--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="xfs_083_v4.3-rc3"

[   53.636917] run fstests xfs/083 at 2015-10-02 11:24:09
[   53.760098] XFS (pmem0p2): Unmounting Filesystem
[   53.779642] XFS (pmem0p2): Mounting V4 Filesystem
[   53.780606] XFS (pmem0p2): Ending clean mount
[   87.506686] XFS (pmem0p2): Unmounting Filesystem
[   87.516433] XFS (pmem0p2): Mounting V4 Filesystem
[   87.519162] XFS (pmem0p2): Ending clean mount
[   87.555099] XFS (pmem0p2): Unmounting Filesystem
[   87.657682] XFS (pmem0p2): Mounting V4 Filesystem
[   87.658598] XFS (pmem0p2): Ending clean mount
[   87.669743] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.669745] XFS (pmem0p2): Unmount and run xfs_repair
[   87.669746] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.669748] ffff8801f9b21000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.669749] ffff8801f9b21010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.669750] ffff8801f9b21020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.669751] ffff8801f9b21030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.669752] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.669754] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.669756] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.669764] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.669765] XFS (pmem0p2): Unmount and run xfs_repair
[   87.669766] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.669767] ffff8801f981e000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.669768] ffff8801f981e010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.669769] ffff8801f981e020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.669769] ffff8801f981e030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.669770] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.669772] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.669773] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.669810] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.669811] XFS (pmem0p2): Unmount and run xfs_repair
[   87.669812] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.669813] ffff8801f981e000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.669814] ffff8801f981e010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.669815] ffff8801f981e020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.669816] ffff8801f981e030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.669817] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.669818] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.669819] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.669864] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.669865] XFS (pmem0p2): Unmount and run xfs_repair
[   87.669866] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.669867] ffff8801f981e000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.669867] ffff8801f981e010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.669868] ffff8801f981e020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.669869] ffff8801f981e030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.669877] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.669878] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.669880] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.669888] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.669889] XFS (pmem0p2): Unmount and run xfs_repair
[   87.669890] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.669891] ffff8801fbaaa000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.669892] ffff8801fbaaa010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.669893] ffff8801fbaaa020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.669893] ffff8801fbaaa030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.669894] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.669896] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.669897] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.669909] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.669910] XFS (pmem0p2): Unmount and run xfs_repair
[   87.669911] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.669912] ffff8801f981e000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.669913] ffff8801f981e010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.669913] ffff8801f981e020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.669914] ffff8801f981e030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.669915] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.669917] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.669918] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.669959] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.669960] XFS (pmem0p2): Unmount and run xfs_repair
[   87.669961] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.669962] ffff8801fbaaa000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.669963] ffff8801fbaaa010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.669963] ffff8801fbaaa020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.669964] ffff8801fbaaa030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.669965] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.669967] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.669968] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.669975] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.669976] XFS (pmem0p2): Unmount and run xfs_repair
[   87.669977] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.669978] ffff8801f981e000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.669978] ffff8801f981e010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.669979] ffff8801f981e020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.669980] ffff8801f981e030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.669981] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.669982] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.669984] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.669995] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.669996] XFS (pmem0p2): Unmount and run xfs_repair
[   87.669996] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.669997] ffff8801fbaaa000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.669998] ffff8801fbaaa010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.669999] ffff8801fbaaa020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.670019] ffff8801fbaaa030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.670020] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.670021] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.670023] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.670075] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.670076] XFS (pmem0p2): Unmount and run xfs_repair
[   87.670077] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.670078] ffff8801f981e000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.670079] ffff8801f981e010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.670080] ffff8801f981e020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.670081] ffff8801f981e030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.670082] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.670084] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.670085] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.670093] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.670094] XFS (pmem0p2): Unmount and run xfs_repair
[   87.670095] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.670096] ffff8801fbaaa000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.670097] ffff8801fbaaa010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.670098] ffff8801fbaaa020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.670099] ffff8801fbaaa030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.670100] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.670101] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.670103] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.670115] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.670116] XFS (pmem0p2): Unmount and run xfs_repair
[   87.670116] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.670118] ffff8801f981e000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.670119] ffff8801f981e010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.670120] ffff8801f981e020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.670121] ffff8801f981e030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.670121] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.670123] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.670125] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.670169] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.670170] XFS (pmem0p2): Unmount and run xfs_repair
[   87.670171] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.670172] ffff8801fbaaa000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.670173] ffff8801fbaaa010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.670174] ffff8801fbaaa020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.670175] ffff8801fbaaa030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.670176] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.670178] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.670179] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.670186] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.670187] XFS (pmem0p2): Unmount and run xfs_repair
[   87.670188] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.670189] ffff8801f981e000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.670190] ffff8801f981e010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.670191] ffff8801f981e020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.670192] ffff8801f981e030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.670193] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.670194] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.670196] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.670216] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.670217] XFS (pmem0p2): Unmount and run xfs_repair
[   87.670219] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.670220] ffff8801fbaaa000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.670221] ffff8801fbaaa010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.670222] ffff8801fbaaa020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.670223] ffff8801fbaaa030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.670223] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.670225] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.670227] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.670269] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.670270] XFS (pmem0p2): Unmount and run xfs_repair
[   87.670271] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.670272] ffff8801fbaaa000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.670273] ffff8801fbaaa010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.670274] ffff8801fbaaa020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.670275] ffff8801fbaaa030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.670276] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.670278] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.670279] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.670287] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.670288] XFS (pmem0p2): Unmount and run xfs_repair
[   87.670289] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.670289] ffff8801fbaa8000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.670290] ffff8801fbaa8010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.670291] ffff8801fbaa8020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.670292] ffff8801fbaa8030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.670293] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.670295] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.670296] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.670307] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.670308] XFS (pmem0p2): Unmount and run xfs_repair
[   87.670309] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.670310] ffff8801fbaaa000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.670311] ffff8801fbaaa010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.670312] ffff8801fbaaa020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.670313] ffff8801fbaaa030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.670314] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.670315] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.670317] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.670356] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.670357] XFS (pmem0p2): Unmount and run xfs_repair
[   87.670358] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.670359] ffff8801fbaa8000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.670360] ffff8801fbaa8010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.670361] ffff8801fbaa8020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.670363] ffff8801fbaa8030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.670364] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.670365] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.670366] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.670373] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.670375] XFS (pmem0p2): Unmount and run xfs_repair
[   87.670375] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.670376] ffff8801fbaaa000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.670377] ffff8801fbaaa010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.670379] ffff8801fbaaa020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.670381] ffff8801fbaaa030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.670382] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.670384] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.670387] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.670402] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.670403] XFS (pmem0p2): Unmount and run xfs_repair
[   87.670404] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.670405] ffff8801fbaa8000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.670406] ffff8801fbaa8010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.670407] ffff8801fbaa8020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.670408] ffff8801fbaa8030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.670409] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.670411] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.670412] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.670454] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.670455] XFS (pmem0p2): Unmount and run xfs_repair
[   87.670456] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.670457] ffff8801fbaa8000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.670458] ffff8801fbaa8010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.670459] ffff8801fbaa8020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.670460] ffff8801fbaa8030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.670461] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.670462] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.670464] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.670471] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.670472] XFS (pmem0p2): Unmount and run xfs_repair
[   87.670473] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.670475] ffff8801fbaa9000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.670476] ffff8801fbaa9010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.670476] ffff8801fbaa9020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.670477] ffff8801fbaa9030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.670478] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.670480] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.670481] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.670492] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.670493] XFS (pmem0p2): Unmount and run xfs_repair
[   87.670494] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.670496] ffff8801fbaa8000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.670497] ffff8801fbaa8010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.670498] ffff8801fbaa8020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.670499] ffff8801fbaa8030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.670500] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.670501] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.670503] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.670556] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.670557] XFS (pmem0p2): Unmount and run xfs_repair
[   87.670558] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.670559] ffff8801fbaa9000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.670560] ffff8801fbaa9010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.670561] ffff8801fbaa9020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.670562] ffff8801fbaa9030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.670563] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.670565] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.670566] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.670573] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.670575] XFS (pmem0p2): Unmount and run xfs_repair
[   87.670575] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.670576] ffff8801fbaa8000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.670577] ffff8801fbaa8010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.670578] ffff8801fbaa8020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.670579] ffff8801fbaa8030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.670581] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.670582] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.670583] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.670602] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.670604] XFS (pmem0p2): Unmount and run xfs_repair
[   87.670605] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.670606] ffff8801fbaa9000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.670607] ffff8801fbaa9010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.670607] ffff8801fbaa9020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.670609] ffff8801fbaa9030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.670610] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.670611] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.670613] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.670654] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.670655] XFS (pmem0p2): Unmount and run xfs_repair
[   87.670656] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.670657] ffff8801fbaa9000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.670659] ffff8801fbaa9010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.670659] ffff8801fbaa9020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.670660] ffff8801fbaa9030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.670661] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.670663] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.670664] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.670671] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.670672] XFS (pmem0p2): Unmount and run xfs_repair
[   87.670673] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.670674] ffff88040e07f000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.670675] ffff88040e07f010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.670676] ffff88040e07f020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.670677] ffff88040e07f030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.670678] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.670679] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.670681] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.670692] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.670693] XFS (pmem0p2): Unmount and run xfs_repair
[   87.670694] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.670695] ffff8801fbaa9000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.670696] ffff8801fbaa9010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.670697] ffff8801fbaa9020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.670698] ffff8801fbaa9030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.670699] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.670700] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.670701] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.670742] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.670743] XFS (pmem0p2): Unmount and run xfs_repair
[   87.670744] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.670745] ffff8801fbaa9000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.670746] ffff8801fbaa9010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.670746] ffff8801fbaa9020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.670747] ffff8801fbaa9030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.670748] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.670750] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.670751] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.670758] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.670759] XFS (pmem0p2): Unmount and run xfs_repair
[   87.670759] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.670760] ffff8801fb9f0000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.670761] ffff8801fb9f0010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.670762] ffff8801fb9f0020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.670763] ffff8801fb9f0030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.670764] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.670765] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.670766] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.670777] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.670778] XFS (pmem0p2): Unmount and run xfs_repair
[   87.670779] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.670780] ffff8801fbaa9000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.670780] ffff8801fbaa9010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.670781] ffff8801fbaa9020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.670782] ffff8801fbaa9030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.670783] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.670785] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.670786] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.670825] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.670826] XFS (pmem0p2): Unmount and run xfs_repair
[   87.670827] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.670828] ffff8801fb9f0000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.670829] ffff8801fb9f0010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.670830] ffff8801fb9f0020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.670830] ffff8801fb9f0030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.670831] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.670833] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.670834] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.670841] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.670842] XFS (pmem0p2): Unmount and run xfs_repair
[   87.670843] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.670843] ffff8801fbaa9000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.670844] ffff8801fbaa9010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.670845] ffff8801fbaa9020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.670846] ffff8801fbaa9030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.670847] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.670848] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.670850] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.670860] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.670861] XFS (pmem0p2): Unmount and run xfs_repair
[   87.670862] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.670863] ffff8801fb9f0000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.670864] ffff8801fb9f0010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.670865] ffff8801fb9f0020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.670866] ffff8801fb9f0030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.670867] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.670868] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.670869] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.670917] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.670918] XFS (pmem0p2): Unmount and run xfs_repair
[   87.670919] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.670920] ffff8801fbaa9000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.670921] ffff8801fbaa9010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.670922] ffff8801fbaa9020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.670923] ffff8801fbaa9030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.670924] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.670925] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.670927] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.670934] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.670935] XFS (pmem0p2): Unmount and run xfs_repair
[   87.670935] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.670936] ffff8801fb9f0000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.670937] ffff8801fb9f0010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.670938] ffff8801fb9f0020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.670939] ffff8801fb9f0030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.670940] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.670941] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.670942] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.670953] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.670954] XFS (pmem0p2): Unmount and run xfs_repair
[   87.670955] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.670956] ffff8801fbaa9000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.670957] ffff8801fbaa9010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.670958] ffff8801fbaa9020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.670959] ffff8801fbaa9030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.670960] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.670962] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.670963] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.671036] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.671037] XFS (pmem0p2): Unmount and run xfs_repair
[   87.671038] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.671039] ffff8801fbaa9000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.671040] ffff8801fbaa9010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.671041] ffff8801fbaa9020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.671042] ffff8801fbaa9030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.671043] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.671045] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.671046] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.671053] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.671054] XFS (pmem0p2): Unmount and run xfs_repair
[   87.671055] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.671056] ffff88040ed48000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.671057] ffff88040ed48010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.671058] ffff88040ed48020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.671059] ffff88040ed48030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.671060] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.671061] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.671063] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.671083] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.671084] XFS (pmem0p2): Unmount and run xfs_repair
[   87.671085] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.671086] ffff8801fbaa9000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.671087] ffff8801fbaa9010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.671088] ffff8801fbaa9020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.671089] ffff8801fbaa9030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.671090] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.671091] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.671093] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.671137] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.671139] XFS (pmem0p2): Unmount and run xfs_repair
[   87.671140] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.671141] ffff8801fb800000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.671142] ffff8801fb800010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.671142] ffff8801fb800020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.671143] ffff8801fb800030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.671144] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.671146] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.671147] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.671154] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.671156] XFS (pmem0p2): Unmount and run xfs_repair
[   87.671156] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.671157] ffff88040f7f3000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.671158] ffff88040f7f3010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.671159] ffff88040f7f3020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.671160] ffff88040f7f3030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.671161] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.671162] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.671164] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.671175] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.671176] XFS (pmem0p2): Unmount and run xfs_repair
[   87.671177] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.671178] ffff8801fb800000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.671178] ffff8801fb800010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.671179] ffff8801fb800020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.671181] ffff8801fb800030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.671182] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.671183] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.671185] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.671225] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.671226] XFS (pmem0p2): Unmount and run xfs_repair
[   87.671227] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.671229] ffff8801fb800000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.671230] ffff8801fb800010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.671231] ffff8801fb800020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.671232] ffff8801fb800030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.671233] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.671234] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.671235] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.671242] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.671243] XFS (pmem0p2): Unmount and run xfs_repair
[   87.671245] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.671246] ffff88040fac6000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.671247] ffff88040fac6010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.671247] ffff88040fac6020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.671248] ffff88040fac6030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.671249] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.671251] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.671252] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.671262] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.671263] XFS (pmem0p2): Unmount and run xfs_repair
[   87.671264] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.671265] ffff8801fb800000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.671266] ffff8801fb800010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.671267] ffff8801fb800020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.671268] ffff8801fb800030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.671269] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.671270] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.671272] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.671311] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.671312] XFS (pmem0p2): Unmount and run xfs_repair
[   87.671313] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.671314] ffff88040fac6000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.671315] ffff88040fac6010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.671316] ffff88040fac6020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.671317] ffff88040fac6030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.671319] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.671321] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.671323] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.671333] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.671334] XFS (pmem0p2): Unmount and run xfs_repair
[   87.671335] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.671336] ffff8801fb800000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.671337] ffff8801fb800010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.671338] ffff8801fb800020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.671339] ffff8801fb800030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.671340] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.671342] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.671343] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.671355] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.671356] XFS (pmem0p2): Unmount and run xfs_repair
[   87.671356] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.671357] ffff88040fac6000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.671358] ffff88040fac6010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.671360] ffff88040fac6020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.671361] ffff88040fac6030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.671362] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.671363] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.671364] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.671405] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.671406] XFS (pmem0p2): Unmount and run xfs_repair
[   87.671407] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.671408] ffff8801fb800000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.671409] ffff8801fb800010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.671410] ffff8801fb800020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.671411] ffff8801fb800030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.671412] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.671413] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.671415] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.671422] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.671423] XFS (pmem0p2): Unmount and run xfs_repair
[   87.671424] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.671425] ffff88040fac6000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.671426] ffff88040fac6010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.671427] ffff88040fac6020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.671428] ffff88040fac6030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.671429] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.671430] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.671431] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.671442] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.671443] XFS (pmem0p2): Unmount and run xfs_repair
[   87.671444] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.671446] ffff8801fb800000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.671447] ffff8801fb800010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.671448] ffff8801fb800020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.671448] ffff8801fb800030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.671449] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.671451] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.671452] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.671506] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.671508] XFS (pmem0p2): Unmount and run xfs_repair
[   87.671508] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.671509] ffff88040fac5000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.671510] ffff88040fac5010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.671511] ffff88040fac5020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.671512] ffff88040fac5030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.671513] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.671515] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.671516] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.671523] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.671524] XFS (pmem0p2): Unmount and run xfs_repair
[   87.671525] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.671526] ffff88040f115000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.671527] ffff88040f115010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.671528] ffff88040f115020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.671529] ffff88040f115030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.671530] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.671531] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.671533] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.671552] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.671553] XFS (pmem0p2): Unmount and run xfs_repair
[   87.671554] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.671555] ffff88040fac5000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.671556] ffff88040fac5010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.671557] ffff88040fac5020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.671558] ffff88040fac5030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.671559] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.671560] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.671562] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.671604] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.671605] XFS (pmem0p2): Unmount and run xfs_repair
[   87.671606] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.671607] ffff88040f115000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.671608] ffff88040f115010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.671609] ffff88040f115020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.671610] ffff88040f115030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.671611] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.671612] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.671613] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.671620] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.671621] XFS (pmem0p2): Unmount and run xfs_repair
[   87.671622] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.671623] ffff88040fac5000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.671624] ffff88040fac5010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.671625] ffff88040fac5020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.671626] ffff88040fac5030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.671627] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.671628] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.671629] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.671640] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.671642] XFS (pmem0p2): Unmount and run xfs_repair
[   87.671643] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.671644] ffff88040f115000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.671644] ffff88040f115010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.671645] ffff88040f115020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.671646] ffff88040f115030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.671647] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.671649] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.671650] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.671689] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.671690] XFS (pmem0p2): Unmount and run xfs_repair
[   87.671691] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.671692] ffff88040fac5000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.671694] ffff88040fac5010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.671695] ffff88040fac5020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.671696] ffff88040fac5030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.671697] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.671698] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.671699] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.671706] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.671707] XFS (pmem0p2): Unmount and run xfs_repair
[   87.671708] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.671710] ffff88040f115000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.671710] ffff88040f115010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.671711] ffff88040f115020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.671712] ffff88040f115030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.671713] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.671715] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.671716] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.671726] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.671727] XFS (pmem0p2): Unmount and run xfs_repair
[   87.671728] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.671729] ffff88040fac5000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.671730] ffff88040fac5010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.671731] ffff88040fac5020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.671732] ffff88040fac5030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.671733] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.671735] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.671736] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.671777] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.671778] XFS (pmem0p2): Unmount and run xfs_repair
[   87.671779] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.671780] ffff88040fac5000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.671781] ffff88040fac5010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.671782] ffff88040fac5020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.671783] ffff88040fac5030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.671784] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.671785] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.671787] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.671794] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.671795] XFS (pmem0p2): Unmount and run xfs_repair
[   87.671796] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.671797] ffff8801fbab1000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.671798] ffff8801fbab1010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.671799] ffff8801fbab1020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.671800] ffff8801fbab1030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.671800] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.671802] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.671803] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.671814] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.671815] XFS (pmem0p2): Unmount and run xfs_repair
[   87.671816] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.671817] ffff88040fac5000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.671818] ffff88040fac5010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.671819] ffff88040fac5020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.671820] ffff88040fac5030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.671821] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.671822] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.671824] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.671863] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.671864] XFS (pmem0p2): Unmount and run xfs_repair
[   87.671865] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.671866] ffff8801fbab1000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.671867] ffff8801fbab1010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.671868] ffff8801fbab1020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.671869] ffff8801fbab1030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.671877] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.671879] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.671881] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.671890] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.671891] XFS (pmem0p2): Unmount and run xfs_repair
[   87.671891] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.671892] ffff88040fac5000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.671893] ffff88040fac5010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.671895] ffff88040fac5020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.671896] ffff88040fac5030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.671897] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.671898] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.671899] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.671917] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.671918] XFS (pmem0p2): Unmount and run xfs_repair
[   87.671919] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.671920] ffff8801fbab1000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.671921] ffff8801fbab1010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.671922] ffff8801fbab1020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.671923] ffff8801fbab1030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.671924] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.671926] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.671927] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.671973] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.671975] XFS (pmem0p2): Unmount and run xfs_repair
[   87.671975] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.671976] ffff8801fbab1000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.671977] ffff8801fbab1010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.671978] ffff8801fbab1020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.671979] ffff8801fbab1030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.671980] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.671982] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.671983] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.671990] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.671991] XFS (pmem0p2): Unmount and run xfs_repair
[   87.671992] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.671993] ffff88040fac4000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.671994] ffff88040fac4010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.671995] ffff88040fac4020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.671996] ffff88040fac4030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.671997] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.671998] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.672002] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.672036] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.672038] XFS (pmem0p2): Unmount and run xfs_repair
[   87.672038] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.672039] ffff8801fbab1000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.672040] ffff8801fbab1010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.672041] ffff8801fbab1020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.672042] ffff8801fbab1030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.672043] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.672044] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.672046] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.672087] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.672088] XFS (pmem0p2): Unmount and run xfs_repair
[   87.672089] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.672090] ffff88040fac4000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.672091] ffff88040fac4010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.672092] ffff88040fac4020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.672093] ffff88040fac4030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.672094] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.672096] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.672097] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.672104] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.672105] XFS (pmem0p2): Unmount and run xfs_repair
[   87.672106] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.672107] ffff8801fbab1000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.672108] ffff8801fbab1010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.672108] ffff8801fbab1020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.672109] ffff8801fbab1030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.672110] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.672112] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.672113] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.672124] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.672126] XFS (pmem0p2): Unmount and run xfs_repair
[   87.672127] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.672129] ffff88040fac4000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.672130] ffff88040fac4010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.672131] ffff88040fac4020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.672133] ffff88040fac4030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.672134] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.672137] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.672140] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.672183] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.672184] XFS (pmem0p2): Unmount and run xfs_repair
[   87.672185] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.672186] ffff8801fbab1000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.672187] ffff8801fbab1010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.672188] ffff8801fbab1020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.672189] ffff8801fbab1030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.672190] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.672191] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.672193] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.672200] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.672200] XFS (pmem0p2): Unmount and run xfs_repair
[   87.672201] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.672202] ffff88040fac4000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.672203] ffff88040fac4010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.672204] ffff88040fac4020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.672205] ffff88040fac4030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.672206] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.672208] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.672209] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.672221] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.672225] XFS (pmem0p2): Unmount and run xfs_repair
[   87.672226] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.672227] ffff8801fbab1000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.672228] ffff8801fbab1010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.672228] ffff8801fbab1020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.672229] ffff8801fbab1030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.672230] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.672232] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.672233] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.672278] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.672279] XFS (pmem0p2): Unmount and run xfs_repair
[   87.672280] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.672281] ffff88040f116000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.672282] ffff88040f116010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.672283] ffff88040f116020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.672284] ffff88040f116030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.672285] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.672286] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.672288] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.672295] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.672296] XFS (pmem0p2): Unmount and run xfs_repair
[   87.672296] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.672298] ffff88040f7f1000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.672299] ffff88040f7f1010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.672300] ffff88040f7f1020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.672301] ffff88040f7f1030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.672302] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.672303] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.672304] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.672315] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.672316] XFS (pmem0p2): Unmount and run xfs_repair
[   87.672317] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.672318] ffff88040f116000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.672319] ffff88040f116010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.672320] ffff88040f116020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.672321] ffff88040f116030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.672322] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.672324] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.672325] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.672379] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.672380] XFS (pmem0p2): Unmount and run xfs_repair
[   87.672381] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.672382] ffff88040f116000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.672383] ffff88040f116010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.672384] ffff88040f116020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.672385] ffff88040f116030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.672386] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.672387] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.672389] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.672396] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.672397] XFS (pmem0p2): Unmount and run xfs_repair
[   87.672398] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.672399] ffff88040f12e000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.672400] ffff88040f12e010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.672401] ffff88040f12e020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.672402] ffff88040f12e030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.672403] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.672404] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.672405] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.672424] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.672425] XFS (pmem0p2): Unmount and run xfs_repair
[   87.672426] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.672428] ffff88040f116000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.672429] ffff88040f116010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.672430] ffff88040f116020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.672430] ffff88040f116030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.672431] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.672433] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.672434] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.672479] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.672481] XFS (pmem0p2): Unmount and run xfs_repair
[   87.672483] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.672485] ffff88040f12e000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.672486] ffff88040f12e010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.672487] ffff88040f12e020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.672488] ffff88040f12e030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.672490] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.672492] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.672494] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.672504] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.672506] XFS (pmem0p2): Unmount and run xfs_repair
[   87.672507] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.672508] ffff88040f116000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.672509] ffff88040f116010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.672511] ffff88040f116020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.672513] ffff88040f116030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.672515] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.672517] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.672519] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.672537] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.672539] XFS (pmem0p2): Unmount and run xfs_repair
[   87.672540] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.672541] ffff88040f12e000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.672542] ffff88040f12e010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.672542] ffff88040f12e020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.672543] ffff88040f12e030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.672545] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.672546] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.672547] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.672590] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.672592] XFS (pmem0p2): Unmount and run xfs_repair
[   87.672593] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.672594] ffff88040f116000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.672596] ffff88040f116010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.672597] ffff88040f116020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.672599] ffff88040f116030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.672600] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.672602] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.672604] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.672617] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.672618] XFS (pmem0p2): Unmount and run xfs_repair
[   87.672619] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.672621] ffff88040f12e000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.672623] ffff88040f12e010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.672624] ffff88040f12e020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.672626] ffff88040f12e030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.672628] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.672630] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.672632] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.672649] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.672650] XFS (pmem0p2): Unmount and run xfs_repair
[   87.672652] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.672653] ffff88040f116000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.672653] ffff88040f116010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.672654] ffff88040f116020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.672655] ffff88040f116030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.672656] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.672658] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.672659] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.672704] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.672705] XFS (pmem0p2): Unmount and run xfs_repair
[   87.672705] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.672706] ffff88040d3f3000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.672707] ffff88040d3f3010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.672709] ffff88040d3f3020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.672710] ffff88040d3f3030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.672711] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.672712] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.672713] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.672721] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.672721] XFS (pmem0p2): Unmount and run xfs_repair
[   87.672722] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.672723] ffff88040f12e000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.672724] ffff88040f12e010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.672725] ffff88040f12e020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.672726] ffff88040f12e030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.672727] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.672729] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.672730] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.672741] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.672742] XFS (pmem0p2): Unmount and run xfs_repair
[   87.672743] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.672744] ffff88040d3f3000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.672745] ffff88040d3f3010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.672746] ffff88040d3f3020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.672747] ffff88040d3f3030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.672748] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.672749] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.672750] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.672790] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.672791] XFS (pmem0p2): Unmount and run xfs_repair
[   87.672792] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.672793] ffff88040f12e000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.672794] ffff88040f12e010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.672795] ffff88040f12e020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.672796] ffff88040f12e030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.672797] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.672798] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.672800] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.672806] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.672807] XFS (pmem0p2): Unmount and run xfs_repair
[   87.672808] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.672809] ffff88040d3f3000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.672810] ffff88040d3f3010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.672811] ffff88040d3f3020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.672812] ffff88040d3f3030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.672813] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.672815] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.672816] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.672826] XFS (pmem0p2): Metadata corruption detected at xfs_inode_buf_verify+0x86/0x150, block 0x480080
[   87.672827] XFS (pmem0p2): Unmount and run xfs_repair
[   87.672828] XFS (pmem0p2): First 64 bytes of corrupted metadata buffer:
[   87.672829] ffff88040f12e000: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[   87.672830] ffff88040f12e010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[   87.672831] ffff88040f12e020: 56 0e bd ba 06 0b a0 a2 56 0e bd ba 06 0b a0 a2  V.......V.......
[   87.672832] ffff88040f12e030: 56 0e bd ba 06 0b a0 a2 00 00 00 00 00 00 00 06  V...............
[   87.672833] XFS (pmem0p2): bad inode magic/vsn daddr 4718720 #23 (magic=907d)
[   87.672835] XFS (pmem0p2): metadata I/O error: block 0x480080 ("xfs_trans_read_buf_map") error 117 numblks 16
[   87.672836] XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
[   87.685900] XFS (pmem0p2): Invalid inode number 0xf56842a6bf
[   87.685905] XFS (pmem0p2): Internal error xfs_dir_ino_validate at line 216 of file fs/xfs/libxfs/xfs_dir2.c.  Caller __xfs_dir3_data_check+0x365/0x6e0
[   87.685907] CPU: 3 PID: 135 Comm: kworker/3:1 Not tainted 4.3.0-rc3 #16
[   87.685908] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140709_153950- 04/01/2014
[   87.685911] Workqueue: xfs-buf/pmem0p2 xfs_buf_ioend_work
[   87.685912]  0000000000000000 0000000039040314 ffff88003695fcb0 ffffffff814def5f
[   87.685914]  ffff8801fbbad000 ffff88003695fcc8 ffffffff8140affc ffffffff813e73b5
[   87.685915]  ffff88003695fce8 ffffffff813e40bb ffff8801fbbad000 ffff8800bb36b000
[   87.685917] Call Trace:
[   87.685922]  [<ffffffff814def5f>] dump_stack+0x44/0x55
[   87.685924]  [<ffffffff8140affc>] xfs_error_report+0x3c/0x40
[   87.685925]  [<ffffffff813e73b5>] ? __xfs_dir3_data_check+0x365/0x6e0
[   87.685927]  [<ffffffff813e40bb>] xfs_dir_ino_validate+0xab/0x110
[   87.685928]  [<ffffffff813e73b5>] __xfs_dir3_data_check+0x365/0x6e0
[   87.685930]  [<ffffffff81407f15>] ? xfs_buf_ioend_work+0x15/0x20
[   87.685932]  [<ffffffff813e77a6>] xfs_dir3_data_verify+0x76/0x80
[   87.685933]  [<ffffffff813e78f4>] xfs_dir3_data_read_verify+0x44/0x100
[   87.685934]  [<ffffffff81407f15>] ? xfs_buf_ioend_work+0x15/0x20
[   87.685936]  [<ffffffff813e7a26>] xfs_dir3_data_reada_verify+0x76/0x80
[   87.685937]  [<ffffffff81407e45>] xfs_buf_ioend+0x85/0x140
[   87.685938]  [<ffffffff81407f15>] xfs_buf_ioend_work+0x15/0x20
[   87.685942]  [<ffffffff810b6ccb>] process_one_work+0x14b/0x3d0
[   87.685943]  [<ffffffff810b76fe>] worker_thread+0x4e/0x450
[   87.685946]  [<ffffffff8195cf34>] ? __schedule+0x2a4/0x8f0
[   87.685947]  [<ffffffff810b76b0>] ? rescuer_thread+0x2f0/0x2f0
[   87.685948]  [<ffffffff810b76b0>] ? rescuer_thread+0x2f0/0x2f0
[   87.685950]  [<ffffffff810bca68>] kthread+0xd8/0xf0
[   87.685951]  [<ffffffff810bc990>] ? kthread_park+0x60/0x60
[   87.685953]  [<ffffffff8196165f>] ret_from_fork+0x3f/0x70
[   87.685955]  [<ffffffff810bc990>] ? kthread_park+0x60/0x60
[   87.685956] XFS: Assertion failed: fs_is_ok, file: fs/xfs/libxfs/xfs_dir2_data.c, line: 165
[   87.685970] ------------[ cut here ]------------
[   87.685971] kernel BUG at fs/xfs/xfs_message.c:106!
[   87.685972] invalid opcode: 0000 [#1] SMP 
[   87.685973] Modules linked in: nd_pmem nd_btt nd_e820 libnvdimm
[   87.685976] CPU: 3 PID: 135 Comm: kworker/3:1 Not tainted 4.3.0-rc3 #16
[   87.685977] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140709_153950- 04/01/2014
[   87.685978] Workqueue: xfs-buf/pmem0p2 xfs_buf_ioend_work
[   87.685979] task: ffff880036948d40 ti: ffff88003695c000 task.ti: ffff88003695c000
[   87.685980] RIP: 0010:[<ffffffff81420100>]  [<ffffffff81420100>] assfail+0x20/0x30
[   87.685982] RSP: 0018:ffff88003695fce8  EFLAGS: 00010246
[   87.685983] RAX: 0000000000000000 RBX: ffff8801fbbad000 RCX: 000000000000004f
[   87.685984] RDX: 0000000000000000 RSI: 0000000000000246 RDI: ffff88043fcce110
[   87.685985] RBP: ffff88003695fce8 R08: 000000000000000a R09: 000000000000fffe
[   87.685985] R10: 00000000000400be R11: 0000000000000002 R12: ffff8800bb36b000
[   87.685986] R13: 0000000000000000 R14: ffff8800bb36b004 R15: ffff8800bb36bb50
[   87.685987] FS:  0000000000000000(0000) GS:ffff88043fcc0000(0000) knlGS:0000000000000000
[   87.685988] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   87.685989] CR2: 0000000001090108 CR3: 00000000babeb000 CR4: 00000000000406e0
[   87.685992] Stack:
[   87.685992]  ffff88003695fd68 ffffffff813e73d5 0000000000000b20 ffffffff81a4dd00
[   87.685994]  000000070000003c 0000000000000000 ffff8800bb36c000 ffff8800bac52c80
[   87.685995]  ffff88043fcd74f8 ffff88003695fd88 0000000039040314 ffff8800af5a0a80
[   87.685997] Call Trace:
[   87.685999]  [<ffffffff813e73d5>] __xfs_dir3_data_check+0x385/0x6e0
[   87.686002]  [<ffffffff81407f15>] ? xfs_buf_ioend_work+0x15/0x20
[   87.686004]  [<ffffffff813e77a6>] xfs_dir3_data_verify+0x76/0x80
[   87.686006]  [<ffffffff813e78f4>] xfs_dir3_data_read_verify+0x44/0x100
[   87.686006]  [<ffffffff81407f15>] ? xfs_buf_ioend_work+0x15/0x20
[   87.686006]  [<ffffffff813e7a26>] xfs_dir3_data_reada_verify+0x76/0x80
[   87.686006]  [<ffffffff81407e45>] xfs_buf_ioend+0x85/0x140
[   87.686006]  [<ffffffff81407f15>] xfs_buf_ioend_work+0x15/0x20
[   87.686006]  [<ffffffff810b6ccb>] process_one_work+0x14b/0x3d0
[   87.686006]  [<ffffffff810b76fe>] worker_thread+0x4e/0x450
[   87.686006]  [<ffffffff8195cf34>] ? __schedule+0x2a4/0x8f0
[   87.686006]  [<ffffffff810b76b0>] ? rescuer_thread+0x2f0/0x2f0
[   87.686006]  [<ffffffff810b76b0>] ? rescuer_thread+0x2f0/0x2f0
[   87.686006]  [<ffffffff810bca68>] kthread+0xd8/0xf0
[   87.686006]  [<ffffffff810bc990>] ? kthread_park+0x60/0x60
[   87.686006]  [<ffffffff8196165f>] ret_from_fork+0x3f/0x70
[   87.686006]  [<ffffffff810bc990>] ? kthread_park+0x60/0x60
[   87.686006] Code: 66 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55 48 89 f1 41 89 d0 48 c7 c6 f0 7b d0 81 48 89 fa 31 ff 48 89 e5 e8 30 fa ff ff <0f> 0b 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 
[   87.686006] RIP  [<ffffffff81420100>] assfail+0x20/0x30
[   87.686006]  RSP <ffff88003695fce8>
[   87.686054] ---[ end trace 974f0659d1414622 ]---
[   87.686071] BUG: unable to handle kernel paging request at ffffffffffffffd8
[   87.686073] IP: [<ffffffff810bd220>] kthread_data+0x10/0x20
[   87.686075] PGD 200f067 PUD 2011067 PMD 0 
[   87.686077] Oops: 0000 [#2] SMP 
[   87.686077] Modules linked in: nd_pmem nd_btt nd_e820 libnvdimm
[   87.686080] CPU: 3 PID: 135 Comm: kworker/3:1 Tainted: G      D         4.3.0-rc3 #16
[   87.686081] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140709_153950- 04/01/2014
[   87.686087] task: ffff880036948d40 ti: ffff88003695c000 task.ti: ffff88003695c000
[   87.686088] RIP: 0010:[<ffffffff810bd220>]  [<ffffffff810bd220>] kthread_data+0x10/0x20
[   87.686090] RSP: 0018:ffff88003695f9c0  EFLAGS: 00010002
[   87.686091] RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000003
[   87.686092] RDX: ffff88041a004000 RSI: 0000000000000003 RDI: ffff880036948d40
[   87.686092] RBP: ffff88003695f9c0 R08: ffff880036948dc8 R09: 0000000000000246
[   87.686093] R10: ffff88043fcdafd0 R11: 0000000000000000 R12: 0000000000017480
[   87.686094] R13: ffff880036948d40 R14: 0000000000000003 R15: 0000000000000000
[   87.686095] FS:  0000000000000000(0000) GS:ffff88043fcc0000(0000) knlGS:0000000000000000
[   87.686096] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   87.686097] CR2: 0000000000000028 CR3: 00000000babeb000 CR4: 00000000000406e0
[   87.686099] Stack:
[   87.686099]  ffff88003695f9d8 ffffffff810b7d41 ffff88043fcd7480 ffff88003695fa20
[   87.686101]  ffffffff8195d364 ffffffff810a07b5 ffff880036948d40 ffff880036960000
[   87.686102]  ffff88003695fa70 ffff88003695fa70 ffff88003695f6d0 ffff88003695f6d0
[   87.686104] Call Trace:
[   87.686105]  [<ffffffff810b7d41>] wq_worker_sleeping+0x11/0x90
[   87.686107]  [<ffffffff8195d364>] __schedule+0x6d4/0x8f0
[   87.686108]  [<ffffffff810a07b5>] ? release_task+0x385/0x470
[   87.686110]  [<ffffffff8195d5b3>] schedule+0x33/0x80
[   87.686111]  [<ffffffff810a2011>] do_exit+0x721/0xa10
[   87.686114]  [<ffffffff8101896a>] oops_end+0x9a/0xd0
[   87.686115]  [<ffffffff81018ddb>] die+0x4b/0x70
[   87.686118]  [<ffffffff81015f19>] do_trap+0x139/0x140
[   87.686119]  [<ffffffff81016639>] do_error_trap+0x89/0x110
[   87.686120]  [<ffffffff81420100>] ? assfail+0x20/0x30
[   87.686122]  [<ffffffff810167f0>] do_invalid_op+0x20/0x30
[   87.686123]  [<ffffffff81962e9e>] invalid_op+0x1e/0x30
[   87.686124]  [<ffffffff81420100>] ? assfail+0x20/0x30
[   87.686126]  [<ffffffff81420100>] ? assfail+0x20/0x30
[   87.686127]  [<ffffffff813e73d5>] __xfs_dir3_data_check+0x385/0x6e0
[   87.686129]  [<ffffffff81407f15>] ? xfs_buf_ioend_work+0x15/0x20
[   87.686131]  [<ffffffff813e77a6>] xfs_dir3_data_verify+0x76/0x80
[   87.686133]  [<ffffffff813e78f4>] xfs_dir3_data_read_verify+0x44/0x100
[   87.686134]  [<ffffffff81407f15>] ? xfs_buf_ioend_work+0x15/0x20
[   87.686135]  [<ffffffff813e7a26>] xfs_dir3_data_reada_verify+0x76/0x80
[   87.686137]  [<ffffffff81407e45>] xfs_buf_ioend+0x85/0x140
[   87.686139]  [<ffffffff81407f15>] xfs_buf_ioend_work+0x15/0x20
[   87.686140]  [<ffffffff810b6ccb>] process_one_work+0x14b/0x3d0
[   87.686142]  [<ffffffff810b76fe>] worker_thread+0x4e/0x450
[   87.686143]  [<ffffffff8195cf34>] ? __schedule+0x2a4/0x8f0
[   87.686144]  [<ffffffff810b76b0>] ? rescuer_thread+0x2f0/0x2f0
[   87.686145]  [<ffffffff810b76b0>] ? rescuer_thread+0x2f0/0x2f0
[   87.686146]  [<ffffffff810bca68>] kthread+0xd8/0xf0
[   87.686148]  [<ffffffff810bc990>] ? kthread_park+0x60/0x60
[   87.686150]  [<ffffffff8196165f>] ret_from_fork+0x3f/0x70
[   87.686151]  [<ffffffff810bc990>] ? kthread_park+0x60/0x60
[   87.686152] Code: 63 20 ba 01 00 00 00 75 c2 48 8b 53 08 eb af e8 57 1b fe ff 0f 1f 80 00 00 00 00 66 66 66 66 90 48 8b 87 18 04 00 00 55 48 89 e5 <48> 8b 40 d8 5d c3 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 
[   87.686168] RIP  [<ffffffff810bd220>] kthread_data+0x10/0x20
[   87.686170]  RSP <ffff88003695f9c0>
[   87.686171] CR2: ffffffffffffffd8
[   87.686172] ---[ end trace 974f0659d1414623 ]---
[   87.686173] Fixing recursive fault but reboot is needed!

--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="xfs_083_v4.3-rc3_trace2"

[ 1207.458454] XFS (pmem0p2): corrupt dinode 8429878, extent total = 5404928, nblocks = 0.
[ 1207.458456] ffff8800ba925600: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[ 1207.458458] ffff8800ba925610: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[ 1207.458459] ffff8800ba925620: 56 0e a7 da 08 20 22 34 56 0e a7 da 08 20 22 34  V.... "4V.... "4
[ 1207.458460] ffff8800ba925630: 56 0e a7 da 08 20 22 34 00 00 00 00 00 00 00 06  V.... "4........
[ 1207.458464] XFS (pmem0p2): Internal error xfs_iformat(1) at line 100 of file fs/xfs/libxfs/xfs_inode_fork.c.  Caller xfs_iread+0x321/0x3e0
[ 1207.458466] CPU: 0 PID: 4237 Comm: find Not tainted 4.3.0-rc3 #16
[ 1207.458467] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140709_153950- 04/01/2014
[ 1207.458468]  0000000000000000 00000000acb7eeb8 ffff8801fb1cfa58 ffffffff814def5f
[ 1207.458470]  ffff8800ae32b800 ffff8801fb1cfa98 ffffffff8140b08c ffffffff813fade1
[ 1207.458471]  ffffffff81d05538 ffff8800ba925600 ffff8800af0de600 ffff8800ae32b800
[ 1207.458473] Call Trace:
[ 1207.458478]  [<ffffffff814def5f>] dump_stack+0x44/0x55
[ 1207.458480]  [<ffffffff8140b08c>] xfs_corruption_error+0x8c/0x90
[ 1207.458481]  [<ffffffff813fade1>] ? xfs_iread+0x321/0x3e0
[ 1207.458483]  [<ffffffff813f9c60>] xfs_iformat_fork+0x360/0x520
[ 1207.458484]  [<ffffffff813fade1>] ? xfs_iread+0x321/0x3e0
[ 1207.458485]  [<ffffffff813fade1>] xfs_iread+0x321/0x3e0
[ 1207.458487]  [<ffffffff8141120b>] xfs_iget+0x28b/0x720
[ 1207.458490]  [<ffffffff813e480c>] ? xfs_dir_lookup+0x13c/0x1d0
[ 1207.458491]  [<ffffffff81419b5a>] xfs_lookup+0xea/0x120
[ 1207.458493]  [<ffffffff81417033>] xfs_vn_lookup+0x73/0xb0
[ 1207.458495]  [<ffffffff8121d22d>] lookup_real+0x1d/0x60
[ 1207.458496]  [<ffffffff8121d5b2>] __lookup_hash+0x42/0x60
[ 1207.458498]  [<ffffffff8121ff4b>] walk_component+0x1eb/0x490
[ 1207.458499]  [<ffffffff81418db5>] ? xfs_iunlock+0x165/0x1c0
[ 1207.458501]  [<ffffffff81231120>] ? __fdget_raw+0x10/0x20
[ 1207.458502]  [<ffffffff8121ec70>] ? path_init+0xc0/0x3c0
[ 1207.458503]  [<ffffffff8122082d>] path_lookupat+0x5d/0x110
[ 1207.458505]  [<ffffffff812231f1>] filename_lookup+0xb1/0x180
[ 1207.458506]  [<ffffffff81418e04>] ? xfs_iunlock+0x1b4/0x1c0
[ 1207.458507]  [<ffffffff811f4013>] ? kmem_cache_alloc+0x183/0x1f0
[ 1207.458509]  [<ffffffff81222df6>] ? getname_flags+0x56/0x1f0
[ 1207.458510]  [<ffffffff81223396>] user_path_at_empty+0x36/0x40
[ 1207.458512]  [<ffffffff81218696>] vfs_fstatat+0x66/0xc0
[ 1207.458513]  [<ffffffff81230e93>] ? __fd_install+0x33/0xe0
[ 1207.458515]  [<ffffffff81218ca4>] SYSC_newfstatat+0x24/0x60
[ 1207.458516]  [<ffffffff8123158e>] ? f_dupfd+0x6e/0x80
[ 1207.458518]  [<ffffffff81225e5b>] ? SyS_fcntl+0x13b/0x550
[ 1207.458519]  [<ffffffff81218ede>] SyS_newfstatat+0xe/0x10
[ 1207.458522]  [<ffffffff819612ee>] entry_SYSCALL_64_fastpath+0x12/0x71
[ 1207.458523] XFS (pmem0p2): Corruption detected. Unmount and run xfs_repair
[ 1207.458524] XFS (pmem0p2): xfs_iread: xfs_iformat() returned error -117
[ 1207.458532] XFS (pmem0p2): corrupt dinode 8429878, extent total = 5404928, nblocks = 0.
[ 1207.458533] ffff8800ba925600: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[ 1207.458534] ffff8800ba925610: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[ 1207.458535] ffff8800ba925620: 56 0e a7 da 08 20 22 34 56 0e a7 da 08 20 22 34  V.... "4V.... "4
[ 1207.458536] ffff8800ba925630: 56 0e a7 da 08 20 22 34 00 00 00 00 00 00 00 06  V.... "4........
[ 1207.458538] XFS (pmem0p2): Internal error xfs_iformat(1) at line 100 of file fs/xfs/libxfs/xfs_inode_fork.c.  Caller xfs_iread+0x321/0x3e0
[ 1207.458539] CPU: 0 PID: 4237 Comm: find Not tainted 4.3.0-rc3 #16
[ 1207.458540] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140709_153950- 04/01/2014
[ 1207.458540]  0000000000000000 00000000acb7eeb8 ffff8801fb1cfa58 ffffffff814def5f
[ 1207.458542]  ffff8800ae32b800 ffff8801fb1cfa98 ffffffff8140b08c ffffffff813fade1
[ 1207.458543]  ffffffff81d05538 ffff8800ba925600 ffff8800af0dea40 ffff8800ae32b800
[ 1207.458544] Call Trace:
[ 1207.458546]  [<ffffffff814def5f>] dump_stack+0x44/0x55
[ 1207.458547]  [<ffffffff8140b08c>] xfs_corruption_error+0x8c/0x90
[ 1207.458549]  [<ffffffff813fade1>] ? xfs_iread+0x321/0x3e0
[ 1207.458550]  [<ffffffff813f9c60>] xfs_iformat_fork+0x360/0x520
[ 1207.458551]  [<ffffffff813fade1>] ? xfs_iread+0x321/0x3e0
[ 1207.458552]  [<ffffffff813fade1>] xfs_iread+0x321/0x3e0
[ 1207.458554]  [<ffffffff8141120b>] xfs_iget+0x28b/0x720
[ 1207.458555]  [<ffffffff813e480c>] ? xfs_dir_lookup+0x13c/0x1d0
[ 1207.458557]  [<ffffffff81419b5a>] xfs_lookup+0xea/0x120
[ 1207.458558]  [<ffffffff81417033>] xfs_vn_lookup+0x73/0xb0
[ 1207.458571]  [<ffffffff8121d22d>] lookup_real+0x1d/0x60
[ 1207.458572]  [<ffffffff8121d5b2>] __lookup_hash+0x42/0x60
[ 1207.458573]  [<ffffffff8121ff4b>] walk_component+0x1eb/0x490
[ 1207.458574]  [<ffffffff81231120>] ? __fdget_raw+0x10/0x20
[ 1207.458575]  [<ffffffff8121ec70>] ? path_init+0xc0/0x3c0
[ 1207.458576]  [<ffffffff8122082d>] path_lookupat+0x5d/0x110
[ 1207.458578]  [<ffffffff812231f1>] filename_lookup+0xb1/0x180
[ 1207.458579]  [<ffffffff81418e04>] ? xfs_iunlock+0x1b4/0x1c0
[ 1207.458580]  [<ffffffff811f4013>] ? kmem_cache_alloc+0x183/0x1f0
[ 1207.458581]  [<ffffffff81222df6>] ? getname_flags+0x56/0x1f0
[ 1207.458582]  [<ffffffff81223396>] user_path_at_empty+0x36/0x40
[ 1207.458583]  [<ffffffff81218696>] vfs_fstatat+0x66/0xc0
[ 1207.458585]  [<ffffffff81230e93>] ? __fd_install+0x33/0xe0
[ 1207.458586]  [<ffffffff81218ca4>] SYSC_newfstatat+0x24/0x60
[ 1207.458587]  [<ffffffff8123158e>] ? f_dupfd+0x6e/0x80
[ 1207.458588]  [<ffffffff81225e5b>] ? SyS_fcntl+0x13b/0x550
[ 1207.458590]  [<ffffffff81218ede>] SyS_newfstatat+0xe/0x10
[ 1207.458591]  [<ffffffff819612ee>] entry_SYSCALL_64_fastpath+0x12/0x71
[ 1207.458592] XFS (pmem0p2): Corruption detected. Unmount and run xfs_repair
[ 1207.458593] XFS (pmem0p2): xfs_iread: xfs_iformat() returned error -117
[ 1207.458626] XFS (pmem0p2): corrupt dinode 8429878, extent total = 5404928, nblocks = 0.
[ 1207.458627] ffff8800ba925600: 49 4e 41 ed 02 01 00 00 00 00 00 00 00 00 00 00  INA.............
[ 1207.458629] ffff8800ba925610: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
[ 1207.458630] ffff8800ba925620: 56 0e a7 da 08 20 22 34 56 0e a7 da 08 20 22 34  V.... "4V.... "4
[ 1207.458631] ffff8800ba925630: 56 0e a7 da 08 20 22 34 00 00 00 00 00 00 00 06  V.... "4........
[ 1207.458634] XFS (pmem0p2): Internal error xfs_iformat(1) at line 100 of file fs/xfs/libxfs/xfs_inode_fork.c.  Caller xfs_iread+0x321/0x3e0
[ 1207.458636] CPU: 0 PID: 4237 Comm: find Not tainted 4.3.0-rc3 #16
[ 1207.458637] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140709_153950- 04/01/2014
[ 1207.458638]  0000000000000000 00000000acb7eeb8 ffff8801fb1cfa58 ffffffff814def5f
[ 1207.458640]  ffff8800ae32b800 ffff8801fb1cfa98 ffffffff8140b08c ffffffff813fade1
[ 1207.458642]  ffffffff81d05538 ffff8800ba925600 ffff8800af0dee80 ffff8800ae32b800
[ 1207.458644] Call Trace:
[ 1207.458647]  [<ffffffff814def5f>] dump_stack+0x44/0x55
[ 1207.458649]  [<ffffffff8140b08c>] xfs_corruption_error+0x8c/0x90
[ 1207.458650]  [<ffffffff813fade1>] ? xfs_iread+0x321/0x3e0
[ 1207.458652]  [<ffffffff813f9c60>] xfs_iformat_fork+0x360/0x520
[ 1207.458654]  [<ffffffff813fade1>] ? xfs_iread+0x321/0x3e0
[ 1207.458656]  [<ffffffff813fade1>] xfs_iread+0x321/0x3e0
[ 1207.458657]  [<ffffffff8141120b>] xfs_iget+0x28b/0x720
[ 1207.458659]  [<ffffffff813e480c>] ? xfs_dir_lookup+0x13c/0x1d0
[ 1207.458660]  [<ffffffff81419b5a>] xfs_lookup+0xea/0x120
[ 1207.458662]  [<ffffffff81417033>] xfs_vn_lookup+0x73/0xb0
[ 1207.458663]  [<ffffffff8121d22d>] lookup_real+0x1d/0x60
[ 1207.458664]  [<ffffffff8121d5b2>] __lookup_hash+0x42/0x60
[ 1207.458665]  [<ffffffff8121ff4b>] walk_component+0x1eb/0x490
[ 1207.458666]  [<ffffffff81231120>] ? __fdget_raw+0x10/0x20
[ 1207.458667]  [<ffffffff8121ec70>] ? path_init+0xc0/0x3c0
[ 1207.458668]  [<ffffffff8122082d>] path_lookupat+0x5d/0x110
[ 1207.458669]  [<ffffffff812231f1>] filename_lookup+0xb1/0x180
[ 1207.458671]  [<ffffffff8122da29>] ? file_update_time+0xc9/0x110
[ 1207.458672]  [<ffffffff811f4013>] ? kmem_cache_alloc+0x183/0x1f0
[ 1207.458673]  [<ffffffff81222df6>] ? getname_flags+0x56/0x1f0
[ 1207.458674]  [<ffffffff81223396>] user_path_at_empty+0x36/0x40
[ 1207.458676]  [<ffffffff81218696>] vfs_fstatat+0x66/0xc0
[ 1207.458677]  [<ffffffff81218ca4>] SYSC_newfstatat+0x24/0x60
[ 1207.458678]  [<ffffffff81213e49>] ? vfs_write+0x149/0x190
[ 1207.458679]  [<ffffffff81214b75>] ? SyS_write+0x55/0xc0
[ 1207.458681]  [<ffffffff81218ede>] SyS_newfstatat+0xe/0x10
[ 1207.458682]  [<ffffffff819612ee>] entry_SYSCALL_64_fastpath+0x12/0x71
[ 1207.458683] XFS (pmem0p2): Corruption detected. Unmount and run xfs_repair
[ 1207.458684] XFS (pmem0p2): xfs_iread: xfs_iformat() returned error -117

--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="generic_299.deadlock"

[ 1501.261288] sysrq: SysRq : Show Blocked State
[ 1501.261292]   task                        PC stack   pid father
[ 1501.261294] kworker/u12:0   D ffff88043fcd7480     0     6      2 0x00000000
[ 1501.261300] Workqueue: writeback wb_workfn (flush-259:0)
[ 1501.261302]  ffff88041121b148 0000000000000046 ffff88041122c240 ffff880411164240
[ 1501.261303]  ffff88041121c000 ffff88040fb5cf30 ffff880411164240 0000000000000008
[ 1501.261305]  ffff8801fcd70010 ffff88041121b160 ffffffff8195ce23 7fffffffffffffff
[ 1501.261306] Call Trace:
[ 1501.261311]  [<ffffffff8195ce23>] schedule+0x33/0x80
[ 1501.261313]  [<ffffffff8195fcfa>] schedule_timeout+0x1fa/0x290
[ 1501.261316]  [<ffffffff810e3f7e>] ? down_trylock+0x2e/0x40
[ 1501.261318]  [<ffffffff8140751c>] ? xfs_buf_trylock+0x1c/0x90
[ 1501.261320]  [<ffffffff8195ecf2>] __down+0x72/0xc0
[ 1501.261321]  [<ffffffff81407847>] ? _xfs_buf_find+0x1d7/0x370
[ 1501.261322]  [<ffffffff810e3fd1>] down+0x41/0x50
[ 1501.261324]  [<ffffffff814075cc>] xfs_buf_lock+0x3c/0xe0
[ 1501.261325]  [<ffffffff81407847>] _xfs_buf_find+0x1d7/0x370
[ 1501.261326]  [<ffffffff81407a7a>] xfs_buf_get_map+0x2a/0x180
[ 1501.261328]  [<ffffffff8140893c>] xfs_buf_read_map+0x2c/0x100
[ 1501.261330]  [<ffffffff8143a435>] xfs_trans_read_buf_map+0x1a5/0x360
[ 1501.261333]  [<ffffffff813bb801>] xfs_read_agf+0xb1/0x140
[ 1501.261334]  [<ffffffff813bb8f4>] xfs_alloc_read_agf+0x64/0x260
[ 1501.261335]  [<ffffffff813bbea1>] xfs_alloc_fix_freelist+0x3b1/0x4d0
[ 1501.261338]  [<ffffffff814e47dd>] ? radix_tree_lookup+0xd/0x10
[ 1501.261340]  [<ffffffff813fb0ba>] ? xfs_perag_get+0x2a/0xc0
[ 1501.261341]  [<ffffffff814e47dd>] ? radix_tree_lookup+0xd/0x10
[ 1501.261342]  [<ffffffff813fb0ba>] ? xfs_perag_get+0x2a/0xc0
[ 1501.261344]  [<ffffffff813bc24d>] xfs_alloc_vextent+0x22d/0x7f0
[ 1501.261345]  [<ffffffff813cef81>] xfs_bmap_btalloc+0x3c1/0x800
[ 1501.261347]  [<ffffffff813f7c15>] ? xfs_iext_get_ext+0x95/0xf0
[ 1501.261349]  [<ffffffff813cf3e4>] xfs_bmap_alloc+0x24/0x30
[ 1501.261350]  [<ffffffff813d0a23>] xfs_bmapi_write+0x6b3/0xf50
[ 1501.261353]  [<ffffffff81416241>] xfs_iomap_write_allocate+0x141/0x330
[ 1501.261355]  [<ffffffff813ff9e5>] xfs_map_blocks+0x255/0x2f0
[ 1501.261357]  [<ffffffff8140083a>] xfs_vm_writepage+0x1aa/0x640
[ 1501.261359]  [<ffffffff811a1e33>] __writepage+0x13/0x30
[ 1501.261361]  [<ffffffff811a40f4>] write_cache_pages+0x224/0x4a0
[ 1501.261363]  [<ffffffff8110476f>] ? mod_timer+0x10f/0x210
[ 1501.261364]  [<ffffffff811a1e20>] ? wb_position_ratio+0x1f0/0x1f0
[ 1501.261366]  [<ffffffff811a43c1>] generic_writepages+0x51/0x80
[ 1501.261367]  [<ffffffff813feefd>] xfs_vm_writepages+0x3d/0x50
[ 1501.261369]  [<ffffffff811a50fe>] do_writepages+0x1e/0x30
[ 1501.261371]  [<ffffffff81240dd5>] __writeback_single_inode+0x45/0x290
[ 1501.261372]  [<ffffffff81241544>] writeback_sb_inodes+0x264/0x4d0
[ 1501.261374]  [<ffffffff81241a36>] wb_writeback+0x106/0x2a0
[ 1501.261376]  [<ffffffff812421c8>] wb_workfn+0x108/0x390
[ 1501.261379]  [<ffffffff810b6ccb>] process_one_work+0x14b/0x3d0
[ 1501.261380]  [<ffffffff810b76fe>] worker_thread+0x4e/0x450
[ 1501.261382]  [<ffffffff810b76b0>] ? rescuer_thread+0x2f0/0x2f0
[ 1501.261383]  [<ffffffff810bca68>] kthread+0xd8/0xf0
[ 1501.261385]  [<ffffffff810bc990>] ? kthread_park+0x60/0x60
[ 1501.261386]  [<ffffffff81960edf>] ret_from_fork+0x3f/0x70
[ 1501.261388]  [<ffffffff810bc990>] ? kthread_park+0x60/0x60
[ 1501.261412] fio             D ffff88043fd57480     0  3806   3734 0x00000000
[ 1501.261414]  ffff88040f7231e8 0000000000000082 ffff88041122dcc0 ffff8801fcdc0000
[ 1501.261415]  ffff88040f724000 ffff88040fb5cf30 ffff8801fcdc0000 0000000000000008
[ 1501.261417]  ffff8801fcd70010 ffff88040f723200 ffffffff8195ce23 7fffffffffffffff
[ 1501.261418] Call Trace:
[ 1501.261420]  [<ffffffff8195ce23>] schedule+0x33/0x80
[ 1501.261421]  [<ffffffff8195fcfa>] schedule_timeout+0x1fa/0x290
[ 1501.261423]  [<ffffffff814069c3>] ? xfs_buf_free+0xf3/0x140
[ 1501.261424]  [<ffffffff81407bc0>] ? xfs_buf_get_map+0x170/0x180
[ 1501.261425]  [<ffffffff8195ecf2>] __down+0x72/0xc0
[ 1501.261427]  [<ffffffff81407847>] ? _xfs_buf_find+0x1d7/0x370
[ 1501.261428]  [<ffffffff810e3fd1>] down+0x41/0x50
[ 1501.261429]  [<ffffffff814075cc>] xfs_buf_lock+0x3c/0xe0
[ 1501.261430]  [<ffffffff81407847>] _xfs_buf_find+0x1d7/0x370
[ 1501.261432]  [<ffffffff81407a7a>] xfs_buf_get_map+0x2a/0x180
[ 1501.261433]  [<ffffffff8140893c>] xfs_buf_read_map+0x2c/0x100
[ 1501.261435]  [<ffffffff8143a435>] xfs_trans_read_buf_map+0x1a5/0x360
[ 1501.261436]  [<ffffffff813bb801>] xfs_read_agf+0xb1/0x140
[ 1501.261437]  [<ffffffff813bb8f4>] xfs_alloc_read_agf+0x64/0x260
[ 1501.261438]  [<ffffffff813bbea1>] xfs_alloc_fix_freelist+0x3b1/0x4d0
[ 1501.261440]  [<ffffffff813cbc0e>] ? xfs_bmap_add_extent_unwritten_real+0x3ee/0x1ae0
[ 1501.261441]  [<ffffffff814e47dd>] ? radix_tree_lookup+0xd/0x10
[ 1501.261443]  [<ffffffff813fb0ba>] ? xfs_perag_get+0x2a/0xc0
[ 1501.261444]  [<ffffffff814e47dd>] ? radix_tree_lookup+0xd/0x10
[ 1501.261445]  [<ffffffff813fb0ba>] ? xfs_perag_get+0x2a/0xc0
[ 1501.261447]  [<ffffffff813bc24d>] xfs_alloc_vextent+0x22d/0x7f0
[ 1501.261448]  [<ffffffff813cef81>] xfs_bmap_btalloc+0x3c1/0x800
[ 1501.261449]  [<ffffffff813f7c15>] ? xfs_iext_get_ext+0x95/0xf0
[ 1501.261451]  [<ffffffff813cf3e4>] xfs_bmap_alloc+0x24/0x30
[ 1501.261453]  [<ffffffff813d0a23>] xfs_bmapi_write+0x6b3/0xf50
[ 1501.261455]  [<ffffffff814155f8>] xfs_iomap_write_direct+0x248/0x380
[ 1501.261457]  [<ffffffff81401128>] __xfs_get_blocks+0x458/0x7b0
[ 1501.261459]  [<ffffffff814014b4>] xfs_get_blocks_direct+0x14/0x20
[ 1501.261461]  [<ffffffff81250dfc>] do_blockdev_direct_IO+0xf8c/0x2bd0
[ 1501.261463]  [<ffffffff814014a0>] ? xfs_get_blocks+0x20/0x20
[ 1501.261465]  [<ffffffff81252a83>] __blockdev_direct_IO+0x43/0x50
[ 1501.261467]  [<ffffffff813ff570>] ? __xfs_end_io_direct_write+0xd0/0xd0
[ 1501.261469]  [<ffffffff813fefd1>] xfs_vm_direct_IO+0xc1/0x120
[ 1501.261470]  [<ffffffff813ff570>] ? __xfs_end_io_direct_write+0xd0/0xd0
[ 1501.261472]  [<ffffffff8140d798>] xfs_file_dio_aio_write+0x1e8/0x3b0
[ 1501.261473]  [<ffffffff8140dbb0>] ? xfs_file_buffered_aio_write+0x250/0x250
[ 1501.261475]  [<ffffffff8140dbb0>] ? xfs_file_buffered_aio_write+0x250/0x250
[ 1501.261476]  [<ffffffff8140dc31>] xfs_file_write_iter+0x81/0x120
[ 1501.261479]  [<ffffffff8126041a>] aio_run_iocb+0x26a/0x2d0
[ 1501.261480]  [<ffffffff8125fa9d>] ? aio_read_events+0x28d/0x380
[ 1501.261482]  [<ffffffff81261348>] ? do_io_submit+0x198/0x4f0
[ 1501.261484]  [<ffffffff81261407>] do_io_submit+0x257/0x4f0
[ 1501.261486]  [<ffffffff812616b0>] SyS_io_submit+0x10/0x20
[ 1501.261487]  [<ffffffff81960b6e>] entry_SYSCALL_64_fastpath+0x12/0x71
[ 1501.261488] fio             D ffff88043fc97480     0  3807   3734 0x00000000
[ 1501.261489]  ffff88040fa1f1e8 0000000000000086 ffff88041122b500 ffff8801fcdc1a80
[ 1501.261491]  ffff88040fa20000 ffff88040fb5cf30 ffff8801fcdc1a80 0000000000000008
[ 1501.261492]  ffff8801fcd70010 ffff88040fa1f200 ffffffff8195ce23 7fffffffffffffff
[ 1501.261493] Call Trace:
[ 1501.261495]  [<ffffffff8195ce23>] schedule+0x33/0x80
[ 1501.261496]  [<ffffffff8195fcfa>] schedule_timeout+0x1fa/0x290
[ 1501.261498]  [<ffffffff814069c3>] ? xfs_buf_free+0xf3/0x140
[ 1501.261499]  [<ffffffff8195ecf2>] __down+0x72/0xc0
[ 1501.261501]  [<ffffffff81407847>] ? _xfs_buf_find+0x1d7/0x370
[ 1501.261502]  [<ffffffff810e3fd1>] down+0x41/0x50
[ 1501.261503]  [<ffffffff814075cc>] xfs_buf_lock+0x3c/0xe0
[ 1501.261504]  [<ffffffff81407847>] _xfs_buf_find+0x1d7/0x370
[ 1501.261506]  [<ffffffff81407a7a>] xfs_buf_get_map+0x2a/0x180
[ 1501.261507]  [<ffffffff8140893c>] xfs_buf_read_map+0x2c/0x100
[ 1501.261508]  [<ffffffff8143a435>] xfs_trans_read_buf_map+0x1a5/0x360
[ 1501.261510]  [<ffffffff813bb801>] xfs_read_agf+0xb1/0x140
[ 1501.261511]  [<ffffffff813bb8f4>] xfs_alloc_read_agf+0x64/0x260
[ 1501.261512]  [<ffffffff813bbea1>] xfs_alloc_fix_freelist+0x3b1/0x4d0
[ 1501.261525]  [<ffffffff813cbc0e>] ? xfs_bmap_add_extent_unwritten_real+0x3ee/0x1ae0
[ 1501.261526]  [<ffffffff814e47dd>] ? radix_tree_lookup+0xd/0x10
[ 1501.261527]  [<ffffffff813fb0ba>] ? xfs_perag_get+0x2a/0xc0
[ 1501.261529]  [<ffffffff814e47dd>] ? radix_tree_lookup+0xd/0x10
[ 1501.261530]  [<ffffffff813fb0ba>] ? xfs_perag_get+0x2a/0xc0
[ 1501.261531]  [<ffffffff813bc24d>] xfs_alloc_vextent+0x22d/0x7f0
[ 1501.261532]  [<ffffffff813cef81>] xfs_bmap_btalloc+0x3c1/0x800
[ 1501.261534]  [<ffffffff813f7c15>] ? xfs_iext_get_ext+0x95/0xf0
[ 1501.261535]  [<ffffffff813cf3e4>] xfs_bmap_alloc+0x24/0x30
[ 1501.261537]  [<ffffffff813d0a23>] xfs_bmapi_write+0x6b3/0xf50
[ 1501.261539]  [<ffffffff814155f8>] xfs_iomap_write_direct+0x248/0x380
[ 1501.261541]  [<ffffffff81401128>] __xfs_get_blocks+0x458/0x7b0
[ 1501.261542]  [<ffffffff814014b4>] xfs_get_blocks_direct+0x14/0x20
[ 1501.261544]  [<ffffffff81250dfc>] do_blockdev_direct_IO+0xf8c/0x2bd0
[ 1501.261546]  [<ffffffff814014a0>] ? xfs_get_blocks+0x20/0x20
[ 1501.261548]  [<ffffffff81252a83>] __blockdev_direct_IO+0x43/0x50
[ 1501.261549]  [<ffffffff813ff570>] ? __xfs_end_io_direct_write+0xd0/0xd0
[ 1501.261551]  [<ffffffff813fefd1>] xfs_vm_direct_IO+0xc1/0x120
[ 1501.261552]  [<ffffffff813ff570>] ? __xfs_end_io_direct_write+0xd0/0xd0
[ 1501.261553]  [<ffffffff8140d798>] xfs_file_dio_aio_write+0x1e8/0x3b0
[ 1501.261555]  [<ffffffff8140dbb0>] ? xfs_file_buffered_aio_write+0x250/0x250
[ 1501.261556]  [<ffffffff8140dc31>] xfs_file_write_iter+0x81/0x120
[ 1501.261558]  [<ffffffff8126041a>] aio_run_iocb+0x26a/0x2d0
[ 1501.261560]  [<ffffffff81198df9>] ? find_get_entries+0x169/0x1b0
[ 1501.261561]  [<ffffffff8125fa9d>] ? aio_read_events+0x28d/0x380
[ 1501.261563]  [<ffffffff81261348>] ? do_io_submit+0x198/0x4f0
[ 1501.261564]  [<ffffffff81261407>] do_io_submit+0x257/0x4f0
[ 1501.261566]  [<ffffffff812616b0>] SyS_io_submit+0x10/0x20
[ 1501.261567]  [<ffffffff81960b6e>] entry_SYSCALL_64_fastpath+0x12/0x71
[ 1501.261568] fio             D ffff88043fc57480     0  3808   3734 0x00000000
[ 1501.261570]  ffff88040e1431e8 0000000000000086 ffff88041122a7c0 ffff8801fcdc27c0
[ 1501.261571]  ffff88040e144000 ffff88040fb5cf30 ffff8801fcdc27c0 0000000000000008
[ 1501.261572]  ffff8801fcd70010 ffff88040e143200 ffffffff8195ce23 7fffffffffffffff
[ 1501.261573] Call Trace:
[ 1501.261575]  [<ffffffff8195ce23>] schedule+0x33/0x80
[ 1501.261576]  [<ffffffff8195fcfa>] schedule_timeout+0x1fa/0x290
[ 1501.261577]  [<ffffffff810e3f7e>] ? down_trylock+0x2e/0x40
[ 1501.261579]  [<ffffffff8195ecf2>] __down+0x72/0xc0
[ 1501.261580]  [<ffffffff81407847>] ? _xfs_buf_find+0x1d7/0x370
[ 1501.261581]  [<ffffffff810e3fd1>] down+0x41/0x50
[ 1501.261583]  [<ffffffff814075cc>] xfs_buf_lock+0x3c/0xe0
[ 1501.261584]  [<ffffffff81407847>] _xfs_buf_find+0x1d7/0x370
[ 1501.261585]  [<ffffffff81407a7a>] xfs_buf_get_map+0x2a/0x180
[ 1501.261586]  [<ffffffff8140893c>] xfs_buf_read_map+0x2c/0x100
[ 1501.261588]  [<ffffffff8143a435>] xfs_trans_read_buf_map+0x1a5/0x360
[ 1501.261589]  [<ffffffff813bb801>] xfs_read_agf+0xb1/0x140
[ 1501.261590]  [<ffffffff813bb8f4>] xfs_alloc_read_agf+0x64/0x260
[ 1501.261591]  [<ffffffff813bbea1>] xfs_alloc_fix_freelist+0x3b1/0x4d0
[ 1501.261593]  [<ffffffff813cbc0e>] ? xfs_bmap_add_extent_unwritten_real+0x3ee/0x1ae0
[ 1501.261594]  [<ffffffff814e47dd>] ? radix_tree_lookup+0xd/0x10
[ 1501.261595]  [<ffffffff813fb0ba>] ? xfs_perag_get+0x2a/0xc0
[ 1501.261596]  [<ffffffff814e47dd>] ? radix_tree_lookup+0xd/0x10
[ 1501.261597]  [<ffffffff813fb0ba>] ? xfs_perag_get+0x2a/0xc0
[ 1501.261599]  [<ffffffff813bc24d>] xfs_alloc_vextent+0x22d/0x7f0
[ 1501.261600]  [<ffffffff813cef81>] xfs_bmap_btalloc+0x3c1/0x800
[ 1501.261601]  [<ffffffff813f7c15>] ? xfs_iext_get_ext+0x95/0xf0
[ 1501.261603]  [<ffffffff813cf3e4>] xfs_bmap_alloc+0x24/0x30
[ 1501.261604]  [<ffffffff813d0a23>] xfs_bmapi_write+0x6b3/0xf50
[ 1501.261605]  [<ffffffff813f799a>] ? xfs_iext_bno_to_irec+0xaa/0xf0
[ 1501.261607]  [<ffffffff814155f8>] xfs_iomap_write_direct+0x248/0x380
[ 1501.261609]  [<ffffffff81401128>] __xfs_get_blocks+0x458/0x7b0
[ 1501.261611]  [<ffffffff814014b4>] xfs_get_blocks_direct+0x14/0x20
[ 1501.261613]  [<ffffffff81250dfc>] do_blockdev_direct_IO+0xf8c/0x2bd0
[ 1501.261615]  [<ffffffff814014a0>] ? xfs_get_blocks+0x20/0x20
[ 1501.261616]  [<ffffffff81252a83>] __blockdev_direct_IO+0x43/0x50
[ 1501.261618]  [<ffffffff813ff570>] ? __xfs_end_io_direct_write+0xd0/0xd0
[ 1501.261619]  [<ffffffff813fefd1>] xfs_vm_direct_IO+0xc1/0x120
[ 1501.261621]  [<ffffffff813ff570>] ? __xfs_end_io_direct_write+0xd0/0xd0
[ 1501.261622]  [<ffffffff8140d798>] xfs_file_dio_aio_write+0x1e8/0x3b0
[ 1501.261623]  [<ffffffff8140dbb0>] ? xfs_file_buffered_aio_write+0x250/0x250
[ 1501.261625]  [<ffffffff8140dbb0>] ? xfs_file_buffered_aio_write+0x250/0x250
[ 1501.261626]  [<ffffffff8140dc31>] xfs_file_write_iter+0x81/0x120
[ 1501.261628]  [<ffffffff8126041a>] aio_run_iocb+0x26a/0x2d0
[ 1501.261629]  [<ffffffff8125fa9d>] ? aio_read_events+0x28d/0x380
[ 1501.261631]  [<ffffffff81261348>] ? do_io_submit+0x198/0x4f0
[ 1501.261632]  [<ffffffff81261407>] do_io_submit+0x257/0x4f0
[ 1501.261634]  [<ffffffff812616b0>] SyS_io_submit+0x10/0x20
[ 1501.261635]  [<ffffffff81960b6e>] entry_SYSCALL_64_fastpath+0x12/0x71
[ 1501.261636] fio             D ffff88043fcd7480     0  3809   3734 0x00000000
[ 1501.261638]  ffff8801fce63b68 0000000000000082 ffff88041122c240 ffff8801fcdc6a00
[ 1501.261639]  ffff8801fce64000 ffff8800363a0500 ffffffffffffffff ffffffff8140d664
[ 1501.261640]  ffffffff8140dbb0 ffff8801fce63b80 ffffffff8195ce23 ffff8801fcdc6a00
[ 1501.261641] Call Trace:
[ 1501.261643]  [<ffffffff8140d664>] ? xfs_file_dio_aio_write+0xb4/0x3b0
[ 1501.261644]  [<ffffffff8140dbb0>] ? xfs_file_buffered_aio_write+0x250/0x250
[ 1501.261645]  [<ffffffff8195ce23>] schedule+0x33/0x80
[ 1501.261647]  [<ffffffff8195f6f4>] rwsem_down_read_failed+0xe4/0x140
[ 1501.261648]  [<ffffffff814ecf54>] call_rwsem_down_read_failed+0x14/0x30
[ 1501.261650]  [<ffffffff8195f020>] ? down_read+0x20/0x30
[ 1501.261651]  [<ffffffff8141894b>] xfs_ilock+0x18b/0x1b0
[ 1501.261652]  [<ffffffff8140d664>] xfs_file_dio_aio_write+0xb4/0x3b0
[ 1501.261654]  [<ffffffff8146ce23>] ? selinux_file_permission+0xc3/0x110
[ 1501.261656]  [<ffffffff8140dbb0>] ? xfs_file_buffered_aio_write+0x250/0x250
[ 1501.261657]  [<ffffffff8140dc31>] xfs_file_write_iter+0x81/0x120
[ 1501.261658]  [<ffffffff8126041a>] aio_run_iocb+0x26a/0x2d0
[ 1501.261660]  [<ffffffff8125fa9d>] ? aio_read_events+0x28d/0x380
[ 1501.261662]  [<ffffffff81261348>] ? do_io_submit+0x198/0x4f0
[ 1501.261663]  [<ffffffff81261407>] do_io_submit+0x257/0x4f0
[ 1501.261665]  [<ffffffff812616b0>] SyS_io_submit+0x10/0x20
[ 1501.261666]  [<ffffffff81960b6e>] entry_SYSCALL_64_fastpath+0x12/0x71
[ 1501.261667] fio             D ffff88043fc57480     0  3810   3734 0x00000000
[ 1501.261668]  ffff8800b00db1e8 0000000000000082 ffff88041122a7c0 ffff8801fcdc3500
[ 1501.261669]  ffff8800b00dc000 ffff88040fb5cf30 ffff8801fcdc3500 0000000000000008
[ 1501.261671]  ffff8801fcd70010 ffff8800b00db200 ffffffff8195ce23 7fffffffffffffff
[ 1501.261672] Call Trace:
[ 1501.261673]  [<ffffffff8195ce23>] schedule+0x33/0x80
[ 1501.261675]  [<ffffffff8195fcfa>] schedule_timeout+0x1fa/0x290
[ 1501.261676]  [<ffffffff810e3f7e>] ? down_trylock+0x2e/0x40
[ 1501.261677]  [<ffffffff810e3f7e>] ? down_trylock+0x2e/0x40
[ 1501.261679]  [<ffffffff8195ecf2>] __down+0x72/0xc0
[ 1501.261680]  [<ffffffff81407800>] ? _xfs_buf_find+0x190/0x370
[ 1501.261681]  [<ffffffff811f4056>] ? kmem_cache_alloc+0x1c6/0x1f0
[ 1501.261682]  [<ffffffff81407847>] ? _xfs_buf_find+0x1d7/0x370
[ 1501.261684]  [<ffffffff810e3fd1>] down+0x41/0x50
[ 1501.261685]  [<ffffffff814075cc>] xfs_buf_lock+0x3c/0xe0
[ 1501.261686]  [<ffffffff81407847>] _xfs_buf_find+0x1d7/0x370
[ 1501.261687]  [<ffffffff81407a7a>] xfs_buf_get_map+0x2a/0x180
[ 1501.261688]  [<ffffffff8140893c>] xfs_buf_read_map+0x2c/0x100
[ 1501.261690]  [<ffffffff8143a435>] xfs_trans_read_buf_map+0x1a5/0x360
[ 1501.261691]  [<ffffffff813bb801>] xfs_read_agf+0xb1/0x140
[ 1501.261692]  [<ffffffff813bb8f4>] xfs_alloc_read_agf+0x64/0x260
[ 1501.261693]  [<ffffffff813bbea1>] xfs_alloc_fix_freelist+0x3b1/0x4d0
[ 1501.261694]  [<ffffffff813ba9d2>] ? xfs_alloc_ag_vextent_near+0xaf2/0xce0
[ 1501.261696]  [<ffffffff814e47dd>] ? radix_tree_lookup+0xd/0x10
[ 1501.261697]  [<ffffffff813fb0ba>] ? xfs_perag_get+0x2a/0xc0
[ 1501.261698]  [<ffffffff813bc24d>] xfs_alloc_vextent+0x22d/0x7f0
[ 1501.261700]  [<ffffffff813cf2d6>] xfs_bmap_btalloc+0x716/0x800
[ 1501.261701]  [<ffffffff813f7c15>] ? xfs_iext_get_ext+0x95/0xf0
[ 1501.261702]  [<ffffffff813cf3e4>] xfs_bmap_alloc+0x24/0x30
[ 1501.261704]  [<ffffffff813d0a23>] xfs_bmapi_write+0x6b3/0xf50
[ 1501.261706]  [<ffffffff814155f8>] xfs_iomap_write_direct+0x248/0x380
[ 1501.261708]  [<ffffffff81401128>] __xfs_get_blocks+0x458/0x7b0
[ 1501.261709]  [<ffffffff814014b4>] xfs_get_blocks_direct+0x14/0x20
[ 1501.261711]  [<ffffffff81250dfc>] do_blockdev_direct_IO+0xf8c/0x2bd0
[ 1501.261713]  [<ffffffff814014a0>] ? xfs_get_blocks+0x20/0x20
[ 1501.261715]  [<ffffffff81252a83>] __blockdev_direct_IO+0x43/0x50
[ 1501.261716]  [<ffffffff813ff570>] ? __xfs_end_io_direct_write+0xd0/0xd0
[ 1501.261718]  [<ffffffff813fefd1>] xfs_vm_direct_IO+0xc1/0x120
[ 1501.261719]  [<ffffffff813ff570>] ? __xfs_end_io_direct_write+0xd0/0xd0
[ 1501.261720]  [<ffffffff8140d798>] xfs_file_dio_aio_write+0x1e8/0x3b0
[ 1501.261722]  [<ffffffff8140dbb0>] ? xfs_file_buffered_aio_write+0x250/0x250
[ 1501.261723]  [<ffffffff8140dc31>] xfs_file_write_iter+0x81/0x120
[ 1501.261725]  [<ffffffff8126041a>] aio_run_iocb+0x26a/0x2d0
[ 1501.261726]  [<ffffffff8125fa9d>] ? aio_read_events+0x28d/0x380
[ 1501.261728]  [<ffffffff81261348>] ? do_io_submit+0x198/0x4f0
[ 1501.261729]  [<ffffffff81261407>] do_io_submit+0x257/0x4f0
[ 1501.261731]  [<ffffffff812616b0>] SyS_io_submit+0x10/0x20
[ 1501.261732]  [<ffffffff81960b6e>] entry_SYSCALL_64_fastpath+0x12/0x71
[ 1501.261733] fio             D ffff88043fd17480     0  3812   3734 0x00000000
[ 1501.261735]  ffff8800b01ebb60 0000000000000086 ffff88041122cf80 ffff8800ba48c240
[ 1501.261737]  ffff8804107e81e8 ffff8800b01ebb78 ffffffff8195ce23 ffff8800b01ebbec
[ 1501.261740]  [<ffffffff8195ce23>] schedule+0x33/0x80
[ 1501.261742]  [<ffffffff810df760>] ? wait_woken+0x80/0x80
[ 1501.261746]  [<ffffffff81424168>] xfs_flush_inodes+0x28/0x40
[ 1501.261748]  [<ffffffff8140dbb0>] ? xfs_file_buffered_aio_write+0x250/0x250
[ 1501.261754]  [<ffffffff81261348>] ? do_io_submit+0x198/0x4f0
[ 1501.261758]  [<ffffffff812616b0>] SyS_io_submit+0x10/0x20
[ 1501.261760] xfs_io          D ffff88043fc57480     0  4225   3474 0x00000000
[ 1501.261765] Call Trace:
[ 1501.261767]  [<ffffffff8195ce23>] schedule+0x33/0x80
[ 1501.261770]  [<ffffffff810e3f7e>] ? down_trylock+0x2e/0x40
[ 1501.261772]  [<ffffffff811f4056>] ? kmem_cache_alloc+0x1c6/0x1f0
[ 1501.261774]  [<ffffffff81407847>] ? _xfs_buf_find+0x1d7/0x370
[ 1501.261777]  [<ffffffff814075cc>] xfs_buf_lock+0x3c/0xe0
[ 1501.261779]  [<ffffffff81407a7a>] xfs_buf_get_map+0x2a/0x180
[ 1501.261783]  [<ffffffff813bb801>] xfs_read_agf+0xb1/0x140
[ 1501.261785]  [<ffffffff813bbea1>] xfs_alloc_fix_freelist+0x3b1/0x4d0
[ 1501.261787]  [<ffffffff814e47dd>] ? radix_tree_lookup+0xd/0x10
[ 1501.261792]  [<ffffffff813bc8e2>] xfs_free_extent+0xd2/0x160
[ 1501.261795]  [<ffffffff81403490>] xfs_bmap_finish+0x120/0x150
[ 1501.261798]  [<ffffffff814181d7>] xfs_setattr_size+0x3a7/0x440
[ 1501.261801]  [<ffffffff8122fec7>] notify_change+0x237/0x350
[ 1501.261805]  [<ffffffff81211cf9>] do_sys_ftruncate.constprop.15+0xe9/0x140

--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".config"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86 4.2.0 Kernel Configuration
#
CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_PERF_EVENTS_INTEL_UNCORE=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_HAVE_INTEL_TXT=y
CONFIG_X86_64_SMP=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_PGTABLE_LEVELS=4
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
# CONFIG_COMPILE_TEST is not set
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_FHANDLE=y
# CONFIG_USELIB is not set
CONFIG_AUDIT=y
CONFIG_HAVE_ARCH_AUDITSYSCALL=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_HIERARCHY=y
CONFIG_GENERIC_MSI_IRQ=y
CONFIG_GENERIC_MSI_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_CLOCKSOURCE_VALIDATE_LAST_CYCLE=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ_FULL=y
# CONFIG_NO_HZ_FULL_ALL is not set
# CONFIG_NO_HZ_FULL_SYSIDLE is not set
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_RCU_EXPERT is not set
CONFIG_SRCU=y
# CONFIG_TASKS_RCU is not set
CONFIG_RCU_STALL_COMMON=y
CONFIG_CONTEXT_TRACKING=y
CONFIG_RCU_USER_QS=y
# CONFIG_CONTEXT_TRACKING_FORCE is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_RCU_NOCB_CPU=y
# CONFIG_RCU_NOCB_CPU_NONE is not set
# CONFIG_RCU_NOCB_CPU_ZERO is not set
CONFIG_RCU_NOCB_CPU_ALL=y
# CONFIG_RCU_EXPEDITE_BOOT is not set
CONFIG_BUILD_BIN2C=y
CONFIG_IKCONFIG=m
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=18
CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_NUMA_BALANCING=y
CONFIG_NUMA_BALANCING_DEFAULT_ENABLED=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_PAGE_COUNTER=y
CONFIG_MEMCG=y
CONFIG_MEMCG_SWAP=y
CONFIG_MEMCG_SWAP_ENABLED=y
CONFIG_MEMCG_KMEM=y
CONFIG_CGROUP_HUGETLB=y
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
CONFIG_CGROUP_WRITEBACK=y
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BPF=y
CONFIG_EXPERT=y
CONFIG_UID16=y
CONFIG_MULTIUSER=y
CONFIG_SGETMASK_SYSCALL=y
CONFIG_SYSFS_SYSCALL=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
# CONFIG_BPF_SYSCALL is not set
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_ADVISE_SYSCALLS=y
CONFIG_PCI_QUIRKS=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_SLUB_CPU_PARTIAL=y
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
# CONFIG_OPROFILE is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
CONFIG_OPTPROBES=y
CONFIG_KPROBES_ON_FTRACE=y
CONFIG_UPROBES=y
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_ARCH_WANTS_DYNAMIC_TASK_STRUCT=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_CLK=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_CC_STACKPROTECTOR=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR_NONE is not set
# CONFIG_CC_STACKPROTECTOR_REGULAR is not set
CONFIG_CC_STACKPROTECTOR_STRONG=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_HUGE_VMAP=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y
CONFIG_ARCH_HAS_ELF_RANDOMIZE=y
CONFIG_HAVE_COPY_THREAD_TLS=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_MODULE_SIG=y
# CONFIG_MODULE_SIG_FORCE is not set
CONFIG_MODULE_SIG_ALL=y
# CONFIG_MODULE_SIG_SHA1 is not set
# CONFIG_MODULE_SIG_SHA224 is not set
CONFIG_MODULE_SIG_SHA256=y
# CONFIG_MODULE_SIG_SHA384 is not set
# CONFIG_MODULE_SIG_SHA512 is not set
CONFIG_MODULE_SIG_HASH="sha256"
# CONFIG_MODULE_COMPRESS is not set
CONFIG_MODULES_TREE_LOOKUP=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_DEV_THROTTLING=y
# CONFIG_BLK_CMDLINE_PARSER is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
CONFIG_AIX_PARTITION=y
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
# CONFIG_CMDLINE_PARTITION is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_CFQ_GROUP_IOSCHED=y
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_ASN1=y
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
CONFIG_INLINE_READ_UNLOCK=y
CONFIG_INLINE_READ_UNLOCK_IRQ=y
CONFIG_INLINE_WRITE_UNLOCK=y
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_RWSEM_SPIN_ON_OWNER=y
CONFIG_LOCK_SPIN_ON_OWNER=y
CONFIG_ARCH_USE_QUEUED_SPINLOCKS=y
CONFIG_QUEUED_SPINLOCKS=y
CONFIG_ARCH_USE_QUEUED_RWLOCKS=y
CONFIG_QUEUED_RWLOCKS=y
CONFIG_FREEZER=y

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
CONFIG_SMP=y
CONFIG_X86_FEATURE_NAMES=y
CONFIG_X86_X2APIC=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_NUMACHIP is not set
# CONFIG_X86_VSMP is not set
CONFIG_X86_UV=y
# CONFIG_X86_GOLDFISH is not set
CONFIG_X86_INTEL_LPSS=y
# CONFIG_X86_AMD_PLATFORM_DEVICE is not set
CONFIG_IOSF_MBI=y
# CONFIG_IOSF_MBI_DEBUG is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
CONFIG_XEN=y
CONFIG_XEN_DOM0=y
CONFIG_XEN_PVHVM=y
CONFIG_XEN_MAX_DOMAIN_MEMORY=500
CONFIG_XEN_SAVE_RESTORE=y
CONFIG_XEN_DEBUG_FS=y
# CONFIG_XEN_PVH is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
# CONFIG_GART_IOMMU is not set
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=64
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX64=y
CONFIG_X86_VSYSCALL_EMULATION=y
# CONFIG_I8K is not set
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_MICROCODE_INTEL_EARLY=y
CONFIG_MICROCODE_AMD_EARLY=y
CONFIG_MICROCODE_EARLY=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_X86_DIRECT_GBPAGES=y
CONFIG_NUMA=y
CONFIG_AMD_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
# CONFIG_NUMA_EMU is not set
CONFIG_NODES_SHIFT=9
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
# CONFIG_ARCH_MEMORY_PROBE is not set
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
# CONFIG_MOVABLE_NODE is not set
CONFIG_HAVE_BOOTMEM_INFO_NODE=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_MEMORY_BALLOON=y
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=0
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=65536
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
# CONFIG_HWPOISON_INJECT is not set
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
CONFIG_CLEANCACHE=y
CONFIG_FRONTSWAP=y
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set
# CONFIG_CMA_DEBUGFS is not set
CONFIG_CMA_AREAS=8
CONFIG_ZSWAP=y
CONFIG_ZPOOL=y
CONFIG_ZBUD=y
CONFIG_ZSMALLOC=y
# CONFIG_PGTABLE_MAPPING is not set
# CONFIG_ZSMALLOC_STAT is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_ARCH_SUPPORTS_DEFERRED_STRUCT_PAGE_INIT=y
# CONFIG_DEFERRED_STRUCT_PAGE_INIT is not set
CONFIG_X86_PMEM_LEGACY=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_X86_INTEL_MPX is not set
CONFIG_EFI=y
CONFIG_EFI_STUB=y
CONFIG_EFI_MIXED=y
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_KEXEC_FILE=y
CONFIG_KEXEC_VERIFY_SIG=y
CONFIG_KEXEC_BZIMAGE_VERIFY_SIG=y
CONFIG_CRASH_DUMP=y
CONFIG_KEXEC_JUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
# CONFIG_RANDOMIZE_BASE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_HAVE_LIVEPATCH=y
# CONFIG_LIVEPATCH is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
# CONFIG_PM_TEST_SUSPEND is not set
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_DPM_WATCHDOG is not set
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_PM_CLK=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
CONFIG_ACPI_SYSTEM_POWER_STATES_SUPPORT=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS_POWER is not set
CONFIG_ACPI_REV_OVERRIDE_POSSIBLE=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_VIDEO is not set
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_NUMA=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_INITRD_TABLE_OVERRIDE=y
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_HOTPLUG_MEMORY=y
CONFIG_ACPI_HOTPLUG_IOAPIC=y
# CONFIG_ACPI_SBS is not set
CONFIG_ACPI_HED=y
# CONFIG_ACPI_CUSTOM_METHOD is not set
CONFIG_ACPI_BGRT=y
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
CONFIG_ACPI_NFIT=m
# CONFIG_ACPI_NFIT_DEBUG is not set
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
CONFIG_ACPI_APEI_PCIEAER=y
CONFIG_ACPI_APEI_MEMORY_FAILURE=y
# CONFIG_ACPI_APEI_EINJ is not set
# CONFIG_ACPI_APEI_ERST_DEBUG is not set
# CONFIG_ACPI_EXTLOG is not set
# CONFIG_PMIC_OPREGION is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_COMMON=y
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
# CONFIG_X86_PCC_CPUFREQ is not set
CONFIG_X86_ACPI_CPUFREQ=y
CONFIG_X86_ACPI_CPUFREQ_CPB=y
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_AMD_FREQ_SENSITIVITY is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_GOV_LADDER is not set
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
CONFIG_INTEL_IDLE=y

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_XEN=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
CONFIG_PCIE_ECRC=y
# CONFIG_PCIEAER_INJECT is not set
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
CONFIG_PCI_BUS_ADDR_T_64BIT=y
CONFIG_PCI_MSI=y
CONFIG_PCI_MSI_IRQ_DOMAIN=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
# CONFIG_XEN_PCIDEV_FRONTEND is not set
CONFIG_HT_IRQ=y
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_ACPI=y
# CONFIG_HOTPLUG_PCI_ACPI_IBM is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set
# CONFIG_RAPIDIO is not set
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
# CONFIG_BINFMT_MISC is not set
CONFIG_COREDUMP=y
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
# CONFIG_X86_X32 is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_KEYS_COMPAT=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_PMC_ATOM=y
CONFIG_NET=y
CONFIG_NET_INGRESS=y

#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_DIAG is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_IP_FIB_TRIE_STATS=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE_DEMUX is not set
# CONFIG_NET_IP_TUNNEL is not set
CONFIG_IP_MROUTE=y
CONFIG_IP_MROUTE_MULTIPLE_TABLES=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
CONFIG_SYN_COOKIES=y
# CONFIG_NET_UDP_TUNNEL is not set
# CONFIG_NET_FOU is not set
# CONFIG_GENEVE_CORE is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=y
# CONFIG_INET_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
# CONFIG_TCP_CONG_BIC is not set
CONFIG_TCP_CONG_CUBIC=y
# CONFIG_TCP_CONG_WESTWOOD is not set
# CONFIG_TCP_CONG_HTCP is not set
# CONFIG_TCP_CONG_HSTCP is not set
# CONFIG_TCP_CONG_HYBLA is not set
# CONFIG_TCP_CONG_VEGAS is not set
# CONFIG_TCP_CONG_SCALABLE is not set
# CONFIG_TCP_CONG_LP is not set
# CONFIG_TCP_CONG_VENO is not set
# CONFIG_TCP_CONG_YEAH is not set
# CONFIG_TCP_CONG_ILLINOIS is not set
# CONFIG_TCP_CONG_DCTCP is not set
# CONFIG_TCP_CONG_CDG is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_IPV6_OPTIMISTIC_DAD=y
# CONFIG_INET6_AH is not set
# CONFIG_INET6_ESP is not set
# CONFIG_INET6_IPCOMP is not set
CONFIG_IPV6_MIP6=y
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
# CONFIG_INET6_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET6_XFRM_MODE_TUNNEL is not set
# CONFIG_INET6_XFRM_MODE_BEET is not set
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
# CONFIG_IPV6_SIT is not set
# CONFIG_IPV6_TUNNEL is not set
# CONFIG_IPV6_GRE is not set
CONFIG_IPV6_MULTIPLE_TABLES=y
CONFIG_IPV6_SUBTREES=y
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
CONFIG_IPV6_PIMSM_V2=y
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NET_PTP_CLASSIFY=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
# CONFIG_BRIDGE_NETFILTER is not set

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_INGRESS=y
# CONFIG_NETFILTER_NETLINK_ACCT is not set
# CONFIG_NETFILTER_NETLINK_QUEUE is not set
# CONFIG_NETFILTER_NETLINK_LOG is not set
CONFIG_NF_CONNTRACK=y
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_PROCFS=y
CONFIG_NF_CONNTRACK_EVENTS=y
# CONFIG_NF_CONNTRACK_TIMEOUT is not set
CONFIG_NF_CONNTRACK_TIMESTAMP=y
# CONFIG_NF_CT_PROTO_DCCP is not set
# CONFIG_NF_CT_PROTO_SCTP is not set
# CONFIG_NF_CT_PROTO_UDPLITE is not set
# CONFIG_NF_CONNTRACK_AMANDA is not set
# CONFIG_NF_CONNTRACK_FTP is not set
# CONFIG_NF_CONNTRACK_H323 is not set
# CONFIG_NF_CONNTRACK_IRC is not set
# CONFIG_NF_CONNTRACK_NETBIOS_NS is not set
# CONFIG_NF_CONNTRACK_SNMP is not set
# CONFIG_NF_CONNTRACK_PPTP is not set
# CONFIG_NF_CONNTRACK_SANE is not set
# CONFIG_NF_CONNTRACK_SIP is not set
# CONFIG_NF_CONNTRACK_TFTP is not set
# CONFIG_NF_CT_NETLINK is not set
# CONFIG_NF_CT_NETLINK_TIMEOUT is not set
CONFIG_NF_NAT=y
CONFIG_NF_NAT_NEEDED=y
# CONFIG_NF_NAT_AMANDA is not set
# CONFIG_NF_NAT_FTP is not set
# CONFIG_NF_NAT_IRC is not set
# CONFIG_NF_NAT_SIP is not set
# CONFIG_NF_NAT_TFTP is not set
# CONFIG_NF_NAT_REDIRECT is not set
# CONFIG_NF_TABLES is not set
CONFIG_NETFILTER_XTABLES=y

#
# Xtables combined modules
#
# CONFIG_NETFILTER_XT_MARK is not set
# CONFIG_NETFILTER_XT_CONNMARK is not set

#
# Xtables targets
#
# CONFIG_NETFILTER_XT_TARGET_AUDIT is not set
CONFIG_NETFILTER_XT_TARGET_CHECKSUM=y
# CONFIG_NETFILTER_XT_TARGET_CLASSIFY is not set
# CONFIG_NETFILTER_XT_TARGET_CONNMARK is not set
# CONFIG_NETFILTER_XT_TARGET_CONNSECMARK is not set
# CONFIG_NETFILTER_XT_TARGET_DSCP is not set
# CONFIG_NETFILTER_XT_TARGET_HL is not set
# CONFIG_NETFILTER_XT_TARGET_HMARK is not set
# CONFIG_NETFILTER_XT_TARGET_IDLETIMER is not set
# CONFIG_NETFILTER_XT_TARGET_LED is not set
# CONFIG_NETFILTER_XT_TARGET_LOG is not set
# CONFIG_NETFILTER_XT_TARGET_MARK is not set
CONFIG_NETFILTER_XT_NAT=y
# CONFIG_NETFILTER_XT_TARGET_NETMAP is not set
# CONFIG_NETFILTER_XT_TARGET_NFLOG is not set
# CONFIG_NETFILTER_XT_TARGET_NFQUEUE is not set
# CONFIG_NETFILTER_XT_TARGET_RATEEST is not set
# CONFIG_NETFILTER_XT_TARGET_REDIRECT is not set
# CONFIG_NETFILTER_XT_TARGET_TEE is not set
# CONFIG_NETFILTER_XT_TARGET_TPROXY is not set
# CONFIG_NETFILTER_XT_TARGET_SECMARK is not set
# CONFIG_NETFILTER_XT_TARGET_TCPMSS is not set
# CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP is not set

#
# Xtables matches
#
# CONFIG_NETFILTER_XT_MATCH_ADDRTYPE is not set
# CONFIG_NETFILTER_XT_MATCH_BPF is not set
# CONFIG_NETFILTER_XT_MATCH_CGROUP is not set
# CONFIG_NETFILTER_XT_MATCH_CLUSTER is not set
# CONFIG_NETFILTER_XT_MATCH_COMMENT is not set
# CONFIG_NETFILTER_XT_MATCH_CONNBYTES is not set
# CONFIG_NETFILTER_XT_MATCH_CONNLABEL is not set
# CONFIG_NETFILTER_XT_MATCH_CONNLIMIT is not set
# CONFIG_NETFILTER_XT_MATCH_CONNMARK is not set
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=y
# CONFIG_NETFILTER_XT_MATCH_CPU is not set
# CONFIG_NETFILTER_XT_MATCH_DCCP is not set
# CONFIG_NETFILTER_XT_MATCH_DEVGROUP is not set
# CONFIG_NETFILTER_XT_MATCH_DSCP is not set
# CONFIG_NETFILTER_XT_MATCH_ECN is not set
# CONFIG_NETFILTER_XT_MATCH_ESP is not set
# CONFIG_NETFILTER_XT_MATCH_HASHLIMIT is not set
# CONFIG_NETFILTER_XT_MATCH_HELPER is not set
# CONFIG_NETFILTER_XT_MATCH_HL is not set
# CONFIG_NETFILTER_XT_MATCH_IPCOMP is not set
# CONFIG_NETFILTER_XT_MATCH_IPRANGE is not set
# CONFIG_NETFILTER_XT_MATCH_L2TP is not set
# CONFIG_NETFILTER_XT_MATCH_LENGTH is not set
# CONFIG_NETFILTER_XT_MATCH_LIMIT is not set
# CONFIG_NETFILTER_XT_MATCH_MAC is not set
# CONFIG_NETFILTER_XT_MATCH_MARK is not set
# CONFIG_NETFILTER_XT_MATCH_MULTIPORT is not set
# CONFIG_NETFILTER_XT_MATCH_NFACCT is not set
# CONFIG_NETFILTER_XT_MATCH_OWNER is not set
# CONFIG_NETFILTER_XT_MATCH_POLICY is not set
# CONFIG_NETFILTER_XT_MATCH_PKTTYPE is not set
# CONFIG_NETFILTER_XT_MATCH_QUOTA is not set
# CONFIG_NETFILTER_XT_MATCH_RATEEST is not set
# CONFIG_NETFILTER_XT_MATCH_REALM is not set
# CONFIG_NETFILTER_XT_MATCH_RECENT is not set
# CONFIG_NETFILTER_XT_MATCH_SCTP is not set
# CONFIG_NETFILTER_XT_MATCH_SOCKET is not set
# CONFIG_NETFILTER_XT_MATCH_STATE is not set
# CONFIG_NETFILTER_XT_MATCH_STATISTIC is not set
# CONFIG_NETFILTER_XT_MATCH_STRING is not set
# CONFIG_NETFILTER_XT_MATCH_TCPMSS is not set
# CONFIG_NETFILTER_XT_MATCH_TIME is not set
# CONFIG_NETFILTER_XT_MATCH_U32 is not set
# CONFIG_IP_SET is not set
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=y
CONFIG_NF_CONNTRACK_IPV4=y
# CONFIG_NF_CONNTRACK_PROC_COMPAT is not set
# CONFIG_NF_LOG_ARP is not set
# CONFIG_NF_LOG_IPV4 is not set
CONFIG_NF_REJECT_IPV4=y
CONFIG_NF_NAT_IPV4=y
CONFIG_NF_NAT_MASQUERADE_IPV4=y
# CONFIG_NF_NAT_PPTP is not set
# CONFIG_NF_NAT_H323 is not set
CONFIG_IP_NF_IPTABLES=y
# CONFIG_IP_NF_MATCH_AH is not set
# CONFIG_IP_NF_MATCH_ECN is not set
# CONFIG_IP_NF_MATCH_RPFILTER is not set
# CONFIG_IP_NF_MATCH_TTL is not set
CONFIG_IP_NF_FILTER=y
CONFIG_IP_NF_TARGET_REJECT=y
# CONFIG_IP_NF_TARGET_SYNPROXY is not set
CONFIG_IP_NF_NAT=y
CONFIG_IP_NF_TARGET_MASQUERADE=y
# CONFIG_IP_NF_TARGET_NETMAP is not set
# CONFIG_IP_NF_TARGET_REDIRECT is not set
CONFIG_IP_NF_MANGLE=y
# CONFIG_IP_NF_TARGET_CLUSTERIP is not set
# CONFIG_IP_NF_TARGET_ECN is not set
# CONFIG_IP_NF_TARGET_TTL is not set
# CONFIG_IP_NF_RAW is not set
# CONFIG_IP_NF_SECURITY is not set
# CONFIG_IP_NF_ARPTABLES is not set

#
# IPv6: Netfilter Configuration
#
# CONFIG_NF_DEFRAG_IPV6 is not set
# CONFIG_NF_CONNTRACK_IPV6 is not set
# CONFIG_NF_REJECT_IPV6 is not set
# CONFIG_NF_LOG_IPV6 is not set
CONFIG_IP6_NF_IPTABLES=y
# CONFIG_IP6_NF_MATCH_AH is not set
# CONFIG_IP6_NF_MATCH_EUI64 is not set
# CONFIG_IP6_NF_MATCH_FRAG is not set
# CONFIG_IP6_NF_MATCH_OPTS is not set
# CONFIG_IP6_NF_MATCH_HL is not set
# CONFIG_IP6_NF_MATCH_IPV6HEADER is not set
# CONFIG_IP6_NF_MATCH_MH is not set
# CONFIG_IP6_NF_MATCH_RPFILTER is not set
# CONFIG_IP6_NF_MATCH_RT is not set
# CONFIG_IP6_NF_TARGET_HL is not set
CONFIG_IP6_NF_FILTER=y
# CONFIG_IP6_NF_TARGET_REJECT is not set
# CONFIG_IP6_NF_TARGET_SYNPROXY is not set
CONFIG_IP6_NF_MANGLE=y
# CONFIG_IP6_NF_RAW is not set
# CONFIG_IP6_NF_SECURITY is not set
CONFIG_BRIDGE_NF_EBTABLES=y
# CONFIG_BRIDGE_EBT_BROUTE is not set
CONFIG_BRIDGE_EBT_T_FILTER=y
# CONFIG_BRIDGE_EBT_T_NAT is not set
# CONFIG_BRIDGE_EBT_802_3 is not set
# CONFIG_BRIDGE_EBT_AMONG is not set
# CONFIG_BRIDGE_EBT_ARP is not set
# CONFIG_BRIDGE_EBT_IP is not set
# CONFIG_BRIDGE_EBT_IP6 is not set
# CONFIG_BRIDGE_EBT_LIMIT is not set
# CONFIG_BRIDGE_EBT_MARK is not set
# CONFIG_BRIDGE_EBT_PKTTYPE is not set
# CONFIG_BRIDGE_EBT_STP is not set
# CONFIG_BRIDGE_EBT_VLAN is not set
# CONFIG_BRIDGE_EBT_ARPREPLY is not set
# CONFIG_BRIDGE_EBT_DNAT is not set
# CONFIG_BRIDGE_EBT_MARK_T is not set
# CONFIG_BRIDGE_EBT_REDIRECT is not set
# CONFIG_BRIDGE_EBT_SNAT is not set
# CONFIG_BRIDGE_EBT_LOG is not set
# CONFIG_BRIDGE_EBT_NFLOG is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
CONFIG_STP=y
CONFIG_GARP=y
CONFIG_MRP=y
CONFIG_BRIDGE=y
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_BRIDGE_VLAN_FILTERING=y
CONFIG_HAVE_NET_DSA=y
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_VLAN_8021Q_MVRP=y
# CONFIG_DECNET is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
# CONFIG_6LOWPAN is not set
# CONFIG_IEEE802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
# CONFIG_NET_SCH_HTB is not set
# CONFIG_NET_SCH_HFSC is not set
# CONFIG_NET_SCH_PRIO is not set
# CONFIG_NET_SCH_MULTIQ is not set
# CONFIG_NET_SCH_RED is not set
# CONFIG_NET_SCH_SFB is not set
# CONFIG_NET_SCH_SFQ is not set
# CONFIG_NET_SCH_TEQL is not set
# CONFIG_NET_SCH_TBF is not set
# CONFIG_NET_SCH_GRED is not set
# CONFIG_NET_SCH_DSMARK is not set
# CONFIG_NET_SCH_NETEM is not set
# CONFIG_NET_SCH_DRR is not set
# CONFIG_NET_SCH_MQPRIO is not set
# CONFIG_NET_SCH_CHOKE is not set
# CONFIG_NET_SCH_QFQ is not set
# CONFIG_NET_SCH_CODEL is not set
CONFIG_NET_SCH_FQ_CODEL=y
# CONFIG_NET_SCH_FQ is not set
# CONFIG_NET_SCH_HHF is not set
# CONFIG_NET_SCH_PIE is not set
# CONFIG_NET_SCH_INGRESS is not set
# CONFIG_NET_SCH_PLUG is not set

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
# CONFIG_NET_CLS_TCINDEX is not set
# CONFIG_NET_CLS_ROUTE4 is not set
# CONFIG_NET_CLS_FW is not set
# CONFIG_NET_CLS_U32 is not set
# CONFIG_NET_CLS_RSVP is not set
# CONFIG_NET_CLS_RSVP6 is not set
# CONFIG_NET_CLS_FLOW is not set
CONFIG_NET_CLS_CGROUP=y
# CONFIG_NET_CLS_BPF is not set
# CONFIG_NET_CLS_FLOWER is not set
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
# CONFIG_NET_EMATCH_CMP is not set
# CONFIG_NET_EMATCH_NBYTE is not set
# CONFIG_NET_EMATCH_U32 is not set
# CONFIG_NET_EMATCH_META is not set
# CONFIG_NET_EMATCH_TEXT is not set
CONFIG_NET_CLS_ACT=y
# CONFIG_NET_ACT_POLICE is not set
# CONFIG_NET_ACT_GACT is not set
# CONFIG_NET_ACT_MIRRED is not set
# CONFIG_NET_ACT_IPT is not set
# CONFIG_NET_ACT_NAT is not set
# CONFIG_NET_ACT_PEDIT is not set
# CONFIG_NET_ACT_SIMP is not set
# CONFIG_NET_ACT_SKBEDIT is not set
# CONFIG_NET_ACT_CSUM is not set
# CONFIG_NET_ACT_VLAN is not set
# CONFIG_NET_ACT_BPF is not set
# CONFIG_NET_ACT_CONNMARK is not set
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=y
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
CONFIG_NETLINK_MMAP=y
# CONFIG_NETLINK_DIAG is not set
CONFIG_MPLS=y
# CONFIG_NET_MPLS_GSO is not set
# CONFIG_MPLS_ROUTING is not set
# CONFIG_HSR is not set
CONFIG_NET_SWITCHDEV=y
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_CGROUP_NET_PRIO=y
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_BPF_JIT=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_TCPPROBE is not set
CONFIG_NET_DROP_MONITOR=y
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
# CONFIG_AX25 is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
CONFIG_MAC80211_STA_HASH_MAX_SIZE=0
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_CEPH_LIB is not set
# CONFIG_NFC is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
# CONFIG_UEVENT_HELPER is not set
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
CONFIG_FW_LOADER_USER_HELPER_FALLBACK=y
CONFIG_ALLOW_DEV_COREDUMP=y
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
CONFIG_SYS_HYPERVISOR=y
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_FENCE_TRACE is not set
CONFIG_DMA_CMA=y

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_MBYTES=600
CONFIG_CMA_SIZE_SEL_MBYTES=y
# CONFIG_CMA_SIZE_SEL_PERCENTAGE is not set
# CONFIG_CMA_SIZE_SEL_MIN is not set
# CONFIG_CMA_SIZE_SEL_MAX is not set
CONFIG_CMA_ALIGNMENT=8

#
# Bus devices
#
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_MTD is not set
# CONFIG_OF is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT=y
CONFIG_PARPORT_PC=y
# CONFIG_PARPORT_SERIAL is not set
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_PC_PCMCIA is not set
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_NULL_BLK is not set
CONFIG_BLK_DEV_FD=y
# CONFIG_PARIDE is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_ZRAM is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SKD is not set
# CONFIG_BLK_DEV_SX8 is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=1
CONFIG_BLK_DEV_RAM_SIZE=1048576
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_XEN_BLKDEV_FRONTEND is not set
# CONFIG_XEN_BLKDEV_BACKEND is not set
CONFIG_VIRTIO_BLK=y
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_AD525X_DPOT is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_SGI_XP is not set
# CONFIG_HP_ILO is not set
# CONFIG_SGI_GRU is not set
# CONFIG_APDS9802ALS is not set
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_SENSORS_BH1780 is not set
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_BMP085_I2C is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_SRAM is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
# CONFIG_INTEL_MEI is not set
# CONFIG_INTEL_MEI_ME is not set
# CONFIG_INTEL_MEI_TXE is not set
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC Bus Driver
#
# CONFIG_INTEL_MIC_BUS is not set

#
# SCIF Bus Driver
#
# CONFIG_SCIF_BUS is not set

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#

#
# SCIF Driver
#
# CONFIG_GENWQE is not set
# CONFIG_ECHO is not set
# CONFIG_CXL_BASE is not set
# CONFIG_CXL_KERNEL_API is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_NETLINK is not set
# CONFIG_SCSI_MQ_DEFAULT is not set
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_ISCSI_BOOT_SYSFS is not set
# CONFIG_SCSI_CXGB3_ISCSI is not set
# CONFIG_SCSI_CXGB4_ISCSI is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_MVUMI is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_SCSI_ESAS2R is not set
CONFIG_MEGARAID_NEWGEN=y
# CONFIG_MEGARAID_MM is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_MPT3SAS is not set
# CONFIG_SCSI_UFSHCD is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_VMWARE_PVSCSI is not set
# CONFIG_XEN_SCSI_FRONTEND is not set
# CONFIG_SCSI_SNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_ISCI is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_PPA is not set
# CONFIG_SCSI_IMM is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_AM53C974 is not set
# CONFIG_SCSI_WD719X is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_VIRTIO is not set
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
CONFIG_SCSI_DH=y
# CONFIG_SCSI_DH_RDAC is not set
# CONFIG_SCSI_DH_HP_SW is not set
# CONFIG_SCSI_DH_EMC is not set
# CONFIG_SCSI_DH_ALUA is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=y
# CONFIG_SATA_AHCI_PLATFORM is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_SX4 is not set
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=y
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_SVW is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_SCH is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_PCMCIA is not set
# CONFIG_PATA_PLATFORM is not set
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
CONFIG_PATA_ACPI=y
CONFIG_ATA_GENERIC=y
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
# CONFIG_MD_LINEAR is not set
# CONFIG_MD_RAID0 is not set
# CONFIG_MD_RAID1 is not set
# CONFIG_MD_RAID10 is not set
# CONFIG_MD_RAID456 is not set
# CONFIG_MD_MULTIPATH is not set
# CONFIG_MD_FAULTY is not set
# CONFIG_BCACHE is not set
CONFIG_BLK_DEV_DM_BUILTIN=y
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_MQ_DEFAULT is not set
CONFIG_DM_DEBUG=y
CONFIG_DM_BUFIO=y
# CONFIG_DM_CRYPT is not set
CONFIG_DM_SNAPSHOT=y
# CONFIG_DM_THIN_PROVISIONING is not set
# CONFIG_DM_CACHE is not set
# CONFIG_DM_ERA is not set
CONFIG_DM_MIRROR=y
# CONFIG_DM_LOG_USERSPACE is not set
# CONFIG_DM_RAID is not set
CONFIG_DM_ZERO=y
# CONFIG_DM_MULTIPATH is not set
# CONFIG_DM_DELAY is not set
CONFIG_DM_UEVENT=y
# CONFIG_DM_FLAKEY is not set
# CONFIG_DM_VERITY is not set
# CONFIG_DM_SWITCH is not set
# CONFIG_DM_LOG_WRITES is not set
# CONFIG_TARGET_CORE is not set
CONFIG_FUSION=y
# CONFIG_FUSION_SPI is not set
# CONFIG_FUSION_SAS is not set
CONFIG_FUSION_MAX_SGE=40
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
# CONFIG_BONDING is not set
# CONFIG_DUMMY is not set
# CONFIG_EQUALIZER is not set
CONFIG_NET_FC=y
# CONFIG_IFB is not set
# CONFIG_NET_TEAM is not set
# CONFIG_MACVLAN is not set
# CONFIG_IPVLAN is not set
# CONFIG_VXLAN is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
CONFIG_TUN=y
# CONFIG_TUN_VNET_CROSS_LE is not set
# CONFIG_VETH is not set
CONFIG_VIRTIO_NET=y
# CONFIG_NLMON is not set
# CONFIG_ARCNET is not set

#
# CAIF transport drivers
#
# CONFIG_VHOST_NET is not set
# CONFIG_VHOST_CROSS_ENDIAN_LEGACY is not set

#
# Distributed Switch Architecture drivers
#
# CONFIG_NET_DSA_MV88E6XXX is not set
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
CONFIG_ETHERNET=y
CONFIG_NET_VENDOR_3COM=y
# CONFIG_PCMCIA_3C574 is not set
# CONFIG_PCMCIA_3C589 is not set
# CONFIG_VORTEX is not set
# CONFIG_TYPHOON is not set
CONFIG_NET_VENDOR_ADAPTEC=y
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_NET_VENDOR_AGERE=y
# CONFIG_ET131X is not set
CONFIG_NET_VENDOR_ALTEON=y
# CONFIG_ACENIC is not set
# CONFIG_ALTERA_TSE is not set
CONFIG_NET_VENDOR_AMD=y
# CONFIG_AMD8111_ETH is not set
# CONFIG_PCNET32 is not set
# CONFIG_PCMCIA_NMCLAN is not set
CONFIG_NET_VENDOR_ARC=y
CONFIG_NET_VENDOR_ATHEROS=y
# CONFIG_ATL2 is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_ALX is not set
CONFIG_NET_CADENCE=y
# CONFIG_MACB is not set
CONFIG_NET_VENDOR_BROADCOM=y
# CONFIG_B44 is not set
# CONFIG_BCMGENET is not set
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2X is not set
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
CONFIG_NET_VENDOR_CAVIUM=y
# CONFIG_THUNDER_NIC_PF is not set
# CONFIG_THUNDER_NIC_VF is not set
# CONFIG_THUNDER_NIC_BGX is not set
# CONFIG_LIQUIDIO is not set
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
# CONFIG_CHELSIO_T4 is not set
# CONFIG_CHELSIO_T4VF is not set
CONFIG_NET_VENDOR_CISCO=y
# CONFIG_ENIC is not set
# CONFIG_CX_ECAT is not set
# CONFIG_DNET is not set
CONFIG_NET_VENDOR_DEC=y
CONFIG_NET_TULIP=y
# CONFIG_DE2104X is not set
# CONFIG_TULIP is not set
# CONFIG_DE4X5 is not set
# CONFIG_WINBOND_840 is not set
# CONFIG_DM9102 is not set
# CONFIG_ULI526X is not set
# CONFIG_PCMCIA_XIRCOM is not set
CONFIG_NET_VENDOR_DLINK=y
# CONFIG_DL2K is not set
# CONFIG_SUNDANCE is not set
CONFIG_NET_VENDOR_EMULEX=y
# CONFIG_BE2NET is not set
CONFIG_NET_VENDOR_EZCHIP=y
CONFIG_NET_VENDOR_EXAR=y
# CONFIG_S2IO is not set
# CONFIG_VXGE is not set
# CONFIG_NET_VENDOR_FUJITSU is not set
# CONFIG_NET_VENDOR_HP is not set
CONFIG_NET_VENDOR_INTEL=y
# CONFIG_E100 is not set
# CONFIG_E1000 is not set
# CONFIG_E1000E is not set
# CONFIG_IGB is not set
# CONFIG_IGBVF is not set
# CONFIG_IXGB is not set
# CONFIG_IXGBE is not set
# CONFIG_IXGBEVF is not set
# CONFIG_I40E is not set
# CONFIG_I40EVF is not set
# CONFIG_FM10K is not set
# CONFIG_NET_VENDOR_I825XX is not set
# CONFIG_IP1000 is not set
# CONFIG_JME is not set
CONFIG_NET_VENDOR_MARVELL=y
# CONFIG_MVMDIO is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
# CONFIG_MLX4_CORE is not set
# CONFIG_MLX5_CORE is not set
CONFIG_NET_VENDOR_MICREL=y
# CONFIG_KS8851_MLL is not set
# CONFIG_KSZ884X_PCI is not set
CONFIG_NET_VENDOR_MYRI=y
# CONFIG_MYRI10GE is not set
# CONFIG_FEALNX is not set
CONFIG_NET_VENDOR_NATSEMI=y
# CONFIG_NATSEMI is not set
# CONFIG_NS83820 is not set
CONFIG_NET_VENDOR_8390=y
# CONFIG_PCMCIA_AXNET is not set
# CONFIG_NE2K_PCI is not set
# CONFIG_PCMCIA_PCNET is not set
CONFIG_NET_VENDOR_NVIDIA=y
# CONFIG_FORCEDETH is not set
CONFIG_NET_VENDOR_OKI=y
# CONFIG_ETHOC is not set
CONFIG_NET_PACKET_ENGINE=y
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_NET_VENDOR_QLOGIC=y
# CONFIG_QLA3XXX is not set
# CONFIG_QLCNIC is not set
# CONFIG_QLGE is not set
# CONFIG_NETXEN_NIC is not set
# CONFIG_NET_VENDOR_QUALCOMM is not set
CONFIG_NET_VENDOR_REALTEK=y
# CONFIG_ATP is not set
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
# CONFIG_R8169 is not set
CONFIG_NET_VENDOR_RENESAS=y
CONFIG_NET_VENDOR_RDC=y
# CONFIG_R6040 is not set
CONFIG_NET_VENDOR_ROCKER=y
# CONFIG_ROCKER is not set
# CONFIG_NET_VENDOR_SAMSUNG is not set
# CONFIG_NET_VENDOR_SEEQ is not set
CONFIG_NET_VENDOR_SILAN=y
# CONFIG_SC92031 is not set
CONFIG_NET_VENDOR_SIS=y
# CONFIG_SIS900 is not set
# CONFIG_SIS190 is not set
# CONFIG_SFC is not set
CONFIG_NET_VENDOR_SMSC=y
# CONFIG_PCMCIA_SMC91C92 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SMSC911X is not set
# CONFIG_SMSC9420 is not set
CONFIG_NET_VENDOR_STMICRO=y
# CONFIG_STMMAC_ETH is not set
CONFIG_NET_VENDOR_SUN=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NIU is not set
CONFIG_NET_VENDOR_TEHUTI=y
# CONFIG_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
# CONFIG_TI_CPSW_ALE is not set
# CONFIG_TLAN is not set
CONFIG_NET_VENDOR_VIA=y
# CONFIG_VIA_RHINE is not set
# CONFIG_VIA_VELOCITY is not set
CONFIG_NET_VENDOR_WIZNET=y
# CONFIG_WIZNET_W5100 is not set
# CONFIG_WIZNET_W5300 is not set
CONFIG_NET_VENDOR_XIRCOM=y
# CONFIG_PCMCIA_XIRC2PS is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_AT803X_PHY is not set
# CONFIG_AMD_PHY is not set
# CONFIG_MARVELL_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_QSEMI_PHY is not set
# CONFIG_LXT_PHY is not set
# CONFIG_CICADA_PHY is not set
# CONFIG_VITESSE_PHY is not set
# CONFIG_SMSC_PHY is not set
# CONFIG_BROADCOM_PHY is not set
# CONFIG_BCM7XXX_PHY is not set
# CONFIG_BCM87XX_PHY is not set
# CONFIG_ICPLUS_PHY is not set
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
# CONFIG_STE10XP is not set
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_MICREL_PHY is not set
# CONFIG_DP83867_PHY is not set
CONFIG_FIXED_PHY=y
# CONFIG_MDIO_BITBANG is not set
# CONFIG_MDIO_BCM_UNIMAC is not set
# CONFIG_PLIP is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
CONFIG_USB_NET_DRIVERS=y
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_RTL8152 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_USB_IPHETH is not set
CONFIG_WLAN=y
# CONFIG_PCMCIA_RAYCS is not set
# CONFIG_PRISM54 is not set
# CONFIG_HOSTAP is not set
# CONFIG_WL_MEDIATEK is not set
# CONFIG_WL_TI is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_WAN is not set
# CONFIG_XEN_NETDEV_FRONTEND is not set
# CONFIG_XEN_NETDEV_BACKEND is not set
# CONFIG_VMXNET3 is not set
CONFIG_ISDN=y
# CONFIG_ISDN_I4L is not set
# CONFIG_ISDN_CAPI is not set
# CONFIG_ISDN_DRV_GIGASET is not set
# CONFIG_HYSDN is not set
# CONFIG_MISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_LEDS=y
CONFIG_INPUT_FF_MEMLESS=y
# CONFIG_INPUT_POLLDEV is not set
# CONFIG_INPUT_SPARSEKMAP is not set
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_SAMSUNG is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_SENTELIC=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_PS2_FOCALTECH=y
CONFIG_MOUSE_PS2_VMMOUSE=y
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_CYAPA is not set
# CONFIG_MOUSE_ELAN_I2C is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_GPIO is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
# CONFIG_JOYSTICK_A3D is not set
# CONFIG_JOYSTICK_ADI is not set
# CONFIG_JOYSTICK_COBRA is not set
# CONFIG_JOYSTICK_GF2K is not set
# CONFIG_JOYSTICK_GRIP is not set
# CONFIG_JOYSTICK_GRIP_MP is not set
# CONFIG_JOYSTICK_GUILLEMOT is not set
# CONFIG_JOYSTICK_INTERACT is not set
# CONFIG_JOYSTICK_SIDEWINDER is not set
# CONFIG_JOYSTICK_TMDC is not set
# CONFIG_JOYSTICK_IFORCE is not set
# CONFIG_JOYSTICK_WARRIOR is not set
# CONFIG_JOYSTICK_MAGELLAN is not set
# CONFIG_JOYSTICK_SPACEORB is not set
# CONFIG_JOYSTICK_SPACEBALL is not set
# CONFIG_JOYSTICK_STINGER is not set
# CONFIG_JOYSTICK_TWIDJOY is not set
# CONFIG_JOYSTICK_ZHENHUA is not set
# CONFIG_JOYSTICK_DB9 is not set
# CONFIG_JOYSTICK_GAMECON is not set
# CONFIG_JOYSTICK_TURBOGRAFX is not set
# CONFIG_JOYSTICK_AS5011 is not set
# CONFIG_JOYSTICK_JOYDUMP is not set
# CONFIG_JOYSTICK_XPAD is not set
# CONFIG_JOYSTICK_WALKERA0701 is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_GTCO is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_SERIAL_WACOM4 is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
# CONFIG_TOUCHSCREEN_AUO_PIXCIR is not set
# CONFIG_TOUCHSCREEN_BU21013 is not set
# CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
# CONFIG_TOUCHSCREEN_CYTTSP4_CORE is not set
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
# CONFIG_TOUCHSCREEN_EETI is not set
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_GOODIX is not set
# CONFIG_TOUCHSCREEN_ILI210X is not set
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_ELAN is not set
# CONFIG_TOUCHSCREEN_ELO is not set
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
# CONFIG_TOUCHSCREEN_WACOM_I2C is not set
# CONFIG_TOUCHSCREEN_MAX11801 is not set
# CONFIG_TOUCHSCREEN_MCS5000 is not set
# CONFIG_TOUCHSCREEN_MMS114 is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_INEXIO is not set
# CONFIG_TOUCHSCREEN_MK712 is not set
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
# CONFIG_TOUCHSCREEN_PIXCIR is not set
# CONFIG_TOUCHSCREEN_WDT87XX_I2C is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
# CONFIG_TOUCHSCREEN_TSC2007 is not set
# CONFIG_TOUCHSCREEN_ST1232 is not set
# CONFIG_TOUCHSCREEN_SX8654 is not set
# CONFIG_TOUCHSCREEN_TPS6507X is not set
# CONFIG_TOUCHSCREEN_ZFORCE is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_BMA150 is not set
# CONFIG_INPUT_E3X0_BUTTON is not set
CONFIG_INPUT_PCSPKR=y
# CONFIG_INPUT_MMA8450 is not set
# CONFIG_INPUT_MPU3050 is not set
# CONFIG_INPUT_APANEL is not set
# CONFIG_INPUT_GP2A is not set
# CONFIG_INPUT_GPIO_BEEPER is not set
# CONFIG_INPUT_GPIO_TILT_POLLED is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_KXTJ9 is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
# CONFIG_INPUT_UINPUT is not set
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_IMS_PCU is not set
# CONFIG_INPUT_CMA3000 is not set
CONFIG_INPUT_XEN_KBDDEV_FRONTEND=y
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set
# CONFIG_INPUT_DRV260X_HAPTICS is not set
# CONFIG_INPUT_DRV2665_HAPTICS is not set
# CONFIG_INPUT_DRV2667_HAPTICS is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_SERIO_ARC_PS2 is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
# CONFIG_CYCLADES is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_SYNCLINK is not set
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
# CONFIG_NOZOMI is not set
# CONFIG_ISI is not set
# CONFIG_N_HDLC is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
CONFIG_DEVMEM=y
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=32
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y
# CONFIG_SERIAL_8250_DW is not set
# CONFIG_SERIAL_8250_FINTEK is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_KGDB_NMI is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_CONSOLE_POLL=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_SC16IS7XX is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_PRINTER is not set
CONFIG_PPDEV=y
CONFIG_HVC_DRIVER=y
CONFIG_HVC_IRQ=y
CONFIG_HVC_XEN=y
CONFIG_HVC_XEN_FRONTEND=y
CONFIG_VIRTIO_CONSOLE=y
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
# CONFIG_HW_RANDOM_INTEL is not set
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_VIA is not set
# CONFIG_HW_RANDOM_VIRTIO is not set
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
# CONFIG_CARDMAN_4040 is not set
# CONFIG_IPWIRELESS is not set
# CONFIG_MWAVE is not set
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=8192
CONFIG_HPET=y
# CONFIG_HPET_MMAP is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_UV_MMTIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
# CONFIG_XILLYBUS is not set

#
# I2C support
#
CONFIG_I2C=y
CONFIG_ACPI_I2C_OPREGION=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
# CONFIG_I2C_CHARDEV is not set
# CONFIG_I2C_MUX is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_ISMT is not set
CONFIG_I2C_PIIX4=y
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_CBUS_GPIO is not set
# CONFIG_I2C_DESIGNWARE_PLATFORM is not set
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
# CONFIG_I2C_PARPORT is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_ROBOTFUZZ_OSIF is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_STUB is not set
CONFIG_I2C_SLAVE=y
# CONFIG_I2C_SLAVE_EEPROM is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
# CONFIG_SPMI is not set
# CONFIG_HSI is not set

#
# PPS support
#
# CONFIG_PPS is not set

#
# PPS generators support
#

#
# PTP clock support
#
# CONFIG_PTP_1588_CLOCK is not set
# CONFIG_DP83640_PHY is not set
CONFIG_PINCTRL=y

#
# Pin controllers
#
# CONFIG_DEBUG_PINCTRL is not set
# CONFIG_PINCTRL_AMD is not set
CONFIG_PINCTRL_BAYTRAIL=y
# CONFIG_PINCTRL_CHERRYVIEW is not set
# CONFIG_PINCTRL_SUNRISEPOINT is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y

#
# Memory mapped GPIO drivers
#
# CONFIG_GPIO_DWAPB is not set
# CONFIG_GPIO_F7188X is not set
# CONFIG_GPIO_GENERIC_PLATFORM is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_IT8761E is not set
# CONFIG_GPIO_LYNXPOINT is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_SCH311X is not set
# CONFIG_GPIO_VX855 is not set

#
# I2C GPIO expanders
#
# CONFIG_GPIO_ADP5588 is not set
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_SX150X is not set

#
# MFD GPIO expanders
#

#
# PCI GPIO expanders
#
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_INTEL_MID is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_RDC321X is not set

#
# USB GPIO expanders
#
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_BQ24190 is not set
# CONFIG_CHARGER_BQ24735 is not set
# CONFIG_CHARGER_BQ25890 is not set
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_BATTERY_GAUGE_LTC2941 is not set
# CONFIG_CHARGER_RT9455 is not set
CONFIG_POWER_RESET=y
# CONFIG_POWER_RESET_RESTART is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
# CONFIG_HWMON_VID is not set
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7410 is not set
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS620 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_DELL_SMM is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_G762 is not set
# CONFIG_SENSORS_GPIO_FAN is not set
# CONFIG_SENSORS_HIH6130 is not set
# CONFIG_SENSORS_I5500 is not set
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_POWR1220 is not set
# CONFIG_SENSORS_LINEAGE is not set
# CONFIG_SENSORS_LTC2945 is not set
# CONFIG_SENSORS_LTC4151 is not set
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4222 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4260 is not set
# CONFIG_SENSORS_LTC4261 is not set
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX1668 is not set
# CONFIG_SENSORS_MAX197 is not set
# CONFIG_SENSORS_MAX6639 is not set
# CONFIG_SENSORS_MAX6642 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_MAX6697 is not set
# CONFIG_SENSORS_HTU21 is not set
# CONFIG_SENSORS_MCP3021 is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LM95234 is not set
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_LM95245 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_NTC_THERMISTOR is not set
# CONFIG_SENSORS_NCT6683 is not set
# CONFIG_SENSORS_NCT6775 is not set
# CONFIG_SENSORS_NCT7802 is not set
# CONFIG_SENSORS_NCT7904 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_PMBUS is not set
# CONFIG_SENSORS_SHT15 is not set
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SHTC1 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
# CONFIG_SENSORS_EMC2103 is not set
# CONFIG_SENSORS_EMC6W201 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_SCH5627 is not set
# CONFIG_SENSORS_SCH5636 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_ADC128D818 is not set
# CONFIG_SENSORS_ADS1015 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_AMC6821 is not set
# CONFIG_SENSORS_INA209 is not set
# CONFIG_SENSORS_INA2XX is not set
# CONFIG_SENSORS_TC74 is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP103 is not set
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
# CONFIG_THERMAL_WRITABLE_TRIPS is not set
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
# CONFIG_THERMAL_DEFAULT_GOV_POWER_ALLOCATOR is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_BANG_BANG=y
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_GOV_POWER_ALLOCATOR is not set
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_INTEL_POWERCLAMP is not set
# CONFIG_X86_PKG_TEMP_THERMAL is not set
# CONFIG_INTEL_SOC_DTS_THERMAL is not set
# CONFIG_INT340X_THERMAL is not set

#
# Texas Instruments thermal drivers
#
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
# CONFIG_XILINX_WATCHDOG is not set
# CONFIG_CADENCE_WATCHDOG is not set
# CONFIG_DW_WATCHDOG is not set
# CONFIG_MAX63XX_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_F71808E_WDT is not set
# CONFIG_SP5100_TCO is not set
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_NV_TCO is not set
# CONFIG_60XX_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC_SCH311X_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_VIA_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set
# CONFIG_MEN_A21_WDT is not set
# CONFIG_XEN_WDT is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_BCM590XX is not set
# CONFIG_MFD_AXP20X is not set
# CONFIG_MFD_CROS_EC is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_DA9063 is not set
# CONFIG_MFD_DA9150 is not set
# CONFIG_MFD_DLN2 is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_HTC_I2CPLD is not set
# CONFIG_MFD_INTEL_QUARK_I2C_GPIO is not set
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_INTEL_SOC_PMIC is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX14577 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX77843 is not set
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_MT6397 is not set
# CONFIG_MFD_MENF21BMC is not set
# CONFIG_MFD_VIPERBOARD is not set
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_RT5033 is not set
# CONFIG_MFD_RTSX_USB is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_RN5T618 is not set
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_SI476X_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_MFD_SKY81452 is not set
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_MFD_LP3943 is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TPS65217 is not set
# CONFIG_MFD_TPS65218 is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
# CONFIG_MFD_TPS65912 is not set
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
CONFIG_AGP_SIS=y
CONFIG_AGP_VIA=y
CONFIG_INTEL_GTT=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
CONFIG_VGA_SWITCHEROO=y

#
# Direct Rendering Manager
#
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_KMS_FB_HELPER=y
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
CONFIG_DRM_TTM=y

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_ADV7511 is not set
# CONFIG_DRM_I2C_CH7006 is not set
# CONFIG_DRM_I2C_SIL164 is not set
# CONFIG_DRM_I2C_NXP_TDA998X is not set
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_AMDGPU is not set
# CONFIG_DRM_NOUVEAU is not set
# CONFIG_DRM_I810 is not set
# CONFIG_DRM_I915 is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_DRM_VGEM is not set
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
CONFIG_DRM_QXL=y
# CONFIG_DRM_BOCHS is not set
# CONFIG_DRM_VIRTIO_GPU is not set

#
# Frame buffer Devices
#
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_CMDLINE=y
# CONFIG_FB_DDC is not set
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
# CONFIG_FB_MODE_HELPERS is not set
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
CONFIG_FB_EFI=y
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_OPENCORES is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_INTEL is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_SMSCUFX is not set
# CONFIG_FB_UDL is not set
# CONFIG_FB_VIRTUAL is not set
CONFIG_XEN_FBDEV_FRONTEND=y
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
# CONFIG_FB_AUO_K190X is not set
# CONFIG_FB_SIMPLE is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_LM3639 is not set
# CONFIG_BACKLIGHT_GPIO is not set
# CONFIG_BACKLIGHT_LV5207LP is not set
# CONFIG_BACKLIGHT_BD6107 is not set
# CONFIG_VGASTATE is not set
CONFIG_HDMI=y

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_DUMMY_CONSOLE_COLUMNS=80
CONFIG_DUMMY_CONSOLE_ROWS=25
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
CONFIG_HIDRAW=y
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=y
# CONFIG_HID_APPLEIR is not set
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=y
# CONFIG_HID_BETOP_FF is not set
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
# CONFIG_HID_CP2112 is not set
CONFIG_HID_CYPRESS=y
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELECOM is not set
# CONFIG_HID_ELO is not set
CONFIG_HID_EZKEY=y
# CONFIG_HID_HOLTEK is not set
# CONFIG_HID_GT683R is not set
# CONFIG_HID_KEYTOUCH is not set
# CONFIG_HID_KYE is not set
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_ICADE is not set
# CONFIG_HID_TWINHAN is not set
CONFIG_HID_KENSINGTON=y
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LENOVO is not set
CONFIG_HID_LOGITECH=y
# CONFIG_HID_LOGITECH_DJ is not set
# CONFIG_HID_LOGITECH_HIDPP is not set
CONFIG_LOGITECH_FF=y
CONFIG_LOGIRUMBLEPAD2_FF=y
CONFIG_LOGIG940_FF=y
CONFIG_LOGIWHEELS_FF=y
CONFIG_HID_MAGICMOUSE=y
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
# CONFIG_HID_MULTITOUCH is not set
CONFIG_HID_NTRIG=y
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PENMOUNT is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PLANTRONICS is not set
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_ROCCAT is not set
# CONFIG_HID_SAITEK is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SONY is not set
# CONFIG_HID_SPEEDLINK is not set
# CONFIG_HID_STEELSERIES is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_RMI is not set
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TIVO is not set
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THINGM is not set
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_WACOM is not set
# CONFIG_HID_WIIMOTE is not set
# CONFIG_HID_XINMO is not set
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
# CONFIG_HID_SENSOR_HUB is not set

#
# USB HID support
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
# CONFIG_USB_OTG_FSM is not set
# CONFIG_USB_ULPI_BUS is not set
CONFIG_USB_MON=y
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=y
CONFIG_USB_XHCI_PCI=y
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=y
# CONFIG_USB_EHCI_HCD_PLATFORM is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
# CONFIG_USB_FUSBH200_HCD is not set
# CONFIG_USB_FOTG210_HCD is not set
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PCI=y
# CONFIG_USB_OHCI_HCD_PLATFORM is not set
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_HCD_TEST_MODE is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
# CONFIG_USB_STORAGE is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set
# CONFIG_USBIP_CORE is not set
# CONFIG_USB_MUSB_HDRC is not set
# CONFIG_USB_DWC3 is not set
# CONFIG_USB_DWC2 is not set
# CONFIG_USB_CHIPIDEA is not set
# CONFIG_USB_ISP1760 is not set

#
# USB port drivers
#
# CONFIG_USB_USS720 is not set
CONFIG_USB_SERIAL=y
CONFIG_USB_SERIAL_CONSOLE=y
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_SIMPLE is not set
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_ARK3116 is not set
# CONFIG_USB_SERIAL_BELKIN is not set
# CONFIG_USB_SERIAL_CH341 is not set
# CONFIG_USB_SERIAL_WHITEHEAT is not set
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
# CONFIG_USB_SERIAL_CP210X is not set
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
# CONFIG_USB_SERIAL_EMPEG is not set
# CONFIG_USB_SERIAL_FTDI_SIO is not set
# CONFIG_USB_SERIAL_VISOR is not set
# CONFIG_USB_SERIAL_IPAQ is not set
# CONFIG_USB_SERIAL_IR is not set
# CONFIG_USB_SERIAL_EDGEPORT is not set
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_F81232 is not set
# CONFIG_USB_SERIAL_GARMIN is not set
# CONFIG_USB_SERIAL_IPW is not set
# CONFIG_USB_SERIAL_IUU is not set
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_KLSI is not set
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
# CONFIG_USB_SERIAL_MCT_U232 is not set
# CONFIG_USB_SERIAL_METRO is not set
# CONFIG_USB_SERIAL_MOS7720 is not set
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_MXUPORT is not set
# CONFIG_USB_SERIAL_NAVMAN is not set
# CONFIG_USB_SERIAL_PL2303 is not set
# CONFIG_USB_SERIAL_OTI6858 is not set
# CONFIG_USB_SERIAL_QCAUX is not set
# CONFIG_USB_SERIAL_QUALCOMM is not set
# CONFIG_USB_SERIAL_SPCP8X5 is not set
# CONFIG_USB_SERIAL_SAFE is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_SYMBOL is not set
# CONFIG_USB_SERIAL_TI is not set
# CONFIG_USB_SERIAL_CYBERJACK is not set
# CONFIG_USB_SERIAL_XIRCOM is not set
# CONFIG_USB_SERIAL_OPTION is not set
# CONFIG_USB_SERIAL_OMNINET is not set
# CONFIG_USB_SERIAL_OPTICON is not set
# CONFIG_USB_SERIAL_XSENS_MT is not set
# CONFIG_USB_SERIAL_WISHBONE is not set
# CONFIG_USB_SERIAL_SSU100 is not set
# CONFIG_USB_SERIAL_QT2 is not set
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
# CONFIG_USB_EZUSB_FX2 is not set
# CONFIG_USB_HSIC_USB3503 is not set
# CONFIG_USB_LINK_LAYER_TEST is not set
# CONFIG_USB_CHAOSKEY is not set

#
# USB Physical Layer drivers
#
# CONFIG_USB_PHY is not set
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_ISP1301 is not set
# CONFIG_USB_GADGET is not set
CONFIG_USB_LED_TRIG=y
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y
# CONFIG_LEDS_CLASS_FLASH is not set

#
# LED drivers
#
# CONFIG_LEDS_LM3530 is not set
# CONFIG_LEDS_LM3642 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_GPIO is not set
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_LP5562 is not set
# CONFIG_LEDS_LP8501 is not set
# CONFIG_LEDS_LP8860 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA963X is not set
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_INTEL_SS4200 is not set
# CONFIG_LEDS_LT3593 is not set
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_TLC591XX is not set
# CONFIG_LEDS_LM355x is not set

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
# CONFIG_LEDS_BLINKM is not set
# CONFIG_LEDS_PM8941_WLED is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_GPIO is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
# CONFIG_LEDS_TRIGGER_CAMERA is not set
CONFIG_ACCESSIBILITY=y
CONFIG_A11Y_BRAILLE_CONSOLE=y
# CONFIG_INFINIBAND is not set
CONFIG_EDAC_ATOMIC_SCRUB=y
CONFIG_EDAC_SUPPORT=y
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
# CONFIG_EDAC_DECODE_MCE is not set
# CONFIG_EDAC_MM_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_SYSTOHC is not set
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_ABB5ZES3 is not set
# CONFIG_RTC_DRV_ABX80X is not set
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_DS3232 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_ISL12022 is not set
# CONFIG_RTC_DRV_ISL12057 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF2127 is not set
# CONFIG_RTC_DRV_PCF8523 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF85063 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_BQ32K is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set
# CONFIG_RTC_DRV_EM3027 is not set
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1685_FAMILY is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_DS2404 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_MSM6242 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_RP5C01 is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#

#
# HID Sensor RTC drivers
#
# CONFIG_RTC_DRV_HID_SENSOR_TIME is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_IOATDMA is not set
# CONFIG_DW_DMAC is not set
# CONFIG_DW_DMAC_PCI is not set
# CONFIG_HSU_DMA_PCI is not set
CONFIG_DMA_ACPI=y
CONFIG_AUXDISPLAY=y
# CONFIG_KS0108 is not set
# CONFIG_UIO is not set
# CONFIG_VFIO is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_PCI_LEGACY=y
CONFIG_VIRTIO_BALLOON=y
# CONFIG_VIRTIO_INPUT is not set
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set

#
# Xen driver support
#
CONFIG_XEN_BALLOON=y
CONFIG_XEN_SELFBALLOONING=y
# CONFIG_XEN_BALLOON_MEMORY_HOTPLUG is not set
CONFIG_XEN_SCRUB_PAGES=y
# CONFIG_XEN_DEV_EVTCHN is not set
CONFIG_XEN_BACKEND=y
# CONFIG_XENFS is not set
CONFIG_XEN_SYS_HYPERVISOR=y
CONFIG_XEN_XENBUS_FRONTEND=y
# CONFIG_XEN_GNTDEV is not set
# CONFIG_XEN_GRANT_DEV_ALLOC is not set
CONFIG_SWIOTLB_XEN=y
CONFIG_XEN_TMEM=m
# CONFIG_XEN_PCIDEV_BACKEND is not set
CONFIG_XEN_PRIVCMD=m
# CONFIG_XEN_ACPI_PROCESSOR is not set
# CONFIG_XEN_MCE_LOG is not set
CONFIG_XEN_HAVE_PVMMU=y
CONFIG_XEN_EFI=y
CONFIG_XEN_AUTO_XLATE=y
CONFIG_XEN_ACPI=y
CONFIG_STAGING=y
# CONFIG_SLICOSS is not set
# CONFIG_COMEDI is not set
# CONFIG_PANEL is not set
# CONFIG_RTL8192U is not set
# CONFIG_RTLLIB is not set
# CONFIG_R8712U is not set
# CONFIG_R8188EU is not set
# CONFIG_RTS5208 is not set
# CONFIG_FB_SM7XX is not set
# CONFIG_FB_SM750 is not set
# CONFIG_FB_XGI is not set
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
# CONFIG_SPEAKUP is not set
# CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
CONFIG_STAGING_MEDIA=y

#
# Android
#
# CONFIG_USB_WPAN_HCD is not set
# CONFIG_WIMAX_GDM72XX is not set
# CONFIG_LTE_GDM724X is not set
# CONFIG_LUSTRE_FS is not set
# CONFIG_DGNC is not set
# CONFIG_DGAP is not set
# CONFIG_GS_FPGABOOT is not set
# CONFIG_CRYPTO_SKEIN is not set
# CONFIG_UNISYSSPAR is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_DELL_SMO8800 is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WIRELESS is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_TOSHIBA_HAPS is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_SAMSUNG_LAPTOP is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
# CONFIG_INTEL_RST is not set
CONFIG_INTEL_SMARTCONNECT=y
CONFIG_PVPANIC=y
# CONFIG_INTEL_PMC_IPC is not set
CONFIG_CHROME_PLATFORMS=y
# CONFIG_CHROMEOS_LAPTOP is not set
# CONFIG_CHROMEOS_PSTORE is not set
CONFIG_CLKDEV_LOOKUP=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y

#
# Common Clock Framework
#
# CONFIG_COMMON_CLK_SI5351 is not set
# CONFIG_COMMON_CLK_PXA is not set
# CONFIG_COMMON_CLK_CDCE706 is not set

#
# Hardware Spinlock drivers
#

#
# Clock Source drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_ATMEL_PIT is not set
# CONFIG_SH_TIMER_CMT is not set
# CONFIG_SH_TIMER_MTU2 is not set
# CONFIG_SH_TIMER_TMU is not set
# CONFIG_EM_TIMER_STI is not set
# CONFIG_MAILBOX is not set
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y

#
# Generic IOMMU Pagetable Support
#
CONFIG_IOMMU_IOVA=y
CONFIG_AMD_IOMMU=y
CONFIG_AMD_IOMMU_STATS=y
# CONFIG_AMD_IOMMU_V2 is not set
CONFIG_DMAR_TABLE=y
CONFIG_INTEL_IOMMU=y
# CONFIG_INTEL_IOMMU_DEFAULT_ON is not set
CONFIG_INTEL_IOMMU_FLOPPY_WA=y
CONFIG_IRQ_REMAP=y

#
# Remoteproc drivers
#
# CONFIG_STE_MODEM_RPROC is not set

#
# Rpmsg drivers
#

#
# SOC (System On Chip) specific Drivers
#
# CONFIG_SUNXI_SRAM is not set
# CONFIG_SOC_TI is not set
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
# CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND is not set
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
# CONFIG_DEVFREQ_GOV_POWERSAVE is not set
# CONFIG_DEVFREQ_GOV_USERSPACE is not set

#
# DEVFREQ Drivers
#
# CONFIG_PM_DEVFREQ_EVENT is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
# CONFIG_IPACK_BUS is not set
CONFIG_RESET_CONTROLLER=y
# CONFIG_FMC is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
# CONFIG_PHY_PXA_28NM_HSIC is not set
# CONFIG_PHY_PXA_28NM_USB2 is not set
# CONFIG_BCM_KONA_USB2_PHY is not set
CONFIG_POWERCAP=y
# CONFIG_INTEL_RAPL is not set
# CONFIG_MCB is not set
CONFIG_RAS=y
# CONFIG_THUNDERBOLT is not set

#
# Android
#
# CONFIG_ANDROID is not set
CONFIG_LIBNVDIMM=y
CONFIG_BLK_DEV_PMEM=m
CONFIG_ND_BLK=m
CONFIG_ND_BTT=m
CONFIG_BTT=y

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_ISCSI_IBFT is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# EFI (Extensible Firmware Interface) Support
#
CONFIG_EFI_VARS=y
CONFIG_EFI_ESRT=y
CONFIG_EFI_VARS_PSTORE=y
CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE=y
CONFIG_EFI_RUNTIME_MAP=y
CONFIG_EFI_RUNTIME_WRAPPERS=y
CONFIG_UEFI_CPER=y

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_USE_FOR_EXT23=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_ENCRYPTION is not set
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
CONFIG_XFS_DEBUG=y
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
# CONFIG_NILFS2_FS is not set
# CONFIG_F2FS_FS is not set
# CONFIG_FS_DAX is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
# CONFIG_CUSE is not set
# CONFIG_OVERLAY_FS is not set

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_STATS=y
# CONFIG_FSCACHE_HISTOGRAM is not set
# CONFIG_FSCACHE_DEBUG is not set
CONFIG_FSCACHE_OBJECT_LIST=y
# CONFIG_CACHEFILES is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
# CONFIG_MSDOS_FS is not set
# CONFIG_VFAT_FS is not set
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
# CONFIG_PROC_CHILDREN is not set
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_EFIVAR_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_LOGFS is not set
# CONFIG_CRAMFS is not set
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_QNX6FS_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
# CONFIG_PSTORE_CONSOLE is not set
# CONFIG_PSTORE_PMSG is not set
# CONFIG_PSTORE_FTRACE is not set
# CONFIG_PSTORE_RAM is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
# CONFIG_NFS_V2 is not set
# CONFIG_NFS_V3 is not set
CONFIG_NFS_V4=y
CONFIG_NFS_SWAP=y
CONFIG_NFS_V4_1=y
CONFIG_NFS_V4_2=y
CONFIG_PNFS_FILE_LAYOUT=y
CONFIG_PNFS_BLOCK=y
CONFIG_NFS_V4_1_IMPLEMENTATION_ID_DOMAIN="kernel.org"
# CONFIG_NFS_V4_1_MIGRATION is not set
CONFIG_NFS_V4_SECURITY_LABEL=y
CONFIG_NFS_FSCACHE=y
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
CONFIG_NFS_DEBUG=y
CONFIG_NFSD=y
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
CONFIG_NFSD_PNFS=y
CONFIG_NFSD_V4_SECURITY_LABEL=y
# CONFIG_NFSD_FAULT_INJECTION is not set
CONFIG_GRACE_PERIOD=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
CONFIG_SUNRPC_BACKCHANNEL=y
CONFIG_SUNRPC_SWAP=y
CONFIG_RPCSEC_GSS_KRB5=y
CONFIG_SUNRPC_DEBUG=y
# CONFIG_CEPH_FS is not set
# CONFIG_CIFS is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
# CONFIG_NLS_MAC_CYRILLIC is not set
# CONFIG_NLS_MAC_GAELIC is not set
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
# CONFIG_NLS_MAC_TURKISH is not set
# CONFIG_NLS_UTF8 is not set
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
CONFIG_BOOT_PRINTK_DELAY=y
CONFIG_DYNAMIC_DEBUG=y

#
# Compile-time checks and compiler options
#
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_INFO_REDUCED is not set
# CONFIG_DEBUG_INFO_SPLIT is not set
# CONFIG_DEBUG_INFO_DWARF4 is not set
# CONFIG_GDB_SCRIPTS is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
# CONFIG_PAGE_OWNER is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x0
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_PAGE_EXTENSION is not set
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VM_VMACACHE is not set
# CONFIG_DEBUG_VM_RB is not set
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_HAVE_ARCH_KASAN=y
# CONFIG_KASAN is not set
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHED_INFO=y
# CONFIG_SCHEDSTATS is not set
# CONFIG_SCHED_STACK_END_CHECK is not set
# CONFIG_DEBUG_TIMEKEEPING is not set
CONFIG_TIMER_STATS=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_ATOMIC_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_LOCK_TORTURE_TEST is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_PI_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
# CONFIG_PROVE_RCU is not set
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_TORTURE_TEST is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=60
CONFIG_RCU_CPU_STALL_INFO=y
# CONFIG_RCU_TRACE is not set
# CONFIG_RCU_EQS_DEBUG is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
# CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP is not set
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_STACK_TRACER=y
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_KPROBE_EVENT=y
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_TRACEPOINT_BENCHMARK is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set
# CONFIG_TRACE_ENUM_MAP_FILE is not set

#
# Runtime Testing
#
# CONFIG_LKDTM is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_PERCPU_TEST is not set
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_TEST_HEXDUMP is not set
# CONFIG_TEST_STRING_HELPERS is not set
CONFIG_TEST_KSTRTOX=y
# CONFIG_TEST_RHASHTABLE is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
CONFIG_BUILD_DOCSRC=y
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_TEST_LKM is not set
# CONFIG_TEST_USER_COPY is not set
# CONFIG_TEST_BPF is not set
# CONFIG_TEST_FIRMWARE is not set
# CONFIG_TEST_UDELAY is not set
# CONFIG_MEMTEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_KGDB=y
CONFIG_KGDB_SERIAL_CONSOLE=y
CONFIG_KGDB_TESTS=y
# CONFIG_KGDB_TESTS_ON_BOOT is not set
CONFIG_KGDB_LOW_LEVEL_TRAP=y
CONFIG_KGDB_KDB=y
CONFIG_KDB_DEFAULT_ENABLE=0x0
CONFIG_KDB_KEYBOARD=y
CONFIG_KDB_CONTINUE_CATASTROPHIC=0
CONFIG_STRICT_DEVMEM=y
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_EARLY_PRINTK_EFI=y
CONFIG_X86_PTDUMP=y
# CONFIG_EFI_PGT_DUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_DEBUG_SET_MODULE_RONX=y
# CONFIG_DEBUG_NX_TEST is not set
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_X86_DECODER_SELFTEST=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_ENTRY is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set
CONFIG_X86_DEBUG_FPU=y
# CONFIG_PUNIT_ATOM_DEBUG is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_PERSISTENT_KEYRINGS=y
CONFIG_BIG_KEYS=y
# CONFIG_ENCRYPTED_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
# CONFIG_SECURITY_PATH is not set
CONFIG_INTEL_TXT=y
CONFIG_LSM_MMAP_MIN_ADDR=65536
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=1
CONFIG_SECURITY_SELINUX_DISABLE=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
# CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
CONFIG_SECURITY_YAMA=y
# CONFIG_SECURITY_YAMA_STACKED is not set
# CONFIG_INTEGRITY is not set
CONFIG_DEFAULT_SECURITY_SELINUX=y
# CONFIG_DEFAULT_SECURITY_YAMA is not set
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="selinux"
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_FIPS=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_RNG_DEFAULT=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_AKCIPHER2=y
# CONFIG_CRYPTO_RSA is not set
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
# CONFIG_CRYPTO_MCRYPTD is not set
# CONFIG_CRYPTO_AUTHENC is not set
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_ABLK_HELPER=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_CHACHA20POLY1305 is not set
CONFIG_CRYPTO_SEQIV=y
# CONFIG_CRYPTO_ECHAINIV is not set

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
# CONFIG_CRYPTO_CMAC is not set
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
# CONFIG_CRYPTO_CRC32 is not set
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=y
# CONFIG_CRYPTO_GHASH is not set
# CONFIG_CRYPTO_POLY1305 is not set
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA1_SSSE3 is not set
# CONFIG_CRYPTO_SHA256_SSSE3 is not set
# CONFIG_CRYPTO_SHA512_SSSE3 is not set
# CONFIG_CRYPTO_SHA1_MB is not set
CONFIG_CRYPTO_SHA256=y
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_BLOWFISH_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAMELLIA_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64 is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST5_AVX_X86_64 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_CAST6_AVX_X86_64 is not set
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_DES3_EDE_X86_64 is not set
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
# CONFIG_CRYPTO_CHACHA20 is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
# CONFIG_CRYPTO_SERPENT_AVX_X86_64 is not set
# CONFIG_CRYPTO_SERPENT_AVX2_X86_64 is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_X86_64 is not set
# CONFIG_CRYPTO_TWOFISH_X86_64_3WAY is not set
# CONFIG_CRYPTO_TWOFISH_AVX_X86_64 is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_ZLIB is not set
CONFIG_CRYPTO_LZO=y
# CONFIG_CRYPTO_842 is not set
# CONFIG_CRYPTO_LZ4 is not set
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_DRBG_MENU=y
CONFIG_CRYPTO_DRBG_HMAC=y
# CONFIG_CRYPTO_DRBG_HASH is not set
# CONFIG_CRYPTO_DRBG_CTR is not set
CONFIG_CRYPTO_DRBG=y
CONFIG_CRYPTO_JITTERENTROPY=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_USER_API_RNG=y
# CONFIG_CRYPTO_USER_API_AEAD is not set
CONFIG_CRYPTO_HASH_INFO=y
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
CONFIG_CRYPTO_DEV_CCP=y
# CONFIG_CRYPTO_DEV_CCP_DD is not set
# CONFIG_CRYPTO_DEV_QAT_DH895xCC is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_PKCS7_MESSAGE_PARSER=y
# CONFIG_PKCS7_TEST_KEY is not set
CONFIG_SIGNED_PE_FILE_VERIFICATION=y
CONFIG_HAVE_KVM=y
CONFIG_KVM_COMPAT=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
# CONFIG_HAVE_ARCH_BITREVERSE is not set
CONFIG_RATIONAL=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_PERCPU_RWSEM=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
# CONFIG_CRC_CCITT is not set
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_GLOB=y
# CONFIG_GLOB_SELFTEST is not set
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y
CONFIG_UCS2_STRING=y
CONFIG_FONT_SUPPORT=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_ARCH_HAS_SG_CHAIN=y
CONFIG_ARCH_HAS_PMEM_API=y

--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--x+6KMIRAuhnl3hBn--
