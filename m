Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C96FC47259
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 22:47:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B420207DD
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 22:47:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BkouQyD+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727057AbgD3WrK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 18:47:10 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58860 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727077AbgD3WrK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 18:47:10 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UMi5bJ063812
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=eSBij3GsuVcuSrdxBUgM1u4nrS7kwiIPn8MxKJOfcTk=;
 b=BkouQyD+wQKPHbnsVGuhYWGm/vt6rglUKF9h6ymd+bfgAibvF1RXEjHF8uqTpaMY4B9N
 xH2Z0u+GqghnnlPAOIkiuKI53tU5X7njawwS43wdiFcslb9xIgmaqD8dRDx+JGFkLEhs
 nuSJu5wNiEF+EDGDId/EN7XRRWo5/fljE+/RGbhHl7uWx3qEAGfSS1QAk5g2463ZWDTe
 8mPHGgZIHq26ZQcPdWfC4tJ3de3v0X27gemKAoL110D26K55D21azbl4HTlgiokbqCvW
 vuNxJmty+wmfclZpRZgWg0Z56N1LUkexpRPN406HQIeojUVzW4qzGQPn8GDPeeeucI3P jQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 30r7f8027t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UMgt0P076959
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:08 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 30r7f89yx1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:08 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03UMl7AA011746
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:07 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 15:47:07 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 10/43] xfsprogs: remove ATTR_ALLOC and XFS_DA_OP_ALLOCVAL
Date:   Thu, 30 Apr 2020 15:46:27 -0700
Message-Id: <20200430224700.4183-11-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430224700.4183-1-allison.henderson@oracle.com>
References: <20200430224700.4183-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=3
 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 clxscore=1015 phishscore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=3 adultscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300167
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Use a NULL args->value as the indicator to lazily allocate a buffer
instead, and let the caller always free args->value instead of
duplicating the cleanup.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c      | 20 +++++---------------
 libxfs/xfs_attr.h      |  7 ++-----
 libxfs/xfs_attr_leaf.c |  2 +-
 libxfs/xfs_da_btree.h  |  2 --
 4 files changed, 8 insertions(+), 23 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index db724af..7adc547 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -98,15 +98,14 @@ xfs_attr_get_ilocked(
  * indication whether the attribute exists and the size of the value if it
  * exists. The size is returned in args.valuelen.
  *
+ * If args->value is NULL but args->valuelen is non-zero, allocate the buffer
+ * for the value after existence of the attribute has been determined. The
+ * caller always has to free args->value if it is set, no matter if this
+ * function was successful or not.
+ *
  * If the attribute is found, but exceeds the size limit set by the caller in
  * args->valuelen, return -ERANGE with the size of the attribute that was found
  * in args->valuelen.
- *
- * If ATTR_ALLOC is set in args->flags, allocate the buffer for the value after
- * existence of the attribute has been determined. On success, return that
- * buffer to the caller and leave them to free it. On failure, free any
- * allocated buffer and ensure the buffer pointer returned to the caller is
- * null.
  */
 int
 xfs_attr_get(
@@ -115,8 +114,6 @@ xfs_attr_get(
 	uint			lock_mode;
 	int			error;
 
-	ASSERT((args->flags & ATTR_ALLOC) || !args->valuelen || args->value);
-
 	XFS_STATS_INC(args->dp->i_mount, xs_attr_get);
 
 	if (XFS_FORCED_SHUTDOWN(args->dp->i_mount))
@@ -128,18 +125,11 @@ xfs_attr_get(
 
 	/* Entirely possible to look up a name which doesn't exist */
 	args->op_flags = XFS_DA_OP_OKNOENT;
-	if (args->flags & ATTR_ALLOC)
-		args->op_flags |= XFS_DA_OP_ALLOCVAL;
 
 	lock_mode = xfs_ilock_attr_map_shared(args->dp);
 	error = xfs_attr_get_ilocked(args);
 	xfs_iunlock(args->dp, lock_mode);
 
-	/* on error, we have to clean up allocated value buffers */
-	if (error && (args->flags & ATTR_ALLOC)) {
-		kmem_free(args->value);
-		args->value = NULL;
-	}
 	return error;
 }
 
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index fe064cd..a6de050 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -35,10 +35,8 @@ struct xfs_attr_list_context;
 
 #define ATTR_KERNOTIME	0x1000	/* [kernel] don't update inode timestamps */
 
-#define ATTR_ALLOC	0x8000	/* [kernel] allocate xattr buffer on demand */
-
 #define ATTR_KERNEL_FLAGS \
-	(ATTR_KERNOTIME | ATTR_ALLOC)
+	(ATTR_KERNOTIME)
 
 #define XFS_ATTR_FLAGS \
 	{ ATTR_DONTFOLLOW, 	"DONTFOLLOW" }, \
@@ -47,8 +45,7 @@ struct xfs_attr_list_context;
 	{ ATTR_SECURE,		"SECURE" }, \
 	{ ATTR_CREATE,		"CREATE" }, \
 	{ ATTR_REPLACE,		"REPLACE" }, \
-	{ ATTR_KERNOTIME,	"KERNOTIME" }, \
-	{ ATTR_ALLOC,		"ALLOC" }
+	{ ATTR_KERNOTIME,	"KERNOTIME" }
 
 /*
  * The maximum size (into the kernel or returned from the kernel) of an
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 8e07e2a..fb07d1d 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -474,7 +474,7 @@ xfs_attr_copy_value(
 		return -ERANGE;
 	}
 
-	if (args->op_flags & XFS_DA_OP_ALLOCVAL) {
+	if (!args->value) {
 		args->value = kmem_alloc_large(valuelen, 0);
 		if (!args->value)
 			return -ENOMEM;
diff --git a/libxfs/xfs_da_btree.h b/libxfs/xfs_da_btree.h
index 0967d1b..dd1ac52 100644
--- a/libxfs/xfs_da_btree.h
+++ b/libxfs/xfs_da_btree.h
@@ -88,7 +88,6 @@ typedef struct xfs_da_args {
 #define XFS_DA_OP_ADDNAME	0x0004	/* this is an add operation */
 #define XFS_DA_OP_OKNOENT	0x0008	/* lookup/add op, ENOENT ok, else die */
 #define XFS_DA_OP_CILOOKUP	0x0010	/* lookup to return CI name if found */
-#define XFS_DA_OP_ALLOCVAL	0x0020	/* lookup to alloc buffer if found  */
 #define XFS_DA_OP_INCOMPLETE	0x0040	/* lookup INCOMPLETE attr keys */
 
 #define XFS_DA_OP_FLAGS \
@@ -97,7 +96,6 @@ typedef struct xfs_da_args {
 	{ XFS_DA_OP_ADDNAME,	"ADDNAME" }, \
 	{ XFS_DA_OP_OKNOENT,	"OKNOENT" }, \
 	{ XFS_DA_OP_CILOOKUP,	"CILOOKUP" }, \
-	{ XFS_DA_OP_ALLOCVAL,	"ALLOCVAL" }, \
 	{ XFS_DA_OP_INCOMPLETE,	"INCOMPLETE" }
 
 /*
-- 
2.7.4

