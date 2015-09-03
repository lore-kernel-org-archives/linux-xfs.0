Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9AA9D7F66
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2015 04:58:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8BD4F304048
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2015 02:58:18 -0700 (PDT)
Received: from youngberry.canonical.com (youngberry.canonical.com
	[91.189.89.112]) by cuda.sgi.com with ESMTP id 7h6onvzuq7J5cgd1
	for <xfs@oss.sgi.com>; Thu, 03 Sep 2015 02:58:16 -0700 (PDT)
From: Colin King <colin.king@canonical.com>
Subject: [PATCH] xfs: fix null pointer dereference when mapping is NULL
Date: Thu,  3 Sep 2015 10:57:40 +0100
Message-Id: <1441274260-10120-1-git-send-email-colin.king@canonical.com>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com
Cc: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

xfs_vm_set_page_dirty checks to see if mapping is NULL however
before this unlikely check it already dereferenced mapping when
initializing inode. Move the inode initialization after the mapping
null check to avoid a potential null pointer dereference.

Fixes: 22e757a49cf0 ("xfs: don't dirty buffers beyond EOF")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/xfs/xfs_aops.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index c77499b..d15ae85 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1935,7 +1935,7 @@ xfs_vm_set_page_dirty(
 	struct page		*page)
 {
 	struct address_space	*mapping = page->mapping;
-	struct inode		*inode = mapping->host;
+	struct inode		*inode;
 	loff_t			end_offset;
 	loff_t			offset;
 	int			newly_dirty;
@@ -1944,6 +1944,7 @@ xfs_vm_set_page_dirty(
 	if (unlikely(!mapping))
 		return !TestSetPageDirty(page);
 
+	inode = mapping->host;
 	end_offset = i_size_read(inode);
 	offset = page_offset(page);
 
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
