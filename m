Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07462C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:23:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235696AbiLaAXn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:23:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiLaAXm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:23:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06416BE0E
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:23:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84CD8B81E85
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:23:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F8BDC433D2;
        Sat, 31 Dec 2022 00:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446218;
        bh=S5fntnGrfLiSPUXpKKMpze2CpbyrXlaQEaYQkaLB4a4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Qpa9Fmcf3B25zBV/GeRA4V9Xmqih62ZxG/gOoouXrChHpzIdU7BEDZlCI2OYKKSAW
         bW7xNwS6kRfRLETxQYjpLWHXNO3g1rjRCr5GYWwJ+W9ZC+8CJKQE8Ul7k2vYWgcHlD
         U0PNs8m1iduVmQvoq6oIav6khvyh5ZoDaoHDbvc/XTziyQaz9As5MO1w++IZL2mIm/
         Dwfx3hbNkc+j1Ar2c1MmS2Q6AK2phn7BHM9sFJv4HnS24F0/XW8LWN+CKT+X7z+Mgk
         ONIqyL+CVG4TKwncdmcN0wdTtLZxkk/EaDrZDrOg73nA7eyzERSH2tdvBuR1jfe3oH
         jcE0+LXw3vqQA==
Subject: [PATCH 19/19] xfs_io: add atomic update commands to exercise extent
 swapping
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:01 -0800
Message-ID: <167243868187.713817.6674892250500816379.stgit@magnolia>
In-Reply-To: <167243867932.713817.982387501030567647.stgit@magnolia>
References: <167243867932.713817.982387501030567647.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add three commands to xfs_io so that we can exercise atomic file updates
as provided by reflink and atomic swapext.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 io/Makefile       |    2 
 io/atomicupdate.c |  387 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 io/init.c         |    1 
 io/io.h           |    5 +
 io/open.c         |   27 +++-
 man/man8/xfs_io.8 |   33 ++++-
 6 files changed, 448 insertions(+), 7 deletions(-)
 create mode 100644 io/atomicupdate.c


diff --git a/io/Makefile b/io/Makefile
index 229f8f377b3..aa0d216b25f 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -13,7 +13,7 @@ CFILES = init.c \
 	file.c freeze.c fsync.c getrusage.c imap.c inject.c label.c link.c \
 	mmap.c open.c parent.c pread.c prealloc.c pwrite.c reflink.c \
 	resblks.c scrub.c seek.c shutdown.c stat.c swapext.c sync.c \
-	truncate.c utimes.c
+	truncate.c utimes.c atomicupdate.c
 
 LLDLIBS = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG) $(LIBPTHREAD)
 LTDEPENDENCIES = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG)
