Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95B62C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 22:18:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbjBIWSy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 17:18:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230361AbjBIWSm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 17:18:42 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 425626A71E
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 14:18:39 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id m2-20020a17090a414200b00231173c006fso7021577pjg.5
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 14:18:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DjhAD5FyHl25OKRnCPymHTbp+AuTLj1vZ8EPysp9TDE=;
        b=ugLxPUCaNRiG0ueH3/71oVtHZaGqfEupalDHN2N1dScAduwr/2ca87jReZfODfs7YJ
         4eBEOxQfFtbor6L8Zs+DaBWPOeZq7elMz2Aqz0dK641ykRG2Jqyalf1TWxFGAldM3ZdG
         5YFgKhTSSlHofoq/fWsDA+ikpuOTqe5O5n6Ih9Ehii5zjBVdj2i5IJ9X9E2CRdDTODqm
         v9XSW4PHzaJOkRsin7cfaeTn6X7+6QSzzoQcSS1GzphwhGihvzlRltPVTW7dZ6PQ4OB9
         F7YCG0VsZSLxtbejO7SdoYmpN5uQse5u2yFKGvcNyf+XxrvT1DavlgNkGjtiSFJCpqGc
         LKYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DjhAD5FyHl25OKRnCPymHTbp+AuTLj1vZ8EPysp9TDE=;
        b=rdOyJ6lN9l6jIPXmMco/wHri5iQOvPNOcU1KYSxjYP11RRZwCg8GdXDiDwoL4QwpD0
         3XhhmSZ38dRYK84dAfeLWQz2VxYTykqgzuV6RMggnxrFTl4pQmL578v3vvDQbM26+vZw
         Xv8HjoC+ymuhRD3NHTNb5uTZmPZxZmXuJI+JzmKQdiG8xDwenr9L3VM0xB/kETmf5N/x
         orfTnn9/3UfyjdF6UlW6q/IOnRFezzxxD5wShzDpflesnqy7paSBpu4zB1T3rNdYbED7
         H7vLT0Uq1ZHxz4q76PNyjCTApeOlMklNu5zIlhf7gMAvLl2yWYSlF21Qdx4qPi87Rxff
         HJOg==
X-Gm-Message-State: AO0yUKXYMlRTnEk6jm1y3JDjE2ay4pf+HH8Y1z2GP6sGbuD4aTcwbYEl
        ZOFS7pHE9xMLIhJfTHWOWIqObESEnwEYPmiF
X-Google-Smtp-Source: AK7set/5AZKQ6xSaYvhLq7H+pD3cgunTIQcqJr+FsGz2jXseLy32qDkrVLwHMG0vXbjpSg2thAzXcQ==
X-Received: by 2002:a17:902:e1c4:b0:199:2378:a6ed with SMTP id t4-20020a170902e1c400b001992378a6edmr9357233pla.67.1675981118706;
        Thu, 09 Feb 2023 14:18:38 -0800 (PST)
Received: from dread.disaster.area (pa49-181-4-128.pa.nsw.optusnet.com.au. [49.181.4.128])
        by smtp.gmail.com with ESMTPSA id h9-20020a170902680900b0019337bf957dsm1972279plk.296.2023.02.09.14.18.35
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 14:18:36 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pQFFM-00DOVG-8M
        for linux-xfs@vger.kernel.org; Fri, 10 Feb 2023 09:18:28 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pQFFM-00FcN7-0n
        for linux-xfs@vger.kernel.org;
        Fri, 10 Feb 2023 09:18:28 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 15/42] xfs: rework xfs_alloc_vextent()
Date:   Fri, 10 Feb 2023 09:17:58 +1100
Message-Id: <20230209221825.3722244-16-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209221825.3722244-1-david@fromorbit.com>
References: <20230209221825.3722244-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

It's a multiplexing mess that can be greatly simplified, and really
needs to be simplified to allow active per-ag references to
propagate from initial AG selection code the the bmapi code.

