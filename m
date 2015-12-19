Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EDE6B29E2A
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:10:04 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 712BAAC005
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:10:04 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id AXpfSH6ULqaXAFWZ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:10:02 -0800 (PST)
Subject: [PATCH 45/53] xfs_repair: handle multiple owners of data blocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:09:55 -0800
Message-ID: <20151219090955.14255.58791.stgit@birch.djwong.org>
In-Reply-To: <20151219090450.14255.48364.stgit@birch.djwong.org>
References: <20151219090450.14255.48364.stgit@birch.djwong.org>
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
 repair/dinode.c |   53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 repair/scan.c   |   40 ++++++++++++++++++++++++++++++++++++++--
 2 files changed, 91 insertions(+), 2 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index 7766dea..2ff1476 100644
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
@@ -2460,6 +2467,52 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
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
+		    (flags & (XFS_DIFLAG_REALTIME | XFS_DIFLAG_RTINHERIT))) {
+			if (!uncertain) {
+				do_warn(
+	_("Cannot have a reflinked realtime inode %" PRIu64 "\n"),
+					lino);
+			}
+			goto clear_bad_out;
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
index 4be02a6..54b9b68 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -783,7 +783,29 @@ ino_issparse(
 
 	return xfs_inobt_is_sparse_disk(rp, offset);
 }
- 
+
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
@@ -910,7 +932,12 @@ advance:
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
@@ -997,6 +1024,15 @@ _("in use block (%d,%d-%d) mismatch in %s tree, state - %d,%" PRIx64 "\n"),
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
