Return-Path: <SRS0=UMh5=XB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A06EC43331
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:40:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02CAC206B8
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:40:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="B3MDtrmF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392161AbfIFDkf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 23:40:35 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53766 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731630AbfIFDkf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 23:40:35 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863duZD113460;
        Fri, 6 Sep 2019 03:40:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=dQxyOB1+lShAZlXcGG0xyatMdWKNAWx0w4R+TFT87Uc=;
 b=B3MDtrmF+yTOvh92mUaOxXAyU8rziaH0/eSfCM2ymWqHGnFp+xgGbd9PoaI7R/b2CawS
 l+MkGDR1YrrNmiJ4NtgC5ADEUnIDJD0dBS+BF8bzdIdoidwC6uKZwHfSLLqW5WzIHS7m
 1VIv7yQcLXKmxHejNpypi2JBjv/mWAn+khJInI35iCDZwm3J8E9qPclmy85/HtrQ+ywB
 kuLdDfz0TlHCWcWRVK/q/+D2UsxgENTpP/r0JY6NBV5bn2omBYtvNQ2kXfJvG7zigmzQ
 iziYHbB/zGC1HbeKnAcLcuqQrud7tLAHQbFex6rK0cdZdKc3JI3Q22owQy40tfEli/Dy 7g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2uufr0802q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:40:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863dISc112883;
        Fri, 6 Sep 2019 03:40:31 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2uud7p2tch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:40:31 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x863eUeA016867;
        Fri, 6 Sep 2019 03:40:30 GMT
Received: from localhost (/10.159.148.70)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 20:40:30 -0700
Subject: [PATCH 3/3] xfs_scrub: adapt phase5 to deferred descriptions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 Sep 2019 20:40:29 -0700
Message-ID: <156774122959.2646601.9272131819485633925.stgit@magnolia>
In-Reply-To: <156774120780.2646601.13902985397309977000.stgit@magnolia>
References: <156774120780.2646601.13902985397309977000.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
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

Apply the deferred description mechanism to phase 5 so that we don't
build inode prefix strings unless we actually want to say something
about an inode's attributes or directory entries.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/phase5.c   |   74 ++++++++++++++++++++++++++++++++++++------------------
 scrub/unicrash.c |   31 ++++++++++++-----------
 scrub/unicrash.h |    6 ++--
 3 files changed, 69 insertions(+), 42 deletions(-)


diff --git a/scrub/phase5.c b/scrub/phase5.c
index 30346fc1..18056afd 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -21,6 +21,7 @@
 #include "inodes.h"
 #include "progress.h"
 #include "scrub.h"
+#include "descr.h"
 #include "unicrash.h"
 
 /* Phase 5: Check directory connectivity. */
