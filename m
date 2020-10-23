Return-Path: <SRS0=+s6N=D6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C03FEC55178
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Oct 2020 06:35:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 703E42192A
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Oct 2020 06:35:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UIjHK3Nn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S375338AbgJWGfW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Oct 2020 02:35:22 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45180 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S372848AbgJWGfV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Oct 2020 02:35:21 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09N6PHhY025926
        for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2020 06:35:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=pG5l8DUz+HYlN1k7Goytm+5fB8gz5YLjZYwBvC94SoE=;
 b=UIjHK3Nny9F5P3TzrlkyiM7ysKpOgt+So+ou+a6Rw4qmdb//kPa5n0PCoPODJccYVple
 gaqxvPUfFrMk5AKQQ90FC3Yf/Cyph2orQ+rfGAM35MrFnxhVhENk3lvCcg4MLt/LfuGj
 CFSMukU3Dzo494sazwSReRqpb2hSUEHONJyfTw/5bdTUDQfmWuKMo4KEReW+wXEWhbVA
 3cEAIsOi8t+H8dO6rcS6A6LzdcSEP673FuFf3qmejGvAi4uw3PhhAf20TjbPrxPXWH45
 X9EnkzYtskQlwpgeVczc9Y4FF1PHEWYkedpT7bG1ooZNtWTLDMRmggk9yWZ/83m/RnOA xg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 34ak16snpy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2020 06:35:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09N6Q16L123287
        for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2020 06:33:20 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 34ak1aqy9c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2020 06:33:20 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09N6XJ3f012225
        for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2020 06:33:19 GMT
Received: from localhost.localdomain (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 22 Oct 2020 23:33:19 -0700
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v13 11/14] xfsprogs: Remove unused xfs_attr_*_args
Date:   Thu, 22 Oct 2020 23:33:03 -0700
Message-Id: <20201023063306.7441-12-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201023063306.7441-1-allison.henderson@oracle.com>
References: <20201023063306.7441-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9782 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxscore=0 phishscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010230045
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9782 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 spamscore=0 mlxlogscore=999
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010230045
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Remove xfs_attr_set_args, xfs_attr_remove_args, and xfs_attr_trans_roll.
These high level loops are now driven by the delayed operations code,
and can be removed.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c | 97 +------------------------------------------------------
 libxfs/xfs_attr.h |  2 --
 2 files changed, 1 insertion(+), 98 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 6267669..248e89e 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -261,65 +261,6 @@ xfs_attr_set_shortform(
 }
 
 /*
- * Checks to see if a delayed attribute transaction should be rolled.  If so,
- * also checks for a defer finish.  Transaction is finished and rolled as
- * needed, and returns true of false if the delayed operation should continue.
- */
-STATIC int
-xfs_attr_trans_roll(
-	struct xfs_delattr_context	*dac)
-{
-	struct xfs_da_args		*args = dac->da_args;
-	int				error = 0;
-
-	if (dac->flags & XFS_DAC_DEFER_FINISH) {
-		/*
-		 * The caller wants us to finish all the deferred ops so that we
-		 * avoid pinning the log tail with a large number of deferred
-		 * ops.
-		 */
-		dac->flags &= ~XFS_DAC_DEFER_FINISH;
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			return error;
-	}
-
-	return xfs_trans_roll_inode(&args->trans, args->dp);
-}
-
-/*
- * Set the attribute specified in @args.
- */
-int
-xfs_attr_set_args(
-	struct xfs_da_args	*args)
-{
-	struct xfs_buf			*leaf_bp = NULL;
-	int				error = 0;
-	struct xfs_delattr_context	dac = {
-		.da_args	= args,
-	};
-
-	do {
-		error = xfs_attr_set_iter(&dac, &leaf_bp);
-		if (error != -EAGAIN)
-			break;
-
-		error = xfs_attr_trans_roll(&dac);
-		if (error)
-			return error;
-
-		if (leaf_bp) {
-			xfs_trans_bjoin(args->trans, leaf_bp);
-			xfs_trans_bhold(args->trans, leaf_bp);
-		}
-
-	} while (true);
-
-	return error;
-}
-
-/*
  * Set the attribute specified in @args.
  * This routine is meant to function as a delayed operation, and may return
  * -EAGAIN when the transaction needs to be rolled.  Calling functions will need
@@ -362,11 +303,7 @@ xfs_attr_set_iter(
 		 * continue.  Otherwise, is it converted from shortform to leaf
 		 * and -EAGAIN is returned.
 		 */
