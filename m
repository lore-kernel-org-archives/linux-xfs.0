Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4843C2B92
	for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 19:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792179286; cv=none; b=IviIAxwdqsWkDYYKAWY+eD8L5kwoFUYi5pYdnXV/5pMKU6Pkz3BgNyhrCESR/k6/caBP6g1A5msa5kcYqfEmYGCGFS28lRhhtNSl0IU8qeTd35RUYgA45wlJUTpChIkCA9nJxDpab+q7VLaSK1Jq6t57JLmf6c+1aCpMHNs7u7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792179286; c=relaxed/simple;
	bh=8RZmcTl/ZVc3KE8PXrF+UbNeggvPBziccjBUYjw5HMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OKfLiF56tca4XpHPgR21pap2vNcmlbXMa9I9PH5247F4rxUzx4F35xdWpbm4I53wQ04XZJ/3WTE+WWOc7Mulji1KM0m9bhE8ENo1/kHHWvYJ9VL8fh/fTgPhlG2dPqXTfG9t3TUAByON76aG3L2ffCE0J7KYdB1oa7TpgCRVyAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JseECD8D; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=MKsa8iPq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JseECD8D";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="MKsa8iPq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792179281;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ys6bO0bWQwt7LYiYZJFJxfGw8GSFIXTOyMqkZ69Fy6A=;
	b=JseECD8DGOlEdwJ72iJAnfuqcKhg/KOHFQ6qLO84Iy9JM9fgFfSskVUsuR0YChQeUG4o9S
	AW/bKQLQiKQw1iOtfoed4+Sd1LyQigf1ODD9z7Mz2NQ42/sQcJuDuLmWjrllTM0uiqLw5N
	fkHi3/ZTllxni/Ta/KztdECdozyoQyE=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-245-jy4VDEvpPVyEz55B5bVpHg-1; Fri, 16 Oct 2026 19:34:40 +0000
X-MC-Unique: jy4VDEvpPVyEz55B5bVpHg-1
X-Mimecast-MFC-AGG-ID: jy4VDEvpPVyEz55B5bVpHg_1792179280
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-93f1f2fafeaso39209785a.2
        for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 12:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1792179280; x=1792784080; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ys6bO0bWQwt7LYiYZJFJxfGw8GSFIXTOyMqkZ69Fy6A=;
        b=MKsa8iPqMg9ZJqWOF6OAjCCL/WvhTdddd7RLineUAF0RreJAz9s5Ho4J25r6ihb6P9
         dPMg/pETv+UeqZahMq0DzG3jQkx82nrRYNT9j2J69rqdLKUZ0Ii9OnIPIcXVRR9SI0Ew
         PlEWjkLRmEvqbIW8SrLhlgarEyT92qGTCyCMrFuaLuKNGJ81AslyAMvjVMCVeklfUG1p
         3sZtLVL/E06EUjisqnrZJYtvPJ02fnBQYKOvG2bTMogdPNaEWJ93JBYgyNN+8WH9tQFY
         YNk3sJKrcQbLT8Uygo/ocwsqLC40BC080OTe9imNmKyZjAouS9Jw5FP8MJdvNvPeV2n2
         wnXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792179280; x=1792784080;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ys6bO0bWQwt7LYiYZJFJxfGw8GSFIXTOyMqkZ69Fy6A=;
        b=KGpjYLjJZOWF0xDRXUyjNxJFT8YW6IdJo4eehBkZ0WafOlcAiwluICoigibEVGhSwA
         2qjWFV939m3oAQPVw5tVpyaEERAkYg4WPaV0ljiU6RY+AeR7+6vRXmOneiRkUPxTNw9f
         Ze8hv/XoTgBBzfrT/4NuxyTRrVnGGQdBbNgT3k3s2fK8/VVHpmA8DcuZWKltKOmp1iBm
         tTwpVJN2NLiC1/4iRiet4xU59y3y3psKkGQyQw/0dg/kjm08RHBpcCFDEQa2kjYmLcGc
         0U8kr9vAdCgDXIsywsN3WpEs6SB0Iq9g66xc5LAiNEh2IrqObb4/l3QYZ8RElOR+CqyJ
         wihg==
