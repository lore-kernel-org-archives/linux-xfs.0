Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F6FBE8FDC3
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Oct 2023 00:19:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231485AbjJDATx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Oct 2023 20:19:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232262AbjJDATw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Oct 2023 20:19:52 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F157FA7
        for <linux-xfs@vger.kernel.org>; Tue,  3 Oct 2023 17:19:49 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-6910ea9cca1so1147469b3a.1
        for <linux-xfs@vger.kernel.org>; Tue, 03 Oct 2023 17:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1696378789; x=1696983589; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ujB/SKgPHPQ3dpLB/wSd0p64HM+IwoQbQ7c1JJnIICQ=;
        b=qddIVqkM1DKiIykqMnKZdrO+TP01MWvOUKAL1c2XH155T/KlLQmq7PdWZPCbzEW1pH
         iTF38H9suHLmKNGM7LBAG6y3Xomi+gJEnt3SVVmAIblfvsp/JAJU4bPtZ49LWqnRL1/r
         FObxrTligTC3BQpqF//CTCweW3//Rbf9z8Dyesp+TpWSMUioh7Gy7xCVz3DV9jVdT0EV
         jeAkSDN3KZ1v34MLusY8M4am/vbz6SAtIupXyHG2TgtwUuO30uLwhsL8CbByHsp33fej
         kCD5q4invrds7MUEZUCf0GEzyqX8W68zUnCUXVk7lRnJG9nu4mkaFaxrnDBftf5ErnS+
         O4WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696378789; x=1696983589;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ujB/SKgPHPQ3dpLB/wSd0p64HM+IwoQbQ7c1JJnIICQ=;
        b=AqZ8rcfunllgEFFStACaVlDV5YXKhdwJKWD1zhz9bIM26ptZOFa3ZfGHmNODVggAu/
         B1UV2iu1LkAbXnOgLMwmgs7lO44JcUKrToCVDdKpxMDXpqueaoJMb3KGmRjogIsi7C/w
         Zoa0slg+i1D4Aaj/UvsN5DtkHLHweYcAGAUSCYa2sRCc28JkIW9Jeerj0PiLrQ4+R/XN
         6RA+jbnWJgmCqyBZxyA1AJaLiyeDsQ2aoaEaS4LD8e5wZwCZf6duDxBFfLellrIDH2FH
         iF68DZ9rOL8Mbloy2AXP5X60ZjYh8iO+CABfrak+7GBJGWyKaTxjCoGHWcTqQAG0KvSa
         /tZQ==
X-Gm-Message-State: AOJu0YzaIB6+7+w7j8tNbpX4p/zLgc0qx064cOd0sI5jpNMvQ8kAhuFg
        YaQpeibvZ7dfBUteTU/Rm/jbOOUuBOxkAsOOTAQ=
X-Google-Smtp-Source: AGHT+IEks1iyCq+dpAoLTj3ow4PJr9e1IjdH5rXyM6u0SvV/pFPwtpE5xK1kKWq/5VTZtdjhZvYIMw==
X-Received: by 2002:a05:6a00:2196:b0:690:24ff:c80f with SMTP id h22-20020a056a00219600b0069024ffc80fmr1060465pfi.34.1696378789446;
        Tue, 03 Oct 2023 17:19:49 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id y2-20020a62b502000000b0068c90e1ec84sm1932553pfe.167.2023.10.03.17.19.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Oct 2023 17:19:48 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.96)
        (envelope-from <dave@fromorbit.com>)
        id 1qnpcA-0097NU-0t;
        Wed, 04 Oct 2023 11:19:46 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97-RC0)
        (envelope-from <dave@devoid.disaster.area>)
        id 1qnpc9-00000001TrZ-4BZJ;
        Wed, 04 Oct 2023 11:19:46 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     john.g.garry@oracle.com
Subject: [PATCH 8/9] xfs: collapse near and exact bno allocation
Date:   Wed,  4 Oct 2023 11:19:42 +1100
Message-Id: <20231004001943.349265-9-david@fromorbit.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231004001943.349265-1-david@fromorbit.com>
References: <20231004001943.349265-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

As they are now identical functions exact for the allocation
function they call.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 84 ++++++++++++++++++---------------------
 fs/xfs/xfs_trace.h        |  1 +
 2 files changed, 40 insertions(+), 45 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 3190c8204903..27c62f303488 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3649,6 +3649,43 @@ xfs_alloc_vextent_first_ag(
 	return xfs_alloc_vextent_finish(args, minimum_agno, error, true);
 }
 
