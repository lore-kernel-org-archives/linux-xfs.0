Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:36814 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725385AbfF0IfP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jun 2019 04:35:15 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 2BB9628A00
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jun 2019 08:35:14 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 203947] [xfstests generic/475]: general protection fault: 0000
 [#1] RIP: 0010:xfs_setfilesize_ioend+0xb1/0x220 [xfs]
Date: Thu, 27 Jun 2019 08:35:13 +0000
Message-ID: <bug-203947-201763-MKNYxee9tc@https.bugzilla.kernel.org/>
In-Reply-To: <bug-203947-201763@https.bugzilla.kernel.org/>
References: <bug-203947-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=203947

--- Comment #1 from Zorro Lang (zlang@redhat.com) ---
Hit this panic again on xfs-linux xfs-5.3-merge-2:

[38857.886348] run fstests generic/475 at 2019-06-27 00:41:30 
[38858.311084] XFS (vda5): Unmounting Filesystem 
[38858.510461] device-mapper: uevent: version 1.0.3 
[38858.511208] device-mapper: ioctl: 4.40.0-ioctl (2019-01-18) initialised:
dm-devel@redhat.com 
[38859.308289] XFS (dm-0): Mounting V5 Filesystem 
[38859.398726] XFS (dm-0): Ending clean mount 
[38860.580486] XFS (dm-0): writeback error on sector 15751000 
[38860.581500] XFS (dm-0): writeback error on sector 23597576 
[38860.581919] XFS (dm-0): log I/O error -5 
[38860.583029] XFS (dm-0): xfs_do_force_shutdown(0x2) called from line 1235 of
file fs/xfs/xfs_log.c. Return address = 00000000a62cc036 
[38860.583272] XFS (dm-0): Log I/O Error Detected. Shutting down filesystem 
[38860.583391] XFS (dm-0): Please unmount the filesystem and rectify the
problem(s) 
[38860.583595] XFS (dm-0): log I/O error -5 
[38860.583791] XFS (dm-0): writeback error on sector 7883120 
[38860.583977] XFS (dm-0): writeback error on sector 15765912 
[38860.584092] XFS (dm-0): writeback error on sector 15765960 
[38860.584294] XFS (dm-0): writeback error on sector 15781104 
[38860.672123] Buffer I/O error on dev dm-0, logical block 31457152, async page
read 
[38860.672288] Buffer I/O error on dev dm-0, logical block 31457153, async page
read 
[38860.672420] Buffer I/O error on dev dm-0, logical block 31457154, async page
read 
[38860.672547] Buffer I/O error on dev dm-0, logical block 31457155, async page
read 
[38860.672676] Buffer I/O error on dev dm-0, logical block 31457156, async page
read 
[38860.672802] Buffer I/O error on dev dm-0, logical block 31457157, async page
read 
[38860.672927] Buffer I/O error on dev dm-0, logical block 31457158, async page
read 
[38860.673053] Buffer I/O error on dev dm-0, logical block 31457159, async page
read 
[38860.673406] Buffer I/O error on dev dm-0, logical block 31457160, async page
read 
[38860.673532] Buffer I/O error on dev dm-0, logical block 31457161, async page
read 
[38861.034014] XFS (dm-0): Unmounting Filesystem 
[38862.090150] XFS (dm-0): Mounting V5 Filesystem 
[38863.214360] XFS (dm-0): Starting recovery (logdev: internal) 
[38863.679809] XFS (dm-0): Ending recovery (logdev: internal) 
[38865.810147] XFS (dm-0): writeback error on sector 15793776 
[38865.811088] XFS (dm-0): writeback error on sector 15779744 
[38865.811237] XFS (dm-0): writeback error on sector 15813904 
[38865.811417] XFS (dm-0): writeback error on sector 23629648 
[38865.811568] XFS (dm-0): writeback error on sector 23634192 
[38865.811730] XFS (dm-0): writeback error on sector 15802768 
[38865.811861] XFS (dm-0): writeback error on sector 15802944 
[38865.812295] XFS (dm-0): writeback error on sector 23629584 
[38865.812441] XFS (dm-0): writeback error on sector 27032 
[38865.812628] XFS (dm-0): writeback error on sector 38560
[38865.812797] XFS (dm-0): log I/O error -5 
[38865.813411] XFS (dm-0): xfs_do_force_shutdown(0x2) called from line 1235 of
file fs/xfs/xfs_log.c. Return address = 00000000a62cc036 
[38865.813700] XFS (dm-0): Log I/O Error Detected. Shutting down filesystem 
[38865.813822] XFS (dm-0): Please unmount the filesystem and rectify the
problem(s) 
[38865.813992] XFS (dm-0): log I/O error -5 
[38865.814076] XFS (dm-0): log I/O error -5 
[38865.935923] buffer_io_error: 118 callbacks suppressed 
[38865.935930] Buffer I/O error on dev dm-0, logical block 31457152, async page
read 
[38865.936236] Buffer I/O error on dev dm-0, logical block 31457153, async page
read 
[38865.936394] Buffer I/O error on dev dm-0, logical block 31457154, async page
read 
[38865.936549] Buffer I/O error on dev dm-0, logical block 31457155, async page
read 
[38865.936697] Buffer I/O error on dev dm-0, logical block 31457156, async page
read 
[38865.936853] Buffer I/O error on dev dm-0, logical block 31457157, async page
read 
[38865.937021] Buffer I/O error on dev dm-0, logical block 31457158, async page
read 
[38865.937170] Buffer I/O error on dev dm-0, logical block 31457159, async page
read 
[38865.937321] Buffer I/O error on dev dm-0, logical block 31457160, async page
read 
[38865.937475] Buffer I/O error on dev dm-0, logical block 31457161, async page
read 
[38866.282227] XFS (dm-0): Unmounting Filesystem 
[38867.000037] XFS (dm-0): Mounting V5 Filesystem 
[38868.488578] XFS (dm-0): Starting recovery (logdev: internal) 
[38870.047897] XFS (dm-0): Ending recovery (logdev: internal) 
[38871.200554] xfs_destroy_ioend: 3 callbacks suppressed 
[38871.200576] XFS (dm-0): writeback error on sector 15846656 
[38871.200931] XFS (dm-0): log I/O error -5 
[38871.201306] XFS (dm-0): xfs_do_force_shutdown(0x2) called from line 1235 of
file fs/xfs/xfs_log.c. Return address = 00000000a62cc036 
[38871.201537] XFS (dm-0): Log I/O Error Detected. Shutting down filesystem 
[38871.201650] XFS (dm-0): Please unmount the filesystem and rectify the
problem(s) 
[38871.201828] XFS (dm-0): writeback error on sector 23645728 
[38871.202155] XFS (dm-0): writeback error on sector 23661208 
[38871.202491] XFS (dm-0): writeback error on sector 7938296 
[38871.202588] XFS (dm-0): writeback error on sector 7938552 
[38871.202680] XFS (dm-0): writeback error on sector 7938648 
[38871.202796] XFS (dm-0): writeback error on sector 7938664 
[38871.202962] XFS (dm-0): writeback error on sector 7936016 
[38871.203068] XFS (dm-0): writeback error on sector 7936392 
[38871.203217] XFS (dm-0): writeback error on sector 7936456 
[38871.287223] buffer_io_error: 118 callbacks suppressed
[38871.287246] Buffer I/O error on dev dm-0, logical block 31457152, async page
read 
[38871.288884] Buffer I/O error on dev dm-0, logical block 31457153, async page
read 
[38871.289067] Buffer I/O error on dev dm-0, logical block 31457154, async page
read 
[38871.289317] Buffer I/O error on dev dm-0, logical block 31457155, async page
read 
[38871.336902] Buffer I/O error on dev dm-0, logical block 31457156, async page
read 
[38871.337150] Buffer I/O error on dev dm-0, logical block 31457157, async page
read 
[38871.337369] Buffer I/O error on dev dm-0, logical block 31457158, async page
read 
[38871.337578] Buffer I/O error on dev dm-0, logical block 31457159, async page
read 
[38871.337795] Buffer I/O error on dev dm-0, logical block 31457160, async page
read 
[38871.337990] Buffer I/O error on dev dm-0, logical block 31457161, async page
read 
[38871.728914] XFS (dm-0): Unmounting Filesystem 
[38872.419930] XFS (dm-0): Mounting V5 Filesystem 
[38874.050592] restraintd[3933]: *** Current Time: Thu Jun 27 00:41:46 2019
Localwatchdog at: Sat Jun 29 00:40:45 2019 
[38874.227008] XFS (dm-0): Starting recovery (logdev: internal) 
[38875.000418] XFS (dm-0): Ending recovery (logdev: internal) 
[38876.444568] BUG: Kernel NULL pointer dereference at 0x000000e0 
[38876.444723] Faulting instruction address: 0xc008000001ada168 
[38876.444855] Oops: Kernel access of bad area, sig: 11 [#1] 
[38876.444941] LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries 
[38876.445079] Modules linked in: dm_mod sunrpc pseries_rng xts virtio_balloon
vmx_crypto xfs libcrc32c virtio_net net_failover virtio_console virtio_blk
failover 
[38876.445436] CPU: 6 PID: 19513 Comm: kworker/6:2 Not tainted 5.2.0-rc4 #1 
[38876.445688] Workqueue: xfs-conv/dm-0 xfs_end_io [xfs] 
[38876.445774] NIP:  c008000001ada168 LR: c008000001ada3fc CTR:
c00000000068cc90 
[38876.445898] REGS: c0000000046c7930 TRAP: 0380   Not tainted  (5.2.0-rc4) 
[38876.446004] MSR:  800000000280b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR:
24002488  XER: 20000000 
[38876.446157] CFAR: c008000001ada3f8 IRQMASK: 0  
[38876.446157] GPR00: c008000001ada3fc c0000000046c7bc0 c008000001bc7500
c00000018c93af00  
[38876.446157] GPR04: 0000000000000001 c00000021d326100 000000302d6d642f
c00000017b547140  
[38876.446157] GPR08: 0000000000007000 0000000004208060 0000000000000000
c008000001b53b90  
[38876.446157] GPR12: c00000000068cc90 c00000003fff7800 c00000000015f9f8
c0000001a5349f40  
[38876.446157] GPR16: 0000000000000000 0000000000000000 0000000000000000
0000000000000000  
[38876.446157] GPR20: 0000000000000000 0000000000000000 fffffffffffffef7
0000000000000402  
[38876.446157] GPR24: 0000000000000000 0000000000000000 c00000017b547390
c00000021d326100  
[38876.446157] GPR28: 0000000000000000 c0000000046c7c38 c00000021d326100
c00000018c93af00  
[38876.447263] NIP [c008000001ada168] xfs_setfilesize_ioend+0x20/0xa0 [xfs] 
[38876.447456] LR [c008000001ada3fc] xfs_ioend_try_merge+0x214/0x230 [xfs]
[38876.447559] Call Trace: 
[38876.447651] [c0000000046c7c10] [c008000001adca2c] xfs_end_io+0xe4/0x140
[xfs] 
[38876.447846] [c0000000046c7c70] [c000000000156250]
process_one_work+0x260/0x520 
[38876.447972] [c0000000046c7d10] [c000000000156598] worker_thread+0x88/0x5f0 
[38876.448078] [c0000000046c7db0] [c00000000015fba8] kthread+0x1b8/0x1c0 
[38876.448187] [c0000000046c7e20] [c00000000000ba54]
ret_from_kernel_thread+0x5c/0x68 
[38876.448312] Instruction dump: 
[38876.448376] 4bfffed0 60000000 000ed3b8 00000000 3c4c000f 3842d3b8 7c0802a6
60000000  
[38876.448504] e8e30018 e9430030 e92d0968 81290114 <f92a00e0> e90d0968 81280114
2fa40000  
[38876.448634] ---[ end trace 2479158bc75365a8 ]--- 
[38876.451282]  
[38877.451364] Kernel panic - not syncing: Fatal exception

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
