Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25F30C432C2
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:39:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E20E620872
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:39:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="k06dm4NE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728686AbfIYVja (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:39:30 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35574 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728253AbfIYVja (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:39:30 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLdQqF058428;
        Wed, 25 Sep 2019 21:39:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=QuZ5jJze+dPMCHOmV0dOrdu2sXxSS+VT9PxAf8ss/kI=;
 b=k06dm4NE48U3hjhMSFdc4WglEtVDyE4gcspbMNCLqbY0UZVCFU4JexhZVKOXOdjeq6LY
 imUWFpe2ZHkGcnlPXskQUqymxUJNfb0Mbx8gtBvZWtCpX0GyCxKhiEq4ZB2MYYPLQAue
 rpIRhdybT3g952GSGiWJglFJWFAkELoQdYUoV11lOBkdNrIAdl15cALEICfOAfBTfLyo
 PkF9W6FBkaYDlixLTwaLENSPz3T7pDXl0o4yHNuG2h42tr8GmZ9+2GjJ3rVAL3sHKi7E
 ZWUlqjhRukZhQMBXkQltKtBhX7Bq3IJ7HvDs70MUxCycgQ0+m6sgzG7o2qGccm9mtBdV ag== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2v5cgr7fee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:39:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLdQZK033878;
        Wed, 25 Sep 2019 21:39:26 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2v7vnyuvph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:39:25 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8PLdKSO018913;
        Wed, 25 Sep 2019 21:39:20 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:39:19 -0700
Subject: [PATCH 12/18] xfs_scrub: remove moveon from phase 5 functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Sep 2019 14:39:18 -0700
Message-ID: <156944755841.301514.5932606543618134345.stgit@magnolia>
In-Reply-To: <156944748487.301514.14685083474028866113.stgit@magnolia>
References: <156944748487.301514.14685083474028866113.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250175
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250175
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Replace the moveon returns in the phase 5 code with a direct integer
error return.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/phase5.c |  184 ++++++++++++++++++++++++++++++--------------------------
 1 file changed, 97 insertions(+), 87 deletions(-)


diff --git a/scrub/phase5.c b/scrub/phase5.c
index cb79752f..1aaa0086 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -31,9 +31,11 @@
  * terminal control characters and escape sequences, since that could be used
  * to do something naughty to the user's computer and/or break scripts.  XFS
  * doesn't consider any byte sequence invalid, so don't flag these as errors.
+ *
+ * Returns 0 for success or -1 for error.  This function logs errors.
  */
