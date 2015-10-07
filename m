Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D66D37F50
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 23:54:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B8ACF304032
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 21:54:55 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id XvUHAU23QOM83L11 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2015 21:54:54 -0700 (PDT)
Subject: [PATCH 01/58] libxfs: make xfs_alloc_fix_freelist non-static
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 06 Oct 2015 21:54:50 -0700
Message-ID: <20151007045450.30457.29367.stgit@birch.djwong.org>
In-Reply-To: <20151007045443.30457.47038.stgit@birch.djwong.org>
References: <20151007045443.30457.47038.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

Since xfs_repair wants to use xfs_alloc_fix_freelist, remove the
static designation.  xfsprogs already has this; this simply brings
the kernel up to date.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c |    2 +-
 fs/xfs/libxfs/xfs_alloc.h |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index ffad7f2..cc07884 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1924,7 +1924,7 @@ xfs_alloc_space_available(
  * Decide whether to use this allocation group for this allocation.
  * If so, fix up the btree freelist's size.
  */
-STATIC int			/* error */
+int			/* error */
 xfs_alloc_fix_freelist(
 	struct xfs_alloc_arg	*args,	/* allocation argument structure */
 	int			flags)	/* XFS_ALLOC_FLAG_... */
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index ca1c816..071b28b 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -233,5 +233,6 @@ xfs_alloc_get_rec(
 
 int xfs_read_agf(struct xfs_mount *mp, struct xfs_trans *tp,
 			xfs_agnumber_t agno, int flags, struct xfs_buf **bpp);
+int xfs_alloc_fix_freelist(struct xfs_alloc_arg *args, int flags);
 
 #endif	/* __XFS_ALLOC_H__ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