@@ -34,7 +35,7 @@
 static bool
 xfs_scrub_check_name(
 	struct scrub_ctx	*ctx,
-	const char		*descr,
+	struct descr		*dsc,
 	const char		*namedescr,
 	const char		*name)
 {
@@ -44,7 +45,7 @@ xfs_scrub_check_name(
 
 	/* Complain about zero length names. */
 	if (*name == '\0' && should_warn_about_name(ctx)) {
-		str_warn(ctx, descr, _("Zero length name found."));
+		str_warn(ctx, descr_render(dsc), _("Zero length name found."));
 		return true;
 	}
 
@@ -59,10 +60,10 @@ xfs_scrub_check_name(
 	if (bad && should_warn_about_name(ctx)) {
 		errname = string_escape(name);
 		if (!errname) {
-			str_errno(ctx, descr);
+			str_errno(ctx, descr_render(dsc));
 			return false;
 		}
-		str_info(ctx, descr,
+		str_info(ctx, descr_render(dsc),
 _("Control character found in %s name \"%s\"."),
 				namedescr, errname);
 		free(errname);
@@ -78,7 +79,7 @@ _("Control character found in %s name \"%s\"."),
 static bool
 xfs_scrub_scan_dirents(
 	struct scrub_ctx	*ctx,
-	const char		*descr,
+	struct descr		*dsc,
 	int			*fd,
 	struct xfs_bulkstat	*bstat)
 {
@@ -89,7 +90,7 @@ xfs_scrub_scan_dirents(
 
 	dir = fdopendir(*fd);
 	if (!dir) {
-		str_errno(ctx, descr);
+		str_errno(ctx, descr_render(dsc));
 		goto out;
 	}
 	*fd = -1; /* closedir will close *fd for us */
@@ -101,9 +102,9 @@ xfs_scrub_scan_dirents(
 	dentry = readdir(dir);
 	while (dentry) {
 		if (uc)
-			moveon = unicrash_check_dir_name(uc, descr, dentry);
+			moveon = unicrash_check_dir_name(uc, dsc, dentry);
 		else
-			moveon = xfs_scrub_check_name(ctx, descr,
+			moveon = xfs_scrub_check_name(ctx, dsc,
 					_("directory"), dentry->d_name);
 		if (!moveon)
 			break;
@@ -138,7 +139,7 @@ static const struct attrns_decode attr_ns[] = {
 static bool
 xfs_scrub_scan_fhandle_namespace_xattrs(
 	struct scrub_ctx		*ctx,
-	const char			*descr,
+	struct descr			*dsc,
 	struct xfs_handle		*handle,
 	struct xfs_bulkstat		*bstat,
 	const struct attrns_decode	*attr_ns)
@@ -169,10 +170,10 @@ xfs_scrub_scan_fhandle_namespace_xattrs(
 			snprintf(keybuf, XATTR_NAME_MAX, "%s.%s", attr_ns->name,
 					ent->a_name);
 			if (uc)
-				moveon = unicrash_check_xattr_name(uc, descr,
+				moveon = unicrash_check_xattr_name(uc, dsc,
 						keybuf);
 			else
-				moveon = xfs_scrub_check_name(ctx, descr,
+				moveon = xfs_scrub_check_name(ctx, dsc,
 						_("extended attribute"),
 						keybuf);
 			if (!moveon)
@@ -185,7 +186,7 @@ xfs_scrub_scan_fhandle_namespace_xattrs(
 				XFS_XATTR_LIST_MAX, attr_ns->flags, &cur);
 	}
 	if (error && errno != ESTALE)
-		str_errno(ctx, descr);
+		str_errno(ctx, descr_render(dsc));
 out:
 	unicrash_free(uc);
 	return moveon;
@@ -198,7 +199,7 @@ xfs_scrub_scan_fhandle_namespace_xattrs(
 static bool
 xfs_scrub_scan_fhandle_xattrs(
 	struct scrub_ctx		*ctx,
-	const char			*descr,
+	struct descr			*dsc,
 	struct xfs_handle		*handle,
 	struct xfs_bulkstat		*bstat)
 {
@@ -206,7 +207,7 @@ xfs_scrub_scan_fhandle_xattrs(
 	bool				moveon = true;
 
 	for (ns = attr_ns; ns->name; ns++) {
-		moveon = xfs_scrub_scan_fhandle_namespace_xattrs(ctx, descr,
+		moveon = xfs_scrub_scan_fhandle_namespace_xattrs(ctx, dsc,
 				handle, bstat, ns);
 		if (!moveon)
 			break;
@@ -217,6 +218,19 @@ xfs_scrub_scan_fhandle_xattrs(
 # define xfs_scrub_scan_fhandle_xattrs(c, d, h, b)	(true)
 #endif /* HAVE_LIBATTR */
 
+static int
+render_ino_from_handle(
+	struct scrub_ctx	*ctx,
+	char			*buf,
+	size_t			buflen,
+	void			*data)
+{
+	struct xfs_bstat	*bstat = data;
+
+	return scrub_render_ino(ctx, buf, buflen, bstat->bs_ino,
+			bstat->bs_gen);
+}
+
 /*
  * Verify the connectivity of the directory tree.
  * We know that the kernel's open-by-handle function will try to reconnect
@@ -232,18 +246,17 @@ xfs_scrub_connections(
 	void			*arg)
 {
 	bool			*pmoveon = arg;
-	char			descr[DESCR_BUFSZ];
+	DEFINE_DESCR(dsc, ctx, render_ino_from_handle);
 	bool			moveon = true;
 	int			fd = -1;
 	int			error;
 
-	scrub_render_ino(ctx, descr, DESCR_BUFSZ, bstat->bs_ino,
-			bstat->bs_gen);
+	descr_set(&dsc, bstat);
 	background_sleep();
 
 	/* Warn about naming problems in xattrs. */
 	if (bstat->bs_xflags & FS_XFLAG_HASATTR) {
-		moveon = xfs_scrub_scan_fhandle_xattrs(ctx, descr, handle,
+		moveon = xfs_scrub_scan_fhandle_xattrs(ctx, &dsc, handle,
 				bstat);
 		if (!moveon)
 			goto out;
@@ -255,14 +268,14 @@ xfs_scrub_connections(
 		if (fd < 0) {
 			if (errno == ESTALE)
 				return ESTALE;
-			str_errno(ctx, descr);
+			str_errno(ctx, descr_render(&dsc));
 			goto out;
 		}
 	}
 
 	/* Warn about naming problems in the directory entries. */
 	if (fd >= 0 && S_ISDIR(bstat->bs_mode)) {
-		moveon = xfs_scrub_scan_dirents(ctx, descr, &fd, bstat);
+		moveon = xfs_scrub_scan_dirents(ctx, &dsc, &fd, bstat);
 		if (!moveon)
 			goto out;
 	}
@@ -272,7 +285,7 @@ xfs_scrub_connections(
 	if (fd >= 0) {
 		error = close(fd);
 		if (error)
-			str_errno(ctx, descr);
+			str_errno(ctx, descr_render(&dsc));
 	}
 	if (!moveon)
 		*pmoveon = false;
@@ -284,6 +297,16 @@ xfs_scrub_connections(
 # define FS_IOC_GETFSLABEL	_IOR(0x94, 49, char[FSLABEL_MAX])
 #endif /* FS_IOC_GETFSLABEL */
 
+static int
+scrub_render_mountpoint(
+	struct scrub_ctx	*ctx,
+	char			*buf,
+	size_t			buflen,
+	void			*data)
+{
+	return snprintf(buf, buflen, _("%s"), ctx->mntpoint);
+}
+
 /*
  * Check the filesystem label for Unicode normalization problems or misleading
  * sequences.
@@ -292,6 +315,7 @@ static bool
 xfs_scrub_fs_label(
 	struct scrub_ctx		*ctx)
 {
+	DEFINE_DESCR(dsc, ctx, scrub_render_mountpoint);
 	char				label[FSLABEL_MAX];
 	struct unicrash			*uc = NULL;
 	bool				moveon = true;
@@ -301,6 +325,8 @@ xfs_scrub_fs_label(
 	if (!moveon)
 		return false;
 
+	descr_set(&dsc, NULL);
+
 	/* Retrieve label; quietly bail if we don't support that. */
 	error = ioctl(ctx->mnt.fd, FS_IOC_GETFSLABEL, &label);
 	if (error) {
@@ -317,10 +343,10 @@ xfs_scrub_fs_label(
 
 	/* Otherwise check for weirdness. */
 	if (uc)
-		moveon = unicrash_check_fs_label(uc, ctx->mntpoint, label);
+		moveon = unicrash_check_fs_label(uc, &dsc, label);
 	else
-		moveon = xfs_scrub_check_name(ctx, ctx->mntpoint,
-				_("filesystem label"), label);
+		moveon = xfs_scrub_check_name(ctx, &dsc, _("filesystem label"),
+				label);
 	if (!moveon)
 		goto out;
 out:
diff --git a/scrub/unicrash.c b/scrub/unicrash.c
index b02c5658..9b619c02 100644
--- a/scrub/unicrash.c
+++ b/scrub/unicrash.c
@@ -16,6 +16,7 @@
 #include "libfrog/paths.h"
 #include "xfs_scrub.h"
 #include "common.h"
+#include "descr.h"
 #include "unicrash.h"
 
 /*
@@ -501,7 +502,7 @@ unicrash_free(
 static void
 unicrash_complain(
 	struct unicrash		*uc,
-	const char		*descr,
+	struct descr		*dsc,
 	const char		*what,
 	struct name_entry	*entry,
 	unsigned int		badflags,
@@ -520,7 +521,7 @@ unicrash_complain(
 	 * that makes "hig<rtl>gnp.sh" render like "highs.png".
 	 */
 	if (badflags & UNICRASH_BIDI_OVERRIDE) {
-		str_warn(uc->ctx, descr,
+		str_warn(uc->ctx, descr_render(dsc),
 _("Unicode name \"%s\" in %s contains suspicious text direction overrides."),
 				bad1, what);
 		goto out;
@@ -533,7 +534,7 @@ _("Unicode name \"%s\" in %s contains suspicious text direction overrides."),
 	 * sequences, but they both appear as "café".
 	 */
 	if (badflags & UNICRASH_NOT_UNIQUE) {
-		str_warn(uc->ctx, descr,
+		str_warn(uc->ctx, descr_render(dsc),
 _("Unicode name \"%s\" in %s renders identically to \"%s\"."),
 				bad1, what, bad2);
 		goto out;
@@ -546,7 +547,7 @@ _("Unicode name \"%s\" in %s renders identically to \"%s\"."),
 	 */
 	if ((badflags & UNICRASH_ZERO_WIDTH) &&
 	    (badflags & UNICRASH_CONFUSABLE)) {
-		str_warn(uc->ctx, descr,
+		str_warn(uc->ctx, descr_render(dsc),
 _("Unicode name \"%s\" in %s could be confused with '%s' due to invisible characters."),
 				bad1, what, bad2);
 		goto out;
@@ -557,7 +558,7 @@ _("Unicode name \"%s\" in %s could be confused with '%s' due to invisible charac
 	 * invisibly in filechooser UIs.
 	 */
 	if (badflags & UNICRASH_CONTROL_CHAR) {
-		str_warn(uc->ctx, descr,
+		str_warn(uc->ctx, descr_render(dsc),
 _("Unicode name \"%s\" in %s contains control characters."),
 				bad1, what);
 		goto out;
@@ -579,7 +580,7 @@ _("Unicode name \"%s\" in %s contains control characters."),
 	 * warn about this too loudly.
 	 */
 	if (badflags & UNICRASH_BIDI_MIXED) {
-		str_info(uc->ctx, descr,
+		str_info(uc->ctx, descr_render(dsc),
 _("Unicode name \"%s\" in %s mixes bidirectional characters."),
 				bad1, what);
 		goto out;
@@ -592,7 +593,7 @@ _("Unicode name \"%s\" in %s mixes bidirectional characters."),
 	 * and "moo.l" look the same, maybe they do not.
 	 */
 	if (badflags & UNICRASH_CONFUSABLE) {
-		str_info(uc->ctx, descr,
+		str_info(uc->ctx, descr_render(dsc),
 _("Unicode name \"%s\" in %s could be confused with \"%s\"."),
 				bad1, what, bad2);
 	}
@@ -653,7 +654,7 @@ unicrash_add(
 static bool
 __unicrash_check_name(
 	struct unicrash		*uc,
-	const char		*descr,
+	struct descr		*dsc,
 	const char		*namedescr,
 	const char		*name,
 	xfs_ino_t		ino)
@@ -674,7 +675,7 @@ __unicrash_check_name(
 		return false;
 
 	if (badflags)
-		unicrash_complain(uc, descr, namedescr, new_entry, badflags,
+		unicrash_complain(uc, dsc, namedescr, new_entry, badflags,
 				dup_entry);
 
 	return true;
@@ -684,12 +685,12 @@ __unicrash_check_name(
 bool
 unicrash_check_dir_name(
 	struct unicrash		*uc,
-	const char		*descr,
+	struct descr		*dsc,
 	struct dirent		*dentry)
 {
 	if (!uc)
 		return true;
-	return __unicrash_check_name(uc, descr, _("directory"),
+	return __unicrash_check_name(uc, dsc, _("directory"),
 			dentry->d_name, dentry->d_ino);
 }
 
@@ -700,12 +701,12 @@ unicrash_check_dir_name(
 bool
 unicrash_check_xattr_name(
 	struct unicrash		*uc,
-	const char		*descr,
+	struct descr		*dsc,
 	const char		*attrname)
 {
 	if (!uc)
 		return true;
-	return __unicrash_check_name(uc, descr, _("extended attribute"),
+	return __unicrash_check_name(uc, dsc, _("extended attribute"),
 			attrname, 0);
 }
 
@@ -715,11 +716,11 @@ unicrash_check_xattr_name(
 bool
 unicrash_check_fs_label(
 	struct unicrash		*uc,
-	const char		*descr,
+	struct descr		*dsc,
 	const char		*label)
 {
 	if (!uc)
 		return true;
-	return __unicrash_check_name(uc, descr, _("filesystem label"),
+	return __unicrash_check_name(uc, dsc, _("filesystem label"),
 			label, 0);
 }
diff --git a/scrub/unicrash.h b/scrub/unicrash.h
index feb9cc86..af96b230 100644
--- a/scrub/unicrash.h
+++ b/scrub/unicrash.h
@@ -19,11 +19,11 @@ bool unicrash_xattr_init(struct unicrash **ucp, struct scrub_ctx *ctx,
 		struct xfs_bulkstat *bstat);
 bool unicrash_fs_label_init(struct unicrash **ucp, struct scrub_ctx *ctx);
 void unicrash_free(struct unicrash *uc);
-bool unicrash_check_dir_name(struct unicrash *uc, const char *descr,
+bool unicrash_check_dir_name(struct unicrash *uc, struct descr *dsc,
 		struct dirent *dirent);
-bool unicrash_check_xattr_name(struct unicrash *uc, const char *descr,
+bool unicrash_check_xattr_name(struct unicrash *uc, struct descr *dsc,
 		const char *attrname);
-bool unicrash_check_fs_label(struct unicrash *uc, const char *descr,
+bool unicrash_check_fs_label(struct unicrash *uc, struct descr *dsc,
 		const char *label);
 #else
 # define unicrash_dir_init(u, c, b)		(true)

