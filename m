Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0084BC61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:08:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbjBPVIr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:08:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbjBPVIo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:08:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFD0A3B642
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 13:08:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3EBCA60C6D
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 21:08:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2113C4339B;
        Thu, 16 Feb 2023 21:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581718;
        bh=ALM0awXkokXMqNm2UNUZBeDFYcg4oup1/0xW8NIdjRQ=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=ckSZwJlmpLKJqzWt+e/nIkWe1jfDLNlc0yCVGrwUen+YvQJQDxfJKQuUcUFuQUHzF
         jVC5+FBxJWwfm1kDqyZNx8bWT0YJQJA+zAsLdjTeA0adP1ot/j602BZC+q4il9GpgE
         V94aRCONnOFOhh82eedjcTHU8guJqN4qxs+XgHyS1hRmbQXCOx8Z0ck01LWxPuzXTz
         DGJ7K/HYHnYCmPtCSPiKh5z3rIVH7nONLh0SNpzyz/8oYNuklBkLaxXwImtIzhKCbW
         iYeW7TfNChVy6Ok89ArOd2eqlQIO2QDFhC3TL3cRMvyS2tDTGJz1w9ANI1oHFGNQyM
         3IMFXeCS+QwNQ==
Date:   Thu, 16 Feb 2023 13:08:38 -0800
Subject: [PATCH 1/8] xfs_repair: build a parent pointer index
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657881978.3477807.7257312710668307765.stgit@magnolia>
In-Reply-To: <167657881963.3477807.5005383731904631094.stgit@magnolia>
References: <167657881963.3477807.5005383731904631094.stgit@magnolia>
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
 repair/Makefile |    2 
 repair/phase6.c |   55 +++++++++++--
 repair/pptr.c   |  242 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 repair/pptr.h   |   15 +++
 4 files changed, 307 insertions(+), 7 deletions(-)
 create mode 100644 repair/pptr.c
 create mode 100644 repair/pptr.h


diff --git a/repair/Makefile b/repair/Makefile
index 2c40e59a..18731613 100644
--- a/repair/Makefile
+++ b/repair/Makefile
@@ -23,6 +23,7 @@ HFILES = \
 	err_protos.h \
 	globals.h \
 	incore.h \
+	pptr.h \
 	prefetch.h \
 	progress.h \
 	protos.h \
@@ -59,6 +60,7 @@ CFILES = \
 	phase5.c \
 	phase6.c \
 	phase7.c \
+	pptr.c \
 	prefetch.c \
 	progress.c \
 	quotacheck.c \
diff --git a/repair/phase6.c b/repair/phase6.c
index 0d253701..48ec236d 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -18,6 +18,7 @@
 #include "dinode.h"
 #include "progress.h"
 #include "versions.h"
+#include "repair/pptr.h"
 
 static struct cred		zerocr;
 static struct fsxattr 		zerofsx;
