Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 304761D53C
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711424081; cv=none; b=iajASuBnKGqOIkM6BDh0QgKgrFviP3zJ0jX0Ooz6HM5gxcJ1Ankc25nFeCi0lTwaFMds+cowprz0aYqlPZ6+rgl3GYty1CSn1LWO3fIls2eaU3LRnGf0wqju5qxmA6XGZTkNlEHWeNL00d08ylQRojTvcOd31uOvtaTrp4FSAAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711424081; c=relaxed/simple;
	bh=FwskUSYy/CeKESsnaqvKvfMVQEOULwpPDb4iwEbOoVs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rPUmf/ot2Fl/KnQnjE2Ag9mrGi8W8tu4AO8U7rcKqGE3Qo+NHCJpEmhDcDRVA07mpV6zss0DoryJFEFfWURHf4giLPIlgyenslLUPWL8rEwWubJq2Bg3LBzxOeduXSnn8tkqpP0t/ZlGd9iVe6FtdoUQ1lT81BVAM/kJVBRB8kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n6SWNN76; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n6SWNN76"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1861C433C7;
	Tue, 26 Mar 2024 03:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711424080;
	bh=FwskUSYy/CeKESsnaqvKvfMVQEOULwpPDb4iwEbOoVs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=n6SWNN761xt9bOPqeviDVszBZrOJpg17vuytbTwCiYvdMrQkJPHVtUlp0OdsCXNnk
	 ++lE5ctuuQvsEqPQFfyzE715nXNuzm/a/BroCWM7MWqXFF5zdLjHjAzD+2P/1+mkvU
	 QgHdlu+KTCNnhrePI0KGhRr9+X+fdjfv4nFzL7ic8IsMiSoyrhPexlikNlvo3ahDIr
	 x/dVv2rtJiSFsHkihIob3t7/Oo1+Jj4+6VAKtR1e4FTeT3y7vz6SSc/Uj+HMN1JNmx
	 I6r/Q1qAq1gF5BjGX9nRmHzwLkURsCMg7TkylMHisCFZU0TWk0KP25gxYGmOJNm8hU
	 8ROlvd1xd0YgA==
Date: Mon, 25 Mar 2024 20:34:40 -0700
Subject: [PATCH 024/110] xfs: report XFS_IS_CORRUPT errors to the health
 system
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142131730.2215168.18262422363066625043.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 989d5ec3175be7c0012d7744c667ae6a266fab06

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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_ag.c          |    4 +-
 libxfs/xfs_alloc.c       |   97 ++++++++++++++++++++++++++++++++++++++--------
 libxfs/xfs_attr_remote.c |    8 +++-
 libxfs/xfs_bmap.c        |   94 ++++++++++++++++++++++++++++++++++++++++-----
 libxfs/xfs_btree.c       |   14 ++++++-
 libxfs/xfs_ialloc.c      |   52 ++++++++++++++++++++-----
 libxfs/xfs_refcount.c    |   37 +++++++++++++++++-
 libxfs/xfs_rmap.c        |   77 +++++++++++++++++++++++++++++++++++--
 8 files changed, 339 insertions(+), 44 deletions(-)


diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index e001ac11ca85..b16f9c5c502d 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -949,8 +949,10 @@ xfs_ag_shrink_space(
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
 
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index aa084120c4c3..3d7686eadab2 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -495,14 +495,18 @@ xfs_alloc_fixup_trees(
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
@@ -514,14 +518,18 @@ xfs_alloc_fixup_trees(
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
@@ -534,8 +542,10 @@ xfs_alloc_fixup_trees(
 
 		if (XFS_IS_CORRUPT(mp,
 				   bnoblock->bb_numrecs !=
-				   cntblock->bb_numrecs))
+				   cntblock->bb_numrecs)) {
+			xfs_btree_mark_sick(bno_cur);
 			return -EFSCORRUPTED;
+		}
 	}
 #endif
 
@@ -565,30 +575,40 @@ xfs_alloc_fixup_trees(
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
@@ -599,8 +619,10 @@ xfs_alloc_fixup_trees(
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
@@ -614,12 +636,16 @@ xfs_alloc_fixup_trees(
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
@@ -892,8 +918,10 @@ xfs_alloc_cur_check(
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
@@ -1099,6 +1127,7 @@ xfs_alloc_ag_vextent_small(
 		if (error)
 			goto error;
 		if (XFS_IS_CORRUPT(args->mp, i != 1)) {
+			xfs_btree_mark_sick(ccur);
 			error = -EFSCORRUPTED;
 			goto error;
 		}
@@ -1133,6 +1162,7 @@ xfs_alloc_ag_vextent_small(
 	*fbnop = args->agbno = fbno;
 	*flenp = args->len = 1;
 	if (XFS_IS_CORRUPT(args->mp, fbno >= be32_to_cpu(agf->agf_length))) {
+		xfs_btree_mark_sick(ccur);
 		error = -EFSCORRUPTED;
 		goto error;
 	}
@@ -1219,6 +1249,7 @@ xfs_alloc_ag_vextent_exact(
 	if (error)
 		goto error0;
 	if (XFS_IS_CORRUPT(args->mp, i != 1)) {
+		xfs_btree_mark_sick(bno_cur);
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
@@ -1498,8 +1529,10 @@ xfs_alloc_ag_vextent_lastblock(
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
@@ -1711,6 +1744,7 @@ xfs_alloc_ag_vextent_size(
 			if (error)
 				goto error0;
 			if (XFS_IS_CORRUPT(args->mp, i != 1)) {
+				xfs_btree_mark_sick(cnt_cur);
 				error = -EFSCORRUPTED;
 				goto error0;
 			}
@@ -1757,6 +1791,7 @@ xfs_alloc_ag_vextent_size(
 			   rlen != 0 &&
 			   (rlen > flen ||
 			    rbno + rlen > fbno + flen))) {
+		xfs_btree_mark_sick(cnt_cur);
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
@@ -1779,6 +1814,7 @@ xfs_alloc_ag_vextent_size(
 					&i)))
 				goto error0;
 			if (XFS_IS_CORRUPT(args->mp, i != 1)) {
+				xfs_btree_mark_sick(cnt_cur);
 				error = -EFSCORRUPTED;
 				goto error0;
 			}
@@ -1791,6 +1827,7 @@ xfs_alloc_ag_vextent_size(
 					   rlen != 0 &&
 					   (rlen > flen ||
 					    rbno + rlen > fbno + flen))) {
+				xfs_btree_mark_sick(cnt_cur);
 				error = -EFSCORRUPTED;
 				goto error0;
 			}
@@ -1807,6 +1844,7 @@ xfs_alloc_ag_vextent_size(
 				&i)))
 			goto error0;
 		if (XFS_IS_CORRUPT(args->mp, i != 1)) {
+			xfs_btree_mark_sick(cnt_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -1845,6 +1883,7 @@ xfs_alloc_ag_vextent_size(
 
 	rlen = args->len;
 	if (XFS_IS_CORRUPT(args->mp, rlen > flen)) {
+		xfs_btree_mark_sick(cnt_cur);
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
@@ -1864,6 +1903,7 @@ xfs_alloc_ag_vextent_size(
 	if (XFS_IS_CORRUPT(args->mp,
 			   args->agbno + args->len >
 			   be32_to_cpu(agf->agf_length))) {
+		xfs_ag_mark_sick(args->pag, XFS_SICK_AG_BNOBT);
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
@@ -1939,6 +1979,7 @@ xfs_free_ag_extent(
 		if ((error = xfs_alloc_get_rec(bno_cur, &ltbno, &ltlen, &i)))
 			goto error0;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(bno_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -1954,6 +1995,7 @@ xfs_free_ag_extent(
 			 * Very bad.
 			 */
 			if (XFS_IS_CORRUPT(mp, ltbno + ltlen > bno)) {
+				xfs_btree_mark_sick(bno_cur);
 				error = -EFSCORRUPTED;
 				goto error0;
 			}
@@ -1972,6 +2014,7 @@ xfs_free_ag_extent(
 		if ((error = xfs_alloc_get_rec(bno_cur, &gtbno, &gtlen, &i)))
 			goto error0;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(bno_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -1987,6 +2030,7 @@ xfs_free_ag_extent(
 			 * Very bad.
 			 */
 			if (XFS_IS_CORRUPT(mp, bno + len > gtbno)) {
+				xfs_btree_mark_sick(bno_cur);
 				error = -EFSCORRUPTED;
 				goto error0;
 			}
@@ -2007,12 +2051,14 @@ xfs_free_ag_extent(
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
@@ -2022,12 +2068,14 @@ xfs_free_ag_extent(
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
@@ -2037,6 +2085,7 @@ xfs_free_ag_extent(
 		if ((error = xfs_btree_delete(bno_cur, &i)))
 			goto error0;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(bno_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -2046,6 +2095,7 @@ xfs_free_ag_extent(
 		if ((error = xfs_btree_decrement(bno_cur, 0, &i)))
 			goto error0;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(bno_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -2065,6 +2115,7 @@ xfs_free_ag_extent(
 					   i != 1 ||
 					   xxbno != ltbno ||
 					   xxlen != ltlen)) {
+				xfs_btree_mark_sick(bno_cur);
 				error = -EFSCORRUPTED;
 				goto error0;
 			}
@@ -2089,12 +2140,14 @@ xfs_free_ag_extent(
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
@@ -2105,6 +2158,7 @@ xfs_free_ag_extent(
 		if ((error = xfs_btree_decrement(bno_cur, 0, &i)))
 			goto error0;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(bno_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -2124,12 +2178,14 @@ xfs_free_ag_extent(
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
@@ -2152,6 +2208,7 @@ xfs_free_ag_extent(
 		if ((error = xfs_btree_insert(bno_cur, &i)))
 			goto error0;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(bno_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -2164,12 +2221,14 @@ xfs_free_ag_extent(
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
@@ -3899,17 +3958,23 @@ __xfs_free_extent(
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
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index a400a22d34a4..855d090c9e53 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -552,8 +552,10 @@ xfs_attr_rmtval_stale(
 	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
 
 	if (XFS_IS_CORRUPT(mp, map->br_startblock == DELAYSTARTBLOCK) ||
-	    XFS_IS_CORRUPT(mp, map->br_startblock == HOLESTARTBLOCK))
+	    XFS_IS_CORRUPT(mp, map->br_startblock == HOLESTARTBLOCK)) {
+		xfs_bmap_mark_sick(ip, XFS_ATTR_FORK);
 		return -EFSCORRUPTED;
+	}
 
 	error = xfs_buf_incore(mp->m_ddev_targp,
 			XFS_FSB_TO_DADDR(mp, map->br_startblock),
@@ -663,8 +665,10 @@ xfs_attr_rmtval_invalidate(
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
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index f15631818b3f..7d7486ca6fec 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -380,6 +380,7 @@ xfs_bmap_check_leaf_extents(
 		pp = XFS_BMBT_PTR_ADDR(mp, block, 1, mp->m_bmap_dmxr[1]);
 		bno = be64_to_cpu(*pp);
 		if (XFS_IS_CORRUPT(mp, !xfs_verify_fsbno(mp, bno))) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -561,8 +562,10 @@ xfs_bmap_btree_to_extents(
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
@@ -879,6 +882,7 @@ xfs_bmap_add_attrfork_btree(
 			goto error0;
 		/* must be at least one entry */
 		if (XFS_IS_CORRUPT(mp, stat != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -1205,6 +1209,7 @@ xfs_iread_extents(
 		goto out;
 
 	if (XFS_IS_CORRUPT(mp, ir.loaded != ifp->if_nextents)) {
+		xfs_bmap_mark_sick(ip, whichfork);
 		error = -EFSCORRUPTED;
 		goto out;
 	}
@@ -1395,8 +1400,10 @@ xfs_bmap_last_offset(
 	if (ifp->if_format == XFS_DINODE_FMT_LOCAL)
 		return 0;
 
-	if (XFS_IS_CORRUPT(ip->i_mount, !xfs_ifork_has_extents(ifp)))
+	if (XFS_IS_CORRUPT(ip->i_mount, !xfs_ifork_has_extents(ifp))) {
+		xfs_bmap_mark_sick(ip, whichfork);
 		return -EFSCORRUPTED;
+	}
 
 	error = xfs_bmap_last_extent(NULL, ip, whichfork, &rec, &is_empty);
 	if (error || is_empty)
@@ -1535,6 +1542,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1542,6 +1550,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1549,6 +1558,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1578,6 +1588,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1611,6 +1622,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1639,6 +1651,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 0)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1646,6 +1659,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1680,6 +1694,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1705,6 +1720,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 0)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1712,6 +1728,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1756,6 +1773,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1792,6 +1810,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 0)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1799,6 +1818,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1878,6 +1898,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 0)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1885,6 +1906,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2081,30 +2103,35 @@ xfs_bmap_add_extent_unwritten_real(
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
@@ -2133,18 +2160,21 @@ xfs_bmap_add_extent_unwritten_real(
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
@@ -2176,18 +2206,21 @@ xfs_bmap_add_extent_unwritten_real(
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
@@ -2214,6 +2247,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2247,6 +2281,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2284,6 +2319,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2294,6 +2330,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2324,6 +2361,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2360,6 +2398,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2370,12 +2409,14 @@ xfs_bmap_add_extent_unwritten_real(
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
@@ -2412,6 +2453,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2424,6 +2466,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2436,6 +2479,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 0)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2443,6 +2487,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2728,6 +2773,7 @@ xfs_bmap_add_extent_hole_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2735,6 +2781,7 @@ xfs_bmap_add_extent_hole_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2742,6 +2789,7 @@ xfs_bmap_add_extent_hole_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2771,6 +2819,7 @@ xfs_bmap_add_extent_hole_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2801,6 +2850,7 @@ xfs_bmap_add_extent_hole_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2827,6 +2877,7 @@ xfs_bmap_add_extent_hole_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 0)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2834,6 +2885,7 @@ xfs_bmap_add_extent_hole_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -5103,8 +5155,10 @@ xfs_bmap_del_extent_real(
 		error = xfs_bmbt_lookup_eq(cur, &got, &i);
 		if (error)
 			return error;
-		if (XFS_IS_CORRUPT(mp, i != 1))
+		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			return -EFSCORRUPTED;
+		}
 	}
 
 	if (got.br_startoff == del->br_startoff)
@@ -5128,8 +5182,10 @@ xfs_bmap_del_extent_real(
 		}
 		if ((error = xfs_btree_delete(cur, &i)))
 			return error;
-		if (XFS_IS_CORRUPT(mp, i != 1))
+		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			return -EFSCORRUPTED;
+		}
 		break;
 	case BMAP_LEFT_FILLING:
 		/*
@@ -5201,8 +5257,10 @@ xfs_bmap_del_extent_real(
 				error = xfs_bmbt_lookup_eq(cur, &got, &i);
 				if (error)
 					return error;
-				if (XFS_IS_CORRUPT(mp, i != 1))
+				if (XFS_IS_CORRUPT(mp, i != 1)) {
+					xfs_btree_mark_sick(cur);
 					return -EFSCORRUPTED;
+				}
 				/*
 				 * Update the btree record back
 				 * to the original value.
@@ -5218,8 +5276,10 @@ xfs_bmap_del_extent_real(
 				*logflagsp = 0;
 				return -ENOSPC;
 			}
-			if (XFS_IS_CORRUPT(mp, i != 1))
+			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				return -EFSCORRUPTED;
+			}
 		} else
 			*logflagsp |= xfs_ilog_fext(whichfork);
 
@@ -5673,21 +5733,27 @@ xfs_bmse_merge(
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
@@ -5735,8 +5801,10 @@ xfs_bmap_shift_update_extent(
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
@@ -5797,6 +5865,7 @@ xfs_bmap_collapse_extents(
 		goto del_cursor;
 	}
 	if (XFS_IS_CORRUPT(mp, isnullstartblock(got.br_startblock))) {
+		xfs_bmap_mark_sick(ip, whichfork);
 		error = -EFSCORRUPTED;
 		goto del_cursor;
 	}
@@ -5922,11 +5991,13 @@ xfs_bmap_insert_extents(
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
@@ -6026,6 +6097,7 @@ xfs_bmap_split_extent(
 		if (error)
 			goto del_cursor;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto del_cursor;
 		}
@@ -6053,6 +6125,7 @@ xfs_bmap_split_extent(
 		if (error)
 			goto del_cursor;
 		if (XFS_IS_CORRUPT(mp, i != 0)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto del_cursor;
 		}
@@ -6060,6 +6133,7 @@ xfs_bmap_split_extent(
 		if (error)
 			goto del_cursor;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto del_cursor;
 		}
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 359d3f99ecf3..b9af447ab69d 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -2023,8 +2023,10 @@ xfs_btree_lookup(
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
@@ -2477,6 +2479,7 @@ xfs_btree_lshift(
 			goto error0;
 		i = xfs_btree_firstrec(tcur, level);
 		if (XFS_IS_CORRUPT(tcur->bc_mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -2647,6 +2650,7 @@ xfs_btree_rshift(
 		goto error0;
 	i = xfs_btree_lastrec(tcur, level);
 	if (XFS_IS_CORRUPT(tcur->bc_mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
@@ -3535,6 +3539,7 @@ xfs_btree_insert(
 		}
 
 		if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -3942,6 +3947,7 @@ xfs_btree_delrec(
 		 */
 		i = xfs_btree_lastrec(tcur, level);
 		if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -3950,12 +3956,14 @@ xfs_btree_delrec(
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
@@ -4003,6 +4011,7 @@ xfs_btree_delrec(
 		if (!xfs_btree_ptr_is_null(cur, &lptr)) {
 			i = xfs_btree_firstrec(tcur, level);
 			if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto error0;
 			}
@@ -4011,6 +4020,7 @@ xfs_btree_delrec(
 			if (error)
 				goto error0;
 			if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto error0;
 			}
@@ -4028,6 +4038,7 @@ xfs_btree_delrec(
 		 */
 		i = xfs_btree_firstrec(tcur, level);
 		if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -4037,6 +4048,7 @@ xfs_btree_delrec(
 			goto error0;
 		i = xfs_btree_firstrec(tcur, level);
 		if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 63922f44ffe7..21577a50f655 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -568,6 +568,7 @@ xfs_inobt_insert_sprec(
 		if (error)
 			goto error;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error;
 		}
@@ -584,10 +585,12 @@ xfs_inobt_insert_sprec(
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
@@ -597,6 +600,7 @@ xfs_inobt_insert_sprec(
 		 * cannot merge, something is seriously wrong.
 		 */
 		if (XFS_IS_CORRUPT(mp, !__xfs_inobt_can_merge(nrec, &rec))) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error;
 		}
@@ -946,8 +950,10 @@ xfs_ialloc_next_rec(
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
@@ -971,8 +977,10 @@ xfs_ialloc_get_rec(
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
@@ -1050,6 +1058,7 @@ xfs_dialloc_ag_inobt(
 		if (error)
 			goto error0;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -1058,6 +1067,7 @@ xfs_dialloc_ag_inobt(
 		if (error)
 			goto error0;
 		if (XFS_IS_CORRUPT(mp, j != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -1216,6 +1226,7 @@ xfs_dialloc_ag_inobt(
 	if (error)
 		goto error0;
 	if (XFS_IS_CORRUPT(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
@@ -1225,6 +1236,7 @@ xfs_dialloc_ag_inobt(
 		if (error)
 			goto error0;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -1234,6 +1246,7 @@ xfs_dialloc_ag_inobt(
 		if (error)
 			goto error0;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -1294,8 +1307,10 @@ xfs_dialloc_ag_finobt_near(
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
@@ -1319,12 +1334,14 @@ xfs_dialloc_ag_finobt_near(
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
@@ -1380,8 +1397,10 @@ xfs_dialloc_ag_finobt_newino(
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
@@ -1392,14 +1411,18 @@ xfs_dialloc_ag_finobt_newino(
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
@@ -1421,14 +1444,18 @@ xfs_dialloc_ag_update_inobt(
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
 
@@ -1437,8 +1464,10 @@ xfs_dialloc_ag_update_inobt(
 
 	if (XFS_IS_CORRUPT(cur->bc_mp,
 			   rec.ir_free != frec->ir_free ||
-			   rec.ir_freecount != frec->ir_freecount))
+			   rec.ir_freecount != frec->ir_freecount)) {
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
+	}
 
 	return xfs_inobt_update(cur, &rec);
 }
@@ -1955,6 +1984,7 @@ xfs_difree_inobt(
 		goto error0;
 	}
 	if (XFS_IS_CORRUPT(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
@@ -1965,6 +1995,7 @@ xfs_difree_inobt(
 		goto error0;
 	}
 	if (XFS_IS_CORRUPT(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
@@ -2077,6 +2108,7 @@ xfs_difree_finobt(
 		 * something is out of sync.
 		 */
 		if (XFS_IS_CORRUPT(mp, ibtrec->ir_freecount != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error;
 		}
@@ -2103,6 +2135,7 @@ xfs_difree_finobt(
 	if (error)
 		goto error;
 	if (XFS_IS_CORRUPT(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto error;
 	}
@@ -2113,6 +2146,7 @@ xfs_difree_finobt(
 	if (XFS_IS_CORRUPT(mp,
 			   rec.ir_free != ibtrec->ir_free ||
 			   rec.ir_freecount != ibtrec->ir_freecount)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto error;
 	}
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 00df1e64ac6c..d0d0d86174a1 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -239,6 +239,7 @@ xfs_refcount_insert(
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, *i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -269,12 +270,14 @@ xfs_refcount_delete(
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
@@ -399,6 +402,7 @@ xfs_refcount_split_extent(
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -426,6 +430,7 @@ xfs_refcount_split_extent(
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -471,6 +476,7 @@ xfs_refcount_merge_center_extents(
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -479,6 +485,7 @@ xfs_refcount_merge_center_extents(
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -488,6 +495,7 @@ xfs_refcount_merge_center_extents(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -499,6 +507,7 @@ xfs_refcount_merge_center_extents(
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -543,6 +552,7 @@ xfs_refcount_merge_left_extent(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -551,6 +561,7 @@ xfs_refcount_merge_left_extent(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -562,6 +573,7 @@ xfs_refcount_merge_left_extent(
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -609,6 +621,7 @@ xfs_refcount_merge_right_extent(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -617,6 +630,7 @@ xfs_refcount_merge_right_extent(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -628,6 +642,7 @@ xfs_refcount_merge_right_extent(
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -675,6 +690,7 @@ xfs_refcount_find_left_extents(
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -694,6 +710,7 @@ xfs_refcount_find_left_extents(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -768,6 +785,7 @@ xfs_refcount_find_right_extents(
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -787,6 +805,7 @@ xfs_refcount_find_right_extents(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -1143,6 +1162,7 @@ xfs_refcount_adjust_extents(
 					goto out_error;
 				if (XFS_IS_CORRUPT(cur->bc_mp,
 						   found_tmp != 1)) {
+					xfs_btree_mark_sick(cur);
 					error = -EFSCORRUPTED;
 					goto out_error;
 				}
@@ -1181,6 +1201,7 @@ xfs_refcount_adjust_extents(
 		 */
 		if (XFS_IS_CORRUPT(cur->bc_mp, ext.rc_blockcount == 0) ||
 		    XFS_IS_CORRUPT(cur->bc_mp, ext.rc_blockcount > *aglen)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -1204,6 +1225,7 @@ xfs_refcount_adjust_extents(
 			if (error)
 				goto out_error;
 			if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto out_error;
 			}
@@ -1328,8 +1350,10 @@ xfs_refcount_continue_op(
 	struct xfs_perag		*pag = cur->bc_ag.pag;
 
 	if (XFS_IS_CORRUPT(mp, !xfs_verify_agbext(pag, new_agbno,
-					ri->ri_blockcount)))
+					ri->ri_blockcount))) {
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
+	}
 
 	ri->ri_startblock = XFS_AGB_TO_FSB(mp, pag->pag_agno, new_agbno);
 
@@ -1536,6 +1560,7 @@ xfs_refcount_find_shared(
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -1553,6 +1578,7 @@ xfs_refcount_find_shared(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -1586,6 +1612,7 @@ xfs_refcount_find_shared(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -1683,6 +1710,7 @@ xfs_refcount_adjust_cow_extents(
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec &&
 				ext.rc_domain != XFS_REFC_DOMAIN_COW)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -1698,6 +1726,7 @@ xfs_refcount_adjust_cow_extents(
 		/* Adding a CoW reservation, there should be nothing here. */
 		if (XFS_IS_CORRUPT(cur->bc_mp,
 				   agbno + aglen > ext.rc_startblock)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -1715,6 +1744,7 @@ xfs_refcount_adjust_cow_extents(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(cur->bc_mp, found_tmp != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -1722,14 +1752,17 @@ xfs_refcount_adjust_cow_extents(
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
@@ -1741,6 +1774,7 @@ xfs_refcount_adjust_cow_extents(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -1903,6 +1937,7 @@ xfs_refcount_recover_extent(
 	if (xfs_refcount_check_irec(cur->bc_ag.pag, &rr->rr_rrec) != NULL ||
 	    XFS_IS_CORRUPT(cur->bc_mp,
 			   rr->rr_rrec.rc_domain != XFS_REFC_DOMAIN_COW)) {
+		xfs_btree_mark_sick(cur);
 		kfree(rr);
 		return -EFSCORRUPTED;
 	}
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 8fbc9583de74..2d96cb60c225 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -134,6 +134,7 @@ xfs_rmap_insert(
 	if (error)
 		goto done;
 	if (XFS_IS_CORRUPT(rcur->bc_mp, i != 0)) {
+		xfs_btree_mark_sick(rcur);
 		error = -EFSCORRUPTED;
 		goto done;
 	}
@@ -147,6 +148,7 @@ xfs_rmap_insert(
 	if (error)
 		goto done;
 	if (XFS_IS_CORRUPT(rcur->bc_mp, i != 1)) {
+		xfs_btree_mark_sick(rcur);
 		error = -EFSCORRUPTED;
 		goto done;
 	}
@@ -176,6 +178,7 @@ xfs_rmap_delete(
 	if (error)
 		goto done;
 	if (XFS_IS_CORRUPT(rcur->bc_mp, i != 1)) {
+		xfs_btree_mark_sick(rcur);
 		error = -EFSCORRUPTED;
 		goto done;
 	}
@@ -184,6 +187,7 @@ xfs_rmap_delete(
 	if (error)
 		goto done;
 	if (XFS_IS_CORRUPT(rcur->bc_mp, i != 1)) {
+		xfs_btree_mark_sick(rcur);
 		error = -EFSCORRUPTED;
 		goto done;
 	}
@@ -515,7 +519,7 @@ xfs_rmap_lookup_le_range(
  */
 static int
 xfs_rmap_free_check_owner(
-	struct xfs_mount	*mp,
+	struct xfs_btree_cur	*cur,
 	uint64_t		ltoff,
 	struct xfs_rmap_irec	*rec,
 	xfs_filblks_t		len,
@@ -523,6 +527,7 @@ xfs_rmap_free_check_owner(
 	uint64_t		offset,
 	unsigned int		flags)
 {
+	struct xfs_mount	*mp = cur->bc_mp;
 	int			error = 0;
 
 	if (owner == XFS_RMAP_OWN_UNKNOWN)
@@ -532,12 +537,14 @@ xfs_rmap_free_check_owner(
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
@@ -549,16 +556,19 @@ xfs_rmap_free_check_owner(
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
@@ -621,6 +631,7 @@ xfs_rmap_unmap(
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -642,6 +653,7 @@ xfs_rmap_unmap(
 		if (XFS_IS_CORRUPT(mp,
 				   bno <
 				   ltrec.rm_startblock + ltrec.rm_blockcount)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -668,6 +680,7 @@ xfs_rmap_unmap(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -680,12 +693,13 @@ xfs_rmap_unmap(
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
@@ -700,6 +714,7 @@ xfs_rmap_unmap(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -903,6 +918,7 @@ xfs_rmap_map(
 	if (XFS_IS_CORRUPT(mp,
 			   have_lt != 0 &&
 			   ltrec.rm_startblock + ltrec.rm_blockcount > bno)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -920,10 +936,12 @@ xfs_rmap_map(
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
@@ -977,6 +995,7 @@ xfs_rmap_map(
 			if (error)
 				goto out_error;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto out_error;
 			}
@@ -1024,6 +1043,7 @@ xfs_rmap_map(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -1119,6 +1139,7 @@ xfs_rmap_convert(
 	if (error)
 		goto done;
 	if (XFS_IS_CORRUPT(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto done;
 	}
@@ -1156,12 +1177,14 @@ xfs_rmap_convert(
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
@@ -1184,6 +1207,7 @@ xfs_rmap_convert(
 	if (error)
 		goto done;
 	if (XFS_IS_CORRUPT(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto done;
 	}
@@ -1196,10 +1220,12 @@ xfs_rmap_convert(
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
@@ -1230,6 +1256,7 @@ xfs_rmap_convert(
 	if (error)
 		goto done;
 	if (XFS_IS_CORRUPT(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto done;
 	}
@@ -1249,6 +1276,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1260,6 +1288,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1267,6 +1296,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1278,6 +1308,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1285,6 +1316,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1308,6 +1340,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1315,6 +1348,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1334,6 +1368,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1345,6 +1380,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1352,6 +1388,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1422,6 +1459,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1464,6 +1502,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 0)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1479,6 +1518,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1512,6 +1552,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1525,6 +1566,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 0)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1537,6 +1579,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1609,6 +1652,7 @@ xfs_rmap_convert_shared(
 	if (error)
 		goto done;
 	if (XFS_IS_CORRUPT(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto done;
 	}
@@ -1637,6 +1681,7 @@ xfs_rmap_convert_shared(
 		if (XFS_IS_CORRUPT(mp,
 				   LEFT.rm_startblock + LEFT.rm_blockcount >
 				   bno)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1655,10 +1700,12 @@ xfs_rmap_convert_shared(
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
@@ -1709,6 +1756,7 @@ xfs_rmap_convert_shared(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1735,6 +1783,7 @@ xfs_rmap_convert_shared(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1761,6 +1810,7 @@ xfs_rmap_convert_shared(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1784,6 +1834,7 @@ xfs_rmap_convert_shared(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1819,6 +1870,7 @@ xfs_rmap_convert_shared(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1864,6 +1916,7 @@ xfs_rmap_convert_shared(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1899,6 +1952,7 @@ xfs_rmap_convert_shared(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -1937,6 +1991,7 @@ xfs_rmap_convert_shared(
 		if (error)
 			goto done;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -2026,6 +2081,7 @@ xfs_rmap_unmap_shared(
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -2036,12 +2092,14 @@ xfs_rmap_unmap_shared(
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
@@ -2050,16 +2108,19 @@ xfs_rmap_unmap_shared(
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
@@ -2116,6 +2177,7 @@ xfs_rmap_unmap_shared(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -2145,6 +2207,7 @@ xfs_rmap_unmap_shared(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -2224,6 +2287,7 @@ xfs_rmap_map_shared(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(mp, have_gt != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -2276,6 +2340,7 @@ xfs_rmap_map_shared(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -2479,10 +2544,14 @@ xfs_rmap_finish_one(
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

