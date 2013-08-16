Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7FAFF7CBF
	for <xfs@oss.sgi.com>; Fri, 16 Aug 2013 13:12:35 -0500 (CDT)
Received: from eagdhcp-232-140.americas.sgi.com
	(eagdhcp-232-140.americas.sgi.com [128.162.232.140])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6406A304043
	for <xfs@oss.sgi.com>; Fri, 16 Aug 2013 11:12:32 -0700 (PDT)
Received: from eagdhcp-232-140.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-140.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	r7GICVgW002870
	for <xfs@oss.sgi.com>; Fri, 16 Aug 2013 13:12:31 -0500 (CDT)
	(envelope-from tinguely@eagdhcp-232-140.americas.sgi.com)
Message-Id: <20130816181254.285296783@sgi.com>
Date: Fri, 16 Aug 2013 13:12:43 -0500
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH] v2 xfsprogs: fix inode crash in xfs_repair
Content-Disposition: inline;
	filename=v2-xfs_progs-fix-repair-crash-new-ichunk.patch
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

Adding the lost+found in phase 6 could allocate an inode from
a new inode chunk. Since this chunk was not around in phase 3
when the inode chunk are verificated and added to the avl tree,
the avl tree look up will return a NULL pointer. This results
in a NULL defererence and segmentation fault.

Add the newly created inode chunk as if found in the chunk
verification phase.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
v2:
  1) add comment.
  2) simplify the if statement.

 repair/incore_ino.c |    2 +-
 repair/phase6.c     |   16 ++++++++++++++++
 2 files changed, 17 insertions(+), 1 deletion(-)

Index: b/repair/incore_ino.c
===================================================================
--- a/repair/incore_ino.c
+++ b/repair/incore_ino.c
@@ -700,7 +700,7 @@ get_inode_parent(ino_tree_node_t *irec,
 	return(0LL);
 }
 
-static void
+void
 alloc_ex_data(ino_tree_node_t *irec)
 {
 	parent_list_t 	*ptbl;
Index: b/repair/phase6.c
===================================================================
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -930,6 +930,22 @@ mk_orphanage(xfs_mount_t *mp)
 	irec = find_inode_rec(mp,
 			XFS_INO_TO_AGNO(mp, ino),
 			XFS_INO_TO_AGINO(mp, ino));
+
+	if (irec == NULL) {
+		/*
+		 * This inode is allocated from a newly created inode
+		 * chunk and therefore did not exist when inode chunks
+		 * were processed in phase3. Add this group of inodes to
+		 * the entry avl tree as if they were discovered in phase3.
+		 */
+		irec = set_inode_free_alloc(mp, XFS_INO_TO_AGNO(mp, ino),
+					    XFS_INO_TO_AGINO(mp, ino));
+		alloc_ex_data(irec);
+
+		for (i = 0; i < XFS_INODES_PER_CHUNK; i++)
+			set_inode_free(irec, i);
+	}
+
 	ino_offset = get_inode_offset(mp, ino, irec);
 
 	/*



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