@@ -67,6 +68,7 @@ struct dir_hash_ent {
 	struct dir_hash_ent	*nextbyorder;	/* next in order added */
 	xfs_dahash_t		hashval;	/* hash value of name */
 	uint32_t		address;	/* offset of data entry */
+	uint32_t		new_address;	/* new address, if we rebuild */
 	xfs_ino_t		inum;		/* inode num of entry */
 	short			junkit;		/* name starts with / */
 	short			seen;		/* have seen leaf entry */
@@ -224,6 +226,7 @@ dir_hash_add(
 	p->address = addr;
 	p->inum = inum;
 	p->seen = 0;
+	p->new_address = addr;
 
 	/* Set up the name in the region trailing the hash entry. */
 	memcpy(p->namebuf, name, namelen);
@@ -885,6 +888,7 @@ mk_orphanage(xfs_mount_t *mp)
 	int		error;
 	const int	mode = 0755;
 	int		nres;
+	xfs_dir2_dataptr_t	diroffset;
 	struct xfs_name	xname;
 
 	/*
@@ -969,11 +973,13 @@ mk_orphanage(xfs_mount_t *mp)
 	/*
 	 * create the actual entry
 	 */
-	error = -libxfs_dir_createname(tp, pip, &xname, ip->i_ino, nres, NULL);
+	error = -libxfs_dir_createname(tp, pip, &xname, ip->i_ino, nres,
+			&diroffset);
 	if (error)
 		do_error(
 		_("can't make %s, createname error %d\n"),
 			ORPHANAGE, error);
+	add_parent_ptr(ip->i_ino, ORPHANAGE, diroffset, pip);
 
 	/*
 	 * bump up the link count in the root directory to account
@@ -1018,6 +1024,7 @@ mv_orphanage(
 	int			nres;
 	int			incr;
 	ino_tree_node_t		*irec;
+	xfs_dir2_dataptr_t	diroffset;
 	int			ino_offset = 0;
 	struct xfs_name		xname;
 
@@ -1066,7 +1073,7 @@ mv_orphanage(
 			libxfs_trans_ijoin(tp, ino_p, 0);
 
 			err = -libxfs_dir_createname(tp, orphanage_ip, &xname,
-						ino, nres, NULL);
+						ino, nres, &diroffset);
 			if (err)
 				do_error(
 	_("name create failed in %s (%d)\n"), ORPHANAGE, err);
@@ -1100,7 +1107,7 @@ mv_orphanage(
 
 
 			err = -libxfs_dir_createname(tp, orphanage_ip, &xname,
-						ino, nres, NULL);
+						ino, nres, &diroffset);
 			if (err)
 				do_error(
 	_("name create failed in %s (%d)\n"), ORPHANAGE, err);
@@ -1147,7 +1154,7 @@ mv_orphanage(
 		libxfs_trans_ijoin(tp, ino_p, 0);
 
 		err = -libxfs_dir_createname(tp, orphanage_ip, &xname, ino,
-						nres, NULL);
+						nres, &diroffset);
 		if (err)
 			do_error(
 	_("name create failed in %s (%d)\n"), ORPHANAGE, err);
@@ -1160,6 +1167,11 @@ mv_orphanage(
 			do_error(
 	_("orphanage name create failed (%d)\n"), err);
 	}
+
+	if (xfs_has_parent(mp))
+		add_parent_ptr(ino_p->i_ino, xname.name, diroffset,
+				orphanage_ip);
+
 	libxfs_irele(ino_p);
 	libxfs_irele(orphanage_ip);
 }
@@ -1330,7 +1342,7 @@ longform_dir2_rebuild(
 		libxfs_trans_ijoin(tp, ip, 0);
 
 		error = -libxfs_dir_createname(tp, ip, &p->name, p->inum,
-						nres, NULL);
+						nres, &p->new_address);
 		if (error) {
 			do_warn(
 _("name create failed in ino %" PRIu64 " (%d)\n"), ino, error);
@@ -2459,6 +2471,7 @@ shortform_dir2_entry_check(
 	struct xfs_dir2_sf_entry *next_sfep;
 	struct xfs_ifork	*ifp;
 	struct ino_tree_node	*irec;
+	xfs_dir2_dataptr_t	diroffset;
 	int			max_size;
 	int			ino_offset;
 	int			i;
@@ -2637,8 +2650,9 @@ shortform_dir2_entry_check(
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
@@ -2672,6 +2686,7 @@ _("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name"),
 				next_sfep = shortform_dir2_junk(mp, sfp, sfep,
 						lino, &max_size, &i,
 						&bytes_deleted, ino_dirty);
+				dir_hash_junkit(hashtab, diroffset);
 				continue;
 			} else if (parent == ino)  {
 				add_inode_reached(irec, ino_offset);
@@ -2696,6 +2711,7 @@ _("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name"),
 				next_sfep = shortform_dir2_junk(mp, sfp, sfep,
 						lino, &max_size, &i,
 						&bytes_deleted, ino_dirty);
+				dir_hash_junkit(hashtab, diroffset);
 				continue;
 			}
 		}
@@ -2787,6 +2803,26 @@ _("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name"),
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
+		add_parent_ptr(p->inum, p->name.name, p->new_address, dp);
+	}
+}
+
 /*
  * processes all reachable inodes in directories
  */
@@ -2913,6 +2949,7 @@ _("error %d fixing shortform directory %llu\n"),
 		default:
 			break;
 	}
+	dir_hash_add_parent_ptrs(ip, hashtab);
 	dir_hash_done(hashtab);
 
 	/*
@@ -3204,6 +3241,8 @@ phase6(xfs_mount_t *mp)
 	ino_tree_node_t		*irec;
 	int			i;
 
+	parent_ptr_init(mp);
+
 	memset(&zerocr, 0, sizeof(struct cred));
 	memset(&zerofsx, 0, sizeof(struct fsxattr));
 	orphanage_ino = 0;
@@ -3304,4 +3343,6 @@ _("        - resetting contents of realtime bitmap and summary inodes\n"));
 			irec = next_ino_rec(irec);
 		}
 	}
+
+	parent_ptr_free(mp);
 }
diff --git a/repair/pptr.c b/repair/pptr.c
new file mode 100644
index 00000000..b10c7f41
--- /dev/null
+++ b/repair/pptr.c
@@ -0,0 +1,242 @@
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
+ *     (dir_ino, dir_offset, name, child_ino)
+ *
+ * becomes this backwards information:
+ *
+ *     (*child_agino, *dir_ino, dir_gen, *dir_offset, name)
+ *
+ * Key fields are starred.
+ *
+ * This tuple is recorded in the per-AG master parent pointer index.  Note
+ * that names are stored separately in an xfblob data structure so that the
+ * rest of the information can be sorted and processed as fixed-size records.
+ *
+ * Once we've finished with the forward scan, we get to work on the backwards
+ * scan.  Each AG is processed independently.  First, we sort the per-AG master
+ * records in order of child_agino, dir_ino, and dir_offset.  Each inode in the
+ * AG is then processed in numerical order.
+ *
+ * The first thing that happens to the file is that we read all the extended
+ * attributes to look for parent pointers.  Attributes that claim to be parent
+ * pointers but are obviously garbage are thrown away.  The rest of the parent
+ * pointers for that file are recorded in memory like this:
+ *
+ *     (*dir_ino, dir_gen, *dir_offset, name)
+ *
+ * When we've concluded the xattr scan, these records are sorted in order of
+ * dir_ino and dir_offset.  The master index cursor should point at the first
+ * record for the file that we're scanning, if everything is consistent.
+ *
+ * If not, there are two possibilities:
+ *
+ * A. The master index cursor points to a higher inode number than the one we
+ * are scanning.  The file has apparently lost all parents, so all parent
+ * pointers (if any) must be deleted.  This should only happen to metadata
+ * inodes.
+ *
+ * B. The cursor instead points to a lower inode number than the one we are
+ * scanning.  This means that there exists a directory entry pointing at an
+ * inode that is free.  We supposedly already settled which inodes are free
+ * and which aren't, which means in-memory information is inconsistent.  Abort.
+ *
+ * Otherwise, we are ready to check the file parent pointers against the
+ * master.  If the ondisk directory metadata are all consistent, this recordset
+ * should correspond exactly to the subset of the master records with a
+ * child_agino matching the file that we're scanning.  We should be able to
+ * walk both sets in lockstep, and find one of the following outcomes:
+ *
+ * 1) The master index cursor is ahead of the ondisk index cursor.  This means
+ * that the inode has parent pointers that were not found during the dirent
+ * scan.  These should be deleted.
+ *
+ * 2) The ondisk index gets ahead of the master index.  This means that the
+ * dirent scan found parent pointers that are not attached to the inode.
+ * These should be added.
+ *
+ * 3) The parent_gen or (dirent) name are not consistent.  Update the parent
+ * pointer to the values that we found during the dirent scan.
+ *
+ * 4) Everything matches.  Move on to the next parent pointer.
+ *
+ * The current implementation does not try to rebuild directories from parent
+ * pointer information, as this requires a lengthy scan of the filesystem for
+ * each broken directory.
+ */
+
+struct ag_pptr {
+	/* parent directory handle */
+	xfs_ino_t		parent_ino;
+	unsigned int		parent_gen;
+
+	/* dirent offset */
+	xfs_dir2_dataptr_t	diroffset;
+
+	/* dirent name length */
+	unsigned int		namelen;
+
+	/* cookie for the actual dirent name */
+	xfblob_cookie		name_cookie;
+
+	/* agino of the child file */
+	xfs_agino_t		child_agino;
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
+/* Remember that @dp has a dirent (@fname, @ino) at @diroffset. */
+void
+add_parent_ptr(
+	xfs_ino_t		ino,
+	const unsigned char	*fname,
+	xfs_dir2_dataptr_t	diroffset,
+	struct xfs_inode	*dp)
+{
+	struct xfs_mount	*mp = dp->i_mount;
+	struct ag_pptr		ag_pptr = {
+		.child_agino	= XFS_INO_TO_AGINO(mp, ino),
+		.parent_ino	= dp->i_ino,
+		.parent_gen	= VFS_I(dp)->i_generation,
+		.diroffset	= diroffset,
+		.namelen	= strlen(fname),
+	};
+	struct ag_pptrs		*ag_pptrs;
+	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ino);
+	int			error;
+
+	if (!xfs_has_parent(mp))
+		return;
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
+ _("%s: dp %llu fname '%s' diroffset %u ino %llu cookie 0x%llx\n"),
+			__func__, (unsigned long long)dp->i_ino, fname,
+			diroffset, (unsigned long long)ino,
+			(unsigned long long)ag_pptr.name_cookie);
+}
diff --git a/repair/pptr.h b/repair/pptr.h
new file mode 100644
index 00000000..2c632ec9
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
+		xfs_dir2_dataptr_t diroffset, struct xfs_inode *dp);
+
+#endif /* __REPAIR_PPTR_H__ */

