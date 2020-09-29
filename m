Return-Path: <SRS0=kcSc=DG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEB35C4727C
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Sep 2020 17:45:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74171208B8
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Sep 2020 17:45:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="G1FehZvJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725776AbgI2RpY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Sep 2020 13:45:24 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41146 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728525AbgI2RpX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Sep 2020 13:45:23 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08THdXOW026447;
        Tue, 29 Sep 2020 17:45:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : references : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ckKzoEIBcuKukMDBFmIM0IyVQPuTkoxL6cM4LafmELM=;
 b=G1FehZvJvRY8M7V2GUc0z7x0k5omMVWnPgbNtRKFjj46wz+v1IpbtNvoqLVTfSfOuQiD
 tEkOrE1uZS6OSpdm99R5i3VAe/g0DYl34wcv6cwnpJ2nIyA8pDUgr86nUvzLBl60T+9b
 sl7+VPtIsvUJ349SzPWbV6b783HLXKYNgmWzuPeFZ37M/YKVUyBGk4w9ns2n4o0n3rgM
 IqfWGIgmTMULZxGwdy8no2YSSjS5PjnDOyWo7gDBRanCpKjriGhfb0QC2VX30ph+IN0x
 fNKayG5dRuP5t+fz8j35DTpSWxdLhQh5XWQz8mFUIicl1FDlBaoqi2lMIGMdz/X6SynV zg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 33swkkvadj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 29 Sep 2020 17:45:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08THeRKX167345;
        Tue, 29 Sep 2020 17:45:20 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 33tfhxyyu1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Sep 2020 17:45:20 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08THjJiI007084;
        Tue, 29 Sep 2020 17:45:19 GMT
Received: from localhost (/67.169.218.210) by default (Oracle Beehive Gateway
 v4.0) with ESMTP ; Tue, 29 Sep 2020 10:44:35 -0700
USER-AGENT: StGit/0.19
MIME-Version: 1.0
Message-ID: <160140147498.831337.5344692693382121188.stgit@magnolia>
Date:   Tue, 29 Sep 2020 10:44:35 -0700 (PDT)
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com
Subject: [PATCH 4/4] xfs: only relog deferred intent items if free space in
 the log gets low
References: <160140144925.831337.14031530940286104610.stgit@magnolia>
In-Reply-To: <160140144925.831337.14031530940286104610.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9759 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 malwarescore=0 adultscore=0 suspectscore=3 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009290149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9759 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=3 mlxlogscore=999 clxscore=1015 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009290149
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
---
 fs/xfs/libxfs/xfs_defer.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 554777d1069c..2ba02f2e59a1 100644
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

