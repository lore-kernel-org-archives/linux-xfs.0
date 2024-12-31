Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5535D29415
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735688816; cv=none; b=lOmmQApyXKuiaDb1SKBCSSHZtSuCG4mXP5cbWyzLFK1Veq9uXK5To2yxhLOB9DwYWOe0dq1DX8WhtjD3tH+eaUWcXSi+2ad4pzAH7gClSJCTOkAlwwWvNzkL8wMtC5Ui2P4+Wlzn2j56Qcq4WieNnrrRi3x1u96ofVdXZ5fbOeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735688816; c=relaxed/simple;
	bh=Bu7yhGg97khaNKSU1dyKpsfZL2ifbUjEhTpf9bSXmHU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VhgU9PeKBGdqr3axfz1pMzAJUFwlmHqfzDdvu8+8SUuIjMVbyrB3lyecLkHTaKkCxKDMYiSMNWc1O/RsAy1TK3WMzpqQ17tjLo5cVZUHSMxVtUo3UuHDb2nVEVbXakrFXt7A9s4Jtjku1uf/KE5raCmIlYSwo/ND548karkCF9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UqND8uuE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UqND8uuE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30BF9C4CED2;
	Tue, 31 Dec 2024 23:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735688816;
	bh=Bu7yhGg97khaNKSU1dyKpsfZL2ifbUjEhTpf9bSXmHU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UqND8uuEGBXiUeG/S6SXKvhx11g8kZzcYy4ClHNWmdJ0nOhogVXbdpUr+0aGTgOBj
	 66bQC2bkrNKXZJmegQicWVMrpaLnbS/199HhIg+8dBiskM0DAs1wHgunusf1kFcZrh
	 5+9ugHCjbvMem5aU1FOXSEGCB0wC1NOyffF92yUjOnib1X775B8EpGLrgyh6fJDYRL
	 DUxtrijdxnB1LL575fApLiPJGYhbDFYZ47+/DhYxGDh9XnxqKcAH5V+8BoXjNHm0Gu
	 4lxMseQlNZ1XY0v2MPMsqRpTCfRZ2Ku6S+cJCzdjh/xmyM6Qisw//SXOCgVcpQicY7
	 Z9D0w247GuVQA==
Date: Tue, 31 Dec 2024 15:46:55 -0800
Subject: [PATCH 08/11] xfs_spaceman: wrap radix tree accesses in find_owner.c
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568777993.2709794.5469351937184897707.stgit@frogsfrogsfrogs>
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

From: Darrick J. Wong <djwong@kernel.org>

Wrap the raw radix tree accesses here so that we can provide an
alternate implementation on platforms where radix tree indices cannot
store a full 64-bit inode number.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 spaceman/Makefile     |    1 
 spaceman/find_owner.c |   76 +++++++++------------------------
 spaceman/relocation.c |  114 +++++++++++++++++++++++++++++++++++++++++++++++++
 spaceman/relocation.h |   46 ++++++++++++++++++++
 4 files changed, 183 insertions(+), 54 deletions(-)
 create mode 100644 spaceman/relocation.c
 create mode 100644 spaceman/relocation.h


diff --git a/spaceman/Makefile b/spaceman/Makefile
index b35ab1dbd2f440..8980208285f610 100644
--- a/spaceman/Makefile
+++ b/spaceman/Makefile
@@ -17,6 +17,7 @@ CFILES = \
 	init.c \
 	move_inode.c \
 	prealloc.c \
+	relocation.c \
 	trim.c
 LSRCFILES = xfs_info.sh
 
diff --git a/spaceman/find_owner.c b/spaceman/find_owner.c
index 7a656d80d21217..80b239f9ac5de8 100644
--- a/spaceman/find_owner.c
+++ b/spaceman/find_owner.c
@@ -15,19 +15,13 @@
 #include <linux/fsmap.h>
 #include "space.h"
 #include "input.h"
+#include "relocation.h"
 
 static cmdinfo_t find_owner_cmd;
 static cmdinfo_t resolve_owner_cmd;
 
 #define NR_EXTENTS 128
 
