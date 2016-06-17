Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EC0D682E0
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:40:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AA71B8F8050
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:40:04 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id cdaQMNLYgVQsMGiJ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:40:02 -0700 (PDT)
Subject: [PATCH 087/145] xfs: log bmap intent items
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:39:58 -0700
Message-ID: <146612759816.16048.13949394799554585448.stgit@birch.djwong.org>
In-Reply-To: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
References: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
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
Cc: xfs@oss.sgi.com

Provide a mechanism for higher levels to create BUI/BUD items, submit
them to the log, and a stub function to deal with recovered BUI items.
These parts will be connected to the rmapbt in a later patch.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_bmap.h |   12 ++++++++++++
 1 file changed, 12 insertions(+)


diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index 41f7ef2..62a66d0 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -209,5 +209,17 @@ struct xfs_bmbt_rec_host *
 				struct xfs_bmbt_irec *gotp,
 				struct xfs_bmbt_irec *prevp);
 
+enum xfs_bmap_intent_type {
+	XFS_BMAP_MAP,
+	XFS_BMAP_UNMAP,
+};
+
+struct xfs_bmap_intent {
+	struct list_head			bi_list;
+	enum xfs_bmap_intent_type		bi_type;
+	struct xfs_inode			*bi_owner;
+	int					bi_whichfork;
+	struct xfs_bmbt_irec			bi_bmap;
+};
 
 #endif	/* __XFS_BMAP_H__ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
