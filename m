Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 25DFB7F4E
	for <xfs@oss.sgi.com>; Sat, 12 Apr 2014 02:59:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 14156304062
	for <xfs@oss.sgi.com>; Sat, 12 Apr 2014 00:59:57 -0700 (PDT)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id LCFQXepG2Sw80PRy (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 12 Apr 2014 00:59:56 -0700 (PDT)
Received: from [83.175.99.196] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1WYsqw-0006GG-Vp
	for xfs@oss.sgi.com; Sat, 12 Apr 2014 07:59:55 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/9] xfs: handle duplicate entries in xfs_mru_cache_insert
Date: Sat, 12 Apr 2014 10:01:57 +0200
Message-Id: <1397289723-26243-4-git-send-email-hch@lst.de>
In-Reply-To: <1397289723-26243-1-git-send-email-hch@lst.de>
References: <1397289723-26243-1-git-send-email-hch@lst.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

The radix tree code can detect and reject duplicate keys at insert
time.  Make xfs_mru_cache_insert handle this case so that future
changes to the filestream allocator can take advantage of this.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_mru_cache.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_mru_cache.c b/fs/xfs/xfs_mru_cache.c
index 4aff563..4aa3166 100644
--- a/fs/xfs/xfs_mru_cache.c
+++ b/fs/xfs/xfs_mru_cache.c
@@ -443,6 +443,7 @@ xfs_mru_cache_insert(
 	void		*value)
 {
 	xfs_mru_cache_elem_t *elem;
+	int error;
 
 	ASSERT(mru && mru->lists);
 	if (!mru || !mru->lists)
@@ -453,8 +454,8 @@ xfs_mru_cache_insert(
 		return ENOMEM;
 
 	if (radix_tree_preload(GFP_KERNEL)) {
-		kmem_zone_free(xfs_mru_elem_zone, elem);
-		return ENOMEM;
+		error = ENOMEM;
+		goto out_free_item;
 	}
 
 	INIT_LIST_HEAD(&elem->list_node);
@@ -463,13 +464,20 @@ xfs_mru_cache_insert(
 
 	spin_lock(&mru->lock);
 
-	radix_tree_insert(&mru->store, key, elem);
+	error = -radix_tree_insert(&mru->store, key, elem);
 	radix_tree_preload_end();
+	if (error) {
+		spin_unlock(&mru->lock);
+		goto out_free_item;
+	}
 	_xfs_mru_cache_list_insert(mru, elem);
 
 	spin_unlock(&mru->lock);
 
 	return 0;
+out_free_item:
+	kmem_zone_free(xfs_mru_elem_zone, elem);
+	return error;
 }
 
 /*
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
