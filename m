Return-Path: <SRS0=y7rh=X4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC9DAC10F14
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Oct 2019 10:26:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDF9B218DE
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Oct 2019 10:26:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729094AbfJCK0e (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Oct 2019 06:26:34 -0400
Received: from icp-osb-irony-out7.external.iinet.net.au ([203.59.1.107]:43057
        "EHLO icp-osb-irony-out7.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727657AbfJCK0e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Oct 2019 06:26:34 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2AVAADHy5Vd/7q70HYNWRwBAQEEAQE?=
 =?us-ascii?q?MBAEBgVMHAQELAYQ5hCKIIocIAwaBEYoajzGBewkBAQEBAQEBAQE3AQGEOwM?=
 =?us-ascii?q?CAoJoNAkOAgwBAQEEAQEBAQEFAwGFWIYaAgEDIwRSEBgNAiYCAkcQBhOFGa4?=
 =?us-ascii?q?MdX8zGoongQwoAYFkikF4gQeBRIMdhDCDIYJYBI8wN4Y5Q5ZUgi2VMwyOEwO?=
 =?us-ascii?q?LHC2ECqUdghFNLgqDJ1CBfxeOMGeOSIJTAQE?=
X-IPAS-Result: =?us-ascii?q?A2AVAADHy5Vd/7q70HYNWRwBAQEEAQEMBAEBgVMHAQELA?=
 =?us-ascii?q?YQ5hCKIIocIAwaBEYoajzGBewkBAQEBAQEBAQE3AQGEOwMCAoJoNAkOAgwBA?=
 =?us-ascii?q?QEEAQEBAQEFAwGFWIYaAgEDIwRSEBgNAiYCAkcQBhOFGa4MdX8zGoongQwoA?=
 =?us-ascii?q?YFkikF4gQeBRIMdhDCDIYJYBI8wN4Y5Q5ZUgi2VMwyOEwOLHC2ECqUdghFNL?=
 =?us-ascii?q?gqDJ1CBfxeOMGeOSIJTAQE?=
X-IronPort-AV: E=Sophos;i="5.67,251,1566835200"; 
   d="scan'208";a="207652939"
Received: from unknown (HELO [192.168.1.222]) ([118.208.187.186])
  by icp-osb-irony-out7.iinet.net.au with ESMTP; 03 Oct 2019 18:26:33 +0800
Subject: [PATCH v4 14/17] xfs: mount-api - add xfs_fc_free()
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Thu, 03 Oct 2019 18:26:32 +0800
Message-ID: <157009839296.13858.9863401564865806171.stgit@fedora-28>
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

Add the fs_context_operations method .free that performs fs
context cleanup on context release.

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/xfs/xfs_super.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 06f650fb3a8c..4f2963ff9e06 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -2133,10 +2133,36 @@ static const struct super_operations xfs_super_operations = {
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
+	 * On super block allocation the mount info struct, mp,
+	 * is moved into private super block info field ->s_fs_info
+	 * of the newly allocated super block. But if an error occurs
+	 * before this happens it's the responsibility of the fs
+	 * context to release the mount info struct.
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

