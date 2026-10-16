Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932203C3C1C
	for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 19:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792179279; cv=none; b=iyjcbceI26FooLgnlkX/SuExqVHgefaD8R0jfsdYAC5Y5FrI2wv5akWQ+DHlqweeHg2hVLm8XRTKk1bdZDEvs3f4bB3C9Wq4SlunsqHwuYNnIq/LCNDChz3lMg5ay7SmsOXNt+fHVRT9I0e2Vwpn1zld0UResAlIh+QeuBRicTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792179279; c=relaxed/simple;
	bh=OHOQxLhIpVDmOHCzi3xwVdt/0RiNYYnUZg33r1FiNsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s5fW3LQL0hZLTauXvV7wVD+Aldr777OQ7rHxJNczM+WiqbHeQF3Fl/CiRt4ZR6DKKB0B7LnBlSVauDxyVbHoyMT1JkIJgCc5l3zPM/Od44NMJUcncJaHc9udnBczItsvM+R+C32K7lU2vE7ndjkBtsFa10tjaD70SMOxpdB+u1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RUN/TE+Y; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=qP1RXMJ4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RUN/TE+Y";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="qP1RXMJ4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792179272;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gw+MFt86hS3EmSATH4Yx4p872znpQ2+zYM2kIgy8nLE=;
	b=RUN/TE+Y24UDNsVXNaJBFpKI0f9daZ/QjEJTMfo3+mL1ixKKptGyHzbRygq9l9s2/Hsb5D
	jK0lTKlJg7flqYNkdrFAUBLJBi4Mkwah7j9n4QmF973aPOUTZpjRZy9l6mPkCao5cLmHxg
	rskHq4/U2BDLOKswUcFngv6N0+vtSos=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-621-guvZF0z3PcO6848fBzB6rA-1; Fri, 16 Oct 2026 19:34:31 +0000
X-MC-Unique: guvZF0z3PcO6848fBzB6rA-1
X-Mimecast-MFC-AGG-ID: guvZF0z3PcO6848fBzB6rA_1792179270
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-934956beec8so61355985a.0
        for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 12:34:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1792179270; x=1792784070; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Gw+MFt86hS3EmSATH4Yx4p872znpQ2+zYM2kIgy8nLE=;
        b=qP1RXMJ4ybJ16thqX8YTrywstyjrQL1TTF5OMQ3m6Xe4UWBfUu2nCJJSmmwR3jh2gU
         7vs2TY68BKrtUV6I3MyxV/ePDq5vSWhUXMyd5OqJzL3OEg7MQonSJMVopvg+ND0nWibB
         k+Iarvy6U7kPnfuFPEP1X6GOlkn1EHrJwXAHRUmDsBfErj7m/wshcZeEF9uBKqOrm6wF
         RO6qGL3rvsGaXEkWU2akNYxgGb0y5EwWJgCIe/9BQj5TeWc9n5XvSohHcqaMTKrxTmS6
         GlJ8xSi3b1H4UY6QmmYlZEbV/bhTXXk4mJOZeCpH/GQ0vcAP/qSjofFYDguNDl12bB3t
         di0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792179270; x=1792784070;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Gw+MFt86hS3EmSATH4Yx4p872znpQ2+zYM2kIgy8nLE=;
        b=rGi8dTkqYAgSlf36qYj4qePO6GzZj99Vk2lAEahPOI6K6NV98wp57wivpbT/spHots
         gUyWgZWRpsyoPm8Lf6zWshRs+U+yAHlAiwmoUGxGx3i8W6lH881qD4AGpzpx9FDxpYvp
         +uyKbZnDa7drkRoTTj9tE00i5uv88O25ncCrjY85b7Lp4ivDl4OlT/cCPmZSf+XW0u/e
         0ktBMV+GK+pUIF/0sOCTXaYuxznKRbAgwsb3w4Gjo9G1laJ3QFVbQvyFLeaZ3TE3QDT0
         /D0wVj1mg5Kanw03XtzAchdGq8s7sOBScl5xZd3KEcApQfWrDnRPlNFxRPR8XkhShnzV
         4f7A==
X-Gm-Message-State: AFq9FYImfP9hnMy7wCvBK8vnuEutQmdotEhBqrjQ5TLhqxaDIvNZwnL1
	mMicI0I01c8UiBIi9iY/y6ZAOUvc3uhOVm34+bF2dOCDjZZL0D607p4vPUVKoLghw5KVuOP4hhZ
	BSq6LHDCg/vYWB8DfQv97EdMPjagKPz3w6YyJAS0tF/hDjQqTC9RN7Z01UtdSjlgfKJRB6nMOT+
	v1U9GpXEd9YPIhaIW69qTAwFMIdpeEPFxCHXKtlfL39d/V
