Return-Path: <SRS0=cWrc=DB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A850C4346E
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 06:05:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A6DD23600
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 06:05:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="D7TlhXQm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbgIXGFZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Sep 2020 02:05:25 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:47534 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726683AbgIXGFZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Sep 2020 02:05:25 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08O63ao7115695;
        Thu, 24 Sep 2020 06:05:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Rye91Nd++pNDSt8+T+oFHCM4+C9xUIss8hERahH6yAo=;
 b=D7TlhXQmPPwkjA9dL7AEgczLtGTjfar8VCP4EENji+y+quRedW8pLOiD7BkQjOn4gEzX
 iJR0TTTc0zXaJrR9dFAloLC/IGKz4f7TTd9OLWGXmICCitLR7/jXezuR7GsGWh/tF9PG
 J1IZwXb6QkKdxJJGjW/1UIX5/aCPL6nIIlM+VgWIKOFLASpkdiHZwAKX7uKt7Phfnkn+
 gYVcgPWH2/CthbgCPIEap38ddASmllTAowgwQpLfL13hmWrmpIty6u84PniQjGn4duJR
 fnvwOE/nu1AdzSfO/VhWwi/l+IzDQBUCXL/Os2/smMQZmfWW9TlafqfkEsTs9M+4RD7e 5g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 33qcpu32r9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 24 Sep 2020 06:05:20 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08O5uQnZ064229;
        Thu, 24 Sep 2020 06:03:19 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 33nujqfgn8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Sep 2020 06:03:19 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08O63JnZ018485;
        Thu, 24 Sep 2020 06:03:19 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 23 Sep 2020 23:03:19 -0700
Date:   Wed, 23 Sep 2020 23:03:19 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v2 3/3] xfs: xfs_defer_capture should absorb remaining
 transaction reservation
Message-ID: <20200924060319.GB7955@magnolia>
References: <160031334050.3624461.17900718410309670962.stgit@magnolia>
 <160031335967.3624461.12775342036527430147.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160031335967.3624461.12775342036527430147.stgit@magnolia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 adultscore=0 spamscore=0 suspectscore=1
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009240048
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxlogscore=999
 adultscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0 priorityscore=1501
 phishscore=0 spamscore=0 malwarescore=0 clxscore=1015 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009240049
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
v2: rebased on v2 of patch 1
---
 fs/xfs/libxfs/xfs_defer.c |    3 +++
 fs/xfs/libxfs/xfs_defer.h |    1 +
 fs/xfs/xfs_log_recover.c  |    4 ++--
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 8bd01952c955..b693d2c42c27 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -595,6 +595,9 @@ xfs_defer_capture(
 	dfc->dfc_tpflags = tp->t_flags & XFS_TRANS_LOWMODE;
 	dfc->dfc_blkres = tp->t_blk_res - tp->t_blk_res_used;
 	tp->t_blk_res = tp->t_blk_res_used;
+	dfc->dfc_tres.tr_logres = tp->t_log_res;
+	dfc->dfc_tres.tr_logcount = tp->t_log_count;
+	dfc->dfc_tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
 	xfs_defer_reset(tp);
 
 	/*
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 59d126aeb31c..254d48e6e4dc 100644
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
index 777b60073ff7..ab9825ab14d5 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2504,8 +2504,8 @@ xlog_finish_defer_ops(
 	int			error = 0;
 
 	list_for_each_entry_safe(dfc, next, capture_list, dfc_list) {
-		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0,
-				0, XFS_TRANS_RESERVE, &tp);
+		error = xfs_trans_alloc(mp, &dfc->dfc_tres, 0, 0,
+				XFS_TRANS_RESERVE, &tp);
 		if (error)
 			return error;
 
