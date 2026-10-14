Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164AD1DDF0
	for <linux-xfs@vger.kernel.org>; Wed, 14 Oct 2026 03:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791949870; cv=none; b=fbbWKV+hLubIwl4Ubp/iOoblRUUxiTZsmTiX7wxZnL7b5r+6DM1KBZ9Yh+Vcr9CizI6ALIBRpGXNbm1At48Xg1R25WXXtfe97hkSY59z0e/wQHsIZuCyvUcBFw6eyiDWr/iyvGk3V3UkGe4Ddgf6KLnrtj8QBwyOUigQhMO2nR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791949870; c=relaxed/simple;
	bh=AyT5WZZDUYNZm9wzgJ8Gd0H/0P8zSnsNlIMMhOErzS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k9eVcnsyylGSLiwsIE12jVLIMZhJQ8sHR8mTVvv8v8eIhOfa2+WY+bq0pcuoVYiMaP3y300YeX6Rs77q67lG7pMJ/ZzfuJ4NqM7JhX02aAFfZpFzUwN+tKPpr6d3/li9SQ5PUEz8Qnktm4vKw/kjdrJSxHDDQ/Gm36M2EI3HIDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bMlChEhh; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=PmAoU79c; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bMlChEhh";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="PmAoU79c"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791949868;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pjl1n0gEgfszLXfg2+hqVie6bralnQoRRgQX4jfrEKY=;
	b=bMlChEhhqS5DZs1tDnI45xjFKoXuF0UK146HddPZQlxbmavzOSW6l6SGdWxgUQQRAfKF2t
	iq0MMHVGYW+vC2JXf2u/YQMusuj7rcqPapQIrhu0RvUOH34h/yelhgyNxsqGt3ADunrWpx
	zBer4NLYOcsqL0On20KGb5i3N77fC+w=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-501-uuY0KTHbNr2D8M1dnn0Z_Q-1; Wed, 14 Oct 2026 03:51:04 +0000
X-MC-Unique: uuY0KTHbNr2D8M1dnn0Z_Q-1
X-Mimecast-MFC-AGG-ID: uuY0KTHbNr2D8M1dnn0Z_Q_1791949864
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-93a1de6d5c3so842381585a.3
        for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 20:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1791949864; x=1792554664; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pjl1n0gEgfszLXfg2+hqVie6bralnQoRRgQX4jfrEKY=;
        b=PmAoU79cdBjeT1AQYrKWZWJoUXF1b5tRMt8uXRN6kxpEpB+JTqzDC/zR+7L2+v7x7f
         b1zJFw8epYAyL5tyCBWD34rkS98kAUbF+RGo2pvMPQtA/eQlGzqIGRbxLooG0tZ9n1aB
         H75w9avm8FPm0sLEN9Iv2iAC7wm3yqRKU/lf8nSB0Wiq3BIdeTxvNzmZwiRGHPO4kHOK
         CsGSIqcmV0YxmoKuEr2gYQI2CDMnC7cbGjDlfJOVkE9MU25FvCjucgG9cp2UHv7tZnhG
         G4hRFJGLh7VVzxDGraH9TtJTpLsHpzhnii7inooQZPww3l+ARDYf4xh4Tt6Q3wXivUWZ
         YACA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791949864; x=1792554664;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=pjl1n0gEgfszLXfg2+hqVie6bralnQoRRgQX4jfrEKY=;
        b=PJAVWUkhGYOzvBrNwmwDGRB9CzRXZq3FAMdS0GYUir+zWos6ZesF1HAfQTMArzNLgK
         O2TYxokVJOs7ZTdkSEJyopcBhlzGJdZq+v5/0TV9kh2z4DK7/3KiSM3fYE8409yMkY67
         vRPzYVIFIENO7kBHVFYdM05b5vL3io4WblOfwkVxenNoB2ws6evGovMpNeAa/dopavE0
         GiUeYvDBqDvhLgNdzqH6arRxmk7AMGRvY3KfsoRuqeRMZBcTYabLlrGdKk2U2qTMJSyQ
         zgOGOfM+M6vZpmcihP53VipyvSQDfHifX6r5azBlRf4JshpplphAeMzXwTNmVV3lFNnW
         05Lw==
