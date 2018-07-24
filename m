Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:52804 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388367AbeGXDy1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Jul 2018 23:54:27 -0400
Subject: [PATCH 2/2 V3] xfs_repair: clear_dinode should simply clear, not
 check contents
References: <b6f745ab-3016-9a95-3085-8584f7200b64@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <6d3277e7-610e-4777-7563-7026b21e8ac6@sandeen.net>
Date: Mon, 23 Jul 2018 19:50:13 -0700
MIME-Version: 1.0
In-Reply-To: <b6f745ab-3016-9a95-3085-8584f7200b64@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

Today clear_inode performs 2 separate tasks - it clears a disk inode
when the calling code detects an inconsistency, and it also validates
free inodes to some extent by checking each field before zeroing it
out.  This leads to unnecessary checks in the former case where we
just want to zap the inode, and duplicates some of the existing
verifier checks in the latter case.
    
Now that we're using xfs_dinode_verify to validate free inodes,
there's no reason to repeat all the checks inside clear_inode_core.
Drop them all and simply clear it when told to do so.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/repair/dinode.c b/repair/dinode.c
index c0db15a..5b9fd9a 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -117,137 +117,24 @@ _("would have cleared inode %" PRIu64 " attributes\n"), ino_num);
 	return(1);
 }
 
-static int
+static void
 clear_dinode_core(struct xfs_mount *mp, xfs_dinode_t *dinoc, xfs_ino_t ino_num)
 {
-	int dirty = 0;
-	int i;
-
-#define __dirty_no_modify_ret(dirty) \
-	({ (dirty) = 1; if (no_modify) return 1; })
-
-	if (be16_to_cpu(dinoc->di_magic) != XFS_DINODE_MAGIC)  {
-		__dirty_no_modify_ret(dirty);
-		dinoc->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
-	}
-
-	if (!libxfs_dinode_good_version(mp, dinoc->di_version)) {
-		__dirty_no_modify_ret(dirty);
-		if (xfs_sb_version_hascrc(&mp->m_sb))
-			dinoc->di_version = 3;
-		else
-			dinoc->di_version = 2;
-	}
-
-	if (be16_to_cpu(dinoc->di_mode) != 0)  {
-		__dirty_no_modify_ret(dirty);
-		dinoc->di_mode = 0;
-	}
-
-	if (be16_to_cpu(dinoc->di_flags) != 0)  {
-		__dirty_no_modify_ret(dirty);
-		dinoc->di_flags = 0;
-	}
-
-	if (be32_to_cpu(dinoc->di_dmevmask) != 0)  {
-		__dirty_no_modify_ret(dirty);
-		dinoc->di_dmevmask = 0;
-	}
-
-	if (dinoc->di_forkoff != 0)  {
-		__dirty_no_modify_ret(dirty);
-		dinoc->di_forkoff = 0;
-	}
-
-	if (dinoc->di_format != XFS_DINODE_FMT_EXTENTS)  {
-		__dirty_no_modify_ret(dirty);
-		dinoc->di_format = XFS_DINODE_FMT_EXTENTS;
-	}
-
-	if (dinoc->di_aformat != XFS_DINODE_FMT_EXTENTS)  {
-		__dirty_no_modify_ret(dirty);
-		dinoc->di_aformat = XFS_DINODE_FMT_EXTENTS;
-	}
-
-	if (be64_to_cpu(dinoc->di_size) != 0)  {
-		__dirty_no_modify_ret(dirty);
-		dinoc->di_size = 0;
-	}
-
-	if (be64_to_cpu(dinoc->di_nblocks) != 0)  {
-		__dirty_no_modify_ret(dirty);
-		dinoc->di_nblocks = 0;
-	}
-
-	if (be16_to_cpu(dinoc->di_onlink) != 0)  {
-		__dirty_no_modify_ret(dirty);
-		dinoc->di_onlink = 0;
-	}
-
-	if (be32_to_cpu(dinoc->di_nextents) != 0)  {
-		__dirty_no_modify_ret(dirty);
-		dinoc->di_nextents = 0;
-	}
-
-	if (be16_to_cpu(dinoc->di_anextents) != 0)  {
-		__dirty_no_modify_ret(dirty);
-		dinoc->di_anextents = 0;
-	}
-
-	if (be32_to_cpu(dinoc->di_extsize) != 0)  {
-		__dirty_no_modify_ret(dirty);
-		dinoc->di_extsize = 0;
-	}
-
-	if (dinoc->di_version > 1 &&
-			be32_to_cpu(dinoc->di_nlink) != 0)  {
-		__dirty_no_modify_ret(dirty);
-		dinoc->di_nlink = 0;
-	}
-
+	memset(dinoc, 0, sizeof(*dinoc));
+	dinoc->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		dinoc->di_version = 3;
+	else
+		dinoc->di_version = 2;
+	dinoc->di_gen = cpu_to_be32(random());
+	dinoc->di_format = XFS_DINODE_FMT_EXTENTS;
+	dinoc->di_aformat = XFS_DINODE_FMT_EXTENTS;
 	/* we are done for version 1/2 inodes */
 	if (dinoc->di_version < 3)
-		return dirty;
-
-	if (be64_to_cpu(dinoc->di_ino) != ino_num) {
-		__dirty_no_modify_ret(dirty);
-		dinoc->di_ino = cpu_to_be64(ino_num);
-	}
-
-	if (platform_uuid_compare(&dinoc->di_uuid, &mp->m_sb.sb_meta_uuid)) {
-		__dirty_no_modify_ret(dirty);
-		platform_uuid_copy(&dinoc->di_uuid, &mp->m_sb.sb_meta_uuid);
-	}
-
-	for (i = 0; i < sizeof(dinoc->di_pad2)/sizeof(dinoc->di_pad2[0]); i++) {
-		if (dinoc->di_pad2[i] != 0) {
-			__dirty_no_modify_ret(dirty);
-			memset(dinoc->di_pad2, 0, sizeof(dinoc->di_pad2));
-			break;
-		}
-	}
-
-	if (be64_to_cpu(dinoc->di_flags2) != 0)  {
-		__dirty_no_modify_ret(dirty);
-		dinoc->di_flags2 = 0;
-	}
-
-	if (be64_to_cpu(dinoc->di_lsn) != 0)  {
-		__dirty_no_modify_ret(dirty);
-		dinoc->di_lsn = 0;
-	}
-
-	if (be64_to_cpu(dinoc->di_changecount) != 0)  {
-		__dirty_no_modify_ret(dirty);
-		dinoc->di_changecount = 0;
-	}
-
-	if (be32_to_cpu(dinoc->di_cowextsize) != 0)  {
-		__dirty_no_modify_ret(dirty);
-		dinoc->di_cowextsize = 0;
-	}
-
-	return dirty;
+		return;
+	dinoc->di_ino = cpu_to_be64(ino_num);
+	platform_uuid_copy(&dinoc->di_uuid, &mp->m_sb.sb_meta_uuid);
+	return;
 }
 
 static int
