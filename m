Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56D7AC4708F
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 00:53:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40B3D613CD
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 00:53:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbhFBAzP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Jun 2021 20:55:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:33874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229736AbhFBAzP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 1 Jun 2021 20:55:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66CCB613CA;
        Wed,  2 Jun 2021 00:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622595213;
        bh=Rhn4H7A53MjxGU5+qPPQhdbDGtd03v1nR729opUjakA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MSe9mlK+XRlePj3dys7G5LU/dP/78JYRNMJXs2CNlls3mcu3aK/gQ0RmJtSwXR/5U
         5uIa5eJplEDnDluAb22MQtC+Dpq2CPzCD0MzrcdI8cCa3o5DMvl7oswEyUkP+dDqJT
         RFS9G1z1eiWRl1CeRUteAqCdNXnDh6PpMxXtA1wRD/2BeYsvrZ77azYSyHVjnjxXc4
         UKIKBIwZRPB6ILphQdTGjvhBCXmp0dMT6nuNJzpRWDcSwjEnJ46VRV0VSSozVhQuRu
         MxkqPbf71G5UtyZV38sx6lm+JKOVA1cwIDSnMYKcEUQP6NKjWy25lyOcuv+HSlzLWh
         xJXMhu5OKip1Q==
Subject: [PATCH 11/14] xfs: fix radix tree tag signs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Tue, 01 Jun 2021 17:53:33 -0700
Message-ID: <162259521313.662681.11016822371804821220.stgit@locust>
In-Reply-To: <162259515220.662681.6750744293005850812.stgit@locust>
References: <162259515220.662681.6750744293005850812.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Radix tree tags are supposed to be unsigned ints, so fix the callers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_sb.c |    2 +-
 fs/xfs/libxfs/xfs_sb.h |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index dfbbcbd448c1..300d0a1a8049 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -61,7 +61,7 @@ struct xfs_perag *
 xfs_perag_get_tag(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		first,
-	int			tag)
+	unsigned int		tag)
 {
 	struct xfs_perag	*pag;
 	int			found;
diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
index f79f9dc632b6..e5f1c2d879eb 100644
--- a/fs/xfs/libxfs/xfs_sb.h
+++ b/fs/xfs/libxfs/xfs_sb.h
@@ -17,8 +17,8 @@ struct xfs_perag;
  * perag get/put wrappers for ref counting
  */
 extern struct xfs_perag *xfs_perag_get(struct xfs_mount *, xfs_agnumber_t);
-extern struct xfs_perag *xfs_perag_get_tag(struct xfs_mount *, xfs_agnumber_t,
-					   int tag);
+struct xfs_perag *xfs_perag_get_tag(struct xfs_mount *mp, xfs_agnumber_t agno,
+		unsigned int tag);
 extern void	xfs_perag_put(struct xfs_perag *pag);
 extern int	xfs_initialize_perag_data(struct xfs_mount *, xfs_agnumber_t);
 

