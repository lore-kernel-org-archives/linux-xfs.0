Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 92F718241
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:37:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1B433AC002
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:37:56 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 8wOAJYhbQGAhuTdi (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:37:55 -0700 (PDT)
Subject: [PATCH 067/145] xfs_repair: look for mergeable rmaps
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:37:51 -0700
Message-ID: <146612747153.16048.4165884380771843048.stgit@birch.djwong.org>
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

Check for adjacent mergeable rmaps; this is a sign that we've
screwed up somehow.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/scan.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)


diff --git a/repair/scan.c b/repair/scan.c
index 6106d93..d72b257 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -787,6 +787,7 @@ ino_issparse(
 struct rmap_priv {
 	struct aghdr_cnts	*agcnts;
 	struct xfs_rmap_irec	high_key;
+	struct xfs_rmap_irec	last_rec;
 };
 
 static void
@@ -943,6 +944,16 @@ advance:
 					goto advance;
 			}
 
+			/* Is this mergeable with the previous record? */
+			if (mergeable_rmaps(&rmap_priv->last_rec, &key)) {
+				do_warn(
+	_("record %d in block (%u/%u) of %s tree should be merged with previous record\n"),
+					i, agno, bno, name);
+				rmap_priv->last_rec.rm_blockcount +=
+						key.rm_blockcount;
+			} else
+				rmap_priv->last_rec = key;
+
 			/* Check that we don't go past the high key. */
 			key.rm_startblock += key.rm_blockcount - 1;
 			if (!XFS_RMAP_NON_INODE_OWNER(key.rm_owner) &&
@@ -1896,6 +1907,7 @@ validate_agf(
 		memset(&priv.high_key, 0xFF, sizeof(priv.high_key));
 		priv.high_key.rm_blockcount = 0;
 		priv.agcnts = agcnts;
+		priv.last_rec.rm_owner = XFS_RMAP_OWN_UNKNOWN;
 		bno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_RMAP]);
 		if (bno != 0 && verify_agbno(mp, agno, bno)) {
 			scan_sbtree(bno,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
