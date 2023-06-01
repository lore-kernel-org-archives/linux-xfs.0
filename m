Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC19EC77B7E
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Jun 2023 09:46:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233009AbjFAJqh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Jun 2023 05:46:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233011AbjFAJqQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Jun 2023 05:46:16 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0118A134;
        Thu,  1 Jun 2023 02:46:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=zztO8WxLu2RClT/8Y5S0j/gxpaEYqpI3KKJwpryT2rg=; b=rfRX7SxcH1Hdnw8ku4tKhidjy0
        ywyrIBljbCLRy2e4sRbVz0kh8ljzPMM4ax1zT+tUe7yx1gjxr1ELZ4cHNkKfBi7aFvZwf5WC0xuHJ
        Cc1TLU+azQGty9t+jFsD+fzt5remWr4lkdNHESN/o2o/jr0h0UzhlUOq/+59RkOZqCpLRHZ/ybSe0
        YBAMcmkgDWo6q1s9IcObT0YioJHc8YktwmSjdtb+D29ySmK9DzwWKKsWIlTALeXXhrPxth1oOUvD7
        nD2Eh7LSqF2ddMIPJhuVQTNnGxEpW3i36AriC1IhCjOVNC9YDbyB5sdVZAKyLlMyDMPnK8dojMJY5
        HmemP0Rg==;
Received: from [2001:4bb8:182:6d06:35f3:1da0:1cc3:d86d] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1q4esl-002mAN-0e;
        Thu, 01 Jun 2023 09:46:12 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>, Jan Kara <jack@suse.cz>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: [PATCH 13/16] xfs: wire up the ->mark_dead holder operation for log and RT devices
Date:   Thu,  1 Jun 2023 11:44:56 +0200
Message-Id: <20230601094459.1350643-14-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230601094459.1350643-1-hch@lst.de>
References: <20230601094459.1350643-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Implement a set of holder_ops that shut down the file system when the
block device used as log or RT device is removed undeneath the file
system.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_super.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index eb469b8f9a0497..1b4bd5c88f4a11 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -377,6 +377,17 @@ xfs_setup_dax_always(
 	return 0;
 }
 
+static void
+xfs_bdev_mark_dead(
+	struct block_device	*bdev)
+{
+	xfs_force_shutdown(bdev->bd_holder, SHUTDOWN_DEVICE_REMOVED);
+}
+
+static const struct blk_holder_ops xfs_holder_ops = {
+	.mark_dead		= xfs_bdev_mark_dead,
+};
+
 STATIC int
 xfs_blkdev_get(
 	xfs_mount_t		*mp,
@@ -386,7 +397,7 @@ xfs_blkdev_get(
 	int			error = 0;
 
 	*bdevp = blkdev_get_by_path(name, FMODE_READ|FMODE_WRITE|FMODE_EXCL,
-				    mp, NULL);
+				    mp, &xfs_holder_ops);
 	if (IS_ERR(*bdevp)) {
 		error = PTR_ERR(*bdevp);
 		xfs_warn(mp, "Invalid device [%s], error=%d", name, error);
-- 
2.39.2

