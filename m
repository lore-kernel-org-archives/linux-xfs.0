Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17894 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751493AbcKEAVJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:21:09 -0400
Subject: [PATCH 19/41] xfs: scrub inodes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:21:06 -0700
Message-ID: <147830526600.2155.16582110516346949006.stgit@birch.djwong.org>
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

Scrub the fields within an inode.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h |    3 +
 fs/xfs/xfs_itable.c    |    2 -
 fs/xfs/xfs_itable.h    |    5 ++
 fs/xfs/xfs_scrub.c     |  144 +++++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_trace.h     |    3 +
 5 files changed, 152 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 559ee76..251db32 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -585,7 +585,8 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_FINOBT	8	/* free inode btree */
 #define XFS_SCRUB_TYPE_RMAPBT	9	/* reverse mapping btree */
 #define XFS_SCRUB_TYPE_REFCNTBT	10	/* reference count btree */
-#define XFS_SCRUB_TYPE_MAX	10
+#define XFS_SCRUB_TYPE_INODE	11	/* inode record */
+#define XFS_SCRUB_TYPE_MAX	11
 
 #define XFS_SCRUB_FLAG_REPAIR	0x1	/* i: repair this metadata */
 #define XFS_SCRUB_FLAG_CORRUPT	0x2	/* o: needs repair */
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 66e8817..4fd5fe1 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -31,7 +31,7 @@
 #include "xfs_trace.h"
 #include "xfs_icache.h"
 
-STATIC int
+int
 xfs_internal_inum(
 	xfs_mount_t	*mp,
 	xfs_ino_t	ino)
diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
index 6ea8b39..dd2427b 100644
--- a/fs/xfs/xfs_itable.h
+++ b/fs/xfs/xfs_itable.h
@@ -96,4 +96,9 @@ xfs_inumbers(
 	void			__user *buffer, /* buffer with inode info */
 	inumbers_fmt_pf		formatter);
 
+int
+xfs_internal_inum(
+	xfs_mount_t	*mp,
+	xfs_ino_t	ino);
+
 #endif	/* __XFS_ITABLE_H__ */
diff --git a/fs/xfs/xfs_scrub.c b/fs/xfs/xfs_scrub.c
index ab92ea4..3723c06 100644
--- a/fs/xfs/xfs_scrub.c
+++ b/fs/xfs/xfs_scrub.c
@@ -45,6 +45,8 @@
 #include "xfs_rtalloc.h"
 #include "xfs_log.h"
 #include "xfs_trans_priv.h"
