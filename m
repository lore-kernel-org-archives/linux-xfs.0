Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3D49C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 14:22:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8551A61A15
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 14:22:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236144AbhCXOWJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 10:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236024AbhCXOVm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Mar 2021 10:21:42 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3BB9C061763
        for <linux-xfs@vger.kernel.org>; Wed, 24 Mar 2021 07:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=xll5QGets+wg5wDVzLdfOCWKDaftbPw7SetQ+4HrF4Q=; b=ILAQL+aw89PcR3n8NmPHG0CG/p
        CXhuLfU8plpXMfN/UJTrSTL8kPOYORhHxVubG9Vp7ZUci/Zxlb7tQG1eUrXV1KYxMLM+AGhcEMP8d
        3ERyAliJRJy1TLAqTyC46X1x01ZG7PYWw0XLxedEf7MDtkrXipSPUk0i692vk7TiEwzjfManCzRaL
        Y5D/5jeixbty+Rn82Nq0Bt87A6jWK5Ji8/aevqElo/Mc7LHqwNmft2GrDutEd/7J1QowH2XR5/Q9S
        hMzceEsVxS5jo/du1KdTeatQY8Q1aM4gyJxGxMLdfy2MtDu/KhlqvAY6Q+GD8+AsUS9E+HP+1g0RE
        q/CN1HRw==;
Received: from [2001:4bb8:191:f692:b499:58dc:411a:54d1] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lP4OB-0045Wy-K6
        for linux-xfs@vger.kernel.org; Wed, 24 Mar 2021 14:21:40 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 03/18] xfs: handle crtime more carefully in xfs_bulkstat_one_int
Date:   Wed, 24 Mar 2021 15:21:14 +0100
Message-Id: <20210324142129.1011766-4-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210324142129.1011766-1-hch@lst.de>
References: <20210324142129.1011766-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The crtime only exists for v5 inodes, so only copy it for those.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_itable.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index ca310a125d1e14..444b551d540f44 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -99,8 +99,6 @@ xfs_bulkstat_one_int(
 	buf->bs_mtime_nsec = inode->i_mtime.tv_nsec;
 	buf->bs_ctime = inode->i_ctime.tv_sec;
 	buf->bs_ctime_nsec = inode->i_ctime.tv_nsec;
-	buf->bs_btime = dic->di_crtime.tv_sec;
-	buf->bs_btime_nsec = dic->di_crtime.tv_nsec;
 	buf->bs_gen = inode->i_generation;
 	buf->bs_mode = inode->i_mode;
 
@@ -113,6 +111,8 @@ xfs_bulkstat_one_int(
 	buf->bs_version = XFS_BULKSTAT_VERSION_V5;
 
 	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
+		buf->bs_btime = dic->di_crtime.tv_sec;
+		buf->bs_btime_nsec = dic->di_crtime.tv_nsec;
 		if (dic->di_flags2 & XFS_DIFLAG2_COWEXTSIZE)
 			buf->bs_cowextsize_blks = dic->di_cowextsize;
 	}
-- 
2.30.1

