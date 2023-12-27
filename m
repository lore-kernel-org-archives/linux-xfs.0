Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C1D6123
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mnY+rVKr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9642C433C7;
	Mon,  1 Jan 2024 00:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704069755;
	bh=25aE4LSLY2OPnVgzLGHUZpo5VSe9M+ammHFi7tO4hj8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mnY+rVKrOefoHmHvayCY9/4/YQLFgmkNQRK0W1KntOsF73VLS8+oKLyR1LN8CM4vV
	 Y7AEI1dYoggCb9WWy4clol9hvw1WFSG6E7/phNQqqwqmwJfHak4Ri2boY8Pys30kn5
	 uHfWTHngVqTnauJirJHwndKP4dtv8rzz3S3JXkEnkIPcGousxq4BBZhFD+zLN2YHHx
	 1z2hOT1LhSDZqyBIXjS8xeXMcOpcjz9AeUqQRKj07dtifffdDrKycZ4nnTA8czVP1s
	 MKkkmKxSflojpJn6eMEHBZ38XnTepkBH7mkWw714Zmjh6mfKgh8VxdWSpZLgqJnFFP
	 XFrwwz11lb/vA==
Date: Sun, 31 Dec 2023 16:42:35 +9900
Subject: [PATCH 10/10] spaceman: move inodes with hardlinks
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <170405020458.1820796.14241728569056483133.stgit@frogsfrogsfrogs>
In-Reply-To: <170405020316.1820796.451112156000559887.stgit@frogsfrogsfrogs>
References: <170405020316.1820796.451112156000559887.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Dave Chinner <dchinner@redhat.com>

When a inode to be moved to a different AG has multiple hard links,
we need to "move" all the hard links, too. To do this, we need to
create temporary hardlinks to the new file, and then use rename
exchange to swap all the hardlinks that point to the old inode
with new hardlinks that point to the new inode.

We already know that an inode has hard links via the path discovery,
and we can check it against the link count that is reported for the
inode before we start building the link farm.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 spaceman/find_owner.c |   13 +----
 spaceman/move_inode.c |  119 +++++++++++++++++++++++++++++++++++++++++++++----
 spaceman/relocation.c |   35 ++++++++++----
 spaceman/relocation.h |    6 ++
 4 files changed, 140 insertions(+), 33 deletions(-)


