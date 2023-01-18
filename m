Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0423C54EBE
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 22:45:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbjARWpb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 17:45:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbjARWpQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 17:45:16 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1775763E33
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:45:15 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id o7-20020a17090a0a0700b00226c9b82c3aso53532pjo.3
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:45:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hnuflYs+BfGSJanOhbybJAm2JtL16RGB8F5JipMIgL0=;
        b=5Fq0DEMRbbG58HJ7PPxkvJn++SXOA3fPyDBW7hJcdjr9XuBcCdDYOfwtHMZSxme3Zm
         cpQcKe88hgs+lbemJulxoj2AXCMZV2wt4EdT7eCVoihWtQKu+n0l4xQGyTxyOTsNNmal
         QoaOlU8H/hf8z5EnEHnH3i55mj/q81PQ9e4oGWVKA9/A1UEF1TxJgAHh697LBIwIhuYm
         6Ok1JgGB0DJpoHsctWJuzpkHnyIZilnWgj316gEF3nsKN7XdX9VhsdBxP32Oxln/Hbgz
         REKJI12h0BuU90Z8gwbWtfys3Bt8t94qn9bMPFd3cHOhSKRxxpzAlMZXST6OAOkmwBYZ
         7p8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hnuflYs+BfGSJanOhbybJAm2JtL16RGB8F5JipMIgL0=;
        b=XeNMlNsx7QQVYTdQ1ZF0KCfjTcl/lLdP5r3ig7DWknakaEE1xUDSE94z0S8OVu0rbG
         +qg2o8NHxs7zgHTl0hMlV7GNpZCh/Yg7Kg5PKJ83fNHGvuvhXqB9g/dqnj8eBAb0Z396
         jE3gbjIu/VEUdSAti5ar8iL/OS5Rdh+BrqkWGRZcJK3eEKRQknIhICfaSQM/e8G4bmVv
         loXExeslGpPRPdSBOqO+JD/mFJMJt6G1CpXtBNTOFyr8YOrpUbl3sLGJKW0whsI6ihDW
         hHm/v8pSTXTecq/BpmhzwmVdDmZdN04Il2osFINF2ouU6Zyvf74qxbRDzs6Gef/nCB6G
         MaRg==
X-Gm-Message-State: AFqh2koms6xSP3cEyN3M6QCCARdOF+wP56G5ucwe3Vd4emurkmKJGtyJ
        /IoUeGbI1vz7l5VmZkb9tLuOU81zZdAfnOdx
X-Google-Smtp-Source: AMrXdXsbaNeFa9pd7a7j8/2kyhKnTFPoAPLCgQ1zdgXfaurPg7iP1LH/p9xNL5Wl/LTBmRr6r375dQ==
X-Received: by 2002:a17:902:e9cd:b0:194:5de4:52d0 with SMTP id 13-20020a170902e9cd00b001945de452d0mr9906567plk.41.1674081914520;
        Wed, 18 Jan 2023 14:45:14 -0800 (PST)
Received: from dread.disaster.area (pa49-186-146-207.pa.vic.optusnet.com.au. [49.186.146.207])
        by smtp.gmail.com with ESMTPSA id a4-20020a170902710400b00192c7f19778sm9189346pll.31.2023.01.18.14.45.13
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 14:45:13 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pIHB9-004iXQ-8t
        for linux-xfs@vger.kernel.org; Thu, 19 Jan 2023 09:45:11 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pIHB9-008FDs-0t
        for linux-xfs@vger.kernel.org;
        Thu, 19 Jan 2023 09:45:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 17/42] xfs: combine __xfs_alloc_vextent_this_ag and  xfs_alloc_ag_vextent
Date:   Thu, 19 Jan 2023 09:44:40 +1100
Message-Id: <20230118224505.1964941-18-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118224505.1964941-1-david@fromorbit.com>
References: <20230118224505.1964941-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

There's a bit of a recursive conundrum around
xfs_alloc_ag_vextent(). We can't first call xfs_alloc_ag_vextent()
without preparing the AGFL for the allocation, and preparing the
AGFL calls xfs_alloc_ag_vextent() to prepare the AGFL for the
allocation. This "double allocation" requirement is not really clear
from the current xfs_alloc_fix_freelist() calls that are sprinkled
through the allocation code.

It's not helped that xfs_alloc_ag_vextent() can actually allocate
from the AGFL itself, but there's special code to prevent AGFL prep
allocations from allocating from the free list it's trying to prep.
The naming is also not consistent: args->wasfromfl is true when we
allocated _from_ the free list, but the indication that we are
allocating _for_ the free list is via checking that (args->resv ==
XFS_AG_RESV_AGFL).

So, lets make this "allocation required for allocation" situation
clear by moving it all inside xfs_alloc_ag_vextent(). The freelist
allocation is a specific XFS_ALLOCTYPE_THIS_AG allocation, which
translated directly to xfs_alloc_ag_vextent_size() allocation.

