Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 27E2681C5
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:50:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EE4878F8037
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:50:43 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id C5bJPZhDq8ipc0Ay (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:50:42 -0700 (PDT)
Subject: [PATCH 38/71] xfs: add shared rmap map/unmap/convert log item types
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:50:38 -0700
Message-ID: <147216903865.4420.10111406668899344566.stgit@birch.djwong.org>
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

Wire up some rmap log redo item type codes to map, unmap, or convert
shared data block extents.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_log_format.h |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index d788d01..75f9890 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -635,8 +635,11 @@ struct xfs_map_extent {
 
 /* rmap me_flags: upper bits are flags, lower byte is type code */
 #define XFS_RMAP_EXTENT_MAP		1
+#define XFS_RMAP_EXTENT_MAP_SHARED	2
 #define XFS_RMAP_EXTENT_UNMAP		3
+#define XFS_RMAP_EXTENT_UNMAP_SHARED	4
 #define XFS_RMAP_EXTENT_CONVERT		5
+#define XFS_RMAP_EXTENT_CONVERT_SHARED	6
 #define XFS_RMAP_EXTENT_ALLOC		7
 #define XFS_RMAP_EXTENT_FREE		8
 #define XFS_RMAP_EXTENT_TYPE_MASK	0xFF

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
