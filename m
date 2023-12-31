Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B06AC147
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e8dkopc4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3616BC433C7;
	Sun, 31 Dec 2023 23:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704064188;
	bh=kmTZOYBq94czzAuxLymgJJOHMHwYA5F5eqzj34WJ79U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=e8dkopc4NH6pz//wXm3IsClistNXyqiwBMMysi0fKDMYbS4+f/Au3IRmEwoM5eTDg
	 OCpUc8whJ0ZS7NRwzR6TCq/ifUKHtC0zQIqt4xC2sT4/KCt1JJ3DbFWk1rDzFxBU0F
	 +NVKB4SDmaXkDJT2BxHfCD4uKfTt8nJAdf9YdnP0P6OhuMyCc2X1b4WkQi7oRuuMRX
	 r4458BV4llrsoFizjjnBsYDxLhLceUUgmW7O8vvL3jixgQjpb/RK/xY7XWV3uETkTf
	 2ujpQOJ+NjmoahyObP5kCNzv5MqvuioE2apQOzdsXUXJmAApZK/kbUe8A2Qen8eAFG
	 6ZgNv48iUi4ow==
Date: Sun, 31 Dec 2023 15:09:47 -0800
Subject: [PATCH 18/32] xfs_io: adapt parent command to new parent pointer
 ioctls
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com
Message-ID: <170405006341.1804688.11009892277015794783.stgit@frogsfrogsfrogs>
In-Reply-To: <170405006077.1804688.8762482665401724622.stgit@frogsfrogsfrogs>
References: <170405006077.1804688.8762482665401724622.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

For ages, xfs_io has had a totally useless 'parent' command that enabled
callers to walk the parents or print the directory tree path of an open
file.  This code used the ioctl interface presented by SGI's version of
parent pointers that was never merged.  Rework the code in here to use
the new ioctl interfaces that we've settled upon.  Get rid of the old
parent pointer checking code since xfs_repair/xfs_scrub will take care
of that.

(This originally was in the "xfsprogs: implement the upper half of
parent pointers" megapatch.)

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
---
 io/parent.c       |  470 ++++++++++++++---------------------------------------
 man/man8/xfs_io.8 |   21 +-
 2 files changed, 133 insertions(+), 358 deletions(-)


diff --git a/io/parent.c b/io/parent.c
index 8f63607ffec..65fd892bffc 100644
--- a/io/parent.c
+++ b/io/parent.c
@@ -7,365 +7,112 @@
 #include "command.h"
 #include "input.h"
 #include "libfrog/paths.h"
-#include "parent.h"
+#include "libfrog/getparents.h"
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
-check_parent_entry(struct xfs_bstat *bstatp, parent_t *parent)
+static int
+pptr_print(
+	const struct parent_rec	*rec,
+	void			*arg)
 {
-	int sts;
-	char fullpath[PATH_MAX];
-	struct stat statbuf;
-	char *str;
-
-	sprintf(fullpath, _("%s%s"), mntpt, parent->p_name);
-
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
-	}
+	const char		*name = (char *)rec->p_name;
+	unsigned int		namelen;
 
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
+	if (rec->p_flags & PARENT_IS_ROOT) {
+		printf(_("Root directory.\n"));
+		return 0;
 	}
-}
-
-static void
-check_parents(parent_t *parentbuf, size_t *parentbuf_size,
-	     jdm_fshandle_t *fshandlep, struct xfs_bstat *statp)
-{
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
 
-	if (count == 0) {
-		/* no links for inode - something wrong here */
-	       fprintf(stderr, _("inode-path for inode: %llu is missing\n"),
-			       (unsigned long long) statp->bs_ino);
-		err_status++;
-	}
+	namelen = strlen(name);
+	printf(_("p_ino     = %llu\n"), (unsigned long long)rec->p_ino);
+	printf(_("p_gen     = %u\n"), (unsigned int)rec->p_gen);
+	printf(_("p_namelen = %u\n"), namelen);
+	printf(_("p_name    = \"%s\"\n\n"), rec->p_name);
 
-	entryp = parentbuf;
-	for (i = 0; i < count; i++) {
-		check_parent_entry(statp, entryp);
-		entryp = (parent_t*) (((char*)entryp) + entryp->p_reclen);
-	}
+	return 0;
 }
 
 static int
-do_bulkstat(parent_t *parentbuf, size_t *parentbuf_size,
-	    struct xfs_bstat *bstatbuf, int fsfd, jdm_fshandle_t *fshandlep)
+print_parents(
+	struct xfs_handle	*handle)
 {
-	__s32 buflenout;
-	__u64 lastino = 0;
-	struct xfs_bstat *p;
-	struct xfs_bstat *endp;
-	struct xfs_fsop_bulkreq bulkreq;
-	struct stat mntstat;
-
-	if (stat(mntpt, &mntstat)) {
-		fprintf(stderr, _("can't stat mount point \"%s\": %s\n"),
-			mntpt, strerror(errno));
-		return 1;
-	}
-
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
-
-			/* print dotted progress */
-			if ((inodes_checked % 100) == 0 && verbose_flag == 1) {
-				printf("."); fflush(stdout);
-			}
-			inodes_checked++;
-
-			check_parents(parentbuf, parentbuf_size, fshandlep, p);
-		}
+	int			ret;
 
