Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 66EFE29E40
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:08:43 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3CCB58F8052
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:08:43 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 8YJ5NbE4Hm66WUqe (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:08:40 -0800 (PST)
Subject: [PATCH 33/53] xfs_repair: check existing rmapbt entries against
	observed rmaps
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:08:35 -0800
Message-ID: <20151219090835.14255.69198.stgit@birch.djwong.org>
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

If we're running in -n mode, check the rmaps that we observe against
what's in the rmap btree and complain if there's a mismatch.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/libxfs.h |    1 
 repair/phase4.c  |    6 ++
 repair/rmap.c    |  173 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 repair/rmap.h    |    5 ++
 repair/scan.c    |   19 ++++--
 5 files changed, 198 insertions(+), 6 deletions(-)


diff --git a/include/libxfs.h b/include/libxfs.h
index 2357aec..5382191 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -77,6 +77,7 @@ extern uint32_t crc32c_le(uint32_t crc, unsigned char const *p, size_t len);
 #include "xfs_bmap.h"
 #include "xfs_trace.h"
 #include "xfs_trans.h"
+#include "xfs_rmap_btree.h"
 
 #ifndef ARRAY_SIZE
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
diff --git a/repair/phase4.c b/repair/phase4.c
index cbdb92e..98aab35 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -174,6 +174,12 @@ _("unable to add AG %u metadata reverse-mapping data.\n"), agno);
 	if (error)
 		do_error(
 _("unable to merge AG %u metadata reverse-mapping data.\n"), agno);
+
+	error = check_rmaps(wq->mp, agno);
+	if (error)
+		do_error(
+_("%s while checking reverse-mappings"),
+			 strerror(-error));
 }
 
 static void
diff --git a/repair/rmap.c b/repair/rmap.c
index e13fc53..bb1206e 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -41,6 +41,7 @@ struct xfs_ag_rmap {
 };
 
 static struct xfs_ag_rmap *ag_rmaps;
