Return-Path: <SRS0=euis=5T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE9B5C2BA1A
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Apr 2020 22:10:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8C012078C
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Apr 2020 22:10:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qJOba/pR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbgDCWKJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Apr 2020 18:10:09 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54072 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727947AbgDCWKJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Apr 2020 18:10:09 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033MA8Wl093384
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:10:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=m37ptyzmIlB9pMTmy2UUktWz+7WyoJEn9LXSavkE1Uo=;
 b=qJOba/pRWatQHUAqZDfCkTYb4jQ5VLKnM5aEmsaMWNEWMLY2wVpJQKG/Xkmz37LC807L
 +m+SVRV44NWBIVkIy3gvJWFjKGbRiMsUQUiTRng9k6jyx68WXdk6p5s6292AyuQ2CTpX
 K0Yh/YUG5u73QL5MNJXOMBryWJOeU+dvwTUX8GCl4N7gMxBEenAQWbamzm9vK7hql8JK
 2vpUWq95VsG6QMMuwVWGgPBf0SqCGMtddYk9gfgTiwa7zEZZX8WEs1xSAbv7YeEMWmWW
 bYAXapHKocYMvjUFHck5qq9olE3RlnFNlcvn4IxTOw7iPzHXZDAGR1CxbXu+ZLTACTNt wA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 303yunp0fk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 03 Apr 2020 22:10:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033M7K5f167858
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:10:07 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 304sju4c47-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 03 Apr 2020 22:10:07 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 033MA6Z7028166
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:10:06 GMT
Received: from localhost.localdomain (/67.1.1.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Apr 2020 15:10:06 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v8 07/39] xfsprogs: pass an initialized xfs_da_args to xfs_attr_get
Date:   Fri,  3 Apr 2020 15:09:26 -0700
Message-Id: <20200403220958.4944-8-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200403220958.4944-1-allison.henderson@oracle.com>
References: <20200403220958.4944-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=3 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0
 suspectscore=3 mlxscore=0 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030171
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
 libxfs/xfs_attr.c | 80 ++++++++++++++++---------------------------------------
 libxfs/xfs_attr.h |  4 +--
 2 files changed, 24 insertions(+), 60 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index bc64e92..9aead7c 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -56,26 +56,6 @@ STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
 STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
 STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
 
-
-STATIC int
-xfs_attr_args_init(
-	struct xfs_da_args	*args,
-	struct xfs_inode	*dp,
-	const unsigned char	*name,
-	size_t			namelen,
-	int			flags)
-{
-	memset(args, 0, sizeof(*args));
-	args->geo = dp->i_mount->m_attr_geo;
-	args->whichfork = XFS_ATTR_FORK;
-	args->dp = dp;
-	args->flags = flags;
-	args->name = name;
-	args->namelen = namelen;
-	args->hashval = xfs_da_hashname(args->name, args->namelen);
-	return 0;
-}
-
 int
 xfs_inode_hasattr(
 	struct xfs_inode	*ip)
@@ -115,15 +95,15 @@ xfs_attr_get_ilocked(
 /*
  * Retrieve an extended attribute by name, and its value if requested.
  *
- * If ATTR_KERNOVAL is set in @flags, then the caller does not want the value,
- * just an indication whether the attribute exists and the size of the value if
- * it exists. The size is returned in @valuelenp,
+ * If ATTR_KERNOVAL is set in args->flags, then the caller does not want the
+ * value, just an indication whether the attribute exists and the size of the
+ * value if it exists. The size is returned in args.valuelen.
  *
  * If the attribute is found, but exceeds the size limit set by the caller in
- * @valuelenp, return -ERANGE with the size of the attribute that was found in
- * @valuelenp.
+ * args->valuelen, return -ERANGE with the size of the attribute that was found
+ * in args->valuelen.
  *
- * If ATTR_ALLOC is set in @flags, allocate the buffer for the value after
+ * If ATTR_ALLOC is set in args->flags, allocate the buffer for the value after
  * existence of the attribute has been determined. On success, return that
  * buffer to the caller and leave them to free it. On failure, free any
  * allocated buffer and ensure the buffer pointer returned to the caller is
@@ -131,51 +111,37 @@ xfs_attr_get_ilocked(
  */
 int
 xfs_attr_get(
-	struct xfs_inode	*ip,
-	const unsigned char	*name,
-	size_t			namelen,
-	unsigned char		**value,
-	int			*valuelenp,
-	int			flags)
+	struct xfs_da_args	*args)
 {
-	struct xfs_da_args	args;
 	uint			lock_mode;
 	int			error;
 
-	ASSERT((flags & (ATTR_ALLOC | ATTR_KERNOVAL)) || *value);
+	ASSERT((args->flags & (ATTR_ALLOC | ATTR_KERNOVAL)) || args->value);
 
-	XFS_STATS_INC(ip->i_mount, xs_attr_get);
+	XFS_STATS_INC(args->dp->i_mount, xs_attr_get);
 
-	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
+	if (XFS_FORCED_SHUTDOWN(args->dp->i_mount))
 		return -EIO;
 
-	error = xfs_attr_args_init(&args, ip, name, namelen, flags);
-	if (error)
-		return error;
+	args->geo = args->dp->i_mount->m_attr_geo;
+	args->whichfork = XFS_ATTR_FORK;
+	args->hashval = xfs_da_hashname(args->name, args->namelen);
 
 	/* Entirely possible to look up a name which doesn't exist */
-	args.op_flags = XFS_DA_OP_OKNOENT;
-	if (flags & ATTR_ALLOC)
-		args.op_flags |= XFS_DA_OP_ALLOCVAL;
-	else
-		args.value = *value;
-	args.valuelen = *valuelenp;
+	args->op_flags = XFS_DA_OP_OKNOENT;
+	if (args->flags & ATTR_ALLOC)
+		args->op_flags |= XFS_DA_OP_ALLOCVAL;
 
-	lock_mode = xfs_ilock_attr_map_shared(ip);
-	error = xfs_attr_get_ilocked(ip, &args);
-	xfs_iunlock(ip, lock_mode);
-	*valuelenp = args.valuelen;
+	lock_mode = xfs_ilock_attr_map_shared(args->dp);
+	error = xfs_attr_get_ilocked(args->dp, args);
+	xfs_iunlock(args->dp, lock_mode);
 
 	/* on error, we have to clean up allocated value buffers */
-	if (error) {
-		if (flags & ATTR_ALLOC) {
-			kmem_free(args.value);
-			*value = NULL;
-		}
-		return error;
+	if (error && (args->flags & ATTR_ALLOC)) {
+		kmem_free(args->value);
+		args->value = NULL;
 	}
-	*value = args.value;
-	return 0;
+	return error;
 }
 
 /*
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 07ca543..be77d13 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -146,9 +146,7 @@ int xfs_attr_list_int_ilocked(struct xfs_attr_list_context *);
 int xfs_attr_list_int(struct xfs_attr_list_context *);
 int xfs_inode_hasattr(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_inode *ip, struct xfs_da_args *args);
-int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
-		 size_t namelen, unsigned char **value, int *valuelenp,
-		 int flags);
+int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_args(struct xfs_da_args *args);
 int xfs_attr_remove_args(struct xfs_da_args *args);
-- 
2.7.4

