Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FF38C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:09:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE0A26112E
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:09:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231782AbhIOXKi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:10:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:34922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231197AbhIOXKi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:10:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADA04610A6;
        Wed, 15 Sep 2021 23:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747358;
        bh=TRV28ApFYh85uyo7F2BFHOvyItV+xYPhcvoDqu6Tc7I=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Whc+WWoL68jRh3hlcRESTQSpAv60XX57fxKsbTjbEAHncX3VIM8ape5iICptrFjmX
         bCq/L5rJqzVgyyHfgPQ5XzkjuXgjP3aAF7ifnwL6YmH7uy3+v75Rnkm0SajaRHDO6g
         SC4AD2O+7A/65B9kqb/4TqMTrlNV05h7FnLFS7lY5BBqFojPKg3ckBs917oElOvf76
         B8nnHIIg4Koq7UFyUkCKSz092Jq+Iz0spq1837hSVmL+XtRmbmCtCxxWxacUuuSVCR
         zq0iX3+m28WPDVeIYR2iSeNjLIYLkz2Jyb7HK9s90/U0XN5F39WrGbkjbTCk0UnJvO
         lVqpmowermD1Q==
Subject: [PATCH 30/61] xfs: pass perags around in fsmap data dev functions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:09:18 -0700
Message-ID: <163174735846.350433.16083642407020794107.stgit@magnolia>
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

Source kernel commit: 58d43a7e3263766ade4974c86118e6b5737ea259

Needs a [from, to] ranged AG walk, and the perag to be stuffed into
the info structure for callouts to use.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_ag.h |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index 052f5ff4..fa58a45f 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
@@ -116,14 +116,25 @@ void	xfs_perag_put(struct xfs_perag *pag);
 
 /*
  * Perag iteration APIs
+ *
+ * XXX: for_each_perag_range() usage really needs an iterator to clean up when
+ * we terminate at end_agno because we may have taken a reference to the perag
+ * beyond end_agno. Right now callers have to be careful to catch and clean that
+ * up themselves. This is not necessary for the callers of for_each_perag() and
+ * for_each_perag_from() because they terminate at sb_agcount where there are
+ * no perag structures in tree beyond end_agno.
  */
-#define for_each_perag_from(mp, next_agno, pag) \
+#define for_each_perag_range(mp, next_agno, end_agno, pag) \
 	for ((pag) = xfs_perag_get((mp), (next_agno)); \
-		(pag) != NULL; \
+		(pag) != NULL && (next_agno) <= (end_agno); \
 		(next_agno) = (pag)->pag_agno + 1, \
 		xfs_perag_put(pag), \
 		(pag) = xfs_perag_get((mp), (next_agno)))
 
+#define for_each_perag_from(mp, next_agno, pag) \
+	for_each_perag_range((mp), (next_agno), (mp)->m_sb.sb_agcount, (pag))
+
+
 #define for_each_perag(mp, agno, pag) \
 	(agno) = 0; \
 	for_each_perag_from((mp), (agno), (pag))

