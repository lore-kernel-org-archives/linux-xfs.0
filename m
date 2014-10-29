Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F0EAD7F37
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2014 22:09:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9C652AC007
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2014 20:09:14 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	w5syKdv6YVCOGIKr for <xfs@oss.sgi.com>;
	Tue, 28 Oct 2014 20:09:13 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] repair: fix XR_BLD_FREE_TRACE compilation errors
Date: Wed, 29 Oct 2014 14:09:03 +1100
Message-Id: <1414552144-12627-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1414552144-12627-1-git-send-email-david@fromorbit.com>
References: <1414552144-12627-1-git-send-email-david@fromorbit.com>
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
Cc: bvowk@box.com

From: Dave Chinner <dchinner@redhat.com>

Obviously hasn't been used for quite some time, so fix the
build problems and make it useful again.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 repair/phase5.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/repair/phase5.c b/repair/phase5.c
index e82eeb7..d6d3c6d 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -362,10 +362,6 @@ calculate_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
 	extent_tree_node_t	*ext_ptr;
 	int			level;
 #ifdef XR_BLD_FREE_TRACE
-	int			old_state;
-	int			state = XR_E_BAD_STATE;
-#endif
-#ifdef XR_BLD_FREE_TRACE
 	fprintf(stderr,
 		"in init_freespace_cursor, agno = %d\n", agno);
 #endif
@@ -1292,8 +1288,8 @@ build_agf_agfl(xfs_mount_t	*mp,
 	memset(agf, 0, mp->m_sb.sb_sectsize);
 
 #ifdef XR_BLD_FREE_TRACE
-	fprintf(stderr, "agf = 0x%x, agf_buf->b_un.b_addr = 0x%x\n",
-		(__psint_t) agf, (__psint_t) agf_buf->b_un.b_addr);
+	fprintf(stderr, "agf = 0x%p, agf_buf->b_addr = 0x%p\n",
+		agf, agf_buf->b_addr);
 #endif
 
 	/*
@@ -1452,7 +1448,7 @@ build_agf_agfl(xfs_mount_t	*mp,
 	}
 
 #ifdef XR_BLD_FREE_TRACE
-	fprintf(stderr, "wrote agf for ag %u, error = %d\n", agno, error);
+	fprintf(stderr, "wrote agf for ag %u\n", agno);
 #endif
 }
 
@@ -1707,11 +1703,10 @@ phase5(xfs_mount_t *mp)
 #ifdef XR_BLD_FREE_TRACE
 	fprintf(stderr, "inobt level 1, maxrec = %d, minrec = %d\n",
 		xfs_inobt_maxrecs(mp, mp->m_sb.sb_blocksize, 0),
-		xfs_inobt_maxrecs(mp->m_sb.sb_blocksize, 0) / 2
-		);
+		xfs_inobt_maxrecs(mp, mp->m_sb.sb_blocksize, 0) / 2);
 	fprintf(stderr, "inobt level 0 (leaf), maxrec = %d, minrec = %d\n",
-		xfs_inobt_maxrecs(mp, mp->m_sb.sb_blocksize, xfs_inobt, 1),
-		xfs_inobt_maxrecs(mp, mp->m_sb.sb_blocksize, xfs_inobt, 1) / 2);
+		xfs_inobt_maxrecs(mp, mp->m_sb.sb_blocksize, 1),
+		xfs_inobt_maxrecs(mp, mp->m_sb.sb_blocksize, 1) / 2);
 	fprintf(stderr, "xr inobt level 0 (leaf), maxrec = %d\n",
 		XR_INOBT_BLOCK_MAXRECS(mp, 0));
 	fprintf(stderr, "xr inobt level 1 (int), maxrec = %d\n",
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
