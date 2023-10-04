Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91269E8FDC4
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Oct 2023 00:19:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232262AbjJDATy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Oct 2023 20:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbjJDATx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Oct 2023 20:19:53 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CB148E
        for <linux-xfs@vger.kernel.org>; Tue,  3 Oct 2023 17:19:50 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id 41be03b00d2f7-54290603887so984391a12.1
        for <linux-xfs@vger.kernel.org>; Tue, 03 Oct 2023 17:19:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1696378790; x=1696983590; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gqobjK1Dii4757l51EvuKRSlTqyqzkuNNRTaTT/hb78=;
        b=ewI0hSRpYuGQcJmff1CigADaBNQK9k6vTFt2xo4BYOlZwHKFB4VJHc1JcVsNk9MZdu
         IWM3hizwwYw4+Ng2kUbEEVt3p4cwqEfKIHqGP+wZRnrn9yxhacrMPB6FtOjkhsJ1d95b
         ZR96axnxwR8pPJzGSsvLCqjpCcqcSINqxKEl4WfNrppKISJmC9gABFwOatbputrs8TLQ
         BlTWzgTc3oEcq/5VOu888sg3k7f3kE7LI04GY/wP79ShvT/JH52wX+Db45g5SRoyQVyl
         BhzaQPDhuTwWGJXvk8Ku8K6NuhKPaHoiOKwQLhfXKao+P/L81buMqvPVKmtXfwC32o8u
         hqCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696378790; x=1696983590;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gqobjK1Dii4757l51EvuKRSlTqyqzkuNNRTaTT/hb78=;
        b=kh4kGFIiJeRzzfAkbCMCryQpCd6qHcJLr1L4kViIlf64IMd66fexXQj1eA3QU8+qXn
         JNTfpF2UcLzzKe0N5DLyj5AmUFcvJXv5wfCgVrP2LIdTEK/pbtmOVImX1emQ8cReza8x
         8AN8z1HwAOGT3QatoZQFzFBQPY+cAeSipeXqmahYEGxM+BN1ellm6BHX69ZNiZBQpoKd
         gExRp98rx1YyrNslsR6hQJe8aGMM/M4F+brWf/fjTyVspV9K1U9ELg8LSaMBmCqNaaiX
         1KKggLjKNG99nAGW+O1FYje0hfJ3gMn2Hhwds6IqgSctwdbhRRNsMWb7dJCWkQbAzmfa
         qVTA==
X-Gm-Message-State: AOJu0YyDp7xKvFq+lrzJQDYy5Qz5SNsSj1eZSyIJeE4B7dTPWPhDW+H9
        GlEjoFpEG7DtthFHY2FYNzKc62X78ula2LTby6Q=
X-Google-Smtp-Source: AGHT+IEIq8HCYxJ2V8cWrynUQmOTYNNiYsmiFKvocu/TqwOk9TCLxvOnchEMoyGeaIOxR38MrrN5Nw==
X-Received: by 2002:a05:6a21:8cc5:b0:14c:c393:6af with SMTP id ta5-20020a056a218cc500b0014cc39306afmr1006188pzb.0.1696378789844;
        Tue, 03 Oct 2023 17:19:49 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id jw19-20020a170903279300b001bb97e51ab4sm2225676plb.98.2023.10.03.17.19.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Oct 2023 17:19:49 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.96)
        (envelope-from <dave@fromorbit.com>)
        id 1qnpcA-0097NQ-0j;
        Wed, 04 Oct 2023 11:19:46 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97-RC0)
        (envelope-from <dave@devoid.disaster.area>)
        id 1qnpc9-00000001TrU-3u3X;
        Wed, 04 Oct 2023 11:19:45 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     john.g.garry@oracle.com
Subject: [PATCH 7/9] xfs: caller perag always supplied to xfs_alloc_vextent_near_bno
Date:   Wed,  4 Oct 2023 11:19:41 +1100
Message-Id: <20231004001943.349265-8-david@fromorbit.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231004001943.349265-1-david@fromorbit.com>
References: <20231004001943.349265-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

So we don't need to conditionally grab the perag anymore.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 289b54911b05..3190c8204903 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3686,7 +3686,7 @@ xfs_alloc_vextent_exact_bno(
  * Allocate an extent as close to the target as possible. If there are not
  * viable candidates in the AG, then fail the allocation.
  *
- * Caller may or may not have a per-ag reference in args->pag.
+ * Caller is expected to hold a per-ag reference in args->pag.
  */
 int
 xfs_alloc_vextent_near_bno(
@@ -3695,14 +3695,12 @@ xfs_alloc_vextent_near_bno(
 {
 	struct xfs_mount	*mp = args->mp;
 	xfs_agnumber_t		minimum_agno;
-	bool			needs_perag = args->pag == NULL;
 	uint32_t		alloc_flags = 0;
 	int			error;
 
-	if (!needs_perag)
-		ASSERT(args->pag->pag_agno == XFS_FSB_TO_AGNO(mp, target));
+	ASSERT(args->pag->pag_agno == XFS_FSB_TO_AGNO(mp, target));
 
-	args->agno = XFS_FSB_TO_AGNO(mp, target);
+	args->agno = args->pag->pag_agno;
 	args->agbno = XFS_FSB_TO_AGBNO(mp, target);
 
 	trace_xfs_alloc_vextent_near_bno(args);
@@ -3715,14 +3713,11 @@ xfs_alloc_vextent_near_bno(
 		return error;
 	}
 
-	if (needs_perag)
-		args->pag = xfs_perag_grab(mp, args->agno);
-
 	error = xfs_alloc_vextent_prepare_ag(args, alloc_flags);
 	if (!error && args->agbp)
 		error = xfs_alloc_ag_vextent_near(args, alloc_flags);
 
-	return xfs_alloc_vextent_finish(args, minimum_agno, error, needs_perag);
+	return xfs_alloc_vextent_finish(args, minimum_agno, error, false);
 }
 
 /* Ensure that the freelist is at full capacity. */
-- 
2.40.1

