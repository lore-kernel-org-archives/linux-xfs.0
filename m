Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AAD7E8FDC2
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Oct 2023 00:19:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232394AbjJDAT4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Oct 2023 20:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232552AbjJDATz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Oct 2023 20:19:55 -0400
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 279E99B
        for <linux-xfs@vger.kernel.org>; Tue,  3 Oct 2023 17:19:52 -0700 (PDT)
Received: by mail-oo1-xc31.google.com with SMTP id 006d021491bc7-57bca5b9b0aso881650eaf.3
        for <linux-xfs@vger.kernel.org>; Tue, 03 Oct 2023 17:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1696378791; x=1696983591; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3vuDpmOAJdGbtAKQnd/e01XgnfdE7mIeD/QyJn7O+9g=;
        b=eZMobt7zEMjQgu0yjjn/j0bnCrlfnG+RuvJF/7aj0p8TEsX15tY9Asbs358OakMQc1
         uFoMeX1UE5cARXvLNC0BB6LOhc5RdoL5L85Ek3lGgTGyYDwLOTqEEkfHJ597k04XCXEP
         qF6QtuQSljY0oR4T731Qgk7kSOWhFOHcpmTQ2sCDwOwkNAs6OnxLhsybS87BZ2f5ZEp4
         Xme0o6VxPjl1T9T89Az3TBpiqhOsV7tpLRRnv4YqFIPT5d0k60OuJmYhbUt67wjy2Tmj
         2ccq19iny59ZGqHsMo6+Og0lodLd8HULgLSafyOf4NZ0SvDbPZw39x0v3Jt4+cPyuyEc
         qhJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696378791; x=1696983591;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3vuDpmOAJdGbtAKQnd/e01XgnfdE7mIeD/QyJn7O+9g=;
        b=IGL8CWOOPlj7wgPqFuCM9XjyxyxRW8qiOmaiC8xRSBHVhLYAoPGe1J3QHa73I36oEC
         DjWu0JLFzlVTEg3Fnn8Qp9jZLfg/sMS7IwldKSt+7amStK3gRdFWwdrBY5IkYjyqYP77
         vI+GgvxyES/JGC0VvwI6lYDROmDNLJyCowUcuZbOb3WebvcQ7OrV7m4+J5qqoihU7Mx1
         aeJtwuyJuZlEuMqGUXfElibDHUu4waT8VlPY7VoMEJmSPGGkSNsEOZXbq4WvVLQgnnPs
         xdahyZsp4zxrypbzVZizKDQHhUOb7mjGtAB35gpOcHxx9Vp03ovAZc/nBd8nIubsv/5u
         MhXw==
X-Gm-Message-State: AOJu0YxLrim8/hSxIIorYt1B1i8pFHa37JXwsqjxoRmmOL8o/eptgscI
        KuEnAZDuyluLZNpQ3G8AKLM56pS6dsNGon4BgYo=
X-Google-Smtp-Source: AGHT+IE0/JAeQDG/BAkWJR6xKpymO/89VsG0vMlv37LdOqovmw7BO3SxsSTmtLyRiY+xlezWj4ns0Q==
X-Received: by 2002:a05:6358:341a:b0:13c:dc2e:3548 with SMTP id h26-20020a056358341a00b0013cdc2e3548mr1000194rwd.28.1696378791388;
        Tue, 03 Oct 2023 17:19:51 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id 14-20020a17090a19ce00b00277371fd346sm205304pjj.30.2023.10.03.17.19.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Oct 2023 17:19:50 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.96)
        (envelope-from <dave@fromorbit.com>)
        id 1qnpcA-0097NM-0U;
        Wed, 04 Oct 2023 11:19:45 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97-RC0)
        (envelope-from <dave@devoid.disaster.area>)
        id 1qnpc9-00000001TrP-3f0u;
        Wed, 04 Oct 2023 11:19:45 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     john.g.garry@oracle.com