X-Gm-Gg: AYBFou2RYT10TE62Fz6pZ94tPPiRxViPHYdcclVK34/ri08Kz6RJXcp4Z9o4G7mWMcW
	3pz3OwOfgcff0qxddoIfaEj576+XoHnNCKwJvf6j4enAEwRhRj7Cjt1mqw2epsekAZF2GhIgEXG
	BqVIYJ68if49YkeNJG9MnF+sPP3KvAQxXm2RxPC8P4yO50UgxlD7sfHreX/PWcY2Gk9B3l8+7ji
	BROHDWy7Gen6jqHGO5sBz9Wujb3W0VgZNPTlL8Y3X/HVWjjgWt9kGHPAr3Nymf7x5Fg3VM1jvIK
	WHKJ2T3zq+GR43gqU4E66a54O95NHOmOxX5nTN7wY9inZo9xT9sdo70GIX4Tp5HiLb5cDuYI+0y
	N7SlP2xGNNGa8q2SRZvqORazzEOth3V19gtEMwQ==
X-Received: by 2002:a05:620a:6410:b0:93e:c12c:440b with SMTP id af79cd13be357-93f29daef78mr135994685a.71.1792179270270;
        Fri, 16 Oct 2026 12:34:30 -0700 (PDT)
X-Received: by 2002:a05:620a:6410:b0:93e:c12c:440b with SMTP id af79cd13be357-93f29daef78mr135991285a.71.1792179269713;
        Fri, 16 Oct 2026 12:34:29 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f1a1a990fsm284359185a.35.2026.10.16.12.34.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 12:34:29 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	hch@lst.de,
	dgc@kernel.org,
	Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 1/8] xfs: remove redundant stat checks after xfs_btree_insert()
Date: Fri, 16 Oct 2026 14:29:01 -0500
Message-ID: <20261016193422.1630907-2-sandeen@redhat.com>
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

xfs_btree_insert() validates its own status internally via the result
of xfs_btree_insrec(). When it returns 0 it guarantees the status value
is 1; on any error it returns a nonzero error and does not update the
status value, so on error the status value is meaningless and on success
the status value does not need to be tested.

This makes every instance of the 2nd test in this idiom:

	if ((error = xfs_btree_insert(cnt_cur, &i)))
		return error;
	if (XFS_IS_CORRUPT(mp, i != 1)) {
		xfs_btree_mark_sick(cnt_cur);
		return -EFSCORRUPTED;
	}

unreachable on an error, and always false on success. The mark_sick and
error return cannot be reached, so remove all that.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c    | 22 ---------------
 fs/xfs/libxfs/xfs_bmap.c     | 54 ------------------------------------
 fs/xfs/libxfs/xfs_refcount.c |  9 ------
 fs/xfs/libxfs/xfs_rmap.c     | 32 ---------------------
 4 files changed, 117 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index ae221a158764..b40c51a0f651 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -694,10 +694,6 @@ xfs_alloc_fixup_trees(
 		}
 		if ((error = xfs_btree_insert(cnt_cur, &i)))
 			return error;
