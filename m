Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982933C10A9
	for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 19:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792179284; cv=none; b=kN/7xNAxJK8Nfn33j3EqDAwU9hJHdG3+5FJlIkJspte+Szp2CN61xaYmmew+s9qPYAYio4TKI/U09qQ5qQ3VT+1+pLq/OOjxr84Y1Nf/hLD6A1cLsbSwJ99bJj/rOjhkSYhTG1exwFQeI64u/wNJ7UMq1282SqerK21Y8d+sZEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792179284; c=relaxed/simple;
	bh=TyBhwcqfIOvc3tb7ptnWVMwNdgZadEg9U4LqLypjXaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ss0dKjup5JaNbQ8iK+Ii+OGvUzX2WzRGLkf9sf0oNYyL9hC6UHZ8U4brKUNLiJimJ+a3CjvpcpG/v8vXA6QF32scNKXapGbFuS4UaK8jq9iand9+3JXV+u18dFtPHTxXGYcotIKpOiMfikFGoMlPXYULbbtKVWkr1TeleX+n3JQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IjHxffSL; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=aMUyhKkx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IjHxffSL";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="aMUyhKkx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792179278;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aX8BMwzWvjwy0zU80VugHODY2Qm8YSCHtwDCUWH9+Eo=;
	b=IjHxffSLo9DZVZnD5umI1aC2Nyxe2dYjgdqt7JWXWxfeCyJM4Dcn8IrGrj5EbdBqlSnzoe
	OOrDzd6nDlIKNynO8qOmynLHOnqYTm79vlW1QU65k6pu5/Jl9cLMIW0KiAvyLiLbEuM05w
	RSN3JhEsgQVqMiQIzRSCeRvBz2vUvds=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-17-8NiWX7xwMHqR02rqfbXHbQ-1; Fri, 16 Oct 2026 19:34:37 +0000
X-MC-Unique: 8NiWX7xwMHqR02rqfbXHbQ-1
X-Mimecast-MFC-AGG-ID: 8NiWX7xwMHqR02rqfbXHbQ_1792179276
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-93ca9b53afaso84380085a.0
        for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 12:34:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1792179276; x=1792784076; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aX8BMwzWvjwy0zU80VugHODY2Qm8YSCHtwDCUWH9+Eo=;
        b=aMUyhKkxcwtoYmiIwc5PjKos+Gi9yYhxKJD5fj3CqoBx1ljawfalO8lM6DkmzU6YtB
         nASByEAEdu5uaIHRlK5IoAAdlDOGqO0gPMa7wSRwCnWln6rokW2LD5DUu4Klxb092n0k
         Hro7GYHqZK+BrV7zZkho6JpP1/paQkkZnuOi1j+ygzdp2L6e1qlm37Bm0Nn9/9P5yedU
         MNfHfUrud86D4xdApILsfsYZDaaNm8MaK8HbsS+uB7F+wGRiXtw1K14PgautjQRoHAQf
         HlEy3FHeqGaqeEdZVwL1EyC/XOwUb4bdinj2wV0DtX5sUZjPX9Njd6fRHQq/9+ThS0xD
         Us1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792179276; x=1792784076;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=aX8BMwzWvjwy0zU80VugHODY2Qm8YSCHtwDCUWH9+Eo=;
        b=Kx5yWTzKsmvsrcBSnPZfycpimeMC3q2HkS0CksuSgNfILMxKLpePMGF8x4pgLTBGw7
         aoJnw+s4ndAleHYx7ZixK/vDodDtqxrhk8nQTmDtqH9e36XbdtOaZbAG5CNkB/cNdKZ1
         XSzM1QBoUwlZJvfrr57rZrlgGmREUuWHe1EZYQ0Txe4Z0/CSomDVOhiT2MHwXUbB7BWw
         iX47Uh6BUBhMJ6VdrgJBSImsc40pKsp56H+BE3sfapahZCswxnxo7lPj01OAiPfzj+JU
         AC1f0IooGEpnF5z6OLr593Ywbs+CrZuYdUIhSNeUXGdz67dSAglTb3KbBA+PlKhWf/j3
         1zbQ==
