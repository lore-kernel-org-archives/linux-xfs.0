Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from m50-138.163.com ([123.125.50.138]:56640 "EHLO m50-138.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757801AbdLRLby (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Dec 2017 06:31:54 -0500
From: "Vaughan" <cxt9401@163.com>
Subject: How to get disk-location from "metadata I/O error"?
Date: Mon, 18 Dec 2017 19:16:33 +0800
Message-ID: <002e01d377f1$a986be00$fc943a00$@163.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: zh-cn
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi All,


I encounter the following output from time to time. Since xfs is built on
our own virtual disk, it's more likely that our vdisk is buggy.
Can anyone tell me how to figure out the on-disk location given the block
number? Does it follow the following formula?
On-disk location = <block number from metadata I/O error> * <bsize of data
section of xfs_info>
However, the result from the above formula suggests the metadata is out of
range of my disk, confused...

Another question is the corrupted metadata buffer always start with 8 bytes
of '8' character. Does xfs use '8' as any magic label?
I'm using centos-7.2, kernel 3.10.0-327.el7.


XFS (md_d27): Metadata corruption detected at xfs_agf_read_verify+0x70/0x120
[xfs], block 0x1e8ffa08
XFS (md_d27): Unmount and run xfs_repair
XFS (md_d27): First 64 bytes of corrupted metadata buffer:
ffff88042fc69000: 38 38 38 38 38 38 38 38 00 00 00 00 00 00 00 00
88888888........
ffff88042fc69010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
................
ffff88042fc69020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
................
ffff88042fc69030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
................
XFS (md_d27): metadata I/O error: block 0x1e8ffa08
("xfs_trans_read_buf_map") error 117 numblks 8
XFS (md_d27): page discard on page ffffea000b34f900, inode 0x23e, offset
362840064.
XFS (md_d27): Metadata corruption detected at xfs_agf_read_verify+0x70/0x120
[xfs], block 0x1e8ffa08
XFS (md_d27): Unmount and run xfs_repair

# xfs_info /mnt/md/27
meta-data=/dev/md_d27            isize=256    agcount=32, agsize=10682336
blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=0        finobt=0
data     =                       bsize=4096   blocks=341834752, imaxpct=5
         =                       sunit=32     swidth=64 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
log      =internal               bsize=4096   blocks=166911, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

#cat /proc/partition
253     1728 1367342592 md_d27


-Vaughan

