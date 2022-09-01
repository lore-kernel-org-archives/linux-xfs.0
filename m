Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2C43ECAAD3
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Sep 2022 10:54:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233583AbiIAKy2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Sep 2022 06:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233399AbiIAKy1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Sep 2022 06:54:27 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B9D6130A12;
        Thu,  1 Sep 2022 03:54:27 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MJHrh6JYJz1N7k9;
        Thu,  1 Sep 2022 18:50:44 +0800 (CST)
Received: from huawei.com (10.175.103.91) by dggpemm500022.china.huawei.com
 (7.185.36.162) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 1 Sep
 2022 18:54:25 +0800
From:   Zeng Heng <zengheng4@huawei.com>
To:     <djwong@kernel.org>
CC:     <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <zengheng4@huawei.com>
Subject: [PATCH -next] xfs: missing space in xfs trace log
Date:   Thu, 1 Sep 2022 19:02:05 +0800
Message-ID: <20220901110205.565167-1-zengheng4@huawei.com>
X-Mailer: git-send-email 2.25.1
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

Add space between arguments would help someone
to locate the key words they want, so break
quoted strings at a space character.

Such as below:
[Before]
kworker/1:0-280     [001] .....   600.782135: xfs_bunmap:
dev 7:0 ino 0x85 disize 0x0 fileoff 0x0 fsbcount 0x400000001fffffflags ATTRFORK ...

[After]
kworker/1:2-564     [001] ..... 23817.906160: xfs_bunmap:
dev 7:0 ino 0x85 disize 0x0 fileoff 0x0 fsbcount 0x400000001fffff flags ATTRFORK ...

Signed-off-by: Zeng Heng <zengheng4@huawei.com>
---
 fs/xfs/xfs_trace.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index f9057af6e0c8..cb7c81ba7fa3 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1170,7 +1170,7 @@ DECLARE_EVENT_CLASS(xfs_dqtrx_class,
 		__entry->ino_res_used = qtrx->qt_ino_res_used;
 		__entry->icount_delta = qtrx->qt_icount_delta;
 	),
-	TP_printk("dev %d:%d dquot id 0x%x type %s flags %s"
+	TP_printk("dev %d:%d dquot id 0x%x type %s flags %s "
 		  "blk_res %llu bcount_delta %lld delbcnt_delta %lld "
 		  "rtblk_res %llu rtblk_res_used %llu rtbcount_delta %lld delrtb_delta %lld "
 		  "ino_res %llu ino_res_used %llu icount_delta %lld",
@@ -1602,7 +1602,7 @@ TRACE_EVENT(xfs_bunmap,
 		__entry->caller_ip = caller_ip;
 		__entry->flags = flags;
 	),
-	TP_printk("dev %d:%d ino 0x%llx disize 0x%llx fileoff 0x%llx fsbcount 0x%llx"
+	TP_printk("dev %d:%d ino 0x%llx disize 0x%llx fileoff 0x%llx fsbcount 0x%llx "
 		  "flags %s caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
-- 
2.25.1

