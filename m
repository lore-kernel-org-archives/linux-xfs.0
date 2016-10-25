Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46969 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935013AbcJYXHS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2016 19:07:18 -0400
Subject: [PATCH 34/39] xfs_repair: complain about copy-on-write leftovers
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 25 Oct 2016 16:07:14 -0700
Message-ID: <147743683456.11035.12043450035449010536.stgit@birch.djwong.org>
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

Complain about leftover CoW allocations that are hanging off the
refcount btree.  These are cleaned out at mount time, but we could be
louder about flagging down evidence of trouble.

Since these extents aren't "owned" by anything, we'll free them up by
reconstructing the free space btrees.

v2: When we're processing rmap records, we inadvertently forgot to
handle the CoW owner, so the leftover CoW staging blocks got marked as
file data.  These blocks will just get freed later, so mark them
"CoW".  When we process the refcountbt, complain about leftovers if
the type is unknown or "CoW".

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/check.c      |   21 +++++++++++++++++----
 repair/incore.h |    3 ++-
 repair/scan.c   |   45 ++++++++++++++++++++++++++++++++++++++++-----
 3 files changed, 59 insertions(+), 10 deletions(-)


diff --git a/db/check.c b/db/check.c
index 5b90182..7392852 100644
--- a/db/check.c
+++ b/db/check.c
@@ -45,7 +45,7 @@ typedef enum {
 	DBM_LOG,	DBM_MISSING,	DBM_QUOTA,	DBM_RTBITMAP,
 	DBM_RTDATA,	DBM_RTFREE,	DBM_RTSUM,	DBM_SB,
 	DBM_SYMLINK,	DBM_BTFINO,	DBM_BTRMAP,	DBM_BTREFC,
-	DBM_RLDATA,
+	DBM_RLDATA,	DBM_COWDATA,
 	DBM_NDBM
 } dbm_t;
 
@@ -4731,9 +4731,22 @@ scanfunc_refcnt(
 		rp = XFS_REFCOUNT_REC_ADDR(block, 1);
 		lastblock = 0;
 		for (i = 0; i < be16_to_cpu(block->bb_numrecs); i++) {
-			set_dbmap(seqno, be32_to_cpu(rp[i].rc_startblock),
-				be32_to_cpu(rp[i].rc_blockcount), DBM_RLDATA,
-				seqno, bno);
+			if (be32_to_cpu(rp[i].rc_refcount) == 1) {
+				dbprintf(_(
+		"leftover CoW extent (%u/%u) len %u\n"),
+					seqno,
+					be32_to_cpu(rp[i].rc_startblock),
+					be32_to_cpu(rp[i].rc_blockcount));
+				set_dbmap(seqno,
+					be32_to_cpu(rp[i].rc_startblock),
+					be32_to_cpu(rp[i].rc_blockcount),
+					DBM_COWDATA, seqno, bno);
+			} else {
+				set_dbmap(seqno,
+					be32_to_cpu(rp[i].rc_startblock),
+					be32_to_cpu(rp[i].rc_blockcount),
+					DBM_RLDATA, seqno, bno);
+			}
 			if (be32_to_cpu(rp[i].rc_startblock) < lastblock) {
 				dbprintf(_(
 		"out-of-order refcnt btree record %d (%u %u) block %u/%u\n"),
diff --git a/repair/incore.h b/repair/incore.h
index bcd2f4b..c23a3a3 100644
--- a/repair/incore.h
+++ b/repair/incore.h
@@ -107,7 +107,8 @@ typedef struct rt_extent_tree_node  {
 #define XR_E_INO1	10	/* used by inodes (marked by rmap btree) */
 #define XR_E_FS_MAP1	11	/* used by fs space/inode maps (rmap btree) */
 #define XR_E_REFC	12	/* used by fs ag reference count btree */
-#define XR_E_BAD_STATE	13
+#define XR_E_COW	13	/* leftover cow extent */
+#define XR_E_BAD_STATE	14
 
 /* separate state bit, OR'ed into high (4th) bit of ex_state field */
 
diff --git a/repair/scan.c b/repair/scan.c
index 1c60784..800a88a 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -813,6 +813,9 @@ process_rmap_rec(
 		case XFS_RMAP_OWN_REFC:
 			set_bmap_ext(agno, b, blen, XR_E_REFC);
 			break;
+		case XFS_RMAP_OWN_COW:
+			set_bmap_ext(agno, b, blen, XR_E_COW);
+			break;
 		case XFS_RMAP_OWN_NULL:
 			/* still unknown */
 			break;
@@ -1288,16 +1291,27 @@ _("%s btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 
 		rp = XFS_REFCOUNT_REC_ADDR(block, 1);
 		for (i = 0; i < numrecs; i++) {
-			xfs_agblock_t		b, end;
+			xfs_agblock_t		b, agb, end;
 			xfs_extlen_t		len;
 			xfs_nlink_t		nr;
 
-			b = be32_to_cpu(rp[i].rc_startblock);
+			b = agb = be32_to_cpu(rp[i].rc_startblock);
 			len = be32_to_cpu(rp[i].rc_blockcount);
 			nr = be32_to_cpu(rp[i].rc_refcount);
-			end = b + len;
+			if (b >= XFS_REFC_COW_START && nr != 1)
+				do_warn(
+_("leftover CoW extent has incorrect refcount in record %u of %s btree block %u/%u\n"),
+					i, name, agno, bno);
+			if (nr == 1) {
+				if (agb < XFS_REFC_COW_START)
+					do_warn(
+_("leftover CoW extent has invalid startblock in record %u of %s btree block %u/%u\n"),
+						i, name, agno, bno);
+				agb -= XFS_REFC_COW_START;
+			}
+			end = agb + len;
 
-			if (!verify_agbno(mp, agno, b)) {
+			if (!verify_agbno(mp, agno, agb)) {
 				do_warn(
 	_("invalid start block %u in record %u of %s btree block %u/%u\n"),
 					b, i, name, agno, bno);
@@ -1310,7 +1324,28 @@ _("%s btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 				continue;
 			}
 
-			if (nr < 2 || nr > MAXREFCOUNT) {
+			if (nr == 1) {
+				xfs_agblock_t	c;
+				xfs_extlen_t	cnr;
+
+				for (c = agb; c < end; c += cnr) {
+					state = get_bmap_ext(agno, c, end, &cnr);
+					switch (state) {
+					case XR_E_UNKNOWN:
+					case XR_E_COW:
+						do_warn(
+_("leftover CoW extent (%u/%u) len %u\n"),
+						agno, c, cnr);
+						set_bmap_ext(agno, c, cnr, XR_E_FREE);
+						break;
+					default:
+						do_warn(
+_("extent (%u/%u) len %u claimed, state is %d\n"),
+						agno, c, cnr, state);
+						break;
+					}
+				}
+			} else if (nr < 2 || nr > MAXREFCOUNT) {
 				do_warn(
 	_("invalid reference count %u in record %u of %s btree block %u/%u\n"),
 					nr, i, name, agno, bno);

