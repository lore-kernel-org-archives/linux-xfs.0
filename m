Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46507376F7
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 05:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706591526; cv=none; b=L5oiu7K+2YA7+Pa6LSguICawEdJKxmOpNtx2QXneeQrJBezPq8VRKzHl8pHGGznicQo1qClDSbeHpUD1bU6dS+F4ipgUp7+dwz+5qqbj+IPktcKCBbrg9YIUSpNNvVFpPHoge2tAzeDDzSsnwiCAGEK+QZPvPCYCorc7Qs5++Yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706591526; c=relaxed/simple;
	bh=SkED0MZl8u1nNudrvi35kkMJBljewNcLdywjhTMJNDI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jnd9BffI8Xy29fikVmQhimKuz2aniODzRw2miGvqqTxox4K6YX12IlzoCCDxWfTRpVnsA+1UpyK1cm1NiCYlJcW/8CK2CySfknP+7Qf80ocSJkcVnKKjU1cqB0xlxBp6gfPC6ktADYMVmD8POl0llb8oqo5AihI8ITFgeud1zPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lzqRJFUq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lzqRJFUq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06C70C43399;
	Tue, 30 Jan 2024 05:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706591526;
	bh=SkED0MZl8u1nNudrvi35kkMJBljewNcLdywjhTMJNDI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lzqRJFUqy5l+B9sM7QYRO+CZY7lqjzwWIqySIFGx3qGpxH+QfN2BASY/Sp13/2Erf
	 6Iq/Weoxn6R7zS+6c4fgBrwQNf4T4Sdj1BaWh5bo9s4zo/nZPcQtOb5cZAsjYVmHvi
	 dS8GsD4iJgZb21TrcxdKUOdUIP32NGknU0wcC5rJP1UMjl1Cdt1uYZracftQW9nF7Z
	 AMloH+O3/uYGBbZdd2wSlZs+EZfx5kPPpt/d9YKAi16gqBKtc6u+XJUoQghaddlnNb
	 qPbj4OMBNzprg5VJkBbnqFPNzmYquFHU1arSY6HoaedmMRJ043EuETDRe2+JY7Kfcq
	 njiGm2lxWfjBg==
