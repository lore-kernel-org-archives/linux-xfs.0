Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB2BC127
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a4oRe8k3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E84C433C8;
	Sun, 31 Dec 2023 23:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704064563;
	bh=/nxHHb9TNG7b5hvNeCSCDBB/eiVojswgdb8kqQXU2pw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=a4oRe8k3xFPFkOzHkhyjbj9lBIR/ndQ2yuM8upwQMavyMZ2XIH8FJlwHVLtaoxFjL
	 pH9gKqJRrb5CL79A27dJdV3/OihESTzAOcgqhpuPOPie5Q8xAkgtp26F9XAZKQL40s
	 8iGZS0QPOOd8W1NeER2JLIIRZzsjh533/qUrTdM3QNKhLTwZjchZUEmT2qJMdyhVyQ
	 0ttNvXqy6dDBkJyDa9hw5JKa0Pm7muTEPtJiNNHjBdQeJlr4geYf7RsmlSoxK/ieaF
	 erzBDuzMxpGlD7jcEcpHhVsgQtqZSzQhaYnbBUL/cG7cmEcR69azz/JMi6cp1yE6ji
	 rHJXYlSx7iYFg==
Date: Sun, 31 Dec 2023 15:16:03 -0800
Subject: [PATCH 10/18] xfs_repair: build a parent pointer index
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com
Message-ID: <170405006995.1805510.17464081923283887210.stgit@frogsfrogsfrogs>
In-Reply-To: <170405006850.1805510.11145262768706358018.stgit@frogsfrogsfrogs>
References: <170405006850.1805510.11145262768706358018.stgit@frogsfrogsfrogs>
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

When we're walking directories during phase 6, build an index of parent
pointers that we expect to find.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/Makefile |    2 +
 repair/phase6.c |   43 +++++++++++-
 repair/pptr.c   |  204 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 repair/pptr.h   |   15 ++++
 4 files changed, 262 insertions(+), 2 deletions(-)
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
index 2bdddafe213..e1cd1984986 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -18,6 +18,7 @@
 #include "dinode.h"
 #include "progress.h"
 #include "versions.h"
+#include "repair/pptr.h"
 
 static struct cred		zerocr;
 static struct fsxattr 		zerofsx;
@@ -996,6 +997,7 @@ mk_orphanage(xfs_mount_t *mp)
 		do_error(
 		_("can't make %s, createname error %d\n"),
 			ORPHANAGE, error);
+	add_parent_ptr(ip->i_ino, ORPHANAGE, pip);
 
 	error = -libxfs_parent_add(tp, ppargs, pip, &xname, ip);
 	if (error)
@@ -1248,6 +1250,10 @@ mv_orphanage(
 			do_error(
 	_("orphanage name create failed (%d)\n"), err);
 	}
+
+	if (xfs_has_parent(mp))
+		add_parent_ptr(ino_p->i_ino, xname.name, orphanage_ip);
+
 	libxfs_irele(ino_p);
 	libxfs_irele(orphanage_ip);
 	libxfs_parent_finish(mp, ppargs);
@@ -2549,6 +2555,7 @@ shortform_dir2_entry_check(
 	struct xfs_dir2_sf_entry *next_sfep;
 	struct xfs_ifork	*ifp;
 	struct ino_tree_node	*irec;
+	xfs_dir2_dataptr_t	diroffset;
 	int			max_size;
 	int			ino_offset;
 	int			i;
@@ -2727,8 +2734,9 @@ shortform_dir2_entry_check(
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
@@ -2762,6 +2770,7 @@ _("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name, "),
 				next_sfep = shortform_dir2_junk(mp, sfp, sfep,
 						lino, &max_size, &i,
 						&bytes_deleted, ino_dirty);
+				dir_hash_junkit(hashtab, diroffset);
 				continue;
 			} else if (parent == ino)  {
 				add_inode_reached(irec, ino_offset);
@@ -2786,6 +2795,7 @@ _("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name, "),
 				next_sfep = shortform_dir2_junk(mp, sfp, sfep,
 						lino, &max_size, &i,
 						&bytes_deleted, ino_dirty);
+				dir_hash_junkit(hashtab, diroffset);
 				continue;
 			}
 		}
@@ -2877,6 +2887,30 @@ _("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name, "),
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
+		if (p->junkit)
+			continue;
+		if (p->name.name[0] == '/')
+			continue;
+		if (p->name.name[0] == '.' &&
+		    (p->name.len == 1 ||
+		     (p->name.len == 2 && p->name.name[1] == '.')))
+			continue;
+
+		add_parent_ptr(p->inum, p->name.name, dp);
+	}
+}
+
 /*
  * processes all reachable inodes in directories
  */
@@ -3003,6 +3037,7 @@ _("error %d fixing shortform directory %llu\n"),
 		default:
 			break;
 	}
+	dir_hash_add_parent_ptrs(ip, hashtab);
 	dir_hash_done(hashtab);
 
 	/*
@@ -3294,6 +3329,8 @@ phase6(xfs_mount_t *mp)
 	ino_tree_node_t		*irec;
 	int			i;
 
+	parent_ptr_init(mp);
+
 	memset(&zerocr, 0, sizeof(struct cred));
 	memset(&zerofsx, 0, sizeof(struct fsxattr));
 	orphanage_ino = 0;
@@ -3394,4 +3431,6 @@ _("        - resetting contents of realtime bitmap and summary inodes\n"));
 			irec = next_ino_rec(irec);
 		}
 	}
+
+	parent_ptr_free(mp);
 }
diff --git a/repair/pptr.c b/repair/pptr.c
new file mode 100644
index 00000000000..68cdd0ae424
--- /dev/null
+++ b/repair/pptr.c
@@ -0,0 +1,204 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2023-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "libxfs.h"
+#include "libxfs/xfile.h"
+#include "libxfs/xfblob.h"
+#include "libfrog/platform.h"
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
+	char			*descr;
+	xfs_agnumber_t		agno;
+	int			error;
+
+	if (!xfs_has_parent(mp))
+		return;
+
+	descr = kasprintf("xfs_repair (%s): parent pointer names",
+			mp->m_fsname);
+	error = -xfblob_create(descr, &names);
+	kfree(descr);
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
index 00000000000..ef85807b117
--- /dev/null
+++ b/repair/pptr.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2023-2024 Oracle.  All Rights Reserved.
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

