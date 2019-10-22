Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1064CCA9EA0
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:50:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4BE420B7C
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:50:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KFc1G5Dl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732322AbfJVSuZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 14:50:25 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50766 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732580AbfJVSuZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 14:50:25 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiDiL089164;
        Tue, 22 Oct 2019 18:50:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=VSh92QpAIMf5VTpa8Quq2AYp4aDMAVrrx+3z/6etU84=;
 b=KFc1G5DlH86c5K2e0dhi3wA5+VuRTvFWVEQxCPmOIZbveWU/OPLtoVHXUzOaXm5WcnLH
 fhkPcD9IGGHyNfocI8NCvPQjuE9KWXcFj5U7hlleqFSTo+qAJsHX90ld0dfoUK3v8cH5
 brNDSFV5vy0u2z/rvrjGHasJ32k062jb+0S5leBlECQmmZKbIGvHZhsqY5SKCY21ZCJY
 Nd50rL66ahdLi5LXWPc81a4d0UtfZFhRYl8Z8T0mWrNJncqN3BXxbEnaANAXZz9q+MLJ
 HAxlyBczF4EFb2PeDtCQHc4JTupVnVQPhhnAfpwbiVBjn9+Qc9cSrV1flUWnG1GVb0ys yQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2vqu4qrkg6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:50:22 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIhQ9H125391;
        Tue, 22 Oct 2019 18:50:21 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2vsx239u9c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:50:21 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9MIoK2e030954;
        Tue, 22 Oct 2019 18:50:20 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Oct 2019 11:50:19 -0700
Subject: [PATCH 3/3] xfs_scrub: relabel verified data block counts in output
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Date:   Tue, 22 Oct 2019 11:50:18 -0700
Message-ID: <157177021896.1460684.17898254855180099140.stgit@magnolia>
In-Reply-To: <157177019803.1460684.3524666107607426492.stgit@magnolia>
References: <157177019803.1460684.3524666107607426492.stgit@magnolia>
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

Relabel the count of verified data blocks to make it more obvious that
we were only looking for file data.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
---
 scrub/phase7.c    |   13 ++++++++-----
 scrub/xfs_scrub.c |    2 ++
 2 files changed, 10 insertions(+), 5 deletions(-)


diff --git a/scrub/phase7.c b/scrub/phase7.c
index 570ceb3f..2622bc45 100644
--- a/scrub/phase7.c
+++ b/scrub/phase7.c
@@ -116,6 +116,7 @@ xfs_scan_summary(
 	unsigned long long	f_free;
 	bool			moveon;
 	bool			complain;
+	bool			scrub_all = scrub_data > 1;
 	int			ip;
 	int			error;
 
@@ -244,14 +245,15 @@ _("%.*f%s inodes counted; %.*f%s inodes checked.\n"),
 	}
 
 	/*
-	 * Complain if the checked block counts are off, which
+	 * Complain if the data file verification block counts are off, which
 	 * implies an incomplete check.
 	 */
-	if (ctx->bytes_checked &&
+	if (scrub_data &&
 	    (verbose ||
 	     !within_range(ctx, used_data + used_rt,
 			ctx->bytes_checked, absdiff, 1, 10,
-			_("verified blocks")))) {
+			scrub_all ? _("verified blocks") :
+				    _("verified file data blocks")))) {
 		double		b1, b2;
 		char		*b1u, *b2u;
 
@@ -262,8 +264,9 @@ _("%.*f%s inodes counted; %.*f%s inodes checked.\n"),
 
 		b1 = auto_space_units(used_data + used_rt, &b1u);
 		b2 = auto_space_units(ctx->bytes_checked, &b2u);
-		fprintf(stdout,
-_("%.1f%s data counted; %.1f%s data verified.\n"),
+		fprintf(stdout, scrub_all ?
+_("%.1f%s data counted; %.1f%s disk media verified.\n") :
+_("%.1f%s data counted; %.1f%s file data media verified.\n"),
 				b1, b1u, b2, b2u);
 		fflush(stdout);
 	}
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index b2e58108..839528ea 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -432,6 +432,8 @@ run_scrub_phases(
 		/* Turn on certain phases if user said to. */
 		if (sp->fn == DATASCAN_DUMMY_FN && scrub_data) {
 			sp->fn = xfs_scan_blocks;
+			if (scrub_data > 1)
+				sp->descr = _("Verify disk integrity.");
 		} else if (sp->fn == REPAIR_DUMMY_FN &&
 			   ctx->mode == SCRUB_MODE_REPAIR) {
 			sp->descr = _("Repair filesystem.");

