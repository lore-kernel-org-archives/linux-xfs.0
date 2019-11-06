Return-Path: <SRS0=KqY6=Y6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18FBAC5DF62
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Nov 2019 04:59:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2C36214D8
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Nov 2019 04:59:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JcJcEu7c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731236AbfKFE7V (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Nov 2019 23:59:21 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:51228 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727266AbfKFE7U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Nov 2019 23:59:20 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA64x60r104625;
        Wed, 6 Nov 2019 04:59:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=mMNf5UDs76QA3y6W02IRFseMzPu2NWV/jWrKLoC1tUg=;
 b=JcJcEu7cQwjEf095FmaFVJ6w0uY6FpwkCqUbLItwLnwcm3NSwiBZGj8HUZFlRGXX10U3
 pftJbEIDZKizkP0M3h8rFaJ9QYQZdurnrdrKo6dg+ZbGQNydYk5zT8S3uOfkQIWF8XnB
 mJv4Y3s/OfaHcsGRZRrz7QGH1Isq8csBYpXQHmn28z8T2DryApA3JjshlDuajl8iQsNn
 3sHzYgkb3IH4BSWeQwSUe45l4jZIxkqVdqkCTOWztMqkKSjxMDwo4qQvmzhDqqQGpGcZ
 cFIGGkYRmW1pgDmENL6e2H7VA7MiwGeaiYzHSq0zfgqUP6ShOO5f5aB/2s75z2RPuKQD Jw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2w11rq35g0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 04:59:10 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA64x5rj060961;
        Wed, 6 Nov 2019 04:59:09 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2w35pq7v7t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 04:59:08 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA64wt7X006364;
        Wed, 6 Nov 2019 04:58:55 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 04:58:55 +0000
Date:   Tue, 5 Nov 2019 20:58:53 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     hch@infradead.org
Subject: [PATCH v2 6/6] xfs: convert open coded corruption check to use
 XFS_IS_CORRUPT
Message-ID: <20191106045853.GG4153244@magnolia>
References: <157281984457.4151907.11281776450827989936.stgit@magnolia>
 <157281988255.4151907.18283117772378693924.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157281988255.4151907.18283117772378693924.stgit@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911060052
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911060052
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Convert the last of the open coded corruption check and report idioms to
use the XFS_IS_CORRUPT macro.  In a subsequent patch we are going to add
health reporting to the code block under each corruption check, so we
don't bother to clean out "{ return -EFSCORRUPTED; }".

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c      |    6 +--
 fs/xfs/libxfs/xfs_bmap.c       |   75 +++++++++++++---------------------------
 fs/xfs/libxfs/xfs_btree.c      |   13 +++----
 fs/xfs/libxfs/xfs_da_btree.c   |   58 ++++++++++++-------------------
 fs/xfs/libxfs/xfs_dir2.c       |    8 ++--
 fs/xfs/libxfs/xfs_dir2_node.c  |    9 ++---
 fs/xfs/libxfs/xfs_inode_fork.h |    4 ++
 fs/xfs/libxfs/xfs_refcount.c   |    7 ++--
 fs/xfs/libxfs/xfs_rmap.c       |    3 +-
 fs/xfs/libxfs/xfs_rtbitmap.c   |    3 +-
 fs/xfs/xfs_attr_list.c         |   20 ++++-------
 fs/xfs/xfs_dir2_readdir.c      |   16 +++------
 fs/xfs/xfs_iomap.c             |    7 +---
 fs/xfs/xfs_iops.c              |    3 +-
 fs/xfs/xfs_log_recover.c       |   66 ++++++++++++-----------------------
 fs/xfs/xfs_mount.c             |    7 +---
 fs/xfs/xfs_qm.c                |   10 ++---
 17 files changed, 116 insertions(+), 199 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 1795dc1ba77f..163fafad46c3 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1066,8 +1066,7 @@ xfs_alloc_ag_vextent_small(
 		struct xfs_buf	*bp;
 
 		bp = xfs_btree_get_bufs(args->mp, args->tp, args->agno, fbno);
-		if (!bp) {
-			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, args->mp);
+		if (XFS_IS_CORRUPT(args->mp, !bp)) {
 			error = -EFSCORRUPTED;
 			goto error;
 		}
@@ -2318,8 +2317,7 @@ xfs_free_agfl_block(
 		return error;
 
 	bp = xfs_btree_get_bufs(tp->t_mountp, tp, agno, agbno);
-	if (!bp) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, tp->t_mountp);
+	if (XFS_IS_CORRUPT(tp->t_mountp, !bp)) {
 		return -EFSCORRUPTED;
 	}
 	xfs_trans_binval(tp, bp);
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 34b1fa8a3213..e422f3604c4a 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -731,8 +731,7 @@ xfs_bmap_extents_to_btree(
 	ip->i_d.di_nblocks++;
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, 1L);
 	abp = xfs_btree_get_bufl(mp, tp, args.fsbno);
-	if (!abp) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
+	if (XFS_IS_CORRUPT(mp, !abp)) {
 		error = -EFSCORRUPTED;
 		goto out_unreserve_dquot;
 	}
@@ -1090,8 +1089,7 @@ xfs_bmap_add_attrfork(
 		goto trans_cancel;
 	if (XFS_IFORK_Q(ip))
 		goto trans_cancel;
-	if (ip->i_d.di_anextents != 0) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
+	if (XFS_IS_CORRUPT(mp, ip->i_d.di_anextents != 0)) {
 		error = -EFSCORRUPTED;
 		goto trans_cancel;
 	}
@@ -1238,8 +1236,8 @@ xfs_iread_extents(
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
-	if (unlikely(XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE)) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
+	if (XFS_IS_CORRUPT(mp, XFS_IFORK_FORMAT(ip, whichfork) !=
+			       XFS_DINODE_FMT_BTREE)) {
 		error = -EFSCORRUPTED;
 		goto out;
 	}
@@ -1253,8 +1251,8 @@ xfs_iread_extents(
 	if (error)
 		goto out;
 
-	if (ir.loaded != XFS_IFORK_NEXTENTS(ip, whichfork)) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
+	if (XFS_IS_CORRUPT(mp,
+			   ir.loaded != XFS_IFORK_NEXTENTS(ip, whichfork))) {
 		error = -EFSCORRUPTED;
 		goto out;
 	}
@@ -1445,9 +1443,8 @@ xfs_bmap_last_offset(
 	if (XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_LOCAL)
 		return 0;
 
-	if (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE &&
-	    XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS) {
-		ASSERT(0);
+	if (XFS_IS_CORRUPT(ip->i_mount,
+	    !XFS_IFORK_MAPS_BLOCKS(ip, whichfork))) {
 		return -EFSCORRUPTED;
 	}
 
@@ -3908,11 +3905,8 @@ xfs_bmapi_read(
 			   XFS_BMAPI_COWFORK)));
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED|XFS_ILOCK_EXCL));
 
-	if (unlikely(XFS_TEST_ERROR(
-	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
-	     XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE),
-	     mp, XFS_ERRTAG_BMAPIFORMAT))) {
-		XFS_ERROR_REPORT("xfs_bmapi_read", XFS_ERRLEVEL_LOW, mp);
+	if (XFS_IS_CORRUPT(mp, !XFS_IFORK_MAPS_BLOCKS(ip, whichfork)) ||
+	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
 		return -EFSCORRUPTED;
 	}
 
@@ -4419,11 +4413,8 @@ xfs_bmapi_write(
 	ASSERT((flags & (XFS_BMAPI_PREALLOC | XFS_BMAPI_ZERO)) !=
 			(XFS_BMAPI_PREALLOC | XFS_BMAPI_ZERO));
 
-	if (unlikely(XFS_TEST_ERROR(
-	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
-	     XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE),
-	     mp, XFS_ERRTAG_BMAPIFORMAT))) {
-		XFS_ERROR_REPORT("xfs_bmapi_write", XFS_ERRLEVEL_LOW, mp);
+	if (XFS_IS_CORRUPT(mp, !XFS_IFORK_MAPS_BLOCKS(ip, whichfork)) ||
+	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
 		return -EFSCORRUPTED;
 	}
 
@@ -4689,11 +4680,8 @@ xfs_bmapi_remap(
 	ASSERT((flags & (XFS_BMAPI_ATTRFORK | XFS_BMAPI_PREALLOC)) !=
 			(XFS_BMAPI_ATTRFORK | XFS_BMAPI_PREALLOC));
 
-	if (unlikely(XFS_TEST_ERROR(
-	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
-	     XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE),
-	     mp, XFS_ERRTAG_BMAPIFORMAT))) {
-		XFS_ERROR_REPORT("xfs_bmapi_remap", XFS_ERRLEVEL_LOW, mp);
+	if (XFS_IS_CORRUPT(mp, !XFS_IFORK_MAPS_BLOCKS(ip, whichfork)) ||
+	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
 		return -EFSCORRUPTED;
 	}
 
@@ -5315,7 +5303,7 @@ __xfs_bunmapi(
 	int			isrt;		/* freeing in rt area */
 	int			logflags;	/* transaction logging flags */
 	xfs_extlen_t		mod;		/* rt extent offset */
-	struct xfs_mount	*mp;		/* mount structure */
+	struct xfs_mount	*mp = ip->i_mount;
 	int			tmp_logflags;	/* partial logging flags */
 	int			wasdel;		/* was a delayed alloc extent */
 	int			whichfork;	/* data or attribute fork */
@@ -5332,14 +5320,9 @@ __xfs_bunmapi(
 	whichfork = xfs_bmapi_whichfork(flags);
 	ASSERT(whichfork != XFS_COW_FORK);
 	ifp = XFS_IFORK_PTR(ip, whichfork);
-	if (unlikely(
-	    XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
-	    XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE)) {
-		XFS_ERROR_REPORT("xfs_bunmapi", XFS_ERRLEVEL_LOW,
-				 ip->i_mount);
+	if (XFS_IS_CORRUPT(mp, !XFS_IFORK_MAPS_BLOCKS(ip, whichfork))) {
 		return -EFSCORRUPTED;
 	}
-	mp = ip->i_mount;
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
@@ -5832,11 +5815,8 @@ xfs_bmap_collapse_extents(
 	int			error = 0;
 	int			logflags = 0;
 
-	if (unlikely(XFS_TEST_ERROR(
-	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
-	     XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE),
-	     mp, XFS_ERRTAG_BMAPIFORMAT))) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
+	if (XFS_IS_CORRUPT(mp, !XFS_IFORK_MAPS_BLOCKS(ip, whichfork)) ||
+	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
 		return -EFSCORRUPTED;
 	}
 
@@ -5952,11 +5932,8 @@ xfs_bmap_insert_extents(
 	int			error = 0;
 	int			logflags = 0;
 
-	if (unlikely(XFS_TEST_ERROR(
-	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
-	     XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE),
-	     mp, XFS_ERRTAG_BMAPIFORMAT))) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
+	if (XFS_IS_CORRUPT(mp, !XFS_IFORK_MAPS_BLOCKS(ip, whichfork)) ||
+	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
 		return -EFSCORRUPTED;
 	}
 
@@ -5994,8 +5971,8 @@ xfs_bmap_insert_extents(
 		goto del_cursor;
 	}
 
-	if (stop_fsb >= got.br_startoff + got.br_blockcount) {
-		ASSERT(0);
+	if (XFS_IS_CORRUPT(mp,
+	    stop_fsb >= got.br_startoff + got.br_blockcount)) {
 		error = -EFSCORRUPTED;
 		goto del_cursor;
 	}
@@ -6061,12 +6038,8 @@ xfs_bmap_split_extent_at(
 	int				logflags = 0;
 	int				i = 0;
 
-	if (unlikely(XFS_TEST_ERROR(
-	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
-	     XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE),
-	     mp, XFS_ERRTAG_BMAPIFORMAT))) {
-		XFS_ERROR_REPORT("xfs_bmap_split_extent_at",
-				 XFS_ERRLEVEL_LOW, mp);
+	if (XFS_IS_CORRUPT(mp, !XFS_IFORK_MAPS_BLOCKS(ip, whichfork)) ||
+	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
 		return -EFSCORRUPTED;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 8ad153bc4dea..1fcdb05b84c8 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -105,11 +105,10 @@ xfs_btree_check_lblock(
 	xfs_failaddr_t		fa;
 
 	fa = __xfs_btree_check_lblock(cur, block, level, bp);
-	if (unlikely(XFS_TEST_ERROR(fa != NULL, mp,
-			XFS_ERRTAG_BTREE_CHECK_LBLOCK))) {
+	if (XFS_IS_CORRUPT(mp, fa != NULL) ||
+	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BTREE_CHECK_LBLOCK)) {
 		if (bp)
 			trace_xfs_btree_corrupt(bp, _RET_IP_);
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
 		return -EFSCORRUPTED;
 	}
 	return 0;
@@ -169,11 +168,10 @@ xfs_btree_check_sblock(
 	xfs_failaddr_t		fa;
 
 	fa = __xfs_btree_check_sblock(cur, block, level, bp);
-	if (unlikely(XFS_TEST_ERROR(fa != NULL, mp,
-			XFS_ERRTAG_BTREE_CHECK_SBLOCK))) {
+	if (XFS_IS_CORRUPT(mp, fa != NULL) ||
+	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BTREE_CHECK_SBLOCK)) {
 		if (bp)
 			trace_xfs_btree_corrupt(bp, _RET_IP_);
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
 		return -EFSCORRUPTED;
 	}
 	return 0;
@@ -1868,8 +1866,7 @@ xfs_btree_lookup(
 	XFS_BTREE_STATS_INC(cur, lookup);
 
 	/* No such thing as a zero-level tree. */
-	if (cur->bc_nlevels == 0) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, cur->bc_mp);
+	if (XFS_IS_CORRUPT(cur->bc_mp, cur->bc_nlevels == 0)) {
 		return -EFSCORRUPTED;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 9925d4a7dc33..ed9e09626204 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -1619,15 +1619,12 @@ xfs_da3_node_lookup_int(
 		}
 
 		/* We can't point back to the root. */
-		if (blkno == args->geo->leafblk) {
-			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
-					dp->i_mount);
+		if (XFS_IS_CORRUPT(dp->i_mount, blkno == args->geo->leafblk)) {
 			return -EFSCORRUPTED;
 		}
 	}
 
-	if (expected_level != 0) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, dp->i_mount);
+	if (XFS_IS_CORRUPT(dp->i_mount, expected_level != 0)) {
 		return -EFSCORRUPTED;
 	}
 
@@ -2225,9 +2222,7 @@ xfs_da3_swap_lastblock(
 	error = xfs_bmap_last_before(tp, dp, &lastoff, w);
 	if (error)
 		return error;
-	if (unlikely(lastoff == 0)) {
-		XFS_ERROR_REPORT("xfs_da_swap_lastblock(1)", XFS_ERRLEVEL_LOW,
-				 mp);
+	if (XFS_IS_CORRUPT(mp, lastoff == 0)) {
 		return -EFSCORRUPTED;
 	}
 	/*
@@ -2274,11 +2269,9 @@ xfs_da3_swap_lastblock(
 		if (error)
 			goto done;
 		sib_info = sib_buf->b_addr;
-		if (unlikely(
+		if (XFS_IS_CORRUPT(mp,
 		    be32_to_cpu(sib_info->forw) != last_blkno ||
 		    sib_info->magic != dead_info->magic)) {
-			XFS_ERROR_REPORT("xfs_da_swap_lastblock(2)",
-					 XFS_ERRLEVEL_LOW, mp);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -2296,11 +2289,9 @@ xfs_da3_swap_lastblock(
 		if (error)
 			goto done;
 		sib_info = sib_buf->b_addr;
-		if (unlikely(
-		       be32_to_cpu(sib_info->back) != last_blkno ||
-		       sib_info->magic != dead_info->magic)) {
-			XFS_ERROR_REPORT("xfs_da_swap_lastblock(3)",
-					 XFS_ERRLEVEL_LOW, mp);
+		if (XFS_IS_CORRUPT(mp,
+		    be32_to_cpu(sib_info->back) != last_blkno ||
+		    sib_info->magic != dead_info->magic)) {
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -2321,9 +2312,8 @@ xfs_da3_swap_lastblock(
 			goto done;
 		par_node = par_buf->b_addr;
 		dp->d_ops->node_hdr_from_disk(&par_hdr, par_node);
-		if (level >= 0 && level != par_hdr.level + 1) {
-			XFS_ERROR_REPORT("xfs_da_swap_lastblock(4)",
-					 XFS_ERRLEVEL_LOW, mp);
+		if (XFS_IS_CORRUPT(mp,
+		    level >= 0 && level != par_hdr.level + 1)) {
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -2334,9 +2324,7 @@ xfs_da3_swap_lastblock(
 		     be32_to_cpu(btree[entno].hashval) < dead_hash;
 		     entno++)
 			continue;
-		if (entno == par_hdr.count) {
-			XFS_ERROR_REPORT("xfs_da_swap_lastblock(5)",
-					 XFS_ERRLEVEL_LOW, mp);
+		if (XFS_IS_CORRUPT(mp, entno == par_hdr.count)) {
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -2361,9 +2349,7 @@ xfs_da3_swap_lastblock(
 		par_blkno = par_hdr.forw;
 		xfs_trans_brelse(tp, par_buf);
 		par_buf = NULL;
-		if (unlikely(par_blkno == 0)) {
-			XFS_ERROR_REPORT("xfs_da_swap_lastblock(6)",
-					 XFS_ERRLEVEL_LOW, mp);
+		if (XFS_IS_CORRUPT(mp, par_blkno == 0)) {
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -2372,9 +2358,7 @@ xfs_da3_swap_lastblock(
 			goto done;
 		par_node = par_buf->b_addr;
 		dp->d_ops->node_hdr_from_disk(&par_hdr, par_node);
-		if (par_hdr.level != level) {
-			XFS_ERROR_REPORT("xfs_da_swap_lastblock(7)",
-					 XFS_ERRLEVEL_LOW, mp);
+		if (XFS_IS_CORRUPT(mp, par_hdr.level != level)) {
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -2531,6 +2515,7 @@ xfs_dabuf_map(
 	int			error = 0;
 	struct xfs_bmbt_irec	irec;
 	struct xfs_bmbt_irec	*irecs = &irec;
+	bool			covers_blocks;
 	int			nirecs;
 
 	ASSERT(map && *map);
@@ -2566,14 +2551,16 @@ xfs_dabuf_map(
 		nirecs = 1;
 	}
 
-	if (!xfs_da_map_covers_blocks(nirecs, irecs, bno, nfsb)) {
-		/* Caller ok with no mapping. */
-		if (mappedbno == -2) {
-			error = -1;
-			goto out;
-		}
+	covers_blocks = xfs_da_map_covers_blocks(nirecs, irecs, bno, nfsb);
+
+	/* Caller ok with no mapping. */
+	if (mappedbno == -2 && !covers_blocks) {
+		error = -1;
+		goto out;
+	}
 
-		/* Caller expected a mapping, so abort. */
+	/* Caller expected a mapping, so abort. */
+	if (XFS_IS_CORRUPT(mp, !covers_blocks)) {
 		if (xfs_error_level >= XFS_ERRLEVEL_LOW) {
 			int i;
 
@@ -2589,7 +2576,6 @@ xfs_dabuf_map(
 					irecs[i].br_state);
 			}
 		}
-		XFS_ERROR_REPORT("xfs_da_do_buf(1)", XFS_ERRLEVEL_LOW, mp);
 		error = -EFSCORRUPTED;
 		goto out;
 	}
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 452d04ae10ce..26ddc979d981 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -191,10 +191,10 @@ xfs_dir_ino_validate(
 {
 	bool		ino_ok = xfs_verify_dir_ino(mp, ino);
 
-	if (unlikely(XFS_TEST_ERROR(!ino_ok, mp, XFS_ERRTAG_DIR_INO_VALIDATE))) {
+	if (XFS_IS_CORRUPT(mp, !ino_ok) ||
+	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_DIR_INO_VALIDATE)) {
 		xfs_warn(mp, "Invalid inode number 0x%Lx",
 				(unsigned long long) ino);
-		XFS_ERROR_REPORT("xfs_dir_ino_validate", XFS_ERRLEVEL_LOW, mp);
 		return -EFSCORRUPTED;
 	}
 	return 0;
@@ -600,8 +600,8 @@ xfs_dir2_isblock(
 	if ((rval = xfs_bmap_last_offset(args->dp, &last, XFS_DATA_FORK)))
 		return rval;
 	rval = XFS_FSB_TO_B(args->dp->i_mount, last) == args->geo->blksize;
-	if (rval != 0 && args->dp->i_d.di_size != args->geo->blksize) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, args->dp->i_mount);
+	if (XFS_IS_CORRUPT(args->dp->i_mount,
+	    rval != 0 && args->dp->i_d.di_size != args->geo->blksize)) {
 		return -EFSCORRUPTED;
 	}
 	*vp = rval;
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 72d7ed17eef5..f6d16cd3004d 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -670,9 +670,8 @@ xfs_dir2_leafn_lookup_for_addname(
 			 * If it has room, return it.
 			 */
 			bests = dp->d_ops->free_bests_p(free);
-			if (unlikely(bests[fi] == cpu_to_be16(NULLDATAOFF))) {
-				XFS_ERROR_REPORT("xfs_dir2_leafn_lookup_int",
-							XFS_ERRLEVEL_LOW, mp);
+			if (XFS_IS_CORRUPT(mp,
+			    bests[fi] == cpu_to_be16(NULLDATAOFF))) {
 				if (curfdb != newfdb)
 					xfs_trans_brelse(tp, curbp);
 				return -EFSCORRUPTED;
@@ -1671,7 +1670,8 @@ xfs_dir2_node_add_datablk(
 		if (error)
 			return error;
 
-		if (dp->d_ops->db_to_fdb(args->geo, *dbno) != fbno) {
+		if (XFS_IS_CORRUPT(mp,
+		    dp->d_ops->db_to_fdb(args->geo, *dbno) != fbno)) {
 			xfs_alert(mp,
 "%s: dir ino %llu needed freesp block %lld for data block %lld, got %lld",
 				__func__, (unsigned long long)dp->i_ino,
@@ -1685,7 +1685,6 @@ xfs_dir2_node_add_datablk(
 			} else {
 				xfs_alert(mp, " ... fblk is NULL");
 			}
-			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
 			return -EFSCORRUPTED;
 		}
 
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 7b845c052fb4..e1b9de6c7437 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -87,6 +87,10 @@ struct xfs_ifork {
 #define XFS_IFORK_MAXEXT(ip, w) \
 	(XFS_IFORK_SIZE(ip, w) / sizeof(xfs_bmbt_rec_t))
 
+#define XFS_IFORK_MAPS_BLOCKS(ip, w) \
+		(XFS_IFORK_FORMAT((ip), (w)) == XFS_DINODE_FMT_EXTENTS || \
+		 XFS_IFORK_FORMAT((ip), (w)) == XFS_DINODE_FMT_BTREE)
+
 struct xfs_ifork *xfs_iext_state_to_fork(struct xfs_inode *ip, int state);
 
 int		xfs_iformat_fork(struct xfs_inode *, struct xfs_dinode *);
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 5a3e8aec2a8e..2bcebd482488 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1177,8 +1177,9 @@ xfs_refcount_finish_one(
 				XFS_ALLOC_FLAG_FREEING, &agbp);
 		if (error)
 			return error;
-		if (!agbp)
+		if (XFS_IS_CORRUPT(tp->t_mountp, !agbp)) {
 			return -EFSCORRUPTED;
+		}
 
 		rcur = xfs_refcountbt_init_cursor(mp, tp, agbp, agno);
 		if (!rcur) {
@@ -1668,8 +1669,8 @@ xfs_refcount_recover_extent(
 	struct list_head		*debris = priv;
 	struct xfs_refcount_recovery	*rr;
 
-	if (be32_to_cpu(rec->refc.rc_refcount) != 1) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, cur->bc_mp);
+	if (XFS_IS_CORRUPT(cur->bc_mp,
+	    be32_to_cpu(rec->refc.rc_refcount) != 1)) {
 		return -EFSCORRUPTED;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index b2043691325b..869ac664f8fb 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -2394,8 +2394,9 @@ xfs_rmap_finish_one(
 		error = xfs_free_extent_fix_freelist(tp, agno, &agbp);
 		if (error)
 			return error;
-		if (!agbp)
+		if (XFS_IS_CORRUPT(tp->t_mountp, !agbp)) {
 			return -EFSCORRUPTED;
+		}
 
 		rcur = xfs_rmapbt_init_cursor(mp, tp, agbp, agno);
 		if (!rcur) {
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index d8aaa1de921c..20113c5f11a5 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -70,8 +70,7 @@ xfs_rtbuf_get(
 	if (error)
 		return error;
 
-	if (nmap == 0 || !xfs_bmap_is_real_extent(&map)) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
+	if (XFS_IS_CORRUPT(mp, nmap == 0 || !xfs_bmap_is_real_extent(&map))) {
 		return -EFSCORRUPTED;
 	}
 
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 64f6ceba9254..265207bbef18 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -86,11 +86,9 @@ xfs_attr_shortform_list(
 	    (XFS_ISRESET_CURSOR(cursor) &&
 	     (dp->i_afp->if_bytes + sf->hdr.count * 16) < context->bufsize)) {
 		for (i = 0, sfe = &sf->list[0]; i < sf->hdr.count; i++) {
-			if (!xfs_attr_namecheck(sfe->nameval, sfe->namelen)) {
-				XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
-						 context->dp->i_mount);
+			if (XFS_IS_CORRUPT(context->dp->i_mount,
+			    !xfs_attr_namecheck(sfe->nameval, sfe->namelen)))
 				return -EFSCORRUPTED;
-			}
 			context->put_listent(context,
 					     sfe->flags,
 					     sfe->nameval,
@@ -179,9 +177,8 @@ xfs_attr_shortform_list(
 			cursor->hashval = sbp->hash;
 			cursor->offset = 0;
 		}
-		if (!xfs_attr_namecheck(sbp->name, sbp->namelen)) {
-			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
-					 context->dp->i_mount);
+		if (XFS_IS_CORRUPT(context->dp->i_mount,
+		    !xfs_attr_namecheck(sbp->name, sbp->namelen))) {
 			error = -EFSCORRUPTED;
 			goto out;
 		}
@@ -269,8 +266,7 @@ xfs_attr_node_list_lookup(
 			return 0;
 
 		/* We can't point back to the root. */
-		if (cursor->blkno == 0) {
-			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
+		if (XFS_IS_CORRUPT(mp, cursor->blkno == 0)) {
 			return -EFSCORRUPTED;
 		}
 	}
@@ -473,11 +469,9 @@ xfs_attr3_leaf_list_int(
 			valuelen = be32_to_cpu(name_rmt->valuelen);
 		}
 
-		if (!xfs_attr_namecheck(name, namelen)) {
-			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
-					 context->dp->i_mount);
+		if (XFS_IS_CORRUPT(context->dp->i_mount,
+		    !xfs_attr_namecheck(name, namelen)))
 			return -EFSCORRUPTED;
-		}
 		context->put_listent(context, entry->flags,
 					      name, namelen, valuelen);
 		if (context->seen_enough)
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index a0bec0931f3b..17f883c212f3 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -116,11 +116,9 @@ xfs_dir2_sf_getdents(
 		ino = dp->d_ops->sf_get_ino(sfp, sfep);
 		filetype = dp->d_ops->sf_get_ftype(sfep);
 		ctx->pos = off & 0x7fffffff;
-		if (!xfs_dir2_namecheck(sfep->name, sfep->namelen)) {
-			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
-					 dp->i_mount);
+		if (XFS_IS_CORRUPT(dp->i_mount,
+		    !xfs_dir2_namecheck(sfep->name, sfep->namelen)))
 			return -EFSCORRUPTED;
-		}
 		if (!dir_emit(ctx, (char *)sfep->name, sfep->namelen, ino,
 			    xfs_dir3_get_dtype(dp->i_mount, filetype)))
 			return 0;
@@ -214,9 +212,8 @@ xfs_dir2_block_getdents(
 		/*
 		 * If it didn't fit, set the final offset to here & return.
 		 */
-		if (!xfs_dir2_namecheck(dep->name, dep->namelen)) {
-			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
-					 dp->i_mount);
+		if (XFS_IS_CORRUPT(dp->i_mount,
+		    !xfs_dir2_namecheck(dep->name, dep->namelen))) {
 			error = -EFSCORRUPTED;
 			goto out_rele;
 		}
@@ -467,9 +464,8 @@ xfs_dir2_leaf_getdents(
 		filetype = dp->d_ops->data_get_ftype(dep);
 
 		ctx->pos = xfs_dir2_byte_to_dataptr(curoff) & 0x7fffffff;
-		if (!xfs_dir2_namecheck(dep->name, dep->namelen)) {
-			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
-					 dp->i_mount);
+		if (XFS_IS_CORRUPT(dp->i_mount,
+		    !xfs_dir2_namecheck(dep->name, dep->namelen))) {
 			error = -EFSCORRUPTED;
 			break;
 		}
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 153262c76051..be9e614133e4 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -846,11 +846,8 @@ xfs_buffered_write_iomap_begin(
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 
-	if (unlikely(XFS_TEST_ERROR(
-	    (XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) != XFS_DINODE_FMT_EXTENTS &&
-	     XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) != XFS_DINODE_FMT_BTREE),
-	     mp, XFS_ERRTAG_BMAPIFORMAT))) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
+	if (XFS_IS_CORRUPT(mp, !XFS_IFORK_MAPS_BLOCKS(ip, XFS_DATA_FORK)) ||
+	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
 		error = -EFSCORRUPTED;
 		goto out_unlock;
 	}
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 4c7962ccb0c4..c4711a8c565e 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -481,8 +481,7 @@ xfs_vn_get_link_inline(
 	 * if_data is junk.
 	 */
 	link = ip->i_df.if_u1.if_data;
-	if (!link) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, ip->i_mount);
+	if (XFS_IS_CORRUPT(ip->i_mount, !link)) {
 		return ERR_PTR(-EFSCORRUPTED);
 	}
 	return link;
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 648d5ecafd91..1fdb613e2747 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -103,10 +103,9 @@ xlog_alloc_buffer(
 	 * Pass log block 0 since we don't have an addr yet, buffer will be
 	 * verified on read.
 	 */
-	if (!xlog_verify_bno(log, 0, nbblks)) {
+	if (XFS_IS_CORRUPT(log->l_mp, !xlog_verify_bno(log, 0, nbblks))) {
 		xfs_warn(log->l_mp, "Invalid block length (0x%x) for buffer",
 			nbblks);
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_HIGH, log->l_mp);
 		return NULL;
 	}
 
@@ -152,11 +151,10 @@ xlog_do_io(
 {
 	int			error;
 
-	if (!xlog_verify_bno(log, blk_no, nbblks)) {
+	if (XFS_IS_CORRUPT(log->l_mp, !xlog_verify_bno(log, blk_no, nbblks))) {
 		xfs_warn(log->l_mp,
 			 "Invalid log block/length (0x%llx, 0x%x) for buffer",
 			 blk_no, nbblks);
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_HIGH, log->l_mp);
 		return -EFSCORRUPTED;
 	}
 
@@ -244,19 +242,17 @@ xlog_header_check_recover(
 	 * (XLOG_FMT_UNKNOWN). This stops us from trying to recover
 	 * a dirty log created in IRIX.
 	 */
-	if (unlikely(head->h_fmt != cpu_to_be32(XLOG_FMT))) {
+	if (XFS_IS_CORRUPT(mp, head->h_fmt != cpu_to_be32(XLOG_FMT))) {
 		xfs_warn(mp,
 	"dirty log written in incompatible format - can't recover");
 		xlog_header_check_dump(mp, head);
-		XFS_ERROR_REPORT("xlog_header_check_recover(1)",
-				 XFS_ERRLEVEL_HIGH, mp);
 		return -EFSCORRUPTED;
-	} else if (unlikely(!uuid_equal(&mp->m_sb.sb_uuid, &head->h_fs_uuid))) {
+	}
+	if (XFS_IS_CORRUPT(mp,
+	    !uuid_equal(&mp->m_sb.sb_uuid, &head->h_fs_uuid))) {
 		xfs_warn(mp,
 	"dirty log entry has mismatched uuid - can't recover");
 		xlog_header_check_dump(mp, head);
-		XFS_ERROR_REPORT("xlog_header_check_recover(2)",
-				 XFS_ERRLEVEL_HIGH, mp);
 		return -EFSCORRUPTED;
 	}
 	return 0;
@@ -279,11 +275,10 @@ xlog_header_check_mount(
 		 * by IRIX and continue.
 		 */
 		xfs_warn(mp, "null uuid in log - IRIX style log");
-	} else if (unlikely(!uuid_equal(&mp->m_sb.sb_uuid, &head->h_fs_uuid))) {
+	} else if (XFS_IS_CORRUPT(mp,
+		   !uuid_equal(&mp->m_sb.sb_uuid, &head->h_fs_uuid))) {
 		xfs_warn(mp, "log has mismatched uuid - can't recover");
 		xlog_header_check_dump(mp, head);
-		XFS_ERROR_REPORT("xlog_header_check_mount",
-				 XFS_ERRLEVEL_HIGH, mp);
 		return -EFSCORRUPTED;
 	}
 	return 0;
@@ -1699,11 +1694,9 @@ xlog_clear_stale_blocks(
 		 * the distance from the beginning of the log to the
 		 * tail.
 		 */
-		if (unlikely(head_block < tail_block || head_block >= log->l_logBBsize)) {
-			XFS_ERROR_REPORT("xlog_clear_stale_blocks(1)",
-					 XFS_ERRLEVEL_LOW, log->l_mp);
+		if (XFS_IS_CORRUPT(log->l_mp,
+		    head_block < tail_block || head_block >= log->l_logBBsize))
 			return -EFSCORRUPTED;
-		}
 		tail_distance = tail_block + (log->l_logBBsize - head_block);
 	} else {
 		/*
@@ -1711,11 +1704,9 @@ xlog_clear_stale_blocks(
 		 * so the distance from the head to the tail is just
 		 * the tail block minus the head block.
 		 */
-		if (unlikely(head_block >= tail_block || head_cycle != (tail_cycle + 1))){
-			XFS_ERROR_REPORT("xlog_clear_stale_blocks(2)",
-					 XFS_ERRLEVEL_LOW, log->l_mp);
+		if (XFS_IS_CORRUPT(log->l_mp,
+		    head_block >= tail_block || head_cycle != (tail_cycle + 1)))
 			return -EFSCORRUPTED;
-		}
 		tail_distance = tail_block - head_block;
 	}
 
@@ -2135,13 +2126,11 @@ xlog_recover_do_inode_buffer(
 		 */
 		logged_nextp = item->ri_buf[item_index].i_addr +
 				next_unlinked_offset - reg_buf_offset;
-		if (unlikely(*logged_nextp == 0)) {
+		if (XFS_IS_CORRUPT(mp, *logged_nextp == 0)) {
 			xfs_alert(mp,
 		"Bad inode buffer log record (ptr = "PTR_FMT", bp = "PTR_FMT"). "
 		"Trying to replay bad (0) inode di_next_unlinked field.",
 				item, bp);
-			XFS_ERROR_REPORT("xlog_recover_do_inode_buf",
-					 XFS_ERRLEVEL_LOW, mp);
 			return -EFSCORRUPTED;
 		}
 
@@ -2969,22 +2958,18 @@ xlog_recover_inode_pass2(
 	 * Make sure the place we're flushing out to really looks
 	 * like an inode!
 	 */
-	if (unlikely(!xfs_verify_magic16(bp, dip->di_magic))) {
+	if (XFS_IS_CORRUPT(mp, !xfs_verify_magic16(bp, dip->di_magic))) {
 		xfs_alert(mp,
 	"%s: Bad inode magic number, dip = "PTR_FMT", dino bp = "PTR_FMT", ino = %Ld",
 			__func__, dip, bp, in_f->ilf_ino);
-		XFS_ERROR_REPORT("xlog_recover_inode_pass2(1)",
-				 XFS_ERRLEVEL_LOW, mp);
 		error = -EFSCORRUPTED;
 		goto out_release;
 	}
 	ldip = item->ri_buf[1].i_addr;
-	if (unlikely(ldip->di_magic != XFS_DINODE_MAGIC)) {
+	if (XFS_IS_CORRUPT(mp, ldip->di_magic != XFS_DINODE_MAGIC)) {
 		xfs_alert(mp,
 			"%s: Bad inode log record, rec ptr "PTR_FMT", ino %Ld",
 			__func__, item, in_f->ilf_ino);
-		XFS_ERROR_REPORT("xlog_recover_inode_pass2(2)",
-				 XFS_ERRLEVEL_LOW, mp);
 		error = -EFSCORRUPTED;
 		goto out_release;
 	}
@@ -5200,31 +5185,24 @@ xlog_valid_rec_header(
 {
 	int			hlen;
 
-	if (unlikely(rhead->h_magicno != cpu_to_be32(XLOG_HEADER_MAGIC_NUM))) {
-		XFS_ERROR_REPORT("xlog_valid_rec_header(1)",
-				XFS_ERRLEVEL_LOW, log->l_mp);
+	if (XFS_IS_CORRUPT(log->l_mp,
+	    rhead->h_magicno != cpu_to_be32(XLOG_HEADER_MAGIC_NUM)))
 		return -EFSCORRUPTED;
-	}
-	if (unlikely(
+	if (XFS_IS_CORRUPT(log->l_mp,
 	    (!rhead->h_version ||
 	    (be32_to_cpu(rhead->h_version) & (~XLOG_VERSION_OKBITS))))) {
 		xfs_warn(log->l_mp, "%s: unrecognised log version (%d).",
 			__func__, be32_to_cpu(rhead->h_version));
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 
 	/* LR body must have data or it wouldn't have been written */
 	hlen = be32_to_cpu(rhead->h_len);
-	if (unlikely( hlen <= 0 || hlen > INT_MAX )) {
-		XFS_ERROR_REPORT("xlog_valid_rec_header(2)",
-				XFS_ERRLEVEL_LOW, log->l_mp);
+	if (XFS_IS_CORRUPT(log->l_mp, hlen <= 0 || hlen > INT_MAX))
 		return -EFSCORRUPTED;
-	}
-	if (unlikely( blkno > log->l_logBBsize || blkno > INT_MAX )) {
-		XFS_ERROR_REPORT("xlog_valid_rec_header(3)",
-				XFS_ERRLEVEL_LOW, log->l_mp);
+	if (XFS_IS_CORRUPT(log->l_mp,
+	    blkno > log->l_logBBsize || blkno > INT_MAX))
 		return -EFSCORRUPTED;
-	}
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 5ea95247a37f..fca65109cf24 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -761,9 +761,8 @@ xfs_mountfs(
 		goto out_free_dir;
 	}
 
-	if (!sbp->sb_logblocks) {
+	if (XFS_IS_CORRUPT(mp, !sbp->sb_logblocks)) {
 		xfs_warn(mp, "no log defined");
-		XFS_ERROR_REPORT("xfs_mountfs", XFS_ERRLEVEL_LOW, mp);
 		error = -EFSCORRUPTED;
 		goto out_free_perag;
 	}
@@ -801,12 +800,10 @@ xfs_mountfs(
 
 	ASSERT(rip != NULL);
 
-	if (unlikely(!S_ISDIR(VFS_I(rip)->i_mode))) {
+	if (XFS_IS_CORRUPT(mp, !S_ISDIR(VFS_I(rip)->i_mode))) {
 		xfs_warn(mp, "corrupted root inode %llu: not a directory",
 			(unsigned long long)rip->i_ino);
 		xfs_iunlock(rip, XFS_ILOCK_EXCL);
-		XFS_ERROR_REPORT("xfs_mountfs_int(2)", XFS_ERRLEVEL_LOW,
-				 mp);
 		error = -EFSCORRUPTED;
 		goto out_rele_rip;
 	}
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 66ea8e4fca86..47318671013e 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -755,17 +755,15 @@ xfs_qm_qino_alloc(
 		if ((flags & XFS_QMOPT_PQUOTA) &&
 			     (mp->m_sb.sb_gquotino != NULLFSINO)) {
 			ino = mp->m_sb.sb_gquotino;
-			if (mp->m_sb.sb_pquotino != NULLFSINO) {
-				XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
-						mp);
+			if (XFS_IS_CORRUPT(mp,
+			    mp->m_sb.sb_pquotino != NULLFSINO)) {
 				return -EFSCORRUPTED;
 			}
 		} else if ((flags & XFS_QMOPT_GQUOTA) &&
 			     (mp->m_sb.sb_pquotino != NULLFSINO)) {
 			ino = mp->m_sb.sb_pquotino;
-			if (mp->m_sb.sb_gquotino != NULLFSINO) {
-				XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
-						mp);
+			if (XFS_IS_CORRUPT(mp,
+			    mp->m_sb.sb_gquotino != NULLFSINO)) {
 				return -EFSCORRUPTED;
 			}
 		}
