Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B570C636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:04:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbjBPVEy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:04:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230109AbjBPVEs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:04:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 600D02B632
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 13:04:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ECCD6B8217A
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 21:04:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8969C433D2;
        Thu, 16 Feb 2023 21:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581484;
        bh=n1YAAIYrvV7Ft+r5eO7KXcc7ydAFK4MBbg4r3ccjOII=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=illw3zfYeV7YIMF3PhmhH2hv4G0OXnvMfCqVDs7WFNoKCiIcG02cb82ag2HwwdXeM
         H/x9a5orAgaAwKbjhIPnmafiWSiM13adjHFxlqSTUK+l4JRkmkn1z9/GCinq6KR01g
         7WpxfywwW/7ndpFiIr7QiSxywoZWKY5GiGLnSqSlsu9tHPX+nBInYmY3oc2zUsIhvN
         Uas++O193UBuFvmh+ob4ozp90+r60E0+nt8Tu48N/mSqIfrrHhgZ77MvVuIq/Shvz6
         k6QJrdi3AMGA/2e3jpejKvzapqxnTWx8pDkIEOBl2M120bINhBswemExD5QDtuhms8
         phYch+YHakbyA==
Date:   Thu, 16 Feb 2023 13:04:44 -0800
Subject: [PATCH 06/10] libfrog: return positive errno in pptrs.c
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657880337.3477097.2597122428206999325.stgit@magnolia>
In-Reply-To: <167657880257.3477097.11495108667073036392.stgit@magnolia>
References: <167657880257.3477097.11495108667073036392.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make all the functions in here return 0 for success or positive errno.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 io/parent.c     |   12 +++-----
 libfrog/paths.c |   11 +++++--
 libfrog/pptrs.c |   81 +++++++++++++++++++++++++++++++++----------------------
 libfrog/pptrs.h |    6 +---
 4 files changed, 62 insertions(+), 48 deletions(-)


diff --git a/io/parent.c b/io/parent.c
index ceb62a43..25d835a3 100644
--- a/io/parent.c
+++ b/io/parent.c
@@ -68,7 +68,7 @@ print_parents(
 	else
 		ret = fd_walk_pptrs(file->fd, pptr_print, args);
 	if (ret)
-		perror(file->name);
+		fprintf(stderr, "%s: %s\n", file->name, strerror(ret));
 
 	return 0;
 }
@@ -106,14 +106,12 @@ path_print(
 	}
 
 	ret = snprintf(buf, len, "%s", mntpt);
-	if (ret != strlen(mntpt)) {
-		errno = ENOMEM;
-		return -1;
-	}
+	if (ret != strlen(mntpt))
+		return ENAMETOOLONG;
 
 	ret = path_list_to_string(path, buf + ret, len - ret);
 	if (ret < 0)
-		return ret;
+		return ENAMETOOLONG;
 
 	printf("%s\n", buf);
 	return 0;
@@ -132,7 +130,7 @@ print_paths(
  	else
 		ret = fd_walk_ppaths(file->fd, path_print, args);
 	if (ret)
-		perror(file->name);
+		fprintf(stderr, "%s: %s\n", file->name, strerror(ret));
 	return 0;
 }
 
diff --git a/libfrog/paths.c b/libfrog/paths.c
index e541e200..cc43b02c 100644
--- a/libfrog/paths.c
+++ b/libfrog/paths.c
@@ -608,7 +608,7 @@ path_component_free(
 	free(pc);
 }
 
