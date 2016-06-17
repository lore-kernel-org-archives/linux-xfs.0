Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CADD87E47
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:33:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 633C4AC002
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:33:56 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 1kzq4o9jBGFiD0yh (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:33:55 -0700 (PDT)
Subject: [PATCH 029/145] xfs: add rmap btree stats infrastructure
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:33:45 -0700
Message-ID: <146612722590.16048.12188344261083410845.stgit@birch.djwong.org>
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
Cc: Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

The rmap btree will require the same stats as all the other generic
btrees, so add al the code for that now.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 libxfs/xfs_btree.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 202fdd3..a29067c 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -96,7 +96,7 @@ do {    \
 	case XFS_BTNUM_BMAP: __XFS_BTREE_STATS_INC(__mp, bmbt, stat); break; \
 	case XFS_BTNUM_INO: __XFS_BTREE_STATS_INC(__mp, ibt, stat); break; \
 	case XFS_BTNUM_FINO: __XFS_BTREE_STATS_INC(__mp, fibt, stat); break; \
-	case XFS_BTNUM_RMAP: break;	\
+	case XFS_BTNUM_RMAP: __XFS_BTREE_STATS_INC(__mp, rmap, stat); break; \
 	case XFS_BTNUM_MAX: ASSERT(0); __mp = __mp /* fucking gcc */ ; break; \
 	}       \
 } while (0)
@@ -117,7 +117,8 @@ do {    \
 		__XFS_BTREE_STATS_ADD(__mp, ibt, stat, val); break; \
 	case XFS_BTNUM_FINO:	\
 		__XFS_BTREE_STATS_ADD(__mp, fibt, stat, val); break; \
-	case XFS_BTNUM_RMAP: break; \
+	case XFS_BTNUM_RMAP:	\
+		__XFS_BTREE_STATS_ADD(__mp, rmap, stat, val); break; \
 	case XFS_BTNUM_MAX: ASSERT(0); __mp = __mp /* fucking gcc */ ; break; \
 	}       \
 } while (0)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
