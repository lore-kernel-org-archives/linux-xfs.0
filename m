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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F038C388F9
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Oct 2020 06:34:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7C29223C7
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Oct 2020 06:34:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EG+NSlUF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S375331AbgJWGer (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Oct 2020 02:34:47 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42592 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S375334AbgJWGeq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Oct 2020 02:34:46 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09N6P6r7106699
        for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2020 06:34:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=88OFuPJRv+3sMpcDlHP6uN3ZFPgZSZqFDbv5yRSMmH4=;
 b=EG+NSlUFeler3wrqhwiDx6FwaFVQsiDTHJqbYT3zzHn+MQ4I75kx0eoZuHUszZ2Phgmn
 +MOeaqyKkLaEhYL05IzTtWQmlAcGJyluxhktB91MDixMclxBor9GiJaSmvZAg0XSr/N8
 q56OGF7EXuXQ1OCSj+eG5jbfN1aen+NxzpMd3P3QEAMS1wH/6Nghnak14TQNXv/XkPUc
 2NTa3vBt0hnwprX3NVF0p/iGqkutv/6GDr9xonKszRV3L6iZWXkS+zcrZOzlPTwMEhDg
 iNs4eOS4YDiaNJ0p2bo5xnXrlWyKMkFWx1nQ06wKPdY5CIIxHdL4hB169OJ/YrQ0hO7q 5A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 349jrq1eua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2020 06:34:45 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09N6Q2lq123324
        for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2020 06:34:44 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 34ak1ar063-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2020 06:34:44 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09N6Yhpm027992
        for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2020 06:34:43 GMT
Received: from localhost.localdomain (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 22 Oct 2020 23:34:43 -0700
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v13 09/10] xfs: Remove unused xfs_attr_*_args
Date:   Thu, 22 Oct 2020 23:34:34 -0700
Message-Id: <20201023063435.7510-10-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201023063435.7510-1-allison.henderson@oracle.com>
References: <20201023063435.7510-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9782 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxscore=0 phishscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010230045
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9782 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=1 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010230045
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Remove xfs_attr_set_args, xfs_attr_remove_args, and xfs_attr_trans_roll.
These high level loops are now driven by the delayed operations code,
and can be removed.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c        | 97 +----------------------------------------
 fs/xfs/libxfs/xfs_attr.h        |  9 ++--
 fs/xfs/libxfs/xfs_attr_remote.c |  4 +-
 3 files changed, 5 insertions(+), 105 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index edd5d10..b5e1e84 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -262,65 +262,6 @@ xfs_attr_set_shortform(
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
@@ -363,11 +304,7 @@ xfs_attr_set_iter(
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
@@ -398,7 +335,6 @@ xfs_attr_set_iter(
 			 * same state (inode locked and joined, transaction
 			 * clean) no matter how we got to this step.
 			 */
-			dac->flags |= XFS_DAC_DEFER_FINISH;
 			return -EAGAIN;
 		case 0:
 			dac->dela_state = XFS_DAS_FOUND_LBLK;
@@ -455,32 +391,6 @@ xfs_has_attr(
 
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
@@ -895,7 +805,6 @@ xfs_attr_leaf_addname(
 		if (error)
 			return error;
 
-		dac->flags |= XFS_DAC_DEFER_FINISH;
 		return -EAGAIN;
 	}
 
@@ -1192,7 +1101,6 @@ xfs_attr_node_addname(
 			 * Restart routine from the top.  No need to set  the
 			 * state
 			 */
-			dac->flags |= XFS_DAC_DEFER_FINISH;
 			return -EAGAIN;
 		}
 
@@ -1205,7 +1113,6 @@ xfs_attr_node_addname(
 		error = xfs_da3_split(state);
 		if (error)
 			goto out;
-		dac->flags |= XFS_DAC_DEFER_FINISH;
 	} else {
 		/*
 		 * Addition succeeded, update Btree hashvals.
@@ -1246,7 +1153,6 @@ xfs_attr_node_addname(
 			if (error)
 				return error;
 
-			dac->flags |= XFS_DAC_DEFER_FINISH;
 			dac->dela_state = XFS_DAS_ALLOC_NODE;
 			return -EAGAIN;
 		}
@@ -1516,7 +1422,6 @@ xfs_attr_node_remove_step(
 		if (error)
 			return error;
 
-		dac->flags |= XFS_DAC_DEFER_FINISH;
 		dac->dela_state = XFS_DAS_RM_SHRINK;
 		return -EAGAIN;
 	}
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 8a08411..6d90301 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -244,10 +244,9 @@ enum xfs_delattr_state {
 /*
  * Defines for xfs_delattr_context.flags
  */
-#define XFS_DAC_DEFER_FINISH		0x01 /* finish the transaction */
-#define XFS_DAC_NODE_RMVNAME_INIT	0x02 /* xfs_attr_node_removename init */
-#define XFS_DAC_LEAF_ADDNAME_INIT	0x04 /* xfs_attr_leaf_addname init*/
-#define XFS_DAC_DELAYED_OP_INIT		0x08 /* delayed operations init*/
+#define XFS_DAC_NODE_RMVNAME_INIT	0x01 /* xfs_attr_node_removename init */
+#define XFS_DAC_LEAF_ADDNAME_INIT	0x02 /* xfs_attr_leaf_addname init*/
+#define XFS_DAC_DELAYED_OP_INIT		0x04 /* delayed operations init*/
 
 /*
  * Context used for keeping track of delayed attribute operations
@@ -297,11 +296,9 @@ int xfs_inode_hasattr(struct xfs_inode *ip);
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
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 45c4bc5..262d1870 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -751,10 +751,8 @@ xfs_attr_rmtval_remove(
 	if (error)
 		return error;
 
-	if (!done) {
-		dac->flags |= XFS_DAC_DEFER_FINISH;
+	if (!done)
 		return -EAGAIN;
-	}
 
 	return error;
 }
-- 
2.7.4