+#include "xfs_icache.h"
+#include "xfs_itable.h"
 
 /*
  * Online Scrub and Repair
@@ -1276,6 +1278,7 @@ xfs_scrub_dummy(
 STATIC int
 xfs_scrub_teardown(
 	struct xfs_scrub_context	*sc,
+	struct xfs_inode		*ip_in,
 	int				error)
 {
 	xfs_scrub_ag_free(&sc->sa);
@@ -1284,6 +1287,14 @@ xfs_scrub_teardown(
 	sc->ag_lock.agmask = NULL;
 	xfs_trans_cancel(sc->tp);
 	sc->tp = NULL;
+	if (sc->ip != NULL) {
+		xfs_iunlock(sc->ip, XFS_ILOCK_EXCL);
+		xfs_iunlock(sc->ip, XFS_IOLOCK_EXCL);
+		xfs_iunlock(sc->ip, XFS_MMAPLOCK_EXCL);
+		if (sc->ip != ip_in)
+			IRELE(sc->ip);
+		sc->ip = NULL;
+	}
 	return error;
 }
 
@@ -1339,6 +1350,82 @@ xfs_scrub_setup_ag_header(
 	return error;
 }
 
+/*
+ * Given an inode and the scrub control structure, return either the
+ * inode referenced in the control structure or the inode passed in.
+ * The inode is not locked.
+ */
+STATIC struct xfs_inode *
+xfs_scrub_get_inode(
+	struct xfs_scrub_context	*sc,
+	struct xfs_inode		*ip)
+{
+	struct xfs_inode		*ips = NULL;
+	int				error;
+
+	if (sc->sm->sm_gen && !sc->sm->sm_ino)
+		return ERR_PTR(-EINVAL);
+
+	if (sc->sm->sm_ino && sc->sm->sm_ino != ip->i_ino) {
+		if (xfs_internal_inum(ip->i_mount, sc->sm->sm_ino))
+			return ERR_PTR(-ENOENT);
+		error = xfs_iget(ip->i_mount, NULL, sc->sm->sm_ino,
+				XFS_IGET_UNTRUSTED | XFS_IGET_DONTCACHE,
+				0, &ips);
+		XFS_SCRUB_OP_ERROR_GOTO(sc,
+				XFS_INO_TO_AGNO(ip->i_mount, sc->sm->sm_ino),
+				XFS_INO_TO_AGBNO(ip->i_mount, sc->sm->sm_ino),
+				"inode", &error, out_err);
+		if (VFS_I(ips)->i_generation != sc->sm->sm_gen) {
+			IRELE(ips);
+			return ERR_PTR(-ENOENT);
+		}
+
+		return ips;
+	}
+
+	return ip;
+out_err:
+	return ERR_PTR(error);
+}
+
+/* Set us up with an inode. */
+STATIC int
+xfs_scrub_setup_inode(
+	struct xfs_scrub_context	*sc,
+	struct xfs_inode		*ip,
+	struct xfs_scrub_metadata	*sm,
+	bool				retry_deadlocked)
+{
+	struct xfs_mount		*mp = ip->i_mount;
+	int				error;
+
+	memset(sc, 0, sizeof(*sc));
+	sc->sm = sm;
+	sc->ip = xfs_scrub_get_inode(sc, ip);
+	if (IS_ERR(sc->ip))
+		return PTR_ERR(sc->ip);
+	else if (sc->ip == NULL)
+		return -ENOENT;
+
+	xfs_ilock(sc->ip, XFS_IOLOCK_EXCL);
+	xfs_ilock(sc->ip, XFS_MMAPLOCK_EXCL);
+	error = xfs_scrub_trans_alloc(sm, mp, &M_RES(mp)->tr_itruncate,
+			0, 0, 0, &sc->tp);
+	if (error)
+		goto out_unlock;
+	xfs_ilock(sc->ip, XFS_ILOCK_EXCL);
+
+	xfs_scrub_ag_lock_init(mp, &sc->ag_lock);
+	return error;
+out_unlock:
+	xfs_iunlock(sc->ip, XFS_IOLOCK_EXCL);
+	xfs_iunlock(sc->ip, XFS_MMAPLOCK_EXCL);
+	if (sc->ip != ip)
+		IRELE(sc->ip);
+	return error;
+}
+
 /* Metadata scrubbers */
 
 #define XFS_SCRUB_SB_CHECK(fs_ok) \
@@ -2022,6 +2109,58 @@ xfs_scrub_refcountbt(
 			&oinfo, NULL);
 }
 