-		error = xfs_attr_set_shortform(args, leaf_bp);
-		if (error == -EAGAIN)
-			dac->flags |= XFS_DAC_DEFER_FINISH;
-
-		return error;
+		return xfs_attr_set_shortform(args, leaf_bp);
 	}
 
 	/*
@@ -397,7 +334,6 @@ xfs_attr_set_iter(
 			 * same state (inode locked and joined, transaction
 			 * clean) no matter how we got to this step.
 			 */
-			dac->flags |= XFS_DAC_DEFER_FINISH;
 			return -EAGAIN;
 		case 0:
 			dac->dela_state = XFS_DAS_FOUND_LBLK;
@@ -454,32 +390,6 @@ xfs_has_attr(
 
 /*
  * Remove the attribute specified in @args.
- */
-int
-xfs_attr_remove_args(
-	struct xfs_da_args	*args)
-{
-	int				error = 0;
-	struct xfs_delattr_context	dac = {
-		.da_args	= args,
-	};
-
-	do {
-		error = xfs_attr_remove_iter(&dac);
-		if (error != -EAGAIN)
-			break;
-
-		error = xfs_attr_trans_roll(&dac);
-		if (error)
-			return error;
-
-	} while (true);
-
-	return error;
-}
-
-/*
- * Remove the attribute specified in @args.
  *
  * This function may return -EAGAIN to signal that the transaction needs to be
  * rolled.  Callers should continue calling this function until they receive a
@@ -886,7 +796,6 @@ xfs_attr_leaf_addname(
 		if (error)
 			return error;
 
-		dac->flags |= XFS_DAC_DEFER_FINISH;
 		return -EAGAIN;
 	}
 
@@ -1183,7 +1092,6 @@ xfs_attr_node_addname(
 			 * Restart routine from the top.  No need to set  the
 			 * state
 			 */
-			dac->flags |= XFS_DAC_DEFER_FINISH;
 			return -EAGAIN;
 		}
 
@@ -1196,7 +1104,6 @@ xfs_attr_node_addname(
 		error = xfs_da3_split(state);
 		if (error)
 			goto out;
-		dac->flags |= XFS_DAC_DEFER_FINISH;
 	} else {
 		/*
 		 * Addition succeeded, update Btree hashvals.
@@ -1237,7 +1144,6 @@ das_alloc_node:
 			if (error)
 				return error;
 
-			dac->flags |= XFS_DAC_DEFER_FINISH;
 			dac->dela_state = XFS_DAS_ALLOC_NODE;
 			return -EAGAIN;
 		}
@@ -1505,7 +1411,6 @@ xfs_attr_node_remove_step(
 	if (retval && (state->path.active > 1)) {
 		error = xfs_da3_join(state);
 		if (error)
-		dac->flags |= XFS_DAC_DEFER_FINISH;
 		dac->dela_state = XFS_DAS_RM_SHRINK;
 		return -EAGAIN;
 	}
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 8a08411..58f9660 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -297,11 +297,9 @@ int xfs_inode_hasattr(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
-int xfs_attr_set_args(struct xfs_da_args *args);
 int xfs_attr_set_iter(struct xfs_delattr_context *dac,
 		      struct xfs_buf **leaf_bp);
 int xfs_has_attr(struct xfs_da_args *args);
-int xfs_attr_remove_args(struct xfs_da_args *args);
 int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
 bool xfs_attr_namecheck(const void *name, size_t length);
 void xfs_delattr_context_init(struct xfs_delattr_context *dac,
-- 
2.7.4

