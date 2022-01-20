Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 475BAC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:24:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240596AbiATAYV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:24:21 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47890 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345268AbiATAYV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:24:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE2E4B81A85
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:24:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9868DC004E1;
        Thu, 20 Jan 2022 00:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638258;
        bh=JAec7AUGvrm0SRaNuT9s4Px5J2p9f7Kbr9NsOjvPspE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=pK7seHISgajp349Uu2CgJdi5TJ/EaOyQEnjZL1dnzjtGKxSienDtZ0OuWKNIYHPzc
         reE+rCbc37Z+x2i8Ev0YEawKgsZIPdkM4GVR2sqwKFauL72q3wivDGDR0HD3I1Ja3V
         8CLXJrFouI6HqfoQ14f+cklinmE0+Pr5x17qfyN5LdclFz/Qw4MmylQIfbxhOaFuJT
         Wt52ObRBoedRgV0mOXN5fvrueigsKEna6rDaHg4pOs4RFjKqy+DRHJ0jJ4wNwP2JFA
         ZOvoVJIETeYjXxfTR30BSLak4W6WJeuG/RIykpSvObtU1TDeFdRHOApG/w3JZM/WQW
         T6hoC0tWHLK0g==
Subject: [PATCH 12/48] xfs: fix perag reference leak on iteration race with
 growfs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:24:18 -0800
Message-ID: <164263825835.865554.16091663428028357322.stgit@magnolia>
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

Source kernel commit: 892a666fafa19ab04b5e948f6c92f98f1dafb489

The for_each_perag*() set of macros are hacky in that some (i.e.
those based on sb_agcount) rely on the assumption that perag
iteration terminates naturally with a NULL perag at the specified
end_agno. Others allow for the final AG to have a valid perag and
require the calling function to clean up any potential leftover
xfs_perag reference on termination of the loop.

Aside from providing a subtly inconsistent interface, the former
variant is racy with growfs because growfs can create discoverable
post-eofs perags before the final superblock update that completes
the grow operation and increases sb_agcount. This leads to the
following assert failure (reproduced by xfs/104) in the perag free
path during unmount:

XFS: Assertion failed: atomic_read(&pag->pag_ref) == 0, file: fs/xfs/libxfs/xfs_ag.c, line: 195

This occurs because one of the many for_each_perag() loops in the
code that is expected to terminate with a NULL pag (and thus has no
post-loop xfs_perag_put() check) raced with a growfs and found a
non-NULL post-EOFS perag, but terminated naturally based on the
end_agno check without releasing the post-EOFS perag.

Rework the iteration logic to lift the agno check from the main for
loop conditional to the iteration helper function. The for loop now
purely terminates on a NULL pag and xfs_perag_next() avoids taking a
reference to any perag beyond end_agno in the first place.

Fixes: f250eedcf762 ("xfs: make for_each_perag... a first class citizen")
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_ag.h |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)


diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index fae2a38e..e411d51c 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
@@ -118,30 +118,26 @@ void xfs_perag_put(struct xfs_perag *pag);
 
 /*
  * Perag iteration APIs
- *
- * XXX: for_each_perag_range() usage really needs an iterator to clean up when
- * we terminate at end_agno because we may have taken a reference to the perag
- * beyond end_agno. Right now callers have to be careful to catch and clean that
- * up themselves. This is not necessary for the callers of for_each_perag() and
- * for_each_perag_from() because they terminate at sb_agcount where there are
- * no perag structures in tree beyond end_agno.
  */
 static inline struct xfs_perag *
 xfs_perag_next(
 	struct xfs_perag	*pag,
-	xfs_agnumber_t		*agno)
+	xfs_agnumber_t		*agno,
+	xfs_agnumber_t		end_agno)
 {
 	struct xfs_mount	*mp = pag->pag_mount;
 
 	*agno = pag->pag_agno + 1;
 	xfs_perag_put(pag);
+	if (*agno > end_agno)
+		return NULL;
 	return xfs_perag_get(mp, *agno);
 }
 
 #define for_each_perag_range(mp, agno, end_agno, pag) \
 	for ((pag) = xfs_perag_get((mp), (agno)); \
-		(pag) != NULL && (agno) <= (end_agno); \
-		(pag) = xfs_perag_next((pag), &(agno)))
+		(pag) != NULL; \
+		(pag) = xfs_perag_next((pag), &(agno), (end_agno)))
 
 #define for_each_perag_from(mp, agno, pag) \
 	for_each_perag_range((mp), (agno), (mp)->m_sb.sb_agcount - 1, (pag))

