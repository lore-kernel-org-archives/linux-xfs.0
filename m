Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05B9AC636D3
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 22:18:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbjBIWS4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 17:18:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbjBIWSj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 17:18:39 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D396813B
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 14:18:37 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id d2so3402762pjd.5
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 14:18:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GmEeYHTe/0QFZl8H89+gLzcWXiqmRgu+HGpxVFHyunM=;
        b=snmx8Apk2ufVBS0/BXI7xxLbwkoqdH+rdYvq72CZZ9KNbaE3NoFImkLrsz8BG5klOi
         r5fVc8YIag+F2TDz6f1rhN1RVDD3yjx1WFbJrbhp7cQWEjUK59wYzLz+7v/v4B06x+pg
         iViuuxmWIHSe8E1J9XAYRJP6jh8sYoqCn6r1aCuohDM+vE5lbBWHPx0mnXpvg3mfpJSx
         xTTWLgYhIUY6I9bb69Grhn3IZ1P1OxWvbHUnronNdanJUZSZnhtJLSsYRE/19pF1O+9H
         n028wTItfHYb3AFEaursWd62EzXGHz/5+z7zBgDVyFZL3QTplmZrQ73Epzdlir4QL7Lv
         bncQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GmEeYHTe/0QFZl8H89+gLzcWXiqmRgu+HGpxVFHyunM=;
        b=GUG4OCSOAhvDaF/9og65JLCBJ/Sir4aFxsmq89NwyZEJ2EQnQRqsvU0hzOecc0goeo
         BFAj35cpLxPDvdcFnZmdV7RzgkFzsehEsdMpIQGp+YHDxtKxdu8q/d6bm+IQvEmSlCVY
         4wJGa9aDKiQ8SZZQb7QeiE2MygqDlSVkBOicNxPm9Bd3H97jof8I1RNbVblRML852f/R
         cUOr3VKvbjH0NeINJazKY0DrPrgdAxutcpG5zjfJ10+QMdQyOHN+XcT8/O8Xl9xwKBgu
         00HB+bfLx+X4NngyrfLwRw7I6U037zxGs6sXI/yCJOURwq8D39I02tF/QKcxL7/B6bIN
         pLdQ==
X-Gm-Message-State: AO0yUKWf9ad1AI4sxh9qCgdF/we5kTz+rGHccJMNp5ZaV1nlYd3NCtQJ
        AGwRjLLDVZQc1FZolCU6X66WareMyL6zDkdD
X-Google-Smtp-Source: AK7set+uESslHMTtHkIJemx8ddt3N09GTFNv9oTD9DvS+fxsgyGleUEsyXwKBWBODIPzZYDELNG4Kw==
X-Received: by 2002:a17:90a:e7c1:b0:233:ab9b:f86a with SMTP id kb1-20020a17090ae7c100b00233ab9bf86amr82648pjb.8.1675981116509;
        Thu, 09 Feb 2023 14:18:36 -0800 (PST)
Received: from dread.disaster.area (pa49-181-4-128.pa.nsw.optusnet.com.au. [49.181.4.128])
        by smtp.gmail.com with ESMTPSA id n12-20020a17090a928c00b0022c326ad011sm1825901pjo.46.2023.02.09.14.18.35
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 14:18:36 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pQFFM-00DOVK-AE
        for linux-xfs@vger.kernel.org; Fri, 10 Feb 2023 09:18:28 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pQFFM-00FcNH-0z
        for linux-xfs@vger.kernel.org;
        Fri, 10 Feb 2023 09:18:28 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 17/42] xfs: combine __xfs_alloc_vextent_this_ag and  xfs_alloc_ag_vextent
Date:   Fri, 10 Feb 2023 09:18:00 +1100
Message-Id: <20230209221825.3722244-18-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209221825.3722244-1-david@fromorbit.com>
References: <20230209221825.3722244-1-david@fromorbit.com>
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
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c | 65 +++++++++++++++++++++------------------
 1 file changed, 35 insertions(+), 30 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 98defd19e09e..edcbf8fd10ea 100644
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