-static RADIX_TREE(inode_tree, 0);
-#define MOVE_INODE	0
-#define MOVE_BLOCKS	1
-#define INODE_PATH	2
-int inode_count;
-int inode_paths;
-
 static void
 track_inode_chunks(
 	struct xfs_fd	*xfd,
@@ -39,7 +33,7 @@ track_inode_chunks(
 	uint64_t	first_ino = cvt_agino_to_ino(xfd, agno,
 						cvt_agbno_to_agino(xfd, agbno));
 	uint64_t	num_inodes = cvt_b_to_inode_count(xfd, length);
-	int		i;
+	uint64_t	i;
 
 	printf(_("AG %d\tInode Range to move: 0x%llx - 0x%llx (length 0x%llx)\n"),
 			agno,
@@ -47,14 +41,8 @@ track_inode_chunks(
 			(unsigned long long)first_ino + num_inodes - 1,
 			(unsigned long long)length);
 
-	for (i = 0; i < num_inodes; i++) {
-		if (!radix_tree_lookup(&inode_tree, first_ino + i)) {
-			radix_tree_insert(&inode_tree, first_ino + i,
-					(void *)first_ino + i);
-			inode_count++;
-		}
-		radix_tree_tag_set(&inode_tree, first_ino + i, MOVE_INODE);
-	}
+	for (i = 0; i < num_inodes; i++)
+		set_reloc_iflag(first_ino + i, MOVE_INODE);
 }
 
 static void
@@ -65,7 +53,7 @@ track_inode(
 	uint64_t	physaddr,
 	uint64_t	length)
 {
-	if (radix_tree_tag_get(&inode_tree, owner, MOVE_BLOCKS))
+	if (test_reloc_iflag(owner, MOVE_BLOCKS))
 		return;
 
 	printf(_("AG %d\tInode 0x%llx: blocks to move to move: 0x%llx - 0x%llx\n"),
@@ -73,11 +61,8 @@ track_inode(
 			(unsigned long long)owner,
 			(unsigned long long)physaddr,
 			(unsigned long long)physaddr + length - 1);
-	if (!radix_tree_lookup(&inode_tree, owner)) {
-		radix_tree_insert(&inode_tree, owner, (void *)owner);
-		inode_count++;
-	}
-	radix_tree_tag_set(&inode_tree, owner, MOVE_BLOCKS);
+
+	set_reloc_iflag(owner, MOVE_BLOCKS);
 }
 
 static void
@@ -111,7 +96,7 @@ scan_ag(
 	h->fmr_offset = ULLONG_MAX;
 
 	while (true) {
-		printf("Inode count %d\n", inode_count);
+		printf("Inode count %llu\n", get_reloc_count());
 		ret = ioctl(xfd->fd, FS_IOC_GETFSMAP, fsmap);
 		if (ret < 0) {
 			fprintf(stderr, _("%s: FS_IOC_GETFSMAP [\"%s\"]: %s\n"),
@@ -245,18 +230,6 @@ find_owner_init(void)
 	add_command(&find_owner_cmd);
 }
 
-/*
- * for each dirent we get returned, look up the inode tree to see if it is an
- * inode we need to process. If it is, then replace the entry in the tree with
- * a structure containing the current path and mark the entry as resolved.
- */
-struct inode_path {
-	uint64_t		ino;
-	struct list_head	path_list;
-	uint32_t		link_count;
-	char			path[1];
-};
-
 static int
 resolve_owner_cb(
 	const char		*path,
@@ -266,14 +239,14 @@ resolve_owner_cb(
 {
 	struct inode_path	*ipath, *slot_ipath;
 	int			pathlen;
-	void			**slot;
+	struct inode_path	**slot;
 
 	/*
 	 * Lookup the slot rather than the entry so we can replace the contents
 	 * without another lookup later on.
 	 */
-	slot = radix_tree_lookup_slot(&inode_tree, stat->st_ino);
-	if (!slot || *slot == NULL)
+	slot = get_reloc_ipath_slot(stat->st_ino);
+	if (!slot)
 		return 0;
 
 	/* Could not get stat data? Fail! */
@@ -303,11 +276,10 @@ _("Aborting: Storing path %s for inode 0x%lx failed: %s\n"),
 	 * set the link count of the path to 1 and replace the slot contents
 	 * with our new_ipath.
 	 */
-	if (stat->st_ino == (uint64_t)*slot) {
+	if (*slot == UNLINKED_IPATH) {
 		ipath->link_count = 1;
 		*slot = ipath;
-		radix_tree_tag_set(&inode_tree, stat->st_ino, INODE_PATH);
-		inode_paths++;
+		set_reloc_iflag(stat->st_ino, INODE_PATH);
 		return 0;
 	}
 
@@ -351,18 +323,15 @@ list_inode_paths(void)
 		bool		move_blocks;
 		bool		move_inode;
 
-		ret = radix_tree_gang_lookup_tag(&inode_tree, (void **)&ipath,
-						idx, 1, INODE_PATH);
-		if (!ret)
+		ipath = get_next_reloc_ipath(idx);
+		if (!ipath)
 			break;
 		idx = ipath->ino + 1;
 
 		/* Grab status tags and remove from tree. */
-		move_blocks = radix_tree_tag_get(&inode_tree, ipath->ino,
-						MOVE_BLOCKS);
-		move_inode = radix_tree_tag_get(&inode_tree, ipath->ino,
-						MOVE_INODE);
-		radix_tree_delete(&inode_tree, ipath->ino);
+		move_blocks = test_reloc_iflag(ipath->ino, MOVE_BLOCKS);
+		move_inode = test_reloc_iflag(ipath->ino, MOVE_INODE);
+		forget_reloc_ino(ipath->ino);
 
 		/* Print the initial path with inode number and state. */
 		printf("0x%.16llx\t%s\t%s\t%8d\t%s\n",
@@ -400,9 +369,8 @@ list_inode_paths(void)
 	do {
 		uint64_t	ino;
 
-
-		ret = radix_tree_gang_lookup(&inode_tree, (void **)&ino, idx, 1);
-		if (!ret) {
+		ino = get_next_reloc_unlinked(idx);
+		if (!ino) {
 			if (idx != 0)
 				ret = -EBUSY;
 			break;
@@ -410,7 +378,7 @@ list_inode_paths(void)
 		idx = ino + 1;
 		printf(_("No path found for inode 0x%llx!\n"),
 				(unsigned long long)ino);
-		radix_tree_delete(&inode_tree, ino);
+		forget_reloc_ino(ino);
 	} while (true);
 
 	return ret;
@@ -426,7 +394,7 @@ resolve_owner_f(
 {
 	int	ret;
 
-	if (!inode_tree.rnode) {
+	if (!is_reloc_populated()) {
 		fprintf(stderr,
 _("Inode list has not been populated. No inodes to resolve.\n"));
 		return 0;
diff --git a/spaceman/relocation.c b/spaceman/relocation.c
new file mode 100644
index 00000000000000..7c7d9a2b4b236f
--- /dev/null
+++ b/spaceman/relocation.c
@@ -0,0 +1,114 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2020 Red Hat, Inc.
+ * All Rights Reserved.
+ */
+
+#include "libxfs.h"
+#include "libfrog/fsgeom.h"
+#include "libfrog/radix-tree.h"
+#include "libfrog/paths.h"
+#include "command.h"
+#include "init.h"
+#include "space.h"
+#include "input.h"
+#include "relocation.h"
+#include "handle.h"
+
+static unsigned long long inode_count;
+static unsigned long long inode_paths;
+
+unsigned long long
+get_reloc_count(void)
+{
+	return inode_count;
+}
+
+static RADIX_TREE(relocation_data, 0);
+
+bool
+is_reloc_populated(void)
+{
+	return relocation_data.rnode != NULL;
+}
+
+bool
+test_reloc_iflag(
+	uint64_t	ino,
+	unsigned int	flag)
+{
+	return radix_tree_tag_get(&relocation_data, ino, flag);
+}
+
+void
+set_reloc_iflag(
+	uint64_t	ino,
+	unsigned int	flag)
+{
+	if (!radix_tree_lookup(&relocation_data, ino)) {
+		radix_tree_insert(&relocation_data, ino, UNLINKED_IPATH);
+		if (flag != INODE_PATH)
+			inode_count++;
+	}
+	if (flag == INODE_PATH)
+		inode_paths++;
+
+	radix_tree_tag_set(&relocation_data, ino, flag);
+}
+
+struct inode_path *
+get_next_reloc_ipath(
+	uint64_t	ino)
+{
+	struct inode_path	*ipath;
+	int			ret;
+
+	ret = radix_tree_gang_lookup_tag(&relocation_data, (void **)&ipath,
+			ino, 1, INODE_PATH);
+	if (!ret)
+		return NULL;
+	return ipath;
+}
+
+uint64_t
+get_next_reloc_unlinked(
+	uint64_t	ino)
+{
+	uint64_t	next_ino;
+	int		ret;
+
+	ret = radix_tree_gang_lookup(&relocation_data, (void **)&next_ino, ino,
+			1);
+	if (!ret)
+		return 0;
+	return next_ino;
+}
+
+/*
+ * Return a pointer to a pointer where the caller can read or write a pointer
+ * to an inode path structure.
+ *
+ * The pointed-to pointer will be set to UNLINKED_IPATH if there is no ipath
+ * associated with this inode but the inode has been flagged for relocation.
+ *
+ * Returns NULL if the inode is not flagged for relocation.
+ */
+struct inode_path **
+get_reloc_ipath_slot(
+	uint64_t		ino)
+{
+	struct inode_path	**slot;
+
+	slot = (struct inode_path **)radix_tree_lookup_slot(&relocation_data,
+			ino);
+	if (!slot || *slot == NULL)
+		return NULL;
+	return slot;
+}
+
+void
+forget_reloc_ino(
+	uint64_t		ino)
+{
+	radix_tree_delete(&relocation_data, ino);
+}
diff --git a/spaceman/relocation.h b/spaceman/relocation.h
new file mode 100644
index 00000000000000..f05a871915da42
--- /dev/null
+++ b/spaceman/relocation.h
@@ -0,0 +1,46 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2020 Red Hat, Inc.
+ * All Rights Reserved.
+ */
+#ifndef XFS_SPACEMAN_RELOCATION_H_
+#define XFS_SPACEMAN_RELOCATION_H_
+
+bool is_reloc_populated(void);
+unsigned long long get_reloc_count(void);
+
+/*
+ * Tags for the relocation_data tree that indicate what it contains and the
+ * discovery information that needed to be stored.
+ */
+#define MOVE_INODE	0
+#define MOVE_BLOCKS	1
+#define INODE_PATH	2
+
+bool test_reloc_iflag(uint64_t ino, unsigned int flag);
+void set_reloc_iflag(uint64_t ino, unsigned int flag);
+struct inode_path *get_next_reloc_ipath(uint64_t ino);
+uint64_t get_next_reloc_unlinked(uint64_t ino);
+struct inode_path **get_reloc_ipath_slot(uint64_t ino);
+void forget_reloc_ino(uint64_t ino);
+
+/*
+ * When the entry in the relocation_data tree is tagged with INODE_PATH, the
+ * entry contains a structure that tracks the discovered paths to the inode. If
+ * the inode has multiple hard links, then we chain each individual path found
+ * via the path_list and record the number of paths in the link_count entry.
+ */
+struct inode_path {
+	uint64_t		ino;
+	struct list_head	path_list;
+	uint32_t		link_count;
+	char			path[1];
+};
+
+/*
+ * Sentinel value for inodes that we have to move but haven't yet found a path
+ * to.
+ */
+#define UNLINKED_IPATH		((struct inode_path *)1)
+
+#endif /* XFS_SPACEMAN_RELOCATION_H_ */

