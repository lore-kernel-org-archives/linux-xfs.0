Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:50808 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753836AbeE3PvG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 30 May 2018 11:51:06 -0400
Subject: [PATCH 1/2] xfs_repair: clear_dinode should only clear, not check
 contents
References: <4f70c5e0-8093-38b3-256d-ee16460aa4ad@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <28617198-68ef-5f75-8462-ca24b66a5b3b@sandeen.net>
Date: Wed, 30 May 2018 10:51:05 -0500
MIME-Version: 1.0
In-Reply-To: <4f70c5e0-8093-38b3-256d-ee16460aa4ad@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

clear_dinode is a strange thing; it's called primarily when other code
detects errors and wishes to clear the inode, but it also re-checks each
piece of the inode before clearing it.  For one, this means that all the
checks that call it need to be re-performed in the clearing function, or
it may do nothing at all.

It's also used to check and clear free inodes; for that purpose going
forward we'll need to first validate a free inode, and then clear_dinode
if it fails validation.

With this commit we unconditionally clear & dirty all free inodes, but
the next commit remedies this and clears only corrupt free inodes.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/repair/dinode.c b/repair/dinode.c
index 49d5d05..92130db 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -117,127 +117,27 @@ _("would have cleared inode %" PRIu64 " attributes\n"), ino_num);
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
-	if (dinoc->di_version > 1 &&
-			be32_to_cpu(dinoc->di_nlink) != 0)  {
-		__dirty_no_modify_ret(dirty);
-		dinoc->di_nlink = 0;
-	}
-
-	/* we are done for version 1/2 inodes */
-	if (dinoc->di_version < 3)
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
+	memset(dinoc, 0, sizeof(*dinoc));
+	dinoc->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		dinoc->di_version = 3;
+	else
+		dinoc->di_version = 2;
  
-	if (be64_to_cpu(dinoc->di_flags2) != 0)  {
-		__dirty_no_modify_ret(dirty);
-		dinoc->di_flags2 = 0;
-	}
+	dinoc->di_gen = cpu_to_be32(random());
+	dinoc->di_format = XFS_DINODE_FMT_EXTENTS;
+	dinoc->di_aformat = XFS_DINODE_FMT_EXTENTS;
  
-	if (be64_to_cpu(dinoc->di_lsn) != 0)  {
-		__dirty_no_modify_ret(dirty);
-		dinoc->di_lsn = 0;
-	}
+        /* we are done for version 1/2 inodes */
+        if (dinoc->di_version < 3)
+                return;
  
-	if (be64_to_cpu(dinoc->di_changecount) != 0)  {
-		__dirty_no_modify_ret(dirty);
-		dinoc->di_changecount = 0;
-	}
-
-	return dirty;
+	dinoc->di_ino = cpu_to_be64(ino_num);
+	platform_uuid_copy(&dinoc->di_uuid, &mp->m_sb.sb_meta_uuid);
+	return;
  }
  
  static int
@@ -258,21 +158,15 @@ clear_dinode_unlinked(xfs_mount_t *mp, xfs_dinode_t *dino)
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
  
  
@@ -2130,8 +2024,8 @@ process_inode_data_fork(
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
@@ -2541,7 +2435,7 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
  	}
  
  	/*
-	 * if not in verify mode, check to sii if the inode and imap
+	 * if not in verify mode, check to see if the inode and imap
  	 * agree that the inode is free
  	 */
  	if (!verify_mode && di_mode == 0) {
@@ -2554,8 +2448,10 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
  			 * it just in case to ensure that format, etc. are
  			 * set correctly
  			 */
-			if (!no_modify)
-				*dirty += clear_dinode(mp, dino, lino);
+			if (!no_modify) {
+				clear_dinode(mp, dino, lino);
+				*dirty += 1;
+			}
  			*used = is_free;
  			return 0;
  		}
@@ -2568,7 +2464,8 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
  	_("imap claims a free inode %" PRIu64 " is in use, "), lino);
  		if (!no_modify)  {
  			do_warn(_("correcting imap and clearing inode\n"));
-			*dirty += clear_dinode(mp, dino, lino);
+			clear_dinode(mp, dino, lino);
+			*dirty += 1;
  			retval = 1;
  		} else
  			do_warn(_("would correct imap and clear inode\n"));
@@ -3006,8 +2903,8 @@ _("Cannot have CoW extent size of zero on cowextsize inode %" PRIu64 ", "),
  
  clear_bad_out:
  	if (!no_modify)  {
-		*dirty += clear_dinode(mp, dino, lino);
-		ASSERT(*dirty > 0);
+		clear_dinode(mp, dino, lino);
+		*dirty += 1;
  	}
  bad_out:
  	*used = is_free;

