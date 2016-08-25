Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 793087F06
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:41:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D3491AC001
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:41:09 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id xcmzOKikXm6CGtu4 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:41:07 -0700 (PDT)
Subject: [PATCH 08/25] xfs: scrub the backup superblocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:41:03 -0700
Message-ID: <147216846337.3108.10510729691563285944.stgit@birch.djwong.org>
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

Ensure that the geometry presented in the backup superblocks matches
the primary superblock so that repair can recover the filesystem if
that primary gets corrupted.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h |    1 +
 fs/xfs/xfs_scrub.c     |   75 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 76 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 22559ab..8d58061 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -535,6 +535,7 @@ struct xfs_scrub_metadata {
 /*
  * Metadata types and flags for scrub operation.
  */
+#define XFS_SCRUB_TYPE_SB	0	/* superblock */
 #define XFS_SCRUB_TYPE_MAX	0
 
 #define XFS_SCRUB_FLAGS_ALL	0x0	/* no flags yet */
diff --git a/fs/xfs/xfs_scrub.c b/fs/xfs/xfs_scrub.c
index fd24af7..3def216 100644
--- a/fs/xfs/xfs_scrub.c
+++ b/fs/xfs/xfs_scrub.c
@@ -704,6 +704,80 @@ out_badcursor:
 	return error;
 }
 
+/* Metadata scrubbers */
+
+/* Scrub the filesystem superblock. */
+STATIC int
+xfs_scrub_sb(
+	struct xfs_inode		*ip,
+	struct xfs_scrub_metadata	*sm)
+{
+	struct xfs_mount		*mp = ip->i_mount;
+	struct xfs_buf			*bp;
+	struct xfs_sb			sb;
+	xfs_agnumber_t			agno;
+	int				error;
+
+	if (sm->control >= mp->m_sb.sb_agcount || sm->flags)
+		return -EINVAL;
+	agno = sm->control;
+
+	error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp,
+		  XFS_AGB_TO_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
+		  XFS_FSS_TO_BB(mp, 1), 0, &bp,
+		  &xfs_sb_buf_ops);
+	if (error)
+		return error;
+
+	if (agno == 0)
+		goto out;
+
+	xfs_sb_from_disk(&sb, XFS_BUF_TO_SBP(bp));
+
+	/* Verify the geometries match. */
+#define XFS_SCRUB_SB_FIELD(fn) \
+		XFS_SCRUB_CHECK(mp, bp, "superblock", \
+		sb.sb_##fn == mp->m_sb.sb_##fn)
+	XFS_SCRUB_SB_FIELD(blocksize);
+	XFS_SCRUB_SB_FIELD(dblocks);
+	XFS_SCRUB_SB_FIELD(rblocks);
+	XFS_SCRUB_SB_FIELD(rextents);
+	XFS_SCRUB_SB_FIELD(logstart);
+	XFS_SCRUB_SB_FIELD(rextsize);
+	XFS_SCRUB_SB_FIELD(agblocks);
+	XFS_SCRUB_SB_FIELD(agcount);
+	XFS_SCRUB_SB_FIELD(rbmblocks);
+	XFS_SCRUB_SB_FIELD(logblocks);
+	XFS_SCRUB_SB_FIELD(sectsize);
+	XFS_SCRUB_SB_FIELD(inodesize);
+#undef XFS_SCRUB_SB_FIELD
+
+#define XFS_SCRUB_SB_FEAT(fn) \
+		XFS_SCRUB_CHECK(mp, bp, "superblock", \
+		xfs_sb_version_has##fn(&sb) == xfs_sb_version_has##fn(&mp->m_sb))
+        XFS_SCRUB_SB_FEAT(align);
+        XFS_SCRUB_SB_FEAT(dalign);
+        XFS_SCRUB_SB_FEAT(logv2);
+        XFS_SCRUB_SB_FEAT(extflgbit);
+        XFS_SCRUB_SB_FEAT(sector);
+        XFS_SCRUB_SB_FEAT(asciici);
+        XFS_SCRUB_SB_FEAT(morebits);
+        XFS_SCRUB_SB_FEAT(lazysbcount);
+        XFS_SCRUB_SB_FEAT(crc);
+        XFS_SCRUB_SB_FEAT(_pquotino);
+        XFS_SCRUB_SB_FEAT(ftype);
+        XFS_SCRUB_SB_FEAT(finobt);
+        XFS_SCRUB_SB_FEAT(sparseinodes);
+        XFS_SCRUB_SB_FEAT(metauuid);
+        XFS_SCRUB_SB_FEAT(rmapbt);
+        XFS_SCRUB_SB_FEAT(reflink);
+#undef XFS_SCRUB_SB_FEAT
+
+out:
+	xfs_buf_relse(bp);
+	return error;
+}
+
 /* Scrubbing dispatch. */
 
 struct xfs_scrub_meta_fns {
@@ -712,6 +786,7 @@ struct xfs_scrub_meta_fns {
 };
 
 static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
+	{xfs_scrub_sb,		NULL},
 };
 
 /* Dispatch metadata scrubbing. */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
