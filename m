Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFC5BC6FD1F
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:29:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbjCPT3G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjCPT3F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:29:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D53922795
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 12:29:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1C32620F8
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 19:29:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30127C433D2;
        Thu, 16 Mar 2023 19:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678994942;
        bh=KkYwuwKgUJrx+Jcb1Wq9oc2aPiv+rEtDOOKyPLAUs2U=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=PlZRXil0q6YeJl9MxiTLO6MGotg+0Z9rij1dC2NR97xBxoqdzy9+uK5gvkPJFVe9+
         YZkQNRurlsgMVDh1G5XVlt7260z9ptWcNHyoY9i9NV9ihyaXyE7DM3H9DKywmBQqHv
         5k6EYrj87V5HekJRk6UKOIjaIxx+neFRyos5ulmt5fxXD/5qaPYVQ/Xzdktortv046
         LDwHtKQVOK8Jj9NeGJ45M40TAuPpAx4OQkTrH01ms/VW6J1NpzHascBRRawZJEIe4C
         2gtYZgBCe1LfCbAbPEwvDuTt3PWM5bNODLmfjz6ufb7WrzrBuvTlNPAWX9NayOBeqM
         s1u9gplbwP+3A==
Date:   Thu, 16 Mar 2023 12:29:01 -0700
Subject: [PATCH 1/7] xfs_io: move parent pointer filtering and formatting
 flags out of libhandle
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167899416082.16628.16791646099642475394.stgit@frogsfrogsfrogs>
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

All this filtering and presentation stuff originates in xfs_io and
should stay there.  The added arguments seriously complicate the basic
iterator interface and there are no other users.

While we're at it, fix a bug in path_print where it doesn't actually
print the path.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/parent.h   |   17 +++------
 io/parent.c        |   99 ++++++++++++++++++++++++++++++++--------------------
 libfrog/paths.c    |   28 ++++++++++++++-
 libfrog/paths.h    |    8 +++-
 libhandle/parent.c |   77 ++++++++++++----------------------------
 5 files changed, 119 insertions(+), 110 deletions(-)


diff --git a/include/parent.h b/include/parent.h
index 2e136724b..fb9000419 100644
--- a/include/parent.h
+++ b/include/parent.h
@@ -17,27 +17,20 @@ typedef struct parent_cursor {
 	__u32	opaque[4];      /* an opaque cookie */
 } parent_cursor_t;
 
-/* Print parent pointer option flags */
-#define XFS_PPPTR_OFLAG_SHORT  (1<<0)	/* Print in short format */
-
 struct path_list;
 
 typedef int (*walk_pptr_fn)(struct xfs_pptr_info *pi, struct xfs_parent_ptr *pptr,
-		void *arg, int flags);
+		void *arg);
 typedef int (*walk_ppath_fn)(const char *mntpt, struct path_list *path,
 		void *arg);
 
 #define WALK_PPTRS_ABORT	1
-int fd_walk_pptrs(int fd, uint64_t pino, char *pname, walk_pptr_fn fn,
-		void *arg, int flags);
-int handle_walk_pptrs(void *hanp, size_t hanlen, uint64_t pino, char *pname,
-		walk_pptr_fn fn, void *arg, int flags);
+int fd_walk_pptrs(int fd, walk_pptr_fn fn, void *arg);
+int handle_walk_pptrs(void *hanp, size_t hanlen, walk_pptr_fn fn, void *arg);
 
 #define WALK_PPATHS_ABORT	1
-int fd_walk_ppaths(int fd, uint64_t pino, char *pname, walk_ppath_fn fn,
-		void *arg, int flags);
-int handle_walk_ppaths(void *hanp, size_t hanlen, uint64_t pino, char *pname,
-		walk_ppath_fn fn, void *arg, int flags);
+int fd_walk_ppaths(int fd, walk_ppath_fn fn, void *arg);
+int handle_walk_ppaths(void *hanp, size_t hanlen, walk_ppath_fn fn, void *arg);
 
 int fd_to_path(int fd, char *path, size_t pathlen);
 int handle_to_path(void *hanp, size_t hlen, char *path, size_t pathlen);
diff --git a/io/parent.c b/io/parent.c
index 6af342820..8c822cdeb 100644
--- a/io/parent.c
+++ b/io/parent.c
@@ -15,34 +15,41 @@
 static cmdinfo_t parent_cmd;
 static char *mntpt;
 
