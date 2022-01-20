Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F605C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:24:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240529AbiATAYJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:24:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345270AbiATAYJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:24:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2DCCC061574
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:24:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52D056150C
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:24:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA89CC004E1;
        Thu, 20 Jan 2022 00:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638247;
        bh=rTgVrWZOtLUovkIrG3Srjb0+iCsMoJi6djpPtRr0Axw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GPw0gUWRBQZeMQKCid1IljDZ+X/WwMloEETGfQATiDi/Cr+1v443+EDkk1ZlYvnfL
         f6+QPVTVV8MtGg+Uxgn8JcRla/tqWLDmUn7KJyTi8jbpKxwAL9G8twR8kFfs22Q3HB
         XSlGyXy3l8eAdXg8yFJB2QpNvq3FkSgbsNZYGsrlWAuEcZror6aNuKXGQBH2lNUjZ1
         uZpFB0ujhsw4Gavni2INTfE9QxVa9Iqo419yt8ZA82A9v+EJV8tbRP9Y3OHDOvr/R+
         9474w7VEZVObd6TdRNOUn4lYkhJOBoBmEnqPgZXQA/BSCb8mdU8uupUfx3DmYFNcx+
         03UvOGtyM3+cg==
Subject: [PATCH 10/48] xfs: rename the next_agno perag iteration variable
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:24:07 -0800
Message-ID: <164263824735.865554.7075356687013149400.stgit@magnolia>
In-Reply-To: <164263819185.865554.6000499997543946756.stgit@magnolia>
References: <164263819185.865554.6000499997543946756.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

Source kernel commit: f1788b5e5ee25bedf00bb4d25f82b93820d61189

Rename the next_agno variable to be consistent across the several
iteration macros and shorten line length.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_ag.h |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)


diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index 95570df0..9cd06694 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
@@ -129,22 +129,22 @@ void xfs_perag_put(struct xfs_perag *pag);
 static inline struct xfs_perag *
 xfs_perag_next(
 	struct xfs_perag	*pag,
-	xfs_agnumber_t		*next_agno)
+	xfs_agnumber_t		*agno)
 {
 	struct xfs_mount	*mp = pag->pag_mount;
 
-	*next_agno = pag->pag_agno + 1;
+	*agno = pag->pag_agno + 1;
 	xfs_perag_put(pag);
-	return xfs_perag_get(mp, *next_agno);
+	return xfs_perag_get(mp, *agno);
 }
 
-#define for_each_perag_range(mp, next_agno, end_agno, pag) \
-	for ((pag) = xfs_perag_get((mp), (next_agno)); \
-		(pag) != NULL && (next_agno) <= (end_agno); \
-		(pag) = xfs_perag_next((pag), &(next_agno)))
+#define for_each_perag_range(mp, agno, end_agno, pag) \
+	for ((pag) = xfs_perag_get((mp), (agno)); \
+		(pag) != NULL && (agno) <= (end_agno); \
+		(pag) = xfs_perag_next((pag), &(agno)))
 
-#define for_each_perag_from(mp, next_agno, pag) \
-	for_each_perag_range((mp), (next_agno), (mp)->m_sb.sb_agcount, (pag))
+#define for_each_perag_from(mp, agno, pag) \
+	for_each_perag_range((mp), (agno), (mp)->m_sb.sb_agcount, (pag))
 
 
 #define for_each_perag(mp, agno, pag) \

