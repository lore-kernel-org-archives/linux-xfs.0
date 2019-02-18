Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:23080 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727266AbfBRC0Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Feb 2019 21:26:25 -0500
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1gvYdP-0002p9-Fk
        for linux-xfs@vger.kernel.org; Mon, 18 Feb 2019 13:26:19 +1100
Date: Mon, 18 Feb 2019 13:26:19 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/3] xfs: EOF blocks are not busy extents
Message-ID: <20190218022619.GD14116@dastard>
References: <20190207050813.24271-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190207050813.24271-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Userdata extents are considered as "busy extents" when they are
freed to ensure that they ar enot reallocated and written to before
the transaction that frees the user data extent has been committed
to disk.

However, in the case of post EOF blocks, these block have
never been exposed to user applications and so don't contain valid
data. Hence they don't need to be considered "busy" when they've
been freed because there is no data in them that can be destroyed
if they are reallocated and have data written to them before the
free transaction is committed.

We already have XFS_BMAPI_NODISCARD to extent freeing that the data
extent has never been used so it doesn't need discards issued on it.
This new functionality is just an extension of that concept - the
extent is actually unused, so doesn't even need to be marked busy.

Hence fix this by adding XFS_BMAPI_UNUSED and update the EOF block
data extent truncate with XFS_BMAPI_UNUSED and propagate that all
the way through the various structures an use it to avoid inserting
the extent into the busy list.

[ Note: this seems like a bit of a hack, but I just don't see the
point of inserting it into the busy list, then adding a new busy
list unused flag, then allowing every allocation type to use it in
the _trim code, then have every caller have to call _reuse to remove
the range from the busy tree. It just seems like complexity that
doesn't need to exist because anyone can reallocate an
unused extent for immediate use. ]

This avoids the problem of free space fragmentation when multiple
files are written sequentially  via synchronous writes or post-write
fsync calls before the next file is written. This results in the
post-eof blocks being marked busy and can't be immediately
reallocated resulting in the files packing poorly and unnecessarily
leaving free space between them.

Freespace fragmentation from sequential multi-file synchronous write
workload:

Before:
  from      to extents  blocks    pct
      1       1       7       7   0.00
      2       3      34      80   0.00
      4       7      65     345   0.01
      8      15     208    2417   0.05
     16      31     147    2982   0.06
     32      63       1      49   0.00
1048576 1310720       4 5185064  99.89

After:
   from      to extents  blocks    pct
      1       1       3       3   0.00
      2       3       1       3   0.00
1048576 1310720       4 5190871 100.00

Much better.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c  | 7 +++----
 fs/xfs/libxfs/xfs_bmap.c   | 6 +++---
 fs/xfs/libxfs/xfs_bmap.h   | 8 ++++++--
 fs/xfs/xfs_bmap_util.c     | 2 +-
 fs/xfs/xfs_trans_extfree.c | 6 +++---
 5 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 659bb9133955..729136ef0ed1 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3014,7 +3014,7 @@ __xfs_free_extent(
 	xfs_extlen_t			len,
 	const struct xfs_owner_info	*oinfo,
 	enum xfs_ag_resv_type		type,
-	bool				skip_discard)
+	bool				unused)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_buf			*agbp;
@@ -3045,9 +3045,8 @@ __xfs_free_extent(
 	if (error)
 		goto err;
 
-	if (skip_discard)
-		busy_flags |= XFS_EXTENT_BUSY_SKIP_DISCARD;
-	xfs_extent_busy_insert(tp, agno, agbno, len, busy_flags);
+	if (!unused)
+		xfs_extent_busy_insert(tp, agno, agbno, len, busy_flags);
 	return 0;
 
 err:
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 332eefa2700b..ba0fd80eede4 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -537,7 +537,7 @@ __xfs_bmap_add_free(
 	xfs_fsblock_t			bno,
 	xfs_filblks_t			len,
 	const struct xfs_owner_info	*oinfo,
-	bool				skip_discard)
+	bool				unused)
 {
 	struct xfs_extent_free_item	*new;		/* new element */
 #ifdef DEBUG
@@ -565,7 +565,7 @@ __xfs_bmap_add_free(
 		new->xefi_oinfo = *oinfo;
 	else
 		new->xefi_oinfo = XFS_RMAP_OINFO_SKIP_UPDATE;
-	new->xefi_skip_discard = skip_discard;
+	new->xefi_unused = unused;
 	trace_xfs_bmap_free_defer(tp->t_mountp,
 			XFS_FSB_TO_AGNO(tp->t_mountp, bno), 0,
 			XFS_FSB_TO_AGBNO(tp->t_mountp, bno), len);
@@ -5069,7 +5069,7 @@ xfs_bmap_del_extent_real(
 		} else {
 			__xfs_bmap_add_free(tp, del->br_startblock,
 					del->br_blockcount, NULL,
-					(bflags & XFS_BMAPI_NODISCARD) ||
+					(bflags & XFS_BMAPI_UNUSED) ||
 					del->br_state == XFS_EXT_UNWRITTEN);
 		}
 	}
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 09d3ea97cc15..33fb95f84ea0 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -54,7 +54,7 @@ struct xfs_extent_free_item
 	xfs_extlen_t		xefi_blockcount;/* number of blocks in extent */
 	struct list_head	xefi_list;
 	struct xfs_owner_info	xefi_oinfo;	/* extent owner */
-	bool			xefi_skip_discard;
+	bool			xefi_unused;
 };
 
 #define	XFS_BMAP_MAX_NMAP	4
