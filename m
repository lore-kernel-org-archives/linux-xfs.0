Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 388ABE8FDBF
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Oct 2023 00:19:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238126AbjJDAT5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Oct 2023 20:19:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232552AbjJDAT5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Oct 2023 20:19:57 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D64C1AF
        for <linux-xfs@vger.kernel.org>; Tue,  3 Oct 2023 17:19:51 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 41be03b00d2f7-584a761b301so1070360a12.3
        for <linux-xfs@vger.kernel.org>; Tue, 03 Oct 2023 17:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1696378791; x=1696983591; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uu328fxBcBYqKT7aAM0FyKfXboClLkDuzWqmLPJ8l0w=;
        b=z6LU5Li1AoqcutP0AhcbB0GUrWhhZ71/8c0KyF51Xz9S6M9I/aFvqfAL0fjTQtZLbD
         wbt2REyF5HpADSzAcXp3IyQyHMIu3FEAFJYMd/n9z2nEvsIzJ6ZbtJT0JQ7BcD01jyTn
         G1snbA76oADDUyUeFopKFlH89t8s0MMN1pq8rPXhAhTy0YbkT1xyFKhQC4ZYbNTTcwKg
         BI8jvb+JX4GyZ3JAiU9whj4VzTKy5D3G4JTTMKAeIZW6CoRHcUGhPTdfPZg3JJQIw0BX
         v2ZoOXFM8WJm3NjRmREBt+jdPWP8vn+RrvKG08hVZazUtvADXVU7FI6MfdUbIcPkCqDW
         8QAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696378791; x=1696983591;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uu328fxBcBYqKT7aAM0FyKfXboClLkDuzWqmLPJ8l0w=;
        b=Yb9u9tnlL8avbgLPj4AV/GgRkgSdws5wLVHKGKkMwctWIhnsYvX5Ev77rIEK853IQx
         DDitgKHuz+jKa8COhaU7khta0K/4sHiBu7J70vBNhWnLwIoO8BrkUtCSLJvW13bOlL/M
         IokkpkIKwB3Lq5rXYs62ZH+oFq86YEsOK13RGIOc7mBXQtdMpn7Y4/X7WtKgdy73JSrC
         hSFyQB2BZqLAuH9Dc04yy6nw5c9zbI9y1u+M6mwZra2GtObQ6dl813eJahgDQgGDGJNM
         +QMRzFMO73YIUqYPAg3VLQXFrRroH/79sr4sJNdi6+B4DCeu9sL/KeGSwD01t5y0VbJe
         rnIg==
X-Gm-Message-State: AOJu0Yxzs9OoIBudCMCNJOBWHamVN8ohDF9PvYRsdNKOdlXEhm4Aek0b
        NZ2S7dagVTQi6GoMA8uFdml7QCWRX2UPdOST4w8=
X-Google-Smtp-Source: AGHT+IFmbVXRHVZs7m2MXykoyWvswOK+sZWQTVchY9GBpllh28vZsy6YdbIjnE5BsL/5YpqEDHtsRw==
X-Received: by 2002:a05:6a20:4420:b0:153:dff0:c998 with SMTP id ce32-20020a056a20442000b00153dff0c998mr1261685pzb.6.1696378791114;
        Tue, 03 Oct 2023 17:19:51 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id 12-20020a170902ee4c00b001c3ea6073e0sm2217749plo.37.2023.10.03.17.19.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Oct 2023 17:19:49 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.96)
        (envelope-from <dave@fromorbit.com>)
        id 1qnpcA-0097NY-18;
        Wed, 04 Oct 2023 11:19:46 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97-RC0)
        (envelope-from <dave@devoid.disaster.area>)
        id 1qnpcA-00000001Tre-0F1R;
        Wed, 04 Oct 2023 11:19:46 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     john.g.garry@oracle.com
Subject: [PATCH 9/9] xfs: return -ENOSPC rather than NULLFSBLOCK from allocation functions
Date:   Wed,  4 Oct 2023 11:19:43 +1100
Message-Id: <20231004001943.349265-10-david@fromorbit.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231004001943.349265-1-david@fromorbit.com>
References: <20231004001943.349265-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The core allocation routines may fail due to an ENOSPC condition.
However, they do not report that via an ENOSPC error, they report it
via a "allocation succeeded" return value but with a allocated block
of NULLFSBLOCK.

