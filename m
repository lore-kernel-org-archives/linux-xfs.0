Return-Path: <SRS0=eQWr=DM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7AC5C4363A
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Oct 2020 18:23:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F2C720853
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Oct 2020 18:23:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sxiXxRX4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727206AbgJESX2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Oct 2020 14:23:28 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40656 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725960AbgJESX1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Oct 2020 14:23:27 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 095IA7td190443;
        Mon, 5 Oct 2020 18:23:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=8xDOqyJiHduX5JZOgsgQNL57A/kC9Qu5ySv3xSyJB7Q=;
 b=sxiXxRX4pjYphWe1F+KOxd0fK7yO3K8uYB77pHkjIQZFSchid8SrHhQz6lohAqlObPLX
 xT+E35oAVmOORMlU4p3gYIVeEF1lqwu4AFtJrF+gcYKgVhUQlummmGeTIGNxwgpU/Yo+
 hdZFIh/MFk2VKLi7XG0Y8xShEejQXVg+T4R2QhelFU0Ye6AoUaeZ9KiZY6MlfeSETM0W
 kOSA+Ju6+Io6k1knBZJ/JTHx7KqtlkP+sAw7WqQ1aVdqN2UwUIFAiLY0kWiYJcnoKLhX
 lpi4FoLKE/iXdN3J6g+qonRiRzdNkj90eZA4SyZACmScokdzVXsV7ju5E+MCZlLp+4wS JA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 33ym34c4v5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 05 Oct 2020 18:23:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 095IAkjU014535;
        Mon, 5 Oct 2020 18:21:22 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 33y36wtk5u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Oct 2020 18:21:22 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 095ILL9c016182;
        Mon, 5 Oct 2020 18:21:21 GMT
Received: from localhost (/10.159.154.228)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 05 Oct 2020 11:21:21 -0700
Subject: [PATCH 4/4] xfs: only relog deferred intent items if free space in
 the log gets low
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        david@fromorbit.com, bfoster@redhat.com, hch@lst.de
Date:   Mon, 05 Oct 2020 11:21:20 -0700
Message-ID: <160192208016.2569788.15118056315778513007.stgit@magnolia>
In-Reply-To: <160192205402.2569788.11403566753219528155.stgit@magnolia>
References: <160192205402.2569788.11403566753219528155.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 spamscore=0 malwarescore=0 suspectscore=3 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010050134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=3 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010050134
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Now that we have the ability to ask the log how far the tail needs to be
pushed to maintain its free space targets, augment the decision to relog
an intent item so that we only do it if the log has hit the 75% full
threshold.  There's no point in relogging an intent into the same
checkpoint, and there's no need to relog if there's plenty of free space
in the log.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_defer.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index fbe64933bcc9..eff4a127188e 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -356,7 +356,10 @@ xfs_defer_relog(
 	struct xfs_trans		**tpp,
 	struct list_head		*dfops)
 {
+	struct xlog			*log = (*tpp)->t_mountp->m_log;
 	struct xfs_defer_pending	*dfp;
+	xfs_lsn_t			threshold_lsn = NULLCOMMITLSN;
+
 
 	ASSERT((*tpp)->t_flags & XFS_TRANS_PERM_LOG_RES);
 
@@ -372,6 +375,19 @@ xfs_defer_relog(
 		    xfs_log_item_in_current_chkpt(dfp->dfp_intent))
 			continue;
 
+		/*
+		 * Figure out where we need the tail to be in order to maintain
+		 * the minimum required free space in the log.  Only sample
+		 * the log threshold once per call.
+		 */
+		if (threshold_lsn == NULLCOMMITLSN) {
+			threshold_lsn = xlog_grant_push_threshold(log, 0);
+			if (threshold_lsn == NULLCOMMITLSN)
+				break;
+		}
+		if (XFS_LSN_CMP(dfp->dfp_intent->li_lsn, threshold_lsn) >= 0)
+			continue;
+
 		trace_xfs_defer_relog_intent((*tpp)->t_mountp, dfp);
 		XFS_STATS_INC((*tpp)->t_mountp, defer_relog);
 		dfp->dfp_intent = xfs_trans_item_relog(dfp->dfp_intent, *tpp);

