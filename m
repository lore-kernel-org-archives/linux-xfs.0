Return-Path: <SRS0=aYBA=4Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 463AEC3F2CD
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 23:40:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 196412469C
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 23:40:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="emlOwy9g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbgB1XkG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Feb 2020 18:40:06 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:44750 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbgB1XkG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Feb 2020 18:40:06 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SNWjNh027728;
        Fri, 28 Feb 2020 23:38:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=G8jWA2MlCkbeVZKU62GSWkH4IsqVQIyEmNSVWsijkw8=;
 b=emlOwy9g3bgvo0PNbq7Lr7flLGgkOL/FhurnXsnxH0cRmx5fSY8v1JRgbeDJ+cLjOdev
 2FjAuZLMyw3sqSM7lZqqS93NJcJB1FDr/yhYvdWBtlkpkyJDg3stt546dHIu8dod1dzN
 lemxLMb/PVe0brOU+f/wHwxEqnKvZ9/6b5TQG5pipSzBHNztZ6ceN3+Lz9YVhoFWOR78
 wrbhTvDqdVYC2eiprW9bWyOht8zz/+qCengzkPbMDybjO5UWDKsybRzq/FTXGSOKLUpu
 iWyXUWwRYqw09fmg4fvBNErg4GcVt4l3UOMItZvf8IZ1Re/K4ChCccr9Ye6K7P8WKcdB Dg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2ydct3nt4c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 23:38:02 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SNWkQx156418;
        Fri, 28 Feb 2020 23:38:01 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2ydcsgbbsa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 23:38:01 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01SNc0Zj013296;
        Fri, 28 Feb 2020 23:38:00 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Feb 2020 15:37:55 -0800
Subject: [PATCH 15/26] libxlog: use uncached buffers instead of open-coding
 them
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Date:   Fri, 28 Feb 2020 15:37:54 -0800
Message-ID: <158293307452.1549542.416939957211924183.stgit@magnolia>
In-Reply-To: <158293297395.1549542.18143701542461010748.stgit@magnolia>
References: <158293297395.1549542.18143701542461010748.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280170
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280170
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Use the new uncached buffer functions to manage buffers instead of
open-coding the logic.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/libxlog.h         |    1 -
 libxlog/xfs_log_recover.c |   35 ++++++++++++++---------------------
 logprint/log_print_all.c  |    2 +-
 3 files changed, 15 insertions(+), 23 deletions(-)


diff --git a/include/libxlog.h b/include/libxlog.h
index 4b785507..5e94fa1e 100644
--- a/include/libxlog.h
+++ b/include/libxlog.h
@@ -75,7 +75,6 @@ extern libxfs_init_t	x;
 extern int xlog_is_dirty(struct xfs_mount *, struct xlog *, libxfs_init_t *,
 			 int);
 extern struct xfs_buf *xlog_get_bp(struct xlog *, int);
