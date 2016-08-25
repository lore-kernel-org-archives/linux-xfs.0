Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C5A447F15
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:41:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6DAE78F8033
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:41:24 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id jD8EGdlZ3ZQYG1LH (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:41:22 -0700 (PDT)
Subject: [PATCH 10/25] xfs: scrub the AGI
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:41:16 -0700
Message-ID: <147216847640.3108.11528139250590916971.stgit@birch.djwong.org>
In-Reply-To: <147216841262.3108.10746252464845687338.stgit@birch.djwong.org>
References: <147216841262.3108.10746252464845687338.stgit@birch.djwong.org>
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

Add a forgotten check to the AGI verifier, then wire up the scrub
infrastructure to check the AGI contents.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h     |    3 ++-
 fs/xfs/libxfs/xfs_ialloc.c |    5 ++++
 fs/xfs/xfs_scrub.c         |   51 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 58 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 8249ae0..2d320a7 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -538,7 +538,8 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_SB	0	/* superblock */
 #define XFS_SCRUB_TYPE_AGF	1	/* AG free header */
 #define XFS_SCRUB_TYPE_AGFL	2	/* AG free list */
-#define XFS_SCRUB_TYPE_MAX	2
+#define XFS_SCRUB_TYPE_AGI	3	/* AG inode header */
+#define XFS_SCRUB_TYPE_MAX	3
 
 #define XFS_SCRUB_FLAGS_ALL	0x0	/* no flags yet */
 
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 60e1a67..1240064 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2514,6 +2514,11 @@ xfs_agi_verify(
 
 	if (be32_to_cpu(agi->agi_level) > XFS_BTREE_MAXLEVELS)
 		return false;
+
+	if (xfs_sb_version_hasfinobt(&mp->m_sb) &&
+	    be32_to_cpu(agi->agi_free_level) > XFS_BTREE_MAXLEVELS)
+		return false;
+
 	/*
 	 * during growfs operations, the perag is not fully initialised,
 	 * so we can't use it for any useful checking. growfs ensures we can't
diff --git a/fs/xfs/xfs_scrub.c b/fs/xfs/xfs_scrub.c
index c04a097..2b1d669 100644
--- a/fs/xfs/xfs_scrub.c
+++ b/fs/xfs/xfs_scrub.c
@@ -909,6 +909,56 @@ err_no_agfl:
 	return error;
 }
 
+/* Scrub the AGI. */
+STATIC int
+xfs_scrub_agi(
+	struct xfs_inode		*ip,
+	struct xfs_scrub_metadata	*sm)
+{
+	struct xfs_mount		*mp = ip->i_mount;
+	struct xfs_agi			*agi;
+	struct xfs_agf			*agf;
+	struct xfs_buf			*agi_bp = NULL;
+	struct xfs_buf			*agf_bp = NULL;
+	xfs_agnumber_t			agno;
+	xfs_agblock_t			agbno;
+	xfs_agblock_t			eoag;
+	xfs_daddr_t			daddr;
+	xfs_daddr_t			eofs;
+	int				error;
+
+	if (sm->control >= mp->m_sb.sb_agcount || sm->flags)
+		return -EINVAL;
+	agno = sm->control;
+
+	error = xfs_scrub_get_ag_headers(mp, agno, &agi_bp, &agf_bp);
+	if (error)
+		return error;
+
+	agi = XFS_BUF_TO_AGI(agi_bp);
+	agf = XFS_BUF_TO_AGF(agf_bp);
+	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
+	eoag = be32_to_cpu(agf->agf_length);
+
+	agbno = be32_to_cpu(agi->agi_root);
+	daddr = XFS_AGB_TO_DADDR(mp, agno, agbno);
+	XFS_SCRUB_CHECK(mp, agi_bp, "AGI", agbno < mp->m_sb.sb_agblocks);
+	XFS_SCRUB_CHECK(mp, agi_bp, "AGI", agbno < eoag);
+	XFS_SCRUB_CHECK(mp, agi_bp, "AGI", daddr < eofs);
+
+	if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
+		agbno = be32_to_cpu(agi->agi_free_root);
+		daddr = XFS_AGB_TO_DADDR(mp, agno, agbno);
+		XFS_SCRUB_CHECK(mp, agi_bp, "AGI",
+				agbno < mp->m_sb.sb_agblocks);
+		XFS_SCRUB_CHECK(mp, agi_bp, "AGI", agbno < eoag);
+		XFS_SCRUB_CHECK(mp, agi_bp, "AGI", daddr < eofs);
+	}
+
+	xfs_scrub_put_ag_headers(&agi_bp, &agf_bp);
+	return error;
+}
+
 /* Scrubbing dispatch. */
 
 struct xfs_scrub_meta_fns {
@@ -920,6 +970,7 @@ static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
 	{xfs_scrub_sb,		NULL},
 	{xfs_scrub_agf,		NULL},
 	{xfs_scrub_agfl,	NULL},
+	{xfs_scrub_agi,		NULL},
 };
 
 /* Dispatch metadata scrubbing. */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
