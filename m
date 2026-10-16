Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005963CEBBA
	for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 19:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792179288; cv=none; b=Wzm/xI90LQy6NzF6zkxVDyKgG8fq0jHNbtu5hEtZdlN7a9Cq2D+VNwQ29Sf7ZzUbdveG/Y0mwxmYFj8255j+ADVFHPIQ9yo4mDZ/0LX4H4bgZ4JVbHDgY04a4f1cEOv08wR9LNzRAlPm8mdnnZAUBSomgccC66tbEJN1+sc7480=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792179288; c=relaxed/simple;
	bh=VYDdAi297oHSfDfWmiAYayX7drPTG/2eR4cxP/b8N2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JWxLi3zU89MLSbDV/dBaPPufwV8Aw3US+05/XhdxPGUAZrkQH2w/auEkB1BFqeaV6Tzy7PyhYMHTMhKUcp0C5cmf+nrem/Up7jlq/xogyOaJ85rKAqcfeqn17ikSnddWRg0tBvCeybgf/QpUjpjFo2eY95AY+IAZLd6S0oMm0K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZfVn8Ene; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=QfRGx5E9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZfVn8Ene";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="QfRGx5E9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792179283;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eOimnxHnSWI+l2j4R4qUXsJ7vDbcGC/SgydpZ9GSCPc=;
	b=ZfVn8EneKhew0+RByk0CvOTxHPnfSJoRsvzvE2sIRzIcPKn4O393jPhdtaJp3AlXxjyo8r
	Mcs7vpW7x1AORKr/9kEfXpb+MlFpz2Trc34REKJMzITFwbng5xWk/DcWFcbjuWHyOb0DYf
	MQQUbCsMX4v28+ykUJ2AmfDOuFlk7Yk=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-264-jc1gWU6OOaSeUg0P2k7WsQ-1; Fri, 16 Oct 2026 19:34:35 +0000
X-MC-Unique: jc1gWU6OOaSeUg0P2k7WsQ-1
X-Mimecast-MFC-AGG-ID: jc1gWU6OOaSeUg0P2k7WsQ_1792179275
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-917a109c937so4745366d6.2
        for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 12:34:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1792179275; x=1792784075; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eOimnxHnSWI+l2j4R4qUXsJ7vDbcGC/SgydpZ9GSCPc=;
        b=QfRGx5E9BJB+CHQ1K+exZ/y7rDYXzlIZ6v7LhILMIfN20i6dXafSnfRqmW4hYvx/ar
         zIyPKbhjq9hNQxe17f53iroDzJgfeP9p03yXf6SN8b29To5WEqEDyrIN3Shx7GkYnTJh
         joJ/OKQtyolfG3wBqx8oed90RR/B//3RSEEz2T2D9rhhcSEAazHdr/vW24CNi/vN8gl/
         /ByV1UH5G/T6tAToG7KN1Z8k2ORv6DlgVizFAVFX22MzgBhHShunITQc0lxdfjo9oq/J
         z8xHhOwz7eN+Ucr596COYdps/wHXqmrBCZrs+WvCz6sRENgahcUzZJnt31gAyXkddkpM
         I8Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792179275; x=1792784075;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=eOimnxHnSWI+l2j4R4qUXsJ7vDbcGC/SgydpZ9GSCPc=;
        b=1bLKck7i/0N4+4+Yee8lbeiQ0pF5pzTJUZCxlGZxoHS4eDSitfobHidozla4PZgyHL
         aENoSVM7/0XLEbL0B1eiePelE5F/1yH+43fUqgEE5QZH7GS32qELFDBNGOaRjms6rWBu
         tNpAtqXYm0jUkect1kGSJ6MpH8T1XO3IkgqiMsShdU7u2X3dz4f0HO1SqpzV40lF+LRM
         LDO9gXmwScyDNIJA8RPJV+5h6qabwgQmUdyw/zrMylw2dguloV4ftCUF7cl6u/+00lyk
         ddy5TI/phfWaBCv63nwWNHIcYI7CU/3ASH8T79L0cx1cOyVqYALcS4ZIyR2BPAgV+eqI
         Snog==
X-Gm-Message-State: AFq9FYIwVQ3jixSAen9yUGdCwv0yhvYWLyLTwsgqfYbB5hYejInAYZbS
	D4t8lnMGy+cid5h2x8yETXqBr+lihjv7yGTTv5kYCmrVhH4Yz7RSQsX1BFp+r3wuZ7Ox5rSd592
	5TgtL6JI3SUezOB//XMh8m5hqX0dpVFqCfSOofCItE7fefJcNUpWGnFa6cQ09YGwh2rg2sDfNsT
	2LLQyNlGA0IGIi84ttrCc/de/CVAxfE2Yo4SU877bnSH3c
X-Gm-Gg: AYBFou1jQUwFJhxrR3fgcdRtsD6mx/ddHxyBw6HDYUYTf04ME66hQc/GBroi81obaU5
	YNwG1nL0fJbW8wcointabp+DBqe5fFqFYieC1GW8L432nwn1MGqkVKnbyM1yAWaFfn5BbK5mVn8
	aQnu8KQd8JgH7Hy4bcTGydJt3B4heO6MVeJtLILLDlb0FP7q9s8P1lEXyTCBElWKijGnErWYMN9
	A+/omCWQWxVoZA4VUwLTB6WEzkflB4gYObuWgBCEDIQ/oH0UG2BGneVP8fOKamr4u9/4mGyzVyO
	1PCQa1PVcGRBibzus4ggM4iSe8PUOcDvbfQSA1VvoY8A+SEQvLrbCQe6qgv/+FYkrRP7I/kSXR9
	wkOoHvjYAZiYUxweghLUHr8hba25P20a/ewiydA==