X-Gm-Message-State: AFq9FYIwzon4sMoU/TuHw0kVCwvzDkFldtktOaPXX+06vnW2LOYmkE/n
	FhbYLBAwmQ7OyynmNQ2AHZyhyZzppHcW7Zk16ODpseGqkiAx5S+jI/p9dI43Rosfx0IhsuzdcOD
	KSrJfntHJbZa9ddq5+Vr7XmQYYVfV579TjPIzteg2znfFDwpevOQxJA4TMs879Lb434xHsO4Z46
	0kHwY7R1DOYdBT/oyyCM+fgxtD5U69CzHvyB/q8+eIOx6M
X-Gm-Gg: AYBFou3rp99L1v1vrZCPXG5Ua/Z7lpb7S1GHsdd4ct7XWFld8SUmlj+ajOU7VwA0zqj
	p7//BH8xpEIBWj4Vu1+bKeC6oYjbpWsn3KJLuRqspNBjsgmfTxZVJDVk69Z3CuK6v4/f5SKv2QI
	Fg8M0dB03ntSbXL6N9qwPZUNKlWKkfAohGqgxWT+TJXejv8J8vxn6iyRR68IDMSRJyX4kPgcau+
	oX9M4mAgeixwqEP3PUF+va2axucDsOg9r+nnmJwkPM7D+sK7ziEBH47lds3l8vQVmVBLV/HwU1x
	+BEg88otP8tnLYFX6x6x1ZFEpPjZTw6IzoeyvMifI4g7MQT12+ATBFaQtIImg7uLb/zQwQSB/T3
	Rjd6W+fwN64X8nM8lfb8yMtK2/S4eT6qo+oklVA==
X-Received: by 2002:a05:620a:44d0:b0:93e:be7f:992b with SMTP id af79cd13be357-93f29cc920amr153880985a.27.1792179279419;
        Fri, 16 Oct 2026 12:34:39 -0700 (PDT)
X-Received: by 2002:a05:620a:44d0:b0:93e:be7f:992b with SMTP id af79cd13be357-93f29cc920amr153873085a.27.1792179278533;
        Fri, 16 Oct 2026 12:34:38 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f1a1a990fsm284359185a.35.2026.10.16.12.34.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 12:34:37 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	hch@lst.de,
	dgc@kernel.org,
	Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 8/8] xfs: remove status parameter from two btree delete functions
Date: Fri, 16 Oct 2026 14:29:08 -0500
Message-ID: <20261016193422.1630907-9-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261016193422.1630907-1-sandeen@redhat.com>
References: <20261016193422.1630907-1-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xfs_btree_delete and its callers now have no need for the status
parameter; either they return error = 0 / status = 1, or nonzero error
and status 0. No caller evaluates the status variable, so remove that
parameter from these functions.