Date: Mon, 29 Jan 2024 21:12:05 -0800
Subject: [PATCH 11/11] xfs: report XFS_IS_CORRUPT errors to the health system
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170659063908.3353909.14280087983835171838.stgit@frogsfrogsfrogs>
In-Reply-To: <170659063695.3353909.12657412146136100266.stgit@frogsfrogsfrogs>
References: <170659063695.3353909.12657412146136100266.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_ag.c          |    4 +-
 fs/xfs/libxfs/xfs_alloc.c       |   97 +++++++++++++++++++++++++++++++++------
 fs/xfs/libxfs/xfs_attr_remote.c |    8 ++-
 fs/xfs/libxfs/xfs_bmap.c        |   94 ++++++++++++++++++++++++++++++++++----
 fs/xfs/libxfs/xfs_btree.c       |   14 +++++-
 fs/xfs/libxfs/xfs_ialloc.c      |   52 +++++++++++++++++----
 fs/xfs/libxfs/xfs_refcount.c    |   37 ++++++++++++++-
 fs/xfs/libxfs/xfs_rmap.c        |   77 +++++++++++++++++++++++++++++--
 fs/xfs/scrub/refcount_repair.c  |    9 +++-
 fs/xfs/xfs_attr_list.c          |    9 +++-
 fs/xfs/xfs_dir2_readdir.c       |    6 ++
 fs/xfs/xfs_discard.c            |    2 +
 fs/xfs/xfs_iwalk.c              |    5 ++
 13 files changed, 364 insertions(+), 50 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 842e79f639475..8bbe399b5f39e 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -951,8 +951,10 @@ xfs_ag_shrink_space(
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
index 2464b64b1cb4e..ac31b62e70177 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -499,14 +499,18 @@ xfs_alloc_fixup_trees(
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
@@ -518,14 +522,18 @@ xfs_alloc_fixup_trees(
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
@@ -538,8 +546,10 @@ xfs_alloc_fixup_trees(
 
 		if (XFS_IS_CORRUPT(mp,
 				   bnoblock->bb_numrecs !=
-				   cntblock->bb_numrecs))
+				   cntblock->bb_numrecs)) {
+			xfs_btree_mark_sick(bno_cur);
 			return -EFSCORRUPTED;
+		}
 	}
 #endif
 
@@ -569,30 +579,40 @@ xfs_alloc_fixup_trees(
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
@@ -603,8 +623,10 @@ xfs_alloc_fixup_trees(
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
@@ -618,12 +640,16 @@ xfs_alloc_fixup_trees(
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
@@ -896,8 +922,10 @@ xfs_alloc_cur_check(
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
@@ -1103,6 +1131,7 @@ xfs_alloc_ag_vextent_small(
 		if (error)
 			goto error;
 		if (XFS_IS_CORRUPT(args->mp, i != 1)) {
+			xfs_btree_mark_sick(ccur);
 			error = -EFSCORRUPTED;
 			goto error;
 		}
@@ -1137,6 +1166,7 @@ xfs_alloc_ag_vextent_small(
 	*fbnop = args->agbno = fbno;
 	*flenp = args->len = 1;
 	if (XFS_IS_CORRUPT(args->mp, fbno >= be32_to_cpu(agf->agf_length))) {
+		xfs_btree_mark_sick(ccur);
 		error = -EFSCORRUPTED;
 		goto error;
 	}
@@ -1223,6 +1253,7 @@ xfs_alloc_ag_vextent_exact(
 	if (error)
 		goto error0;
 	if (XFS_IS_CORRUPT(args->mp, i != 1)) {
+		xfs_btree_mark_sick(bno_cur);
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
@@ -1502,8 +1533,10 @@ xfs_alloc_ag_vextent_lastblock(
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
@@ -1715,6 +1748,7 @@ xfs_alloc_ag_vextent_size(
 			if (error)
 				goto error0;
 			if (XFS_IS_CORRUPT(args->mp, i != 1)) {
+				xfs_btree_mark_sick(cnt_cur);
 				error = -EFSCORRUPTED;
 				goto error0;
 			}
@@ -1761,6 +1795,7 @@ xfs_alloc_ag_vextent_size(
 			   rlen != 0 &&
 			   (rlen > flen ||
 			    rbno + rlen > fbno + flen))) {
+		xfs_btree_mark_sick(cnt_cur);
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
@@ -1783,6 +1818,7 @@ xfs_alloc_ag_vextent_size(
 					&i)))
 				goto error0;
 			if (XFS_IS_CORRUPT(args->mp, i != 1)) {
+				xfs_btree_mark_sick(cnt_cur);
 				error = -EFSCORRUPTED;
 				goto error0;
 			}
@@ -1795,6 +1831,7 @@ xfs_alloc_ag_vextent_size(
 					   rlen != 0 &&
 					   (rlen > flen ||
 					    rbno + rlen > fbno + flen))) {
+				xfs_btree_mark_sick(cnt_cur);
 				error = -EFSCORRUPTED;
 				goto error0;
 			}
@@ -1811,6 +1848,7 @@ xfs_alloc_ag_vextent_size(
 				&i)))
 			goto error0;
 		if (XFS_IS_CORRUPT(args->mp, i != 1)) {
+			xfs_btree_mark_sick(cnt_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -1849,6 +1887,7 @@ xfs_alloc_ag_vextent_size(
 
 	rlen = args->len;
 	if (XFS_IS_CORRUPT(args->mp, rlen > flen)) {
+		xfs_btree_mark_sick(cnt_cur);
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
@@ -1868,6 +1907,7 @@ xfs_alloc_ag_vextent_size(
 	if (XFS_IS_CORRUPT(args->mp,
 			   args->agbno + args->len >
 			   be32_to_cpu(agf->agf_length))) {
+		xfs_ag_mark_sick(args->pag, XFS_SICK_AG_BNOBT);
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
@@ -1943,6 +1983,7 @@ xfs_free_ag_extent(
 		if ((error = xfs_alloc_get_rec(bno_cur, &ltbno, &ltlen, &i)))
 			goto error0;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(bno_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -1958,6 +1999,7 @@ xfs_free_ag_extent(
 			 * Very bad.
 			 */
 			if (XFS_IS_CORRUPT(mp, ltbno + ltlen > bno)) {
+				xfs_btree_mark_sick(bno_cur);
 				error = -EFSCORRUPTED;
 				goto error0;
 			}
@@ -1976,6 +2018,7 @@ xfs_free_ag_extent(
 		if ((error = xfs_alloc_get_rec(bno_cur, &gtbno, &gtlen, &i)))
 			goto error0;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(bno_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -1991,6 +2034,7 @@ xfs_free_ag_extent(
 			 * Very bad.
 			 */
 			if (XFS_IS_CORRUPT(mp, bno + len > gtbno)) {
+				xfs_btree_mark_sick(bno_cur);
 				error = -EFSCORRUPTED;
 				goto error0;
 			}
@@ -2011,12 +2055,14 @@ xfs_free_ag_extent(
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
@@ -2026,12 +2072,14 @@ xfs_free_ag_extent(
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
@@ -2041,6 +2089,7 @@ xfs_free_ag_extent(
 		if ((error = xfs_btree_delete(bno_cur, &i)))
 			goto error0;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(bno_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -2050,6 +2099,7 @@ xfs_free_ag_extent(
 		if ((error = xfs_btree_decrement(bno_cur, 0, &i)))
 			goto error0;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(bno_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -2069,6 +2119,7 @@ xfs_free_ag_extent(
 					   i != 1 ||
 					   xxbno != ltbno ||
 					   xxlen != ltlen)) {
+				xfs_btree_mark_sick(bno_cur);
 				error = -EFSCORRUPTED;
 				goto error0;
 			}
@@ -2093,12 +2144,14 @@ xfs_free_ag_extent(
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
@@ -2109,6 +2162,7 @@ xfs_free_ag_extent(
 		if ((error = xfs_btree_decrement(bno_cur, 0, &i)))
 			goto error0;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(bno_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -2128,12 +2182,14 @@ xfs_free_ag_extent(
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
@@ -2156,6 +2212,7 @@ xfs_free_ag_extent(
 		if ((error = xfs_btree_insert(bno_cur, &i)))
 			goto error0;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(bno_cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -2168,12 +2225,14 @@ xfs_free_ag_extent(
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
@@ -3903,17 +3962,23 @@ __xfs_free_extent(
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
index b18a3cf44192e..bb4cf1fa0dc2c 100644
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
index 3cbd3d80a3b97..a8bcddcdd986e 100644
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
@@ -885,6 +888,7 @@ xfs_bmap_add_attrfork_btree(
 			goto error0;
 		/* must be at least one entry */
 		if (XFS_IS_CORRUPT(mp, stat != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -1211,6 +1215,7 @@ xfs_iread_extents(
 		goto out;
 
 	if (XFS_IS_CORRUPT(mp, ir.loaded != ifp->if_nextents)) {
+		xfs_bmap_mark_sick(ip, whichfork);
 		error = -EFSCORRUPTED;
 		goto out;
 	}
@@ -1401,8 +1406,10 @@ xfs_bmap_last_offset(
 	if (ifp->if_format == XFS_DINODE_FMT_LOCAL)
 		return 0;
 
-	if (XFS_IS_CORRUPT(ip->i_mount, !xfs_ifork_has_extents(ifp)))
+	if (XFS_IS_CORRUPT(ip->i_mount, !xfs_ifork_has_extents(ifp))) {
+		xfs_bmap_mark_sick(ip, whichfork);
 		return -EFSCORRUPTED;
+	}
 
 	error = xfs_bmap_last_extent(NULL, ip, whichfork, &rec, &is_empty);
 	if (error || is_empty)
@@ -1541,6 +1548,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1548,6 +1556,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1555,6 +1564,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1584,6 +1594,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1617,6 +1628,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1645,6 +1657,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 0)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1652,6 +1665,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1686,6 +1700,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1711,6 +1726,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 0)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1718,6 +1734,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1762,6 +1779,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1798,6 +1816,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 0)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1805,6 +1824,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1884,6 +1904,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 0)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -1891,6 +1912,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(bma->cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2087,30 +2109,35 @@ xfs_bmap_add_extent_unwritten_real(
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
@@ -2139,18 +2166,21 @@ xfs_bmap_add_extent_unwritten_real(
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
@@ -2182,18 +2212,21 @@ xfs_bmap_add_extent_unwritten_real(
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
@@ -2220,6 +2253,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2253,6 +2287,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2290,6 +2325,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2300,6 +2336,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2330,6 +2367,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2366,6 +2404,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2376,12 +2415,14 @@ xfs_bmap_add_extent_unwritten_real(
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
@@ -2418,6 +2459,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2430,6 +2472,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2442,6 +2485,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 0)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2449,6 +2493,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2734,6 +2779,7 @@ xfs_bmap_add_extent_hole_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2741,6 +2787,7 @@ xfs_bmap_add_extent_hole_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2748,6 +2795,7 @@ xfs_bmap_add_extent_hole_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2777,6 +2825,7 @@ xfs_bmap_add_extent_hole_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2807,6 +2856,7 @@ xfs_bmap_add_extent_hole_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2833,6 +2883,7 @@ xfs_bmap_add_extent_hole_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 0)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -2840,6 +2891,7 @@ xfs_bmap_add_extent_hole_real(
 			if (error)
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto done;
 			}
@@ -5109,8 +5161,10 @@ xfs_bmap_del_extent_real(
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
@@ -5134,8 +5188,10 @@ xfs_bmap_del_extent_real(
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
@@ -5207,8 +5263,10 @@ xfs_bmap_del_extent_real(
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
@@ -5224,8 +5282,10 @@ xfs_bmap_del_extent_real(
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
 
@@ -5680,21 +5740,27 @@ xfs_bmse_merge(
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
@@ -5742,8 +5808,10 @@ xfs_bmap_shift_update_extent(
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
@@ -5804,6 +5872,7 @@ xfs_bmap_collapse_extents(
 		goto del_cursor;
 	}
 	if (XFS_IS_CORRUPT(mp, isnullstartblock(got.br_startblock))) {
+		xfs_bmap_mark_sick(ip, whichfork);
 		error = -EFSCORRUPTED;
 		goto del_cursor;
 	}
@@ -5929,11 +5998,13 @@ xfs_bmap_insert_extents(
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
@@ -6033,6 +6104,7 @@ xfs_bmap_split_extent(
 		if (error)
 			goto del_cursor;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto del_cursor;
 		}
@@ -6060,6 +6132,7 @@ xfs_bmap_split_extent(
 		if (error)
 			goto del_cursor;
 		if (XFS_IS_CORRUPT(mp, i != 0)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto del_cursor;
 		}
@@ -6067,6 +6140,7 @@ xfs_bmap_split_extent(
 		if (error)
 			goto del_cursor;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto del_cursor;
 		}
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 51d0a569e8216..28ba528086888 100644
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
@@ -3538,6 +3542,7 @@ xfs_btree_insert(
 		}
 
 		if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -3945,6 +3950,7 @@ xfs_btree_delrec(
 		 */
 		i = xfs_btree_lastrec(tcur, level);
 		if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -3953,12 +3959,14 @@ xfs_btree_delrec(
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
@@ -4006,6 +4014,7 @@ xfs_btree_delrec(
 		if (!xfs_btree_ptr_is_null(cur, &lptr)) {
 			i = xfs_btree_firstrec(tcur, level);
 			if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto error0;
 			}
@@ -4014,6 +4023,7 @@ xfs_btree_delrec(
 			if (error)
 				goto error0;
 			if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto error0;
 			}
@@ -4031,6 +4041,7 @@ xfs_btree_delrec(
 		 */
 		i = xfs_btree_firstrec(tcur, level);
 		if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -4040,6 +4051,7 @@ xfs_btree_delrec(
 			goto error0;
 		i = xfs_btree_firstrec(tcur, level);
 		if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 56f82b8af07e8..1ff867075026d 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -573,6 +573,7 @@ xfs_inobt_insert_sprec(
 		if (error)
 			goto error;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error;
 		}
@@ -589,10 +590,12 @@ xfs_inobt_insert_sprec(
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
@@ -602,6 +605,7 @@ xfs_inobt_insert_sprec(
 		 * cannot merge, something is seriously wrong.
 		 */
 		if (XFS_IS_CORRUPT(mp, !__xfs_inobt_can_merge(nrec, &rec))) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error;
 		}
@@ -951,8 +955,10 @@ xfs_ialloc_next_rec(
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
@@ -976,8 +982,10 @@ xfs_ialloc_get_rec(
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
@@ -1055,6 +1063,7 @@ xfs_dialloc_ag_inobt(
 		if (error)
 			goto error0;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -1063,6 +1072,7 @@ xfs_dialloc_ag_inobt(
 		if (error)
 			goto error0;
 		if (XFS_IS_CORRUPT(mp, j != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -1221,6 +1231,7 @@ xfs_dialloc_ag_inobt(
 	if (error)
 		goto error0;
 	if (XFS_IS_CORRUPT(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
@@ -1230,6 +1241,7 @@ xfs_dialloc_ag_inobt(
 		if (error)
 			goto error0;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -1239,6 +1251,7 @@ xfs_dialloc_ag_inobt(
 		if (error)
 			goto error0;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
@@ -1299,8 +1312,10 @@ xfs_dialloc_ag_finobt_near(
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
@@ -1324,12 +1339,14 @@ xfs_dialloc_ag_finobt_near(
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
@@ -1385,8 +1402,10 @@ xfs_dialloc_ag_finobt_newino(
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
@@ -1397,14 +1416,18 @@ xfs_dialloc_ag_finobt_newino(
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
@@ -1426,14 +1449,18 @@ xfs_dialloc_ag_update_inobt(
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
 
@@ -1442,8 +1469,10 @@ xfs_dialloc_ag_update_inobt(
 
 	if (XFS_IS_CORRUPT(cur->bc_mp,
 			   rec.ir_free != frec->ir_free ||
-			   rec.ir_freecount != frec->ir_freecount))
+			   rec.ir_freecount != frec->ir_freecount)) {
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
+	}
 
 	return xfs_inobt_update(cur, &rec);
 }
@@ -1960,6 +1989,7 @@ xfs_difree_inobt(
 		goto error0;
 	}
 	if (XFS_IS_CORRUPT(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
@@ -1970,6 +2000,7 @@ xfs_difree_inobt(
 		goto error0;
 	}
 	if (XFS_IS_CORRUPT(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
@@ -2082,6 +2113,7 @@ xfs_difree_finobt(
 		 * something is out of sync.
 		 */
 		if (XFS_IS_CORRUPT(mp, ibtrec->ir_freecount != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto error;
 		}
@@ -2108,6 +2140,7 @@ xfs_difree_finobt(
 	if (error)
 		goto error;
 	if (XFS_IS_CORRUPT(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto error;
 	}
@@ -2118,6 +2151,7 @@ xfs_difree_finobt(
 	if (XFS_IS_CORRUPT(mp,
 			   rec.ir_free != ibtrec->ir_free ||
 			   rec.ir_freecount != ibtrec->ir_freecount)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto error;
 	}
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 91f1066f408b9..90a4526fef929 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -240,6 +240,7 @@ xfs_refcount_insert(
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, *i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -270,12 +271,14 @@ xfs_refcount_delete(
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
@@ -400,6 +403,7 @@ xfs_refcount_split_extent(
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -427,6 +431,7 @@ xfs_refcount_split_extent(
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -472,6 +477,7 @@ xfs_refcount_merge_center_extents(
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -480,6 +486,7 @@ xfs_refcount_merge_center_extents(
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -489,6 +496,7 @@ xfs_refcount_merge_center_extents(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -500,6 +508,7 @@ xfs_refcount_merge_center_extents(
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -544,6 +553,7 @@ xfs_refcount_merge_left_extent(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -552,6 +562,7 @@ xfs_refcount_merge_left_extent(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -563,6 +574,7 @@ xfs_refcount_merge_left_extent(
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -610,6 +622,7 @@ xfs_refcount_merge_right_extent(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -618,6 +631,7 @@ xfs_refcount_merge_right_extent(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -629,6 +643,7 @@ xfs_refcount_merge_right_extent(
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -676,6 +691,7 @@ xfs_refcount_find_left_extents(
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -695,6 +711,7 @@ xfs_refcount_find_left_extents(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -769,6 +786,7 @@ xfs_refcount_find_right_extents(
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -788,6 +806,7 @@ xfs_refcount_find_right_extents(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -1144,6 +1163,7 @@ xfs_refcount_adjust_extents(
 					goto out_error;
 				if (XFS_IS_CORRUPT(cur->bc_mp,
 						   found_tmp != 1)) {
+					xfs_btree_mark_sick(cur);
 					error = -EFSCORRUPTED;
 					goto out_error;
 				}
@@ -1182,6 +1202,7 @@ xfs_refcount_adjust_extents(
 		 */
 		if (XFS_IS_CORRUPT(cur->bc_mp, ext.rc_blockcount == 0) ||
 		    XFS_IS_CORRUPT(cur->bc_mp, ext.rc_blockcount > *aglen)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -1205,6 +1226,7 @@ xfs_refcount_adjust_extents(
 			if (error)
 				goto out_error;
 			if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+				xfs_btree_mark_sick(cur);
 				error = -EFSCORRUPTED;
 				goto out_error;
 			}
@@ -1329,8 +1351,10 @@ xfs_refcount_continue_op(
 	struct xfs_perag		*pag = cur->bc_ag.pag;
 
 	if (XFS_IS_CORRUPT(mp, !xfs_verify_agbext(pag, new_agbno,
-					ri->ri_blockcount)))
+					ri->ri_blockcount))) {
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
+	}
 
 	ri->ri_startblock = XFS_AGB_TO_FSB(mp, pag->pag_agno, new_agbno);
 
@@ -1537,6 +1561,7 @@ xfs_refcount_find_shared(
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -1554,6 +1579,7 @@ xfs_refcount_find_shared(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -1587,6 +1613,7 @@ xfs_refcount_find_shared(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -1684,6 +1711,7 @@ xfs_refcount_adjust_cow_extents(
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec &&
 				ext.rc_domain != XFS_REFC_DOMAIN_COW)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
@@ -1699,6 +1727,7 @@ xfs_refcount_adjust_cow_extents(
 		/* Adding a CoW reservation, there should be nothing here. */
 		if (XFS_IS_CORRUPT(cur->bc_mp,
 				   agbno + aglen > ext.rc_startblock)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -1716,6 +1745,7 @@ xfs_refcount_adjust_cow_extents(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(cur->bc_mp, found_tmp != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -1723,14 +1753,17 @@ xfs_refcount_adjust_cow_extents(
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
@@ -1742,6 +1775,7 @@ xfs_refcount_adjust_cow_extents(
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
@@ -1904,6 +1938,7 @@ xfs_refcount_recover_extent(
 	if (xfs_refcount_check_irec(cur->bc_ag.pag, &rr->rr_rrec) != NULL ||
 	    XFS_IS_CORRUPT(cur->bc_mp,
 			   rr->rr_rrec.rc_domain != XFS_REFC_DOMAIN_COW)) {
+		xfs_btree_mark_sick(cur);
 		kfree(rr);
 		return -EFSCORRUPTED;
 	}
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 76a2e47b8a8ee..cad9b456db81f 100644
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
@@ -2480,10 +2545,14 @@ xfs_rmap_finish_one(
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
index f38fccc42a209..9c39af03ee1d8 100644
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
@@ -253,8 +254,10 @@ xrep_refc_walk_rmaps(
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
@@ -425,8 +428,10 @@ xrep_refc_push_rmaps_at(
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
index 453b15ec33df3..7f8072e9babd3 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -83,8 +83,10 @@ xfs_attr_shortform_list(
 		for (i = 0, sfe = xfs_attr_sf_firstentry(sf); i < sf->count; i++) {
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
@@ -177,6 +179,7 @@ xfs_attr_shortform_list(
 		if (XFS_IS_CORRUPT(context->dp->i_mount,
 				   !xfs_attr_namecheck(sbp->name,
 						       sbp->namelen))) {
+			xfs_dirattr_mark_sick(context->dp, XFS_ATTR_FORK);
 			error = -EFSCORRUPTED;
 			goto out;
 		}
@@ -471,8 +474,10 @@ xfs_attr3_leaf_list_int(
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
index cc6dc56f455d0..3b3e3f0c3e7ab 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -118,8 +118,10 @@ xfs_dir2_sf_getdents(
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
@@ -211,6 +213,7 @@ xfs_dir2_block_getdents(
 		if (XFS_IS_CORRUPT(dp->i_mount,
 				   !xfs_dir2_namecheck(dep->name,
 						       dep->namelen))) {
+			xfs_dirattr_mark_sick(dp, XFS_DATA_FORK);
 			error = -EFSCORRUPTED;
 			goto out_rele;
 		}
@@ -465,6 +468,7 @@ xfs_dir2_leaf_getdents(
 		if (XFS_IS_CORRUPT(dp->i_mount,
 				   !xfs_dir2_namecheck(dep->name,
 						       dep->namelen))) {
+			xfs_dirattr_mark_sick(dp, XFS_DATA_FORK);
 			error = -EFSCORRUPTED;
 			break;
 		}
diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index d5787991bb5b4..e38c4c46d1275 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -18,6 +18,7 @@
 #include "xfs_trace.h"
 #include "xfs_log.h"
 #include "xfs_ag.h"
+#include "xfs_health.h"
 
 /*
  * Notes on an efficient, low latency fstrim algorithm
@@ -204,6 +205,7 @@ xfs_trim_gather_extents(
 		if (error)
 			break;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
 			break;
 		}
diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index 4ce85423ef3e0..6f26a791f17f0 100644
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

