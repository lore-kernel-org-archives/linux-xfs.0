Return-Path: <SRS0=yuEF=YW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D695BCA9EB9
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 04:04:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9EF89214B2
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 04:04:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NITOehhz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726048AbfJ2EEI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Oct 2019 00:04:08 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48166 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbfJ2EEI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Oct 2019 00:04:08 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9T40xa3187442;
        Tue, 29 Oct 2019 04:04:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=lBQL7OqJA0zSfZXG3XG3e4UCoLB7Ow/CVDL100m9rIY=;
 b=NITOehhz617tlICc3TRnnMg7w+1zJtFZWyZEh1IzbAQrjrs7Nk7QqNdQVZemGXV1otVc
 HbMEcDbl94ymCMLbJcicr37fBvK0FWBhB67QHjQEdZQqXX1cLPMABjOPZd8IwI43bu8Y
 ZOXpbwJGUqkkp5RwvwOTUU47MbGL/hP33q1D9bJ8EabGS51lI/e+8vT7IepkgVOjrlLF
 j5ZfjsBs9Vj7irp5FCpmUJlhuQ3siK4nOmrW42iiOmuzl9xF/61oiZFUkNS19tyLiGd8
 vZyuU9kox+ZyOPjn59PKcpTlLDPUCmc75mAc3MPkG7SXDGkbv9MtSgnG9KhphuHSZvie aQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2vve3q62q1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Oct 2019 04:04:01 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9T3xwvg102695;
        Tue, 29 Oct 2019 04:04:01 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2vvyn10281-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Oct 2019 04:04:01 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9T440Y6018650;
        Tue, 29 Oct 2019 04:04:00 GMT
Received: from localhost (/10.159.156.71)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Oct 2019 21:04:00 -0700
Subject: [PATCH 2/4] xfs: namecheck attribute names before listing them
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com, hch@lst.de
Date:   Mon, 28 Oct 2019 21:03:58 -0700
Message-ID: <157232183873.593721.440778415935090240.stgit@magnolia>
In-Reply-To: <157232182246.593721.4902116478429075171.stgit@magnolia>
References: <157232182246.593721.4902116478429075171.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9424 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910290042
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9424 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910290042
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Actually call namecheck on attribute names before we hand them over to
userspace.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.h |    4 +--
 fs/xfs/xfs_attr_list.c        |   60 +++++++++++++++++++++++++++--------------
 2 files changed, 41 insertions(+), 23 deletions(-)


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
index 00758fdc2fec..c02f22d50e45 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -49,14 +49,16 @@ xfs_attr_shortform_compare(const void *a, const void *b)
  * we can begin returning them to the user.
  */
 static int
-xfs_attr_shortform_list(xfs_attr_list_context_t *context)
+xfs_attr_shortform_list(
+	struct xfs_attr_list_context	*context)
 {
-	attrlist_cursor_kern_t *cursor;
-	xfs_attr_sf_sort_t *sbuf, *sbp;
-	xfs_attr_shortform_t *sf;
-	xfs_attr_sf_entry_t *sfe;
-	xfs_inode_t *dp;
-	int sbsize, nsbuf, count, i;
+	struct attrlist_cursor_kern	*cursor;
+	struct xfs_attr_sf_sort		*sbuf, *sbp;
+	struct xfs_attr_shortform	*sf;
+	struct xfs_attr_sf_entry	*sfe;
+	struct xfs_inode		*dp;
+	int				sbsize, nsbuf, count, i;
+	int				error = 0;
 
 	ASSERT(context != NULL);
 	dp = context->dp;
@@ -84,6 +86,11 @@ xfs_attr_shortform_list(xfs_attr_list_context_t *context)
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
@@ -161,10 +168,8 @@ xfs_attr_shortform_list(xfs_attr_list_context_t *context)
 			break;
 		}
 	}
-	if (i == nsbuf) {
-		kmem_free(sbuf);
-		return 0;
-	}
+	if (i == nsbuf)
+		goto out;
 
 	/*
 	 * Loop putting entries into the user buffer.
@@ -174,6 +179,12 @@ xfs_attr_shortform_list(xfs_attr_list_context_t *context)
 			cursor->hashval = sbp->hash;
 			cursor->offset = 0;
 		}
+		if (!xfs_attr_namecheck(sbp->name, sbp->namelen)) {
+			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
+					 context->dp->i_mount);
+			error = -EFSCORRUPTED;
+			goto out;
+		}
 		context->put_listent(context,
 				     sbp->flags,
 				     sbp->name,
@@ -183,9 +194,9 @@ xfs_attr_shortform_list(xfs_attr_list_context_t *context)
 			break;
 		cursor->offset++;
 	}
-
+out:
 	kmem_free(sbuf);
-	return 0;
+	return error;
 }
 
 /*
@@ -284,7 +295,7 @@ xfs_attr_node_list(
 	struct xfs_buf			*bp;
 	struct xfs_inode		*dp = context->dp;
 	struct xfs_mount		*mp = dp->i_mount;
-	int				error;
+	int				error = 0;
 
 	trace_xfs_attr_node_list(context);
 
@@ -358,7 +369,9 @@ xfs_attr_node_list(
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
@@ -369,13 +382,13 @@ xfs_attr_node_list(
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
@@ -417,7 +430,7 @@ xfs_attr3_leaf_list_int(
 		}
 		if (i == ichdr.count) {
 			trace_xfs_attr_list_notfound(context);
-			return;
+			return 0;
 		}
 	} else {
 		entry = &entries[0];
@@ -457,6 +470,11 @@ xfs_attr3_leaf_list_int(
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
@@ -464,7 +482,7 @@ xfs_attr3_leaf_list_int(
 		cursor->offset++;
 	}
 	trace_xfs_attr_list_leaf_end(context);
-	return;
+	return 0;
 }
 
 /*
@@ -483,9 +501,9 @@ xfs_attr_leaf_list(xfs_attr_list_context_t *context)
 	if (error)
 		return error;
 
-	xfs_attr3_leaf_list_int(bp, context);
+	error = xfs_attr3_leaf_list_int(bp, context);
 	xfs_trans_brelse(context->tp, bp);
-	return 0;
+	return error;
 }
 
 int

