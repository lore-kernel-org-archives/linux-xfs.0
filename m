Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F4EEC38147
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 22:45:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbjARWpe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 17:45:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjARWpT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 17:45:19 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B1A560491
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:45:18 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id o7-20020a17090a0a0700b00226c9b82c3aso53650pjo.3
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:45:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P81BaZMttsxu9qBV+N8cR5TRwjRefLeeP4Kqf5YDWIQ=;
        b=zdJ+65g9/300ixAYDIoZNEgFZ1O6Mw3/S3LosLKcNoHQdVrE7oLa9Kss8XY8QGHAYl
         0scBPfLiLeIHKQN24yH/wMdQx1ohCcPLorqVhaamoDTkZ1hnIxELJ73itrPQqYpD2U2m
         nYoH5MM6zvclDJj/LHpQZYPU0GCSgJgLR+nFbpobIu1Z0u4TZUOuJCXActcllQAJ9EA7
         m0e+0K951xe8ADjEiNAAPel+FVAAgTS0F6pDaITrQ6pxjGI1vZB3p6Kkt+I0jbb77FmP
         9rFaMDdstGMPB8bc1LFflZwJAvL8U+mveSEuSpUfc3qlpCSRhw/Rmfh8nDZyvy/NoEJZ
         zLnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P81BaZMttsxu9qBV+N8cR5TRwjRefLeeP4Kqf5YDWIQ=;
        b=qkOJBrX2CVTkjujClB2REEx7rvp8kSeQbVKUWdzhYdUmNcGFGRXFBx/QpvWm21TTK3
         +59P7eVSaf9HF/t7aG+ALO3tnPwa8ArAacqS4yujltAVnD/IV13aOVDR0neIGUja/G+w
         lO22t1nezyu4nUKlGX8v2o0ih5XQxctJx2GD61Afbje5452Y6bClGu9ZRVKR1kZ/G81L
         3lOIoYL9NGVPX7IvlBJtUyhVgRTmkKocv+ca5I0pZYyAPklw9/cid1XbbrIpEsxYSjeJ
         uLiss9bsnw+xeySBcv3ZfExYi9yqN9s2auFIb0FOxzW/u5sjLh0IP7+w30w8Svzrb0TJ
         ynBA==
X-Gm-Message-State: AFqh2krcJqu9Vd7MYo/GND5apW8zJFOFWNO6PsdrdIBrsuj4a0ea54Wc
        9bly6dhZ1njIu6szEommN5aBFzMoMf5u8rma
X-Google-Smtp-Source: AMrXdXvfnPwUXxLsHVK46zqEPchJeJ7WKAMJ9PhgVGUOt2lPMaXFAn0hkC+LtN+aO9WdMuAKBd2+DQ==
X-Received: by 2002:a17:90b:4f86:b0:229:307f:65e6 with SMTP id qe6-20020a17090b4f8600b00229307f65e6mr8990647pjb.48.1674081917595;
        Wed, 18 Jan 2023 14:45:17 -0800 (PST)
Received: from dread.disaster.area (pa49-186-146-207.pa.vic.optusnet.com.au. [49.186.146.207])
        by smtp.gmail.com with ESMTPSA id u4-20020a17090a6a8400b0022717d8d835sm1797701pjj.16.2023.01.18.14.45.13
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 14:45:15 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pIHB9-004iXu-IB
        for linux-xfs@vger.kernel.org; Thu, 19 Jan 2023 09:45:11 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pIHB9-008FEg-1p
        for linux-xfs@vger.kernel.org;
        Thu, 19 Jan 2023 09:45:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 27/42] xfs: move the minimum agno checks into xfs_alloc_vextent_check_args
Date:   Thu, 19 Jan 2023 09:44:50 +1100
Message-Id: <20230118224505.1964941-28-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118224505.1964941-1-david@fromorbit.com>
References: <20230118224505.1964941-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

All of the allocation functions now extract the minimum allowed AG
from the transaction and then use it in some way. The allocation
functions that are restricted to a single AG all check if the
AG requested can be allocated from and return an error if so. These
all set args->agno appropriately.

