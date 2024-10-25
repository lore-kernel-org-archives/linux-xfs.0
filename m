Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC921CF96
	for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2024 06:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729838057; cv=none; b=XdJLblLHIDh/hFJB+Bbgqoyv+tPbmGshitYFo1wyyJmtXJ0qiOikmT0W2vZFvb3l/M8v07cZeI9SMstTtpbq6PLDaTnCi6J+9cy9hQdkZ6JoYRZXymN7leOeH+sUghcvSz0zVQgihWaoo2EupcVv9uPfUtPeF/IgTr4Gca9qqao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729838057; c=relaxed/simple;
	bh=VMlnZuHjBiD6M2h6NQalcon/08D20hDwYhTgose8m2A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=if5xaADnK7BOq6i/gyp9qj7DQ7XsXBlG9Wf6LhrsFMILIWmd/B1YdCNFcOnZeBaZkdxHIaPMQXOIRlVeITIddNySlMk1dNXy/0cZlvvBvq7g725jq91zUZSaskQhkAu5pXsaK5P8PXh0WbkF+PZlMs3SxX4kDLB2W+DCbMFU/FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jd5HdjP4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jd5HdjP4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE2CC4CEC3;
	Fri, 25 Oct 2024 06:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729838057;
	bh=VMlnZuHjBiD6M2h6NQalcon/08D20hDwYhTgose8m2A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Jd5HdjP45xgn8T71T/R4jGhaIff/s9INwDaAPeLY9jPbMzTbR9six3VSj3tOpI6qv
	 7y2IfhX0YstcmIouQ6RetYsXgAM/7VXMLi9b6e6eXKNoeDchadXCR7As+xLCVJweKI
	 B3BFEMTGTg8uY3DgypPwenPh8HKbNpdIr8gtQhcF0/XSWJt8SMaKJ7zONUDnNFM2QE
	 6kzzC/TFK1qm13tDvHxXUCmkQkFlXxAxG5IU8A/qFSsERcdExeF01RHrxC7bNa6e9s
	 GwGEtxHEc8IwHyIcXE752Ewc5s4mCxOpZNsE/ePI0a3J2C3xTWNbCJNw4ygKrFgqkv
	 l+8OiqY2Q+GkQ==
Date: Thu, 24 Oct 2024 23:34:16 -0700
Subject: [PATCH 7/7] xfs_io: add atomic file update commands to exercise file
 commit range
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172983773435.3040944.11571503838591968979.stgit@frogsfrogsfrogs>
In-Reply-To: <172983773323.3040944.5615240418900510348.stgit@frogsfrogsfrogs>
References: <172983773323.3040944.5615240418900510348.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add three commands to xfs_io so that we can exercise atomic file updates
as provided by reflink and the start-commit / commit-range functionality.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 io/exchrange.c    |  364 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 io/io.h           |    4 +
 io/open.c         |   27 +++-
 man/man8/xfs_io.8 |   32 +++++
 4 files changed, 421 insertions(+), 6 deletions(-)


diff --git a/io/exchrange.c b/io/exchrange.c
index 0a3750f1eb2607..707d78d8e624fe 100644
--- a/io/exchrange.c
+++ b/io/exchrange.c
@@ -164,6 +164,358 @@ static struct cmdinfo exchangerange_cmd = {
 	.help		= exchangerange_help,
 };
 
+/* Atomic file updates commands */
+
+struct update_info {
+	/* File that we're updating. */
+	int			fd;
+
+	/* ioctl data to commit the changes */
+	struct xfs_commit_range	xcr;
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
+	/* Open a temporary file to stage the new contents. */
+	temp_fd = openfile(path, &fsgeom, flags, 0600, &fspath);
+	if (temp_fd < 0) {
+		perror(path);
+		goto fail;
+	}
+
+	/*
+	 * Snapshot the original file metadata in anticipation of the later
+	 * file mapping exchange request.
+	 */
+	ret = xfrog_commitrange_prep(&p->xcr, file->fd, 0, temp_fd, 0,
+			stat.st_size);
+	if (ret) {
+		perror("update prep");
+		goto fail;
+	}
+
+	/* Clone all the data from the original file into the temporary file. */
+	if (clone_file) {
+		ret = ioctl(temp_fd, XFS_IOC_CLONE, file->fd);
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
+	p->fd = file->fd;
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
+	/*
+	 * Commit our changes, if desired.  If the mapping exchange fails, we
+	 * stop processing immediately so that we can run more xfs_io commands.
+	 */
+	switch (how) {
+	case FINISH_CHECK:
+		flags |= XFS_EXCHANGE_RANGE_DRY_RUN;
+		fallthrough;
+	case FINISH_COMMIT:
+		ret = xfrog_commitrange(p->fd, &p->xcr, flags);
+		if (ret) {
+			xfrog_perror(ret, _("committing update"));
+			exitcode = 1;
+			return -1;
+		}
+		printf(_("Committed updates to '%s'.\n"), p->old_fname);
+		*offset = p->xcr.file2_offset;
+		committed_bytes = p->xcr.length;
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
+	file->fd = p->fd;
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
+" will be exchanged atomically with the corresponding range in the original\n"
+" file.  The temporary file will be closed, and the current file set back to\n"
+" the original file.\n"
+"\n"
+" -C   -- Print timing information in a condensed format.\n"
+" -h   -- Only exchange written ranges in the temporary file.\n"
+" -k   -- Exchange to end of file, ignore any length previously set.\n"
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
+	uint64_t	flags = XFS_EXCHANGE_RANGE_TO_EOF;
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
+			flags |= XFS_EXCHANGE_RANGE_FILE1_WRITTEN;
+			break;
+		case 'k':
+			flags &= ~XFS_EXCHANGE_RANGE_TO_EOF;
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
 void
 exchangerange_init(void)
 {
@@ -171,4 +523,16 @@ exchangerange_init(void)
 	exchangerange_cmd.oneline = _("Exchange contents between files.");
 
 	add_command(&exchangerange_cmd);
+
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
 }
diff --git a/io/io.h b/io/io.h
index 8c5e59100c5cbd..4daedac06419ae 100644
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
diff --git a/io/open.c b/io/open.c
index 15850b5557bc5b..a30dd89a1fd56c 100644
--- a/io/open.c
+++ b/io/open.c
@@ -338,14 +338,19 @@ open_f(
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
@@ -371,7 +376,19 @@ close_f(
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
index 49d4057bb069ed..eb2201fca74380 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -1058,7 +1058,37 @@ .SH FILE I/O COMMANDS
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
+Only swap ranges in the update staging file that were actually written.
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

