Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AAC5C3A59F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 00:30:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3B9921874
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 00:30:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ouaovZzS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbfH3AaO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 20:30:14 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35640 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727122AbfH3AaO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 20:30:14 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7U0TcST111134;
        Fri, 30 Aug 2019 00:30:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=DQq7AOhpxlShZJNh5szwC/M3REa0EkFjszt3BCQQpSI=;
 b=ouaovZzSsGof3/Rz9feA0yfEh2wUNcl38cxp3O8Bv93gqEDDYV1gblXp7Aa4igWpfomm
 ORryLsWlq8rotpLwdHjD9o3LdwVJCh5V1Z7AQbEYkQ6K90if9Bqbl98WgetuoKOR2FwE
 NYqQDrDgLq+wVa3zi0EduBDnR2QsBcLzNJXQamkV9CCxB98lWF9C/xAGt1PLFlw/99Qj
 B7imllYHocBYit1i1F1A0s4TNj3Y4axIxsgibWppjrq2lKEXnHTImhI+luTLy4SDSlWW
 pDpZgHvcLWlId3LzoS3RiMk5iqxzwGMJV7ixAo4QEHwLqe++uLa54NDKXRN6k7C8QT6P eA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2ups9y0028-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 00:30:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7U0NWvb054475;
        Fri, 30 Aug 2019 00:30:09 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2unvu0tdfa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 00:30:08 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7U0U7Gt007052;
        Fri, 30 Aug 2019 00:30:08 GMT