-static bool
-xfs_scrub_check_name(
+static int
+simple_check_name(
 	struct scrub_ctx	*ctx,
 	struct descr		*dsc,
 	const char		*namedescr,
@@ -46,7 +48,7 @@ xfs_scrub_check_name(
 	/* Complain about zero length names. */
 	if (*name == '\0' && should_warn_about_name(ctx)) {
 		str_warn(ctx, descr_render(dsc), _("Zero length name found."));
-		return true;
+		return 0;
 	}
 
 	/* control characters */
@@ -61,7 +63,7 @@ xfs_scrub_check_name(
 		errname = string_escape(name);
 		if (!errname) {
 			str_errno(ctx, descr_render(dsc));
-			return false;
+			return -1;
 		}
 		str_info(ctx, descr_render(dsc),
 _("Control character found in %s name \"%s\"."),
@@ -69,15 +71,15 @@ _("Control character found in %s name \"%s\"."),
 		free(errname);
 	}
 
-	return true;
+	return 0;
 }
 
 /*
  * Iterate a directory looking for filenames with problematic
  * characters.
  */
-static bool
-xfs_scrub_scan_dirents(
+static int
+check_dirent_names(
 	struct scrub_ctx	*ctx,
 	struct descr		*dsc,
 	int			*fd,
@@ -86,45 +88,45 @@ xfs_scrub_scan_dirents(
 	struct unicrash		*uc = NULL;
 	DIR			*dir;
 	struct dirent		*dentry;
-	bool			moveon = true;
 	int			ret;
 
 	dir = fdopendir(*fd);
 	if (!dir) {
 		str_errno(ctx, descr_render(dsc));
-		moveon = false;
-		goto out;
+		return errno;
 	}
 	*fd = -1; /* closedir will close *fd for us */
 
 	ret = unicrash_dir_init(&uc, ctx, bstat);
 	if (ret) {
 		str_liberror(ctx, ret, descr_render(dsc));
-		moveon = false;
 		goto out_unicrash;
 	}
 
+	errno = 0;
 	dentry = readdir(dir);
 	while (dentry) {
-		if (uc) {
+		if (uc)
 			ret = unicrash_check_dir_name(uc, dsc, dentry);
-			if (ret) {
-				str_liberror(ctx, ret, descr_render(dsc));
-				moveon = false;
-			}
-		} else
-			moveon = xfs_scrub_check_name(ctx, dsc,
-					_("directory"), dentry->d_name);
-		if (!moveon)
+		else
+			ret = simple_check_name(ctx, dsc, _("directory"),
+					dentry->d_name);
+		if (ret) {
+			str_liberror(ctx, ret, descr_render(dsc));
 			break;
+		}
+		errno = 0;
 		dentry = readdir(dir);
 	}
+	if (errno) {
+		ret = errno;
+		str_liberror(ctx, ret, descr_render(dsc));
+	}
 	unicrash_free(uc);
 
 out_unicrash:
 	closedir(dir);
-out:
-	return moveon;
+	return ret;
 }
 
 #ifdef HAVE_LIBATTR
@@ -145,8 +147,8 @@ static const struct attrns_decode attr_ns[] = {
  * Check all the xattr names in a particular namespace of a file handle
  * for Unicode normalization problems or collisions.
  */
-static bool
-xfs_scrub_scan_fhandle_namespace_xattrs(
+static int
+check_xattr_ns_names(
 	struct scrub_ctx		*ctx,
 	struct descr			*dsc,
 	struct xfs_handle		*handle,
@@ -159,14 +161,13 @@ xfs_scrub_scan_fhandle_namespace_xattrs(
 	struct attrlist			*attrlist = (struct attrlist *)attrbuf;
 	struct attrlist_ent		*ent;
 	struct unicrash			*uc = NULL;
-	bool				moveon = true;
 	int				i;
 	int				error;
 
 	error = unicrash_xattr_init(&uc, ctx, bstat);
 	if (error) {
 		str_liberror(ctx, error, descr_render(dsc));
-		return false;
+		return error;
 	}
 
 	memset(attrbuf, 0, XFS_XATTR_LIST_MAX);
@@ -180,20 +181,17 @@ xfs_scrub_scan_fhandle_namespace_xattrs(
 			ent = ATTR_ENTRY(attrlist, i);
 			snprintf(keybuf, XATTR_NAME_MAX, "%s.%s", attr_ns->name,
 					ent->a_name);
-			if (uc) {
+			if (uc)
 				error = unicrash_check_xattr_name(uc, dsc,
 						keybuf);
-				if (error) {
-					str_liberror(ctx, error,
-							descr_render(dsc));
-					moveon = false;
-				}
-			} else
-				moveon = xfs_scrub_check_name(ctx, dsc,
+			else
+				error = simple_check_name(ctx, dsc,
 						_("extended attribute"),
 						keybuf);
-			if (!moveon)
+			if (error) {
+				str_liberror(ctx, error, descr_render(dsc));
 				goto out;
+			}
 		}
 
 		if (!attrlist->al_more)
@@ -201,37 +199,40 @@ xfs_scrub_scan_fhandle_namespace_xattrs(
 		error = attr_list_by_handle(handle, sizeof(*handle), attrbuf,
 				XFS_XATTR_LIST_MAX, attr_ns->flags, &cur);
 	}
-	if (error && errno != ESTALE)
-		str_errno(ctx, descr_render(dsc));
+	if (error) {
+		if (errno == ESTALE)
+			errno = 0;
+		if (errno)
+			str_errno(ctx, descr_render(dsc));
+	}
 out:
 	unicrash_free(uc);
-	return moveon;
+	return error;
 }
 
 /*
  * Check all the xattr names in all the xattr namespaces for problematic
  * characters.
  */
-static bool
-xfs_scrub_scan_fhandle_xattrs(
+static int
+check_xattr_names(
 	struct scrub_ctx		*ctx,
 	struct descr			*dsc,
 	struct xfs_handle		*handle,
 	struct xfs_bulkstat		*bstat)
 {
 	const struct attrns_decode	*ns;
-	bool				moveon = true;
+	int				ret;
 
 	for (ns = attr_ns; ns->name; ns++) {
-		moveon = xfs_scrub_scan_fhandle_namespace_xattrs(ctx, dsc,
-				handle, bstat, ns);
-		if (!moveon)
+		ret = check_xattr_ns_names(ctx, dsc, handle, bstat, ns);
+		if (ret)
 			break;
 	}
-	return moveon;
+	return ret;
 }
 #else
-# define xfs_scrub_scan_fhandle_xattrs(c, d, h, b)	(true)
+# define check_xattr_names(c, d, h, b)	(0)
 #endif /* HAVE_LIBATTR */
 
 static int
@@ -255,26 +256,25 @@ render_ino_from_handle(
  * Check for potential Unicode collisions in names.
  */
 static int
-xfs_scrub_connections(
+check_inode_names(
 	struct scrub_ctx	*ctx,
 	struct xfs_handle	*handle,
 	struct xfs_bulkstat	*bstat,
 	void			*arg)
 {
-	bool			*pmoveon = arg;
 	DEFINE_DESCR(dsc, ctx, render_ino_from_handle);
-	bool			moveon = true;
+	bool			*aborted = arg;
 	int			fd = -1;
-	int			error;
+	int			error = 0;
+	int			err2;
 
 	descr_set(&dsc, bstat);
 	background_sleep();
 
 	/* Warn about naming problems in xattrs. */
 	if (bstat->bs_xflags & FS_XFLAG_HASATTR) {
-		moveon = xfs_scrub_scan_fhandle_xattrs(ctx, &dsc, handle,
-				bstat);
-		if (!moveon)
+		error = check_xattr_names(ctx, &dsc, handle, bstat);
+		if (error)
 			goto out;
 	}
 
@@ -282,7 +282,8 @@ xfs_scrub_connections(
 	if (S_ISDIR(bstat->bs_mode)) {
 		fd = scrub_open_handle(handle);
 		if (fd < 0) {
-			if (errno == ESTALE)
+			error = errno;
+			if (error == ESTALE)
 				return ESTALE;
 			str_errno(ctx, descr_render(&dsc));
 			goto out;
@@ -291,21 +292,27 @@ xfs_scrub_connections(
 
 	/* Warn about naming problems in the directory entries. */
 	if (fd >= 0 && S_ISDIR(bstat->bs_mode)) {
-		moveon = xfs_scrub_scan_dirents(ctx, &dsc, &fd, bstat);
-		if (!moveon)
+		error = check_dirent_names(ctx, &dsc, &fd, bstat);
+		if (error)
 			goto out;
 	}
 
 out:
 	progress_add(1);
 	if (fd >= 0) {
-		error = close(fd);
-		if (error)
+		err2 = close(fd);
+		if (err2)
 			str_errno(ctx, descr_render(&dsc));
+		if (!error && err2)
+			error = err2;
 	}
-	if (!moveon)
-		*pmoveon = false;
-	return *pmoveon ? 0 : XFS_ITERATE_INODES_ABORT;
+
+	if (error)
+		*aborted = true;
+	if (!error && *aborted)
+		error = ECANCELED;
+
+	return error;
 }
 
 #ifndef FS_IOC_GETFSLABEL
@@ -327,20 +334,19 @@ scrub_render_mountpoint(
  * Check the filesystem label for Unicode normalization problems or misleading
  * sequences.
  */
-static bool
-xfs_scrub_fs_label(
+static int
+check_fs_label(
 	struct scrub_ctx		*ctx)
 {
 	DEFINE_DESCR(dsc, ctx, scrub_render_mountpoint);
 	char				label[FSLABEL_MAX];
 	struct unicrash			*uc = NULL;
-	bool				moveon = true;
 	int				error;
 
 	error = unicrash_fs_label_init(&uc, ctx);
 	if (error) {
 		str_liberror(ctx, error, descr_render(&dsc));
-		return false;
+		return error;
 	}
 
 	descr_set(&dsc, NULL);
@@ -349,7 +355,7 @@ xfs_scrub_fs_label(
 	error = ioctl(ctx->mnt.fd, FS_IOC_GETFSLABEL, &label);
 	if (error) {
 		if (errno != EOPNOTSUPP && errno != ENOTTY) {
-			moveon = false;
+			error = errno;
 			perror(ctx->mntpoint);
 		}
 		goto out;
@@ -360,45 +366,49 @@ xfs_scrub_fs_label(
 		goto out;
 
 	/* Otherwise check for weirdness. */
-	if (uc) {
+	if (uc)
 		error = unicrash_check_fs_label(uc, &dsc, label);
-		if (error) {
-			str_liberror(ctx, error, descr_render(&dsc));
-			moveon = false;
-		}
-	} else
-		moveon = xfs_scrub_check_name(ctx, &dsc, _("filesystem label"),
+	else
+		error = simple_check_name(ctx, &dsc, _("filesystem label"),
 				label);
-	if (!moveon)
-		goto out;
+	if (error)
+		str_liberror(ctx, error, descr_render(&dsc));
 out:
 	unicrash_free(uc);
-	return moveon;
+	return error;
 }
 
 /* Check directory connectivity. */
-bool
-xfs_scan_connections(
+int
+phase5_func(
 	struct scrub_ctx	*ctx)
 {
-	bool			moveon = true;
+	bool			aborted = false;
 	int			ret;
 
 	if (ctx->errors_found || ctx->unfixable_errors) {
 		str_info(ctx, ctx->mntpoint,
 _("Filesystem has errors, skipping connectivity checks."));
-		return true;
+		return 0;
 	}
 
-	ret = xfs_scrub_fs_label(ctx);
+	ret = check_fs_label(ctx);
 	if (ret)
-		return false;
+		return ret;
 
-	ret = scrub_scan_all_inodes(ctx, xfs_scrub_connections, &moveon);
+	ret = scrub_scan_all_inodes(ctx, check_inode_names, &aborted);
 	if (ret)
-		return false;
-	if (!moveon)
-		return false;
+		return ret;
+	if (aborted)
+		return ECANCELED;
+
 	xfs_scrub_report_preen_triggers(ctx);
-	return true;
+	return 0;
+}
+
+bool
+xfs_scan_connections(
+	struct scrub_ctx	*ctx)
+{
+	return phase5_func(ctx) == 0;
 }

