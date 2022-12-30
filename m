Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F06D7C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:39:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbiL3Xjg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:39:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiL3Xjf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:39:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B4D1DF16
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:39:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 089A161C31
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:39:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D6F7C433EF;
        Fri, 30 Dec 2022 23:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672443571;
        bh=YjZqZ2UBVodzlSADpGGUjaUOlioexySDM7n91rNeT5s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=CaCntV2mBlMKzITFi3yQhh6VYWIhCykI3CL2Q5bAuLG63u3yBEi8XNAJngLgeTBhA
         rRBKmG50F/wPO6Af0GhM7/M4Yemgrry2v9DoMsxuCU1Me56rUjWciYrLkz9A+/iyMR
         slZ5AVxIQQQo9hqpOm4nF3yYX11cFgRAVdF5vRqbHPI23s+JvJ6FAUkMOhwjf2FMzS
         KUBpSchSpNQJZQ62O9EqSAlw9sQ32pKr2IWNJiHe2dLVdijAjNmdGY2lcqmfs42DCf
         VR97q6JfR/ggz01lgQHgLrmVWfBpyddNGkWIZChL5enR/fz88jEwcs0a3MMWCexzY1
         YOMTfkwPE82ew==
Subject: [PATCH 11/11] xfs: report XFS_IS_CORRUPT errors to the health system
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:16 -0800
Message-ID: <167243839617.695999.17687994600739482578.stgit@magnolia>
In-Reply-To: <167243839445.695999.12861421643354894719.stgit@magnolia>
References: <167243839445.695999.12861421643354894719.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Whenever we encounter XFS_IS_CORRUPT failures, we should report that to
the health monitoring system for later reporting.

I started with this semantic patch and massaged everything until it
built:

@@
expression mp, test;
@@

- if (XFS_IS_CORRUPT(mp, test)) return -EFSCORRUPTED;
+ if (XFS_IS_CORRUPT(mp, test)) { xfs_btree_mark_sick(cur); return -EFSCORRUPTED; }

@@
expression mp, test;
identifier label, error;
@@

- if (XFS_IS_CORRUPT(mp, test)) { error = -EFSCORRUPTED; goto label; }
+ if (XFS_IS_CORRUPT(mp, test)) { xfs_btree_mark_sick(cur); error = -EFSCORRUPTED; goto label; }

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c          |    4 +-
 fs/xfs/libxfs/xfs_alloc.c       |   97 +++++++++++++++++++++++++++++++++------
 fs/xfs/libxfs/xfs_attr_remote.c |    8 ++-
 fs/xfs/libxfs/xfs_bmap.c        |   82 +++++++++++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_btree.c       |   14 +++++-
 fs/xfs/libxfs/xfs_ialloc.c      |   52 +++++++++++++++++----
 fs/xfs/libxfs/xfs_refcount.c    |   37 ++++++++++++++-
 fs/xfs/libxfs/xfs_rmap.c        |   77 +++++++++++++++++++++++++++++--
 fs/xfs/scrub/refcount_repair.c  |    9 +++-
 fs/xfs/xfs_attr_list.c          |    9 +++-
 fs/xfs/xfs_dir2_readdir.c       |    7 ++-
 fs/xfs/xfs_discard.c            |    2 +
 fs/xfs/xfs_iwalk.c              |    5 ++
 13 files changed, 357 insertions(+), 46 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index a30eab622266..d98ac1a997d9 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -871,8 +871,10 @@ xfs_ag_shrink_space(
 	agf = agfbp->b_addr;
 	aglen = be32_to_cpu(agi->agi_length);
 	/* some extra paranoid checks before we shrink the ag */
-	if (XFS_IS_CORRUPT(mp, agf->agf_length != agi->agi_length))
+	if (XFS_IS_CORRUPT(mp, agf->agf_length != agi->agi_length)) {
+		xfs_ag_mark_sick(pag, XFS_SICK_AG_AGF);
 		return -EFSCORRUPTED;
+	}
 	if (delta >= aglen)
 		return -EINVAL;
 
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 06562746fa75..550d0e3c8528 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -511,14 +511,18 @@ xfs_alloc_fixup_trees(
 		if (XFS_IS_CORRUPT(mp,
 				   i != 1 ||
 				   nfbno1 != fbno ||
-				   nflen1 != flen))
+				   nflen1 != flen)) {
+			xfs_btree_mark_sick(cnt_cur);
 			return -EFSCORRUPTED;
+		}
 #endif
 	} else {
 		if ((error = xfs_alloc_lookup_eq(cnt_cur, fbno, flen, &i)))
 			return error;
-		if (XFS_IS_CORRUPT(mp, i != 1))
+		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cnt_cur);
 			return -EFSCORRUPTED;
+		}
 	}
 	/*
 	 * Look up the record in the by-block tree if necessary.
@@ -530,14 +534,18 @@ xfs_alloc_fixup_trees(
 		if (XFS_IS_CORRUPT(mp,
 				   i != 1 ||
 				   nfbno1 != fbno ||
-				   nflen1 != flen))
+				   nflen1 != flen)) {
+			xfs_btree_mark_sick(bno_cur);
 			return -EFSCORRUPTED;
+		}
 #endif
 	} else {
 		if ((error = xfs_alloc_lookup_eq(bno_cur, fbno, flen, &i)))
 			return error;
-		if (XFS_IS_CORRUPT(mp, i != 1))
+		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(bno_cur);
 			return -EFSCORRUPTED;
+		}
 	}
 
 #ifdef DEBUG
@@ -550,8 +558,10 @@ xfs_alloc_fixup_trees(
 
 		if (XFS_IS_CORRUPT(mp,
 				   bnoblock->bb_numrecs !=
-				   cntblock->bb_numrecs))
+				   cntblock->bb_numrecs)) {
+			xfs_btree_mark_sick(bno_cur);
 			return -EFSCORRUPTED;
+		}
 	}
 #endif
 
@@ -581,30 +591,40 @@ xfs_alloc_fixup_trees(
 	 */
 	if ((error = xfs_btree_delete(cnt_cur, &i)))
 		return error;
-	if (XFS_IS_CORRUPT(mp, i != 1))
+	if (XFS_IS_CORRUPT(mp, i != 1)) {
+		xfs_btree_mark_sick(cnt_cur);
 		return -EFSCORRUPTED;
+	}
 	/*
 	 * Add new by-size btree entry(s).
 	 */
 	if (nfbno1 != NULLAGBLOCK) {
 		if ((error = xfs_alloc_lookup_eq(cnt_cur, nfbno1, nflen1, &i)))
 			return error;
-		if (XFS_IS_CORRUPT(mp, i != 0))
+		if (XFS_IS_CORRUPT(mp, i != 0)) {
+			xfs_btree_mark_sick(cnt_cur);
 			return -EFSCORRUPTED;
+		}
 		if ((error = xfs_btree_insert(cnt_cur, &i)))
 			return error;
-		if (XFS_IS_CORRUPT(mp, i != 1))
+		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cnt_cur);
 			return -EFSCORRUPTED;
