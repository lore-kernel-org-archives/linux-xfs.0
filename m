Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 24 Jun 2008 23:47:16 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5P6lD0i008299
	for <linux-xfs@oss.sgi.com>; Tue, 24 Jun 2008 23:47:13 -0700
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Subject: RE: Xfs Access to block zero  exception and system crash
Date: Tue, 24 Jun 2008 23:48:36 -0700
Message-ID: <340C71CD25A7EB49BFA81AE8C839266701323BDB@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
In-Reply-To: <340C71CD25A7EB49BFA81AE8C839266701323BD8@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
References: <340C71CD25A7EB49BFA81AE8C839266701323BD8@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
From: "Sagar Borikar" <Sagar_Borikar@pmc-sierra.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: linux-xfs@oss.sgi.com

 
Hello,

Can anyone help me out here?

Thanks
Sagar

-----Original Message-----
From: Sagar Borikar 
Sent: Tuesday, June 24, 2008 12:33 PM
To: 'xfs@oss.sgi.com'
Cc: Sagar Borikar
Subject: Xfs Access to block zero exception and system crash


Hello,

I hope this is the right list to address this issue. If not please divert me to the right list. 

We are facing strange issue with xfs under heavy load. It's a NAS box with 2.6.18 kernel,128 MB of RAM, MIPS architecture and XFS version 2.8.11. 
NAS allows to create RAID1,RAID5 over XFS. The system is stable in general without any stress. We don't see any issues in day to day activities. 
But when it is exposed to stress with multiple iozone clients, it starts giving weird issues. 
The iozone stress test is ran with 15 CIFS clients, pumping data over 1GBps network, continuously for 48 hours as a part of calculating MTBF of the system, it crashes at different stages in different stimulus but in XFS only. 


A. Initially it used to give access to block zero exception and system used to crash for which I applied Nathan Scott's patch which removes the kernel panic when this situation is hit. http://oss.sgi.com/archives/xfs/2006-08/msg00073.html
After back porting this patch, we observed that the system is not crashing but the warning messages are still coming. And after some time the system goes in soft lockup state and becomes non-responsive. 

I couldn't run the xfs_db or xfs_repair to check what is the state of the inode as console was not reachable after hitting the lockup state. 
Here is the log
"
Filesystem "dm-0": Access to block zero in inode 33554565 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 7 af Filesystem "dm-0": Access to block zero in inode 33554565 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 7 af Filesystem "dm-0": Access to block zero in inode 33554565 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 7 af Filesystem "dm-0": Access to block zero in inode 33554565 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 7 b0 Filesystem "dm-0": Access to block zero in inode 33554565 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 7 b0 Filesystem "dm-0": Access to block zero in inode 33554565 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 7
e7
Filesystem "dm-0": Access to block zero in inode 33554565 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 7
e7
Filesystem "dm-0": Access to block zero in inode 33554565 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 7
e7
Filesystem "dm-0": Access to block zero in inode 33554565 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 8 20 Filesystem "dm-0": Access to block zero in inode 33554565 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 8 20 Filesystem "dm-0": Access to block zero in inode 33554565 start_block: 0 start_off: 3ffffffe000000 blkcnt: 68 extent-sta
te: 1 lastx: 88d
Filesystem "dm-0": Access to block zero in inode 33554565 start_block: 0 start_off: 3ffffffe000000 blkcnt: 68 extent-sta
te: 1 lastx: 88d
Filesystem "dm-0": Access to block zero in inode 33554565 start_block: 0 start_off: 3ffffffe000000 blkcnt: 68 extent-sta
te: 1 lastx: 88d
Filesystem "dm-0": Access to block zero in inode 33554565 start_block: 0 start_off: 3ffffffc000000 blkcnt: 180 extent-st
ate: 1 lastx: 88f
Filesystem "dm-0": Access to block zero in inode 33554565 start_block: 0 start_off: 3ffffffc000000 blkcnt: 180 extent-st
ate: 1 lastx: 88f
Filesystem "dm-0": Access to block zero in inode 33554565 start_block: 0 start_off: 3ffffffc000000 blkcnt: 180 extent-st
ate: 1 lastx: 88f
Filesystem "dm-0": Access to block zero in inode 33554565 start_block: 0 start_off: 3ffffffe000000 blkcnt: 1a0 extent-st
ate: 1 lastx: 891
Filesystem "dm-0": Access to block zero in inode 33554565 start_block: 0 start_off: 3ffffffe000000 blkcnt: 1a0 extent-st "

