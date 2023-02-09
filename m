Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEB8AC6379F
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 22:26:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbjBIW0h (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 17:26:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbjBIW0f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 17:26:35 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96D375775B
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 14:26:34 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id j1so3495350pjd.0
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 14:26:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mexBWptNQVnP9reQWDWoN0KN+Goqay1SSt+uxDo4sfc=;
        b=J8Q1uBtw+ECNE9/6yW6s6O6KKbMr3Vjpc+/I7l67Lo04RbpnhHDaCipIchHl6NgKVB
         giZwJd1lvH6P546bLAdwf9F3VRh4UaDpfqJ9t4/sHrQOrD337X+QsDJxNK7AMBgpW/Bk
         HZeZsqkhvUJEzk2fcdubh9ndnkWBUyzNBcFsehM4Axyl8PtZKAGKeoBncwg9hSplPsq/
         Y4eCXFT1qvllAtSBvhozli7Aeads9NfSoewvTxp5GErRoyKGRQpsmxxna63AxMYFqKeP
         WJ1TmZI+qNh0vrAty7R3L8OiukZE6cJaGMQEH3QHG2Rkidj29YMDL8y0DiiBT1dTYrqT
         llDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mexBWptNQVnP9reQWDWoN0KN+Goqay1SSt+uxDo4sfc=;
        b=fhGkEHwU5mzZcsMaD08hO+aaN68LNCTLSNcRPC9hRZq1LzoxzLaiJ4TL4izCqZ+Kmm
         pTpZJOy9vHDJp50N/l0czX2BfdPt+jYG9YJxrVGZeHnP6aZA88CYZuxrrHGfdZ7m484p
         EaZGt6sP34yOTL9bQUgaZ8cH8I6Hjb7OXbz/NcO5sbL4B+PPjCq4RIBdw+QVhMovoAXI
         L1UadHHgPhZ019RAmWK7cfYQG6JKXiTlsmlu8oJqzzEcWlOlTk3twE6Wk+EIDeY8pUlI
         J15+xWQI5zNHbiAtYcwMvF+oY/OZXN37NjYTM8VeqQTwkQyOZubevIVCVF20l9KeFVhW
         Z2Bw==
X-Gm-Message-State: AO0yUKU2I1F0bJ4xpfhr0hT6Y7d5GwLNPqMHHwAdMcGy2W7DjZSYTc7F
        htHEGo4EIG9lVD3edEhwVW3OCMNL1D40hBwJ
X-Google-Smtp-Source: AK7set/tt6nXXSZHekAIBYB7kKrj/vkYq/kNnmM2woFHeqeeD9vaPTZN5t8kBZM1MQmkQY7pyARJ6A==
X-Received: by 2002:a17:90b:3ece:b0:230:8452:679e with SMTP id rm14-20020a17090b3ece00b002308452679emr14057695pjb.27.1675981594013;
        Thu, 09 Feb 2023 14:26:34 -0800 (PST)
Received: from dread.disaster.area (pa49-181-4-128.pa.nsw.optusnet.com.au. [49.181.4.128])
        by smtp.gmail.com with ESMTPSA id h4-20020a17090a648400b0022c35afad5bsm250635pjj.16.2023.02.09.14.26.33
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 14:26:33 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pQFFM-00DOVY-Gh
        for linux-xfs@vger.kernel.org; Fri, 10 Feb 2023 09:18:28 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pQFFM-00FcNq-1d
        for linux-xfs@vger.kernel.org;
        Fri, 10 Feb 2023 09:18:28 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 24/42] xfs: introduce xfs_alloc_vextent_prepare()
Date:   Fri, 10 Feb 2023 09:18:07 +1100
Message-Id: <20230209221825.3722244-25-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209221825.3722244-1-david@fromorbit.com>
References: <20230209221825.3722244-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Now that we have wrapper functions for each type of allocation we
can ask for, we can start unravelling xfs_alloc_ag_vextent(). That
is essentially just a prepare stage, the allocation multiplexer
and a post-allocation accounting step is the allocation proceeded.

The current xfs_alloc_vextent*() wrappers all have a prepare stage,
the allocation operation and a post-allocation accounting step.

