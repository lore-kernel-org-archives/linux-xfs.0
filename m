Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86250CA9EA0
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:49:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56B6121872
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:49:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ixldua8s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732758AbfJVSt0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 14:49:26 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52134 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732615AbfJVSt0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 14:49:26 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiGah091023;
        Tue, 22 Oct 2019 18:49:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=rkTVJLE1AsUvXbBlEEOQ/HTJe1ka3dTmPYu5nWq+Zhs=;
 b=Ixldua8sOt0L2pkTkGlzgW/q2sv5b4pn8CnOr2dq7SLRu36/9nIlB80ocjkgIoUcJ5Ny
 JCGX83egguv7Ax97oounI9K3g9nhuwCAajDfxE2WOsFuGVgGCBbOEnNrBwEw5LWX9blv
 mFWPZ4Nf40DfdV2+rK+PCVtp/kPwpwgsa7soDT/drcFb7bSKM1fCfoRfNAMc+nABMy6J
 plAhEas6SvuvKD6ju91juSwjPd/0cpXR5hibPx5z8dTbkWInGjSZP6yljwE7UvKTWb0Q
 VD33q0K6/UDcR+wtZiAfk0SPbmGy5i/rdWR0xVJF1c/+FIhqXRTbWKHvvwcl5QjSACST kg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2vqteprrbw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:49:24 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIhkTI148070;
        Tue, 22 Oct 2019 18:49:24 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2vsp400xgv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:49:23 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9MInN3q026753;
        Tue, 22 Oct 2019 18:49:23 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Oct 2019 11:49:21 -0700
Subject: [PATCH 5/7] xfs_scrub: promote some of the str_info to str_error
 calls
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 22 Oct 2019 11:49:20 -0700
Message-ID: <157177016089.1460394.14422501768544972131.stgit@magnolia>
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

Now that str_error is only for runtime errors, we can promote a few of
the str_info calls that report runtime errors to str_error.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/phase1.c |   10 +++++-----
 scrub/scrub.c  |   11 +++++------
 2 files changed, 10 insertions(+), 11 deletions(-)


diff --git a/scrub/phase1.c b/scrub/phase1.c
index d040c4a8..0ae368ff 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -88,7 +88,7 @@ xfs_setup_fs(
 			O_RDONLY | O_NOATIME | O_DIRECTORY);
 	if (error) {
 		if (error == EPERM)
-			str_info(ctx, ctx->mntpoint,
+			str_error(ctx, ctx->mntpoint,
 _("Must be root to run scrub."));
 		else if (error == ENOTTY)
 			str_error(ctx, ctx->mntpoint,
@@ -143,26 +143,26 @@ _("Not an XFS filesystem."));
 	    !xfs_can_scrub_bmap(ctx) || !xfs_can_scrub_dir(ctx) ||
 	    !xfs_can_scrub_attr(ctx) || !xfs_can_scrub_symlink(ctx) ||
 	    !xfs_can_scrub_parent(ctx)) {
-		str_info(ctx, ctx->mntpoint,
+		str_error(ctx, ctx->mntpoint,
 _("Kernel metadata scrubbing facility is not available."));
 		return false;
 	}
 
 	/* Do we need kernel-assisted metadata repair? */
 	if (ctx->mode != SCRUB_MODE_DRY_RUN && !xfs_can_repair(ctx)) {
-		str_info(ctx, ctx->mntpoint,
+		str_error(ctx, ctx->mntpoint,
 _("Kernel metadata repair facility is not available.  Use -n to scrub."));
 		return false;
 	}
 
 	/* Did we find the log and rt devices, if they're present? */
 	if (ctx->mnt.fsgeom.logstart == 0 && ctx->fsinfo.fs_log == NULL) {
-		str_info(ctx, ctx->mntpoint,
+		str_error(ctx, ctx->mntpoint,
 _("Unable to find log device path."));
 		return false;
 	}
 	if (ctx->mnt.fsgeom.rtblocks && ctx->fsinfo.fs_rt == NULL) {
-		str_info(ctx, ctx->mntpoint,
+		str_error(ctx, ctx->mntpoint,
 _("Unable to find realtime device path."));
 		return false;
 	}
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 75a64efa..718f09b8 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -141,7 +141,7 @@ xfs_check_metadata(
 			return CHECK_DONE;
 		case ESHUTDOWN:
 			/* FS already crashed, give up. */
-			str_info(ctx, buf,
+			str_error(ctx, buf,
 _("Filesystem is shut down, aborting."));
 			return CHECK_ABORT;
 		case EIO:
@@ -157,8 +157,7 @@ _("Filesystem is shut down, aborting."));
 			 * The first two should never escape the kernel,
 			 * and the other two should be reported via sm_flags.
 			 */
-			str_info(ctx, buf,
-_("Kernel bug!  errno=%d"), code);
+			str_liberror(ctx, code, _("Kernel bug"));
 			/* fall through */
 		default:
 			/* Operational error. */
@@ -702,7 +701,7 @@ _("Filesystem is busy, deferring repair."));
 			return CHECK_RETRY;
 		case ESHUTDOWN:
 			/* Filesystem is already shut down, abort. */
-			str_info(ctx, buf,
+			str_error(ctx, buf,
 _("Filesystem is shut down, aborting."));
 			return CHECK_ABORT;
 		case ENOTTY:
@@ -733,9 +732,9 @@ _("Don't know how to fix; offline repair required."));
 		case EROFS:
 			/* Read-only filesystem, can't fix. */
 			if (verbose || debug || needs_repair(&oldm))
-				str_info(ctx, buf,
+				str_error(ctx, buf,
 _("Read-only filesystem; cannot make changes."));
-			return CHECK_DONE;
+			return CHECK_ABORT;
 		case ENOENT:
 			/* Metadata not present, just skip it. */
 			return CHECK_DONE;