X-Gm-Message-State: AFq9FYK2ySkLx/+g2ByV8goYTUNb2bkG1uv7sxyRkV+pz9ME6IWcLUOL
	XKNTBnWA8o4w3haak57Q/3Uk3qp6/M462z/456FCiagSK2svMAeLk5xmdToQ018TsPCTM1IRbJK
	MD8Iu4wFGLGgmxfGA5lqId805TEeSyAahUeumrhXObssL+MJZKRkPwpOpw7f2hSYPCW0g/5DCTh
	pkILF/iGHFZbI/EieAvyY2tPfDR9RukdBzETepfpfDgokx
X-Gm-Gg: AYBFou2cc2t+Ao+p37hXVO80kBjTho+XcXsDmczJgG7XwDlMhrTkAoN4uHXBdgaib4L
	WuwPTNuY7rxVTlrEwbSm3IQ/Hz0QZIftYIrBEZQINbbH95Ui9TI8SAQy/89++8zx/YvMHvvMOVW
	iu+FeDdK8mBmHCD5LPovI/SyhT3rcGTFjS4NvIl8CXtmODUSb6eR56Iet2dUTsEM+kUfVLVvT3l
	VDPKeFm/VxiJ7xq1zt9v6Lk0O/jWMcDkYCEytcpHF20kaVmke5i4vminz4+BlUITyxxi4ksQIZC
	qcQNvAFtZHk/kPtmsCb1oTjl0NkDpR4JWcaJCGemVoHxsNHEPzj5r3gFuQZ6g2yYj6hYywCirT8
	0ikk5fzDmFXQPnFH1roQ8rLEfOTU/qw5RVBtPRQ==
X-Received: by 2002:a05:620a:a0cd:20b0:93e:c12c:f149 with SMTP id af79cd13be357-93ec12d0893mr1661563285a.83.1791949864083;
        Tue, 13 Oct 2026 20:51:04 -0700 (PDT)
X-Received: by 2002:a05:620a:a0cd:20b0:93e:c12c:f149 with SMTP id af79cd13be357-93ec12d0893mr1661561285a.83.1791949863449;
        Tue, 13 Oct 2026 20:51:03 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93ef50b6c4fsm393907285a.47.2026.10.13.20.51.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 20:51:02 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	djwong@kernel.org,
	hch@lst.de,
	Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 5/5] xfs: remove status parameter from several btree insert functions
Date: Tue, 13 Oct 2026 20:30:03 -0500
Message-ID: <20261014013505.759089-6-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261014013505.759089-1-sandeen@redhat.com>
References: <20261014013505.759089-1-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xfs_btree_insert and its callers now have no need for the status
parameter; either they return error = 0 / status = 1, or nonzero error
and status 0. Every caller now handles the error and never reaches
the duplicate status variable check. Remove the status params.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c    | 10 +++++-----
 fs/xfs/libxfs/xfs_bmap.c     | 22 +++++++++++-----------
 fs/xfs/libxfs/xfs_btree.c    |  4 +---
 fs/xfs/libxfs/xfs_btree.h    |  2 +-
 fs/xfs/libxfs/xfs_ialloc.c   | 13 ++++++-------
 fs/xfs/libxfs/xfs_ialloc.h   |  3 +--
 fs/xfs/libxfs/xfs_refcount.c | 17 +++++++----------
 fs/xfs/libxfs/xfs_refcount.h |  2 +-
 fs/xfs/libxfs/xfs_rmap.c     | 14 +++++++-------
 fs/xfs/scrub/rcbag.c         |  2 +-
 fs/xfs/scrub/rcbag_btree.c   |  5 ++---
 fs/xfs/scrub/rcbag_btree.h   |  3 +--
 12 files changed, 44 insertions(+), 53 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index b40c51a0f651..13a61144a2c8 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -692,7 +692,7 @@ xfs_alloc_fixup_trees(
 			xfs_btree_mark_sick(cnt_cur);
 			return -EFSCORRUPTED;
 		}
