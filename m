Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p17Au66u038052 for <xfs@oss.sgi.com>; Mon, 7 Feb 2011 04:56:07 -0600
Received: from mailout4.samsung.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AD13010717D2
	for <xfs@oss.sgi.com>; Mon,  7 Feb 2011 02:58:31 -0800 (PST)
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34]) by
	cuda.sgi.com with ESMTP id kXy5QhKP3gTDdLYz for
	<xfs@oss.sgi.com>; Mon, 07 Feb 2011 02:58:31 -0800 (PST)
MIME-version: 1.0
Received: from epmmp1 (mailout4.samsung.com [203.254.224.34])
	by mailout4.samsung.com
	(Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built
	Sep 7
	2010)) with ESMTP id <0LG800HOAUHHRVA0@mailout4.samsung.com> for
	xfs@oss.sgi.com; Mon, 07 Feb 2011 19:58:29 +0900 (KST)
Received: from unisistPC ([165.213.110.204])
	by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
	2004))
	with ESMTPA id <0LG800IYLUHGJ8@mmp1.samsung.com> for xfs@oss.sgi.com;
	Mon, 07 Feb 2011 19:58:29 +0900 (KST)
Date: Mon, 07 Feb 2011 19:58:28 +0900
From: Ryan Roh <unisist.roh@samsung.com>
Subject: system hang up during mount
Message-id: <02af01cbc6b5$f372d340$da5879c0$@samsung.com>
Content-language: en-us
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2952253783612129089=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a multipart message in MIME format.

--===============2952253783612129089==
Content-type: multipart/alternative;
 boundary="Boundary_(ID_hERFTgdZheltJ2F45NpSFA)"
Content-language: en-us

This is a multipart message in MIME format.

--Boundary_(ID_hERFTgdZheltJ2F45NpSFA)
Content-type: text/plain; CHARSET=US-ASCII
Content-transfer-encoding: 7BIT

Dear Members,

 

I'm using XFS based on STMicro SH4 based chip (STi7105).

and I have some issue on xfs log mounting.

 

1. chip : sh4 STi7105

2. HDD : 320GB USB HDD USB 2.0 port.

3. OS : Linux 2.6.23.17 + patch for fixing cache aliasing issue.

4. XFSProgs version : 3.1.1

 

 

The repairing log in the below. This hang-up (various kind of) is caused by

the memmove in xfs_alloc_insrec function of xfs_alloc_btree.c file. The
memmove

has negative value for size argument so the system hang-up is caused. the

