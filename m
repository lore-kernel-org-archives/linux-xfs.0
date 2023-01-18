Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15BBFC38159
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 22:45:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbjARWpT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 17:45:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjARWpP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 17:45:15 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD0860499
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:45:14 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id jl3so556128plb.8
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:45:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=15e2UAXWr7DjHXYNVfG1pIY5WBwP+AvEXcPNz5p9Ow0=;
        b=avqMkrS3V2WWjLtFt0FN1ORGTdaQ4/9349AypXLxB8hNgImQkqPZqtcpTyszBHec9m
         h/ItLginCiMQxMh3rX6/7rlTOsrspMLJyM1j37V+g/dkU5JmKv5wm4I5+uKTQ9hRuSGb
         gIFVqzRj0bSFH4VHNbvhY08dpoMnV+BhT24336bIZoyFQYt8BtaqHSpFfx8lZr252ixe
         EYHotMimDmaUelK20yYxxa6slMA4vLy0iG0XiCgeQ0bVjapv2jsmLhltavikE2s8ZVZV
         PBP+yQnofCZ9ntDDpprM7LdNeMQmInRan0jFYVNW6EvQQdiY3eT4dxyxsMKJX52pHivb
         7bbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=15e2UAXWr7DjHXYNVfG1pIY5WBwP+AvEXcPNz5p9Ow0=;
        b=275eh01fCLXfpbToFPhv+4+JJ63sKTATIH7GUBxQbpJDYIB4ePbgVc2JWpdygEsZZP
         6XcxTzWt4pklpdAHirUCSfE+e9RS08RH2BG4yk/WAd9BUxuIOjLYDAFrgeu8UH2Co79E
         44dQjmMMB9Cdtgd5z91Liwn5q5t3fqGwY3XqNA5I4pyo+A4IcpwSt7dzh56q+bHT9PT3
         vAFGHyRw0yEt+q1nofDAA2Qm5w2wEz+pQYinNPt1YbxdNm0zpVV11e28Fk7eGipQ6vwR
         dO3d5UKz1edFal8pcjvsR4vfvETfjDRs4TsIludPql2q+itqh3vDk3k6vHjJX7YKZOrL
         gevg==
X-Gm-Message-State: AFqh2koilqJ0ldvk/7hi/apUcnkgDML4IIW4zW/610UgajY66fYM8mJ+
        E64dscBK+kUnV9n4HSgbJqUf9o1somUaePX2
X-Google-Smtp-Source: AMrXdXuYOSvZZRtRCe99QltoJlzKEfF2Wd0ZCKtQm5APw/Bfft3TEGvFWsV8UkFstDkKFq/v15Uozg==
X-Received: by 2002:a17:902:d697:b0:194:abe9:bc83 with SMTP id v23-20020a170902d69700b00194abe9bc83mr8463038ply.61.1674081914025;
        Wed, 18 Jan 2023 14:45:14 -0800 (PST)
Received: from dread.disaster.area (pa49-186-146-207.pa.vic.optusnet.com.au. [49.186.146.207])
        by smtp.gmail.com with ESMTPSA id q18-20020a170902bd9200b00186b7443082sm23652909pls.195.2023.01.18.14.45.13
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 14:45:13 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pIHB8-004iWd-Qm
        for linux-xfs@vger.kernel.org; Thu, 19 Jan 2023 09:45:10 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pIHB8-008FCb-2h
        for linux-xfs@vger.kernel.org;
        Thu, 19 Jan 2023 09:45:10 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 01/42] xfs: fix low space alloc deadlock
Date:   Thu, 19 Jan 2023 09:44:24 +1100
Message-Id: <20230118224505.1964941-2-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118224505.1964941-1-david@fromorbit.com>
References: <20230118224505.1964941-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

I've recently encountered an ABBA deadlock with g/476. The upcoming
changes seem to make this much easier to hit, but the underlying
problem is a pre-existing one.

Essentially, if we select an AG for allocation, then lock the AGF
and then fail to allocate for some reason (e.g. minimum length
requirements cannot be satisfied), then we drop out of the
allocation with the AGF still locked.

The caller then modifies the allocation constraints - usually
loosening them up - and tries again. This can result in trying to
access AGFs that are lower than the AGF we already have locked from
the failed attempt. e.g. the failed attempt skipped several AGs
before failing, so we have locks an AG higher than the start AG.
Retrying the allocation from the start AG then causes us to violate
AGF lock ordering and this can lead to deadlocks.