-		if ((error = xfs_btree_insert(cnt_cur, &i)))
+		if ((error = xfs_btree_insert(cnt_cur)))
 			return error;
 	}
 	if (nfbno2 != NULLAGBLOCK) {
@@ -702,7 +702,7 @@ xfs_alloc_fixup_trees(
 			xfs_btree_mark_sick(cnt_cur);
 			return -EFSCORRUPTED;
 		}
-		if ((error = xfs_btree_insert(cnt_cur, &i)))
+		if ((error = xfs_btree_insert(cnt_cur)))
 			return error;
 	}
 	/*
@@ -735,7 +735,7 @@ xfs_alloc_fixup_trees(
 			xfs_btree_mark_sick(bno_cur);
 			return -EFSCORRUPTED;
 		}
-		if ((error = xfs_btree_insert(bno_cur, &i)))
+		if ((error = xfs_btree_insert(bno_cur)))
 			return error;
 	}
 
@@ -2300,7 +2300,7 @@ xfs_free_ag_extent(
 	else {
 		nbno = bno;
 		nlen = len;
-		if ((error = xfs_btree_insert(bno_cur, &i)))
+		if ((error = xfs_btree_insert(bno_cur)))
 			goto error0;
 	}
 	xfs_btree_del_cursor(bno_cur, XFS_BTREE_NOERROR);
@@ -2322,7 +2322,7 @@ xfs_free_ag_extent(
 	}
 	if (xfs_alloc_cursor_at_lastrec(cnt_cur))
 		fixup_longest = true;
-	if ((error = xfs_btree_insert(cnt_cur, &i)))
+	if ((error = xfs_btree_insert(cnt_cur)))
 		goto error0;
 	if (fixup_longest) {
 		error = xfs_alloc_fixup_longest(cnt_cur);
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index a7e548078d18..a2f46037e0c3 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1671,7 +1671,7 @@ xfs_bmap_add_extent_delay_real(
 				error = -EFSCORRUPTED;
 				goto done;
 			}
-			error = xfs_btree_insert(bma->cur, &i);
+			error = xfs_btree_insert(bma->cur);
 			if (error)
 				goto done;
 		}
@@ -1737,7 +1737,7 @@ xfs_bmap_add_extent_delay_real(
 				error = -EFSCORRUPTED;
 				goto done;
 			}
-			error = xfs_btree_insert(bma->cur, &i);
+			error = xfs_btree_insert(bma->cur);
 			if (error)
 				goto done;
 		}
@@ -1823,7 +1823,7 @@ xfs_bmap_add_extent_delay_real(
 				error = -EFSCORRUPTED;
 				goto done;
 			}
-			error = xfs_btree_insert(bma->cur, &i);
+			error = xfs_btree_insert(bma->cur);
 			if (error)
 				goto done;
 		}
@@ -1907,7 +1907,7 @@ xfs_bmap_add_extent_delay_real(
 				error = -EFSCORRUPTED;
 				goto done;
 			}
-			error = xfs_btree_insert(bma->cur, &i);
+			error = xfs_btree_insert(bma->cur);
 			if (error)
 				goto done;
 		}
@@ -2328,7 +2328,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if (error)
 				goto done;
 			cur->bc_rec.b = *new;
-			if ((error = xfs_btree_insert(cur, &i)))
+			if ((error = xfs_btree_insert(cur)))
 				goto done;
 		}
 		break;
@@ -2409,7 +2409,7 @@ xfs_bmap_add_extent_unwritten_real(
 				error = -EFSCORRUPTED;
 				goto done;
 			}
-			if ((error = xfs_btree_insert(cur, &i)))
+			if ((error = xfs_btree_insert(cur)))
 				goto done;
 		}
 		break;
@@ -2454,7 +2454,7 @@ xfs_bmap_add_extent_unwritten_real(
 				goto done;
 			/* new left extent - oldext */
 			cur->bc_rec.b = PREV;
-			if ((error = xfs_btree_insert(cur, &i)))
+			if ((error = xfs_btree_insert(cur)))
 				goto done;
 			/*
 			 * Reset the cursor to the position of the new extent
@@ -2470,7 +2470,7 @@ xfs_bmap_add_extent_unwritten_real(
 				goto done;
 			}
 			/* new middle extent - newext */
-			if ((error = xfs_btree_insert(cur, &i)))
+			if ((error = xfs_btree_insert(cur)))
 				goto done;
 		}
 		break;
@@ -2724,7 +2724,7 @@ xfs_bmap_add_extent_hole_real(
 				error = -EFSCORRUPTED;
 				goto done;
 			}
-			error = xfs_btree_insert(cur, &i);
+			error = xfs_btree_insert(cur);
 			if (error)
 				goto done;
 		}
