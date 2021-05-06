Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08F6FC4361B
	for <linux-xfs@archiver.kernel.org>; Thu,  6 May 2021 07:21:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D03C561077
	for <linux-xfs@archiver.kernel.org>; Thu,  6 May 2021 07:21:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233389AbhEFHWG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 May 2021 03:22:06 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:57938 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233383AbhEFHWB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 May 2021 03:22:01 -0400
Received: from dread.disaster.area (pa49-179-143-157.pa.nsw.optusnet.com.au [49.179.143.157])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 3718D37E1
        for <linux-xfs@vger.kernel.org>; Thu,  6 May 2021 17:20:57 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1leYJc-005loc-OH
        for linux-xfs@vger.kernel.org; Thu, 06 May 2021 17:20:56 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1leYJc-00197w-Fs
        for linux-xfs@vger.kernel.org; Thu, 06 May 2021 17:20:56 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 20/22] xfs: inode allocation can use a single perag instance
Date:   Thu,  6 May 2021 17:20:52 +1000
Message-Id: <20210506072054.271157-21-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210506072054.271157-1-david@fromorbit.com>
References: <20210506072054.271157-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=I9rzhn+0hBG9LkCzAun3+g==:117 a=I9rzhn+0hBG9LkCzAun3+g==:17
        a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=PVd9y4yBuWbgVO6N8hQA:9
        a=7Zwj6sZBwVKJAoWSPKxL6X1jA+E=:19
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Now that we've internalised the two-phase inode allocation, we can
now easily make the AG selection and allocation atomic from the
perspective of a single perag context. This will ensure AGs going
offline/away cannot occur between the selection and allocation
steps.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 2c0ef2dd46d9..d749bb7c7a69 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1432,6 +1432,7 @@ int
 xfs_dialloc_ag(
 	struct xfs_trans	*tp,
 	struct xfs_buf		*agbp,
+	struct xfs_perag	*pag,
 	xfs_ino_t		parent,
 	xfs_ino_t		*inop)
 {
@@ -1446,7 +1447,6 @@ xfs_dialloc_ag(
 	int				error;
 	int				offset;
 	int				i;
-	struct xfs_perag		*pag = agbp->b_pag;
 
 	if (!xfs_sb_version_hasfinobt(&mp->m_sb))
 		return xfs_dialloc_ag_inobt(tp, agbp, pag, parent, inop);
@@ -1761,9 +1761,9 @@ xfs_dialloc(
 	xfs_perag_put(pag);
 	return error ? error : -ENOSPC;
 found_ag:
-	xfs_perag_put(pag);
 	/* Allocate an inode in the found AG */
-	error = xfs_dialloc_ag(*tpp, agbp, parent, &ino);
+	error = xfs_dialloc_ag(*tpp, agbp, pag, parent, &ino);
+	xfs_perag_put(pag);
 	if (error)
 		return error;
 	*new_ino = ino;
-- 
2.31.1

