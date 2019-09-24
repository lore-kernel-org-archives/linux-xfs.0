Return-Path: <SRS0=ckLY=XT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB79BC432C1
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Sep 2019 13:23:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCB252064A
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Sep 2019 13:23:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2632729AbfIXNXM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Sep 2019 09:23:12 -0400
Received: from icp-osb-irony-out7.external.iinet.net.au ([203.59.1.107]:5979
        "EHLO icp-osb-irony-out7.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2505051AbfIXNXM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Sep 2019 09:23:12 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2BmAAA1GIpd/9+j0HYNWBwBAQEEAQE?=
 =?us-ascii?q?MBAEBgVYEAQELAYQ5hCKPWQEBAQEBAQaBEYoahR+MCQkBAQEBAQEBAQE3AQG?=
 =?us-ascii?q?EOgMCAoNENwYOAgwBAQEEAQEBAQEFAwGFWIYZAgEDIwRSEBgNAiYCAkcQBhO?=
 =?us-ascii?q?FGa0Tc38zGoo0gQwoAYFiij54gQeBRIMdhDCDH4JYBI9WhixClkiCLJUlDI4?=
 =?us-ascii?q?HA4sPLYQGpQyBek0uCoMnUIF+F44vZopSglMBAQ?=
X-IPAS-Result: =?us-ascii?q?A2BmAAA1GIpd/9+j0HYNWBwBAQEEAQEMBAEBgVYEAQELA?=
 =?us-ascii?q?YQ5hCKPWQEBAQEBAQaBEYoahR+MCQkBAQEBAQEBAQE3AQGEOgMCAoNENwYOA?=
 =?us-ascii?q?gwBAQEEAQEBAQEFAwGFWIYZAgEDIwRSEBgNAiYCAkcQBhOFGa0Tc38zGoo0g?=
 =?us-ascii?q?QwoAYFiij54gQeBRIMdhDCDH4JYBI9WhixClkiCLJUlDI4HA4sPLYQGpQyBe?=
 =?us-ascii?q?k0uCoMnUIF+F44vZopSglMBAQ?=
X-IronPort-AV: E=Sophos;i="5.64,544,1559491200"; 
   d="scan'208";a="205615220"
Received: from unknown (HELO [192.168.1.222]) ([118.208.163.223])
  by icp-osb-irony-out7.iinet.net.au with ESMTP; 24 Sep 2019 21:23:10 +0800
Subject: [REPOST PATCH v3 13/16] xfs: mount-api - add xfs_fc_free()
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Date:   Tue, 24 Sep 2019 21:23:09 +0800
Message-ID: <156933138994.20933.13243420107808961029.stgit@fedora-28>
In-Reply-To: <156933112949.20933.12761540130806431294.stgit@fedora-28>
References: <156933112949.20933.12761540130806431294.stgit@fedora-28>
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
 fs/xfs/xfs_super.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index e7627f7ca7f2..5bc2363269a9 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -2157,10 +2157,37 @@ static const struct super_operations xfs_super_operations = {
 	.free_cached_objects	= xfs_fs_free_cached_objects,
 };
 
+static void xfs_fc_free(struct fs_context *fc)
+{
+	struct xfs_fs_context	*ctx = fc->fs_private;
+	struct xfs_mount	*mp = fc->s_fs_info;
+
+	/*
+	 * When the mount context is initialized the private
+	 * struct xfs_mount info (mp) is allocated and stored in
+	 * the fs context along with the struct xfs_fs_context
+	 * (ctx) mount context working working storage.
+	 *
+	 * On success the mount info struct, mp, is moved into
+	 * private info super block field ->s_fs_info of the
+	 * newly allocated super block. But if an error occurs
+	 * before this happens it's the responsibility of the fs
+	 * context to release the mount info struct in addition
+	 * to the mount context working storage.
+	 */
+	if (mp) {
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
+	.free        = xfs_fc_free,
 };
 
 static struct file_system_type xfs_fs_type = {

