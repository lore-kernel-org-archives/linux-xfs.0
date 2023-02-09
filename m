Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EECAC636D6
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 22:18:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbjBIWSj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 17:18:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbjBIWSg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 17:18:36 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7FEA6B371
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 14:18:32 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id g9so2316800pfo.5
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 14:18:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fAcQzdkdwgSgjD3TvHpuNNxyWFMaiQRygF8zFkELz3Q=;
        b=kWGXrIX3Sa8EjbZ3Ibhd92CvI8pxEChZX+EUIIq8xwXgARE6Jooh7ULReebWzflw9o
         6sRV2/LF+jziABcum2crdH++r11beImjKpZ265GhXFGQ8PJm5p/kgYi2RgusatrYyHLP
         cVvOIZ9c3y7SDfJ3t5YlXuEOXm8ArCcIr81Ng40vA2c+eHO8RBn0/hArxGZw6oTd/8+l
         TCv0ZferDB/DXW90SiaSBhl+C+xCyCJocLv5BeIL1nnHbK0l0I6tmpjOGv6TW+1aB43T
         Yo2AZtHJs1PshGWW5MT0eSm81sPVwhkQz3riRWlchHG1Rii+plkWxYWvKPZ9o6YJRRvR
         CCgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fAcQzdkdwgSgjD3TvHpuNNxyWFMaiQRygF8zFkELz3Q=;
        b=jTil33zZeDyHHSHVFTZGbyijEVObknPcEvV+4BOWNyKog4MvyTg7fhk3/ene4ls0+w
         OxPmQVZZtIEAYLRtiv1FhAtBPc1vPDA9+D10zZgKciosLKlrNl4jEdelpQ1rxHSXhNyj
         g2zzd6M0vDS5W/bs55Sry/QjVE4iryr8xD4+IilD0X19T/dTsQl8llzq+GAuPCp5101V
         Td19TfpAl/qhnL34woh1fvtgcgMTAzX0Qv0ESsvkhblyhlR6zdQTBYCJPnVfmXvtUDAx
         AUwafgQKsuDwHpFr3QBSOkC6PItqGgCryUATi7Q0Ju5ojwRFJIhHyTtW0ZmfPS/0itcq
         wcqA==
X-Gm-Message-State: AO0yUKWJvInGT/AKzOwjXKRDIp0cZzoHeFjshuF7BefvrobKZPVeOYuG
        I//2eTMJt52ZqwrE9y5OURrMx5DzIHhA70kB
X-Google-Smtp-Source: AK7set8vg8E3a6TWZmrvjNtRvEtSA+ssGm0VLSnATRgZGxrKRWW3qvLRm6LMPjk7ZuJzcMV615Xazg==
X-Received: by 2002:aa7:9533:0:b0:593:95cf:3c81 with SMTP id c19-20020aa79533000000b0059395cf3c81mr10788813pfp.24.1675981112322;
        Thu, 09 Feb 2023 14:18:32 -0800 (PST)
Received: from dread.disaster.area (pa49-181-4-128.pa.nsw.optusnet.com.au. [49.181.4.128])
        by smtp.gmail.com with ESMTPSA id t20-20020aa79394000000b005921c46cbadsm1975387pfe.99.2023.02.09.14.18.30
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 14:18:31 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pQFFM-00DOVb-Hd
        for linux-xfs@vger.kernel.org; Fri, 10 Feb 2023 09:18:28 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pQFFM-00FcNv-1j
        for linux-xfs@vger.kernel.org;
        Fri, 10 Feb 2023 09:18:28 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 25/42] xfs: move allocation accounting to xfs_alloc_vextent_set_fsbno()
Date:   Fri, 10 Feb 2023 09:18:08 +1100
Message-Id: <20230209221825.3722244-26-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209221825.3722244-1-david@fromorbit.com>
References: <20230209221825.3722244-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Move it from xfs_alloc_ag_vextent() so we can get rid of that layer.
Rename xfs_alloc_vextent_set_fsbno() to xfs_alloc_vextent_finish()
to indicate that it's function is finishing off the allocation that
we've run now that it contains much more functionality.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c | 122 ++++++++++++++++++++------------------
 1 file changed, 63 insertions(+), 59 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index dc1b6c6e1de7..afc6bd48b0a5 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1163,36 +1163,6 @@ xfs_alloc_ag_vextent(
 		ASSERT(0);
 		/* NOTREACHED */
 	}
