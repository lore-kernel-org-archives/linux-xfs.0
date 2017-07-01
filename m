Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from a4-6.smtp-out.eu-west-1.amazonses.com ([54.240.4.6]:50438 "EHLO
        a4-6.smtp-out.eu-west-1.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751680AbdGAA0K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Jun 2017 20:26:10 -0400
From: Martin Raiber <martin@urbackup.org>
Subject: Large file with a lot of extents: Memory allocation failure
Message-ID: <0102015cfb8a5638-65ee1c03-edfb-4c2d-880b-691fac15f4e6-000000@eu-west-1.amazonses.com>
Date: Sat, 1 Jul 2017 00:26:06 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi,

this came up in the mailing list before and I think devs are aware of
this issue. I just wanted to add a data point to this issue. Stack
traces point to xfs_iext_realloc_indirect same as e.g.
http://oss.sgi.com/archives/xfs/2015-07/msg00075.html .
I created a large file (2TB) then proceeded to punch a lot of holes into
it. After a while XFS hangs with e.g.

 > possible memory allocation deadlock size 131088 in kmem_realloc
(mode:0x2400240)

Kernel version is mainline 4.9.22. Memory is horribly fragmented by
other things (user space program that has fluctuating memory allocs,
bcache, blk-mq, btrfs).

Where I guess this issue would be a possible blocker would be with my
backup software UrBackup. With ZFS/btrfs it can save disk images in a
raw file, then to create an incremental image backup it snapshots that
and changes it to reflect the current state, including punching holes
into the raw file where there is unused file system space.
With reflinks now in XFS, it would be possible to add XFS to the list of
file systems able to perform this kind of image backup, only I fear it
would then hit the memory allocation deadlock issue when free space
changes a lot (which it often does) and the volume is larger on the client.


Regards,
Martin Raiber


