Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A35E9ECAAD1
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Aug 2022 13:32:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbiH3NcB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Aug 2022 09:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbiH3NcA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Aug 2022 09:32:00 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED8A9D5DE9;
        Tue, 30 Aug 2022 06:31:58 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MH7QY6dq2zYcqv;
        Tue, 30 Aug 2022 21:27:33 +0800 (CST)
Received: from huawei.com (10.175.103.91) by dggpemm500022.china.huawei.com
 (7.185.36.162) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 30 Aug
 2022 21:31:56 +0800
From:   Zeng Heng <zengheng4@huawei.com>
To:     <djwong@kernel.org>
CC:     <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <zengheng4@huawei.com>
Subject: [PATCH -next 2/2] xfs: simplify if-else condition in xfs_reflink_trim_around_shared
Date:   Tue, 30 Aug 2022 21:39:39 +0800
Message-ID: <20220830133939.2726749-3-zengheng4@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220830133939.2726749-1-zengheng4@huawei.com>
References: <20220830133939.2726749-1-zengheng4@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500022.china.huawei.com (7.185.36.162)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

"else" is not generally useful after a return,
so remove it for clean code.

There is no logical changes.

Signed-off-by: Zeng Heng <zengheng4@huawei.com>
---
 fs/xfs/xfs_reflink.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 251f20ddd368..93bdd25680bc 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -200,7 +200,9 @@ xfs_reflink_trim_around_shared(
 	if (fbno == NULLAGBLOCK) {
 		/* No shared blocks at all. */
 		return 0;
-	} else if (fbno == agbno) {
+	}
+
+	if (fbno == agbno) {
 		/*
 		 * The start of this extent is shared.  Truncate the
 		 * mapping at the end of the shared region so that a
@@ -210,16 +212,16 @@ xfs_reflink_trim_around_shared(
 		irec->br_blockcount = flen;
 		*shared = true;
 		return 0;
-	} else {
-		/*
-		 * There's a shared extent midway through this extent.
-		 * Truncate the mapping at the start of the shared
-		 * extent so that a subsequent iteration starts at the
-		 * start of the shared region.
-		 */
-		irec->br_blockcount = fbno - agbno;
-		return 0;
 	}
+
+	/*
+	 * There's a shared extent midway through this extent.
+	 * Truncate the mapping at the start of the shared
+	 * extent so that a subsequent iteration starts at the
+	 * start of the shared region.
+	 */
+	irec->br_blockcount = fbno - agbno;
+	return 0;
 }
 
 int
-- 
2.25.1

