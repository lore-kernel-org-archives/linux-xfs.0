Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DA61B7F6D
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 13:42:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C996E304051
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 11:42:06 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 02uGGJqNjETbKVzj (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Jun 2015 11:42:06 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id 6199E19EF37
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 18:42:05 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t52Ig4ki010509
	for <xfs@oss.sgi.com>; Tue, 2 Jun 2015 14:42:05 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 22/28] repair: factor out sparse inodes from finobt
	reconstruction
Date: Tue,  2 Jun 2015 14:41:55 -0400
Message-Id: <1433270521-62026-23-git-send-email-bfoster@redhat.com>
In-Reply-To: <1433270521-62026-1-git-send-email-bfoster@redhat.com>
References: <1433270521-62026-1-git-send-email-bfoster@redhat.com>
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

Phase 5 of xfs_repair recreates the on-disk btrees. The free inode btree
(finobt) contains inode records that contain one or more free inodes.
Sparse inodes are marked as free and therefore sparse inode records can
be incorrectly included in the finobt even when no real free inodes are
available in the record.

Update the finobt in-core record traversal helpers to factor out sparse
inodes and only consider inode records with allocated, free inodes for
finobt insertion.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 repair/incore.h | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/repair/incore.h b/repair/incore.h
index d4e44a7..5a63e1e 100644
--- a/repair/incore.h
+++ b/repair/incore.h
@@ -384,6 +384,14 @@ void			clear_uncertain_ino_cache(xfs_agnumber_t agno);
 /*
  * finobt helpers
  */
+
+static inline bool
+inode_rec_has_free(struct ino_tree_node *ino_rec)
+{
+	/* must have real, allocated inodes for finobt */
+	return ino_rec->ir_free & ~ino_rec->ir_sparse;
+}
+
 static inline ino_tree_node_t *
 findfirst_free_inode_rec(xfs_agnumber_t agno)
 {
@@ -391,7 +399,7 @@ findfirst_free_inode_rec(xfs_agnumber_t agno)
 
 	ino_rec = findfirst_inode_rec(agno);
 
-	while (ino_rec && !ino_rec->ir_free)
+	while (ino_rec && !inode_rec_has_free(ino_rec))
 		ino_rec = next_ino_rec(ino_rec);
 
 	return ino_rec;
@@ -402,7 +410,7 @@ next_free_ino_rec(ino_tree_node_t *ino_rec)
 {
 	ino_rec = next_ino_rec(ino_rec);
 
-	while (ino_rec && !ino_rec->ir_free)
+	while (ino_rec && !inode_rec_has_free(ino_rec))
 		ino_rec = next_ino_rec(ino_rec);
 
 	return ino_rec;
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
