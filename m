Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:47892 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750811AbdLHEDh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Dec 2017 23:03:37 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vB842Q03034508
        for <linux-xfs@vger.kernel.org>; Fri, 8 Dec 2017 04:03:37 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2eqjvu825m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Fri, 08 Dec 2017 04:03:37 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vB843adl010073
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 8 Dec 2017 04:03:36 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vB843alD003752
        for <linux-xfs@vger.kernel.org>; Fri, 8 Dec 2017 04:03:36 GMT
Date: Thu, 7 Dec 2017 20:03:32 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [RFCRAP DONOTMERGE PATCH 2/2] xfsprogs: implement the upper half of
 parent pointers
Message-ID: <20171208040332.GF19219@magnolia>
References: <20171208035457.GD19219@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171208035457.GD19219@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Add ioctl definitions to libxfs, build the necessary helpers into
libfrog and libhandle to iterate parents (and parent paths), then wire
up xfs_scrub to be able to query parent pointers from userspace.  The
goal of this patch is to exercise userspace, and is nowhere near a
complete solution.  A basic xfs_io parent command implementation
replaces ... whatever that is that's there now.

Totally missing: actual support in libxfs for working with parent ptrs
straight off the disk (mkfs, xfs_db, xfs_repair).

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fsr/Makefile       |    5 -
 include/handle.h   |    1 
 include/parent.h   |   20 ++
 include/path.h     |   19 ++
 io/parent.c        |  459 +++++++++++++---------------------------------------
 libfrog/paths.c    |  135 +++++++++++++++
 libhandle/Makefile |    2 
 libhandle/handle.c |    7 -
 libhandle/parent.c |  324 +++++++++++++++++++++++++++++++++++++
 libxfs/xfs_fs.h    |   57 ++++++
 scrub/inodes.c     |   25 +++
 scrub/inodes.h     |    2 
 scrub/phase5.c     |    9 -
 13 files changed, 708 insertions(+), 357 deletions(-)
 create mode 100644 libhandle/parent.c

diff --git a/fsr/Makefile b/fsr/Makefile
index d3521b2..e5baf02 100644
--- a/fsr/Makefile
+++ b/fsr/Makefile
@@ -7,7 +7,10 @@ include $(TOPDIR)/include/builddefs
 
 LTCOMMAND = xfs_fsr
 CFILES = xfs_fsr.c
-LLDLIBS = $(LIBHANDLE)
+
+LLDLIBS += $(LIBHANDLE) $(LIBFROG) $(LIBPTHREAD)
+LTDEPENDENCIES += $(LIBHANDLE) $(LIBFROG)
+LLDFLAGS = -static
 
 ifeq ($(HAVE_GETMNTENT),yes)
 LCFLAGS += -DHAVE_GETMNTENT
diff --git a/include/handle.h b/include/handle.h
index 49f1441..cae0e99 100644
--- a/include/handle.h
+++ b/include/handle.h
@@ -51,6 +51,7 @@ extern int  fssetdm_by_handle (void *__hanp, size_t __hlen,
 			       struct fsdmidata *__fsdmi);
 
 void fshandle_destroy(void);
+int handle_to_fsfd(void *hanp, char **path);
 
 #ifdef __cplusplus
 }
