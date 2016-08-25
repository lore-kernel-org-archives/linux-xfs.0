Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DE3FC82D6
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:54:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 531F8AC001
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:54:13 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id h1hwwQX2pzXRkqzm (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:54:11 -0700 (PDT)
Subject: [PATCH 70/71] xfs_repair: check for mergeable refcount records
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:54:06 -0700
Message-ID: <147216924692.4420.10874812188502361823.stgit@birch.djwong.org>
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

Make sure there aren't adjacent refcount records that could be merged;
this is a sign that the refcount tree algorithms aren't working
correctly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/scan.c |   32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)


diff --git a/repair/scan.c b/repair/scan.c
index 499253e..f4d6f89 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -1215,6 +1215,12 @@ out:
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
@@ -1349,6 +1358,20 @@ _("extent (%u/%u) len %u claimed, state is %d\n"),
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
@@ -2192,10 +2215,17 @@ validate_agf(
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
