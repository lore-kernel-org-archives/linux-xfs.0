Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E86AC61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:00:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbjBPVAJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:00:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbjBPVAI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:00:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16946521F1
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 13:00:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8E3BB826BA
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 21:00:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80597C433EF;
        Thu, 16 Feb 2023 21:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581201;
        bh=1VlrpqX9uVr9veoNR+/lTiM8Gcxu2+TFeq5KUs/hWLw=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=oTJ0WS/XKXBPBvyakOo4JlbvkSoYEQeivipO/1t+OvYfdBxPMzrhKK8hfPBSmfwFO
         vQlMjoDxWGARd/3AjxDnU5+MgcECtqXu9D7mSoNOBNjRizQCm6zq7FYwS77Rs2g1ol
         6BzpakzPTKJnoOMPdzLJm8KdXe5WHV5voWVkrZTxIWddhwjkkmLhEVBwIpnHSWanKe
         meQVQZay0YSChqr1Pbps1ZQVgMPjomjaVEiaVnA5OYkrh2ZQDwqQW5WTAWbLbkQpNO
         p631ZgoS5ErS1txpoj4cML7bFfZIXVK0ADAUzQYBjMSAAms5OVEINsMR0nbbRPJtfc
         W7GBuhDqX4W4Q==
Date:   Thu, 16 Feb 2023 13:00:00 -0800
Subject: [PATCH 25/25] xfsprogs: Add i, n and f flags to parent command
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657879242.3476112.116732180377794388.stgit@magnolia>
In-Reply-To: <167657878885.3476112.11949206434283274332.stgit@magnolia>
References: <167657878885.3476112.11949206434283274332.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch adds the flags i, n, and f to the parent command. These flags add
filtering options that are used by the new parent pointer tests in xfstests, and
help to improve the test run time.  The flags are:

-i: Only show parent pointer records containing the given inode
-n: Only show parent pointer records containing the given filename
-f: Print records in short format: ino/gen/namelen/name

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 include/parent.h   |   17 ++++++++---
 io/parent.c        |   82 ++++++++++++++++++++++++++++++++++++++++------------
 libhandle/parent.c |   73 ++++++++++++++++++++++++++++++++++------------
 3 files changed, 128 insertions(+), 44 deletions(-)


diff --git a/include/parent.h b/include/parent.h
index fb900041..2e136724 100644
--- a/include/parent.h
+++ b/include/parent.h
@@ -17,20 +17,27 @@ typedef struct parent_cursor {
 	__u32	opaque[4];      /* an opaque cookie */
 } parent_cursor_t;
 
+/* Print parent pointer option flags */
+#define XFS_PPPTR_OFLAG_SHORT  (1<<0)	/* Print in short format */
+
 struct path_list;
 
 typedef int (*walk_pptr_fn)(struct xfs_pptr_info *pi, struct xfs_parent_ptr *pptr,
-		void *arg);
+		void *arg, int flags);
 typedef int (*walk_ppath_fn)(const char *mntpt, struct path_list *path,
 		void *arg);
 
 #define WALK_PPTRS_ABORT	1
-int fd_walk_pptrs(int fd, walk_pptr_fn fn, void *arg);
-int handle_walk_pptrs(void *hanp, size_t hanlen, walk_pptr_fn fn, void *arg);
+int fd_walk_pptrs(int fd, uint64_t pino, char *pname, walk_pptr_fn fn,
+		void *arg, int flags);
+int handle_walk_pptrs(void *hanp, size_t hanlen, uint64_t pino, char *pname,
+		walk_pptr_fn fn, void *arg, int flags);
 
 #define WALK_PPATHS_ABORT	1
-int fd_walk_ppaths(int fd, walk_ppath_fn fn, void *arg);
-int handle_walk_ppaths(void *hanp, size_t hanlen, walk_ppath_fn fn, void *arg);
+int fd_walk_ppaths(int fd, uint64_t pino, char *pname, walk_ppath_fn fn,
+		void *arg, int flags);
+int handle_walk_ppaths(void *hanp, size_t hanlen, uint64_t pino, char *pname,
+		walk_ppath_fn fn, void *arg, int flags);
 
 int fd_to_path(int fd, char *path, size_t pathlen);
 int handle_to_path(void *hanp, size_t hlen, char *path, size_t pathlen);