All the allocation functions that iterate AGs use it to calculate
the scan start AG. args->agno is not set until the iterator starts
walking AGs.

Hence we can easily set up a conditional check against the minimum
AG allowed in xfs_alloc_vextent_check_args() based on whether
args->agno contains NULLAGNUMBER or not and move all the repeated
setup code to xfs_alloc_vextent_check_args(), further simplifying
the allocation functions.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 88 +++++++++++++++------------------------
 1 file changed, 33 insertions(+), 55 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 4de9026d872f..43a054002da3 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3089,14 +3089,18 @@ xfs_alloc_read_agf(
 static int
 xfs_alloc_vextent_check_args(
 	struct xfs_alloc_arg	*args,
-	xfs_rfsblock_t		target)
+	xfs_rfsblock_t		target,
+	xfs_agnumber_t		*minimum_agno)
 {
 	struct xfs_mount	*mp = args->mp;
 	xfs_agblock_t		agsize;
 
-	args->agbno = NULLAGBLOCK;
 	args->fsbno = NULLFSBLOCK;
 
+	*minimum_agno = 0;
+	if (args->tp->t_highest_agno != NULLAGNUMBER)
+		*minimum_agno = args->tp->t_highest_agno;
+
 	/*
 	 * Just fix this up, for the case where the last a.g. is shorter
 	 * (or there's only one a.g.) and the caller couldn't easily figure
@@ -3123,11 +3127,16 @@ xfs_alloc_vextent_check_args(
 	    XFS_FSB_TO_AGBNO(mp, target) >= agsize ||
 	    args->minlen > args->maxlen || args->minlen > agsize ||
 	    args->mod >= args->prod) {
-		args->fsbno = NULLFSBLOCK;
 		trace_xfs_alloc_vextent_badargs(args);
 		return -ENOSPC;
 	}
+
+	if (args->agno != NULLAGNUMBER && *minimum_agno > args->agno) {
+		trace_xfs_alloc_vextent_skip_deadlock(args);
+		return -ENOSPC;
+	}
 	return 0;
+
 }
 
 /*
@@ -3266,28 +3275,19 @@ xfs_alloc_vextent_this_ag(
 	xfs_agnumber_t		agno)
 {
 	struct xfs_mount	*mp = args->mp;
-	xfs_agnumber_t		minimum_agno = 0;
+	xfs_agnumber_t		minimum_agno;
 	int			error;
 
-	if (args->tp->t_highest_agno != NULLAGNUMBER)
-		minimum_agno = args->tp->t_highest_agno;
-
-	if (minimum_agno > agno) {
-		trace_xfs_alloc_vextent_skip_deadlock(args);
-		args->fsbno = NULLFSBLOCK;
-		return 0;
-	}
-
-	error = xfs_alloc_vextent_check_args(args, XFS_AGB_TO_FSB(mp, agno, 0));
+	args->agno = agno;
+	args->agbno = 0;
+	error = xfs_alloc_vextent_check_args(args, XFS_AGB_TO_FSB(mp, agno, 0),
+			&minimum_agno);
 	if (error) {
 		if (error == -ENOSPC)
 			return 0;
 		return error;
 	}
 
-	args->agno = agno;
-	args->agbno = 0;
-
 	error = xfs_alloc_vextent_prepare_ag(args);
 	if (!error && args->agbp)
 		error = xfs_alloc_ag_vextent_size(args);
@@ -3400,16 +3400,15 @@ xfs_alloc_vextent_start_ag(
 	xfs_rfsblock_t		target)
 {
 	struct xfs_mount	*mp = args->mp;
-	xfs_agnumber_t		minimum_agno = 0;
+	xfs_agnumber_t		minimum_agno;
 	xfs_agnumber_t		start_agno;
 	xfs_agnumber_t		rotorstep = xfs_rotorstep;
 	bool			bump_rotor = false;
 	int			error;
 
-	if (args->tp->t_highest_agno != NULLAGNUMBER)
-		minimum_agno = args->tp->t_highest_agno;
-
-	error = xfs_alloc_vextent_check_args(args, target);
+	args->agno = NULLAGNUMBER;
+	args->agbno = NULLAGBLOCK;
+	error = xfs_alloc_vextent_check_args(args, target, &minimum_agno);
 	if (error) {
 		if (error == -ENOSPC)
 			return 0;
@@ -3451,14 +3450,13 @@ xfs_alloc_vextent_first_ag(
 	xfs_rfsblock_t		target)
  {
 	struct xfs_mount	*mp = args->mp;
-	xfs_agnumber_t		minimum_agno = 0;
+	xfs_agnumber_t		minimum_agno;
 	xfs_agnumber_t		start_agno;
 	int			error;
 
-	if (args->tp->t_highest_agno != NULLAGNUMBER)
-		minimum_agno = args->tp->t_highest_agno;
-
-	error = xfs_alloc_vextent_check_args(args, target);
+	args->agno = NULLAGNUMBER;
+	args->agbno = NULLAGBLOCK;
+	error = xfs_alloc_vextent_check_args(args, target, &minimum_agno);
 	if (error) {
 		if (error == -ENOSPC)
 			return 0;
@@ -3481,28 +3479,18 @@ xfs_alloc_vextent_exact_bno(
 	xfs_rfsblock_t		target)
 {
 	struct xfs_mount	*mp = args->mp;
-	xfs_agnumber_t		minimum_agno = 0;
+	xfs_agnumber_t		minimum_agno;
 	int			error;
 
-	if (args->tp->t_highest_agno != NULLAGNUMBER)
-		minimum_agno = args->tp->t_highest_agno;
-
-	error = xfs_alloc_vextent_check_args(args, target);
+	args->agno = XFS_FSB_TO_AGNO(mp, target);
+	args->agbno = XFS_FSB_TO_AGBNO(mp, target);
+	error = xfs_alloc_vextent_check_args(args, target, &minimum_agno);
 	if (error) {
 		if (error == -ENOSPC)
 			return 0;
 		return error;
 	}
 
-	args->agno = XFS_FSB_TO_AGNO(mp, target);
-	if (minimum_agno > args->agno) {
-		trace_xfs_alloc_vextent_skip_deadlock(args);
-		args->fsbno = NULLFSBLOCK;
-		return 0;
-	}
-
-	args->agbno = XFS_FSB_TO_AGBNO(mp, target);
-
 	error = xfs_alloc_vextent_prepare_ag(args);
 	if (!error && args->agbp)
 		error = xfs_alloc_ag_vextent_exact(args);
@@ -3522,32 +3510,22 @@ xfs_alloc_vextent_near_bno(
 	xfs_rfsblock_t		target)
 {
 	struct xfs_mount	*mp = args->mp;
-	xfs_agnumber_t		minimum_agno = 0;
+	xfs_agnumber_t		minimum_agno;
 	bool			needs_perag = args->pag == NULL;
 	int			error;
 
-	if (args->tp->t_highest_agno != NULLAGNUMBER)
-		minimum_agno = args->tp->t_highest_agno;
-
-	error = xfs_alloc_vextent_check_args(args, target);
+	args->agno = XFS_FSB_TO_AGNO(mp, target);
+	args->agbno = XFS_FSB_TO_AGBNO(mp, target);
+	error = xfs_alloc_vextent_check_args(args, target, &minimum_agno);
 	if (error) {
 		if (error == -ENOSPC)
 			return 0;
 		return error;
 	}
 
-	args->agno = XFS_FSB_TO_AGNO(mp, target);
-	if (minimum_agno > args->agno) {
-		trace_xfs_alloc_vextent_skip_deadlock(args);
-		args->fsbno = NULLFSBLOCK;
-		return 0;
-	}
-
 	if (needs_perag)
 		args->pag = xfs_perag_get(mp, args->agno);
 
-	args->agbno = XFS_FSB_TO_AGBNO(mp, target);
-
 	error = xfs_alloc_vextent_prepare_ag(args);
 	if (!error && args->agbp)
 		error = xfs_alloc_ag_vextent_near(args);
-- 
2.39.0