diff --git a/spaceman/find_owner.c b/spaceman/find_owner.c
index 3236290e3fd..2b3dc653271 100644
--- a/spaceman/find_owner.c
+++ b/spaceman/find_owner.c
@@ -240,7 +240,6 @@ resolve_owner_cb(
 	struct FTW		*data)
 {
 	struct inode_path	*ipath, *slot_ipath;
-	int			pathlen;
 	struct inode_path	**slot;
 
 	/*
@@ -260,17 +259,9 @@ _("Failed to obtain stat(2) information from path %s. Aborting\n"),
 	}
 
 	/* Allocate a new inode path and record the path in it. */
-	pathlen = strlen(path);
-	ipath = calloc(1, sizeof(*ipath) + pathlen + 1);
-	if (!ipath) {
-		fprintf(stderr,
-_("Aborting: Storing path %s for inode 0x%lx failed: %s\n"),
-			path, stat->st_ino, strerror(ENOMEM));
+	ipath = ipath_alloc(path, stat);
+	if (!ipath)
 		return -ENOMEM;
-	}
-	INIT_LIST_HEAD(&ipath->path_list);
-	memcpy(&ipath->path[0], path, pathlen);
-	ipath->ino = stat->st_ino;
 
 	/*
 	 * If the slot contains the inode number we just looked up, then we
diff --git a/spaceman/move_inode.c b/spaceman/move_inode.c
index 9190b1d3ab2..e8e3a64cb39 100644
--- a/spaceman/move_inode.c
+++ b/spaceman/move_inode.c
@@ -36,12 +36,14 @@ create_tmpfile(
 	struct xfs_fd	*xfd,
 	xfs_agnumber_t	agno,
 	char		**tmpfile,
-	int		*tmpfd)
+	int		*tmpfd,
+	int		link_count)
 {
 	char		name[PATH_MAX + 1];
+	char		linkname[PATH_MAX + 1];
 	mode_t		mask;
 	int		fd;
-	int		i;
+	int		i, j;
 	int		ret;
 
 	/* construct tmpdir */
@@ -105,14 +107,36 @@ create_tmpfile(
 		fprintf(stderr, _("cannot create tmpfile: %s: %s\n"),
 		       name, strerror(errno));
 		ret = -errno;
+		goto out_cleanup_dir;
 	}
 
+	/* Create hard links to temporary file. */
+	for (j = link_count; j > 1; i--) {
+		snprintf(linkname, PATH_MAX, "%s/.spaceman/dir%d/tmpfile.%d.hardlink.%d", mnt, i, getpid(), j);
+		ret = link(name, linkname);
+		if (ret < 0) {
+			fprintf(stderr, _("cannot create hardlink: %s: %s\n"),
+			       linkname, strerror(errno));
+			ret = -errno;
+			goto out_cleanup_links;
+		}
+	}
+
+
 	/* return name and fd */
 	(void)umask(mask);
 	*tmpfd = fd;
 	*tmpfile = strdup(name);
 
 	return 0;
+
+out_cleanup_links:
+	for (; j <= link_count; j++) {
+		snprintf(linkname, PATH_MAX, "%s/.spaceman/dir%d/tmpfile.%d.hardlink.%d", mnt, i, getpid(), j);
+		unlink(linkname);
+	}
+	close(fd);
+	unlink(name);
 out_cleanup_dir:
 	snprintf(name, PATH_MAX, "%s/.spaceman", mnt);
 	rmdir(name);
@@ -405,21 +429,53 @@ exchange_inodes(
 	return 0;
 }
 
+static int
+exchange_hardlinks(
+	struct inode_path	*ipath,
+	const char		*tmpfile)
+{
+	char			linkname[PATH_MAX];
+	struct inode_path	*linkpath;
+	int			i = 2;
+	int			ret;
+
+	list_for_each_entry(linkpath, &ipath->path_list, path_list) {
+		if (i++ > ipath->link_count) {
+			fprintf(stderr, "ipath link count mismatch!\n");
+			return 0;
+		}
+
+		snprintf(linkname, PATH_MAX, "%s.hardlink.%d", tmpfile, i);
+		ret = renameat2(AT_FDCWD, linkname,
+				AT_FDCWD, linkpath->path, RENAME_EXCHANGE);
+		if (ret) {
+			fprintf(stderr,
+		"failed to exchange hard link %s with %s: %s\n",
+				linkname, linkpath->path, strerror(errno));
+			return -errno;
+		}
+	}
+	return 0;
+}
+
 int
 relocate_file_to_ag(
 	const char		*mnt,
-	const char		*path,
+	struct inode_path	*ipath,
 	struct xfs_fd		*xfd,
 	xfs_agnumber_t		agno)
 {
 	int			ret;
 	int			tmpfd = -1;
 	char			*tmpfile = NULL;
+	int			i;
 
-	fprintf(stderr, "move mnt %s, path %s, agno %d\n", mnt, path, agno);
+	fprintf(stderr, "move mnt %s, path %s, agno %d\n",
+			mnt, ipath->path, agno);
 
 	/* create temporary file in agno */
-	ret = create_tmpfile(mnt, xfd, agno, &tmpfile, &tmpfd);
+	ret = create_tmpfile(mnt, xfd, agno, &tmpfile, &tmpfd,
+				ipath->link_count);
 	if (ret)
 		return ret;
 
@@ -444,12 +500,28 @@ relocate_file_to_ag(
 		goto out_cleanup;
 
 	/* swap the inodes over */
-	ret = exchange_inodes(xfd, tmpfd, tmpfile, path);
+	ret = exchange_inodes(xfd, tmpfd, tmpfile, ipath->path);
+	if (ret)
+		goto out_cleanup;
+
+	/* swap the hard links over */
+	ret = exchange_hardlinks(ipath, tmpfile);
+	if (ret)
+		goto out_cleanup;
 
 out_cleanup:
 	if (ret == -1)
 		ret = -errno;
 
+	/* remove old hard links */
+	for (i = 2; i <= ipath->link_count; i++) {
+		char linkname[PATH_MAX + 256]; // anti-warning-crap
+
+		snprintf(linkname, PATH_MAX + 256, "%s.hardlink.%d", tmpfile, i);
+		unlink(linkname);
+	}
+
+	/* remove tmpfile */
 	close(tmpfd);
 	if (tmpfile)
 		unlink(tmpfile);
@@ -458,11 +530,32 @@ relocate_file_to_ag(
 	return ret;
 }
 
+static int
+build_ipath(
+	const char		*path,
+	struct stat		*st,
+	struct inode_path	**ipathp)
+{
+	struct inode_path	*ipath;
+
+	*ipathp = NULL;
+
+	ipath = ipath_alloc(path, st);
+	if (!ipath)
+		return -ENOMEM;
+
+	/* we only move a single path with move_inode */
+	ipath->link_count = 1;
+	*ipathp = ipath;
+	return 0;
+}
+
 static int
 move_inode_f(
 	int			argc,
 	char			**argv)
 {
+	struct inode_path	*ipath = NULL;
 	void			*fshandle;
 	size_t			fshdlen;
 	xfs_agnumber_t		agno = 0;
@@ -511,24 +604,30 @@ _("Destination AG %d does not exist. Filesystem only has %d AGs\n"),
 		goto exit_fail;
 	}
 
-	if (S_ISREG(st.st_mode)) {
-		ret = relocate_file_to_ag(file->fs_path.fs_dir, file->name,
-				&file->xfd, agno);
-	} else {
+	if (!S_ISREG(st.st_mode)) {
 		fprintf(stderr, _("Unsupported: %s is not a regular file.\n"),
 			file->name);
 		goto exit_fail;
 	}
 
+	ret = build_ipath(file->name, &st, &ipath);
+	if (ret)
+		goto exit_fail;
+
+	ret = relocate_file_to_ag(file->fs_path.fs_dir, ipath,
+				&file->xfd, agno);
 	if (ret) {
 		fprintf(stderr, _("Failed to move inode to AG %d: %s\n"),
 			agno, strerror(-ret));
 		goto exit_fail;
 	}
+	free(ipath);
 	fshandle_destroy();
 	return 0;
 
 exit_fail:
+	if (ipath)
+		free(ipath);
 	fshandle_destroy();
 	exitcode = 1;
 	return 0;
diff --git a/spaceman/relocation.c b/spaceman/relocation.c
index 7b125cc0ae1..b0960272168 100644
--- a/spaceman/relocation.c
+++ b/spaceman/relocation.c
@@ -318,6 +318,30 @@ forget_reloc_ino(
 
 static struct cmdinfo relocate_cmd;
 
+struct inode_path *
+ipath_alloc(
+	const char		*path,
+	const struct stat	*stat)
+{
+	struct inode_path	*ipath;
+	int			pathlen = strlen(path);
+
+	/* Allocate a new inode path and record the path in it. */
+	ipath = calloc(1, sizeof(*ipath) + pathlen + 1);
+	if (!ipath) {
+		fprintf(stderr,
+_("Failed to allocate ipath %s for inode 0x%llx failed: %s\n"),
+			path, (unsigned long long)stat->st_ino,
+			strerror(-errno));
+		return NULL;
+	}
+	INIT_LIST_HEAD(&ipath->path_list);
+	memcpy(&ipath->path[0], path, pathlen);
+	ipath->ino = stat->st_ino;
+
+	return ipath;
+}
+
 static int
 relocate_targets_to_ag(
 	const char		*mnt,
@@ -336,15 +360,6 @@ relocate_targets_to_ag(
 		if (!ipath)
 			break;
 
-		/* XXX: don't handle hard link cases yet */
-		if (ipath->link_count > 1) {
-			fprintf(stderr,
-		"FIXME! Skipping hardlinked inode at path %s\n",
-				ipath->path);
-			goto next;
-		}
-
-
 		ret = stat(ipath->path, &st);
 		if (ret) {
 			fprintf(stderr, _("stat(%s) failed: %s\n"),
@@ -367,7 +382,7 @@ relocate_targets_to_ag(
 		}
 
 		/* move to destination AG */
-		ret = relocate_file_to_ag(mnt, ipath->path, &xfd, dst_agno);
+		ret = relocate_file_to_ag(mnt, ipath, &xfd, dst_agno);
 		xfd_close(&xfd);
 
 		/*
diff --git a/spaceman/relocation.h b/spaceman/relocation.h
index d4c71b7bb7f..2c807aa678e 100644
--- a/spaceman/relocation.h
+++ b/spaceman/relocation.h
@@ -43,9 +43,11 @@ struct inode_path {
  */
 #define UNLINKED_IPATH		((struct inode_path *)1)
 
+struct inode_path *ipath_alloc(const char *path, const struct stat *st);
+
 int find_relocation_targets(xfs_agnumber_t agno);
-int relocate_file_to_ag(const char *mnt, const char *path, struct xfs_fd *xfd,
-			xfs_agnumber_t agno);
+int relocate_file_to_ag(const char *mnt, struct inode_path *ipath,
+			struct xfs_fd *xfd, xfs_agnumber_t agno);
 int resolve_target_paths(const char *mntpt);
 
 #endif /* XFS_SPACEMAN_RELOCATION_H_ */

