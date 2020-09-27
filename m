Return-Path: <SRS0=IMq7=DE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DCBCC4346E
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Sep 2020 23:41:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 484EA23A33
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Sep 2020 23:41:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZumSV6LR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbgI0Xlk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 27 Sep 2020 19:41:40 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:46288 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbgI0Xlk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Sep 2020 19:41:40 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08RNe9fr081249;
        Sun, 27 Sep 2020 23:41:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=pb0DGE6qxnni5pvB18FOgmt0H34mUcQm2qrqFUd7tFI=;
 b=ZumSV6LRW0OYW/yoaa4bHAHefciT2OyviwEDuE8qD+d16UAKbxv8s6p+SlOa0pcRcEJ2
 7U3SMFQ6FXBGuBEV48rGIDjCdHddBGPXlvM7c+a+2nwf1FOEEJFVUB7iKPVYGGdjggh2
 o237ImNO6p6GPjlWyoK7GMhjl9CLHwYwo07StxoYD84qPfDmBzQm0k4BX3LmEVKj/SEz
 yeeIObyetQnZHbfTN8lByQ5fcEE3+gBsHZ0m/q1poJo1JexC+n4unak9H2TSDCBetp1O
 ipFqR9znOBDRs6EsF9bnaH0yvEVSmZwz0QlgmlPjawK0m6rIDMOkQnGQKoKQp4rAZrnz iQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 33su5ajme9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 27 Sep 2020 23:41:35 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08RNejdT186931;
        Sun, 27 Sep 2020 23:41:35 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 33tf7jnp8b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 27 Sep 2020 23:41:35 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08RNfY8Q009926;
        Sun, 27 Sep 2020 23:41:34 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 27 Sep 2020 16:41:34 -0700
Subject: [PATCH 4/4] xfs: xfs_defer_capture should absorb remaining
 transaction reservation
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@lst.de,
        bfoster@redhat.com
Date:   Sun, 27 Sep 2020 16:41:33 -0700
Message-ID: <160125009361.174438.2579393022515355249.stgit@magnolia>
In-Reply-To: <160125006793.174438.10683462598722457550.stgit@magnolia>
References: <160125006793.174438.10683462598722457550.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9757 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=1 adultscore=0 malwarescore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009270227
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9757 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=1
 lowpriorityscore=0 spamscore=0 clxscore=1015 mlxscore=0 impostorscore=0
 malwarescore=0 phishscore=0 adultscore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009270227
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
 fs/xfs/libxfs/xfs_defer.c |    5 +++++
 fs/xfs/libxfs/xfs_defer.h |    1 +
 fs/xfs/xfs_log_recover.c  |    4 ++--
 3 files changed, 8 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 85d70f1edc1c..c53443252389 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -577,6 +577,11 @@ xfs_defer_capture(
 	dfc->dfc_blkres = tp->t_blk_res - tp->t_blk_res_used;
 	tp->t_blk_res = tp->t_blk_res_used;
 
+	/* Preserve the transaction reservation type. */
+	dfc->dfc_tres.tr_logres = tp->t_log_res;
+	dfc->dfc_tres.tr_logcount = tp->t_log_count;
+	dfc->dfc_tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
+
 	return dfc;
 }
 
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 999adbb8c449..063276c063b6 100644
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
index 60670ac4e5ae..0d899ab7df2e 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2487,8 +2487,8 @@ xlog_finish_defer_ops(
 	int			error = 0;
 
 	list_for_each_entry_safe(dfc, next, capture_list, dfc_list) {
-		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0,
-				0, XFS_TRANS_RESERVE, &tp);
+		error = xfs_trans_alloc(mp, &dfc->dfc_tres, 0, 0,
+				XFS_TRANS_RESERVE, &tp);
 		if (error)
 			return error;
 

