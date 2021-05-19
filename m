Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA418C4360C
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 01:21:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA93061369
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 01:21:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231924AbhESBW2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 May 2021 21:22:28 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:58862 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232046AbhESBWZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 May 2021 21:22:25 -0400
Received: from dread.disaster.area (pa49-195-118-180.pa.nsw.optusnet.com.au [49.195.118.180])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 7D24B80B19B
        for <linux-xfs@vger.kernel.org>; Wed, 19 May 2021 11:21:04 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ljAtU-002bOo-2z
        for linux-xfs@vger.kernel.org; Wed, 19 May 2021 11:21:04 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1ljAtT-001tKi-RB
        for linux-xfs@vger.kernel.org; Wed, 19 May 2021 11:21:03 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 20/23] xfs: inode allocation can use a single perag instance
Date:   Wed, 19 May 2021 11:20:59 +1000
Message-Id: <20210519012102.450926-21-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519012102.450926-1-david@fromorbit.com>
References: <20210519012102.450926-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=xcwBwyABtj18PbVNKPPJDQ==:117 a=xcwBwyABtj18PbVNKPPJDQ==:17
        a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=NAOyA5QPs9IPWwe0BV0A:9 a=7Zwj6sZBwVKJAoWSPKxL6X1jA+E=:19
        a=AjGcO6oz07-iQ99wixmX:22
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
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ialloc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 8762836d0996..88c15d8bd6e4 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1432,6 +1432,7 @@ static int
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
@@ -1760,9 +1760,9 @@ xfs_dialloc(
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