@@ -5013,7 +5013,7 @@ xfs_bmap_del_extent_real(
 			if (error)
 				return error;
 			cur->bc_rec.b = new;
-			error = xfs_btree_insert(cur, &i);
+			error = xfs_btree_insert(cur);
 			if (error && error != -ENOSPC)
 				return error;
 			/*
@@ -5906,7 +5906,7 @@ xfs_bmap_split_extent(
 			error = -EFSCORRUPTED;
 			goto del_cursor;
 		}
-		error = xfs_btree_insert(cur, &i);
+		error = xfs_btree_insert(cur);
 		if (error)
 			goto del_cursor;
 	}
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 7effebe297ea..e2e698596c21 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -3728,8 +3728,7 @@ xfs_btree_insrec(
  */
 int
 xfs_btree_insert(
-	struct xfs_btree_cur	*cur,
-	int			*stat)
+	struct xfs_btree_cur	*cur)
 {
 	int			error;	/* error return value */
 	int			i;	/* result value, 0 for failure */
@@ -3798,7 +3797,6 @@ xfs_btree_insert(
 		}
 	} while (!xfs_btree_ptr_is_null(cur, &nptr));
 
-	*stat = i;
 	return 0;
 error0:
 	return error;
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 60e78572e725..0f82f3106bac 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -405,7 +405,7 @@ int xfs_btree_decrement(struct xfs_btree_cur *, int, int *);
 int xfs_btree_lookup(struct xfs_btree_cur *, xfs_lookup_t, int *);
 int xfs_btree_update(struct xfs_btree_cur *, union xfs_btree_rec *);
 int xfs_btree_new_iroot(struct xfs_btree_cur *, int *, int *);
-int xfs_btree_insert(struct xfs_btree_cur *, int *);
+int xfs_btree_insert(struct xfs_btree_cur *);
 int xfs_btree_delete(struct xfs_btree_cur *, int *);
 int xfs_btree_get_rec(struct xfs_btree_cur *, union xfs_btree_rec **, int *);
 int xfs_btree_change_owner(struct xfs_btree_cur *cur, uint64_t new_owner,
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index fd916a2a005b..bd7b0a24225f 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -186,14 +186,13 @@ xfs_inobt_insert_rec(
 	uint16_t		holemask,
 	uint8_t			count,
 	int32_t			freecount,
-	xfs_inofree_t		free,
-	int			*stat)
+	xfs_inofree_t		free)
 {
 	cur->bc_rec.i.ir_holemask = holemask;
 	cur->bc_rec.i.ir_count = count;
 	cur->bc_rec.i.ir_freecount = freecount;
 	cur->bc_rec.i.ir_free = free;
-	return xfs_btree_insert(cur, stat);
+	return xfs_btree_insert(cur);
 }
 
 /*
@@ -231,7 +230,7 @@ xfs_inobt_insert(
 		error = xfs_inobt_insert_rec(cur, XFS_INOBT_HOLEMASK_FULL,
 					     XFS_INODES_PER_CHUNK,
 					     XFS_INODES_PER_CHUNK,
-					     XFS_INOBT_ALL_FREE, &i);
+					     XFS_INOBT_ALL_FREE);
 		if (error) {
 			xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
 			return error;
@@ -568,7 +567,7 @@ xfs_inobt_insert_sprec(
 	if (i == 0) {
 		error = xfs_inobt_insert_rec(cur, nrec->ir_holemask,
 					     nrec->ir_count, nrec->ir_freecount,
-					     nrec->ir_free, &i);
+					     nrec->ir_free);
 		if (error)
 			goto error;
 		goto out;
@@ -654,7 +653,7 @@ xfs_finobt_insert_sprec(
 	if (i == 0) {
 		error = xfs_inobt_insert_rec(cur, nrec->ir_holemask,
 					     nrec->ir_count, nrec->ir_freecount,
-					     nrec->ir_free, &i);
+					     nrec->ir_free);
 		if (error)
 			goto error;
 	} else {
@@ -2238,7 +2237,7 @@ xfs_difree_finobt(
 		error = xfs_inobt_insert_rec(cur, ibtrec->ir_holemask,
 					     ibtrec->ir_count,
 					     ibtrec->ir_freecount,
-					     ibtrec->ir_free, &i);
+					     ibtrec->ir_free);
 		if (error)
 			goto error;
 		goto out;
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index 3a1323155a45..49c3d4c513c9 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -105,8 +105,7 @@ int xfs_ialloc_has_inodes_at_extent(struct xfs_btree_cur *cur,
 int xfs_ialloc_count_inodes(struct xfs_btree_cur *cur, xfs_agino_t *count,
 		xfs_agino_t *freecount);
 int xfs_inobt_insert_rec(struct xfs_btree_cur *cur, uint16_t holemask,
-		uint8_t count, int32_t freecount, xfs_inofree_t free,
-		int *stat);
+		uint8_t count, int32_t freecount, xfs_inofree_t free);
 
 int xfs_ialloc_cluster_alignment(struct xfs_mount *mp);
 void xfs_ialloc_setup_geometry(struct xfs_mount *mp);
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index aec6c839220a..574a5e7c0cdf 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -263,8 +263,7 @@ xfs_refcount_update(
 int
 xfs_refcount_insert(
 	struct xfs_btree_cur		*cur,
-	struct xfs_refcount_irec	*irec,
-	int				*i)
+	struct xfs_refcount_irec	*irec)
 {
 	int				error;
 
@@ -275,7 +274,7 @@ xfs_refcount_insert(
 	cur->bc_rec.rc.rc_refcount = irec->rc_refcount;
 	cur->bc_rec.rc.rc_domain = irec->rc_domain;
 
-	error = xfs_btree_insert(cur, i);
+	error = xfs_btree_insert(cur);
 	if (error)
 		trace_xfs_refcount_insert_error(cur, error, _RET_IP_);
 	return error;
@@ -454,7 +453,7 @@ xfs_refcount_split_extent(
 	/* Insert the left extent. */
 	tmp = rcext;
 	tmp.rc_blockcount = agbno - rcext.rc_startblock;
