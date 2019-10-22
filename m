Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3780CA9EA0
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:53:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 695DD218AE
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:53:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ai2WSorh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbfJVSxM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 14:53:12 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56538 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387791AbfJVSxL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 14:53:11 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiQNa091102;
        Tue, 22 Oct 2019 18:53:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=sP32KWap6/Q1MjZrQ1N69fEN/zoSiRU59w3Tj/CIjxo=;
 b=ai2WSorh6ffUK89hPBMGAjMLo2S+1CgAiQVqneXB7J91TIGD4HmBCUIS0572FsGitkOc
 0yJZlnvjl0Oxc2GiqBdjdf6MOTbS+XH0M2hzR3XbYH4DDFF1xdnvhVmV1g8lyj0HE5JZ
 j+l3PtszeI7A3G7vyE+a70S0cOxepoNIfmW2COUL6oVyHA6TzeuI4W2TwOBu0VeUWOkU
 Js+QCrOutdSFZCporIIvy2Ose7pdWZkqiF/KW9l1yCvamNSddDVg1P4QimpHLpREgkxP
 62re1tr6JonPfqTiXuyKJM2AhTq2rGZ6+Np1V8e+KpobDBGv3Ttj+4WQu62vopFEGiYA +w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2vqteprrxm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:53:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIhotp148304;
        Tue, 22 Oct 2019 18:53:06 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2vsp401b1p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:53:06 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9MIr5Pc028950;
        Tue, 22 Oct 2019 18:53:05 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Oct 2019 11:53:05 -0700
Subject: [PATCH 6/7] libfrog: convert scrub.c functions to negative error
 codes
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Date:   Tue, 22 Oct 2019 11:53:04 -0700
Message-ID: <157177038420.1462916.10509381356508642852.stgit@magnolia>
In-Reply-To: <157177034582.1462916.12588287391821422188.stgit@magnolia>
References: <157177034582.1462916.12588287391821422188.stgit@magnolia>
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

Convert libfrog functions to return negative error codes like libxfs
does.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libfrog/scrub.c |    9 ++-
 scrub/scrub.c   |  196 ++++++++++++++++++++++++++++---------------------------
 2 files changed, 107 insertions(+), 98 deletions(-)


diff --git a/libfrog/scrub.c b/libfrog/scrub.c
index e9671da2..d900bf2a 100644
--- a/libfrog/scrub.c
+++ b/libfrog/scrub.c
@@ -137,10 +137,17 @@ const struct xfrog_scrub_descr xfrog_scrubbers[XFS_SCRUB_TYPE_NR] = {
 	},
 };
 