+#define XFS_SCRUB_INODE_CHECK(fs_ok) \
+	XFS_SCRUB_INO_CHECK(sc, NULL, "inode", fs_ok);
+#define XFS_SCRUB_INODE_GOTO(fs_ok, label) \
+	XFS_SCRUB_INO_GOTO(sc, NULL, "inode", fs_ok, label);
+/* Scrub an inode. */
+STATIC int
+xfs_scrub_inode(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_inode		*ip = sc->ip;
+	struct xfs_mount		*mp = ip->i_mount;
+	struct xfs_ifork		*ifp;
+	int				error = 0;
+
+	/* Look for funny values in the fields. */
+	XFS_SCRUB_INODE_CHECK(ip->i_d.di_projid_hi == 0 ||
+			xfs_sb_version_hasprojid32bit(&mp->m_sb));
+
+	if (ip->i_d.di_flags & XFS_DIFLAG_EXTSIZE) {
+		XFS_SCRUB_INODE_CHECK(ip->i_d.di_extsize > 0);
+		XFS_SCRUB_INODE_CHECK(ip->i_d.di_extsize <= MAXEXTLEN);
+		XFS_SCRUB_INODE_CHECK(XFS_IS_REALTIME_INODE(ip) ||
+				ip->i_d.di_extsize <=
+				mp->m_sb.sb_agblocks / 2);
+	}
+	XFS_SCRUB_INODE_CHECK(!(ip->i_d.di_flags & XFS_DIFLAG_IMMUTABLE) ||
+			      !(ip->i_d.di_flags & XFS_DIFLAG_APPEND));
+
+	if (ip->i_d.di_version == 3 &&
+	    ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE) {
+		XFS_SCRUB_INODE_CHECK(xfs_sb_version_hasreflink(&mp->m_sb));
+		XFS_SCRUB_INODE_CHECK(ip->i_d.di_cowextsize > 0);
+		XFS_SCRUB_INODE_CHECK(ip->i_d.di_cowextsize <= MAXEXTLEN);
+		XFS_SCRUB_INODE_CHECK(ip->i_d.di_cowextsize <=
+				mp->m_sb.sb_agblocks / 2);
+	}
+
+	/*
+	 * If this is a reflink inode with no CoW in progress, maybe we
+	 * can turn off the reflink flag?
+	 */
+	if (xfs_is_reflink_inode(ip)) {
+		ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
+		if (ifp->if_bytes == 0)
+			sc->sm->sm_flags |= XFS_SCRUB_FLAG_PREEN;
+	}
+
+	return error;
+}
+#undef XFS_SCRUB_INODE_GOTO
+#undef XFS_SCRUB_INODE_CHECK
+
 /* Scrubbing dispatch. */
 
 struct xfs_scrub_meta_fns {
@@ -2044,6 +2183,7 @@ static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
 	{xfs_scrub_setup_ag_header, xfs_scrub_finobt, NULL, xfs_sb_version_hasfinobt},
 	{xfs_scrub_setup_ag_header, xfs_scrub_rmapbt, NULL, xfs_sb_version_hasrmapbt},
 	{xfs_scrub_setup_ag_header, xfs_scrub_refcountbt, NULL, xfs_sb_version_hasreflink},
+	{xfs_scrub_setup_inode, xfs_scrub_inode, NULL, NULL},
 };
 
 /* Dispatch metadata scrubbing. */
@@ -2107,7 +2247,7 @@ xfs_scrub_metadata(
 	error = fns->scrub(&sc);
 	if (!deadlocked && error == -EDEADLOCK) {
 		deadlocked = true;
-		error = xfs_scrub_teardown(&sc, error);
+		error = xfs_scrub_teardown(&sc, ip, error);
 		if (error != -EDEADLOCK)
 			goto out;
 		goto retry_op;
@@ -2118,7 +2258,7 @@ xfs_scrub_metadata(
 		xfs_alert_ratelimited(mp, "Corruption detected during scrub.");
 
 out_teardown:
-	error = xfs_scrub_teardown(&sc, error);
+	error = xfs_scrub_teardown(&sc, ip, error);
 out:
 	trace_xfs_scrub_done(ip, sm->sm_type, sm->sm_agno, sm->sm_ino,
 			sm->sm_gen, sm->sm_flags, error);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 039ef32..e37c8bc 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3472,7 +3472,8 @@ DEFINE_GETFSMAP_EVENT(xfs_getfsmap_mapping);
 	{ XFS_SCRUB_TYPE_INOBT,		"inobt" }, \
 	{ XFS_SCRUB_TYPE_FINOBT,	"finobt" }, \
 	{ XFS_SCRUB_TYPE_RMAPBT,	"rmapbt" }, \
-	{ XFS_SCRUB_TYPE_REFCNTBT,	"refcountbt" }
+	{ XFS_SCRUB_TYPE_REFCNTBT,	"refcountbt" }, \
+	{ XFS_SCRUB_TYPE_INODE,		"inode" }
 DECLARE_EVENT_CLASS(xfs_scrub_class,
 	TP_PROTO(struct xfs_inode *ip, int type, xfs_agnumber_t agno,
 		 xfs_ino_t inum, unsigned int gen, unsigned int flags,

