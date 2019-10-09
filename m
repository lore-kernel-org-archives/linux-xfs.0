Return-Path: <SRS0=7gTY=YC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F02CDC47404
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 11:30:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C26932133F
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 11:30:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727657AbfJILaX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 07:30:23 -0400
Received: from icp-osb-irony-out3.external.iinet.net.au ([203.59.1.153]:33301
        "EHLO icp-osb-irony-out3.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725962AbfJILaX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 07:30:23 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2BYAQBjw51d/0e30XYNWRwBAQEBAQc?=
 =?us-ascii?q?BAREBBAQBAYF7iF2PKAEBAQMGgRGKHYUfjA8JAQEBAQEBAQEBNwEBhDsDAgK?=
 =?us-ascii?q?CcTgTAgwBAQEEAQEBAQEFAwGFWIYaAgEDIwRSEBgNAiYCAkcQBoUsr3J1fzM?=
 =?us-ascii?q?aiiyBDCiBZYpBeIEHgUSDHYQNg0WCWASPNDeGPEOWWYIslTQMjhUDixwtqUe?=
 =?us-ascii?q?Bek0uCoMoT5BGjyeCVAEB?=
X-IPAS-Result: =?us-ascii?q?A2BYAQBjw51d/0e30XYNWRwBAQEBAQcBAREBBAQBAYF7i?=
 =?us-ascii?q?F2PKAEBAQMGgRGKHYUfjA8JAQEBAQEBAQEBNwEBhDsDAgKCcTgTAgwBAQEEA?=
 =?us-ascii?q?QEBAQEFAwGFWIYaAgEDIwRSEBgNAiYCAkcQBoUsr3J1fzMaiiyBDCiBZYpBe?=
 =?us-ascii?q?IEHgUSDHYQNg0WCWASPNDeGPEOWWYIslTQMjhUDixwtqUeBek0uCoMoT5BGj?=
 =?us-ascii?q?yeCVAEB?=
X-IronPort-AV: E=Sophos;i="5.67,273,1566835200"; 
   d="scan'208";a="216228978"
Received: from unknown (HELO [192.168.1.222]) ([118.209.183.71])
  by icp-osb-irony-out3.iinet.net.au with ESMTP; 09 Oct 2019 19:30:21 +0800
Subject: [PATCH v5 02/17] vfs: add missing blkdev_put() in get_tree_bdev()
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Wed, 09 Oct 2019 19:30:21 +0800
Message-ID: <157062062120.32346.6331183312304681728.stgit@fedora-28>
In-Reply-To: <157062043952.32346.977737248061083292.stgit@fedora-28>
References: <157062043952.32346.977737248061083292.stgit@fedora-28>
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