@@ -268,21 +155,15 @@ clear_dinode_unlinked(xfs_mount_t *mp, xfs_dinode_t *dino)
  * until after the agi unlinked lists are walked in phase 3.
  * returns > zero if the inode has been altered while being cleared
  */
-static int
+static void
 clear_dinode(xfs_mount_t *mp, xfs_dinode_t *dino, xfs_ino_t ino_num)
 {
-	int dirty;
-
-	dirty = clear_dinode_core(mp, dino, ino_num);
-	dirty += clear_dinode_unlinked(mp, dino);
+	clear_dinode_core(mp, dino, ino_num);
+	clear_dinode_unlinked(mp, dino);
 
 	/* and clear the forks */
-
-	if (dirty && !no_modify)
-		memset(XFS_DFORK_DPTR(dino), 0,
-		       XFS_LITINO(mp, dino->di_version));
-
-	return(dirty);
+	memset(XFS_DFORK_DPTR(dino), 0, XFS_LITINO(mp, dino->di_version));
+	return;
 }
 
 
@@ -2140,8 +2021,8 @@ process_inode_data_fork(
 	if (err)  {
 		do_warn(_("bad data fork in inode %" PRIu64 "\n"), lino);
 		if (!no_modify)  {
-			*dirty += clear_dinode(mp, dino, lino);
-			ASSERT(*dirty > 0);
+			clear_dinode(mp, dino, lino);
+			*dirty += 1;
 		}
 		return 1;
 	}
@@ -2551,7 +2432,7 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 	}
 
 	/*
-	 * if not in verify mode, check to sii if the inode and imap
+	 * if not in verify mode, check to see if the inode and imap
 	 * agree that the inode is free
 	 */
 	if (!verify_mode && di_mode == 0) {
@@ -2568,8 +2449,9 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 				do_warn(
  _("free inode %" PRIu64 " contains errors, "), lino);
 				if (!no_modify) {
-					*dirty += clear_dinode(mp, dino, lino);
+					clear_dinode(mp, dino, lino);
 					do_warn(_("corrected\n"));
+					*dirty += 1;
 				} else {
 					do_warn(_("would correct\n"));
 				}
@@ -2586,7 +2468,8 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 	_("imap claims a free inode %" PRIu64 " is in use, "), lino);
 		if (!no_modify)  {
 			do_warn(_("correcting imap and clearing inode\n"));
-			*dirty += clear_dinode(mp, dino, lino);
+			clear_dinode(mp, dino, lino);
+			*dirty += 1;
 			retval = 1;
 		} else
 			do_warn(_("would correct imap and clear inode\n"));
@@ -2804,8 +2687,10 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 	 * we're going to find.  check_dups is set to 1 only during
 	 * phase 4.  Ugly.
 	 */
-	if (check_dups && !no_modify)
-		*dirty += clear_dinode_unlinked(mp, dino);
+	if (check_dups && !no_modify) {
+		clear_dinode_unlinked(mp, dino);
+		*dirty += 1;
+	}
 
 	/* set type and map type info */
 
@@ -3024,8 +2909,8 @@ _("Cannot have CoW extent size of zero on cowextsize inode %" PRIu64 ", "),
 
 clear_bad_out:
 	if (!no_modify)  {
-		*dirty += clear_dinode(mp, dino, lino);
-		ASSERT(*dirty > 0);
+		clear_dinode(mp, dino, lino);
+		*dirty += 1;
 	}
 bad_out:
 	*used = is_free;

