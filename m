Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D4E9FA372C
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 07:07:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 120D62087E
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 07:07:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PkfRY22g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725372AbfKHHHf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 02:07:35 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:42642 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbfKHHHf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Nov 2019 02:07:35 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA873btP042276;
        Fri, 8 Nov 2019 07:07:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=PiNRzwHxdLsYaZcG92MQSLhoqE1OQtPdvCXCnXkM1Y4=;
 b=PkfRY22gAlhhqgOf0+uc7ZmSRtdI0deiv13czXXLfCBUrQne5kwKt181y6pad5HqPlyQ
 H6KIHdYa91MaK16wSkvDLHVlZBQacvyhnx+w3hUtleBLJQaAEjSlb+KezaKcqMLd/yVq
 LEHqmvaSz4Z4rF/gC8npSmiS9zdEOMMC+K0he8iw2ThCeKjiJLinH+SjRqn6g3kMYT69
 R+aIakrskky5jGXs3pX98QIHNqtnE3zhy/fLFYi88k3hxoA7DFMx0GolDiLl/JQ13fFu
 CwJeNfcScAFGwcyRb7ivjUb+fcekz8ETc6HSEstOppCi4iH6Bq4fsjSHS417847QYZJb PA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2w41w13csv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 07:07:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA873xOb183110;
        Fri, 8 Nov 2019 07:05:23 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2w41wh0jv8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 07:05:23 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA875McA018377;
        Fri, 8 Nov 2019 07:05:22 GMT
Received: from localhost (/10.159.155.116)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Nov 2019 23:05:22 -0800
Subject: [PATCH 2/2] xfs: convert open coded corruption check to use
 XFS_IS_CORRUPT
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Thu, 07 Nov 2019 23:05:21 -0800
Message-ID: <157319672136.834699.13051359836285578031.stgit@magnolia>
In-Reply-To: <157319670850.834699.10430897268214054248.stgit@magnolia>
References: <157319670850.834699.10430897268214054248.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911080069
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911080069
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Convert the last of the open coded corruption check and report idioms to
use the XFS_IS_CORRUPT macro.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c     |    7 +---
 fs/xfs/libxfs/xfs_bmap.c      |   67 ++++++++++++++---------------------------
 fs/xfs/libxfs/xfs_btree.c     |   14 +++------
 fs/xfs/libxfs/xfs_da_btree.c  |   46 ++++++++--------------------
 fs/xfs/libxfs/xfs_dir2.c      |    9 ++----
 fs/xfs/libxfs/xfs_dir2_node.c |    9 ++----
 fs/xfs/libxfs/xfs_refcount.c  |    9 ++----
 fs/xfs/libxfs/xfs_rmap.c      |    2 +
 fs/xfs/libxfs/xfs_rtbitmap.c  |    4 +-
 fs/xfs/xfs_attr_list.c        |   21 ++++---------
 fs/xfs/xfs_dir2_readdir.c     |   16 ++++------
 fs/xfs/xfs_iomap.c            |    6 +---
 fs/xfs/xfs_iops.c             |    4 +-
 fs/xfs/xfs_log_recover.c      |   64 +++++++++++++--------------------------
 fs/xfs/xfs_mount.c            |    7 +---
 fs/xfs/xfs_qm.c               |   12 ++-----
 16 files changed, 100 insertions(+), 197 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 65d870189548..d3764de08f5f 100644
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
@@ -2334,10 +2333,8 @@ xfs_free_agfl_block(
 		return error;
 
 	bp = xfs_btree_get_bufs(tp->t_mountp, tp, agno, agbno);
-	if (!bp) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, tp->t_mountp);
+	if (XFS_IS_CORRUPT(tp->t_mountp, !bp))
 		return -EFSCORRUPTED;
