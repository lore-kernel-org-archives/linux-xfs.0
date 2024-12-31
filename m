Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E42529415
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735688802; cv=none; b=Ds1dIvA6dyf1DCS5ljysqmSIXG35Bzp1n5RHOq7l9wQGkB5z2wPx6nE+J9xJu2A/zRNrAc3ohnGEUON8TXPQVMaijY2AOZG1S/L4glq1OjP5OU9xF7T/paCZ2NtLljLBFO2Ku5LktvaSkVkDFRAbaC0HPe8+m9B5Awn95xW+Xx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735688802; c=relaxed/simple;
	bh=IfOhOqc/kJ43To3u3e21xv6uM0GT8r3eB4uo0tqF76Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QOXsNVzp9LHb0xEr0BSIiHsz1uZSscXEp9kYjPcrdR9DaIgOY4gurNqfLNsJzMTLbsQ1wZcKHDIk48skoedfr2AOFsewLtwWe4bSeGJNOptH56aVaRUpuUxESYo8Ctbl8OA1qfL39FrqXkbNEmsDA5d8JGqQEj/0nbCl7kQIQh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ikNxpCmM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ikNxpCmM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 924E4C4CED2;
	Tue, 31 Dec 2024 23:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735688800;
	bh=IfOhOqc/kJ43To3u3e21xv6uM0GT8r3eB4uo0tqF76Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ikNxpCmM59sV2Bc+nbEvLw0GfU+bpO2lgO2E3+Y7aJVDhEvvGJJTFkbCvZDdEg/Vy
	 +Vljz5SQQ95q52vBlgvZudUWb2Y8hxQu1i38pOzfzgcnI0PsCiZFWG4lotaDxvA37z
	 zvw/YaEi3+pRu59k46g+N525y7nLz0XuMVNB8GKJIqxYbSTIgZVkU947NZhH7I+RcT
	 HBFblOKaz07f7FOaJnmWNvfgxssinyJULx4uXsnOY/M4oHvAyIMMss8XV4rndnHBRZ
	 efClJ0FfgJpVSouPTQB/4ESHMPxBMKAbBTV1mH/RewpjsWXuvmcL83S9gHJglUVb0O
	 RxVMgZgrzJ8Zg==
Date: Tue, 31 Dec 2024 15:46:40 -0800
Subject: [PATCH 07/11] spaceman: find owners of space in an AG
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: dchinner@redhat.com, linux-xfs@vger.kernel.org
Message-ID: <173568777977.2709794.10470936364792801206.stgit@frogsfrogsfrogs>
In-Reply-To: <173568777852.2709794.6356870909327619205.stgit@frogsfrogsfrogs>
References: <173568777852.2709794.6356870909327619205.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Dave Chinner <dchinner@redhat.com>

Before we can move inodes for a shrink operation, we have to find
all the inodes that own space in the AG(s) we want to empty.

This implementation uses FS_IOC_GETFSMAP on the assumption that
filesystems to be shrunk have reverse mapping enabled as it is the
only way to identify inode related metadata that userspace is unable
to see or influence (e.g. BMBT blocks) that may be located in the
specific AG. We can use GETFSMAP to identify both inodes to be moved
(via XFS_FMR_OWN_INODES records) and inodes with just data and/or
metadata to be moved.

Once we have identified all the inodes to be moved, we have to
map them to paths so that we can use renameat2() to exchange the
directory entries pointing at the moved inode atomically. We also
need to record inodes with hard links and all of the paths to the
inode so that hard links can be recreated appropriately.

This requires a directory tree walk to discover the paths (until
parent pointers are a thing). Hence for filesystems that aren't
reverse mapping enabled, we can eventually use this pass to discover
inodes with visible data and metadata that need to be moved.

As we resolve the paths to the inodes to be moved, output the
information to stdout so that it can be acted upon by other
utilities. This results in a command that acts similar to find but
with a physical location filter rather than an inode metadata
filter.

Again, this is not meant to be an optimal implementation. It
shouldn't suck, but there is plenty of scope for performance
optimisation, especially with a multithreaded and/or async directory
traversal/parent pointer path resolution process to hide access
latencies.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libfrog/fsgeom.h        |   19 ++
 libfrog/radix-tree.c    |    2 
 libfrog/radix-tree.h    |    2 
 man/man8/xfs_spaceman.8 |   11 +
 spaceman/Makefile       |    1 
 spaceman/find_owner.c   |  481 +++++++++++++++++++++++++++++++++++++++++++++++
 spaceman/init.c         |    4 
 spaceman/space.h        |    2 
 8 files changed, 521 insertions(+), 1 deletion(-)
 create mode 100644 spaceman/find_owner.c


