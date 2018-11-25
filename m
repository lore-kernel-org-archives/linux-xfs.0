Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:49926 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726083AbeKZAbM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 25 Nov 2018 19:31:12 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id wAPD9Haa013141
        for <linux-xfs@vger.kernel.org>; Sun, 25 Nov 2018 08:40:05 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2nyn6jv00e-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Sun, 25 Nov 2018 08:40:05 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Sun, 25 Nov 2018 13:39:33 -0000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: COW improvements and always_cow support V2
Date: Sun, 25 Nov 2018 19:09:33 +0530
In-Reply-To: <20181119134619.16812-1-hch@lst.de>
References: <20181119134619.16812-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Message-Id: <4455584.hbaYzlDTmr@localhost.localdomain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Monday, November 19, 2018 7:16:10 PM IST Christoph Hellwig wrote:
> Hi all,
> 
> this series adds the always_cow mode support after improving our COW
> write support a little bit first.
> 
> The always_cow mode stresses the COW path a lot, but with a few xfstests
> fixups it generall looks good, except for:
> 
>  - a few tests that complain about fragmentation, which is rather inherent
>    in this mode
>  - generic/208 crashing a lot (and generic/095 with 1k block similarly)
>    because a COW fork extent has changed under writeback.  As far as I can
>    tell this is because nothing prevents another thread from moving a COW
>    fork extent to the data fork while we are under writeback.  I'm currently
>    fully root causing this and looking into a potential fix
>  - xfs/017 crashes occasionally in log recovery because we can't find
>    a refcount tree record that we try to free.
>    I haven't really fully understood this one yet.
> 
> Changes since v1:
>  - make delalloc and unwritten extent conversions simpler and more robust
>  - add a few additional cleanups
>  - support all fallocate modes but actual preallocation
>  - rebase on top of a fix from Brian (which is included as first patch
>    to make the patch set more usable)
> 

Hi Christoph,

On ppc64le (with 4k block size), xfs/017 causes the following call trace,

WARNING: CPU: 2 PID: 7865 at /root/repos/linux/fs/xfs/xfs_aops.c:352 xfs_map_blocks+0x154/0xc44
Modules linked in:
CPU: 2 PID: 7865 Comm: fsstress Not tainted 4.20.0-rc3-next-20181123-00008-gbb319d33d6c5-dirty #7
NIP:  c00000000069f924 LR: c00000000069f88c CTR: 0000000000000000
REGS: c000000630dc3520 TRAP: 0700   Not tainted  (4.20.0-rc3-next-20181123-00008-gbb319d33d6c5-dirty)
MSR:  8000000000029033 <SF,EE,ME,IR,DR,RI,LE>  CR: 44004484  XER: 00000000
CFAR: c00000000000e6d4 IRQMASK: 0
GPR00: c00000000069f88c c000000630dc37b0 c0000000017a3100 c000000630dc3b80
GPR04: 0000000000000000 000000000000008f 0000000000000008 fffffffffffffffe
GPR08: 000000000000002b 0000000000000001 0000000000000009 c000000623040080
GPR12: c0000000003113a0 c00000003fffdf00 0000000000000000 0000000000000000
GPR16: 0000000100030780 00007fffffffb2c0 00000001000136a8 0000000000000001
GPR20: 0000000000000000 0000000000010000 c000000630dc3c20 0000000000001000
GPR24: 0000000000000008 f000000000d79a00 c000000630dc3b80 c000000624320300
GPR28: c000000100733f48 0000000000000000 0000000000009000 c000000630dc37b0
NIP [c00000000069f924] xfs_map_blocks+0x154/0xc44
LR [c00000000069f88c] xfs_map_blocks+0xbc/0xc44
Call Trace:
[c000000630dc37b0] [c00000000069f88c] xfs_map_blocks+0xbc/0xc44 (unreliable)
[c000000630dc3960] [c0000000006a0e88] xfs_writepage_map+0x174/0x428
[c000000630dc39f0] [c0000000006a12ac] xfs_do_writepage+0x170/0x2c0
[c000000630dc3a40] [c0000000003257f0] write_cache_pages+0x350/0x540
[c000000630dc3b60] [c0000000006a1508] xfs_vm_writepages+0x98/0xd4
[c000000630dc3bd0] [c000000000326c2c] do_writepages+0x5c/0xcc
[c000000630dc3c00] [c00000000030e338] __filemap_fdatawrite_range+0xc4/0xd4
[c000000630dc3c60] [c00000000030e460] filemap_flush+0x30/0x40
[c000000630dc3c80] [c0000000006d0538] xfs_release+0x12c/0x298
[c000000630dc3cc0] [c0000000006b4ca4] xfs_file_release+0x24/0x38
[c000000630dc3ce0] [c0000000003f68f8] __fput+0xc8/0x280
[c000000630dc3d40] [c0000000003f6b40] ____fput+0x20/0x30
[c000000630dc3d60] [c00000000014bef4] task_work_run+0xb8/0x100
[c000000630dc3da0] [c0000000000231cc] do_notify_resume+0x184/0x18c
[c000000630dc3e20] [c00000000000e544] ret_from_except_lite+0x70/0x74
Instruction dump:
39290002 7d290074 7929d182 5529063e 913f005c 813f005c 7d290034 5529d97e
69290001 5529063e 2fa90000 419e0008 <0fe00000> 813f005c 7d290034 5529d97e