This enables us to replace __xfs_alloc_vextent_this_ag() with a call
to xfs_alloc_ag_vextent(), and we drive the freelist fixing further
into the per-ag allocation algorithm.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 65 +++++++++++++++++++++------------------
 1 file changed, 35 insertions(+), 30 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 2dec95f35562..011baace7e9d 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1140,22 +1140,38 @@ xfs_alloc_ag_vextent_small(
  * and of the form k * prod + mod unless there's nothing that large.
  * Return the starting a.g. block, or NULLAGBLOCK if we can't do it.
  */
-STATIC int			/* error */
+static int
 xfs_alloc_ag_vextent(
-	xfs_alloc_arg_t	*args)	/* argument structure for allocation */
+	struct xfs_alloc_arg	*args)
 {
-	int		error=0;
+	struct xfs_mount	*mp = args->mp;
+	int			error = 0;
 
 	ASSERT(args->minlen > 0);
 	ASSERT(args->maxlen > 0);
 	ASSERT(args->minlen <= args->maxlen);
 	ASSERT(args->mod < args->prod);
 	ASSERT(args->alignment > 0);
+	ASSERT(args->resv != XFS_AG_RESV_AGFL);
+
+
+	error = xfs_alloc_fix_freelist(args, 0);
+	if (error) {
+		trace_xfs_alloc_vextent_nofix(args);
+		return error;
+	}
+	if (!args->agbp) {
+		/* cannot allocate in this AG at all */
+		trace_xfs_alloc_vextent_noagbp(args);
+		args->agbno = NULLAGBLOCK;
+		return 0;
+	}
+	args->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);
+	args->wasfromfl = 0;
 
 	/*
 	 * Branch to correct routine based on the type.
 	 */
-	args->wasfromfl = 0;
 	switch (args->type) {
 	case XFS_ALLOCTYPE_THIS_AG:
 		error = xfs_alloc_ag_vextent_size(args);
@@ -1176,7 +1192,6 @@ xfs_alloc_ag_vextent(
 
 	ASSERT(args->len >= args->minlen);
 	ASSERT(args->len <= args->maxlen);
-	ASSERT(!args->wasfromfl || args->resv != XFS_AG_RESV_AGFL);
 	ASSERT(args->agbno % args->alignment == 0);
 
 	/* if not file data, insert new block into the reverse map btree */
@@ -2721,7 +2736,7 @@ xfs_alloc_fix_freelist(
 		targs.resv = XFS_AG_RESV_AGFL;
 
 		/* Allocate as many blocks as possible at once. */
-		error = xfs_alloc_ag_vextent(&targs);
+		error = xfs_alloc_ag_vextent_size(&targs);
 		if (error)
 			goto out_agflbp_relse;
 
@@ -2735,6 +2750,18 @@ xfs_alloc_fix_freelist(
 				break;
 			goto out_agflbp_relse;
 		}
+
+		if (!xfs_rmap_should_skip_owner_update(&targs.oinfo)) {
+			error = xfs_rmap_alloc(tp, agbp, pag,
+				       targs.agbno, targs.len, &targs.oinfo);
+			if (error)
+				goto out_agflbp_relse;
+		}
+		error = xfs_alloc_update_counters(tp, agbp,
+						  -((long)(targs.len)));
+		if (error)
+			goto out_agflbp_relse;
+
 		/*
 		 * Put each allocated block on the list.
 		 */
@@ -3244,28 +3271,6 @@ xfs_alloc_vextent_set_fsbno(
 /*
  * Allocate within a single AG only.
  */
-static int
-__xfs_alloc_vextent_this_ag(
-	struct xfs_alloc_arg	*args)
-{
-	struct xfs_mount	*mp = args->mp;
-	int			error;
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
-	return xfs_alloc_ag_vextent(args);
-}
-
 static int
 xfs_alloc_vextent_this_ag(
 	struct xfs_alloc_arg	*args,
@@ -3289,7 +3294,7 @@ xfs_alloc_vextent_this_ag(
 	}
 
 	args->pag = xfs_perag_get(mp, args->agno);
-	error = __xfs_alloc_vextent_this_ag(args);
+	error = xfs_alloc_ag_vextent(args);
 
 	xfs_alloc_vextent_set_fsbno(args, minimum_agno);
 	xfs_perag_put(args->pag);
@@ -3329,7 +3334,7 @@ xfs_alloc_vextent_iterate_ags(
 	args->agno = start_agno;
 	for (;;) {
 		args->pag = xfs_perag_get(mp, args->agno);
-		error = __xfs_alloc_vextent_this_ag(args);
+		error = xfs_alloc_ag_vextent(args);
 		if (error) {
 			args->agbno = NULLAGBLOCK;
 			break;
-- 
2.39.0

