Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70826C4363A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:39:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37C3A20809
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:39:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Uz6/p+4l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407243AbgJZXjD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:39:03 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39398 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407284AbgJZXjD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:39:03 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPuo5158448;
        Mon, 26 Oct 2020 23:39:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=aHK3RRmbjuUucP/NJHl38w5ICgWGiEk4fWyClVNwPek=;
 b=Uz6/p+4lAGrZxYb+qLmHFlYCATMSwFz6CTT37xbq3LdqGLBNw8AXMEckcWxQ8a+s5cz2
 GCR2rtWM4VwZ3goqH10JR2NtGWzQ7elWn2EFJsXYp+5tMcb7PqeLyCPJF8wy4Tm1kp5l
 +UyGyRVSZ+Wo0YDrQDP9D22N+KpapQpK4Q10B1zcb/rj9Rb2l0jfM5C42RdX2mLAibqx
 C1bp+HCbmgXQysgjStszzi2pTA9vBDP7u2MKD7VDqRoKt23njqXxSoT2xwRTPwkkg09w
 dSHmOFsJSUkbgwx3O+bx0znXb/BfnA/FeI4tFCxUf/C5m7nJ6j9MPw69cNPze/NSrRyy eQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 34cc7kq8tw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:38:59 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPGj3121116;
        Mon, 26 Oct 2020 23:38:59 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 34cx6va7xa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:38:59 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09QNcwLv030625;
        Mon, 26 Oct 2020 23:38:58 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:38:58 -0700
Subject: [PATCH 19/21] xfs: only relog deferred intent items if free space in
 the log gets low
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:38:57 -0700
Message-ID: <160375553723.882906.12560590143941032565.stgit@magnolia>
In-Reply-To: <160375541713.882906.11902959014062334120.stgit@magnolia>
References: <160375541713.882906.11902959014062334120.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=2
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Source kernel commit: 74f4d6a1e065c92428c5b588099e307a582d79d9

Now that we have the ability to ask the log how far the tail needs to be
pushed to maintain its free space targets, augment the decision to relog
an intent item so that we only do it if the log has hit the 75% full
threshold.  There's no point in relogging an intent into the same
checkpoint, and there's no need to relog if there's plenty of free space
in the log.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/xfs_trans.h |   20 ++++++++++++++++++++
 libxfs/xfs_defer.c  |   16 ++++++++++++++++
 2 files changed, 36 insertions(+)


diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index 1784b8b64cf8..a409757420e4 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -151,4 +151,24 @@ libxfs_trans_read_buf(
 #define xfs_log_item_in_current_chkpt(lip)	(false)
 #define xfs_trans_item_relog(lip, tp)		(NULL)
 
+/* Contorted mess to make gcc shut up. */
+#define xlog_grant_push_threshold(log, need)	\
+		((log) == (log) ? NULLCOMMITLSN : NULLCOMMITLSN)
+
+/*
+ * By comparing each component, we don't have to worry about extra
+ * endian issues in treating two 32 bit numbers as one 64 bit number
+ */
+static inline xfs_lsn_t	_lsn_cmp(xfs_lsn_t lsn1, xfs_lsn_t lsn2)
+{
+	if (CYCLE_LSN(lsn1) != CYCLE_LSN(lsn2))
+		return (CYCLE_LSN(lsn1)<CYCLE_LSN(lsn2))? -999 : 999;
+
+	if (BLOCK_LSN(lsn1) != BLOCK_LSN(lsn2))
+		return (BLOCK_LSN(lsn1)<BLOCK_LSN(lsn2))? -999 : 999;
+
+	return 0;
+}
+#define XFS_LSN_CMP(a, b)			_lsn_cmp(a, b)
+
 #endif	/* __XFS_TRANS_H__ */
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index abee6d4260e2..1fdf6c720357 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -352,7 +352,10 @@ xfs_defer_relog(
 	struct xfs_trans		**tpp,
 	struct list_head		*dfops)
 {
+	struct xlog			*log = (*tpp)->t_mountp->m_log;
 	struct xfs_defer_pending	*dfp;
+	xfs_lsn_t			threshold_lsn = NULLCOMMITLSN;
+
 
 	ASSERT((*tpp)->t_flags & XFS_TRANS_PERM_LOG_RES);
 
@@ -368,6 +371,19 @@ xfs_defer_relog(
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