X-Gm-Message-State: AFq9FYKSMHH5rP6C959GceQ2MMkZx2/pVSQg4b+WpaVp2L8hSc5ByznW
	N+DnpzL+lEnSkf90bWLEETWDPHLV8DkWFF5h/7YitH/7xsPSq614wqCQFaT5choReVXZC7IU1mT
	tkOcDtV0GBDhBpyf3pB6DxnqKuDjazaIKVVHUuQz5Wv3bsMScVKsQ4mZtskrIhrRNOw3mKElp7r
	zkGze1j5doNj4LlKGYON8pTlvMR2HjAJYiw9yCkBtC6iFW
X-Gm-Gg: AYBFou2mCAKSqbgPW3/Di66zElRY8w3+dBmLi3QxYtHGzWzUKS3aw1MdcrXXEW4rLD2
	LsCS266CloZCl+B2ipwO0iRSnP5BVmKT638W4DeJS4FkdzTBqjHsXPI69xzVMhadJrJrqIVLhMG
	cgEt6y16Gb3nkC/SvLtBvjja6hI6F3UpNyd45RcbdNckdWhNonmy/ONY6Cgk5KeGAhMKj0VJthX
	QjSAMQBWkVbcUgOdWMfhw5XGSYG6aLr0/9QgGi7CuaBkIkkINmS3uSr5BrlSeAOtsyiX8F7u7Hn
	9PPNUdUud2VVhkyg2pz9OYFgp7J7Va1QankOn0/ezgtLr3fc8yo9bRjTR6LYiu2Z6/NMUCzQqpt
	S+yz1S0sdoBkYhBMkXGNJ+VDB+22mK2OwGbb2LA==
X-Received: by 2002:a05:620a:7106:b0:93c:b420:c2b8 with SMTP id af79cd13be357-93f29db7ef9mr157015885a.61.1792179276257;
        Fri, 16 Oct 2026 12:34:36 -0700 (PDT)
X-Received: by 2002:a05:620a:7106:b0:93c:b420:c2b8 with SMTP id af79cd13be357-93f29db7ef9mr157011085a.61.1792179275652;
        Fri, 16 Oct 2026 12:34:35 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f1a1a990fsm284359185a.35.2026.10.16.12.34.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 12:34:34 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	hch@lst.de,
	dgc@kernel.org,
	Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 6/8] xfs: add stat check to xfs_btree_delete and remove caller checks
Date: Fri, 16 Oct 2026 14:29:06 -0500
Message-ID: <20261016193422.1630907-7-sandeen@redhat.com>
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

Unlike xfs_btree_insert(), xfs_btree_delete() does not validate its own
status return internally, so every caller open-codes the same check that
a record was actually deleted:

	error = xfs_btree_delete(cur, &i);
	if (error)
		return error;
	if (XFS_IS_CORRUPT(mp, i != 1)) {
		xfs_btree_mark_sick(cur);
		return -EFSCORRUPTED;
	}

No caller expects or accepts i == 0; that is considered corruption in
every case.

Move this check into xfs_btree_delete, to mirror xfs_btree_insert's
behavior, so that xfs_btree_delete either returns error = 0 / status = 1,
or a nonzero error.

