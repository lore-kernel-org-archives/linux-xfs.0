Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 041FC7F5D
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 02:56:38 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DA97E8F8052
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:56:37 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id iPrJmP67XQKFqMHF (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:56:36 -0800 (PST)
Subject: [PATCH 01/76] libxfs: make xfs_alloc_fix_freelist non-static
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 00:56:30 -0800
Message-ID: <20151219085630.12713.24724.stgit@birch.djwong.org>
In-Reply-To: <20151219085622.12713.88678.stgit@birch.djwong.org>
References: <20151219085622.12713.88678.stgit@birch.djwong.org>
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

Since xfs_repair wants to use xfs_alloc_fix_freelist, remove the
static designation.  xfsprogs already has this; this simply brings
the kernel up to date.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c |    2 +-
 fs/xfs/libxfs/xfs_alloc.h |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 3479294..89c4775 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1926,7 +1926,7 @@ xfs_alloc_space_available(
  * Decide whether to use this allocation group for this allocation.
  * If so, fix up the btree freelist's size.
  */
-STATIC int			/* error */
+int			/* error */
 xfs_alloc_fix_freelist(
 	struct xfs_alloc_arg	*args,	/* allocation argument structure */
 	int			flags)	/* XFS_ALLOC_FLAG_... */
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 0ecde4d..135eb3d 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -235,5 +235,6 @@ xfs_alloc_get_rec(
 
 int xfs_read_agf(struct xfs_mount *mp, struct xfs_trans *tp,
 			xfs_agnumber_t agno, int flags, struct xfs_buf **bpp);
+int xfs_alloc_fix_freelist(struct xfs_alloc_arg *args, int flags);
 
 #endif	/* __XFS_ALLOC_H__ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
