Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F373C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jan 2022 07:15:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378883AbiAUHPM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jan 2022 02:15:12 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:60892 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1378907AbiAUHPH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jan 2022 02:15:07 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R621e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=hongnan.li@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0V2PmL9d_1642749306;
Received: from localhost(mailfrom:hongnan.li@linux.alibaba.com fp:SMTPD_---0V2PmL9d_1642749306)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 21 Jan 2022 15:15:06 +0800
From:   hongnanli <hongnan.li@linux.alibaba.com>
To:     linux-xfs@vger.kernel.org
Cc:     djwong@kernel.org
Subject: [PATCH] fs/xfs: fix comments mentioning i_mutex
Date:   Fri, 21 Jan 2022 15:15:05 +0800
Message-Id: <20220121071505.31930-1-hongnan.li@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

inode->i_mutex has been replaced with inode->i_rwsem long ago. Fix
comments still mentioning i_mutex.

Signed-off-by: hongnanli <hongnan.li@linux.alibaba.com>
---
 fs/xfs/xfs_acl.c   | 2 +-
 fs/xfs/xfs_iomap.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 5c52ee869272..b02c83f8b8c4 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -22,7 +22,7 @@
 
 /*
  * Locking scheme:
- *  - all ACL updates are protected by inode->i_mutex, which is taken before
+ *  - all ACL updates are protected by inode->i_rwsem, which is taken before
  *    calling into this file.
  */
 
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index e552ce541ec2..288a5cdcaa61 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1126,7 +1126,7 @@ xfs_buffered_write_iomap_end(
 	 * Trim delalloc blocks if they were allocated by this write and we
 	 * didn't manage to write the whole range.
 	 *
-	 * We don't need to care about racing delalloc as we hold i_mutex
+	 * We don't need to care about racing delalloc as we hold i_rwsem
 	 * across the reserve/allocate/unreserve calls. If there are delalloc
 	 * blocks in the range, they are ours.
 	 */
-- 
2.19.1.6.gb485710b

