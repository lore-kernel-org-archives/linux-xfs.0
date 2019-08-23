Return-Path: <SRS0=lWMA=WT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD3CAC3A5A1
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Aug 2019 01:09:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9F8423404
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Aug 2019 01:09:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387606AbfHWBJf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Aug 2019 21:09:35 -0400
Received: from icp-osb-irony-out2.external.iinet.net.au ([203.59.1.155]:5692
        "EHLO icp-osb-irony-out2.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387641AbfHWBJf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Aug 2019 21:09:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2DWAQAROl9d/3Wz0XYNWBwBAQEEAQE?=
 =?us-ascii?q?HBAEBgWeEM4Qgj1YBAQaBEYoRkSMJAQEBAQEBAQEBNwEBhDoDAgKDAjgTAgk?=
 =?us-ascii?q?BAQEEAQIBAQYDAYVYhhkCAQMjBFIQGA0CJgICRxAGE4UZq1BzfzMaikCBDCi?=
 =?us-ascii?q?BY4okeIEHgUSDHYdPglgEjxSGD0KVdwmCH5RYDI1bA4pgLYNzo2GBeU0uCoM?=
 =?us-ascii?q?ngk4Xji9ljFYBAQ?=
X-IPAS-Result: =?us-ascii?q?A2DWAQAROl9d/3Wz0XYNWBwBAQEEAQEHBAEBgWeEM4Qgj?=
 =?us-ascii?q?1YBAQaBEYoRkSMJAQEBAQEBAQEBNwEBhDoDAgKDAjgTAgkBAQEEAQIBAQYDA?=
 =?us-ascii?q?YVYhhkCAQMjBFIQGA0CJgICRxAGE4UZq1BzfzMaikCBDCiBY4okeIEHgUSDH?=
 =?us-ascii?q?YdPglgEjxSGD0KVdwmCH5RYDI1bA4pgLYNzo2GBeU0uCoMngk4Xji9ljFYBA?=
 =?us-ascii?q?Q?=
X-IronPort-AV: E=Sophos;i="5.64,419,1559491200"; 
   d="scan'208";a="231796864"
Received: from unknown (HELO [192.168.1.222]) ([118.209.179.117])
  by icp-osb-irony-out2.iinet.net.au with ESMTP; 23 Aug 2019 09:00:22 +0800
Subject: [PATCH v2 12/15] xfs: mount-api - add xfs_fc_free()
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Date:   Fri, 23 Aug 2019 09:00:22 +0800
Message-ID: <156652202212.2607.8621137631843273531.stgit@fedora-28>
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

Add the fs_context_operations method .free that performs fs
context cleanup on context release.

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/xfs/xfs_super.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index aae0098fecab..9976163dc537 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -2129,10 +2129,32 @@ static const struct super_operations xfs_super_operations = {
 	.free_cached_objects	= xfs_fs_free_cached_objects,
 };
 
+static void xfs_fc_free(struct fs_context *fc)
+{
+	struct xfs_fs_context	*ctx = fc->fs_private;
+	struct xfs_mount	*mp = fc->s_fs_info;
+
+	if (mp) {
+		/*
+		 * If an error occurs before ownership the xfs_mount
+		 * info struct is passed to xfs by the VFS (by assigning
+		 * it to sb->s_fs_info and clearing the corresponding
+		 * fs_context field, which is done before calling fill
+		 * super via .get_tree()) there may be some strings to
+		 * cleanup.
+		 */
+		kfree(mp->m_logname);
+		kfree(mp->m_rtname);
+		kfree(mp);
+	}
+	kfree(ctx);
+}
+
 static const struct fs_context_operations xfs_context_ops = {
 	.parse_param = xfs_parse_param,
 	.get_tree    = xfs_get_tree,
 	.reconfigure = xfs_reconfigure,
+	.free	     = xfs_fc_free,
 };
 
 static struct file_system_type xfs_fs_type = {

