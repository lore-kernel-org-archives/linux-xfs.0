Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17F89C77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:31:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbjEZCbb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbjEZCba (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:31:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AA2DB6
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:31:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA0C36157B
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:31:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37BB2C433EF;
        Fri, 26 May 2023 02:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685068288;
        bh=Ei/pWAGU1xatbB+H3QC8bx+dM1FJEHRRyMYTIp20gc0=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=qetbThSwlhVNG5TgE9weJmwDLzum2Dz7YX29/EY4GLuJkm2OTzPdXVejyiJTKMFmE
         CECsY474s4E4J1rH7WNrQqwyffYwTrSQEGOrzIrw1QTjB+6EpT7RsOpkc0KE8o43ks
         TPDT8QbVMEHNR9QwKEcFoeVx2mfthR+/WVPFdGZb307zd5SkGkqfyy/Bd1JLwcGwUH
         4aIswft6R8FvF27BPUFaqaa6cI2pU0NGSyHLKwwJGI+CuOp2q54Ji3Kx+IpXixwPxc
         BKI80sPPf+QrL/ZDrif85UgQ9NW7ky3RsZzBcBo8T6EWswSgCRma6MeZ3wgFoyZoHD
         xORGzN9wSva0A==
Date:   Thu, 25 May 2023 19:31:27 -0700
Subject: [PATCH 07/14] xfs_repair: build a parent pointer index
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506078691.3750196.17559352007149378002.stgit@frogsfrogsfrogs>
In-Reply-To: <168506078591.3750196.1821601831633863822.stgit@frogsfrogsfrogs>
References: <168506078591.3750196.1821601831633863822.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When we're walking directories during phase 6, build an index of parent
pointers that we expect to find.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/Makefile |    2 +
 repair/phase6.c |   39 ++++++++++-
 repair/pptr.c   |  199 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 repair/pptr.h   |   15 ++++
 4 files changed, 253 insertions(+), 2 deletions(-)
 create mode 100644 repair/pptr.c
 create mode 100644 repair/pptr.h


diff --git a/repair/Makefile b/repair/Makefile
index 250c86cca2d..a5102015651 100644
--- a/repair/Makefile
+++ b/repair/Makefile
@@ -24,6 +24,7 @@ HFILES = \
 	err_protos.h \
 	globals.h \
 	incore.h \
+	pptr.h \
 	prefetch.h \
 	progress.h \
 	protos.h \
@@ -63,6 +64,7 @@ CFILES = \
 	phase5.c \
 	phase6.c \
 	phase7.c \
+	pptr.c \
 	prefetch.c \
 	progress.c \
 	quotacheck.c \
diff --git a/repair/phase6.c b/repair/phase6.c
index 3e2436130f4..a50d93a3cb0 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -18,6 +18,7 @@
 #include "dinode.h"
 #include "progress.h"
 #include "versions.h"
+#include "repair/pptr.h"
 
 static struct cred		zerocr;
 static struct fsxattr 		zerofsx;
@@ -980,6 +981,7 @@ mk_orphanage(xfs_mount_t *mp)
 		do_error(
 		_("can't make %s, createname error %d\n"),
 			ORPHANAGE, error);
+	add_parent_ptr(ip->i_ino, ORPHANAGE, pip);
 
 	if (parent) {
 		error = -libxfs_parent_add(tp, parent, pip, &xname, ip);
@@ -1234,6 +1236,10 @@ mv_orphanage(
 			do_error(
 	_("orphanage name create failed (%d)\n"), err);
 	}
+
+	if (xfs_has_parent(mp))
+		add_parent_ptr(ino_p->i_ino, xname.name, orphanage_ip);
+
 	libxfs_irele(ino_p);
 	libxfs_irele(orphanage_ip);
 	libxfs_parent_finish(mp, parent);
@@ -2535,6 +2541,7 @@ shortform_dir2_entry_check(
 	struct xfs_dir2_sf_entry *next_sfep;
 	struct xfs_ifork	*ifp;
 	struct ino_tree_node	*irec;
+	xfs_dir2_dataptr_t	diroffset;
 	int			max_size;
 	int			ino_offset;
 	int			i;
@@ -2713,8 +2720,9 @@ shortform_dir2_entry_check(
 		/*
 		 * check for duplicate names in directory.
 		 */
-		if (!dir_hash_add(mp, hashtab, (xfs_dir2_dataptr_t)
-				(sfep - xfs_dir2_sf_firstentry(sfp)),
+		diroffset = xfs_dir2_byte_to_dataptr(
+				xfs_dir2_sf_get_offset(sfep));
+		if (!dir_hash_add(mp, hashtab, diroffset,
 				lino, sfep->namelen, sfep->name,
 				libxfs_dir2_sf_get_ftype(mp, sfep))) {
 			do_warn(
@@ -2748,6 +2756,7 @@ _("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name, "),
 				next_sfep = shortform_dir2_junk(mp, sfp, sfep,
 						lino, &max_size, &i,
 						&bytes_deleted, ino_dirty);
+				dir_hash_junkit(hashtab, diroffset);
 				continue;
 			} else if (parent == ino)  {
 				add_inode_reached(irec, ino_offset);
@@ -2772,6 +2781,7 @@ _("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name, "),
 				next_sfep = shortform_dir2_junk(mp, sfp, sfep,
 						lino, &max_size, &i,
 						&bytes_deleted, ino_dirty);
+				dir_hash_junkit(hashtab, diroffset);
 				continue;
 			}
 		}
@@ -2863,6 +2873,26 @@ _("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name, "),
 	}
 }
 
+static void
+dir_hash_add_parent_ptrs(
+	struct xfs_inode	*dp,
+	struct dir_hash_tab	*hashtab)
+{
+	struct dir_hash_ent	*p;
+
+	if (!xfs_has_parent(dp->i_mount))
+		return;
+
+	for (p = hashtab->first; p; p = p->nextbyorder) {
+		if (p->name.name[0] == '/' || (p->name.name[0] == '.' &&
+				(p->name.len == 1 || (p->name.len == 2 &&
+						p->name.name[1] == '.'))))
+			continue;
+
+		add_parent_ptr(p->inum, p->name.name, dp);
+	}
+}
+
 /*
  * processes all reachable inodes in directories
  */
@@ -2989,6 +3019,7 @@ _("error %d fixing shortform directory %llu\n"),
 		default:
 			break;
 	}
+	dir_hash_add_parent_ptrs(ip, hashtab);
 	dir_hash_done(hashtab);
 
 	/*
@@ -3280,6 +3311,8 @@ phase6(xfs_mount_t *mp)
 	ino_tree_node_t		*irec;
 	int			i;
 
+	parent_ptr_init(mp);
+
 	memset(&zerocr, 0, sizeof(struct cred));
 	memset(&zerofsx, 0, sizeof(struct fsxattr));
 	orphanage_ino = 0;
@@ -3380,4 +3413,6 @@ _("        - resetting contents of realtime bitmap and summary inodes\n"));
 			irec = next_ino_rec(irec);
 		}
 	}
+
+	parent_ptr_free(mp);
 }
diff --git a/repair/pptr.c b/repair/pptr.c
new file mode 100644
index 00000000000..847e4885aba
--- /dev/null
+++ b/repair/pptr.c
@@ -0,0 +1,199 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2023 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "libxfs.h"
+#include "libxfs/xfile.h"
+#include "libxfs/xfblob.h"
+#include "repair/err_protos.h"
+#include "repair/slab.h"
+#include "repair/pptr.h"
+
+#undef PPTR_DEBUG
+
+#ifdef PPTR_DEBUG
+# define dbg_printf(f, a...)  do {printf(f, ## a); fflush(stdout); } while (0)
+#else
+# define dbg_printf(f, a...)
+#endif
+
+/*
+ * Parent Pointer Validation
+ * =========================
+ *
+ * Phase 6 validates the connectivity of the directory tree after validating
+ * that all the space metadata are correct, and confirming all the inodes that
+ * we intend to keep.  The first part of phase 6 walks the directories of the
+ * filesystem to ensure that every file that isn't the root directory has a
+ * parent.  Unconnected files are attached to the orphanage.  Filesystems with
+ * the directory parent pointer feature enabled must also ensure that for every
+ * directory entry that points to a child file, that child has a matching
+ * parent pointer.
+ *
+ * There are many ways that we could check the parent pointers, but the means
+ * that we have chosen is to build a per-AG master index of all parent pointers
+ * of all inodes stored in that AG, and use that as the basis for comparison.
+ * This consumes a lot of memory, but performing both a forward scan to check
+ * dirent -> parent pointer and a backwards scan of parent pointer -> dirent
+ * takes longer than the simple method presented here.  Userspace adds the
+ * additional twist that inodes are not cached (and there are no ILOCKs), which
+ * makes that approach even less attractive.
+ *
+ * During the directory walk at the start of phase 6, we transform each child
+ * directory entry found into its parent pointer equivalent.  In other words,
+ * the forward information:
+ *
+ *     (dir_ino, name, child_ino)
+ *
+ * becomes this backwards information:
+ *
+ *     (child_agino*, dir_ino*, dir_gen, name*)
+ *
+ * Key fields are starred.
+ *
+ * This tuple is recorded in the per-AG master parent pointer index.  Note
+ * that names are stored separately in an xfblob data structure so that the
+ * rest of the information can be sorted and processed as fixed-size records;
+ * the incore parent pointer record contains a pointer to the xfblob data.
+ */
+
+struct ag_pptr {
+	/* parent directory handle */
+	xfs_ino_t		parent_ino;
+	unsigned int		parent_gen;
+
+	/* dirent name length */
+	unsigned int		namelen;
+
+	/* cookie for the actual dirent name */
+	xfblob_cookie		name_cookie;
+
+	/* agino of the child file */
+	xfs_agino_t		child_agino;
+
+	/* hash of the dirent name */
+	xfs_dahash_t		namehash;
+};
+
+struct ag_pptrs {
+	/* Lock to protect pptr_recs during the dirent scan. */
+	pthread_mutex_t		lock;
+
+	/* Parent pointer records for files in this AG. */
+	struct xfs_slab		*pptr_recs;
+};
+
+/* Global names storage file. */
+static struct xfblob	*names;
+static pthread_mutex_t	names_mutex = PTHREAD_MUTEX_INITIALIZER;
+static struct ag_pptrs	*fs_pptrs;
+
+void
+parent_ptr_free(
+	struct xfs_mount	*mp)
+{
+	xfs_agnumber_t		agno;
+
+	if (!xfs_has_parent(mp))
+		return;
+
+	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
+		free_slab(&fs_pptrs[agno].pptr_recs);
+		pthread_mutex_destroy(&fs_pptrs[agno].lock);
+	}
+	free(fs_pptrs);
+	fs_pptrs = NULL;
+
+	xfblob_destroy(names);
+}
+
+void
+parent_ptr_init(
+	struct xfs_mount	*mp)
+{
+	xfs_agnumber_t		agno;
+	int			error;
+
+	if (!xfs_has_parent(mp))
+		return;
+
+	error = -xfblob_create(mp, "parent pointer names", &names);
+	if (error)
+		do_error(_("init parent pointer names failed: %s\n"),
+				strerror(error));
+
+	fs_pptrs = calloc(mp->m_sb.sb_agcount, sizeof(struct ag_pptrs));
+	if (!fs_pptrs)
+		do_error(
+ _("init parent pointer per-AG record array failed: %s\n"),
+				strerror(errno));
+
+	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
+		error = pthread_mutex_init(&fs_pptrs[agno].lock, NULL);
+		if (error)
+			do_error(
+ _("init agno %u parent pointer lock failed: %s\n"),
+					agno, strerror(error));
+
+		error = -init_slab(&fs_pptrs[agno].pptr_recs,
+				sizeof(struct ag_pptr));
+		if (error)
+			do_error(
+ _("init agno %u parent pointer recs failed: %s\n"),
+					agno, strerror(error));
+	}
+}
+
+/* Remember that @dp has a dirent (@fname, @ino). */
+void
+add_parent_ptr(
+	xfs_ino_t		ino,
+	const unsigned char	*fname,
+	struct xfs_inode	*dp)
+{
+	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_name		dname = {
+		.name		= fname,
+		.len		= strlen(fname),
+	};
+	struct ag_pptr		ag_pptr = {
+		.child_agino	= XFS_INO_TO_AGINO(mp, ino),
+		.parent_ino	= dp->i_ino,
+		.parent_gen	= VFS_I(dp)->i_generation,
+		.namelen	= dname.len,
+	};
+	struct ag_pptrs		*ag_pptrs;
+	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ino);
+	int			error;
+
+	if (!xfs_has_parent(mp))
+		return;
+
+	ag_pptr.namehash = libxfs_dir2_hashname(mp, &dname);
+
+	pthread_mutex_lock(&names_mutex);
+	error = -xfblob_store(names, &ag_pptr.name_cookie, fname,
+			ag_pptr.namelen);
+	pthread_mutex_unlock(&names_mutex);
+	if (error)
+		do_error(_("storing name '%s' failed: %s\n"),
+				fname, strerror(error));
+
+	ag_pptrs = &fs_pptrs[agno];
+	pthread_mutex_lock(&ag_pptrs->lock);
+	error = -slab_add(ag_pptrs->pptr_recs, &ag_pptr);
+	pthread_mutex_unlock(&ag_pptrs->lock);
+	if (error)
+		do_error(_("storing name '%s' key failed: %s\n"),
+				fname, strerror(error));
+
+	dbg_printf(
+ _("%s: dp %llu gen 0x%x fname '%s' ino %llu namecookie 0x%llx\n"),
+			__func__,
+			(unsigned long long)dp->i_ino,
+			VFS_I(dp)->i_generation,
+			fname,
+			(unsigned long long)ino,
+			(unsigned long long)ag_pptr.name_cookie);
+}
diff --git a/repair/pptr.h b/repair/pptr.h
new file mode 100644
index 00000000000..0ca2e1c6ffc
--- /dev/null
+++ b/repair/pptr.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (C) 2023 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __REPAIR_PPTR_H__
+#define __REPAIR_PPTR_H__
+
+void parent_ptr_free(struct xfs_mount *mp);
+void parent_ptr_init(struct xfs_mount *mp);
+
+void add_parent_ptr(xfs_ino_t ino, const unsigned char *fname,
+		struct xfs_inode *dp);
+
+#endif /* __REPAIR_PPTR_H__ */