+static bool rmapbt_suspect;
 
 /*
  * Compare rmap observations for array sorting.
@@ -453,3 +454,175 @@ dump_rmap(
 #else
 # define dump_rmap(m, a, r)
 #endif
+
+/**
+ * rmap_record_count() -- Return the number of rmap objects for an AG.
+ *
+ * @mp: XFS mount object
+ * @agno: AG number
+ */
+size_t
+rmap_record_count(
+	struct xfs_mount		*mp,
+	xfs_agnumber_t		agno)
+{
+	return slab_count(ag_rmaps[agno].ar_rmaps);
+}
+
+/**
+ * init_rmap_cursor() -- Return a slab cursor that will return rmap
+ *                       objects in order.
+ * @agno: AG number.
+ * @cur: The new cursor.
+ */
+int
+init_rmap_cursor(
+	xfs_agnumber_t		agno,
+	struct xfs_slab_cursor	**cur)
+{
+	return init_slab_cursor(ag_rmaps[agno].ar_rmaps, rmap_compare, cur);
+}
+
+/**
+ * rmap_avoid_check() -- Disable the refcount btree check.
+ */
+void
+rmap_avoid_check(void)
+{
+	rmapbt_suspect = true;
+}
+
+/**
+ * check_rmaps() -- Compare the observed reverse mappings against
+ *		    what's in the ag btree.
+ * @mp: XFS mount object
+ * @agno: AG number
+ */
+int
+check_rmaps(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno)
+{
+	struct xfs_slab_cursor	*rm_cur;
+	struct xfs_btree_cur	*bt_cur = NULL;
+	int			error;
+	int			have;
+	int			i;
+	struct xfs_buf		*agbp = NULL;
+	struct xfs_rmap_irec	*rm_rec;
+	struct xfs_rmap_irec	tmp;
+	struct xfs_perag	*pag;		/* per allocation group data */
+
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+		return 0;
+	if (rmapbt_suspect) {
+		if (no_modify && agno == 0)
+			do_warn(_("would rebuild corrupt rmap btrees.\n"));
+		return 0;
+	}
+
+	/* Create cursors to refcount structures */
+	error = init_rmap_cursor(agno, &rm_cur);
+	if (error)
+		return error;
+
+	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
+	if (error)
+		goto err;
+
+	/* Leave the per-ag data "uninitialized" since we rewrite it later */
+	pag = xfs_perag_get(mp, agno);
+	pag->pagf_init = 0;
+	xfs_perag_put(pag);
+
+	bt_cur = xfs_rmapbt_init_cursor(mp, NULL, agbp, agno);
+	if (!bt_cur) {
+		error = -ENOMEM;
+		goto err;
+	}
+
+	rm_rec = pop_slab_cursor(rm_cur);
+	while (rm_rec) {
+		/* Look for a rmap record in the btree */
+		error = xfs_rmap_lookup_eq(bt_cur, rm_rec->rm_startblock,
+				rm_rec->rm_blockcount, rm_rec->rm_owner,
+				rm_rec->rm_offset, &have);
+		if (error)
+			goto err;
+		if (!have) {
+			do_warn(
+_("Missing reverse-mapping record for (%u/%u) %slen %u owner %"PRIx64" \
+%s%soff %"PRIx64"\n"),
+				agno, rm_rec->rm_startblock,
+				XFS_RMAP_IS_UNWRITTEN(rm_rec->rm_blockcount) ?
+					_("unwritten ") : "",
+				XFS_RMAP_LEN(rm_rec->rm_blockcount),
+				rm_rec->rm_owner,
+				XFS_RMAP_IS_ATTR_FORK(rm_rec->rm_offset) ?
+					_("attr ") : "",
+				XFS_RMAP_IS_BMBT(rm_rec->rm_offset) ?
+					_("bmbt ") : "",
+				XFS_RMAP_OFF(rm_rec->rm_offset));
+			goto next_loop;
+		}
+
+		error = xfs_rmap_get_rec(bt_cur, &tmp, &i);
+		if (error)
+			goto err;
+		if (!i) {
+			do_warn(
+_("Unretrievable reverse-mapping record for (%u/%u) %slen %u owner %"PRIx64" \
+%s%soff %"PRIx64"\n"),
+				agno, rm_rec->rm_startblock,
+				XFS_RMAP_IS_UNWRITTEN(rm_rec->rm_blockcount) ?
+					_("unwritten ") : "",
+				XFS_RMAP_LEN(rm_rec->rm_blockcount),
+				rm_rec->rm_owner,
+				XFS_RMAP_IS_ATTR_FORK(rm_rec->rm_offset) ?
+					_("attr ") : "",
+				XFS_RMAP_IS_BMBT(rm_rec->rm_offset) ?
+					_("bmbt ") : "",
+				XFS_RMAP_OFF(rm_rec->rm_offset));
+			goto next_loop;
+		}
+
+		/* Compare each refcount observation against the btree's */
+		if (tmp.rm_startblock != rm_rec->rm_startblock ||
+		    tmp.rm_blockcount != rm_rec->rm_blockcount ||
+		    tmp.rm_owner != rm_rec->rm_owner ||
+		    tmp.rm_offset != rm_rec->rm_offset)
+			do_warn(
+_("Incorrect reverse-mapping: saw (%u/%u) %slen %u owner %"PRIx64" %s%soff \
+%"PRIx64"; should be (%u/%u) %slen %u owner %"PRIx64" %s%soff %"PRIx64"\n"),
+				agno, tmp.rm_startblock,
+				XFS_RMAP_IS_UNWRITTEN(tmp.rm_blockcount) ?
+					_("unwritten ") : "",
+				XFS_RMAP_LEN(tmp.rm_blockcount),
+				tmp.rm_owner,
+				XFS_RMAP_IS_ATTR_FORK(tmp.rm_offset) ?
+					_("attr ") : "",
+				XFS_RMAP_IS_BMBT(tmp.rm_offset) ?
+					_("bmbt ") : "",
+				XFS_RMAP_OFF(tmp.rm_offset),
+				agno, rm_rec->rm_startblock,
+				XFS_RMAP_IS_UNWRITTEN(rm_rec->rm_blockcount) ?
+					_("unwritten ") : "",
+				XFS_RMAP_LEN(rm_rec->rm_blockcount),
+				rm_rec->rm_owner,
+				XFS_RMAP_IS_ATTR_FORK(rm_rec->rm_offset) ?
+					_("attr ") : "",
+				XFS_RMAP_IS_BMBT(rm_rec->rm_offset) ?
+					_("bmbt ") : "",
+				XFS_RMAP_OFF(rm_rec->rm_offset));
+next_loop:
+		rm_rec = pop_slab_cursor(rm_cur);
+	}
+
+err:
+	if (bt_cur)
+		xfs_btree_del_cursor(bt_cur, XFS_BTREE_NOERROR);
+	if (agbp)
+		libxfs_putbuf(agbp);
+	free_slab_cursor(&rm_cur);
+	return 0;
+}
diff --git a/repair/rmap.h b/repair/rmap.h
index 7bab450..f3f3331 100644
--- a/repair/rmap.h
+++ b/repair/rmap.h
@@ -33,4 +33,9 @@ extern int fold_raw_rmaps(struct xfs_mount *mp, xfs_agnumber_t agno);
 
 extern int add_fixed_ag_rmap_data(struct xfs_mount *, xfs_agnumber_t);
 
