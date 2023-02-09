Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28BE4C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 22:26:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbjBIW0m (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 17:26:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbjBIW0l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 17:26:41 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD8166BA82
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 14:26:37 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id ea13so2300099pfb.13
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 14:26:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VgH3sUFvzuRr1FZQ4Xh2YQhn6u0DFL7SR30vhXFDTiI=;
        b=eoBOC6tYT4S9rCF036m8sdLQX42WE6GrRAKVr6y5YiK0lwuJ8p0MIpn8aDNE6+Xq8x
         k4GlUmz+Zhy6fIYxAtZQr8hCiNgzF+Xbj2vqOK4xjEPMfB77+cuHOoXeXUYgSwifwjfg
         OAi1vZa7YgvRCWWH0oJIDM2mHZ/VLt0wLGaO+7WZu3klsYWAnnpqaEDeBc1u8+gIXYL3
         q4WFw4nx+/l4PY2QOiaqDmM2mIBFf/5h5/a/AmjF8O8fi7CBXxw2vJFao+4yjwG1yKgM
         EqwX9gDQMaL2ihBq1SqBGW5MGxYE8XS2Ct6EswnCWKrfYyJwY0Hb/Av6nzZdZQTX4WuC
         ITbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VgH3sUFvzuRr1FZQ4Xh2YQhn6u0DFL7SR30vhXFDTiI=;
        b=osd5VAgCZCFsGpIAznRK/nOqBt8fUIBsx87lln15UfDcoKy0KWZ3C5i9GgMSY/G3bp
         Cq3eLKo0H7g9tjaZLR7j4wXjcianjJwMDHL7k+WRFzEA82OGW8hNTZ3NjEAtDWfF0Voz
         oPFcxheUt5r11rfC+HVabyJkWg2s/CIOFL5Ir9wi+u6+tPcSCZvcbLwzbR9CBVxquDHs
         uKXNX2eurXwibPlLFG8/ZfpETk/GgwTSBdqTwWwjkCpk/9fDQ+aJKN2lWuCFMYf7MDT8
         XC30y5j2osVTyx8WY5nd0ydarAY7Db1UXw04vIKyf0Kh+5y1YvlLjBkCWStgFzTAj1gL
         hecg==
X-Gm-Message-State: AO0yUKUOEhmPQAC5AUc7e8SRUlRNLxK/MVlHj/kfizxfCHYPOcg1tb7x
        QnV+H4x0sHsyTmME/uwXLuVKfNpsm1bowYfu
X-Google-Smtp-Source: AK7set+mBpiVIuBOGUiS1sO90+JSQQcIuuIHS2EOo3RCjZARt+NlYJFZJB3JMestgG+pNhtDD03Ajw==
X-Received: by 2002:a62:8407:0:b0:580:d71e:a2e5 with SMTP id k7-20020a628407000000b00580d71ea2e5mr11291664pfd.22.1675981597233;
        Thu, 09 Feb 2023 14:26:37 -0800 (PST)
Received: from dread.disaster.area (pa49-181-4-128.pa.nsw.optusnet.com.au. [49.181.4.128])
        by smtp.gmail.com with ESMTPSA id m6-20020aa78a06000000b005772d55df03sm1955381pfa.35.2023.02.09.14.26.36
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 14:26:36 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pQFFM-00DOVv-JQ
        for linux-xfs@vger.kernel.org; Fri, 10 Feb 2023 09:18:28 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pQFFM-00FcO5-1u
        for linux-xfs@vger.kernel.org;
        Fri, 10 Feb 2023 09:18:28 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 27/42] xfs: move the minimum agno checks into xfs_alloc_vextent_check_args
Date:   Fri, 10 Feb 2023 09:18:10 +1100
Message-Id: <20230209221825.3722244-28-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209221825.3722244-1-david@fromorbit.com>
References: <20230209221825.3722244-1-david@fromorbit.com>
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
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c | 94 +++++++++++++++------------------------
 1 file changed, 36 insertions(+), 58 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 50eb44851f23..94cea96caf5d 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3089,14 +3089,18 @@ xfs_alloc_read_agf(
 static int
 xfs_alloc_vextent_check_args(
 	struct xfs_alloc_arg	*args,
-	xfs_fsblock_t		target)
+	xfs_fsblock_t		target,
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
@@ -3266,27 +3275,18 @@ xfs_alloc_vextent_this_ag(
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
-	if (error) {
-		if (error == -ENOSPC)
-			return 0;
-		return error;
-	}
-
 	args->agno = agno;
 	args->agbno = 0;
+	error = xfs_alloc_vextent_check_args(args, XFS_AGB_TO_FSB(mp, agno, 0),
+			&minimum_agno);
+	if (error) {
+		if (error == -ENOSPC)
+			return 0;
+		return error;
+	}
 
 	error = xfs_alloc_vextent_prepare_ag(args);
 	if (!error && args->agbp)
@@ -3400,16 +3400,15 @@ xfs_alloc_vextent_start_ag(
 	xfs_fsblock_t		target)
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
 	xfs_fsblock_t		target)
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
 	xfs_fsblock_t		target)
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
 	xfs_fsblock_t		target)
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

