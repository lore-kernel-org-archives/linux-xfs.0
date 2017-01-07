Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:44218 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964810AbdAGK5J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 7 Jan 2017 05:57:09 -0500
From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Subject: Re: [BUG v4.10-rc1] fzero returns EIO on DAX mount
Date: Sat, 7 Jan 2017 10:57:06 +0000
Message-ID: <CO2PR04MB2184684C56DC9BA1A16AF5D586620@CO2PR04MB2184.namprd04.prod.outlook.com>
References: <20170106103239.GY1859@eguan.usersys.redhat.com>
In-Reply-To: <20170106103239.GY1859@eguan.usersys.redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>


Hi all,

I'm debugging=A0the issue from block layer and brd.c code, after initial in=
vestigation brd.c:brd_make_request() seems to be generating the error at br=
d.c:brd_make_request() :-

if (unlikely(bio_op(bio) =3D=3D REQ_OP_DISCARD)) {
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (sector & ((PAGE_SIZE >> SECTOR_SHIFT) -=
 1) ||
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bio->bi_iter.bi_size & ~PAGE_MASK)
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_ERR "ERROR : %s=
 %s %d\n", __FILE__, __func__, __LINE__);
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto io_error;

<--------------------------------------------------------------------------=
--------------------------------------------------------------------->
[ =A0960.726281] ERROR : /home/neo/work/linux-4.10-rc1/drivers/block/brd.c =
brd_make_request 348
[ =A0960.726287] CPU: 3 PID: 13185 Comm: xfs_io Tainted: G =A0 =A0 =A0 =A0 =
=A0 OE =A0 4.10.0-rc1 #4
[ =A0960.726289] Hardware name: Supermicro X10SAE/X10SAE, BIOS 2.0a 05/09/2=
014
[ =A0960.726290] Call Trace:
[ =A0960.726297] =A0dump_stack+0x63/0x87
[ =A0960.726302] =A0brd_make_request+0x18d/0x224 [brd]
[ =A0960.726306] =A0? bio_alloc_bioset+0x1a2/0x2e0
[ =A0960.726310] =A0generic_make_request+0x103/0x210
[ =A0960.726313] =A0submit_bio+0x75/0x150
[ =A0960.726316] =A0submit_bio_wait+0x60/0x90
[ =A0960.726322] =A0blkdev_issue_zeroout+0x77/0xc0
[ =A0960.726327] =A0__dax_zero_page_range+0x9d/0x150
[ =A0960.726332] =A0iomap_zero_range_actor+0x8d/0x1f0
[ =A0960.726337] =A0? iomap_fiemap_actor+0x80/0x80
[ =A0960.726340] =A0iomap_apply+0xb3/0x130
[ =A0960.726345] =A0iomap_zero_range+0x58/0x80
[ =A0960.726349] =A0? iomap_fiemap_actor+0x80/0x80
[ =A0960.726369] =A0ext4_block_zero_page_range+0x334/0x4f0 [ext4]
[ =A0960.726398] =A0? ext4_fallocate+0x498/0x8b0 [ext4]
[ =A0960.726418] =A0ext4_zero_partial_blocks+0xcd/0xe0 [ext4]
[ =A0960.726443] =A0ext4_fallocate+0x4a9/0x8b0 [ext4]
[ =A0960.726449] =A0vfs_fallocate+0x155/0x220
[ =A0960.726454] =A0SyS_fallocate+0x44/0x70
[ =A0960.726459] =A0do_syscall_64+0x67/0x180
[ =A0960.726464] =A0entry_SYSCALL64_slow_path+0x25/0x25
[ =A0960.726466] RIP: 0033:0x7ff1cb1a78da
[ =A0960.726468] RSP: 002b:00007ffd71218f98 EFLAGS: 00000246 ORIG_RAX: 0000=
00000000011d
[ =A0960.726472] RAX: ffffffffffffffda RBX: 0000000000000010 RCX: 00007ff1c=
b1a78da
[ =A0960.726474] RDX: 0000000000000000 RSI: 0000000000000010 RDI: 000000000=
0000003
[ =A0960.726476] RBP: 0000000000e690d0 R08: 00007ff1cb475060 R09: 000000000=
0e6710c
[ =A0960.726477] R10: 0000000000000400 R11: 0000000000000246 R12: 000000000=
0e67100
[ =A0960.726479] R13: 0000000000000001 R14: 0000000000e68940 R15: 000000000=
0e67100
[ =A0960.726492] ERROR ./include/linux/bio.h bio_io_error 419
<--------------------------------------------------------------------------=
--------------------------------------------------------------------->
=20
Give me some time to debug more and come up with the solution.

Regards,
-Chaitanya
 =20
From: Eryu Guan <eguan@redhat.com>
Sent: Friday, January 6, 2017 2:32:39 AM
To: linux-block@vger.kernel.org
Cc: Chaitanya Kulkarni; linux-xfs@vger.kernel.org; linux-ext4@vger.kernel.o=
rg
Subject: [BUG v4.10-rc1] fzero returns EIO on DAX mount
=A0  =20
Hi all,

I hit a regression in my xfstests run on DAX mount with 4.10-rc1 and rc2
kernel, some fzero/fpunch/ftruncate operations start returning EIO, extN
and xfs are all affected. 4.9 kernel is doing well.

This is a simple reproducer:

=A0=A0=A0=A0=A0=A0=A0 modprobe brd rd_size=3D$((1024*1024))
=A0=A0=A0=A0=A0=A0=A0 mkfs -t ext4 -F /dev/ram0
=A0=A0=A0=A0=A0=A0=A0 mount -o dax /dev/ram0 /mnt/ext4
=A0=A0=A0=A0=A0=A0=A0 xfs_io -fc "pwrite 0 1024" -c "fzero 0 1024" /mnt/ext=
4/testfile

The last xfs_io returns:
=A0=A0=A0=A0=A0=A0=A0 wrote 1024/1024 bytes at offset 0
=A0=A0=A0=A0=A0=A0=A0 1 KiB, 1 ops; 0.0000 sec (17.013 KiB/sec and 17.0132 =
ops/sec)
=A0=A0=A0=A0=A0=A0=A0 fallocate: Input/output error

And git bisect pointed the first bad commit to

e73c23ff736e1ea371dfa419d7bf8e77ee53044a
Author: Chaitanya Kulkarni <chaitanya.kulkarni@hgst.com>
Date:=A0=A0 Wed Nov 30 12:28:58 2016 -0800

=A0=A0=A0 block: add async variant of blkdev_issue_zeroout

=A0=A0=A0 Similar to __blkdev_issue_discard this variant allows submitting
=A0=A0=A0 the final bio asynchronously and chaining multiple ranges
=A0=A0=A0 into a single completion.

=A0=A0=A0 Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@hgst.com>
=A0=A0=A0 Reviewed-by: Christoph Hellwig <hch@lst.de>
=A0=A0=A0 Signed-off-by: Jens Axboe <axboe@fb.com>

I've confirmed that "reverting" it fixed all the new test failures, by
"reverting" I mean revert it when it's the top.

A preliminary investigation shows that it's submit_bio_wait() in
blkdev_issue_zeroout() where EIO is returned.

block/blk-lib.c:blkdev_issue_zeroout
=A0=A0=A0=A0=A0=A0=A0 ret =3D __blkdev_issue_zeroout(bdev, sector, nr_sects=
, gfp_mask,=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 &bio,=
 discard);=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0
=A0=A0=A0=A0=A0=A0=A0 if (ret =3D=3D 0 && bio) {=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ret =3D submit_bio_wait(bio);=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 bio_put(bio);=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0
=A0=A0=A0=A0=A0=A0=A0 }

Thanks,
Eryu

P.S. failed xfstests cases

xfs:
generic/008 generic/029 generic/030 generic/074 generic/075 generic/086
generic/091 generic/112 generic/127 generic/135 generic/231 generic/263
generic/392 xfs/071 xfs/190 xfs/229 xfs/290

ext4:
generic/008 generic/075 generic/091 generic/112 generic/127 generic/263

ext2,ext3:
generic/091 generic/127 generic/263
    =