diff --git a/libfrog/fsgeom.h b/libfrog/fsgeom.h
index b851b9bbf36a58..679046077cba84 100644
--- a/libfrog/fsgeom.h
+++ b/libfrog/fsgeom.h
@@ -97,6 +97,25 @@ cvt_ino_to_agino(
 	return ino & ((1ULL << xfd->aginolog) - 1);
 }
 
+/* Convert an AG block to an AG inode number. */
+static inline uint32_t
+cvt_agbno_to_agino(
+	const struct xfs_fd	*xfd,
+	xfs_agblock_t		agbno)
+{
+	return agbno << xfd->inopblog;
+}
+
+/* Calculate the number of inodes in a byte range */
+static inline uint32_t
+cvt_b_to_inode_count(
+	const struct xfs_fd	*xfd,
+	uint64_t		bytes)
+{
+	return (bytes >> xfd->blocklog) << xfd->inopblog;
+}
+
+
 /*
  * Convert a linear fs block offset number into bytes.  This is the runtime
  * equivalent of XFS_FSB_TO_B, which means that it is /not/ for segmented fsbno
diff --git a/libfrog/radix-tree.c b/libfrog/radix-tree.c
index 261fc2487de97f..788d11612e290f 100644
--- a/libfrog/radix-tree.c
+++ b/libfrog/radix-tree.c
@@ -377,6 +377,8 @@ void *radix_tree_tag_set(struct radix_tree_root *root,
 	unsigned int height, shift;
 	struct radix_tree_node *slot;
 
+	ASSERT(tag < RADIX_TREE_MAX_TAGS);
+
 	height = root->height;
 	if (index > radix_tree_maxindex(height))
 		return NULL;
diff --git a/libfrog/radix-tree.h b/libfrog/radix-tree.h
index 0a4e3bb4f9defc..73f41a9d902a26 100644
--- a/libfrog/radix-tree.h
+++ b/libfrog/radix-tree.h
@@ -28,7 +28,7 @@ do {									\
 } while (0)
 
 #ifdef RADIX_TREE_TAGS
-#define RADIX_TREE_MAX_TAGS 2
+#define RADIX_TREE_MAX_TAGS 3
 #endif
 
 int radix_tree_insert(struct radix_tree_root *, unsigned long, void *);
diff --git a/man/man8/xfs_spaceman.8 b/man/man8/xfs_spaceman.8
index f898a8bbe840ea..6fef6949aa6c8b 100644
--- a/man/man8/xfs_spaceman.8
+++ b/man/man8/xfs_spaceman.8
@@ -41,6 +41,14 @@ .SH COMMANDS
 If the
 .B -v
 option is given, print what's happening every step of the way.
+.TP
+.BI "find_owner \-a agno"
+Create an internal structure to map physical space in the given allocation
+group to file paths.
+This enables space reorganization on a mounted filesystem by enabling
+us to find files.
+Unclear why we can't just use FSMAP and BULKSTAT to open by handle.
+
 .TP
 .BI "freesp [ \-dgrs ] [-a agno]... [ \-b | \-e bsize | \-h bsize | \-m factor ]"
 With no arguments,
@@ -195,6 +203,9 @@ .SH COMMANDS
 .B print
 Display a list of all open files.
 .TP
+.B resolve_owner
+Resolves space in the filesystem to file paths, maybe?
+.TP
 .B quit
 Exit
 .BR xfs_spaceman .
diff --git a/spaceman/Makefile b/spaceman/Makefile
index 9d080b67de9a22..b35ab1dbd2f440 100644
--- a/spaceman/Makefile
+++ b/spaceman/Makefile
@@ -11,6 +11,7 @@ HFILES = \
 	space.h
 CFILES = \
 	file.c \
+	find_owner.c \
 	health.c \
 	info.c \
 	init.c \
diff --git a/spaceman/find_owner.c b/spaceman/find_owner.c
new file mode 100644
index 00000000000000..7a656d80d21217
--- /dev/null
+++ b/spaceman/find_owner.c
@@ -0,0 +1,481 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2017 Oracle.
+ * Copyright (c) 2020 Red Hat, Inc.
+ * All Rights Reserved.
+ */
+
+#include "libxfs.h"
+#include <linux/fiemap.h>
+#include "libfrog/fsgeom.h"
+#include "libfrog/radix-tree.h"
+#include "command.h"
+#include "init.h"
+#include "libfrog/paths.h"
+#include <linux/fsmap.h>
+#include "space.h"
+#include "input.h"
+
+static cmdinfo_t find_owner_cmd;
+static cmdinfo_t resolve_owner_cmd;
+
+#define NR_EXTENTS 128
+
+static RADIX_TREE(inode_tree, 0);
+#define MOVE_INODE	0
+#define MOVE_BLOCKS	1
+#define INODE_PATH	2
+int inode_count;
+int inode_paths;
+
+static void
+track_inode_chunks(
+	struct xfs_fd	*xfd,
+	xfs_agnumber_t	agno,
+	uint64_t	physaddr,
+	uint64_t	length)
+{
+	xfs_agblock_t	agbno = cvt_b_to_agbno(xfd, physaddr);
+	uint64_t	first_ino = cvt_agino_to_ino(xfd, agno,
+						cvt_agbno_to_agino(xfd, agbno));
+	uint64_t	num_inodes = cvt_b_to_inode_count(xfd, length);
+	int		i;
+
+	printf(_("AG %d\tInode Range to move: 0x%llx - 0x%llx (length 0x%llx)\n"),
+			agno,
+			(unsigned long long)first_ino,
+			(unsigned long long)first_ino + num_inodes - 1,
+			(unsigned long long)length);
+
+	for (i = 0; i < num_inodes; i++) {
+		if (!radix_tree_lookup(&inode_tree, first_ino + i)) {
+			radix_tree_insert(&inode_tree, first_ino + i,
+					(void *)first_ino + i);
+			inode_count++;
+		}
+		radix_tree_tag_set(&inode_tree, first_ino + i, MOVE_INODE);
+	}
+}
+
+static void
+track_inode(
+	struct xfs_fd	*xfd,
+	xfs_agnumber_t	agno,
+	uint64_t	owner,
+	uint64_t	physaddr,
+	uint64_t	length)
+{
+	if (radix_tree_tag_get(&inode_tree, owner, MOVE_BLOCKS))
+		return;
+
+	printf(_("AG %d\tInode 0x%llx: blocks to move to move: 0x%llx - 0x%llx\n"),
+			agno,
+			(unsigned long long)owner,
+			(unsigned long long)physaddr,
+			(unsigned long long)physaddr + length - 1);
+	if (!radix_tree_lookup(&inode_tree, owner)) {
+		radix_tree_insert(&inode_tree, owner, (void *)owner);
+		inode_count++;
+	}
+	radix_tree_tag_set(&inode_tree, owner, MOVE_BLOCKS);
+}
+
+static void
+scan_ag(
+	xfs_agnumber_t		agno)
+{
+	struct fsmap_head	*fsmap;
+	struct fsmap		*extent;
+	struct fsmap		*l, *h;
+	struct fsmap		*p;
+	struct xfs_fd		*xfd = &file->xfd;
+	int			ret;
+	int			i;
+
+	fsmap = malloc(fsmap_sizeof(NR_EXTENTS));
+	if (!fsmap) {
+		fprintf(stderr, _("%s: fsmap malloc failed.\n"), progname);
+		exitcode = 1;
+		return;
+	}
+
+	memset(fsmap, 0, sizeof(*fsmap));
+	fsmap->fmh_count = NR_EXTENTS;
+	l = fsmap->fmh_keys;
+	h = fsmap->fmh_keys + 1;
+	l->fmr_physical = cvt_agbno_to_b(xfd, agno, 0);
+	h->fmr_physical = cvt_agbno_to_b(xfd, agno + 1, 0);
+	l->fmr_device = h->fmr_device = file->fs_path.fs_datadev;
+	h->fmr_owner = ULLONG_MAX;
+	h->fmr_flags = UINT_MAX;
+	h->fmr_offset = ULLONG_MAX;
+
+	while (true) {
+		printf("Inode count %d\n", inode_count);
+		ret = ioctl(xfd->fd, FS_IOC_GETFSMAP, fsmap);
+		if (ret < 0) {
+			fprintf(stderr, _("%s: FS_IOC_GETFSMAP [\"%s\"]: %s\n"),
+				progname, file->name, strerror(errno));
+			free(fsmap);
+			exitcode = 1;
+			return;
+		}
+
+		/* No more extents to map, exit */
+		if (!fsmap->fmh_entries)
+			break;
+
+		/*
+		 * Walk the extents, ignore everything except inode chunks
+		 * and inode owned blocks.
+		 */
+		for (i = 0, extent = fsmap->fmh_recs;
+		     i < fsmap->fmh_entries;
+		     i++, extent++) {
+			if (extent->fmr_flags & FMR_OF_SPECIAL_OWNER) {
+				if (extent->fmr_owner != XFS_FMR_OWN_INODES)
+					continue;
+				/*
+				 * This extent contains inodes that need to be
+				 * moved into another AG. Convert the extent to
+				 * a range of inode numbers and track them all.
+				 */
+				track_inode_chunks(xfd, agno,
+							extent->fmr_physical,
+							extent->fmr_length);
+
+				continue;
+			}
+
+			/*
+			 * Extent is owned by an inode that may be located
+			 * anywhere in the filesystem, not just this AG.
+			 */
+			track_inode(xfd, agno, extent->fmr_owner,
+					extent->fmr_physical,
+					extent->fmr_length);
+		}
+
+		p = &fsmap->fmh_recs[fsmap->fmh_entries - 1];
+		if (p->fmr_flags & FMR_OF_LAST)
+			break;
+		fsmap_advance(fsmap);
+	}
+
+	free(fsmap);
+}
+
+/*
+ * find inodes that own physical space in a given AG.
+ */
+static int
+find_owner_f(
+	int			argc,
+	char			**argv)
+{
+	xfs_agnumber_t		agno = -1;
+	int			c;
+
+	while ((c = getopt(argc, argv, "a:")) != EOF) {
+		switch (c) {
+		case 'a':
+			agno = cvt_u32(optarg, 10);
+			if (errno) {
+				fprintf(stderr, _("bad agno value %s\n"),
+					optarg);
+				return command_usage(&find_owner_cmd);
+			}
+			break;
+		default:
+			return command_usage(&find_owner_cmd);
+		}
+	}
+
+	if (optind != argc)
+		return command_usage(&find_owner_cmd);
+
+	if (agno == -1 || agno >= file->xfd.fsgeom.agcount) {
+		fprintf(stderr,
+_("Destination AG %d does not exist. Filesystem only has %d AGs\n"),
+			agno, file->xfd.fsgeom.agcount);
+		exitcode = 1;
+		return 0;
+	}
+
+	/*
+	 * Check that rmap is enabled so that GETFSMAP is actually useful.
+	 */
+	if (!(file->xfd.fsgeom.flags & XFS_FSOP_GEOM_FLAGS_RMAPBT)) {
+		fprintf(stderr,
+_("Filesystem at %s does not have reverse mapping enabled. Aborting.\n"),
+			file->fs_path.fs_dir);
+		exitcode = 1;
+		return 0;
+	}
+
+	scan_ag(agno);
+	return 0;
+}
+
+static void
+find_owner_help(void)
+{
+	printf(_(
+"\n"
+"Find inodes owning physical blocks in a given AG.\n"
+"\n"
+" -a agno  -- Scan the given AG agno.\n"
+"\n"));
+
+}
+
+void
+find_owner_init(void)
+{
+	find_owner_cmd.name = "find_owner";
+	find_owner_cmd.altname = "fown";
+	find_owner_cmd.cfunc = find_owner_f;
+	find_owner_cmd.argmin = 2;
+	find_owner_cmd.argmax = 2;
+	find_owner_cmd.args = "-a agno";
+	find_owner_cmd.flags = CMD_FLAG_ONESHOT;
+	find_owner_cmd.oneline = _("Find inodes owning physical blocks in a given AG");
+	find_owner_cmd.help = find_owner_help;
+
+	add_command(&find_owner_cmd);
+}
+
+/*
+ * for each dirent we get returned, look up the inode tree to see if it is an
+ * inode we need to process. If it is, then replace the entry in the tree with
+ * a structure containing the current path and mark the entry as resolved.
+ */
+struct inode_path {
+	uint64_t		ino;
+	struct list_head	path_list;
+	uint32_t		link_count;
+	char			path[1];
+};
+
+static int
+resolve_owner_cb(
+	const char		*path,
+	const struct stat	*stat,
+	int			status,
+	struct FTW		*data)
+{
+	struct inode_path	*ipath, *slot_ipath;
+	int			pathlen;
+	void			**slot;
+
+	/*
+	 * Lookup the slot rather than the entry so we can replace the contents
+	 * without another lookup later on.
+	 */
+	slot = radix_tree_lookup_slot(&inode_tree, stat->st_ino);
+	if (!slot || *slot == NULL)
+		return 0;
+
+	/* Could not get stat data? Fail! */
+	if (status == FTW_NS) {
+		fprintf(stderr,
+_("Failed to obtain stat(2) information from path %s. Aborting\n"),
+			path);
+		return -EPERM;
+	}
+
+	/* Allocate a new inode path and record the path in it. */
+	pathlen = strlen(path);
+	ipath = calloc(1, sizeof(*ipath) + pathlen + 1);
+	if (!ipath) {
+		fprintf(stderr,
+_("Aborting: Storing path %s for inode 0x%lx failed: %s\n"),
+			path, stat->st_ino, strerror(ENOMEM));
+		return -ENOMEM;
+	}
+	INIT_LIST_HEAD(&ipath->path_list);
+	memcpy(&ipath->path[0], path, pathlen);
+	ipath->ino = stat->st_ino;
+
+	/*
+	 * If the slot contains the inode number we just looked up, then we
+	 * haven't recorded a path for it yet. If that is the case, we just
+	 * set the link count of the path to 1 and replace the slot contents
+	 * with our new_ipath.
+	 */
+	if (stat->st_ino == (uint64_t)*slot) {
+		ipath->link_count = 1;
+		*slot = ipath;
+		radix_tree_tag_set(&inode_tree, stat->st_ino, INODE_PATH);
+		inode_paths++;
+		return 0;
+	}
+
+	/*
+	 * Multiple hard links to this inode. The slot already contains an
+	 * ipath pointer, so we add the new ipath to the tail of the list held
+	 * by the slot's ipath and bump the link count of the slot's ipath to
+	 * keep track of how many hard links the inode has.
+	 */
+	slot_ipath = *slot;
+	slot_ipath->link_count++;
+	list_add_tail(&ipath->path_list, &slot_ipath->path_list);
+	return 0;
+}
+
+/*
+ * This should be parallelised - pass subdirs off to a work queue, have the
+ * work queue processes subdirs, queueing more subdirs to work on.
+ */
+static int
+walk_mount(
+	const char	*mntpt)
+{
+	int		ret;
+
+	ret = nftw(mntpt, resolve_owner_cb,
+                        100, FTW_PHYS | FTW_MOUNT | FTW_DEPTH);
+	if (ret)
+		return -errno;
+	return 0;
+}
+
+static int
+list_inode_paths(void)
+{
+	struct inode_path	*ipath;
+	uint64_t		idx = 0;
+	int			ret;
+
+	do {
+		bool		move_blocks;
+		bool		move_inode;
+
+		ret = radix_tree_gang_lookup_tag(&inode_tree, (void **)&ipath,
+						idx, 1, INODE_PATH);
+		if (!ret)
+			break;
+		idx = ipath->ino + 1;
+
+		/* Grab status tags and remove from tree. */
+		move_blocks = radix_tree_tag_get(&inode_tree, ipath->ino,
+						MOVE_BLOCKS);
+		move_inode = radix_tree_tag_get(&inode_tree, ipath->ino,
+						MOVE_INODE);
+		radix_tree_delete(&inode_tree, ipath->ino);
+
+		/* Print the initial path with inode number and state. */
+		printf("0x%.16llx\t%s\t%s\t%8d\t%s\n",
+				(unsigned long long)ipath->ino,
+				move_blocks ? "BLOCK" : "---",
+				move_inode ? "INODE" : "---",
+				ipath->link_count, ipath->path);
+		ipath->link_count--;
+
+		/* Walk all the hard link paths and emit them. */
+		while (!list_empty(&ipath->path_list)) {
+			struct inode_path	*hpath;
+
+			hpath = list_first_entry(&ipath->path_list,
+					struct inode_path, path_list);
+			list_del(&hpath->path_list);
+			ipath->link_count--;
+
+			printf("\t\t\t\t\t%s\n", hpath->path);
+		}
+		if (ipath->link_count) {
+			printf(_("Link count anomaly: %d paths left over\n"),
+				ipath->link_count);
+		}
+		free(ipath);
+	} while (true);
+
+	/*
+	 * Any inodes remaining in the tree at this point indicate inodes whose
+	 * paths were not found. This will be unlinked but still open inodes or
+	 * lost inodes due to corruptions. Either way, a shrink will not succeed
+	 * until these inodes are removed from the filesystem.
+	 */
+	idx = 0;
+	do {
+		uint64_t	ino;
+
+
+		ret = radix_tree_gang_lookup(&inode_tree, (void **)&ino, idx, 1);
+		if (!ret) {
+			if (idx != 0)
+				ret = -EBUSY;
+			break;
+		}
+		idx = ino + 1;
+		printf(_("No path found for inode 0x%llx!\n"),
+				(unsigned long long)ino);
+		radix_tree_delete(&inode_tree, ino);
+	} while (true);
+
+	return ret;
+}
+
+/*
+ * Resolve inode numbers to paths via a directory tree walk.
+ */
+static int
+resolve_owner_f(
+	int	argc,
+	char	**argv)
+{
+	int	ret;
+
+	if (!inode_tree.rnode) {
+		fprintf(stderr,
+_("Inode list has not been populated. No inodes to resolve.\n"));
+		return 0;
+	}
+
+	ret = walk_mount(file->fs_path.fs_dir);
+	if (ret) {
+		fprintf(stderr,
+_("Failed to resolve all paths from mount point %s: %s\n"),
+			file->fs_path.fs_dir, strerror(-ret));
+		exitcode = 1;
+		return 0;
+	}
+
+	ret = list_inode_paths();
+	if (ret) {
+		fprintf(stderr,
+_("Failed to list all resolved paths from mount point %s: %s\n"),
+			file->fs_path.fs_dir, strerror(-ret));
+		exitcode = 1;
+		return 0;
+	}
+	return 0;
+}
+
+static void
+resolve_owner_help(void)
+{
+	printf(_(
+"\n"
+"Resolve inodes owning physical blocks in a given AG.\n"
+"This requires the find_owner command to be run first to populate the table\n"
+"of inodes that need to have their paths resolved.\n"
+"\n"));
+
+}
+
+void
+resolve_owner_init(void)
+{
+	resolve_owner_cmd.name = "resolve_owner";
+	resolve_owner_cmd.altname = "rown";
+	resolve_owner_cmd.cfunc = resolve_owner_f;
+	resolve_owner_cmd.argmin = 0;
+	resolve_owner_cmd.argmax = 0;
+	resolve_owner_cmd.args = "";
+	resolve_owner_cmd.flags = CMD_FLAG_ONESHOT;
+	resolve_owner_cmd.oneline = _("Resolve patches to inodes owning physical blocks in a given AG");
+	resolve_owner_cmd.help = resolve_owner_help;
+
+	add_command(&resolve_owner_cmd);
+}
diff --git a/spaceman/init.c b/spaceman/init.c
index dbeebcf97b9fb2..8b0af14e566dc8 100644
--- a/spaceman/init.c
+++ b/spaceman/init.c
@@ -10,6 +10,7 @@
 #include "input.h"
 #include "init.h"
 #include "libfrog/paths.h"
+#include "libfrog/radix-tree.h"
 #include "space.h"
 
 char	*progname;
@@ -37,6 +38,8 @@ init_commands(void)
 	health_init();
 	clearfree_init();
 	move_inode_init();
+	find_owner_init();
+	resolve_owner_init();
 }
 
 static int
@@ -71,6 +74,7 @@ init(
 	setlocale(LC_ALL, "");
 	bindtextdomain(PACKAGE, LOCALEDIR);
 	textdomain(PACKAGE);
+	radix_tree_init();
 
 	fs_table_initialise(0, NULL, 0, NULL);
 	while ((c = getopt(argc, argv, "c:p:V")) != EOF) {
diff --git a/spaceman/space.h b/spaceman/space.h
index 96c3c356f13fec..cffb1882153a18 100644
--- a/spaceman/space.h
+++ b/spaceman/space.h
@@ -39,5 +39,7 @@ extern void	clearfree_init(void);
 extern void	info_init(void);
 extern void	health_init(void);
 void		move_inode_init(void);
+void		find_owner_init(void);
+void		resolve_owner_init(void);
 
 #endif /* XFS_SPACEMAN_SPACE_H_ */

