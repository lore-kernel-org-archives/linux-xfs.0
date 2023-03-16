Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82952C7618B
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 16:47:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjCPQrt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 12:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjCPQrs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 12:47:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BF49DFB75
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 09:47:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3A1CB8228C
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 16:47:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E072C433D2;
        Thu, 16 Mar 2023 16:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678985263;
        bh=CFe3YsYUO545URGjypw0WMV+8HqeRtvDUk/EEwRZl3A=;
        h=Date:From:To:Cc:Subject:From;
        b=bSbqfA91mI5by7PQUowrtRpRIkoesJck+u9k1C5ES8C+Ar61PwNpZzIer3DnQFYmZ
         O3Bgzr80KezdNopeM5M8D+mDZiG1jjCmdfrQVctknxF8qh4KHUCDaCcBZTq3m2e/nY
         dqIt3igGbKZIVby+A+7kiCwCIPHxKvqKJJlOcbhoaxuzV6GDqhFtnGjbPQYEWUb2nx
         iWZ/1IA2LxS2smKmAZCSeIcdguRPyNowDPXfMHqISWqRur/kHnEQ9sQwwjpBeC+X3B
         ijiCvmZyiyOsZJfcFwEg2R3xcGS4wLCjCprfs0WEiFMCSMOXTeGTrff9+DWroLxJrM
         HMQy1xYhmiG1w==
Date:   Thu, 16 Mar 2023 09:47:43 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: add tracepoints for each of the externally visible
 allocators
Message-ID: <20230316164743.GL11376@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

There are now five separate space allocator interfaces exposed to the
rest of XFS for five different strategies to find space.  Add
tracepoints for each of them so that I can tell from a trace dump
exactly which ones got called and what happened underneath them.  Add a
sixth so it's more obvious if an allocation actually happened.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c |   17 +++++++++++++++++
 fs/xfs/xfs_trace.h        |    7 +++++++
 2 files changed, 24 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index bd7112d430b6..55ae08a6144c 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3255,6 +3255,8 @@ xfs_alloc_vextent_finish(
 	XFS_STATS_INC(mp, xs_allocx);
 	XFS_STATS_ADD(mp, xs_allocb, args->len);
 
+	trace_xfs_alloc_vextent_finish(args);
+
 out_drop_perag:
 	if (drop_perag && args->pag) {
 		xfs_perag_rele(args->pag);
@@ -3284,6 +3286,9 @@ xfs_alloc_vextent_this_ag(
 
 	args->agno = agno;
 	args->agbno = 0;
+
+	trace_xfs_alloc_vextent_this_ag(args);
+
 	error = xfs_alloc_vextent_check_args(args, XFS_AGB_TO_FSB(mp, agno, 0),
 			&minimum_agno);
 	if (error) {
@@ -3405,6 +3410,9 @@ xfs_alloc_vextent_start_ag(
 
 	args->agno = NULLAGNUMBER;
 	args->agbno = NULLAGBLOCK;
+
+	trace_xfs_alloc_vextent_first_ag(args);
+
 	error = xfs_alloc_vextent_check_args(args, target, &minimum_agno);
 	if (error) {
 		if (error == -ENOSPC)
@@ -3455,6 +3463,9 @@ xfs_alloc_vextent_first_ag(
 
 	args->agno = NULLAGNUMBER;
 	args->agbno = NULLAGBLOCK;
+
+	trace_xfs_alloc_vextent_start_ag(args);
+
 	error = xfs_alloc_vextent_check_args(args, target, &minimum_agno);
 	if (error) {
 		if (error == -ENOSPC)
@@ -3486,6 +3497,9 @@ xfs_alloc_vextent_exact_bno(
 
 	args->agno = XFS_FSB_TO_AGNO(mp, target);
 	args->agbno = XFS_FSB_TO_AGBNO(mp, target);
+
+	trace_xfs_alloc_vextent_near_bno(args);
+
 	error = xfs_alloc_vextent_check_args(args, target, &minimum_agno);
 	if (error) {
 		if (error == -ENOSPC)
@@ -3521,6 +3535,9 @@ xfs_alloc_vextent_near_bno(
 
 	args->agno = XFS_FSB_TO_AGNO(mp, target);
 	args->agbno = XFS_FSB_TO_AGBNO(mp, target);
+
+	trace_xfs_alloc_vextent_exact_bno(args);
+
 	error = xfs_alloc_vextent_check_args(args, target, &minimum_agno);
 	if (error) {
 		if (error == -ENOSPC)
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 7dc0fd6a6504..9c0006c55fec 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1883,6 +1883,13 @@ DEFINE_ALLOC_EVENT(xfs_alloc_vextent_noagbp);
 DEFINE_ALLOC_EVENT(xfs_alloc_vextent_loopfailed);
 DEFINE_ALLOC_EVENT(xfs_alloc_vextent_allfailed);
 
+DEFINE_ALLOC_EVENT(xfs_alloc_vextent_this_ag);
+DEFINE_ALLOC_EVENT(xfs_alloc_vextent_start_ag);
+DEFINE_ALLOC_EVENT(xfs_alloc_vextent_first_ag);
+DEFINE_ALLOC_EVENT(xfs_alloc_vextent_exact_bno);
+DEFINE_ALLOC_EVENT(xfs_alloc_vextent_near_bno);
+DEFINE_ALLOC_EVENT(xfs_alloc_vextent_finish);
+
 TRACE_EVENT(xfs_alloc_cur_check,
 	TP_PROTO(struct xfs_mount *mp, xfs_btnum_t btnum, xfs_agblock_t bno,
 		 xfs_extlen_t len, xfs_extlen_t diff, bool new),