With that in place, remove the now-redundant i != 1 checks from all
callers, parallel to what was done earlier for xfs_btree_insert().

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c    | 33 -------------------------------
 fs/xfs/libxfs/xfs_bmap.c     | 38 ------------------------------------
 fs/xfs/libxfs/xfs_btree.c    |  6 ++++++
 fs/xfs/libxfs/xfs_ialloc.c   | 15 --------------
 fs/xfs/libxfs/xfs_refcount.c |  5 -----
 fs/xfs/libxfs/xfs_rmap.c     | 35 ---------------------------------
 fs/xfs/scrub/rcbag.c         |  4 ----
 7 files changed, 6 insertions(+), 130 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index acd8f4521c4c..bc43afff33bc 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -678,10 +678,6 @@ xfs_alloc_fixup_trees(
 	 */
 	if ((error = xfs_btree_delete(cnt_cur, &i)))
 		return error;
-	if (XFS_IS_CORRUPT(mp, i != 1)) {
-		xfs_btree_mark_sick(cnt_cur);
-		return -EFSCORRUPTED;
-	}
 	/*
 	 * Add new by-size btree entry(s).
 	 */
@@ -716,10 +712,6 @@ xfs_alloc_fixup_trees(
 		 */
 		if ((error = xfs_btree_delete(bno_cur, &i)))
 			return error;
-		if (XFS_IS_CORRUPT(mp, i != 1)) {
-			xfs_btree_mark_sick(bno_cur);
-			return -EFSCORRUPTED;
-		}
 	} else {
 		/*
 		 * Update the by-block entry to start later|be shorter.
@@ -2155,11 +2147,6 @@ xfs_free_ag_extent(
 		}
 		if ((error = xfs_btree_delete(cnt_cur, &i)))
 			goto error0;
-		if (XFS_IS_CORRUPT(mp, i != 1)) {
-			xfs_btree_mark_sick(cnt_cur);
-			error = -EFSCORRUPTED;
-			goto error0;
-		}
 		/*
 		 * Delete the old by-size entry on the right.
 		 */
@@ -2172,21 +2159,11 @@ xfs_free_ag_extent(
 		}
 		if ((error = xfs_btree_delete(cnt_cur, &i)))
 			goto error0;
-		if (XFS_IS_CORRUPT(mp, i != 1)) {
-			xfs_btree_mark_sick(cnt_cur);
-			error = -EFSCORRUPTED;
-			goto error0;
-		}
 		/*
 		 * Delete the old by-block entry for the right block.
 		 */
 		if ((error = xfs_btree_delete(bno_cur, &i)))
 			goto error0;
-		if (XFS_IS_CORRUPT(mp, i != 1)) {
-			xfs_btree_mark_sick(bno_cur);
-			error = -EFSCORRUPTED;
-			goto error0;
-		}
 		/*
 		 * Move the by-block cursor back to the left neighbor.
 		 */
@@ -2244,11 +2221,6 @@ xfs_free_ag_extent(
 		}
 		if ((error = xfs_btree_delete(cnt_cur, &i)))
 			goto error0;
-		if (XFS_IS_CORRUPT(mp, i != 1)) {
-			xfs_btree_mark_sick(cnt_cur);
-			error = -EFSCORRUPTED;
-			goto error0;
-		}
 		/*
 		 * Back up the by-block cursor to the left neighbor, and
 		 * update its length.
@@ -2282,11 +2254,6 @@ xfs_free_ag_extent(
 		}
 		if ((error = xfs_btree_delete(cnt_cur, &i)))
 			goto error0;
-		if (XFS_IS_CORRUPT(mp, i != 1)) {
-			xfs_btree_mark_sick(cnt_cur);
-			error = -EFSCORRUPTED;
-			goto error0;
-		}
 		/*
 		 * Update the starting block and length of the right
 		 * neighbor in the by-block tree.
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 09d6792e42be..cf7360adf1a8 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1562,11 +1562,6 @@ xfs_bmap_add_extent_delay_real(
 			error = xfs_btree_delete(bma->cur, &i);
 			if (error)
 				goto done;
-			if (XFS_IS_CORRUPT(mp, i != 1)) {
-				xfs_btree_mark_sick(bma->cur);
-				error = -EFSCORRUPTED;
-				goto done;
-			}
 			error = xfs_btree_decrement(bma->cur, 0, &i);
 			if (error)
 				goto done;
@@ -2110,11 +2105,6 @@ xfs_bmap_add_extent_unwritten_real(
 			}
 			if ((error = xfs_btree_delete(cur, &i)))
 				goto done;
-			if (XFS_IS_CORRUPT(mp, i != 1)) {
-				xfs_btree_mark_sick(cur);
-				error = -EFSCORRUPTED;
-				goto done;
-			}
 			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
@@ -2124,11 +2114,6 @@ xfs_bmap_add_extent_unwritten_real(
 			}
 			if ((error = xfs_btree_delete(cur, &i)))
 				goto done;
-			if (XFS_IS_CORRUPT(mp, i != 1)) {
-				xfs_btree_mark_sick(cur);
-				error = -EFSCORRUPTED;
-				goto done;
-			}
 			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
@@ -2167,11 +2152,6 @@ xfs_bmap_add_extent_unwritten_real(
 			}
 			if ((error = xfs_btree_delete(cur, &i)))
 				goto done;
-			if (XFS_IS_CORRUPT(mp, i != 1)) {
-				xfs_btree_mark_sick(cur);
-				error = -EFSCORRUPTED;
-				goto done;
-			}
 			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
@@ -2213,11 +2193,6 @@ xfs_bmap_add_extent_unwritten_real(
 			}
 			if ((error = xfs_btree_delete(cur, &i)))
 				goto done;
-			if (XFS_IS_CORRUPT(mp, i != 1)) {
-				xfs_btree_mark_sick(cur);
-				error = -EFSCORRUPTED;
-				goto done;
-			}
 			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
 			if (XFS_IS_CORRUPT(mp, i != 1)) {
@@ -2627,11 +2602,6 @@ xfs_bmap_add_extent_hole_real(
 			error = xfs_btree_delete(cur, &i);
 			if (error)
 				goto done;
-			if (XFS_IS_CORRUPT(mp, i != 1)) {
-				xfs_btree_mark_sick(cur);
-				error = -EFSCORRUPTED;
-				goto done;
-			}
 			error = xfs_btree_decrement(cur, 0, &i);
 			if (error)
 				goto done;
@@ -4958,10 +4928,6 @@ xfs_bmap_del_extent_real(
 		}
 		if ((error = xfs_btree_delete(cur, &i)))
 			return error;
-		if (XFS_IS_CORRUPT(mp, i != 1)) {
-			xfs_btree_mark_sick(cur);
-			return -EFSCORRUPTED;
-		}
 		break;
 	case BMAP_LEFT_FILLING:
 		/*
@@ -5525,10 +5491,6 @@ xfs_bmse_merge(
 	error = xfs_btree_delete(cur, &i);
 	if (error)
 		return error;
-	if (XFS_IS_CORRUPT(mp, i != 1)) {
-		xfs_btree_mark_sick(cur);
-		return -EFSCORRUPTED;
-	}
 
 	/* lookup and update size of the previous extent */
 	error = xfs_bmbt_lookup_eq(cur, left, &i);
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index e2e698596c21..367c14e4dec5 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -4598,6 +4598,12 @@ xfs_btree_delete(
 		}
 	}
 
+	if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
+		error = -EFSCORRUPTED;
+		goto error0;
+	}
+
 	*stat = i;
 	return 0;
 error0:
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index bd7b0a24225f..7a9cc0b9e206 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1620,11 +1620,6 @@ xfs_dialloc_ag(
 		error = xfs_btree_delete(cur, &i);
 		if (error)
 			goto error_cur;
-		if (XFS_IS_CORRUPT(mp, i != 1)) {
-			xfs_btree_mark_sick(cur);
-			error = -EFSCORRUPTED;
-			goto error_cur;
-		}
 	}
 
 	/*
@@ -2158,11 +2153,6 @@ xfs_difree_inobt(
 				__func__, error);
 			goto error0;
 		}
-		if (XFS_IS_CORRUPT(mp, i != 1)) {
-			xfs_btree_mark_sick(cur);
-			error = -EFSCORRUPTED;
-			goto error0;
-		}
 
 		error = xfs_difree_inode_chunk(tp, pag, &rec);
 		if (error)
@@ -2287,11 +2277,6 @@ xfs_difree_finobt(
 		error = xfs_btree_delete(cur, &i);
 		if (error)
 			goto error;
-		if (XFS_IS_CORRUPT(mp, i != 1)) {
-			xfs_btree_mark_sick(cur);
-			error = -EFSCORRUPTED;
-			goto error;
-		}
 	} else {
 		error = xfs_inobt_update(cur, &rec);
 		if (error)
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 574a5e7c0cdf..bf7526621681 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -305,11 +305,6 @@ xfs_refcount_delete(
 	}
 	trace_xfs_refcount_delete(cur, &irec);
 	error = xfs_btree_delete(cur, i);
-	if (XFS_IS_CORRUPT(cur->bc_mp, *i != 1)) {
-		xfs_btree_mark_sick(cur);
-		error = -EFSCORRUPTED;
-		goto out_error;
-	}
 	if (error)
 		goto out_error;
 	error = xfs_refcount_lookup_ge(cur, irec.rc_domain, irec.rc_startblock,
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 99575ae419a7..31c41e9bcb3f 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -178,11 +178,6 @@ xfs_rmap_delete(
 	error = xfs_btree_delete(rcur, &i);
 	if (error)
 		goto done;
-	if (XFS_IS_CORRUPT(rcur->bc_mp, i != 1)) {
-		xfs_btree_mark_sick(rcur);
-		error = -EFSCORRUPTED;
-		goto done;
-	}
 done:
 	if (error)
 		trace_xfs_rmap_delete_error(rcur, error, _RET_IP_);
@@ -778,11 +773,6 @@ xfs_rmap_unmap(
 		error = xfs_btree_delete(cur, &i);
 		if (error)
 			goto out_error;
-		if (XFS_IS_CORRUPT(mp, i != 1)) {
-			xfs_btree_mark_sick(cur);
-			error = -EFSCORRUPTED;
-			goto out_error;
-		}
 	} else if (ltrec.rm_startblock == bno) {
 		/*
 		 * overlap left hand side of extent: move the start, trim the
@@ -1131,11 +1121,6 @@ xfs_rmap_map(
 			error = xfs_btree_delete(cur, &i);
 			if (error)
 				goto out_error;
-			if (XFS_IS_CORRUPT(mp, i != 1)) {
-				xfs_btree_mark_sick(cur);
-				error = -EFSCORRUPTED;
-				goto out_error;
-			}
 		}
 
 		/* point the cursor back to the left record and update */
