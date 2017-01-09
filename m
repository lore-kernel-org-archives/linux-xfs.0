Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33346 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1162773AbdAIPki (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jan 2017 10:40:38 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 32/32] xfs: fix max_retries _show and _store functions
Date: Mon,  9 Jan 2017 16:39:03 +0100
Message-Id: <1483976343-661-33-git-send-email-hch@lst.de>
In-Reply-To: <1483976343-661-1-git-send-email-hch@lst.de>
References: <1483976343-661-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cmaiolino@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>

From: Carlos Maiolino <cmaiolino@redhat.com>

commit ff97f2399edac1e0fb3fa7851d5fbcbdf04717cf upstream.

max_retries _show and _store functions should test against cfg->max_retries,
not cfg->retry_timeout

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_sysfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index 276d302..de6195e 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -396,7 +396,7 @@ max_retries_show(
 	int		retries;
 	struct xfs_error_cfg *cfg = to_error_cfg(kobject);
 
-	if (cfg->retry_timeout == XFS_ERR_RETRY_FOREVER)
+	if (cfg->max_retries == XFS_ERR_RETRY_FOREVER)
 		retries = -1;
 	else
 		retries = cfg->max_retries;
@@ -422,7 +422,7 @@ max_retries_store(
 		return -EINVAL;
 
 	if (val == -1)
-		cfg->retry_timeout = XFS_ERR_RETRY_FOREVER;
+		cfg->max_retries = XFS_ERR_RETRY_FOREVER;
 	else
 		cfg->max_retries = val;
 	return count;
-- 
2.1.4