This corresponds to the following code inside xfs_map_blocks(),

imap_valid = offset_fsb >= wpc->imap.br_startoff &&
	     offset_fsb < wpc->imap.br_startoff + wpc->imap.br_blockcount;
if (imap_valid &&
    !WARN_ON_ONCE(wpc->imap.br_startblock == HOLESTARTBLOCK) &&
    (!xfs_inode_has_cow_data(ip) ||
     wpc->io_type == XFS_IO_COW ||
     wpc->cow_seq == READ_ONCE(ip->i_cowfp->if_seq)))
	return 0;


I did some debugging and the following provides an explaination as to why 
the condition passed to WARN_ON_ONCE() evaluated to true,

148854:fsstress 19867 [001] 178758.940803:  probe:xfs_file_buffered_aio_write: (c0000000006b71f0) ki_pos=1301686 i_ino=8388710
149023:fsstress 19867 [001] 178758.940968:            probe:__iomap_write_end: (c00000000049720c) i_ino=8388710 len_u32=9034 copied_u32=9034 pos_u64=1301686
149191:fsstress 19867 [001] 178758.941167:            probe:__iomap_write_end: (c00000000049720c) i_ino=8388710 len_u32=65536 copied_u32=65536 pos_u64=1310720
150133:fsstress 19867 [001] 178758.941566:            probe:__iomap_write_end: (c00000000049720c) i_ino=8388710 len_u32=8475 copied_u32=8475 pos_u64=1376256

An "Extended write" is performed at a 4k block which maps file offset
1298432. Hence the file range before 1298431 maps to a hole.



123854:fsstress 19867 [001] 178758.896306:  probe:xfs_file_buffered_aio_write: (c0000000006b71f0) ki_pos=434109 i_ino=8388710
124223:fsstress 19867 [001] 178758.896549:            probe:__iomap_write_end: (c00000000049720c) i_ino=8388710 len_u32=24643 copied_u32=24643 pos_u64=434109
124583:fsstress 19867 [001] 178758.896719:            probe:__iomap_write_end: (c00000000049720c) i_ino=8388710 len_u32=65536 copied_u32=65536 pos_u64=458752
125875:fsstress 19867 [001] 178758.897266:            probe:__iomap_write_end: (c00000000049720c) i_ino=8388710 len_u32=38283 copied_u32=38283 pos_u64=524288

The 8th 64k page now has data written to it in the file offset range [524288,
565247]. So there is a hole in the range [565248, 589823] mapped by the page. 


154474:fsstress 19867 [001] 178758.947596:     probe:iomap_set_range_uptodate: (c000000000495a40) index=8 i_ino=8388710 last=0xf first=0xa

The above event occurs when fsstress invokes a buffered read operation at 10
block of 8th page i.e. file offset 565248. Hence the blocks mapping the file
offset range  [565248, 589823] are marked uptodate in iop->uptodate.


238888:fsstress 19867 [001] 178759.134993: probe:xfs_map_blocks_found_new_map: (c00000000069fefc) blockcount=27 startblock=18446744073709551614 startoff=138 i_ino=8388710 offset_fsb_u64=138 imap_valid_u8=0
238913:fsstress 19867 [001] 178759.135003:               probe:xfs_map_blocks: (c00000000069f87c) blockcount=27 startblock=18446744073709551614 startoff=138 i_ino=8388710 offset_fsb_u64=139 offset_u64=569344
238938:fsstress 19867 [001] 178759.135012:    probe:xfs_map_blocks_imap_valid: (c00000000069f8e0) startoff=138 startblock=18446744073709551614 blockcount=27 i_ino=8388710 offset_fsb_u64=139 offset_u64=569344 imap_valid_u8=1
238963:fsstress 19867 [001] 178759.135054:  probe:xfs_map_blocks_imap_valid_1: (c00000000069f93c) startoff=138 startblock=18446744073709551614 blockcount=27 i_ino=8388710 offset_fsb_u64=139 offset_u64=569344 imap_valid_u8=1
238988:fsstress 19867 [001] 178759.135065:               probe:xfs_map_blocks: (c00000000069f87c) blockcount=27 startblock=18446744073709551614 startoff=138 i_ino=8388710 offset_fsb_u64=140 offset_u64=573440

When writing the dirty page which maps the 4k block starting at file offset
565248 (138th block) we would encounter a hole with HOLESTARTBLOCK (i.e. -2)
as the value of startblock. xfs_map_blocks() assigns this imap to
xfs_writepage_ctx->imap and returns. xfs_writepage_map() loops once again
since iop->uptodate has the corresponding bit set.

-- 
chandan
