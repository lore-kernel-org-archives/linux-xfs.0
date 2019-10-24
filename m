Return-Path: <SRS0=feM8=YR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49832CA9EAF
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 07:50:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 177212084C
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 07:50:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408737AbfJXHun (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Oct 2019 03:50:43 -0400
Received: from icp-osb-irony-out1.external.iinet.net.au ([203.59.1.210]:26989
        "EHLO icp-osb-irony-out1.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407212AbfJXHun (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Oct 2019 03:50:43 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2ASAADRVrFd/0e30XYNWBsBAQEBAQE?=
 =?us-ascii?q?BBQEBAREBAQMDAQEBgWgFAQEBCwEBiGKPSQaBEYoihSABihOBewkBAQEBAQE?=
 =?us-ascii?q?BAQE3AQGEOwMCAoNZNQgOAgwBAQEEAQEBAQEFAwGFWIEaAQEEBwGFAQIBAyM?=
 =?us-ascii?q?EUhAYDQImAgJHEAaGCLF0dX8zGoowgQ4oAYFkikJ4gQeBRIMdhA6DR4JeBI8?=
 =?us-ascii?q?9N4ZAQ5Zsgi6VRQyOHwOLJC2pVAGCDk0uCoMoT5F9iCSDGYJ9glsBAQ?=
X-IPAS-Result: =?us-ascii?q?A2ASAADRVrFd/0e30XYNWBsBAQEBAQEBBQEBAREBAQMDA?=
 =?us-ascii?q?QEBgWgFAQEBCwEBiGKPSQaBEYoihSABihOBewkBAQEBAQEBAQE3AQGEOwMCA?=
 =?us-ascii?q?oNZNQgOAgwBAQEEAQEBAQEFAwGFWIEaAQEEBwGFAQIBAyMEUhAYDQImAgJHE?=
 =?us-ascii?q?AaGCLF0dX8zGoowgQ4oAYFkikJ4gQeBRIMdhA6DR4JeBI89N4ZAQ5Zsgi6VR?=
 =?us-ascii?q?QyOHwOLJC2pVAGCDk0uCoMoT5F9iCSDGYJ9glsBAQ?=
X-IronPort-AV: E=Sophos;i="5.68,224,1569254400"; 
   d="scan'208";a="250043678"
Received: from unknown (HELO [192.168.1.222]) ([118.209.183.71])
  by icp-osb-irony-out1.iinet.net.au with ESMTP; 24 Oct 2019 15:50:39 +0800
Subject: [PATCH v7 01/17] vfs: add missing blkdev_put() in get_tree_bdev()
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Thu, 24 Oct 2019 15:50:39 +0800
Message-ID: <157190343951.27074.2151762352313017753.stgit@fedora-28>
In-Reply-To: <157190333868.27074.13987695222060552856.stgit@fedora-28>
References: <157190333868.27074.13987695222060552856.stgit@fedora-28>
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

