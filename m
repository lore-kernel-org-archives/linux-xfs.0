Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 105C3C7EE29
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Jun 2023 09:46:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233029AbjFAJql (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Jun 2023 05:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233030AbjFAJqZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Jun 2023 05:46:25 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E959A195;
        Thu,  1 Jun 2023 02:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=92H2SuIqaLTdF0yqiMnFtm3c7m1gbxKAE17NACokr8Q=; b=IIgbZyPgdehBxCmCC21JhGrr2t
        ZNL90glx6BblQPSfM+8aXSfvGcsqfCEwG65nWX1ah8xRfXWhDbDUBhnFjqff5E79C0eF2LEevk7h5
        HnzMRwKYNuxyHwC82KU/WveHqpT5R7rRlDTaNylPARjI7eUYsSz2LCBW/FyKjsTXPWq0P3fPFzjlO
        cXcoRgltFbNP9rH4SnCGouptlcHbkfd/hUl9Ox184mTOmoC1+FwQxiC96BnBVw03X1gzz6H0Xmspd
        ewHnXNc25B7nfLLnpPYADgQrVggC6I0rnkE5V/Aea9M5x5Uw3j6OqymdZ7pTGXO/Pgj1nCNEqF4w/
        HqQywp0g==;
Received: from [2001:4bb8:182:6d06:35f3:1da0:1cc3:d86d] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1q4esw-002mDR-1V;
        Thu, 01 Jun 2023 09:46:23 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>, Jan Kara <jack@suse.cz>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: [PATCH 15/16] ext4: wire up sops->shutdown
Date:   Thu,  1 Jun 2023 11:44:58 +0200
Message-Id: <20230601094459.1350643-16-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230601094459.1350643-1-hch@lst.de>
References: <20230601094459.1350643-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Wire up the shutdown method to shut down the file system when the
underlying block device is marked dead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/ext4/super.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 865625089ecca3..a177a16c4d2fe5 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1450,6 +1450,11 @@ static void ext4_destroy_inode(struct inode *inode)
 			 EXT4_I(inode)->i_reserved_data_blocks);
 }
 
+static void ext4_shutdown(struct super_block *sb)
+{
+       ext4_force_shutdown(sb, EXT4_GOING_FLAGS_NOLOGFLUSH);
+}
+
 static void init_once(void *foo)
 {
 	struct ext4_inode_info *ei = foo;
@@ -1610,6 +1615,7 @@ static const struct super_operations ext4_sops = {
 	.unfreeze_fs	= ext4_unfreeze,
 	.statfs		= ext4_statfs,
 	.show_options	= ext4_show_options,
+	.shutdown	= ext4_shutdown,
 #ifdef CONFIG_QUOTA
 	.quota_read	= ext4_quota_read,
 	.quota_write	= ext4_quota_write,
-- 
2.39.2

