Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E80AC61DA4
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 22:18:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbjBIWSi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 17:18:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbjBIWSd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 17:18:33 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B792E6A320
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 14:18:31 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id v18-20020a17090ae99200b00230f079dcd9so6727704pjy.1
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 14:18:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PSbpx7Sk6YgqaCtZA0cJTMX6lBSAnprcBaRlnmUCpiE=;
        b=BRYwh/18zdqcoSJ6WPk+IqH/Lq+4LnLPVOBhVf/uF/KrGN87C4dwte8ZBnuBnXnZtj
         DGlQMkgChuPFqFdmk02pvz7KBWduUXXAGpZMGrxNXzA1Z6wDvGKSazLtDTBpzCk5Ilp1
         NsXtSDMuI1iFC3aMK4fRjG1b6hIUlnmCbhxgiYxH8upRTpbQIu6Ftz7/Ji6TlHn8IN6G
         2rERIKbOMBhCrPKOLy76nq8e9SyWH8QRII/Tph+w7yb7NT9p8qzo4180Nxr/vNuFhCvi
         KYDvWZO+vHtj5eeb8un+guAND6gWfiZy4SapGYu1iAZIquvaw7KuvUnAq4yaqC450l2q
         6m4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PSbpx7Sk6YgqaCtZA0cJTMX6lBSAnprcBaRlnmUCpiE=;
        b=l4edzzeKDeZl9Qg2HiEfGzt56qy+5uY5GpLggsbI51T1vtN3PuwlHnhpRdML0YznxK
         H6mY13mzasctFHJectdkK1KUrF0USEYdkvPDJfG15HRtd+Bm8TCHslfHteNeJ+6Q32hw
         mQaEc++UOUOoWzV3fGbonZ+PM5hkZYAoQi0sUR2Cr2sgIUdksk3dCLlWb1PROFZn1FX5
         OVKqOuwv0jresf9A6GHXe26t5zqgP79kwVhFn0tFttOKEQTkYek8aHutN9iK6fVW0h68
         gB+s/O1TnTIvuymRstbtSPZIpNNJjJEMkYLo5wO9+pOTQuJLIPokA9nHIs5VulfO6bzb
         +TSw==
X-Gm-Message-State: AO0yUKXkUSeShgK0zaEzInKnNumTmqhAneBBd46iIdu1wvbuK+RTgnId
        Ai3Xlr8JWQRHQNw7NQrDm/TIqBo/QCZhq1zu
X-Google-Smtp-Source: AK7set8PMgryug/0V7dUH+RiIayE4k4ahy+KyEA92WnwFaKoZh2nOOpClKYc7X2g5RNrvhI+P1e7Rg==
X-Received: by 2002:a17:903:4091:b0:19a:67c0:53fb with SMTP id z17-20020a170903409100b0019a67c053fbmr1652785plc.56.1675981111326;
        Thu, 09 Feb 2023 14:18:31 -0800 (PST)
Received: from dread.disaster.area (pa49-181-4-128.pa.nsw.optusnet.com.au. [49.181.4.128])
        by smtp.gmail.com with ESMTPSA id 6-20020a170902c24600b0019472226769sm1983231plg.251.2023.02.09.14.18.30
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 14:18:31 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pQFFM-00DOVz-KN
        for linux-xfs@vger.kernel.org; Fri, 10 Feb 2023 09:18:28 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pQFFM-00FcOA-20
        for linux-xfs@vger.kernel.org;
        Fri, 10 Feb 2023 09:18:28 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 28/42] xfs: convert xfs_alloc_vextent_iterate_ags() to use perag walker
