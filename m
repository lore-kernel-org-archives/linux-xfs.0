Return-Path: <SRS0=lWMA=WT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8735DC3A5A1
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Aug 2019 01:09:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62E6623402
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Aug 2019 01:09:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387641AbfHWBJr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Aug 2019 21:09:47 -0400
Received: from icp-osb-irony-out2.external.iinet.net.au ([203.59.1.155]:5786
        "EHLO icp-osb-irony-out2.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730545AbfHWBJq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Aug 2019 21:09:46 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2CzAQAROl9d/3Wz0XYNWBwBAQEEAQE?=
 =?us-ascii?q?HBAEBgVYEAQELAQGEMYQgj1YBAQaBEYoRkSMJAQEBAQEBAQEBNwEBhDoDAgK?=
 =?us-ascii?q?DAjcGDgIJAQEBBAECAQEGAwGFWIEQAQwBCAEBhHECAQMjBFIQGA0CJgICRxA?=
 =?us-ascii?q?GE4UZq1BzfzMaikCBDCgBgWKKJHiBB4FEgx2HT4JYBI8UhTJdQpV3CYIflFg?=
 =?us-ascii?q?MjVsDimCEIKNggXpNLgqDJ5EUZYRsg3ttgwIBAQ?=
X-IPAS-Result: =?us-ascii?q?A2CzAQAROl9d/3Wz0XYNWBwBAQEEAQEHBAEBgVYEAQELA?=
 =?us-ascii?q?QGEMYQgj1YBAQaBEYoRkSMJAQEBAQEBAQEBNwEBhDoDAgKDAjcGDgIJAQEBB?=
 =?us-ascii?q?AECAQEGAwGFWIEQAQwBCAEBhHECAQMjBFIQGA0CJgICRxAGE4UZq1BzfzMai?=
 =?us-ascii?q?kCBDCgBgWKKJHiBB4FEgx2HT4JYBI8UhTJdQpV3CYIflFgMjVsDimCEIKNgg?=
 =?us-ascii?q?XpNLgqDJ5EUZYRsg3ttgwIBAQ?=
X-IronPort-AV: E=Sophos;i="5.64,419,1559491200"; 
   d="scan'208";a="231796920"
Received: from unknown (HELO [192.168.1.222]) ([118.209.179.117])
  by icp-osb-irony-out2.iinet.net.au with ESMTP; 23 Aug 2019 09:00:32 +0800
Subject: [PATCH v2 14/15] xfs: mount-api - switch to new mount-api
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Date:   Fri, 23 Aug 2019 09:00:32 +0800
Message-ID: <156652203256.2607.18022916035406730007.stgit@fedora-28>
In-Reply-To: <156652158924.2607.14608448087216437699.stgit@fedora-28>
References: <156652158924.2607.14608448087216437699.stgit@fedora-28>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The infrastructure needed to use the new mount api is now
in place, switch over to use it.

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/xfs/xfs_super.c |   51 +++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 49 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index d2a1a62a3edc..fe7acd8ddd48 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -2123,7 +2123,6 @@ static const struct super_operations xfs_super_operations = {
 	.freeze_fs		= xfs_fs_freeze,
 	.unfreeze_fs		= xfs_fs_unfreeze,
 	.statfs			= xfs_fs_statfs,
-	.remount_fs		= xfs_fs_remount,
 	.show_options		= xfs_fs_show_options,
 	.nr_cached_objects	= xfs_fs_nr_cached_objects,
 	.free_cached_objects	= xfs_fs_free_cached_objects,
@@ -2157,10 +2156,58 @@ static const struct fs_context_operations xfs_context_ops = {
 	.free	     = xfs_fc_free,
 };
 
+/*
+ * Set up the filesystem mount context.
+ */
+int xfs_init_fs_context(struct fs_context *fc)
+{
+	struct xfs_fs_context	*ctx;
+	struct xfs_mount	*mp;
+
+	ctx = kzalloc(sizeof(struct xfs_fs_context), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	mp = xfs_mount_alloc();
+	if (!mp) {
+		kfree(ctx);
+		return -ENOMEM;
+	}
+
+	/*
+	 * Set some default flags that could be cleared by the mount option
+	 * parsing.
+	 */
+	mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
+
+	/*
+	 * These can be overridden by the mount option parsing.
+	 */
+	mp->m_logbufs = -1;
+	mp->m_logbsize = -1;
+
+	/*
+	 * Copy binary VFS mount flags we are interested in.
+	 */
+	if (fc->sb_flags & SB_RDONLY)
+		mp->m_flags |= XFS_MOUNT_RDONLY;
+	if (fc->sb_flags & SB_DIRSYNC)
+		mp->m_flags |= XFS_MOUNT_DIRSYNC;
+	if (fc->sb_flags & SB_SYNCHRONOUS)
+		mp->m_flags |= XFS_MOUNT_WSYNC;
+
+	fc->fs_private = ctx;
+	fc->s_fs_info = mp;
+	fc->ops = &xfs_context_ops;
+
+	return 0;
+}
+
 static struct file_system_type xfs_fs_type = {
 	.owner			= THIS_MODULE,
 	.name			= "xfs",
-	.mount			= xfs_fs_mount,
+	.init_fs_context	= xfs_init_fs_context,
+	.parameters		= &xfs_fs_parameters,
 	.kill_sb		= kill_block_super,
 	.fs_flags		= FS_REQUIRES_DEV,
 };

