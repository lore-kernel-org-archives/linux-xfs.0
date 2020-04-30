Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4EF2C47258
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 22:47:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C30392074A
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 22:47:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MHnMuujv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbgD3WrK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 18:47:10 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58852 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727057AbgD3WrK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 18:47:10 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UMhiUS063692
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=NsVaLSWlUl8F1K6hY1/VK4rCXNSeDosL4h+VnArxnsg=;
 b=MHnMuujv0y3Qcu4lBmW4eII624Ov/6T27WbhRLyByMGn3bPrnjTAwaNUDXSNPgB031OH
 u3ca+BWD3hbvrXIczLAQYSfyv1ppaZXMpwmVD2/YUMIu69qD9teX0UByi2MsM3dO6e7n
 SFcDsceHC0Nnv80ea39RA5c39pv71N4t1sgwhsS+wvXdz75P05r/Ra2ny3iAP/jPmT0D
 rHGIA8+GzLLoyASDdvRpfcRfMY96pWwWw6f8r4Ic2vghSpiXMDCBaB/ECI6OWM6LG90W
 oA6rDXHjGhwXf6vrHQTErCk+JOfIGlxPmHm2NVRbLWbP98c2RzZKNrRBsd/9cSNW6LXN 7w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 30r7f8027r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UMgER3141553
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:07 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 30qtg23dpu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:07 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03UMl6sc012281
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:06 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 15:47:06 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 06/43] xfsprogs: pass an initialized xfs_da_args structure to xfs_attr_set
Date:   Thu, 30 Apr 2020 15:46:23 -0700
Message-Id: <20200430224700.4183-7-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430224700.4183-1-allison.henderson@oracle.com>
References: <20200430224700.4183-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 clxscore=1015 phishscore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=1 adultscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300167
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Instead of converting from one style of arguments to another in
xfs_attr_set, pass the structure from higher up in the call chain.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 db/attrset.c      | 34 ++++++++++++++++++---------
 libxfs/xfs_attr.c | 69 +++++++++++++++++++++++++------------------------------
 libxfs/xfs_attr.h |  3 +--
 3 files changed, 55 insertions(+), 51 deletions(-)

