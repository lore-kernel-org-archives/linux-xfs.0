Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C1E20E8
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KTl3jo0p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AEBBC433B6;
	Mon,  1 Jan 2024 00:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704069740;
	bh=jzDRhOnRQRqYJCpDxZMnGdgm0xRQqkz3VeitXjFF2pk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KTl3jo0pj8SsS+bpZrWKAzHM/4//MWdiBdcnPNU3sfkNPUi4emj/6faxCuVNMGL32
	 KAb7Ku49A79GHMRHaf79hZh0BubZZgbpnlDorsxPPkqYRJmiZZojM8kPwdPwPsoAsp
	 bcw4f8wmgiIYzaugilfbJo1rW1iXoxhfKd5b039HpUkNBywjoFie3ztmtHUxviezSC
	 vOhhHO03UZG0JPo1W+LQ0Sjs/ktsAP4dkJeEUF5fFxMraNkETQAtcheHoMy/q7nBfR
	 b8N1q8jMeg8qs1vjM0XkJmkzQFSJvO8MKehLAjp8fOZ40TgKCctj4sg/bqKy1prwOt
	 kO5wYZD+D1xzA==
Date: Sun, 31 Dec 2023 16:42:19 +9900
Subject: [PATCH 09/10] spaceman: relocate the contents of an AG
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <170405020444.1820796.11110446647220627270.stgit@frogsfrogsfrogs>
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

Shrinking a filesystem needs to first remove all the active user
data and metadata from the AGs that are going to be lopped off the
filesystem. Before we can do this, we have to relocate this
information to a region of the filesystem that is going to be
retained.

We have a function to move an inode and all it's related
information to a specific AG, we have functions to find the
owners of all the information in an AG and we can find their paths.
This gives us all the information we need to relocate all the
objects in an AG we are going to remove via shrinking.

Firstly we scan the AG to be emptied to find the inodes that need to
be relocated, then we scan the directory structure to find all the
paths to those inodes that need to be moved. Then we iterate over
all the inodes to be moved attempting to move them to the lowest
numbers AGs.

When the destination AG fills up, we'll get ENOSPC from
the moving code and this is a trigger to bump the destination AG and
retry the move. If we haven't moved all the inodes and their data by
the time the destination reaches the source AG, then the entire
operation will fail with ENOSPC - there is not enough room in the
filesystem to empty the selected AG in preparation for a shrink.

This, once again, is not intended as an optimal or even guaranteed
way of emptying an AG for shrink. It simply provides the basic
algorithm and mechanisms we need to perform a shrink operation.
Improvements and optimisations will come in time, but we can't get
to an optimal solution without first having basic functionality in
place.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/fsgeom.h        |   10 ++
 man/man8/xfs_spaceman.8 |    8 ++
 spaceman/find_owner.c   |   32 +++---
 spaceman/init.c         |    1 
 spaceman/move_inode.c   |    7 +
 spaceman/relocation.c   |  234 +++++++++++++++++++++++++++++++++++++++++++++++
 spaceman/relocation.h   |    5 +
 spaceman/space.h        |    1 
 8 files changed, 280 insertions(+), 18 deletions(-)


diff --git a/libfrog/fsgeom.h b/libfrog/fsgeom.h
index 073a03e8681..f23184a0d34 100644
--- a/libfrog/fsgeom.h
+++ b/libfrog/fsgeom.h
@@ -202,6 +202,16 @@ cvt_daddr_to_agno(
 	return cvt_bb_to_off_fsbt(xfd, daddr) / xfd->fsgeom.agblocks;
 }
 
