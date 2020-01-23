Return-Path: <SRS0=OHiL=3M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA73BC33CAA
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jan 2020 07:44:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAD27206D4
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jan 2020 07:44:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SawNAjkB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725938AbgAWHoT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jan 2020 02:44:19 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:58214 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbgAWHoT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jan 2020 02:44:19 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00N7i3ZD175033;
        Thu, 23 Jan 2020 07:44:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=nZsvjhc+j9nW0RaRqDlKu2iVCRJnk+svpiF7YhNDveE=;
 b=SawNAjkBHlCpET30XUVbCW46J9P+fCdWqr161BiDoFvjgLPOGCRAlOE1tZzYei7pETvJ
 rQnlevC/7HbqAduZTf3+4GTngZ68dCsDlWoi70D9zGhJuM9Y01+p5qB+JN3AJi8YQ+gq
 HTyn2n/PHh4uP32QbR6EF6laRNdg6hO3kqZPoETHul/MFJ6H9b95Yr8hGBZyk2L6Fy9Y
 4/3YWt0DtLiFL7ICOYduD22bZvWVOE1SSUrkcYTOXAATF1Gc7GJWviGH3cGMQejMBuYK
 rWjFPlxSc3K5Q9gWqv5Ny8JrLCGD2bUiIAFbZTQf5cWXCAdfc3bmy5ynKrlGUWmBV4w+ 1A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2xkseurm19-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jan 2020 07:44:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00N7i5Y0073043;
        Thu, 23 Jan 2020 07:44:11 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2xpt6nprxw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jan 2020 07:44:05 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00N7h1q5018078;
        Thu, 23 Jan 2020 07:43:01 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 22 Jan 2020 23:43:01 -0800
Subject: [PATCH 11/12] xfs: remove unnecessary null pointer checks from
 _read_agf callers
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        Christoph Hellwig <hch@lst.de>
Date:   Wed, 22 Jan 2020 23:43:01 -0800
Message-ID: <157976538103.2388944.15185862740410550762.stgit@magnolia>
In-Reply-To: <157976531016.2388944.3654360225810285604.stgit@magnolia>
References: <157976531016.2388944.3654360225810285604.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9508 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001230066
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9508 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001230066
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Drop the null buffer pointer checks in all code that calls
xfs_alloc_read_agf and doesn't pass XFS_ALLOC_FLAG_TRYLOCK because
they're no longer necessary.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_refcount.c   |    6 ------
 fs/xfs/scrub/agheader_repair.c |    4 ----
 fs/xfs/scrub/fscounters.c      |    3 ---
 fs/xfs/scrub/repair.c          |    2 --
 fs/xfs/xfs_discard.c           |    2 +-
 fs/xfs/xfs_reflink.c           |    2 --
 6 files changed, 1 insertion(+), 18 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index d7d702ee4d1a..6e1665f2cb67 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1177,8 +1177,6 @@ xfs_refcount_finish_one(
 				XFS_ALLOC_FLAG_FREEING, &agbp);
 		if (error)
 			return error;
-		if (XFS_IS_CORRUPT(tp->t_mountp, !agbp))
-			return -EFSCORRUPTED;
 
 		rcur = xfs_refcountbt_init_cursor(mp, tp, agbp, agno);
 		if (!rcur) {
@@ -1718,10 +1716,6 @@ xfs_refcount_recover_cow_leftovers(
 	error = xfs_alloc_read_agf(mp, tp, agno, 0, &agbp);
 	if (error)
 		goto out_trans;
-	if (!agbp) {
-		error = -ENOMEM;
-		goto out_trans;
-	}
 	cur = xfs_refcountbt_init_cursor(mp, tp, agbp, agno);
 
 	/* Find all the leftover CoW staging extents. */
diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 7a1a38b636a9..d5e6db9af434 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -659,8 +659,6 @@ xrep_agfl(
 	error = xfs_alloc_read_agf(mp, sc->tp, sc->sa.agno, 0, &agf_bp);
 	if (error)
 		return error;
-	if (!agf_bp)
-		return -ENOMEM;
 
 	/*
 	 * Make sure we have the AGFL buffer, as scrub might have decided it
@@ -735,8 +733,6 @@ xrep_agi_find_btrees(
 	error = xfs_alloc_read_agf(mp, sc->tp, sc->sa.agno, 0, &agf_bp);
 	if (error)
 		return error;
-	if (!agf_bp)
-		return -ENOMEM;
 
 	/* Find the btree roots. */
 	error = xrep_find_ag_btree_roots(sc, agf_bp, fab, NULL);
diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index 7251c66a82c9..ec2064ed3c30 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -83,9 +83,6 @@ xchk_fscount_warmup(
 		error = xfs_alloc_read_agf(mp, sc->tp, agno, 0, &agf_bp);
 		if (error)
 			break;
-		error = -ENOMEM;
-		if (!agf_bp || !agi_bp)
-			break;
 
 		/*
 		 * These are supposed to be initialized by the header read
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 3df49d487940..e489d7a8446a 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -546,8 +546,6 @@ xrep_reap_block(
 		error = xfs_alloc_read_agf(sc->mp, sc->tp, agno, 0, &agf_bp);
 		if (error)
 			return error;
-		if (!agf_bp)
-			return -ENOMEM;
 	} else {
 		agf_bp = sc->sa.agf_bp;
 	}
diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index cae613620175..0b8350e84d28 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -45,7 +45,7 @@ xfs_trim_extents(
 	xfs_log_force(mp, XFS_LOG_SYNC);
 
 	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
-	if (error || !agbp)
+	if (error)
 		goto out_put_perag;
 
 	cur = xfs_allocbt_init_cursor(mp, NULL, agbp, agno, XFS_BTNUM_CNT);
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index e723b267a247..b0ce04ffd3cd 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -143,8 +143,6 @@ xfs_reflink_find_shared(
 	error = xfs_alloc_read_agf(mp, tp, agno, 0, &agbp);
 	if (error)
 		return error;
-	if (!agbp)
-		return -ENOMEM;
 
 	cur = xfs_refcountbt_init_cursor(mp, tp, agbp, agno);
 

