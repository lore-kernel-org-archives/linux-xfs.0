Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04CE6C43334
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 01:27:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239210AbiFKB1h (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jun 2022 21:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348986AbiFKB1V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jun 2022 21:27:21 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2671C3A4820
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jun 2022 18:27:17 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 7BD755EC7FA
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 11:27:05 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu4-005AQ9-Cu
        for linux-xfs@vger.kernel.org; Sat, 11 Jun 2022 11:27:04 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu4-00ELO2-Ba
        for linux-xfs@vger.kernel.org;
        Sat, 11 Jun 2022 11:27:04 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 43/50] xfs: remove xfs_filestream_select_ag() longest extent check
Date:   Sat, 11 Jun 2022 11:26:52 +1000
Message-Id: <20220611012659.3418072-44-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220611012659.3418072-1-david@fromorbit.com>
References: <20220611012659.3418072-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62a3ef69
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=P9eyHUEY7nqEdYE7ebEA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Picking a new AG checks the longest free extent in the AG is valid,
so there's no need to repeat the check in
xfs_filestream_select_ag(). Remove it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_filestream.c | 22 +++-------------------
 1 file changed, 3 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index 4c0392dedeb9..d251f78ffc95 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -341,32 +341,16 @@ xfs_filestream_select_ag(
 		goto out_error;
 	if (agno == NULLAGNUMBER) {
 		agno = 0;
-		goto out_irele;
-	}
-
-	pag = xfs_perag_grab(mp, agno);
-	if (!pag)
-		goto out_irele;
-
-	error = xfs_bmap_longest_free_extent(pag, args->tp, blen);
-	xfs_perag_rele(pag);
-	if (error) {
-		if (error != -EAGAIN)
-			goto out_error;
 		*blen = 0;
 	}
 
-out_irele:
-	if (mru)
-		xfs_fstrm_free_func(mp, mru);
-	xfs_irele(pip);
-out_select:
-	ap->blkno = XFS_AGB_TO_FSB(mp, agno, 0);
-	return 0;
 out_error:
 	if (mru)
 		xfs_fstrm_free_func(mp, mru);
 	xfs_irele(pip);
+out_select:
+	if (!error)
+		ap->blkno = XFS_AGB_TO_FSB(mp, agno, 0);
 	return error;
 
 }
-- 
2.35.1