-	}/*while*/
+	if (handle)
+		ret = handle_walk_parents(handle, sizeof(*handle), pptr_print,
+				NULL);
+	else
+		ret = fd_walk_parents(file->fd, pptr_print, NULL);
+	if (ret)
+		fprintf(stderr, "%s: %s\n", file->name, strerror(ret));
 
-	fprintf(stderr, _("syssgi bulkstat failed: %s\n"), strerror(errno));
-	return 1;
+	return 0;
 }
 
 static int
-parent_check(void)
+path_print(
+	const char		*mntpt,
+	const struct path_list	*path,
+	void			*arg)
 {
-	int fsfd;
-	jdm_fshandle_t *fshandlep;
-	parent_t *parentbuf;
-	size_t parentbuf_size = PARENTBUF_SZ;
-	struct xfs_bstat *bstatbuf;
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
+	char			buf[PATH_MAX];
+	size_t			len = PATH_MAX;
+	int			mntpt_len = strlen(mntpt);
+	int			ret;
 
-	/* allocate buffers */
-        bstatbuf = (struct xfs_bstat *)calloc(BSTATBUF_SZ, sizeof(struct xfs_bstat));
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
+	/* Trim trailing slashes from the mountpoint */
+	while (mntpt_len > 0 && mntpt[mntpt_len - 1] == '/')
+		mntpt_len--;
 
-	if (err_status > 0)
-		fprintf(stderr, _("num errors: %d\n"), err_status);
-	else
-		printf(_("succeeded checking %llu inodes\n"),
-			(unsigned long long) inodes_checked);
+	ret = snprintf(buf, len, "%.*s", mntpt_len, mntpt);
+	if (ret != mntpt_len)
+		return ENAMETOOLONG;
 
-out:
-	free(bstatbuf);
-	free(parentbuf);
-	free(fshandlep);
-	return err_status;
-}
+	ret = path_list_to_string(path, buf + ret, len - ret);
+	if (ret < 0)
+		return ENAMETOOLONG;
 
-static void
-print_parent_entry(parent_t *parent, int fullpath)
-{
-       printf(_("p_ino    = %llu\n"),  (unsigned long long) parent->p_ino);
-	printf(_("p_gen    = %u\n"),	parent->p_gen);
-	printf(_("p_reclen = %u\n"),	parent->p_reclen);
-	if (fullpath)
-		printf(_("p_name   = \"%s%s\"\n"), mntpt, parent->p_name);
-	else
-		printf(_("p_name   = \"%s\"\n"), parent->p_name);
+	printf("%s\n", buf);
+	return 0;
 }
 
 static int
-parent_list(int fullpath)
+print_paths(
+	struct xfs_handle	*handle)
 {
-	void *handlep = NULL;
-	size_t handlen;
-	int error, i;
-	int retval = 1;
-	__u32 count;
-	parent_t *entryp;
-	parent_t *parentbuf = NULL;
-	char *path = file->name;
-	int pb_size = PARENTBUF_SZ;
+	int			ret;
 
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
-
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
+	if (handle)
+		ret = handle_walk_parent_paths(handle, sizeof(*handle),
+				path_print, NULL);
+	else
+		ret = fd_walk_parent_paths(file->fd, path_print, NULL);
+	if (ret)
+		fprintf(stderr, "%s: %s\n", file->name, strerror(ret));
+	return 0;
 }
 
 static int
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
@@ -380,46 +127,74 @@ parent_f(int argc, char **argv)
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
+	ret = path_to_fshandle((char *)mntpt, &hanp, &hlen);
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
+	} else if (optind != argc) {
+		return command_usage(&parent_cmd);
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
 
 static void
 parent_help(void)
 {
-	printf(_(
+printf(_(
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
 
@@ -430,11 +205,10 @@ parent_init(void)
 	parent_cmd.cfunc = parent_f;
 	parent_cmd.argmin = 0;
 	parent_cmd.argmax = -1;
-	parent_cmd.args = _("[-cpv]");
+	parent_cmd.args = _("[-p] [ino gen]");
 	parent_cmd.flags = CMD_NOMAP_OK;
-	parent_cmd.oneline = _("print or check parent inodes");
+	parent_cmd.oneline = _("print parent inodes");
 	parent_cmd.help = parent_help;
 
-	if (expert)
-		add_command(&parent_cmd);
+	add_command(&parent_cmd);
 }
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 6ebb479a344..4eda47c2772 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -1016,25 +1016,26 @@ and
 options behave as described above, in
 .B chproj.
 .TP
-.BR parent " [ " \-cpv " ]"
+.BR parent " [ " \-p " ] [" " ino gen " "]"
 By default this command prints out the parent inode numbers,
 inode generation numbers and basenames of all the hardlinks which
 point to the inode of the current file.
+
+If the optional
+.B ino
+and
+.B gen
+parameters are provided, they will be used to create a file handle on the same
+filesystem as the open file.
+The parents of the file represented by the handle will be reported instead of
+the open file.
+
 .RS 1.0i
 .PD 0
 .TP 0.4i
 .B \-p
 the output is similar to the default output except pathnames up to
 the mount-point are printed out instead of the component name.
-.TP
-.B \-c
-the file's filesystem will check all the parent attributes for consistency.
-.TP
-.B \-v
-verbose output will be printed.
-.RE
-.IP
-.B [NOTE: Not currently operational on Linux.]
 .RE
 .PD
 .TP