diff --git a/include/parent.h b/include/parent.h
index f338f96..9757fb6 100644
--- a/include/parent.h
+++ b/include/parent.h
@@ -16,7 +16,25 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 #ifndef __PARENT_H__
-#define	__PARENT_H__
+#define __PARENT_H__
+
+struct path_list;
+
+typedef int (*walk_pptr_fn)(struct xfs_pptr_info *pi, struct xfs_pptr *pptr,
+		void *arg);
+typedef int (*walk_ppath_fn)(const char *mntpt, struct path_list *path,
+		void *arg);
+
+#define WALK_PPTRS_ABORT	1
+int fd_walk_pptrs(int fd, walk_pptr_fn fn, void *arg);
+int handle_walk_pptrs(void *hanp, size_t hanlen, walk_pptr_fn fn, void *arg);
+
+#define WALK_PPATHS_ABORT	1
+int fd_walk_ppaths(int fd, walk_ppath_fn fn, void *arg);
+int handle_walk_ppaths(void *hanp, size_t hanlen, walk_ppath_fn fn, void *arg);
+
+int fd_to_path(int fd, char *path, size_t pathlen);
+int handle_to_path(void *hanp, size_t hlen, char *path, size_t pathlen);
 
 typedef struct parent {
 	__u64	p_ino;
diff --git a/include/path.h b/include/path.h
index 1d3a902..9b0c8a3 100644
--- a/include/path.h
+++ b/include/path.h
@@ -69,4 +69,23 @@ typedef struct fs_cursor {
 extern void fs_cursor_initialise(char *__dir, uint __flags, fs_cursor_t *__cp);
 extern fs_path_t *fs_cursor_next_entry(fs_cursor_t *__cp);
 
+/* Path information. */
+
+struct path_list;
+struct path_component;
+
+struct path_component *path_component_init(const char *name);
+void path_component_free(struct path_component *pc);
+int path_component_change(struct path_component *pc, void *name,
+		size_t namelen);
+
+struct path_list *path_list_init(void);
+void path_list_free(struct path_list *path);
+void path_list_add_parent_component(struct path_list *path,
+		struct path_component *pc);
+void path_list_add_component(struct path_list *path, struct path_component *pc);
+void path_list_del_component(struct path_list *path, struct path_component *pc);
+
+ssize_t path_list_to_string(struct path_list *path, char *buf, size_t buflen);
+
 #endif	/* __PATH_H__ */
diff --git a/io/parent.c b/io/parent.c
index 1968516..3adbc0d 100644
--- a/io/parent.c
+++ b/io/parent.c
@@ -21,363 +21,108 @@
 #include "path.h"
 #include "parent.h"
 #include "handle.h"
-#include "jdm.h"
 #include "init.h"
 #include "io.h"
 
-#define PARENTBUF_SZ		16384
-#define BSTATBUF_SZ		16384
-
 static cmdinfo_t parent_cmd;
-static int verbose_flag;
-static int err_status;
-static __u64 inodes_checked;
 static char *mntpt;
 
-/*
- * check out a parent entry to see if the values seem valid
- */
-static void
-check_parent_entry(xfs_bstat_t *bstatp, parent_t *parent)
+static int
+pptr_print(
+	struct xfs_pptr_info	*pi,
+	struct xfs_pptr		*pptr,
+	void			*arg)
 {
-	int sts;
-	char fullpath[PATH_MAX];
-	struct stat statbuf;
-	char *str;
-
-	sprintf(fullpath, _("%s%s"), mntpt, parent->p_name);
+	char			buf[XFS_PPTR_NAME_MAX + 1];
 
-	sts = lstat(fullpath, &statbuf);
-	if (sts != 0) {
-		fprintf(stderr,
-			_("inode-path for inode: %llu is incorrect - path \"%s\" non-existent\n"),
-			(unsigned long long) bstatp->bs_ino, fullpath);
-		if (verbose_flag) {
-			fprintf(stderr,
-				_("path \"%s\" does not stat for inode: %llu; err = %s\n"),
-				fullpath,
-			       (unsigned long long) bstatp->bs_ino,
-				strerror(errno));
-		}
-		err_status++;
-		return;
-	} else {
-		if (verbose_flag > 1) {
-			printf(_("path \"%s\" found\n"), fullpath);
-		}
-	}
-
-	if (statbuf.st_ino != bstatp->bs_ino) {
-		fprintf(stderr,
-			_("inode-path for inode: %llu is incorrect - wrong inode#\n"),
-		       (unsigned long long) bstatp->bs_ino);
-		if (verbose_flag) {
-			fprintf(stderr,
-				_("ino mismatch for path \"%s\" %llu vs %llu\n"),
-				fullpath,
-				(unsigned long long)statbuf.st_ino,
-				(unsigned long long)bstatp->bs_ino);
-		}
-		err_status++;
-		return;
-	} else if (verbose_flag > 1) {
-		printf(_("inode number match: %llu\n"),
-			(unsigned long long)statbuf.st_ino);
+	if (pi->pi_oflags & XFS_PPTR_OFLAG_ROOT) {
+		printf(_("Root directory.\n"));
+		return 0;
 	}
 
-	/* get parent path */
-	str = strrchr(fullpath, '/');
-	*str = '\0';
-	sts = stat(fullpath, &statbuf);
-	if (sts != 0) {
-		fprintf(stderr,
-			_("parent path \"%s\" does not stat: %s\n"),
-			fullpath,
-			strerror(errno));
-		err_status++;
-		return;
-	} else {
-		if (parent->p_ino != statbuf.st_ino) {
-			fprintf(stderr,
-				_("inode-path for inode: %llu is incorrect - wrong parent inode#\n"),
-			       (unsigned long long) bstatp->bs_ino);
-			if (verbose_flag) {
-				fprintf(stderr,
-					_("ino mismatch for path \"%s\" %llu vs %llu\n"),
-					fullpath,
-					(unsigned long long)parent->p_ino,
-					(unsigned long long)statbuf.st_ino);
-			}
-			err_status++;
-			return;
-		} else {
-			if (verbose_flag > 1) {
-			       printf(_("parent ino match for %llu\n"),
-				       (unsigned long long) parent->p_ino);
-			}
-		}
-	}
+	memcpy(buf, pptr->pp_name, pptr->pp_namelen);
+	buf[pptr->pp_namelen] = 0;
+	printf(_("pp_ino  = %llu\n"), (unsigned long long)pptr->pp_ino);
+	printf(_("pp_gen  = %u\n"), (unsigned int)pptr->pp_gen);
+	printf(_("pp_name = \"%s\"\n"), buf);
+	return 0;
 }
 
-static void
-check_parents(parent_t *parentbuf, size_t *parentbuf_size,
-	     jdm_fshandle_t *fshandlep, xfs_bstat_t *statp)
+int
+print_parents(
+	struct xfs_handle	*handle)
 {
-	int error, i;
-	__u32 count;
-	parent_t *entryp;
-
-	do {
-		error = jdm_parentpaths(fshandlep, statp, parentbuf, *parentbuf_size, &count);
-
-		if (error == ERANGE) {
-			*parentbuf_size *= 2;
-			parentbuf = (parent_t *)realloc(parentbuf, *parentbuf_size);
-		} else if (error) {
-			fprintf(stderr, _("parentpaths failed for ino %llu: %s\n"),
-			       (unsigned long long) statp->bs_ino,
-				strerror(errno));
-			err_status++;
-			break;
-		}
-	} while (error == ERANGE);
-
+	int			ret;
 
-	if (count == 0) {
-		/* no links for inode - something wrong here */
-	       fprintf(stderr, _("inode-path for inode: %llu is missing\n"),
-			       (unsigned long long) statp->bs_ino);
-		err_status++;
-	}
+	if (handle)
+		ret = handle_walk_pptrs(handle, sizeof(*handle), pptr_print,
+				NULL);
+	else
+		ret = fd_walk_pptrs(file->fd, pptr_print, NULL);
+	if (ret)
+		perror(file->name);
 
-	entryp = parentbuf;
-	for (i = 0; i < count; i++) {
-		check_parent_entry(statp, entryp);
-		entryp = (parent_t*) (((char*)entryp) + entryp->p_reclen);
-	}
+	return 0;
 }
 
 static int
-do_bulkstat(parent_t *parentbuf, size_t *parentbuf_size, xfs_bstat_t *bstatbuf,
-	    int fsfd, jdm_fshandle_t *fshandlep)
+path_print(
+	const char		*mntpt,
+	struct path_list	*path,
+	void			*arg)
 {
-	__s32 buflenout;
-	__u64 lastino = 0;
-	xfs_bstat_t *p;
-	xfs_bstat_t *endp;
-	xfs_fsop_bulkreq_t bulkreq;
-	struct stat mntstat;
+	char			buf[PATH_MAX];
+	size_t			len = PATH_MAX;
+	int			ret;
 
-	if (stat(mntpt, &mntstat)) {
-		fprintf(stderr, _("can't stat mount point \"%s\": %s\n"),
-			mntpt, strerror(errno));
-		return 1;
+	ret = snprintf(buf, len, "%s", mntpt);
+	if (ret != strlen(mntpt)) {
+		errno = ENOMEM;
+		return -1;
 	}
 
-	bulkreq.lastip  = &lastino;
-	bulkreq.icount  = BSTATBUF_SZ;
-	bulkreq.ubuffer = (void *)bstatbuf;
-	bulkreq.ocount  = &buflenout;
-
-	while (xfsctl(mntpt, fsfd, XFS_IOC_FSBULKSTAT, &bulkreq) == 0) {
-		if (*(bulkreq.ocount) == 0) {
-			return 0;
-		}
-		for (p = bstatbuf, endp = bstatbuf + *bulkreq.ocount; p < endp; p++) {
-
-			/* inode being modified, get synced data with iget */
-			if ( (!p->bs_nlink || !p->bs_mode) && p->bs_ino != 0 ) {
-
-				if (xfsctl(mntpt, fsfd, XFS_IOC_FSBULKSTAT_SINGLE, &bulkreq) < 0) {
-				    fprintf(stderr,
-					  _("failed to get bulkstat information for inode %llu\n"),
-					 (unsigned long long) p->bs_ino);
-				    continue;
-				}
-				if (!p->bs_nlink || !p->bs_mode || !p->bs_ino) {
-				    fprintf(stderr,
-					  _("failed to get valid bulkstat information for inode %llu\n"),
-					 (unsigned long long) p->bs_ino);
-				    continue;
-				}
-			}
-
-			/* skip root */
-			if (p->bs_ino == mntstat.st_ino) {
-				continue;
-			}
-
-			if (verbose_flag > 1) {
-			       printf(_("checking inode %llu\n"),
-				       (unsigned long long) p->bs_ino);
-			}
+	ret = path_list_to_string(path, buf + ret, len - ret);
+	if (ret < 0)
+		return ret;
 
-			/* print dotted progress */
-			if ((inodes_checked % 100) == 0 && verbose_flag == 1) {
-				printf("."); fflush(stdout);
-			}
-			inodes_checked++;
+	printf("%s\n", buf);
 
-			check_parents(parentbuf, parentbuf_size, fshandlep, p);
-		}
-
-	}/*while*/
-
-	fprintf(stderr, _("syssgi bulkstat failed: %s\n"), strerror(errno));
-	return 1;
+	return 0;
 }
 
-static int
-parent_check(void)
+int
+print_paths(
+	struct xfs_handle	*handle)
 {
-	int fsfd;
-	jdm_fshandle_t *fshandlep;
-	parent_t *parentbuf;
-	size_t parentbuf_size = PARENTBUF_SZ;
-	xfs_bstat_t *bstatbuf;
-
-	err_status = 0;
-	inodes_checked = 0;
-
-	sync();
-
-        fsfd = file->fd;
-
-	fshandlep = jdm_getfshandle(mntpt);
-	if (fshandlep == NULL) {
-		fprintf(stderr, _("unable to open \"%s\" for jdm: %s\n"),
-		      mntpt,
-		      strerror(errno));
-		return 1;
-	}
-
-	/* allocate buffers */
-        bstatbuf = (xfs_bstat_t *)calloc(BSTATBUF_SZ, sizeof(xfs_bstat_t));
-	parentbuf = (parent_t *)malloc(parentbuf_size);
-	if (!bstatbuf || !parentbuf) {
-		fprintf(stderr, _("unable to allocate buffers: %s\n"),
-			strerror(errno));
-		err_status = 1;
-		goto out;
-	}
-
-	if (do_bulkstat(parentbuf, &parentbuf_size, bstatbuf, fsfd, fshandlep) != 0)
-		err_status++;
-
-	if (err_status > 0)
-		fprintf(stderr, _("num errors: %d\n"), err_status);
-	else
-		printf(_("succeeded checking %llu inodes\n"),
-			(unsigned long long) inodes_checked);
+	int			ret;
 
-out:
-	free(bstatbuf);
-	free(parentbuf);
-	free(fshandlep);
-	return err_status;
-}
-
-static void
-print_parent_entry(parent_t *parent, int fullpath)
-{
-       printf(_("p_ino    = %llu\n"),  (unsigned long long) parent->p_ino);
-	printf(_("p_gen    = %u\n"),	parent->p_gen);
-	printf(_("p_reclen = %u\n"),	parent->p_reclen);
-	if (fullpath)
-		printf(_("p_name   = \"%s%s\"\n"), mntpt, parent->p_name);
+	if (handle)
+		ret = handle_walk_ppaths(handle, sizeof(*handle), path_print,
+				NULL);
 	else
-		printf(_("p_name   = \"%s\"\n"), parent->p_name);
-}
-
-static int
-parent_list(int fullpath)
-{
-	void *handlep = NULL;
-	size_t handlen;
-	int error, i;
-	int retval = 1;
-	__u32 count;
-	parent_t *entryp;
-	parent_t *parentbuf = NULL;
-	char *path = file->name;
-	int pb_size = PARENTBUF_SZ;
-
-	/* XXXX for linux libhandle version - to set libhandle fsfd cache */
-	{
-		void *fshandle;
-		size_t fshlen;
-
-		if (path_to_fshandle(mntpt, &fshandle, &fshlen) != 0) {
-			fprintf(stderr, _("%s: failed path_to_fshandle \"%s\": %s\n"),
-				progname, path, strerror(errno));
-			goto error;
-		}
-		free_handle(fshandle, fshlen);
-	}
+		ret = fd_walk_ppaths(file->fd, path_print, NULL);
+	if (ret)
+		perror(file->name);
 
-	if (path_to_handle(path, &handlep, &handlen) != 0) {
-		fprintf(stderr, _("%s: path_to_handle failed for \"%s\"\n"), progname, path);
-		goto error;
-	}
-
-	do {
-		parentbuf = (parent_t *)realloc(parentbuf, pb_size);
-		if (!parentbuf) {
-			fprintf(stderr, _("%s: unable to allocate parent buffer: %s\n"),
-				progname, strerror(errno));
-			goto error;
-		}
-
-		if (fullpath) {
-			error = parentpaths_by_handle(handlep,
-						       handlen,
-						       parentbuf,
-						       pb_size,
-						       &count);
-		} else {
-			error = parents_by_handle(handlep,
-						   handlen,
-						   parentbuf,
-						   pb_size,
-						   &count);
-		}
-		if (error == ERANGE) {
-			pb_size *= 2;
-		} else if (error) {
-			fprintf(stderr, _("%s: %s call failed for \"%s\": %s\n"),
-				progname, fullpath ? "parentpaths" : "parents",
-				path, strerror(errno));
-			goto error;
-		}
-	} while (error == ERANGE);
-
-	if (count == 0) {
-		/* no links for inode - something wrong here */
-		fprintf(stderr, _("%s: inode-path is missing\n"), progname);
-		goto error;
-	}
-
-	entryp = parentbuf;
-	for (i = 0; i < count; i++) {
-		print_parent_entry(entryp, fullpath);
-		entryp = (parent_t*) (((char*)entryp) + entryp->p_reclen);
-	}
-
-	retval = 0;
-error:
-	free(handlep);
-	free(parentbuf);
-	return retval;
+	return 0;
 }
 
 int
-parent_f(int argc, char **argv)
+parent_f(
+	int			argc,
+	char			**argv)
 {
-	int c;
-	int listpath_flag = 0;
-	int check_flag = 0;
-	fs_path_t *fs;
-	static int tab_init;
+	struct xfs_handle	handle;
+	void			*hanp = NULL;
+	size_t			hlen;
+	struct fs_path		*fs;
+	char			*p;
+	uint64_t		ino = 0;
+	uint32_t		gen = 0;
+	int			c;
+	int			listpath_flag = 0;
+	int			ret;
+	static int		tab_init;
 
 	if (!tab_init) {
 		tab_init = 1;
@@ -391,33 +136,59 @@ parent_f(int argc, char **argv)
 	}
 	mntpt = fs->fs_dir;
 
-	verbose_flag = 0;
-
-	while ((c = getopt(argc, argv, "cpv")) != EOF) {
+	while ((c = getopt(argc, argv, "p")) != EOF) {
 		switch (c) {
-		case 'c':
-			check_flag = 1;
-			break;
 		case 'p':
 			listpath_flag = 1;
 			break;
-		case 'v':
-			verbose_flag++;
-			break;
 		default:
 			return command_usage(&parent_cmd);
 		}
 	}
 
-	if (!check_flag && !listpath_flag) /* default case */
-		exitcode = parent_list(listpath_flag);
-	else {
-		if (listpath_flag)
-			exitcode = parent_list(listpath_flag);
-		if (check_flag)
-			exitcode = parent_check();
+	/*
+	 * Always initialize the fshandle table because we need it for
+	 * the ppaths functions to work.
+	 */
+	ret = path_to_fshandle(mntpt, &hanp, &hlen);
+	if (ret) {
+		perror(mntpt);
+		return 0;
 	}
 
+	if (optind + 2 == argc) {
+		ino = strtoull(argv[optind], &p, 0);
+		if (*p != '\0' || ino == 0) {
+			fprintf(stderr,
+				_("Bad inode number '%s'.\n"),
+				argv[optind]);
+			return 0;
+		}
+		gen = strtoul(argv[optind + 1], &p, 0);
+		if (*p != '\0') {
+			fprintf(stderr,
+				_("Bad generation number '%s'.\n"),
+				argv[optind + 1]);
+			return 0;
+		}
+
+		memcpy(&handle, hanp, sizeof(handle));
+		handle.ha_fid.fid_len = sizeof(xfs_fid_t) -
+				sizeof(handle.ha_fid.fid_len);
+		handle.ha_fid.fid_pad = 0;
+		handle.ha_fid.fid_ino = ino;
+		handle.ha_fid.fid_gen = gen;
+
+	}
+
+	if (listpath_flag)
+		exitcode = print_paths(ino ? &handle : NULL);
+	else
+		exitcode = print_parents(ino ? &handle : NULL);
+
+	if (hanp)
+		free_handle(hanp, hlen);
+
 	return 0;
 }
 
@@ -428,9 +199,9 @@ parent_help(void)
 "\n"
 " list the current file's parents and their filenames\n"
 "\n"
-" -c -- check the current file's file system for parent consistency\n"
-" -p -- list the current file's parents and their full paths\n"
-" -v -- verbose mode\n"
+" -p -- list the current file's paths up to the root\n"
+"\n"
+"If ino and gen are supplied, use them instead.\n"
 "\n"));
 }
 
@@ -441,9 +212,9 @@ parent_init(void)
 	parent_cmd.cfunc = parent_f;
 	parent_cmd.argmin = 0;
 	parent_cmd.argmax = -1;
-	parent_cmd.args = _("[-cpv]");
+	parent_cmd.args = _("[-p] [ino gen]");
 	parent_cmd.flags = CMD_NOMAP_OK;
-	parent_cmd.oneline = _("print or check parent inodes");
+	parent_cmd.oneline = _("print parent inodes");
 	parent_cmd.help = parent_help;
 
 	if (expert)
diff --git a/libfrog/paths.c b/libfrog/paths.c
index 62b4eda..62a0af3 100644
--- a/libfrog/paths.c
+++ b/libfrog/paths.c
@@ -27,6 +27,7 @@
 #include "path.h"
 #include "input.h"
 #include "project.h"
+#include "list.h"
 #include <limits.h>
 
 extern char *progname;
@@ -604,3 +605,137 @@ fs_table_insert_project_path(
 		exit(1);
 	}
 }
+
+/* Structured path components. */
+
+struct path_list {
+	struct list_head	p_head;
+};
+
+struct path_component {
+	struct list_head	pc_list;
+	char			*pc_fname;
+};
+
+/* Initialize a path component with a given name. */
+struct path_component *
+path_component_init(
+	const char		*name)
+{
+	struct path_component	*pc;
+
+	pc = malloc(sizeof(struct path_component));
+	if (!pc)
+		return NULL;
+	INIT_LIST_HEAD(&pc->pc_list);
+	pc->pc_fname = strdup(name);
+	if (!pc->pc_fname) {
+		free(pc);
+		return NULL;
+	}
+	return pc;
+}
+
+/* Free a path component. */
+void
+path_component_free(
+	struct path_component	*pc)
+{
+	free(pc->pc_fname);
+	free(pc);
+}
+
+/* Change a path component's filename. */
+int
+path_component_change(
+	struct path_component	*pc,
+	void			*name,
+	size_t			namelen)
+{
+	void			*p;
+
+	p = realloc(pc->pc_fname, namelen + 1);
+	if (!p)
+		return -1;
+	pc->pc_fname = p;
+	memcpy(pc->pc_fname, name, namelen);
+	pc->pc_fname[namelen] = 0;
+	return 0;
+}
+
+/* Initialize a pathname. */
+struct path_list *
+path_list_init(void)
+{
+	struct path_list	*path;
+
+	path = malloc(sizeof(struct path_list));
+	if (!path)
+		return NULL;
+	INIT_LIST_HEAD(&path->p_head);
+	return path;
+}
+
+/* Empty out a pathname. */
+void
+path_list_free(
+	struct path_list	*path)
+{
+	struct path_component	*pos;
+	struct path_component	*n;
+
+	list_for_each_entry_safe(pos, n, &path->p_head, pc_list) {
+		path_list_del_component(path, pos);
+		path_component_free(pos);
+	}
+	free(path);
+}
+
+/* Add a parent component to a pathname. */
+void
+path_list_add_parent_component(
+	struct path_list	*path,
+	struct path_component	*pc)
+{
+	list_add(&pc->pc_list, &path->p_head);
+}
+
+/* Add a component to a pathname. */
+void
+path_list_add_component(
+	struct path_list	*path,
+	struct path_component	*pc)
+{
+	list_add_tail(&pc->pc_list, &path->p_head);
+}
+
+/* Remove a component from a pathname. */
+void
+path_list_del_component(
+	struct path_list	*path,
+	struct path_component	*pc)
+{
+	list_del_init(&pc->pc_list);
+}
+
+/* Convert a pathname into a string. */
+ssize_t
+path_list_to_string(
+	struct path_list	*path,
+	char			*buf,
+	size_t			buflen)
+{
+	struct path_component	*pos;
+	ssize_t			bytes = 0;
+	int			ret;
+
+	list_for_each_entry(pos, &path->p_head, pc_list) {
+		ret = snprintf(buf, buflen, "/%s", pos->pc_fname);
+		if (ret != 1 + strlen(pos->pc_fname))
+			return -1;
+		bytes += ret;
+		buf += ret;
+		buflen -= ret;
+	}
+	return bytes;
+}
diff --git a/libhandle/Makefile b/libhandle/Makefile
index fe1a2af..d3cea41 100644
--- a/libhandle/Makefile
+++ b/libhandle/Makefile
@@ -16,7 +16,7 @@ else
 LTLDFLAGS += -Wl,--version-script,libhandle.sym
 endif
 
-CFILES = handle.c jdm.c
+CFILES = handle.c jdm.c parent.c
 LSRCFILES = libhandle.sym
 
 default: ltdepend $(LTLIBRARY)
diff --git a/libhandle/handle.c b/libhandle/handle.c
index 878d14d..a70fa32 100644
--- a/libhandle/handle.c
+++ b/libhandle/handle.c
@@ -41,7 +41,6 @@ typedef union {
 } comarg_t;
 
 static int obj_to_handle(char *, int, unsigned int, comarg_t, void**, size_t*);
-static int handle_to_fsfd(void *, char **);
 static char *path_to_fspath(char *path);
 
 
@@ -214,8 +213,10 @@ handle_to_fshandle(
 	return 0;
 }
 
-static int
-handle_to_fsfd(void *hanp, char **path)
+int
+handle_to_fsfd(
+	void		*hanp,
+	char		**path)
 {
 	struct fdhash	*fdhp;
 
diff --git a/libhandle/parent.c b/libhandle/parent.c
new file mode 100644
index 0000000..6d0f50e
--- /dev/null
+++ b/libhandle/parent.c
@@ -0,0 +1,324 @@
+/*
+ * Copyright (C) 2017 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#include "platform_defs.h"
+#include "xfs.h"
+#include "xfs_arch.h"
+#include "list.h"
+#include "path.h"
+#include "handle.h"
+#include "parent.h"
+
+/* Allocate a buffer large enough for some parent pointer records. */
+static inline struct xfs_pptr_info *
+xfs_pptr_alloc(
+      size_t                  nr_ptrs)
+{
+      struct xfs_pptr_info    *pi;
+
+      pi = malloc(XFS_PPTR_INFO_SIZEOF(nr_ptrs));
+      if (!pi)
+              return NULL;
+      memset(pi, 0, sizeof(struct xfs_pptr_info));
+      pi->pi_ptrs_size = nr_ptrs;
+      return pi;
+}
+
+/* Walk all parents of the given file handle. */
+static int
+handle_walk_parents(
+	int			fd,
+	struct xfs_handle	*handle,
+	walk_pptr_fn		fn,
+	void			*arg)
+{
+	struct xfs_pptr_info	*pi;
+	struct xfs_pptr		*p;
+	unsigned int		i;
+	ssize_t			ret = -1;
+
+	pi = xfs_pptr_alloc(4);
+	if (!pi)
+		return -1;
+
+	p = pi->pi_ptrs;
+	if (handle) {
+		memcpy(&pi->pi_handle, handle, sizeof(struct xfs_handle));
+		pi->pi_iflags = XFS_PPTR_IFLAG_HANDLE;
+	}
+
+	ret = ioctl(fd, XFS_IOC_GET_PPTR, pi);
+	while (!ret) {
+		if (pi->pi_oflags & XFS_PPTR_OFLAG_ROOT) {
+			ret = fn(pi, NULL, arg);
+			break;
+		}
+		if (pi->pi_ptrs_used == 0)
+			break;
+		for (i = 0, p = pi->pi_ptrs; i < pi->pi_ptrs_used; i++, p++) {
+			ret = fn(pi, p, arg);
+			if (ret)
+				goto out_pi;
+		}
+		ret = ioctl(fd, XFS_IOC_GET_PPTR, pi);
+	}
+
+out_pi:
+	free(pi);
+	return ret;
+}
+
+/* Walk all parent pointers of this handle. */
+int
+handle_walk_pptrs(
+	void			*hanp,
+	size_t			hlen,
+	walk_pptr_fn		fn,
+	void			*arg)
+{
+	char			*mntpt;
+	int			fd;
+
+	if (hlen != sizeof(struct xfs_handle)) {
+		errno = EINVAL;
+		return -1;
+	}
+
+	fd = handle_to_fsfd(hanp, &mntpt);
+	if (fd < 0)
+		return -1;
+
+	return handle_walk_parents(fd, hanp, fn, arg);
+}
+
+/* Walk all parent pointers of this fd. */
+int
+fd_walk_pptrs(
+	int			fd,
+	walk_pptr_fn		fn,
+	void			*arg)
+{
+	return handle_walk_parents(fd, NULL, fn, arg);
+}
+
+struct walk_ppaths_info {
+	walk_ppath_fn			fn;
+	void				*arg;
+	char				*mntpt;
+	struct path_list		*path;
+	int				fd;
+};
+
+struct walk_ppath_level_info {
+	struct xfs_handle		newhandle;
+	struct path_component		*pc;
+	struct walk_ppaths_info		*wpi;
+};
+
+static int handle_walk_parent_paths(struct walk_ppaths_info *wpi,
+		struct xfs_handle *handle);
+
+static int
+handle_walk_parent_path_ptr(
+	struct xfs_pptr_info		*pi,
+	struct xfs_pptr			*p,
+	void				*arg)
+{
+	struct walk_ppath_level_info	*wpli = arg;
+	struct walk_ppaths_info		*wpi = wpli->wpi;
+	unsigned int			i;
+	int				ret = 0;
+
+	if (pi->pi_oflags & XFS_PPTR_OFLAG_ROOT)
+		return wpi->fn(wpi->mntpt, wpi->path, wpi->arg);
+
+	for (i = 0, p = pi->pi_ptrs; i < pi->pi_ptrs_used; i++, p++) {
+		ret = path_component_change(wpli->pc, p->pp_name,
+				p->pp_namelen);
+		if (ret)
+			break;
+		wpli->newhandle.ha_fid.fid_ino = p->pp_ino;
+		wpli->newhandle.ha_fid.fid_gen = p->pp_gen;
+		path_list_add_parent_component(wpi->path, wpli->pc);
+		ret = handle_walk_parent_paths(wpi, &wpli->newhandle);
+		path_list_del_component(wpi->path, wpli->pc);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
+
+/*
+ * Recursively walk all parents of the given file handle; if we hit the
+ * fs root then we call the associated function with the constructed path.
+ */
+static int
+handle_walk_parent_paths(
+	struct walk_ppaths_info		*wpi,
+	struct xfs_handle		*handle)
+{
+	struct walk_ppath_level_info	*wpli;
+	int				ret;
+
+	wpli = malloc(sizeof(struct walk_ppath_level_info));
+	if (!wpli)
+		return -1;
+	wpli->pc = path_component_init("");
+	if (!wpli->pc) {
+		free(wpli);
+		return -1;
+	}
+	wpli->wpi = wpi;
+	memcpy(&wpli->newhandle, handle, sizeof(struct xfs_handle));
+
+	ret = handle_walk_parents(wpi->fd, handle, handle_walk_parent_path_ptr,
+			wpli);
+
+	path_component_free(wpli->pc);
+	free(wpli);
+	return ret;
+}
+
+/*
+ * Call the given function on all known paths from the vfs root to the inode
+ * described in the handle.
+ */
+int
+handle_walk_ppaths(
+	void			*hanp,
+	size_t			hlen,
+	walk_ppath_fn		fn,
+	void			*arg)
+{
+	struct walk_ppaths_info	wpi;
+	ssize_t			ret;
+
+	if (hlen != sizeof(struct xfs_handle)) {
+		errno = EINVAL;
+		return -1;
+	}
+
+	wpi.fd = handle_to_fsfd(hanp, &wpi.mntpt);
+	if (wpi.fd < 0)
+		return -1;
+	wpi.path = path_list_init();
+	if (!wpi.path)
+		return -1;
+	wpi.fn = fn;
+	wpi.arg = arg;
+
+	ret = handle_walk_parent_paths(&wpi, hanp);
+	path_list_free(wpi.path);
+
+	return ret;
+}
+
+/*
+ * Call the given function on all known paths from the vfs root to the inode
+ * referred to by the file description.
+ */
+int
+fd_walk_ppaths(
+	int			fd,
+	walk_ppath_fn		fn,
+	void			*arg)
+{
+	struct walk_ppaths_info	wpi;
+	void			*hanp;
+	size_t			hlen;
+	int			fsfd;
+	int			ret;
+
+	ret = fd_to_handle(fd, &hanp, &hlen);
+	if (ret)
+		return ret;
+
+	fsfd = handle_to_fsfd(hanp, &wpi.mntpt);
+	if (fsfd < 0)
+		return -1;
+	wpi.fd = fd;
+	wpi.path = path_list_init();
+	if (!wpi.path)
+		return -1;
+	wpi.fn = fn;
+	wpi.arg = arg;
+
+	ret = handle_walk_parent_paths(&wpi, hanp);
+	path_list_free(wpi.path);
+
+	return ret;
+}
+
+struct path_walk_info {
+	char			*buf;
+	size_t			len;
+};
+
+/* Helper that stringifies the first full path that we find. */
+static int
+handle_to_path_walk(
+	const char		*mntpt,
+	struct path_list	*path,
+	void			*arg)
+{
+	struct path_walk_info	*pwi = arg;
+	int			ret;
+
+	ret = snprintf(pwi->buf, pwi->len, "%s", mntpt);
+	if (ret != strlen(mntpt)) {
+		errno = ENOMEM;
+		return -1;
+	}
+
+	ret = path_list_to_string(path, pwi->buf + ret, pwi->len - ret);
+	if (ret < 0)
+		return ret;
+
+	return WALK_PPATHS_ABORT;
+}
+
+/* Return any eligible path to this file handle. */
+int
+handle_to_path(
+	void			*hanp,
+	size_t			hlen,
+	char			*path,
+	size_t			pathlen)
+{
+	struct path_walk_info	pwi;
+
+	pwi.buf = path;
+	pwi.len = pathlen;
+	return handle_walk_ppaths(hanp, hlen, handle_to_path_walk, &pwi);
+}
+
+/* Return any eligible path to this file description. */
+int
+fd_to_path(
+	int			fd,
+	char			*path,
+	size_t			pathlen)
+{
+	struct path_walk_info	pwi;
+
+	pwi.buf = path;
+	pwi.len = pathlen;
+	return fd_walk_ppaths(fd, handle_to_path_walk, &pwi);
+}
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 319b2a6..f555360 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -566,6 +566,62 @@ struct xfs_scrub_metadata {
 				 XFS_SCRUB_OFLAG_WARNING)
 #define XFS_SCRUB_FLAGS_ALL	(XFS_SCRUB_FLAGS_IN | XFS_SCRUB_FLAGS_OUT)
 
+/* Parent Pointers */
+#define XFS_PPTR_NAME_MAX	256
+
+struct xfs_pptr {
+	/* Parent inode number. */
+	__u64				pp_ino;
+	__u64				pp_reserved[2];
+
+	/* Parent generation number. */
+	__u32				pp_gen;
+
+	/* Name in the parent. */
+	__u32				pp_namelen;
+	__u8				pp_name[XFS_PPTR_NAME_MAX];
+};
+
+/* return parents of the handle, not the open fd */
+#define XFS_PPTR_IFLAG_HANDLE	(1U << 0)
+
+#define XFS_PPTR_ALL_IFLAGS	(XFS_PPTR_IFLAG_HANDLE)
+
+/* partial results only */
+#define XFS_PPTR_OFLAG_PARTIAL	(1U << 0)
+
+/* target was the root directory */
+#define XFS_PPTR_OFLAG_ROOT	(1U << 1)
+
+struct xfs_pptr_info {
+	/* i: (optional) file handle. */
+	struct xfs_handle		pi_handle;
+
+	/* i/o: xattr lookup cursor, if necessary */
+	struct xfs_attrlist_cursor	pi_cursor;
+
+	/* i: input flags */
+	__u32				pi_iflags;
+
+	/* o: output flags */
+	__u32				pi_oflags;
+
+	/* i: number of pointers we have space for. */
+	__u32				pi_ptrs_size;
+
+	/* o: number of pointers actually returned. */
+	__u32				pi_ptrs_used;
+
+	/* must be zero */
+	__u64				pi_reserved[6];
+
+	/* o: pointer info, must come last */
+	struct xfs_pptr			pi_ptrs[];
+};
+
+#define XFS_PPTR_INFO_SIZEOF(nr_ptrs)	(sizeof(struct xfs_pptr_info) + \
+					((nr_ptrs) * sizeof(struct xfs_pptr)))
+
 /*
  * ioctl limits
  */
@@ -609,6 +665,7 @@ struct xfs_scrub_metadata {
 #define XFS_IOC_FREE_EOFBLOCKS	_IOR ('X', 58, struct xfs_fs_eofblocks)
 /*	XFS_IOC_GETFSMAP ------ hoisted 59         */
 #define XFS_IOC_SCRUB_METADATA	_IOWR('X', 60, struct xfs_scrub_metadata)
+#define XFS_IOC_GET_PPTR	_IOWR('X', 61, struct xfs_pptr_info)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s
diff --git a/scrub/inodes.c b/scrub/inodes.c
index c880c36..076ea6f 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -33,6 +33,7 @@
 #include "xfs_scrub.h"
 #include "common.h"
 #include "inodes.h"
+#include "parent.h"
 
 /*
  * Iterate a range of inodes.
@@ -282,3 +283,27 @@ xfs_open_handle(
 	return open_by_fshandle(handle, sizeof(*handle),
 			O_RDONLY | O_NOATIME | O_NOFOLLOW | O_NOCTTY);
 }
+
+/* Construct a description for an inode. */
+void
+xfs_scrub_ino_descr(
+	struct scrub_ctx	*ctx,
+	struct xfs_handle	*handle,
+	char			*buf,
+	size_t			buflen)
+{
+	uint64_t		ino;
+	xfs_agnumber_t		agno;
+	xfs_agino_t		agino;
+	int			ret;
+
+	ret = handle_to_path(handle, sizeof(struct xfs_handle), buf, buflen);
+	if (ret >= 0)
+		return;
+
+	ino = handle->ha_fid.fid_ino;
+	agno = ino / (1ULL << (ctx->inopblog + ctx->agblklog));
+	agino = ino % (1ULL << (ctx->inopblog + ctx->agblklog));
+	snprintf(buf, buflen, _("inode %"PRIu64" (%u/%u)"), ino, agno,
+			agino);
+}
diff --git a/scrub/inodes.h b/scrub/inodes.h
index c398677..912985e 100644
--- a/scrub/inodes.h
+++ b/scrub/inodes.h
@@ -28,5 +28,7 @@ bool xfs_scan_all_inodes(struct scrub_ctx *ctx, xfs_inode_iter_fn fn,
 		void *arg);
 
 int xfs_open_handle(struct xfs_handle *handle);
+void xfs_scrub_ino_descr(struct scrub_ctx *ctx, struct xfs_handle *handle,
+		char *buf, size_t buflen);
 
 #endif /* XFS_SCRUB_INODES_H_ */
diff --git a/scrub/phase5.c b/scrub/phase5.c
index 72b7cda..ba2e412 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -253,16 +253,11 @@ xfs_scrub_connections(
 	void			*arg)
 {
 	bool			*pmoveon = arg;
-	char			descr[DESCR_BUFSZ];
+	char			descr[PATH_MAX];
 	bool			moveon;
-	xfs_agnumber_t		agno;
-	xfs_agino_t		agino;
 	int			fd = -1;
 
-	agno = bstat->bs_ino / (1ULL << (ctx->inopblog + ctx->agblklog));
-	agino = bstat->bs_ino % (1ULL << (ctx->inopblog + ctx->agblklog));
-	snprintf(descr, DESCR_BUFSZ, _("inode %"PRIu64" (%u/%u)"),
-			(uint64_t)bstat->bs_ino, agno, agino);
+	xfs_scrub_ino_descr(ctx, handle, descr, PATH_MAX);
 	background_sleep();
 
         /* Warn about naming problems in xattrs. */
