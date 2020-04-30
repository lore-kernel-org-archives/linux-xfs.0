Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DE73C47247
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 22:49:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B31C208C3
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 22:49:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JaAG8JCr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgD3WtJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 18:49:09 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45062 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726784AbgD3WtI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 18:49:08 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UMmvLN132933
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:49:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=7uN69r3Relzv2FGxyDjHYizrqgKyFeQt6aX0C7cDqr0=;
 b=JaAG8JCrsDp5vP9IMLW28lW+E39wLNDHj4VuSwMT7Pj8NG5xbaQeWoywnxstA5uewGDe
 zDJ/kd/i3bF9kEuieTWM+nof2nDzu9Mq5KXLaoyMrvzklkZNJkP4AEDid+qeoGpMzB2q
 UBUVJ1CnC/dILjmNm6PRvgMNqlcLyoHzzSeVHrZM8bo9wTnnn1sNeZfgtBK5pHP4cn5n
 jPtZG4UyNhcwRhoULaQWFWUaJwnC2uic3cEx3fzIKOrefQyLtL+vtWQzkvRjZMy3/rE9
 IYfsFbWyxTY18FPLnI7AIhMcpTPXNk35RQSTksBqKPfaXK+7Zuqhm/RGijyokrjS7KyC OQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 30r7f3g2an-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:49:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UMgt3e076965
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:06 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 30r7f89ytx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:06 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03UMl5kQ031978
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:05 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 15:47:05 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 02/43] xfsprogs: merge xfs_attr_remove into xfs_attr_set
Date:   Thu, 30 Apr 2020 15:46:19 -0700
Message-Id: <20200430224700.4183-3-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430224700.4183-1-allison.henderson@oracle.com>
References: <20200430224700.4183-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=1
 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 suspectscore=1
 phishscore=0 mlxlogscore=999 impostorscore=0 spamscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300167
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The Linux xattr and acl APIs use a single call for set and remove.
Modify the high-level XFS API to match that and let xfs_attr_set handle
removing attributes as well.  With a little bit of reordering this
removes a lot of code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 db/attrset.c             |   3 +-
 libxfs/libxfs_api_defs.h |   1 -
 libxfs/xfs_attr.c        | 179 +++++++++++++++++------------------------------
 libxfs/xfs_attr.h        |   2 -
 4 files changed, 65 insertions(+), 120 deletions(-)

diff --git a/db/attrset.c b/db/attrset.c
index d96b78d..708e71e3 100644
--- a/db/attrset.c
+++ b/db/attrset.c
@@ -222,7 +222,8 @@ attr_remove_f(
 		goto out;
 	}
 
