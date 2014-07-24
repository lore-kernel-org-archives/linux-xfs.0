Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 908487F3F
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 09:23:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1B3B9AC009
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 07:23:13 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Fd3fyOnCOEXflL7x (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 24 Jul 2014 07:23:12 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s6OENAnO016644
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 10:23:11 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s6OENAnS030753
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 10:23:10 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 13/18] xfs: filter out sparse regions from individual inode
	allocation
Date: Thu, 24 Jul 2014 10:23:03 -0400
Message-Id: <1406211788-63206-14-git-send-email-bfoster@redhat.com>
In-Reply-To: <1406211788-63206-1-git-send-email-bfoster@redhat.com>
References: <1406211788-63206-1-git-send-email-bfoster@redhat.com>
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

Inode allocation from an existing record with free inodes traditionally
selects the first inode available according to the ir_free mask. With
sparse inode chunks, the ir_free mask could refer to an unallocated
region. We must mask the unallocated regions out of ir_free before using
it to select a free inode in the chunk.

Create the xfs_inobt_first_free_inode() helper to find the first free
inode available of the allocated regions of the inode chunk.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 166602e..1d74394 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -930,6 +930,27 @@ xfs_inobt_ialloc_bitmap(
 }
 
 /*
+ * Return the offset of the first free inode in the record. If the inode chunk
+ * is sparsely allocated, we convert the record holemask to inode granularity
+ * and mask off the unallocated regions from the inode free mask.
+ */
+STATIC int
+xfs_inobt_first_free_inode(
+	struct xfs_inobt_rec_incore	*rec)
+{
+	xfs_inofree_t	realfree;
+
+	/* if there are no holes, return the first available offset */
+	if (!xfs_inobt_issparse(rec))
+		return xfs_lowbit64(rec->ir_free);
+
+	realfree = xfs_inobt_ialloc_bitmap(rec);
+	realfree &= rec->ir_free;
+
+	return xfs_lowbit64(realfree);
+}
+
+/*
  * Allocate an inode using the inobt-only algorithm.
  */
 STATIC int
@@ -1159,7 +1180,7 @@ newino:
 	}
 
 alloc_inode:
-	offset = xfs_lowbit64(rec.ir_free);
+	offset = xfs_inobt_first_free_inode(&rec);
 	ASSERT(offset >= 0);
 	ASSERT(offset < XFS_INODES_PER_CHUNK);
 	ASSERT((XFS_AGINO_TO_OFFSET(mp, rec.ir_startino) %
@@ -1413,7 +1434,7 @@ xfs_dialloc_ag(
 	if (error)
 		goto error_cur;
 
-	offset = xfs_lowbit64(rec.ir_free);
+	offset = xfs_inobt_first_free_inode(&rec);
 	ASSERT(offset >= 0);
 	ASSERT(offset < XFS_INODES_PER_CHUNK);
 	ASSERT((XFS_AGINO_TO_OFFSET(mp, rec.ir_startino) %
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
