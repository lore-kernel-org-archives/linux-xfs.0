Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4I4h8ux028631 for <xfs@oss.sgi.com>; Mon, 17 May 2010 23:43:12 -0500
Received: from bby1mta02.pmc-sierra.bc.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 62F179CB4E7
	for <xfs@oss.sgi.com>; Mon, 17 May 2010 21:46:24 -0700 (PDT)
Received: from bby1mta02.pmc-sierra.bc.ca (bby1mta02.pmc-sierra.com
	[216.241.235.117]) by cuda.sgi.com with ESMTP id
	slYPqngSTd5FTX3l for <xfs@oss.sgi.com>;
	Mon, 17 May 2010 21:46:24 -0700 (PDT)
Received: from bby1mta02.pmc-sierra.bc.ca (localhost.pmc-sierra.bc.ca
	[127.0.0.1]) by localhost (Postfix) with SMTP id 8157A8E0083
	for <xfs@oss.sgi.com>; Mon, 17 May 2010 21:45:23 -0700 (PDT)
Received: from bby1exg02.pmc_nt.nt.pmc-sierra.bc.ca
	(BBY1EXG02.pmc-sierra.bc.ca [216.241.231.167])
	by bby1mta02.pmc-sierra.bc.ca (Postfix) with SMTP id 74EAF8E007A
	for <xfs@oss.sgi.com>; Mon, 17 May 2010 21:45:23 -0700 (PDT)
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: xfs crash
Date: Mon, 17 May 2010 21:45:23 -0700
Message-ID: <BE430C874DBA6841A75E65151DCC6E1C04076679@BBY1EXM11.pmc_nt.nt.pmc-sierra.bc.ca>
From: "Jabir M" <Jabir_M@pmc-sierra.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


Hi all,

       I am using xfs file system on a MIPS based processor having linux-2.6.24. when executed a script to copy an mp4 file of 1GB upto 30 instances on back ground. xfs crashed displaying the following log. Please suggest me a solution.

CPU 1 Unable to handle kernel paging request at virtual address 00000006, epc == 803375e8, ra == 803375d4
Oops[#1]:
Cpu 1
$ 0   : 00000000 00000000 00000000 00000025
$ 4   : 8f1c383c 00000038 00000038 0000003b
$ 8   : 00000002 00000400 0000000a 00000400
$12   : 00000000 8054c5c0 0000123c 00000000
$16   : 8f1c383c 8d2c936c 00000038 0000003b
$20   : 87738000 00000000 00000000 00000000
$24   : 8f39b1d0 8036ca64
$28   : 8f0ea000 8f0eb428 8fb18900 803375d4
Hi    : 00000000
Lo    : 00001104
epc   : 803375e8 xfs_trans_log_buf+0xa0/0xe0     Not tainted
ra    : 803375d4 xfs_trans_log_buf+0x8c/0xe0
Status: 1100c303    KERNEL EXL IE
Cause : 00800008
BadVA : 00000006
PrId  : 00019548 (MIPS 34K)
Modules linked in: block2mtd
Process cp (pid: 1407, threadinfo=8f0ea000, task=8f89b648)
Stack : 00000000 03a70c78 8f0ca480 8d2c936c 8f017400 8d2c936c 8f336200 00000001
        8f08ee98 802e2858 00000008 00014005 8f3362c0 8f3362c0 8f0eb468 8f0eb46c
        00000038 0000003b 00000000 87738010 00000001 802e7a18 00000001 00000000
        8f08ee08 00000001 00000024 00000000 8064eec0 8f08ee30 8f017400 80300ea4
        00004004 80337af0 00000200 00001104 003a5fc3 03a70c78 00000008 00000000
        ...
Call Trace:
[<803375e8>] xfs_trans_log_buf+0xa0/0xe0
[<802e2858>] xfs_alloc_log_agf+0x58/0x6c
[<802e7a18>] xfs_alloc_delrec+0x4b8/0xba4
[<802e814c>] xfs_alloc_delete+0x48/0xec
[<802e1e84>] xfs_alloc_fixup_trees+0x8c/0x46c
[<802e4004>] xfs_alloc_ag_vextent_near+0x42c/0xae8
[<802e47fc>] xfs_alloc_ag_vextent+0x13c/0x1a4
[<802e51d4>] xfs_alloc_vextent+0x3d4/0x490
[<802f6930>] xfs_bmap_btalloc+0x66c/0xabc
[<802fac58>] xfs_bmapi+0xd48/0x13f8
[<803215d8>] xfs_iomap_write_allocate+0x178/0x59c
[<80320408>] xfs_iomap+0x40c/0x468
[<8034570c>] xfs_map_blocks+0x48/0xac
[<80346928>] xfs_page_state_convert+0x658/0x910
[<80346f28>] xfs_vm_writepage+0x84/0x20c
[<8016987c>] __writepage+0x1c/0x88
[<8016a6a8>] write_cache_pages+0x300/0x418
[<8016a828>] do_writepages+0x44/0x78
[<801abf80>] __writeback_single_inode+0xa0/0x488
[<801ac934>] sync_sb_inodes+0x318/0x470
[<801acddc>] writeback_inodes+0x9c/0x160
[<8016b3bc>] balance_dirty_pages_ratelimited_nr+0x278/0x3c8
[<80163e64>] generic_file_buffered_write+0x1fc/0x758
[<8034f8fc>] xfs_write+0x680/0x934
[<80184608>] do_sync_write+0xe0/0x168
[<80185298>] sys_write+0x58/0xc0
[<8010bed0>] stack_done+0x20/0x3c


Code: 02402821  34630001  ae230060 <90470006> 2403fff7  02603021  34e70001  00e33824  a0470006



Thanks
Jabir

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
