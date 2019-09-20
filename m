Return-Path: <SRS0=+mcJ=XP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37EF4C4CEC9
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Sep 2019 09:56:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1479B2080F
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Sep 2019 09:56:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408602AbfITJ4m (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Sep 2019 05:56:42 -0400
Received: from icp-osb-irony-out5.external.iinet.net.au ([203.59.1.221]:6242
        "EHLO icp-osb-irony-out5.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2408596AbfITJ4m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Sep 2019 05:56:42 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2CNAQDfoYRd/zmr0HYNVxwBAQEEAQE?=
 =?us-ascii?q?HBAEBgWcChDKEIo9nAQEGgRGKGoUfjAkJAQEBAQEBAQEBNwEBhDoDAgKDKjg?=
 =?us-ascii?q?TAgwBAQEEAQEBAQEFAwGFWIEQARABhHcCAQMjBFIQGA0CJgICRxAGE4UZqwZ?=
 =?us-ascii?q?zfzMaii6BDCgBgWKKPniBB4FEgx2EMIMfglgEj1aFTV9ClkeCLJUlDI4HA4s?=
 =?us-ascii?q?OLYQGpQ2BeU0uCoMnUIF+F44vZoJriW6CUwEB?=
X-IPAS-Result: =?us-ascii?q?A2CNAQDfoYRd/zmr0HYNVxwBAQEEAQEHBAEBgWcChDKEI?=
 =?us-ascii?q?o9nAQEGgRGKGoUfjAkJAQEBAQEBAQEBNwEBhDoDAgKDKjgTAgwBAQEEAQEBA?=
 =?us-ascii?q?QEFAwGFWIEQARABhHcCAQMjBFIQGA0CJgICRxAGE4UZqwZzfzMaii6BDCgBg?=
 =?us-ascii?q?WKKPniBB4FEgx2EMIMfglgEj1aFTV9ClkeCLJUlDI4HA4sOLYQGpQ2BeU0uC?=
 =?us-ascii?q?oMnUIF+F44vZoJriW6CUwEB?=
X-IronPort-AV: E=Sophos;i="5.64,528,1559491200"; 
   d="scan'208";a="253491559"
Received: from unknown (HELO [192.168.1.222]) ([118.208.171.57])
  by icp-osb-irony-out5.iinet.net.au with ESMTP; 20 Sep 2019 17:56:40 +0800
Subject: [PATCH v3 13/16] xfs: mount-api - add xfs_fc_free()
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Date:   Fri, 20 Sep 2019 17:56:41 +0800
Message-ID: <156897340101.20210.12319397145422337643.stgit@fedora-28>
In-Reply-To: <156897321789.20210.339237101446767141.stgit@fedora-28>
References: <156897321789.20210.339237101446767141.stgit@fedora-28>
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
index 06b382290354..edb15bb98dde 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -2155,6 +2155,32 @@ static const struct super_operations xfs_super_operations = {
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
 static struct file_system_type xfs_fs_type = {
 	.owner			= THIS_MODULE,
 	.name			= "xfs",

