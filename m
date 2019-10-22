Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF1E1CA9EA0
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:51:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92B6520B7C
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:51:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dr1yawvZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732729AbfJVSvQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 14:51:16 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51716 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731436AbfJVSvQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 14:51:16 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiF2V089172;
        Tue, 22 Oct 2019 18:51:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=u2WuJvJqcV3lYiLz4AnnpZGiZJ99kS5k3v/VBvPZ5+4=;
 b=dr1yawvZYWi52Ab6givjREyXq93CiFBef4d4bUXx5kKcamwkmzIVlZM3mgN9nvO9R3lu
 m+/hO73m0knQzo1k1zd8TgWI3Nm5/VkI+fx6UooFyBFpA4V+CU+xiM5jA2006U0tZL7p
 xdEYtrKMfPF6eUlLIpq0QZs5lgN9TGmA8alqKqPSoKK8dVRYMm99xHvxe3SG8Y4LkRc1
 jR0Fo5fo9f2QqYvf6wxTHsr4ahr5/0XuknSvwY1jlGYPYXhF5sZm+rIo5cR2z3qe5rcr
 TojqDnba+VzydK3Y590m2HGu4GIGwKEHZ4+XRJVO8gVEptxpJZUpkeLJIzsUi6DsZz0N Pg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2vqu4qrkkv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:51:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiQN8064588;
        Tue, 22 Oct 2019 18:51:12 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2vt2hdkn67-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:51:12 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9MIpBsI031523;
        Tue, 22 Oct 2019 18:51:11 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Oct 2019 11:51:10 -0700
Subject: [PATCH 07/18] xfs_scrub: remove moveon from progress report helpers
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 22 Oct 2019 11:51:09 -0700
Message-ID: <157177026933.1461658.9187931765295782274.stgit@magnolia>
In-Reply-To: <157177022106.1461658.18024534947316119946.stgit@magnolia>
References: <157177022106.1461658.18024534947316119946.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910220156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910220156
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
index 839528ea..c0e60b92 100644
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

