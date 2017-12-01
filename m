Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24567 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751265AbdLAXXu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Dec 2017 18:23:50 -0500
Date: Fri, 1 Dec 2017 15:23:43 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 3/4] xfs: factor out scrub input checking
Message-ID: <20171201232343.GD21412@magnolia>
References: <2f4bb05f-fd41-7fa3-22f0-9ec9d2224a47@redhat.com>
 <1d269656-35e3-f54a-884d-9ba01ae3f5ba@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d269656-35e3-f54a-884d-9ba01ae3f5ba@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

From: Eric Sandeen <sandeen@sandeen.net>

Do this before adding more core checks.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
[darrick: rename input validation function]
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/scrub.c |   75 +++++++++++++++++++++++++++++---------------------
 1 file changed, 44 insertions(+), 31 deletions(-)

diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index dc1f33a..182d2fe 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -285,47 +285,34 @@ xfs_scrub_experimental_warning(
 "EXPERIMENTAL online scrub feature in use. Use at your own risk!");
 }
 
-/* Dispatch metadata scrubbing. */
-int
-xfs_scrub_metadata(
-	struct xfs_inode		*ip,
+static int
+xfs_scrub_validate_inputs(
+	struct xfs_mount		*mp,
 	struct xfs_scrub_metadata	*sm)
 {
-	struct xfs_scrub_context	sc;
-	struct xfs_mount		*mp = ip->i_mount;
+	int				error;
 	const struct xfs_scrub_meta_ops	*ops;
-	bool				try_harder = false;
-	int				error = 0;
-
-	BUILD_BUG_ON(sizeof(meta_scrub_ops) !=
-		(sizeof(struct xfs_scrub_meta_ops) * XFS_SCRUB_TYPE_NR));
-
-	trace_xfs_scrub_start(ip, sm, error);
-
-	/* Forbidden if we are shut down or mounted norecovery. */
-	error = -ESHUTDOWN;
-	if (XFS_FORCED_SHUTDOWN(mp))
-		goto out;
-	error = -ENOTRECOVERABLE;
-	if (mp->m_flags & XFS_MOUNT_NORECOVERY)
-		goto out;
 
-	/* Check our inputs. */
 	error = -EINVAL;
+	/* Check our inputs. */
 	sm->sm_flags &= ~XFS_SCRUB_FLAGS_OUT;
 	if (sm->sm_flags & ~XFS_SCRUB_FLAGS_IN)
 		goto out;
 	if (memchr_inv(sm->sm_reserved, 0, sizeof(sm->sm_reserved)))
 		goto out;
 
-	/* Do we know about this type of metadata? */
 	error = -ENOENT;
+	/* Do we know about this type of metadata? */
 	if (sm->sm_type >= XFS_SCRUB_TYPE_NR)
 		goto out;
 	ops = &meta_scrub_ops[sm->sm_type];
 	if (ops->setup == NULL || ops->scrub == NULL)
 		goto out;
+	/* Does this fs even support this type of metadata? */
+	if (ops->has && !ops->has(&mp->m_sb))
+		goto out;
 
+	error = -EOPNOTSUPP;
 	/*
 	 * We won't scrub any filesystem that doesn't have the ability
 	 * to record unwritten extents.  The option was made default in
@@ -335,20 +322,46 @@ xfs_scrub_metadata(
 	 * We also don't support v1-v3 filesystems, which aren't
 	 * mountable.
 	 */
-	error = -EOPNOTSUPP;
 	if (!xfs_sb_version_hasextflgbit(&mp->m_sb))
 		goto out;
 
-	/* Does this fs even support this type of metadata? */
-	error = -ENOENT;
-	if (ops->has && !ops->has(&mp->m_sb))
-		goto out;
-
 	/* We don't know how to repair anything yet. */
-	error = -EOPNOTSUPP;
 	if (sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR)
 		goto out;
 
+	error = 0;
+out:
+	return error;
+}
+
+/* Dispatch metadata scrubbing. */
+int
+xfs_scrub_metadata(
+	struct xfs_inode		*ip,
+	struct xfs_scrub_metadata	*sm)
+{
+	struct xfs_scrub_context	sc;
+	struct xfs_mount		*mp = ip->i_mount;
+	bool				try_harder = false;
+	int				error = 0;
+
+	BUILD_BUG_ON(sizeof(meta_scrub_ops) !=
+		(sizeof(struct xfs_scrub_meta_ops) * XFS_SCRUB_TYPE_NR));
+
+	trace_xfs_scrub_start(ip, sm, error);
+
+	/* Forbidden if we are shut down or mounted norecovery. */
+	error = -ESHUTDOWN;
+	if (XFS_FORCED_SHUTDOWN(mp))
+		goto out;
+	error = -ENOTRECOVERABLE;
+	if (mp->m_flags & XFS_MOUNT_NORECOVERY)
+		goto out;
+
+	error = xfs_scrub_validate_inputs(mp, sm);
+	if (error)
+		goto out;
+
 	xfs_scrub_experimental_warning(mp);
 
 retry_op:
@@ -356,7 +369,7 @@ xfs_scrub_metadata(
 	memset(&sc, 0, sizeof(sc));
 	sc.mp = ip->i_mount;
 	sc.sm = sm;
-	sc.ops = ops;
+	sc.ops = &meta_scrub_ops[sm->sm_type];
 	sc.try_harder = try_harder;
 	sc.sa.agno = NULLAGNUMBER;
 	error = sc.ops->setup(&sc, ip);