-	if (libxfs_attr_remove(ip, (unsigned char *)name, strlen(name), flags)){
+	if (libxfs_attr_set(ip, (unsigned char *)name, strlen(name), NULL, 0,
+			       flags)){
 		dbprintf(_("failed to remove attr %s from inode %llu\n"),
 			name, (unsigned long long)iocur_top->ino);
 		goto out;
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 1149e30..0ffad20 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -32,7 +32,6 @@
 #define xfs_attr_get			libxfs_attr_get
 #define xfs_attr_leaf_newentsize	libxfs_attr_leaf_newentsize
 #define xfs_attr_namecheck		libxfs_attr_namecheck
-#define xfs_attr_remove			libxfs_attr_remove
 #define xfs_attr_set			libxfs_attr_set
 
 #define xfs_bmapi_read			libxfs_bmapi_read
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 5110bb4..6c56428 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -23,6 +23,7 @@
 #include "xfs_attr_remote.h"
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
+#include "xfs_quota_defs.h"
 
 /*
  * xfs_attr.c
@@ -335,6 +336,10 @@ xfs_attr_remove_args(
 	return error;
 }
 
+/*
+ * Note: If value is NULL the attribute will be removed, just like the
+ * Linux ->setattr API.
+ */
 int
 xfs_attr_set(
 	struct xfs_inode	*dp,
@@ -349,149 +354,92 @@ xfs_attr_set(
 	struct xfs_trans_res	tres;
 	int			rsvd = (flags & ATTR_ROOT) != 0;
 	int			error, local;
-
-	XFS_STATS_INC(mp, xs_attr_set);
+	unsigned int		total;
 
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return -EIO;
 
-	error = xfs_attr_args_init(&args, dp, name, namelen, flags);
-	if (error)
-		return error;
-
-	args.value = value;
-	args.valuelen = valuelen;
-	args.op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
-	args.total = xfs_attr_calc_size(&args, &local);
-
 	error = xfs_qm_dqattach(dp);
 	if (error)
 		return error;
 
-	/*
-	 * If the inode doesn't have an attribute fork, add one.
-	 * (inode must not be locked when we call this routine)
-	 */
-	if (XFS_IFORK_Q(dp) == 0) {
-		int sf_size = sizeof(xfs_attr_sf_hdr_t) +
-			XFS_ATTR_SF_ENTSIZE_BYNAME(args.namelen, valuelen);
-
-		error = xfs_bmap_add_attrfork(dp, sf_size, rsvd);
-		if (error)
-			return error;
-	}
-
-	tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
-			 M_RES(mp)->tr_attrsetrt.tr_logres * args.total;
-	tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
-	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
-
-	/*
-	 * Root fork attributes can use reserved data blocks for this
-	 * operation if necessary
-	 */
-	error = xfs_trans_alloc(mp, &tres, args.total, 0,
-			rsvd ? XFS_TRANS_RESERVE : 0, &args.trans);
+	error = xfs_attr_args_init(&args, dp, name, namelen, flags);
 	if (error)
 		return error;
 
-	xfs_ilock(dp, XFS_ILOCK_EXCL);
-	error = xfs_trans_reserve_quota_nblks(args.trans, dp, args.total, 0,
-				rsvd ? XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_FORCE_RES :
-				       XFS_QMOPT_RES_REGBLKS);
-	if (error)
-		goto out_trans_cancel;
-
-	xfs_trans_ijoin(args.trans, dp, 0);
-	error = xfs_attr_set_args(&args);
-	if (error)
-		goto out_trans_cancel;
-	if (!args.trans) {
-		/* shortform attribute has already been committed */
-		goto out_unlock;
-	}
-
-	/*
-	 * If this is a synchronous mount, make sure that the
-	 * transaction goes to disk before returning to the user.
-	 */
-	if (mp->m_flags & XFS_MOUNT_WSYNC)
-		xfs_trans_set_sync(args.trans);
-
-	if ((flags & ATTR_KERNOTIME) == 0)
-		xfs_trans_ichgtime(args.trans, dp, XFS_ICHGTIME_CHG);
+	args.value = value;
+	args.valuelen = valuelen;
 
 	/*
-	 * Commit the last in the sequence of transactions.
+	 * We have no control over the attribute names that userspace passes us
+	 * to remove, so we have to allow the name lookup prior to attribute
+	 * removal to fail as well.
 	 */
-	xfs_trans_log_inode(args.trans, dp, XFS_ILOG_CORE);
-	error = xfs_trans_commit(args.trans);
-out_unlock:
-	xfs_iunlock(dp, XFS_ILOCK_EXCL);
-	return error;
-
-out_trans_cancel:
-	if (args.trans)
-		xfs_trans_cancel(args.trans);
-	goto out_unlock;
-}
+	args.op_flags = XFS_DA_OP_OKNOENT;
 
-/*
- * Generic handler routine to remove a name from an attribute list.
- * Transitions attribute list from Btree to shortform as necessary.
- */
-int
-xfs_attr_remove(
-	struct xfs_inode	*dp,
-	const unsigned char	*name,
-	size_t			namelen,
-	int			flags)
-{
-	struct xfs_mount	*mp = dp->i_mount;
-	struct xfs_da_args	args;
-	int			error;
+	if (value) {
+		XFS_STATS_INC(mp, xs_attr_set);
 
-	XFS_STATS_INC(mp, xs_attr_remove);
+		args.op_flags |= XFS_DA_OP_ADDNAME;
+		args.total = xfs_attr_calc_size(&args, &local);
 
-	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
-		return -EIO;
+		/*
+		 * If the inode doesn't have an attribute fork, add one.
+		 * (inode must not be locked when we call this routine)
+		 */
+		if (XFS_IFORK_Q(dp) == 0) {
+			int sf_size = sizeof(struct xfs_attr_sf_hdr) +
+				XFS_ATTR_SF_ENTSIZE_BYNAME(args.namelen,
+						valuelen);
 
-	error = xfs_attr_args_init(&args, dp, name, namelen, flags);
-	if (error)
-		return error;
+			error = xfs_bmap_add_attrfork(dp, sf_size, rsvd);
+			if (error)
+				return error;
+		}
 
-	/*
-	 * we have no control over the attribute names that userspace passes us
-	 * to remove, so we have to allow the name lookup prior to attribute
-	 * removal to fail.
-	 */
-	args.op_flags = XFS_DA_OP_OKNOENT;
+		tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
+				 M_RES(mp)->tr_attrsetrt.tr_logres * args.total;
+		tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
+		tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
+		total = args.total;
+	} else {
+		XFS_STATS_INC(mp, xs_attr_remove);
 
-	error = xfs_qm_dqattach(dp);
-	if (error)
-		return error;
+		tres = M_RES(mp)->tr_attrrm;
+		total = XFS_ATTRRM_SPACE_RES(mp);
+	}
 
 	/*
 	 * Root fork attributes can use reserved data blocks for this
 	 * operation if necessary
 	 */
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_attrrm,
-			XFS_ATTRRM_SPACE_RES(mp), 0,
-			(flags & ATTR_ROOT) ? XFS_TRANS_RESERVE : 0,
-			&args.trans);
+	error = xfs_trans_alloc(mp, &tres, total, 0,
+			rsvd ? XFS_TRANS_RESERVE : 0, &args.trans);
 	if (error)
 		return error;
 
 	xfs_ilock(dp, XFS_ILOCK_EXCL);
-	/*
-	 * No need to make quota reservations here. We expect to release some
-	 * blocks not allocate in the common case.
-	 */
 	xfs_trans_ijoin(args.trans, dp, 0);
+	if (value) {
+		unsigned int	quota_flags = XFS_QMOPT_RES_REGBLKS;
 
-	error = xfs_attr_remove_args(&args);
-	if (error)
-		goto out;
+		if (rsvd)
+			quota_flags |= XFS_QMOPT_FORCE_RES;
+		error = xfs_trans_reserve_quota_nblks(args.trans, dp,
+				args.total, 0, quota_flags);
+		if (error)
+			goto out_trans_cancel;
+		error = xfs_attr_set_args(&args);
+		if (error)
+			goto out_trans_cancel;
+		/* shortform attribute has already been committed */
+		if (!args.trans)
+			goto out_unlock;
+	} else {
+		error = xfs_attr_remove_args(&args);
+		if (error)
+			goto out_trans_cancel;
+	}
 
 	/*
 	 * If this is a synchronous mount, make sure that the
@@ -508,15 +456,14 @@ xfs_attr_remove(
 	 */
 	xfs_trans_log_inode(args.trans, dp, XFS_ILOG_CORE);
 	error = xfs_trans_commit(args.trans);
+out_unlock:
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
-
 	return error;
 
-out:
+out_trans_cancel:
 	if (args.trans)
 		xfs_trans_cancel(args.trans);
-	xfs_iunlock(dp, XFS_ILOCK_EXCL);
-	return error;
+	goto out_unlock;
 }
 
 /*========================================================================
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 71bcf12..db58a6c 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -152,8 +152,6 @@ int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
 int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
 		 size_t namelen, unsigned char *value, int valuelen, int flags);
 int xfs_attr_set_args(struct xfs_da_args *args);
-int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name,
-		    size_t namelen, int flags);
 int xfs_attr_remove_args(struct xfs_da_args *args);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 		  int flags, struct attrlist_cursor_kern *cursor);
-- 
2.7.4

