Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:58698 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730044AbfAUPXe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Jan 2019 10:23:34 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/2] orangefs: don't reinitialize result_mask in ->getattr
Date: Mon, 21 Jan 2019 16:23:25 +0100
Message-Id: <20190121152326.9954-2-hch@lst.de>
In-Reply-To: <20190121152326.9954-1-hch@lst.de>
References: <20190121152326.9954-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>, Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, devel@lists.orangefs.org

The caller already initializes it to the basic stats.  Just
clear not supported default bits where needed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/orangefs/inode.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/orangefs/inode.c b/fs/orangefs/inode.c
index f038235c64bd..c3334eca18c7 100644
--- a/fs/orangefs/inode.c
+++ b/fs/orangefs/inode.c
@@ -261,11 +261,8 @@ int orangefs_getattr(const struct path *path, struct kstat *stat,
 		generic_fillattr(inode, stat);
 
 		/* override block size reported to stat */
-		if (request_mask & STATX_SIZE)
-			stat->result_mask = STATX_BASIC_STATS;
-		else
-			stat->result_mask = STATX_BASIC_STATS &
-			    ~STATX_SIZE;
+		if (!(request_mask & STATX_SIZE))
+			stat->result_mask &= ~STATX_SIZE;
 
 		stat->attributes_mask = STATX_ATTR_IMMUTABLE |
 		    STATX_ATTR_APPEND;
-- 
2.20.1
