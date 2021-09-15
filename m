Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F96DC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:10:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58C9461101
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:10:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbhIOXMG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:12:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:37402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232868AbhIOXMF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:12:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41E35610A6;
        Wed, 15 Sep 2021 23:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747446;
        bh=mMuQ3KH7ggyv9PuEtQ1p0Lj6fjvzNXbdqI3PwjPtgf8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=mWRA6tXaolEp+XLWMPYkDr8aFlhTa6fhiDkqc8Qat/5jAnFFDW5SP6mtJ9rLp7v3P
         JDd/P+ypwHXVYChS0GyriQ5Pc46Y2H7Fbh7WOsXMzHL+WVRZ/xH3NflA6Oh/I4Ucn/
         Sd9d0kzEvw4XI3P8yR19z4mICcBo1o/dxgId4w0d9FWHs8E2vWwMfxiAcEjnrMTcnW
         U9VA7DIIlo5UytQUjIb3zX+WW0gu53usfxL/lELFng+WZKJk++l39jEviifEoIvrN/
         7SqvJcXvh3x+S4HGxf3fiJCmYGXPtaMjq89Bv2DPyUUg8cLtDfFnU+de8gPhaCuMCE
         Wb+okaZEFABng==
Subject: [PATCH 46/61] xfs: mark xfs_bmap_set_attrforkoff static
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:10:46 -0700
Message-ID: <163174744600.350433.11396345644221713486.stgit@magnolia>
In-Reply-To: <163174719429.350433.8562606396437219220.stgit@magnolia>
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 5a981e4ea8ff8062e7c7ea8fc4a1565e4820a08b

xfs_bmap_set_attrforkoff is only used inside of xfs_bmap.c, so mark it
static.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_bmap.c |    2 +-
 libxfs/xfs_bmap.h |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 0809922e..a548507c 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -1022,7 +1022,7 @@ xfs_bmap_add_attrfork_local(
 /*
  * Set an inode attr fork offset based on the format of the data fork.
  */
-int
+static int
 xfs_bmap_set_attrforkoff(
 	struct xfs_inode	*ip,
 	int			size,
diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index f9a390ec..67641f66 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -187,7 +187,6 @@ void	xfs_trim_extent(struct xfs_bmbt_irec *irec, xfs_fileoff_t bno,
 		xfs_filblks_t len);
 unsigned int xfs_bmap_compute_attr_offset(struct xfs_mount *mp);
 int	xfs_bmap_add_attrfork(struct xfs_inode *ip, int size, int rsvd);
-int	xfs_bmap_set_attrforkoff(struct xfs_inode *ip, int size, int *version);
 void	xfs_bmap_local_to_extents_empty(struct xfs_trans *tp,
 		struct xfs_inode *ip, int whichfork);
 void	__xfs_bmap_add_free(struct xfs_trans *tp, xfs_fsblock_t bno,