-	}
 	xfs_trans_binval(tp, bp);
 
 	return 0;
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 97b6a1fd3246..f11f4d25c56b 100644
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
+	if (XFS_IS_CORRUPT(mp,
+	    XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE)) {
 		error = -EFSCORRUPTED;
 		goto out;
 	}
@@ -1253,8 +1251,8 @@ xfs_iread_extents(
 	if (error)
 		goto out;
 
-	if (ir.loaded != XFS_IFORK_NEXTENTS(ip, whichfork)) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
+	if (XFS_IS_CORRUPT(mp,
+	    ir.loaded != XFS_IFORK_NEXTENTS(ip, whichfork))) {
 		error = -EFSCORRUPTED;
 		goto out;
 	}
@@ -1444,10 +1442,8 @@ xfs_bmap_last_offset(
 	if (XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_LOCAL)
 		return 0;
 
-	if (!xfs_ifork_has_extents(ip, whichfork)) {
-		ASSERT(0);
+	if (XFS_IS_CORRUPT(ip->i_mount, !xfs_ifork_has_extents(ip, whichfork)))
 		return -EFSCORRUPTED;
-	}
 
 	error = xfs_bmap_last_extent(NULL, ip, whichfork, &rec, &is_empty);
 	if (error || is_empty)
@@ -3906,10 +3902,8 @@ xfs_bmapi_read(
 			   XFS_BMAPI_COWFORK)));
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED|XFS_ILOCK_EXCL));
 
-	if (unlikely(XFS_TEST_ERROR(
-	    !xfs_ifork_has_extents(ip, whichfork),
-	     mp, XFS_ERRTAG_BMAPIFORMAT))) {
-		XFS_ERROR_REPORT("xfs_bmapi_read", XFS_ERRLEVEL_LOW, mp);
+	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ip, whichfork)) ||
+	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
 		return -EFSCORRUPTED;
 	}
 
@@ -4417,10 +4411,8 @@ xfs_bmapi_write(
 	ASSERT((flags & (XFS_BMAPI_PREALLOC | XFS_BMAPI_ZERO)) !=
 			(XFS_BMAPI_PREALLOC | XFS_BMAPI_ZERO));
 
-	if (unlikely(XFS_TEST_ERROR(
-	    !xfs_ifork_has_extents(ip, whichfork),
-	     mp, XFS_ERRTAG_BMAPIFORMAT))) {
-		XFS_ERROR_REPORT("xfs_bmapi_write", XFS_ERRLEVEL_LOW, mp);
+	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ip, whichfork)) ||
+	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
 		return -EFSCORRUPTED;
 	}
 
@@ -4686,10 +4678,8 @@ xfs_bmapi_remap(
 	ASSERT((flags & (XFS_BMAPI_ATTRFORK | XFS_BMAPI_PREALLOC)) !=
 			(XFS_BMAPI_ATTRFORK | XFS_BMAPI_PREALLOC));
 
-	if (unlikely(XFS_TEST_ERROR(
-	    !xfs_ifork_has_extents(ip, whichfork),
-	     mp, XFS_ERRTAG_BMAPIFORMAT))) {
-		XFS_ERROR_REPORT("xfs_bmapi_remap", XFS_ERRLEVEL_LOW, mp);
+	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ip, whichfork)) ||
+	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
 		return -EFSCORRUPTED;
 	}
 
@@ -5311,7 +5301,7 @@ __xfs_bunmapi(
 	int			isrt;		/* freeing in rt area */
 	int			logflags;	/* transaction logging flags */
 	xfs_extlen_t		mod;		/* rt extent offset */
-	struct xfs_mount	*mp;		/* mount structure */
+	struct xfs_mount	*mp = ip->i_mount;
 	int			tmp_logflags;	/* partial logging flags */
 	int			wasdel;		/* was a delayed alloc extent */
 	int			whichfork;	/* data or attribute fork */
@@ -5328,12 +5318,8 @@ __xfs_bunmapi(
 	whichfork = xfs_bmapi_whichfork(flags);
 	ASSERT(whichfork != XFS_COW_FORK);
 	ifp = XFS_IFORK_PTR(ip, whichfork);
-	if (unlikely(!xfs_ifork_has_extents(ip, whichfork))) {
-		XFS_ERROR_REPORT("xfs_bunmapi", XFS_ERRLEVEL_LOW,
-				 ip->i_mount);
+	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ip, whichfork)))
 		return -EFSCORRUPTED;
