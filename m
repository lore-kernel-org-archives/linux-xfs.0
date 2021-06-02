Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0612C4708F
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 22:26:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE6E4613E6
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 22:26:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbhFBW1r (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Jun 2021 18:27:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:43346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229583AbhFBW1r (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 2 Jun 2021 18:27:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 950A3613AC;
        Wed,  2 Jun 2021 22:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622672763;
        bh=ia6Ty8afeb+EIgbMN3ys4Hm6M1cU3Kqn6vWSvfOOncs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=e43uqg1SY2F9+qDIe5y3gjS62cCDPYSizq8gjiLFwNVhzweppClSXVy/ypMm+s+Ix
         8H1wSVie92OmVWL4G4pYV6D+FjsqoR4rP9QOe8JeLRgXDzykZCrBZ/UzxQmMLvq0jM
         vEAAD8Gq8K+NBvXEmAyzTXG2UfyLPdSnfB5Tcr3s9QiacK30uHedxC9BiKRVbud9Y4
         KCW2gRntjyCujFyatVf1dYHL1XgUkJq4oWZHGtRKDUXUK4/7Z2zjv3rkQfN2L8+blR
         3rXSmYryFC1W9h/Sa32y2n7i2OhSCZfH5NafsTDz9rUVerZUTTcq4zN+0zdN4erlwf
         MJB2cR+fZqtfw==
Subject: [PATCH 12/15] xfs: fix radix tree tag signs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        david@fromorbit.com, hch@infradead.org
Date:   Wed, 02 Jun 2021 15:26:03 -0700
Message-ID: <162267276329.2375284.10095234780682022490.stgit@locust>
In-Reply-To: <162267269663.2375284.15885514656776142361.stgit@locust>
References: <162267269663.2375284.15885514656776142361.stgit@locust>
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
Reviewed-by: Dave Chinner <dchinner@redhat.com>
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
 

