Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17752 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753021AbcKEAU1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:20:27 -0400
Subject: [PATCH 12/41] xfs: scrub the backup superblocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:20:22 -0700
Message-ID: <147830522198.2155.12250037056347893426.stgit@birch.djwong.org>
In-Reply-To: <147830514302.2155.3920703176812208304.stgit@birch.djwong.org>
References: <147830514302.2155.3920703176812208304.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Ensure that the geometry presented in the backup superblocks matches
the primary superblock so that repair can recover the filesystem if
that primary gets corrupted.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h |    3 +-
 fs/xfs/xfs_scrub.c     |   94 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trace.h     |    3 +-
 3 files changed, 98 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 34fd6c1..e176147 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -575,7 +575,8 @@ struct xfs_scrub_metadata {
  * Metadata types and flags for scrub operation.
  */
 #define XFS_SCRUB_TYPE_TEST	0	/* dummy to test ioctl */
-#define XFS_SCRUB_TYPE_MAX	0
+#define XFS_SCRUB_TYPE_SB	1	/* superblock */
+#define XFS_SCRUB_TYPE_MAX	1
 
 #define XFS_SCRUB_FLAG_REPAIR	0x1	/* i: repair this metadata */
 #define XFS_SCRUB_FLAG_CORRUPT	0x2	/* o: needs repair */
diff --git a/fs/xfs/xfs_scrub.c b/fs/xfs/xfs_scrub.c
index 0647c88..9237103 100644
--- a/fs/xfs/xfs_scrub.c
+++ b/fs/xfs/xfs_scrub.c
@@ -1303,6 +1303,99 @@ xfs_scrub_setup(
 			0, 0, 0, &sc->tp);
 }
 
+/* Set us up to check an AG header. */
+STATIC int
+xfs_scrub_setup_ag(
+	struct xfs_scrub_context	*sc,
+	struct xfs_inode		*ip,
+	struct xfs_scrub_metadata	*sm,
+	bool				retry_deadlocked)
+{
+	struct xfs_mount		*mp = ip->i_mount;
+
+	if (sm->sm_agno >= mp->m_sb.sb_agcount)
+		return -EINVAL;
+	return xfs_scrub_setup(sc, ip, sm, retry_deadlocked);
+}
+
+/* Metadata scrubbers */
+
+#define XFS_SCRUB_SB_CHECK(fs_ok) \
+	XFS_SCRUB_CHECK(sc, bp, "superblock", fs_ok)
+#define XFS_SCRUB_SB_OP_ERROR_GOTO(label) \
+	XFS_SCRUB_OP_ERROR_GOTO(sc, agno, 0, "superblock", &error, out)
+/* Scrub the filesystem superblock. */
+STATIC int
+xfs_scrub_superblock(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_mount		*mp = sc->tp->t_mountp;
+	struct xfs_buf			*bp;
+	struct xfs_sb			sb;
+	xfs_agnumber_t			agno;
+	int				error;
+
+	agno = sc->sm->sm_agno;
+
+	error = xfs_trans_read_buf(mp, sc->tp, mp->m_ddev_targp,
+		  XFS_AGB_TO_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
+		  XFS_FSS_TO_BB(mp, 1), 0, &bp,
+		  &xfs_sb_buf_ops);
+	XFS_SCRUB_SB_OP_ERROR_GOTO(out);
+
+	/*
+	 * The in-core sb is a more up-to-date copy of AG 0's sb,
+	 * so there's no point in comparing the two.
+	 */
+	if (agno == 0)
+		goto out;
+
+	xfs_sb_from_disk(&sb, XFS_BUF_TO_SBP(bp));
+
+	/* Verify the geometries match. */
+#define XFS_SCRUB_SB_FIELD(fn) \
+		XFS_SCRUB_SB_CHECK(sb.sb_##fn == mp->m_sb.sb_##fn)
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
+		XFS_SCRUB_SB_CHECK(xfs_sb_version_has##fn(&sb) == \
+		xfs_sb_version_has##fn(&mp->m_sb))
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
+	return error;
+}
+#undef XFS_SCRUB_SB_OP_ERROR_GOTO
+#undef XFS_SCRUB_SB_CHECK
+
 /* Scrubbing dispatch. */
 
 struct xfs_scrub_meta_fns {
@@ -1315,6 +1408,7 @@ struct xfs_scrub_meta_fns {
 
 static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
 	{xfs_scrub_setup, xfs_scrub_dummy, NULL, NULL},
+	{xfs_scrub_setup_ag, xfs_scrub_superblock, NULL, NULL},
 };
 
 /* Dispatch metadata scrubbing. */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index f004784..94bae99 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3462,7 +3462,8 @@ DEFINE_GETFSMAP_EVENT(xfs_getfsmap_mapping);
 
 /* scrub */
 #define XFS_SCRUB_TYPE_DESC \
-	{ XFS_SCRUB_TYPE_TEST,		"dummy" }
+	{ XFS_SCRUB_TYPE_TEST,		"dummy" }, \
+	{ XFS_SCRUB_TYPE_SB,		"superblock" }
 DECLARE_EVENT_CLASS(xfs_scrub_class,
 	TP_PROTO(struct xfs_inode *ip, int type, xfs_agnumber_t agno,
 		 xfs_ino_t inum, unsigned int gen, unsigned int flags,

