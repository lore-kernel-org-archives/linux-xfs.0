Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E2513FED
	for <linux-xfs@vger.kernel.org>; Mon,  8 Jan 2024 12:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4T7tYB4wLczNkfS;
	Mon,  8 Jan 2024 20:24:46 +0800 (CST)
Received: from kwepemi500009.china.huawei.com (unknown [7.221.188.199])
	by mail.maildlp.com (Postfix) with ESMTPS id 5187314040F;
	Mon,  8 Jan 2024 20:25:22 +0800 (CST)
Received: from localhost (10.175.127.227) by kwepemi500009.china.huawei.com
 (7.221.188.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 8 Jan
 2024 20:25:21 +0800
Date: Mon, 8 Jan 2024 20:28:19 +0800
From: Long Li <leo.lilong@huawei.com>
To: Dave Chinner <david@fromorbit.com>
CC: <djwong@kernel.org>, <chandanbabu@kernel.org>,
	<linux-xfs@vger.kernel.org>, <yi.zhang@huawei.com>, <houtao1@huawei.com>,
	<yangerkun@huawei.com>
Subject: Re: [PATCH] xfs: ensure submit buffers on LSN boundaries in error
 handlers
Message-ID: <20240108122819.GA3770304@ceph-admin>
References: <20231228124646.142757-1-leo.lilong@huawei.com>
 <ZZsiHu15pAMl+7aY@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <ZZsiHu15pAMl+7aY@dread.disaster.area>
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi500009.china.huawei.com (7.221.188.199)

Hi, Dave

Thanks for your reply.

On Mon, Jan 08, 2024 at 09:13:50AM +1100, Dave Chinner wrote:
> On Thu, Dec 28, 2023 at 08:46:46PM +0800, Long Li wrote:
> > While performing the IO fault injection test, I caught the following data
> > corruption report:
> > 
> >  XFS (dm-0): Internal error ltbno + ltlen > bno at line 1957 of file fs/xfs/libxfs/xfs_alloc.c.  Caller xfs_free_ag_extent+0x79c/0x1130
> >  CPU: 3 PID: 33 Comm: kworker/3:0 Not tainted 6.5.0-rc7-next-20230825-00001-g7f8666926889 #214
> >  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2014
> >  Workqueue: xfs-inodegc/dm-0 xfs_inodegc_worker
> >  Call Trace:
> >   <TASK>
> >   dump_stack_lvl+0x50/0x70
> >   xfs_corruption_error+0x134/0x150
> >   xfs_free_ag_extent+0x7d3/0x1130
> >   __xfs_free_extent+0x201/0x3c0
> >   xfs_trans_free_extent+0x29b/0xa10
> >   xfs_extent_free_finish_item+0x2a/0xb0
> >   xfs_defer_finish_noroll+0x8d1/0x1b40
> >   xfs_defer_finish+0x21/0x200
> >   xfs_itruncate_extents_flags+0x1cb/0x650
> >   xfs_free_eofblocks+0x18f/0x250
> >   xfs_inactive+0x485/0x570
> >   xfs_inodegc_worker+0x207/0x530
> >   process_scheduled_works+0x24a/0xe10
> >   worker_thread+0x5ac/0xc60
> >   kthread+0x2cd/0x3c0
> >   ret_from_fork+0x4a/0x80
> >   ret_from_fork_asm+0x11/0x20
> >   </TASK>
> >  XFS (dm-0): Corruption detected. Unmount and run xfs_repair
> > 
> > After analyzing the disk image, it was found that the corruption was
> > triggered by the fact that extent was recorded in both the inode and AGF
> > btrees. After a long time of reproduction and analysis, we found that the
> > root cause of the problem was that the AGF btree block was not recovered.
> 
> Why was it not recovered? Because of an injected IO error during
> recovery?

The reason why the buf item of AGF btree is not recovery is that the LSN
of AGF btree block equal to the current LSN of the recovery item, Because
log recovery skips items with a metadata LSN >= the current LSN of the 
recovery item.

Injected IO error during recovery cause that the LSN of AGF btree block
equal to the current LSN of the recovery item, that's happend in the
situation of two transaction on disk share same LSN and both modify the
same buffer. Detailed information can be found below.

> 
> > Consider the following situation, Transaction A and Transaction B are in
> > the same record, so Transaction A and Transaction B share the same LSN1.
> > If the buf item in Transaction A has been recovered, then the buf item in
> > Transaction B cannot be recovered, because log recovery skips items with a
> > metadata LSN >= the current LSN of the recovery item.
> 
> This makes no sense to me. Transactions don't exist in the journal;
> they are purely in-memory constructs that are aggregated
> in memory (in the CIL) before being written to disk as an atomic
> checkpoint. Hence a log item can only appear once in a checkpoint
> regardless of how many transactions it is modified in memory between
> CIL checkpoints.
> 
> > If there is still an
> > inode item in transaction B that records the Extent X, the Extent X will
> > be recorded in both the inode and the AGF btree block after transaction B
> > is recovered.
> 
> That transaction should record both the addition to the inode BMBT
> and the removal from the AGF. Hence if transaction B is recovered in
> full with no errors, this should not occur.
> 
> > 
> >   |------------Record (LSN1)------------------|---Record (LSN2)---|
> >   |----------Trans A------------|-------------Trans B-------------|
> >   |     Buf Item(Extent X)      | Buf Item / Inode item(Extent X) |
> >   |     Extent X is freed       |     Extent X is allocated       |
> 
> This looks wrong. A transaction can only exist in a single CIL
> checkpoint and everything in a checkpoint has the same LSN. Hence we
> cannot have the situation where trans B spans two different
> checkpoints and hence span LSNs.

There is some misunderstanding here. Transactions that I said is on disk, not
in memory. Each transaction on disk corresponds to a checkpoint(This is my 
understanding, or we can call it as checkpoint transaction just like <<XFS
Algorithms & Data Structures>>), The two are easily confused, and their
meanings are not the same.

The transaction on disk can spans two different record. The following logs
show the details:

//Trans A, tid d0bfef23
//Trans B, tid 9a76bd30 

============================================================================
cycle: 271	version: 2		lsn: 271,14642	tail_lsn: 271,12644
length of Log Record: 32256	prev offset: 14608		num ops: 249
uuid: 01ce1afc-cedd-4120-8d8d-05fbee260af9   format: little endian linux
h_size: 32768
----------------------------------------------------------------------------
Oper (0): tid: d0bfef23  len: 0  clientid: TRANS  flags: START 
----------------------------------------------------------------------------
Oper (1): tid: d0bfef23  len: 16  clientid: TRANS  flags: none
TRAN:     tid: d0bfef23  num_items: 145
----------------------------------------------------------------------------
	  ......
----------------------------------------------------------------------------
Oper (5): tid: d0bfef23  len: 56  clientid: TRANS  flags: none
INODE: #regs: 3   ino: 0xc4aa3  flags: 0x41   dsize: 0
        blkno: 805536  len: 32  boff: 1536
Oper (6): tid: d0bfef23  len: 176  clientid: TRANS  flags: none
INODE CORE
magic 0x494e mode 0100666 version 3 format 2
nlink 1 uid 0 gid 0
atime 0xd014ae00 mtime 0xfe187700 ctime 0xfe187700
size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0

/* inode 0xc4aa3 nblocks is 0 */

naextents 0x0 forkoff 35 dmevmask 0x0 dmstate 0x0
flags 0x0 gen 0x526bda01
flags2 0x8 cowextsize 0x0
Oper (7): tid: d0bfef23  len: 52  clientid: TRANS  flags: none
LOCAL attr data
----------------------------------------------------------------------------
	......
----------------------------------------------------------------------------
Oper (102): tid: d0bfef23  len: 24  clientid: TRANS  flags: none
BUF:  #regs: 2   start blkno: 1048577 (0x100001)  len: 1  bmap size: 1  flags: 0x2800
Oper (103): tid: d0bfef23  len: 128  clientid: TRANS  flags: none
AGF Buffer: XAGF  
ver: 1  seq#: 2  len: 65536  
root BNO: 3  CNT: 4
level BNO: 1  CNT: 1
1st: 110  last: 113  cnt: 4  freeblks: 40923  longest: 37466
----------------------------------------------------------------------------
Oper (104): tid: d0bfef23  len: 24  clientid: TRANS  flags: none
BUF:  #regs: 2   start blkno: 1048600 (0x100018)  len: 8  bmap size: 1  flags: 0x2000
Oper (105): tid: d0bfef23  len: 768  clientid: TRANS  flags: none
BUF DATA
 0 42334241 4a000000 ffffffff ffffffff        0 18001000  f010000 ff300000 
 8 fc1ace01 2041ddce fb058d8d f90a26ee  2000000 128ec3ad  50a0000 5d000000 
10 770a0000 21000000 a00a0000 b5000000 580b0000 2d010000 fa0c0000 10000000 
	
/* extent (770a0000 21000000) recorded in the AGF */

18 170d0000  b000000 3e0d0000 1a000000 710d0000  5000000 a60d0000  3000000 
20 ee0d0000 91000000 bf0e0000  1000000 c80e0000  3000000 d60e0000 62010000 
28 47100000  a000000 68100000  6000000 89500000 a0000000 94510000  4000000 
30 c2510000 60000000 3e520000 31000000 8a520000 1e000000 b0520000  1000000 
38 ce520000 1e000000 ee520000 11000000  8530000 18000000 14540000 23000000 
40 70540000 2c000000 a3540000 19000000 d2540000 13000000  9550000 19000000 
48 35550000  2000000 61550000  e000000 81550000 11000000 a0550000  4000000 
50 b6550000  6000000 d4550000  5000000 df550000  3000000  d560000  8000000 
58 24560000  5000000 7b560000  2000000 c8560000 10000000 df560000 36000000 
60 74570000 20000000 a2570000 5d000000 16580000 13000000 46580000 3a000000 
68 91580000  9000000 3a590000  1000000 6a590000  2000000   5a0000 15000000 
70 525a0000 35000000 e85a0000  1000000 d95b0000  2000000 615d0000 28000000 
78 485e0000 d3000000 2a5f0000  9000000 495f0000 44000000 c15f0000 a9000000 
80 cd600000  c000000 34610000  4000000 99610000  1000000 b9610000 1c000000 
88 dc610000  2000000 e2610000 84000000 77620000 1f000000 95630000 8c000000 
90 77640000 13000000 73650000 71000000 7a690000  5000000 8e690000  6000000 
98 576a0000 26000000 376b0000 3a000000 ce6b0000 1e000000  66c0000 a7000000 
a0 a66d0000 5a920000 336d0000 cd920000 336d0000 cd920000 336d0000 cd920000 
a8        0        0        0        0        0        0        0        0 
b0        0        0        0        0        0        0        0        0 
b8        0        0        0        0        0        0        0        0 

----------------------------------------------------------------------------
Oper (106): tid: d0bfef23  len: 24  clientid: TRANS  flags: none
BUF:  #regs: 2   start blkno: 1048608 (0x100020)  len: 8  bmap size: 1  flags: 0x2000
Oper (107): tid: d0bfef23  len: 768  clientid: TRANS  flags: none
BUF DATA
 0 43334241 4a000000 ffffffff ffffffff        0 20001000  f010000 ff300000 
 8 fc1ace01 2041ddce fb058d8d f90a26ee  2000000 3ea37604 bf0e0000  1000000 
10 b0520000  1000000 3a590000  1000000 e85a0000  1000000 99610000  1000000 
18 35550000  2000000 7b560000  2000000 6a590000  2000000 d95b0000  2000000 
20 dc610000  2000000 a60d0000  3000000 c80e0000  3000000 df550000  3000000 
28 94510000  4000000 a0550000  4000000 34610000  4000000 710d0000  5000000 
30 d4550000  5000000 24560000  5000000 7a690000  5000000 68100000  6000000 
38 b6550000  6000000 8e690000  6000000  d560000  8000000 91580000  9000000 
40 2a5f0000  9000000 47100000  a000000 170d0000  b000000 cd600000  c000000 
48 61550000  e000000 fa0c0000 10000000 c8560000 10000000 ee520000 11000000 
50 81550000 11000000 d2540000 13000000 16580000 13000000 77640000 13000000 
58   5a0000 15000000  8530000 18000000 a3540000 19000000  9550000 19000000 
60 3e0d0000 1a000000 b9610000 1c000000 8a520000 1e000000 ce520000 1e000000 
68 ce6b0000 1e000000 77620000 1f000000 74570000 20000000 770a0000 21000000 
70 14540000 23000000 576a0000 26000000 615d0000 28000000 70540000 2c000000 
78 3e520000 31000000 525a0000 35000000 df560000 36000000 46580000 3a000000 
80 376b0000 3a000000 495f0000 44000000  50a0000 5d000000 a2570000 5d000000 
88 c2510000 60000000 73650000 71000000 e2610000 84000000 95630000 8c000000 
90 ee0d0000 91000000 89500000 a0000000  66c0000 a7000000 c15f0000 a9000000 
98 a00a0000 b5000000 485e0000 d3000000 580b0000 2d010000 d60e0000 62010000 
a0 a66d0000 5a920000 336d0000 cd920000 336d0000 cd920000 336d0000 cd920000 
a8        0        0        0        0        0        0        0        0 
b0        0        0        0        0        0        0        0        0 
b8        0        0        0        0        0        0        0        0 

----------------------------------------------------------------------------
	......
----------------------------------------------------------------------------
Oper (147): tid: d0bfef23  len: 0  clientid: TRANS  flags: COMMIT 
----------------------------------------------------------------------------
Oper (148): tid: 9a76bd30  len: 0  clientid: TRANS  flags: START 
----------------------------------------------------------------------------
Oper (149): tid: 9a76bd30  len: 16  clientid: TRANS  flags: none
TRAN:     tid: 9a76bd30  num_items: 164
----------------------------------------------------------------------------
	......
----------------------------------------------------------------------------
Oper (248): tid: 9a76bd30  len: 168  clientid: TRANS  flags: CONTINUE 

============================================================================
cycle: 271	version: 2		lsn: 271,14706	tail_lsn: 271,12644
length of Log Record: 10752	prev offset: 14642		num ops: 67
uuid: 01ce1afc-cedd-4120-8d8d-05fbee260af9   format: little endian linux
h_size: 32768
----------------------------------------------------------------------------
Oper (0): tid: 9a76bd30  len: 8  clientid: TRANS  flags: WAS_CONT END 
Left over region from split log item
----------------------------------------------------------------------------
Oper (1): tid: 9a76bd30  len: 52  clientid: TRANS  flags: none
Left over region from split log item
----------------------------------------------------------------------------
	......
----------------------------------------------------------------------------
Oper (5): tid: 9a76bd30  len: 56  clientid: TRANS  flags: none
INODE: #regs: 4   ino: 0xc4aa3  flags: 0x45   dsize: 32
        blkno: 805536  len: 32  boff: 1536
Oper (6): tid: 9a76bd30  len: 176  clientid: TRANS  flags: none
INODE CORE
magic 0x494e mode 0100666 version 3 format 2
nlink 0 uid 0 gid 0
atime 0xf4e300 mtime 0x2261000 ctime 0x2a02200
size 0x1a9600 nblocks 0x3f extsize 0x0 nextents 0x2

/* inode 0xc4aa3 nblocks is 0x3f */

naextents 0x0 forkoff 24 dmevmask 0x0 dmstate 0x0
flags 0x0 gen 0x526bda01
flags2 0x8 cowextsize 0x0
Oper (7): tid: 9a76bd30  len: 32  clientid: TRANS  flags: none
EXTENTS inode data
Oper (8): tid: 9a76bd30  len: 144  clientid: TRANS  flags: none
LOCAL attr data
----------------------------------------------------------------------------
	......
----------------------------------------------------------------------------
Oper (57): tid: 9a76bd30  len: 24  clientid: TRANS  flags: none
BUF:  #regs: 2   start blkno: 1048577 (0x100001)  len: 1  bmap size: 1  flags: 0x2800
Oper (58): tid: 9a76bd30  len: 128  clientid: TRANS  flags: none
AGF Buffer: XAGF  
ver: 1  seq#: 2  len: 65536  
root BNO: 3  CNT: 4
level BNO: 1  CNT: 1
1st: 114  last: 117  cnt: 4  freeblks: 40714  longest: 37466
----------------------------------------------------------------------------
Oper (59): tid: 9a76bd30  len: 24  clientid: TRANS  flags: none
BUF:  #regs: 2   start blkno: 1048608 (0x100020)  len: 8  bmap size: 1  flags: 0x2000
Oper (60): tid: 9a76bd30  len: 768  clientid: TRANS  flags: none
BUF DATA
 0 43334241 47000000 ffffffff ffffffff        0 20001000  f010000 ff300000 
 8 fc1ace01 2041ddce fb058d8d f90a26ee  2000000 3ea37604 b0520000  1000000 
10 3a590000  1000000 e85a0000  1000000 99610000  1000000 dc610000  1000000 
18 35550000  2000000 7b560000  2000000 6a590000  2000000 d95b0000  2000000 
20 a60d0000  3000000 c80e0000  3000000 df550000  3000000 34610000  4000000 
28 710d0000  5000000 d4550000  5000000 24560000  5000000 7a690000  5000000 
30 68100000  6000000 b6550000  6000000 8e690000  6000000  d560000  8000000 
38 91580000  9000000 2a5f0000  9000000 5d620000  9000000 47100000  a000000 
40 170d0000  b000000 cd600000  c000000 580b0000  d000000 61550000  e000000 
48 fa0c0000 10000000 d5540000 10000000 c8560000 10000000 ee520000 11000000 
50 81550000 11000000 16580000 13000000 77640000 13000000   5a0000 15000000 
58  8530000 18000000 a3540000 19000000  9550000 19000000 3e0d0000 1a000000 
60 b9610000 1c000000 8a520000 1e000000 ce520000 1e000000 ce6b0000 1e000000 
68 77620000 1f000000 74570000 20000000 14540000 23000000 576a0000 26000000 
70 615d0000 28000000 70540000 2c000000 3e520000 31000000 525a0000 35000000 
78 df560000 36000000 46580000 3a000000 376b0000 3a000000 495f0000 44000000 
80 c6510000 5c000000  50a0000 5d000000 a2570000 5d000000 73650000 71000000 
88 95630000 8c000000 ee0d0000 91000000 89500000 a0000000  66c0000 a7000000 
90 c15f0000 a9000000 a00a0000 b5000000 485e0000 d3000000 830b0000  2010000 
98 dc0e0000 5c010000 a66d0000 5a920000 a66d0000 5a920000 a66d0000 5a920000 
a0 a66d0000 5a920000 336d0000 cd920000 336d0000 cd920000 336d0000 cd920000 
a8        0        0        0        0        0        0        0        0 
b0        0        0        0        0        0        0        0        0 
b8        0        0        0        0        0        0        0        0 

----------------------------------------------------------------------------
Oper (61): tid: 9a76bd30  len: 24  clientid: TRANS  flags: none
BUF:  #regs: 2   start blkno: 1048600 (0x100018)  len: 8  bmap size: 1  flags: 0x2000
Oper (62): tid: 9a76bd30  len: 768  clientid: TRANS  flags: none
BUF DATA
 0 42334241 47000000 ffffffff ffffffff        0 18001000  f010000 ff300000 
 8 fc1ace01 2041ddce fb058d8d f90a26ee  2000000 128ec3ad  50a0000 5d000000 
10 a00a0000 b5000000 580b0000  d000000 830b0000  2010000 fa0c0000 10000000 
	
/* extent (770a0000 21000000) has been removed from the AGF */

18 170d0000  b000000 3e0d0000 1a000000 710d0000  5000000 a60d0000  3000000 
20 ee0d0000 91000000 c80e0000  3000000 dc0e0000 5c010000 47100000  a000000 
28 68100000  6000000 89500000 a0000000 c6510000 5c000000 3e520000 31000000 
30 8a520000 1e000000 b0520000  1000000 ce520000 1e000000 ee520000 11000000 
38  8530000 18000000 14540000 23000000 70540000 2c000000 a3540000 19000000 
40 d5540000 10000000  9550000 19000000 35550000  2000000 61550000  e000000 
48 81550000 11000000 b6550000  6000000 d4550000  5000000 df550000  3000000 
50  d560000  8000000 24560000  5000000 7b560000  2000000 c8560000 10000000 
58 df560000 36000000 74570000 20000000 a2570000 5d000000 16580000 13000000 
60 46580000 3a000000 91580000  9000000 3a590000  1000000 6a590000  2000000 
68   5a0000 15000000 525a0000 35000000 e85a0000  1000000 d95b0000  2000000 
70 615d0000 28000000 485e0000 d3000000 2a5f0000  9000000 495f0000 44000000 
78 c15f0000 a9000000 cd600000  c000000 34610000  4000000 99610000  1000000 
80 b9610000 1c000000 dc610000  1000000 5d620000  9000000 77620000 1f000000 
88 95630000 8c000000 77640000 13000000 73650000 71000000 7a690000  5000000 
90 8e690000  6000000 576a0000 26000000 376b0000 3a000000 ce6b0000 1e000000 
98  66c0000 a7000000 a66d0000 5a920000 a66d0000 5a920000 a66d0000 5a920000 
a0 a66d0000 5a920000 336d0000 cd920000 336d0000 cd920000 336d0000 cd920000 
a8        0        0        0        0        0        0        0        0 
b0        0        0        0        0        0        0        0        0 
b8        0        0        0        0        0        0        0        0 

----------------------------------------------------------------------------
	......
----------------------------------------------------------------------------
Oper (66): tid: 9a76bd30  len: 0  clientid: TRANS  flags: COMMIT 


> 
> These are valid representations:
> 
>   |------------Record (LSN1)----|-----------------Record (LSN2)---|
>   |----------Trans A------------|-------------Trans B-------------|
> 
>   |------------Record (LSN1)--------------------------------------|
>   |----------Trans A------------|-------------Trans B-------------|
> 
>   |-----------------------------------------------Record (LSN2)---|
>   |----------Trans A------------|-------------Trans B-------------|
> 
> Only in the first case are there two instances of the AGF buf item
> object in the journal (one in each checkpoint). In the latter two
> cases, there is only one copy of the AGF buf log item that contains
> extent X. Indeed, it will not contain extent X, because the CIL
> aggregation results in the addition in trans A being elided by the
> removal in trans B, essentially resulting in the buffer being
> unchanged except for the LSN after recovery.
> 
> As such, I'm really not sure what you are trying to describe here -
> if recovery of the checkpoint at LSN1 fails in any way, we should
> never attempt to recovery the checkpoint at LSN2. If LSN1 recoveres
> entirely successfully, then LSN2 should see the correct state and
> recover appropriately, too. Hence I don't see how the situation you
> are describing arises.
> 
> > After commit 12818d24db8a ("xfs: rework log recovery to submit buffers on
> > LSN boundaries") was introduced, we submit buffers on lsn boundaries during
> > log recovery. 
> 
> Correct - we submit all the changes in a checkpoint for submission
> before we start recovering the next checkpoint. That's because
> checkpoints are supposed to be atomic units of change moving the
> on-disk state from one change set to the next.

Submit buffer on LSN boundaries not means submit buffer on checkpoint
boundaries during recovery. In my understanding, One transaction on disk
corresponds to a checkpoint, there's maybe multiple transaction on disk
share same LSN, so sometimes we should ensure that submit multiple
transation one time in such case. This rule was introduced by commit
12818d24db8a ("xfs: rework log recovery to submit buffers on LSN boundaries")

Now, we can ensure this rule in most case, but we violate the rule when
submitting buffer regardless of error in xlog_do_recovery_pass(), this
pacth try to fix the problem.

If I misunderstand, expect you to point it out. :)

Thanks,
Long Li

> 
> If any error during processing of a checkpoint occurs, we are
> supposed to abort recovery at that checkpoint so we don't create a
> situation where future recovery attempts skip checkpoints that need
> to be recovered.
> 
> It does not matter if we write back the modified buffers from
> partially completed checkpoints - they were successfully recovered
> in their entirity, and so it is safe to write them back knowing that
> the next attempt to recover the failed checkpoint will see a
> matching LSN and skip that buffer item. If writeback fails, then it
> just doesn't matter as the next recovery attempt will see the old
> LSN and recover that buf item again and write it back....
> 
> AFAICT, you're describing things working as they are supposed to,
> and I don't see where the problem you are attempting to fix is yet.
> 
> > The above problem can be avoided under normal paths, but it's
> > not guaranteed under abnormal paths. Consider the following process, if an
> > error was encountered after recover buf item in transaction A and before
> > recover buf item in transaction B, buffers that have been added to
> > buffer_list will still be submitted, this violates the submits rule on lsn
> > boundaries. So buf item in Transaction B cannot be recovered on the next
> > mount due to current lsn of transaction equal to metadata lsn on disk.
> > 
> >   xlog_do_recovery_pass
> >     error = xlog_recover_process
> >       xlog_recover_process_data
> >         ...
> >           xlog_recover_buf_commit_pass2
> >             xlog_recover_do_reg_buffer  //recover buf item in Trans A
> >             xfs_buf_delwri_queue(bp, buffer_list)
> >         ...
> >         ====> Encountered error and returned
> 
> What error is this, and why isn't it a fatal error causing the
> checkpoint recovery to be aborted and the delwri list to be canceled?
> 
> >         ...
> >           xlog_recover_buf_commit_pass2
> >             xlog_recover_do_reg_buffer  //recover buf item in Trans B
> >             xfs_buf_delwri_queue(bp, buffer_list)
> 
> This should never occur as we should be aborting log recovery on the
> first failure, not continuing to process the checkpoint or starting
> to process other checkpoints. Where are we failing to handle an
> error?
> 
> >     if (!list_empty(&buffer_list))
> >       xfs_buf_delwri_submit(&buffer_list); //submit regardless of error
> 
> Yes, that's fine (as per above). Indeed, this is how we handle
> releasing the buffer log item on failure - this goes through IO
> completion and that release the buf log item we added to the buffer
> during recovery for LSN stamping.
> 
> > In order to make sure that submits buffers on lsn boundaries in the
> > abnormal paths, we need to check error status before submit buffers that
> > have been added from the last record processed. If error status exist,
> > buffers in the bufffer_list should be canceled.
> 
> No, it does not need to be cancelled, it just needs to be processed.
> Anything we've fully recovered is safe to write - it's no different
> from having the system crash during AIL writeback having written
> back these buffers and having to recover from part way through this
> checkpoint.
> 
> > Canceling the buffers in the buffer_list directly isn't correct, unlike
> > any other place where write list was canceled, these buffers has been
> > initialized by xfs_buf_item_init() during recovery and held by buf
> > item, buf items will not be released in xfs_buf_delwri_cancel(). If
> > these buffers are submitted successfully, buf items assocated with
> > the buffer will be released in io end process. So releasing buf item
> > in write list cacneling process is needed.
> 
> Yes, that's why we use xfs_buf_delwri_submit() even on error - it
> handles releasing the buffer log item in IO completion handling
> (even on error).
> 
> 
> 
> > Fixes: 50d5c8d8e938 ("xfs: check LSN ordering for v5 superblocks during recovery")
> > Signed-off-by: Long Li <leo.lilong@huawei.com>
> > ---
> >  fs/xfs/xfs_buf.c         |  2 ++
> >  fs/xfs/xfs_log_recover.c | 22 +++++++++++++---------
> >  2 files changed, 15 insertions(+), 9 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > index 8e5bd50d29fe..6a1b26aaf97e 100644
> > --- a/fs/xfs/xfs_buf.c
> > +++ b/fs/xfs/xfs_buf.c
> > @@ -2075,6 +2075,8 @@ xfs_buf_delwri_cancel(
> >  		xfs_buf_lock(bp);
> >  		bp->b_flags &= ~_XBF_DELWRI_Q;
> >  		xfs_buf_list_del(bp);
> > +		if (bp->b_log_item)
> > +			xfs_buf_item_relse(bp);
> >  		xfs_buf_relse(bp);
> >  	}
> >  }
> 
> I don't think this is a good idea - the delwri does not own the
> buf log item reference, and so this will cause problems with
> anything that already handles buf log item references correctly.
> 
> > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > index 1251c81e55f9..2cda6c90890d 100644
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -2964,7 +2964,6 @@ xlog_do_recovery_pass(
> >  	char			*offset;
> >  	char			*hbp, *dbp;
> >  	int			error = 0, h_size, h_len;
> > -	int			error2 = 0;
> >  	int			bblks, split_bblks;
> >  	int			hblks, split_hblks, wrapped_hblks;
> >  	int			i;
> > @@ -3203,16 +3202,21 @@ xlog_do_recovery_pass(
> >   bread_err1:
> >  	kmem_free(hbp);
> >  
> > -	/*
> > -	 * Submit buffers that have been added from the last record processed,
> > -	 * regardless of error status.
> > -	 */
> > -	if (!list_empty(&buffer_list))
> > -		error2 = xfs_buf_delwri_submit(&buffer_list);
> > -
> >  	if (error && first_bad)
> >  		*first_bad = rhead_blk;
> >  
> > +	/*
> > +	 * If there are no error, submit buffers that have been added from the
> > +	 * last record processed, othrewise cancel the write list, to ensure
> > +	 * submit buffers on LSN boundaries.
> > +	 */
> > +	if (!list_empty(&buffer_list)) {
> > +		if (error)
> > +			xfs_buf_delwri_cancel(&buffer_list);
> > +		else
> > +			error = xfs_buf_delwri_submit(&buffer_list);
> > +	}
> 
> > +
> >  	/*
> >  	 * Transactions are freed at commit time but transactions without commit
> >  	 * records on disk are never committed. Free any that may be left in the
> > @@ -3226,7 +3230,7 @@ xlog_do_recovery_pass(
> >  			xlog_recover_free_trans(trans);
> >  	}
> >  
> > -	return error ? error : error2;
> > +	return error;
> >  }
> >  
> >  /*
> > -- 
> > 2.31.1
> > 
> > 
> > 
> 
> -- 
> Dave Chinner
> david@fromorbit.com