Received: from localhost (/10.145.178.11)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Aug 2019 17:30:07 -0700
Date:   Thu, 29 Aug 2019 17:30:07 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] xfs: remove all *_ITER_ABORT values
Message-ID: <20190830003007.GU5354@magnolia>
References: <20190830002554.GT5354@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190830002554.GT5354@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908300001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908300002
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Use -ECANCELED to signal "stop iterating" instead of these magical
*_ITER_ABORT values, since it's duplicative.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_btree.c  |   12 +++++-------
 fs/xfs/libxfs/xfs_btree.h  |    9 +++++++--
 fs/xfs/libxfs/xfs_rmap.c   |   10 +++++-----
 fs/xfs/libxfs/xfs_shared.h |    3 ---
 fs/xfs/scrub/agheader.c    |    4 ++--
 fs/xfs/scrub/attr.c        |    2 +-
 fs/xfs/scrub/bmap.c        |    4 ++--
 fs/xfs/scrub/repair.c      |    4 ++--
 fs/xfs/xfs_dquot.c         |    2 +-
 fs/xfs/xfs_fsmap.c         |    4 ++--
 fs/xfs/xfs_ioctl.c         |   12 ++++++------
 fs/xfs/xfs_itable.c        |    6 +++---
 fs/xfs/xfs_itable.h        |   13 +++++++++----
 fs/xfs/xfs_iwalk.c         |    2 +-
 fs/xfs/xfs_iwalk.h         |   11 ++++++++---
 15 files changed, 54 insertions(+), 44 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 802eb53c7a73..71de937f9e64 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -4598,7 +4598,7 @@ xfs_btree_simple_query_range(
 
 		/* Callback */
 		error = fn(cur, recp, priv);
-		if (error < 0 || error == XFS_BTREE_QUERY_RANGE_ABORT)
+		if (error)
 			break;
 
 advloop:
@@ -4700,8 +4700,7 @@ xfs_btree_overlapped_query_range(
 			 */
 			if (ldiff >= 0 && hdiff >= 0) {
 				error = fn(cur, recp, priv);
-				if (error < 0 ||
-				    error == XFS_BTREE_QUERY_RANGE_ABORT)
+				if (error)
 					break;
 			} else if (hdiff < 0) {
 				/* Record is larger than high key; pop. */
@@ -4772,8 +4771,7 @@ xfs_btree_overlapped_query_range(
  * Query a btree for all records overlapping a given interval of keys.  The
  * supplied function will be called with each record found; return one of the
  * XFS_BTREE_QUERY_RANGE_{CONTINUE,ABORT} values or the usual negative error
- * code.  This function returns XFS_BTREE_QUERY_RANGE_ABORT, zero, or a
- * negative error code.
+ * code.  This function returns -ECANCELED, zero, or a negative error code.
  */
 int
 xfs_btree_query_range(
@@ -4889,7 +4887,7 @@ xfs_btree_has_record_helper(
 	union xfs_btree_rec		*rec,
 	void				*priv)
 {
-	return XFS_BTREE_QUERY_RANGE_ABORT;
+	return -ECANCELED;
 }
 
 /* Is there a record covering a given range of keys? */
@@ -4904,7 +4902,7 @@ xfs_btree_has_record(
 
 	error = xfs_btree_query_range(cur, low, high,
 			&xfs_btree_has_record_helper, NULL);
-	if (error == XFS_BTREE_QUERY_RANGE_ABORT) {
+	if (error == -ECANCELED) {
 		*exists = true;
 		return 0;
 	}
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index fa3cd8ab9aba..326cf2a43f0d 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -464,9 +464,14 @@ xfs_failaddr_t xfs_btree_lblock_verify(struct xfs_buf *bp,
 uint xfs_btree_compute_maxlevels(uint *limits, unsigned long len);
 unsigned long long xfs_btree_calc_size(uint *limits, unsigned long long len);
 
-/* return codes */
+/*
+ * Return codes for the query range iterator function are 0 to continue
+ * iterating, and non-zero to stop iterating.  Any non-zero value will be
+ * passed up to the _query_range caller.  The special value -ECANCELED can be
+ * used to stop iteration, because _query_range never generates that error
+ * code on its own.
+ */
 #define XFS_BTREE_QUERY_RANGE_CONTINUE	(XFS_ITER_CONTINUE) /* keep iterating */
-#define XFS_BTREE_QUERY_RANGE_ABORT	(XFS_ITER_ABORT)    /* stop iterating */
 typedef int (*xfs_btree_query_range_fn)(struct xfs_btree_cur *cur,
 		union xfs_btree_rec *rec, void *priv);
 
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 408dd2ec7a75..09644ff2c345 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -261,7 +261,7 @@ xfs_rmap_find_left_neighbor_helper(
 
 	*info->irec = *rec;
 	*info->stat = 1;
-	return XFS_BTREE_QUERY_RANGE_ABORT;
+	return -ECANCELED;
 }
 
 /*
@@ -304,7 +304,7 @@ xfs_rmap_find_left_neighbor(
 
 	error = xfs_rmap_query_range(cur, &info.high, &info.high,
 			xfs_rmap_find_left_neighbor_helper, &info);
-	if (error == XFS_BTREE_QUERY_RANGE_ABORT)
+	if (error == -ECANCELED)
 		error = 0;
 	if (*stat)
 		trace_xfs_rmap_find_left_neighbor_result(cur->bc_mp,
@@ -338,7 +338,7 @@ xfs_rmap_lookup_le_range_helper(
 
 	*info->irec = *rec;
 	*info->stat = 1;
-	return XFS_BTREE_QUERY_RANGE_ABORT;
+	return -ECANCELED;
 }
 
 /*
@@ -376,7 +376,7 @@ xfs_rmap_lookup_le_range(
 			cur->bc_private.a.agno, bno, 0, owner, offset, flags);
 	error = xfs_rmap_query_range(cur, &info.high, &info.high,
 			xfs_rmap_lookup_le_range_helper, &info);
-	if (error == XFS_BTREE_QUERY_RANGE_ABORT)
+	if (error == -ECANCELED)
 		error = 0;
 	if (*stat)
 		trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
@@ -2509,7 +2509,7 @@ xfs_rmap_has_other_keys_helper(
 	    ((rks->flags & rec->rm_flags) & XFS_RMAP_KEY_FLAGS) == rks->flags)
 		return 0;
 	rks->has_rmap = true;
-	return XFS_BTREE_QUERY_RANGE_ABORT;
+	return -ECANCELED;
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index e0641b7337b3..2bc31c5a0d49 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -180,7 +180,4 @@ struct xfs_ino_geometry {
 /* Keep iterating the data structure. */
 #define XFS_ITER_CONTINUE	(0)
 
-/* Stop iterating the data structure. */
-#define XFS_ITER_ABORT		(1)
-
 #endif /* __XFS_SHARED_H__ */
diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 16b09b941441..ba0f747c82e8 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -639,7 +639,7 @@ xchk_agfl_block(
 	xchk_agfl_block_xref(sc, agbno);
 
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
-		return XFS_ITER_ABORT;
+		return -ECANCELED;
 
 	return 0;
 }
@@ -730,7 +730,7 @@ xchk_agfl(
 	/* Check the blocks in the AGFL. */
 	error = xfs_agfl_walk(sc->mp, XFS_BUF_TO_AGF(sc->sa.agf_bp),
 			sc->sa.agfl_bp, xchk_agfl_block, &sai);
-	if (error == XFS_ITER_ABORT) {
+	if (error == -ECANCELED) {
 		error = 0;
 		goto out_free;
 	}
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 57dafb1665d9..bfb5f90a6dbd 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -171,7 +171,7 @@ xchk_xattr_listent(
 					     args.blkno);
 fail_xref:
 	if (sx->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
-		context->seen_enough = XFS_ITER_ABORT;
+		context->seen_enough = -ECANCELED;
 	return;
 }
 
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 7b19c63e12ce..fa6ea6407992 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -522,7 +522,7 @@ xchk_bmap_check_rmap(
 
 out:
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
-		return XFS_BTREE_QUERY_RANGE_ABORT;
+		return -ECANCELED;
 	return 0;
 }
 
@@ -551,7 +551,7 @@ xchk_bmap_check_ag_rmaps(
 	sbcri.sc = sc;
 	sbcri.whichfork = whichfork;
 	error = xfs_rmap_query_all(cur, xchk_bmap_check_rmap, &sbcri);
-	if (error == XFS_BTREE_QUERY_RANGE_ABORT)
+	if (error == -ECANCELED)
 		error = 0;
 
 	xfs_btree_del_cursor(cur, error);
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 7bcc755beb40..b70a88bc975e 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -664,7 +664,7 @@ xrep_findroot_agfl_walk(
 {
 	xfs_agblock_t		*agbno = priv;
 
-	return (*agbno == bno) ? XFS_ITER_ABORT : 0;
+	return (*agbno == bno) ? -ECANCELED : 0;
 }
 
 /* Does this block match the btree information passed in? */
@@ -694,7 +694,7 @@ xrep_findroot_block(
 	if (owner == XFS_RMAP_OWN_AG) {
 		error = xfs_agfl_walk(mp, ri->agf, ri->agfl_bp,
 				xrep_findroot_agfl_walk, &agbno);
-		if (error == XFS_ITER_ABORT)
+		if (error == -ECANCELED)
 			return 0;
 		if (error)
 			return error;
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 7ce770e779b4..aeb95e7391c1 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1239,7 +1239,7 @@ xfs_qm_exit(void)
 /*
  * Iterate every dquot of a particular type.  The caller must ensure that the
  * particular quota type is active.  iter_fn can return negative error codes,
- * or XFS_ITER_ABORT to indicate that it wants to stop iterating.
+ * or -ECANCELED to indicate that it wants to stop iterating.
  */
 int
 xfs_qm_dqiterate(
diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 5a8f9641562a..8ab4ab56fa89 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -276,7 +276,7 @@ xfs_getfsmap_helper(
 	 */
 	if (rec_daddr > info->next_daddr) {
 		if (info->head->fmh_entries >= info->head->fmh_count)
-			return XFS_BTREE_QUERY_RANGE_ABORT;
+			return -ECANCELED;
 
 		fmr.fmr_device = info->dev;
 		fmr.fmr_physical = info->next_daddr;
@@ -295,7 +295,7 @@ xfs_getfsmap_helper(
 
 	/* Fill out the extent we found */
 	if (info->head->fmh_entries >= info->head->fmh_count)
-		return XFS_BTREE_QUERY_RANGE_ABORT;
+		return -ECANCELED;
 
 	trace_xfs_fsmap_mapping(mp, info->dev, info->agno, rec);
 
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 6ad63b57b6ca..495565feae4f 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -831,7 +831,7 @@ xfs_bulkstat_fmt(
 /*
  * Check the incoming bulk request @hdr from userspace and initialize the
  * internal @breq bulk request appropriately.  Returns 0 if the bulk request
- * should proceed; XFS_ITER_ABORT if there's nothing to do; or the usual
+ * should proceed; -ECANCELED if there's nothing to do; or the usual
  * negative error code.
  */
 static int
@@ -889,13 +889,13 @@ xfs_bulk_ireq_setup(
 
 		/* Asking for an inode past the end of the AG?  We're done! */
 		if (XFS_INO_TO_AGNO(mp, breq->startino) > hdr->agno)
-			return XFS_ITER_ABORT;
+			return -ECANCELED;
 	} else if (hdr->agno)
 		return -EINVAL;
 
 	/* Asking for an inode past the end of the FS?  We're done! */
 	if (XFS_INO_TO_AGNO(mp, breq->startino) >= mp->m_sb.sb_agcount)
-		return XFS_ITER_ABORT;
+		return -ECANCELED;
 
 	return 0;
 }
@@ -936,7 +936,7 @@ xfs_ioc_bulkstat(
 		return -EFAULT;
 
 	error = xfs_bulk_ireq_setup(mp, &hdr, &breq, arg->bulkstat);
-	if (error == XFS_ITER_ABORT)
+	if (error == -ECANCELED)
 		goto out_teardown;
 	if (error < 0)
 		return error;
@@ -986,7 +986,7 @@ xfs_ioc_inumbers(
 		return -EFAULT;
 
 	error = xfs_bulk_ireq_setup(mp, &hdr, &breq, arg->inumbers);
-	if (error == XFS_ITER_ABORT)
+	if (error == -ECANCELED)
 		goto out_teardown;
 	if (error < 0)
 		return error;
@@ -1881,7 +1881,7 @@ xfs_ioc_getfsmap(
 	info.mp = ip->i_mount;
 	info.data = arg;
 	error = xfs_getfsmap(ip->i_mount, &xhead, xfs_getfsmap_format, &info);
-	if (error == XFS_BTREE_QUERY_RANGE_ABORT) {
+	if (error == -ECANCELED) {
 		error = 0;
 		aborted = true;
 	} else if (error)
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index b049e7369a66..884950adbd16 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -137,7 +137,7 @@ xfs_bulkstat_one_int(
 	xfs_irele(ip);
 
 	error = bc->formatter(bc->breq, buf);
-	if (error == XFS_IBULK_ABORT)
+	if (error == -ECANCELED)
 		goto out_advance;
 	if (error)
 		goto out;
@@ -181,7 +181,7 @@ xfs_bulkstat_one(
 	 * If we reported one inode to userspace then we abort because we hit
 	 * the end of the buffer.  Don't leak that back to userspace.
 	 */
-	if (error == XFS_IWALK_ABORT)
+	if (error == -ECANCELED)
 		error = 0;
 
 	return error;
@@ -342,7 +342,7 @@ xfs_inumbers_walk(
 	int			error;
 
 	error = ic->formatter(ic->breq, &inogrp);
-	if (error && error != XFS_IBULK_ABORT)
+	if (error && error != -ECANCELED)
 		return error;
 
 	ic->breq->startino = XFS_AGINO_TO_INO(mp, agno, irec->ir_startino) +
diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
index e90c1fc5b981..96a1e2a9be3f 100644
--- a/fs/xfs/xfs_itable.h
+++ b/fs/xfs/xfs_itable.h
@@ -18,9 +18,6 @@ struct xfs_ibulk {
 /* Only iterate within the same AG as startino */
 #define XFS_IBULK_SAME_AG	(XFS_IWALK_SAME_AG)
 
-/* Return value that means we want to abort the walk. */
-#define XFS_IBULK_ABORT		(XFS_IWALK_ABORT)
-
 /*
  * Advance the user buffer pointer by one record of the given size.  If the
  * buffer is now full, return the appropriate error code.
@@ -34,13 +31,21 @@ xfs_ibulk_advance(
 
 	breq->ubuffer = b + bytes;
 	breq->ocount++;
-	return breq->ocount == breq->icount ? XFS_IBULK_ABORT : 0;
+	return breq->ocount == breq->icount ? -ECANCELED : 0;
 }
 
 /*
  * Return stat information in bulk (by-inode) for the filesystem.
  */
 
+/*
+ * Return codes for the formatter function are 0 to continue iterating, and
+ * non-zero to stop iterating.  Any non-zero value will be passed up to the
+ * bulkstat/inumbers caller.  The special value -ECANCELED can be used to stop
+ * iteration, as neither bulkstat nor inumbers will ever generate that error
+ * code on their own.
+ */
+
 typedef int (*bulkstat_one_fmt_pf)(struct xfs_ibulk *breq,
 		const struct xfs_bulkstat *bstat);
 
diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index 86ce52c1871f..aa375cf53021 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -31,7 +31,7 @@
  * inode it finds, it calls a walk function with the relevant inode number and
  * a pointer to caller-provided data.  The walk function can return the usual
  * negative error code to stop the iteration; 0 to continue the iteration; or
- * XFS_IWALK_ABORT to stop the iteration.  This return value is returned to the
+ * -ECANCELED to stop the iteration.  This return value is returned to the
  * caller.
  *
  * Internally, we allow the walk function to do anything, which means that we
diff --git a/fs/xfs/xfs_iwalk.h b/fs/xfs/xfs_iwalk.h
index 6c960e10ed4d..742360d51378 100644
--- a/fs/xfs/xfs_iwalk.h
+++ b/fs/xfs/xfs_iwalk.h
@@ -6,12 +6,19 @@
 #ifndef __XFS_IWALK_H__
 #define __XFS_IWALK_H__
 
+/*
+ * Return codes for the inode/inobt walk function are 0 to continue iterating,
+ * and non-zero to stop iterating.  Any non-zero value will be passed up to the
+ * iwalk or inobt_walk caller.  The special value -ECANCELED can be used to
+ * stop iteration, as neither iwalk nor inobt_walk will ever generate that
+ * error code on their own.
+ */
+
 /* Walk all inodes in the filesystem starting from @startino. */
 typedef int (*xfs_iwalk_fn)(struct xfs_mount *mp, struct xfs_trans *tp,
 			    xfs_ino_t ino, void *data);
 /* Return values for xfs_iwalk_fn. */
 #define XFS_IWALK_CONTINUE	(XFS_ITER_CONTINUE)
-#define XFS_IWALK_ABORT		(XFS_ITER_ABORT)
 
 int xfs_iwalk(struct xfs_mount *mp, struct xfs_trans *tp, xfs_ino_t startino,
 		unsigned int flags, xfs_iwalk_fn iwalk_fn,
@@ -30,8 +37,6 @@ typedef int (*xfs_inobt_walk_fn)(struct xfs_mount *mp, struct xfs_trans *tp,
 				 xfs_agnumber_t agno,
 				 const struct xfs_inobt_rec_incore *irec,
 				 void *data);
-/* Return value (for xfs_inobt_walk_fn) that aborts the walk immediately. */
-#define XFS_INOBT_WALK_ABORT	(XFS_IWALK_ABORT)
 
 int xfs_inobt_walk(struct xfs_mount *mp, struct xfs_trans *tp,
 		xfs_ino_t startino, unsigned int flags,