-	}
-	mp = ip->i_mount;
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
@@ -5826,10 +5812,8 @@ xfs_bmap_collapse_extents(
 	int			error = 0;
 	int			logflags = 0;
 
-	if (unlikely(XFS_TEST_ERROR(
-	    !xfs_ifork_has_extents(ip, whichfork),
-	     mp, XFS_ERRTAG_BMAPIFORMAT))) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
+	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ip, whichfork)) ||
+	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
 		return -EFSCORRUPTED;
 	}
 
@@ -5945,10 +5929,8 @@ xfs_bmap_insert_extents(
 	int			error = 0;
 	int			logflags = 0;
 
-	if (unlikely(XFS_TEST_ERROR(
-	    !xfs_ifork_has_extents(ip, whichfork),
-	     mp, XFS_ERRTAG_BMAPIFORMAT))) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
+	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ip, whichfork)) ||
+	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
 		return -EFSCORRUPTED;
 	}
 
@@ -5986,8 +5968,8 @@ xfs_bmap_insert_extents(
 		goto del_cursor;
 	}
 
-	if (stop_fsb >= got.br_startoff + got.br_blockcount) {
-		ASSERT(0);
+	if (XFS_IS_CORRUPT(mp,
+	    stop_fsb >= got.br_startoff + got.br_blockcount)) {
 		error = -EFSCORRUPTED;
 		goto del_cursor;
 	}
@@ -6053,11 +6035,8 @@ xfs_bmap_split_extent_at(
 	int				logflags = 0;
 	int				i = 0;
 
-	if (unlikely(XFS_TEST_ERROR(
-	    !xfs_ifork_has_extents(ip, whichfork),
-	     mp, XFS_ERRTAG_BMAPIFORMAT))) {
-		XFS_ERROR_REPORT("xfs_bmap_split_extent_at",
-				 XFS_ERRLEVEL_LOW, mp);
+	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ip, whichfork)) ||
+	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
 		return -EFSCORRUPTED;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 37b4fa93085c..962020574a2d 100644
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
@@ -1873,10 +1871,8 @@ xfs_btree_lookup(
 	XFS_BTREE_STATS_INC(cur, lookup);
 
 	/* No such thing as a zero-level tree. */
-	if (cur->bc_nlevels == 0) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, cur->bc_mp);
+	if (XFS_IS_CORRUPT(cur->bc_mp, cur->bc_nlevels == 0))
 		return -EFSCORRUPTED;
-	}
 
 	block = NULL;
 	keyno = 0;
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 9925d4a7dc33..588d286935f9 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -1619,17 +1619,12 @@ xfs_da3_node_lookup_int(
 		}
 
 		/* We can't point back to the root. */
-		if (blkno == args->geo->leafblk) {
-			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
-					dp->i_mount);
+		if (XFS_IS_CORRUPT(dp->i_mount, blkno == args->geo->leafblk))
 			return -EFSCORRUPTED;
-		}
 	}
 
-	if (expected_level != 0) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, dp->i_mount);
+	if (XFS_IS_CORRUPT(dp->i_mount, expected_level != 0))
 		return -EFSCORRUPTED;
