Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37969C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 22:18:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbjBIWS5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 17:18:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbjBIWSj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 17:18:39 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62BCF68AEB
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 14:18:37 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id z1so4525249plg.6
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 14:18:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bsG57kQY0rNm/TbgUZSy9nfQBGGzaK4U5L8IbHZUFE0=;
        b=puPneiHPjlF3D+zq3ih/+xE7NgVGNbZ0JitwCIXg5E2ut6vBpzk4tAJoiT4J9dno35
         G1VAz5QersoqKTUepNQvZF7uf2UVvKVkIhMELdtR1su8qgOneSQrkcZn/yW6VUDVhNss
         hvymwrHq6VMRH0f1mIuOU2c5ZOPdTdQESQE6OkMpq1s9nZC3TiJwEO4CHhW511TM2TdA
         J6qFUVoMYmNLlo7ldS3V3RqPtBiws+ZzU1HdVWW59zKO9WzpU5sHuCaJfRwUxcqTWqlc
         NHfp4pLVTpt5t05YSfhUsZliN45TzXQvb5fys46qiaXkQGn4xQJmtaFMtVOOCGyucloL
         c12g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bsG57kQY0rNm/TbgUZSy9nfQBGGzaK4U5L8IbHZUFE0=;
        b=tN/kjE5ryPT0IbMHF9l1UNeAHwbzK0HZynMN3KD+2l5pIElpTCo+0X3EY0K9RCCb0V
         GMXi94ssoJ0eVB8hPNV42l8XCZ9wrKHVmy5K04gqnG+ssv2b6p/yUzsD2tLL+nTTUeK6
         FrS6EHl+dM6vjcCR8lMHUL6xsORXoFeyfnkPSs9Fw4jzIqk8DJbItVC069gykqAKTjY6
         3ZRRiXq6LMBOr4OXmua6dfhzA4Yyz3Xt0aQFfUhI36nyvOM7XhXaKTw///4bzGjLTP6i
         yjLXPyCOgDNiqKO/Uh5PysHxl4RGUxp8CXLni0WDMICM7zE9j0mvB/WEjrhUuwSj4Aa8
         iXTw==
X-Gm-Message-State: AO0yUKWUDA/j4mPuR6xoesEAuKZX5OjEGY0aIENCAKZyg/mIJP2LN7qA
        XHewNrkH+6VOlzllCs9Cfls2sI5NJUnZpvsQ
X-Google-Smtp-Source: AK7set9sbSlZ8GABO0kX382uX2VzL0oSteco//iOVRqMmwgPtEt2I6w7zETWxULvotdcRXte78A/pg==
X-Received: by 2002:a17:90b:4f4d:b0:22c:7e4d:caeb with SMTP id pj13-20020a17090b4f4d00b0022c7e4dcaebmr13975901pjb.22.1675981116810;
        Thu, 09 Feb 2023 14:18:36 -0800 (PST)
Received: from dread.disaster.area (pa49-181-4-128.pa.nsw.optusnet.com.au. [49.181.4.128])
        by smtp.gmail.com with ESMTPSA id r6-20020a17090b050600b00230cbb4b6e8sm1849097pjz.24.2023.02.09.14.18.35
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 14:18:36 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pQFFM-00DOVI-9I
        for linux-xfs@vger.kernel.org; Fri, 10 Feb 2023 09:18:28 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pQFFM-00FcNC-0t
        for linux-xfs@vger.kernel.org;
        Fri, 10 Feb 2023 09:18:28 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 16/42] xfs: factor xfs_alloc_vextent_this_ag() for  _iterate_ags()
Date:   Fri, 10 Feb 2023 09:17:59 +1100
Message-Id: <20230209221825.3722244-17-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209221825.3722244-1-david@fromorbit.com>
References: <20230209221825.3722244-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The core of the per-ag iteration is effectively doing a "this ag"
allocation on one AG at a time. Use the same code to implement the
core "this ag" allocation in both xfs_alloc_vextent_this_ag()
and xfs_alloc_vextent_iterate_ags().

This means we only call xfs_alloc_ag_vextent() from one place so we
can easily collapse the call stack in future patches.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c | 50 ++++++++++++++++++++-------------------
 1 file changed, 26 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 5afda109aaef..98defd19e09e 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3244,6 +3244,28 @@ xfs_alloc_vextent_set_fsbno(
 /*
  * Allocate within a single AG only.
  */
+static int
+__xfs_alloc_vextent_this_ag(
+	struct xfs_alloc_arg	*args)
+{
+	struct xfs_mount	*mp = args->mp;
+	int			error;
+
+	error = xfs_alloc_fix_freelist(args, 0);
+	if (error) {
+		trace_xfs_alloc_vextent_nofix(args);
+		return error;
+	}
+	if (!args->agbp) {
+		/* cannot allocate in this AG at all */
+		trace_xfs_alloc_vextent_noagbp(args);
+		args->agbno = NULLAGBLOCK;
+		return 0;
+	}
+	args->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);
+	return xfs_alloc_ag_vextent(args);
+}
+
 static int
 xfs_alloc_vextent_this_ag(
 	struct xfs_alloc_arg	*args,
@@ -3267,21 +3289,9 @@ xfs_alloc_vextent_this_ag(
 	}
 
 	args->pag = xfs_perag_get(mp, args->agno);
-	error = xfs_alloc_fix_freelist(args, 0);
-	if (error) {
-		trace_xfs_alloc_vextent_nofix(args);
-		goto out_error;
-	}
-	if (!args->agbp) {
-		trace_xfs_alloc_vextent_noagbp(args);
-		args->fsbno = NULLFSBLOCK;
-		goto out_error;
-	}
-	args->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);
-	error = xfs_alloc_ag_vextent(args);
+	error = __xfs_alloc_vextent_this_ag(args);
 
 	xfs_alloc_vextent_set_fsbno(args, minimum_agno);
-out_error:
 	xfs_perag_put(args->pag);
 	return error;
 }
@@ -3319,24 +3329,16 @@ xfs_alloc_vextent_iterate_ags(
 	args->agno = start_agno;
 	for (;;) {
 		args->pag = xfs_perag_get(mp, args->agno);
-		error = xfs_alloc_fix_freelist(args, flags);
+		error = __xfs_alloc_vextent_this_ag(args);
 		if (error) {
-			trace_xfs_alloc_vextent_nofix(args);
+			args->agbno = NULLAGBLOCK;
 			break;
 		}
-		/*
-		 * If we get a buffer back then the allocation will fly.
-		 */
-		if (args->agbp) {
-			error = xfs_alloc_ag_vextent(args);
+		if (args->agbp)
 			break;
-		}
 
 		trace_xfs_alloc_vextent_loopfailed(args);
 
-		/*
-		 * Didn't work, figure out the next iteration.
-		 */
 		if (args->agno == start_agno &&
 		    args->otype == XFS_ALLOCTYPE_START_BNO)
 			args->type = XFS_ALLOCTYPE_THIS_AG;
-- 
2.39.0