This splits the code out into separate a parameter checking
function, an iterator function, and allocation completion functions
and then implements the individual policies using these functions.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c | 496 +++++++++++++++++++++++---------------
 1 file changed, 301 insertions(+), 195 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 4508862239a8..5afda109aaef 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3151,29 +3151,20 @@ xfs_alloc_read_agf(
 }
 
 /*
- * Allocate an extent (variable-size).
- * Depending on the allocation type, we either look in a single allocation
- * group or loop over the allocation groups to find the result.
+ * Pre-proces allocation arguments to set initial state that we don't require
+ * callers to set up correctly, as well as bounds check the allocation args
+ * that are set up.
  */
-int				/* error */
-xfs_alloc_vextent(
-	struct xfs_alloc_arg	*args)	/* allocation argument structure */
+static int
+xfs_alloc_vextent_check_args(
+	struct xfs_alloc_arg	*args)
 {
-	xfs_agblock_t		agsize;	/* allocation group size */
-	int			error;
-	int			flags;	/* XFS_ALLOC_FLAG_... locking flags */
-	struct xfs_mount	*mp;	/* mount structure pointer */
-	xfs_agnumber_t		sagno;	/* starting allocation group number */
-	xfs_alloctype_t		type;	/* input allocation type */
-	int			bump_rotor = 0;
-	xfs_agnumber_t		rotorstep = xfs_rotorstep; /* inode32 agf stepper */
-	xfs_agnumber_t		minimum_agno = 0;
+	struct xfs_mount	*mp = args->mp;
+	xfs_agblock_t		agsize;
 
-	mp = args->mp;
-	type = args->otype = args->type;
+	args->otype = args->type;
 	args->agbno = NULLAGBLOCK;
-	if (args->tp->t_highest_agno != NULLAGNUMBER)
-		minimum_agno = args->tp->t_highest_agno;
+
 	/*
 	 * Just fix this up, for the case where the last a.g. is shorter
 	 * (or there's only one a.g.) and the caller couldn't easily figure
@@ -3195,199 +3186,314 @@ xfs_alloc_vextent(
 	    args->mod >= args->prod) {
 		args->fsbno = NULLFSBLOCK;
 		trace_xfs_alloc_vextent_badargs(args);
-		return 0;
-	}
-
-	switch (type) {
-	case XFS_ALLOCTYPE_THIS_AG:
-	case XFS_ALLOCTYPE_NEAR_BNO:
-	case XFS_ALLOCTYPE_THIS_BNO:
-		/*
-		 * These three force us into a single a.g.
-		 */
-		args->agno = XFS_FSB_TO_AGNO(mp, args->fsbno);
-		args->pag = xfs_perag_get(mp, args->agno);
-
-		if (minimum_agno > args->agno) {
-			trace_xfs_alloc_vextent_skip_deadlock(args);
-			error = 0;
-			break;
-		}
-
-		error = xfs_alloc_fix_freelist(args, 0);
-		if (error) {
-			trace_xfs_alloc_vextent_nofix(args);
-			goto error0;
-		}
-		if (!args->agbp) {
-			trace_xfs_alloc_vextent_noagbp(args);
-			break;
-		}
-		args->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);
-		if ((error = xfs_alloc_ag_vextent(args)))
-			goto error0;
-		break;
-	case XFS_ALLOCTYPE_START_BNO:
-		/*
-		 * Try near allocation first, then anywhere-in-ag after
-		 * the first a.g. fails.
-		 */
-		if ((args->datatype & XFS_ALLOC_INITIAL_USER_DATA) &&
-		    xfs_is_inode32(mp)) {
-			args->fsbno = XFS_AGB_TO_FSB(mp,
-					((mp->m_agfrotor / rotorstep) %
-					mp->m_sb.sb_agcount), 0);
-			bump_rotor = 1;
-		}
-		args->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);
-		args->type = XFS_ALLOCTYPE_NEAR_BNO;
-		fallthrough;
-	case XFS_ALLOCTYPE_FIRST_AG:
-		/*
-		 * Rotate through the allocation groups looking for a winner.
-		 * If we are blocking, we must obey minimum_agno contraints for
-		 * avoiding ABBA deadlocks on AGF locking.
-		 */
-		if (type == XFS_ALLOCTYPE_FIRST_AG) {
-			/*
-			 * Start with allocation group given by bno.
-			 */
-			args->agno = XFS_FSB_TO_AGNO(mp, args->fsbno);
-			args->type = XFS_ALLOCTYPE_THIS_AG;
-			sagno = minimum_agno;
-			flags = 0;
-		} else {
-			/*
-			 * Start with the given allocation group.
-			 */
-			args->agno = sagno = XFS_FSB_TO_AGNO(mp, args->fsbno);
-			flags = XFS_ALLOC_FLAG_TRYLOCK;
-		}
-
-		/*
-		 * Loop over allocation groups twice; first time with
-		 * trylock set, second time without.
-		 */
-		for (;;) {
-			args->pag = xfs_perag_get(mp, args->agno);
-			error = xfs_alloc_fix_freelist(args, flags);
-			if (error) {
-				trace_xfs_alloc_vextent_nofix(args);
-				goto error0;
-			}
-			/*
-			 * If we get a buffer back then the allocation will fly.
-			 */
-			if (args->agbp) {
-				if ((error = xfs_alloc_ag_vextent(args)))
-					goto error0;
-				break;
-			}
-
-			trace_xfs_alloc_vextent_loopfailed(args);
-
-			/*
-			 * Didn't work, figure out the next iteration.
-			 */
-			if (args->agno == sagno &&
-			    type == XFS_ALLOCTYPE_START_BNO)
-				args->type = XFS_ALLOCTYPE_THIS_AG;
-
-			/*
-			 * If we are try-locking, we can't deadlock on AGF
-			 * locks, so we can wrap all the way back to the first
-			 * AG. Otherwise, wrap back to the start AG so we can't
-			 * deadlock, and let the end of scan handler decide what
-			 * to do next.
-			 */
-			if (++(args->agno) == mp->m_sb.sb_agcount) {
-				if (flags & XFS_ALLOC_FLAG_TRYLOCK)
-					args->agno = 0;
-				else
-					args->agno = sagno;
-			}
-
-			/*
-			 * Reached the starting a.g., must either be done
-			 * or switch to non-trylock mode.
-			 */
-			if (args->agno == sagno) {
-				if (flags == 0) {
-					args->agbno = NULLAGBLOCK;
-					trace_xfs_alloc_vextent_allfailed(args);
-					break;
-				}
-
-				/*
-				 * Blocking pass next, so we must obey minimum
-				 * agno constraints to avoid ABBA AGF deadlocks.
-				 */
-				flags = 0;
-				if (minimum_agno > sagno)
-					sagno = minimum_agno;
-
-				if (type == XFS_ALLOCTYPE_START_BNO) {
-					args->agbno = XFS_FSB_TO_AGBNO(mp,
-						args->fsbno);
-					args->type = XFS_ALLOCTYPE_NEAR_BNO;
-				}
-			}
-			xfs_perag_put(args->pag);
-		}
-		if (bump_rotor) {
-			if (args->agno == sagno)
-				mp->m_agfrotor = (mp->m_agfrotor + 1) %
-					(mp->m_sb.sb_agcount * rotorstep);
-			else
-				mp->m_agfrotor = (args->agno * rotorstep + 1) %
-					(mp->m_sb.sb_agcount * rotorstep);
-		}
-		break;
-	default:
-		ASSERT(0);
-		/* NOTREACHED */
-	}
-	if (args->agbno == NULLAGBLOCK) {
-		args->fsbno = NULLFSBLOCK;
-	} else {
-		args->fsbno = XFS_AGB_TO_FSB(mp, args->agno, args->agbno);
-#ifdef DEBUG
-		ASSERT(args->len >= args->minlen);
-		ASSERT(args->len <= args->maxlen);
-		ASSERT(args->agbno % args->alignment == 0);
-		XFS_AG_CHECK_DADDR(mp, XFS_FSB_TO_DADDR(mp, args->fsbno),
-			args->len);
-#endif
-
+		return -ENOSPC;
 	}
