Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25D8BC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:08:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0AAE1600D4
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:08:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232852AbhIOXKQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:10:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:34460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232828AbhIOXKQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:10:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0B2B610A4;
        Wed, 15 Sep 2021 23:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747337;
        bh=n1njFr/SSgsFf0X/D7xNQuYHtnAJ7fsitwoXobSt1o0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=l+Q9xV/Hv2VqbyYJseWcxIwYsYXLbgL5wX5EqjxeqketFHmMYOTERdquwEZ9PLlW6
         REeBBMsz7OL+IPVWsGEtZMkBOlVbBAASwnB2WQNS252KVIzPYqfl81e6OG2nNMadl+
         3pfAk8PMVDFGc+621BRYcnAwRH+ysZi97E0LRrnxkbVUKkH+f4Uo705+u1sV46PzoK
         VtnXEJOTQJ4Kr9aaN4S1iXK/S7x+UTtwfnSdGoyvH9ZpcU2yjMQfeBnixGydKjsu2l
         MgWOrb3csGmmWi0rWHoueI+O1DXroZpRX9PNw6dnGZ2imxvga8hDPCw/fLXBy8Ng6z
         2pK9/7rTfiYnA==
Subject: [PATCH 26/61] xfs: convert xfs_iwalk to use perag references
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:08:56 -0700
Message-ID: <163174733665.350433.7001697669532798362.stgit@magnolia>
In-Reply-To: <163174719429.350433.8562606396437219220.stgit@magnolia>
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: 6f4118fc6482b1989cdcb19a1a0ab53b2dca7ab9

Rather than manually walking the ags and passing agnunbers around,
pass the perag for the AG we are currently working on around in the
iwalk structure.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_ag.h |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)


diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index 8f26a7b1..052f5ff4 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
@@ -117,19 +117,23 @@ void	xfs_perag_put(struct xfs_perag *pag);
 /*
  * Perag iteration APIs
  */
-#define for_each_perag(mp, next_agno, pag) \
-	for ((next_agno) = 0, (pag) = xfs_perag_get((mp), 0); \
+#define for_each_perag_from(mp, next_agno, pag) \
+	for ((pag) = xfs_perag_get((mp), (next_agno)); \
 		(pag) != NULL; \
 		(next_agno) = (pag)->pag_agno + 1, \
 		xfs_perag_put(pag), \
 		(pag) = xfs_perag_get((mp), (next_agno)))
 
-#define for_each_perag_tag(mp, next_agno, pag, tag) \
-	for ((next_agno) = 0, (pag) = xfs_perag_get_tag((mp), 0, (tag)); \
+#define for_each_perag(mp, agno, pag) \
+	(agno) = 0; \
+	for_each_perag_from((mp), (agno), (pag))
+
+#define for_each_perag_tag(mp, agno, pag, tag) \
+	for ((agno) = 0, (pag) = xfs_perag_get_tag((mp), 0, (tag)); \
 		(pag) != NULL; \
-		(next_agno) = (pag)->pag_agno + 1, \
+		(agno) = (pag)->pag_agno + 1, \
 		xfs_perag_put(pag), \
-		(pag) = xfs_perag_get_tag((mp), (next_agno), (tag)))
+		(pag) = xfs_perag_get_tag((mp), (agno), (tag)))
 
 struct aghdr_init_data {
 	/* per ag data */