@@ -1413,11 +1398,6 @@ xfs_rmap_convert(
 		error = xfs_btree_delete(cur, &i);
 		if (error)
 			goto done;
-		if (XFS_IS_CORRUPT(mp, i != 1)) {
-			xfs_btree_mark_sick(cur);
-			error = -EFSCORRUPTED;
-			goto done;
-		}
 		error = xfs_btree_decrement(cur, 0, &i);
 		if (error)
 			goto done;
@@ -1432,11 +1412,6 @@ xfs_rmap_convert(
 		error = xfs_btree_delete(cur, &i);
 		if (error)
 			goto done;
-		if (XFS_IS_CORRUPT(mp, i != 1)) {
-			xfs_btree_mark_sick(cur);
-			error = -EFSCORRUPTED;
-			goto done;
-		}
 		error = xfs_btree_decrement(cur, 0, &i);
 		if (error)
 			goto done;
@@ -1463,11 +1438,6 @@ xfs_rmap_convert(
 		error = xfs_btree_delete(cur, &i);
 		if (error)
 			goto done;
-		if (XFS_IS_CORRUPT(mp, i != 1)) {
-			xfs_btree_mark_sick(cur);
-			error = -EFSCORRUPTED;
-			goto done;
-		}
 		error = xfs_btree_decrement(cur, 0, &i);
 		if (error)
 			goto done;
@@ -1502,11 +1472,6 @@ xfs_rmap_convert(
 		error = xfs_btree_delete(cur, &i);
 		if (error)
 			goto done;
-		if (XFS_IS_CORRUPT(mp, i != 1)) {
-			xfs_btree_mark_sick(cur);
-			error = -EFSCORRUPTED;
-			goto done;
-		}
 		error = xfs_btree_decrement(cur, 0, &i);
 		if (error)
 			goto done;
diff --git a/fs/xfs/scrub/rcbag.c b/fs/xfs/scrub/rcbag.c
index 41e798f65c67..5a390e3c7777 100644
--- a/fs/xfs/scrub/rcbag.c
+++ b/fs/xfs/scrub/rcbag.c
@@ -242,10 +242,6 @@ rcbag_remove_ending_at(
 		error = xfs_btree_delete(cur, &has);
 		if (error)
 			goto out_cur;
-		if (!has) {
-			error = -EFSCORRUPTED;
-			goto out_cur;
-		}
 
 		bag->nr_items -= bagrec.rbg_refcount;
 	}
-- 
2.55.0

