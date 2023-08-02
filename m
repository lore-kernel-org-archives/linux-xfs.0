Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF1C7C04FDF
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Aug 2023 15:44:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234395AbjHBPov (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Aug 2023 11:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235312AbjHBPmf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Aug 2023 11:42:35 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4627D2695;
        Wed,  2 Aug 2023 08:42:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=i4RVxh7cqcfhStKnrFuIVUqPlurNIlyMZ1NDN212nv0=; b=m9OaeC94Czmbb5hPBahN8SXBqI
        HNi7Mt4xq8QD0KfNROKtIz4cWo24dWSBz7X8e50X0RB4sQ5tkio4jz+r4r8ZXafkW2ww175yxfozT
        NCUZO2qzsSFjl3BFFlIRN3Wfa2mzIAi3PGZkD8Cd957ycv8VcxS6B+Gl86ETq6tCRKfhACSRqvwK7
        ZdYNXIQB/XHcCPAEwZsU/ppTsd8l/Kd7bPks6ODFCghe5WMh0L9iLVh6NfcG8q01AnZzhLKiyX/4B
        4MY4Wr/7eVJVJE1UTa4EMeC4cbXZti0JxzrFZGHMr43Ix5mWyHHev/cZbWwF9pp4HCsk18N+iH6el
        wjXcrqPw==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qRDzN-005GOT-0f;
        Wed, 02 Aug 2023 15:42:17 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Al Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>
Cc:     Jan Kara <jack@suse.cz>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-block@vger.kernel.org
Subject: [PATCH 12/12] xfs use fs_holder_ops for the log and RT devices
Date:   Wed,  2 Aug 2023 17:41:31 +0200
Message-Id: <20230802154131.2221419-13-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230802154131.2221419-1-hch@lst.de>
References: <20230802154131.2221419-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Use the generic fs_holder_ops to shut down the file system when the
log or RT device goes away instead of duplicating the logic.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_super.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index d5042419ed9997..338eba71ff8667 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -377,17 +377,6 @@ xfs_setup_dax_always(
 	return 0;
 }
 
-static void
-xfs_bdev_mark_dead(
-	struct block_device	*bdev)
-{
-	xfs_force_shutdown(bdev->bd_holder, SHUTDOWN_DEVICE_REMOVED);
-}
-
-static const struct blk_holder_ops xfs_holder_ops = {
-	.mark_dead		= xfs_bdev_mark_dead,
-};
-
 STATIC int
 xfs_blkdev_get(
 	xfs_mount_t		*mp,
@@ -396,8 +385,8 @@ xfs_blkdev_get(
 {
 	int			error = 0;
 
-	*bdevp = blkdev_get_by_path(name, BLK_OPEN_READ | BLK_OPEN_WRITE, mp,
-				    &xfs_holder_ops);
+	*bdevp = blkdev_get_by_path(name, BLK_OPEN_READ | BLK_OPEN_WRITE,
+				    mp->m_super, &fs_holder_ops);
 	if (IS_ERR(*bdevp)) {
 		error = PTR_ERR(*bdevp);
 		xfs_warn(mp, "Invalid device [%s], error=%d", name, error);
@@ -412,7 +401,7 @@ xfs_blkdev_put(
 	struct block_device	*bdev)
 {
 	if (bdev)
-		blkdev_put(bdev, mp);
+		blkdev_put(bdev, mp->m_super);
 }
 
 STATIC void
-- 
2.39.2

