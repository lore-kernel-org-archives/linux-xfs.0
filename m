Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:55490 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727552AbeIZQiK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Sep 2018 12:38:10 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w8QANsMY087768
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:53 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2mndpphh81-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:53 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w8QAPrga005053
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:53 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w8QAPrgE032179
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:53 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v3 30/30] xfsprogs: Add i, n and f flags to parent command
Date: Wed, 26 Sep 2018 03:23:33 -0700
Message-Id: <1537957413-10630-31-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1537957413-10630-1-git-send-email-allison.henderson@oracle.com>
References: <1537957413-10630-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This patch adds the flags i, n, and f to the parent command.
These flags add filtering options that are used by the new
parent pointer tests in xfstests, and help to improve the test
run time.  The flags are:

-i: Only show parent pointer records containing the given inode
-n: Only show parent pointer records containing the given filename
-f: Print records in short format: ino/gen/namelen/name

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 include/parent.h   | 17 ++++++++----
 io/parent.c        | 80 ++++++++++++++++++++++++++++++++++++++++++------------
 libhandle/parent.c | 73 +++++++++++++++++++++++++++++++++++--------------
 3 files changed, 128 insertions(+), 42 deletions(-)

diff --git a/include/parent.h b/include/parent.h
index fb90004..2e13672 100644
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
index 0e94d96..022dcf0 100644
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
 
@@ -30,24 +31,38 @@ pptr_print(
 
 	memcpy(buf, pptr->xpp_name, pptr->xpp_namelen);
 	buf[pptr->xpp_namelen] = 0;
-	printf(_("p_ino    = %llu\n"), (unsigned long long)pptr->xpp_ino);
-	printf(_("p_gen    = %u\n"), (unsigned int)pptr->xpp_gen);
-	printf(_("p_reclen = %u\n"), (unsigned int)pptr->xpp_namelen);
-	printf(_("p_name   = \"%s\"\n\n"), buf);
+
+	if (flags & XFS_PPPTR_OFLAG_SHORT) {
+		printf("%llu/%u/%u/%s\n",
+			(unsigned long long)pptr->xpp_ino,
+			(unsigned int)pptr->xpp_gen,
+			(unsigned int)pptr->xpp_namelen,
+			buf);
+	}
+	else {
+		printf(_("p_ino    = %llu\n"), (unsigned long long)pptr->xpp_ino);
+		printf(_("p_gen    = %u\n"), (unsigned int)pptr->xpp_gen);
+		printf(_("p_reclen = %u\n"), (unsigned int)pptr->xpp_namelen);
+		printf(_("p_name   = \"%s\"\n\n"), buf);
+	}
 	return 0;
 }
 
 int
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
 
@@ -78,15 +93,19 @@ path_print(
 
 int
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
@@ -108,6 +127,9 @@ parent_f(
 	int			listpath_flag = 0;
 	int			ret;
 	static int		tab_init;
+	uint64_t		pino = 0;
+	char			*pname = NULL;
+	int			ppptr_flags = 0;
 
 	if (!tab_init) {
 		tab_init = 1;
@@ -121,11 +143,27 @@ parent_f(
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
@@ -167,9 +205,11 @@ parent_f(
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
@@ -187,6 +227,12 @@ printf(_(
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
 
@@ -197,7 +243,7 @@ parent_init(void)
 	parent_cmd.cfunc = parent_f;
 	parent_cmd.argmin = 0;
 	parent_cmd.argmax = -1;
-	parent_cmd.args = _("[-p] [ino gen]");
+	parent_cmd.args = _("[-p] [ino gen] [-i] [ino] [-n] [name] [-f]");
 	parent_cmd.flags = CMD_NOMAP_OK;
 	parent_cmd.oneline = _("print parent inodes");
 	parent_cmd.help = parent_help;
diff --git a/libhandle/parent.c b/libhandle/parent.c
index eee5ec1..72310d7 100644
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
 	ret = ioctl(fd, XFS_IOC_GETPPOINTER, pi);
 	while (!ret) {
 		if (pi->pi_flags & XFS_PPTR_OFLAG_ROOT) {
-			ret = fn(pi, NULL, arg);
+			ret = fn(pi, NULL, arg, flags);
 			break;
 		}
 
 		for (i = 0; i < pi->pi_ptrs_used; i++) {
 			p = XFS_PPINFO_TO_PP(pi, i);
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
-- 
2.7.4
