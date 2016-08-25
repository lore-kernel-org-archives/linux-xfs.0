Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DF56780FD
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:48:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A47F3304039
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:48:03 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id Xv6rATR8ZBtCExdE (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:48:01 -0700 (PDT)
Subject: [PATCH 13/71] xfs: log refcount intent items
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:47:55 -0700
Message-ID: <147216887536.4420.16308398963061320982.stgit@birch.djwong.org>
In-Reply-To: <147216879156.4420.2446767701729565218.stgit@birch.djwong.org>
References: <147216879156.4420.2446767701729565218.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Provide a mechanism for higher levels to create CUI/CUD items, submit
them to the log, and a stub function to deal with recovered CUI items.
These parts will be connected to the refcountbt in a later patch.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_refcount.h |   14 ++++++++++++++
 1 file changed, 14 insertions(+)


diff --git a/libxfs/xfs_refcount.h b/libxfs/xfs_refcount.h
index 4dc335a..2ef2b28 100644
--- a/libxfs/xfs_refcount.h
+++ b/libxfs/xfs_refcount.h
@@ -27,4 +27,18 @@ extern int xfs_refcount_lookup_ge(struct xfs_btree_cur *cur,
 extern int xfs_refcount_get_rec(struct xfs_btree_cur *cur,
 		struct xfs_refcount_irec *irec, int *stat);
 
+enum xfs_refcount_intent_type {
+	XFS_REFCOUNT_INCREASE,
+	XFS_REFCOUNT_DECREASE,
+	XFS_REFCOUNT_ALLOC_COW,
+	XFS_REFCOUNT_FREE_COW,
+};
+
+struct xfs_refcount_intent {
+	struct list_head			ri_list;
+	enum xfs_refcount_intent_type		ri_type;
+	xfs_fsblock_t				ri_startblock;
+	xfs_extlen_t				ri_blockcount;
+};
+
 #endif	/* __XFS_REFCOUNT_H__ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
