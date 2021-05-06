Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CED6C43603
	for <linux-xfs@archiver.kernel.org>; Thu,  6 May 2021 07:21:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BCD4613DD
	for <linux-xfs@archiver.kernel.org>; Thu,  6 May 2021 07:21:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233408AbhEFHV7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 May 2021 03:21:59 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:50426 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233281AbhEFHV6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 May 2021 03:21:58 -0400
Received: from dread.disaster.area (pa49-179-143-157.pa.nsw.optusnet.com.au [49.179.143.157])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 137A510A785
        for <linux-xfs@vger.kernel.org>; Thu,  6 May 2021 17:20:57 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1leYJc-005lny-4u
        for linux-xfs@vger.kernel.org; Thu, 06 May 2021 17:20:56 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1leYJb-00197J-TU
        for linux-xfs@vger.kernel.org; Thu, 06 May 2021 17:20:55 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 07/22] xfs: convert secondary superblock walk to use perags
Date:   Thu,  6 May 2021 17:20:39 +1000
Message-Id: <20210506072054.271157-8-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210506072054.271157-1-david@fromorbit.com>
References: <20210506072054.271157-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=I9rzhn+0hBG9LkCzAun3+g==:117 a=I9rzhn+0hBG9LkCzAun3+g==:17
        a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=RuY9LHvN9V0gqSKNSQYA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Clean up the last external manual AG walk.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_sb.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index cbcfce8cebf1..7d4c238540d4 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -25,6 +25,7 @@
 #include "xfs_refcount_btree.h"
 #include "xfs_da_format.h"
 #include "xfs_health.h"
+#include "xfs_ag.h"
 
 /*
  * Physical superblock buffer manipulations. Shared with libxfs in userspace.
@@ -856,17 +857,18 @@ int
 xfs_update_secondary_sbs(
 	struct xfs_mount	*mp)
 {
-	xfs_agnumber_t		agno;
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno = 1;
 	int			saved_error = 0;
 	int			error = 0;
 	LIST_HEAD		(buffer_list);
 
 	/* update secondary superblocks. */
-	for (agno = 1; agno < mp->m_sb.sb_agcount; agno++) {
+	for_each_perag_from(mp, agno, pag) {
 		struct xfs_buf		*bp;
 
 		error = xfs_buf_get(mp->m_ddev_targp,
-				 XFS_AG_DADDR(mp, agno, XFS_SB_DADDR),
+				 XFS_AG_DADDR(mp, pag->pag_agno, XFS_SB_DADDR),
 				 XFS_FSS_TO_BB(mp, 1), &bp);
 		/*
 		 * If we get an error reading or writing alternate superblocks,
@@ -878,7 +880,7 @@ xfs_update_secondary_sbs(
 		if (error) {
 			xfs_warn(mp,
 		"error allocating secondary superblock for ag %d",
-				agno);
+				pag->pag_agno);
 			if (!saved_error)
 				saved_error = error;
 			continue;
@@ -899,7 +901,7 @@ xfs_update_secondary_sbs(
 		if (error) {
 			xfs_warn(mp,
 		"write error %d updating a secondary superblock near ag %d",
-				error, agno);
+				error, pag->pag_agno);
 			if (!saved_error)
 				saved_error = error;
 			continue;
-- 
2.31.1

