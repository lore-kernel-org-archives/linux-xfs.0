Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C10AFCA9EA0
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:49:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92CFB21872
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:49:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NdLja85H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732548AbfJVStH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 14:49:07 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46242 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731436AbfJVStH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 14:49:07 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiBNE109498;
        Tue, 22 Oct 2019 18:49:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=hCGDAUx3sxEjktPbEBF4/pSa1hPP/1GxXv8bBqAektc=;
 b=NdLja85HAlv/kNuIJMfDvFPLzA+kpf2GJSmDgpimP+o3mnoVSRb3nhOUGa33xyVchlSj
 0+AenrkCtH1ROHbqGXuVVT9Zl87ZUbaDIWpGIn9zkLzfba2sQNqw0Vv2QhsHa7hCDXWY
 dnbxZ+P3iKJVwyyC0hD8Uj+Bmp7sQ/KEnkIM2sG+FtrpVHZvMUK1aiHt5NEAyKYl/0ij
 IJUAdtQtPudShvS+bWe7l6dm+ZDynudQGjjE7NMxHv/NmO6D40rqYJd+w5QWprOugiUW
 IOVuVTXqQ/qlt0IXLkYVabIr1PGH1GuttTq0S1G+h974F2fA9WlwgVw20rNYIjEEq3Hy pA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2vqswtgv1h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:49:04 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiNJg070505;
        Tue, 22 Oct 2019 18:49:04 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2vsx2rkjae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:49:04 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9MIn33L026473;
        Tue, 22 Oct 2019 18:49:03 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Oct 2019 11:49:03 -0700
Subject: [PATCH 2/7] xfs_scrub: simplify post-run reporting logic
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 22 Oct 2019 11:49:01 -0700
Message-ID: <157177014195.1460394.14453951715857384456.stgit@magnolia>
In-Reply-To: <157177012894.1460394.4672572733673534420.stgit@magnolia>
References: <157177012894.1460394.4672572733673534420.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910220156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910220156
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Simplify the post-run error and warning reporting logic so that in
subsequent patches we can be more specific about what types of things
went wrong.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/xfs_scrub.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)


diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index e9fc3650..c7305694 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -516,24 +516,20 @@ report_outcome(
 	total_errors = ctx->errors_found + ctx->runtime_errors;
 
 	if (total_errors == 0 && ctx->warnings_found == 0) {
-		log_info(ctx, _("No errors found."));
+		log_info(ctx, _("No problems found."));
 		return;
 	}
 
-	if (total_errors == 0) {
-		fprintf(stderr, _("%s: warnings found: %llu\n"), ctx->mntpoint,
-				ctx->warnings_found);
-		log_warn(ctx, _("warnings found: %llu"), ctx->warnings_found);
-	} else if (ctx->warnings_found == 0) {
+	if (total_errors > 0) {
 		fprintf(stderr, _("%s: errors found: %llu\n"), ctx->mntpoint,
 				total_errors);
 		log_err(ctx, _("errors found: %llu"), total_errors);
-	} else {
-		fprintf(stderr, _("%s: errors found: %llu; warnings found: %llu\n"),
-				ctx->mntpoint, total_errors,
+	}
+
+	if (ctx->warnings_found > 0) {
+		fprintf(stderr, _("%s: warnings found: %llu\n"), ctx->mntpoint,
 				ctx->warnings_found);
-		log_err(ctx, _("errors found: %llu; warnings found: %llu"),
-				total_errors, ctx->warnings_found);
+		log_warn(ctx, _("warnings found: %llu"), ctx->warnings_found);
 	}
 
 	/*

