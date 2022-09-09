Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1457ECAAD3
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Sep 2022 06:57:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbiIIG5F (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Sep 2022 02:57:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231234AbiIIG5D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Sep 2022 02:57:03 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A1FC13B125;
        Thu,  8 Sep 2022 23:56:57 -0700 (PDT)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MP6DC5fyKznVCk;
        Fri,  9 Sep 2022 14:54:19 +0800 (CST)
Received: from cgs.huawei.com (10.244.148.83) by
 kwepemi500012.china.huawei.com (7.221.188.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 9 Sep 2022 14:56:55 +0800
From:   Gaosheng Cui <cuigaosheng1@huawei.com>
To:     <djwong@kernel.org>, <cuigaosheng1@huawei.com>
CC:     <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] xfs: remove xfs_setattr_time() declaration
Date:   Fri, 9 Sep 2022 14:56:54 +0800
Message-ID: <20220909065654.1156896-1-cuigaosheng1@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.244.148.83]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemi500012.china.huawei.com (7.221.188.12)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_setattr_time() has been removed since
commit e014f37db1a2 ("xfs: use setattr_copy to set vfs inode
attributes"), so remove it.

Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
---
 fs/xfs/xfs_iops.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_iops.h b/fs/xfs/xfs_iops.h
index cb5fc68c9ea0..e570dcb5df8d 100644
--- a/fs/xfs/xfs_iops.h
+++ b/fs/xfs/xfs_iops.h
@@ -13,7 +13,6 @@ extern const struct file_operations xfs_dir_file_operations;
 
 extern ssize_t xfs_vn_listxattr(struct dentry *, char *data, size_t size);
 
-extern void xfs_setattr_time(struct xfs_inode *ip, struct iattr *iattr);
 int xfs_vn_setattr_size(struct user_namespace *mnt_userns,
 		struct dentry *dentry, struct iattr *vap);
 
-- 
2.25.1

