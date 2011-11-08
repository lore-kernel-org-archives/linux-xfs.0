Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA8Ilhvq143007 for <xfs@oss.sgi.com>; Tue, 8 Nov 2011 12:47:43 -0600
Received: from hades.usersys.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D74F3148A50C
	for <xfs@oss.sgi.com>; Tue,  8 Nov 2011 10:47:41 -0800 (PST)
Received: from hades.usersys.redhat.com ([187.60.101.4]) by cuda.sgi.com with
	ESMTP id OySZEmal4ohngbJJ for <xfs@oss.sgi.com>;
	Tue, 08 Nov 2011 10:47:41 -0800 (PST)
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 1/2] xfs_repair: Add inline function to get avl tree node
Date: Tue,  8 Nov 2011 16:46:29 -0200
Message-Id: <1320777990-6556-2-git-send-email-cmaiolino@redhat.com>
In-Reply-To: <1320777990-6556-1-git-send-email-cmaiolino@redhat.com>
References: <1320777990-6556-1-git-send-email-cmaiolino@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Carlos Maiolino <cmaiolino@redhat.com>

dd get_inode_offset() inline function, which will return the offset
of a specific node in the AVL tree avoiding the need to calculate the
the offset each time it needs to be used.
---
 repair/incore.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/repair/incore.h b/repair/incore.h
index ee0e86a..8e311c9 100644
--- a/repair/incore.h
+++ b/repair/incore.h
@@ -311,6 +311,12 @@ void		get_inode_rec(struct xfs_mount *mp, xfs_agnumber_t agno,
 			      ino_tree_node_t *ino_rec);
 
 extern avltree_desc_t     **inode_tree_ptrs;
+
+static inline int
+get_inode_offset(struct xfs_mount *mp, xfs_ino_t ino, ino_tree_node_t *irec)
+{
+	return XFS_INO_TO_AGINO(mp, ino) - irec->ino_startnum;
+}
 static inline ino_tree_node_t *
 findfirst_inode_rec(xfs_agnumber_t agno)
 {
-- 
1.7.6.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
