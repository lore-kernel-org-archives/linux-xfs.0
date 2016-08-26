Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1C4088479
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 19:01:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C65AF8F8033
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 17:01:07 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id YuHDP557CtmS8T3n (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 17:01:05 -0700 (PDT)
Subject: [PATCH 22/29] xfs_repair: pass private data pointer to scan_lbtree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 17:00:57 -0700
Message-ID: <147216965723.7022.951619178919594524.stgit@birch.djwong.org>
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

Pass a private data pointer through scan_lbtree.  We'll use this
later when scanning the rtrmapbt to keep track of scan state.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/dinode.c |    2 +-
 repair/scan.c   |   11 +++++++----
 repair/scan.h   |    7 +++++--
 3 files changed, 13 insertions(+), 7 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index 11b60ce..843c465 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -1007,7 +1007,7 @@ _("bad bmap btree ptr 0x%" PRIx64 " in ino %" PRIu64 "\n"),
 
 		if (scan_lbtree(get_unaligned_be64(&pp[i]), level, scan_bmapbt,
 				type, whichfork, lino, tot, nex, blkmapp,
-				&cursor, 1, check_dups, magic,
+				&cursor, 1, check_dups, magic, NULL,
 				&xfs_bmbt_buf_ops))
 			return(1);
 		/*
diff --git a/repair/scan.c b/repair/scan.c
index f4d6f89..8935be7 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -116,7 +116,8 @@ scan_lbtree(
 				int			isroot,
 				int			check_dups,
 				int			*dirty,
-				__uint64_t		magic),
+				__uint64_t		magic,
+				void			*priv),
 	int		type,
 	int		whichfork,
 	xfs_ino_t	ino,
@@ -127,6 +128,7 @@ scan_lbtree(
 	int		isroot,
 	int		check_dups,
 	__uint64_t	magic,
+	void		*priv,
 	const struct xfs_buf_ops *ops)
 {
 	xfs_buf_t	*bp;
@@ -158,7 +160,7 @@ scan_lbtree(
 	err = (*func)(XFS_BUF_TO_BLOCK(bp), nlevels - 1,
 			type, whichfork, root, ino, tot, nex, blkmapp,
 			bm_cursor, isroot, check_dups, &dirty,
-			magic);
+			magic, priv);
 
 	ASSERT(dirty == 0 || (dirty && !no_modify));
 
@@ -185,7 +187,8 @@ scan_bmapbt(
 	int			isroot,
 	int			check_dups,
 	int			*dirty,
-	__uint64_t		magic)
+	__uint64_t		magic,
+	void			*priv)
 {
 	int			i;
 	int			err;
@@ -469,7 +472,7 @@ _("bad bmap btree ptr 0x%llx in ino %" PRIu64 "\n"),
 
 		err = scan_lbtree(be64_to_cpu(pp[i]), level, scan_bmapbt,
 				type, whichfork, ino, tot, nex, blkmapp,
-				bm_cursor, 0, check_dups, magic,
+				bm_cursor, 0, check_dups, magic, priv,
 				&xfs_bmbt_buf_ops);
 		if (err)
 			return(1);
diff --git a/repair/scan.h b/repair/scan.h
index ea8c0bf..854897c 100644
--- a/repair/scan.h
+++ b/repair/scan.h
@@ -36,7 +36,8 @@ int scan_lbtree(
 				int			isroot,
 				int			check_dups,
 				int			*dirty,
-				__uint64_t		magic),
+				__uint64_t		magic,
+				void			*priv),
 	int		type,
 	int		whichfork,
 	xfs_ino_t	ino,
@@ -47,6 +48,7 @@ int scan_lbtree(
 	int		isroot,
 	int		check_dups,
 	__uint64_t	magic,
+	void		*priv,
 	const struct xfs_buf_ops *ops);
 
 int scan_bmapbt(
@@ -63,7 +65,8 @@ int scan_bmapbt(
 	int			isroot,
 	int			check_dups,
 	int			*dirty,
-	__uint64_t		magic);
+	__uint64_t		magic,
+	void			*priv);
 
 void
 scan_ags(

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
