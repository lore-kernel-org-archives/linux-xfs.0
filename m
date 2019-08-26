Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2D45C3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:32:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 86E5D2186A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:32:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hwDY2dIm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729008AbfHZVcx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:32:53 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52506 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728677AbfHZVcw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:32:52 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLF5Kc162141;
        Mon, 26 Aug 2019 21:32:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=yaGs/ds5kGsBhKNyMcNeVXrSonrxhIWbpirdQkKTD3s=;
 b=hwDY2dImANy2mjwGZgM08nX6dmTqYK43bV5k8cLyRDogQDApD1JCIY73Ci0jKWw2WgDG
 XsqhJEidNlGNDlIsEavcvSvwhQpEvu3QPoHkBJtAoYduTIHTuETf1B2Dp5Fg9/ckH03S
 qccdtFaFSXxzJnIfwM0InrSNTH/cKgysoi45hrkuh1caXjjGJ4vcNkmNGHeiA1dqnsft
 T9W5UHZrc5yAq8g5XDZAwDdqheB8x+YD9a0te/yaxkUlGZsyLhqZG/f7pX6i3VRV48TS
 fV4FlTgUyf7/41uJuahlODlA8dhFqh0pcvrhP5gNiKWzSbMNzRZz4KAnOkTwsj+Ls/IM 0A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2umq5t82ke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:32:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLIPic170109;
        Mon, 26 Aug 2019 21:32:49 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2umj278bbu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:32:49 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7QLWmYn030617;
        Mon, 26 Aug 2019 21:32:48 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:32:48 -0700
Subject: [PATCH 3/3] xfs_scrub: adapt phase5 to deferred descriptions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:32:47 -0700
Message-ID: <156685516698.2843450.5657240622652218872.stgit@magnolia>
In-Reply-To: <156685514116.2843450.13345990837227741560.stgit@magnolia>
References: <156685514116.2843450.13345990837227741560.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260198
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260198
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
index d90b4028..0ed48122 100644
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
+scrub_render_ino(
+	struct scrub_ctx	*ctx,
+	char			*buf,
+	size_t			buflen,
+	void			*data)
+{
+	struct xfs_bstat	*bstat = data;
+
+	return xfs_scrub_render_ino(ctx, buf, buflen, bstat->bs_ino,
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
+	DEFINE_DESCR(dsc, ctx, scrub_render_ino);
 	bool			moveon = true;
 	int			fd = -1;
 	int			error;
 
-	xfs_scrub_render_ino(ctx, descr, DESCR_BUFSZ, bstat->bs_ino,
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
index 3ae91327..149e3b2d 100644
--- a/scrub/unicrash.c
+++ b/scrub/unicrash.c
@@ -16,6 +16,7 @@
 #include "path.h"
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

