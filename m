Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A9FFC433FE
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 01:15:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43E53224B8
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 01:15:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728139AbgLDBPW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 20:15:22 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:48414 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbgLDBPW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 20:15:22 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B419hEF014509;
        Fri, 4 Dec 2020 01:12:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=88m3F0gr7DRiV55VrYVBa6uCGFdOsZkM0pHI5IXQpZM=;
 b=m+l67sVuKtW6e6dzJFBcdfzi7xz7vqZfdJfW78ecat3HBLGlZs9zObIqTDKlcwoalEMs
 eAjq7B1tU2gjj3z0mmWC8S8rUkrZkU62aF/A3qWrl2W3coDHHltR3sYhqVTluIJh7wlb
 t/Rd+mLfrk26kDYGVzCunQa5uFpEXuIAprx+d0cGa1RWx3qhPPodOr/vUX8yUbqSBD5Q
 rKiGlJsZ+aLUKjNrL/UcGIf4k+ongZfe8ETzZAQKJnNs21uxP894Rd2rcfBlVAnP0arC
 lI2e6Ry/5uWYEMwaa22rRs3cnwgN6eUutjik1buhoc7dv+zT1ymW9O2iAmQglFv/GA1D rA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 353egm0yma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 04 Dec 2020 01:12:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B41BSfC157253;
        Fri, 4 Dec 2020 01:12:38 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 3540g2sw7v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Dec 2020 01:12:38 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B41Cbln002562;
        Fri, 4 Dec 2020 01:12:37 GMT
Received: from localhost (/10.159.242.140)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Dec 2020 17:12:37 -0800
Subject: [PATCH 10/10] xfs: trace log intent item recovery failures
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Thu, 03 Dec 2020 17:12:37 -0800
Message-ID: <160704435695.734470.320027217185016602.stgit@magnolia>
In-Reply-To: <160704429410.734470.15640089119078502938.stgit@magnolia>
References: <160704429410.734470.15640089119078502938.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=1
 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012040003
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=1
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012040003
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
 fs/xfs/xfs_trace.h       |   19 +++++++++++++++++++
 2 files changed, 23 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 87886b7f77da..ed92c72976c9 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2559,8 +2559,11 @@ xlog_recover_process_intents(
 		spin_unlock(&ailp->ail_lock);
 		error = lip->li_ops->iop_recover(lip, &capture_list);
 		spin_lock(&ailp->ail_lock);
-		if (error)
+		if (error) {
+			trace_xfs_error_return(log->l_mp, error,
+					lip->li_ops->iop_recover);
 			break;
+		}
 	}
 
 	xfs_trans_ail_cursor_done(&cur);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 86951652d3ed..99383b1acd49 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -103,6 +103,25 @@ DEFINE_ATTR_LIST_EVENT(xfs_attr_list_notfound);
 DEFINE_ATTR_LIST_EVENT(xfs_attr_leaf_list);
 DEFINE_ATTR_LIST_EVENT(xfs_attr_node_list);
 
+TRACE_EVENT(xfs_error_return,
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
+	TP_printk("dev %d:%d error %d caller %pS",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->error, __entry->caller_ip)
+
+);
+
 DECLARE_EVENT_CLASS(xfs_perag_class,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, int refcount,
 		 unsigned long caller_ip),

