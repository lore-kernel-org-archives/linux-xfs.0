Return-Path: <SRS0=4Z0m=Y3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C226CA9EB0
	for <linux-xfs@archiver.kernel.org>; Sun,  3 Nov 2019 22:25:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6F1821D71
	for <linux-xfs@archiver.kernel.org>; Sun,  3 Nov 2019 22:25:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NRncXQJB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727520AbfKCWZI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 3 Nov 2019 17:25:08 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:39822 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727503AbfKCWZI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Nov 2019 17:25:08 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA3MOJTn073221
        for <linux-xfs@vger.kernel.org>; Sun, 3 Nov 2019 22:25:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=4hugr4An6f0QMQT33VAB7/rcaEgVWTNVWooPBdLfkLU=;
 b=NRncXQJB3SEQD7gzi3wqb9c8eGUxriN6TIyvuEkPjc8mrw9HitKu/WVUEZ4chCcamx5i
 8HuEFB1MNyVJ0j1VKgpSPDhuyEimiYSbaL+AykrBXOUTR6LImfV0QNjN/KxmIHP7Ik0s
 9ra1sQfnfrY+wAVJLWmMcC2fEuJIMR5xNgwJN/DrQM01/3yaap0ufomFrz2/LzdJwTuO
 Jo1RjWk4sDJ5x84NHtgKNI7q5ISmHCSOupCahPe+khZrg3toKbCN0ygpkrqJ1LebJ8Rj
 tsWXYJvcDw3O+LbJXo6BFohPeYppay7fds0AtSwDYayjGMl6W4rNjgctaCUTmQKQKESB og== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2w11rpm48v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 03 Nov 2019 22:25:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA3MOAx1071437
        for <linux-xfs@vger.kernel.org>; Sun, 3 Nov 2019 22:25:06 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2w1ka8e7bj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 03 Nov 2019 22:25:06 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA3MP54w007476
        for <linux-xfs@vger.kernel.org>; Sun, 3 Nov 2019 22:25:05 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 03 Nov 2019 14:25:04 -0800
Subject: [PATCH 03/10] xfs: report block map corruption errors to the health
 tracking system
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 03 Nov 2019 14:25:03 -0800
Message-ID: <157281990353.4152102.15406319284510044621.stgit@magnolia>
In-Reply-To: <157281988489.4152102.1632857939932700344.stgit@magnolia>
References: <157281988489.4152102.1632857939932700344.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9430 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911030234
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9430 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911030234
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Whenever we encounter a corrupt block mapping, we should report that to
the health monitoring system for later reporting.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c   |   32 ++++++++++++++++++++++++++++----
 fs/xfs/libxfs/xfs_health.h |    1 +
 fs/xfs/xfs_health.c        |   26 ++++++++++++++++++++++++++
 fs/xfs/xfs_iomap.c         |   15 +++++++++++----
 4 files changed, 66 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 0ad47ca9b14d..13523be72b8a 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -35,7 +35,7 @@
 #include "xfs_refcount.h"
 #include "xfs_icache.h"
 #include "xfs_iomap.h"
-
+#include "xfs_health.h"
 
 kmem_zone_t		*xfs_bmap_free_item_zone;
 
@@ -732,6 +732,7 @@ xfs_bmap_extents_to_btree(
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, 1L);
 	abp = xfs_btree_get_bufl(mp, tp, args.fsbno);
 	if (XFS_CORRUPT_ON(mp, !abp)) {
+		xfs_bmap_mark_sick(ip, whichfork);
 		error = -EFSCORRUPTED;
 		goto out_unreserve_dquot;
 	}
@@ -1021,6 +1022,7 @@ xfs_bmap_add_attrfork_local(
 
 	/* should only be called for types that support local format data */
 	ASSERT(0);
+	xfs_bmap_mark_sick(ip, XFS_ATTR_FORK);
 	return -EFSCORRUPTED;
 }
 
@@ -1090,6 +1092,7 @@ xfs_bmap_add_attrfork(
 	if (XFS_IFORK_Q(ip))
 		goto trans_cancel;
 	if (XFS_CORRUPT_ON(mp, ip->i_d.di_anextents != 0)) {
+		xfs_bmap_mark_sick(ip, XFS_ATTR_FORK);
 		error = -EFSCORRUPTED;
 		goto trans_cancel;
 	}
@@ -1192,6 +1195,7 @@ xfs_iread_bmbt_block(
 				(unsigned long long)ip->i_ino);
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, block,
 				sizeof(*block), __this_address);
+		xfs_bmap_mark_sick(ip, whichfork);
 		return -EFSCORRUPTED;
 	}
 
