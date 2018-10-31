Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:59452 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725955AbeJaQbt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Oct 2018 12:31:49 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 2E4F72A64B
        for <linux-xfs@vger.kernel.org>; Wed, 31 Oct 2018 07:34:51 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201577] New: [xfstests generic/070]: XFS corruption and Oops
 when setxattr on 64k blocksize XFS
Date: Wed, 31 Oct 2018 07:34:49 +0000
Message-ID: <bug-201577-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=201577

            Bug ID: 201577
           Summary: [xfstests generic/070]: XFS corruption and Oops when
                    setxattr on 64k blocksize XFS
           Product: File System
           Version: 2.5
    Kernel Version: v4.19
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: zlang@redhat.com
        Regression: No

Description of problem:
xfstests generic/070 fails on kernel 4.19, when test on 64k blocksize XFS:
# ./check generic/070
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/ppc64le ibm-p9z-06-lp1 4.19.0+
MKFS_OPTIONS  -- -f -b size=65536 /dev/sda5
MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 /dev/sda5
/mnt/xfstests/mnt2

generic/070 3s ... _check_xfs_filesystem: filesystem on /dev/sda3 has dirty log
(see /var/lib/xfstests/results//generic/070.full for details)
_check_xfs_filesystem: filesystem on /dev/sda3 is inconsistent (c)
(see /var/lib/xfstests/results//generic/070.full for details)
_check_xfs_filesystem: filesystem on /dev/sda3 is inconsistent (r)
(see /var/lib/xfstests/results//generic/070.full for details)
- output mismatch (see /var/lib/xfstests/results//generic/070.out.bad)
    --- tests/generic/070.out   2018-10-30 02:53:01.357248735 -0400
    +++ /var/lib/xfstests/results//generic/070.out.bad  2018-10-31
03:23:51.821967706 -0400
    @@ -1 +1,2 @@
     QA output created by 070
    +rm: cannot remove '/mnt/xfstests/mnt1/fsstress': Is a directory
    ...
    (Run 'diff -u tests/generic/070.out
/var/lib/xfstests/results//generic/070.out.bad'  to see the entire diff)
Ran: generic/070
Failures: generic/070
Failed 1 of 1 tests
# dmesg
[ 1737.798270] run fstests generic/070 at 2018-10-31 03:23:47
[ 1740.657734] XFS (sda3): Metadata corruption detected at
xfs_attr3_leaf_verify+0x2f0/0x320 [xfs], xfs_attr3_leaf block 0x2d05a00 
[ 1740.657755] XFS (sda3): Unmount and run xfs_repair
[ 1740.657767] XFS (sda3): First 128 bytes of corrupted metadata buffer:
[ 1740.657779] 00000000b4bb4297: 00 00 00 00 00 00 00 00 3b ee 00 00 00 00 00
00  ........;.......
[ 1740.657791] 000000005ec77e26: 00 00 00 00 02 d0 5a 00 00 00 00 00 00 00 00
00  ......Z.........
[ 1740.657803] 0000000015938018: 21 98 e8 b4 fd de 4c 07 bc ea 3c e5 ae b4 7c
48  !.....L...<...|H
[ 1740.657815] 000000004bb71ab9: 00 00 00 00 03 00 05 26 00 04 0e 1c ee 28 01
00  .......&.....(..
[ 1740.657827] 00000000bf96d940: 00 70 ed b8 ff f4 00 0c fb e4 03 b0 00 00 00
00  .p..............
[ 1740.657839] 000000003dbe20a7: 0c 38 5c 34 fa c4 01 00 0c 38 73 31 ee 28 01
00  .8\4.....8s1.(..
[ 1740.657850] 00000000512e45c5: 0c 38 b1 b2 ff 94 01 00 cd 3a 75 d6 ff c4 05
00  .8.......:u.....
[ 1740.657863] 000000008c9563dc: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00  ................
[ 1740.705766] XFS (sda3): xfs_do_force_shutdown(0x8) called from line 1453 of
file fs/xfs/xfs_buf.c. Return address = 00000000debd573a
[ 1740.705783] XFS (sda3): Corruption of in-memory data detected.  Shutting
down filesystem
[ 1740.705795] XFS (sda3): Please unmount the filesystem and rectify the
problem(s)
[ 1741.373384] XFS (sda3): Unmounting Filesystem

If keep running, run generic/070 again (after mkfs), it even cause a Assertion
failure and kernel Oops:
# # mkfs.xfs -f -b size=65536 /dev/sda3
meta-data=/dev/sda3              isize=512    agcount=4, agsize=122880 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1
data     =                       bsize=65536  blocks=491520, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=65536  ascii-ci=0, ftype=1
log      =internal log           bsize=65536  blocks=951, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=65536  blocks=0, rtextents=0
# mkfs.xfs -f -b size=65536 /dev/sda5
meta-data=/dev/sda5              isize=512    agcount=4, agsize=122880 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1
data     =                       bsize=65536  blocks=491520, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=65536  ascii-ci=0, ftype=1
log      =internal log           bsize=65536  blocks=951, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=65536  blocks=0, rtextents=0
# ./check generic/070
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/ppc64le ibm-p9z-06-lp1 4.19.0+
MKFS_OPTIONS  -- -f -b size=65536 /dev/sda5
MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 /dev/sda5
/mnt/xfstests/mnt2

generic/070 3s ... umount: /mnt/xfstests/mnt1: target is busy.
_check_xfs_filesystem: filesystem on /dev/sda3 has dirty log
(see /var/lib/xfstests/results//generic/070.full for details)
_check_xfs_filesystem: filesystem on /dev/sda3 is inconsistent (c)
(see /var/lib/xfstests/results//generic/070.full for details)
_check_xfs_filesystem: filesystem on /dev/sda3 is inconsistent (r)
(see /var/lib/xfstests/results//generic/070.full for details)
_check_dmesg: something found in dmesg (see
/var/lib/xfstests/results//generic/070.dmesg)
- output mismatch (see /var/lib/xfstests/results//generic/070.out.bad)
    --- tests/generic/070.out   2018-10-30 02:53:01.357248735 -0400
    +++ /var/lib/xfstests/results//generic/070.out.bad  2018-10-31
03:28:46.923211040 -0400
    @@ -1 +1,2 @@
     QA output created by 070
    +rm: cannot remove '/mnt/xfstests/mnt1/fsstress': Is a directory
    ...
    (Run 'diff -u tests/generic/070.out
/var/lib/xfstests/results//generic/070.out.bad'  to see the entire diff)
Ran: generic/070
Failures: generic/070
Failed 1 of 1 tests
# dmesg
[ 2034.152185] run fstests generic/070 at 2018-10-31 03:28:44                  
                                                                               
                      [40/9430]
[ 2036.434743] XFS (sda3): Metadata corruption detected at
xfs_attr3_leaf_verify+0x2f0/0x320 [xfs], xfs_attr3_leaf block 0xf00980          
[ 2036.434759] XFS (sda3): Unmount and run xfs_repair                           
[ 2036.434766] XFS (sda3): First 128 bytes of corrupted metadata buffer:        
[ 2036.434774] 0000000023a43335: 00 00 00 00 00 00 00 00 3b ee 00 00 00 00 00
00  ........;.......                                                            
[ 2036.434782] 0000000049638a65: 00 00 00 00 00 f0 09 80 00 00 00 00 00 00 00
00  ................                                                            
[ 2036.434790] 00000000f96e216a: 94 89 69 36 6b 3f 43 85 87 94 d9 a6 ca 87 65
12  ..i6k?C.......e.                                                            
[ 2036.434798] 00000000656aab6b: 00 00 00 00 01 00 05 12 00 02 01 c4 fe 2c 01
00  .............,..                                                            
[ 2036.434806] 00000000241e6087: 00 60 fd cc ff f0 00 10 00 00 00 00 00 00 00
00  .`..............                                                            
[ 2036.434813] 0000000051fe854f: 0c 2e 18 b9 fe 2c 01 00 cd 3a 75 d6 ff c0 05
00  .....,...:u.....                                                            
[ 2036.434821] 0000000088866c7a: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00  ................                                                            
[ 2036.434829] 000000009f826903: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00  ................                                                            
[ 2036.451454] XFS (sda3): xfs_do_force_shutdown(0x8) called from line 1453 of
file fs/xfs/xfs_buf.c. Return address = 00000000debd573a                        
[ 2036.451470] XFS (sda3): Corruption of in-memory data detected.  Shutting
down filesystem                                                                 
[ 2036.451482] XFS (sda3): Please unmount the filesystem and rectify the
problem(s)                                                                      
[ 2036.451853] XFS: Assertion failed: bp->b_transp == tp, file:
fs/xfs/xfs_trans_buf.c, line: 385                                               
[ 2036.452007] WARNING: CPU: 3 PID: 3096 at fs/xfs/xfs_message.c:93
asswarn+0x38/0x54 [xfs]                                                         
[ 2036.452015] Modules linked in: sunrpc sg pseries_rng xfs libcrc32c sd_mod
ibmvscsi scsi_transport_srp ibmveth                                             
[ 2036.452030] CPU: 3 PID: 3096 Comm: fsstress Not tainted 4.19.0+ #1           
[ 2036.452037] NIP:  d000000008def69c LR: d000000008def69c CTR:
c0000000006dc990                                                                
[ 2036.452044] REGS: c0000007b776b690 TRAP: 0700   Not tainted  (4.19.0+)       
[ 2036.452050] MSR:  800000010282b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE,TM[E]> 
CR: 28004428  XER: 00000003                                                     
[ 2036.452064] CFAR: d000000008def394 IRQMASK: 0                                
[ 2036.452064] GPR00: d000000008def69c c0000007b776b918 d000000008e77800
ffffffffffffffea                                                                
[ 2036.452064] GPR04: 000000000000000a c0000007b776b818 d000000008e12f00
0000000000000000                                                                
[ 2036.452064] GPR08: ffffffffffffffc0 0000000000000000 0000000000000000
0000000000000000                                                                
[ 2036.452064] GPR12: c0000000006dc990 c00000001ecaae80 0000000000000000
0000000000000000                                                                
[ 2036.452064] GPR16: 0000000010030a40 00000000100121d0 0000000000000001
0000000010030b7c                                                                
[ 2036.452064] GPR20: 0000000000000001 0000000010005a70 0000000010030c08
000000000000024f                                                                
[ 2036.452064] GPR24: 00000100370a3700 0000000000000000 c0000007c52fc000
fffffffffffffffb                                                                
[ 2036.452064] GPR28: 0000000000000000 c0000007f31cc900 c0000007e10d3100
0000000000000000                                                                
[ 2036.452144] NIP [d000000008def69c] asswarn+0x38/0x54 [xfs]                   
[ 2036.452187] LR [d000000008def69c] asswarn+0x38/0x54 [xfs]                    
[ 2036.452196] Call Trace:                                                      
[ 2036.452232] [c0000007b776b918] [d000000008def69c] asswarn+0x38/0x54 [xfs]
(unreliable)                                                                    
[ 2036.452266] [c0000007b776b978] [d000000008dd0498]
xfs_trans_brelse+0x2d0/0x3c0 [xfs]                                              
[ 2036.452295] [c0000007b776b9c8] [d000000008ce3314] xfs_attr_set+0x31c/0x3a0
[xfs]
[ 2036.452329] [c0000007b776bac8] [d000000008da9720] xfs_xattr_set+0x78/0x130
[xfs]
[ 2036.452338] [c0000007b776bb08] [c0000000004cbeac] __vfs_setxattr+0x9c/0x110
[ 2036.452346] [c0000007b776bb68] [c0000000004cdacc]
__vfs_setxattr_noperm+0xbc/0x320
[ 2036.452354] [c0000007b776bbc8] [c0000000004cde1c] vfs_setxattr+0xec/0x130
[ 2036.452361] [c0000007b776bc28] [c0000000004ce168] setxattr+0x308/0x6a0
[ 2036.452368] [c0000007b776bd88] [c0000000004ce758] path_setxattr+0x128/0x150
[ 2036.452375] [c0000007b776be08] [c0000000004ce7e8] sys_lsetxattr+0x28/0x40
[ 2036.452383] [c0000007b776be28] [c00000000000b488] system_call+0x5c/0x70
[ 2036.452389] Instruction dump:
[ 2036.452395] 7c0802a6 60000000 7c0802a6 7c862378 3c820000 e884cd78 7ca72b78
7c651b78
[ 2036.452406] 38600000 f8010010 f821ffa1 4bfffc25 <0fe00000> 38210060 e8010010
7c0803a6
[ 2036.452417] irq event stamp: 898510
[ 2036.452424] hardirqs last  enabled at (898509): [<c0000000001e1654>]
console_unlock+0x664/0x8b0
[ 2036.452433] hardirqs last disabled at (898510): [<c000000000008ea8>]
program_check_common+0x138/0x150
[ 2036.452462] softirqs last  enabled at (897034): [<d000000008d68948>]
xfs_buf_find+0x7b0/0xf90 [xfs]
[ 2036.452494] softirqs last disabled at (897032): [<d000000008d6859c>]
xfs_buf_find+0x404/0xf90 [xfs]
[ 2036.452502] ---[ end trace 09823b36a21fc04c ]---
[ 2036.452512] Unable to handle kernel paging request for data at address
0x00000038
[ 2036.452520] Faulting instruction address: 0xd000000008dd0258
[ 2036.452527] Oops: Kernel access of bad area, sig: 11 [#1]
[ 2036.452531] LE SMP NR_CPUS=2048 NUMA pSeries
[ 2036.452537] Modules linked in: sunrpc sg pseries_rng xfs libcrc32c sd_mod
ibmvscsi scsi_transport_srp ibmveth
[ 2036.452548] CPU: 3 PID: 3096 Comm: fsstress Tainted: G        W        
4.19.0+ #1
[ 2036.452554] NIP:  d000000008dd0258 LR: d000000008dd0514 CTR:
c0000000001f57f0
[ 2036.452560] REGS: c0000007b776b6f0 TRAP: 0300   Tainted: G        W         
(4.19.0+)
[ 2036.452565] MSR:  800000010280b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE,TM[E]> 
CR: 28004424  XER: 20040003
[ 2036.452576] CFAR: c00000000000e038 DAR: 0000000000000038 DSISR: 40000000
IRQMASK: 0
[ 2036.452576] GPR00: d000000008dd0514 c0000007b776b978 d000000008e77800
0000000000000001
[ 2036.452576] GPR04: c0000000019dac30 c0000007b776b818 d000000008e12f00
0000000000000000
[ 2036.452576] GPR08: c0000000019dae00 0000000000000000 c0000007b7768000
d000000008df18e8
[ 2036.452576] GPR12: c0000000001f57f0 c00000001ecaae80 0000000000000000
0000000000000000
[ 2036.452576] GPR16: 0000000010030a40 00000000100121d0 0000000000000001
0000000010030b7c
[ 2036.452576] GPR20: 0000000000000001 0000000010005a70 0000000010030c08
000000000000024f
[ 2036.452576] GPR24: 00000100370a3700 0000000000000000 c0000007c52fc000
c000000001b8a424
[ 2036.452576] GPR28: c000000001b89de0 c0000007f31cc900 d000000008e9f204
0000000000000000
[ 2036.452653] NIP [d000000008dd0258] xfs_trans_brelse+0x90/0x3c0 [xfs]
[ 2036.452686] LR [d000000008dd0514] xfs_trans_brelse+0x34c/0x3c0 [xfs]
[ 2036.452691] Call Trace:
[ 2036.452721] [c0000007b776b978] [d000000008dd0514]
xfs_trans_brelse+0x34c/0x3c0 [xfs] (unreliable)
[ 2036.452744] [c0000007b776b9c8] [d000000008ce3314] xfs_attr_set+0x31c/0x3a0
[xfs]
[ 2036.452778] [c0000007b776bac8] [d000000008da9720] xfs_xattr_set+0x78/0x130
[xfs]
[ 2036.452785] [c0000007b776bb08] [c0000000004cbeac] __vfs_setxattr+0x9c/0x110
[ 2036.452791] [c0000007b776bb68] [c0000000004cdacc]
__vfs_setxattr_noperm+0xbc/0x320
[ 2036.452797] [c0000007b776bbc8] [c0000000004cde1c] vfs_setxattr+0xec/0x130
[ 2036.452803] [c0000007b776bc28] [c0000000004ce168] setxattr+0x308/0x6a0
[ 2036.452809] [c0000007b776bd88] [c0000000004ce758] path_setxattr+0x128/0x150
[ 2036.452815] [c0000007b776be08] [c0000000004ce7e8] sys_lsetxattr+0x28/0x40
[ 2036.452821] [c0000007b776be28] [c00000000000b488] system_call+0x5c/0x70
[ 2036.452826] Instruction dump:
[ 2036.452831] eb9cec20 a12d0008 815b0000 7f8a4840 7d2807b4 409d02c4 5508ecf8
552a06be
[ 2036.452839] 7d3c402a 7d295436 71290001 408201cc <813f0038> 2f89123c 409e0280
813f00a8
[ 2036.452849] ---[ end trace 09823b36a21fc04d ]---
[ 2036.455943]
[ 2036.986931] XFS (sda5): Unmounting Filesystem

How reproducible:
nearly 100% on 64k blocksize XFS on ppc64le

Additional info:
Can't reproduce this bug on 4k blocksize XFS

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
