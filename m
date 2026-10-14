Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236D8377A9E
	for <linux-xfs@vger.kernel.org>; Wed, 14 Oct 2026 03:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791949870; cv=none; b=Tp1A3cLoD7ysz45H2gIX/8dT6FCXNVA6PtoLacM2QiW1eDXRpJFOrSFbcCnLK8stXA8gH/HOC2cRlKCTQj2xHCV8NHSeaAGyECS94R9uYlDEblr7xIMr2iDdqldX1Km3o2MBc0xZ44n6VPlckTsSCuDoaI4F5SUocDahYlLnI5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791949870; c=relaxed/simple;
	bh=kp+HeuY3gqQvp1C+kq7TkFNbnt9Vb4baAeXPiwSa14c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F2WOFc2JRErtPDPP6ecboj/PYHYGUKFXkfqLLhNxvDJKW/OtyQECzvglFrYyoS1g3Q6dnFdgN1dhltDY+JjzyIwzeVvXqCB9Bm3JLDLR1SXpl8i5I0Sb89X1QnmkMQBrMEArZLWFly2o1ArwDFfYKDQHfG4hJpOkQuK0xgtLp1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bdJIEuFe; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=FQDA25e7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bdJIEuFe";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="FQDA25e7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791949867;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mHn4phJ4Z2BM0riVPKmHCkM6aD7sIH4AYzEXm46TrOE=;
	b=bdJIEuFevM/H6lBcOxuUiWSSHRSM6LLBmrXii9M7ZggS9O9VWDaJg9mGP2yIPQIP+aOZeM
	ktp4FE9gambVZvJCcHuaerngMR8yeDz04K7PtwLZ60VobTpYWELAAMHCKWSF+L+LP7LcXF
	CJ09RSx8UEhd+kc0NeOy81xRFWWr9gQ=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-136-7wQhnLO-No2vVKwp3rSXoA-1; Wed, 14 Oct 2026 03:51:00 +0000
X-MC-Unique: 7wQhnLO-No2vVKwp3rSXoA-1
X-Mimecast-MFC-AGG-ID: 7wQhnLO-No2vVKwp3rSXoA_1791949860
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-9104eedb5b0so132010906d6.0
        for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 20:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1791949860; x=1792554660; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mHn4phJ4Z2BM0riVPKmHCkM6aD7sIH4AYzEXm46TrOE=;
        b=FQDA25e7AKq/G97ZAtT/uz3jpC7EEbfnURayH9EQAdVsKcaCXec+wUn8izX/Z+m1ae
         8DaQdlS7stjUznVne8TUGW95NUoCjTbJHl/JLQKITG3U9NnEcoSVJ7BrL7zZrcmckXLq
         CCQxDNAp2Zu4Vt1xY0l6f/K1EVwqvxozpNoqtDd8lLqH4zBjeeOxeY4LKjRQYp47LZ+A
         3CR639Wt+/tRyud87GA4PX70DJEcUWPE3H5BUeWpbTn0sgK/BNJ3z6DnOr7zvbfKtrSX
         6MwKAqINogiLbMeHLxb8wh4odJWrRJEGO9fQCQbNFeQvKaGQL2fKRW129ng60fNvaAan
         8FUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791949860; x=1792554660;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mHn4phJ4Z2BM0riVPKmHCkM6aD7sIH4AYzEXm46TrOE=;
        b=EQI7svDecOaMsDzu+umNDnHsX0stfIlfQ3wbCwjX+3Y9PA+Jep1ypzrxkOXnnIOfxb
         hQrn5h69tdXYwSxVSFiUpsbRDk0UdSaJ4loMJjCRfKVkQrVQ9hvtgdNzl8vVTO2Z9V4h
         LCrIcRvH4O6Vj/8ZIz1J7oHwsAePMyAbSTiJPIYjgATY/x3LdDbxWklvNZNALuPdOuSu
         HNboI5aIttt/axhq9nEwNyEU82uXNOn4Pkrx1C7oFvtB0BOahKzfgqm9YlUNhaJ1N5ti
         udl/f/0qJ9CPWRtljbcXpjQuHnyomzHRW0XQ1SiBrOCmHOvMEE3ZRg8kf6tlFs00G2ed
         MTSA==
X-Gm-Message-State: AFq9FYIZ4VYhjSQ19WsnWZJlm9+xNkUcaipoM1+oIFaDs/rYMmGlHZ1M
	jpDWsz9USI3IrW3ns85EaDC5pPXI7JC2eARSJTqs9oUI0GKHnf1kC8gTFJTa2mwgebyr1Q5vqY9
	8OusZAc9g0ieBTg1Plt9/XCP5XOhiD0spu20STDglX626MNmT9LyWWBY60eCAUk0ktNIAz4d2Jo
	mbPkWaai/tNb+yQevP2OxeCyRhh79chnKFQt3VgrF0Kz7f
X-Gm-Gg: AYBFou19XwBZ2y3gIh7OUpQH9N0DhQCe7fQAKBtSFpgo+A6o4SkkMokKJxq4QTMnE/I
	Tmg+WqKy6aCJgaFj81yCfwTlFgE6oOd4uIBTaynu7/fVQIBuAaH6/ps29+yv7+ZwT7ovEimI9wI
	nGnf/Hf1m7cNWYvgcsHCymjAfGOoPkjbVfRHi/LAuErKe7C/e8pKenqPNoHdn5QBwbzyPhpMwXc
	m9uqGg4CkbEMbt+Z3zCqMUhteriJMl2r8dARD+1kIEB0V9RYWCM+dlvEJ2XoqbYjhOgpFmcTT4p
	12g/rUghxQxtI9fRvhaqYL5ee5c7lNoX3sHgvb9WCBavLeVzrO24MCV3YAuEe7urUrgpoP0n2iJ
	k6mZzF9DsH+3MC4ybUHTXdNPXhZKiqDx9qlJPUQ==
X-Received: by 2002:a05:620a:2a14:b0:93b:d7ed:ff3d with SMTP id af79cd13be357-93ebd2aa64cmr2335759585a.63.1791949859665;
        Tue, 13 Oct 2026 20:50:59 -0700 (PDT)
X-Received: by 2002:a05:620a:2a14:b0:93b:d7ed:ff3d with SMTP id af79cd13be357-93ebd2aa64cmr2335756785a.63.1791949859113;
        Tue, 13 Oct 2026 20:50:59 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93ef50b6c4fsm393907285a.47.2026.10.13.20.50.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 20:50:58 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	djwong@kernel.org,
	hch@lst.de,
	Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 1/5] xfs: remove redundant stat checks after xfs_btree_insert()
Date: Tue, 13 Oct 2026 20:29:59 -0500
Message-ID: <20261014013505.759089-2-sandeen@redhat.com>
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

xfs_btree_insert() already validates its own status internally; it
checks the result of xfs_btree_insrec(). If it succeeds, it returns
error == 0 and status == 1. If that fails, it returns a nonzero error
and never even updates stat.

This makes every instance of the 2nd test in this idiom:

	if ((error = xfs_btree_insert(cnt_cur, &i)))
		return error;
	if (XFS_IS_CORRUPT(mp, i != 1)) {
		xfs_btree_mark_sick(cnt_cur);
		return -EFSCORRUPTED;
	}

duplicate/unreachable code at best, which is good because on an error
return it would have tested a stale variable.

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
index 9bffde1484a7..a7e548078d18 100644
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

