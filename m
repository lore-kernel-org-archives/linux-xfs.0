Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 415597F47
	for <xfs@oss.sgi.com>; Mon,  3 Nov 2014 10:35:49 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0F435304039
	for <xfs@oss.sgi.com>; Mon,  3 Nov 2014 08:35:49 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id sMUWLEiXjWAkaYxP (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 03 Nov 2014 08:35:48 -0800 (PST)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sA3GZkaa014509
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Mon, 3 Nov 2014 11:35:47 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id sA3GCSYH028189
	for <xfs@oss.sgi.com>; Mon, 3 Nov 2014 11:12:28 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 11/17] xfs: filter out sparse regions from individual inode
	allocation
Date: Mon,  3 Nov 2014 11:12:20 -0500
Message-Id: <1415031146-9107-12-git-send-email-bfoster@redhat.com>
In-Reply-To: <1415031146-9107-1-git-send-email-bfoster@redhat.com>
References: <1415031146-9107-1-git-send-email-bfoster@redhat.com>
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
 fs/xfs/libxfs/xfs_ialloc.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 88ca72f..2bc998d 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -978,6 +978,30 @@ xfs_inobt_ialloc_bitmap(
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
+	DECLARE_BITMAP(alloc, 64);
+
+	/* if there are no holes, return the first available offset */
+	if (!xfs_inobt_issparse(rec->ir_holemask))
+		return xfs_lowbit64(rec->ir_free);
+
+	xfs_inobt_ialloc_bitmap(alloc, rec);
+	realfree = bitmap_to_u64(alloc, 64);
+
+	realfree &= rec->ir_free;
+
+	return xfs_lowbit64(realfree);
+}
+
+/*
  * Allocate an inode using the inobt-only algorithm.
  */
 STATIC int
@@ -1207,7 +1231,7 @@ newino:
 	}
 
 alloc_inode:
-	offset = xfs_lowbit64(rec.ir_free);
+	offset = xfs_inobt_first_free_inode(&rec);
 	ASSERT(offset >= 0);
 	ASSERT(offset < XFS_INODES_PER_CHUNK);
 	ASSERT((XFS_AGINO_TO_OFFSET(mp, rec.ir_startino) %
@@ -1460,7 +1484,7 @@ xfs_dialloc_ag(
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
