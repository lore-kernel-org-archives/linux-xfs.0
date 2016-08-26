Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D8795849A
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 19:01:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3F2E6AC002
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 17:01:39 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 3T5cLnenXXqyvl65 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 17:01:37 -0700 (PDT)
Subject: [PATCH 26/29] xfs_repair: check existing realtime rmapbt entries
	against observed rmaps
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 17:01:26 -0700
Message-ID: <147216968687.7022.9876273075739424824.stgit@birch.djwong.org>
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

Once we've finished collecting reverse mapping observations from the
metadata scan, check those observations against the realtime rmap btree
(particularly if we're in -n mode) to detect rtrmapbt problems.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/rmap.c |   48 +++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 39 insertions(+), 9 deletions(-)


diff --git a/repair/rmap.c b/repair/rmap.c
index 37da251..d6a75d7 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -1008,6 +1008,7 @@ rmaps_verify_btree(
 	struct xfs_rmap_irec	*rm_rec;
 	struct xfs_rmap_irec	tmp;
 	struct xfs_perag	*pag;		/* per allocation group data */
+	struct xfs_inode	*ip = NULL;
 
 	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
 		return 0;
@@ -1016,22 +1017,47 @@ rmaps_verify_btree(
 			do_warn(_("would rebuild corrupt rmap btrees.\n"));
 		return 0;
 	}
+	if (agno == NULLAGNUMBER && mp->m_sb.sb_rblocks == 0) {
+		if (rmap_record_count(mp, NULLAGNUMBER) != 0) {
+			do_error(_("realtime extents but no rtdev?\n"));
+			return -EFSCORRUPTED;
+		}
+		return 0;
+	}
 
-	/* Create cursors to refcount structures */
+	/* Create cursors to rmap structures */
 	error = rmap_init_cursor(agno, &rm_cur);
 	if (error)
 		return error;
 
-	error = -libxfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
-	if (error)
-		goto err;
+	if (agno == NULLAGNUMBER) {
+		if (mp->m_sb.sb_rrmapino == 0 ||
+		    mp->m_sb.sb_rrmapino == NULLFSINO) {
+			do_warn(
+_("garbage in sb_rrmapino, not checking realtime rmaps\n"));
+			goto err;
+		}
 
-	/* Leave the per-ag data "uninitialized" since we rewrite it later */
-	pag = libxfs_perag_get(mp, agno);
-	pag->pagf_init = 0;
-	libxfs_perag_put(pag);
+		error = -libxfs_iget(mp, NULL, mp->m_sb.sb_rrmapino, 0, &ip, 0);
+		if (error) {
+			do_warn(_("%d - couldn't iget rtrmap inode.\n"),
+				 error);
+			goto err;
+		}
+		mp->m_rrmapip = ip;
+		bt_cur = libxfs_rtrmapbt_init_cursor(mp, NULL, mp->m_rrmapip);
+	} else {
+		error = -libxfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
+		if (error)
+			goto err;
+
+		/* Leave the per-ag data "uninitialized" since we rewrite it later */
+		pag = libxfs_perag_get(mp, agno);
+		pag->pagf_init = 0;
+		libxfs_perag_put(pag);
 
-	bt_cur = libxfs_rmapbt_init_cursor(mp, NULL, agbp, agno);
+		bt_cur = libxfs_rmapbt_init_cursor(mp, NULL, agbp, agno);
+	}
 	if (!bt_cur) {
 		error = -ENOMEM;
 		goto err;
@@ -1107,6 +1133,10 @@ err:
 		libxfs_btree_del_cursor(bt_cur, XFS_BTREE_NOERROR);
 	if (agbp)
 		libxfs_putbuf(agbp);
+	if (ip) {
+		IRELE(mp->m_rrmapip);
+		mp->m_rrmapip = NULL;
+	}
 	free_slab_cursor(&rm_cur);
 	return 0;
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