+/* Invoke the scrub ioctl.  Returns zero or negative error code. */
 int
 xfrog_scrub_metadata(
 	struct xfs_fd			*xfd,
 	struct xfs_scrub_metadata	*meta)
 {
-	return ioctl(xfd->fd, XFS_IOC_SCRUB_METADATA, meta);
+	int				ret;
+
+	ret = ioctl(xfd->fd, XFS_IOC_SCRUB_METADATA, meta);
+	if (ret)
+		return -errno;
+
+	return 0;
 }
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 9aac3737..2885aa34 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -127,7 +127,6 @@ xfs_check_metadata(
 {
 	DEFINE_DESCR(dsc, ctx, format_scrub_descr);
 	unsigned int			tries = 0;
-	int				code;
 	int				error;
 
 	assert(!debug_tweak_on("XFS_SCRUB_NO_KERNEL"));
@@ -136,40 +135,40 @@ xfs_check_metadata(
 
 	dbg_printf("check %s flags %xh\n", descr_render(&dsc), meta->sm_flags);
 retry:
-	error = xfrog_scrub_metadata(&ctx->mnt, meta);
+	error = -xfrog_scrub_metadata(&ctx->mnt, meta);
 	if (debug_tweak_on("XFS_SCRUB_FORCE_REPAIR") && !error)
 		meta->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
-	if (error) {
-		code = errno;
-		switch (code) {
-		case ENOENT:
-			/* Metadata not present, just skip it. */
-			return CHECK_DONE;
-		case ESHUTDOWN:
-			/* FS already crashed, give up. */
-			str_error(ctx, descr_render(&dsc),
+	switch (error) {
+	case 0:
+		/* No operational errors encountered. */
+		break;
+	case ENOENT:
+		/* Metadata not present, just skip it. */
+		return CHECK_DONE;
+	case ESHUTDOWN:
+		/* FS already crashed, give up. */
+		str_error(ctx, descr_render(&dsc),
 _("Filesystem is shut down, aborting."));
-			return CHECK_ABORT;
-		case EIO:
-		case ENOMEM:
-			/* Abort on I/O errors or insufficient memory. */
-			str_errno(ctx, descr_render(&dsc));
-			return CHECK_ABORT;
-		case EDEADLOCK:
-		case EBUSY:
-		case EFSBADCRC:
-		case EFSCORRUPTED:
-			/*
-			 * The first two should never escape the kernel,
-			 * and the other two should be reported via sm_flags.
-			 */
-			str_liberror(ctx, code, _("Kernel bug"));
-			/* fall through */
-		default:
-			/* Operational error. */
-			str_errno(ctx, descr_render(&dsc));
-			return CHECK_DONE;
-		}
+		return CHECK_ABORT;
+	case EIO:
+	case ENOMEM:
+		/* Abort on I/O errors or insufficient memory. */
+		str_errno(ctx, descr_render(&dsc));
+		return CHECK_ABORT;
+	case EDEADLOCK:
+	case EBUSY:
+	case EFSBADCRC:
+	case EFSCORRUPTED:
+		/*
+		 * The first two should never escape the kernel,
+		 * and the other two should be reported via sm_flags.
+		 */
+		str_liberror(ctx, error, _("Kernel bug"));
+		/* fall through */
+	default:
+		/* Operational error. */
+		str_errno(ctx, descr_render(&dsc));
+		return CHECK_DONE;
 	}
 
 	/*
@@ -577,10 +576,10 @@ __xfs_scrub_test(
 	meta.sm_type = type;
 	if (repair)
 		meta.sm_flags |= XFS_SCRUB_IFLAG_REPAIR;
-	error = xfrog_scrub_metadata(&ctx->mnt, &meta);
-	if (!error)
+	error = -xfrog_scrub_metadata(&ctx->mnt, &meta);
+	switch (error) {
+	case 0:
 		return true;
-	switch (errno) {
 	case EROFS:
 		str_info(ctx, ctx->mntpoint,
 _("Filesystem is mounted read-only; cannot proceed."));
@@ -706,74 +705,77 @@ xfs_repair_metadata(
 		str_info(ctx, descr_render(&dsc),
 				_("Attempting optimization."));
 
-	error = xfrog_scrub_metadata(&ctx->mnt, &meta);
-	if (error) {
-		switch (errno) {
-		case EDEADLOCK:
-		case EBUSY:
-			/* Filesystem is busy, try again later. */
-			if (debug || verbose)
-				str_info(ctx, descr_render(&dsc),
+	error = -xfrog_scrub_metadata(&ctx->mnt, &meta);
+	switch (error) {
+	case 0:
+		/* No operational errors encountered. */
+		break;
+	case EDEADLOCK:
+	case EBUSY:
+		/* Filesystem is busy, try again later. */
+		if (debug || verbose)
+			str_info(ctx, descr_render(&dsc),
 _("Filesystem is busy, deferring repair."));
-			return CHECK_RETRY;
-		case ESHUTDOWN:
-			/* Filesystem is already shut down, abort. */
-			str_error(ctx, descr_render(&dsc),
+		return CHECK_RETRY;
+	case ESHUTDOWN:
+		/* Filesystem is already shut down, abort. */
+		str_error(ctx, descr_render(&dsc),
 _("Filesystem is shut down, aborting."));
-			return CHECK_ABORT;
-		case ENOTTY:
-		case EOPNOTSUPP:
-			/*
-			 * If we're in no-complain mode, requeue the check for
-			 * later.  It's possible that an error in another
-			 * component caused us to flag an error in this
-			 * component.  Even if the kernel didn't think it
-			 * could fix this, it's at least worth trying the scan
-			 * again to see if another repair fixed it.
-			 */
-			if (!(repair_flags & XRM_COMPLAIN_IF_UNFIXED))
-				return CHECK_RETRY;
-			/*
-			 * If we forced repairs or this is a preen, don't
-			 * error out if the kernel doesn't know how to fix.
-			 */
-			if (is_unoptimized(&oldm) ||
-			    debug_tweak_on("XFS_SCRUB_FORCE_REPAIR"))
-				return CHECK_DONE;
-			/* fall through */
-		case EINVAL:
-			/* Kernel doesn't know how to repair this? */
-			str_corrupt(ctx, descr_render(&dsc),
-_("Don't know how to fix; offline repair required."));
+		return CHECK_ABORT;
+	case ENOTTY:
+	case EOPNOTSUPP:
+		/*
+		 * If we're in no-complain mode, requeue the check for
+		 * later.  It's possible that an error in another
+		 * component caused us to flag an error in this
+		 * component.  Even if the kernel didn't think it
+		 * could fix this, it's at least worth trying the scan
+		 * again to see if another repair fixed it.
+		 */
+		if (!(repair_flags & XRM_COMPLAIN_IF_UNFIXED))
+			return CHECK_RETRY;
+		/*
+		 * If we forced repairs or this is a preen, don't
+		 * error out if the kernel doesn't know how to fix.
+		 */
+		if (is_unoptimized(&oldm) ||
+		    debug_tweak_on("XFS_SCRUB_FORCE_REPAIR"))
 			return CHECK_DONE;
-		case EROFS:
-			/* Read-only filesystem, can't fix. */
-			if (verbose || debug || needs_repair(&oldm))
-				str_error(ctx, descr_render(&dsc),
+		/* fall through */
+	case EINVAL:
+		/* Kernel doesn't know how to repair this? */
+		str_corrupt(ctx,
+_("%s: Don't know how to fix; offline repair required."),
+				descr_render(&dsc));
+		return CHECK_DONE;
+	case EROFS:
+		/* Read-only filesystem, can't fix. */
+		if (verbose || debug || needs_repair(&oldm))
+			str_error(ctx, descr_render(&dsc),
 _("Read-only filesystem; cannot make changes."));
-			return CHECK_ABORT;
-		case ENOENT:
-			/* Metadata not present, just skip it. */
-			return CHECK_DONE;
-		case ENOMEM:
-		case ENOSPC:
-			/* Don't care if preen fails due to low resources. */
-			if (is_unoptimized(&oldm) && !needs_repair(&oldm))
-				return CHECK_DONE;
-			/* fall through */
-		default:
-			/*
-			 * Operational error.  If the caller doesn't want us
-			 * to complain about repair failures, tell the caller
-			 * to requeue the repair for later and don't say a
-			 * thing.  Otherwise, print error and bail out.
-			 */
-			if (!(repair_flags & XRM_COMPLAIN_IF_UNFIXED))
-				return CHECK_RETRY;
-			str_errno(ctx, descr_render(&dsc));
+		return CHECK_ABORT;
+	case ENOENT:
+		/* Metadata not present, just skip it. */
+		return CHECK_DONE;
+	case ENOMEM:
+	case ENOSPC:
+		/* Don't care if preen fails due to low resources. */
+		if (is_unoptimized(&oldm) && !needs_repair(&oldm))
 			return CHECK_DONE;
-		}
+		/* fall through */
+	default:
+		/*
+		 * Operational error.  If the caller doesn't want us
+		 * to complain about repair failures, tell the caller
+		 * to requeue the repair for later and don't say a
+		 * thing.  Otherwise, print error and bail out.
+		 */
+		if (!(repair_flags & XRM_COMPLAIN_IF_UNFIXED))
+			return CHECK_RETRY;
+		str_liberror(ctx, error, descr_render(&dsc));
+		return CHECK_DONE;
 	}
+
 	if (repair_flags & XRM_COMPLAIN_IF_UNFIXED)
 		xfs_scrub_warn_incomplete_scrub(ctx, &dsc, &meta);
 	if (needs_repair(&meta)) {

