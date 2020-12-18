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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDF87C2D0E4
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Dec 2020 07:30:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83A4323A5B
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Dec 2020 07:30:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732914AbgLRHaH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Dec 2020 02:30:07 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:58092 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732869AbgLRHaG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Dec 2020 02:30:06 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BI7Jwj4122123
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:29:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=e+r9h8knHnfvdIq7lmKnDFVa+fdta30gvTP5Kxhrr/Y=;
 b=RO4d9iPfhSPKOg35kHOzMpHZ9FvjWtaHu4/eDnyWmeLNh/pbZwxS1r20uNv2gGw6gSpy
 izWbAJ5jMmvsJRuM56eMkyTiubxvsJ2Yrb2r4phBM5Iwa1NuN72E+wOq0yoUlOGQOpaW
 FutBFKza7EdhDRmZYnCSeB9fyCZ64TfP/cHGSI/wWqEogeyf1XAwUicq1dSD1JlKI1bO
 NZmYH8bWFp3DnD57deScTz3qtT/bDBh8/KFBfasV5OY7RqMPZvywU5WtDiM8nW1NpvVO
 8K7uGA8nmnEJZfdMF4NN4jky6c7li8JcFMQHjmtFmIxIGTX9xEniqO9w5HSc1xVgq9ic tw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 35cntmgyag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:29:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BI7KIPk038228
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:29:24 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 35d7t1hc35-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:29:24 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BI7TOQp020729
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:29:24 GMT
Received: from localhost.localdomain (/67.1.214.41)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Dec 2020 23:29:23 -0800
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v14 06/15] xfs: Add state machine tracepoints
Date:   Fri, 18 Dec 2020 00:29:08 -0700
Message-Id: <20201218072917.16805-7-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201218072917.16805-1-allison.henderson@oracle.com>
References: <20201218072917.16805-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9838 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012180052
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9838 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 priorityscore=1501 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012180052
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is a quick patch to add a new tracepoint: xfs_das_state_return.  We
use this to track when ever a new state is set or -EAGAIN is returned

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c        | 22 +++++++++++++++++++++-
 fs/xfs/libxfs/xfs_attr_remote.c |  1 +
 fs/xfs/xfs_trace.h              | 20 ++++++++++++++++++++
 3 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index cd72512..8ed00bc 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
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
@@ -891,6 +896,8 @@ xfs_attr_leaf_addname(
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
 
@@ -1202,6 +1211,7 @@ xfs_attr_node_addname(
 				return error;
 
 			dac->flags |= XFS_DAC_DEFER_FINISH;
+			trace_xfs_das_state_return(dac->dela_state);
 			return -EAGAIN;
 		}
 
@@ -1236,6 +1246,7 @@ xfs_attr_node_addname(
 	 * Commit the flag value change and start the next trans in series
 	 */
 	dac->dela_state = XFS_DAS_FLIP_NFLAG;
+	trace_xfs_das_state_return(dac->dela_state);
 	return -EAGAIN;
 das_flip_flag:
 	/*
@@ -1253,6 +1264,10 @@ xfs_attr_node_addname(
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
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 6af86bf..4840de9 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -763,6 +763,7 @@ __xfs_attr_rmtval_remove(
 	 */
 	if (!done) {
 		dac->flags |= XFS_DAC_DEFER_FINISH;
+		trace_xfs_das_state_return(dac->dela_state);
 		return -EAGAIN;
 	}
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 9074b8b..4f6939b4 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3887,6 +3887,26 @@ DEFINE_EVENT(xfs_timestamp_range_class, name, \
 DEFINE_TIMESTAMP_RANGE_EVENT(xfs_inode_timestamp_range);
 DEFINE_TIMESTAMP_RANGE_EVENT(xfs_quota_expiry_range);
 
+
+DECLARE_EVENT_CLASS(xfs_das_state_class,
+	TP_PROTO(int das),
+	TP_ARGS(das),
+	TP_STRUCT__entry(
+		__field(int, das)
+	),
+	TP_fast_assign(
+		__entry->das = das;
+	),
+	TP_printk("state change %d",
+		  __entry->das)
+)
+
+#define DEFINE_DAS_STATE_EVENT(name) \
+DEFINE_EVENT(xfs_das_state_class, name, \
+	TP_PROTO(int das), \
+	TP_ARGS(das))
+DEFINE_DAS_STATE_EVENT(xfs_das_state_return);
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH
-- 
2.7.4

