Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BE6727F63
	for <xfs@oss.sgi.com>; Mon,  2 Mar 2015 07:28:27 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9E53F304066
	for <xfs@oss.sgi.com>; Mon,  2 Mar 2015 05:28:27 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id QHQQQ3OJG1VlKkOT (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Mar 2015 05:28:11 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t22DSAUB010031
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Mon, 2 Mar 2015 08:28:10 -0500
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t22DS9pt021862
	for <xfs@oss.sgi.com>; Mon, 2 Mar 2015 08:28:09 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v6 15/18] xfs: filter out sparse regions from individual inode
	allocation
Date: Mon,  2 Mar 2015 08:28:05 -0500
Message-Id: <1425302888-4962-16-git-send-email-bfoster@redhat.com>
In-Reply-To: <1425302888-4962-1-git-send-email-bfoster@redhat.com>
References: <1425302888-4962-1-git-send-email-bfoster@redhat.com>
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

Update the xfs_inobt_first_free_inode() helper to find the first free
inode available of the allocated regions of the inode chunk.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 9a18c0b..6451a80 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1076,13 +1076,24 @@ xfs_ialloc_get_rec(
 }
 
 /*
- * Return the offset of the first free inode in the record.
+ * Return the offset of the first free inode in the record. If the inode chunk
+ * is sparsely allocated, we convert the record holemask to inode granularity
+ * and mask off the unallocated regions from the inode free mask.
  */
 STATIC int
 xfs_inobt_first_free_inode(
 	struct xfs_inobt_rec_incore	*rec)
 {
-	return xfs_lowbit64(rec->ir_free);
+	xfs_inofree_t			realfree;
+
+	/* if there are no holes, return the first available offset */
+	if (!xfs_inobt_issparse(rec->ir_holemask))
+		return xfs_lowbit64(rec->ir_free);
+
+	realfree = xfs_inobt_irec_to_allocmask(rec);
+	realfree &= rec->ir_free;
+
+	return xfs_lowbit64(realfree);
 }
 
 /*
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