-	error = xfs_refcount_insert(cur, &tmp, &found_rec);
+	error = xfs_refcount_insert(cur, &tmp);
 	if (error)
 		goto out_error;
 
@@ -1141,7 +1140,7 @@ xfs_refcount_adjust_extents(
 {
 	struct xfs_refcount_irec	ext, tmp;
 	int				error;
-	int				found_rec, found_tmp;
+	int				found_rec;
 
 	/* Merging did all the work already. */
 	if (*aglen == 0)
@@ -1183,8 +1182,7 @@ xfs_refcount_adjust_extents(
 			 */
 			cur->bc_refc.nr_ops++;
 			if (tmp.rc_refcount) {
-				error = xfs_refcount_insert(cur, &tmp,
-						&found_tmp);
+				error = xfs_refcount_insert(cur, &tmp);
 				if (error)
 					goto out_error;
 			} else {
@@ -1784,7 +1782,7 @@ xfs_refcount_adjust_cow_extents(
 {
 	struct xfs_refcount_irec	ext, tmp;
 	int				error;
-	int				found_rec, found_tmp;
+	int				found_rec;
 
 	if (aglen == 0)
 		return 0;
@@ -1827,8 +1825,7 @@ xfs_refcount_adjust_cow_extents(
 
 		trace_xfs_refcount_modify_extent(cur, &tmp);
 
-		error = xfs_refcount_insert(cur, &tmp,
-				&found_tmp);
+		error = xfs_refcount_insert(cur, &tmp);
 		if (error)
 			goto out_error;
 		break;
diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
index f2e299a716a4..cf300532bf04 100644
--- a/fs/xfs/libxfs/xfs_refcount.h
+++ b/fs/xfs/libxfs/xfs_refcount.h
@@ -126,7 +126,7 @@ xfs_failaddr_t xfs_refcount_check_irec(struct xfs_perag *pag,
 xfs_failaddr_t xfs_rtrefcount_check_irec(struct xfs_rtgroup *rtg,
 		const struct xfs_refcount_irec *irec);
 extern int xfs_refcount_insert(struct xfs_btree_cur *cur,
-		struct xfs_refcount_irec *irec, int *stat);
+		struct xfs_refcount_irec *irec);
 
 extern struct kmem_cache	*xfs_refcount_intent_cache;
 
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index ff4aef8d30a7..99575ae419a7 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -145,7 +145,7 @@ xfs_rmap_insert(
 	rcur->bc_rec.r.rm_owner = owner;
 	rcur->bc_rec.r.rm_offset = offset;
 	rcur->bc_rec.r.rm_flags = flags;
-	error = xfs_btree_insert(rcur, &i);
+	error = xfs_btree_insert(rcur);
 done:
 	if (error)
 		trace_xfs_rmap_insert_error(rcur, error, _RET_IP_);
@@ -855,7 +855,7 @@ xfs_rmap_unmap(
 				cur->bc_rec.r.rm_owner,
 				cur->bc_rec.r.rm_offset,
 				cur->bc_rec.r.rm_flags);
-		error = xfs_btree_insert(cur, &i);
+		error = xfs_btree_insert(cur);
 		if (error)
 			goto out_error;
 	}
@@ -1175,7 +1175,7 @@ xfs_rmap_map(
 		cur->bc_rec.r.rm_offset = offset;
 		cur->bc_rec.r.rm_flags = flags;
 		trace_xfs_rmap_insert(cur, bno, len, owner, offset, flags);
-		error = xfs_btree_insert(cur, &i);
+		error = xfs_btree_insert(cur);
 		if (error)
 			goto out_error;
 	}
@@ -1577,7 +1577,7 @@ xfs_rmap_convert(
 		NEW.rm_flags = newext;
 		cur->bc_rec.r = NEW;
 		trace_xfs_rmap_insert(cur, bno, len, owner, offset, newext);
-		error = xfs_btree_insert(cur, &i);
+		error = xfs_btree_insert(cur);
 		if (error)
 			goto done;
 		break;
@@ -1630,7 +1630,7 @@ xfs_rmap_convert(
 		NEW.rm_flags = newext;
 		cur->bc_rec.r = NEW;
 		trace_xfs_rmap_insert(cur, bno, len, owner, offset, newext);
-		error = xfs_btree_insert(cur, &i);
+		error = xfs_btree_insert(cur);
 		if (error)
 			goto done;
 		break;
@@ -1658,7 +1658,7 @@ xfs_rmap_convert(
 		trace_xfs_rmap_insert(cur, NEW.rm_startblock,
 				NEW.rm_blockcount, NEW.rm_owner, NEW.rm_offset,
 				NEW.rm_flags);
-		error = xfs_btree_insert(cur, &i);
+		error = xfs_btree_insert(cur);
 		if (error)
 			goto done;
 		/*
@@ -1679,7 +1679,7 @@ xfs_rmap_convert(
 		cur->bc_rec.r.rm_flags &= ~XFS_RMAP_UNWRITTEN;
 		cur->bc_rec.r.rm_flags |= newext;
 		trace_xfs_rmap_insert(cur, bno, len, owner, offset, newext);
-		error = xfs_btree_insert(cur, &i);
+		error = xfs_btree_insert(cur);
 		if (error)
 			goto done;
 		break;
diff --git a/fs/xfs/scrub/rcbag.c b/fs/xfs/scrub/rcbag.c
index fd9ccb205725..41e798f65c67 100644
--- a/fs/xfs/scrub/rcbag.c
+++ b/fs/xfs/scrub/rcbag.c
@@ -102,7 +102,7 @@ rcbag_add(
 		bagrec.rbg_blockcount = rmap->rm_blockcount;
 		bagrec.rbg_refcount = 1;
 
-		error = rcbagbt_insert(cur, &bagrec, &has);
+		error = rcbagbt_insert(cur, &bagrec);
 		if (error)
 			goto out_cur;
 	}
diff --git a/fs/xfs/scrub/rcbag_btree.c b/fs/xfs/scrub/rcbag_btree.c
index 367f8ccf55c4..790931fa8f06 100644
--- a/fs/xfs/scrub/rcbag_btree.c
+++ b/fs/xfs/scrub/rcbag_btree.c
@@ -342,11 +342,10 @@ rcbagbt_update(
 int
 rcbagbt_insert(
 	struct xfs_btree_cur	*cur,
-	const struct rcbag_rec	*rec,
-	int			*success)
+	const struct rcbag_rec	*rec)
 {
 	struct rcbag_rec	*btrec = (struct rcbag_rec *)&cur->bc_rec;
 
 	memcpy(btrec, rec, sizeof(struct rcbag_rec));
-	return xfs_btree_insert(cur, success);
+	return xfs_btree_insert(cur);
 }
diff --git a/fs/xfs/scrub/rcbag_btree.h b/fs/xfs/scrub/rcbag_btree.h
index 03cadb032552..da45d9e885f8 100644
--- a/fs/xfs/scrub/rcbag_btree.h
+++ b/fs/xfs/scrub/rcbag_btree.h
@@ -70,8 +70,7 @@ int rcbagbt_lookup_eq(struct xfs_btree_cur *cur,
 		const struct xfs_rmap_irec *rmap, int *success);
 int rcbagbt_get_rec(struct xfs_btree_cur *cur, struct rcbag_rec *rec, int *has);
 int rcbagbt_update(struct xfs_btree_cur *cur, const struct rcbag_rec *rec);
-int rcbagbt_insert(struct xfs_btree_cur *cur, const struct rcbag_rec *rec,
-		int *success);
+int rcbagbt_insert(struct xfs_btree_cur *cur, const struct rcbag_rec *rec);
 
 #else
 # define rcbagbt_init_cur_cache()		0
-- 
2.55.0

