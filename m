Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AF5227F4E
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 09:56:26 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 83FB88F8035
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 07:56:26 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id fxWhQAVluDS1nVLu for
	<xfs@oss.sgi.com>; Wed, 13 Nov 2013 07:56:25 -0800 (PST)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id rADFuPsY006267
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 10:56:25 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id rADFuOSU030016
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 10:56:25 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 17/20] xfsprogs/repair: helpers for finding in-core inode
	records w/ free inodes
Date: Wed, 13 Nov 2013 10:56:19 -0500
Message-Id: <1384358182-37967-18-git-send-email-bfoster@redhat.com>
In-Reply-To: <1384358182-37967-1-git-send-email-bfoster@redhat.com>
References: <1384358182-37967-1-git-send-email-bfoster@redhat.com>
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
index 38caa6d..5a563db 100644
--- a/repair/incore.h
+++ b/repair/incore.h
@@ -379,6 +379,33 @@ void			clear_uncertain_ino_cache(xfs_agnumber_t agno);
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
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