We can consolidate this by moving the AG alloc prep code into the
wrapper functions, the accounting code in the wrapper accounting
functions, and cut out the multiplexer layer entirely.

This patch consolidates the AG preparation stage.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c | 122 ++++++++++++++++++++++++--------------
 1 file changed, 77 insertions(+), 45 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 5093fa856f35..dc1b6c6e1de7 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1144,31 +1144,8 @@ static int
 xfs_alloc_ag_vextent(
 	struct xfs_alloc_arg	*args)
 {
-	struct xfs_mount	*mp = args->mp;
 	int			error = 0;
 
-	ASSERT(args->minlen > 0);
-	ASSERT(args->maxlen > 0);
-	ASSERT(args->minlen <= args->maxlen);
-	ASSERT(args->mod < args->prod);
-	ASSERT(args->alignment > 0);
-	ASSERT(args->resv != XFS_AG_RESV_AGFL);
-
-
-	error = xfs_alloc_fix_freelist(args, 0);
-	if (error) {
-		trace_xfs_alloc_vextent_nofix(args);
-		return error;
-	}
-	if (!args->agbp) {
-		/* cannot allocate in this AG at all */
-		trace_xfs_alloc_vextent_noagbp(args);
-		args->agbno = NULLAGBLOCK;
-		return 0;
-	}
-	args->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);
-	args->wasfromfl = 0;
-
 	/*
 	 * Branch to correct routine based on the type.
 	 */
