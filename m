Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4780C2D0E4
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Dec 2020 07:27:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD78623A82
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Dec 2020 07:27:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732951AbgLRH0t (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Dec 2020 02:26:49 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:55174 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732952AbgLRH0t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Dec 2020 02:26:49 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BI7JopY122066
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:26:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=ztI7XuW2az80ka0SGlEfXi+CpHnTOzZMJLYomZDvy5M=;
 b=gPgvYXdmfqohDEdmvATN9TZFr3mKhPTSxntTQcd27CdpsdxAdBJXe6gj9WZht4XB9KnE
 VwvvGeTCM3nxoVm/BBCM6abcXvSAEAxEzlGhCA8SRmBVIgPjq9CzfU/4S9DaXS40Jkjh
 WqKG++LxsQb7mCSL6PxvEuryPnuEHjS6otxJan14uUF+UkNMVF4/russE3SvUA32wtjS
 G7qj6QnG0pjZU5GvZUCyGEzfc8TfTfu9ilHLGxhbEbl+MoNHVojTnmoXvC228QnDw393
 eVkvV7PaE9IMs0RVOoF2iEQIDdGtslKNbMn7kEAzcAZLRABiahpNaXWdyUJyor6/9Kmg LQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 35cntmgy2v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:26:08 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BI7LKCw044414
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:26:07 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 35d7erys6c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:26:07 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BI7Q7Om002046
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:26:07 GMT
Received: from localhost.localdomain (/67.1.214.41)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Dec 2020 23:26:07 -0800
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v14 06/14] xfsprogs: Add state machine tracepoints
Date:   Fri, 18 Dec 2020 00:25:47 -0700
Message-Id: <20201218072555.16694-7-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201218072555.16694-1-allison.henderson@oracle.com>
References: <20201218072555.16694-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9838 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012180052
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9838 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 priorityscore=1501 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012180052
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: 5421d11d87aa32479cb41c18e2487db3b3a75cde

This is a quick patch to add a new tracepoint: xfs_das_state_return.  We
use this to track when ever a new state is set or -EAGAIN is returned

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 include/xfs_trace.h      |  1 +
 libxfs/xfs_attr.c        | 22 +++++++++++++++++++++-
 libxfs/xfs_attr_remote.c |  1 +
 3 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index a100263..5ca5d03 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -314,4 +314,5 @@
 #define trace_xfs_perag_get_tag(a,b,c,d)	((c) = (c))
 #define trace_xfs_perag_put(a,b,c,d)		((c) = (c))
 
+#define trace_xfs_das_state_return(a)		((void) 0)
 #endif /* __TRACE_H__ */
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 83400fc..e15344d 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -263,6 +263,7 @@ xfs_attr_set_shortform(
 	 * We're still in XFS_DAS_UNINIT state here.  We've converted the attr
 	 * fork to leaf format and will restart with the leaf add.
 	 */
+	trace_xfs_das_state_return(XFS_DAS_UNINIT);
 	return -EAGAIN;
 }
 
@@ -409,9 +410,11 @@ xfs_attr_set_iter(
 		 * down into the node handling code below
 		 */
 		dac->flags |= XFS_DAC_DEFER_FINISH;
+		trace_xfs_das_state_return(dac->dela_state);
 		return -EAGAIN;
 	case 0:
 		dac->dela_state = XFS_DAS_FOUND_LBLK;
+		trace_xfs_das_state_return(dac->dela_state);
 		return -EAGAIN;
 	}
 	return error;
@@ -841,6 +844,7 @@ xfs_attr_leaf_addname(
 			return error;
 
 		dac->flags |= XFS_DAC_DEFER_FINISH;
+		trace_xfs_das_state_return(dac->dela_state);
 		return -EAGAIN;
 	}
 
@@ -874,6 +878,7 @@ xfs_attr_leaf_addname(
 	 * Commit the flag value change and start the next trans in series.
 	 */
 	dac->dela_state = XFS_DAS_FLIP_LFLAG;
+	trace_xfs_das_state_return(dac->dela_state);
 	return -EAGAIN;
 das_flip_flag:
 	/*
@@ -891,6 +896,8 @@ das_flip_flag:
 das_rm_lblk:
 	if (args->rmtblkno) {
 		error = __xfs_attr_rmtval_remove(dac);
+		if (error == -EAGAIN)
+			trace_xfs_das_state_return(dac->dela_state);
 		if (error)
 			return error;
 	}
@@ -1142,6 +1149,7 @@ xfs_attr_node_addname(
 			 * this point.
 			 */
 			dac->flags |= XFS_DAC_DEFER_FINISH;
+			trace_xfs_das_state_return(dac->dela_state);
 			return -EAGAIN;
 		}
 
@@ -1175,6 +1183,7 @@ xfs_attr_node_addname(
 	state = NULL;
 
 	dac->dela_state = XFS_DAS_FOUND_NBLK;
+	trace_xfs_das_state_return(dac->dela_state);
 	return -EAGAIN;
 das_found_nblk:
 
@@ -1202,6 +1211,7 @@ das_alloc_node:
 				return error;
 
 			dac->flags |= XFS_DAC_DEFER_FINISH;
+			trace_xfs_das_state_return(dac->dela_state);
 			return -EAGAIN;
 		}
 
@@ -1236,6 +1246,7 @@ das_alloc_node:
 	 * Commit the flag value change and start the next trans in series
 	 */
 	dac->dela_state = XFS_DAS_FLIP_NFLAG;
+	trace_xfs_das_state_return(dac->dela_state);
 	return -EAGAIN;
 das_flip_flag:
 	/*
@@ -1253,6 +1264,10 @@ das_flip_flag:
 das_rm_nblk:
 	if (args->rmtblkno) {
 		error = __xfs_attr_rmtval_remove(dac);
+
+		if (error == -EAGAIN)
+			trace_xfs_das_state_return(dac->dela_state);
+
 		if (error)
 			return error;
 	}
@@ -1396,6 +1411,8 @@ xfs_attr_node_remove_rmt (
 	 * May return -EAGAIN to request that the caller recall this function
 	 */
 	error = __xfs_attr_rmtval_remove(dac);
+	if (error == -EAGAIN)
+		trace_xfs_das_state_return(dac->dela_state);
 	if (error)
 		return error;
 
@@ -1514,6 +1531,7 @@ xfs_attr_node_removename_iter(
 
 			dac->flags |= XFS_DAC_DEFER_FINISH;
 			dac->dela_state = XFS_DAS_RM_SHRINK;
+			trace_xfs_das_state_return(dac->dela_state);
 			return -EAGAIN;
 		}
 
@@ -1532,8 +1550,10 @@ xfs_attr_node_removename_iter(
 		goto out;
 	}
 
-	if (error == -EAGAIN)
+	if (error == -EAGAIN) {
+		trace_xfs_das_state_return(dac->dela_state);
 		return error;
+	}
 out:
 	if (state)
 		xfs_da_state_free(state);
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index 628ab42..543dd67 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -762,6 +762,7 @@ __xfs_attr_rmtval_remove(
 	 */
 	if (!done) {
 		dac->flags |= XFS_DAC_DEFER_FINISH;
+		trace_xfs_das_state_return(dac->dela_state);
 		return -EAGAIN;
 	}
 
-- 
2.7.4

