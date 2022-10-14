Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 177BAC433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Oct 2022 08:41:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbiJNIlk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Oct 2022 04:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiJNIlj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Oct 2022 04:41:39 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C70C1C39CB
        for <linux-xfs@vger.kernel.org>; Fri, 14 Oct 2022 01:41:37 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Mpfrf1ZNZzVj5J;
        Fri, 14 Oct 2022 16:37:06 +0800 (CST)
Received: from dggpemm500014.china.huawei.com (7.185.36.153) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 14 Oct 2022 16:41:35 +0800
Received: from [10.174.177.211] (10.174.177.211) by
 dggpemm500014.china.huawei.com (7.185.36.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 14 Oct 2022 16:41:35 +0800
Message-ID: <b359751c-2397-bcd1-9065-583afb2f93ef@huawei.com>
Date:   Fri, 14 Oct 2022 16:41:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
To:     <cem@kernel.org>
CC:     <linux-xfs@vger.kernel.org>,
        "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
From:   Wu Guanghao <wuguanghao3@huawei.com>
Subject: [PATCH] mkfs: acquire flock before modifying the device superblock
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.211]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500014.china.huawei.com (7.185.36.153)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We noticed that systemd has an issue about symlink unreliable caused by
formatting filesystem and systemd operating on same device.
Issue Link: https://github.com/systemd/systemd/issues/23746

According to systemd doc, a BSD flock needs to be acquired before
formatting the device.
Related Link: https://systemd.io/BLOCK_DEVICE_LOCKING/

So we acquire flock after opening the device but before
writing superblock.

Signed-off-by: wuguanghao <wuguanghao3@huawei.com>
---
 mkfs/xfs_mkfs.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 9dd0e79c..b83cb043 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -13,6 +13,7 @@
 #include "libfrog/crc32cselftest.h"
 #include "proto.h"
 #include <ini.h>
+#include <sys/file.h>

 #define TERABYTES(count, blog) ((uint64_t)(count) << (40 - (blog)))
 #define GIGABYTES(count, blog) ((uint64_t)(count) << (30 - (blog)))
@@ -2758,6 +2759,30 @@ _("log stripe unit (%d bytes) is too large (maximum is 256KiB)\n"

 }

+static void
+lock_device(dev_t dev, int flag, char *name)
+{
+       int fd = libxfs_device_to_fd(dev);
+       int readonly = flag & LIBXFS_ISREADONLY;
+
+       if (!readonly && fd > 0)
+               if (flock(fd, LOCK_EX) != 0) {
+                       fprintf(stderr, "%s: failed to get lock.\n", name);
+                       exit(1);
+               }
+}
+
+static void
+lock_devices(struct libxfs_xinit *xi)
+{
+       if (!xi->disfile)
+               lock_device(xi->ddev, xi->dcreat, xi->dname);
+       if (xi->logdev && !xi->lisfile)
+               lock_device(xi->logdev, xi->lcreat, xi->logname);
+       if (xi->rtdev && !xi->risfile)
+               lock_device(xi->rtdev, xi->rcreat, xi->rtname);
+}
+
 static void
 open_devices(
        struct mkfs_params      *cfg,
@@ -4208,6 +4233,7 @@ main(
         * Open and validate the device configurations
         */
        open_devices(&cfg, &xi);
+       lock_devices(&xi);
        validate_overwrite(dfile, force_overwrite);
        validate_datadev(&cfg, &cli);
        validate_logdev(&cfg, &cli, &logfile);
--
2.27.0
