Return-Path: <SRS0=Pn/S=YS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C714BCA9EA0
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 05:15:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F71921872
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 05:15:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ddagZR+S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392691AbfJYFPE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Oct 2019 01:15:04 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45492 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729081AbfJYFPE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Oct 2019 01:15:04 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9P5Dkdp123713
        for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2019 05:15:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=yarOo7g07vFG0hy0ibtp91U16e8vPmwdOYZr7kdbZTQ=;
 b=ddagZR+SM2jhhqBzdFd4oc8bPhzwrak+Akt0tkWXa+8K7Wn5983xRXEkheZz7OwW2D/K
 vn/MpZ2L9WKGjajcleAv0UGIZIavYiUBkvXURhx928RJ4HcVA8CytwcGuJ5zd/sKvhs2
 PEd0/LG/6LJcAPkz3rfs5E7v515YvPt8tSklpkCoo6AARkAiCcba2MYPvIJ07T9KydN8
 3j3EqhKiMoVUySdAZ7djeM7NEESDE2ytYu6gmWdLRIrQG5l1/8zQWSlylCWwkjCsr5pT
 ziapqUOXlEJ3RfMpem+i4sTQL2I1Dkznq/gGKNdfQuOcgYJV9tJqjJpakDxUW9UeZv8Z lg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2vqswu08n6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2019 05:15:02 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9P5Dlam073525
        for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2019 05:15:02 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2vu0fqsbq5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2019 05:15:01 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9P5F0qc002027
        for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2019 05:15:00 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 24 Oct 2019 22:15:00 -0700
Subject: [PATCH 2/4] xfs: namecheck attribute names before listing them
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 24 Oct 2019 22:14:59 -0700
Message-ID: <157198049955.2873445.974102983711142585.stgit@magnolia>
In-Reply-To: <157198048552.2873445.18067788660614948888.stgit@magnolia>
References: <157198048552.2873445.18067788660614948888.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9420 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910250050
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9420 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910250050
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Actually call namecheck on attribute names before we hand them over to
userspace.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.h |    4 ++--
 fs/xfs/xfs_attr_list.c        |   40 ++++++++++++++++++++++++++++++++--------
 2 files changed, 34 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
index 7b74e18becff..bb0880057ee3 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.h
+++ b/fs/xfs/libxfs/xfs_attr_leaf.h
@@ -67,8 +67,8 @@ int	xfs_attr3_leaf_add(struct xfs_buf *leaf_buffer,
 				 struct xfs_da_args *args);
 int	xfs_attr3_leaf_remove(struct xfs_buf *leaf_buffer,
 				    struct xfs_da_args *args);
-void	xfs_attr3_leaf_list_int(struct xfs_buf *bp,
-				      struct xfs_attr_list_context *context);
+int	xfs_attr3_leaf_list_int(struct xfs_buf *bp,
+				struct xfs_attr_list_context *context);
 
 /*
  * Routines used for shrinking the Btree.
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 00758fdc2fec..3a1158a1347d 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -84,6 +84,11 @@ xfs_attr_shortform_list(xfs_attr_list_context_t *context)
 	    (XFS_ISRESET_CURSOR(cursor) &&
 	     (dp->i_afp->if_bytes + sf->hdr.count * 16) < context->bufsize)) {
 		for (i = 0, sfe = &sf->list[0]; i < sf->hdr.count; i++) {
+			if (!xfs_attr_namecheck(sfe->nameval, sfe->namelen)) {
+				XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
+						 context->dp->i_mount);
+				return -EFSCORRUPTED;
+			}
 			context->put_listent(context,
 					     sfe->flags,
 					     sfe->nameval,
@@ -174,6 +179,11 @@ xfs_attr_shortform_list(xfs_attr_list_context_t *context)
 			cursor->hashval = sbp->hash;
 			cursor->offset = 0;
 		}
+		if (!xfs_attr_namecheck(sbp->name, sbp->namelen)) {
+			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
+					 context->dp->i_mount);
+			return -EFSCORRUPTED;
+		}
 		context->put_listent(context,
 				     sbp->flags,
 				     sbp->name,
@@ -284,7 +294,7 @@ xfs_attr_node_list(
 	struct xfs_buf			*bp;
 	struct xfs_inode		*dp = context->dp;
 	struct xfs_mount		*mp = dp->i_mount;
-	int				error;
+	int				error = 0;
 
 	trace_xfs_attr_node_list(context);
 
@@ -358,7 +368,9 @@ xfs_attr_node_list(
 	 */
 	for (;;) {
 		leaf = bp->b_addr;
-		xfs_attr3_leaf_list_int(bp, context);
+		error = xfs_attr3_leaf_list_int(bp, context);
+		if (error)
+			break;
 		xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, leaf);
 		if (context->seen_enough || leafhdr.forw == 0)
 			break;
@@ -369,13 +381,13 @@ xfs_attr_node_list(
 			return error;
 	}
 	xfs_trans_brelse(context->tp, bp);
-	return 0;
+	return error;
 }
 
 /*
  * Copy out attribute list entries for attr_list(), for leaf attribute lists.
  */
-void
+int
 xfs_attr3_leaf_list_int(
 	struct xfs_buf			*bp,
 	struct xfs_attr_list_context	*context)
@@ -417,7 +429,7 @@ xfs_attr3_leaf_list_int(
 		}
 		if (i == ichdr.count) {
 			trace_xfs_attr_list_notfound(context);
-			return;
+			return 0;
 		}
 	} else {
 		entry = &entries[0];
@@ -457,6 +469,11 @@ xfs_attr3_leaf_list_int(
 			valuelen = be32_to_cpu(name_rmt->valuelen);
 		}
 
+		if (!xfs_attr_namecheck(name, namelen)) {
+			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
+					 context->dp->i_mount);
+			return -EFSCORRUPTED;
+		}
 		context->put_listent(context, entry->flags,
 					      name, namelen, valuelen);
 		if (context->seen_enough)
@@ -464,7 +481,7 @@ xfs_attr3_leaf_list_int(
 		cursor->offset++;
 	}
 	trace_xfs_attr_list_leaf_end(context);
-	return;
+	return 0;
 }
 
 /*
@@ -483,9 +500,9 @@ xfs_attr_leaf_list(xfs_attr_list_context_t *context)
 	if (error)
 		return error;
 
-	xfs_attr3_leaf_list_int(bp, context);
+	error = xfs_attr3_leaf_list_int(bp, context);
 	xfs_trans_brelse(context->tp, bp);
-	return 0;
+	return error;
 }
 
 int
@@ -557,6 +574,13 @@ xfs_attr_put_listent(
 	ASSERT(context->firstu >= sizeof(*alist));
 	ASSERT(context->firstu <= context->bufsize);
 
+	if (!xfs_attr_namecheck(name, namelen)) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
+				 context->dp->i_mount);
+		context->seen_enough = -EFSCORRUPTED;
+		return;
+	}
+
 	/*
 	 * Only list entries in the right namespace.
 	 */

