Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C66B48481
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:44:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8D68830404E
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:44:58 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 6fhJiAnhLrhwOoFN (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:44:56 -0700 (PDT)
Subject: [PATCH 134/145] xfs_repair: check for mergeable refcount records
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:44:50 -0700
Message-ID: <146612789069.16048.5418520558159694317.stgit@birch.djwong.org>
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

Make sure there aren't adjacent refcount records that could be merged;
this is a sign that the refcount tree algorithms aren't working
correctly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/scan.c |   25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)


diff --git a/repair/scan.c b/repair/scan.c
index 1c2afb6..d2e588a 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -1195,6 +1195,11 @@ out:
 		rmap_avoid_check();
 }
 
+struct refc_priv {
+	struct xfs_refcount_irec	last_rec;
+};
+
+
 static void
 scan_refcbt(
 	struct xfs_btree_block	*block,
@@ -1214,6 +1219,7 @@ scan_refcbt(
 	int			numrecs;
 	int			state;
 	xfs_agblock_t		lastblock = 0;
+	struct refc_priv	*refc_priv = priv;
 
 	if (magic != XFS_REFC_CRC_MAGIC) {
 		name = "(unknown)";
@@ -1331,6 +1337,20 @@ _("extent (%u/%u) len %u claimed, state is %d\n"),
 				lastblock = b;
 			}
 
+			/* Is this record mergeable with the last one? */
+			if (refc_priv->last_rec.rc_startblock +
+			    refc_priv->last_rec.rc_blockcount == b &&
+			    refc_priv->last_rec.rc_refcount == nr) {
+				do_warn(
+	_("record %d in block (%u/%u) of %s tree should be merged with previous record\n"),
+					i, agno, bno, name);
+				refc_priv->last_rec.rc_blockcount += len;
+			} else {
+				refc_priv->last_rec.rc_startblock = b;
+				refc_priv->last_rec.rc_blockcount = len;
+				refc_priv->last_rec.rc_refcount = nr;
+			}
+
 			/* XXX: probably want to mark the reflinked areas? */
 		}
 		goto out;
@@ -2169,10 +2189,13 @@ validate_agf(
 	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
 		bno = be32_to_cpu(agf->agf_refcount_root);
 		if (bno != 0 && verify_agbno(mp, agno, bno)) {
+			struct refc_priv	priv;
+
+			memset(&priv, 0, sizeof(priv));
 			scan_sbtree(bno,
 				    be32_to_cpu(agf->agf_refcount_level),
 				    agno, 0, scan_refcbt, 1, XFS_REFC_CRC_MAGIC,
-				    agcnts, &xfs_refcountbt_buf_ops);
+				    &priv, &xfs_refcountbt_buf_ops);
 		} else  {
 			do_warn(_("bad agbno %u for refcntbt root, agno %d\n"),
 				bno, agno);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