@@ -3201,11 +3178,18 @@ xfs_alloc_vextent_check_args(
 		args->maxlen = agsize;
 	if (args->alignment == 0)
 		args->alignment = 1;
+
+	ASSERT(args->minlen > 0);
+	ASSERT(args->maxlen > 0);
+	ASSERT(args->alignment > 0);
+	ASSERT(args->resv != XFS_AG_RESV_AGFL);
+
 	ASSERT(XFS_FSB_TO_AGNO(mp, target) < mp->m_sb.sb_agcount);
 	ASSERT(XFS_FSB_TO_AGBNO(mp, target) < agsize);
 	ASSERT(args->minlen <= args->maxlen);
 	ASSERT(args->minlen <= agsize);
 	ASSERT(args->mod < args->prod);
+
 	if (XFS_FSB_TO_AGNO(mp, target) >= mp->m_sb.sb_agcount ||
 	    XFS_FSB_TO_AGBNO(mp, target) >= agsize ||
 	    args->minlen > args->maxlen || args->minlen > agsize ||
@@ -3217,6 +3201,41 @@ xfs_alloc_vextent_check_args(
 	return 0;
 }
 
+/*
+ * Prepare an AG for allocation. If the AG is not prepared to accept the
+ * allocation, return failure.
+ *
+ * XXX(dgc): The complexity of "need_pag" will go away as all caller paths are
+ * modified to hold their own perag references.
+ */
+static int
+xfs_alloc_vextent_prepare_ag(
+	struct xfs_alloc_arg	*args)
+{
+	bool			need_pag = !args->pag;
+	int			error;
+
+	if (need_pag)
+		args->pag = xfs_perag_get(args->mp, args->agno);
+
+	error = xfs_alloc_fix_freelist(args, 0);
+	if (error) {
+		trace_xfs_alloc_vextent_nofix(args);
+		if (need_pag)
+			xfs_perag_put(args->pag);
+		args->agbno = NULLAGBLOCK;
+		return error;
+	}
+	if (!args->agbp) {
+		/* cannot allocate in this AG at all */
+		trace_xfs_alloc_vextent_noagbp(args);
+		args->agbno = NULLAGBLOCK;
+		return 0;
+	}
+	args->wasfromfl = 0;
+	return 0;
+}
+
 /*
  * Post-process allocation results to set the allocated block number correctly
  * for the caller.
@@ -3268,7 +3287,8 @@ xfs_alloc_vextent_set_fsbno(
 }
 
 /*
- * Allocate within a single AG only.
+ * Allocate within a single AG only. Caller is expected to hold a
+ * perag reference in args->pag.
  */
 int
 xfs_alloc_vextent_this_ag(
@@ -3301,7 +3321,10 @@ xfs_alloc_vextent_this_ag(
 	args->fsbno = target;
 	args->type = XFS_ALLOCTYPE_THIS_AG;
 
-	error = xfs_alloc_ag_vextent(args);
+	error = xfs_alloc_vextent_prepare_ag(args);
+	if (!error && args->agbp)
+		error = xfs_alloc_ag_vextent(args);
+
 	xfs_alloc_vextent_set_fsbno(args, minimum_agno);
 	return error;
 }
@@ -3339,13 +3362,19 @@ xfs_alloc_vextent_iterate_ags(
 	args->agno = start_agno;
 	for (;;) {
 		args->pag = xfs_perag_get(mp, args->agno);
-		error = xfs_alloc_ag_vextent(args);
-		if (error) {
-			args->agbno = NULLAGBLOCK;
+		args->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);
+		error = xfs_alloc_vextent_prepare_ag(args);
+		if (error)
+			break;
+
+		if (args->agbp) {
+			/*
+			 * Allocation is supposed to succeed now, so break out
+			 * of the loop regardless of whether we succeed or not.
+			 */
+			error = xfs_alloc_ag_vextent(args);
 			break;
 		}
-		if (args->agbp)
-			break;
 
 		trace_xfs_alloc_vextent_loopfailed(args);
 
@@ -3378,10 +3407,8 @@ xfs_alloc_vextent_iterate_ags(
 			}
 
 			flags = 0;
-			if (args->otype == XFS_ALLOCTYPE_NEAR_BNO) {
-				args->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);
+			if (args->otype == XFS_ALLOCTYPE_NEAR_BNO)
 				args->type = XFS_ALLOCTYPE_NEAR_BNO;
-			}
 		}
 		xfs_perag_put(args->pag);
 		args->pag = NULL;
@@ -3485,7 +3512,8 @@ xfs_alloc_vextent_first_ag(
 }
 
 /*
- * Allocate within a single AG only.
+ * Allocate at the exact block target or fail. Caller is expected to hold a
+ * perag reference in args->pag.
  */
 int
 xfs_alloc_vextent_exact_bno(
@@ -3515,9 +3543,10 @@ xfs_alloc_vextent_exact_bno(
 	args->agbno = XFS_FSB_TO_AGBNO(mp, target);
 	args->fsbno = target;
 	args->type = XFS_ALLOCTYPE_THIS_BNO;
-	error = xfs_alloc_ag_vextent(args);
-	if (error)
-		return error;
+
+	error = xfs_alloc_vextent_prepare_ag(args);
+	if (!error && args->agbp)
+		error = xfs_alloc_ag_vextent(args);
 
 	xfs_alloc_vextent_set_fsbno(args, minimum_agno);
 	return 0;
@@ -3526,6 +3555,8 @@ xfs_alloc_vextent_exact_bno(
 /*
  * Allocate an extent as close to the target as possible. If there are not
  * viable candidates in the AG, then fail the allocation.
+ *
+ * Caller may or may not have a per-ag reference in args->pag.
  */
 int
 xfs_alloc_vextent_near_bno(
@@ -3550,21 +3581,22 @@ xfs_alloc_vextent_near_bno(
 	args->agno = XFS_FSB_TO_AGNO(mp, target);
 	if (minimum_agno > args->agno) {
 		trace_xfs_alloc_vextent_skip_deadlock(args);
+		args->fsbno = NULLFSBLOCK;
 		return 0;
 	}
 
 	args->agbno = XFS_FSB_TO_AGBNO(mp, target);
 	args->type = XFS_ALLOCTYPE_NEAR_BNO;
-	if (need_pag)
-		args->pag = xfs_perag_get(args->mp, args->agno);
-	error = xfs_alloc_ag_vextent(args);
-	if (need_pag)
-		xfs_perag_put(args->pag);
-	if (error)
-		return error;
+
+	error = xfs_alloc_vextent_prepare_ag(args);
+	if (!error && args->agbp)
+		error = xfs_alloc_ag_vextent(args);
 
 	xfs_alloc_vextent_set_fsbno(args, minimum_agno);
-	return 0;
+	if (need_pag)
+		xfs_perag_put(args->pag);
+
+	return error;
 }
 
 /* Ensure that the freelist is at full capacity. */
-- 
2.39.0