-		if (XFS_IS_CORRUPT(mp, i != 1)) {
-			xfs_btree_mark_sick(cnt_cur);
-			return -EFSCORRUPTED;
-		}
 	}
 	if (nfbno2 != NULLAGBLOCK) {
 		if ((error = xfs_alloc_lookup_eq(cnt_cur, nfbno2, nflen2, &i)))
@@ -708,10 +704,6 @@ xfs_alloc_fixup_trees(
 		}
 		if ((error = xfs_btree_insert(cnt_cur, &i)))
 			return error;
-		if (XFS_IS_CORRUPT(mp, i != 1)) {
-			xfs_btree_mark_sick(cnt_cur);
-			return -EFSCORRUPTED;
-		}
 	}
 	/*
 	 * Fix up the by-block btree entry(s).
@@ -745,10 +737,6 @@ xfs_alloc_fixup_trees(
 		}
 		if ((error = xfs_btree_insert(bno_cur, &i)))
 			return error;
-		if (XFS_IS_CORRUPT(mp, i != 1)) {
-			xfs_btree_mark_sick(bno_cur);
-			return -EFSCORRUPTED;
-		}
 	}
 
 	if (fixup_longest)
@@ -2314,11 +2302,6 @@ xfs_free_ag_extent(
 		nlen = len;
 		if ((error = xfs_btree_insert(bno_cur, &i)))
 			goto error0;
-		if (XFS_IS_CORRUPT(mp, i != 1)) {
-			xfs_btree_mark_sick(bno_cur);
-			error = -EFSCORRUPTED;
-			goto error0;
-		}
 	}
 	xfs_btree_del_cursor(bno_cur, XFS_BTREE_NOERROR);
 	bno_cur = NULL;
@@ -2341,11 +2324,6 @@ xfs_free_ag_extent(
 		fixup_longest = true;
 	if ((error = xfs_btree_insert(cnt_cur, &i)))
 		goto error0;
-	if (XFS_IS_CORRUPT(mp, i != 1)) {
-		xfs_btree_mark_sick(cnt_cur);
-		error = -EFSCORRUPTED;
-		goto error0;
-	}
 	if (fixup_longest) {
 		error = xfs_alloc_fixup_longest(cnt_cur);
 		if (error)
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index ca49bf4a50c5..073c11e631ea 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1674,11 +1674,6 @@ xfs_bmap_add_extent_delay_real(
 			error = xfs_btree_insert(bma->cur, &i);
 			if (error)
 				goto done;
-			if (XFS_IS_CORRUPT(mp, i != 1)) {
-				xfs_btree_mark_sick(bma->cur);
-				error = -EFSCORRUPTED;
-				goto done;
-			}
 		}
 		ASSERT(da_new <= da_old);
 		break;
@@ -1745,11 +1740,6 @@ xfs_bmap_add_extent_delay_real(
 			error = xfs_btree_insert(bma->cur, &i);
 			if (error)
 				goto done;
-			if (XFS_IS_CORRUPT(mp, i != 1)) {
-				xfs_btree_mark_sick(bma->cur);
-				error = -EFSCORRUPTED;
-				goto done;
-			}
 		}
 
 		if (xfs_bmap_needs_btree(bma->ip, whichfork)) {
@@ -1836,11 +1826,6 @@ xfs_bmap_add_extent_delay_real(
 			error = xfs_btree_insert(bma->cur, &i);
 			if (error)
 				goto done;
-			if (XFS_IS_CORRUPT(mp, i != 1)) {
-				xfs_btree_mark_sick(bma->cur);
-				error = -EFSCORRUPTED;
-				goto done;
-			}
 		}
 
 		if (xfs_bmap_needs_btree(bma->ip, whichfork)) {
@@ -1925,11 +1910,6 @@ xfs_bmap_add_extent_delay_real(
 			error = xfs_btree_insert(bma->cur, &i);
 			if (error)
 				goto done;
-			if (XFS_IS_CORRUPT(mp, i != 1)) {
-				xfs_btree_mark_sick(bma->cur);
-				error = -EFSCORRUPTED;
-				goto done;
-			}
 		}
 
 		if (xfs_bmap_needs_btree(bma->ip, whichfork)) {
@@ -2350,11 +2330,6 @@ xfs_bmap_add_extent_unwritten_real(
 			cur->bc_rec.b = *new;
 			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
-			if (XFS_IS_CORRUPT(mp, i != 1)) {
-				xfs_btree_mark_sick(cur);
-				error = -EFSCORRUPTED;
-				goto done;
-			}
 		}
 		break;
 
@@ -2436,11 +2411,6 @@ xfs_bmap_add_extent_unwritten_real(
 			}
 			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
-			if (XFS_IS_CORRUPT(mp, i != 1)) {
-				xfs_btree_mark_sick(cur);
-				error = -EFSCORRUPTED;
-				goto done;
-			}
 		}
 		break;
 
@@ -2486,11 +2456,6 @@ xfs_bmap_add_extent_unwritten_real(
 			cur->bc_rec.b = PREV;
 			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
-			if (XFS_IS_CORRUPT(mp, i != 1)) {
-				xfs_btree_mark_sick(cur);
-				error = -EFSCORRUPTED;
-				goto done;
-			}
 			/*
 			 * Reset the cursor to the position of the new extent
 			 * we are about to insert as we can't trust it after
@@ -2507,11 +2472,6 @@ xfs_bmap_add_extent_unwritten_real(
 			/* new middle extent - newext */
 			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
-			if (XFS_IS_CORRUPT(mp, i != 1)) {
-				xfs_btree_mark_sick(cur);
-				error = -EFSCORRUPTED;
-				goto done;
-			}
 		}
 		break;
 
@@ -2767,11 +2727,6 @@ xfs_bmap_add_extent_hole_real(
 			error = xfs_btree_insert(cur, &i);
 			if (error)
 				goto done;
-			if (XFS_IS_CORRUPT(mp, i != 1)) {
-				xfs_btree_mark_sick(cur);
-				error = -EFSCORRUPTED;
-				goto done;
-			}
 		}
 		break;
 	}
