Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46964 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932449AbcJYXGj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2016 19:06:39 -0400
Subject: [PATCH 28/39] xfs_repair: handle multiple owners of data blocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 25 Oct 2016 16:06:35 -0700
Message-ID: <147743679506.11035.9193078348507369875.stgit@birch.djwong.org>
In-Reply-To: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

If reflink is enabled, don't freak out if there are multiple owners of
a given block; that's just a sign that each of those owners are
reflink files.

v2: owner and offset are unsigned types, so use those for inorder
comparison.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/dinode.c |   66 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 repair/scan.c   |   42 ++++++++++++++++++++++++++++++++++-
 2 files changed, 107 insertions(+), 1 deletion(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index 16e0a06..98afdc9 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -722,6 +722,9 @@ _("Fatal error: inode %" PRIu64 " - blkmap_set_ext(): %s\n"
 			 * checking each entry without setting the
 			 * block bitmap
 			 */
+			if (type == XR_INO_DATA &&
+			    xfs_sb_version_hasreflink(&mp->m_sb))
+				goto skip_dup;
 			if (search_dup_extent(agno, agbno, ebno)) {
 				do_warn(
 _("%s fork in ino %" PRIu64 " claims dup extent, "
@@ -731,6 +734,7 @@ _("%s fork in ino %" PRIu64 " claims dup extent, "
 					irec.br_blockcount);
 				goto done;
 			}
+skip_dup:
 			*tot += irec.br_blockcount;
 			continue;
 		}
@@ -770,6 +774,9 @@ _("%s fork in inode %" PRIu64 " claims metadata block %" PRIu64 "\n"),
 			case XR_E_INUSE:
 			case XR_E_MULT:
 				set_bmap_ext(agno, agbno, blen, XR_E_MULT);
+				if (type == XR_INO_DATA &&
+				    xfs_sb_version_hasreflink(&mp->m_sb))
+					break;
 				do_warn(
 _("%s fork in %s inode %" PRIu64 " claims used block %" PRIu64 "\n"),
 					forkname, ftype, ino, b);
@@ -2475,6 +2482,65 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 		}
 	}
 
+	/*
+	 * check that we only have valid flags2 set, and those that are set make
+	 * sense.
+	 */
+	if (dino->di_version >= 3) {
+		uint16_t flags = be16_to_cpu(dino->di_flags);
+		uint64_t flags2 = be64_to_cpu(dino->di_flags2);
+
+		if (flags2 & ~XFS_DIFLAG2_ANY) {
+			if (!uncertain) {
+				do_warn(
+	_("Bad flags2 set in inode %" PRIu64 "\n"),
+					lino);
+			}
+			flags2 &= XFS_DIFLAG2_ANY;
+		}
+
+		if ((flags2 & XFS_DIFLAG2_REFLINK) &&
+		    !xfs_sb_version_hasreflink(&mp->m_sb)) {
+			if (!uncertain) {
+				do_warn(
+	_("inode %" PRIu64 " is marked reflinked but file system does not support reflink\n"),
+					lino);
+			}
+			goto clear_bad_out;
+		}
+
+		if (flags2 & XFS_DIFLAG2_REFLINK) {
+			/* must be a file */
+			if (di_mode && !S_ISREG(di_mode)) {
+				if (!uncertain) {
+					do_warn(
+	_("reflink flag set on non-file inode %" PRIu64 "\n"),
+						lino);
+				}
+				goto clear_bad_out;
+			}
+		}
+
+		if ((flags2 & XFS_DIFLAG2_REFLINK) &&
+		    (flags & (XFS_DIFLAG_REALTIME | XFS_DIFLAG_RTINHERIT))) {
+			if (!uncertain) {
+				do_warn(
+	_("Cannot have a reflinked realtime inode %" PRIu64 "\n"),
+					lino);
+			}
+			goto clear_bad_out;
+		}
+
+		if (!verify_mode && flags2 != be64_to_cpu(dino->di_flags2)) {
+			if (!no_modify) {
+				do_warn(_("fixing bad flags2.\n"));
+				dino->di_flags2 = cpu_to_be64(flags2);
+				*dirty = 1;
+			} else
+				do_warn(_("would fix bad flags2.\n"));
+		}
+	}
+
 	if (verify_mode)
 		return retval;
 
diff --git a/repair/scan.c b/repair/scan.c
index c27f969..d3a1a82 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -872,6 +872,15 @@ _("in use block (%d,%d-%d) mismatch in %s tree, state - %d,%" PRIx64 "\n"),
 		 * be caught later.
 		 */
 		break;
+	case XR_E_INUSE1:
+		/*
+		 * multiple inode owners are ok with
+		 * reflink enabled
+		 */
+		if (xfs_sb_version_hasreflink(&mp->m_sb) &&
+		    !XFS_RMAP_NON_INODE_OWNER(owner))
+			break;
+		/* fall through */
 	default:
 		do_warn(
 _("unknown block (%d,%d-%d) mismatch on %s tree, state - %d,%" PRIx64 "\n"),
@@ -888,6 +897,28 @@ struct rmap_priv {
 	xfs_agblock_t		nr_blocks;
 };
 
+static bool
+rmap_in_order(
+	xfs_agblock_t	b,
+	xfs_agblock_t	lastblock,
+	uint64_t	owner,
+	uint64_t	lastowner,
+	uint64_t	offset,
+	uint64_t	lastoffset)
+{
+	if (b > lastblock)
+		return true;
+	else if (b < lastblock)
+		return false;
+
+	if (owner > lastowner)
+		return true;
+	else if (owner < lastowner)
+		return false;
+
+	return offset > lastoffset;
+}
+
 static void
 scan_rmapbt(
 	struct xfs_btree_block	*block,
@@ -908,6 +939,8 @@ scan_rmapbt(
 	int			numrecs;
 	int			state;
 	xfs_agblock_t		lastblock = 0;
+	uint64_t		lastowner = 0;
+	uint64_t		lastoffset = 0;
 	struct xfs_rmap_key	*kp;
 	struct xfs_rmap_irec	key = {0};
 
@@ -1038,10 +1071,17 @@ _("%s rmap btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 			if (i == 0) {
 advance:
 				lastblock = b;
+				lastowner = owner;
+				lastoffset = offset;
 			} else {
 				bool bad;
 
-				bad = b <= lastblock;
+				if (xfs_sb_version_hasreflink(&mp->m_sb))
+					bad = !rmap_in_order(b, lastblock,
+							owner, lastowner,
+							offset, lastoffset);
+				else
+					bad = b <= lastblock;
 				if (bad)
 					do_warn(
 	_("out-of-order rmap btree record %d (%u %"PRId64" %"PRIx64" %u) block %u/%u\n"),