diff --git a/io/atomicupdate.c b/io/atomicupdate.c
new file mode 100644
index 00000000000..cb9b664cfed
--- /dev/null
+++ b/io/atomicupdate.c
@@ -0,0 +1,387 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "platform_defs.h"
+#include "command.h"
+#include "init.h"
+#include "io.h"
+#include "input.h"
+#include "libfrog/logging.h"
+#include "libfrog/fsgeom.h"
+#include "libfrog/fiexchange.h"
+#include "libfrog/file_exchange.h"
+
+struct update_info {
+	/* File object for the file that we're updating. */
+	struct xfs_fd		file_fd;
+
+	/* FIEXCHANGE_RANGE request to commit the changes. */
+	struct file_xchg_range	xchg_req;
+
+	/* Name of the file we're updating. */
+	char			*old_fname;
+
+	/* fd we're using to stage the updates. */
+	int			temp_fd;
+};
+
+enum finish_how	{
+	FINISH_ABORT,
+	FINISH_COMMIT,
+	FINISH_CHECK
+};
+
+static struct update_info *updates;
+static unsigned int nr_updates;
+
+static void
+startupdate_help(void)
+{
+	printf(_(
+"\n"
+" Prepare for an atomic file update, if supported by the filesystem.\n"
+" A temporary file will be opened for writing and inserted into the file\n"
+" table.  The current file will be changed to this temporary file.  Neither\n"
+" file can be closed for the duration of the update.\n"
+"\n"
+" -e   -- Start with an empty file\n"
+"\n"));
+}
+
+static int
+startupdate_f(
+	int			argc,
+	char			*argv[])
+{
+	struct fsxattr		attr;
+	struct xfs_fsop_geom	fsgeom;
+	struct fs_path		fspath;
+	struct stat		stat;
+	struct update_info	*p;
+	char			*fname;
+	char			*path = NULL, *d;
+	size_t			fname_len;
+	int			flags = IO_TMPFILE | IO_ATOMICUPDATE;
+	int			temp_fd = -1;
+	bool			clone_file = true;
+	int			c;
+	int			ret;
+
+	while ((c = getopt(argc, argv, "e")) != -1) {
+		switch (c) {
+		case 'e':
+			clone_file = false;
+			break;
+		default:
+			startupdate_help();
+			return 0;
+		}
+	}
+	if (optind != argc) {
+		startupdate_help();
+		return 0;
+	}
+
+	/* Allocate a new slot. */
+	p = realloc(updates, (++nr_updates) * sizeof(*p));
+	if (!p) {
+		perror("startupdate realloc");
+		goto fail;
+	}
+	updates = p;
+
+	/* Fill out the update information so that we can commit later. */
+	p = &updates[nr_updates - 1];
+	memset(p, 0, sizeof(*p));
+	p->file_fd.fd = file->fd;
+	ret = xfd_prepare_geometry(&p->file_fd);
+	if (ret) {
+		xfrog_perror(ret, file->name);
+		goto fail;
+	}
+
+	ret = fstat(file->fd, &stat);
+	if (ret) {
+		perror(file->name);
+		goto fail;
+	}
+
+	/* Is the current file realtime?  If so, the temp file must match. */
+	ret = ioctl(file->fd, FS_IOC_FSGETXATTR, &attr);
+	if (ret == 0 && attr.fsx_xflags & FS_XFLAG_REALTIME)
+		flags |= IO_REALTIME;
+
+	/* Compute path to the directory that the current file is in. */
+	path = strdup(file->name);
+	d = strrchr(path, '/');
+	if (!d) {
+		fprintf(stderr, _("%s: cannot compute dirname?"), path);
+		goto fail;
+	}
+	*d = 0;
+
+	/* Open a temporary file to stage the extents. */
+	temp_fd = openfile(path, &fsgeom, flags, 0600, &fspath);
+	if (temp_fd < 0) {
+		perror(path);
+		goto fail;
+	}
+
+	/*
+	 * Snapshot the original file metadata in anticipation of the later
+	 * extent swap request.
+	 */
+	ret = xfrog_file_exchange_prep(&p->file_fd, FILE_XCHG_RANGE_COMMIT, 0,
+			temp_fd, 0, stat.st_size, &p->xchg_req);
+	if (ret) {
+		perror("update prep");
+		goto fail;
+	}
+
+	/* Clone all the data from the original file into the temporary file. */
+	if (clone_file) {
+		ret = ioctl(temp_fd, XFS_IOC_CLONE, p->file_fd.fd);
+		if (ret) {
+			perror(path);
+			goto fail;
+		}
+	}
+
+	/* Prepare a new path string for the duration of the update. */
+#define FILEUPDATE_STR	" (fileupdate)"
+	fname_len = strlen(file->name) + strlen(FILEUPDATE_STR);
+	fname = malloc(fname_len + 1);
+	if (!fname) {
+		perror("new path");
+		goto fail;
+	}
+	snprintf(fname, fname_len + 1, "%s%s", file->name, FILEUPDATE_STR);
+
+	/*
+	 * Install the temporary file into the same slot of the file table as
+	 * the original file.  Ensure that the original file cannot be closed.
+	 */
+	file->flags |= IO_ATOMICUPDATE;
+	p->old_fname = file->name;
+	file->name = fname;
+	p->temp_fd = file->fd = temp_fd;
+
+	free(path);
+	return 0;
+fail:
+	if (temp_fd >= 0)
+		close(temp_fd);
+	free(path);
+	nr_updates--;
+	exitcode = 1;
+	return 1;
+}
+
+static long long
+finish_update(
+	enum finish_how		how,
+	uint64_t		flags,
+	long long		*offset)
+{
+	struct update_info	*p;
+	long long		committed_bytes = 0;
+	size_t			length;
+	unsigned int		i;
+	unsigned int		upd_offset;
+	int			temp_fd;
+	int			ret;
+
+	/* Find our update descriptor. */
+	for (i = 0, p = updates; i < nr_updates; i++, p++) {
+		if (p->temp_fd == file->fd)
+			break;
+	}
+
+	if (i == nr_updates) {
+		fprintf(stderr,
+	_("Current file is not the staging file for an atomic update.\n"));
+		exitcode = 1;
+		return -1;
+	}
+
+	p->xchg_req.flags |= flags;
+
+	/*
+	 * Commit our changes, if desired.  If the extent swap fails, we stop
+	 * processing immediately so that we can run more xfs_io commands.
+	 */
+	switch (how) {
+	case FINISH_CHECK:
+		p->xchg_req.flags |= FILE_XCHG_RANGE_DRY_RUN;
+		fallthrough;
+	case FINISH_COMMIT:
+		ret = xfrog_file_exchange(&p->file_fd, &p->xchg_req);
+		if (ret) {
+			xfrog_perror(ret, _("committing update"));
+			exitcode = 1;
+			return -1;
+		}
+		printf(_("Committed updates to '%s'.\n"), p->old_fname);
+		*offset = p->xchg_req.file2_offset;
+		committed_bytes = p->xchg_req.length;
+		break;
+	case FINISH_ABORT:
+		printf(_("Cancelled updates to '%s'.\n"), p->old_fname);
+		break;
+	}
+
+	/*
+	 * Reset the filetable to point to the original file, and close the
+	 * temporary file.
+	 */
+	free(file->name);
+	file->name = p->old_fname;
+	file->flags &= ~IO_ATOMICUPDATE;
+	temp_fd = file->fd;
+	file->fd = p->file_fd.fd;
+	ret = close(temp_fd);
+	if (ret)
+		perror(_("closing temporary file"));
+
+	/* Remove the atomic update context, shifting things down. */
+	upd_offset = p - updates;
+	length = nr_updates * sizeof(struct update_info);
+	length -= (upd_offset + 1) * sizeof(struct update_info);
+	if (length)
+		memmove(p, p + 1, length);
+
+	nr_updates--;
+	return committed_bytes;
+}
+
+static void
+cancelupdate_help(void)
+{
+	printf(_(
+"\n"
+" Cancels an atomic file update.  The temporary file will be closed, and the\n"
+" current file set back to the original file.\n"
+"\n"));
+}
+
+static int
+cancelupdate_f(
+	int		argc,
+	char		*argv[])
+{
+	return finish_update(FINISH_ABORT, 0, NULL);
+}
+
+static void
+commitupdate_help(void)
+{
+	printf(_(
+"\n"
+" Commits an atomic file update.  File contents written to the temporary file\n"
+" will be swapped atomically with the corresponding range in the original\n"
+" file.  The temporary file will be closed, and the current file set back to\n"
+" the original file.\n"
+"\n"
+" -C   -- Print timing information in a condensed format.\n"
+" -h   -- Do not swap sparse areas of the temporary file.\n"
+" -k   -- Do not change file size.\n"
+" -n   -- Check parameters but do not change anything.\n"
+" -q   -- Do not print timing information at all.\n"));
+}
+
+static int
+commitupdate_f(
+	int		argc,
+	char		*argv[])
+{
+	struct timeval	t1, t2;
+	enum finish_how	how = FINISH_COMMIT;
+	uint64_t	flags = FILE_XCHG_RANGE_TO_EOF;
+	long long	offset, len;
+	int		condensed = 0, quiet_flag = 0;
+	int		c;
+
+	while ((c = getopt(argc, argv, "Chknq")) != -1) {
+		switch (c) {
+		case 'C':
+			condensed = 1;
+			break;
+		case 'h':
+			flags |= FILE_XCHG_RANGE_SKIP_FILE1_HOLES;
+			break;
+		case 'k':
+			flags &= ~FILE_XCHG_RANGE_TO_EOF;
+			break;
+		case 'n':
+			how = FINISH_CHECK;
+			break;
+		case 'q':
+			quiet_flag = 1;
+			break;
+		default:
+			commitupdate_help();
+			return 0;
+		}
+	}
+	if (optind != argc) {
+		commitupdate_help();
+		return 0;
+	}
+
+	gettimeofday(&t1, NULL);
+	len = finish_update(how, flags, &offset);
+	if (len < 0)
+		return 1;
+	if (quiet_flag)
+		return 0;
+
+	gettimeofday(&t2, NULL);
+	t2 = tsub(t2, t1);
+	report_io_times("commitupdate", &t2, offset, len, len, 1, condensed);
+	return 0;
+}
+
+static struct cmdinfo startupdate_cmd = {
+	.name		= "startupdate",
+	.cfunc		= startupdate_f,
+	.argmin		= 0,
+	.argmax		= -1,
+	.flags		= CMD_FLAG_ONESHOT | CMD_NOMAP_OK,
+	.help		= startupdate_help,
+};
+
+static struct cmdinfo cancelupdate_cmd = {
+	.name		= "cancelupdate",
+	.cfunc		= cancelupdate_f,
+	.argmin		= 0,
+	.argmax		= 0,
+	.flags		= CMD_FLAG_ONESHOT | CMD_NOMAP_OK,
+	.help		= cancelupdate_help,
+};
+
+static struct cmdinfo commitupdate_cmd = {
+	.name		= "commitupdate",
+	.cfunc		= commitupdate_f,
+	.argmin		= 0,
+	.argmax		= -1,
+	.flags		= CMD_FLAG_ONESHOT | CMD_NOMAP_OK,
+	.help		= commitupdate_help,
+};
+
+void
+atomicupdate_init(void)
+{
+	startupdate_cmd.oneline = _("start an atomic update of a file");
+	startupdate_cmd.args = _("[-e]");
+
+	cancelupdate_cmd.oneline = _("cancel an atomic update");
+
+	commitupdate_cmd.oneline = _("commit a file update atomically");
+	commitupdate_cmd.args = _("[-C] [-h] [-n] [-q]");
+
+	add_command(&startupdate_cmd);
+	add_command(&cancelupdate_cmd);
+	add_command(&commitupdate_cmd);
+}
diff --git a/io/init.c b/io/init.c
index 033ed67d455..96536a25a1f 100644
--- a/io/init.c
+++ b/io/init.c
@@ -44,6 +44,7 @@ init_cvtnum(
 static void
 init_commands(void)
 {
+	atomicupdate_init();
 	attr_init();
 	bmap_init();
 	bulkstat_init();
diff --git a/io/io.h b/io/io.h
index 64b7a663a8c..1cfe8edc2db 100644
--- a/io/io.h
+++ b/io/io.h
@@ -31,6 +31,9 @@
 #define IO_PATH		(1<<10)
 #define IO_NOFOLLOW	(1<<11)
 
+/* undergoing atomic update, do not close */
+#define IO_ATOMICUPDATE	(1<<12)
+
 /*
  * Regular file I/O control
  */
@@ -74,6 +77,7 @@ extern int		openfile(char *, struct xfs_fsop_geom *, int, mode_t,
 				 struct fs_path *);
 extern int		addfile(char *, int , struct xfs_fsop_geom *, int,
 				struct fs_path *);
+extern int		closefile(void);
 extern void		printxattr(uint, int, int, const char *, int, int);
 
 extern unsigned int	recurse_all;
@@ -184,3 +188,4 @@ extern void		scrub_init(void);
 extern void		repair_init(void);
 extern void		crc32cselftest_init(void);
 extern void		bulkstat_init(void);
+extern void		atomicupdate_init(void);
diff --git a/io/open.c b/io/open.c
index d8072664c16..12c486395ce 100644
--- a/io/open.c
+++ b/io/open.c
@@ -337,14 +337,19 @@ open_f(
 	return 0;
 }
 
-static int
-close_f(
-	int		argc,
-	char		**argv)
+int
+closefile(void)
 {
 	size_t		length;
 	unsigned int	offset;
 
+	if (file->flags & IO_ATOMICUPDATE) {
+		fprintf(stderr,
+	_("%s: atomic update in progress, cannot close.\n"),
+			file->name);
+		exitcode = 1;
+		return 0;
+	}
 	if (close(file->fd) < 0) {
 		perror("close");
 		exitcode = 1;
@@ -370,7 +375,19 @@ close_f(
 		free(filetable);
 		file = filetable = NULL;
 	}
-	filelist_f();
+	return 0;
+}
+
+static int
+close_f(
+	int		argc,
+	char		**argv)
+{
+	int		ret;
+
+	ret = closefile();
+	if (!ret)
+		filelist_f();
 	return 0;
 }
 
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 9a155aaa02c..d531cabc3ef 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -1042,7 +1042,38 @@ sec uses UNIX timestamp notation and is the seconds elapsed since
 nsec is the nanoseconds since the sec. This value needs to be in
 the range 0-999999999 with UTIME_NOW and UTIME_OMIT being exceptions.
 Each (sec, nsec) pair constitutes a single timestamp value.
-
+.TP
+.BI "startupdate [ " -e ]
+Create a temporary clone of a file in which to stage file updates.
+The
+.B \-e
+option creates an empty staging file.
+.TP
+.B cancelupdate
+Abandon changes from a update staging file.
+.TP
+.BI "commitupdate [" OPTIONS ]
+Commit changes from a update staging file to the real file.
+.RS 1.0i
+.PD 0
+.TP 0.4i
+.B \-C
+Print timing information in a condensed format.
+.TP 0.4i
+.B \-h
+Skip the range swap for all ranges of the update staging file that
+are sparse holes.
+.TP 0.4i
+.B \-k
+Do not change file size.
+.TP 0.4i
+.B \-n
+Check parameters without changing anything.
+.TP 0.4i
+.B \-q
+Do not print timing information at all.
+.PD
+.RE
 
 .SH MEMORY MAPPED I/O COMMANDS
 .TP

