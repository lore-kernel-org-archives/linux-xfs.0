Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8C5448457
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 19:00:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5C440304039
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 17:00:51 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 48JRZZ5bTLui7fJ7 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 17:00:48 -0700 (PDT)
Subject: [PATCH 19/29] xfs_db: make fsmap query the realtime reverse mapping
	tree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 17:00:36 -0700
Message-ID: <147216963661.7022.10313609648459852221.stgit@birch.djwong.org>
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

Extend the 'fsmap' debugger command to support querying the realtime
rmap btree via a new -r argument.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/fsmap.c               |   70 +++++++++++++++++++++++++++++++++++++++++++---
 libxfs/libxfs_api_defs.h |    1 +
 2 files changed, 67 insertions(+), 4 deletions(-)


diff --git a/db/fsmap.c b/db/fsmap.c
index a25461e..bb08421 100644
--- a/db/fsmap.c
+++ b/db/fsmap.c
@@ -36,8 +36,8 @@ fsmap_fn(
 {
 	struct fsmap_info	*info = priv;
 
-	dbprintf(_("%llu: %u/%u len %u owner %lld offset %llu bmbt %d attrfork %d extflag %d\n"),
-		info->nr, info->agno, rec->rm_startblock,
+	dbprintf(_("%llu: %d/%llu len %llu owner %lld offset %llu bmbt %d attrfork %d extflag %d\n"),
+		info->nr, (signed)info->agno, rec->rm_startblock,
 		rec->rm_blockcount, rec->rm_owner, rec->rm_offset,
 		!!(rec->rm_flags & XFS_RMAP_BMBT_BLOCK),
 		!!(rec->rm_flags & XFS_RMAP_ATTR_FORK),
@@ -113,6 +113,61 @@ fsmap(
 	}
 }
 
+static void
+fsmap_rt(
+	xfs_fsblock_t		start_fsb,
+	xfs_fsblock_t		end_fsb)
+{
+	struct fsmap_info	info;
+	xfs_daddr_t		eofs;
+	struct xfs_rmap_irec	low;
+	struct xfs_rmap_irec	high;
+	struct xfs_btree_cur	*bt_cur;
+	struct xfs_inode	*ip;
+	int			error;
+
+	if (mp->m_sb.sb_rblocks == 0)
+		return;
+
+	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rblocks);
+	if (XFS_FSB_TO_DADDR(mp, end_fsb) >= eofs)
+		end_fsb = XFS_DADDR_TO_FSB(mp, eofs - 1);
+
+	low.rm_startblock = start_fsb;
+	low.rm_owner = 0;
+	low.rm_offset = 0;
+	low.rm_flags = 0;
+	high.rm_startblock = end_fsb;
+	high.rm_owner = ULLONG_MAX;
+	high.rm_offset = ULLONG_MAX;
+	high.rm_flags = XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK |
+			XFS_RMAP_UNWRITTEN;
+
+	info.nr = 0;
+
+	error = -libxfs_iget(mp, NULL, mp->m_sb.sb_rrmapino, 0, &ip, 0);
+	if (error) {
+		dbprintf(_("%d - couldn't iget rtrmap inode.\n"),
+			 error);
+		return;
+	}
+
+	bt_cur = libxfs_rtrmapbt_init_cursor(mp, NULL, ip);
+	if (!bt_cur)
+		goto out_ino;
+
+	info.agno = NULLAGNUMBER;
+	error = -libxfs_rmap_query_range(bt_cur, &low, &high,
+			fsmap_fn, &info);
+	if (error)
+		dbprintf(_("Error %d while querying fsmap btree.\n"),
+			error);
+
+	libxfs_btree_del_cursor(bt_cur, XFS_BTREE_NOERROR);
+out_ino:
+	IRELE(ip);
+}
+
 int
 fsmap_f(
 	int			argc,
@@ -122,14 +177,18 @@ fsmap_f(
 	int			c;
 	xfs_fsblock_t		start_fsb = 0;
 	xfs_fsblock_t		end_fsb = NULLFSBLOCK;
+	bool			is_rt = false;
 
 	if (!xfs_sb_version_hasrmapbt(&mp->m_sb)) {
 		dbprintf(_("Filesystem does not support reverse mapping btree.\n"));
 		return 0;
 	}
 
-	while ((c = getopt(argc, argv, "")) != EOF) {
+	while ((c = getopt(argc, argv, "r")) != EOF) {
 		switch (c) {
+		case 'r':
+			is_rt = true;
+			break;
 		default:
 			dbprintf(_("Bad option for fsmap command.\n"));
 			return 0;
@@ -152,7 +211,10 @@ fsmap_f(
 		}
 	}
 
-	fsmap(start_fsb, end_fsb);
+	if (is_rt)
+		fsmap_rt(start_fsb, end_fsb);
+	else
+		fsmap(start_fsb, end_fsb);
 
 	return 0;
 }
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index c66e31b..a6ea865 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -143,5 +143,6 @@
 #define xfs_rmap_lookup_le_range	libxfs_rmap_lookup_le_range
 #define xfs_refc_block			libxfs_refc_block
 #define xfs_rtrmapbt_maxrecs		libxfs_rtrmapbt_maxrecs
+#define xfs_rtrmapbt_init_cursor	libxfs_rtrmapbt_init_cursor
 
 #endif /* __LIBXFS_API_DEFS_H__ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
