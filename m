Return-Path: <SRS0=y7rh=X4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43C9EC10F14
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Oct 2019 10:25:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 197F1218DE
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Oct 2019 10:25:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbfJCKZb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Oct 2019 06:25:31 -0400
Received: from icp-osb-irony-out7.external.iinet.net.au ([203.59.1.107]:42874
        "EHLO icp-osb-irony-out7.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726039AbfJCKZb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Oct 2019 06:25:31 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2CrAQDHy5Vd/7q70HYNWRwBAQEEAQE?=
 =?us-ascii?q?MBAEBgWeIXI8qAwaBEYoakSwJAQEBAQEBAQEBNwEBhDsDAgKCaDgTAgwBAQE?=
 =?us-ascii?q?EAQEBAQEFAwGFWIYaAgEDIwRSEBgNAiYCAkcQBoUsrgx1fzMaiieBDCiBZYp?=
 =?us-ascii?q?BeIEHgUSDHYQNg0SCWASPMDeGOUOWVIItlTMMjhMDixwtqT6Bek0uCoMoT5B?=
 =?us-ascii?q?Gjy6CVAEB?=
X-IPAS-Result: =?us-ascii?q?A2CrAQDHy5Vd/7q70HYNWRwBAQEEAQEMBAEBgWeIXI8qA?=
 =?us-ascii?q?waBEYoakSwJAQEBAQEBAQEBNwEBhDsDAgKCaDgTAgwBAQEEAQEBAQEFAwGFW?=
 =?us-ascii?q?IYaAgEDIwRSEBgNAiYCAkcQBoUsrgx1fzMaiieBDCiBZYpBeIEHgUSDHYQNg?=
 =?us-ascii?q?0SCWASPMDeGOUOWVIItlTMMjhMDixwtqT6Bek0uCoMoT5BGjy6CVAEB?=
X-IronPort-AV: E=Sophos;i="5.67,251,1566835200"; 
   d="scan'208";a="207652666"
Received: from unknown (HELO [192.168.1.222]) ([118.208.187.186])
  by icp-osb-irony-out7.iinet.net.au with ESMTP; 03 Oct 2019 18:25:30 +0800
Subject: [PATCH v4 02/17] vfs: add missing blkdev_put() in get_tree_bdev()
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Thu, 03 Oct 2019 18:25:28 +0800
Message-ID: <157009832879.13858.5261547183927327078.stgit@fedora-28>
In-Reply-To: <157009817203.13858.7783767645177567968.stgit@fedora-28>
References: <157009817203.13858.7783767645177567968.stgit@fedora-28>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

There appear to be a couple of missing blkdev_put() in get_tree_bdev().
---
 fs/super.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/super.c b/fs/super.c
index a7f62c964e58..fd816014bd7d 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1268,6 +1268,7 @@ int get_tree_bdev(struct fs_context *fc,
 	mutex_lock(&bdev->bd_fsfreeze_mutex);
 	if (bdev->bd_fsfreeze_count > 0) {
 		mutex_unlock(&bdev->bd_fsfreeze_mutex);
+		blkdev_put(bdev, mode);
 		warnf(fc, "%pg: Can't mount, blockdev is frozen", bdev);
 		return -EBUSY;
 	}
@@ -1276,8 +1277,10 @@ int get_tree_bdev(struct fs_context *fc,
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

