Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75273C6FD1F
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:30:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbjCPTaE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbjCPT3x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:29:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F183273385
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 12:29:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F135B8228E
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 19:29:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15C7FC433EF;
        Thu, 16 Mar 2023 19:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678994989;
        bh=8zWcXdhWdFj7ddmVXQhqBMSsORvaDpb+1KMdxyHAatA=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=NagIanjb3iwi7w68RZQgmkId7A/SXnZSpNIJvY06P4Yl/u/lEubF7mTwL3BM9lEbc
         30PP8bAY1mYsSMtTbBBiJNx8r6XwDIheGOiMKn6rEeVnhN31qSlErnefhmXp6FEZgG
         Ephqz+0atzkWaMclTx+8ZnI2MUyr67vw7kxypx667Y378UhA2b4YmfWFHtHhr87sN2
         Pmt9b8+krie0Soum7WxOMymnILQXAL0cmFlpzKNEWEPKhp2KLIT+HYq9Yyc5ZBEaU+
         gnciVm51TfgubCsGqk3ko+SBhrvkDnwZ1LB27QzK7gj4/JvB/cUmLtxcbeHOi++Vim
         5Zrz3RXdpK7UA==
Date:   Thu, 16 Mar 2023 12:29:48 -0700
Subject: [PATCH 4/7] libfrog: return positive errno in pptrs.c
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167899416122.16628.10916393155125095333.stgit@frogsfrogsfrogs>
In-Reply-To: <167899416068.16628.8907331389138892555.stgit@frogsfrogsfrogs>
References: <167899416068.16628.8907331389138892555.stgit@frogsfrogsfrogs>
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
index f5ebb40e4..6c0d81c12 100644
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
index e541e2007..cc43b02c4 100644
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
index 6a4f60cf6..ac7fcea28 100644
--- a/libfrog/pptrs.c
+++ b/libfrog/pptrs.c
@@ -25,7 +25,10 @@ alloc_pptr_buf(
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
@@ -40,7 +43,7 @@ handle_walk_parents(
 
 	pi = alloc_pptr_buf(XFS_XATTR_LIST_MAX);
 	if (!pi)
-		return -1;
+		return errno;
 
 	if (handle) {
 		memcpy(&pi->pi_handle, handle, sizeof(struct xfs_handle));
@@ -51,7 +54,7 @@ handle_walk_parents(
 	while (!ret) {
 		if (pi->pi_flags & XFS_PPTR_OFLAG_ROOT) {
 			ret = fn(pi, NULL, arg);
-			break;
+			goto out_pi;
 		}
 
 		for (i = 0; i < pi->pi_count; i++) {
@@ -66,13 +69,15 @@ handle_walk_parents(
 
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
@@ -83,19 +88,17 @@ handle_walk_pptrs(
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
@@ -157,6 +160,7 @@ handle_walk_parent_path_ptr(
 /*
  * Recursively walk all parents of the given file handle; if we hit the
  * fs root then we call the associated function with the constructed path.
+ * Returns 0 for success or positive errno.
  */
 static int
 handle_walk_parent_paths(
@@ -168,11 +172,12 @@ handle_walk_parent_paths(
 
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
@@ -187,7 +192,7 @@ handle_walk_parent_paths(
 
 /*
  * Call the given function on all known paths from the vfs root to the inode
- * described in the handle.
+ * described in the handle.  Returns 0 for success or positive errno.
  */
 int
 handle_walk_ppaths(
@@ -199,17 +204,15 @@ handle_walk_ppaths(
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
 
@@ -221,7 +224,7 @@ handle_walk_ppaths(
 
 /*
  * Call the given function on all known paths from the vfs root to the inode
- * referred to by the file description.
+ * referred to by the file description.  Returns 0 or positive errno.
  */
 int
 fd_walk_ppaths(
@@ -237,15 +240,15 @@ fd_walk_ppaths(
 
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
 
@@ -271,19 +274,20 @@ handle_to_path_walk(
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
@@ -292,13 +296,20 @@ handle_to_path(
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
@@ -306,8 +317,12 @@ fd_to_path(
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
index d174aa2a5..1666de060 100644
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
 