Once we hit the soft lockup, system has to be rebooted as it is completely stalled and we can't even check which processes are running. I could be wrong but it was surprising to me that the same inode was referring to different offsets and blkcnt. It took 48 hours to reach this state and system had to be rebooted.


B. In another DUT, the system just rebooted after displaying couple of warning messages without entering in soft lockup state.


"
Filesystem "dm-1": Access to block zero in inode 2097283 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 46 d Filesystem "dm-1": Access to block zero in inode 2097283 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 46 d Filesystem "dm-1": Access to block zero in inode 2097283 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 46 d Filesystem "dm-1": Access to block zero in inode 2097283 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 46 d Filesystem "dm-1": Access to block zero in inode 2097283 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 46 d Filesystem "dm-1": Access to block zero in inï



PMON2000 MIPS Initializing. Standby...
ERRORPC=bfc00004 CONFIG=0042e4bb STATUS=00400000 CPU PRID 000034c1, MaskID 00001320 Initializing caches...done (CONFIG=0042e4bb) Switching to runtime address map...done Setting up SDRAM controller: Manual SDRAM setup
  drive strength 0x000073c7
  output timing  0x00000fca
  general config 0x80010000
master clock 100 Mhz, MulFundBIU 0x02, DivXSDRAM 0x02 sdram freq 0x09ef21aa hz, sdram period: 0x06 nsec

"


It took 43 hours to come to this state. 

C. In another stimulus, device driver mentioned that it can't access the block. Which means that filesystem got corrupted. I inferred that Filesystem was trying to reach block which is not existing in the disk. After some time, it recovers itself and starts giving weird issue. Finally it hits the memory access exception and system crashes.

"
Filesystem "dm-1": Access to block zero in inode 2097284 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 1a
8
Filesystem "dm-1": Access to block zero in inode 2097284 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 1a
8
Filesystem "dm-1": Access to block zero in inode 2097284 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 1a
1
Filesystem "dm-1": Access to block zero in inode 2097284 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 1a
1
Filesystem "dm-1": Access to block zero in inode 2097284 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 1a
1
attempt to access beyond end of device
dm-1: rw=0, want=1003118956380168, limit=8388608
I/O error in filesystem ("dm-1") meta-data dev dm-1 block 0x39054d5100001       ("xfs_trans_read_buf") error 5 buf count
 512
attempt to access beyond end of device
dm-1: rw=0, want=1003118956380168, limit=8388608
I/O error in filesystem ("dm-1") meta-data dev dm-1 block 0x39054d5100001       ("xfs_trans_read_buf") error 5 buf count
 512
attempt to access beyond end of device
dm-1: rw=0, want=1003118956380168, limit=8388608
I/O error in filesystem ("dm-1") meta-data dev dm-1 block 0x39054d5100001       ("xfs_trans_read_buf") error 5 buf count
 512
attempt to access beyond end of device
dm-1: rw=0, want=1003118956380168, limit=8388608
I/O error in filesystem ("dm-1") meta-data dev dm-1 block 0x39054d5100001       ("xfs_trans_read_buf") error 5 buf count
 512
attempt to access beyond end of device