@@ -1207,6 +1211,7 @@ xfs_iread_bmbt_block(
 			xfs_inode_verifier_error(ip, -EFSCORRUPTED,
 					"xfs_iread_extents(2)", frp,
 					sizeof(*frp), fa);
+			xfs_bmap_mark_sick(ip, whichfork);
 			return -EFSCORRUPTED;
 		}
 		xfs_iext_insert(ip, &ir->icur, &new,
@@ -1238,6 +1243,7 @@ xfs_iread_extents(
 
 	if (XFS_CORRUPT_ON(mp, XFS_IFORK_FORMAT(ip, whichfork) !=
 			       XFS_DINODE_FMT_BTREE)) {
+		xfs_bmap_mark_sick(ip, whichfork);
 		error = -EFSCORRUPTED;
 		goto out;
 	}
@@ -1253,6 +1259,7 @@ xfs_iread_extents(
 
 	if (XFS_CORRUPT_ON(mp,
 			   ir.loaded != XFS_IFORK_NEXTENTS(ip, whichfork))) {
+		xfs_bmap_mark_sick(ip, whichfork);
 		error = -EFSCORRUPTED;
 		goto out;
 	}
@@ -1261,6 +1268,8 @@ xfs_iread_extents(
 	ifp->if_flags |= XFS_IFEXTENTS;
 	return 0;
 out:
+	if (xfs_metadata_is_sick(error))
+		xfs_bmap_mark_sick(ip, whichfork);
 	xfs_iext_destroy(ifp);
 	return error;
 }
@@ -1344,6 +1353,7 @@ xfs_bmap_last_before(
 		break;
 	default:
 		ASSERT(0);
+		xfs_bmap_mark_sick(ip, whichfork);
 		return -EFSCORRUPTED;
 	}
 
@@ -1445,6 +1455,7 @@ xfs_bmap_last_offset(
 
 	if (XFS_CORRUPT_ON(ip->i_mount,
 	    !XFS_IFORK_MAPS_BLOCKS(ip, whichfork))) {
+		xfs_bmap_mark_sick(ip, whichfork);
 		return -EFSCORRUPTED;
 	}
 
@@ -3907,6 +3918,7 @@ xfs_bmapi_read(
 
 	if (XFS_CORRUPT_ON(mp, !XFS_IFORK_MAPS_BLOCKS(ip, whichfork)) ||
 	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
+		xfs_bmap_mark_sick(ip, whichfork);
 		return -EFSCORRUPTED;
 	}
 
@@ -3937,6 +3949,7 @@ xfs_bmapi_read(
 		xfs_alert(mp, "%s: inode %llu missing fork %d",
 				__func__, ip->i_ino, whichfork);
 #endif /* DEBUG */
+		xfs_bmap_mark_sick(ip, whichfork);
 		return -EFSCORRUPTED;
 	}
 
@@ -4415,6 +4428,7 @@ xfs_bmapi_write(
 
 	if (XFS_CORRUPT_ON(mp, !XFS_IFORK_MAPS_BLOCKS(ip, whichfork)) ||
 	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
+		xfs_bmap_mark_sick(ip, whichfork);
 		return -EFSCORRUPTED;
 	}
 
@@ -4622,9 +4636,11 @@ xfs_bmapi_convert_delalloc(
 	error = -ENOSPC;
 	if (WARN_ON_ONCE(bma.blkno == NULLFSBLOCK))
 		goto out_finish;
-	error = -EFSCORRUPTED;
-	if (WARN_ON_ONCE(!xfs_valid_startblock(ip, bma.got.br_startblock)))
+	if (WARN_ON_ONCE(!xfs_valid_startblock(ip, bma.got.br_startblock))) {
+		xfs_bmap_mark_sick(ip, whichfork);
+		error = -EFSCORRUPTED;
 		goto out_finish;
+	}
 
 	XFS_STATS_ADD(mp, xs_xstrat_bytes, XFS_FSB_TO_B(mp, bma.length));
 	XFS_STATS_INC(mp, xs_xstrat_quick);
@@ -4682,6 +4698,7 @@ xfs_bmapi_remap(
 
 	if (XFS_CORRUPT_ON(mp, !XFS_IFORK_MAPS_BLOCKS(ip, whichfork)) ||
 	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
+		xfs_bmap_mark_sick(ip, whichfork);
 		return -EFSCORRUPTED;
 	}
 
@@ -5321,6 +5338,7 @@ __xfs_bunmapi(
 	ASSERT(whichfork != XFS_COW_FORK);
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	if (XFS_CORRUPT_ON(mp, !XFS_IFORK_MAPS_BLOCKS(ip, whichfork))) {
+		xfs_bmap_mark_sick(ip, whichfork);
 		return -EFSCORRUPTED;
 	}
 	if (XFS_FORCED_SHUTDOWN(mp))
@@ -5817,6 +5835,7 @@ xfs_bmap_collapse_extents(
 
 	if (XFS_CORRUPT_ON(mp, !XFS_IFORK_MAPS_BLOCKS(ip, whichfork)) ||
 	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
+		xfs_bmap_mark_sick(ip, whichfork);
 		return -EFSCORRUPTED;
 	}
 
@@ -5934,6 +5953,7 @@ xfs_bmap_insert_extents(
 
 	if (XFS_CORRUPT_ON(mp, !XFS_IFORK_MAPS_BLOCKS(ip, whichfork)) ||
 	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
+		xfs_bmap_mark_sick(ip, whichfork);
 		return -EFSCORRUPTED;
 	}
 
@@ -6040,6 +6060,7 @@ xfs_bmap_split_extent_at(
 
 	if (XFS_CORRUPT_ON(mp, !XFS_IFORK_MAPS_BLOCKS(ip, whichfork)) ||
 	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
+		xfs_bmap_mark_sick(ip, whichfork);
 		return -EFSCORRUPTED;
 	}
 
@@ -6255,8 +6276,10 @@ xfs_bmap_finish_one(
 			XFS_FSB_TO_AGBNO(tp->t_mountp, startblock),
 			ip->i_ino, whichfork, startoff, *blockcount, state);
 
-	if (WARN_ON_ONCE(whichfork != XFS_DATA_FORK))
+	if (WARN_ON_ONCE(whichfork != XFS_DATA_FORK)) {
+		xfs_bmap_mark_sick(ip, whichfork);
 		return -EFSCORRUPTED;
+	}
 
 	if (XFS_TEST_ERROR(false, tp->t_mountp,
 			XFS_ERRTAG_BMAP_FINISH_ONE))
@@ -6274,6 +6297,7 @@ xfs_bmap_finish_one(
 		break;
 	default:
 		ASSERT(0);
+		xfs_bmap_mark_sick(ip, whichfork);
 		error = -EFSCORRUPTED;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index ce8954a10c66..25b61180b562 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -138,6 +138,7 @@ void xfs_inode_measure_sickness(struct xfs_inode *ip, unsigned int *sick,
 		unsigned int *checked);
 
 void xfs_health_unmount(struct xfs_mount *mp);
+void xfs_bmap_mark_sick(struct xfs_inode *ip, int whichfork);
 
 /* Now some helpers. */
 
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 36c32b108b39..5e5de5338476 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -452,3 +452,29 @@ xfs_bulkstat_health(
 			bs->bs_sick |= m->ioctl_mask;
 	}
 }
+
+/* Mark a block mapping sick. */
+void
+xfs_bmap_mark_sick(
+	struct xfs_inode	*ip,
+	int			whichfork)
+{
+	unsigned int		mask;
+
+	switch (whichfork) {
+	case XFS_DATA_FORK:
+		mask = XFS_SICK_INO_BMBTD;
+		break;
+	case XFS_ATTR_FORK:
+		mask = XFS_SICK_INO_BMBTA;
+		break;
+	case XFS_COW_FORK:
+		mask = XFS_SICK_INO_BMBTC;
+		break;
+	default:
+		ASSERT(0);
+		return;
+	}
+
+	xfs_inode_mark_sick(ip, mask);
+}
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index d78df4bdd700..894ec033b3f1 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -27,7 +27,7 @@
 #include "xfs_dquot_item.h"
 #include "xfs_dquot.h"
 #include "xfs_reflink.h"
-
+#include "xfs_health.h"
 
 #define XFS_ALLOC_ALIGN(mp, off) \
 	(((off) >> mp->m_allocsize_log) << mp->m_allocsize_log)
@@ -59,8 +59,10 @@ xfs_bmbt_to_iomap(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_buftarg	*target = xfs_inode_buftarg(ip);
 
-	if (unlikely(!xfs_valid_startblock(ip, imap->br_startblock)))
+	if (unlikely(!xfs_valid_startblock(ip, imap->br_startblock))) {
+		xfs_bmap_mark_sick(ip, XFS_DATA_FORK);
 		return xfs_alert_fsblock_zero(ip, imap);
+	}
 
 	if (imap->br_startblock == HOLESTARTBLOCK) {
 		iomap->addr = IOMAP_NULL_ADDR;
@@ -277,8 +279,10 @@ xfs_iomap_write_direct(
 		goto out_unlock;
 	}
 
-	if (unlikely(!xfs_valid_startblock(ip, imap->br_startblock)))
+	if (unlikely(!xfs_valid_startblock(ip, imap->br_startblock))) {
+		xfs_bmap_mark_sick(ip, XFS_DATA_FORK);
 		error = xfs_alert_fsblock_zero(ip, imap);
+	}
 
 out_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
@@ -588,8 +592,10 @@ xfs_iomap_write_unwritten(
 		if (error)
 			return error;
 
-		if (unlikely(!xfs_valid_startblock(ip, imap.br_startblock)))
+		if (unlikely(!xfs_valid_startblock(ip, imap.br_startblock))) {
+			xfs_bmap_mark_sick(ip, XFS_DATA_FORK);
 			return xfs_alert_fsblock_zero(ip, &imap);
+		}
 
 		if ((numblks_fsb = imap.br_blockcount) == 0) {
 			/*
@@ -848,6 +854,7 @@ xfs_buffered_write_iomap_begin(
 
 	if (XFS_CORRUPT_ON(mp, !XFS_IFORK_MAPS_BLOCKS(ip, XFS_DATA_FORK)) ||
 	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
+		xfs_bmap_mark_sick(ip, XFS_DATA_FORK);
 		error = -EFSCORRUPTED;
 		goto out_unlock;
 	}

