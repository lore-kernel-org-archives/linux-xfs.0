Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18064 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753497AbcKEAWB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:22:01 -0400
Subject: [PATCH 27/41] xfs: cross-reference bnobt records with cntbt
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:21:56 -0700
Message-ID: <147830531652.2155.4482425600492560722.stgit@birch.djwong.org>
In-Reply-To: <147830514302.2155.3920703176812208304.stgit@birch.djwong.org>
References: <147830514302.2155.3920703176812208304.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Scrub should make sure that each bnobt record has a corresponding
cntbt record.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c |    2 +-
 fs/xfs/libxfs/xfs_alloc.h |    7 ++++++
 fs/xfs/xfs_scrub.c        |   50 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 58 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index a7c0d7a..9405a30 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -169,7 +169,7 @@ xfs_alloc_lookup_ge(
  * Lookup the first record less than or equal to [bno, len]
  * in the btree given by cur.
  */
-static int				/* error */
+int					/* error */
 xfs_alloc_lookup_le(
 	struct xfs_btree_cur	*cur,	/* btree cursor */
 	xfs_agblock_t		bno,	/* starting block of extent */
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 3fd6540..b79159c 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -202,6 +202,13 @@ xfs_free_extent(
 	enum xfs_ag_resv_type	type);	/* block reservation type */
 
 int				/* error */
+xfs_alloc_lookup_le(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	xfs_agblock_t		bno,	/* starting block of extent */
+	xfs_extlen_t		len,	/* length of extent */
+	int			*stat);	/* success/failure */
+
+int				/* error */
 xfs_alloc_lookup_ge(
 	struct xfs_btree_cur	*cur,	/* btree cursor */
 	xfs_agblock_t		bno,	/* starting block of extent */
diff --git a/fs/xfs/xfs_scrub.c b/fs/xfs/xfs_scrub.c
index 166fc3d..45504d4 100644
--- a/fs/xfs/xfs_scrub.c
+++ b/fs/xfs/xfs_scrub.c
@@ -1816,6 +1816,7 @@ xfs_scrub_agf(
 	xfs_agblock_t			fl_count;
 	xfs_extlen_t			blocks;
 	bool				is_freesp;
+	int				have;
 	int				level;
 	int				error = 0;
 	int				err2;
@@ -1914,6 +1915,25 @@ xfs_scrub_agf(
 	}
 skip_bnobt:
 
+	/* Cross-reference with the cntbt. */
+	if (psa->cnt_cur) {
+		err2 = xfs_alloc_lookup_le(psa->cnt_cur, 0, -1U, &have);
+		if (!xfs_scrub_should_xref(sc, err2, &psa->cnt_cur))
+			goto skip_cntbt;
+		if (!have) {
+			XFS_SCRUB_AGF_CHECK(agf->agf_freeblks ==
+					be32_to_cpu(0));
+			goto skip_cntbt;
+		}
+		err2 = xfs_alloc_get_rec(psa->cnt_cur, &agbno, &blocks, &have);
+		if (!xfs_scrub_should_xref(sc, err2, &psa->cnt_cur))
+			goto skip_cntbt;
+		XFS_SCRUB_AGF_CHECK(have);
+		XFS_SCRUB_AGF_CHECK(!have ||
+				blocks == be32_to_cpu(agf->agf_longest));
+	}
+skip_cntbt:
+
 out:
 	return error;
 }
@@ -2150,9 +2170,15 @@ xfs_scrub_allocbt_helper(
 {
 	struct xfs_mount		*mp = bs->cur->bc_mp;
 	struct xfs_agf			*agf;
+	struct xfs_btree_cur		**xcur;
+	struct xfs_scrub_ag		*psa;
+	xfs_agblock_t			fbno;
 	xfs_agblock_t			bno;
+	xfs_extlen_t			flen;
 	xfs_extlen_t			len;
+	int				has_otherrec;
 	int				error = 0;
+	int				err2;
 
 	bno = be32_to_cpu(rec->alloc.ar_startblock);
 	len = be32_to_cpu(rec->alloc.ar_blockcount);
@@ -2166,6 +2192,30 @@ xfs_scrub_allocbt_helper(
 	XFS_SCRUB_BTREC_CHECK(bs, (unsigned long long)bno + len <=
 			be32_to_cpu(agf->agf_length));
 
+	if (error)
+		goto out;
+
+	psa = &bs->sc->sa;
+	/*
+	 * Ensure there's a corresponding cntbt/bnobt record matching
+	 * this bnobt/cntbt record, respectively.
+	 */
+	xcur = bs->cur == psa->bno_cur ? &psa->cnt_cur : &psa->bno_cur;
+	if (*xcur) {
+		err2 = xfs_alloc_lookup_le(*xcur, bno, len, &has_otherrec);
+		if (xfs_scrub_btree_should_xref(bs, err2, xcur)) {
+			XFS_SCRUB_BTREC_GOTO(bs, has_otherrec, out);
+			err2 = xfs_alloc_get_rec(*xcur, &fbno, &flen,
+					&has_otherrec);
+			if (xfs_scrub_btree_should_xref(bs, err2, xcur)) {
+				XFS_SCRUB_BTREC_GOTO(bs, has_otherrec, out);
+				XFS_SCRUB_BTREC_CHECK(bs, fbno == bno);
+				XFS_SCRUB_BTREC_CHECK(bs, flen == len);
+			}
+		}
+	}
+
+out:
 	return error;
 }
 