-extern void	xlog_put_bp(struct xfs_buf *);
 extern int	xlog_bread(struct xlog *log, xfs_daddr_t blk_no, int nbblks,
 				xfs_buf_t *bp, char **offset);
 extern int	xlog_bread_noalign(struct xlog *log, xfs_daddr_t blk_no,
diff --git a/libxlog/xfs_log_recover.c b/libxlog/xfs_log_recover.c
index 9324a213..e7e57bd2 100644
--- a/libxlog/xfs_log_recover.c
+++ b/libxlog/xfs_log_recover.c
@@ -67,14 +67,7 @@ xlog_get_bp(
 		nbblks += log->l_sectBBsize;
 	nbblks = round_up(nbblks, log->l_sectBBsize);
 
-	return libxfs_getbufr(log->l_dev, (xfs_daddr_t)-1, nbblks);
-}
-
-void
-xlog_put_bp(
-	xfs_buf_t	*bp)
-{
-	libxfs_putbufr(bp);
+	return libxfs_buf_get_uncached(log->l_dev, nbblks, 0);
 }
 
 /*
@@ -274,7 +267,7 @@ xlog_find_verify_cycle(
 	*new_blk = -1;
 
 out:
-	xlog_put_bp(bp);
+	libxfs_buf_relse(bp);
 	return error;
 }
 
@@ -383,7 +376,7 @@ xlog_find_verify_log_record(
 		*last_blk = i;
 
 out:
-	xlog_put_bp(bp);
+	libxfs_buf_relse(bp);
 	return error;
 }
 
@@ -634,7 +627,7 @@ xlog_find_head(
 			goto bp_err;
 	}
 
-	xlog_put_bp(bp);
+	libxfs_buf_relse(bp);
 	if (head_blk == log_bbnum)
 		*return_head_blk = 0;
 	else
@@ -648,7 +641,7 @@ xlog_find_head(
 	return 0;
 
  bp_err:
-	xlog_put_bp(bp);
+	libxfs_buf_relse(bp);
 
 	if (error)
 		xfs_warn(log->l_mp, "failed to find log head");
@@ -745,7 +738,7 @@ xlog_find_tail(
 	}
 	if (!found) {
 		xfs_warn(log->l_mp, "%s: couldn't find sync record", __func__);
-		xlog_put_bp(bp);
+		libxfs_buf_relse(bp);
 		ASSERT(0);
 		return XFS_ERROR(EIO);
 	}
@@ -858,7 +851,7 @@ xlog_find_tail(
 		error = xlog_clear_stale_blocks(log, tail_lsn);
 
 done:
-	xlog_put_bp(bp);
+	libxfs_buf_relse(bp);
 
 	if (error)
 		xfs_warn(log->l_mp, "failed to locate log tail");
@@ -906,7 +899,7 @@ xlog_find_zeroed(
 	first_cycle = xlog_get_cycle(offset);
 	if (first_cycle == 0) {		/* completely zeroed log */
 		*blk_no = 0;
-		xlog_put_bp(bp);
+		libxfs_buf_relse(bp);
 		return -1;
 	}
 
@@ -917,7 +910,7 @@ xlog_find_zeroed(
 
 	last_cycle = xlog_get_cycle(offset);
 	if (last_cycle != 0) {		/* log completely written to */
-		xlog_put_bp(bp);
+		libxfs_buf_relse(bp);
 		return 0;
 	} else if (first_cycle != 1) {
 		/*
@@ -974,7 +967,7 @@ xlog_find_zeroed(
 
 	*blk_no = last_blk;
 bp_err:
-	xlog_put_bp(bp);
+	libxfs_buf_relse(bp);
 	if (error)
 		return error;
 	return -1;
@@ -1457,7 +1450,7 @@ xlog_do_recovery_pass(
 			hblks = h_size / XLOG_HEADER_CYCLE_SIZE;
 			if (h_size % XLOG_HEADER_CYCLE_SIZE)
 				hblks++;
-			xlog_put_bp(hbp);
+			libxfs_buf_relse(hbp);
 			hbp = xlog_get_bp(log, hblks);
 		} else {
 			hblks = 1;
@@ -1473,7 +1466,7 @@ xlog_do_recovery_pass(
 		return ENOMEM;
 	dbp = xlog_get_bp(log, BTOBB(h_size));
 	if (!dbp) {
-		xlog_put_bp(hbp);
+		libxfs_buf_relse(hbp);
 		return ENOMEM;
 	}
 
@@ -1657,8 +1650,8 @@ xlog_do_recovery_pass(
 	}
 
  bread_err2:
-	xlog_put_bp(dbp);
+	libxfs_buf_relse(dbp);
  bread_err1:
-	xlog_put_bp(hbp);
+	libxfs_buf_relse(hbp);
 	return error;
 }
diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index d3d4c07b..32d13719 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -39,7 +39,7 @@ xlog_print_find_oldest(
 		error = xlog_find_cycle_start(log, bp, first_blk,
 					      last_blk, last_half_cycle);
 
-	xlog_put_bp(bp);
+	libxfs_buf_relse(bp);
 	return error;
 }
 

