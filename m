Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC32CC32793
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 22:45:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbjARWpS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 17:45:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjARWpO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 17:45:14 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 265E35F38D
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:45:14 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id s67so109150pgs.3
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:45:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ov9bhFS8pKfhJk0aMdPqZ2dmp6OGyvqPU45nRBLq+DI=;
        b=yPy776//fUVAjqeRkLrLGlGkqQnr38nEKbARglJymHm7DYOGD/JH0tJqqVV8DeTCf8
         GY8P3KSH13quVZvBeNOrbdn03cBU0WwqeNT2X5gWb7hzIhRdev+/PbSpRyOiNxEFUfFI
         nJLNjpnQoJZpWekl0G/EGq2+DNsW/W/xO0PXZyjHxBCQy42AmSeOx7mhvt4aPlp9V2bT
         D1vO6b/ke+G2gmvFnfSTb47tVr6gFs+0vfMiKYw/zKKohpxCnXu6q8DJVQPNHtN4JMek
         7f84XRJFRgXFYw7xzBXXFYm7ARzN4TLEfxObwWJ+d718jmijXhOkj3FYHWiO/RFltTx8
         qnFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ov9bhFS8pKfhJk0aMdPqZ2dmp6OGyvqPU45nRBLq+DI=;
        b=1XNRQWKVpr4BCew1qFRNj3JDBQGQgcA5fEnJLbBhT9wZCEWR5UwIUo7iQ94+wqTsU/
         p/0uh7fPx6SRTq6OBu/R0BLNDZgo9of0XA7FXjjHsLdDX3mc1spi8HgV2aZtvb9Hpx5E
         t3os4MDKnqXYVcZugxMr5iqDI3dYbRMSGq+Yhehz52k8JxTtF5w0QBu/WahMYhzbisx9
         3+WLCq5HAlWJbhrgfLYSQHwr8YobKQGhAhDB28ZGrotN5pSp/Uta3G2NRMnjQJSEtjuw
         ccVnY/t783uYfMKQclbygpo+jWZa421Ads8X0G6klwhvKjRj8QPGeDpg4UNY0C5Kn5C2
         xFxw==
X-Gm-Message-State: AFqh2kqEN0KqUsdKyG6pHwMHU27MA1ly1XoVWJxU7n8Hp2g9uXmXawzF
        L8wxUcUO5RE3cSyMOHEphjpRWBSbuS9EOVq3
X-Google-Smtp-Source: AMrXdXt8BDy+8UDLFXUQQlVOKavTbWibM/MSpg2d2sYXiLZUO249kp4vnf8P0XmKOoA5Y+WyrRNu6Q==
X-Received: by 2002:a05:6a00:d5e:b0:589:a782:470c with SMTP id n30-20020a056a000d5e00b00589a782470cmr26019719pfv.2.1674081913697;
        Wed, 18 Jan 2023 14:45:13 -0800 (PST)
Received: from dread.disaster.area (pa49-186-146-207.pa.vic.optusnet.com.au. [49.186.146.207])
        by smtp.gmail.com with ESMTPSA id v15-20020aa799cf000000b0056bc5ad4862sm14277283pfi.28.2023.01.18.14.45.13
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 14:45:13 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pIHB9-004iXM-7y
        for linux-xfs@vger.kernel.org; Thu, 19 Jan 2023 09:45:11 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pIHB9-008FDn-0o
        for linux-xfs@vger.kernel.org;
        Thu, 19 Jan 2023 09:45:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 16/42] xfs: factor xfs_alloc_vextent_this_ag() for  _iterate_ags()
Date:   Thu, 19 Jan 2023 09:44:39 +1100
Message-Id: <20230118224505.1964941-17-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118224505.1964941-1-david@fromorbit.com>
References: <20230118224505.1964941-1-david@fromorbit.com>
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
---
 fs/xfs/libxfs/xfs_alloc.c | 50 ++++++++++++++++++++-------------------
 1 file changed, 26 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 39e34a1bfa31..2dec95f35562 100644
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