Subject: [PATCH 6/9] xfs: use agno/agbno in xfs_alloc_vextent functions
Date:   Wed,  4 Oct 2023 11:19:40 +1100
Message-Id: <20231004001943.349265-7-david@fromorbit.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231004001943.349265-1-david@fromorbit.com>
References: <20231004001943.349265-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We're moving away from using xfs_fsblock_t to define allocation
targets, and instead we are using {agno,agbno} tuples instead. This
will allow us to eventually move everything to {perag,agbno}. But
before we get there, we need to split the fsblock into {agno,agbno}
and convert the code to use those first.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 57 +++++++++++++++++++++------------------
 1 file changed, 31 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 3069194527dd..289b54911b05 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3249,7 +3249,8 @@ xfs_alloc_read_agf(
 static int
 xfs_alloc_vextent_check_args(
 	struct xfs_alloc_arg	*args,
-	xfs_fsblock_t		target,
+	xfs_agnumber_t		target_agno,
+	xfs_agblock_t		target_agbno,
 	xfs_agnumber_t		*minimum_agno)
 {
 	struct xfs_mount	*mp = args->mp;
@@ -3277,14 +3278,14 @@ xfs_alloc_vextent_check_args(
 	ASSERT(args->alignment > 0);
 	ASSERT(args->resv != XFS_AG_RESV_AGFL);
 
-	ASSERT(XFS_FSB_TO_AGNO(mp, target) < mp->m_sb.sb_agcount);
-	ASSERT(XFS_FSB_TO_AGBNO(mp, target) < agsize);
+	ASSERT(target_agno < mp->m_sb.sb_agcount);
+	ASSERT(target_agbno < agsize);
 	ASSERT(args->minlen <= args->maxlen);
 	ASSERT(args->minlen <= agsize);
 	ASSERT(args->mod < args->prod);
 
-	if (XFS_FSB_TO_AGNO(mp, target) >= mp->m_sb.sb_agcount ||
-	    XFS_FSB_TO_AGBNO(mp, target) >= agsize ||
+	if (target_agno >= mp->m_sb.sb_agcount ||
+	    target_agbno >= agsize ||
 	    args->minlen > args->maxlen || args->minlen > agsize ||
 	    args->mod >= args->prod) {
 		trace_xfs_alloc_vextent_badargs(args);
@@ -3438,7 +3439,6 @@ xfs_alloc_vextent_this_ag(
 	struct xfs_alloc_arg	*args,
 	xfs_agnumber_t		agno)
 {
-	struct xfs_mount	*mp = args->mp;
 	xfs_agnumber_t		minimum_agno;
 	uint32_t		alloc_flags = 0;
 	int			error;
@@ -3451,8 +3451,7 @@ xfs_alloc_vextent_this_ag(
 
 	trace_xfs_alloc_vextent_this_ag(args);
 
-	error = xfs_alloc_vextent_check_args(args, XFS_AGB_TO_FSB(mp, agno, 0),
-			&minimum_agno);
+	error = xfs_alloc_vextent_check_args(args, agno, 0, &minimum_agno);
 	if (error) {
 		if (error == -ENOSPC)
 			return 0;
@@ -3563,7 +3562,8 @@ xfs_alloc_vextent_start_ag(
 {
 	struct xfs_mount	*mp = args->mp;
 	xfs_agnumber_t		minimum_agno;
-	xfs_agnumber_t		start_agno;
+	xfs_agnumber_t		target_agno;
+	xfs_agblock_t		target_agbno;
 	xfs_agnumber_t		rotorstep = xfs_rotorstep;
 	bool			bump_rotor = false;
 	uint32_t		alloc_flags = XFS_ALLOC_FLAG_TRYLOCK;
@@ -3576,7 +3576,10 @@ xfs_alloc_vextent_start_ag(
 
 	trace_xfs_alloc_vextent_start_ag(args);
 
-	error = xfs_alloc_vextent_check_args(args, target, &minimum_agno);
+	target_agno = XFS_FSB_TO_AGNO(mp, target);
+	target_agbno = XFS_FSB_TO_AGBNO(mp, target);
+	error = xfs_alloc_vextent_check_args(args, target_agno, target_agbno,
+			&minimum_agno);
 	if (error) {
 		if (error == -ENOSPC)
 			return 0;
@@ -3591,12 +3594,11 @@ xfs_alloc_vextent_start_ag(
 		bump_rotor = 1;
 	}
 
-	start_agno = max(minimum_agno, XFS_FSB_TO_AGNO(mp, target));
-	error = xfs_alloc_vextent_iterate_ags(args, minimum_agno, start_agno,
-			XFS_FSB_TO_AGBNO(mp, target), alloc_flags);
-
+	target_agno = max(minimum_agno, target_agno);
+	error = xfs_alloc_vextent_iterate_ags(args, minimum_agno, target_agno,
+			target_agbno, alloc_flags);
 	if (bump_rotor) {
-		if (args->agno == start_agno)
+		if (args->agno == target_agno)
 			mp->m_agfrotor = (mp->m_agfrotor + 1) %
 				(mp->m_sb.sb_agcount * rotorstep);
 		else
@@ -3619,7 +3621,8 @@ xfs_alloc_vextent_first_ag(
  {
 	struct xfs_mount	*mp = args->mp;
 	xfs_agnumber_t		minimum_agno;
-	xfs_agnumber_t		start_agno;
+	xfs_agnumber_t		target_agno;
+	xfs_agblock_t		target_agbno;
 	uint32_t		alloc_flags = XFS_ALLOC_FLAG_TRYLOCK;
 	int			error;
 
@@ -3630,16 +3633,19 @@ xfs_alloc_vextent_first_ag(
 
 	trace_xfs_alloc_vextent_first_ag(args);
 
-	error = xfs_alloc_vextent_check_args(args, target, &minimum_agno);
+	target_agno = XFS_FSB_TO_AGNO(mp, target);
+	target_agbno = XFS_FSB_TO_AGBNO(mp, target);
+	error = xfs_alloc_vextent_check_args(args, target_agno, target_agbno,
+			&minimum_agno);
 	if (error) {
 		if (error == -ENOSPC)
 			return 0;
 		return error;
 	}
 
-	start_agno = max(minimum_agno, XFS_FSB_TO_AGNO(mp, target));
-	error = xfs_alloc_vextent_iterate_ags(args, minimum_agno, start_agno,
-			XFS_FSB_TO_AGBNO(mp, target), alloc_flags);
+	target_agno = max(minimum_agno, target_agno);
+	error = xfs_alloc_vextent_iterate_ags(args, minimum_agno, target_agno,
+			target_agbno, alloc_flags);
 	return xfs_alloc_vextent_finish(args, minimum_agno, error, true);
 }
 
@@ -3656,15 +3662,13 @@ xfs_alloc_vextent_exact_bno(
 	xfs_agnumber_t		minimum_agno;
 	int			error;
 
-	ASSERT(args->pag != NULL);
-	ASSERT(args->pag->pag_agno == XFS_FSB_TO_AGNO(mp, target));
-
-	args->agno = XFS_FSB_TO_AGNO(mp, target);
+	args->agno = args->pag->pag_agno;
 	args->agbno = XFS_FSB_TO_AGBNO(mp, target);
 
 	trace_xfs_alloc_vextent_exact_bno(args);
 
-	error = xfs_alloc_vextent_check_args(args, target, &minimum_agno);
+	error = xfs_alloc_vextent_check_args(args, args->agno, args->agbno,
+			&minimum_agno);
 	if (error) {
 		if (error == -ENOSPC)
 			return 0;
@@ -3703,7 +3707,8 @@ xfs_alloc_vextent_near_bno(
 
 	trace_xfs_alloc_vextent_near_bno(args);
 
-	error = xfs_alloc_vextent_check_args(args, target, &minimum_agno);
+	error = xfs_alloc_vextent_check_args(args, args->agno, args->agbno,
+			&minimum_agno);
 	if (error) {
 		if (error == -ENOSPC)
 			return 0;
-- 
2.40.1

