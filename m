Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45758 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732084AbfHHI2A (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 8 Aug 2019 04:28:00 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 3/9] ecryptfs: drop direct calls to ->bmap
Date: Thu,  8 Aug 2019 10:27:38 +0200
Message-Id: <20190808082744.31405-4-cmaiolino@redhat.com>
In-Reply-To: <20190808082744.31405-1-cmaiolino@redhat.com>
References: <20190808082744.31405-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: hch@lst.de, adilger@dilger.ca, jaegeuk@kernel.org, darrick.wong@oracle.com, miklos@szeredi.hu, rpeterso@redhat.com, linux-xfs@vger.kernel.org

Replace direct ->bmap calls by bmap() method.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---

 fs/ecryptfs/mmap.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/fs/ecryptfs/mmap.c b/fs/ecryptfs/mmap.c
index cffa0c1ec829..019572c6b39a 100644
--- a/fs/ecryptfs/mmap.c
+++ b/fs/ecryptfs/mmap.c
@@ -524,16 +524,12 @@ static int ecryptfs_write_end(struct file *file,
 
 static sector_t ecryptfs_bmap(struct address_space *mapping, sector_t block)
 {
-	int rc = 0;
-	struct inode *inode;
-	struct inode *lower_inode;
-
-	inode = (struct inode *)mapping->host;
-	lower_inode = ecryptfs_inode_to_lower(inode);
-	if (lower_inode->i_mapping->a_ops->bmap)
-		rc = lower_inode->i_mapping->a_ops->bmap(lower_inode->i_mapping,
-							 block);
-	return rc;
+	struct inode *lower_inode = ecryptfs_inode_to_lower(mapping->host);
+	int ret = bmap(lower_inode, &block);
+
+	if (ret)
+		return 0;
+	return block;
 }
 
 const struct address_space_operations ecryptfs_aops = {
-- 
2.20.1