+extern size_t rmap_record_count(struct xfs_mount *, xfs_agnumber_t);
+extern int init_rmap_cursor(xfs_agnumber_t, struct xfs_slab_cursor **);
+extern void rmap_avoid_check(void);
+extern int check_rmaps(struct xfs_mount *, xfs_agnumber_t);
+
 #endif /* RMAP_H_ */
diff --git a/repair/scan.c b/repair/scan.c
index db9e131..823401b 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -29,6 +29,7 @@
 #include "bmap.h"
 #include "progress.h"
 #include "threads.h"
+#include "slab.h"
 #include "rmap.h"
 
 static xfs_mount_t	*mp = NULL;
@@ -808,7 +809,9 @@ scan_rmapbt(
 
 	if (magic != XFS_RMAP_CRC_MAGIC) {
 		name = "(unknown)";
-		assert(0);
+		hdr_errors++;
+		suspect++;
+		goto out;
 	}
 
 	if (be32_to_cpu(block->bb_magic) != magic) {
@@ -816,7 +819,7 @@ scan_rmapbt(
 			be32_to_cpu(block->bb_magic), name, agno, bno);
 		hdr_errors++;
 		if (suspect)
-			return;
+			goto out;
 	}
 
 	/*
@@ -834,7 +837,7 @@ scan_rmapbt(
 			level, be16_to_cpu(block->bb_level), name, agno, bno);
 		hdr_errors++;
 		if (suspect)
-			return;
+			goto out;
 	}
 
 	/* check for btree blocks multiply claimed */
@@ -844,7 +847,7 @@ scan_rmapbt(
 		do_warn(
 _("%s rmap btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 				name, state, agno, bno, suspect);
-		return;
+		goto out;
 	}
 	set_bmap(agno, bno, XR_E_FS_MAP);
 
@@ -992,7 +995,7 @@ _("unknown block (%d,%d-%d) mismatch on %s tree, state - %d,%" PRIx64 "\n"),
 				}
 			}
 		}
-		return;
+		goto out;
 	}
 
 	/*
@@ -1020,7 +1023,7 @@ _("unknown block (%d,%d-%d) mismatch on %s tree, state - %d,%" PRIx64 "\n"),
 			mp->m_rmap_mnr[1], mp->m_rmap_mxr[1],
 			name, agno, bno);
 		if (suspect)
-			return;
+			goto out;
 		suspect++;
 	} else if (suspect) {
 		suspect = 0;
@@ -1043,6 +1046,10 @@ _("unknown block (%d,%d-%d) mismatch on %s tree, state - %d,%" PRIx64 "\n"),
 				    magic, priv, &xfs_rmapbt_buf_ops);
 		}
 	}
+
+out:
+	if (suspect)
+		rmap_avoid_check();
 }
 
 /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
