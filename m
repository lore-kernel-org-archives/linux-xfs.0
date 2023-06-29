Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FA8FEB64D7
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jun 2023 02:20:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbjF2CU6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jun 2023 22:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232023AbjF2CUe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Jun 2023 22:20:34 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB92D10FF
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jun 2023 19:20:32 -0700 (PDT)
Received: from dggpemm500014.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Qs2Dc6HxyzLn3D;
        Thu, 29 Jun 2023 10:18:24 +0800 (CST)
Received: from [10.174.177.211] (10.174.177.211) by
 dggpemm500014.china.huawei.com (7.185.36.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 29 Jun 2023 10:20:30 +0800
Message-ID: <182e9ac9-933f-ed8e-1f5a-9ffc2d730eb7@huawei.com>
Date:   Thu, 29 Jun 2023 10:20:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
From:   Wu Guanghao <wuguanghao3@huawei.com>
Subject: [PATCH V2] mkfs.xfs: fix segmentation fault caused by accessing a
 null pointer
To:     <cem@kernel.org>, <djwong@kernel.org>, <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.211]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500014.china.huawei.com (7.185.36.153)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We encountered a segfault while testing the mkfs.xfs + iscsi.

(gdb) bt
#0 libxfs_log_sb (tp=0xaaaafaea0630) at xfs_sb.c:810
#1 0x0000aaaaca991468 in __xfs_trans_commit (tp=<optimized out>, tp@entry=0xaaaafaea0630, regrant=regrant@entry=true) at trans.c:995
#2 0x0000aaaaca991790 in libxfs_trans_roll (tpp=tpp@entry=0xfffffe1f3018) at trans.c:103
#3 0x0000aaaaca9bcde8 in xfs_dialloc_roll (agibp=0xaaaafaea2fa0, tpp=0xfffffe1f31c8) at xfs_ialloc.c:1561
#4 xfs_dialloc_try_ag (ok_alloc=true, new_ino=<synthetic pointer>, parent=0, pag=0xaaaafaea0210, tpp=0xfffffe1f31c8) at xfs_ialloc.c:1698
#5 xfs_dialloc (tpp=tpp@entry=0xfffffe1f31c8, parent=0, mode=mode@entry=16877, new_ino=new_ino@entry=0xfffffe1f3128) at xfs_ialloc.c:1776
#6 0x0000aaaaca9925b0 in libxfs_dir_ialloc (tpp=tpp@entry=0xfffffe1f31c8, dp=dp@entry=0x0, mode=mode@entry=16877, nlink=nlink@entry=1, rdev=rdev@entry=0, cr=cr@entry=0xfffffe1f31d0,
    fsx=fsx@entry=0xfffffe1f36a4, ipp=ipp@entry=0xfffffe1f31c0) at util.c:525
#7 0x0000aaaaca988fac in parseproto (mp=0xfffffe1f36c8, pip=0x0, fsxp=0xfffffe1f36a4, pp=0xfffffe1f3370, name=0x0) at proto.c:552
#8 0x0000aaaaca9867a4 in main (argc=<optimized out>, argv=<optimized out>) at xfs_mkfs.c:4217

(gdb) p bp
$1 = 0x0

```
void
xfs_log_sb(
        struct xfs_trans        *tp)
{
        // iscsi offline
        ...
        // failed to read sb, bp = NULL
        struct xfs_buf          *bp = xfs_trans_getsb(tp);
        ...
}
```

When writing data to sb, if the device is abnormal at this time,
the bp may be empty. Using it without checking will result in
a segfault.

So it's necessary to ensure that the superblock has been cached.

Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
---
 mkfs/xfs_mkfs.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 7b3c2304..8d0ec4b5 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -4406,6 +4406,15 @@ main(
                exit(1);
        }

+       /*
+        *  Cached superblock to ensure that xfs_trans_getsb() will not return NULL.
+        */
+       buf = libxfs_getsb(mp);
+       if (!buf || buf->b_error) {
+               fprintf(stderr, _("%s: read superblock failed, err=%d\n"),
+                               progname, !buf ? EIO : -buf->b_error);
+               exit(1);
+       }
        /*
         * Initialise the freespace freelists (i.e. AGFLs) in each AG.
         */
@@ -4433,6 +4442,7 @@ main(
         * Need to drop references to inodes we still hold, first.
         */
        libxfs_rtmount_destroy(mp);
+       libxfs_buf_relse(buf);
        libxfs_bcache_purge();

        /*
--
2.27.0
