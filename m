Return-Path: <SRS0=7gTY=YC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E0FDC47404
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 11:31:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 763E220B7C
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 11:31:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730504AbfJILb1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 07:31:27 -0400
Received: from icp-osb-irony-out3.external.iinet.net.au ([203.59.1.153]:33473
        "EHLO icp-osb-irony-out3.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730398AbfJILb1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 07:31:27 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2BZAQBxxJ1d/0e30XYNWRwBAQEBAQc?=
 =?us-ascii?q?BAREBBAQBAYF7hDqEI48oAQEBAwaBEYodhR+MDwkBAQEBAQEBAQE3AQGEOwM?=
 =?us-ascii?q?CAoJyOBMCDAEBAQQBAQEBAQUDAYVYhhoCAQMjBFIQGA0CJgICRxAGCgmFGa9?=
 =?us-ascii?q?vdX8zGoosgQwogWWKQXiBB4FEgx2HUoJYBI80N4Y8Q5ZZgiyVNAyOFQOLHC2?=
 =?us-ascii?q?ECqU9gXpNLgqDJ1CBfxeOMGeRFAEB?=
X-IPAS-Result: =?us-ascii?q?A2BZAQBxxJ1d/0e30XYNWRwBAQEBAQcBAREBBAQBAYF7h?=
 =?us-ascii?q?DqEI48oAQEBAwaBEYodhR+MDwkBAQEBAQEBAQE3AQGEOwMCAoJyOBMCDAEBA?=
 =?us-ascii?q?QQBAQEBAQUDAYVYhhoCAQMjBFIQGA0CJgICRxAGCgmFGa9vdX8zGoosgQwog?=
 =?us-ascii?q?WWKQXiBB4FEgx2HUoJYBI80N4Y8Q5ZZgiyVNAyOFQOLHC2ECqU9gXpNLgqDJ?=
 =?us-ascii?q?1CBfxeOMGeRFAEB?=
X-IronPort-AV: E=Sophos;i="5.67,273,1566835200"; 
   d="scan'208";a="216229105"
Received: from unknown (HELO [192.168.1.222]) ([118.209.183.71])
  by icp-osb-irony-out3.iinet.net.au with ESMTP; 09 Oct 2019 19:31:24 +0800
Subject: [PATCH v5 14/17] xfs: mount-api - add xfs_fc_free()
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Wed, 09 Oct 2019 19:31:24 +0800
Message-ID: <157062068470.32346.8530858639686710763.stgit@fedora-28>
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

Add the fs_context_operations method .free that performs fs
context cleanup on context release.

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/xfs/xfs_super.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 230b0e2a184c..c7c33395b648 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -2127,10 +2127,29 @@ static const struct super_operations xfs_super_operations = {
 	.free_cached_objects	= xfs_fs_free_cached_objects,
 };
 
+static void xfs_fc_free(struct fs_context *fc)
+{
+	struct xfs_fs_context	*ctx = fc->fs_private;
+	struct xfs_mount	*mp = fc->s_fs_info;
+
+	/*
+	 * mp and ctx are stored in the fs_context when it is
+	 * initialized. mp is transferred to the superblock on
+	 * a successful mount, but if an error occurs before the
+	 * transfer we have to free it here.
+	 */
+	if (mp) {
+		xfs_free_fsname(mp);
+		kfree(mp);
+	}
+	kfree(ctx);
+}
+
 static const struct fs_context_operations xfs_context_ops = {
 	.parse_param = xfs_parse_param,
 	.get_tree    = xfs_get_tree,
 	.reconfigure = xfs_reconfigure,
+	.free        = xfs_fc_free,
 };
 
 static struct file_system_type xfs_fs_type = {

