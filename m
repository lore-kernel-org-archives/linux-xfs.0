Return-Path: <SRS0=UMh5=XB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 902CCC00307
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:37:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89614206B8
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:37:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="b88umjvu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392102AbfIFDhg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 23:37:36 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36300 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732799AbfIFDhf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 23:37:35 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863XwBC105063;
        Fri, 6 Sep 2019 03:37:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=+Iesd87YkMxOI/J+X/jVDJxmXkXlWI+yBnYZU+NrZxo=;
 b=b88umjvuVuYRF2/B0RjwK99jpaquBqj8ZZw3eWcjZ3j9zYl/XuUbZwXptvHkBJA3wdHx
 VejVLzNdzrgkDPNzablN715FvGBKhxsaz9RySjKOacaCfGZqfRaCnC1/mb1n2rvtfOAr
 C01Nyod7+O83kTPvAYSReCvLS9fFQ39Cqh+ndm3/5z8mjs2vNY2629GQl4jeJM/RVZHK
 U6FhUOQpY2NWZYF/oIvxG/zfHSlDxgeQYQ/JLxyfRmAoVvd4+pIXbhnpp1XKFz06x3EO
 29OolmdnCFB0IbprTznVcHDS+F50MFOiQ2QFuhUiR8Fq6i2tMRl1QgRZaFSc3uGtZ6wv qA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2uuf5f833b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:37:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863YW9V103784;
        Fri, 6 Sep 2019 03:37:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2uud7p2rtn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:37:32 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x863bV6H015653;
        Fri, 6 Sep 2019 03:37:31 GMT
Received: from localhost (/10.159.148.70)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 20:37:31 -0700
Subject: [PATCH 12/13] xfs_scrub: move all the queue_subdir error reporting
 to callers
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 Sep 2019 20:37:30 -0700
Message-ID: <156774105080.2644719.10846017264580113281.stgit@magnolia>
In-Reply-To: <156774097496.2644719.4441145106129821110.stgit@magnolia>
References: <156774097496.2644719.4441145106129821110.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060039
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060039
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Change queue_subdir to return a positive error code to callers and move
the error reporting to the callers.  This continues the process of
changing internal functions to return error codes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/vfs.c |   29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)


diff --git a/scrub/vfs.c b/scrub/vfs.c
index 49d689af..e0bc3ea4 100644
--- a/scrub/vfs.c
+++ b/scrub/vfs.c
@@ -72,7 +72,7 @@ dec_nr_dirs(
 }
 
 /* Queue a directory for scanning. */
-static bool
+static int
 queue_subdir(
 	struct scrub_ctx	*ctx,
 	struct scan_fs_tree	*sft,
@@ -84,14 +84,12 @@ queue_subdir(
 	int			error;
 
 	new_sftd = malloc(sizeof(struct scan_fs_tree_dir));
-	if (!new_sftd) {
-		str_errno(ctx, _("creating directory scan context"));
-		return false;
-	}
+	if (!new_sftd)
+		return errno;
 
 	new_sftd->path = strdup(path);
 	if (!new_sftd->path) {
-		str_errno(ctx, _("creating directory scan path"));
+		error = errno;
 		goto out_sftd;
 	}
 
@@ -106,12 +104,12 @@ queue_subdir(
 		goto out_path;
 	}
 
-	return true;
+	return 0;
 out_path:
 	free(new_sftd->path);
 out_sftd:
 	free(new_sftd);
-	return false;
+	return error;
 }
 
 /* Scan a directory sub tree. */
@@ -187,10 +185,13 @@ scan_fs_dir(
 		/* If directory, call ourselves recursively. */
 		if (S_ISDIR(sb.st_mode) && strcmp(".", dirent->d_name) &&
 		    strcmp("..", dirent->d_name)) {
-			sft->moveon = queue_subdir(ctx, sft, wq, newpath,
-					false);
-			if (!sft->moveon)
+			error = queue_subdir(ctx, sft, wq, newpath, false);
+			if (error) {
+				str_liberror(ctx, error,
+_("queueing subdirectory scan"));
+				sft->moveon = false;
 				break;
+			}
 		}
 	}
 
@@ -233,9 +234,11 @@ scan_fs_tree(
 		return false;
 	}
 
-	sft.moveon = queue_subdir(ctx, &sft, &wq, ctx->mntpoint, true);
-	if (!sft.moveon)
+	ret = queue_subdir(ctx, &sft, &wq, ctx->mntpoint, true);
+	if (ret) {
+		str_liberror(ctx, ret, _("queueing directory scan"));
 		goto out_wq;
+	}
 
 	/*
 	 * Wait for the wakeup to trigger, which should only happen when the

