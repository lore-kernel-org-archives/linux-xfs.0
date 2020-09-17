Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A582C43461
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 03:29:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1BAA208E4
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 03:29:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Fq2b9coN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbgIQD3g (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Sep 2020 23:29:36 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49570 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbgIQD3Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Sep 2020 23:29:25 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08H3OWOW162455;
        Thu, 17 Sep 2020 03:29:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=CY+LSFbwC7IWo8AEbJtus6cgvcOdkYy7H9U8ZzoPd54=;
 b=Fq2b9coNLQEn/nbqXMIu43s8HAM3QQOpM3sIK3DM3q+m8JikS0nMvad9GuV/e5xE9q9s
 4gMC2RYNj6CSHJfJEGxnWNr5SLPTSkWxp9JT96pE5hvHmP92M+GQ1Ll/hgtUil3OI1u8
 jyLlx8WmfxKBKDVBi303F2UmeXnAgCZxBuGG9yNT1kkpZzm3ivEpT4El7XoLNzQoE9uS
 xSQVAB+e3p4S8OFuvC7mpK9rrTdLeiBERhmuoMv9XZlfv/wSu+Tg0yxyd/Su0jevQVaD
 WFNoY+SVcNhgNl0QNKX2f55/eeilWlXIkDMv/vadYBkE7R7EJcCUOd4UFa783B8o+drW gA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 33gnrr6j8b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Sep 2020 03:29:23 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08H3OmXt041526;
        Thu, 17 Sep 2020 03:29:22 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 33h892y5rj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Sep 2020 03:29:22 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08H3TLxG007015;
        Thu, 17 Sep 2020 03:29:21 GMT
Received: from localhost (/10.159.158.133)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Sep 2020 03:29:20 +0000
Subject: [PATCH 3/3] xfs: xfs_defer_capture should absorb remaining
 transaction reservation
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Wed, 16 Sep 2020 20:29:19 -0700
Message-ID: <160031335967.3624461.12775342036527430147.stgit@magnolia>
In-Reply-To: <160031334050.3624461.17900718410309670962.stgit@magnolia>
References: <160031334050.3624461.17900718410309670962.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=1 mlxscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009170023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 mlxscore=0 bulkscore=0 suspectscore=1
 clxscore=1015 mlxlogscore=999 adultscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009170023
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When xfs_defer_capture extracts the deferred ops and transaction state
from a transaction, it should record the transaction reservation type
from the old transaction so that when we continue the dfops chain, we
still use the same reservation parameters.

This avoids a potential failure vector by ensuring that we never ask for
more log reservation space than we would have asked for had the system
not gone down.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.c |    3 +++
 fs/xfs/libxfs/xfs_defer.h |    1 +
 fs/xfs/xfs_log_recover.c  |    4 ++--
 3 files changed, 6 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index d1db97ccad51..edfb3b9856c8 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -590,6 +590,9 @@ xfs_defer_capture(
 		dfc->dfc_tpflags = tp->t_flags & XFS_TRANS_LOWMODE;
 		dfc->dfc_blkres = tp->t_blk_res - tp->t_blk_res_used;
 		tp->t_blk_res = tp->t_blk_res_used;
+		dfc->dfc_tres.tr_logres = tp->t_log_res;
+		dfc->dfc_tres.tr_logcount = tp->t_log_count;
+		dfc->dfc_tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
 		xfs_defer_reset(tp);
 	}
 
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index fea610f5d3e1..a788855aef69 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -77,6 +77,7 @@ struct xfs_defer_capture {
 	struct list_head	dfc_dfops;
 	unsigned int		dfc_tpflags;
 	unsigned int		dfc_blkres;
+	struct xfs_trans_res	dfc_tres;
 };
 
 /*
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 5f664e52c542..f5748c8f5157 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2503,8 +2503,8 @@ xlog_finish_defer_ops(
 	int			error = 0;
 
 	list_for_each_entry_safe(dfc, next, dfops_freezers, dfc_list) {
-		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0,
-				0, XFS_TRANS_RESERVE, &tp);
+		error = xfs_trans_alloc(mp, &dfc->dfc_tres, 0, 0,
+				XFS_TRANS_RESERVE, &tp);
 		if (error)
 			break;
 

