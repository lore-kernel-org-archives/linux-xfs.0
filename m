Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8465C38159
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 22:45:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbjARWpd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 17:45:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbjARWpS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 17:45:18 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B32EC5FD60
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:45:17 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id 7-20020a17090a098700b002298931e366so67363pjo.2
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:45:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=etaI0Gchj8lFe6SVq82O+3tRjxGxTPna0CWpt9psuR8=;
        b=Pfje9+2AsnhYqua03Ex8W3ngg/hRV/GI1PIRa9gkKHV2yLSOc+qpt3TkjIww4ocZK3
         Pxyq+3Y6zgg2ZZTcUcePR6m7QAcJ2cKiJrmkQHM8TgRz3pT+ndzSXuSGaCbdvPD4mp4e
         ldl2XgaMuBAlCMhM6j47YneOFI7lAvD56ML0cYNaOTSMYMLRtMVbJ+SLb2v09yKBK56N
         yChJjLTWnL0NRJuLArYCL3p8DDswCfa2KcWx8ejgT8pXrYRKSEI4BV4GLJkXDtWssuv9
         cz0rSBZzrBzoxBVxwzB6KNS1GGI2CJYjAGDPPDgGFB/URgD0d73FvTB0OthIOkmSWzR6
         PeTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=etaI0Gchj8lFe6SVq82O+3tRjxGxTPna0CWpt9psuR8=;
        b=19mSvKJIavY25CtSFRHZlrLmfT1a67tz5+FyZNXmNhMFrSYqFRNJqBK/+5d+F6BYtF
         0WOEYu7GCr83gg4dMQTJj7lV8pCJcG5guNfRumRHwX3NQJDANxbhxh1oJlvqaGp3vkmF
         Ob5+r8Zq7SXTJ0bRzBw5Sk8tJ93ceB9z3mresA18olLuAfWsLf5Nq6Q1zsoIBAR/dF8u
         3xMErRYkwVQ0w11zZ9KbVHJmoFsh3XKnCV3dVYUSKk6upYhND6YWS5bGP2favXTuLRr/
         oxKdIViKGDGp/EdtqHygm5zy8xHv3HEZiENP2cphPKmiAX1uDpBk8pXJYIflbqI2MxS6
         I+5w==
X-Gm-Message-State: AFqh2kr0LMtNTchWBwIP60yys4L4URB64gctYy6cpt6sVNWATRXzwvPC
        brp4hx8xLqs51Dgut5lnVbL0CjdjIitSC4WP
X-Google-Smtp-Source: AMrXdXs9tGuLlV7qqqcl+9SxLKvZoz3gEJD80mNRiZDiOP5sK6lsFWSYdPNQ3xsA2yANJCA6GgXpFA==
X-Received: by 2002:a17:902:c3cd:b0:194:623e:f401 with SMTP id j13-20020a170902c3cd00b00194623ef401mr9191092plj.8.1674081917095;
        Wed, 18 Jan 2023 14:45:17 -0800 (PST)
Received: from dread.disaster.area (pa49-186-146-207.pa.vic.optusnet.com.au. [49.186.146.207])
        by smtp.gmail.com with ESMTPSA id q6-20020a170902dac600b0018544ad1e8esm2150724plx.238.2023.01.18.14.45.13
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 14:45:15 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pIHB9-004iXl-FN
        for linux-xfs@vger.kernel.org; Thu, 19 Jan 2023 09:45:11 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pIHB9-008FER-1X
        for linux-xfs@vger.kernel.org;
        Thu, 19 Jan 2023 09:45:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 24/42] xfs: introduce xfs_alloc_vextent_prepare()
Date:   Thu, 19 Jan 2023 09:44:47 +1100
Message-Id: <20230118224505.1964941-25-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118224505.1964941-1-david@fromorbit.com>
References: <20230118224505.1964941-1-david@fromorbit.com>
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
---
 fs/xfs/libxfs/xfs_alloc.c | 120 ++++++++++++++++++++++++--------------
 1 file changed, 76 insertions(+), 44 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index b810a94aad70..bfbbb7536310 100644
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
 			break;
-		}
-		if (args->agbp)
+
+		if (args->agbp) {
+			/*
+			 * Allocation is supposed to succeed now, so break out
+			 * of the loop regardless of whether we succeed or not.
+			 */
+			error = xfs_alloc_ag_vextent(args);
 			break;
+		}
 
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
+
+	error = xfs_alloc_vextent_prepare_ag(args);
+	if (!error && args->agbp)
+		error = xfs_alloc_ag_vextent(args);
+
+	xfs_alloc_vextent_set_fsbno(args, minimum_agno);
 	if (need_pag)
 		xfs_perag_put(args->pag);
-	if (error)
-		return error;
 
-	xfs_alloc_vextent_set_fsbno(args, minimum_agno);
-	return 0;
+	return error;
 }
 
 /* Ensure that the freelist is at full capacity. */
-- 
2.39.0

