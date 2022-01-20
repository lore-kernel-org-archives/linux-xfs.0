Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA4FAC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:24:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234599AbiATAYF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:24:05 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47804 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345222AbiATAYE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:24:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5FAE2B81AD5
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:24:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A60DC004E1;
        Thu, 20 Jan 2022 00:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638242;
        bh=MtsU0qxh8RAaQl3qgouNWvDMiIp0ssPAgnX+F8hw5IQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=c7poxNPNRd8LLmt6dgsMaHwX7UZBzthi/voav2ywa08ik29Vg5qpl4xA5ddgiVCZv
         jeUZtL14vbDQUEKaO+6zmxhowhEwChcKIVVGtMFaoR56TROzQmPismTughqYRAecUf
         oNbo9IMqDlNIHCvIwyMiEhhGpUgqSzeM5/2hpMr95YnGTZ3Wd/3+kDCgzjfSVRGq/h
         XQZz9D5R1K9laX2oHm4IQ13cK8fbw1M/1WO3qLSmeqGhaZZZ9yKUbT+Vpwp/Gltily
         +nyRS4n+JEqOeNmFRYH41oniShGYCiBltxEgyI1hGMuohJZ18rN73Gb385Jp0HisZv
         zUhXoPtG2YUkQ==
Subject: [PATCH 09/48] xfs: fold perag loop iteration logic into helper
 function
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:24:01 -0800
Message-ID: <164263824189.865554.51073696809603760.stgit@magnolia>
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

Source kernel commit: bf2307b195135ed9c95eebb38920d8bd41843092

Fold the loop iteration logic into a helper in preparation for
further fixups. No functional change in this patch.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_ag.h |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index 2522f766..95570df0 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
@@ -126,12 +126,22 @@ void xfs_perag_put(struct xfs_perag *pag);
  * for_each_perag_from() because they terminate at sb_agcount where there are
  * no perag structures in tree beyond end_agno.
  */
+static inline struct xfs_perag *
+xfs_perag_next(
+	struct xfs_perag	*pag,
+	xfs_agnumber_t		*next_agno)
+{
+	struct xfs_mount	*mp = pag->pag_mount;
+
+	*next_agno = pag->pag_agno + 1;
+	xfs_perag_put(pag);
+	return xfs_perag_get(mp, *next_agno);
+}
+
 #define for_each_perag_range(mp, next_agno, end_agno, pag) \
 	for ((pag) = xfs_perag_get((mp), (next_agno)); \
 		(pag) != NULL && (next_agno) <= (end_agno); \
-		(next_agno) = (pag)->pag_agno + 1, \
-		xfs_perag_put(pag), \
-		(pag) = xfs_perag_get((mp), (next_agno)))
+		(pag) = xfs_perag_next((pag), &(next_agno)))
 
 #define for_each_perag_from(mp, next_agno, pag) \
 	for_each_perag_range((mp), (next_agno), (mp)->m_sb.sb_agcount, (pag))

