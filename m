Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47069 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932328AbcJYXHl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2016 19:07:41 -0400
Subject: [PATCH 37/39] xfs_repair: check for mergeable refcount records
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 25 Oct 2016 16:07:32 -0700
Message-ID: <147743685290.11035.7257156561485684708.stgit@birch.djwong.org>
In-Reply-To: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Make sure there aren't adjacent refcount records that could be merged;
this is a sign that the refcount tree algorithms aren't working
correctly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/scan.c |   32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)


diff --git a/repair/scan.c b/repair/scan.c
index 800a88a..0e13581 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -1215,6 +1215,12 @@ _("%s rmap btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 		rmap_avoid_check();
 }
 
+struct refc_priv {
+	struct xfs_refcount_irec	last_rec;
+	xfs_agblock_t			nr_blocks;
+};
+
+
 static void
 scan_refcbt(
 	struct xfs_btree_block	*block,
@@ -1234,6 +1240,7 @@ scan_refcbt(
 	int			numrecs;
 	int			state;
 	xfs_agblock_t		lastblock = 0;
+	struct refc_priv	*refc_priv = priv;
 
 	if (magic != XFS_REFC_CRC_MAGIC) {
 		name = "(unknown)";
@@ -1258,6 +1265,8 @@ scan_refcbt(
 			goto out;
 	}
 
+	refc_priv->nr_blocks++;
+
 	/* check for btree blocks multiply claimed */
 	state = get_bmap(agno, bno);
 	if (!(state == XR_E_UNKNOWN || state == XR_E_REFC))  {
@@ -1360,6 +1369,20 @@ _("extent (%u/%u) len %u claimed, state is %d\n"),
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
@@ -2203,10 +2226,17 @@ validate_agf(
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
+			if (be32_to_cpu(agf->agf_refcount_blocks) != priv.nr_blocks)
+				do_warn(_("bad refcountbt block count %u, saw %u\n"),
+					priv.nr_blocks,
+					be32_to_cpu(agf->agf_refcount_blocks));
 		} else  {
 			do_warn(_("bad agbno %u for refcntbt root, agno %d\n"),
 				bno, agno);