-
-	if (error || args->agbno == NULLAGBLOCK)
-		return error;
-
-	ASSERT(args->len >= args->minlen);
-	ASSERT(args->len <= args->maxlen);
-	ASSERT(args->agbno % args->alignment == 0);
-
-	/* if not file data, insert new block into the reverse map btree */
-	if (!xfs_rmap_should_skip_owner_update(&args->oinfo)) {
-		error = xfs_rmap_alloc(args->tp, args->agbp, args->pag,
-				       args->agbno, args->len, &args->oinfo);
-		if (error)
-			return error;
-	}
-
-	if (!args->wasfromfl) {
-		error = xfs_alloc_update_counters(args->tp, args->agbp,
-						  -((long)(args->len)));
-		if (error)
-			return error;
-
-		ASSERT(!xfs_extent_busy_search(args->mp, args->pag,
-					      args->agbno, args->len));
-	}
-
-	xfs_ag_resv_alloc_extent(args->pag, args->resv, args);
-
-	XFS_STATS_INC(args->mp, xs_allocx);
-	XFS_STATS_ADD(args->mp, xs_allocb, args->len);
 	return error;
 }
 
@@ -3237,18 +3207,21 @@ xfs_alloc_vextent_prepare_ag(
 }
 
 /*
- * Post-process allocation results to set the allocated block number correctly
- * for the caller.
+ * Post-process allocation results to account for the allocation if it succeed
+ * and set the allocated block number correctly for the caller.
  *
- * XXX: xfs_alloc_vextent() should really be returning ENOSPC for ENOSPC, not
+ * XXX: we should really be returning ENOSPC for ENOSPC, not
  * hiding it behind a "successful" NULLFSBLOCK allocation.
  */
-static void
-xfs_alloc_vextent_set_fsbno(
+static int
+xfs_alloc_vextent_finish(
 	struct xfs_alloc_arg	*args,
-	xfs_agnumber_t		minimum_agno)
+	xfs_agnumber_t		minimum_agno,
+	int			alloc_error,
+	bool			drop_perag)
 {
 	struct xfs_mount	*mp = args->mp;
+	int			error = 0;
 
 	/*
 	 * We can end up here with a locked AGF. If we failed, the caller is
@@ -3271,19 +3244,54 @@ xfs_alloc_vextent_set_fsbno(
 	     args->agno > minimum_agno))
 		args->tp->t_highest_agno = args->agno;
 
-	/* Allocation failed with ENOSPC if NULLAGBLOCK was returned. */
-	if (args->agbno == NULLAGBLOCK) {
+	/*
+	 * If the allocation failed with an error or we had an ENOSPC result,
+	 * preserve the returned error whilst also marking the allocation result
+	 * as "no extent allocated". This ensures that callers that fail to
+	 * capture the error will still treat it as a failed allocation.
+	 */
+	if (alloc_error || args->agbno == NULLAGBLOCK) {
 		args->fsbno = NULLFSBLOCK;
-		return;
+		error = alloc_error;
+		goto out_drop_perag;
 	}
 
 	args->fsbno = XFS_AGB_TO_FSB(mp, args->agno, args->agbno);
-#ifdef DEBUG
+
 	ASSERT(args->len >= args->minlen);
 	ASSERT(args->len <= args->maxlen);
 	ASSERT(args->agbno % args->alignment == 0);
 	XFS_AG_CHECK_DADDR(mp, XFS_FSB_TO_DADDR(mp, args->fsbno), args->len);
-#endif
+
+	/* if not file data, insert new block into the reverse map btree */
+	if (!xfs_rmap_should_skip_owner_update(&args->oinfo)) {
+		error = xfs_rmap_alloc(args->tp, args->agbp, args->pag,
+				       args->agbno, args->len, &args->oinfo);
+		if (error)
+			goto out_drop_perag;
+	}
+
+	if (!args->wasfromfl) {
+		error = xfs_alloc_update_counters(args->tp, args->agbp,
+						  -((long)(args->len)));
+		if (error)
+			goto out_drop_perag;
+
+		ASSERT(!xfs_extent_busy_search(mp, args->pag, args->agbno,
+				args->len));
+	}
+
+	xfs_ag_resv_alloc_extent(args->pag, args->resv, args);
+
+	XFS_STATS_INC(mp, xs_allocx);
+	XFS_STATS_ADD(mp, xs_allocb, args->len);
+
+out_drop_perag:
+	if (drop_perag) {
+		xfs_perag_put(args->pag);
+		args->pag = NULL;
+	}
+	return error;
 }
 
 /*
@@ -3325,8 +3333,7 @@ xfs_alloc_vextent_this_ag(
 	if (!error && args->agbp)
 		error = xfs_alloc_ag_vextent(args);
 
-	xfs_alloc_vextent_set_fsbno(args, minimum_agno);
-	return error;
+	return xfs_alloc_vextent_finish(args, minimum_agno, error, false);
 }
 
 /*
@@ -3413,10 +3420,10 @@ xfs_alloc_vextent_iterate_ags(
 		xfs_perag_put(args->pag);
 		args->pag = NULL;
 	}
-	if (args->pag) {
-		xfs_perag_put(args->pag);
-		args->pag = NULL;
-	}
+	/*
+	 * The perag is left referenced in args for the caller to clean
+	 * up after they've finished the allocation.
+	 */
 	return error;
 }
 
