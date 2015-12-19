Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 20BED80D6
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:04:55 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 99960AC004
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:04:54 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id IwHL2GryA32GYA9X (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:04:53 -0800 (PST)
Subject: [PATCH 76/76] xfs: try to prevent failed rmap btree expansion
	during cow
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:04:49 -0800
Message-ID: <20151219090449.12713.21009.stgit@birch.djwong.org>
In-Reply-To: <20151219085622.12713.88678.stgit@birch.djwong.org>
References: <20151219085622.12713.88678.stgit@birch.djwong.org>
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

It's possible, if reflink and rmap are both enabled, for CoW to create
a lot of small mappings that cause an rmap btree expansion to run out
of space.  If both are enabled, keep the AGFL fully stocked at all
times, refuse to CoW if we start to run out of space in the AGFL, and
hope that's good enough.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c |    8 ++++++++
 fs/xfs/xfs_reflink.c      |   20 ++++++++++++++++++++
 2 files changed, 28 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 637e2e7..70aad82 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2000,6 +2000,14 @@ xfs_alloc_min_freelist(
 		min_free += min_t(unsigned int,
 				  pag->pagf_levels[XFS_BTNUM_RMAPi] + 1,
 				  mp->m_ag_maxlevels);
+	/*
+	 * The rmapbt can explode if we have reflink enabled and someone
+	 * creates a lot of small mappings... so max out the AGFL to try
+	 * to prevent that.
+	 */
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb) &&
+	    xfs_sb_version_hasreflink(&mp->m_sb))
+		min_free = XFS_AGFL_SIZE(mp) - min_free;
 
 	return min_free;
 }
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 299a957..da4a715 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -49,6 +49,7 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_reflink.h"
 #include "xfs_iomap.h"
+#include "xfs_sb.h"
 
 /*
  * Copy on Write of Shared Blocks
@@ -191,6 +192,8 @@ xfs_reflink_reserve_cow_extent(
 	struct xfs_bmbt_irec	*irec)
 {
 	struct xfs_bmbt_irec	rec;
+	struct xfs_perag	*pag;
+	unsigned int		resblks;
 	xfs_agnumber_t		agno;
 	xfs_agblock_t		agbno;
 	xfs_extlen_t		aglen;
@@ -225,6 +228,23 @@ xfs_reflink_reserve_cow_extent(
 			goto advloop;
 		}
 
+		/*
+		 * XXX: The rmapbt can ENOSPC if we do evil things like
+		 * CoW every other block of a long shared segment.  Don't
+		 * let the CoW happen if we lack sufficient space in the AG.
+		 * We overinflate the AGFL in the hopes that this will never
+		 * have to happen.
+		 */
+		if (xfs_sb_version_hasrmapbt(&ip->i_mount->m_sb)) {
+			pag = xfs_perag_get(ip->i_mount, agno);
+			resblks = pag->pagf_flcount;
+			xfs_perag_put(pag);
+			if (resblks < 50) {
+				error = -ENOSPC;
+				break;
+			}
+		}
+
 		/* Add as much as we can to the cow fork */
 		foffset = XFS_FSB_TO_B(ip->i_mount, lblk + fbno - agbno);
 		fsize = XFS_FSB_TO_B(ip->i_mount, flen);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
