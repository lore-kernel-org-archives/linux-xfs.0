Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75EC0C433E6
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 08:41:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 399C864F68
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 08:41:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233024AbhBCIlK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Feb 2021 03:41:10 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:12012 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233001AbhBCIk6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Feb 2021 03:40:58 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DVw7d1cs9zjJYJ;
        Wed,  3 Feb 2021 16:38:37 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.498.0; Wed, 3 Feb 2021 16:39:44 +0800
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
To:     <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Shaokun Zhang <zhangshaokun@hisilicon.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH -next] xfs: Fix unused variable 'mp' warning
Date:   Wed, 3 Feb 2021 16:39:18 +0800
Message-ID: <1612341558-22171-1-git-send-email-zhangshaokun@hisilicon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

There is a warning on arm64 platform:
  CC [M]  fs/xfs/xfs_ioctl32.o
fs/xfs/xfs_ioctl32.c: In function ‘xfs_file_compat_ioctl’:
fs/xfs/xfs_ioctl32.c:441:20: warning: unused variable ‘mp’ [-Wunused-variable]
  441 |  struct xfs_mount *mp = ip->i_mount;
      |                    ^~
  LD [M]  fs/xfs/xfs.o

Fix this warning.

Fixes: f736d93d76d3 ("xfs: support idmapped mounts")
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <christian.brauner@ubuntu.com> 
Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
---
 fs/xfs/xfs_ioctl32.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 926427b19573..fd590c0b5d3b 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -438,7 +438,6 @@ xfs_file_compat_ioctl(
 {
 	struct inode		*inode = file_inode(filp);
 	struct xfs_inode	*ip = XFS_I(inode);
-	struct xfs_mount	*mp = ip->i_mount;
 	void			__user *arg = compat_ptr(p);
 	int			error;
 
@@ -446,6 +445,8 @@ xfs_file_compat_ioctl(
 
 	switch (cmd) {
 #if defined(BROKEN_X86_ALIGNMENT)
+	struct xfs_mount	*mp = ip->i_mount;
+
 	case XFS_IOC_ALLOCSP_32:
 	case XFS_IOC_FREESP_32:
 	case XFS_IOC_ALLOCSP64_32:
-- 
2.7.4

