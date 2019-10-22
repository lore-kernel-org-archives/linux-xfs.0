Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73D84CA9EA0
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:49:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4212F20B7C
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:49:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nI+fjtYu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731806AbfJVStA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 14:49:00 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49264 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731436AbfJVStA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 14:49:00 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiOtF089207;
        Tue, 22 Oct 2019 18:48:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=2PvVF2H3TrR9myez0Teafvnmz4x04/mbYUEx5ELZZOc=;
 b=nI+fjtYuWiciB5s8B1eSqPLy0wFWYBy5LNvDPYFbDSWsCnSZgAY07EHJnkjM8FzR92OW
 6Z+Mr9iL9KtoOlXopJ20/ejcdNVtRLC7NqGIM9mB3DhTx3s+SI+qRuuY81DsVRjHD5KK
 E9V5B0y5k5WFRZyDFTKxMnCcdRw79Pv1EE1qFlV0l98emqJBTOkoXrAHvor6f7ZhO1a8
 J8DCH5ojnWUp+8pGPJ5REE2wCP1nHs2nJJ6Lo1GyxdpicDlKlHITVlpFyVOAFB9WOPZ4
 M44urtsFnKHURjDB0p39PcPyeAGDCKjFNUxfGT4wiVuJJIUmyAGTFFTX+mazcEZDCAnB RQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2vqu4qrk8m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:48:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiRnU064727;
        Tue, 22 Oct 2019 18:48:57 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2vt2hdkf8n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:48:57 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9MImuLZ030107;
        Tue, 22 Oct 2019 18:48:56 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Oct 2019 11:48:56 -0700
Subject: [PATCH 1/7] xfs_scrub: fix misclassified error reporting
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 22 Oct 2019 11:48:55 -0700
Message-ID: <157177013543.1460394.2045917914550132194.stgit@magnolia>
In-Reply-To: <157177012894.1460394.4672572733673534420.stgit@magnolia>
References: <157177012894.1460394.4672572733673534420.stgit@magnolia>
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

Fix a few places where we assign error reports to the wrong
classification.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/fscounters.c |    2 +-
 scrub/inodes.c     |    4 ++--
 scrub/phase1.c     |    2 +-
 scrub/xfs_scrub.c  |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)


diff --git a/scrub/fscounters.c b/scrub/fscounters.c
index 98aa3826..e064c865 100644
--- a/scrub/fscounters.c
+++ b/scrub/fscounters.c
@@ -48,7 +48,7 @@ xfs_count_inodes_ag(
 
 	ireq = xfrog_inumbers_alloc_req(64, 0);
 	if (!ireq) {
-		str_info(ctx, descr, _("Insufficient memory; giving up."));
+		str_liberror(ctx, ENOMEM, _("allocating inumbers request"));
 		return false;
 	}
 	xfrog_inumbers_set_ag(ireq, agno);
diff --git a/scrub/inodes.c b/scrub/inodes.c
index 7c04d7f6..71e53bb6 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -126,13 +126,13 @@ xfs_iterate_inodes_ag(
 
 	breq = xfrog_bulkstat_alloc_req(XFS_INODES_PER_CHUNK, 0);
 	if (!breq) {
-		str_info(ctx, descr, _("Insufficient memory; giving up."));
+		str_liberror(ctx, ENOMEM, _("allocating bulkstat request"));
 		return false;
 	}
 
 	ireq = xfrog_inumbers_alloc_req(1, 0);
 	if (!ireq) {
-		str_info(ctx, descr, _("Insufficient memory; giving up."));
+		str_liberror(ctx, ENOMEM, _("allocating inumbers request"));
 		free(breq);
 		return false;
 	}
diff --git a/scrub/phase1.c b/scrub/phase1.c
index 3211a488..d040c4a8 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -127,7 +127,7 @@ _("Not an XFS filesystem."));
 
 	if (!xfs_action_lists_alloc(ctx->mnt.fsgeom.agcount,
 				&ctx->action_lists)) {
-		str_error(ctx, ctx->mntpoint, _("Not enough memory."));
+		str_liberror(ctx, ENOMEM, _("allocating action lists"));
 		return false;
 	}
 
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index 147c114c..e9fc3650 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -738,7 +738,7 @@ main(
 		str_info(&ctx, ctx.mntpoint, _("Too many errors; aborting."));
 
 	if (debug_tweak_on("XFS_SCRUB_FORCE_ERROR"))
-		str_error(&ctx, ctx.mntpoint, _("Injecting error."));
+		str_info(&ctx, ctx.mntpoint, _("Injecting error."));
 
 	/* Clean up scan data. */
 	moveon = xfs_cleanup_fs(&ctx);

