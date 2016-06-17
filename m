Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 02DB383B1
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:44:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B6BC6304039
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:44:07 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 38qxg1B4l4Vmyr1n (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:44:01 -0700 (PDT)
Subject: [PATCH 125/145] xfs_repair: handle multiple owners of data blocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:43:52 -0700
Message-ID: <146612783221.16048.14013741850074078546.stgit@birch.djwong.org>
In-Reply-To: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
References: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

If reflink is enabled, don't freak out if there are multiple owners of
a given block; that's just a sign that each of those owners are
reflink files.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/dinode.c |   66 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 repair/scan.c   |   38 +++++++++++++++++++++++++++++++-
 2 files changed, 103 insertions(+), 1 deletion(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index e9b4f8f..ecba3be 100644
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
index 6300204..8938341 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -790,6 +790,28 @@ struct rmap_priv {
 	struct xfs_rmap_irec	last_rec;
 };
 
+static bool
+rmap_in_order(
+	xfs_agblock_t	b,
+	xfs_agblock_t	lastblock,
+	int64_t		owner,
+	int64_t		lastowner,
+	int64_t		offset,
+	int64_t		lastoffset)
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
@@ -947,7 +969,12 @@ advance:
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
@@ -1057,6 +1084,15 @@ _("in use block (%d,%d-%d) mismatch in %s tree, state - %d,%" PRIx64 "\n"),
 					 * be caught later.
 					 */
 					break;
+				case XR_E_INUSE1:
+					/*
+					 * multiple inode owners are ok with
+					 * reflink enabled
+					 */
+					if (xfs_sb_version_hasreflink(&mp->m_sb) &&
+					    !XFS_RMAP_NON_INODE_OWNER(owner))
+						break;
+					/* fall through */
 				default:
 					do_warn(
 _("unknown block (%d,%d-%d) mismatch on %s tree, state - %d,%" PRIx64 "\n"),

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
