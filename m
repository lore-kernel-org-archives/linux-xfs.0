Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C3D4C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:10:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 206B66112E
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:10:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232684AbhIOXML (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:12:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:37576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232868AbhIOXML (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:12:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD3A5600D4;
        Wed, 15 Sep 2021 23:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747451;
        bh=WXzETT73ONh0EbzdtKfZDeYw6XIKJh95Euh428v8JkA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=IHigMeGw4XiYk3mDsPSLJlMo9CcgP6JWeiIl8n/pkVXAckDUj7S6zRi6pnI5UwzaO
         NHkzkFOm9XxahpE1LWtW+3aJXnCAF2Hpe15t9r58ihHHfDXibH4vOBhG5mO/cs8snI
         RWJbYErxWVyRXjws+Sbum1exPpDMV5lSUHG+d39sfE6e3xjdAzNrUC4YFXBs0fx4c6
         tZRg3XByClwIPSnYN1n3KKRAreW2DhtjLx3AviP5kJrL4bscx/kMEdlz08XMlZEXTC
         14rJCN4C0n5h6LhILKeVDbIG/wNXdIQQrt2xH2LBBZORHy9CE3pxJCESRunqRNxKnm
         EvXlRe57afACg==
Subject: [PATCH 47/61] xfs: fix radix tree tag signs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:10:51 -0700
Message-ID: <163174745144.350433.16331886921260004878.stgit@magnolia>
In-Reply-To: <163174719429.350433.8562606396437219220.stgit@magnolia>
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 919a4ddb68413056ecb7c71d9d5465bb54c8032b

Radix tree tags are supposed to be unsigned ints, so fix the callers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_ag.c |    2 +-
 libxfs/xfs_ag.h |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)


diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index 403d9a20..a1a2d0d9 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -62,7 +62,7 @@ struct xfs_perag *
 xfs_perag_get_tag(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		first,
-	int			tag)
+	unsigned int		tag)
 {
 	struct xfs_perag	*pag;
 	int			found;
diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index 70b97851..4c6f9045 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
@@ -109,10 +109,10 @@ int xfs_initialize_perag(struct xfs_mount *mp, xfs_agnumber_t agcount,
 int xfs_initialize_perag_data(struct xfs_mount *mp, xfs_agnumber_t agno);
 void xfs_free_perag(struct xfs_mount *mp);
 
-struct xfs_perag *xfs_perag_get(struct xfs_mount *, xfs_agnumber_t);
-struct xfs_perag *xfs_perag_get_tag(struct xfs_mount *, xfs_agnumber_t,
-				   int tag);
-void	xfs_perag_put(struct xfs_perag *pag);
+struct xfs_perag *xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t agno);
+struct xfs_perag *xfs_perag_get_tag(struct xfs_mount *mp, xfs_agnumber_t agno,
+		unsigned int tag);
+void xfs_perag_put(struct xfs_perag *pag);
 
 /*
  * Perag iteration APIs