+		}
 	}
 	if (nfbno2 != NULLAGBLOCK) {
 		if ((error = xfs_alloc_lookup_eq(cnt_cur, nfbno2, nflen2, &i)))
 			return error;
-		if (XFS_IS_CORRUPT(mp, i != 0))
+		if (XFS_IS_CORRUPT(mp, i != 0)) {
+			xfs_btree_mark_sick(cnt_cur);
 			return -EFSCORRUPTED;
+		}
 		if ((error = xfs_btree_insert(cnt_cur, &i)))
 			return error;
-		if (XFS_IS_CORRUPT(mp, i != 1))
+		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cnt_cur);
 			return -EFSCORRUPTED;
+		}
 	}
 	/*
 	 * Fix up the by-block btree entry(s).
@@ -615,8 +635,10 @@ xfs_alloc_fixup_trees(
 		 */
 		if ((error = xfs_btree_delete(bno_cur, &i)))
 			return error;
-		if (XFS_IS_CORRUPT(mp, i != 1))
+		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(bno_cur);
 			return -EFSCORRUPTED;
+		}
 	} else {
 		/*
 		 * Update the by-block entry to start later|be shorter.
@@ -630,12 +652,16 @@ xfs_alloc_fixup_trees(
 		 */
 		if ((error = xfs_alloc_lookup_eq(bno_cur, nfbno2, nflen2, &i)))
 			return error;
-		if (XFS_IS_CORRUPT(mp, i != 0))
+		if (XFS_IS_CORRUPT(mp, i != 0)) {
+			xfs_btree_mark_sick(bno_cur);
 			return -EFSCORRUPTED;
+		}
 		if ((error = xfs_btree_insert(bno_cur, &i)))
 			return error;
-		if (XFS_IS_CORRUPT(mp, i != 1))
+		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(bno_cur);
 			return -EFSCORRUPTED;
+		}
 	}
 	return 0;
 }