X-Received: by 2002:a05:620a:29d5:b0:93f:167e:d98d with SMTP id af79cd13be357-93f29d45bebmr160039885a.43.1792179275059;
        Fri, 16 Oct 2026 12:34:35 -0700 (PDT)
X-Received: by 2002:a05:620a:29d5:b0:93f:167e:d98d with SMTP id af79cd13be357-93f29d45bebmr160033785a.43.1792179274386;
        Fri, 16 Oct 2026 12:34:34 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f1a1a990fsm284359185a.35.2026.10.16.12.34.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 12:34:33 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	hch@lst.de,
	dgc@kernel.org,
	Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 5/8] xfs: remove status parameter from several btree insert functions
Date: Fri, 16 Oct 2026 14:29:05 -0500
Message-ID: <20261016193422.1630907-6-sandeen@redhat.com>
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

xfs_btree_insert and its callers now have no need for the status
parameter; either they return error = 0 / status = 1, or nonzero error
and status 0. No caller evaluates the status variable, so remove that
parameter from these functions.

As requested, convert all of the compound tests/assignments to discrete
lines.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c    | 15 ++++++++++-----
 fs/xfs/libxfs/xfs_bmap.c     | 26 +++++++++++++++-----------
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
 12 files changed, 53 insertions(+), 53 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index b40c51a0f651..acd8f4521c4c 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -692,7 +692,8 @@ xfs_alloc_fixup_trees(
 			xfs_btree_mark_sick(cnt_cur);
 			return -EFSCORRUPTED;
 		}
-		if ((error = xfs_btree_insert(cnt_cur, &i)))
+		error = xfs_btree_insert(cnt_cur);
+		if (error)
 			return error;
 	}
 	if (nfbno2 != NULLAGBLOCK) {
@@ -702,7 +703,8 @@ xfs_alloc_fixup_trees(
 			xfs_btree_mark_sick(cnt_cur);
 			return -EFSCORRUPTED;
 		}
-		if ((error = xfs_btree_insert(cnt_cur, &i)))
+		error = xfs_btree_insert(cnt_cur);
+		if (error)
 			return error;
 	}
 	/*
@@ -735,7 +737,8 @@ xfs_alloc_fixup_trees(
 			xfs_btree_mark_sick(bno_cur);
 			return -EFSCORRUPTED;
 		}
-		if ((error = xfs_btree_insert(bno_cur, &i)))
+		error = xfs_btree_insert(bno_cur);
+		if (error)
 			return error;
 	}
 
@@ -2300,7 +2303,8 @@ xfs_free_ag_extent(
 	else {
 		nbno = bno;
 		nlen = len;
-		if ((error = xfs_btree_insert(bno_cur, &i)))
+		error = xfs_btree_insert(bno_cur);
+		if (error)
 			goto error0;
 	}
 	xfs_btree_del_cursor(bno_cur, XFS_BTREE_NOERROR);
@@ -2322,7 +2326,8 @@ xfs_free_ag_extent(
 	}
 	if (xfs_alloc_cursor_at_lastrec(cnt_cur))
 		fixup_longest = true;
-	if ((error = xfs_btree_insert(cnt_cur, &i)))
+	error = xfs_btree_insert(cnt_cur);
+	if (error)
 		goto error0;
 	if (fixup_longest) {
 		error = xfs_alloc_fixup_longest(cnt_cur);
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 073c11e631ea..09d6792e42be 100644
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
@@ -2328,7 +2328,8 @@ xfs_bmap_add_extent_unwritten_real(
 			if (error)
 				goto done;
 			cur->bc_rec.b = *new;
-			if ((error = xfs_btree_insert(cur, &i)))
+			error = xfs_btree_insert(cur);
+			if (error)
 				goto done;
 		}
 		break;
@@ -2409,7 +2410,8 @@ xfs_bmap_add_extent_unwritten_real(
 				error = -EFSCORRUPTED;
 				goto done;
 			}
-			if ((error = xfs_btree_insert(cur, &i)))
+			error = xfs_btree_insert(cur);
+			if (error)
 				goto done;
 		}
 		break;
@@ -2454,7 +2456,8 @@ xfs_bmap_add_extent_unwritten_real(
 				goto done;
 			/* new left extent - oldext */
 			cur->bc_rec.b = PREV;
-			if ((error = xfs_btree_insert(cur, &i)))
+			error = xfs_btree_insert(cur);
+			if (error)
 				goto done;
 			/*
 			 * Reset the cursor to the position of the new extent
@@ -2470,7 +2473,8 @@ xfs_bmap_add_extent_unwritten_real(
 				goto done;
 			}
 			/* new middle extent - newext */
-			if ((error = xfs_btree_insert(cur, &i)))
+			error = xfs_btree_insert(cur);
+			if (error)
 				goto done;
 		}
 		break;
@@ -2724,7 +2728,7 @@ xfs_bmap_add_extent_hole_real(
 				error = -EFSCORRUPTED;
 				goto done;
 			}
-			error = xfs_btree_insert(cur, &i);
+			error = xfs_btree_insert(cur);
 			if (error)
 				goto done;
 		}
@@ -5013,7 +5017,7 @@ xfs_bmap_del_extent_real(
 			if (error)
 				return error;
 			cur->bc_rec.b = new;
-			error = xfs_btree_insert(cur, &i);
+			error = xfs_btree_insert(cur);
 			if (error && error != -ENOSPC)
 				return error;
 			/*
@@ -5906,7 +5910,7 @@ xfs_bmap_split_extent(
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

