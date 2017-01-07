Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51855 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032643AbdAGAik (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Jan 2017 19:38:40 -0500
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v070cdcA023647
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 7 Jan 2017 00:38:39 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v070ccZd013072
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 7 Jan 2017 00:38:38 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v070ccUH009059
        for <linux-xfs@vger.kernel.org>; Sat, 7 Jan 2017 00:38:38 GMT
Subject: [PATCH 26/47] xfs: cross-reference bnobt records with cntbt
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 06 Jan 2017 16:38:37 -0800
Message-ID: <148374951738.30431.9816411507202357535.stgit@birch.djwong.org>
In-Reply-To: <148374934333.30431.11042523766304087227.stgit@birch.djwong.org>
References: <148374934333.30431.11042523766304087227.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Scrub should make sure that each bnobt record has a corresponding
cntbt record.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c |    2 +-
 fs/xfs/libxfs/xfs_alloc.h |    7 +++++++
 fs/xfs/repair/agheader.c  |   20 ++++++++++++++++++++
 fs/xfs/repair/alloc.c     |   31 +++++++++++++++++++++++++++++++
 4 files changed, 59 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index ad8044b..4776f66 100644
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
diff --git a/fs/xfs/repair/agheader.c b/fs/xfs/repair/agheader.c
index 6375f19..b351885 100644
--- a/fs/xfs/repair/agheader.c
+++ b/fs/xfs/repair/agheader.c
@@ -318,6 +318,7 @@ xfs_scrub_agf(
 	xfs_agblock_t			fl_count;
 	xfs_extlen_t			blocks;
 	bool				is_freesp;
+	int				have;
 	int				level;
 	int				error = 0;
 	int				err2;
@@ -417,6 +418,25 @@ xfs_scrub_agf(
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
diff --git a/fs/xfs/repair/alloc.c b/fs/xfs/repair/alloc.c
index 2fef449..7cc15b8 100644
--- a/fs/xfs/repair/alloc.c
+++ b/fs/xfs/repair/alloc.c
@@ -31,6 +31,7 @@
 #include "xfs_trace.h"
 #include "xfs_sb.h"
 #include "xfs_rmap.h"
+#include "xfs_alloc.h"
 #include "repair/common.h"
 #include "repair/btree.h"
 
@@ -65,9 +66,15 @@ xfs_scrub_allocbt_helper(
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
@@ -81,6 +88,30 @@ xfs_scrub_allocbt_helper(
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
 

