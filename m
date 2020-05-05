Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51CB1C3A5A9
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 01:13:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31438205ED
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 01:13:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZDIUQLB4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbgEEBNd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 21:13:33 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37938 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726598AbgEEBNd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 21:13:33 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 045136u7054641
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:13:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=u+aT+lLbAfgpmD3Kr+1ZkhBfWAepKWP8VXxP10rVd3U=;
 b=ZDIUQLB42GqYNFcRjAsH06Ji2Y6zLks2/n4NqtLLdOZw09dX1VZ670k4Wh8xGo3yrIph
 b+LYQ4fFd7Y6MF1O2OpFYhCf3OIcOT06LXHgAMNZeMiLEdir2i0JAPtkQBei6/8Ul5nM
 RG3TWmjj28VYEVQywXySDqWWmW9FdsUb6PZ7VKGid2QHf106nqPPYxwiWFS7iNj7KYdT
 8NfpDzG0QFkbEgjJiE9qeK1xVXsQuJlTSAkKw0VoLsANQJ27IV6CUJweQ+uR5vXn0i1U
 BBUbuJwB/Ls0BsE60ERyrdTfixejcxEo2izSRWf48jvOsHiQmDtgiDpm7TNiUtevdsXy Cw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 30s0tma1be-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 01:13:32 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04516smN004726
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:13:32 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 30sjdru0kv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 01:13:32 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0451DV3B015558
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:13:31 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 18:13:31 -0700
Subject: [PATCH 28/28] xfs: use parallel processing to clear unlinked metadata
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 04 May 2020 18:13:30 -0700
Message-ID: <158864121071.182683.2313546760215092713.stgit@magnolia>
In-Reply-To: <158864103195.182683.2056162574447133617.stgit@magnolia>
References: <158864103195.182683.2056162574447133617.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=3 mlxscore=0
 bulkscore=0 adultscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 suspectscore=3
 phishscore=0 clxscore=1015 bulkscore=0 mlxlogscore=999 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050005
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Run all the unlinked metadata clearing work in parallel so that we can
take advantage of higher-performance storage devices.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_unlink_recover.c |   42 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 39 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_unlink_recover.c b/fs/xfs/xfs_unlink_recover.c
index fe7fa3d623f2..92ea81969e02 100644
--- a/fs/xfs/xfs_unlink_recover.c
+++ b/fs/xfs/xfs_unlink_recover.c
@@ -21,6 +21,7 @@
 #include "xfs_trans_priv.h"
 #include "xfs_ialloc.h"
 #include "xfs_icache.h"
+#include "xfs_pwork.h"
 
 /*
  * This routine performs a transaction to null out a bad inode pointer
@@ -195,19 +196,54 @@ xlog_recover_process_iunlinked(
 	return 0;
 }
 
+struct xlog_recover_unlinked {
+	struct xfs_pwork	pwork;
+	xfs_agnumber_t		agno;
+};
+
+static int
+xlog_recover_process_unlinked_ag(
+	struct xfs_mount		*mp,
+	struct xfs_pwork		*pwork)
+{
+	struct xlog_recover_unlinked	*ru;
+	int				error = 0;
+
+	ru = container_of(pwork, struct xlog_recover_unlinked, pwork);
+	if (xfs_pwork_want_abort(pwork))
+		goto out;
+
+	error = xlog_recover_process_iunlinked(mp, ru->agno);
+out:
+	kmem_free(ru);
+	return error;
+}
+
 int
 xlog_recover_process_unlinked(
 	struct xlog		*log)
 {
 	struct xfs_mount	*mp = log->l_mp;
+	struct xfs_pwork_ctl	pctl;
+	struct xlog_recover_unlinked *ru;
+	unsigned int		nr_threads;
 	xfs_agnumber_t		agno;
 	int			error;
 
+	nr_threads = xfs_pwork_guess_datadev_parallelism(mp);
+	error = xfs_pwork_init(mp, &pctl, xlog_recover_process_unlinked_ag,
+			"xlog_recover", nr_threads);
+	if (error)
+		return error;
+
 	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
-		error = xlog_recover_process_iunlinked(mp, agno);
-		if (error)
+		if (xfs_pwork_ctl_want_abort(&pctl))
 			break;
+
+		ru = kmem_zalloc(sizeof(struct xlog_recover_unlinked), 0);
+		ru->agno = agno;
+		xfs_pwork_queue(&pctl, &ru->pwork);
 	}
 
-	return error;
+	return xfs_pwork_destroy(&pctl);
 }