+struct pptr_args {
+	uint64_t	filter_ino;
+	char		*filter_name;
+	bool		shortformat;
+};
+
 static int
 pptr_print(
 	struct xfs_pptr_info	*pi,
 	struct xfs_parent_ptr	*pptr,
-	void			*arg,
-	int			flags)
+	void			*arg)
 {
-	char			buf[XFS_PPTR_MAXNAMELEN + 1];
-	unsigned int		namelen = strlen((char *)pptr->xpp_name);
+	struct pptr_args	*args = arg;
+	unsigned int		namelen;
 
 	if (pi->pi_flags & XFS_PPTR_OFLAG_ROOT) {
 		printf(_("Root directory.\n"));
 		return 0;
 	}
 
-	memcpy(buf, pptr->xpp_name, namelen);
-	buf[namelen] = 0;
+	if (args->filter_ino && pptr->xpp_ino != args->filter_ino)
+		return 0;
+	if (args->filter_name && strcmp(args->filter_name, pptr->xpp_name))
+		return 0;
 
-	if (flags & XFS_PPPTR_OFLAG_SHORT) {
+	namelen = strlen(pptr->xpp_name);
+	if (args->shortformat) {
 		printf("%llu/%u/%u/%s\n",
 			(unsigned long long)pptr->xpp_ino,
-			(unsigned int)pptr->xpp_gen, namelen, buf);
-	}
-	else {
+			(unsigned int)pptr->xpp_gen, namelen, pptr->xpp_name);
+	} else {
 		printf(_("p_ino    = %llu\n"), (unsigned long long)pptr->xpp_ino);
 		printf(_("p_gen    = %u\n"), (unsigned int)pptr->xpp_gen);
 		printf(_("p_reclen = %u\n"), namelen);
-		printf(_("p_name   = \"%s\"\n\n"), buf);
+		printf(_("p_name   = \"%s\"\n\n"), pptr->xpp_name);
 	}
 	return 0;
 }
@@ -50,34 +57,53 @@ pptr_print(
 static int
 print_parents(
 	struct xfs_handle	*handle,
-	uint64_t		pino,
-	char			*pname,
-	int			flags)
+	struct pptr_args	*args)
 {
 	int			ret;
 
 	if (handle)
-		ret = handle_walk_pptrs(handle, sizeof(*handle), pino,
-				pname, pptr_print, NULL, flags);
+		ret = handle_walk_pptrs(handle, sizeof(*handle), pptr_print,
+				args);
 	else
-		ret = fd_walk_pptrs(file->fd, pino, pname, pptr_print,
-				NULL, flags);
+		ret = fd_walk_pptrs(file->fd, pptr_print, args);
 	if (ret)
 		perror(file->name);
 
 	return 0;
 }
 
