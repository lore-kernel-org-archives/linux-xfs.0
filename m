Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0A2C37F54
	for <xfs@oss.sgi.com>; Wed,  7 May 2014 07:22:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EF01C304059
	for <xfs@oss.sgi.com>; Wed,  7 May 2014 05:22:02 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Qn9qCkL4HM7NkJ8i for
	<xfs@oss.sgi.com>; Wed, 07 May 2014 05:22:02 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s47CM1Kk004821
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Wed, 7 May 2014 08:22:02 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s47CM0pb019914
	for <xfs@oss.sgi.com>; Wed, 7 May 2014 08:22:01 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v4 17/20] xfsprogs/repair: helpers for finding in-core inode
	records w/ free inodes
Date: Wed,  7 May 2014 08:21:56 -0400
Message-Id: <1399465319-65066-18-git-send-email-bfoster@redhat.com>
In-Reply-To: <1399465319-65066-1-git-send-email-bfoster@redhat.com>
References: <1399465319-65066-1-git-send-email-bfoster@redhat.com>
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

Add the findfirst_free_inode_rec() and next_free_ino_rec() helpers
to assist scanning the in-core inode records for records with at
least one free inode. These will be used to determine what records
are included in the free inode btree.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 repair/incore.h | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/repair/incore.h b/repair/incore.h
index 5419884..5f8c188 100644
--- a/repair/incore.h
+++ b/repair/incore.h
@@ -381,6 +381,33 @@ void			clear_uncertain_ino_cache(xfs_agnumber_t agno);
 		((ino_tree_node_t *) ((ino_node_ptr)->avl_node.avl_forw))
 
 /*
+ * finobt helpers
+ */
+static inline ino_tree_node_t *
+findfirst_free_inode_rec(xfs_agnumber_t agno)
+{
+	ino_tree_node_t *ino_rec;
+
+	ino_rec = findfirst_inode_rec(agno);
+
+	while (ino_rec && !ino_rec->ir_free)
+		ino_rec = next_ino_rec(ino_rec);
+
+	return ino_rec;
+}
+
+static inline ino_tree_node_t *
+next_free_ino_rec(ino_tree_node_t *ino_rec)
+{
+	ino_rec = next_ino_rec(ino_rec);
+
+	while (ino_rec && !ino_rec->ir_free)
+		ino_rec = next_ino_rec(ino_rec);
+
+	return ino_rec;
+}
+
+/*
  * Has an inode been processed for phase 6 (reference count checking)?
  *
  * add_inode_refchecked() is set on an inode when it gets traversed
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