This behaviour recently lead to a data corruption bug where failure
to allocate a block was not caught correctly - the failure was
treated as a success and an uninitialised fsblock was used for a
data write instead.  This would have been avoided if we returned
ENOSPC for ENOSPC conditions, but we don't so bad things happened.

Make sure we don't have a repeat of this situation by changing the
API to explicitly return ENOSPC when we fail to allocate. If we fail
to capture this correctly, it will lead to failures being noticed
either by ENOSPC escaping to userspace or by causing filesystem
shutdowns when allocations failure where they really shouldn't.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c          |  73 +++++++------------
 fs/xfs/libxfs/xfs_bmap.c           | 112 +++++++++++------------------
 fs/xfs/libxfs/xfs_bmap_btree.c     |  19 +++--
 fs/xfs/libxfs/xfs_ialloc.c         |  26 ++++---
 fs/xfs/libxfs/xfs_ialloc_btree.c   |   8 +--
 fs/xfs/libxfs/xfs_refcount_btree.c |   8 +--
 6 files changed, 98 insertions(+), 148 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 27c62f303488..13fda27fabcb 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1157,9 +1157,9 @@ xfs_alloc_ag_vextent_small(
 	 * Can't do the allocation, give up.
 	 */
 	if (flen < args->minlen) {
-		args->agbno = NULLAGBLOCK;
 		trace_xfs_alloc_small_notenough(args);
-		flen = 0;
+		error = -ENOSPC;
+		goto error;
 	}
 	*fbnop = fbno;
 	*flenp = flen;
@@ -1279,9 +1279,8 @@ xfs_alloc_ag_vextent_exact(
 not_found:
 	/* Didn't find it, return null. */
 	xfs_btree_del_cursor(bno_cur, XFS_BTREE_NOERROR);
-	args->agbno = NULLAGBLOCK;
 	trace_xfs_alloc_exact_notfound(args);
-	return 0;
+	return -ENOSPC;
 
 error0:
 	xfs_btree_del_cursor(bno_cur, XFS_BTREE_ERROR);
@@ -1630,7 +1629,7 @@ xfs_alloc_ag_vextent_near(
 			goto restart;
 		}
 		trace_xfs_alloc_size_neither(args);
-		args->agbno = NULLAGBLOCK;
+		error = -ENOSPC;
 		goto out;
 	}
 
@@ -1882,8 +1881,7 @@ xfs_alloc_ag_vextent_size(
 out_nominleft:
 	xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
 	trace_xfs_alloc_size_nominleft(args);
-	args->agbno = NULLAGBLOCK;
-	return 0;
+	return -ENOSPC;
 }
 
 /*
@@ -2742,16 +2740,15 @@ xfs_alloc_fix_freelist(
 
 		/* Allocate as many blocks as possible at once. */
 		error = xfs_alloc_ag_vextent_size(&targs, alloc_flags);
-		if (error)
-			goto out_agflbp_relse;
 
-		/*
-		 * Stop if we run out.  Won't happen if callers are obeying
-		 * the restrictions correctly.  Can happen for free calls
-		 * on a completely full ag.
-		 */
-		if (targs.agbno == NULLAGBLOCK) {
-			if (alloc_flags & XFS_ALLOC_FLAG_FREEING)
+		if (error) {
+			/*
+			 * Stop if we run out.  Won't happen if callers are
+			 * obeying the restrictions correctly.  Can happen for
+			 * free calls on a completely full ag.
+			 */
+			if (error == -ENOSPC &&
+			    (alloc_flags & XFS_ALLOC_FLAG_FREEING))
 				break;
 			goto out_agflbp_relse;
 		}
@@ -3324,14 +3321,12 @@ xfs_alloc_vextent_prepare_ag(
 		trace_xfs_alloc_vextent_nofix(args);
 		if (need_pag)
 			xfs_perag_put(args->pag);
-		args->agbno = NULLAGBLOCK;
 		return error;
 	}
 	if (!args->agbp) {
 		/* cannot allocate in this AG at all */
 		trace_xfs_alloc_vextent_noagbp(args);
-		args->agbno = NULLAGBLOCK;
-		return 0;
+		return -ENOSPC;
 	}
 	args->wasfromfl = 0;
 	return 0;
@@ -3375,14 +3370,7 @@ xfs_alloc_vextent_finish(
 	     args->agno > minimum_agno))
 		args->tp->t_highest_agno = args->agno;
 
-	/*
-	 * If the allocation failed with an error or we had an ENOSPC result,
-	 * preserve the returned error whilst also marking the allocation result
-	 * as "no extent allocated". This ensures that callers that fail to
-	 * capture the error will still treat it as a failed allocation.
-	 */
-	if (alloc_error || args->agbno == NULLAGBLOCK) {
-		args->fsbno = NULLFSBLOCK;
+	if (alloc_error) {
 		error = alloc_error;
 		goto out_drop_perag;
 	}
@@ -3452,11 +3440,8 @@ xfs_alloc_vextent_this_ag(
 	trace_xfs_alloc_vextent_this_ag(args);
 
 	error = xfs_alloc_vextent_check_args(args, agno, 0, &minimum_agno);
-	if (error) {
-		if (error == -ENOSPC)
-			return 0;
+	if (error)
 		return error;
-	}
 
 	error = xfs_alloc_vextent_prepare_ag(args, alloc_flags);
 	if (!error && args->agbp)
@@ -3503,7 +3488,7 @@ xfs_alloc_vextent_iterate_ags(
 			mp->m_sb.sb_agcount, agno, args->pag) {
 		args->agno = agno;
 		error = xfs_alloc_vextent_prepare_ag(args, alloc_flags);
-		if (error)
+		if (error && error != -ENOSPC)
 			break;
 		if (!args->agbp) {
 			trace_xfs_alloc_vextent_loopfailed(args);
@@ -3523,13 +3508,13 @@ xfs_alloc_vextent_iterate_ags(
 		}
 		break;
 	}
-	if (error) {
+	if (error && error != -ENOSPC) {
 		xfs_perag_rele(args->pag);
 		args->pag = NULL;
 		return error;
 	}
 	if (args->agbp)
-		return 0;
+		return error;
 
 	/*
 	 * We didn't find an AG we can alloation from. If we were given
@@ -3544,7 +3529,7 @@ xfs_alloc_vextent_iterate_ags(
 
 	ASSERT(args->pag == NULL);
 	trace_xfs_alloc_vextent_allfailed(args);
-	return 0;
+	return -ENOSPC;
 }
 
 /*
@@ -3580,11 +3565,8 @@ xfs_alloc_vextent_start_ag(
 	target_agbno = XFS_FSB_TO_AGBNO(mp, target);
 	error = xfs_alloc_vextent_check_args(args, target_agno, target_agbno,
 			&minimum_agno);
-	if (error) {
-		if (error == -ENOSPC)
-			return 0;
+	if (error)
 		return error;
-	}
 
 	if ((args->datatype & XFS_ALLOC_INITIAL_USER_DATA) &&
 	    xfs_is_inode32(mp)) {
@@ -3637,11 +3619,8 @@ xfs_alloc_vextent_first_ag(
 	target_agbno = XFS_FSB_TO_AGBNO(mp, target);
 	error = xfs_alloc_vextent_check_args(args, target_agno, target_agbno,
 			&minimum_agno);
-	if (error) {
-		if (error == -ENOSPC)
-			return 0;
+	if (error)
 		return error;
-	}
 
 	target_agno = max(minimum_agno, target_agno);
 	error = xfs_alloc_vextent_iterate_ags(args, minimum_agno, target_agno,
@@ -3669,11 +3648,8 @@ xfs_alloc_vextent_bno(
 
 	error = xfs_alloc_vextent_check_args(args, args->agno, args->agbno,
 			&minimum_agno);
-	if (error) {
-		if (error == -ENOSPC)
-			return 0;
+	if (error)
 		return error;
-	}
 
 	error = xfs_alloc_vextent_prepare_ag(args, 0);
 	if (!error && args->agbp) {
@@ -3688,7 +3664,8 @@ xfs_alloc_vextent_bno(
 
 /*
  * Allocate at the exact block target or fail. Caller is expected to hold a
- * perag reference in args->pag.
+ * perag reference in args->pag. If the exact block required cannot be
+ * allocated, this will return -ENOSPC.
  */
 int
 xfs_alloc_vextent_exact_bno(
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index c1e2c0707e20..00cebf9eb682 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -659,14 +659,6 @@ xfs_bmap_extents_to_btree(
 	if (error)
 		goto out_root_realloc;
 
-	/*
-	 * Allocation can't fail, the space was reserved.
-	 */
-	if (WARN_ON_ONCE(args.fsbno == NULLFSBLOCK)) {
-		error = -ENOSPC;
-		goto out_root_realloc;
-	}
-
 	cur->bc_ino.allocated++;
 	ip->i_nblocks++;
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, 1L);
@@ -724,6 +716,8 @@ xfs_bmap_extents_to_btree(
 	ASSERT(ifp->if_broot == NULL);
 	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
 
+	/* Allocation shouldn't fail with -ENOSPC because space was reserved. */
+	WARN_ON_ONCE(error == -ENOSPC);
 	return error;
 }
 
@@ -808,8 +802,6 @@ xfs_bmap_local_to_extents(
 	if (error)
 		goto done;
 
-	/* Can't fail, the space was reserved. */
-	ASSERT(args.fsbno != NULLFSBLOCK);
 	ASSERT(args.len == 1);
 	error = xfs_trans_get_buf(tp, args.mp->m_ddev_targp,
 			XFS_FSB_TO_DADDR(args.mp, args.fsbno),
@@ -849,6 +841,9 @@ xfs_bmap_local_to_extents(
 
 done:
 	*logflagsp = flags;
+
+	/* Allocation shouldn't fail with -ENOSPC because space was reserved. */
+	ASSERT(error != -ENOSPC);
 	return error;
 }
 
@@ -3435,11 +3430,8 @@ xfs_bmap_exact_minlen_extent_alloc(
 
 	ASSERT(ap->length);
 
-	if (ap->minlen != 1) {
-		ap->blkno = NULLFSBLOCK;
-		ap->length = 0;
-		return 0;
-	}
+	if (ap->minlen != 1)
+		return -ENOSPC;
 
 	orig_offset = ap->offset;
 	orig_length = ap->length;
@@ -3474,14 +3466,7 @@ xfs_bmap_exact_minlen_extent_alloc(
 	if (error)
 		return error;
 
-	if (args.fsbno != NULLFSBLOCK) {
-		xfs_bmap_process_allocated_extent(ap, &args, orig_offset,
-			orig_length);
-	} else {
-		ap->blkno = NULLFSBLOCK;
-		ap->length = 0;
-	}
-
+	xfs_bmap_process_allocated_extent(ap, &args, orig_offset, orig_length);
 	return 0;
 }
 #else
@@ -3520,17 +3505,14 @@ xfs_bmap_exact_minlen_extent_alloc(
 		args->minalignslop = 0;
 
 	error = xfs_alloc_vextent_exact_bno(args, ap->blkno);
-	if (error)
-		return error;
-
-	if (args->fsbno != NULLFSBLOCK)
-		return 0;
-	/*
-	 * Exact allocation failed. Reset to try an aligned allocation
-	 * according to the original allocation specification.
-	 */
-	args->minlen = nextminlen;
-	return 0;
+	if (error == -ENOSPC) {
+		/*
+		 * Exact allocation failed. Reset to try an aligned allocation
+		 * according to the original allocation specification.
+		 */
+		args->minlen = nextminlen;
+	}
+	return error;
 }
 
 static int
@@ -3557,19 +3539,15 @@ xfs_bmap_btalloc_aligned(
 	args->minalignslop = 0;
 
 	error = xfs_alloc_vextent_near_bno(args, ap->blkno);
-	if (error)
-		return error;
-
-	if (args->fsbno != NULLFSBLOCK)
-		return 0;
-
-	/*
-	 * Allocation failed, so turn return the allocation args to their
-	 * original non-aligned state so the caller can proceed on allocation
-	 * failure as if this function was never called.
-	 */
-	args->alignment = 1;
-	return 0;
+	if (error == -ENOSPC) {
+		/*
+		 * Allocation failed, so turn return the allocation args to
+		 * their original non-aligned state so the caller can proceed on
+		 * allocation failure as if this function was never called.
+		 */
+		args->alignment = 1;
+	}
+	return error;
 }
 
 /*
@@ -3594,17 +3572,15 @@ xfs_bmap_btalloc_low_space(
 	if (args->minlen > ap->minlen) {
 		args->minlen = ap->minlen;
 		error = xfs_alloc_vextent_start_ag(args, ap->blkno);
-		if (error || args->fsbno != NULLFSBLOCK)
+		if (error != -ENOSPC)
 			return error;
 	}
 
 	/* Last ditch attempt before failure is declared. */
 	args->total = ap->minlen;
 	error = xfs_alloc_vextent_first_ag(args, 0);
-	if (error)
-		return error;
 	ap->tp->t_flags |= XFS_TRANS_LOWMODE;
-	return 0;
+	return error;
 }
 
 static int
@@ -3633,17 +3609,18 @@ xfs_bmap_btalloc_filestreams(
 		goto out_low_space;
 	}
 
+	error = -ENOSPC;
 	args->minlen = xfs_bmap_select_minlen(ap, args, blen);
 	if (ap->aeof && ap->offset)
 		error = xfs_bmap_btalloc_at_eof(ap, args, blen, stripe_align);
 
-	if (error || args->fsbno != NULLFSBLOCK)
+	if (error != -ENOSPC)
 		goto out_low_space;
 
 	if (ap->aeof)
 		error = xfs_bmap_btalloc_aligned(ap, args, blen, stripe_align);
 
-	if (!error && args->fsbno == NULLFSBLOCK)
+	if (error == -ENOSPC)
 		error = xfs_alloc_vextent_near_bno(args, ap->blkno);
 
 out_low_space:
@@ -3656,7 +3633,7 @@ xfs_bmap_btalloc_filestreams(
 	 */
 	xfs_perag_rele(args->pag);
 	args->pag = NULL;
-	if (error || args->fsbno != NULLFSBLOCK)
+	if (error != -ENOSPC)
 		return error;
 
 	return xfs_bmap_btalloc_low_space(ap, args);
@@ -3705,10 +3682,11 @@ xfs_bmap_btalloc_best_length(
 		return error;
 	ASSERT(args->pag);
 
+	error = -ENOSPC;
 	if (ap->aeof && ap->offset)
 		error = xfs_bmap_btalloc_at_eof(ap, args, blen, stripe_align);
 
-	if (error || args->fsbno != NULLFSBLOCK)
+	if (error != -ENOSPC)
 		goto out_perag_rele;
 
 
@@ -3726,12 +3704,12 @@ xfs_bmap_btalloc_best_length(
 out_perag_rele:
 	xfs_perag_rele(args->pag);
 	args->pag = NULL;
-	if (error || args->fsbno != NULLFSBLOCK)
+	if (error != -ENOSPC)
 		return error;
 
 	/* attempt unaligned allocation */
 	error = xfs_alloc_vextent_start_ag(args, ap->blkno);
-	if (error || args->fsbno != NULLFSBLOCK)
+	if (error != -ENOSPC)
 		return error;
 
 	return xfs_bmap_btalloc_low_space(ap, args);
@@ -3773,17 +3751,10 @@ xfs_bmap_btalloc(
 		error = xfs_bmap_btalloc_filestreams(ap, &args, stripe_align);
 	else
 		error = xfs_bmap_btalloc_best_length(ap, &args, stripe_align);
-	if (error)
-		return error;
-
-	if (args.fsbno != NULLFSBLOCK) {
+	if (!error)
 		xfs_bmap_process_allocated_extent(ap, &args, orig_offset,
 			orig_length);
-	} else {
-		ap->blkno = NULLFSBLOCK;
-		ap->length = 0;
-	}
-	return 0;
+	return error;
 }
 
 /* Trim extent to fit a logical block range. */
@@ -4189,7 +4160,7 @@ xfs_bmapi_allocate(
 	} else {
 		error = xfs_bmap_alloc_userdata(bma);
 	}
-	if (error || bma->blkno == NULLFSBLOCK)
+	if (error)
 		return error;
 
 	if (bma->flags & XFS_BMAPI_ZERO) {
@@ -4497,10 +4468,10 @@ xfs_bmapi_write(
 			ASSERT(len > 0);
 			ASSERT(bma.length > 0);
 			error = xfs_bmapi_allocate(&bma);
+			if (error == -ENOSPC)
+				break;
 			if (error)
 				goto error0;
-			if (bma.blkno == NULLFSBLOCK)
-				break;
 
 			/*
 			 * If this is a CoW allocation, record the data in
@@ -4656,9 +4627,6 @@ xfs_bmapi_convert_delalloc(
 	if (error)
 		goto out_finish;
 
-	error = -ENOSPC;
-	if (WARN_ON_ONCE(bma.blkno == NULLFSBLOCK))
-		goto out_finish;
 	error = -EFSCORRUPTED;
 	if (WARN_ON_ONCE(!xfs_valid_startblock(ip, bma.got.br_startblock)))
 		goto out_finish;
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index bf3f1b36fdd2..c1f6d0a7d960 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -225,25 +225,24 @@ xfs_bmbt_alloc_block(
 					cur->bc_ino.whichfork);
 
 	error = xfs_alloc_vextent_start_ag(&args, be64_to_cpu(start->l));
-	if (error)
-		return error;
-
-	if (args.fsbno == NULLFSBLOCK && args.minleft) {
+	if (error == -ENOSPC && args.minleft) {
 		/*
-		 * Could not find an AG with enough free space to satisfy
-		 * a full btree split.  Try again and if
-		 * successful activate the lowspace algorithm.
+		 * Could not find an AG with enough free space to satisfy a full
+		 * btree split.  Try again and then activate the lowspace
+		 * algorithm.
 		 */
 		args.minleft = 0;
 		error = xfs_alloc_vextent_start_ag(&args, 0);
-		if (error)
-			return error;
 		cur->bc_tp->t_flags |= XFS_TRANS_LOWMODE;
 	}
-	if (WARN_ON_ONCE(args.fsbno == NULLFSBLOCK)) {
+
+	/* This allocation really should not fail. */
+	if (WARN_ON_ONCE(error == -ENOSPC)) {
 		*stat = 0;
 		return 0;
 	}
+	if (error)
+		return error;
 
 	ASSERT(args.len == 1);
 	cur->bc_ino.allocated++;
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index b83e54c70906..96ccf01a3a74 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -686,6 +686,7 @@ xfs_ialloc_ag_alloc(
 		     igeo->ialloc_blks;
 	if (do_sparse)
 		goto sparse_alloc;
+	error = -ENOSPC;
 	if (likely(newino != NULLAGINO &&
 		  (args.agbno < be32_to_cpu(agi->agi_length)))) {
 		args.prod = 1;
@@ -711,7 +712,7 @@ xfs_ialloc_ag_alloc(
 		error = xfs_alloc_vextent_exact_bno(&args,
 				XFS_AGB_TO_FSB(args.mp, pag->pag_agno,
 						args.agbno));
-		if (error)
+		if (error && error != -ENOSPC)
 			return error;
 
 		/*
@@ -727,7 +728,7 @@ xfs_ialloc_ag_alloc(
 		args.minalignslop = 0;
 	}
 
-	if (unlikely(args.fsbno == NULLFSBLOCK)) {
+	if (error == -ENOSPC) {
 		/*
 		 * Set the alignment for the allocation.
 		 * If stripe alignment is turned on then align at stripe unit
@@ -754,7 +755,7 @@ xfs_ialloc_ag_alloc(
 		error = xfs_alloc_vextent_near_bno(&args,
 				XFS_AGB_TO_FSB(args.mp, pag->pag_agno,
 						be32_to_cpu(agi->agi_root)));
-		if (error)
+		if (error && error != -ENOSPC)
 			return error;
 	}
 
@@ -762,12 +763,12 @@ xfs_ialloc_ag_alloc(
 	 * If stripe alignment is turned on, then try again with cluster
 	 * alignment.
 	 */
-	if (isaligned && args.fsbno == NULLFSBLOCK) {
+	if (error == -ENOSPC && isaligned) {
 		args.alignment = igeo->cluster_align;
 		error = xfs_alloc_vextent_near_bno(&args,
 				XFS_AGB_TO_FSB(args.mp, pag->pag_agno,
 						be32_to_cpu(agi->agi_root)));
-		if (error)
+		if (error && error != -ENOSPC)
 			return error;
 	}
 
@@ -775,9 +776,9 @@ xfs_ialloc_ag_alloc(
 	 * Finally, try a sparse allocation if the filesystem supports it and
 	 * the sparse allocation length is smaller than a full chunk.
 	 */
-	if (xfs_has_sparseinodes(args.mp) &&
-	    igeo->ialloc_min_blks < igeo->ialloc_blks &&
-	    args.fsbno == NULLFSBLOCK) {
+	if (error == -ENOSPC &&
+	    xfs_has_sparseinodes(args.mp) &&
+	    igeo->ialloc_min_blks < igeo->ialloc_blks) {
 sparse_alloc:
 		args.alignment = args.mp->m_sb.sb_spino_align;
 		args.prod = 1;
@@ -803,7 +804,7 @@ xfs_ialloc_ag_alloc(
 		error = xfs_alloc_vextent_near_bno(&args,
 				XFS_AGB_TO_FSB(args.mp, pag->pag_agno,
 						be32_to_cpu(agi->agi_root)));
-		if (error)
+		if (error && error != -ENOSPC)
 			return error;
 
 		newlen = XFS_AGB_TO_AGINO(args.mp, args.len);
@@ -811,7 +812,12 @@ xfs_ialloc_ag_alloc(
 		allocmask = (1 << (newlen / XFS_INODES_PER_HOLEMASK_BIT)) - 1;
 	}
 
-	if (args.fsbno == NULLFSBLOCK)
+	/*
+	 * There really is not available space for inode allocation in this AG,
+	 * so return a -EAGAIN error to the caller to tell it to try a different
+	 * AG.
+	 */
+	if (error == -ENOSPC)
 		return -EAGAIN;
 
 	ASSERT(args.len == args.minlen);
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 9258f01c0015..cbc4413042f2 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -112,13 +112,13 @@ __xfs_inobt_alloc_block(
 
 	error = xfs_alloc_vextent_near_bno(&args,
 			XFS_AGB_TO_FSB(args.mp, args.pag->pag_agno, sbno));
-	if (error)
-		return error;
-
-	if (args.fsbno == NULLFSBLOCK) {
+	if (error == -ENOSPC) {
 		*stat = 0;
 		return 0;
 	}
+	if (error)
+		return error;
+
 	ASSERT(args.len == 1);
 
 	new->s = cpu_to_be32(XFS_FSB_TO_AGBNO(args.mp, args.fsbno));
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 5c3987d8dc24..d5fbdd4e25b6 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -75,14 +75,14 @@ xfs_refcountbt_alloc_block(
 	error = xfs_alloc_vextent_near_bno(&args,
 			XFS_AGB_TO_FSB(args.mp, args.pag->pag_agno,
 					xfs_refc_block(args.mp)));
+	if (error == -ENOSPC) {
+		*stat = 0;
+		return 0;
+	}
 	if (error)
 		goto out_error;
 	trace_xfs_refcountbt_alloc_block(cur->bc_mp, cur->bc_ag.pag->pag_agno,
 			args.agbno, 1);
-	if (args.fsbno == NULLFSBLOCK) {
-		*stat = 0;
-		return 0;
-	}
 	ASSERT(args.agno == cur->bc_ag.pag->pag_agno);
 	ASSERT(args.len == 1);
 
-- 
2.40.1

