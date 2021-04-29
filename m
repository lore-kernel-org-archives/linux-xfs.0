Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 658D1C433B4
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Apr 2021 05:44:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3053361431
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Apr 2021 05:44:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbhD2FpD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Apr 2021 01:45:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:46724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229814AbhD2FpD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Apr 2021 01:45:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0717D61431;
        Thu, 29 Apr 2021 05:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619675057;
        bh=Pe8Iyvpwf8Vvyp4xsIgPYlW/SnXrlrNTDT83EjZx28w=;
        h=Date:From:To:Cc:Subject:From;
        b=WxN28KaRkqH/GJoeVxqN4nrj+2DCtgrflHHqb4cxRhFAqL0mBiMNK0ZOAJWw5Zgkl
         tHkBSKUgLHx6wcuR8EO2aFFWZGuBilsyuNvMmJmoWLRksN2atK+2RsokrgHMqAFYPG
         G7b0wuQzRPhPW0Ty7Ad2Iirtk2YH0dCR8rv93rU2Qkj5OIH59XpJzgVTikXnzWDX4z
         UhMgPpZW5YGV5lEfQNuSGxZHFX41+8E8wsRo5o5OjTU4ZPdKvjdvGR59HMEtpb+9qR
         a81RZYWAFzm2WhO+d6u3vTy0unxoYivNuNars5/fAy+scqFrU08qSIxNDoLUqxjHyf
         pboAXNM09SPTQ==
Date:   Wed, 28 Apr 2021 22:44:16 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     chandanrlinux@gmail.com
Subject: [PATCH] xfs: fix xfs_reflink_unshare usage of
 filemap_write_and_wait_range
Message-ID: <20210429054416.GJ1251862@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The final parameter of filemap_write_and_wait_range is the end of the
range to flush, not the length of the range to flush.

Fixes: 46afb0628b86 ("xfs: only flush the unshared range in xfs_reflink_unshare")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_reflink.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 4dd4af6ac2ef..060695d6d56a 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1522,7 +1522,8 @@ xfs_reflink_unshare(
 	if (error)
 		goto out;
 
-	error = filemap_write_and_wait_range(inode->i_mapping, offset, len);
+	error = filemap_write_and_wait_range(inode->i_mapping, offset,
+			offset + len - 1);
 	if (error)
 		goto out;
 