+static int
+filter_path_components(
+	const char		*name,
+	uint64_t		ino,
+	void			*arg)
+{
+	struct pptr_args	*args = arg;
+
+	if (args->filter_ino && ino == args->filter_ino)
+		return ECANCELED;
+	if (args->filter_name && !strcmp(args->filter_name, name))
+		return ECANCELED;
+	return 0;
+}
+
 static int
 path_print(
 	const char		*mntpt,
 	struct path_list	*path,
-	void			*arg) {
-
+	void			*arg)
+{
+	struct pptr_args	*args = arg;
 	char			buf[PATH_MAX];
 	size_t			len = PATH_MAX;
 	int			ret;
 
+	if (args->filter_ino || args->filter_name) {
+		ret = path_walk_components(path, filter_path_components, args);
+		if (ret != ECANCELED)
+			return 0;
+	}
+
 	ret = snprintf(buf, len, "%s", mntpt);
 	if (ret != strlen(mntpt)) {
 		errno = ENOMEM;
@@ -95,18 +121,15 @@ path_print(
 static int
 print_paths(
 	struct xfs_handle	*handle,
-	uint64_t		pino,
-	char			*pname,
-	int			flags)
+	struct pptr_args	*args)
 {
 	int			ret;
 
 	if (handle)
-		ret = handle_walk_ppaths(handle, sizeof(*handle), pino,
-				pname, path_print, NULL, flags);
+		ret = handle_walk_ppaths(handle, sizeof(*handle), path_print,
+				args);
  	else
-		ret = fd_walk_ppaths(file->fd, pino, pname, path_print,
-				NULL, flags);
+		ret = fd_walk_ppaths(file->fd, path_print, args);
 	if (ret)
 		perror(file->name);
 	return 0;
@@ -118,6 +141,7 @@ parent_f(
 	char			**argv)
 {
 	struct xfs_handle	handle;
+	struct pptr_args	args = { 0 };
 	void			*hanp = NULL;
 	size_t			hlen;
 	struct fs_path		*fs;
@@ -128,9 +152,6 @@ parent_f(
 	int			listpath_flag = 0;
 	int			ret;
 	static int		tab_init;
-	uint64_t		pino = 0;
-	char			*pname = NULL;
-	int			ppptr_flags = 0;
 
 	if (!tab_init) {
 		tab_init = 1;
@@ -151,8 +172,8 @@ parent_f(
 			listpath_flag = 1;
 			break;
 		case 'i':
-	                pino = strtoull(optarg, &p, 0);
-	                if (*p != '\0' || pino == 0) {
+	                args.filter_ino = strtoull(optarg, &p, 0);
+	                if (*p != '\0' || args.filter_ino == 0) {
 	                        fprintf(stderr,
 	                                _("Bad inode number '%s'.\n"),
 	                                optarg);
@@ -161,10 +182,10 @@ parent_f(
 
 			break;
 		case 'n':
-			pname = optarg;
+			args.filter_name = optarg;
 			break;
 		case 'f':
-			ppptr_flags |= XFS_PPPTR_OFLAG_SHORT;
+			args.shortformat = true;
 			break;
 		default:
 			return command_usage(&parent_cmd);
@@ -204,14 +225,14 @@ parent_f(
 		handle.ha_fid.fid_ino = ino;
 		handle.ha_fid.fid_gen = gen;
 
+	} else if (optind != argc) {
+		return command_usage(&parent_cmd);
 	}
 
 	if (listpath_flag)
-		exitcode = print_paths(ino ? &handle : NULL,
-				pino, pname, ppptr_flags);
+		exitcode = print_paths(ino ? &handle : NULL, &args);
 	else
-		exitcode = print_parents(ino ? &handle : NULL,
-				pino, pname, ppptr_flags);
+		exitcode = print_parents(ino ? &handle : NULL, &args);
 
 	if (hanp)
 		free_handle(hanp, hlen);
@@ -245,7 +266,7 @@ parent_init(void)
 	parent_cmd.cfunc = parent_f;
 	parent_cmd.argmin = 0;
 	parent_cmd.argmax = -1;
-	parent_cmd.args = _("[-p] [ino gen] [-i] [ino] [-n] [name] [-f]");
+	parent_cmd.args = _("[-p] [ino gen] [-i ino] [-n name] [-f]");
 	parent_cmd.flags = CMD_NOMAP_OK;
 	parent_cmd.oneline = _("print parent inodes");
 	parent_cmd.help = parent_help;
diff --git a/libfrog/paths.c b/libfrog/paths.c
index a86ae07c1..e541e2007 100644
--- a/libfrog/paths.c
+++ b/libfrog/paths.c
@@ -574,13 +574,15 @@ struct path_list {
 
 struct path_component {
 	struct list_head	pc_list;
+	uint64_t		pc_ino;
 	char			*pc_fname;
 };
 
 /* Initialize a path component with a given name. */
 struct path_component *
 path_component_init(
-	const char		*name)
+	const char		*name,
+	uint64_t		ino)
 {
 	struct path_component	*pc;
 
@@ -593,6 +595,7 @@ path_component_init(
 		free(pc);
 		return NULL;
 	}
+	pc->pc_ino = ino;
 	return pc;
 }
 
@@ -610,7 +613,8 @@ int
 path_component_change(
 	struct path_component	*pc,
 	void			*name,
-	size_t			namelen)
+	size_t			namelen,
+	uint64_t		ino)
 {
 	void			*p;
 
@@ -620,6 +624,7 @@ path_component_change(
 	pc->pc_fname = p;
 	memcpy(pc->pc_fname, name, namelen);
 	pc->pc_fname[namelen] = 0;
+	pc->pc_ino = ino;
 	return 0;
 }
 
@@ -699,3 +704,22 @@ path_list_to_string(
 	}
 	return bytes;
 }
+
+/* Walk each component of a path. */
+int
+path_walk_components(
+	struct path_list	*path,
+	path_walk_fn_t		fn,
+	void			*arg)
+{
+	struct path_component	*pos;
+	int			ret;
+
+	list_for_each_entry(pos, &path->p_head, pc_list) {
+		ret = fn(pos->pc_fname, pos->pc_ino, arg);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
diff --git a/libfrog/paths.h b/libfrog/paths.h
index 52538fb56..eb66df0c1 100644
--- a/libfrog/paths.h
+++ b/libfrog/paths.h
@@ -63,10 +63,10 @@ extern fs_path_t *fs_cursor_next_entry(fs_cursor_t *__cp);
 struct path_list;
 struct path_component;
 
-struct path_component *path_component_init(const char *name);
+struct path_component *path_component_init(const char *name, uint64_t ino);
 void path_component_free(struct path_component *pc);
 int path_component_change(struct path_component *pc, void *name,
-		size_t namelen);
+		size_t namelen, uint64_t ino);
 
 struct path_list *path_list_init(void);
 void path_list_free(struct path_list *path);
@@ -77,4 +77,8 @@ void path_list_del_component(struct path_list *path, struct path_component *pc);
 
 ssize_t path_list_to_string(struct path_list *path, char *buf, size_t buflen);
 
+typedef int (*path_walk_fn_t)(const char *name, uint64_t ino, void *arg);
+
+int path_walk_components(struct path_list *path, path_walk_fn_t fn, void *arg);
+
 #endif	/* __PATH_H__ */
diff --git a/libhandle/parent.c b/libhandle/parent.c
index 966ed74d5..b511f5b64 100644
--- a/libhandle/parent.c
+++ b/libhandle/parent.c
@@ -39,21 +39,13 @@ xfs_pptr_alloc(
       return pi;
 }
 
-/*
- * Walk all parents of the given file handle.
- * If pino is set, print only the parent pointer
- * of that inode.  If pname is set, print only the
- * parent pointer of that filename
- */
+/* Walk all parents of the given file handle. */
 static int
 handle_walk_parents(
 	int			fd,
 	struct xfs_handle	*handle,
-	uint64_t		pino,
-	char			*pname,
 	walk_pptr_fn		fn,
-	void			*arg,
-	int			flags)
+	void			*arg)
 {
 	struct xfs_pptr_info	*pi;
 	struct xfs_parent_ptr	*p;
@@ -72,20 +64,13 @@ handle_walk_parents(
 	ret = ioctl(fd, XFS_IOC_GETPARENTS, pi);
 	while (!ret) {
 		if (pi->pi_flags & XFS_PPTR_OFLAG_ROOT) {
-			ret = fn(pi, NULL, arg, flags);
+			ret = fn(pi, NULL, arg);
 			break;
 		}
 
 		for (i = 0; i < pi->pi_count; i++) {
 			p = xfs_ppinfo_to_pp(pi, i);
-			if ((pino != 0) && (pino != p->xpp_ino))
-				continue;
-
-			if ((pname  != NULL) && (strcmp(pname,
-					(char *)p->xpp_name) != 0))
-				continue;
-
-			ret = fn(pi, p, arg, flags);
+			ret = fn(pi, p, arg);
 			if (ret)
 				goto out_pi;
 		}
@@ -106,11 +91,8 @@ int
 handle_walk_pptrs(
 	void			*hanp,
 	size_t			hlen,
-	uint64_t		pino,
-	char			*pname,
 	walk_pptr_fn		fn,
-	void			*arg,
-	int			flags)
+	void			*arg)
 {
 	char			*mntpt;
 	int			fd;
@@ -124,20 +106,17 @@ handle_walk_pptrs(
 	if (fd < 0)
 		return -1;
 
-	return handle_walk_parents(fd, hanp, pino, pname, fn, arg, flags);
+	return handle_walk_parents(fd, hanp, fn, arg);
 }
 
 /* Walk all parent pointers of this fd. */
 int
 fd_walk_pptrs(
 	int			fd,
-	uint64_t		pino,
-	char			*pname,
 	walk_pptr_fn		fn,
-	void			*arg,
-	int			flags)
+	void			*arg)
 {
-	return handle_walk_parents(fd, NULL, pino, pname, fn, arg, flags);
+	return handle_walk_parents(fd, NULL, fn, arg);
 }
 
 struct walk_ppaths_info {
@@ -155,15 +134,13 @@ struct walk_ppath_level_info {
 };
 
 static int handle_walk_parent_paths(struct walk_ppaths_info *wpi,
-		struct xfs_handle *handle, uint64_t pino, char *pname,
-		int flags);
+		struct xfs_handle *handle);
 
 static int
 handle_walk_parent_path_ptr(
 	struct xfs_pptr_info		*pi,
 	struct xfs_parent_ptr		*p,
-	void				*arg,
-	int				flags)
+	void				*arg)
 {
 	struct walk_ppath_level_info	*wpli = arg;
 	struct walk_ppaths_info		*wpi = wpli->wpi;
@@ -176,13 +153,13 @@ handle_walk_parent_path_ptr(
 	for (i = 0; i < pi->pi_count; i++) {
 		p = xfs_ppinfo_to_pp(pi, i);
 		ret = path_component_change(wpli->pc, p->xpp_name,
-				strlen((char *)p->xpp_name));
+				strlen((char *)p->xpp_name), p->xpp_ino);
 		if (ret)
 			break;
 		wpli->newhandle.ha_fid.fid_ino = p->xpp_ino;
 		wpli->newhandle.ha_fid.fid_gen = p->xpp_gen;
 		path_list_add_parent_component(wpi->path, wpli->pc);
-		ret = handle_walk_parent_paths(wpi, &wpli->newhandle, 0, NULL, 0);
+		ret = handle_walk_parent_paths(wpi, &wpli->newhandle);
 		path_list_del_component(wpi->path, wpli->pc);
 		if (ret)
 			break;
@@ -198,10 +175,7 @@ handle_walk_parent_path_ptr(
 static int
 handle_walk_parent_paths(
 	struct walk_ppaths_info		*wpi,
-	struct xfs_handle		*handle,
-	uint64_t			pino,
-	char				*pname,
-	int				flags)
+	struct xfs_handle		*handle)
 {
 	struct walk_ppath_level_info	*wpli;
 	int				ret;
@@ -209,7 +183,7 @@ handle_walk_parent_paths(
 	wpli = malloc(sizeof(struct walk_ppath_level_info));
 	if (!wpli)
 		return -1;
-	wpli->pc = path_component_init("");
+	wpli->pc = path_component_init("", 0);
 	if (!wpli->pc) {
 		free(wpli);
 		return -1;
@@ -217,8 +191,8 @@ handle_walk_parent_paths(
 	wpli->wpi = wpi;
 	memcpy(&wpli->newhandle, handle, sizeof(struct xfs_handle));
 
-	ret = handle_walk_parents(wpi->fd, handle, pino, pname,
-			handle_walk_parent_path_ptr, wpli, flags);
+	ret = handle_walk_parents(wpi->fd, handle, handle_walk_parent_path_ptr,
+			wpli);
 
 	path_component_free(wpli->pc);
 	free(wpli);
@@ -233,11 +207,8 @@ int
 handle_walk_ppaths(
 	void			*hanp,
 	size_t			hlen,
-	uint64_t		pino,
-	char			*pname,
 	walk_ppath_fn		fn,
-	void			*arg,
-	int			flags)
+	void			*arg)
 {
 	struct walk_ppaths_info	wpi;
 	ssize_t			ret;
@@ -256,7 +227,7 @@ handle_walk_ppaths(
 	wpi.fn = fn;
 	wpi.arg = arg;
 
-	ret = handle_walk_parent_paths(&wpi, hanp, pino, pname, flags);
+	ret = handle_walk_parent_paths(&wpi, hanp);
 	path_list_free(wpi.path);
 
 	return ret;
@@ -269,11 +240,8 @@ handle_walk_ppaths(
 int
 fd_walk_ppaths(
 	int			fd,
-	uint64_t		pino,
-	char			*pname,
 	walk_ppath_fn		fn,
-	void			*arg,
-	int			flags)
+	void			*arg)
 {
 	struct walk_ppaths_info	wpi;
 	void			*hanp;
@@ -295,7 +263,7 @@ fd_walk_ppaths(
 	wpi.fn = fn;
 	wpi.arg = arg;
 
-	ret = handle_walk_parent_paths(&wpi, hanp, pino, pname, flags);
+	ret = handle_walk_parent_paths(&wpi, hanp);
 	path_list_free(wpi.path);
 
 	return ret;
@@ -341,8 +309,7 @@ handle_to_path(
 
 	pwi.buf = path;
 	pwi.len = pathlen;
-	return handle_walk_ppaths(hanp, hlen, 0, NULL, handle_to_path_walk,
-			&pwi, 0);
+	return handle_walk_ppaths(hanp, hlen, handle_to_path_walk, &pwi);
 }
 
 /* Return any eligible path to this file description. */
@@ -356,5 +323,5 @@ fd_to_path(
 
 	pwi.buf = path;
 	pwi.len = pathlen;
-	return fd_walk_ppaths(fd, 0, NULL, handle_to_path_walk, &pwi, 0);
+	return fd_walk_ppaths(fd, handle_to_path_walk, &pwi);
 }