Filesystem "dm-1": Access to block zero in inode 2097284 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 1f e Filesystem "dm-1": Access to block zero in inode 2097284 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 1f e Filesystem "dm-1": Access to block zero in inode 2097284 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 1f f Filesystem "dm-1": Access to block zero in inode 2097284 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 1f f Filesystem "dm-1": Access to block zero in inode 2097284 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 1f f CPU 0 Unable to handle kernel paging request at virtual address 04e81080, epc == 802a90ac, ra == 802a9094
Oops[#1]:
Cpu 0
$ 0   : 00000000 9000a001 84e81080 80000000
$ 4   : 82ce6dd0 00000000 ffffffff ffffffff
$ 8   : 00086800 00000000 00086800 00000001
$12   : 00000004 34000000 82ce6c00 00000001
$16   : ffffffff 04e81080 34000000 81213978
$20   : 82ce6c00 82ce6dd0 00000000 34000000
$24   : 00086800 00000000                  
$28   : 81212000 81213878 00000000 802a9094
Hi    : 00000000
Lo    : 00036a20
epc   : 802a90ac xfs_bmap_btalloc+0x33c/0x950     Not tainted
ra    : 802a9094 xfs_bmap_btalloc+0x324/0x950
Status: 9000a003    KERNEL EXL IE 
Cause : 00000008
BadVA : 04e81080
PrId  : 000034c1
Modules linked in: aes autofs4
Process pdflush (pid: 66, threadinfo=81212000, task=8120b138) Stack : 81213880 811c9074 00000003 863af000 00000000 00000001 000000cb 805c1f90
        812139b8 8616ece0 8538e6f8 82ce6c00 812139fc ffffffff 00086800 00000000
        802aad9c 802aad80 8616ed30 00000001 8173c6f4 813cf200 812138d8 00000001
        00000200 00000000 812139b8 00000004 81213a00 00000000 ffffffff ffffffff
        00000000 00000000 00000001 00000000 00000000 81213a00 000002a3 81213ac0
        ...
Call Trace:
[<802a90ac>] xfs_bmap_btalloc+0x33c/0x950 [<802a9700>] xfs_bmap_alloc+0x40/0x4c [<802acc9c>] xfs_bmapi+0x8d8/0x13e4 [<802d42d4>] xfs_iomap_write_allocate+0x3c0/0x5f4
[<802d2b28>] xfs_iomap+0x408/0x4dc
[<802fe90c>] xfs_bmap+0x30/0x3c
[<802f3cfc>] xfs_map_blocks+0x50/0x84
[<802f512c>] xfs_page_state_convert+0x3f4/0x840
[<802f565c>] xfs_vm_writepage+0xe4/0x140 [<80198758>] mpage_writepages+0x24c/0x45c [<802f56e8>] xfs_vm_writepages+0x30/0x3c [<801507b4>] do_writepages+0x44/0x84 [<80196628>] __sync_single_inode+0x68/0x234 [<80196980>] __writeback_single_inode+0x18c/0x1ac
[<80196ba8>] sync_sb_inodes+0x208/0x2f0
[<80196d14>] writeback_inodes+0x84/0xd0
[<801503e0>] background_writeout+0xac/0xfc [<80151330>] __pdflush+0x130/0x228 [<80151458>] pdflush+0x30/0x3c [<801398bc>] kthread+0x98/0xe0 [<80104c38>] kernel_thread_helper+0x10/0x18

"


In all the three cases, when I tried to perform the slower tests i.e. with 6 clients but with the same stimulus, there we re no exceptions and system was stable for 5 days. 

[root@Cousteau6 ~]# df -k
Filesystem           1k-blocks      Used Available Use% Mounted on
/dev/scsibd2              41664     41664         0 100% /
udev                      62044         4     62040   0% /dev
tmpfs                      5120      3468      1652  68% /var
tmpfs                     62044        24     62020   0% /tmp
tmpfs                       128         4       124   3% /mnt
/dev/mtdblock1             1664       436      1228  26% /linuxrwfs
/dev/RAIDA/Volume1     10475520       624  10474896   0% /mnt/RAIDA/Volume1
/dev/RAIDA/Volume1     10475520       624  10474896   0% /mnt/ftp_dir/homes
/dev/RAIDA/IOZONETEST   4184064   2479044   1705020  59% /mnt/RAIDA/IOZONETEST
/dev/RAIDA/IOZONETEST   4184064   2479044   1705020  59% /mnt/ftp_dir/share1
/dev/RAIDA/Volume1     10475520       624  10474896   0% /mnt/ftp_dir/share2

Can anyone let me know what could be the probable cause of this issue.

Thanks in advance
Sagar
