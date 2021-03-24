Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5B70C433E3
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 14:22:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7053461A0F
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 14:22:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236246AbhCXOWI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 10:22:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236202AbhCXOVn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Mar 2021 10:21:43 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4B92C0613DF
        for <linux-xfs@vger.kernel.org>; Wed, 24 Mar 2021 07:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=CndO8qRsyTMTBBuMfz2eq56r3DlPewLjX31EYs1JLqc=; b=lKe+hJGrZv5S9h3yKYiQXJyiSc
        dF8xihLndyJCWTNAX4YvnwlF1Y7FbiC4rpaDddef0uKKq1UuN0Bo3z73ZoVzbrBJ+96hQUIvk5ovm
        dwYDOLPKi80chWyYEyokOWTf1PCLmus4kbbgoAg7GguS+s6ncrxLsKiq0irlXMqv80TTyUukNgGCU
        5G2pgPJwh7ZuI3WQ8rh6/8VxOLhMLuX7b/N6PBHui0K80Sg50kIFvuRRsvWefVFXVBxVM0zApr+dI
        Oefa4vNRVVl+5nOzQrR6+I+LyE5IaTC7c/rdpIlLWQ5x4GW4caZJWmTI/wD4SpRaD1V+bT/w++RJE
        Lq0gfTjQ==;
Received: from [2001:4bb8:191:f692:b499:58dc:411a:54d1] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lP4OE-0045X5-52
        for linux-xfs@vger.kernel.org; Wed, 24 Mar 2021 14:21:42 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 04/18] xfs: remove the unused xfs_icdinode_has_bigtime helper
Date:   Wed, 24 Mar 2021 15:21:15 +0100
Message-Id: <20210324142129.1011766-5-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210324142129.1011766-1-hch@lst.de>
References: <20210324142129.1011766-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_inode_buf.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index 9e1ae38380b3c0..b3097ea8b53366 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -32,11 +32,6 @@ struct xfs_icdinode {
 	struct timespec64 di_crtime;	/* time created */
 };
 
-static inline bool xfs_icdinode_has_bigtime(const struct xfs_icdinode *icd)
-{
-	return icd->di_flags2 & XFS_DIFLAG2_BIGTIME;
-}
-
 /*
  * Inode location information.  Stored in the inode and passed to
  * xfs_imap_to_bp() to get a buffer and dinode for a given inode.
-- 
2.30.1