Date:   Fri, 10 Feb 2023 09:18:11 +1100
Message-Id: <20230209221825.3722244-29-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209221825.3722244-1-david@fromorbit.com>
References: <20230209221825.3722244-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Now that the AG iteration code in the core allocation code has been
cleaned up, we can easily convert it to use a for_each_perag..()
variant to use active references and skip AGs that it can't get
active references on.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ag.h    | 22 ++++++---
 fs/xfs/libxfs/xfs_alloc.c | 96 +++++++++++++++++----------------------
 2 files changed, 57 insertions(+), 61 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 8f43b91d4cf3..5e18536dfdce 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -253,6 +253,7 @@ xfs_perag_next_wrap(
 	struct xfs_perag	*pag,
 	xfs_agnumber_t		*agno,
 	xfs_agnumber_t		stop_agno,
+	xfs_agnumber_t		restart_agno,
 	xfs_agnumber_t		wrap_agno)
 {
 	struct xfs_mount	*mp = pag->pag_mount;
@@ -260,10 +261,11 @@ xfs_perag_next_wrap(
 	*agno = pag->pag_agno + 1;
 	xfs_perag_rele(pag);
 	while (*agno != stop_agno) {
-		if (*agno >= wrap_agno)
-			*agno = 0;
-		if (*agno == stop_agno)
-			break;
+		if (*agno >= wrap_agno) {
+			if (restart_agno >= stop_agno)
+				break;
+			*agno = restart_agno;
+		}
 
 		pag = xfs_perag_grab(mp, *agno);
 		if (pag)
@@ -274,14 +276,20 @@ xfs_perag_next_wrap(
 }
 
 /*
- * Iterate all AGs from start_agno through wrap_agno, then 0 through
+ * Iterate all AGs from start_agno through wrap_agno, then restart_agno through
  * (start_agno - 1).
  */
-#define for_each_perag_wrap_at(mp, start_agno, wrap_agno, agno, pag) \
+#define for_each_perag_wrap_range(mp, start_agno, restart_agno, wrap_agno, agno, pag) \
 	for ((agno) = (start_agno), (pag) = xfs_perag_grab((mp), (agno)); \
 		(pag) != NULL; \
 		(pag) = xfs_perag_next_wrap((pag), &(agno), (start_agno), \
-				(wrap_agno)))
+				(restart_agno), (wrap_agno)))
+/*
+ * Iterate all AGs from start_agno through wrap_agno, then 0 through
+ * (start_agno - 1).
+ */
+#define for_each_perag_wrap_at(mp, start_agno, wrap_agno, agno, pag) \
+	for_each_perag_wrap_range((mp), (start_agno), 0, (wrap_agno), (agno), (pag))
 
 /*
  * Iterate all AGs from start_agno through to the end of the filesystem, then 0
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 94cea96caf5d..6a037173d20d 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3156,6 +3156,7 @@ xfs_alloc_vextent_prepare_ag(
 	if (need_pag)
 		args->pag = xfs_perag_get(args->mp, args->agno);
 
+	args->agbp = NULL;
 	error = xfs_alloc_fix_freelist(args, 0);
 	if (error) {
 		trace_xfs_alloc_vextent_nofix(args);
@@ -3255,8 +3256,8 @@ xfs_alloc_vextent_finish(
 	XFS_STATS_ADD(mp, xs_allocb, args->len);
 
 out_drop_perag:
-	if (drop_perag) {
-		xfs_perag_put(args->pag);
+	if (drop_perag && args->pag) {
+		xfs_perag_rele(args->pag);
 		args->pag = NULL;
 	}
 	return error;
@@ -3304,6 +3305,10 @@ xfs_alloc_vextent_this_ag(
  * we attempt to allocation in as there is no locality optimisation possible for
  * those allocations.
  *
+ * On return, args->pag may be left referenced if we finish before the "all
+ * failed" return point. The allocation finish still needs the perag, and
+ * so the caller will release it once they've finished the allocation.
+ *
  * When we wrap the AG iteration at the end of the filesystem, we have to be
  * careful not to wrap into AGs below ones we already have locked in the
  * transaction if we are doing a blocking iteration. This will result in an
@@ -3318,72 +3323,55 @@ xfs_alloc_vextent_iterate_ags(
 	uint32_t		flags)
 {
 	struct xfs_mount	*mp = args->mp;
+	xfs_agnumber_t		agno;
 	int			error = 0;
 
-	ASSERT(start_agno >= minimum_agno);
-
-	/*
-	 * Loop over allocation groups twice; first time with
-	 * trylock set, second time without.
-	 */
-	args->agno = start_agno;
-	for (;;) {
-		args->pag = xfs_perag_get(mp, args->agno);
+restart:
+	for_each_perag_wrap_range(mp, start_agno, minimum_agno,
+			mp->m_sb.sb_agcount, agno, args->pag) {
+		args->agno = agno;
 		error = xfs_alloc_vextent_prepare_ag(args);
 		if (error)
 			break;
-
-		if (args->agbp) {
-			/*
-			 * Allocation is supposed to succeed now, so break out
-			 * of the loop regardless of whether we succeed or not.
-			 */
-			if (args->agno == start_agno && target_agbno) {
-				args->agbno = target_agbno;
-				error = xfs_alloc_ag_vextent_near(args);
-			} else {
-				args->agbno = 0;
-				error = xfs_alloc_ag_vextent_size(args);
-			}
-			break;
-		}
-
-		trace_xfs_alloc_vextent_loopfailed(args);
-
-		/*
-		 * If we are try-locking, we can't deadlock on AGF locks so we
-		 * can wrap all the way back to the first AG. Otherwise, wrap
-		 * back to the start AG so we can't deadlock and let the end of
-		 * scan handler decide what to do next.
-		 */
-		if (++(args->agno) == mp->m_sb.sb_agcount) {
-			if (flags & XFS_ALLOC_FLAG_TRYLOCK)
-				args->agno = 0;
-			else
-				args->agno = minimum_agno;
+		if (!args->agbp) {
+			trace_xfs_alloc_vextent_loopfailed(args);
+			continue;
 		}
 
 		/*
-		 * Reached the starting a.g., must either be done
-		 * or switch to non-trylock mode.
+		 * Allocation is supposed to succeed now, so break out of the
+		 * loop regardless of whether we succeed or not.
 		 */
-		if (args->agno == start_agno) {
-			if (flags == 0) {
-				args->agbno = NULLAGBLOCK;
-				trace_xfs_alloc_vextent_allfailed(args);
-				break;
-			}
+		if (args->agno == start_agno && target_agbno) {
 			args->agbno = target_agbno;
-			flags = 0;
+			error = xfs_alloc_ag_vextent_near(args);
+		} else {
+			args->agbno = 0;
+			error = xfs_alloc_ag_vextent_size(args);
 		}
-		xfs_perag_put(args->pag);
+		break;
+	}
+	if (error) {
+		xfs_perag_rele(args->pag);
 		args->pag = NULL;
+		return error;
 	}
+	if (args->agbp)
+		return 0;
+
 	/*
-	 * The perag is left referenced in args for the caller to clean
-	 * up after they've finished the allocation.
+	 * We didn't find an AG we can alloation from. If we were given
+	 * constraining flags by the caller, drop them and retry the allocation
+	 * without any constraints being set.
 	 */
-	return error;
+	if (flags) {
+		flags = 0;
+		goto restart;
+	}
+
+	ASSERT(args->pag == NULL);
+	trace_xfs_alloc_vextent_allfailed(args);
+	return 0;
 }
 
 /*
@@ -3524,7 +3512,7 @@ xfs_alloc_vextent_near_bno(
 	}
 
 	if (needs_perag)
-		args->pag = xfs_perag_get(mp, args->agno);
+		args->pag = xfs_perag_grab(mp, args->agno);
 
 	error = xfs_alloc_vextent_prepare_ag(args);
 	if (!error && args->agbp)
-- 
2.39.0