+static int
+xfs_alloc_vextent_bno(
+	struct xfs_alloc_arg	*args,
+	xfs_fsblock_t		target,
+	bool			exact)
+{
+	struct xfs_mount	*mp = args->mp;
+	xfs_agnumber_t		minimum_agno;
+	int			error;
+
+	ASSERT(args->pag != NULL);
+	ASSERT(args->pag->pag_agno == XFS_FSB_TO_AGNO(mp, target));
+
+	args->agno = args->pag->pag_agno;
+	args->agbno = XFS_FSB_TO_AGBNO(mp, target);
+
+	trace_xfs_alloc_vextent_bno(args);
+
+	error = xfs_alloc_vextent_check_args(args, args->agno, args->agbno,
+			&minimum_agno);
+	if (error) {
+		if (error == -ENOSPC)
+			return 0;
+		return error;
+	}
+
+	error = xfs_alloc_vextent_prepare_ag(args, 0);
+	if (!error && args->agbp) {
+		if (exact)
+			error = xfs_alloc_ag_vextent_exact(args);
+		else
+			error = xfs_alloc_ag_vextent_near(args, 0);
+	}
+
+	return xfs_alloc_vextent_finish(args, minimum_agno, error, false);
+}
+
 /*
  * Allocate at the exact block target or fail. Caller is expected to hold a
  * perag reference in args->pag.
@@ -3658,28 +3695,8 @@ xfs_alloc_vextent_exact_bno(
 	struct xfs_alloc_arg	*args,
 	xfs_fsblock_t		target)
 {
-	struct xfs_mount	*mp = args->mp;
-	xfs_agnumber_t		minimum_agno;
-	int			error;
-
-	args->agno = args->pag->pag_agno;
-	args->agbno = XFS_FSB_TO_AGBNO(mp, target);
-
 	trace_xfs_alloc_vextent_exact_bno(args);
-
-	error = xfs_alloc_vextent_check_args(args, args->agno, args->agbno,
-			&minimum_agno);
-	if (error) {
-		if (error == -ENOSPC)
-			return 0;
-		return error;
-	}
-
-	error = xfs_alloc_vextent_prepare_ag(args, 0);
-	if (!error && args->agbp)
-		error = xfs_alloc_ag_vextent_exact(args);
-
-	return xfs_alloc_vextent_finish(args, minimum_agno, error, false);
+	return xfs_alloc_vextent_bno(args, target, true);
 }
 
 /*
@@ -3693,31 +3710,8 @@ xfs_alloc_vextent_near_bno(
 	struct xfs_alloc_arg	*args,
 	xfs_fsblock_t		target)
 {
-	struct xfs_mount	*mp = args->mp;
-	xfs_agnumber_t		minimum_agno;
-	uint32_t		alloc_flags = 0;
-	int			error;
-
-	ASSERT(args->pag->pag_agno == XFS_FSB_TO_AGNO(mp, target));
-
-	args->agno = args->pag->pag_agno;
-	args->agbno = XFS_FSB_TO_AGBNO(mp, target);
-
 	trace_xfs_alloc_vextent_near_bno(args);
-
-	error = xfs_alloc_vextent_check_args(args, args->agno, args->agbno,
-			&minimum_agno);
-	if (error) {
-		if (error == -ENOSPC)
-			return 0;
-		return error;
-	}
-
-	error = xfs_alloc_vextent_prepare_ag(args, alloc_flags);
-	if (!error && args->agbp)
-		error = xfs_alloc_ag_vextent_near(args, alloc_flags);
-
-	return xfs_alloc_vextent_finish(args, minimum_agno, error, false);
+	return xfs_alloc_vextent_bno(args, target, false);
 }
 
 /* Ensure that the freelist is at full capacity. */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 3926cf7f2a6e..628da36b20b9 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1884,6 +1884,7 @@ DEFINE_ALLOC_EVENT(xfs_alloc_vextent_start_ag);
 DEFINE_ALLOC_EVENT(xfs_alloc_vextent_first_ag);
 DEFINE_ALLOC_EVENT(xfs_alloc_vextent_exact_bno);
 DEFINE_ALLOC_EVENT(xfs_alloc_vextent_near_bno);
+DEFINE_ALLOC_EVENT(xfs_alloc_vextent_bno);
 DEFINE_ALLOC_EVENT(xfs_alloc_vextent_finish);
 
 TRACE_EVENT(xfs_alloc_cur_check,
-- 
2.40.1