-	}
 
 	/*
 	 * A leaf block that ends in the hashval that we are interested in
@@ -2225,11 +2220,8 @@ xfs_da3_swap_lastblock(
 	error = xfs_bmap_last_before(tp, dp, &lastoff, w);
 	if (error)
 		return error;
-	if (unlikely(lastoff == 0)) {
-		XFS_ERROR_REPORT("xfs_da_swap_lastblock(1)", XFS_ERRLEVEL_LOW,
-				 mp);
+	if (XFS_IS_CORRUPT(mp, lastoff == 0))
 		return -EFSCORRUPTED;
-	}
 	/*
 	 * Read the last block in the btree space.
 	 */
@@ -2274,11 +2266,9 @@ xfs_da3_swap_lastblock(
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
@@ -2296,11 +2286,9 @@ xfs_da3_swap_lastblock(
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
@@ -2321,9 +2309,8 @@ xfs_da3_swap_lastblock(
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
@@ -2334,9 +2321,7 @@ xfs_da3_swap_lastblock(
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
@@ -2361,9 +2346,7 @@ xfs_da3_swap_lastblock(
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
@@ -2372,9 +2355,7 @@ xfs_da3_swap_lastblock(
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
@@ -2568,7 +2549,7 @@ xfs_dabuf_map(
 
 	if (!xfs_da_map_covers_blocks(nirecs, irecs, bno, nfsb)) {
 		/* Caller ok with no mapping. */
-		if (mappedbno == -2) {
+		if (!XFS_IS_CORRUPT(mp, mappedbno != -2)) {
 			error = -1;
 			goto out;
 		}
@@ -2589,7 +2570,6 @@ xfs_dabuf_map(
 					irecs[i].br_state);
 			}
 		}
-		XFS_ERROR_REPORT("xfs_da_do_buf(1)", XFS_ERRLEVEL_LOW, mp);
 		error = -EFSCORRUPTED;
 		goto out;
 	}
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 452d04ae10ce..86eec7ad920b 100644
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
@@ -600,10 +600,9 @@ xfs_dir2_isblock(
 	if ((rval = xfs_bmap_last_offset(args->dp, &last, XFS_DATA_FORK)))
 		return rval;
 	rval = XFS_FSB_TO_B(args->dp->i_mount, last) == args->geo->blksize;
-	if (rval != 0 && args->dp->i_d.di_size != args->geo->blksize) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, args->dp->i_mount);
+	if (XFS_IS_CORRUPT(args->dp->i_mount,
+	    rval != 0 && args->dp->i_d.di_size != args->geo->blksize))
 		return -EFSCORRUPTED;
-	}
 	*vp = rval;
 	return 0;
 }
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
 
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 5a3e8aec2a8e..05061edc4e15 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1177,7 +1177,7 @@ xfs_refcount_finish_one(
 				XFS_ALLOC_FLAG_FREEING, &agbp);
 		if (error)
 			return error;
-		if (!agbp)
+		if (XFS_IS_CORRUPT(tp->t_mountp, !agbp))
 			return -EFSCORRUPTED;
 
 		rcur = xfs_refcountbt_init_cursor(mp, tp, agbp, agno);
@@ -1661,17 +1661,16 @@ struct xfs_refcount_recovery {
 /* Stuff an extent on the recovery list. */
 STATIC int
 xfs_refcount_recover_extent(
-	struct xfs_btree_cur 		*cur,
+	struct xfs_btree_cur		*cur,
 	union xfs_btree_rec		*rec,
 	void				*priv)
 {
 	struct list_head		*debris = priv;
 	struct xfs_refcount_recovery	*rr;
 
-	if (be32_to_cpu(rec->refc.rc_refcount) != 1) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, cur->bc_mp);
+	if (XFS_IS_CORRUPT(cur->bc_mp,
+	    be32_to_cpu(rec->refc.rc_refcount) != 1))
 		return -EFSCORRUPTED;
-	}
 
 	rr = kmem_alloc(sizeof(struct xfs_refcount_recovery), 0);
 	xfs_refcount_btrec_to_irec(rec, &rr->rr_rrec);
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index b2043691325b..61d4596931ff 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -2394,7 +2394,7 @@ xfs_rmap_finish_one(
 		error = xfs_free_extent_fix_freelist(tp, agno, &agbp);
 		if (error)
 			return error;
-		if (!agbp)
+		if (XFS_IS_CORRUPT(tp->t_mountp, !agbp))
 			return -EFSCORRUPTED;
 
 		rcur = xfs_rmapbt_init_cursor(mp, tp, agbp, agno);
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index d8aaa1de921c..f42c74cb8be5 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -70,10 +70,8 @@ xfs_rtbuf_get(
 	if (error)
 		return error;
 
-	if (nmap == 0 || !xfs_bmap_is_real_extent(&map)) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
+	if (XFS_IS_CORRUPT(mp, nmap == 0 || !xfs_bmap_is_real_extent(&map)))
 		return -EFSCORRUPTED;
-	}
 
 	ASSERT(map.br_startblock != NULLFSBLOCK);
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 64f6ceba9254..d0fac1061d6d 100644
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
@@ -269,10 +266,8 @@ xfs_attr_node_list_lookup(
 			return 0;
 
 		/* We can't point back to the root. */
-		if (cursor->blkno == 0) {
-			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
+		if (XFS_IS_CORRUPT(mp, cursor->blkno == 0))
 			return -EFSCORRUPTED;
-		}
 	}
 
 	if (expected_level != 0)
@@ -473,11 +468,9 @@ xfs_attr3_leaf_list_int(
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
index 1471bcd6cb70..c5fa5d83021d 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -846,10 +846,8 @@ xfs_buffered_write_iomap_begin(
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 
-	if (unlikely(XFS_TEST_ERROR(
-	    !xfs_ifork_has_extents(ip, XFS_DATA_FORK),
-	     mp, XFS_ERRTAG_BMAPIFORMAT))) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
+	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ip, XFS_DATA_FORK)) ||
+	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
 		error = -EFSCORRUPTED;
 		goto out_unlock;
 	}
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 4c7962ccb0c4..6e8eed4f4955 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -481,10 +481,8 @@ xfs_vn_get_link_inline(
 	 * if_data is junk.
 	 */
 	link = ip->i_df.if_u1.if_data;
-	if (!link) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, ip->i_mount);
+	if (XFS_IS_CORRUPT(ip->i_mount, !link))
 		return ERR_PTR(-EFSCORRUPTED);
-	}
 	return link;
 }
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 02f2147952b3..dc01bc0071a5 100644
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
+		    head_block >= tail_block || head_cycle != tail_cycle + 1))
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
@@ -5209,12 +5194,10 @@ xlog_valid_rec_header(
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
@@ -5224,16 +5207,11 @@ xlog_valid_rec_header(
 
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
index 66ea8e4fca86..3d8a08d02649 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -755,19 +755,15 @@ xfs_qm_qino_alloc(
 		if ((flags & XFS_QMOPT_PQUOTA) &&
 			     (mp->m_sb.sb_gquotino != NULLFSINO)) {
 			ino = mp->m_sb.sb_gquotino;
-			if (mp->m_sb.sb_pquotino != NULLFSINO) {
-				XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
-						mp);
+			if (XFS_IS_CORRUPT(mp,
+			    mp->m_sb.sb_pquotino != NULLFSINO))
 				return -EFSCORRUPTED;
-			}
 		} else if ((flags & XFS_QMOPT_GQUOTA) &&
 			     (mp->m_sb.sb_pquotino != NULLFSINO)) {
 			ino = mp->m_sb.sb_pquotino;
-			if (mp->m_sb.sb_gquotino != NULLFSINO) {
-				XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
-						mp);
+			if (XFS_IS_CORRUPT(mp,
+			    mp->m_sb.sb_gquotino != NULLFSINO))
 				return -EFSCORRUPTED;
-			}
 		}
 		if (ino != NULLFSINO) {
 			error = xfs_iget(mp, NULL, ino, 0, 0, ip);