+	return 0;
+}
+
+/*
+ * Post-process allocation results to set the allocated block number correctly
+ * for the caller.
+ *
+ * XXX: xfs_alloc_vextent() should really be returning ENOSPC for ENOSPC, not
+ * hiding it behind a "successful" NULLFSBLOCK allocation.
+ */
+static void
+xfs_alloc_vextent_set_fsbno(
+	struct xfs_alloc_arg	*args,
+	xfs_agnumber_t		minimum_agno)
+{
+	struct xfs_mount	*mp = args->mp;
 
 	/*
-	 * We end up here with a locked AGF. If we failed, the caller is likely
-	 * going to try to allocate again with different parameters, and that
-	 * can widen the AGs that are searched for free space. If we have to do
-	 * BMBT block allocation, we have to do a new allocation.
+	 * We can end up here with a locked AGF. If we failed, the caller is
+	 * likely going to try to allocate again with different parameters, and
+	 * that can widen the AGs that are searched for free space. If we have
+	 * to do BMBT block allocation, we have to do a new allocation.
 	 *
 	 * Hence leaving this function with the AGF locked opens up potential
 	 * ABBA AGF deadlocks because a future allocation attempt in this
 	 * transaction may attempt to lock a lower number AGF.
 	 *
 	 * We can't release the AGF until the transaction is commited, so at
-	 * this point we must update the "firstblock" tracker to point at this
-	 * AG if the tracker is empty or points to a lower AG. This allows the
-	 * next allocation attempt to be modified appropriately to avoid
+	 * this point we must update the "first allocation" tracker to point at
+	 * this AG if the tracker is empty or points to a lower AG. This allows
+	 * the next allocation attempt to be modified appropriately to avoid
 	 * deadlocks.
 	 */
 	if (args->agbp &&
 	    (args->tp->t_highest_agno == NULLAGNUMBER ||
-	     args->pag->pag_agno > minimum_agno))
-		args->tp->t_highest_agno = args->pag->pag_agno;
-	xfs_perag_put(args->pag);
-	return 0;
-error0:
+	     args->agno > minimum_agno))
+		args->tp->t_highest_agno = args->agno;
+
+	/* Allocation failed with ENOSPC if NULLAGBLOCK was returned. */
+	if (args->agbno == NULLAGBLOCK) {
+		args->fsbno = NULLFSBLOCK;
+		return;
+	}
+
+	args->fsbno = XFS_AGB_TO_FSB(mp, args->agno, args->agbno);
+#ifdef DEBUG
+	ASSERT(args->len >= args->minlen);
+	ASSERT(args->len <= args->maxlen);
+	ASSERT(args->agbno % args->alignment == 0);
+	XFS_AG_CHECK_DADDR(mp, XFS_FSB_TO_DADDR(mp, args->fsbno), args->len);
+#endif
+}
+
+/*
+ * Allocate within a single AG only.
+ */
+static int
+xfs_alloc_vextent_this_ag(
+	struct xfs_alloc_arg	*args,
+	xfs_agnumber_t		minimum_agno)
+{
+	struct xfs_mount	*mp = args->mp;
+	int			error;
+
+	error = xfs_alloc_vextent_check_args(args);
+	if (error) {
+		if (error == -ENOSPC)
+			return 0;
+		return error;
+	}
+
+	args->agno = XFS_FSB_TO_AGNO(mp, args->fsbno);
+	if (minimum_agno > args->agno) {
+		trace_xfs_alloc_vextent_skip_deadlock(args);
+		args->fsbno = NULLFSBLOCK;
+		return 0;
+	}
+
+	args->pag = xfs_perag_get(mp, args->agno);
+	error = xfs_alloc_fix_freelist(args, 0);
+	if (error) {
+		trace_xfs_alloc_vextent_nofix(args);
+		goto out_error;
+	}
+	if (!args->agbp) {
+		trace_xfs_alloc_vextent_noagbp(args);
+		args->fsbno = NULLFSBLOCK;
+		goto out_error;
+	}
+	args->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);
+	error = xfs_alloc_ag_vextent(args);
+
+	xfs_alloc_vextent_set_fsbno(args, minimum_agno);
+out_error:
 	xfs_perag_put(args->pag);
 	return error;
 }
 