diff --git a/io/parent.c b/io/parent.c
index e0ca29eb..a6f3fa0c 100644
--- a/io/parent.c
+++ b/io/parent.c
@@ -19,7 +19,8 @@ static int
 pptr_print(
 	struct xfs_pptr_info	*pi,
 	struct xfs_parent_ptr	*pptr,
-	void			*arg)
+	void			*arg,
+	int			flags)
 {
 	char			buf[XFS_PPTR_MAXNAMELEN + 1];
 	unsigned int		namelen = strlen((char *)pptr->xpp_name);
@@ -31,24 +32,36 @@ pptr_print(
 
 	memcpy(buf, pptr->xpp_name, namelen);
 	buf[namelen] = 0;
-	printf(_("p_ino    = %llu\n"), (unsigned long long)pptr->xpp_ino);
-	printf(_("p_gen    = %u\n"), (unsigned int)pptr->xpp_gen);
-	printf(_("p_reclen = %u\n"), namelen);
-	printf(_("p_name   = \"%s\"\n\n"), buf);
+
+	if (flags & XFS_PPPTR_OFLAG_SHORT) {
+		printf("%llu/%u/%u/%s\n",
+			(unsigned long long)pptr->xpp_ino,
+			(unsigned int)pptr->xpp_gen, namelen, buf);
+	}
+	else {
+		printf(_("p_ino    = %llu\n"), (unsigned long long)pptr->xpp_ino);
+		printf(_("p_gen    = %u\n"), (unsigned int)pptr->xpp_gen);
+		printf(_("p_reclen = %u\n"), namelen);
+		printf(_("p_name   = \"%s\"\n\n"), buf);
+	}
 	return 0;
 }
 
-int
+static int
 print_parents(
-	struct xfs_handle	*handle)
+	struct xfs_handle	*handle,
+	uint64_t		pino,
+	char			*pname,
+	int			flags)
 {
 	int			ret;
 
 	if (handle)
-		ret = handle_walk_pptrs(handle, sizeof(*handle), pptr_print,
-				NULL);
+		ret = handle_walk_pptrs(handle, sizeof(*handle), pino,
+				pname, pptr_print, NULL, flags);
 	else
-		ret = fd_walk_pptrs(file->fd, pptr_print, NULL);
+		ret = fd_walk_pptrs(file->fd, pino, pname, pptr_print,
+				NULL, flags);
 	if (ret)
 		perror(file->name);
 
@@ -77,17 +90,21 @@ path_print(
 	return 0;
 }
 
-int
+static int
 print_paths(
-	struct xfs_handle	*handle)
+	struct xfs_handle	*handle,
+	uint64_t		pino,
+	char			*pname,
+	int			flags)
 {
 	int			ret;
 
 	if (handle)
-		ret = handle_walk_ppaths(handle, sizeof(*handle), path_print,
-				NULL);
+		ret = handle_walk_ppaths(handle, sizeof(*handle), pino,
+				pname, path_print, NULL, flags);
  	else
-		ret = fd_walk_ppaths(file->fd, path_print, NULL);
+		ret = fd_walk_ppaths(file->fd, pino, pname, path_print,
+				NULL, flags);
 	if (ret)
 		perror(file->name);
 	return 0;
@@ -109,6 +126,9 @@ parent_f(
 	int			listpath_flag = 0;
 	int			ret;
 	static int		tab_init;
+	uint64_t		pino = 0;
+	char			*pname = NULL;
+	int			ppptr_flags = 0;
 
 	if (!tab_init) {
 		tab_init = 1;
@@ -123,11 +143,27 @@ parent_f(
 	}
 	mntpt = fs->fs_dir;
 
-	while ((c = getopt(argc, argv, "p")) != EOF) {
+	while ((c = getopt(argc, argv, "pfi:n:")) != EOF) {
 		switch (c) {
 		case 'p':
 			listpath_flag = 1;
 			break;
+		case 'i':
+	                pino = strtoull(optarg, &p, 0);
+	                if (*p != '\0' || pino == 0) {
+	                        fprintf(stderr,
+	                                _("Bad inode number '%s'.\n"),
+	                                optarg);
+	                        return 0;
+			}
+
+			break;
+		case 'n':
+			pname = optarg;
+			break;
+		case 'f':
+			ppptr_flags |= XFS_PPPTR_OFLAG_SHORT;
+			break;
 		default:
 			return command_usage(&parent_cmd);
 		}
@@ -169,9 +205,11 @@ parent_f(
 	}
 
 	if (listpath_flag)
-		exitcode = print_paths(ino ? &handle : NULL);
+		exitcode = print_paths(ino ? &handle : NULL,
+				pino, pname, ppptr_flags);
 	else
-		exitcode = print_parents(ino ? &handle : NULL);
+		exitcode = print_parents(ino ? &handle : NULL,
+				pino, pname, ppptr_flags);
 
 	if (hanp)
 		free_handle(hanp, hlen);
@@ -189,6 +227,12 @@ printf(_(
 " -p -- list the current file's paths up to the root\n"
 "\n"
 "If ino and gen are supplied, use them instead.\n"
+"\n"
+" -i -- Only show parent pointer records containing the given inode\n"
+"\n"
+" -n -- Only show parent pointer records containing the given filename\n"
+"\n"
+" -f -- Print records in short format: ino/gen/namelen/filename\n"
 "\n"));
 }
 
@@ -199,7 +243,7 @@ parent_init(void)
 	parent_cmd.cfunc = parent_f;
 	parent_cmd.argmin = 0;
 	parent_cmd.argmax = -1;
-	parent_cmd.args = _("[-p] [ino gen]");
+	parent_cmd.args = _("[-p] [ino gen] [-i] [ino] [-n] [name] [-f]");
 	parent_cmd.flags = CMD_NOMAP_OK;
 	parent_cmd.oneline = _("print parent inodes");
 	parent_cmd.help = parent_help;
diff --git a/libhandle/parent.c b/libhandle/parent.c
index ebd0abd5..3de8742c 100644
--- a/libhandle/parent.c
+++ b/libhandle/parent.c
@@ -40,13 +40,21 @@ xfs_pptr_alloc(
       return pi;
 }
 
-/* Walk all parents of the given file handle. */
+/*
+ * Walk all parents of the given file handle.
+ * If pino is set, print only the parent pointer
+ * of that inode.  If pname is set, print only the
+ * parent pointer of that filename
+ */
 static int
 handle_walk_parents(
 	int			fd,
 	struct xfs_handle	*handle,
+	uint64_t		pino,
+	char			*pname,
 	walk_pptr_fn		fn,
-	void			*arg)
+	void			*arg,
+	int			flags)
 {
 	struct xfs_pptr_info	*pi;
 	struct xfs_parent_ptr	*p;
@@ -65,13 +73,20 @@ handle_walk_parents(
 	ret = ioctl(fd, XFS_IOC_GETPARENTS, pi);
 	while (!ret) {
 		if (pi->pi_flags & XFS_PPTR_OFLAG_ROOT) {
-			ret = fn(pi, NULL, arg);
+			ret = fn(pi, NULL, arg, flags);
 			break;
 		}
 
 		for (i = 0; i < pi->pi_ptrs_used; i++) {
 			p = xfs_ppinfo_to_pp(pi, i);
-			ret = fn(pi, p, arg);
+			if ((pino != 0) && (pino != p->xpp_ino))
+				continue;
+
+			if ((pname  != NULL) && (strcmp(pname,
+					(char *)p->xpp_name) != 0))
+				continue;
+
+			ret = fn(pi, p, arg, flags);
 			if (ret)
 				goto out_pi;
 		}
@@ -92,8 +107,11 @@ int
 handle_walk_pptrs(
 	void			*hanp,
 	size_t			hlen,
+	uint64_t		pino,
+	char			*pname,
 	walk_pptr_fn		fn,
-	void			*arg)
+	void			*arg,
+	int			flags)
 {
 	char			*mntpt;
 	int			fd;
@@ -107,17 +125,20 @@ handle_walk_pptrs(
 	if (fd < 0)
 		return -1;
 
-	return handle_walk_parents(fd, hanp, fn, arg);
+	return handle_walk_parents(fd, hanp, pino, pname, fn, arg, flags);
 }
 
 /* Walk all parent pointers of this fd. */
 int
 fd_walk_pptrs(
 	int			fd,
+	uint64_t		pino,
+	char			*pname,
 	walk_pptr_fn		fn,
-	void			*arg)
+	void			*arg,
+	int			flags)
 {
-	return handle_walk_parents(fd, NULL, fn, arg);
+	return handle_walk_parents(fd, NULL, pino, pname, fn, arg, flags);
 }
 
 struct walk_ppaths_info {
@@ -135,13 +156,15 @@ struct walk_ppath_level_info {
 };
 
 static int handle_walk_parent_paths(struct walk_ppaths_info *wpi,
-		struct xfs_handle *handle);
+		struct xfs_handle *handle, uint64_t pino, char *pname,
+		int flags);
 
 static int
 handle_walk_parent_path_ptr(
 	struct xfs_pptr_info		*pi,
 	struct xfs_parent_ptr		*p,
-	void				*arg)
+	void				*arg,
+	int				flags)
 {
 	struct walk_ppath_level_info	*wpli = arg;
 	struct walk_ppaths_info		*wpi = wpli->wpi;
@@ -160,7 +183,7 @@ handle_walk_parent_path_ptr(
 		wpli->newhandle.ha_fid.fid_ino = p->xpp_ino;
 		wpli->newhandle.ha_fid.fid_gen = p->xpp_gen;
 		path_list_add_parent_component(wpi->path, wpli->pc);
-		ret = handle_walk_parent_paths(wpi, &wpli->newhandle);
+		ret = handle_walk_parent_paths(wpi, &wpli->newhandle, 0, NULL, 0);
 		path_list_del_component(wpi->path, wpli->pc);
 		if (ret)
 			break;
@@ -176,7 +199,10 @@ handle_walk_parent_path_ptr(
 static int
 handle_walk_parent_paths(
 	struct walk_ppaths_info		*wpi,
-	struct xfs_handle		*handle)
+	struct xfs_handle		*handle,
+	uint64_t			pino,
+	char				*pname,
+	int				flags)
 {
 	struct walk_ppath_level_info	*wpli;
 	int				ret;
@@ -192,8 +218,8 @@ handle_walk_parent_paths(
 	wpli->wpi = wpi;
 	memcpy(&wpli->newhandle, handle, sizeof(struct xfs_handle));
 
-	ret = handle_walk_parents(wpi->fd, handle, handle_walk_parent_path_ptr,
-			wpli);
+	ret = handle_walk_parents(wpi->fd, handle, pino, pname,
+			handle_walk_parent_path_ptr, wpli, flags);
 
 	path_component_free(wpli->pc);
 	free(wpli);
@@ -208,8 +234,11 @@ int
 handle_walk_ppaths(
 	void			*hanp,
 	size_t			hlen,
+	uint64_t		pino,
+	char			*pname,
 	walk_ppath_fn		fn,
-	void			*arg)
+	void			*arg,
+	int			flags)
 {
 	struct walk_ppaths_info	wpi;
 	ssize_t			ret;
@@ -228,7 +257,7 @@ handle_walk_ppaths(
 	wpi.fn = fn;
 	wpi.arg = arg;
 
-	ret = handle_walk_parent_paths(&wpi, hanp);
+	ret = handle_walk_parent_paths(&wpi, hanp, pino, pname, flags);
 	path_list_free(wpi.path);
 
 	return ret;
@@ -241,8 +270,11 @@ handle_walk_ppaths(
 int
 fd_walk_ppaths(
 	int			fd,
+	uint64_t		pino,
+	char			*pname,
 	walk_ppath_fn		fn,
-	void			*arg)
+	void			*arg,
+	int			flags)
 {
 	struct walk_ppaths_info	wpi;
 	void			*hanp;
@@ -264,7 +296,7 @@ fd_walk_ppaths(
 	wpi.fn = fn;
 	wpi.arg = arg;
 
-	ret = handle_walk_parent_paths(&wpi, hanp);
+	ret = handle_walk_parent_paths(&wpi, hanp, pino, pname, flags);
 	path_list_free(wpi.path);
 
 	return ret;
@@ -310,7 +342,8 @@ handle_to_path(
 
 	pwi.buf = path;
 	pwi.len = pathlen;
-	return handle_walk_ppaths(hanp, hlen, handle_to_path_walk, &pwi);
+	return handle_walk_ppaths(hanp, hlen, 0, NULL, handle_to_path_walk,
+			&pwi, 0);
 }
 
 /* Return any eligible path to this file description. */
@@ -324,5 +357,5 @@ fd_to_path(
 
 	pwi.buf = path;
 	pwi.len = pathlen;
-	return fd_walk_ppaths(fd, handle_to_path_walk, &pwi);
+	return fd_walk_ppaths(fd, 0, NULL, handle_to_path_walk, &pwi, 0);
 }

