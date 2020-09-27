Return-Path: <SRS0=IMq7=DE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CE14C4346E
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Sep 2020 23:42:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6582523A33
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Sep 2020 23:42:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="J0hJ5sQ6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbgI0Xmb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 27 Sep 2020 19:42:31 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54826 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726392AbgI0Xma (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Sep 2020 19:42:30 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08RNfdF5144068;
        Sun, 27 Sep 2020 23:42:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Ub6douGDfii24Sm74FDwX00R5ZseK+kkkbopo01XtHQ=;
 b=J0hJ5sQ6lkazrZAekyNc6DKwIUPCiHwJtHgf62SLndET0C9iLzGC11oPWFlmtUoBIuxO
 UPL2xEjKQg2r5WzlmsRUVAXsexWk4uTtrT1W1RSL8nEYIFumhiGLBMYd/kEepHCAyVap
 2s3c3P5kXUMql4M3/HhgXYGgXkQ6qMwZ4Oc//Nm/go/XANpRcDuO4xVvopQscT4w5ZoL
 9tM5QsetC8Jvgqb8GcH1JZhQdoWnuoZaER63PfupNXmEE0GMWkQqmGoAsrHIjL6nlReV
 5RfOTB5HJvf13o9yiEXr46rAozhCCABKPdk+GhkvHWubXDMYQm7RUOS6JG54tV9pHTyx cQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 33swkkjh65-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 27 Sep 2020 23:42:27 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08RNeoWX187032;
        Sun, 27 Sep 2020 23:42:27 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 33tf7jnphe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 27 Sep 2020 23:42:27 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08RNgQrf002610;
        Sun, 27 Sep 2020 23:42:26 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 27 Sep 2020 16:42:25 -0700
Subject: [PATCH 4/4] xfs: only relog deferred intent items if free space in
 the log gets low
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com
Date:   Sun, 27 Sep 2020 16:42:24 -0700
Message-ID: <160125014477.174867.15070395010887462680.stgit@magnolia>
In-Reply-To: <160125011935.174867.2604597189723452984.stgit@magnolia>
References: <160125011935.174867.2604597189723452984.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9757 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=3 adultscore=0 malwarescore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009270227
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9757 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=3 mlxlogscore=999 clxscore=1015 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009270227
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
 fs/xfs/libxfs/xfs_defer.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index dfa301bddf6f..30627f524b8c 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -356,11 +356,14 @@ xfs_defer_relog(
 	struct xfs_trans		**tpp,
 	struct list_head		*dfops)
 {
+	struct xlog			*log = (*tpp)->t_mountp->m_log;
 	struct xfs_defer_pending	*dfp;
 
 	ASSERT((*tpp)->t_flags & XFS_TRANS_PERM_LOG_RES);
 
 	list_for_each_entry(dfp, dfops, dfp_list) {
+		xfs_lsn_t		threshold_lsn;
+
 		/*
 		 * If the log intent item for this deferred op is not a part of
 		 * the current log checkpoint, relog the intent item to keep
@@ -372,6 +375,15 @@ xfs_defer_relog(
 		    xfs_log_item_in_current_chkpt(dfp->dfp_intent))
 			continue;
 
+		/*
+		 * Figure out where we need the tail to be in order to maintain
+		 * the minimum required free space in the log.
+		 */
+		threshold_lsn = xlog_grant_push_threshold(log, 0);
+		if (threshold_lsn == NULLCOMMITLSN ||
+		    XFS_LSN_CMP(dfp->dfp_intent->li_lsn, threshold_lsn) >= 0)
+			continue;
+
 		trace_xfs_defer_relog_intent((*tpp)->t_mountp, dfp);
 		dfp->dfp_intent = xfs_trans_item_relog(dfp->dfp_intent, *tpp);
 	}