+/* Convert sparse filesystem block to AG Number */
+static inline uint32_t
+cvt_fsb_to_agno(
+	struct xfs_fd		*xfd,
+	uint64_t		fsbno)
+{
+	return fsbno >> xfd->agblklog;
+}
+
+
 /* Convert sector number to AG block number. */
 static inline uint32_t
 cvt_daddr_to_agbno(
diff --git a/man/man8/xfs_spaceman.8 b/man/man8/xfs_spaceman.8
index 6fef6949aa6..b6488810cfa 100644
--- a/man/man8/xfs_spaceman.8
+++ b/man/man8/xfs_spaceman.8
@@ -202,9 +202,17 @@ Wait for removal to complete.
 .TP
 .B print
 Display a list of all open files.
+.TP
+.BI "relocate \-a agno [ \-h agno ]"
+Empty out the given allocation group by moving file data elsewhere.
+The
+.B -h
+option specifies the highest allocation group into which we can move data.
+
 .TP
 .B resolve_owner
 Resolves space in the filesystem to file paths, maybe?
+
 .TP
 .B quit
 Exit
diff --git a/spaceman/find_owner.c b/spaceman/find_owner.c
index 4e03add75dc..3236290e3fd 100644
--- a/spaceman/find_owner.c
+++ b/spaceman/find_owner.c
@@ -9,10 +9,10 @@
 #include <linux/fiemap.h>
 #include "libfrog/fsgeom.h"
 #include "libfrog/radix-tree.h"
-#include "command.h"
-#include "init.h"
 #include "libfrog/paths.h"
 #include <linux/fsmap.h>
+#include "command.h"
+#include "init.h"
 #include "space.h"
 #include "input.h"
 #include "relocation.h"
@@ -65,8 +65,8 @@ track_inode(
 	set_reloc_iflag(owner, MOVE_BLOCKS);
 }
 
-static void
-scan_ag(
+int
+find_relocation_targets(
 	xfs_agnumber_t		agno)
 {
 	struct fsmap_head	*fsmap;
@@ -80,8 +80,7 @@ scan_ag(
 	fsmap = malloc(fsmap_sizeof(NR_EXTENTS));
 	if (!fsmap) {
 		fprintf(stderr, _("%s: fsmap malloc failed.\n"), progname);
-		exitcode = 1;
-		return;
+		return -ENOMEM;
 	}
 
 	memset(fsmap, 0, sizeof(*fsmap));
@@ -102,8 +101,7 @@ scan_ag(
 			fprintf(stderr, _("%s: FS_IOC_GETFSMAP [\"%s\"]: %s\n"),
 				progname, file->name, strerror(errno));
 			free(fsmap);
-			exitcode = 1;
-			return;
+			return -errno;
 		}
 
 		/* No more extents to map, exit */
@@ -148,6 +146,7 @@ scan_ag(
 	}
 
 	free(fsmap);
+	return 0;
 }
 
 /*
@@ -159,6 +158,7 @@ find_owner_f(
 	char			**argv)
 {
 	xfs_agnumber_t		agno = -1;
+	int			ret;
 	int			c;
 
 	while ((c = getopt(argc, argv, "a:")) != EOF) {
@@ -198,7 +198,9 @@ _("Filesystem at %s does not have reverse mapping enabled. Aborting.\n"),
 		return 0;
 	}
 
-	scan_ag(agno);
+	ret = find_relocation_targets(agno);
+	if (ret)
+		exitcode = 1;
 	return 0;
 }
 
@@ -299,8 +301,8 @@ _("Aborting: Storing path %s for inode 0x%lx failed: %s\n"),
  * This should be parallelised - pass subdirs off to a work queue, have the
  * work queue processes subdirs, queueing more subdirs to work on.
  */
-static int
-walk_mount(
+int
+resolve_target_paths(
 	const char	*mntpt)
 {
 	int		ret;
@@ -361,9 +363,9 @@ list_inode_paths(void)
 
 	/*
 	 * Any inodes remaining in the tree at this point indicate inodes whose
-	 * paths were not found. This will be unlinked but still open inodes or
-	 * lost inodes due to corruptions. Either way, a shrink will not succeed
-	 * until these inodes are removed from the filesystem.
+	 * paths were not found. This will be free inodes or unlinked but still
+	 * open inodes. Either way, a shrink will not succeed until these inodes
+	 * are removed from the filesystem.
 	 */
 	idx = 0;
 	do {
@@ -400,7 +402,7 @@ _("Inode list has not been populated. No inodes to resolve.\n"));
 		return 0;
 	}
 
-	ret = walk_mount(file->fs_path.fs_dir);
+	ret = resolve_target_paths(file->fs_path.fs_dir);
 	if (ret) {
 		fprintf(stderr,
 _("Failed to resolve all paths from mount point %s: %s\n"),
diff --git a/spaceman/init.c b/spaceman/init.c
index 8b0af14e566..cfe1b96fb66 100644
--- a/spaceman/init.c
+++ b/spaceman/init.c
@@ -40,6 +40,7 @@ init_commands(void)
 	move_inode_init();
 	find_owner_init();
 	resolve_owner_init();
+	relocate_init();
 }
 
 static int
diff --git a/spaceman/move_inode.c b/spaceman/move_inode.c
index 6238a48e948..9190b1d3ab2 100644
--- a/spaceman/move_inode.c
+++ b/spaceman/move_inode.c
@@ -12,6 +12,7 @@
 #include "space.h"
 #include "input.h"
 #include "handle.h"
+#include "relocation.h"
 
 #include <linux/fiemap.h>
 #include <linux/falloc.h>
@@ -404,8 +405,8 @@ exchange_inodes(
 	return 0;
 }
 
-static int
-move_file_to_ag(
+int
+relocate_file_to_ag(
 	const char		*mnt,
 	const char		*path,
 	struct xfs_fd		*xfd,
@@ -511,7 +512,7 @@ _("Destination AG %d does not exist. Filesystem only has %d AGs\n"),
 	}
 
 	if (S_ISREG(st.st_mode)) {
-		ret = move_file_to_ag(file->fs_path.fs_dir, file->name,
+		ret = relocate_file_to_ag(file->fs_path.fs_dir, file->name,
 				&file->xfd, agno);
 	} else {
 		fprintf(stderr, _("Unsupported: %s is not a regular file.\n"),
diff --git a/spaceman/relocation.c b/spaceman/relocation.c
index 1c0db6a1dab..7b125cc0ae1 100644
--- a/spaceman/relocation.c
+++ b/spaceman/relocation.c
@@ -315,3 +315,237 @@ forget_reloc_ino(
 	free(rln);
 }
 #endif /* USE_RADIX_TREE_FOR_INUMS */
+
+static struct cmdinfo relocate_cmd;
+
+static int
+relocate_targets_to_ag(
+	const char		*mnt,
+	xfs_agnumber_t		dst_agno)
+{
+	struct inode_path	*ipath;
+	uint64_t		idx = 0;
+	int			ret = 0;
+
+	do {
+		struct xfs_fd	xfd = {0};
+		struct stat	st;
+
+		/* lookup first relocation target */
+		ipath = get_next_reloc_ipath(idx);
+		if (!ipath)
+			break;
+
+		/* XXX: don't handle hard link cases yet */
+		if (ipath->link_count > 1) {
+			fprintf(stderr,
+		"FIXME! Skipping hardlinked inode at path %s\n",
+				ipath->path);
+			goto next;
+		}
+
+
+		ret = stat(ipath->path, &st);
+		if (ret) {
+			fprintf(stderr, _("stat(%s) failed: %s\n"),
+				ipath->path, strerror(errno));
+			goto next;
+		}
+
+		if (!S_ISREG(st.st_mode)) {
+			fprintf(stderr,
+		_("FIXME! Skipping %s: not a regular file.\n"),
+				ipath->path);
+			goto next;
+		}
+
+		ret = xfd_open(&xfd, ipath->path, O_RDONLY);
+		if (ret) {
+			fprintf(stderr, _("xfd_open(%s) failed: %s\n"),
+				ipath->path, strerror(-ret));
+			goto next;
+		}
+
+		/* move to destination AG */
+		ret = relocate_file_to_ag(mnt, ipath->path, &xfd, dst_agno);
+		xfd_close(&xfd);
+
+		/*
+		 * If the destination AG has run out of space, we do not remove
+		 * this inode from relocation data so it will be immediately
+		 * retried in the next AG. Other errors will be fatal.
+		 */
+		if (ret < 0)
+			return ret;
+next:
+		/* remove from relocation data */
+		idx = ipath->ino + 1;
+		forget_reloc_ino(ipath->ino);
+	} while (ret != -ENOSPC);
+
+	return ret;
+}
+
+static int
+relocate_targets(
+	const char		*mnt,
+	xfs_agnumber_t		highest_agno)
+{
+	xfs_agnumber_t		dst_agno = 0;
+	int			ret;
+
+	for (dst_agno = 0; dst_agno <= highest_agno; dst_agno++) {
+		ret = relocate_targets_to_ag(mnt, dst_agno);
+		if (ret == -ENOSPC)
+			continue;
+		break;
+	}
+	return ret;
+}
+
+/*
+ * Relocate all the user objects in an AG to lower numbered AGs.
+ */
+static int
+relocate_f(
+	int		argc,
+	char		**argv)
+{
+	xfs_agnumber_t	target_agno = -1;
+	xfs_agnumber_t	highest_agno = -1;
+	xfs_agnumber_t	log_agno;
+	void		*fshandle;
+	size_t		fshdlen;
+	int		c;
+	int		ret;
+
+	while ((c = getopt(argc, argv, "a:h:")) != EOF) {
+		switch (c) {
+		case 'a':
+			target_agno = cvt_u32(optarg, 10);
+			if (errno) {
+				fprintf(stderr, _("bad target agno value %s\n"),
+					optarg);
+				return command_usage(&relocate_cmd);
+			}
+			break;
+		case 'h':
+			highest_agno = cvt_u32(optarg, 10);
+			if (errno) {
+				fprintf(stderr, _("bad highest agno value %s\n"),
+					optarg);
+				return command_usage(&relocate_cmd);
+			}
+			break;
+		default:
+			return command_usage(&relocate_cmd);
+		}
+	}
+
+	if (optind != argc)
+		return command_usage(&relocate_cmd);
+
+	if (target_agno == -1) {
+		fprintf(stderr, _("Target AG must be specified!\n"));
+		return command_usage(&relocate_cmd);
+	}
+
+	log_agno = cvt_fsb_to_agno(&file->xfd, file->xfd.fsgeom.logstart);
+	if (target_agno <= log_agno) {
+		fprintf(stderr,
+_("Target AG %d must be higher than the journal AG (AG %d). Aborting.\n"),
+			target_agno, log_agno);
+		goto out_fail;
+	}
+
+	if (target_agno >= file->xfd.fsgeom.agcount) {
+		fprintf(stderr,
+_("Target AG %d does not exist. Filesystem only has %d AGs\n"),
+			target_agno, file->xfd.fsgeom.agcount);
+		goto out_fail;
+	}
+
+	if (highest_agno == -1)
+		highest_agno = target_agno - 1;
+
+	if (highest_agno >= target_agno) {
+		fprintf(stderr,
+_("Highest destination AG %d must be less than target AG %d. Aborting.\n"),
+			highest_agno, target_agno);
+		goto out_fail;
+	}
+
+	if (is_reloc_populated()) {
+		fprintf(stderr,
+_("Relocation data populated from previous commands. Aborting.\n"));
+		goto out_fail;
+	}
+
+	/* this is so we can use fd_to_handle() later on */
+	ret = path_to_fshandle(file->fs_path.fs_dir, &fshandle, &fshdlen);
+	if (ret < 0) {
+		fprintf(stderr, _("Cannot get fshandle for mount %s: %s\n"),
+			file->fs_path.fs_dir, strerror(errno));
+		goto out_fail;
+	}
+
+	ret = find_relocation_targets(target_agno);
+	if (ret) {
+		fprintf(stderr,
+_("Failure during target discovery. Aborting.\n"));
+		goto out_fail;
+	}
+
+	ret = resolve_target_paths(file->fs_path.fs_dir);
+	if (ret) {
+		fprintf(stderr,
+_("Failed to resolve all paths from mount point %s: %s\n"),
+			file->fs_path.fs_dir, strerror(-ret));
+		goto out_fail;
+	}
+
+	ret = relocate_targets(file->fs_path.fs_dir, highest_agno);
+	if (ret) {
+		fprintf(stderr,
+_("Failed to relocate all targets out of AG %d: %s\n"),
+			target_agno, strerror(-ret));
+		goto out_fail;
+	}
+
+	return 0;
+out_fail:
+	exitcode = 1;
+	return 0;
+}
+
+static void
+relocate_help(void)
+{
+	printf(_(
+"\n"
+"Relocate all the user data and metadata in an AG.\n"
+"\n"
+"This function will discover all the relocatable objects in a single AG and\n"
+"move them to a lower AG as preparation for a shrink operation.\n"
+"\n"
+"	-a <agno>	Allocation group to empty\n"
+"	-h <agno>	Highest target AG allowed to relocate into\n"
+"\n"));
+
+}
+
+void
+relocate_init(void)
+{
+	relocate_cmd.name = "relocate";
+	relocate_cmd.altname = "relocate";
+	relocate_cmd.cfunc = relocate_f;
+	relocate_cmd.argmin = 2;
+	relocate_cmd.argmax = 4;
+	relocate_cmd.args = "-a agno [-h agno]";
+	relocate_cmd.flags = CMD_FLAG_ONESHOT;
+	relocate_cmd.oneline = _("Relocate data in an AG.");
+	relocate_cmd.help = relocate_help;
+
+	add_command(&relocate_cmd);
+}
diff --git a/spaceman/relocation.h b/spaceman/relocation.h
index f05a871915d..d4c71b7bb7f 100644
--- a/spaceman/relocation.h
+++ b/spaceman/relocation.h
@@ -43,4 +43,9 @@ struct inode_path {
  */
 #define UNLINKED_IPATH		((struct inode_path *)1)
 
+int find_relocation_targets(xfs_agnumber_t agno);
+int relocate_file_to_ag(const char *mnt, const char *path, struct xfs_fd *xfd,
+			xfs_agnumber_t agno);
+int resolve_target_paths(const char *mntpt);
+
 #endif /* XFS_SPACEMAN_RELOCATION_H_ */
diff --git a/spaceman/space.h b/spaceman/space.h
index cffb1882153..8c2b3e5464d 100644
--- a/spaceman/space.h
+++ b/spaceman/space.h
@@ -41,5 +41,6 @@ extern void	health_init(void);
 void		move_inode_init(void);
 void		find_owner_init(void);
 void		resolve_owner_init(void);
+void		relocate_init(void);
 
 #endif /* XFS_SPACEMAN_SPACE_H_ */