The deadlock exists even if allocation succeeds - we can do a
followup allocations in the same transaction for BMBT blocks that
aren't guaranteed to be in the same AG as the original, and can move
into higher AGs. Hence we really need to move the tp->t_firstblock
tracking down into xfs_alloc_vextent() where it can be set when we
exit with a locked AG.

xfs_alloc_vextent() can also check there if the requested
allocation falls within the allow range of AGs set by
tp->t_firstblock. If we can't allocate within the range set, we have
to fail the allocation. If we are allowed to to non-blocking AGF
locking, we can ignore the AG locking order limitations as we can
use try-locks for the first iteration over requested AG range.

This invalidates a set of post allocation asserts that check that
the allocation is always above tp->t_firstblock if it is set.
Because we can use try-locks to avoid the deadlock in some
circumstances, having a pre-existing locked AGF doesn't always
prevent allocation from lower order AGFs. Hence those ASSERTs need
to be removed.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 69 ++++++++++++++++++++++++++++++++-------
 fs/xfs/libxfs/xfs_bmap.c  | 14 --------
 fs/xfs/xfs_trace.h        |  1 +
 3 files changed, 58 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 989cf341779b..c2f38f595d7f 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3164,10 +3164,13 @@ xfs_alloc_vextent(
 	xfs_alloctype_t		type;	/* input allocation type */
 	int			bump_rotor = 0;
 	xfs_agnumber_t		rotorstep = xfs_rotorstep; /* inode32 agf stepper */
+	xfs_agnumber_t		minimum_agno = 0;
 
 	mp = args->mp;
 	type = args->otype = args->type;
 	args->agbno = NULLAGBLOCK;
+	if (args->tp->t_firstblock != NULLFSBLOCK)
+		minimum_agno = XFS_FSB_TO_AGNO(mp, args->tp->t_firstblock);
 	/*
 	 * Just fix this up, for the case where the last a.g. is shorter
 	 * (or there's only one a.g.) and the caller couldn't easily figure
@@ -3201,6 +3204,13 @@ xfs_alloc_vextent(
 		 */
 		args->agno = XFS_FSB_TO_AGNO(mp, args->fsbno);
 		args->pag = xfs_perag_get(mp, args->agno);
+
+		if (minimum_agno > args->agno) {
+			trace_xfs_alloc_vextent_skip_deadlock(args);
+			error = 0;
+			break;
+		}
+
 		error = xfs_alloc_fix_freelist(args, 0);
 		if (error) {
 			trace_xfs_alloc_vextent_nofix(args);
@@ -3232,6 +3242,8 @@ xfs_alloc_vextent(
 	case XFS_ALLOCTYPE_FIRST_AG:
 		/*
 		 * Rotate through the allocation groups looking for a winner.
+		 * If we are blocking, we must obey minimum_agno contraints for
+		 * avoiding ABBA deadlocks on AGF locking.
 		 */
 		if (type == XFS_ALLOCTYPE_FIRST_AG) {
 			/*
@@ -3239,7 +3251,7 @@ xfs_alloc_vextent(
 			 */
 			args->agno = XFS_FSB_TO_AGNO(mp, args->fsbno);
 			args->type = XFS_ALLOCTYPE_THIS_AG;
-			sagno = 0;
+			sagno = minimum_agno;
 			flags = 0;
 		} else {
 			/*
@@ -3248,6 +3260,7 @@ xfs_alloc_vextent(
 			args->agno = sagno = XFS_FSB_TO_AGNO(mp, args->fsbno);
 			flags = XFS_ALLOC_FLAG_TRYLOCK;
 		}
+
 		/*
 		 * Loop over allocation groups twice; first time with
 		 * trylock set, second time without.
@@ -3276,19 +3289,21 @@ xfs_alloc_vextent(
 			if (args->agno == sagno &&
 			    type == XFS_ALLOCTYPE_START_BNO)
 				args->type = XFS_ALLOCTYPE_THIS_AG;
+
 			/*
-			* For the first allocation, we can try any AG to get
-			* space.  However, if we already have allocated a
-			* block, we don't want to try AGs whose number is below
-			* sagno. Otherwise, we may end up with out-of-order
-			* locking of AGF, which might cause deadlock.
-			*/
+			 * If we are try-locking, we can't deadlock on AGF
+			 * locks, so we can wrap all the way back to the first
+			 * AG. Otherwise, wrap back to the start AG so we can't
+			 * deadlock, and let the end of scan handler decide what
+			 * to do next.
+			 */
 			if (++(args->agno) == mp->m_sb.sb_agcount) {
-				if (args->tp->t_firstblock != NULLFSBLOCK)
-					args->agno = sagno;
-				else
+				if (flags & XFS_ALLOC_FLAG_TRYLOCK)
 					args->agno = 0;
+				else
+					args->agno = sagno;
 			}
+
 			/*
 			 * Reached the starting a.g., must either be done
 			 * or switch to non-trylock mode.
@@ -3300,7 +3315,14 @@ xfs_alloc_vextent(
 					break;
 				}
 
+				/*
+				 * Blocking pass next, so we must obey minimum
+				 * agno constraints to avoid ABBA AGF deadlocks.
+				 */
 				flags = 0;
+				if (minimum_agno > sagno)
+					sagno = minimum_agno;
+
 				if (type == XFS_ALLOCTYPE_START_BNO) {
 					args->agbno = XFS_FSB_TO_AGBNO(mp,
 						args->fsbno);
@@ -3322,9 +3344,9 @@ xfs_alloc_vextent(
 		ASSERT(0);
 		/* NOTREACHED */
 	}
-	if (args->agbno == NULLAGBLOCK)
+	if (args->agbno == NULLAGBLOCK) {
 		args->fsbno = NULLFSBLOCK;
-	else {
+	} else {
 		args->fsbno = XFS_AGB_TO_FSB(mp, args->agno, args->agbno);
 #ifdef DEBUG
 		ASSERT(args->len >= args->minlen);
@@ -3335,6 +3357,29 @@ xfs_alloc_vextent(
 #endif
 
 	}
+
+	/*
+	 * We end up here with a locked AGF. If we failed, the caller is likely
+	 * going to try to allocate again with different parameters, and that
+	 * can widen the AGs that are searched for free space. If we have to do
+	 * BMBT block allocation, we have to do a new allocation.
+	 *
+	 * Hence leaving this function with the AGF locked opens up potential
+	 * ABBA AGF deadlocks because a future allocation attempt in this
+	 * transaction may attempt to lock a lower number AGF.
+	 *
+	 * We can't release the AGF until the transaction is commited, so at
+	 * this point we must update the "firstblock" tracker to point at this
+	 * AG if the tracker is empty or points to a lower AG. This allows the
+	 * next allocation attempt to be modified appropriately to avoid
+	 * deadlocks.
+	 */
+	if (args->agbp &&
+	    (args->tp->t_firstblock == NULLFSBLOCK ||
+	     args->pag->pag_agno > minimum_agno)) {
+		args->tp->t_firstblock = XFS_AGB_TO_FSB(mp,
+					args->pag->pag_agno, 0);
+	}
 	xfs_perag_put(args->pag);
 	return 0;
 error0:
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 0d56a8d862e8..018837bd72c8 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3413,21 +3413,7 @@ xfs_bmap_process_allocated_extent(
 	xfs_fileoff_t		orig_offset,
 	xfs_extlen_t		orig_length)
 {
-	int			nullfb;
-
-	nullfb = ap->tp->t_firstblock == NULLFSBLOCK;
-
-	/*
-	 * check the allocation happened at the same or higher AG than
-	 * the first block that was allocated.
-	 */
-	ASSERT(nullfb ||
-		XFS_FSB_TO_AGNO(args->mp, ap->tp->t_firstblock) <=
-		XFS_FSB_TO_AGNO(args->mp, args->fsbno));
-
 	ap->blkno = args->fsbno;
-	if (nullfb)
-		ap->tp->t_firstblock = args->fsbno;
 	ap->length = args->len;
 	/*
 	 * If the extent size hint is active, we tried to round the
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 421d1e504ac4..918e778fdd55 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1877,6 +1877,7 @@ DEFINE_ALLOC_EVENT(xfs_alloc_small_notenough);
 DEFINE_ALLOC_EVENT(xfs_alloc_small_done);
 DEFINE_ALLOC_EVENT(xfs_alloc_small_error);
 DEFINE_ALLOC_EVENT(xfs_alloc_vextent_badargs);
+DEFINE_ALLOC_EVENT(xfs_alloc_vextent_skip_deadlock);
 DEFINE_ALLOC_EVENT(xfs_alloc_vextent_nofix);
 DEFINE_ALLOC_EVENT(xfs_alloc_vextent_noagbp);
 DEFINE_ALLOC_EVENT(xfs_alloc_vextent_loopfailed);
-- 
2.39.0