diff --git a/db/attrset.c b/db/attrset.c
index 708e71e3..0b5aabb 100644
--- a/db/attrset.c
+++ b/db/attrset.c
@@ -66,9 +66,10 @@ attr_set_f(
 	int		argc,
 	char		**argv)
 {
-	xfs_inode_t	*ip = NULL;
-	char		*name, *value, *sp;
-	int		c, valuelen = 0, flags = 0;
+	xfs_inode_t		*ip = NULL;
+	char			*name, *value, *sp;
+	int			c, valuelen = 0, flags = 0;
+	struct xfs_da_args	args;
 
 	if (cur_typ == NULL) {
 		dbprintf(_("no current type\n"));
@@ -146,8 +147,13 @@ attr_set_f(
 		goto out;
 	}
 
-	if (libxfs_attr_set(ip, (unsigned char *)name, strlen(name),
-				(unsigned char *)value, valuelen, flags)) {
+	args.dp = ip;
+	args.name = (unsigned char *)name;
+	args.namelen = strlen(name);
+	args.value = (unsigned char *)value;
+	args.flags = flags;
+
+	if (libxfs_attr_set(&args)){
 		dbprintf(_("failed to set attr %s on inode %llu\n"),
 			name, (unsigned long long)iocur_top->ino);
 		goto out;
@@ -170,10 +176,10 @@ attr_remove_f(
 	int		argc,
 	char		**argv)
 {
-	xfs_inode_t	*ip = NULL;
-	char		*name;
-	int		c, flags = 0;
-
+	xfs_inode_t		*ip = NULL;
+	char			*name;
+	int			c, flags = 0;
+	struct xfs_da_args	args;
 	if (cur_typ == NULL) {
 		dbprintf(_("no current type\n"));
 		return 0;
@@ -222,8 +228,14 @@ attr_remove_f(
 		goto out;
 	}
 
-	if (libxfs_attr_set(ip, (unsigned char *)name, strlen(name), NULL, 0,
-			       flags)){
+	args.dp = ip;
+	args.name = (unsigned char *)name;
+	args.namelen = strlen(name);
+	args.value = NULL;
+	args.valuelen = 0;
+	args.flags = flags;
+
+	if (libxfs_attr_set(&args)){
 		dbprintf(_("failed to remove attr %s from inode %llu\n"),
 			name, (unsigned long long)iocur_top->ino);
 		goto out;
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 00cd7c2..bc64e92 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -330,22 +330,17 @@ xfs_attr_remove_args(
 }
 
 /*
- * Note: If value is NULL the attribute will be removed, just like the
+ * Note: If args->value is NULL the attribute will be removed, just like the
  * Linux ->setattr API.
  */
 int
 xfs_attr_set(
-	struct xfs_inode	*dp,
-	const unsigned char	*name,
-	size_t			namelen,
-	unsigned char		*value,
-	int			valuelen,
-	int			flags)
+	struct xfs_da_args	*args)
 {
+	struct xfs_inode	*dp = args->dp;
 	struct xfs_mount	*mp = dp->i_mount;
-	struct xfs_da_args	args;
 	struct xfs_trans_res	tres;
-	int			rsvd = (flags & ATTR_ROOT) != 0;
+	int			rsvd = (args->flags & ATTR_ROOT) != 0;
 	int			error, local;
 	unsigned int		total;
 
@@ -356,25 +351,22 @@ xfs_attr_set(
 	if (error)
 		return error;
 
-	error = xfs_attr_args_init(&args, dp, name, namelen, flags);
-	if (error)
-		return error;
-
-	args.value = value;
-	args.valuelen = valuelen;
+	args->geo = mp->m_attr_geo;
+	args->whichfork = XFS_ATTR_FORK;
+	args->hashval = xfs_da_hashname(args->name, args->namelen);
 
 	/*
 	 * We have no control over the attribute names that userspace passes us
 	 * to remove, so we have to allow the name lookup prior to attribute
 	 * removal to fail as well.
 	 */
-	args.op_flags = XFS_DA_OP_OKNOENT;
+	args->op_flags = XFS_DA_OP_OKNOENT;
 
-	if (value) {
+	if (args->value) {
 		XFS_STATS_INC(mp, xs_attr_set);
 
-		args.op_flags |= XFS_DA_OP_ADDNAME;
-		args.total = xfs_attr_calc_size(&args, &local);
+		args->op_flags |= XFS_DA_OP_ADDNAME;
+		args->total = xfs_attr_calc_size(args, &local);
 
 		/*
 		 * If the inode doesn't have an attribute fork, add one.
@@ -382,8 +374,8 @@ xfs_attr_set(
 		 */
 		if (XFS_IFORK_Q(dp) == 0) {
 			int sf_size = sizeof(struct xfs_attr_sf_hdr) +
-				XFS_ATTR_SF_ENTSIZE_BYNAME(args.namelen,
-						valuelen);
+				XFS_ATTR_SF_ENTSIZE_BYNAME(args->namelen,
+						args->valuelen);
 
 			error = xfs_bmap_add_attrfork(dp, sf_size, rsvd);
 			if (error)
@@ -391,10 +383,11 @@ xfs_attr_set(
 		}
 
 		tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
-				 M_RES(mp)->tr_attrsetrt.tr_logres * args.total;
+				 M_RES(mp)->tr_attrsetrt.tr_logres *
+					args->total;
 		tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
 		tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
-		total = args.total;
+		total = args->total;
 	} else {
 		XFS_STATS_INC(mp, xs_attr_remove);
 
@@ -407,29 +400,29 @@ xfs_attr_set(
 	 * operation if necessary
 	 */
 	error = xfs_trans_alloc(mp, &tres, total, 0,
-			rsvd ? XFS_TRANS_RESERVE : 0, &args.trans);
+			rsvd ? XFS_TRANS_RESERVE : 0, &args->trans);
 	if (error)
 		return error;
 
 	xfs_ilock(dp, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(args.trans, dp, 0);
-	if (value) {
+	xfs_trans_ijoin(args->trans, dp, 0);
+	if (args->value) {
 		unsigned int	quota_flags = XFS_QMOPT_RES_REGBLKS;
 
 		if (rsvd)
 			quota_flags |= XFS_QMOPT_FORCE_RES;
-		error = xfs_trans_reserve_quota_nblks(args.trans, dp,
-				args.total, 0, quota_flags);
+		error = xfs_trans_reserve_quota_nblks(args->trans, dp,
+				args->total, 0, quota_flags);
 		if (error)
 			goto out_trans_cancel;
-		error = xfs_attr_set_args(&args);
+		error = xfs_attr_set_args(args);
 		if (error)
 			goto out_trans_cancel;
 		/* shortform attribute has already been committed */
-		if (!args.trans)
+		if (!args->trans)
 			goto out_unlock;
 	} else {
-		error = xfs_attr_remove_args(&args);
+		error = xfs_attr_remove_args(args);
 		if (error)
 			goto out_trans_cancel;
 	}
@@ -439,23 +432,23 @@ xfs_attr_set(
 	 * transaction goes to disk before returning to the user.
 	 */
 	if (mp->m_flags & XFS_MOUNT_WSYNC)
-		xfs_trans_set_sync(args.trans);
+		xfs_trans_set_sync(args->trans);
 
-	if ((flags & ATTR_KERNOTIME) == 0)
-		xfs_trans_ichgtime(args.trans, dp, XFS_ICHGTIME_CHG);
+	if ((args->flags & ATTR_KERNOTIME) == 0)
+		xfs_trans_ichgtime(args->trans, dp, XFS_ICHGTIME_CHG);
 
 	/*
 	 * Commit the last in the sequence of transactions.
 	 */
-	xfs_trans_log_inode(args.trans, dp, XFS_ILOG_CORE);
-	error = xfs_trans_commit(args.trans);
+	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE);
+	error = xfs_trans_commit(args->trans);
 out_unlock:
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
 	return error;
 
 out_trans_cancel:
-	if (args.trans)
-		xfs_trans_cancel(args.trans);
+	if (args->trans)
+		xfs_trans_cancel(args->trans);
 	goto out_unlock;
 }
 
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index db58a6c..07ca543 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -149,8 +149,7 @@ int xfs_attr_get_ilocked(struct xfs_inode *ip, struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
 		 size_t namelen, unsigned char **value, int *valuelenp,
 		 int flags);
-int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
-		 size_t namelen, unsigned char *value, int valuelen, int flags);
+int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_args(struct xfs_da_args *args);
 int xfs_attr_remove_args(struct xfs_da_args *args);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
-- 
2.7.4

