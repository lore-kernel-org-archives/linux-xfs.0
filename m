Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55020 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751993AbdC0UCN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 27 Mar 2017 16:02:13 -0400
From: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] xfs: Remove obsolete declaration of xfs_buf_get_empty
Date: Mon, 27 Mar 2017 23:01:49 +0300
Message-Id: <1490644909-30636-1-git-send-email-nborisov@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>

This function has been removed ever since at least 3.12-era. No need to
keep its declaration in the header so nuke it.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/xfs/xfs_buf.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 3c867e5a63e1..e1bc1af743fa 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -291,7 +291,6 @@ xfs_buf_readahead(
 	return xfs_buf_readahead_map(target, &map, 1, ops);
 }
 
-struct xfs_buf *xfs_buf_get_empty(struct xfs_buftarg *target, size_t numblks);
 void xfs_buf_set_empty(struct xfs_buf *bp, size_t numblks);
 int xfs_buf_associate_memory(struct xfs_buf *bp, void *mem, size_t length);
 
-- 
2.7.4

