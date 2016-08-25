Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4E6D37F32
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:41:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 056FA304043
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:41:55 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id mElOxi9KMjRCCNzX (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:41:54 -0700 (PDT)
Subject: [PATCH 15/25] xfs: scrub inodes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:41:50 -0700
Message-ID: <147216851043.3108.602921681514529851.stgit@birch.djwong.org>
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

Scrub the fields within an inode.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h |    3 +-
 fs/xfs/xfs_itable.c    |    2 +
 fs/xfs/xfs_itable.h    |    5 +++
 fs/xfs/xfs_scrub.c     |   69 ++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 77 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 60dfe03..30903d1 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -545,7 +545,8 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_FINOBT	7	/* free inode btree */
 #define XFS_SCRUB_TYPE_RMAPBT	8	/* reverse mapping btree */
 #define XFS_SCRUB_TYPE_REFCNTBT	9	/* reference count btree */
-#define XFS_SCRUB_TYPE_MAX	9
+#define XFS_SCRUB_TYPE_INODE	10	/* inode record */
+#define XFS_SCRUB_TYPE_MAX	10
 
 #define XFS_SCRUB_FLAGS_ALL	0x0	/* no flags yet */
 
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
index 4894221..383a00e 100644
--- a/fs/xfs/xfs_scrub.c
+++ b/fs/xfs/xfs_scrub.c
@@ -43,6 +43,8 @@
 #include "xfs_rmap.h"
 #include "xfs_rmap_btree.h"
 #include "xfs_rtalloc.h"
+#include "xfs_icache.h"
+#include "xfs_itable.h"
 
 /* Report a scrub corruption in dmesg. */
 STATIC void
@@ -1313,6 +1315,72 @@ xfs_scrub_refcountbt(
 	return error;
 }
 
+/* Scrub an inode. */
+STATIC int
+xfs_scrub_inode(
+	struct xfs_inode		*ip,
+	struct xfs_scrub_metadata	*sm)
+{
+	struct xfs_mount		*mp = ip->i_mount;
+	struct xfs_inode		*ips;
+	int				error;
+
+	if (sm->flags)
+		return -EINVAL;
+
+	if (sm->control && sm->control != ip->i_ino) {
+		if (xfs_internal_inum(mp, sm->control)) {
+			error = -ENOENT;
+			goto out;
+		}
+		error = xfs_iget(ip->i_mount, NULL, sm->control,
+				XFS_IGET_UNTRUSTED | XFS_IGET_DONTCACHE,
+				XFS_ILOCK_EXCL, &ips);
+		if (error)
+			goto out;
+	} else {
+		ips = ip;
+		xfs_ilock(ips, XFS_ILOCK_EXCL);
+	}
+
+	/* The verifiers should refuse any inode with bad fields. */
+	XFS_INO_SCRUB_GOTO(ips, NULL, "inode", ips != NULL, out_unlock);
+
+	XFS_INO_SCRUB_CHECK(ips, NULL, "inode",
+			ips->i_d.di_projid_hi == 0 ||
+			xfs_sb_version_hasprojid32bit(&mp->m_sb));
+
+	if (ips->i_d.di_flags & XFS_DIFLAG_EXTSIZE) {
+		XFS_INO_SCRUB_CHECK(ips, NULL, "inode",
+				ips->i_d.di_extsize > 0);
+		XFS_INO_SCRUB_CHECK(ips, NULL, "inode",
+				ips->i_d.di_extsize <= MAXEXTLEN);
+		XFS_INO_SCRUB_CHECK(ips, NULL, "inode",
+				XFS_IS_REALTIME_INODE(ip) ||
+				ips->i_d.di_extsize <= mp->m_sb.sb_agblocks / 2);
+	}
+	XFS_INO_SCRUB_CHECK(ips, NULL, "inode",
+			!(ip->i_d.di_flags & XFS_DIFLAG_IMMUTABLE) ||
+			!(ip->i_d.di_flags & XFS_DIFLAG_APPEND));
+
+	if (ips->i_d.di_version == 3 &&
+	    ips->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE) {
+		XFS_INO_SCRUB_CHECK(ips, NULL, "inode",
+				ips->i_d.di_cowextsize > 0);
+		XFS_INO_SCRUB_CHECK(ips, NULL, "inode",
+				ips->i_d.di_cowextsize <= MAXEXTLEN);
+		XFS_INO_SCRUB_CHECK(ips, NULL, "inode",
+				ips->i_d.di_cowextsize <= mp->m_sb.sb_agblocks / 2);
+	}
+
+out_unlock:
+	xfs_iunlock(ips, XFS_ILOCK_EXCL);
+	if (ips != ip)
+		IRELE(ips);
+out:
+	return error;
+}
+
 /* Scrubbing dispatch. */
 
 struct xfs_scrub_meta_fns {
@@ -1331,6 +1399,7 @@ static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
 	{xfs_scrub_finobt,	xfs_sb_version_hasfinobt},
 	{xfs_scrub_rmapbt,	xfs_sb_version_hasrmapbt},
 	{xfs_scrub_refcountbt,	xfs_sb_version_hasreflink},
+	{xfs_scrub_inode,	NULL},
 };
 
 /* Dispatch metadata scrubbing. */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
