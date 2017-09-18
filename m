Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:36567 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753887AbdIRMB6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2017 08:01:58 -0400
From: Colin King <colin.king@canonical.com>
Subject: [PATCH] xfs: remove redundant re-initialization of total_nr_pages
Date: Mon, 18 Sep 2017 13:01:57 +0100
Message-Id: <20170918120157.30134-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Variable total_nr_pages is being initialized and then updated with
the same value, this latter assignment is redundant and can be
removed.  Cleans up clang build warning:

Value stored to 'total_nr_pages' during its initialization is never read

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/xfs/xfs_buf.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index da14658da310..2f97c12ca75e 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1258,8 +1258,6 @@ xfs_buf_ioapply_map(
 	int		size;
 	int		offset;
 
-	total_nr_pages = bp->b_page_count;
-
 	/* skip the pages in the buffer before the start offset */
 	page_index = 0;
 	offset = *buf_offset;
-- 
2.14.1

