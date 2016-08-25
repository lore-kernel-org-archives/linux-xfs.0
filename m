Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5C7447E4B
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:48:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BFB2AAC002
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:48:44 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id mqPMMLF3wXvuYw1t (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:48:43 -0700 (PDT)
Subject: [PATCH 20/71] xfs: log bmap intent items
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:48:39 -0700
Message-ID: <147216891904.4420.8548167605851988552.stgit@birch.djwong.org>
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

Provide a mechanism for higher levels to create BUI/BUD items, submit
them to the log, and a stub function to deal with recovered BUI items.
These parts will be connected to the rmapbt in a later patch.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_bmap.h |   12 ++++++++++++
 1 file changed, 12 insertions(+)


diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index 9220b1d..c8160fe 100644
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
