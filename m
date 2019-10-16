Return-Path: <SRS0=pjFm=YJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B63EFECE59D
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 00:41:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93FF320872
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 00:41:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729522AbfJPAlW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Oct 2019 20:41:22 -0400
Received: from icp-osb-irony-out1.external.iinet.net.au ([203.59.1.210]:40358
        "EHLO icp-osb-irony-out1.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726872AbfJPAlV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Oct 2019 20:41:21 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2A3AADRZqZd/0e30XYNWRwBAQEBAQc?=
 =?us-ascii?q?BAREBBAQBAYFpBQEBCwGIYI8zAQEBAQEBBoERih2FIAGKE4F7CQEBAQEBAQE?=
 =?us-ascii?q?BATcBAYQ7AwICgxI2Bw4CDAEBAQQBAQEBAQUDAYVYhhoCAQMjBFIQGA0CJgI?=
 =?us-ascii?q?CRxAGhgiuB3V/MxqKKYEMKAGBZIpBeIEHgUSDHYQNg0WCXgSPNjeGPkOWXYI?=
 =?us-ascii?q?slTYMjhYDix0tqUANgX1NLgqDKE+QRo9kglQBAQ?=
X-IPAS-Result: =?us-ascii?q?A2A3AADRZqZd/0e30XYNWRwBAQEBAQcBAREBBAQBAYFpB?=
 =?us-ascii?q?QEBCwGIYI8zAQEBAQEBBoERih2FIAGKE4F7CQEBAQEBAQEBATcBAYQ7AwICg?=
 =?us-ascii?q?xI2Bw4CDAEBAQQBAQEBAQUDAYVYhhoCAQMjBFIQGA0CJgICRxAGhgiuB3V/M?=
 =?us-ascii?q?xqKKYEMKAGBZIpBeIEHgUSDHYQNg0WCXgSPNjeGPkOWXYIslTYMjhYDix0tq?=
 =?us-ascii?q?UANgX1NLgqDKE+QRo9kglQBAQ?=
X-IronPort-AV: E=Sophos;i="5.67,301,1566835200"; 
   d="scan'208";a="247444090"
Received: from unknown (HELO [192.168.1.222]) ([118.209.183.71])
  by icp-osb-irony-out1.iinet.net.au with ESMTP; 16 Oct 2019 08:40:47 +0800
Subject: [PATCH v6 01/12] vfs: add missing blkdev_put() in get_tree_bdev()
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Wed, 16 Oct 2019 08:40:47 +0800
Message-ID: <157118644757.9678.8135598206478346052.stgit@fedora-28>
In-Reply-To: <157118625324.9678.16275725173770634823.stgit@fedora-28>
References: <157118625324.9678.16275725173770634823.stgit@fedora-28>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

There appear to be a couple of missing blkdev_put() in get_tree_bdev().
This change has been sent to Linus and has been included in the current
rc kernel but is not present in the xfs-linux tree.
---
 fs/super.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/super.c b/fs/super.c
index f627b7c53d2b..cfadab2cbf35 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1300,6 +1300,7 @@ int get_tree_bdev(struct fs_context *fc,
 	mutex_lock(&bdev->bd_fsfreeze_mutex);
 	if (bdev->bd_fsfreeze_count > 0) {
 		mutex_unlock(&bdev->bd_fsfreeze_mutex);
+		blkdev_put(bdev, mode);
 		warnf(fc, "%pg: Can't mount, blockdev is frozen", bdev);
 		return -EBUSY;
 	}
@@ -1308,8 +1309,10 @@ int get_tree_bdev(struct fs_context *fc,
 	fc->sget_key = bdev;
 	s = sget_fc(fc, test_bdev_super_fc, set_bdev_super_fc);
 	mutex_unlock(&bdev->bd_fsfreeze_mutex);
-	if (IS_ERR(s))
+	if (IS_ERR(s)) {
+		blkdev_put(bdev, mode);
 		return PTR_ERR(s);
+	}
 
 	if (s->s_root) {
 		/* Don't summarily change the RO/RW state. */

