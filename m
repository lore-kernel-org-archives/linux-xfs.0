Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 158EC843D
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 19:00:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CC827304043
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 17:00:22 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 3wJ6qpTi6YUuJYsE (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 17:00:21 -0700 (PDT)
Subject: [PATCH 15/29] xfs: scrub the realtime rmapbt
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 17:00:11 -0700
Message-ID: <147216961151.7022.12610377850464261933.stgit@birch.djwong.org>
In-Reply-To: <147216950911.7022.438115723996286926.stgit@birch.djwong.org>
References: <147216950911.7022.438115723996286926.stgit@birch.djwong.org>
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

Check the realtime reverse mapping btree against the rtbitmap, and
modify the rtbitmap scrub to check against the rtrmapbt.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_fs.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 2c37d57..112afc0 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -575,7 +575,8 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_BMBTC	13	/* CoW fork block mapping */
 #define XFS_SCRUB_TYPE_RTBITMAP	14	/* realtime bitmap */
 #define XFS_SCRUB_TYPE_RTSUM	15	/* realtime summary */
-#define XFS_SCRUB_TYPE_MAX	15
+#define XFS_SCRUB_TYPE_RTRMAPBT	16	/* realtime reverse mapping btree */
+#define XFS_SCRUB_TYPE_MAX	16
 
 #define XFS_SCRUB_FLAGS_ALL	0x0	/* no flags yet */
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
