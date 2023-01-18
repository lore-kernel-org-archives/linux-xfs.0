Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1250EC32793
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 22:45:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbjARWp0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 17:45:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbjARWpQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 17:45:16 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A571563E1F
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:45:14 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id o7-20020a17090a0a0700b00226c9b82c3aso53519pjo.3
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:45:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D7o6UfQsnAtjBR7SeLr9Zc4Msd8I2/kH0fTTZKIXwXk=;
        b=ACXupMryS9oGvMV0ZBUUaL3q9scZbg1gCoTZWpU0XlumN+68WA0uTqLpy8ej9YzjBA
         5uanLM9YUL02WttclxhryVKvFncevcxxdIRxj86gSrLROvgYnGLXFCVdtfE8PwYBJKYW
         vIR9rUh1Hzssg4K6y0KrKyUJGQS0NI5cgCuVoPhB8HrvZ63OBk6zLY0v16eQI0GlW5lB
         6Ke14f7eSc1ML5hUHDjQ+6g2kTFw1cfAwxb/mY8MujfVCGd7ruYioYuTY3cwo2/kpU7M
         veXxg05Ci6uDhW3cR2dgLJHTqXHrLvFLuVmbm/dRZrcQtDMdHxMuCCAuXRknUV88HRoE
         AM9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D7o6UfQsnAtjBR7SeLr9Zc4Msd8I2/kH0fTTZKIXwXk=;
        b=AuPbGAjOj9VhBT4dYiibMuJM79r9rJ6e+lPb+oVCrNLIWK/mEjx9RyF+/o7FKa6FUj
         AyhQcfpjWCjvdKtVOk40XtqC8uMiLGvWYMUtH0FYb5zMXbUZ5MidfdGSSfRrveTC0uZM
         /VLVbyqlq7CiiC1sCR3/h288fPmk/3tzkbEKTOLw36lXIOYbroR413AYn5bUlrbqcA81
         6BqWF0J+OH5jNOGFMJtz4kDGOA93fv0xfW0n9OHZRzY3Cy57Q13W6om7/iXoWVsbSFoJ
         v0KkRlsMydLkzjilNA6hLzgx/U8RxUXOMH8ZKwBQDU6/PITwRXdIGnNJXfwq+9GcI0oR
         Mu1g==
X-Gm-Message-State: AFqh2koCEYFi36LHvAIKLrbwnN719i6WaqaJoFQJh5LSji3PRj32v1yp
        Tma49h5bSqFKK0rcrEF6ZlGKY8dQYmwdqQR4
X-Google-Smtp-Source: AMrXdXuawooRGBzLGwOhu3Wn2Okt/t530dstG3368a/DtBtRcJa3Tc+Az9KNIywHAYO8B7cR+iZoAw==
X-Received: by 2002:a17:902:e04b:b0:194:beaf:f652 with SMTP id x11-20020a170902e04b00b00194beaff652mr2916184plx.20.1674081914250;
        Wed, 18 Jan 2023 14:45:14 -0800 (PST)
Received: from dread.disaster.area (pa49-186-146-207.pa.vic.optusnet.com.au. [49.186.146.207])
        by smtp.gmail.com with ESMTPSA id l17-20020a170903245100b001890cbd1ff1sm23727811pls.149.2023.01.18.14.45.13
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 14:45:14 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pIHB9-004iXK-76
        for linux-xfs@vger.kernel.org; Thu, 19 Jan 2023 09:45:11 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pIHB9-008FDi-0i
        for linux-xfs@vger.kernel.org;
        Thu, 19 Jan 2023 09:45:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 15/42] xfs: rework xfs_alloc_vextent()
Date:   Thu, 19 Jan 2023 09:44:38 +1100
Message-Id: <20230118224505.1964941-16-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118224505.1964941-1-david@fromorbit.com>
References: <20230118224505.1964941-1-david@fromorbit.com>
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
---
 fs/xfs/libxfs/xfs_alloc.c | 464 +++++++++++++++++++++++---------------
 1 file changed, 285 insertions(+), 179 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 246c2e7d9e7a..39e34a1bfa31 100644
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
+		return -ENOSPC;
+	}
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
+
+	/*
+	 * We can end up here with a locked AGF. If we failed, the caller is
+	 * likely going to try to allocate again with different parameters, and
+	 * that can widen the AGs that are searched for free space. If we have
+	 * to do BMBT block allocation, we have to do a new allocation.
+	 *
+	 * Hence leaving this function with the AGF locked opens up potential
+	 * ABBA AGF deadlocks because a future allocation attempt in this
+	 * transaction may attempt to lock a lower number AGF.
+	 *
+	 * We can't release the AGF until the transaction is commited, so at
+	 * this point we must update the "first allocation" tracker to point at
+	 * this AG if the tracker is empty or points to a lower AG. This allows
+	 * the next allocation attempt to be modified appropriately to avoid
+	 * deadlocks.
+	 */
+	if (args->agbp &&
+	    (args->tp->t_highest_agno == NULLAGNUMBER ||
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
 		return 0;
 	}
 
-	switch (type) {
-	case XFS_ALLOCTYPE_THIS_AG:
-	case XFS_ALLOCTYPE_NEAR_BNO:
-	case XFS_ALLOCTYPE_THIS_BNO:
-		/*
-		 * These three force us into a single a.g.
-		 */
-		args->agno = XFS_FSB_TO_AGNO(mp, args->fsbno);
-		args->pag = xfs_perag_get(mp, args->agno);
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
 
-		if (minimum_agno > args->agno) {
-			trace_xfs_alloc_vextent_skip_deadlock(args);
-			error = 0;
-			break;
-		}
+	xfs_alloc_vextent_set_fsbno(args, minimum_agno);
+out_error:
+	xfs_perag_put(args->pag);
+	return error;
+}
+
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
 
-		error = xfs_alloc_fix_freelist(args, 0);
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
 		if (error) {
 			trace_xfs_alloc_vextent_nofix(args);
-			goto error0;
-		}
-		if (!args->agbp) {
-			trace_xfs_alloc_vextent_noagbp(args);
 			break;
 		}
-		args->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);
-		if ((error = xfs_alloc_ag_vextent(args)))
-			goto error0;
-		break;
-	case XFS_ALLOCTYPE_START_BNO:
 		/*
-		 * Try near allocation first, then anywhere-in-ag after
-		 * the first a.g. fails.
+		 * If we get a buffer back then the allocation will fly.
 		 */
