Return-Path: <SRS0=2cgH=B3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5271C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 23:01:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CE78204EC
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 23:01:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DIzQy8/V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbgHQXBz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 19:01:55 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42526 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbgHQXBy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Aug 2020 19:01:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMv9PF136201;
        Mon, 17 Aug 2020 23:01:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=2UCY3ZQitWE+qiZlRbjx1QvdkSw4DYINPMPobk5Dmis=;
 b=DIzQy8/VVsr36DcZ6kApk3bJ9AfbRKtuBKW16UAaQMOPxuRIQjBjM/tTGKvQ9qD0G8qR
 79fvPb8J45iJCHu1X9GD3yhhd2W9Yq35sTSlf4NVhS6yHQgzjEViu1QzS0nFhGEmKnqx
 07ozVfjeVDKymfzpWT5hpDtVhShNe3SbKFkhdzjGXhYB771BQH2e4sPaUS/rCIxRXtIi
 bYfWdSVQgpXVfIX5xwpzexWWJeMoNpjWw8x1za9Rwis7PIo06farWspFfjlYdNX9WOC/
 eniBHsB5hL9V96SR57eBntw+yYPJjJ2zEw09OeDppFdTalHkTPEFepruLCAFHBhEVzvZ Eg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 32x8bn1g9y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 17 Aug 2020 23:01:52 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMw8J6139080;
        Mon, 17 Aug 2020 22:59:51 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 32xs9ma04n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Aug 2020 22:59:51 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07HMxpdH025674;
        Mon, 17 Aug 2020 22:59:51 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Aug 2020 15:59:50 -0700
Subject: [PATCH 09/18] libxfs: refactor NSEC_PER_SEC
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 17 Aug 2020 15:59:50 -0700
Message-ID: <159770519011.3958786.9102828204613614956.stgit@magnolia>
In-Reply-To: <159770513155.3958786.16108819726679724438.stgit@magnolia>
References: <159770513155.3958786.16108819726679724438.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 suspectscore=9 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008170153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 suspectscore=9 adultscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008170153
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Clean up all the open-coded and duplicate definitions of time unit
conversion factors.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
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
index c5f2248b2b9a..0bee3c3d988e 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2172,7 +2172,7 @@ check_nsec(
 	union xfs_timestamp	*t,
 	int			*dirty)
 {
-	if (be32_to_cpu(t->t_nsec) < 1000000000)
+	if (be32_to_cpu(t->t_nsec) < NSEC_PER_SEC)
 		return;
 
 	do_warn(
diff --git a/scrub/common.c b/scrub/common.c
index 261f575a0c9b..70efaf04c648 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -294,8 +294,6 @@ scrub_nproc_workqueue(
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

