Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B7F9C38159
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 22:48:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbjARWsO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 17:48:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbjARWr7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 17:47:59 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F393654F8
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:47:46 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id u1-20020a17090a450100b0022936a63a21so4004403pjg.4
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:47:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=15eOzrsB+JxkdRA4BtFu4xZcL002FZiyOkGx7qF3I7M=;
        b=Ndo14pvY02JXIyrECFLQkPLFLrNvlopfHzz4Ma6gOqjaIOQiN/MqozW2Y7VR4bWtfv
         g3xePZZqawfmyAXInKI6G2QemBCqAfcMF9TZFcbaUSXXbUG6Wt/aqUqHqmRvQE2j0Ruv
         E1RFnhJzkOJO+UYRn+iiQXMqskB1/B4mrA3ml5/l1Zc0CwKHZ3r0kqkNsf055bfvLOy1
         tIzbywcB0cX2H82qwn3aG3LTHQuRfhbH83nTBgTjVpw2zBGeg56zez32tKTTz2moBvNE
         zU0HATYg88LgFkx37XDavcPK4ZDlYtd0Kg6/trSrMlWgYeYXJ2zszbasty5fAUEbhodb
         UufQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=15eOzrsB+JxkdRA4BtFu4xZcL002FZiyOkGx7qF3I7M=;
        b=WNzTa8T3UyYpX7BZdZHYg7kEGn6J9IqITz+MHpcrEi0CTnbWlDJjPxs+k//1f9Mw7r
         Z7LKCsO9HHscfJlyHmRZvCdCNGhddmhDfT6bqk8EXUVDDlhFrSWBH8DFmXWPurTG91Vj
         4JfBaQmS+R5iVaAuu+5l2zoAqgrAbqivlh9StryWjrPaT6xRoSmw8gQXlAe3RuLpOCmY
         Ta1LssS7Y48OlLQOIQcgNDeO4cT49eHNuAE0WA6nYxU9cb52gSKjoFciTNYST5IkAUvB
         KkKcQ9tijz/Bm7VLMhZmxkf30Qg75buMl4UovUakDKcYpFjhhSFS1kfIpKThcDDrBWjL
         HkyA==
X-Gm-Message-State: AFqh2koLaZrP0+BqOlB8/1gqtpuop+SdYjUqcGRqNHg9GOVWyI9S6ZgA
        id+kMRtgzbcni1mWnR5Pby82IzDYbOcc91Ab
X-Google-Smtp-Source: AMrXdXtLDydnr1b757d9OGm+02rS5YEvHhhTu1HTt07MEsvfoCmTWab6qqJfwm4bFzcmrOV0BFq2Ow==
X-Received: by 2002:a05:6a20:a698:b0:a9:f163:3ecf with SMTP id ba24-20020a056a20a69800b000a9f1633ecfmr10483817pzb.50.1674082065826;
        Wed, 18 Jan 2023 14:47:45 -0800 (PST)
Received: from dread.disaster.area (pa49-186-146-207.pa.vic.optusnet.com.au. [49.186.146.207])
        by smtp.gmail.com with ESMTPSA id 129-20020a630887000000b004777c56747csm19181116pgi.11.2023.01.18.14.47.45
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 14:47:45 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pIHB9-004iXw-J2
        for linux-xfs@vger.kernel.org; Thu, 19 Jan 2023 09:45:11 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pIHB9-008FEl-1u
        for linux-xfs@vger.kernel.org;
        Thu, 19 Jan 2023 09:45:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 28/42] xfs: convert xfs_alloc_vextent_iterate_ags() to use perag walker
Date:   Thu, 19 Jan 2023 09:44:51 +1100
Message-Id: <20230118224505.1964941-29-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118224505.1964941-1-david@fromorbit.com>
References: <20230118224505.1964941-1-david@fromorbit.com>
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
 fs/xfs/libxfs/xfs_alloc.c | 98 ++++++++++++++++++---------------------
 2 files changed, 60 insertions(+), 60 deletions(-)

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
index 43a054002da3..39f3e76efcab 100644
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
@@ -3318,72 +3323,59 @@ xfs_alloc_vextent_iterate_ags(
 	uint32_t		flags)
 {
 	struct xfs_mount	*mp = args->mp;
+	xfs_agnumber_t		agno;
 	int			error = 0;
 
-	ASSERT(start_agno >= minimum_agno);
+restart:
+	for_each_perag_wrap_range(mp, start_agno, minimum_agno,
+			mp->m_sb.sb_agcount, agno, args->pag) {
+		args->agno = agno;
+		trace_printk("sag %u minag %u agno %u pag %u, agbno %u, agcnt %u",
+			start_agno, minimum_agno, agno, args->pag->pag_agno,
+			target_agbno, mp->m_sb.sb_agcount);
 
-	/*
-	 * Loop over allocation groups twice; first time with
-	 * trylock set, second time without.
-	 */
-	args->agno = start_agno;
-	for (;;) {
-		args->pag = xfs_perag_get(mp, args->agno);
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
+		if (!args->agbp) {
+			trace_xfs_alloc_vextent_loopfailed(args);
+			continue;
 		}
 
-		trace_xfs_alloc_vextent_loopfailed(args);
-
 		/*
-		 * If we are try-locking, we can't deadlock on AGF locks so we
-		 * can wrap all the way back to the first AG. Otherwise, wrap
-		 * back to the start AG so we can't deadlock and let the end of
-		 * scan handler decide what to do next.
+		 * Allocation is supposed to succeed now, so break out of the
+		 * loop regardless of whether we succeed or not.
 		 */
-		if (++(args->agno) == mp->m_sb.sb_agcount) {
-			if (flags & XFS_ALLOC_FLAG_TRYLOCK)
-				args->agno = 0;
-			else
-				args->agno = minimum_agno;
-		}
-
-		/*
-		 * Reached the starting a.g., must either be done
-		 * or switch to non-trylock mode.
-		 */
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
@@ -3524,7 +3516,7 @@ xfs_alloc_vextent_near_bno(
 	}
 
 	if (needs_perag)
-		args->pag = xfs_perag_get(mp, args->agno);
+		args->pag = xfs_perag_grab(mp, args->agno);
 
 	error = xfs_alloc_vextent_prepare_ag(args);
 	if (!error && args->agbp)
-- 
2.39.0

