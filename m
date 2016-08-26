Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4F04184A9
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 19:01:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B54C4AC001
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 17:01:52 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id dbwCWoBYrYFMvXWN (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 17:01:50 -0700 (PDT)
Subject: [PATCH 29/29] mkfs: create the realtime rmap inode
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 17:01:45 -0700
Message-ID: <147216970577.7022.917857374242640355.stgit@birch.djwong.org>
In-Reply-To: <147216950911.7022.438115723996286926.stgit@birch.djwong.org>
References: <147216950911.7022.438115723996286926.stgit@birch.djwong.org>
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

Create a realtime rmapbt inode if we format the fs with realtime
and rmap.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/libxfs_api_defs.h |    1 +
 mkfs/proto.c             |   51 +++++++++++++++++++++++++++++++---------------
 mkfs/xfs_mkfs.c          |   19 +++++++++++------
 3 files changed, 47 insertions(+), 24 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 44b9065..e567076 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -145,5 +145,6 @@
 #define xfs_rtrmapbt_maxrecs		libxfs_rtrmapbt_maxrecs
 #define xfs_rtrmapbt_init_cursor	libxfs_rtrmapbt_init_cursor
 #define xfs_rmap_map_extent		libxfs_rmap_map_extent
+#define xfs_btree_compute_maxlevels	libxfs_btree_compute_maxlevels
 
 #endif /* __LIBXFS_API_DEFS_H__ */
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 1de77f8..bf31483 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -626,24 +626,25 @@ parse_proto(
  */
 static void
 rtinit(
-	xfs_mount_t	*mp)
+	struct xfs_mount	*mp)
 {
-	xfs_fileoff_t	bno;
-	xfs_fileoff_t	ebno;
-	xfs_bmbt_irec_t	*ep;
-	int		error;
-	xfs_fsblock_t	first;
+	xfs_fileoff_t		bno;
+	xfs_fileoff_t		ebno;
+	struct xfs_bmbt_irec	*ep;
+	int			error;
+	xfs_fsblock_t		first;
 	struct xfs_defer_ops	dfops;
-	int		i;
-	xfs_bmbt_irec_t	map[XFS_BMAP_MAX_NMAP];
-	xfs_extlen_t	nsumblocks;
-	int		nmap;
-	xfs_inode_t	*rbmip;
-	xfs_inode_t	*rsumip;
-	xfs_trans_t	*tp;
-	struct cred	creds;
-	struct fsxattr	fsxattrs;
-	struct xfs_trans_res tres = {0};
+	int			i;
+	struct xfs_bmbt_irec	map[XFS_BMAP_MAX_NMAP];
+	xfs_extlen_t		nsumblocks;
+	int			nmap;
+	struct xfs_inode	*rbmip;
+	struct xfs_inode	*rsumip;
+	struct xfs_inode	*rrmapip;
+	struct xfs_trans	*tp;
+	struct cred		creds;
+	struct fsxattr		fsxattrs;
+	struct xfs_trans_res	tres = {0};
 
 	/*
 	 * First, allocate the inodes.
@@ -680,8 +681,24 @@ rtinit(
 	rsumip->i_d.di_size = mp->m_rsumsize;
 	libxfs_trans_log_inode(tp, rsumip, XFS_ILOG_CORE);
 	libxfs_log_sb(tp);
-	libxfs_trans_commit(tp);
 	mp->m_rsumip = rsumip;
+
+	/* If we have rmap and a realtime device, create a rtrmapbt inode. */
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb) && mp->m_sb.sb_rblocks > 0) {
+		error = -libxfs_inode_alloc(&tp, NULL, S_IFREG, 1, 0,
+				&creds, &fsxattrs, &rrmapip);
+		if (error) {
+			fail(_("Realtime rmap inode allocation failed"), error);
+		}
+		mp->m_sb.sb_rrmapino = rrmapip->i_ino;
+		rrmapip->i_d.di_size = 0;
+		rrmapip->i_d.di_format = XFS_DINODE_FMT_RMAP;
+		libxfs_trans_log_inode(tp, rrmapip, XFS_ILOG_CORE);
+		libxfs_log_sb(tp);
+		mp->m_rrmapip = rrmapip;
+	}
+	libxfs_trans_commit(tp);
+
 	/*
 	 * Next, give the bitmap file some zero-filled blocks.
 	 */
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index fc565c0..e7bc044 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2141,13 +2141,6 @@ _("reflink not supported without CRC support\n"));
 	}
 
 
-	if (sb_feat.rmapbt && xi.rtname) {
-		fprintf(stderr,
-_("rmapbt not supported with realtime devices\n"));
-		usage();
-		sb_feat.rmapbt = false;
-	}
-
 	if (nsflag || nlflag) {
 		if (dirblocksize < blocksize ||
 					dirblocksize > XFS_MAX_BLOCKSIZE) {
@@ -2908,6 +2901,18 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		exit(1);
 	}
 
+	/* The realtime rmapbt mustn't grow taller than max btree height. */
+	if (xfs_sb_version_hasrtrmapbt(&mp->m_sb) &&
+	    libxfs_btree_compute_maxlevels(mp, mp->m_rtrmap_mnr,
+			mp->m_sb.sb_rblocks) > XFS_BTREE_MAXLEVELS) {
+		fprintf(stderr,
+_("%s: max realtime rmapbt height (%d) exceeds configured maximum (%d)\n"),
+			progname, libxfs_btree_compute_maxlevels(mp,
+			mp->m_rtrmap_mnr, mp->m_sb.sb_rblocks),
+			XFS_BTREE_MAXLEVELS);
+		exit(1);
+	}
+
 	/*
 	 * XXX: this code is effectively shared with the kernel growfs code.
 	 * These initialisations should be pulled into libxfs to keep the

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