+/*
+ * Iterate all AGs trying to allocate an extent starting from @start_ag.
+ *
+ * If the incoming allocation type is XFS_ALLOCTYPE_NEAR_BNO, it means the
+ * allocation attempts in @start_agno have locality information. If we fail to
+ * allocate in that AG, then we revert to anywhere-in-AG for all the other AGs
+ * we attempt to allocation in as there is no locality optimisation possible for
+ * those allocations.
+ *
+ * When we wrap the AG iteration at the end of the filesystem, we have to be
+ * careful not to wrap into AGs below ones we already have locked in the
+ * transaction if we are doing a blocking iteration. This will result in an
+ * out-of-order locking of AGFs and hence can cause deadlocks.
+ */
+static int
+xfs_alloc_vextent_iterate_ags(
+	struct xfs_alloc_arg	*args,
+	xfs_agnumber_t		minimum_agno,
+	xfs_agnumber_t		start_agno,
+	uint32_t		flags)
+{
+	struct xfs_mount	*mp = args->mp;
+	int			error = 0;
+
+	ASSERT(start_agno >= minimum_agno);
+
+	/*
+	 * Loop over allocation groups twice; first time with
+	 * trylock set, second time without.
+	 */
+	args->agno = start_agno;
+	for (;;) {
+		args->pag = xfs_perag_get(mp, args->agno);
+		error = xfs_alloc_fix_freelist(args, flags);
+		if (error) {
+			trace_xfs_alloc_vextent_nofix(args);
+			break;
+		}
+		/*
+		 * If we get a buffer back then the allocation will fly.
+		 */
+		if (args->agbp) {
+			error = xfs_alloc_ag_vextent(args);
+			break;
+		}
+
+		trace_xfs_alloc_vextent_loopfailed(args);
+
+		/*
+		 * Didn't work, figure out the next iteration.
+		 */
+		if (args->agno == start_agno &&
+		    args->otype == XFS_ALLOCTYPE_START_BNO)
+			args->type = XFS_ALLOCTYPE_THIS_AG;
+
+		/*
+		 * If we are try-locking, we can't deadlock on AGF locks so we
+		 * can wrap all the way back to the first AG. Otherwise, wrap
+		 * back to the start AG so we can't deadlock and let the end of
+		 * scan handler decide what to do next.
+		 */
+		if (++(args->agno) == mp->m_sb.sb_agcount) {
+			if (flags & XFS_ALLOC_FLAG_TRYLOCK)
+				args->agno = 0;
+			else
+				args->agno = minimum_agno;
+		}
+
+		/*
+		 * Reached the starting a.g., must either be done
+		 * or switch to non-trylock mode.
+		 */
+		if (args->agno == start_agno) {
+			if (flags == 0) {
+				args->agbno = NULLAGBLOCK;
+				trace_xfs_alloc_vextent_allfailed(args);
+				break;
+			}
+
+			flags = 0;
+			if (args->otype == XFS_ALLOCTYPE_START_BNO) {
+				args->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);
+				args->type = XFS_ALLOCTYPE_NEAR_BNO;
+			}
+		}
+		xfs_perag_put(args->pag);
+		args->pag = NULL;
+	}
+	if (args->pag) {
+		xfs_perag_put(args->pag);
+		args->pag = NULL;
+	}
+	return error;
+}
+
+/*
+ * Iterate from the AGs from the start AG to the end of the filesystem, trying
+ * to allocate blocks. It starts with a near allocation attempt in the initial
+ * AG, then falls back to anywhere-in-ag after the first AG fails. It will wrap
+ * back to zero if allowed by previous allocations in this transaction,
+ * otherwise will wrap back to the start AG and run a second blocking pass to
+ * the end of the filesystem.
+ */
+static int
+xfs_alloc_vextent_start_ag(
+	struct xfs_alloc_arg	*args,
+	xfs_agnumber_t		minimum_agno)
+{
+	struct xfs_mount	*mp = args->mp;
+	xfs_agnumber_t		start_agno;
+	xfs_agnumber_t		rotorstep = xfs_rotorstep;
+	bool			bump_rotor = false;
+	int			error;
+
+	error = xfs_alloc_vextent_check_args(args);
+	if (error) {
+		if (error == -ENOSPC)
+			return 0;
+		return error;
+	}
+
+	if ((args->datatype & XFS_ALLOC_INITIAL_USER_DATA) &&
+	    xfs_is_inode32(mp)) {
+		args->fsbno = XFS_AGB_TO_FSB(mp,
+				((mp->m_agfrotor / rotorstep) %
+				mp->m_sb.sb_agcount), 0);
+		bump_rotor = 1;
+	}
+	start_agno = max(minimum_agno, XFS_FSB_TO_AGNO(mp, args->fsbno));
+	args->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);
+	args->type = XFS_ALLOCTYPE_NEAR_BNO;
+
+	error = xfs_alloc_vextent_iterate_ags(args, minimum_agno, start_agno,
+			XFS_ALLOC_FLAG_TRYLOCK);
+	if (bump_rotor) {
+		if (args->agno == start_agno)
+			mp->m_agfrotor = (mp->m_agfrotor + 1) %
+				(mp->m_sb.sb_agcount * rotorstep);
+		else
+			mp->m_agfrotor = (args->agno * rotorstep + 1) %
+				(mp->m_sb.sb_agcount * rotorstep);
+	}
+
+	xfs_alloc_vextent_set_fsbno(args, minimum_agno);
+	return error;
+}
+
+/*
+ * Iterate from the agno indicated from args->fsbno through to the end of the
+ * filesystem attempting blocking allocation. This does not wrap or try a second
+ * pass, so will not recurse into AGs lower than indicated by fsbno.
+ */
+static int
+xfs_alloc_vextent_first_ag(
+	struct xfs_alloc_arg	*args,
+	xfs_agnumber_t		minimum_agno)
+{
+	struct xfs_mount	*mp = args->mp;
+	xfs_agnumber_t		start_agno;
+	int			error;
+
+	error = xfs_alloc_vextent_check_args(args);
+	if (error) {
+		if (error == -ENOSPC)
+			return 0;
+		return error;
+	}
+
+	start_agno = max(minimum_agno, XFS_FSB_TO_AGNO(mp, args->fsbno));
+
+	args->type = XFS_ALLOCTYPE_THIS_AG;
+	error =  xfs_alloc_vextent_iterate_ags(args, minimum_agno,
+			start_agno, 0);
+	xfs_alloc_vextent_set_fsbno(args, minimum_agno);
+	return error;
+}
+
+/*
+ * Allocate an extent (variable-size).
+ * Depending on the allocation type, we either look in a single allocation
+ * group or loop over the allocation groups to find the result.
+ */
+int
+xfs_alloc_vextent(
+	struct xfs_alloc_arg	*args)
+{
+	xfs_agnumber_t		minimum_agno = 0;
+
+	if (args->tp->t_highest_agno != NULLAGNUMBER)
+		minimum_agno = args->tp->t_highest_agno;
+
+	switch (args->type) {
+	case XFS_ALLOCTYPE_THIS_AG:
+	case XFS_ALLOCTYPE_NEAR_BNO:
+	case XFS_ALLOCTYPE_THIS_BNO:
+		return xfs_alloc_vextent_this_ag(args, minimum_agno);
+	case XFS_ALLOCTYPE_START_BNO:
+		return xfs_alloc_vextent_start_ag(args, minimum_agno);
+	case XFS_ALLOCTYPE_FIRST_AG:
+		return xfs_alloc_vextent_first_ag(args, minimum_agno);
+	default:
+		ASSERT(0);
+		/* NOTREACHED */
+	}
+	/* Should never get here */
+	return -EFSCORRUPTED;
+}
+
 /* Ensure that the freelist is at full capacity. */
 int
 xfs_free_extent_fix_freelist(
-- 
2.39.0