As requested, convert all of the compound tests/assignments to discrete
lines.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c    | 21 ++++++++++++++-------
 fs/xfs/libxfs/xfs_bmap.c     | 21 +++++++++++++--------
 fs/xfs/libxfs/xfs_btree.c    |  4 +---
 fs/xfs/libxfs/xfs_btree.h    |  2 +-
 fs/xfs/libxfs/xfs_ialloc.c   |  8 ++++----
 fs/xfs/libxfs/xfs_refcount.c | 17 ++++++++---------
 fs/xfs/libxfs/xfs_rmap.c     | 15 +++++++--------
 fs/xfs/scrub/rcbag.c         |  2 +-
 8 files changed, 49 insertions(+), 41 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index bc43afff33bc..c32816390217 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -676,7 +676,8 @@ xfs_alloc_fixup_trees(
 	/*
 	 * Delete the entry from the by-size btree.
 	 */
-	if ((error = xfs_btree_delete(cnt_cur, &i)))
+	error = xfs_btree_delete(cnt_cur);
+	if (error)
 		return error;
 	/*
 	 * Add new by-size btree entry(s).
@@ -710,7 +711,8 @@ xfs_alloc_fixup_trees(
 		/*
 		 * No remaining freespace, just delete the by-block tree entry.
 		 */
-		if ((error = xfs_btree_delete(bno_cur, &i)))
+		error = xfs_btree_delete(bno_cur);
+		if (error)
 			return error;
 	} else {
 		/*
@@ -2145,7 +2147,8 @@ xfs_free_ag_extent(
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
-		if ((error = xfs_btree_delete(cnt_cur, &i)))
+		error = xfs_btree_delete(cnt_cur);
+		if (error)
 			goto error0;
 		/*
 		 * Delete the old by-size entry on the right.
@@ -2157,12 +2160,14 @@ xfs_free_ag_extent(
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
-		if ((error = xfs_btree_delete(cnt_cur, &i)))
+		error = xfs_btree_delete(cnt_cur);
+		if (error)
 			goto error0;
 		/*
 		 * Delete the old by-block entry for the right block.
 		 */
-		if ((error = xfs_btree_delete(bno_cur, &i)))
+		error = xfs_btree_delete(bno_cur);
+		if (error)
 			goto error0;
 		/*
 		 * Move the by-block cursor back to the left neighbor.
@@ -2219,7 +2224,8 @@ xfs_free_ag_extent(
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
-		if ((error = xfs_btree_delete(cnt_cur, &i)))
+		error = xfs_btree_delete(cnt_cur);
+		if (error)
 			goto error0;
 		/*
 		 * Back up the by-block cursor to the left neighbor, and
@@ -2252,7 +2258,8 @@ xfs_free_ag_extent(
 			error = -EFSCORRUPTED;
 			goto error0;
 		}
-		if ((error = xfs_btree_delete(cnt_cur, &i)))
+		error = xfs_btree_delete(cnt_cur);
+		if (error)
 			goto error0;
 		/*
 		 * Update the starting block and length of the right
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index cf7360adf1a8..beaa92ea8015 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1559,7 +1559,7 @@ xfs_bmap_add_extent_delay_real(
 				error = -EFSCORRUPTED;
 				goto done;
 			}
-			error = xfs_btree_delete(bma->cur, &i);
+			error = xfs_btree_delete(bma->cur);
 			if (error)
 				goto done;
 			error = xfs_btree_decrement(bma->cur, 0, &i);
@@ -2103,7 +2103,8 @@ xfs_bmap_add_extent_unwritten_real(
 				error = -EFSCORRUPTED;
 				goto done;
 			}
-			if ((error = xfs_btree_delete(cur, &i)))
+			error = xfs_btree_delete(cur);
+			if (error)
 				goto done;
 			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
@@ -2112,7 +2113,8 @@ xfs_bmap_add_extent_unwritten_real(
 				error = -EFSCORRUPTED;
 				goto done;
 			}
-			if ((error = xfs_btree_delete(cur, &i)))
+			error = xfs_btree_delete(cur);
+			if (error)
 				goto done;
 			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
@@ -2150,7 +2152,8 @@ xfs_bmap_add_extent_unwritten_real(
 				error = -EFSCORRUPTED;
 				goto done;
 			}
-			if ((error = xfs_btree_delete(cur, &i)))
+			error = xfs_btree_delete(cur);
+			if (error)
 				goto done;
 			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
@@ -2191,7 +2194,8 @@ xfs_bmap_add_extent_unwritten_real(
 				error = -EFSCORRUPTED;
 				goto done;
 			}
-			if ((error = xfs_btree_delete(cur, &i)))
+			error = xfs_btree_delete(cur);
+			if (error)
 				goto done;
 			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
@@ -2599,7 +2603,7 @@ xfs_bmap_add_extent_hole_real(
 				error = -EFSCORRUPTED;
 				goto done;
 			}
-			error = xfs_btree_delete(cur, &i);
+			error = xfs_btree_delete(cur);
 			if (error)
 				goto done;
 			error = xfs_btree_decrement(cur, 0, &i);
@@ -4926,7 +4930,8 @@ xfs_bmap_del_extent_real(
 			*logflagsp |= xfs_ilog_fext(whichfork);
 			break;
 		}
-		if ((error = xfs_btree_delete(cur, &i)))
+		error = xfs_btree_delete(cur);
+		if (error)
 			return error;
 		break;
 	case BMAP_LEFT_FILLING:
@@ -5488,7 +5493,7 @@ xfs_bmse_merge(
 		return -EFSCORRUPTED;
 	}
 
-	error = xfs_btree_delete(cur, &i);
+	error = xfs_btree_delete(cur);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 367c14e4dec5..91211d212c74 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -4555,8 +4555,7 @@ xfs_btree_delrec(
  */
 int					/* error */
 xfs_btree_delete(
-	struct xfs_btree_cur	*cur,
-	int			*stat)	/* success/failure */
+	struct xfs_btree_cur	*cur)
 {
 	int			error;	/* error return value */
 	int			level;
@@ -4604,7 +4603,6 @@ xfs_btree_delete(
 		goto error0;
 	}
 
-	*stat = i;
 	return 0;
 error0:
 	return error;
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 0f82f3106bac..c4337ab244f2 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -406,7 +406,7 @@ int xfs_btree_lookup(struct xfs_btree_cur *, xfs_lookup_t, int *);
 int xfs_btree_update(struct xfs_btree_cur *, union xfs_btree_rec *);
 int xfs_btree_new_iroot(struct xfs_btree_cur *, int *, int *);
 int xfs_btree_insert(struct xfs_btree_cur *);
-int xfs_btree_delete(struct xfs_btree_cur *, int *);
+int xfs_btree_delete(struct xfs_btree_cur *);
 int xfs_btree_get_rec(struct xfs_btree_cur *, union xfs_btree_rec **, int *);
 int xfs_btree_change_owner(struct xfs_btree_cur *cur, uint64_t new_owner,
 			   struct list_head *buffer_list);
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 7a9cc0b9e206..ec0a37499f28 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1564,7 +1564,6 @@ xfs_dialloc_ag(
 	xfs_ino_t			ino;
 	int				error;
 	int				offset;
-	int				i;
 
 	if (!xfs_has_finobt(mp))
 		return xfs_dialloc_ag_inobt(pag, tp, agbp, parent, inop);
@@ -1617,7 +1616,7 @@ xfs_dialloc_ag(
 		if (error)
 			goto error_cur;
 	} else {
-		error = xfs_btree_delete(cur, &i);
+		error = xfs_btree_delete(cur);
 		if (error)
 			goto error_cur;
 	}
@@ -2148,7 +2147,8 @@ xfs_difree_inobt(
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_ICOUNT, -ilen);
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, -(ilen - 1));
 
-		if ((error = xfs_btree_delete(cur, &i))) {
+		error = xfs_btree_delete(cur);
+		if (error) {
 			xfs_warn(mp, "%s: xfs_btree_delete returned error %d.",
 				__func__, error);
 			goto error0;
@@ -2274,7 +2274,7 @@ xfs_difree_finobt(
 	 */
 	if (rec.ir_free == XFS_INOBT_ALL_FREE &&
 	    mp->m_sb.sb_inopblock <= XFS_INODES_PER_CHUNK) {
-		error = xfs_btree_delete(cur, &i);
+		error = xfs_btree_delete(cur);
 		if (error)
 			goto error;
 	} else {
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 924f839b35a0..75e469576a8b 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -288,8 +288,7 @@ xfs_refcount_insert(
  */
 STATIC int
 xfs_refcount_delete(
-	struct xfs_btree_cur	*cur,
-	int			*i)
+	struct xfs_btree_cur	*cur)
 {
 	struct xfs_refcount_irec	irec;
 	int			found_rec;
@@ -304,7 +303,7 @@ xfs_refcount_delete(
 		goto out_error;
 	}
 	trace_xfs_refcount_delete(cur, &irec);
-	error = xfs_btree_delete(cur, i);
+	error = xfs_btree_delete(cur);
 	if (error)
 		goto out_error;
 	error = xfs_refcount_lookup_ge(cur, irec.rc_domain, irec.rc_startblock,
@@ -497,12 +496,12 @@ xfs_refcount_merge_center_extents(
 		goto out_error;
 	}
 
-	error = xfs_refcount_delete(cur, &found_rec);
+	error = xfs_refcount_delete(cur);
 	if (error)
 		goto out_error;
 
 	if (center->rc_refcount > 1) {
-		error = xfs_refcount_delete(cur, &found_rec);
+		error = xfs_refcount_delete(cur);
 		if (error)
 			goto out_error;
 	}
@@ -561,7 +560,7 @@ xfs_refcount_merge_left_extent(
 			goto out_error;
 		}
 
-		error = xfs_refcount_delete(cur, &found_rec);
+		error = xfs_refcount_delete(cur);
 		if (error)
 			goto out_error;
 	}
@@ -623,7 +622,7 @@ xfs_refcount_merge_right_extent(
 			goto out_error;
 		}
 
-		error = xfs_refcount_delete(cur, &found_rec);
+		error = xfs_refcount_delete(cur);
 		if (error)
 			goto out_error;
 	}
@@ -1209,7 +1208,7 @@ xfs_refcount_adjust_extents(
 			if (error)
 				goto out_error;
 		} else if (ext.rc_refcount == 1) {
-			error = xfs_refcount_delete(cur, &found_rec);
+			error = xfs_refcount_delete(cur);
 			if (error)
 				goto out_error;
 			goto advloop;
@@ -1819,7 +1818,7 @@ xfs_refcount_adjust_cow_extents(
 
 		ext.rc_refcount = 0;
 		trace_xfs_refcount_modify_extent(cur, &ext);
-		error = xfs_refcount_delete(cur, &found_rec);
+		error = xfs_refcount_delete(cur);
 		if (error)
 			goto out_error;
 		break;
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 31c41e9bcb3f..6fe06612eac2 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -175,7 +175,7 @@ xfs_rmap_delete(
 		goto done;
 	}
 
-	error = xfs_btree_delete(rcur, &i);
+	error = xfs_btree_delete(rcur);
 	if (error)
 		goto done;
 done:
@@ -770,7 +770,7 @@ xfs_rmap_unmap(
 		trace_xfs_rmap_delete(cur, ltrec.rm_startblock,
 				ltrec.rm_blockcount, ltrec.rm_owner,
 				ltrec.rm_offset, ltrec.rm_flags);
-		error = xfs_btree_delete(cur, &i);
+		error = xfs_btree_delete(cur);
 		if (error)
 			goto out_error;
 	} else if (ltrec.rm_startblock == bno) {
@@ -1012,7 +1012,6 @@ xfs_rmap_map(
 	int				have_gt;
 	int				have_lt;
 	int				error = 0;
-	int				i;
 	uint64_t			owner;
 	uint64_t			offset;
 	unsigned int			flags = 0;
@@ -1118,7 +1117,7 @@ xfs_rmap_map(
 			trace_xfs_rmap_delete(cur, gtrec.rm_startblock,
 					gtrec.rm_blockcount, gtrec.rm_owner,
 					gtrec.rm_offset, gtrec.rm_flags);
-			error = xfs_btree_delete(cur, &i);
+			error = xfs_btree_delete(cur);
 			if (error)
 				goto out_error;
 		}
@@ -1395,7 +1394,7 @@ xfs_rmap_convert(
 		trace_xfs_rmap_delete(cur, RIGHT.rm_startblock,
 				RIGHT.rm_blockcount, RIGHT.rm_owner,
 				RIGHT.rm_offset, RIGHT.rm_flags);
-		error = xfs_btree_delete(cur, &i);
+		error = xfs_btree_delete(cur);
 		if (error)
 			goto done;
 		error = xfs_btree_decrement(cur, 0, &i);
@@ -1409,7 +1408,7 @@ xfs_rmap_convert(
 		trace_xfs_rmap_delete(cur, PREV.rm_startblock,
 				PREV.rm_blockcount, PREV.rm_owner,
 				PREV.rm_offset, PREV.rm_flags);
-		error = xfs_btree_delete(cur, &i);
+		error = xfs_btree_delete(cur);
 		if (error)
 			goto done;
 		error = xfs_btree_decrement(cur, 0, &i);
@@ -1435,7 +1434,7 @@ xfs_rmap_convert(
 		trace_xfs_rmap_delete(cur, PREV.rm_startblock,
 				PREV.rm_blockcount, PREV.rm_owner,
 				PREV.rm_offset, PREV.rm_flags);
-		error = xfs_btree_delete(cur, &i);
+		error = xfs_btree_delete(cur);
 		if (error)
 			goto done;
 		error = xfs_btree_decrement(cur, 0, &i);
@@ -1469,7 +1468,7 @@ xfs_rmap_convert(
 		trace_xfs_rmap_delete(cur, RIGHT.rm_startblock,
 				RIGHT.rm_blockcount, RIGHT.rm_owner,
 				RIGHT.rm_offset, RIGHT.rm_flags);
-		error = xfs_btree_delete(cur, &i);
+		error = xfs_btree_delete(cur);
 		if (error)
 			goto done;
 		error = xfs_btree_decrement(cur, 0, &i);
diff --git a/fs/xfs/scrub/rcbag.c b/fs/xfs/scrub/rcbag.c
index 5a390e3c7777..bd1aa55a8910 100644
--- a/fs/xfs/scrub/rcbag.c
+++ b/fs/xfs/scrub/rcbag.c
@@ -239,7 +239,7 @@ rcbag_remove_ending_at(
 		if (rcbag_rec_next_bno(&bagrec) != next_bno)
 			continue;
 
-		error = xfs_btree_delete(cur, &has);
+		error = xfs_btree_delete(cur);
 		if (error)
 			goto out_cur;
 
-- 
2.55.0

