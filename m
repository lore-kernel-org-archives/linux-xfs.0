Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47A9BC4361B
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Dec 2020 23:11:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B2B923120
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Dec 2020 23:11:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbgLFXLf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 6 Dec 2020 18:11:35 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:57030 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728209AbgLFXLf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Dec 2020 18:11:35 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B6N66dQ020862;
        Sun, 6 Dec 2020 23:10:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=4IhH1Ucoq/Cx3lanYx9oYb3hSbLg6W0uo8eaLtBPiCA=;
 b=TdoY6/mpozSIEhqVO3zKRX4AAkN2byQI6ieDW5/8RjcYCOVAc9xQwZbjrArutU2L8Bmo
 noG7ln6RAgt5xMPh9uYfq4dYedjOCdvDyfwciH8nM5AiebijXVRlpRmZImuBrL6ji8LW
 vnnoIfsR/vWgQh6gLyEekTsqXAGf6Q6NaqFAKWyU+TNUNcOEGbvXM1mxCxiIK5uErCPc
 nSoPFTTvHT6TNWcnDZy9rEHEwHfeBbQwPpZOihjGXd38koJDIK1tIC/ZY/l0pPL5gIQ8
 dJr+1S4HBUALAliXDt+rxAT9TtHgXoGXZ2qPLTtICsP6/CopQJgHXhO5lBPN2nVkny5F 3w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 357yqbk0wb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 06 Dec 2020 23:10:50 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B6NAenW177314;
        Sun, 6 Dec 2020 23:10:49 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 358kskgb4b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 06 Dec 2020 23:10:49 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B6NAnk0031543;
        Sun, 6 Dec 2020 23:10:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 06 Dec 2020 15:10:49 -0800
Subject: [PATCH 10/10] xfs: trace log intent item recovery failures
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        bfoster@redhat.com
Date:   Sun, 06 Dec 2020 15:10:48 -0800
Message-ID: <160729624812.1607103.14927905190925127101.stgit@magnolia>
In-Reply-To: <160729618252.1607103.863261260798043728.stgit@magnolia>
References: <160729618252.1607103.863261260798043728.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9827 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=1
 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012060152
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9827 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxlogscore=999
 clxscore=1015 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012060151
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a trace point so that we can capture when a recovered log intent
item fails to recover.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log_recover.c |    5 ++++-
 fs/xfs/xfs_trace.h       |   18 ++++++++++++++++++
 2 files changed, 22 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 87886b7f77da..1152c4b3ba96 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2559,8 +2559,11 @@ xlog_recover_process_intents(
 		spin_unlock(&ailp->ail_lock);
 		error = lip->li_ops->iop_recover(lip, &capture_list);
 		spin_lock(&ailp->ail_lock);
-		if (error)
+		if (error) {
+			trace_xlog_intent_recovery_failed(log->l_mp, error,
+					lip->li_ops->iop_recover);
 			break;
+		}
 	}
 
 	xfs_trans_ail_cursor_done(&cur);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 86951652d3ed..8fdb51eac1af 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -103,6 +103,24 @@ DEFINE_ATTR_LIST_EVENT(xfs_attr_list_notfound);
 DEFINE_ATTR_LIST_EVENT(xfs_attr_leaf_list);
 DEFINE_ATTR_LIST_EVENT(xfs_attr_node_list);
 
+TRACE_EVENT(xlog_intent_recovery_failed,
+	TP_PROTO(struct xfs_mount *mp, int error, void *caller_ip),
+	TP_ARGS(mp, error, caller_ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(int, error)
+		__field(void *, caller_ip)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->error = error;
+		__entry->caller_ip = caller_ip;
+	),
+	TP_printk("dev %d:%d error %d function %pS",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->error, __entry->caller_ip)
+);
+
 DECLARE_EVENT_CLASS(xfs_perag_class,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, int refcount,
 		 unsigned long caller_ip),