@@ -107,6 +107,9 @@ struct xfs_extent_free_item
 /* Do not update the rmap btree.  Used for reconstructing bmbt from rmapbt. */
 #define XFS_BMAPI_NORMAP	0x2000
 
+/* Unused freed data extent, no need to mark busy */
+#define XFS_BMAPI_UNUSED	0x4000
+
 #define XFS_BMAPI_FLAGS \
 	{ XFS_BMAPI_ENTIRE,	"ENTIRE" }, \
 	{ XFS_BMAPI_METADATA,	"METADATA" }, \
@@ -120,7 +123,8 @@ struct xfs_extent_free_item
 	{ XFS_BMAPI_DELALLOC,	"DELALLOC" }, \
 	{ XFS_BMAPI_CONVERT_ONLY, "CONVERT_ONLY" }, \
 	{ XFS_BMAPI_NODISCARD,	"NODISCARD" }, \
-	{ XFS_BMAPI_NORMAP,	"NORMAP" }
+	{ XFS_BMAPI_NORMAP,	"NORMAP" }, \
+	{ XFS_BMAPI_UNUSED,	"UNUSED" }
 
 
 static inline int xfs_bmapi_aflag(int w)
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index af2e30d33794..f5a8a4385512 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -841,7 +841,7 @@ xfs_free_eofblocks(
 		 * may be full of holes (ie NULL files bug).
 		 */
 		error = xfs_itruncate_extents_flags(&tp, ip, XFS_DATA_FORK,
-					XFS_ISIZE(ip), XFS_BMAPI_NODISCARD);
+					XFS_ISIZE(ip), XFS_BMAPI_UNUSED);
 		if (error) {
 			/*
 			 * If we get an error at this point we simply don't
diff --git a/fs/xfs/xfs_trans_extfree.c b/fs/xfs/xfs_trans_extfree.c
index 0710434eb240..d06fb2cd6ffb 100644
--- a/fs/xfs/xfs_trans_extfree.c
+++ b/fs/xfs/xfs_trans_extfree.c
@@ -58,7 +58,7 @@ xfs_trans_free_extent(
 	xfs_fsblock_t			start_block,
 	xfs_extlen_t			ext_len,
 	const struct xfs_owner_info	*oinfo,
-	bool				skip_discard)
+	bool				unused)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_extent		*extp;
@@ -71,7 +71,7 @@ xfs_trans_free_extent(
 	trace_xfs_bmap_free_deferred(tp->t_mountp, agno, 0, agbno, ext_len);
 
 	error = __xfs_free_extent(tp, start_block, ext_len,
-				  oinfo, XFS_AG_RESV_NONE, skip_discard);
+				  oinfo, XFS_AG_RESV_NONE, unused);
 	/*
 	 * Mark the transaction dirty, even on error. This ensures the
 	 * transaction is aborted, which:
@@ -184,7 +184,7 @@ xfs_extent_free_finish_item(
 	error = xfs_trans_free_extent(tp, done_item,
 			free->xefi_startblock,
 			free->xefi_blockcount,
-			&free->xefi_oinfo, free->xefi_skip_discard);
+			&free->xefi_oinfo, free->xefi_unused);
 	kmem_free(free);
 	return error;
 }