-		if ((args->datatype & XFS_ALLOC_INITIAL_USER_DATA) &&
-		    xfs_is_inode32(mp)) {
-			args->fsbno = XFS_AGB_TO_FSB(mp,
-					((mp->m_agfrotor / rotorstep) %
-					mp->m_sb.sb_agcount), 0);
-			bump_rotor = 1;
+		if (args->agbp) {
+			error = xfs_alloc_ag_vextent(args);
+			break;
 		}
-		args->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);
-		args->type = XFS_ALLOCTYPE_NEAR_BNO;
-		fallthrough;
-	case XFS_ALLOCTYPE_FIRST_AG:
+
+		trace_xfs_alloc_vextent_loopfailed(args);
+
 		/*
-		 * Rotate through the allocation groups looking for a winner.
-		 * If we are blocking, we must obey minimum_agno contraints for
-		 * avoiding ABBA deadlocks on AGF locking.
+		 * Didn't work, figure out the next iteration.
 		 */
-		if (type == XFS_ALLOCTYPE_FIRST_AG) {
-			/*
-			 * Start with allocation group given by bno.
-			 */
-			args->agno = XFS_FSB_TO_AGNO(mp, args->fsbno);
+		if (args->agno == start_agno &&
+		    args->otype == XFS_ALLOCTYPE_START_BNO)
 			args->type = XFS_ALLOCTYPE_THIS_AG;
-			sagno = minimum_agno;
-			flags = 0;
-		} else {
-			/*
-			 * Start with the given allocation group.
-			 */
-			args->agno = sagno = XFS_FSB_TO_AGNO(mp, args->fsbno);
-			flags = XFS_ALLOC_FLAG_TRYLOCK;
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
 		}
 
 		/*
-		 * Loop over allocation groups twice; first time with
-		 * trylock set, second time without.
+		 * Reached the starting a.g., must either be done
+		 * or switch to non-trylock mode.
 		 */
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
+		if (args->agno == start_agno) {
+			if (flags == 0) {
+				args->agbno = NULLAGBLOCK;
+				trace_xfs_alloc_vextent_allfailed(args);
 				break;
 			}
 
-			trace_xfs_alloc_vextent_loopfailed(args);
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
 
-			/*
-			 * Didn't work, figure out the next iteration.
-			 */
-			if (args->agno == sagno &&
-			    type == XFS_ALLOCTYPE_START_BNO)
-				args->type = XFS_ALLOCTYPE_THIS_AG;
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
+	error = xfs_alloc_vextent_check_args(args);
+	if (error) {
+		if (error == -ENOSPC)
+			return 0;
+		return error;
+	}
 
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
+	error = xfs_alloc_vextent_iterate_ags(args, minimum_agno, start_agno,
+			XFS_ALLOC_FLAG_TRYLOCK);
+	if (bump_rotor) {
+		if (args->agno == start_agno)
+			mp->m_agfrotor = (mp->m_agfrotor + 1) %
+				(mp->m_sb.sb_agcount * rotorstep);
+		else
+			mp->m_agfrotor = (args->agno * rotorstep + 1) %
+				(mp->m_sb.sb_agcount * rotorstep);
 	}
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
 	}
 
-	/*
-	 * We end up here with a locked AGF. If we failed, the caller is likely
-	 * going to try to allocate again with different parameters, and that
-	 * can widen the AGs that are searched for free space. If we have to do
-	 * BMBT block allocation, we have to do a new allocation.
-	 *
-	 * Hence leaving this function with the AGF locked opens up potential
-	 * ABBA AGF deadlocks because a future allocation attempt in this
-	 * transaction may attempt to lock a lower number AGF.
-	 *
-	 * We can't release the AGF until the transaction is commited, so at
-	 * this point we must update the "firstblock" tracker to point at this
-	 * AG if the tracker is empty or points to a lower AG. This allows the
-	 * next allocation attempt to be modified appropriately to avoid
-	 * deadlocks.
-	 */
-	if (args->agbp &&
-	    (args->tp->t_highest_agno == NULLAGNUMBER ||
-	     args->pag->pag_agno > minimum_agno))
-		args->tp->t_highest_agno = args->pag->pag_agno;
-	xfs_perag_put(args->pag);
-	return 0;
-error0:
-	xfs_perag_put(args->pag);
+	start_agno = max(minimum_agno, XFS_FSB_TO_AGNO(mp, args->fsbno));
+
+	args->type = XFS_ALLOCTYPE_THIS_AG;
+	error =  xfs_alloc_vextent_iterate_ags(args, minimum_agno,
+			start_agno, 0);
+	xfs_alloc_vextent_set_fsbno(args, minimum_agno);
 	return error;
 }
 
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