@@ -897,8 +923,10 @@ xfs_alloc_cur_check(
 	error = xfs_alloc_get_rec(cur, &bno, &len, &i);
 	if (error)
 		return error;
-	if (XFS_IS_CORRUPT(args->mp, i != 1))
+	if (XFS_IS_CORRUPT(args->mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
+	}
 
 	/*
 	 * Check minlen and deactivate a cntbt cursor if out of acceptable size
@@ -1105,6 +1133,7 @@ xfs_alloc_ag_vextent_small(
 		if (error)
 			goto error;
 		if (XFS_IS_CORRUPT(args->mp, i != 1)) {
+			xfs_btree_mark_sick(ccur);
 			error = -EFSCORRUPTED;
 			goto error;
 		}
@@ -1139,6 +1168,7 @@ xfs_alloc_ag_vextent_small(
 	*fbnop = args->agbno = fbno;
 	*flenp = args->len = 1;
 	if (XFS_IS_CORRUPT(args->mp, fbno >= be32_to_cpu(agf->agf_length))) {
+		xfs_btree_mark_sick(ccur);
 		error = -EFSCORRUPTED;
 		goto error;
 	}
@@ -1297,6 +1327,7 @@ xfs_alloc_ag_vextent_exact(
 	if (error)
 		goto error0;
 	if (XFS_IS_CORRUPT(args->mp, i != 1)) {
+		xfs_btree_mark_sick(bno_cur);
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
@@ -1577,8 +1608,10 @@ xfs_alloc_ag_vextent_lastblock(
 			error = xfs_alloc_get_rec(acur->cnt, bno, len, &i);
 			if (error)
 				return error;
-			if (XFS_IS_CORRUPT(args->mp, i != 1))
+			if (XFS_IS_CORRUPT(args->mp, i != 1)) {
+				xfs_btree_mark_sick(acur->cnt);
 				return -EFSCORRUPTED;
+			}
 			if (*len >= args->minlen)
 				break;
 			error = xfs_btree_increment(acur->cnt, 0, &i);
@@ -1773,6 +1806,7 @@ xfs_alloc_ag_vextent_size(
 			if (error)
 				goto error0;
 			if (XFS_IS_CORRUPT(args->mp, i != 1)) {
+				xfs_btree_mark_sick(cnt_cur);
 				error = -EFSCORRUPTED;
 				goto error0;
 			}
@@ -1813,6 +1847,7 @@ xfs_alloc_ag_vextent_size(
 			   rlen != 0 &&
 			   (rlen > flen ||
 			    rbno + rlen > fbno + flen))) {
+		xfs_btree_mark_sick(cnt_cur);
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
@@ -1835,6 +1870,7 @@ xfs_alloc_ag_vextent_size(
 					&i)))
 				goto error0;
 			if (XFS_IS_CORRUPT(args->mp, i != 1)) {
+				xfs_btree_mark_sick(cnt_cur);
 				error = -EFSCORRUPTED;
 				goto error0;
 			}
@@ -1847,6 +1883,7 @@ xfs_alloc_ag_vextent_size(
 					   rlen != 0 &&
 					   (rlen > flen ||
 					    rbno + rlen > fbno + flen))) {
+				xfs_btree_mark_sick(cnt_cur);
 				error = -EFSCORRUPTED;
 				goto error0;
 			}
@@ -1863,6 +1900,7 @@ xfs_alloc_ag_vextent_size(
 				&i)))
 			goto error0;
 		if (XFS_IS_CORRUPT(args->mp, i != 1)) {
+			xfs_btree_mark_sick(cnt_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -1889,6 +1927,7 @@ xfs_alloc_ag_vextent_size(
 
 	rlen = args->len;
 	if (XFS_IS_CORRUPT(args->mp, rlen > flen)) {
+		xfs_btree_mark_sick(cnt_cur);
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
@@ -1908,6 +1947,7 @@ xfs_alloc_ag_vextent_size(
 	if (XFS_IS_CORRUPT(args->mp,
 			   args->agbno + args->len >
 			   be32_to_cpu(agf->agf_length))) {
+		xfs_ag_mark_sick(args->pag, XFS_SICK_AG_BNOBT);
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
@@ -1983,6 +2023,7 @@ xfs_free_ag_extent(
 		if ((error = xfs_alloc_get_rec(bno_cur, &ltbno, &ltlen, &i)))
 			goto error0;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(bno_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -1998,6 +2039,7 @@ xfs_free_ag_extent(
 			 * Very bad.
 			 */
 			if (XFS_IS_CORRUPT(mp, ltbno + ltlen > bno)) {
+				xfs_btree_mark_sick(bno_cur);
 				error = -EFSCORRUPTED;
 				goto error0;
 			}
@@ -2016,6 +2058,7 @@ xfs_free_ag_extent(
 		if ((error = xfs_alloc_get_rec(bno_cur, &gtbno, &gtlen, &i)))
 			goto error0;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(bno_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -2031,6 +2074,7 @@ xfs_free_ag_extent(
 			 * Very bad.
 			 */
 			if (XFS_IS_CORRUPT(mp, bno + len > gtbno)) {
+				xfs_btree_mark_sick(bno_cur);
 				error = -EFSCORRUPTED;
 				goto error0;
 			}
@@ -2051,12 +2095,14 @@ xfs_free_ag_extent(
 		if ((error = xfs_alloc_lookup_eq(cnt_cur, ltbno, ltlen, &i)))
 			goto error0;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cnt_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
 		if ((error = xfs_btree_delete(cnt_cur, &i)))
 			goto error0;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cnt_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -2066,12 +2112,14 @@ xfs_free_ag_extent(
 		if ((error = xfs_alloc_lookup_eq(cnt_cur, gtbno, gtlen, &i)))
 			goto error0;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cnt_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
 		if ((error = xfs_btree_delete(cnt_cur, &i)))
 			goto error0;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cnt_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -2081,6 +2129,7 @@ xfs_free_ag_extent(
 		if ((error = xfs_btree_delete(bno_cur, &i)))
 			goto error0;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(bno_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -2090,6 +2139,7 @@ xfs_free_ag_extent(
 		if ((error = xfs_btree_decrement(bno_cur, 0, &i)))
 			goto error0;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(bno_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -2109,6 +2159,7 @@ xfs_free_ag_extent(
 					   i != 1 ||
 					   xxbno != ltbno ||
 					   xxlen != ltlen)) {
+				xfs_btree_mark_sick(bno_cur);
 				error = -EFSCORRUPTED;
 				goto error0;
 			}
@@ -2133,12 +2184,14 @@ xfs_free_ag_extent(
 		if ((error = xfs_alloc_lookup_eq(cnt_cur, ltbno, ltlen, &i)))
 			goto error0;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cnt_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
 		if ((error = xfs_btree_delete(cnt_cur, &i)))
 			goto error0;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cnt_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -2149,6 +2202,7 @@ xfs_free_ag_extent(
 		if ((error = xfs_btree_decrement(bno_cur, 0, &i)))
 			goto error0;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(bno_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -2168,12 +2222,14 @@ xfs_free_ag_extent(
 		if ((error = xfs_alloc_lookup_eq(cnt_cur, gtbno, gtlen, &i)))
 			goto error0;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cnt_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
 		if ((error = xfs_btree_delete(cnt_cur, &i)))
 			goto error0;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cnt_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -2196,6 +2252,7 @@ xfs_free_ag_extent(
 		if ((error = xfs_btree_insert(bno_cur, &i)))
 			goto error0;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(bno_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -2208,12 +2265,14 @@ xfs_free_ag_extent(
 	if ((error = xfs_alloc_lookup_eq(cnt_cur, nbno, nlen, &i)))
 		goto error0;
 	if (XFS_IS_CORRUPT(mp, i != 0)) {
+		xfs_btree_mark_sick(cnt_cur);
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
 	if ((error = xfs_btree_insert(cnt_cur, &i)))
 		goto error0;
 	if (XFS_IS_CORRUPT(mp, i != 1)) {
+		xfs_btree_mark_sick(cnt_cur);
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
@@ -3453,17 +3512,23 @@ __xfs_free_extent(
 		return -EIO;
 
 	error = xfs_free_extent_fix_freelist(tp, pag, &agbp);
-	if (error)
+	if (error) {
+		if (xfs_metadata_is_sick(error))
+			xfs_ag_mark_sick(pag, XFS_SICK_AG_BNOBT);
 		return error;
+	}
+
 	agf = agbp->b_addr;
 
 	if (XFS_IS_CORRUPT(mp, agbno >= mp->m_sb.sb_agblocks)) {
+		xfs_ag_mark_sick(pag, XFS_SICK_AG_BNOBT);
 		error = -EFSCORRUPTED;
 		goto err_release;
 	}
 
 	/* validate the extent size is legal now we have the agf locked */
 	if (XFS_IS_CORRUPT(mp, agbno + len > be32_to_cpu(agf->agf_length))) {
+		xfs_ag_mark_sick(pag, XFS_SICK_AG_BNOBT);
 		error = -EFSCORRUPTED;
 		goto err_release;
 	}
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index b18a3cf44192..bb4cf1fa0dc2 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -553,8 +553,10 @@ xfs_attr_rmtval_stale(
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
 	if (XFS_IS_CORRUPT(mp, map->br_startblock == DELAYSTARTBLOCK) ||
-	    XFS_IS_CORRUPT(mp, map->br_startblock == HOLESTARTBLOCK))
+	    XFS_IS_CORRUPT(mp, map->br_startblock == HOLESTARTBLOCK)) {
+		xfs_bmap_mark_sick(ip, XFS_ATTR_FORK);
 		return -EFSCORRUPTED;
+	}
 
 	error = xfs_buf_incore(mp->m_ddev_targp,
 			XFS_FSB_TO_DADDR(mp, map->br_startblock),
@@ -664,8 +666,10 @@ xfs_attr_rmtval_invalidate(
 				       blkcnt, &map, &nmap, XFS_BMAPI_ATTRFORK);
 		if (error)
 			return error;
-		if (XFS_IS_CORRUPT(args->dp->i_mount, nmap != 1))
+		if (XFS_IS_CORRUPT(args->dp->i_mount, nmap != 1)) {
+			xfs_bmap_mark_sick(args->dp, XFS_ATTR_FORK);
 			return -EFSCORRUPTED;
+		}
 		error = xfs_attr_rmtval_stale(args->dp, &map, XBF_TRYLOCK);
 		if (error)
 			return error;
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index de5d7b842145..b658373bedc7 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -386,6 +386,7 @@ xfs_bmap_check_leaf_extents(
 		pp = XFS_BMBT_PTR_ADDR(mp, block, 1, mp->m_bmap_dmxr[1]);
 		bno = be64_to_cpu(*pp);
 		if (XFS_IS_CORRUPT(mp, !xfs_verify_fsbno(mp, bno))) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -567,8 +568,10 @@ xfs_bmap_btree_to_extents(
 	pp = XFS_BMAP_BROOT_PTR_ADDR(mp, rblock, 1, ifp->if_broot_bytes);
 	cbno = be64_to_cpu(*pp);
 #ifdef DEBUG
-	if (XFS_IS_CORRUPT(cur->bc_mp, !xfs_btree_check_lptr(cur, cbno, 1)))
+	if (XFS_IS_CORRUPT(cur->bc_mp, !xfs_btree_check_lptr(cur, cbno, 1))) {
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
+	}
 #endif
 	error = xfs_btree_read_bufl(mp, tp, cbno, &cbp, XFS_BMAP_BTREE_REF,
 				&xfs_bmbt_buf_ops);
@@ -896,6 +899,7 @@ xfs_bmap_add_attrfork_btree(
 			goto error0;
 		/* must be at least one entry */
 		if (XFS_IS_CORRUPT(mp, stat != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -1222,6 +1226,7 @@ xfs_iread_extents(
 		goto out;
 
 	if (XFS_IS_CORRUPT(mp, ir.loaded != ifp->if_nextents)) {
+		xfs_bmap_mark_sick(ip, whichfork);
 		error = -EFSCORRUPTED;
 		goto out;
 	}
@@ -1406,8 +1411,10 @@ xfs_bmap_last_offset(
 	if (ifp->if_format == XFS_DINODE_FMT_LOCAL)
 		return 0;
 
-	if (XFS_IS_CORRUPT(ip->i_mount, !xfs_ifork_has_extents(ifp)))
+	if (XFS_IS_CORRUPT(ip->i_mount, !xfs_ifork_has_extents(ifp))) {
+		xfs_bmap_mark_sick(ip, whichfork);
 		return -EFSCORRUPTED;
+	}
 
 	error = xfs_bmap_last_extent(NULL, ip, whichfork, &rec, &is_empty);
 	if (error || is_empty)
@@ -1546,6 +1553,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1553,6 +1561,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1560,6 +1569,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1589,6 +1599,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1622,6 +1633,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1650,6 +1662,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 0)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1657,6 +1670,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1691,6 +1705,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1716,6 +1731,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 0)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1723,6 +1739,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1767,6 +1784,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1803,6 +1821,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 0)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1810,6 +1829,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1889,6 +1909,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 0)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1896,6 +1917,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2092,30 +2114,35 @@ xfs_bmap_add_extent_unwritten_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
 			if ((error = xfs_btree_delete(cur, &i)))
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
 			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
 			if ((error = xfs_btree_delete(cur, &i)))
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
 			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2144,18 +2171,21 @@ xfs_bmap_add_extent_unwritten_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
 			if ((error = xfs_btree_delete(cur, &i)))
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
 			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2187,18 +2217,21 @@ xfs_bmap_add_extent_unwritten_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
 			if ((error = xfs_btree_delete(cur, &i)))
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
 			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2225,6 +2258,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2258,6 +2292,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2295,6 +2330,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2305,6 +2341,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2335,6 +2372,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2371,6 +2409,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2381,12 +2420,14 @@ xfs_bmap_add_extent_unwritten_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 0)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
 			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2423,6 +2464,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2435,6 +2477,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2447,6 +2490,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 0)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2454,6 +2498,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2739,6 +2784,7 @@ xfs_bmap_add_extent_hole_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2746,6 +2792,7 @@ xfs_bmap_add_extent_hole_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2753,6 +2800,7 @@ xfs_bmap_add_extent_hole_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2782,6 +2830,7 @@ xfs_bmap_add_extent_hole_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2812,6 +2861,7 @@ xfs_bmap_add_extent_hole_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2838,6 +2888,7 @@ xfs_bmap_add_extent_hole_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 0)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2845,6 +2896,7 @@ xfs_bmap_add_extent_hole_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -5135,6 +5187,7 @@ xfs_bmap_del_extent_real(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -5162,6 +5215,7 @@ xfs_bmap_del_extent_real(
 		if ((error = xfs_btree_delete(cur, &i)))
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -5237,6 +5291,7 @@ xfs_bmap_del_extent_real(
 				if (error)
 					goto done;
 				if (XFS_IS_CORRUPT(mp, i != 1)) {
+					xfs_btree_mark_sick(cur);
 					error = -EFSCORRUPTED;
 					goto done;
 				}
@@ -5257,6 +5312,7 @@ xfs_bmap_del_extent_real(
 				goto done;
 			}
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -5713,21 +5769,27 @@ xfs_bmse_merge(
 	error = xfs_bmbt_lookup_eq(cur, got, &i);
 	if (error)
 		return error;
-	if (XFS_IS_CORRUPT(mp, i != 1))
+	if (XFS_IS_CORRUPT(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
+	}
 
 	error = xfs_btree_delete(cur, &i);
 	if (error)
 		return error;
-	if (XFS_IS_CORRUPT(mp, i != 1))
+	if (XFS_IS_CORRUPT(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
+	}
 
 	/* lookup and update size of the previous extent */
 	error = xfs_bmbt_lookup_eq(cur, left, &i);
 	if (error)
 		return error;
-	if (XFS_IS_CORRUPT(mp, i != 1))
+	if (XFS_IS_CORRUPT(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
+	}
 
 	error = xfs_bmbt_update(cur, &new);
 	if (error)
@@ -5775,8 +5837,10 @@ xfs_bmap_shift_update_extent(
 		error = xfs_bmbt_lookup_eq(cur, &prev, &i);
 		if (error)
 			return error;
-		if (XFS_IS_CORRUPT(mp, i != 1))
+		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			return -EFSCORRUPTED;
+		}
 
 		error = xfs_bmbt_update(cur, got);
 		if (error)
@@ -5837,6 +5901,7 @@ xfs_bmap_collapse_extents(
 		goto del_cursor;
 	}
 	if (XFS_IS_CORRUPT(mp, isnullstartblock(got.br_startblock))) {
+		xfs_bmap_mark_sick(ip, whichfork);
 		error = -EFSCORRUPTED;
 		goto del_cursor;
 	}
@@ -5962,11 +6027,13 @@ xfs_bmap_insert_extents(
 		}
 	}
 	if (XFS_IS_CORRUPT(mp, isnullstartblock(got.br_startblock))) {
+		xfs_bmap_mark_sick(ip, whichfork);
 		error = -EFSCORRUPTED;
 		goto del_cursor;
 	}
 
 	if (XFS_IS_CORRUPT(mp, stop_fsb > got.br_startoff)) {
+		xfs_bmap_mark_sick(ip, whichfork);
 		error = -EFSCORRUPTED;
 		goto del_cursor;
 	}
@@ -6066,6 +6133,7 @@ xfs_bmap_split_extent(
 		if (error)
 			goto del_cursor;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto del_cursor;
 		}
@@ -6093,6 +6161,7 @@ xfs_bmap_split_extent(
 		if (error)
 			goto del_cursor;
 		if (XFS_IS_CORRUPT(mp, i != 0)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto del_cursor;
 		}
@@ -6100,6 +6169,7 @@ xfs_bmap_split_extent(
 		if (error)
 			goto del_cursor;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto del_cursor;
 		}
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 2f0e8450268f..02c237984fa6 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -2026,8 +2026,10 @@ xfs_btree_lookup(
 			error = xfs_btree_increment(cur, 0, &i);
 			if (error)
 				goto error0;
-			if (XFS_IS_CORRUPT(cur->bc_mp, i != 1))
+			if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				return -EFSCORRUPTED;
+			}
 			*stat = 1;
 			return 0;
 		}
@@ -2480,6 +2482,7 @@ xfs_btree_lshift(
 			goto error0;
 		i = xfs_btree_firstrec(tcur, level);
 		if (XFS_IS_CORRUPT(tcur->bc_mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -2650,6 +2653,7 @@ xfs_btree_rshift(
 		goto error0;
 	i = xfs_btree_lastrec(tcur, level);
 	if (XFS_IS_CORRUPT(tcur->bc_mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
@@ -3524,6 +3528,7 @@ xfs_btree_insert(
 		}
 
 		if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -3931,6 +3936,7 @@ xfs_btree_delrec(
 		 */
 		i = xfs_btree_lastrec(tcur, level);
 		if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -3939,12 +3945,14 @@ xfs_btree_delrec(
 		if (error)
 			goto error0;
 		if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
 
 		i = xfs_btree_lastrec(tcur, level);
 		if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -3992,6 +4000,7 @@ xfs_btree_delrec(
 		if (!xfs_btree_ptr_is_null(cur, &lptr)) {
 			i = xfs_btree_firstrec(tcur, level);
 			if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto error0;
 			}
@@ -4000,6 +4009,7 @@ xfs_btree_delrec(
 			if (error)
 				goto error0;
 			if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto error0;
 			}
@@ -4017,6 +4027,7 @@ xfs_btree_delrec(
 		 */
 		i = xfs_btree_firstrec(tcur, level);
 		if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -4026,6 +4037,7 @@ xfs_btree_delrec(
 			goto error0;
 		i = xfs_btree_firstrec(tcur, level);
 		if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index ddfe365666ba..ecf53198907f 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -584,6 +584,7 @@ xfs_inobt_insert_sprec(
 		if (error)
 			goto error;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error;
 		}
@@ -600,10 +601,12 @@ xfs_inobt_insert_sprec(
 		if (error)
 			goto error;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error;
 		}
 		if (XFS_IS_CORRUPT(mp, rec.ir_startino != nrec->ir_startino)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error;
 		}
@@ -613,6 +616,7 @@ xfs_inobt_insert_sprec(
 		 * cannot merge, something is seriously wrong.
 		 */
 		if (XFS_IS_CORRUPT(mp, !__xfs_inobt_can_merge(nrec, &rec))) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error;
 		}
@@ -966,8 +970,10 @@ xfs_ialloc_next_rec(
 		error = xfs_inobt_get_rec(cur, rec, &i);
 		if (error)
 			return error;
-		if (XFS_IS_CORRUPT(cur->bc_mp, i != 1))
+		if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			return -EFSCORRUPTED;
+		}
 	}
 
 	return 0;
@@ -991,8 +997,10 @@ xfs_ialloc_get_rec(
 		error = xfs_inobt_get_rec(cur, rec, &i);
 		if (error)
 			return error;
-		if (XFS_IS_CORRUPT(cur->bc_mp, i != 1))
+		if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			return -EFSCORRUPTED;
+		}
 	}
 
 	return 0;
@@ -1070,6 +1078,7 @@ xfs_dialloc_ag_inobt(
 		if (error)
 			goto error0;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -1078,6 +1087,7 @@ xfs_dialloc_ag_inobt(
 		if (error)
 			goto error0;
 		if (XFS_IS_CORRUPT(mp, j != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -1236,6 +1246,7 @@ xfs_dialloc_ag_inobt(
 	if (error)
 		goto error0;
 	if (XFS_IS_CORRUPT(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
@@ -1245,6 +1256,7 @@ xfs_dialloc_ag_inobt(
 		if (error)
 			goto error0;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -1254,6 +1266,7 @@ xfs_dialloc_ag_inobt(
 		if (error)
 			goto error0;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -1314,8 +1327,10 @@ xfs_dialloc_ag_finobt_near(
 		error = xfs_inobt_get_rec(lcur, rec, &i);
 		if (error)
 			return error;
-		if (XFS_IS_CORRUPT(lcur->bc_mp, i != 1))
+		if (XFS_IS_CORRUPT(lcur->bc_mp, i != 1)) {
+			xfs_btree_mark_sick(lcur);
 			return -EFSCORRUPTED;
+		}
 
 		/*
 		 * See if we've landed in the parent inode record. The finobt
@@ -1339,12 +1354,14 @@ xfs_dialloc_ag_finobt_near(
 		if (error)
 			goto error_rcur;
 		if (XFS_IS_CORRUPT(lcur->bc_mp, j != 1)) {
+			xfs_btree_mark_sick(lcur);
 			error = -EFSCORRUPTED;
 			goto error_rcur;
 		}
 	}
 
 	if (XFS_IS_CORRUPT(lcur->bc_mp, i != 1 && j != 1)) {
+		xfs_btree_mark_sick(lcur);
 		error = -EFSCORRUPTED;
 		goto error_rcur;
 	}
@@ -1400,8 +1417,10 @@ xfs_dialloc_ag_finobt_newino(
 			error = xfs_inobt_get_rec(cur, rec, &i);
 			if (error)
 				return error;
-			if (XFS_IS_CORRUPT(cur->bc_mp, i != 1))
+			if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				return -EFSCORRUPTED;
+			}
 			return 0;
 		}
 	}
@@ -1412,14 +1431,18 @@ xfs_dialloc_ag_finobt_newino(
 	error = xfs_inobt_lookup(cur, 0, XFS_LOOKUP_GE, &i);
 	if (error)
 		return error;
-	if (XFS_IS_CORRUPT(cur->bc_mp, i != 1))
+	if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
+	}
 
 	error = xfs_inobt_get_rec(cur, rec, &i);
 	if (error)
 		return error;
-	if (XFS_IS_CORRUPT(cur->bc_mp, i != 1))
+	if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
+	}
 
 	return 0;
 }
@@ -1441,14 +1464,18 @@ xfs_dialloc_ag_update_inobt(
 	error = xfs_inobt_lookup(cur, frec->ir_startino, XFS_LOOKUP_EQ, &i);
 	if (error)
 		return error;
-	if (XFS_IS_CORRUPT(cur->bc_mp, i != 1))
+	if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
+	}
 
 	error = xfs_inobt_get_rec(cur, &rec, &i);
 	if (error)
 		return error;
-	if (XFS_IS_CORRUPT(cur->bc_mp, i != 1))
+	if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
+	}
 	ASSERT((XFS_AGINO_TO_OFFSET(cur->bc_mp, rec.ir_startino) %
 				   XFS_INODES_PER_CHUNK) == 0);
 
@@ -1457,8 +1484,10 @@ xfs_dialloc_ag_update_inobt(
 
 	if (XFS_IS_CORRUPT(cur->bc_mp,
 			   rec.ir_free != frec->ir_free ||
-			   rec.ir_freecount != frec->ir_freecount))
+			   rec.ir_freecount != frec->ir_freecount)) {
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
+	}
 
 	return xfs_inobt_update(cur, &rec);
 }
@@ -1965,6 +1994,7 @@ xfs_difree_inobt(
 		goto error0;
 	}
 	if (XFS_IS_CORRUPT(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
@@ -1975,6 +2005,7 @@ xfs_difree_inobt(
 		goto error0;
 	}
 	if (XFS_IS_CORRUPT(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
@@ -2085,6 +2116,7 @@ xfs_difree_finobt(
 		 * something is out of sync.
 		 */
 		if (XFS_IS_CORRUPT(mp, ibtrec->ir_freecount != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error;
 		}
@@ -2111,6 +2143,7 @@ xfs_difree_finobt(
 	if (error)
 		goto error;
 	if (XFS_IS_CORRUPT(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto error;
 	}
@@ -2121,6 +2154,7 @@ xfs_difree_finobt(
 	if (XFS_IS_CORRUPT(mp,
 			   rec.ir_free != ibtrec->ir_free ||
 			   rec.ir_freecount != ibtrec->ir_freecount)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto error;
 	}
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index e8eda50a1ee1..ba329fa53a56 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -248,6 +248,7 @@ xfs_refcount_insert(
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, *i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -278,12 +279,14 @@ xfs_refcount_delete(
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
 	trace_xfs_refcount_delete(cur->bc_mp, cur->bc_ag.pag->pag_agno, &irec);
 	error = xfs_btree_delete(cur, i);
 	if (XFS_IS_CORRUPT(cur->bc_mp, *i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -408,6 +411,7 @@ xfs_refcount_split_extent(
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -435,6 +439,7 @@ xfs_refcount_split_extent(
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -480,6 +485,7 @@ xfs_refcount_merge_center_extents(
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -488,6 +494,7 @@ xfs_refcount_merge_center_extents(
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -497,6 +504,7 @@ xfs_refcount_merge_center_extents(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -508,6 +516,7 @@ xfs_refcount_merge_center_extents(
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -552,6 +561,7 @@ xfs_refcount_merge_left_extent(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -560,6 +570,7 @@ xfs_refcount_merge_left_extent(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -571,6 +582,7 @@ xfs_refcount_merge_left_extent(
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -618,6 +630,7 @@ xfs_refcount_merge_right_extent(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -626,6 +639,7 @@ xfs_refcount_merge_right_extent(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -637,6 +651,7 @@ xfs_refcount_merge_right_extent(
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -684,6 +699,7 @@ xfs_refcount_find_left_extents(
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -703,6 +719,7 @@ xfs_refcount_find_left_extents(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -777,6 +794,7 @@ xfs_refcount_find_right_extents(
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -796,6 +814,7 @@ xfs_refcount_find_right_extents(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -1152,6 +1171,7 @@ xfs_refcount_adjust_extents(
 					goto out_error;
 				if (XFS_IS_CORRUPT(cur->bc_mp,
 						   found_tmp != 1)) {
+					xfs_btree_mark_sick(cur);
 					error = -EFSCORRUPTED;
 					goto out_error;
 				}
@@ -1187,6 +1207,7 @@ xfs_refcount_adjust_extents(
 		 */
 		if (XFS_IS_CORRUPT(cur->bc_mp, ext.rc_blockcount == 0) ||
 		    XFS_IS_CORRUPT(cur->bc_mp, ext.rc_blockcount > *aglen)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -1210,6 +1231,7 @@ xfs_refcount_adjust_extents(
 			if (error)
 				goto out_error;
 			if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto out_error;
 			}
@@ -1331,8 +1353,10 @@ xfs_refcount_continue_op(
 	struct xfs_perag		*pag = cur->bc_ag.pag;
 
 	if (XFS_IS_CORRUPT(mp, !xfs_verify_agbext(pag, new_agbno,
-					ri->ri_blockcount)))
+					ri->ri_blockcount))) {
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
+	}
 
 	ri->ri_startblock = XFS_AGB_TO_FSB(mp, pag->pag_agno, new_agbno);
 
@@ -1539,6 +1563,7 @@ xfs_refcount_find_shared(
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -1556,6 +1581,7 @@ xfs_refcount_find_shared(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -1589,6 +1615,7 @@ xfs_refcount_find_shared(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -1686,6 +1713,7 @@ xfs_refcount_adjust_cow_extents(
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec &&
 				ext.rc_domain != XFS_REFC_DOMAIN_COW)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -1701,6 +1729,7 @@ xfs_refcount_adjust_cow_extents(
 		/* Adding a CoW reservation, there should be nothing here. */
 		if (XFS_IS_CORRUPT(cur->bc_mp,
 				   agbno + aglen > ext.rc_startblock)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -1718,6 +1747,7 @@ xfs_refcount_adjust_cow_extents(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(cur->bc_mp, found_tmp != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -1725,14 +1755,17 @@ xfs_refcount_adjust_cow_extents(
 	case XFS_REFCOUNT_ADJUST_COW_FREE:
 		/* Removing a CoW reservation, there should be one extent. */
 		if (XFS_IS_CORRUPT(cur->bc_mp, ext.rc_startblock != agbno)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
 		if (XFS_IS_CORRUPT(cur->bc_mp, ext.rc_blockcount != aglen)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
 		if (XFS_IS_CORRUPT(cur->bc_mp, ext.rc_refcount != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -1744,6 +1777,7 @@ xfs_refcount_adjust_cow_extents(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -1906,6 +1940,7 @@ xfs_refcount_recover_extent(
 	if (xfs_refcount_check_irec(cur, &rr->rr_rrec) != NULL ||
 	    XFS_IS_CORRUPT(cur->bc_mp,
 			   rr->rr_rrec.rc_domain != XFS_REFC_DOMAIN_COW)) {
+		xfs_btree_mark_sick(cur);
 		kfree(rr);
 		return -EFSCORRUPTED;
 	}
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 0d41d1256fd9..a30602660669 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -135,6 +135,7 @@ xfs_rmap_insert(
 	if (error)
 		goto done;
 	if (XFS_IS_CORRUPT(rcur->bc_mp, i != 0)) {
+		xfs_btree_mark_sick(rcur);
 		error = -EFSCORRUPTED;
 		goto done;
 	}
@@ -148,6 +149,7 @@ xfs_rmap_insert(
 	if (error)
 		goto done;
 	if (XFS_IS_CORRUPT(rcur->bc_mp, i != 1)) {
+		xfs_btree_mark_sick(rcur);
 		error = -EFSCORRUPTED;
 		goto done;
 	}
@@ -177,6 +179,7 @@ xfs_rmap_delete(
 	if (error)
 		goto done;
 	if (XFS_IS_CORRUPT(rcur->bc_mp, i != 1)) {
+		xfs_btree_mark_sick(rcur);
 		error = -EFSCORRUPTED;
 		goto done;
 	}
@@ -185,6 +188,7 @@ xfs_rmap_delete(
 	if (error)
 		goto done;
 	if (XFS_IS_CORRUPT(rcur->bc_mp, i != 1)) {
+		xfs_btree_mark_sick(rcur);
 		error = -EFSCORRUPTED;
 		goto done;
 	}
@@ -516,7 +520,7 @@ xfs_rmap_lookup_le_range(
  */
 static int
 xfs_rmap_free_check_owner(
-	struct xfs_mount	*mp,
+	struct xfs_btree_cur	*cur,
 	uint64_t		ltoff,
 	struct xfs_rmap_irec	*rec,
 	xfs_filblks_t		len,
@@ -524,6 +528,7 @@ xfs_rmap_free_check_owner(
 	uint64_t		offset,
 	unsigned int		flags)
 {
+	struct xfs_mount	*mp = cur->bc_mp;
 	int			error = 0;
 
 	if (owner == XFS_RMAP_OWN_UNKNOWN)
@@ -533,12 +538,14 @@ xfs_rmap_free_check_owner(
 	if (XFS_IS_CORRUPT(mp,
 			   (flags & XFS_RMAP_UNWRITTEN) !=
 			   (rec->rm_flags & XFS_RMAP_UNWRITTEN))) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out;
 	}
 
 	/* Make sure the owner matches what we expect to find in the tree. */
 	if (XFS_IS_CORRUPT(mp, owner != rec->rm_owner)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out;
 	}
@@ -550,16 +557,19 @@ xfs_rmap_free_check_owner(
 	if (flags & XFS_RMAP_BMBT_BLOCK) {
 		if (XFS_IS_CORRUPT(mp,
 				   !(rec->rm_flags & XFS_RMAP_BMBT_BLOCK))) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out;
 		}
 	} else {
 		if (XFS_IS_CORRUPT(mp, rec->rm_offset > offset)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out;
 		}
 		if (XFS_IS_CORRUPT(mp,
 				   offset + len > ltoff + rec->rm_blockcount)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out;
 		}
@@ -622,6 +632,7 @@ xfs_rmap_unmap(
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -643,6 +654,7 @@ xfs_rmap_unmap(
 		if (XFS_IS_CORRUPT(mp,
 				   bno <
 				   ltrec.rm_startblock + ltrec.rm_blockcount)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -669,6 +681,7 @@ xfs_rmap_unmap(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -681,12 +694,13 @@ xfs_rmap_unmap(
 			   ltrec.rm_startblock > bno ||
 			   ltrec.rm_startblock + ltrec.rm_blockcount <
 			   bno + len)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
 
 	/* Check owner information. */
-	error = xfs_rmap_free_check_owner(mp, ltoff, &ltrec, len, owner,
+	error = xfs_rmap_free_check_owner(cur, ltoff, &ltrec, len, owner,
 			offset, flags);
 	if (error)
 		goto out_error;
@@ -701,6 +715,7 @@ xfs_rmap_unmap(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -904,6 +919,7 @@ xfs_rmap_map(
 	if (XFS_IS_CORRUPT(mp,
 			   have_lt != 0 &&
 			   ltrec.rm_startblock + ltrec.rm_blockcount > bno)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -921,10 +937,12 @@ xfs_rmap_map(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(mp, have_gt != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
 		if (XFS_IS_CORRUPT(mp, bno + len > gtrec.rm_startblock)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -978,6 +996,7 @@ xfs_rmap_map(
 			if (error)
 				goto out_error;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto out_error;
 			}
@@ -1025,6 +1044,7 @@ xfs_rmap_map(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -1120,6 +1140,7 @@ xfs_rmap_convert(
 	if (error)
 		goto done;
 	if (XFS_IS_CORRUPT(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto done;
 	}
@@ -1157,12 +1178,14 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
 		if (XFS_IS_CORRUPT(mp,
 				   LEFT.rm_startblock + LEFT.rm_blockcount >
 				   bno)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1185,6 +1208,7 @@ xfs_rmap_convert(
 	if (error)
 		goto done;
 	if (XFS_IS_CORRUPT(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto done;
 	}
@@ -1197,10 +1221,12 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
 		if (XFS_IS_CORRUPT(mp, bno + len > RIGHT.rm_startblock)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1231,6 +1257,7 @@ xfs_rmap_convert(
 	if (error)
 		goto done;
 	if (XFS_IS_CORRUPT(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto done;
 	}
@@ -1250,6 +1277,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1261,6 +1289,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1268,6 +1297,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1279,6 +1309,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1286,6 +1317,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1309,6 +1341,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1316,6 +1349,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1335,6 +1369,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1346,6 +1381,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1353,6 +1389,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1423,6 +1460,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1465,6 +1503,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 0)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1480,6 +1519,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1513,6 +1553,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1526,6 +1567,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 0)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1538,6 +1580,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1610,6 +1653,7 @@ xfs_rmap_convert_shared(
 	if (error)
 		goto done;
 	if (XFS_IS_CORRUPT(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto done;
 	}
@@ -1638,6 +1682,7 @@ xfs_rmap_convert_shared(
 		if (XFS_IS_CORRUPT(mp,
 				   LEFT.rm_startblock + LEFT.rm_blockcount >
 				   bno)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1656,10 +1701,12 @@ xfs_rmap_convert_shared(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
 		if (XFS_IS_CORRUPT(mp, bno + len > RIGHT.rm_startblock)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1710,6 +1757,7 @@ xfs_rmap_convert_shared(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1736,6 +1784,7 @@ xfs_rmap_convert_shared(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1762,6 +1811,7 @@ xfs_rmap_convert_shared(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1785,6 +1835,7 @@ xfs_rmap_convert_shared(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1820,6 +1871,7 @@ xfs_rmap_convert_shared(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1865,6 +1917,7 @@ xfs_rmap_convert_shared(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1900,6 +1953,7 @@ xfs_rmap_convert_shared(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1938,6 +1992,7 @@ xfs_rmap_convert_shared(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -2027,6 +2082,7 @@ xfs_rmap_unmap_shared(
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -2037,12 +2093,14 @@ xfs_rmap_unmap_shared(
 			   ltrec.rm_startblock > bno ||
 			   ltrec.rm_startblock + ltrec.rm_blockcount <
 			   bno + len)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
 
 	/* Make sure the owner matches what we expect to find in the tree. */
 	if (XFS_IS_CORRUPT(mp, owner != ltrec.rm_owner)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -2051,16 +2109,19 @@ xfs_rmap_unmap_shared(
 	if (XFS_IS_CORRUPT(mp,
 			   (flags & XFS_RMAP_UNWRITTEN) !=
 			   (ltrec.rm_flags & XFS_RMAP_UNWRITTEN))) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
 
 	/* Check the offset. */
 	if (XFS_IS_CORRUPT(mp, ltrec.rm_offset > offset)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
 	if (XFS_IS_CORRUPT(mp, offset > ltoff + ltrec.rm_blockcount)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -2117,6 +2178,7 @@ xfs_rmap_unmap_shared(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -2146,6 +2208,7 @@ xfs_rmap_unmap_shared(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -2225,6 +2288,7 @@ xfs_rmap_map_shared(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(mp, have_gt != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -2277,6 +2341,7 @@ xfs_rmap_map_shared(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -2484,10 +2549,14 @@ xfs_rmap_finish_one(
 		 * allocate blocks.
 		 */
 		error = xfs_free_extent_fix_freelist(tp, ri->ri_pag, &agbp);
-		if (error)
+		if (error) {
+			xfs_ag_mark_sick(ri->ri_pag, XFS_SICK_AG_AGFL);
 			return error;
-		if (XFS_IS_CORRUPT(tp->t_mountp, !agbp))
+		}
+		if (XFS_IS_CORRUPT(tp->t_mountp, !agbp)) {
+			xfs_ag_mark_sick(ri->ri_pag, XFS_SICK_AG_AGFL);
 			return -EFSCORRUPTED;
+		}
 
 		rcur = xfs_rmapbt_init_cursor(mp, tp, agbp, ri->ri_pag);
 	}
diff --git a/fs/xfs/scrub/refcount_repair.c b/fs/xfs/scrub/refcount_repair.c
index d3f0384d084d..4bf48fbe5285 100644
--- a/fs/xfs/scrub/refcount_repair.c
+++ b/fs/xfs/scrub/refcount_repair.c
@@ -25,6 +25,7 @@
 #include "xfs_refcount_btree.h"
 #include "xfs_error.h"
 #include "xfs_ag.h"
+#include "xfs_health.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -252,8 +253,10 @@ xrep_refc_walk_rmaps(
 		error = xfs_rmap_get_rec(cur, &rmap, &have_gt);
 		if (error)
 			return error;
-		if (XFS_IS_CORRUPT(mp, !have_gt))
+		if (XFS_IS_CORRUPT(mp, !have_gt)) {
+			xfs_btree_mark_sick(cur);
 			return -EFSCORRUPTED;
+		}
 
 		if (rmap.rm_owner == XFS_RMAP_OWN_COW) {
 			error = xrep_refc_stash_cow(rr, rmap.rm_startblock,
@@ -424,8 +427,10 @@ xrep_refc_push_rmaps_at(
 	error = xfs_btree_decrement(sc->sa.rmap_cur, 0, &have_gt);
 	if (error)
 		return error;
-	if (XFS_IS_CORRUPT(sc->mp, !have_gt))
+	if (XFS_IS_CORRUPT(sc->mp, !have_gt)) {
+		xfs_btree_mark_sick(sc->sa.rmap_cur);
 		return -EFSCORRUPTED;
+	}
 
 	return 0;
 }
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 305559bfe2a1..dcfa8e8e146a 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -84,8 +84,10 @@ xfs_attr_shortform_list(
 		for (i = 0, sfe = &sf->list[0]; i < sf->hdr.count; i++) {
 			if (XFS_IS_CORRUPT(context->dp->i_mount,
 					   !xfs_attr_namecheck(sfe->nameval,
-							       sfe->namelen)))
+							       sfe->namelen))) {
+				xfs_dirattr_mark_sick(context->dp, XFS_ATTR_FORK);
 				return -EFSCORRUPTED;
+			}
 			context->put_listent(context,
 					     sfe->flags,
 					     sfe->nameval,
@@ -178,6 +180,7 @@ xfs_attr_shortform_list(
 		if (XFS_IS_CORRUPT(context->dp->i_mount,
 				   !xfs_attr_namecheck(sbp->name,
 						       sbp->namelen))) {
+			xfs_dirattr_mark_sick(context->dp, XFS_ATTR_FORK);
 			error = -EFSCORRUPTED;
 			goto out;
 		}
@@ -472,8 +475,10 @@ xfs_attr3_leaf_list_int(
 		}
 
 		if (XFS_IS_CORRUPT(context->dp->i_mount,
-				   !xfs_attr_namecheck(name, namelen)))
+				   !xfs_attr_namecheck(name, namelen))) {
+			xfs_dirattr_mark_sick(context->dp, XFS_ATTR_FORK);
 			return -EFSCORRUPTED;
+		}
 		context->put_listent(context, entry->flags,
 					      name, namelen, valuelen);
 		if (context->seen_enough)
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 9f3ceb461515..4c061b48da18 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -18,6 +18,7 @@
 #include "xfs_bmap.h"
 #include "xfs_trans.h"
 #include "xfs_error.h"
+#include "xfs_health.h"
 
 /*
  * Directory file type support functions
@@ -119,8 +120,10 @@ xfs_dir2_sf_getdents(
 		ctx->pos = off & 0x7fffffff;
 		if (XFS_IS_CORRUPT(dp->i_mount,
 				   !xfs_dir2_namecheck(sfep->name,
-						       sfep->namelen)))
+						       sfep->namelen))) {
+			xfs_dirattr_mark_sick(dp, XFS_DATA_FORK);
 			return -EFSCORRUPTED;
+		}
 		if (!dir_emit(ctx, (char *)sfep->name, sfep->namelen, ino,
 			    xfs_dir3_get_dtype(mp, filetype)))
 			return 0;
@@ -212,6 +215,7 @@ xfs_dir2_block_getdents(
 		if (XFS_IS_CORRUPT(dp->i_mount,
 				   !xfs_dir2_namecheck(dep->name,
 						       dep->namelen))) {
+			xfs_dirattr_mark_sick(dp, XFS_DATA_FORK);
 			error = -EFSCORRUPTED;
 			goto out_rele;
 		}
@@ -466,6 +470,7 @@ xfs_dir2_leaf_getdents(
 		if (XFS_IS_CORRUPT(dp->i_mount,
 				   !xfs_dir2_namecheck(dep->name,
 						       dep->namelen))) {
+			xfs_dirattr_mark_sick(dp, XFS_DATA_FORK);
 			error = -EFSCORRUPTED;
 			break;
 		}
diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index bfc829c07f03..3fa6b0ab9ed6 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -18,6 +18,7 @@
 #include "xfs_trace.h"
 #include "xfs_log.h"
 #include "xfs_ag.h"
+#include "xfs_health.h"
 
 STATIC int
 xfs_trim_extents(
@@ -73,6 +74,7 @@ xfs_trim_extents(
 		if (error)
 			goto out_del_cursor;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_del_cursor;
 		}
diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index 54a262b33244..9a8c7c0913a0 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -297,8 +297,10 @@ xfs_iwalk_ag_start(
 	error = xfs_inobt_get_rec(*curpp, irec, has_more);
 	if (error)
 		return error;
-	if (XFS_IS_CORRUPT(mp, *has_more != 1))
+	if (XFS_IS_CORRUPT(mp, *has_more != 1)) {
+		xfs_btree_mark_sick(*curpp);
 		return -EFSCORRUPTED;
+	}
 
 	iwag->lastino = XFS_AGINO_TO_INO(mp, pag->pag_agno,
 				irec->ir_startino + XFS_INODES_PER_CHUNK - 1);
@@ -425,6 +427,7 @@ xfs_iwalk_ag(
 		rec_fsino = XFS_AGINO_TO_INO(mp, pag->pag_agno, irec->ir_startino);
 		if (iwag->lastino != NULLFSINO &&
 		    XFS_IS_CORRUPT(mp, iwag->lastino >= rec_fsino)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out;
 		}

