Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 30C327F3F
	for <xfs@oss.sgi.com>; Fri, 27 Dec 2013 22:01:06 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AF158AC004
	for <xfs@oss.sgi.com>; Fri, 27 Dec 2013 20:01:02 -0800 (PST)
Received: from trent.utfs.org (trent.utfs.org [94.185.90.103]) by cuda.sgi.com
	with ESMTP id OB5FHXCkRvznorSS for <xfs@oss.sgi.com>;
	Fri, 27 Dec 2013 20:01:00 -0800 (PST)
Date: Fri, 27 Dec 2013 20:00:57 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
Subject: 3.13-rc3: BUG: soft lockup - CPU#0 stuck for 23s!
Message-ID: <alpine.DEB.2.11.1312271942300.5808@trent.utfs.org>
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: LKML <linux-kernel@vger.kernel.org>
Cc: linuxppc-dev@lists.ozlabs.org, xfs@oss.sgi.com

I noticed that my machine locks up quite often with 3.13.-rc3.

PowerPC G4 again, but this machine was pretty much rock solid until now:
when there's lots of disk I/O going on, the system locks up, but not 
entirely: the calltrace is still written to netconsole (but not to its 
local disk) and answers ping requests - but SSH login is impossible and a 
reset is needed. The workload of the machine has not changed, when there's 
disk I/O it means that either rsync is running or some crazy remote Java 
application is scanning over this machine's NFS shares.

There's sometimes "xfs" mentioned in the call trace and the disk I/O is 
all happening on the xfs mounts, that's why I Cc'ed the xfs mailing list.

More details on: http://nerdbynature.de/bits/3.13-rc3/

Any ideas?

The most recent lockup is from today below, this time it wasn't rsync or 
NFS but I was experimenting with xfs on a loop device, backed by a 1GB 
file, like this:

  $ dd if=/dev/zero of=/usr/local/test.img bs=1M count=1k
  $ losetup -f /usr/local/test.img && mkfs.xfs /dev/loop0
  $ mount -t xfs /dev/loop0 /mnt/disk
  $ cd /mnt/disk
  $ cp -ax / /mnt/disk       - which filled the disk
  $ rm -rf lib/              - make some room
  $ i=1; while true; do printf "$i "; dd if=/dev/zero of=f$i \
        count=100 bs=100k; i=$(($i+1)); done      - filling the disk again

  => and then the machine locked up.

 [308783.613600] BUG: soft lockup - CPU#0 stuck for 23s! [kworker/u2:1:14542]
 [308783.613703] Modules linked in: md5 ecb nfs i2c_powermac therm_adt746x ecryptfs arc4 b43 firewire_sbp2 usb_storage mac80211 cfg80211
 [308783.613944] irq event stamp: 37770086
 [308783.613980] hardirqs last  enabled at (37770085): [<c0546ff0>] _raw_spin_unlock_irq+0x30/0x60
 [308783.614075] hardirqs last disabled at (37770086): [<c0010700>] reenable_mmu+0x30/0x88
 [308783.614156] softirqs last  enabled at (37764418): [<c00354d4>] __do_softirq+0x168/0x1e8
 [308783.614236] softirqs last disabled at (37764411): [<c0035990>] irq_exit+0xa4/0xc8
 [308783.614312] CPU: 0 PID: 14542 Comm: kworker/u2:1 Not tainted 3.13.0-rc3-00365-gc48b660 #1
 [308783.614384] Workqueue: writeback bdi_writeback_workfn  (flush-7:0)
  
 [308783.614454] task: e8d20bb0 ti: e0c5a000 task.ti: e0c5a000
 [308783.614499] NIP: c0546ffc LR: c0546ff0 CTR: 00000000
 [308783.614543] REGS: e0c5ba80 TRAP: 0901   Not tainted  (3.13.0-rc3-00365-gc48b660)
 [308783.614596] MSR: 00009032 ,ME ,IR ,DR ,RI > CR: 444c2224  XER: 20000000
 [308783.614739] #012GPR00: #012GPR08: 
  
 [308783.614998] NIP [c0546ffc] _raw_spin_unlock_irq+0x3c/0x60
 [308783.615047] LR [c0546ff0] _raw_spin_unlock_irq+0x30/0x60
 [308783.615089] Call Trace:
 [308783.615121] [e0c5bb30] [c0546ff0] _raw_spin_unlock_irq+0x30/0x60  (unreliable)
 [308783.615202] [e0c5bb40] [c009f0e4] __set_page_dirty_nobuffers+0xc8/0x144
 [308783.615264] [e0c5bb60] [c01bec28] xfs_vm_writepage+0x90/0x57c
 [308783.615322] [e0c5bbf0] [c009e618] __writepage+0x24/0x7c
 [308783.615376] [e0c5bc00] [c009ec38] write_cache_pages+0x1d0/0x380
 [308783.615433] [e0c5bca0] [c009ee34] generic_writepages+0x4c/0x70
 [308783.615493] [e0c5bce0] [c00f9af8] __writeback_single_inode+0x34/0x12c
 [308783.615968] [e0c5bd00] [c00f9e74] writeback_sb_inodes+0x1f4/0x344
 [308783.616418] [e0c5bd70] [c00fa050] __writeback_inodes_wb+0x8c/0xd0
 [308783.616864] [e0c5bda0] [c00fa258] wb_writeback+0x1c4/0x1cc
 [308783.617306] [e0c5bdd0] [c00fae14] bdi_writeback_workfn+0x158/0x33c
 [308783.617751] [e0c5be50] [c004906c] process_one_work+0x19c/0x3f0
 [308783.618193] [e0c5be80] [c0049a0c] worker_thread+0x128/0x3c0
 [308783.618630] [e0c5beb0] [c004fa8c] kthread+0xbc/0xd0
 [308783.619071] [e0c5bf40] [c001099c] ret_from_kernel_thread+0x5c/0x64
 [308783.619501] Instruction dump:
 [308783.619915] 7ca802a6 
 [308783.620437] 4bb1c681 

-- 
BOFH excuse #446:

Mailer-daemon is busy burning your message in hell.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