@@ -3473,8 +3480,7 @@ xfs_alloc_vextent_start_ag(
 				(mp->m_sb.sb_agcount * rotorstep);
 	}
 
-	xfs_alloc_vextent_set_fsbno(args, minimum_agno);
-	return error;
+	return xfs_alloc_vextent_finish(args, minimum_agno, error, true);
 }
 
 /*
@@ -3507,8 +3513,7 @@ xfs_alloc_vextent_first_ag(
 	args->fsbno = target;
 	error = xfs_alloc_vextent_iterate_ags(args, minimum_agno,
 			start_agno, 0);
-	xfs_alloc_vextent_set_fsbno(args, minimum_agno);
-	return error;
+	return xfs_alloc_vextent_finish(args, minimum_agno, error, true);
 }
 
 /*
@@ -3537,6 +3542,7 @@ xfs_alloc_vextent_exact_bno(
 	args->agno = XFS_FSB_TO_AGNO(mp, target);
 	if (minimum_agno > args->agno) {
 		trace_xfs_alloc_vextent_skip_deadlock(args);
+		args->fsbno = NULLFSBLOCK;
 		return 0;
 	}
 
@@ -3548,8 +3554,7 @@ xfs_alloc_vextent_exact_bno(
 	if (!error && args->agbp)
 		error = xfs_alloc_ag_vextent(args);
 
-	xfs_alloc_vextent_set_fsbno(args, minimum_agno);
-	return 0;
+	return xfs_alloc_vextent_finish(args, minimum_agno, error, false);
 }
 
 /*
@@ -3564,8 +3569,8 @@ xfs_alloc_vextent_near_bno(
 	xfs_fsblock_t		target)
 {
 	struct xfs_mount	*mp = args->mp;
-	bool			need_pag = !args->pag;
 	xfs_agnumber_t		minimum_agno = 0;
+	bool			needs_perag = args->pag == NULL;
 	int			error;
 
 	if (args->tp->t_highest_agno != NULLAGNUMBER)
@@ -3585,6 +3590,9 @@ xfs_alloc_vextent_near_bno(
 		return 0;
 	}
 
+	if (needs_perag)
+		args->pag = xfs_perag_get(mp, args->agno);
+
 	args->agbno = XFS_FSB_TO_AGBNO(mp, target);
 	args->type = XFS_ALLOCTYPE_NEAR_BNO;
 
@@ -3592,11 +3600,7 @@ xfs_alloc_vextent_near_bno(
 	if (!error && args->agbp)
 		error = xfs_alloc_ag_vextent(args);
 
-	xfs_alloc_vextent_set_fsbno(args, minimum_agno);
-	if (need_pag)
-		xfs_perag_put(args->pag);
-
-	return error;
+	return xfs_alloc_vextent_finish(args, minimum_agno, error, needs_perag);
 }
 
 /* Ensure that the freelist is at full capacity. */
-- 
2.39.0