-/* Change a path component's filename. */
+/* Change a path component's filename or returns positive errno. */
 int
 path_component_change(
 	struct path_component	*pc,
@@ -620,7 +620,7 @@ path_component_change(
 
 	p = realloc(pc->pc_fname, namelen + 1);
 	if (!p)
-		return -1;
+		return errno;
 	pc->pc_fname = p;
 	memcpy(pc->pc_fname, name, namelen);
 	pc->pc_fname[namelen] = 0;
@@ -628,7 +628,7 @@ path_component_change(
 	return 0;
 }
 
-/* Initialize a pathname. */
+/* Initialize a pathname or returns positive errno. */
 struct path_list *
 path_list_init(void)
 {
@@ -683,7 +683,10 @@ path_list_del_component(
 	list_del_init(&pc->pc_list);
 }
 
-/* Convert a pathname into a string. */
+/*
+ * Convert a pathname into a string or returns -1 if the buffer isn't long
+ * enough.
+ */
 ssize_t
 path_list_to_string(
 	struct path_list	*path,
diff --git a/libfrog/pptrs.c b/libfrog/pptrs.c
index 5a3a7e2b..ef91a919 100644
--- a/libfrog/pptrs.c
+++ b/libfrog/pptrs.c
@@ -26,7 +26,10 @@ alloc_pptr_buf(
 	return pi;
 }
 
-/* Walk all parents of the given file handle. */
+/*
+ * Walk all parents of the given file handle.  Returns 0 on success or positive
+ * errno.
+ */
 static int
 handle_walk_parents(
 	int			fd,
@@ -41,7 +44,7 @@ handle_walk_parents(
 
 	pi = alloc_pptr_buf(4);
 	if (!pi)
-		return -1;
+		return errno;
 
 	if (handle) {
 		memcpy(&pi->pi_handle, handle, sizeof(struct xfs_handle));
@@ -52,7 +55,7 @@ handle_walk_parents(
 	while (!ret) {
 		if (pi->pi_flags & XFS_PPTR_OFLAG_ROOT) {
 			ret = fn(pi, NULL, arg);
-			break;
+			goto out_pi;
 		}
 
 		for (i = 0; i < pi->pi_ptrs_used; i++) {
@@ -67,13 +70,15 @@ handle_walk_parents(
 
 		ret = ioctl(fd, XFS_IOC_GETPARENTS, pi);
 	}
+	if (ret)
+		ret = errno;
 
 out_pi:
 	free(pi);
 	return ret;
 }
 
-/* Walk all parent pointers of this handle. */
+/* Walk all parent pointers of this handle.  Returns 0 or positive errno. */
 int
 handle_walk_pptrs(
 	void			*hanp,
@@ -84,19 +89,17 @@ handle_walk_pptrs(
 	char			*mntpt;
 	int			fd;
 
-	if (hlen != sizeof(struct xfs_handle)) {
-		errno = EINVAL;
-		return -1;
-	}
+	if (hlen != sizeof(struct xfs_handle))
+		return EINVAL;
 
 	fd = handle_to_fsfd(hanp, &mntpt);
 	if (fd < 0)
-		return -1;
+		return errno;
 
 	return handle_walk_parents(fd, hanp, fn, arg);
 }
 
-/* Walk all parent pointers of this fd. */
+/* Walk all parent pointers of this fd.  Returns 0 or positive errno. */
 int
 fd_walk_pptrs(
 	int			fd,
@@ -158,6 +161,7 @@ handle_walk_parent_path_ptr(
 /*
  * Recursively walk all parents of the given file handle; if we hit the
  * fs root then we call the associated function with the constructed path.
+ * Returns 0 for success or positive errno.
  */
 static int
 handle_walk_parent_paths(
@@ -169,11 +173,12 @@ handle_walk_parent_paths(
 
 	wpli = malloc(sizeof(struct walk_ppath_level_info));
 	if (!wpli)
-		return -1;
+		return errno;
 	wpli->pc = path_component_init("", 0);
 	if (!wpli->pc) {
+		ret = errno;
 		free(wpli);
-		return -1;
+		return ret;
 	}
 	wpli->wpi = wpi;
 	memcpy(&wpli->newhandle, handle, sizeof(struct xfs_handle));
@@ -188,7 +193,7 @@ handle_walk_parent_paths(
 
 /*
  * Call the given function on all known paths from the vfs root to the inode
- * described in the handle.
+ * described in the handle.  Returns 0 for success or positive errno.
  */
 int
 handle_walk_ppaths(
@@ -200,17 +205,15 @@ handle_walk_ppaths(
 	struct walk_ppaths_info	wpi;
 	ssize_t			ret;
 
-	if (hlen != sizeof(struct xfs_handle)) {
-		errno = EINVAL;
-		return -1;
-	}
+	if (hlen != sizeof(struct xfs_handle))
+		return EINVAL;
 
 	wpi.fd = handle_to_fsfd(hanp, &wpi.mntpt);
 	if (wpi.fd < 0)
-		return -1;
+		return errno;
 	wpi.path = path_list_init();
 	if (!wpi.path)
-		return -1;
+		return errno;
 	wpi.fn = fn;
 	wpi.arg = arg;
 
@@ -222,7 +225,7 @@ handle_walk_ppaths(
 
 /*
  * Call the given function on all known paths from the vfs root to the inode
- * referred to by the file description.
+ * referred to by the file description.  Returns 0 or positive errno.
  */
 int
 fd_walk_ppaths(
@@ -238,15 +241,15 @@ fd_walk_ppaths(
 
 	ret = fd_to_handle(fd, &hanp, &hlen);
 	if (ret)
-		return ret;
+		return errno;
 
 	fsfd = handle_to_fsfd(hanp, &wpi.mntpt);
 	if (fsfd < 0)
-		return -1;
+		return errno;
 	wpi.fd = fd;
 	wpi.path = path_list_init();
 	if (!wpi.path)
-		return -1;
+		return errno;
 	wpi.fn = fn;
 	wpi.arg = arg;
 
@@ -272,19 +275,20 @@ handle_to_path_walk(
 	int			ret;
 
 	ret = snprintf(pwi->buf, pwi->len, "%s", mntpt);
-	if (ret != strlen(mntpt)) {
-		errno = ENOMEM;
-		return -1;
-	}
+	if (ret != strlen(mntpt))
+		return ENAMETOOLONG;
 
 	ret = path_list_to_string(path, pwi->buf + ret, pwi->len - ret);
 	if (ret < 0)
-		return ret;
+		return ENAMETOOLONG;
 
-	return WALK_PPATHS_ABORT;
+	return ECANCELED;
 }
 
-/* Return any eligible path to this file handle. */
+/*
+ * Return any eligible path to this file handle.  Returns 0 for success or
+ * positive errno.
+ */
 int
 handle_to_path(
 	void			*hanp,
@@ -293,13 +297,20 @@ handle_to_path(
 	size_t			pathlen)
 {
 	struct path_walk_info	pwi;
+	int			ret;
 
 	pwi.buf = path;
 	pwi.len = pathlen;
-	return handle_walk_ppaths(hanp, hlen, handle_to_path_walk, &pwi);
+	ret = handle_walk_ppaths(hanp, hlen, handle_to_path_walk, &pwi);
+	if (ret == ECANCELED)
+		return 0;
+	return ret;
 }
 
-/* Return any eligible path to this file description. */
+/*
+ * Return any eligible path to this file description.  Returns 0 for success
+ * or positive errno.
+ */
 int
 fd_to_path(
 	int			fd,
@@ -307,8 +318,12 @@ fd_to_path(
 	size_t			pathlen)
 {
 	struct path_walk_info	pwi;
+	int			ret;
 
 	pwi.buf = path;
 	pwi.len = pathlen;
-	return fd_walk_ppaths(fd, handle_to_path_walk, &pwi);
+	ret = fd_walk_ppaths(fd, handle_to_path_walk, &pwi);
+	if (ret == ECANCELED)
+		return 0;
+	return ret;
 }
diff --git a/libfrog/pptrs.h b/libfrog/pptrs.h
index d174aa2a..1666de06 100644
--- a/libfrog/pptrs.h
+++ b/libfrog/pptrs.h
@@ -8,16 +8,14 @@
 
 struct path_list;
 
-typedef int (*walk_pptr_fn)(struct xfs_pptr_info *pi, struct xfs_parent_ptr *pptr,
-		void *arg);
+typedef int (*walk_pptr_fn)(struct xfs_pptr_info *pi,
+		struct xfs_parent_ptr *pptr, void *arg);
 typedef int (*walk_ppath_fn)(const char *mntpt, struct path_list *path,
 		void *arg);
 
-#define WALK_PPTRS_ABORT	1
 int fd_walk_pptrs(int fd, walk_pptr_fn fn, void *arg);
 int handle_walk_pptrs(void *hanp, size_t hanlen, walk_pptr_fn fn, void *arg);
 
-#define WALK_PPATHS_ABORT	1
 int fd_walk_ppaths(int fd, walk_ppath_fn fn, void *arg);
 int handle_walk_ppaths(void *hanp, size_t hanlen, walk_ppath_fn fn, void *arg);
 