numrecs was 2 and the ptr was 11 before hang-up.

 

    } else {

        /*

         * It's a leaf entry.  Make a hole for the new record.

         */

        rp = XFS_ALLOC_REC_ADDR(block, 1, cur);

        memmove(&rp[ptr], &rp[ptr - 1],

            (numrecs - ptr + 1) * sizeof(*rp));

 

 

I want to know why and how this error can be happen. Would you please
explain or give some hint for this?

 

Thank you in advance.

 

============================================================================
====

# mount /dev/sdb3 /mnt/flash/

XFS mounting filesystem sdb3

Starting XFS recovery on filesystem: sdb3 (logdev: internal)

BUG: FPU is used in kernel mode.

Unable to handle kernel paging request at virtual address 005f2222

pc = 81332400

*pde = 83ced000

Oops: 0001 [#1]

Modules linked in: stsectoolfuse_ioctl(P) adf(P) asf(P) ath_hif_usb

embxloopback(P) embxmailbox(P) sec_nvram ath_htc_hst ath_dfs(P) embxshell(P)

sttkdma_ioctl(P) ath_rate_atheros(P) mme_host(P) embxshm(P) sttkdma_core(P)

stpti4_ioctl(P) stsectoolfuse_core(P) MHFSWRAPGPL_KERN ath_dev(P) xsr(P)

ath_hal(P) xsr_stl(P) stuart_core(P) MHFSWRAP_KERN(P) stsmart_core(P)
wifitt(P)

umac stapi_core(P) CDIDVB_ST_REF(P)

 

Pid : 998, Comm:                mount

PC is at boot_tvec_bases+0x120/0x1020

PC  : 81332400 SP  : 810218d0 SR  : 40000001 TEA : c162cb64    Tainted: P


R0  : 00000004 R1  : 00000101 R2  : 81020000 R3  : 8acffe94

R4  : 005f2222 R5  : 8a31b260 R6  : 005f2223 R7  : 00000002

R8  : 00000101 R9  : 813322e0 R10 : 810218e0 R11 : 81020000

R12 : 810218a8 R13 : 813323f8 R14 : 005f2222

MACH: 000000c0 MACL: 00000028 GBR : 004d2290 PR  : 80722ccc

 

Call trace: 

[<8071e8e4>] __do_softirq+0x64/0x100

[<808bca60>] debug_smp_processor_id+0x0/0xc0

[<8071e9e4>] do_softirq+0x64/0x80

[<8071ee78>] irq_exit+0x38/0x60

[<80712ee0>] sub_preempt_count+0x0/0xa0

[<807028f6>] do_IRQ+0x36/0x80

[<80707746>] ret_from_irq+0x0/0x1a

[<807028c0>] do_IRQ+0x0/0x80

[<808b2820>] memcpy+0xac/0x28c

[<8083315e>] xfs_alloc_insrec+0x2be/0x400

[<8088c8aa>] xfs_buf_get_flags+0x10a/0x160

[<808332fe>] xfs_alloc_insert+0x5e/0x100

[<8082ebf2>] xfs_free_ag_extent+0x272/0x5c0

[<808305e2>] xfs_free_extent+0x82/0xc0

[<8083ada0>] xfs_bmap_del_free+0x0/0x40

[<8083af04>] xfs_bmap_finish+0xe4/0x160

[<80861fd2>] xfs_itruncate_finish+0x212/0x420

[<8087bf40>] xfs_trans_ihold+0x0/0x20

[<8087bfc0>] xfs_trans_ijoin+0x0/0x80

[<808851ea>] xfs_inactive+0x3ea/0x500

[<8085e960>] xfs_ilock+0x0/0xc0

[<80892d34>] xfs_fs_clear_inode+0x34/0xa0

[<8077f34a>] clear_inode+0x4a/0x120

[<8077f4f2>] generic_delete_inode+0xd2/0x120

[<80712ee0>] sub_preempt_count+0x0/0xa0

[<8087017e>] xlog_recover_process_iunlinks+0x35e/0x3a0

[<808707e6>] xlog_recover_finish+0xa6/0xe0

[<8087625c>] xfs_mountfs+0xc1c/0xe40

[<808876d2>] kmem_alloc+0x52/0x100

[<808877ec>] kmem_zalloc+0xc/0x40

[<808584c0>] xfs_fstrm_free_func+0x0/0xc0

[<8087f30a>] xfs_mount+0x3ca/0x420

[<80893318>] xfs_fs_fill_super+0x58/0x240

[<80774d20>] path_lookup+0x0/0x20

[<808ba576>] snprintf+0x16/0x40

[<80774d20>] path_lookup+0x0/0x20

[<807aab2e>] disk_name+0x8e/0xc0

[<80794f54>] sb_set_blocksize+0x14/0x40

[<8076ae32>] get_sb_bdev+0x152/0x1e0

[<807644a8>] __kmalloc+0x48/0x100

[<80892250>] xfs_fs_get_sb+0x10/0x20

[<808932c0>] xfs_fs_fill_super+0x0/0x240

[<8076a596>] vfs_kern_mount+0x36/0xc0

[<8076a66e>] do_kern_mount+0x2e/0xe0

[<80783390>] do_mount+0x130/0x6c0

[<80770900>] path_release+0x0/0x40

[<80712b3a>] enqueue_entity+0x9a/0x2a0

[<80a45f16>] __down_read+0x136/0x180

[<80712a58>] dequeue_entity+0x58/0xa0

[<80712d66>] task_tick_fair+0x26/0x80

[<8070faa0>] do_page_fault+0x60/0x380

[<808b852e>] __up_read+0x4e/0xe0

[<8070e9ce>] fixup_exception+0xe/0x40

[<8070fb30>] do_page_fault+0xf0/0x380

[<80722b3a>] run_timer_softirq+0x1a/0x200

[<808bca60>] debug_smp_processor_id+0x0/0xc0

[<80722c72>] run_timer_softirq+0x152/0x200

[<8071e8e4>] __do_softirq+0x64/0x100

[<808bca60>] debug_smp_processor_id+0x0/0xc0

[<8071e8f6>] __do_softirq+0x76/0x100

[<8071e9e4>] do_softirq+0x64/0x80

[<80749020>] get_page_from_freelist+0x160/0x3e0

[<80748fc2>] get_page_from_freelist+0x102/0x3e0

[<8074980e>] __alloc_pages+0x6e/0x2e0

[<80749aa0>] __get_free_pages+0x20/0x60

[<80783986>] sys_mount+0x66/0xe0

[<80749740>] free_pages+0x0/0x60

[<807078f8>] syscall_call+0xa/0xe

[<80783920>] sys_mount+0x0/0xe0

 

Process: mount (pid: 998, stack limit = 81020001)

Stack: (0x810218d0 to 0x81022000)

18c0:                                     813330e8 81332ee8 81332ce8
81332ae8 

18e0: 810218e0 810218e0 8071e8e4 81333398 813320c0 808bca60 00000009
ffffff0f 

1900: 00000000 8133210c 8071e9e4 00000000 8a7fc7c8 000000f1 8a56ed40
00000000 

1920: 8133c374 000000f0 8071ee78 80712ee0 807028f6 000013e0 80707746
00000000 

1940: 807028c0 400081f1 8ac02f68 e9008920 2dd868f6 fffffff0 8ada8798
fffffff4 

1960: 1ffcb4f9 00000040 8ada8790 810219e4 00000000 8a56ed40 000000f1
8a7fc7c8 

1980: 00000000 810219a8 808b2820 8083315e 40008100 004d2290 00000000
025029d4 

19a0: ffffffff 4a7c053e 8ada8006 81021a14 81021a20 8a56e8c0 8088c8aa
8ada8000 

19c0: 000000f1 dad17f00 46000000 dad17f00 46000000 186a8600 bc000000
8a7fc744 

19e0: 0000a12b 00000001 808332fe 81021a24 8a7fc830 8a7fc7c8 00000000
8a7fc7c8 

1a00: 810219e8 8a7fc7c8 81021a1c 81021a24 81021a60 186a8600 bc000000
00000000 

1a20: ffffffff 81021a34 8082ebf2 83ac4c00 81021a34 00866a18 8a56e5c0
8a7fc7c8 

1a40: 82db651c 00000000 00000002 8a7fc84c 008667e4 00000001 000000bc
008667e4 

1a60: 00000001 00000000 00000000 000002e4 00866b90 808305e2 8083ada0
8a698d8c 

1a80: 000000bc 000001cc 81021a9c 82db651c 00000000 000000bc 00000000
82db651c 

1aa0: 83ac4c00 8a56e5c0 8acf6f78 00000000 00000002 00866a18 00000000
00000000 

1ac0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000
00000000 

1ae0: 00000000 00000000 00000000 8083af04 81021b54 00000000 00000000
82db651c 

1b00: 83d3e4c8 00000002 80861fd2 81021ba0 00000000 00000000 82dbbc60
82db6790 

1b20: 81021b54 00000000 83ac4dfc 82dbbd1c 83ac4efc 8087bf40 8087bfc0
00000000 

1b40: 00000000 80000000 00000000 80000001 00000000 83d3e4c8 00000001
00000000 

1b60: 00000001 00000000 ffffffff 808851ea 83ac4c00 00000001 00000000
81021b68 

1b80: 8085e960 00000000 82dbbc60 00000000 00000001 81021bbc 81021c1c
00000000 

1ba0: 82db651c 81021c18 80892d34 00000000 40000000 00000000 00000002
8113adb4 

1bc0: 00000000 8113ace0 8077f34a 8113acf8 8077f4f2 80712ee0 00000000
8113acf8 

1be0: 8087017e ffffffff 00000000 8ada6ee0 83ac4d78 83ac4d76 83ac4d3c
83ac4ea6 

1c00: 8a64e2a0 83ac4c40 83ac4c00 00000002 0000002e 00000000 82dbbc60
8ad4ae00 

1c20: 8ada6ee0 808707e6 81021c90 83ac4c40 8113ae20 8a64e2a0 8a64e2dc
00000000 

1c40: 8a64e260 8087625c 83ac4c00 00000000 00000000 83ac4ebc 00000002
00000000 

1c60: 00000000 00000000 00000002 00000000 00000040 835a3380 25029d38
00000000 

1c80: 00000000 00000000 00000001 00000000 808876d2 00000000 000002d0
00000058 

1ca0: 00000001 808877ec 816f01e0 808584c0 1e3c3c28 d591ef53 83ac4f54
00000058 

1cc0: 00000000 00000000 82dbbde0 8a56eb00 8087f30a 816f01e0 835a3380
8113b000 

1ce0: 81021cc0 83ac4c00 00000000 00000000 00000000 00000040 00000000
00000000 

1d00: 80893318 80774d20 8a99a000 8113b000 835a3380 83d68200 8a99a000
00000001 

1d20: 00000002 81021d93 0000000a ffffffff ffffffff 00000002 00000020
81021d90 

1d40: 8a67096c ffffffff 80ab6bdc 808ba576 80774d20 8a99a000 816f0220
81021d90 

1d60: 8a67096c 00000003 8a670960 81021d74 807aab2e 80794f54 8076ae32
816f0220 

1d80: 83d68200 816f01f8 00000001 83d68200 33626473 00000000 00000001
00000000 

1da0: 00000080 835b845c 807644a8 00000000 80892250 83832000 8a99a000
00008000 

1dc0: 8addf000 816f58a0 80b2b2e4 808932c0 816f58a0 8076a596 816f58a0
8076a66e 

1de0: ffffffed 80b2b2e4 8a99a000 8addf000 00008000 80783390 00008000
00000000 

1e00: 83832000 80770900 00000000 00000000 80712b3a 81021e30 835b8160
ffffffff 

1e20: ff485b19 8132d3a8 80a45f16 83c7cd94 835b8160 80712a58 8132d758
80712d66 

1e40: 8070faa0 808b852e 8070e9ce 81021f44 8070fb30 835b8160 00c76668
81020000 

1e60: 00000000 00000002 00000050 80722b3a 81333398 813320c0 808bca60
0000000a 

1e80: ffffff0f 80722c72 81333398 813330e8 81332ee8 81332ce8 81332ae8
81021e9c 

1ea0: 81021e9c 8071e8e4 81333398 813320c0 808bca60 0000000a 8071e8f6
00000000 

1ec0: 8133210c 8071e9e4 00008000 80749020 80748fc2 00000000 00000000
80b267bc 

1ee0: 00000044 00000000 000200d0 80b26944 00000000 00000000 8074980e
80b26940 

1f00: 80d330b8 816f57a0 835b8160 8a667000 81021f84 00000001 00000001
00000000 

1f20: 00000080 835b845c 00000010 00000eb1 814a3340 8addf000 000200d0
00008000 

1f40: 80749aa0 00008000 00402c9c 00008000 7b850eb1 8a667000 80783986
00008000 

1f60: 00402c9c 00008000 80749740 8a667000 81021f48 00000000 8a99a000
8addf000 

1f80: 83832000 8a99a000 807078f8 00000514 00000000 00000021 00000054
80783920 

1fa0: 004d22c0 0044b4b4 ffffffff 00000015 7b850eb1 7b850ebb 004d3518
00008000 

1fc0: 00008000 7b850aa4 004d2298 004d22c0 004736cc 00402c9c 00008000
7b8509e0 

1fe0: 0044b4bc 00423268 00008000 004d2290 00000000 0000004e 00000054
00000160 

Kernel panic - not syncing: Fatal exception in interrupt

============================================================================
====

 

============================================================================
====

# xfs_repair -n /dev/sdb3

Phase 1 - find and verify superblock...

Phase 2 - using internal log

        - scan filesystem freespace and inode maps...

block (2,518687-518687) multiply claimed by bno space tree, state - 2

bno freespace btree block claimed (state 2), agno 2, bno 41259, suspect 0

bno freespace btree block claimed (state 2), agno 2, bno 41348, suspect 0

block (2,518687-518687) multiply claimed by cnt space tree, state - 2

cnt freespace btree block claimed (state 2), agno 2, bno 38694, suspect 0

block (2,9883756-9883756) multiply claimed by cnt space tree, state - 2

block (2,9888268-9888268) multiply claimed by cnt space tree, state - 2

block (2,9889396-9889396) multiply claimed by cnt space tree, state - 2

block (2,9890900-9890900) multiply claimed by cnt space tree, state - 2

block (2,9891276-9891276) multiply claimed by cnt space tree, state - 2

block (2,9891652-9891652) multiply claimed by cnt space tree, state - 2

block (2,9892216-9892216) multiply claimed by cnt space tree, state - 2

block (2,9892592-9892592) multiply claimed by cnt space tree, state - 2

block (2,9893908-9893908) multiply claimed by cnt space tree, state - 2

block (2,9894284-9894284) multiply claimed by cnt space tree, state - 2

block (2,9895036-9895036) multiply claimed by cnt space tree, state - 2

block (2,9895600-9895600) multiply claimed by cnt space tree, state - 2

block (2,9895976-9895976) multiply claimed by cnt space tree, state - 2

block (2,9896540-9896540) multiply claimed by cnt space tree, state - 2

block (2,9897480-9897480) multiply claimed by cnt space tree, state - 2

block (2,9898420-9898420) multiply claimed by cnt space tree, state - 2

block (2,9899360-9899360) multiply claimed by cnt space tree, state - 2

block (2,9900488-9900488) multiply claimed by cnt space tree, state - 2

block (2,9905940-9905940) multiply claimed by cnt space tree, state - 2

block (2,9906316-9906316) multiply claimed by cnt space tree, state - 2

block (2,9908572-9908572) multiply claimed by cnt space tree, state - 2

block (2,9908948-9908948) multiply claimed by cnt space tree, state - 2

block (2,9913272-9913272) multiply claimed by cnt space tree, state - 2

block (2,9916656-9916656) multiply claimed by cnt space tree, state - 2

block (2,9922108-9922108) multiply claimed by cnt space tree, state - 2

block (2,9923048-9923048) multiply claimed by cnt space tree, state - 2

block (2,9924928-9924928) multiply claimed by cnt space tree, state - 2

block (2,9925868-9925868) multiply claimed by cnt space tree, state - 2

block (2,9926244-9926244) multiply claimed by cnt space tree, state - 2

block (2,9928500-9928500) multiply claimed by cnt space tree, state - 2

block (2,9929628-9929628) multiply claimed by cnt space tree, state - 2

block (2,9931320-9931320) multiply claimed by cnt space tree, state - 2

block (2,9931696-9931696) multiply claimed by cnt space tree, state - 2

block (2,9933012-9933012) multiply claimed by cnt space tree, state - 2

block (2,9936584-9936584) multiply claimed by cnt space tree, state - 2

block (2,9937524-9937524) multiply claimed by cnt space tree, state - 2

block (2,9939592-9939592) multiply claimed by cnt space tree, state - 2

block (2,9941472-9941472) multiply claimed by cnt space tree, state - 2

block (2,9943164-9943164) multiply claimed by cnt space tree, state - 2

block (2,9943728-9943728) multiply claimed by cnt space tree, state - 2

block (2,9944104-9944104) multiply claimed by cnt space tree, state - 2

block (2,9946360-9946360) multiply claimed by cnt space tree, state - 2

block (2,9946736-9946736) multiply claimed by cnt space tree, state - 2

block (2,9947676-9947676) multiply claimed by cnt space tree, state - 2

block (2,9948052-9948052) multiply claimed by cnt space tree, state - 2

block (2,9948241-9948241) multiply claimed by cnt space tree, state - 2

block (2,9949932-9949932) multiply claimed by cnt space tree, state - 2

block (2,9951624-9951624) multiply claimed by cnt space tree, state - 2

block (2,9954820-9954820) multiply claimed by cnt space tree, state - 2

block (2,9955760-9955760) multiply claimed by cnt space tree, state - 2

block (2,9957264-9957264) multiply claimed by cnt space tree, state - 2

block (2,9957640-9957640) multiply claimed by cnt space tree, state - 2

block (2,9959144-9959144) multiply claimed by cnt space tree, state - 2

block (2,9962904-9962904) multiply claimed by cnt space tree, state - 2

block (2,9964220-9964220) multiply claimed by cnt space tree, state - 2

block (2,9966664-9966664) multiply claimed by cnt space tree, state - 2

block (2,9967040-9967040) multiply claimed by cnt space tree, state - 2

block (2,9968168-9968168) multiply claimed by cnt space tree, state - 2

block (2,9968544-9968544) multiply claimed by cnt space tree, state - 2

block (2,9969672-9969672) multiply claimed by cnt space tree, state - 2

block (2,9971176-9971176) multiply claimed by cnt space tree, state - 2

block (2,9973620-9973620) multiply claimed by cnt space tree, state - 2

block (2,9973996-9973996) multiply claimed by cnt space tree, state - 2

block (2,9977192-9977192) multiply claimed by cnt space tree, state - 2

block (2,9978508-9978508) multiply claimed by cnt space tree, state - 2

block (2,9978884-9978884) multiply claimed by cnt space tree, state - 2

block (2,9983961-9983961) multiply claimed by cnt space tree, state - 2

block (2,9984337-9984337) multiply claimed by cnt space tree, state - 2

agf_freeblks 8477471, counted 8544090 in ag 2

agi unlinked bucket 46 is 608366 in ag 2 (inode=1074350190)

sb_ifree 193, counted 197

sb_fdblocks 65043106, counted 65276224

        - found root inode chunk

Phase 3 - for each AG...

        - scan (but don't clear) agi unlinked lists...

        - process known inodes and perform inode discovery...

        - agno = 0

        - agno = 1

        - agno = 2

data fork in ino 1074348352 claims free block 67147515

29560000: Badness in key lookup (length)

bp=(bno 310768336, len 16384 bytes) key=(bno 310768336, len 8192 bytes)

data fork in ino 1074350209 claims free block 75847242

data fork in ino 1074350209 claims free block 75847806

data fork in ino 1074350209 claims free block 75848558

data fork in ino 1074350209 claims free block 75849122

data fork in ino 1074350209 claims free block 75849686

data fork in ino 1074350209 claims free block 75851002

data fork in ino 1074350209 claims free block 75852694

data fork in ino 1074350209 claims free block 75853446

data fork in ino 1074350209 claims free block 75854198

data fork in ino 1074350209 claims free block 75854762

data fork in ino 1074350209 claims free block 75855514

data fork in ino 1074350209 claims free block 75856078

data fork in ino 1074350209 claims free block 75856830

data fork in ino 1074350209 claims free block 75858146

data fork in ino 1074350209 claims free block 75859086

data fork in ino 1074350209 claims free block 75859650

data fork in ino 1074350209 claims free block 75860402

data fork in ino 1074350209 claims free block 75861530

data fork in ino 1074350209 claims free block 75862094

data fork in ino 1074350209 claims free block 75862658

data fork in ino 1074350209 claims free block 75863222

data fork in ino 1074350209 claims free block 75863974

data fork in ino 1074350209 claims free block 75864350

data fork in ino 1074350209 claims free block 75864914

data fork in ino 1074350209 claims free block 75865478

data fork in ino 1074350209 claims free block 75866042

data fork in ino 1074350209 claims free block 75866794

data fork in ino 1074350209 claims free block 75867922

data fork in ino 1074350209 claims free block 75868862

data fork in ino 1074350209 claims free block 75869426

data fork in ino 1074350209 claims free block 75869802

data fork in ino 1074350209 claims free block 75870366

data fork in ino 1074350209 claims free block 75870930

data fork in ino 1074350209 claims free block 75871494

data fork in ino 1074350209 claims free block 75872246

data fork in ino 1074350209 claims free block 75873186

data fork in ino 1074350209 claims free block 75873750

data fork in ino 1074350209 claims free block 75874126

data fork in ino 1074350209 claims free block 75875066

data fork in ino 1074350209 claims free block 75875630

data fork in ino 1074350209 claims free block 75876194

data fork in ino 1074350209 claims free block 75876570

data fork in ino 1074350209 claims free block 75878074

data fork in ino 1074350209 claims free block 75878638

data fork in ino 1074350209 claims free block 75879014

data fork in ino 1074350209 claims free block 75880246

data fork in ino 1074350209 claims free block 75880810

data fork in ino 1074350209 claims free block 75881374

data fork in ino 1074350209 claims free block 75882502

data fork in ino 1074350209 claims free block 75882878

data fork in ino 1074350209 claims free block 75883442

data fork in ino 1074350209 claims free block 75884006

data fork in ino 1074350209 claims free block 75884759

data fork in ino 1074350209 claims free block 75885135

data fork in ino 1074350209 claims free block 75885699

data fork in ino 1074350209 claims free block 75886075

data fork in ino 1074350209 claims free block 75886827

data fork in ino 1074350209 claims free block 75888144

data fork in ino 1074350209 claims free block 75888896

data fork in ino 1074350209 claims free block 75889648

data fork in ino 1074350209 claims free block 75890212

data fork in ino 1074350209 claims free block 75890588

data fork in ino 1074350209 claims free block 75891152

data fork in ino 1074350209 claims free block 75891716

data fork in ino 1074350209 claims free block 75892280

data fork in ino 1074350209 claims free block 75892844

data fork in ino 1074350209 claims free block 75893220

data fork in ino 1074350209 claims free block 75893784

data fork in ino 1074350209 claims free block 76120044

data fork in ino 1074350218 claims free block 76543991

data fork in ino 1074350218 claims free block 76546060

data fork in ino 1074350218 claims free block 76546436

data fork in ino 1074350218 claims free block 76549820

data fork in ino 1074350218 claims free block 76550196

data fork in ino 1074350218 claims free block 76552828

data fork in ino 1074350218 claims free block 76554896

data fork in ino 1074350218 claims free block 76559784

data fork in ino 1074350218 claims free block 76580652

data fork in ino 1074350218 claims free block 76581216

data fork in ino 1074350218 claims free block 76581780

data fork in ino 1074350218 claims free block 76584224

data fork in ino 1074350218 claims free block 76587044

data fork in ino 1074350218 claims free block 76587420

data fork in ino 1074350218 claims free block 76588360

data fork in ino 1074350218 claims free block 76590804

data fork in ino 1074350218 claims free block 76591180

data fork in ino 1074350218 claims free block 76593436

data fork in ino 1074350218 claims free block 76593812

data fork in ino 1074350218 claims free block 76595128

data fork in ino 1074350218 claims free block 76596632

data fork in ino 1074350218 claims free block 76597948

data fork in ino 1074350218 claims free block 76599828

data fork in ino 1074350218 claims free block 76601144

data fork in ino 1074350218 claims free block 76601520

data fork in ino 1074350218 claims free block 76604152

data fork in ino 1074350218 claims free block 76605844

data fork in ino 1074350218 claims free block 76606784

data fork in ino 1074350218 claims free block 76608852

data fork in ino 1074350218 claims free block 76609792

data fork in ino 1074350218 claims free block 76610732

data fork in ino 1074350218 claims free block 76611860

data fork in ino 1074350218 claims free block 76612988

data fork in ino 1074350218 claims free block 76615996

data fork in ino 1074350218 claims free block 76617688

data fork in ino 1074350218 claims free block 76619568

data fork in ino 1074350218 claims free block 76621824

data fork in ino 1074350218 claims free block 76622600

data fork in ino 1074350218 claims free block 76626172

data fork in ino 1074350218 claims free block 76627301

data fork in ino 1074350218 claims free block 76632753

data fork in ino 1074350218 claims free block 76634069

data fork in ino 1074350218 claims free block 76638205

data fork in ino 1074350218 claims free block 76639897

data fork in ino 1074350218 claims free block 76640273

data fork in ino 1074350218 claims free block 76647041

data fork in ino 1074350218 claims free block 76647417

data fork in ino 1074350218 claims free block 76648733

data fork in ino 1074350218 claims free block 76649109

data fork in ino 1074350218 claims free block 76650801

data fork in ino 1074350218 claims free block 76651177

data fork in ino 1074350218 claims free block 76652869

data fork in ino 1074350218 claims free block 76653245

data fork in ino 1074350218 claims free block 76653809

data fork in ino 1074350218 claims free block 76658509

data fork in ino 1074350218 claims free block 76659825

data fork in ino 1074350218 claims free block 76662645

data fork in ino 1074350218 claims free block 76663021

data fork in ino 1074350218 claims free block 76666781

data fork in ino 1074350218 claims free block 76668097

data fork in ino 1074350218 claims free block 76675054

data fork in ino 1074350218 claims free block 76676934

data fork in ino 1074350218 claims free block 76682574

data fork in ino 1074350218 claims free block 76686334

data fork in ino 1074350218 claims free block 76689342

data fork in ino 1074350218 claims free block 76691786

data fork in ino 1074350218 claims free block 76697802

data fork in ino 1074350218 claims free block 76705134

data fork in ino 1074350218 claims free block 76707202

data fork in ino 1074350218 claims free block 76709646

data fork in ino 1074350218 claims free block 76710022

data fork in ino 1074350218 claims free block 76710398

data fork in ino 1074350218 claims free block 76715286

        - agno = 3

        - process newly discovered inodes...

Phase 4 - check for duplicate blocks...

        - setting up duplicate extent list...

        - check for inodes claiming duplicate blocks...

        - agno = 0

        - agno = 1

        - agno = 2

        - agno = 3

No modify flag set, skipping phase 5

Phase 6 - check inode connectivity...

        - traversing filesystem ...

        - traversal finished ...

        - moving disconnected inodes to lost+found ...

disconnected inode 1074350190, would move to lost+found

Phase 7 - verify link counts...

would have reset inode 1074350190 nlinks from 0 to 1

No modify flag set, skipping filesystem flush and exiting.

============================================================================
====

 

============================================================================
====

# xfs_logprint -t /dev/sdb3

xfs_logprint:

    data device: 0x813

    log device: 0x813 daddr: 310464192 length: 303184

 

    log tail: 273322 head: 273412 state: <DIRTY>

 

 

LOG REC AT LSN cycle 7 block 273322 (0x7, 0x42baa)

============================================================================

TRANS: tid:0x83f862b0  type:INACTIVE  #items:3  trans:0x0  q:0x434c08

INO: cnt:2 total:2 a:0x42c6f8 len:52 a:0x42c750 len:96 

        INODE: #regs:2   ino:0x4009486e  flags:0x1   dsize:0

        CORE inode:

BUF: cnt:2 total:2 a:0x42c7b8 len:28 a:0x42ca28 len:128 

        BUF:  #regs:2   start blkno:0x160fa990   len:8   bmap size:2  

flags:0x0

        BUF DATA

EFI: cnt:1 total:1 a:0x42cab0 len:40 

        EFI:  #regs:1    num_extents:2  id:0xffffffff81dd5c88

        (s: 0x6129273, l: 18236) (s: 0x6137a4d, l: 3388) 

============================================================================

TRANS: tid:0x83f862b0  type:INACTIVE  #items:7  trans:0x0  q:0x42cae0

EFD: cnt:1 total:1 a:0x42cab0 len:40 

        EFD:  #regs: 1    num_extents: 2  id: 0xffffffff81dd5c88

BUF: cnt:2 total:2 a:0x42ca08 len:24 a:0x42ca28 len:128 

        BUF:  #regs:2   start blkno:0x1bc1f5f1   len:1   bmap size:1  

flags:0x0

        AGF Buffer: (XAGF)

BUF: cnt:3 total:3 a:0x42c730 len:28 a:0x42cb40 len:128 a:0x434c28 len:512 

        BUF:  #regs:3   start blkno:0x1c1bb470   len:8   bmap size:2  

flags:0x0

        BUF DATA

        BUF DATA

BUF: cnt:3 total:3 a:0x42cb10 len:28 a:0x434e30 len:128 a:0x434eb8 len:128 

        BUF:  #regs:3   start blkno:0x1bcf8b40   len:8   bmap size:2  

flags:0x0

        BUF DATA

        BUF DATA

BUF: cnt:2 total:2 a:0x42c770 len:28 a:0x434f60 len:2304 

        BUF:  #regs:2   start blkno:0x1bcf8b50   len:8   bmap size:2  

flags:0x0

        BUF DATA

INO: cnt:2 total:2 a:0x435868 len:52 a:0x4358e0 len:96 

        INODE: #regs:2   ino:0x4009486e  flags:0x1   dsize:0

        CORE inode:

BUF: cnt:2 total:2 a:0x435948 len:24 a:0x4359a8 len:128 

        BUF:  #regs:2   start blkno:0x0   len:1   bmap size:1   flags:0x0

        SUPER Block Buffer:

============================================================================

TRANS: tid:0x83f862b0  type:INACTIVE  #items:3  trans:0x0  q:0x435968

INO: cnt:2 total:2 a:0x435868 len:52 a:0x4358e0 len:96 

        INODE: #regs:2   ino:0x4009486e  flags:0x1   dsize:0

        CORE inode:

BUF: cnt:2 total:2 a:0x435948 len:28 a:0x42ca28 len:128 

        BUF:  #regs:2   start blkno:0x160fa990   len:8   bmap size:2  

flags:0x0

        BUF DATA

EFI: cnt:1 total:1 a:0x42cab0 len:40 

        EFI:  #regs:1    num_extents:2  id:0xffffffff81dd5d8c

        (s: 0x610546a, l: 188) (s: 0x61055e2, l: 22372) 

============================================================================

TRANS: tid:0x83f862b0  type:INACTIVE  #items:9  trans:0x0  q:0x434f40

EFD: cnt:1 total:1 a:0x42cab0 len:40 

        EFD:  #regs: 1    num_extents: 2  id: 0xffffffff81dd5d8c

BUF: cnt:2 total:2 a:0x4358a0 len:24 a:0x42ca28 len:128 

        BUF:  #regs:2   start blkno:0x1bc1f5f1   len:1   bmap size:1  

flags:0x0

        AGF Buffer: (XAGF)

BUF: cnt:3 total:3 a:0x435968 len:28 a:0x434c28 len:128 a:0x434f60 len:896 

        BUF:  #regs:3   start blkno:0x1c1bb470   len:8   bmap size:2  

flags:0x0

        BUF DATA

        BUF DATA

BUF: cnt:2 total:2 a:0x434c08 len:28 a:0x4359a8 len:2304 

        BUF:  #regs:2   start blkno:0x1bcf8b50   len:8   bmap size:2  

flags:0x0

        BUF DATA

BUF: cnt:2 total:2 a:0x42c7b8 len:28 a:0x42c6f8 len:128 

        BUF:  #regs:2   start blkno:0x1c23cb48   len:8   bmap size:2  

flags:0x0

        BUF DATA

BUF: cnt:2 total:2 a:0x435900 len:28 a:0x4362b0 len:4096 

        BUF:  #regs:2   start blkno:0x1bcf8b40   len:8   bmap size:2  

flags:0x0

        BUF DATA

BUF: cnt:3 total:3 a:0x42cb30 len:28 a:0x434cb0 len:128 a:0x434d38 len:128 

        BUF:  #regs:3   start blkno:0x1bc1f620   len:8   bmap size:2  

flags:0x0

        BUF DATA

        BUF DATA

INO: cnt:2 total:2 a:0x434dc0 len:52 a:0x42cb98 len:96 

        INODE: #regs:2   ino:0x4009486e  flags:0x1   dsize:0

        CORE inode:

BUF: cnt:2 total:2 a:0x434e38 len:24 a:0x434e98 len:128 

        BUF:  #regs:2   start blkno:0x0   len:1   bmap size:1   flags:0x0

        SUPER Block Buffer:

============================================================================

TRANS: tid:0x83f862b0  type:INACTIVE  #items:3  trans:0x0  q:0x434e58

INO: cnt:2 total:2 a:0x434dc0 len:52 a:0x42cb98 len:96 

        INODE: #regs:2   ino:0x4009486e  flags:0x1   dsize:0

        CORE inode:

BUF: cnt:2 total:2 a:0x434e38 len:28 a:0x42ca28 len:128 

        BUF:  #regs:2   start blkno:0x160fa990   len:8   bmap size:2  

flags:0x0

        BUF DATA

EFI: cnt:1 total:1 a:0x42cab0 len:40 

        EFI:  #regs:1    num_extents:2  id:0xffffffff81dd5e90

       (s: 0x610517a, l: 188) (s: 0x61052f2, l: 188) 

============================================================================

TRANS: tid:0x83f862b0  type:INACTIVE  #items:6  trans:0x0  q:0x42cb50

EFD: cnt:1 total:1 a:0x42cab0 len:40 

        EFD:  #regs: 1    num_extents: 2  id: 0xffffffff81dd5e90

BUF: cnt:2 total:2 a:0x434df8 len:24 a:0x42ca28 len:128 

        BUF:  #regs:2   start blkno:0x1bc1f5f1   len:1   bmap size:1  

flags:0x0

        AGF Buffer: (XAGF)

BUF: cnt:3 total:3 a:0x434e58 len:28 a:0x434e98 len:128 a:0x434f20 len:896 

        BUF:  #regs:3   start blkno:0x1c1bb470   len:8   bmap size:2  

flags:0x0

        BUF DATA

        BUF DATA

BUF: cnt:2 total:2 a:0x42ca08 len:28 a:0x4352a8 len:2304 

        BUF:  #regs:2   start blkno:0x1bcf8b50   len:8   bmap size:2  

flags:0x0

        BUF DATA

INO: cnt:2 total:2 a:0x42cb98 len:52 a:0x42c6f8 len:96 

        INODE: #regs:2   ino:0x4009486e  flags:0x1   dsize:0

        CORE inode:

BUF: cnt:2 total:2 a:0x42c760 len:24 a:0x434c08 len:128 

        BUF:  #regs:2   start blkno:0x0   len:1   bmap size:1   flags:0x0

        SUPER Block Buffer:

============================================================================

TRANS: tid:0x83f862b0  type:INACTIVE  #items:3  trans:0x0  q:0x42c780

INO: cnt:2 total:2 a:0x42cb98 len:52 a:0x42c6f8 len:96 

        INODE: #regs:2   ino:0x4009486e  flags:0x1   dsize:0

        CORE inode:

BUF: cnt:2 total:2 a:0x42c760 len:28 a:0x42ca28 len:128 

        BUF:  #regs:2   start blkno:0x160fa990   len:8   bmap size:2  

flags:0x0

        BUF DATA

EFI: cnt:1 total:1 a:0x42cab0 len:40 

        EFI:  #regs:1    num_extents:2  id:0xffffffff81dd597c

        (s: 0x48670b4, l: 376) (s: 0x6104f46, l: 188) 

 

LOG REC AT LSN cycle 7 block 273386 (0x7, 0x42bea)

============================================================================

TRANS: tid:0x82a500ac  type:  #items:12  trans:0x0  q:0x437e68

EFD: cnt:1 total:1 a:0x437e88 len:40 

        EFD:  #regs: 1    num_extents: 2  id: 0xffffffff81dd597c

BUF: cnt:2 total:2 a:0x437eb8 len:24 a:0x437f18 len:128 

        BUF:  #regs:2   start blkno:0x12814ea1   len:1   bmap size:1  

flags:0x0

        AGF Buffer: (XAGF)

BUF: cnt:3 total:3 a:0x437fa0 len:28 a:0x438008 len:128 a:0x438090 len:896 

        BUF:  #regs:3   start blkno:0x1bcf8b50   len:8   bmap size:2  

flags:0x0

        BUF DATA

        BUF DATA

BUF: cnt:2 total:2 a:0x438418 len:28 a:0x438478 len:128 

        BUF:  #regs:2   start blkno:0x1285f888   len:8   bmap size:2  

flags:0x0

        BUF DATA

BUF: cnt:2 total:2 a:0x438500 len:28 a:0x438560 len:4096 

        BUF:  #regs:2   start blkno:0x128657f8   len:8   bmap size:2  

flags:0x0

        BUF DATA

BUF: cnt:3 total:3 a:0x439568 len:28 a:0x4395d0 len:128 a:0x439658 len:128 

        BUF:  #regs:3   start blkno:0x12869e58   len:8   bmap size:2  

flags:0x0

        BUF DATA

        BUF DATA

BUF: cnt:2 total:2 a:0x4396e0 len:28 a:0x439740 len:128 

        BUF:  #regs:2   start blkno:0x12ac72b0   len:8   bmap size:2  

flags:0x0

        BUF DATA

BUF: cnt:3 total:3 a:0x4397c8 len:28 a:0x439830 len:128 a:0x4398b8 len:1792 

        BUF:  #regs:3   start blkno:0x12e15e58   len:8   bmap size:2  

flags:0x0

        BUF DATA

        BUF DATA

BUF: cnt:2 total:2 a:0x439fc0 len:28 a:0x43a020 len:2816 

        BUF:  #regs:2   start blkno:0x12f68de0   len:8   bmap size:2  

flags:0x0

        BUF DATA

BUF: cnt:2 total:2 a:0x43ab28 len:24 a:0x43ab88 len:128 

        BUF:  #regs:2   start blkno:0x1bc1f5f1   len:1   bmap size:1  

flags:0x0

        AGF Buffer: (XAGF)

BUF: cnt:2 total:2 a:0x43ac10 len:24 a:0x43ac70 len:128 

        BUF:  #regs:2   start blkno:0x0   len:1   bmap size:1   flags:0x0

        SUPER Block Buffer:

BUF: cnt:3 total:3 a:0x43acf8 len:28 a:0x43ad60 len:128 a:0x43ade8 len:896 

        BUF:  #regs:3   start blkno:0x1c1bb470   len:8   bmap size:2  

flags:0x0

        BUF DATA

        BUF DATA

============================================================================
====

 

Regrads,

Ryan. 

 

 

 

 

Hi All,

 

I got different behavior when I tried to mount the image which was created
by

the xfs_mdrestore. 

 

I made the image with xfs_metadump and xfs_mdrestore and tried to mount it.

 

please see the log in the below.

 

============================================================================
====

# mount -o loop -t xfs ./HDD7.img /mnt/hdd

Filesystem "loop0": Disabling barriers, not supported by the underlying
device

XFS mounting filesystem loop0

Starting XFS recovery on filesystem: loop0 (logdev: internal)

Filesystem "loop0": XFS internal error xfs_btree_check_sblock at line 334 of

file fs/xfs/xfs_btree.c.  Caller 0x8083159e

Stack: (0x8aeb5940 to 0x8aeb6000)

5940: 808496cc 8223c7e8 82bc3000 0000014e 8083159e 8083159e 00000045
833da000 

5960: 811355c0 8223c7e8 82bc3000 8aeb2400 00000000 8113563c 811355c0
8aeb2400 

5980: 811352c0 81135500 80833104 8aeb5a24 8223c7e8 00000045 811355c0
00000000 

59a0: 8aeb59e4 00000000 833da006 8aeb5a14 8aeb5a20 81337764 00000000
833da000 

59c0: 8223c7e8 00000000 00000000 12cbf008 00000000 e4678600 bc000000
00000000 

59e0: ffffffff 00000000 808332fe 8aeb5a24 8223c850 8223c7e8 00000000
8223c86c 

5a00: 8aeb59e8 8223c7e8 8aeb5a1c 8aeb5a24 8aeb5a60 e4678600 bc000000
00000000 

5a20: ffffffff 811355c0 8082ec3e 8aeb2400 8aeb5a34 008667e4 81135200
8223c86c 

5a40: 82991094 00000000 00000002 8223c7e8 008667e4 000000bc 00000001
0085f3db 

5a60: 00000000 00000000 00000000 000002e4 00866b90 808305e2 8083ada0
82f8ad8c 

5a80: 000000bc 000001cc 8aeb5a9c 82991094 00000000 000000bc 00000000
82991094 

5aa0: 8aeb2400 81135200 8ad557d8 00000000 00000002 008667e4 00000000
00000000 

5ac0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000
00000000 

5ae0: 00000000 00000000 00000000 8083af04 8aeb5b54 82f8b4c8 00000000
82991094 

5b00: 82f8b4bc 00000002 80861fd2 8aeb5ba0 00000000 00000000 8afe8360
82991a64 

5b20: 8aeb5b54 00000000 8aeb25fc 8afe841c 8aeb26fc 8087bf40 8087bfc0
00000000 

5b40: 00000000 80000000 00000000 80000001 00000000 82f8b4bc 00000002
00000000 

5b60: 00000001 00000000 ffffffff 808851ea 8aeb2400 00000001 00000000
8aeb5b68 

5b80: 8085e960 00000000 8afe8360 00000000 00000001 8aeb5bbc 8aeb5c1c
00000000 

5ba0: 82991094 8aeb5c18 80892d34 00000000 40000000 00000000 00000002
83d303b4 

5bc0: 00000000 83d302e0 8077f34a 83d302f8 8077f4f2 80712ee0 00000000
83d302f8 

5be0: 8087017e ffffffff 00000000 828f1be0 8aeb2578 8aeb2576 8aeb253c
8aeb26a6 

5c00: 8a985e20 8aeb2440 8aeb2400 00000002 0000002e 00000000 8afe8360
822b8e00 

5c20: 828f1be0 808707e6 8aeb5c90 8aeb2440 83d301a0 8a985e20 8a985e5c
00000000 

5c40: 8a985de0 8087625c 8aeb2400 00000000 00000000 8aeb26bc 00000002
00000000 

5c60: 00000000 00000000 00000002 00000000 00000040 83e814a0 25029d38
00000000 

5c80: 00000000 00000000 00000001 00000000 808876d2 00000000 000002d0
00000058 

5ca0: 00000001 808877ec 816f0380 808584c0 1e3c3c28 d591ef53 8aeb2754
00000058 

5cc0: 00000000 00000000 8afe81e0 81135800 8087f30a 816f0380 83e814a0
83817800 

5ce0: 8aeb5cc0 8aeb2400 00000000 00000000 00000000 00000040 00000000
00000000 

5d00: 80893318 80774d20 00000000 83817800 83e814a0 83ad0600 00000000
00000001 

5d20: 00000000 00000000 00000000 00000000 00000000 00000000 80a45d74
00000020 

5d40: 8aeb5d90 8a5ee9cc ffffffff 80ad8926 808ba576 80774d20 00000000
816f03c0 

5d60: 8aeb5d90 816f0398 00000000 8a5ee9c0 8aeb5d78 80794f54 8076ae32
816f03c0 

5d80: 83ad0600 816f0398 00000001 83ad0600 706f6f6c 80760030 80774d20
8317d000 

5da0: 00000000 000080d0 807644a8 00000000 80892250 8317d000 00000000
00008000 

5dc0: 82e0b000 816f5920 80b2b2e4 808932c0 816f5920 8076a596 816f5920
8076a66e 

5de0: ffffffed 80b2b2e4 00000000 82e0b000 00008000 80783390 00008000
00000000 

5e00: 8317d000 80770900 00000000 00000000 ffffffe7 807539a6 8295534c
80753a6c 

5e20: 81334c90 00000000 83d6e470 83cd4c20 7b847848 816f0380 8070fad2
83cd4c14 

5e40: 8aeb5f04 808b852e 83cd4c14 8070faf8 83d6e470 8a33ea40 8aeb4000
83cd4be0 

5e60: 00000000 814979c0 8a5ee9c0 807518e2 8a6c9004 00447cb4 00000000
00000000 

5e80: 00000000 00000047 00447000 814979c0 00000200 80753680 81334c90
00447cb4 

5ea0: 8a6c9004 8aeb4000 8295511c 00000000 0000011c 00000047 00000000
00000000 

5ec0: 00000000 83d6e710 83cd4be0 80749020 80748fc2 00000000 00000000
80b267bc 

5ee0: 00000044 80707740 00008000 00402c9c 82e0b000 00001000 000002d0
807076c0 

5f00: 812e5498 816f57a0 00000000 00000000 000002d0 00000001 00000001
00000000 

5f20: 82e0bd30 004d22d0 8aeb5f7c 000002d0 00001000 82e0b000 00402c9c
00008000 

5f40: 8aeb5f64 80781eae 80781e68 40008000 004d2290 00000000 80783986
00008000 

5f60: 00402c9c 00008000 80749740 828fe000 8aeb5f48 00000000 00000000
82e0b000 

5f80: 8317d000 00000000 807078f8 00000514 00000000 00000021 00000054
80783920 

5fa0: 00000000 0044b4b4 00000002 00000015 004d22d0 7b847ea4 7b847e95
00008000 

5fc0: 00008000 7b847a64 004d2298 00000000 004736cc 00402c9c 00008000
7b8479a0 

5fe0: 0044b4bc 00423268 00008000 004d2290 00000000 00000000 00000054
00000160 

 

Call trace: 

[<8083159e>] xfs_alloc_lshift+0x7e/0x280

[<8083159e>] xfs_alloc_lshift+0x7e/0x280

[<80833104>] xfs_alloc_insrec+0x264/0x400

[<808332fe>] xfs_alloc_insert+0x5e/0x100

[<8082ec3e>] xfs_free_ag_extent+0x2be/0x5c0

[<808305e2>] xfs_free_extent+0x82/0xc0

[<8083ada0>] xfs_bmap_del_free+0x0/0x40

[<8083af04>] xfs_bmap_finish+0xe4/0x160

[<80861fd2>] xfs_itruncate_finish+0x212/0x420

[<8087bf40>] xfs_trans_ihold+0x0/0x20

[<8087bfc0>] xfs_trans_ijoin+0x0/0x80

[<808851ea>] xfs_inactive+0x3ea/0x500

[<8085e960>] xfs_ilock+0x0/0xc0

[<80892d34>] xfs_fs_clear_inode+0x34/0xa0

[<8077f34a>] clear_inode+0x4a/0x120

[<8077f4f2>] generic_delete_inode+0xd2/0x120

[<80712ee0>] sub_preempt_count+0x0/0xa0

[<8087017e>] xlog_recover_process_iunlinks+0x35e/0x3a0

[<808707e6>] xlog_recover_finish+0xa6/0xe0

[<8087625c>] xfs_mountfs+0xc1c/0xe40

[<808876d2>] kmem_alloc+0x52/0x100

[<808877ec>] kmem_zalloc+0xc/0x40

[<808584c0>] xfs_fstrm_free_func+0x0/0xc0

[<8087f30a>] xfs_mount+0x3ca/0x420

[<80893318>] xfs_fs_fill_super+0x58/0x240

[<80774d20>] path_lookup+0x0/0x20

[<80a45d74>] __down_write_nested+0x134/0x180

[<808ba576>] snprintf+0x16/0x40

[<80774d20>] path_lookup+0x0/0x20

[<80794f54>] sb_set_blocksize+0x14/0x40

[<8076ae32>] get_sb_bdev+0x152/0x1e0

[<80760030>] shmem_parse_options+0x2b0/0x3c0

[<80774d20>] path_lookup+0x0/0x20

[<807644a8>] __kmalloc+0x48/0x100

[<80892250>] xfs_fs_get_sb+0x10/0x20

[<808932c0>] xfs_fs_fill_super+0x0/0x240

[<8076a596>] vfs_kern_mount+0x36/0xc0

[<8076a66e>] do_kern_mount+0x2e/0xe0

[<80783390>] do_mount+0x130/0x6c0

[<80770900>] path_release+0x0/0x40

[<807539a6>] handle_mm_fault+0x446/0x720

[<80753a6c>] handle_mm_fault+0x50c/0x720

[<8070fad2>] do_page_fault+0x92/0x380

[<808b852e>] __up_read+0x4e/0xe0

[<8070faf8>] do_page_fault+0xb8/0x380

[<807518e2>] __do_fault+0x182/0x4a0

[<80753680>] handle_mm_fault+0x120/0x720

[<80749020>] get_page_from_freelist+0x160/0x3e0

[<80748fc2>] get_page_from_freelist+0x102/0x3e0

[<80707740>] ret_from_exception+0x0/0x6

[<807076c0>] tlb_miss_load+0x0/0x4

[<80781eae>] copy_mount_options+0x8e/0x100

[<80781e68>] copy_mount_options+0x48/0x100

[<80783986>] sys_mount+0x66/0xe0

[<80749740>] free_pages+0x0/0x60

[<807078f8>] syscall_call+0xa/0xe

[<80783920>] sys_mount+0x0/0xe0

 

xfs_force_shutdown(loop0,0x8) called from line 4274 of file
fs/xfs/xfs_bmap.c. 

Return address = 0x8083af3c

Filesystem "loop0": Corruption of in-memory data detected.  Shutting down

filesystem: loop0

Please umount the filesystem, and rectify the problem(s)

Ending XFS recovery on filesystem: loop0 (logdev: internal)

============================================================================
====

 

Thanks,

Ryan. 

 

 

----------------------------------------------------------------------------
----


--Boundary_(ID_hERFTgdZheltJ2F45NpSFA)
Content-type: text/html; CHARSET=US-ASCII
Content-transfer-encoding: 7BIT

<html xmlns:v="urn:schemas-microsoft-com:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:w="urn:schemas-microsoft-com:office:word" xmlns:m="http://schemas.microsoft.com/office/2004/12/omml" xmlns="http://www.w3.org/TR/REC-html40"><head><meta http-equiv=Content-Type content="text/html; charset=us-ascii"><meta name=Generator content="Microsoft Word 14 (filtered medium)"><style><!--
/* Font Definitions */
@font-face
	{font-family:"Malgun Gothic";
	panose-1:2 11 5 3 2 0 0 2 0 4;}
@font-face
	{font-family:"Malgun Gothic";
	panose-1:2 11 5 3 2 0 0 2 0 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
	margin-bottom:.0001pt;
	text-align:justify;
	text-justify:inter-ideograph;
	text-autospace:none;
	word-break:break-hangul;
	font-size:10.0pt;
	font-family:"Malgun Gothic";}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:purple;
	text-decoration:underline;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Malgun Gothic";
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-family:"Malgun Gothic";}
/* Page Definitions */
@page WordSection1
	{size:612.0pt 792.0pt;
	margin:3.0cm 72.0pt 72.0pt 72.0pt;}
div.WordSection1
	{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext="edit" spidmax="1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext="edit">
<o:idmap v:ext="edit" data="1" />
</o:shapelayout></xml><![endif]--></head><body lang=KO link=blue vlink=purple><div class=WordSection1><p class=MsoNormal><span lang=EN-US>Dear Members,<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><span lang=EN-US>I'm using XFS based on STMicro SH4 based chip (STi7105).<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>and I have some issue on xfs log mounting.<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><span lang=EN-US>1. chip : sh4 STi7105<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>2. HDD : 320GB USB HDD USB 2.0 port.<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>3. OS : Linux 2.6.23.17 + patch for fixing cache aliasing issue.<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>4. XFSProgs version : 3.1.1<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><span lang=E
 N-US><o:
<p class=MsoNormal><span lang=EN-US>The repairing log in the below. This hang-up (various kind of) is caused by<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>the memmove in xfs_alloc_insrec function of xfs_alloc_btree.c file. The memmove<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>has negative value for size argument so the system hang-up is caused. the<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>numrecs was 2 and the ptr was 11 before hang-up.<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp; } else {<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /*<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * It's a leaf entry.&nbsp; Make a hole for the new record.<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
 &nbsp;&n
/span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rp = XFS_ALLOC_REC_ADDR(block, 1, cur);<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; memmove(&amp;rp[ptr], &amp;rp[ptr - 1],<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (numrecs - ptr + 1) * sizeof(*rp));<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><span lang=EN-US>I want to know why and how this error can be happen. Would you please explain or give some hint for this?<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><span lang=EN-US>Thank you in advance.<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><span lang=EN-US>======
 ========
=========================================<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US># mount /dev/sdb3 /mnt/flash/<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>XFS mounting filesystem sdb3<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>Starting XFS recovery on filesystem: sdb3 (logdev: internal)<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>BUG: FPU is used in kernel mode.<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>Unable to handle kernel paging request at virtual address 005f2222<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>pc = 81332400<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>*pde = 83ced000<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>Oops: 0001 [#1]<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>Modules linked in: stsectoolfuse_ioctl(P) adf(P) asf(P) ath_hif_usb<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>embxloopback(P) embxmailbox(P) sec_nvram ath
 _htc_hst
o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>sttkdma_ioctl(P) ath_rate_atheros(P) mme_host(P) embxshm(P) sttkdma_core(P)<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>stpti4_ioctl(P) stsectoolfuse_core(P) MHFSWRAPGPL_KERN ath_dev(P) xsr(P)<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>ath_hal(P) xsr_stl(P) stuart_core(P) MHFSWRAP_KERN(P) stsmart_core(P) wifitt(P)<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>umac stapi_core(P) CDIDVB_ST_REF(P)<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><span lang=EN-US>Pid : 998, Comm:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; mount<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>PC is at boot_tvec_bases+0x120/0x1020<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>PC&nbsp; : 81332400 SP&nbsp; : 810218d0 SR&nbsp; : 40000001 TEA : c162cb64&nbsp;&nbsp;&nbsp; Tainted: P&nbsp;&n
 bsp;&nbs
></o:p></span></p><p class=MsoNormal><span lang=EN-US>R0&nbsp; : 00000004 R1&nbsp; : 00000101 R2&nbsp; : 81020000 R3&nbsp; : 8acffe94<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>R4&nbsp; : 005f2222 R5&nbsp; : 8a31b260 R6&nbsp; : 005f2223 R7&nbsp; : 00000002<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>R8&nbsp; : 00000101 R9&nbsp; : 813322e0 R10 : 810218e0 R11 : 81020000<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>R12 : 810218a8 R13 : 813323f8 R14 : 005f2222<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>MACH: 000000c0 MACL: 00000028 GBR : 004d2290 PR&nbsp; : 80722ccc<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><span lang=EN-US>Call trace: <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;8071e8e4&gt;] __do_softirq+0x64/0x100<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;808bca60&gt;] debug_smp_processor_id+0x0/0xc0<o:p></o:p></span></p><p cl
 ass=MsoN
lt;8071e9e4&gt;] do_softirq+0x64/0x80<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;8071ee78&gt;] irq_exit+0x38/0x60<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80712ee0&gt;] sub_preempt_count+0x0/0xa0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;807028f6&gt;] do_IRQ+0x36/0x80<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80707746&gt;] ret_from_irq+0x0/0x1a<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;807028c0&gt;] do_IRQ+0x0/0x80<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;808b2820&gt;] memcpy+0xac/0x28c<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;8083315e&gt;] xfs_alloc_insrec+0x2be/0x400<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;8088c8aa&gt;] xfs_buf_get_flags+0x10a/0x160<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;808332fe&gt;] xfs_alloc_insert+0x5e/0x100<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;
 8082ebf2
0x272/0x5c0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;808305e2&gt;] xfs_free_extent+0x82/0xc0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;8083ada0&gt;] xfs_bmap_del_free+0x0/0x40<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;8083af04&gt;] xfs_bmap_finish+0xe4/0x160<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80861fd2&gt;] xfs_itruncate_finish+0x212/0x420<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;8087bf40&gt;] xfs_trans_ihold+0x0/0x20<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;8087bfc0&gt;] xfs_trans_ijoin+0x0/0x80<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;808851ea&gt;] xfs_inactive+0x3ea/0x500<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;8085e960&gt;] xfs_ilock+0x0/0xc0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80892d34&gt;] xfs_fs_clear_inode+0x34/0xa0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[
 &lt;8077
a/0x120<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;8077f4f2&gt;] generic_delete_inode+0xd2/0x120<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80712ee0&gt;] sub_preempt_count+0x0/0xa0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;8087017e&gt;] xlog_recover_process_iunlinks+0x35e/0x3a0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;808707e6&gt;] xlog_recover_finish+0xa6/0xe0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;8087625c&gt;] xfs_mountfs+0xc1c/0xe40<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;808876d2&gt;] kmem_alloc+0x52/0x100<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;808877ec&gt;] kmem_zalloc+0xc/0x40<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;808584c0&gt;] xfs_fstrm_free_func+0x0/0xc0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;8087f30a&gt;] xfs_mount+0x3ca/0x420<o:p></o:p></span></p><p class=MsoNormal><span lan
 g=EN-US>
_fill_super+0x58/0x240<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80774d20&gt;] path_lookup+0x0/0x20<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;808ba576&gt;] snprintf+0x16/0x40<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80774d20&gt;] path_lookup+0x0/0x20<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;807aab2e&gt;] disk_name+0x8e/0xc0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80794f54&gt;] sb_set_blocksize+0x14/0x40<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;8076ae32&gt;] get_sb_bdev+0x152/0x1e0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;807644a8&gt;] __kmalloc+0x48/0x100<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80892250&gt;] xfs_fs_get_sb+0x10/0x20<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;808932c0&gt;] xfs_fs_fill_super+0x0/0x240<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;8076a596&gt;] vf
 s_kern_m
</span></p><p class=MsoNormal><span lang=EN-US>[&lt;8076a66e&gt;] do_kern_mount+0x2e/0xe0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80783390&gt;] do_mount+0x130/0x6c0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80770900&gt;] path_release+0x0/0x40<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80712b3a&gt;] enqueue_entity+0x9a/0x2a0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80a45f16&gt;] __down_read+0x136/0x180<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80712a58&gt;] dequeue_entity+0x58/0xa0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80712d66&gt;] task_tick_fair+0x26/0x80<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;8070faa0&gt;] do_page_fault+0x60/0x380<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;808b852e&gt;] __up_read+0x4e/0xe0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;8070e9ce&gt;] fixup_exception+0xe/0x40<o:p
 ></o:p><
mal><span lang=EN-US>[&lt;8070fb30&gt;] do_page_fault+0xf0/0x380<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80722b3a&gt;] run_timer_softirq+0x1a/0x200<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;808bca60&gt;] debug_smp_processor_id+0x0/0xc0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80722c72&gt;] run_timer_softirq+0x152/0x200<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;8071e8e4&gt;] __do_softirq+0x64/0x100<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;808bca60&gt;] debug_smp_processor_id+0x0/0xc0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;8071e8f6&gt;] __do_softirq+0x76/0x100<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;8071e9e4&gt;] do_softirq+0x64/0x80<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80749020&gt;] get_page_from_freelist+0x160/0x3e0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80748fc2&gt;] get_page_from_
 freelist
span></p><p class=MsoNormal><span lang=EN-US>[&lt;8074980e&gt;] __alloc_pages+0x6e/0x2e0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80749aa0&gt;] __get_free_pages+0x20/0x60<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80783986&gt;] sys_mount+0x66/0xe0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80749740&gt;] free_pages+0x0/0x60<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;807078f8&gt;] syscall_call+0xa/0xe<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80783920&gt;] sys_mount+0x0/0xe0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><span lang=EN-US>Process: mount (pid: 998, stack limit = 81020001)<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>Stack: (0x810218d0 to 0x81022000)<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>18c0:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
 &nbsp;&n
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 813330e8 81332ee8 81332ce8 81332ae8 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>18e0: 810218e0 810218e0 8071e8e4 81333398 813320c0 808bca60 00000009 ffffff0f <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>1900: 00000000 8133210c 8071e9e4 00000000 8a7fc7c8 000000f1 8a56ed40 00000000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>1920: 8133c374 000000f0 8071ee78 80712ee0 807028f6 000013e0 80707746 00000000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>1940: 807028c0 400081f1 8ac02f68 e9008920 2dd868f6 fffffff0 8ada8798 fffffff4 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>1960: 1ffcb4f9 00000040 8ada8790 810219e4 00000000 8a56ed40 000000f1 8a7fc7c8 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>1980: 00000000 810219a8 808b2820 8083315e 40008100 004d2290 00000000 025029d4 <o:p></o:p></span></p><p class=MsoNormal><sp
 an lang=
053e 8ada8006 81021a14 81021a20 8a56e8c0 8088c8aa 8ada8000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>19c0: 000000f1 dad17f00 46000000 dad17f00 46000000 186a8600 bc000000 8a7fc744 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>19e0: 0000a12b 00000001 808332fe 81021a24 8a7fc830 8a7fc7c8 00000000 8a7fc7c8 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>1a00: 810219e8 8a7fc7c8 81021a1c 81021a24 81021a60 186a8600 bc000000 00000000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>1a20: ffffffff 81021a34 8082ebf2 83ac4c00 81021a34 00866a18 8a56e5c0 8a7fc7c8 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>1a40: 82db651c 00000000 00000002 8a7fc84c 008667e4 00000001 000000bc 008667e4 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>1a60: 00000001 00000000 00000000 000002e4 00866b90 808305e2 8083ada0 8a698d8c <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>1a80: 000000bc 000001cc 81021a9c 82db651c 00000000 000000
 bc 00000
/span></p><p class=MsoNormal><span lang=EN-US>1aa0: 83ac4c00 8a56e5c0 8acf6f78 00000000 00000002 00866a18 00000000 00000000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>1ac0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>1ae0: 00000000 00000000 00000000 8083af04 81021b54 00000000 00000000 82db651c <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>1b00: 83d3e4c8 00000002 80861fd2 81021ba0 00000000 00000000 82dbbc60 82db6790 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>1b20: 81021b54 00000000 83ac4dfc 82dbbd1c 83ac4efc 8087bf40 8087bfc0 00000000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>1b40: 00000000 80000000 00000000 80000001 00000000 83d3e4c8 00000001 00000000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>1b60: 00000001 00000000 ffffffff 808851ea 83ac4c00 00000001 00000000 81021b68 <o:p></o:p></span></p><p class=MsoNormal><span lan
 g=EN-US>
2dbbc60 00000000 00000001 81021bbc 81021c1c 00000000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>1ba0: 82db651c 81021c18 80892d34 00000000 40000000 00000000 00000002 8113adb4 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>1bc0: 00000000 8113ace0 8077f34a 8113acf8 8077f4f2 80712ee0 00000000 8113acf8 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>1be0: 8087017e ffffffff 00000000 8ada6ee0 83ac4d78 83ac4d76 83ac4d3c 83ac4ea6 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>1c00: 8a64e2a0 83ac4c40 83ac4c00 00000002 0000002e 00000000 82dbbc60 8ad4ae00 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>1c20: 8ada6ee0 808707e6 81021c90 83ac4c40 8113ae20 8a64e2a0 8a64e2dc 00000000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>1c40: 8a64e260 8087625c 83ac4c00 00000000 00000000 83ac4ebc 00000002 00000000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>1c60: 00000000 00000000 00000002 00000000 00000040 835a3380 250
 29d38 00
</p><p class=MsoNormal><span lang=EN-US>1c80: 00000000 00000000 00000001 00000000 808876d2 00000000 000002d0 00000058 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>1ca0: 00000001 808877ec 816f01e0 808584c0 1e3c3c28 d591ef53 83ac4f54 00000058 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>1cc0: 00000000 00000000 82dbbde0 8a56eb00 8087f30a 816f01e0 835a3380 8113b000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>1ce0: 81021cc0 83ac4c00 00000000 00000000 00000000 00000040 00000000 00000000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>1d00: 80893318 80774d20 8a99a000 8113b000 835a3380 83d68200 8a99a000 00000001 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>1d20: 00000002 81021d93 0000000a ffffffff ffffffff 00000002 00000020 81021d90 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>1d40: 8a67096c ffffffff 80ab6bdc 808ba576 80774d20 8a99a000 816f0220 81021d90 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-U
 S>1d60: 
0 81021d74 807aab2e 80794f54 8076ae32 816f0220 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>1d80: 83d68200 816f01f8 00000001 83d68200 33626473 00000000 00000001 00000000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>1da0: 00000080 835b845c 807644a8 00000000 80892250 83832000 8a99a000 00008000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>1dc0: 8addf000 816f58a0 80b2b2e4 808932c0 816f58a0 8076a596 816f58a0 8076a66e <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>1de0: ffffffed 80b2b2e4 8a99a000 8addf000 00008000 80783390 00008000 00000000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>1e00: 83832000 80770900 00000000 00000000 80712b3a 81021e30 835b8160 ffffffff <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>1e20: ff485b19 8132d3a8 80a45f16 83c7cd94 835b8160 80712a58 8132d758 80712d66 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>1e40: 8070faa0 808b852e 8070e9ce 81021f44 8070fb30 835b8160 00c76668 
 81020000
 class=MsoNormal><span lang=EN-US>1e60: 00000000 00000002 00000050 80722b3a 81333398 813320c0 808bca60 0000000a <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>1e80: ffffff0f 80722c72 81333398 813330e8 81332ee8 81332ce8 81332ae8 81021e9c <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>1ea0: 81021e9c 8071e8e4 81333398 813320c0 808bca60 0000000a 8071e8f6 00000000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>1ec0: 8133210c 8071e9e4 00008000 80749020 80748fc2 00000000 00000000 80b267bc <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>1ee0: 00000044 00000000 000200d0 80b26944 00000000 00000000 8074980e 80b26940 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>1f00: 80d330b8 816f57a0 835b8160 8a667000 81021f84 00000001 00000001 00000000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>1f20: 00000080 835b845c 00000010 00000eb1 814a3340 8addf000 000200d0 00008000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>1f40
 : 80749a
8000 7b850eb1 8a667000 80783986 00008000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>1f60: 00402c9c 00008000 80749740 8a667000 81021f48 00000000 8a99a000 8addf000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>1f80: 83832000 8a99a000 807078f8 00000514 00000000 00000021 00000054 80783920 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>1fa0: 004d22c0 0044b4b4 ffffffff 00000015 7b850eb1 7b850ebb 004d3518 00008000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>1fc0: 00008000 7b850aa4 004d2298 004d22c0 004736cc 00402c9c 00008000 7b8509e0 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>1fe0: 0044b4bc 00423268 00008000 004d2290 00000000 0000004e 00000054 00000160 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>Kernel panic - not syncing: Fatal exception in interrupt<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>================================================================================<o:p></o:p></span
 ></p><p 
g=EN-US><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><span lang=EN-US>================================================================================<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US># xfs_repair -n /dev/sdb3<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>Phase 1 - find and verify superblock...<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>Phase 2 - using internal log<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - scan filesystem freespace and inode maps...<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,518687-518687) multiply claimed by bno space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>bno freespace btree block claimed (state 2), agno 2, bno 41259, suspect 0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>bno freespace btree block claimed (state 2), agno 2, bno 41348, suspect 0<o:p></o:p></span></p><p class=MsoNor
 mal><spa
687-518687) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>cnt freespace btree block claimed (state 2), agno 2, bno 38694, suspect 0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9883756-9883756) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9888268-9888268) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9889396-9889396) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9890900-9890900) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9891276-9891276) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9891652-9891652) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p cla
 ss=MsoNo
ck (2,9892216-9892216) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9892592-9892592) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9893908-9893908) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9894284-9894284) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9895036-9895036) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9895600-9895600) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9895976-9895976) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9896540-9896540) multiply claimed by cnt space tree, state - 2<o:p></o:p></span><
 /p><p cl
EN-US>block (2,9897480-9897480) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9898420-9898420) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9899360-9899360) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9900488-9900488) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9905940-9905940) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9906316-9906316) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9908572-9908572) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9908948-9908948) multiply claimed by cnt space tree, state - 2<o:p></o:p
 ></span>
pan lang=EN-US>block (2,9913272-9913272) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9916656-9916656) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9922108-9922108) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9923048-9923048) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9924928-9924928) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9925868-9925868) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9926244-9926244) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9928500-9928500) multiply claimed by cnt space tree, state - 2<
 o:p></o:
Normal><span lang=EN-US>block (2,9929628-9929628) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9931320-9931320) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9931696-9931696) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9933012-9933012) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9936584-9936584) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9937524-9937524) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9939592-9939592) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9941472-9941472) multiply claimed by cnt space tree, s
 tate - 2
class=MsoNormal><span lang=EN-US>block (2,9943164-9943164) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9943728-9943728) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9944104-9944104) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9946360-9946360) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9946736-9946736) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9947676-9947676) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9948052-9948052) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9948241-9948241) multiply claimed by cnt spac
 e tree, 
n></p><p class=MsoNormal><span lang=EN-US>block (2,9949932-9949932) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9951624-9951624) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9954820-9954820) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9955760-9955760) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9957264-9957264) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9957640-9957640) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9959144-9959144) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9962904-9962904) multiply claimed by
  cnt spa
o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9964220-9964220) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9966664-9966664) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9967040-9967040) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9968168-9968168) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9968544-9968544) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9969672-9969672) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9971176-9971176) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9973620-9973620) multiply c
 laimed b
 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9973996-9973996) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9977192-9977192) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9978508-9978508) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9978884-9978884) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9983961-9983961) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,9984337-9984337) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>agf_freeblks 8477471, counted 8544090 in ag 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>agi unlinked bucket 46 is 608366 in ag 2 (inode=10743
 50190)<o
ass=MsoNormal><span lang=EN-US>sb_ifree 193, counted 197<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>sb_fdblocks 65043106, counted 65276224<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - found root inode chunk<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>Phase 3 - for each AG...<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - scan (but don't clear) agi unlinked lists...<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - process known inodes and perform inode discovery...<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno = 0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno = 1<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno 
 = 2<o:p>
=MsoNormal><span lang=EN-US>data fork in ino 1074348352 claims free block 67147515<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>29560000: Badness in key lookup (length)<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>bp=(bno 310768336, len 16384 bytes) key=(bno 310768336, len 8192 bytes)<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75847242<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75847806<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75848558<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75849122<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75849686<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75851002<o:p></o:
 p></span
span lang=EN-US>data fork in ino 1074350209 claims free block 75852694<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75853446<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75854198<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75854762<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75855514<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75856078<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75856830<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75858146<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75859086<o:p></o:p></span></p><p
  class=M
>data fork in ino 1074350209 claims free block 75859650<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75860402<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75861530<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75862094<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75862658<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75863222<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75863974<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75864350<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75864914<o:p></o:p></span></p><p class=MsoNorma
 l><span 
no 1074350209 claims free block 75865478<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75866042<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75866794<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75867922<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75868862<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75869426<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75869802<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75870366<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75870930<o:p></o:p></span></p><p class=MsoNormal><span lang=EN
 -US>data
laims free block 75871494<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75872246<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75873186<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75873750<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75874126<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75875066<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75875630<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75876194<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75876570<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork i
 n ino 10
k 75878074<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75878638<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75879014<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75880246<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75880810<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75881374<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75882502<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75882878<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75883442<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 107435020
 9 claims
</o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75884759<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75885135<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75885699<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75886075<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75886827<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75888144<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75888896<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75889648<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free b
 lock 758
p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75890588<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75891152<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75891716<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75892280<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75892844<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75893220<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 75893784<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350209 claims free block 76120044<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76543991<o
 :p></o:p
ormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76546060<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76546436<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76549820<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76550196<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76552828<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76554896<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76559784<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76580652<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76581216<o:p></o:p></span
 ></p><p 
g=EN-US>data fork in ino 1074350218 claims free block 76581780<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76584224<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76587044<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76587420<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76588360<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76590804<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76591180<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76593436<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76593812<o:p></o:p></span></p><p class=M
 soNormal
rk in ino 1074350218 claims free block 76595128<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76596632<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76597948<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76599828<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76601144<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76601520<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76604152<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76605844<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76606784<o:p></o:p></span></p><p class=MsoNormal><span 
 lang=EN-
50218 claims free block 76608852<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76609792<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76610732<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76611860<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76612988<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76615996<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76617688<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76619568<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76621824<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data
  fork in
ee block 76622600<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76626172<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76627301<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76632753<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76634069<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76638205<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76639897<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76640273<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76647041<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 10
 74350218
17<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76648733<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76649109<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76650801<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76651177<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76652869<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76653245<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76653809<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76658509<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims
  free bl
span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76662645<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76663021<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76666781<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76668097<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76675054<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76676934<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76682574<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76686334<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 766
 89342<o:
ss=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76691786<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76697802<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76705134<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76707202<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76709646<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76710022<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76710398<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>data fork in ino 1074350218 claims free block 76715286<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno = 3<o:p></o:p>
 </span><
an lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - process newly discovered inodes...<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>Phase 4 - check for duplicate blocks...<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - setting up duplicate extent list...<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - check for inodes claiming duplicate blocks...<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno = 0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno = 1<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno = 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno = 3<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>No modify fl
 ag set, 
p></span></p><p class=MsoNormal><span lang=EN-US>Phase 6 - check inode connectivity...<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - traversing filesystem ...<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - traversal finished ...<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - moving disconnected inodes to lost+found ...<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>disconnected inode 1074350190, would move to lost+found<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>Phase 7 - verify link counts...<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>would have reset inode 1074350190 nlinks from 0 to 1<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>No modify flag set, skipping filesystem flush and exiting.<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>==================
 ========
=============================<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><span lang=EN-US>================================================================================<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US># xfs_logprint -t /dev/sdb3<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>xfs_logprint:<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp; data device: 0x813<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp; log device: 0x813 daddr: 310464192 length: 303184<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp; log tail: 273322 head: 273412 state: &lt;DIRTY&gt;<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><span lang=EN-US>LOG R
 EC AT LS
x7, 0x42baa)<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>============================================================================<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>TRANS: tid:0x83f862b0&nbsp; type:INACTIVE&nbsp; #items:3&nbsp; trans:0x0&nbsp; q:0x434c08<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>INO: cnt:2 total:2 a:0x42c6f8 len:52 a:0x42c750 len:96 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;INODE: #regs:2&nbsp;&nbsp; ino:0x4009486e&nbsp; flags:0x1&nbsp;&nbsp; dsize:0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; CORE inode:<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>BUF: cnt:2 total:2 a:0x42c7b8 len:28 a:0x42ca28 len:128 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;BUF:&nbsp; #regs:2&nbsp;&nbsp; start blkno:0x160fa990&nbsp;&nbsp; len
 :8&nbsp;
<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>flags:0x0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; BUF DATA<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>EFI: cnt:1 total:1 a:0x42cab0 len:40 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;EFI:&nbsp; #regs:1&nbsp;&nbsp;&nbsp; num_extents:2&nbsp; id:0xffffffff81dd5c88<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (s: 0x6129273, l: 18236) (s: 0x6137a4d, l: 3388) <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>============================================================================<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>TRANS: tid:0x83f862b0&nbsp; type:INACTIVE&nbsp; #items:7&nbsp; trans:0x0&nbsp; q:0x42cae0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>EFD: cnt:1 total:1 a:0x42cab0 len:40 <o:p></o:
 p></span
span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;EFD:&nbsp; #regs: 1&nbsp;&nbsp;&nbsp; num_extents: 2&nbsp; id: 0xffffffff81dd5c88<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>BUF: cnt:2 total:2 a:0x42ca08 len:24 a:0x42ca28 len:128 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;BUF:&nbsp; #regs:2&nbsp;&nbsp; start blkno:0x1bc1f5f1&nbsp;&nbsp; len:1&nbsp;&nbsp; bmap size:1&nbsp; <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>flags:0x0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;AGF Buffer: (XAGF)<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>BUF: cnt:3 total:3 a:0x42c730 len:28 a:0x42cb40 len:128 a:0x434c28 len:512 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;BUF:&nbsp; #regs:3&nbsp;&nbsp; start blkno:0x1c1bb470&nbsp;&nbsp; len:8&nbsp;&nbsp; bmap size:2&nb
 sp; <o:p
s=MsoNormal><span lang=EN-US>flags:0x0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; BUF DATA<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; BUF DATA<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>BUF: cnt:3 total:3 a:0x42cb10 len:28 a:0x434e30 len:128 a:0x434eb8 len:128 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;BUF:&nbsp; #regs:3&nbsp;&nbsp; start blkno:0x1bcf8b40&nbsp;&nbsp; len:8&nbsp;&nbsp; bmap size:2&nbsp; <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>flags:0x0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; BUF DATA<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; BUF DATA<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>BUF: cnt:2 total:2 a:0x42c770 len:28 a:0x434f60 le
 n:2304 <
lass=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;BUF:&nbsp; #regs:2&nbsp;&nbsp; start blkno:0x1bcf8b50&nbsp;&nbsp; len:8&nbsp;&nbsp; bmap size:2&nbsp; <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>flags:0x0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; BUF DATA<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>INO: cnt:2 total:2 a:0x435868 len:52 a:0x4358e0 len:96 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;INODE: #regs:2&nbsp;&nbsp; ino:0x4009486e&nbsp; flags:0x1&nbsp;&nbsp; dsize:0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; CORE inode:<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>BUF: cnt:2 total:2 a:0x435948 len:24 a:0x4359a8 len:128 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;BUF:
 &nbsp; #
blkno:0x0&nbsp;&nbsp; len:1&nbsp;&nbsp; bmap size:1&nbsp;&nbsp; flags:0x0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; SUPER Block Buffer:<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>============================================================================<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>TRANS: tid:0x83f862b0&nbsp; type:INACTIVE&nbsp; #items:3&nbsp; trans:0x0&nbsp; q:0x435968<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>INO: cnt:2 total:2 a:0x435868 len:52 a:0x4358e0 len:96 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;INODE: #regs:2&nbsp;&nbsp; ino:0x4009486e&nbsp; flags:0x1&nbsp;&nbsp; dsize:0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; CORE inode:<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>BUF: cnt:2 total:2 a:0x435948 len:28 a:0x42ca28 le
 n:128 <o
ass=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;BUF:&nbsp; #regs:2&nbsp;&nbsp; start blkno:0x160fa990&nbsp;&nbsp; len:8&nbsp;&nbsp; bmap size:2 &nbsp;<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>flags:0x0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; BUF DATA<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>EFI: cnt:1 total:1 a:0x42cab0 len:40 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;EFI:&nbsp; #regs:1&nbsp;&nbsp;&nbsp; num_extents:2&nbsp; id:0xffffffff81dd5d8c<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (s: 0x610546a, l: 188) (s: 0x61055e2, l: 22372) <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>============================================================================<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>TRANS: tid:0x
 83f862b0
; #items:9&nbsp; trans:0x0&nbsp; q:0x434f40<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>EFD: cnt:1 total:1 a:0x42cab0 len:40 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;EFD:&nbsp; #regs: 1&nbsp;&nbsp;&nbsp; num_extents: 2&nbsp; id: 0xffffffff81dd5d8c<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>BUF: cnt:2 total:2 a:0x4358a0 len:24 a:0x42ca28 len:128 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;BUF:&nbsp; #regs:2&nbsp;&nbsp; start blkno:0x1bc1f5f1&nbsp;&nbsp; len:1&nbsp;&nbsp; bmap size:1&nbsp; <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>flags:0x0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; AGF Buffer: (XAGF)<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>BUF: cnt:3 total:3 a:0x435968 len:28 a:0x434c28 len:128 a:0x434f60 len:896 <o:p></o:p></span></p><p
  class=M
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;BUF:&nbsp; #regs:3&nbsp;&nbsp; start blkno:0x1c1bb470&nbsp;&nbsp; len:8&nbsp;&nbsp; bmap size:2&nbsp; <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>flags:0x0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; BUF DATA<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; BUF DATA<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>BUF: cnt:2 total:2 a:0x434c08 len:28 a:0x4359a8 len:2304 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;BUF:&nbsp; #regs:2&nbsp;&nbsp; start blkno:0x1bcf8b50&nbsp;&nbsp; len:8&nbsp;&nbsp; bmap size:2&nbsp; <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>flags:0x0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; BUF DATA<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-
 US>BUF: 
len:28 a:0x42c6f8 len:128 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;BUF:&nbsp; #regs:2&nbsp;&nbsp; start blkno:0x1c23cb48&nbsp;&nbsp; len:8&nbsp;&nbsp; bmap size:2&nbsp; <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>flags:0x0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; BUF DATA<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>BUF: cnt:2 total:2 a:0x435900 len:28 a:0x4362b0 len:4096 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;BUF:&nbsp; #regs:2&nbsp;&nbsp; start blkno:0x1bcf8b40&nbsp;&nbsp; len:8&nbsp;&nbsp; bmap size:2&nbsp; <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>flags:0x0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; BUF DATA<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>BUF: cnt:3 total:3 a:0x
 42cb30 l
a:0x434d38 len:128 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;BUF:&nbsp; #regs:3&nbsp;&nbsp; start blkno:0x1bc1f620&nbsp;&nbsp; len:8&nbsp;&nbsp; bmap size:2&nbsp; <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>flags:0x0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; BUF DATA<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; BUF DATA<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>INO: cnt:2 total:2 a:0x434dc0 len:52 a:0x42cb98 len:96 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;INODE: #regs:2&nbsp;&nbsp; ino:0x4009486e&nbsp; flags:0x1&nbsp;&nbsp; dsize:0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; CORE inode:<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>BUF: cnt:2 t
 otal:2 a
98 len:128 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;BUF:&nbsp; #regs:2&nbsp;&nbsp; start blkno:0x0&nbsp;&nbsp; len:1&nbsp;&nbsp; bmap size:1&nbsp;&nbsp; flags:0x0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; SUPER Block Buffer:<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>============================================================================<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>TRANS: tid:0x83f862b0&nbsp; type:INACTIVE&nbsp; #items:3&nbsp; trans:0x0&nbsp; q:0x434e58<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>INO: cnt:2 total:2 a:0x434dc0 len:52 a:0x42cb98 len:96 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;INODE: #regs:2&nbsp;&nbsp; ino:0x4009486e&nbsp; flags:0x1&nbsp;&nbsp; dsize:0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&n
 bsp;&nbs
; CORE inode:<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>BUF: cnt:2 total:2 a:0x434e38 len:28 a:0x42ca28 len:128 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;BUF:&nbsp; #regs:2&nbsp;&nbsp; start blkno:0x160fa990&nbsp;&nbsp; len:8&nbsp;&nbsp; bmap size:2&nbsp; <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>flags:0x0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; BUF DATA<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>EFI: cnt:1 total:1 a:0x42cab0 len:40 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;EFI:&nbsp; #regs:1&nbsp;&nbsp;&nbsp; num_extents:2&nbsp; id:0xffffffff81dd5e90<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(s: 0x610517a, l: 188) (s: 0x61052f2, l: 188) <o:p></o:p></span></p><p class=MsoNormal><span lang=E
 N-US>===
================================================<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>TRANS: tid:0x83f862b0&nbsp; type:INACTIVE&nbsp; #items:6&nbsp; trans:0x0&nbsp; q:0x42cb50<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>EFD: cnt:1 total:1 a:0x42cab0 len:40 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;EFD:&nbsp; #regs: 1&nbsp;&nbsp;&nbsp; num_extents: 2&nbsp; id: 0xffffffff81dd5e90<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>BUF: cnt:2 total:2 a:0x434df8 len:24 a:0x42ca28 len:128 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;BUF:&nbsp; #regs:2&nbsp;&nbsp; start blkno:0x1bc1f5f1&nbsp;&nbsp; len:1&nbsp;&nbsp; bmap size:1&nbsp; <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>flags:0x0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; AGF Buffer: (XAGF)<o:p>
 </o:p></
al><span lang=EN-US>BUF: cnt:3 total:3 a:0x434e58 len:28 a:0x434e98 len:128 a:0x434f20 len:896 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;BUF:&nbsp; #regs:3&nbsp;&nbsp; start blkno:0x1c1bb470&nbsp;&nbsp; len:8&nbsp;&nbsp; bmap size:2&nbsp; <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>flags:0x0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; BUF DATA<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; BUF DATA<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>BUF: cnt:2 total:2 a:0x42ca08 len:28 a:0x4352a8 len:2304 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;BUF:&nbsp; #regs:2&nbsp;&nbsp; start blkno:0x1bcf8b50&nbsp;&nbsp; len:8&nbsp;&nbsp; bmap size:2&nbsp; <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>flags:0x0<o:p></o:p><
 /span></
n lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; BUF DATA<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>INO: cnt:2 total:2 a:0x42cb98 len:52 a:0x42c6f8 len:96 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;INODE: #regs:2&nbsp;&nbsp; ino:0x4009486e&nbsp; flags:0x1&nbsp;&nbsp; dsize:0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; CORE inode:<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>BUF: cnt:2 total:2 a:0x42c760 len:24 a:0x434c08 len:128 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;BUF:&nbsp; #regs:2&nbsp;&nbsp; start blkno:0x0&nbsp;&nbsp; len:1&nbsp;&nbsp; bmap size:1&nbsp;&nbsp; flags:0x0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; SUPER Block Buffer:<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>==========
 ========
=================================<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>TRANS: tid:0x83f862b0&nbsp; type:INACTIVE&nbsp; #items:3&nbsp; trans:0x0&nbsp; q:0x42c780<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>INO: cnt:2 total:2 a:0x42cb98 len:52 a:0x42c6f8 len:96 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;INODE: #regs:2&nbsp;&nbsp; ino:0x4009486e&nbsp; flags:0x1&nbsp;&nbsp; dsize:0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; CORE inode:<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>BUF: cnt:2 total:2 a:0x42c760 len:28 a:0x42ca28 len:128 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;BUF:&nbsp; #regs:2&nbsp;&nbsp; start blkno:0x160fa990&nbsp;&nbsp; len:8&nbsp;&nbsp; bmap size:2 &nbsp;<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>flags:0x0<o:p></o:p></
 span></p
 lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; BUF DATA<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>EFI: cnt:1 total:1 a:0x42cab0 len:40 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;EFI:&nbsp; #regs:1&nbsp;&nbsp;&nbsp; num_extents:2&nbsp; id:0xffffffff81dd597c<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (s: 0x48670b4, l: 376) (s: 0x6104f46, l: 188) <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><span lang=EN-US>LOG REC AT LSN cycle 7 block 273386 (0x7, 0x42bea)<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>============================================================================<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>TRANS: tid:0x82a500ac&nbsp; type:&nbsp; #items:12&nbsp; trans:0x0&nbsp; q:0x437e68<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-
 US>EFD: 
len:40 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;EFD:&nbsp; #regs: 1&nbsp;&nbsp;&nbsp; num_extents: 2&nbsp; id: 0xffffffff81dd597c<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>BUF: cnt:2 total:2 a:0x437eb8 len:24 a:0x437f18 len:128 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;BUF:&nbsp; #regs:2&nbsp;&nbsp; start blkno:0x12814ea1&nbsp;&nbsp; len:1&nbsp;&nbsp; bmap size:1&nbsp; <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>flags:0x0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; AGF Buffer: (XAGF)<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>BUF: cnt:3 total:3 a:0x437fa0 len:28 a:0x438008 len:128 a:0x438090 len:896 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;BUF:&nbsp; #regs:3&nbsp;&nbsp; start blkno:0x1bcf
 8b50&nbs
; bmap size:2&nbsp; <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>flags:0x0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; BUF DATA<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; BUF DATA<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>BUF: cnt:2 total:2 a:0x438418 len:28 a:0x438478 len:128 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;BUF:&nbsp; #regs:2&nbsp;&nbsp; start blkno:0x1285f888&nbsp;&nbsp; len:8&nbsp;&nbsp; bmap size:2&nbsp; <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>flags:0x0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; BUF DATA<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>BUF: cnt:2 total:2 a:0x438500 len:28 a:0x438560 len:4096 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&n
 bsp;&nbs
;BUF:&nbsp; #regs:2&nbsp;&nbsp; start blkno:0x128657f8&nbsp;&nbsp; len:8&nbsp;&nbsp; bmap size:2&nbsp; <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>flags:0x0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; BUF DATA<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>BUF: cnt:3 total:3 a:0x439568 len:28 a:0x4395d0 len:128 a:0x439658 len:128 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;BUF:&nbsp; #regs:3&nbsp;&nbsp; start blkno:0x12869e58&nbsp;&nbsp; len:8&nbsp;&nbsp; bmap size:2&nbsp; <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>flags:0x0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; BUF DATA<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; BUF DATA<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>BUF: cnt:2 total:2 a:0x4396
 e0 len:2
></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;BUF:&nbsp; #regs:2&nbsp;&nbsp; start blkno:0x12ac72b0&nbsp;&nbsp; len:8&nbsp;&nbsp; bmap size:2&nbsp; <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>flags:0x0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; BUF DATA<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>BUF: cnt:3 total:3 a:0x4397c8 len:28 a:0x439830 len:128 a:0x4398b8 len:1792 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;BUF:&nbsp; #regs:3&nbsp;&nbsp; start blkno:0x12e15e58&nbsp;&nbsp; len:8&nbsp;&nbsp; bmap size:2&nbsp; <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>flags:0x0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; BUF DATA<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs
 p;&nbsp;
n></p><p class=MsoNormal><span lang=EN-US>BUF: cnt:2 total:2 a:0x439fc0 len:28 a:0x43a020 len:2816 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;BUF:&nbsp; #regs:2&nbsp;&nbsp; start blkno:0x12f68de0&nbsp;&nbsp; len:8&nbsp;&nbsp; bmap size:2&nbsp; <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>flags:0x0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; BUF DATA<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>BUF: cnt:2 total:2 a:0x43ab28 len:24 a:0x43ab88 len:128 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;BUF:&nbsp; #regs:2&nbsp;&nbsp; start blkno:0x1bc1f5f1&nbsp;&nbsp; len:1&nbsp;&nbsp; bmap size:1&nbsp; <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>flags:0x0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; AGF Buffer: (XAGF
 )<o:p></
soNormal><span lang=EN-US>BUF: cnt:2 total:2 a:0x43ac10 len:24 a:0x43ac70 len:128 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;BUF:&nbsp; #regs:2&nbsp;&nbsp; start blkno:0x0&nbsp;&nbsp; len:1&nbsp;&nbsp; bmap size:1&nbsp;&nbsp; flags:0x0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; SUPER Block Buffer:<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>BUF: cnt:3 total:3 a:0x43acf8 len:28 a:0x43ad60 len:128 a:0x43ade8 len:896 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;BUF:&nbsp; #regs:3&nbsp;&nbsp; start blkno:0x1c1bb470&nbsp;&nbsp; len:8&nbsp;&nbsp; bmap size:2&nbsp; <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>flags:0x0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; BUF DATA<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-
 US>&nbsp
&nbsp;&nbsp; BUF DATA<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>================================================================================<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><span lang=EN-US>Regrads,<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>Ryan. <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><span lang=EN-US>Hi All,<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><span lang=EN-US>I got different behavior when I tried to mount the image which was created by<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>the xfs_mdrestore. <o:p></o:p></span></p><p class=MsoNormal
 ><span l
p></span></p><p class=MsoNormal><span lang=EN-US>I made the image with xfs_metadump and xfs_mdrestore and tried to mount it.<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><span lang=EN-US>please see the log in the below.<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><span lang=EN-US>================================================================================<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US># mount -o loop -t xfs ./HDD7.img /mnt/hdd<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>Filesystem &quot;loop0&quot;: Disabling barriers, not supported by the underlying device<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>XFS mounting filesystem loop0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>Starting XFS recovery on filesystem: loop0 (logdev: internal)<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>
 Filesyst
 internal error xfs_btree_check_sblock at line 334 of<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>file fs/xfs/xfs_btree.c.&nbsp; Caller 0x8083159e<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>Stack: (0x8aeb5940 to 0x8aeb6000)<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5940: 808496cc 8223c7e8 82bc3000 0000014e 8083159e 8083159e 00000045 833da000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5960: 811355c0 8223c7e8 82bc3000 8aeb2400 00000000 8113563c 811355c0 8aeb2400 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5980: 811352c0 81135500 80833104 8aeb5a24 8223c7e8 00000045 811355c0 00000000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>59a0: 8aeb59e4 00000000 833da006 8aeb5a14 8aeb5a20 81337764 00000000 833da000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>59c0: 8223c7e8 00000000 00000000 12cbf008 00000000 e4678600 bc000000 00000000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>59
 e0: ffff
eb5a24 8223c850 8223c7e8 00000000 8223c86c <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5a00: 8aeb59e8 8223c7e8 8aeb5a1c 8aeb5a24 8aeb5a60 e4678600 bc000000 00000000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5a20: ffffffff 811355c0 8082ec3e 8aeb2400 8aeb5a34 008667e4 81135200 8223c86c <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5a40: 82991094 00000000 00000002 8223c7e8 008667e4 000000bc 00000001 0085f3db <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5a60: 00000000 00000000 00000000 000002e4 00866b90 808305e2 8083ada0 82f8ad8c <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5a80: 000000bc 000001cc 8aeb5a9c 82991094 00000000 000000bc 00000000 82991094 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5aa0: 8aeb2400 81135200 8ad557d8 00000000 00000002 008667e4 00000000 00000000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5ac0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 0000
 0000 <o:
ss=MsoNormal><span lang=EN-US>5ae0: 00000000 00000000 00000000 8083af04 8aeb5b54 82f8b4c8 00000000 82991094 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5b00: 82f8b4bc 00000002 80861fd2 8aeb5ba0 00000000 00000000 8afe8360 82991a64 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5b20: 8aeb5b54 00000000 8aeb25fc 8afe841c 8aeb26fc 8087bf40 8087bfc0 00000000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5b40: 00000000 80000000 00000000 80000001 00000000 82f8b4bc 00000002 00000000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5b60: 00000001 00000000 ffffffff 808851ea 8aeb2400 00000001 00000000 8aeb5b68 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5b80: 8085e960 00000000 8afe8360 00000000 00000001 8aeb5bbc 8aeb5c1c 00000000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5ba0: 82991094 8aeb5c18 80892d34 00000000 40000000 00000000 00000002 83d303b4 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5bc0: 00
 000000 8
 8077f4f2 80712ee0 00000000 83d302f8 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5be0: 8087017e ffffffff 00000000 828f1be0 8aeb2578 8aeb2576 8aeb253c 8aeb26a6 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5c00: 8a985e20 8aeb2440 8aeb2400 00000002 0000002e 00000000 8afe8360 822b8e00 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5c20: 828f1be0 808707e6 8aeb5c90 8aeb2440 83d301a0 8a985e20 8a985e5c 00000000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5c40: 8a985de0 8087625c 8aeb2400 00000000 00000000 8aeb26bc 00000002 00000000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5c60: 00000000 00000000 00000002 00000000 00000040 83e814a0 25029d38 00000000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5c80: 00000000 00000000 00000001 00000000 808876d2 00000000 000002d0 00000058 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5ca0: 00000001 808877ec 816f0380 808584c0 1e3c3c28 d591ef53 8aeb2754 00000058 <
 o:p></o:
Normal><span lang=EN-US>5cc0: 00000000 00000000 8afe81e0 81135800 8087f30a 816f0380 83e814a0 83817800 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5ce0: 8aeb5cc0 8aeb2400 00000000 00000000 00000000 00000040 00000000 00000000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5d00: 80893318 80774d20 00000000 83817800 83e814a0 83ad0600 00000000 00000001 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5d20: 00000000 00000000 00000000 00000000 00000000 00000000 80a45d74 00000020 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5d40: 8aeb5d90 8a5ee9cc ffffffff 80ad8926 808ba576 80774d20 00000000 816f03c0 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5d60: 8aeb5d90 816f0398 00000000 8a5ee9c0 8aeb5d78 80794f54 8076ae32 816f03c0 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5d80: 83ad0600 816f0398 00000001 83ad0600 706f6f6c 80760030 80774d20 8317d000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5da0: 00000000
  000080d
250 8317d000 00000000 00008000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5dc0: 82e0b000 816f5920 80b2b2e4 808932c0 816f5920 8076a596 816f5920 8076a66e <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5de0: ffffffed 80b2b2e4 00000000 82e0b000 00008000 80783390 00008000 00000000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5e00: 8317d000 80770900 00000000 00000000 ffffffe7 807539a6 8295534c 80753a6c <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5e20: 81334c90 00000000 83d6e470 83cd4c20 7b847848 816f0380 8070fad2 83cd4c14 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5e40: 8aeb5f04 808b852e 83cd4c14 8070faf8 83d6e470 8a33ea40 8aeb4000 83cd4be0 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5e60: 00000000 814979c0 8a5ee9c0 807518e2 8a6c9004 00447cb4 00000000 00000000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5e80: 00000000 00000047 00447000 814979c0 00000200 80753680 81334c90 00447cb4 <o:p></
 o:p></sp
><span lang=EN-US>5ea0: 8a6c9004 8aeb4000 8295511c 00000000 0000011c 00000047 00000000 00000000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5ec0: 00000000 83d6e710 83cd4be0 80749020 80748fc2 00000000 00000000 80b267bc <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5ee0: 00000044 80707740 00008000 00402c9c 82e0b000 00001000 000002d0 807076c0 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5f00: 812e5498 816f57a0 00000000 00000000 000002d0 00000001 00000001 00000000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5f20: 82e0bd30 004d22d0 8aeb5f7c 000002d0 00001000 82e0b000 00402c9c 00008000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5f40: 8aeb5f64 80781eae 80781e68 40008000 004d2290 00000000 80783986 00008000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5f60: 00402c9c 00008000 80749740 828fe000 8aeb5f48 00000000 00000000 82e0b000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5f80: 8317d000 00000
 000 8070
000021 00000054 80783920 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5fa0: 00000000 0044b4b4 00000002 00000015 004d22d0 7b847ea4 7b847e95 00008000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5fc0: 00008000 7b847a64 004d2298 00000000 004736cc 00402c9c 00008000 7b8479a0 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5fe0: 0044b4bc 00423268 00008000 004d2290 00000000 00000000 00000054 00000160 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><span lang=EN-US>Call trace: <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;8083159e&gt;] xfs_alloc_lshift+0x7e/0x280<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;8083159e&gt;] xfs_alloc_lshift+0x7e/0x280<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80833104&gt;] xfs_alloc_insrec+0x264/0x400<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;808332fe&gt;] xfs_alloc_insert+0x5e/0x100<o:p><
 /o:p></s
l><span lang=EN-US>[&lt;8082ec3e&gt;] xfs_free_ag_extent+0x2be/0x5c0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;808305e2&gt;] xfs_free_extent+0x82/0xc0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;8083ada0&gt;] xfs_bmap_del_free+0x0/0x40<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;8083af04&gt;] xfs_bmap_finish+0xe4/0x160<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80861fd2&gt;] xfs_itruncate_finish+0x212/0x420<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;8087bf40&gt;] xfs_trans_ihold+0x0/0x20<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;8087bfc0&gt;] xfs_trans_ijoin+0x0/0x80<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;808851ea&gt;] xfs_inactive+0x3ea/0x500<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;8085e960&gt;] xfs_ilock+0x0/0xc0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80892d34&gt;] xfs_fs_clear_inode+0x34/0xa0<o
 :p></o:p
ormal><span lang=EN-US>[&lt;8077f34a&gt;] clear_inode+0x4a/0x120<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;8077f4f2&gt;] generic_delete_inode+0xd2/0x120<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80712ee0&gt;] sub_preempt_count+0x0/0xa0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;8087017e&gt;] xlog_recover_process_iunlinks+0x35e/0x3a0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;808707e6&gt;] xlog_recover_finish+0xa6/0xe0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;8087625c&gt;] xfs_mountfs+0xc1c/0xe40<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;808876d2&gt;] kmem_alloc+0x52/0x100<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;808877ec&gt;] kmem_zalloc+0xc/0x40<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;808584c0&gt;] xfs_fstrm_free_func+0x0/0xc0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;8087f30a&gt;] xfs_mount+0x3c
 a/0x420<
lass=MsoNormal><span lang=EN-US>[&lt;80893318&gt;] xfs_fs_fill_super+0x58/0x240<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80774d20&gt;] path_lookup+0x0/0x20<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80a45d74&gt;] __down_write_nested+0x134/0x180<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;808ba576&gt;] snprintf+0x16/0x40<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80774d20&gt;] path_lookup+0x0/0x20<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80794f54&gt;] sb_set_blocksize+0x14/0x40<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;8076ae32&gt;] get_sb_bdev+0x152/0x1e0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80760030&gt;] shmem_parse_options+0x2b0/0x3c0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80774d20&gt;] path_lookup+0x0/0x20<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;807644a8&gt;] __kmalloc+0x48/0x100<o:p></o:
 p></span
span lang=EN-US>[&lt;80892250&gt;] xfs_fs_get_sb+0x10/0x20<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;808932c0&gt;] xfs_fs_fill_super+0x0/0x240<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;8076a596&gt;] vfs_kern_mount+0x36/0xc0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;8076a66e&gt;] do_kern_mount+0x2e/0xe0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80783390&gt;] do_mount+0x130/0x6c0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80770900&gt;] path_release+0x0/0x40<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;807539a6&gt;] handle_mm_fault+0x446/0x720<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80753a6c&gt;] handle_mm_fault+0x50c/0x720<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;8070fad2&gt;] do_page_fault+0x92/0x380<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;808b852e&gt;] __up_read+0x4e/0xe0<o:p></o:p></span></p><p cl
 ass=MsoN
lt;8070faf8&gt;] do_page_fault+0xb8/0x380<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;807518e2&gt;] __do_fault+0x182/0x4a0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80753680&gt;] handle_mm_fault+0x120/0x720<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80749020&gt;] get_page_from_freelist+0x160/0x3e0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80748fc2&gt;] get_page_from_freelist+0x102/0x3e0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80707740&gt;] ret_from_exception+0x0/0x6<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;807076c0&gt;] tlb_miss_load+0x0/0x4<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80781eae&gt;] copy_mount_options+0x8e/0x100<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80781e68&gt;] copy_mount_options+0x48/0x100<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80783986&gt;] sys_mount+0x66/0xe0<o:p></o:p></sp
 an></p><
ang=EN-US>[&lt;80749740&gt;] free_pages+0x0/0x60<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;807078f8&gt;] syscall_call+0xa/0xe<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80783920&gt;] sys_mount+0x0/0xe0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><span lang=EN-US>xfs_force_shutdown(loop0,0x8) called from line 4274 of file fs/xfs/xfs_bmap.c. <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>Return address = 0x8083af3c<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>Filesystem &quot;loop0&quot;: Corruption of in-memory data detected.&nbsp; Shutting down<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>filesystem: loop0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>Please umount the filesystem, and rectify the problem(s)<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>Ending XFS recovery on filesystem: loop0 (logdev: internal)<o:p></o:p><
 /span></
n lang=EN-US>================================================================================<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><span lang=EN-US>Thanks,<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>Ryan. <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><span lang=EN-US>--------------------------------------------------------------------------------<o:p></o:p></span></p></div></body></html>

--Boundary_(ID_hERFTgdZheltJ2F45NpSFA)--


--===============2952253783612129089==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2952253783612129089==--
