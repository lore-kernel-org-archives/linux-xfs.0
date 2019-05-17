Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:8202 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725933AbfEQCnf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 May 2019 22:43:35 -0400
From: Hou Tao <houtao1@huawei.com>
Subject: Question about commit b450672fb66b ("iomap: sub-block dio needs to
 zeroout beyond EOF")
Message-ID: <8b1ba3a1-7ecc-6e1f-c944-26a51baa9747@huawei.com>
Date: Fri, 17 May 2019 10:41:44 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, david@fromorbit.com
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>

Hi,

I don't understand why the commit b450672fb66b ("iomap: sub-block dio needs to zeroout beyond EOF") is needed here:

diff --git a/fs/iomap.c b/fs/iomap.c
index 72f3864a2e6b..77c214194edf 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -1677,7 +1677,14 @@ iomap_dio_bio_actor(struct inode *inode, loff_t pos, loff_t length,
                dio->submit.cookie = submit_bio(bio);
        } while (nr_pages);

-       if (need_zeroout) {
+       /*
+        * We need to zeroout the tail of a sub-block write if the extent type
+        * requires zeroing or the write extends beyond EOF. If we don't zero
+        * the block tail in the latter case, we can expose stale data via mmap
+        * reads of the EOF block.
+        */
+       if (need_zeroout ||
+           ((dio->flags & IOMAP_DIO_WRITE) && pos >= i_size_read(inode))) {
                /* zero out from the end of the write to the end of the block */
                pad = pos & (fs_block_size - 1);
                if (pad)

If need_zeroout is false, it means the block neither is a unwritten block nor
a newly-mapped block, but that also means the block must had been a unwritten block
or a newly-mapped block before this write, so the block must have been zeroed, correct ?

It also introduces unnecessary sub-block zeroing if we repeat the same sub-block write.

I also have tried to reproduce the problem by using fsx as noted in the commit message,
but cann't reproduce it. Maybe I do it in the wrong way:

$ ./ltp/fsx -d -g H -H -z -C -I -w 1024 -F -r 1024 -t 4096 -Z /tmp/xfs/fsx

The XFS related with /tmp/xfs is formatted with "-b size=4096". I also try "-b size=1024",
but still no luck.

Could someone explain the scenario in which the extra block zeroing is needed ? Thanks.

Regards,
Tao
