Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 448DEC27C40
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Aug 2023 09:20:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbjHXJTl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Aug 2023 05:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240732AbjHXJTj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Aug 2023 05:19:39 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2740199F
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2023 02:19:04 -0700 (PDT)
Received: from dggpemm100012.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4RWctM4wtXz1L9NN;
        Thu, 24 Aug 2023 17:17:31 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm100012.china.huawei.com (7.185.36.212) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Thu, 24 Aug 2023 17:19:02 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.31; Thu, 24 Aug
 2023 17:19:01 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-xfs@vger.kernel.org>
CC:     <chandan.babu@oracle.com>, <djwong@kernel.org>,
        <kent.overstreet@linux.dev>, <dchinner@redhat.com>,
        <yangyingliang@huawei.com>
Subject: [PATCH -next] xfs: remove unnecessary check in xfile_create()
Date:   Thu, 24 Aug 2023 17:15:37 +0800
Message-ID: <20230824091537.1072956-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

shmem_file_setup() returns ERR_PTR() when it fails,
so remove the unnecessary null pointer check.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 fs/xfs/scrub/xfile.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
index d98e8e77c684..71779d81cad7 100644
--- a/fs/xfs/scrub/xfile.c
+++ b/fs/xfs/scrub/xfile.c
@@ -70,8 +70,6 @@ xfile_create(
 		return -ENOMEM;
 
 	xf->file = shmem_file_setup(description, isize, 0);
-	if (!xf->file)
-		goto out_xfile;
 	if (IS_ERR(xf->file)) {
 		error = PTR_ERR(xf->file);
 		goto out_xfile;
-- 
2.25.1

