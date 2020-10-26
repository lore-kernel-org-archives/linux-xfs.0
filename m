Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 449D8C2D0A3
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:34:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12CBB20809
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:34:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="czczXiWX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406536AbgJZXeX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:34:23 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36486 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406526AbgJZXeX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:34:23 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNP7Bb157988;
        Mon, 26 Oct 2020 23:34:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=0OyZ49m3GaKDSrxF9Mb8uPLTrz8w9VSpOFamaA6647o=;
 b=czczXiWXZnOtw7iJRIx4Gb8sjE0Bx440zu2+kAtArXeNu5bGChZL8YnPFASKL8AC97DJ
 RwfkIsQy3kuEsdRV0dI+jY6i3ehWyW7iNjEFw+6//03cmPMIAxt16t9gNC34IXuygwZ4
 xtLabmTcvwPdxc3P9UjOsGCkDhL6eOZhdsMMQy+XpJltYEFPNiOPRfCjxoIimfGyVGTp
 4r+RIzrdL+IqDPxTUYI19foGB8/kvr7XYN5sp1J0nS0KgccwpR9gUJrpuNY8xLkZVoEN
 FhEtnaOUu9PezGh17WRicseg42ORR5d3VlyspoKeUJFzzOYwVrX4HKo0U526NHIN/R5z oA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 34cc7kq8hh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:34:21 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNQNWH058417;
        Mon, 26 Oct 2020 23:34:20 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 34cwukr8cy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:34:20 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09QNYKxr012515;
        Mon, 26 Oct 2020 23:34:20 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:34:20 -0700
Subject: [PATCH 02/26] libxfs: refactor NSEC_PER_SEC
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:34:19 -0700
Message-ID: <160375525913.881414.1818734123140314548.stgit@magnolia>
In-Reply-To: <160375524618.881414.16347303401529121282.stgit@magnolia>
References: <160375524618.881414.16347303401529121282.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=9
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=9
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Clean up all the open-coded and duplicate definitions of time unit
conversion factors.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 include/platform_defs.h.in |    3 +++
 repair/dinode.c            |    2 +-
 scrub/common.c             |    2 --
 scrub/progress.c           |    1 -
 4 files changed, 4 insertions(+), 4 deletions(-)


diff --git a/include/platform_defs.h.in b/include/platform_defs.h.in
index 1f7ceafb1fbc..a11b58719380 100644
--- a/include/platform_defs.h.in
+++ b/include/platform_defs.h.in
@@ -80,4 +80,7 @@ typedef unsigned short umode_t;
 
 extern int	platform_nproc(void);
 
+#define NSEC_PER_SEC	(1000000000ULL)
+#define NSEC_PER_USEC	(1000ULL)
+
 #endif	/* __XFS_PLATFORM_DEFS_H__ */
diff --git a/repair/dinode.c b/repair/dinode.c
index 028a23cd5c8c..95e57b5318b5 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2170,7 +2170,7 @@ check_nsec(
 	struct xfs_timestamp	*t,
 	int			*dirty)
 {
-	if (be32_to_cpu(t->t_nsec) < 1000000000)
+	if (be32_to_cpu(t->t_nsec) < NSEC_PER_SEC)
 		return;
 
 	do_warn(
diff --git a/scrub/common.c b/scrub/common.c
index c4699b6ad1e3..49a87f412c4d 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -288,8 +288,6 @@ scrub_nproc_workqueue(
  * Sleep for 100us * however many -b we got past the initial one.
  * This is an (albeit clumsy) way to throttle scrub activity.
  */
-#define NSEC_PER_SEC	1000000000ULL
-#define NSEC_PER_USEC	1000ULL
 void
 background_sleep(void)
 {
diff --git a/scrub/progress.c b/scrub/progress.c
index d8130ca5f93c..15247b7c6d1b 100644
--- a/scrub/progress.c
+++ b/scrub/progress.c
@@ -110,7 +110,6 @@ progress_report(
 	fflush(pt.fp);
 }
 
-#define NSEC_PER_SEC	(1000000000)
 static void *
 progress_report_thread(void *arg)
 {

