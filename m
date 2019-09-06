Return-Path: <SRS0=UMh5=XB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC80EC43331
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:41:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5E8E206BB
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:41:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IWM/02a+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388477AbfIFDlo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 23:41:44 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54916 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404465AbfIFDln (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 23:41:43 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863dGJv113013;
        Fri, 6 Sep 2019 03:41:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=bMOgTxMhxRdI5J33gp8lJ6r10yE4SBz3daFQpUI9vcw=;
 b=IWM/02a+WToKUuF+S/VLegGaBAeuNmMw4+xTg4XPgA+9TBbOzofle8MyPKBSPln5PP6H
 Fmp/LF9IMZYYp/HiV9CtIuanX01/mxKZCq30EEmlgMFWB1iZKGBkU8bipGMPsfUmj41G
 3MRQ9AqiC6QPtTziftBiV3qJPO1YitHtwTrazmzdolLFi2yUQwbYDIgavlOWBqTyD5E6
 XU9+VHuh8szek10cwNVSumOvTgdVy5cDZ9PKwj5PXW5PkIEPY39Cs5YFHPiLIUKHBjZq
 TjJ0ffP+vusUeOujox4XtM3dANUFOxxoyeD68GbRq5ve7AqPp8a7bEMOua+A1NJIXPO+ mg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2uufr0807m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:41:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863cPMe077867;
        Fri, 6 Sep 2019 03:41:41 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2utvr4k30x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:41:41 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x863fe2q021299;
        Fri, 6 Sep 2019 03:41:40 GMT
Received: from localhost (/10.159.148.70)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 20:41:40 -0700
Subject: [PATCH 07/18] xfs_scrub: remove moveon from progress report helpers
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 Sep 2019 20:41:39 -0700
Message-ID: <156774129978.2646807.79385701060866371.stgit@magnolia>
In-Reply-To: <156774125578.2646807.1183436616735969617.stgit@magnolia>
References: <156774125578.2646807.1183436616735969617.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060040
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060040
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Replace the moveon returns in the scrub process reporting helpers
with a direct integer error return.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/progress.c  |   13 ++++++++-----
 scrub/progress.h  |    2 +-
 scrub/xfs_scrub.c |   13 +++++++++----
 3 files changed, 18 insertions(+), 10 deletions(-)


diff --git a/scrub/progress.c b/scrub/progress.c
index e93b607f..d8130ca5 100644
--- a/scrub/progress.c
+++ b/scrub/progress.c
@@ -167,8 +167,11 @@ progress_end_phase(void)
 	pt.fp = NULL;
 }
 
-/* Set ourselves up to report progress. */
-bool
+/*
+ * Set ourselves up to report progress.  If errors are encountered, this
+ * function will log them and return nonzero.
+ */
+int
 progress_init_phase(
 	struct scrub_ctx	*ctx,
 	FILE			*fp,
@@ -182,7 +185,7 @@ progress_init_phase(
 	assert(pt.fp == NULL);
 	if (fp == NULL || max == 0) {
 		pt.fp = NULL;
-		return true;
+		return 0;
 	}
 	pt.fp = fp;
 	pt.isatty = isatty(fileno(fp));
@@ -205,7 +208,7 @@ progress_init_phase(
 		goto out_ptcounter;
 	}
 
-	return true;
+	return 0;
 
 out_ptcounter:
 	ptcounter_free(pt.ptc);
@@ -213,5 +216,5 @@ progress_init_phase(
 out_max:
 	pt.max = 0;
 	pt.fp = NULL;
-	return false;
+	return ret;
 }
diff --git a/scrub/progress.h b/scrub/progress.h
index 9144770e..c1a115cb 100644
--- a/scrub/progress.h
+++ b/scrub/progress.h
@@ -10,7 +10,7 @@
 #define START_IGNORE	'\001'
 #define END_IGNORE	'\002'
 
-bool progress_init_phase(struct scrub_ctx *ctx, FILE *progress_fp,
+int progress_init_phase(struct scrub_ctx *ctx, FILE *progress_fp,
 			 unsigned int phase, uint64_t max, int rshift,
 			 unsigned int nr_threads);
 void progress_end_phase(void);
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index 89f6c96a..97482c8c 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -423,6 +423,7 @@ run_scrub_phases(
 	unsigned int		debug_phase = 0;
 	unsigned int		phase;
 	int			rshift;
+	int			ret;
 
 	if (debug_tweak_on("XFS_SCRUB_PHASE"))
 		debug_phase = atoi(getenv("XFS_SCRUB_PHASE"));
@@ -468,15 +469,19 @@ run_scrub_phases(
 			 * whatever other per-thread data we need to allocate.
 			 */
 			work_threads++;
-			moveon = progress_init_phase(ctx, progress_fp, phase,
+			ret = progress_init_phase(ctx, progress_fp, phase,
 					max_work, rshift, work_threads);
-			if (!moveon)
+			if (ret) {
+				moveon = false;
 				break;
+			}
 			moveon = descr_init_phase(ctx, work_threads) == 0;
 		} else {
-			moveon = progress_init_phase(ctx, NULL, phase, 0, 0, 0);
-			if (!moveon)
+			ret = progress_init_phase(ctx, NULL, phase, 0, 0, 0);
+			if (ret) {
+				moveon = false;
 				break;
+			}
 			moveon = descr_init_phase(ctx, 1) == 0;
 		}
 		if (!moveon)

