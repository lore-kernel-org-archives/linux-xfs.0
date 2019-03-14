Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:52504 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727204AbfCNVGk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Mar 2019 17:06:40 -0400
Subject: [PATCH 27/36] xfs_repair: pass ops through during scan
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 14 Mar 2019 14:06:35 -0700
Message-ID: <155259759563.31886.2004896919962409807.stgit@magnolia>
In-Reply-To: <155259742281.31886.17157720770696604377.stgit@magnolia>
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Pass the buffer ops through scan_sbtree so that we detect finobt blocks
properly and we don't have to keep switching on magic numbers for the
free space btrees.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/scan.c |   39 ++++++++++++++++-----------------------
 1 file changed, 16 insertions(+), 23 deletions(-)


diff --git a/repair/scan.c b/repair/scan.c
index 12ca3144..edc375a9 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -59,7 +59,8 @@ scan_sbtree(
 				int			suspect,
 				int			isroot,
 				uint32_t		magic,
-				void			*priv),
+				void			*priv,
+				const struct xfs_buf_ops *ops),
 	int		isroot,
 	uint32_t	magic,
 	void		*priv,
@@ -80,7 +81,7 @@ scan_sbtree(
 	}
 
 	(*func)(XFS_BUF_TO_BLOCK(bp), nlevels - 1, root, agno, suspect,
-							isroot, magic, priv);
+			isroot, magic, priv, ops);
 	libxfs_putbuf(bp);
 }
 
@@ -543,7 +544,8 @@ scan_allocbt(
 	int			suspect,
 	int			isroot,
 	uint32_t		magic,
-	void			*priv)
+	void			*priv,
+	const struct xfs_buf_ops *ops)
 {
 	struct aghdr_cnts	*agcnts = priv;
 	const char 		*name;
@@ -750,20 +752,8 @@ _("%s freespace btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 		 * as possible.
 		 */
 		if (agbno != 0 && verify_agbno(mp, agno, agbno)) {
-			switch (magic) {
-			case XFS_ABTB_CRC_MAGIC:
-			case XFS_ABTB_MAGIC:
-				scan_sbtree(agbno, level, agno, suspect,
-					    scan_allocbt, 0, magic, priv,
-					    &xfs_allocbt_buf_ops);
-				break;
-			case XFS_ABTC_CRC_MAGIC:
-			case XFS_ABTC_MAGIC:
-				scan_sbtree(agbno, level, agno, suspect,
-					    scan_allocbt, 0, magic, priv,
-					    &xfs_allocbt_buf_ops);
-				break;
-			}
+			scan_sbtree(agbno, level, agno, suspect, scan_allocbt,
+				    0, magic, priv, ops);
 		}
 	}
 }
@@ -926,7 +916,8 @@ scan_rmapbt(
 	int			suspect,
 	int			isroot,
 	uint32_t		magic,
-	void			*priv)
+	void			*priv,
+	const struct xfs_buf_ops *ops)
 {
 	const char		*name = "rmap";
 	int			i;
@@ -1205,7 +1196,7 @@ _("%s rmap btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 
 		if (agbno != 0 && verify_agbno(mp, agno, agbno)) {
 			scan_sbtree(agbno, level, agno, suspect, scan_rmapbt, 0,
-				    magic, priv, &xfs_rmapbt_buf_ops);
+				    magic, priv, ops);
 		}
 	}
 
@@ -1229,7 +1220,8 @@ scan_refcbt(
 	int			suspect,
 	int			isroot,
 	uint32_t		magic,
-	void			*priv)
+	void			*priv,
+	const struct xfs_buf_ops *ops)
 {
 	const char		*name = "refcount";
 	int			i;
@@ -1423,7 +1415,7 @@ _("extent (%u/%u) len %u claimed, state is %d\n"),
 
 		if (agbno != 0 && verify_agbno(mp, agno, agbno)) {
 			scan_sbtree(agbno, level, agno, suspect, scan_refcbt, 0,
-				    magic, priv, &xfs_refcountbt_buf_ops);
+				    magic, priv, ops);
 		}
 	}
 out:
@@ -1935,7 +1927,8 @@ scan_inobt(
 	int			suspect,
 	int			isroot,
 	uint32_t		magic,
-	void			*priv)
+	void			*priv,
+	const struct xfs_buf_ops *ops)
 {
 	struct aghdr_cnts	*agcnts = priv;
 	int			i;
@@ -2091,7 +2084,7 @@ _("inode btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 							be32_to_cpu(pp[i])))
 			scan_sbtree(be32_to_cpu(pp[i]), level, agno,
 					suspect, scan_inobt, 0, magic, priv,
-					&xfs_inobt_buf_ops);
+					ops);
 	}
 }
 