@@ -5093,10 +5048,6 @@ xfs_bmap_del_extent_real(
 				*logflagsp = 0;
 				return -ENOSPC;
 			}
-			if (XFS_IS_CORRUPT(mp, i != 1)) {
-				xfs_btree_mark_sick(cur);
-				return -EFSCORRUPTED;
-			}
 		} else
 			*logflagsp |= xfs_ilog_fext(whichfork);
 
@@ -5958,11 +5909,6 @@ xfs_bmap_split_extent(
 		error = xfs_btree_insert(cur, &i);
 		if (error)
 			goto del_cursor;
-		if (XFS_IS_CORRUPT(mp, i != 1)) {
-			xfs_btree_mark_sick(cur);
-			error = -EFSCORRUPTED;
-			goto del_cursor;
-		}
 	}
 
 	/*
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 6b67308fa594..49e9993ce360 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -276,15 +276,6 @@ xfs_refcount_insert(
 	cur->bc_rec.rc.rc_domain = irec->rc_domain;
 
 	error = xfs_btree_insert(cur, i);
-	if (error)
-		goto out_error;
-	if (XFS_IS_CORRUPT(cur->bc_mp, *i != 1)) {
-		xfs_btree_mark_sick(cur);
-		error = -EFSCORRUPTED;
-		goto out_error;
-	}
-
-out_error:
 	if (error)
 		trace_xfs_refcount_insert_error(cur, error, _RET_IP_);
 	return error;
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 14aef87837a9..ff4aef8d30a7 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -146,13 +146,6 @@ xfs_rmap_insert(
 	rcur->bc_rec.r.rm_offset = offset;
 	rcur->bc_rec.r.rm_flags = flags;
 	error = xfs_btree_insert(rcur, &i);
-	if (error)
-		goto done;
-	if (XFS_IS_CORRUPT(rcur->bc_mp, i != 1)) {
-		xfs_btree_mark_sick(rcur);
-		error = -EFSCORRUPTED;
-		goto done;
-	}
 done:
 	if (error)
 		trace_xfs_rmap_insert_error(rcur, error, _RET_IP_);
@@ -1185,11 +1178,6 @@ xfs_rmap_map(
 		error = xfs_btree_insert(cur, &i);
 		if (error)
 			goto out_error;
-		if (XFS_IS_CORRUPT(mp, i != 1)) {
-			xfs_btree_mark_sick(cur);
-			error = -EFSCORRUPTED;
-			goto out_error;
-		}
 	}
 
 	trace_xfs_rmap_map_done(cur, bno, len, unwritten, oinfo);
@@ -1592,11 +1580,6 @@ xfs_rmap_convert(
 		error = xfs_btree_insert(cur, &i);
 		if (error)
 			goto done;
-		if (XFS_IS_CORRUPT(mp, i != 1)) {
-			xfs_btree_mark_sick(cur);
-			error = -EFSCORRUPTED;
-			goto done;
-		}
 		break;
 
 	case RMAP_RIGHT_FILLING | RMAP_RIGHT_CONTIG:
@@ -1650,11 +1633,6 @@ xfs_rmap_convert(
 		error = xfs_btree_insert(cur, &i);
 		if (error)
 			goto done;
-		if (XFS_IS_CORRUPT(mp, i != 1)) {
-			xfs_btree_mark_sick(cur);
-			error = -EFSCORRUPTED;
-			goto done;
-		}
 		break;
 
 	case 0:
@@ -1683,11 +1661,6 @@ xfs_rmap_convert(
 		error = xfs_btree_insert(cur, &i);
 		if (error)
 			goto done;
-		if (XFS_IS_CORRUPT(mp, i != 1)) {
-			xfs_btree_mark_sick(cur);
-			error = -EFSCORRUPTED;
-			goto done;
-		}
 		/*
 		 * Reset the cursor to the position of the new extent
 		 * we are about to insert as we can't trust it after
@@ -1709,11 +1682,6 @@ xfs_rmap_convert(
 		error = xfs_btree_insert(cur, &i);
 		if (error)
 			goto done;
-		if (XFS_IS_CORRUPT(mp, i != 1)) {
-			xfs_btree_mark_sick(cur);
-			error = -EFSCORRUPTED;
-			goto done;
-		}
 		break;
 
 	case RMAP_LEFT_FILLING | RMAP_LEFT_CONTIG | RMAP_RIGHT_CONTIG:
-- 
2.55.0

