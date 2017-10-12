Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30219 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752498AbdJLBlE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2017 21:41:04 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9C1f3Iw027499
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2017 01:41:03 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v9C1f3Yj027576
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2017 01:41:03 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v9C1f21O000760
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2017 01:41:03 GMT
Subject: [PATCH 03/30] xfs: refactor btree pointer checks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 11 Oct 2017 18:41:01 -0700
Message-ID: <150777246184.1724.16766765917643944746.stgit@magnolia>
In-Reply-To: <150777244315.1724.6916081372861799350.stgit@magnolia>
References: <150777244315.1724.6916081372861799350.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor the btree pointer checks so that we can call them from the
scrub code without logging errors to dmesg.  Preserve the existing error
reporting for regular operations.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c  |    4 +--
 fs/xfs/libxfs/xfs_btree.c |   70 +++++++++++++++++++++------------------------
 fs/xfs/libxfs/xfs_btree.h |   13 +++++++-
 3 files changed, 45 insertions(+), 42 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 044a363..b4cbd1a 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -657,8 +657,8 @@ xfs_bmap_btree_to_extents(
 	cbno = be64_to_cpu(*pp);
 	*logflagsp = 0;
 #ifdef DEBUG
-	if ((error = xfs_btree_check_lptr(cur, cbno, 1)))
-		return error;
+	XFS_WANT_CORRUPTED_RETURN(cur->bc_mp,
+			xfs_btree_check_lptr(cur, cbno, 1));
 #endif
 	error = xfs_btree_read_bufl(mp, tp, cbno, 0, &cbp, XFS_BMAP_BTREE_REF,
 				&xfs_bmbt_buf_ops);
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 5bfb882..e7e033a 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -177,59 +177,53 @@ xfs_btree_check_block(
 		return xfs_btree_check_sblock(cur, block, level, bp);
 }
 
-/*
- * Check that (long) pointer is ok.
- */
-int					/* error (0 or EFSCORRUPTED) */
+/* Check that this long pointer is valid and points within the fs. */
+bool
 xfs_btree_check_lptr(
-	struct xfs_btree_cur	*cur,	/* btree cursor */
-	xfs_fsblock_t		bno,	/* btree block disk address */
-	int			level)	/* btree block level */
+	struct xfs_btree_cur	*cur,
+	xfs_fsblock_t		fsbno,
+	int			level)
 {
-	XFS_WANT_CORRUPTED_RETURN(cur->bc_mp,
-		level > 0 &&
-		bno != NULLFSBLOCK &&
-		XFS_FSB_SANITY_CHECK(cur->bc_mp, bno));
-	return 0;
+	if (level <= 0)
+		return false;
+	return xfs_verify_fsbno_ptr(cur->bc_mp, fsbno);
 }
 
-#ifdef DEBUG
-/*
- * Check that (short) pointer is ok.
- */
-STATIC int				/* error (0 or EFSCORRUPTED) */
+/* Check that this short pointer is valid and points within the AG. */
+bool
 xfs_btree_check_sptr(
-	struct xfs_btree_cur	*cur,	/* btree cursor */
-	xfs_agblock_t		bno,	/* btree block disk address */
-	int			level)	/* btree block level */
+	struct xfs_btree_cur	*cur,
+	xfs_agblock_t		agbno,
+	int			level)
 {
-	xfs_agblock_t		agblocks = cur->bc_mp->m_sb.sb_agblocks;
-
-	XFS_WANT_CORRUPTED_RETURN(cur->bc_mp,
-		level > 0 &&
-		bno != NULLAGBLOCK &&
-		bno != 0 &&
-		bno < agblocks);
-	return 0;
+	if (level <= 0)
+		return false;
+	return xfs_verify_agbno_ptr(cur->bc_mp, cur->bc_private.a.agno, agbno);
 }
 
+#ifdef DEBUG
 /*
- * Check that block ptr is ok.
+ * Check that a given (indexed) btree pointer at a certain level of a
+ * btree is valid and doesn't point past where it should.
  */
-STATIC int				/* error (0 or EFSCORRUPTED) */
+int
 xfs_btree_check_ptr(
-	struct xfs_btree_cur	*cur,	/* btree cursor */
-	union xfs_btree_ptr	*ptr,	/* btree block disk address */
-	int			index,	/* offset from ptr to check */
-	int			level)	/* btree block level */
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr,
+	int			index,
+	int			level)
 {
 	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
-		return xfs_btree_check_lptr(cur,
-				be64_to_cpu((&ptr->l)[index]), level);
+		XFS_WANT_CORRUPTED_RETURN(cur->bc_mp,
+				xfs_btree_check_lptr(cur,
+					be64_to_cpu((&ptr->l)[index]), level));
 	} else {
-		return xfs_btree_check_sptr(cur,
-				be32_to_cpu((&ptr->s)[index]), level);
+		XFS_WANT_CORRUPTED_RETURN(cur->bc_mp,
+				xfs_btree_check_sptr(cur,
+					be32_to_cpu((&ptr->s)[index]), level));
 	}
+
+	return 0;
 }
 #endif
 
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index f2a88c3..8f52eda 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -269,10 +269,19 @@ xfs_btree_check_block(
 /*
  * Check that (long) pointer is ok.
  */
-int					/* error (0 or EFSCORRUPTED) */
+bool					/* error (0 or EFSCORRUPTED) */
 xfs_btree_check_lptr(
 	struct xfs_btree_cur	*cur,	/* btree cursor */
-	xfs_fsblock_t		ptr,	/* btree block disk address */
+	xfs_fsblock_t		fsbno,	/* btree block disk address */
+	int			level);	/* btree block level */
+
+/*
+ * Check that (short) pointer is ok.
+ */
+bool					/* error (0 or EFSCORRUPTED) */
+xfs_btree_check_sptr(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	xfs_agblock_t		agbno,	/* btree block disk address */
 	int			level);	/* btree block level */
 
 /*

