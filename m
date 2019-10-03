Return-Path: <SRS0=y7rh=X4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C240BC32792
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Oct 2019 10:26:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3422218DE
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Oct 2019 10:26:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729170AbfJCK0O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Oct 2019 06:26:14 -0400
Received: from icp-osb-irony-out7.external.iinet.net.au ([203.59.1.107]:43057
        "EHLO icp-osb-irony-out7.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729094AbfJCK0O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Oct 2019 06:26:14 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2AiAADHy5Vd/7q70HYNWRwBAQEEAQE?=
 =?us-ascii?q?MBAEBgVQGAQELAYQ5hCKPKgMGgRGKGo8xgXsJAQEBAQEBAQEBNwEBhDsDAgK?=
 =?us-ascii?q?CaDUIDgIMAQEBBAEBAQEBBQMBhViGGgIBAyMEUhAYDQImAgJHEAYThRmuDHV?=
 =?us-ascii?q?/MxqKJ4EMKAGBZIpBeIEHgREzgx2HUYJYBI8wN4VYYUOWVIItlTMMjhMDixw?=
 =?us-ascii?q?thAqlHwOCDE0uCoMnUIF/F44wZ45JK4InAQE?=
X-IPAS-Result: =?us-ascii?q?A2AiAADHy5Vd/7q70HYNWRwBAQEEAQEMBAEBgVQGAQELA?=
 =?us-ascii?q?YQ5hCKPKgMGgRGKGo8xgXsJAQEBAQEBAQEBNwEBhDsDAgKCaDUIDgIMAQEBB?=
 =?us-ascii?q?AEBAQEBBQMBhViGGgIBAyMEUhAYDQImAgJHEAYThRmuDHV/MxqKJ4EMKAGBZ?=
 =?us-ascii?q?IpBeIEHgREzgx2HUYJYBI8wN4VYYUOWVIItlTMMjhMDixwthAqlHwOCDE0uC?=
 =?us-ascii?q?oMnUIF/F44wZ45JK4InAQE?=
X-IronPort-AV: E=Sophos;i="5.67,251,1566835200"; 
   d="scan'208";a="207652864"
Received: from unknown (HELO [192.168.1.222]) ([118.208.187.186])
  by icp-osb-irony-out7.iinet.net.au with ESMTP; 03 Oct 2019 18:26:12 +0800
Subject: [PATCH v4 10/17] xfs: mount-api - add xfs_get_tree()
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Thu, 03 Oct 2019 18:26:12 +0800
Message-ID: <157009837210.13858.11725663486459207040.stgit@fedora-28>
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

Add the fs_context_operations method .get_tree that validates
mount options and fills the super block as previously done
by the file_system_type .mount method.

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/xfs/xfs_super.c |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index cc2da9093e34..b984120667da 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1925,6 +1925,51 @@ xfs_fs_fill_super(
 	return error;
 }
 
+STATIC int
+xfs_fill_super(
+	struct super_block	*sb,
+	struct fs_context	*fc)
+{
+	struct xfs_fs_context	*ctx = fc->fs_private;
+	struct xfs_mount	*mp = sb->s_fs_info;
+	int			silent = fc->sb_flags & SB_SILENT;
+	int			error = -ENOMEM;
+
+	mp->m_super = sb;
+
+	/*
+	 * set up the mount name first so all the errors will refer to the
+	 * correct device.
+	 */
+	mp->m_fsname = kstrndup(sb->s_id, MAXNAMELEN, GFP_KERNEL);
+	if (!mp->m_fsname)
+		goto out_free_fsname;
+	mp->m_fsname_len = strlen(mp->m_fsname) + 1;
+
+	error = xfs_validate_params(mp, ctx, false);
+	if (error)
+		goto out_free_fsname;
+
+	error = __xfs_fs_fill_super(mp, silent);
+	if (error)
+		goto out_free_fsname;
+
+	return 0;
+
+ out_free_fsname:
+	sb->s_fs_info = NULL;
+	xfs_free_fsname(mp);
+	kfree(mp);
+	return error;
+}
+
+STATIC int
+xfs_get_tree(
+	struct fs_context	*fc)
+{
+	return get_tree_bdev(fc, xfs_fill_super);
+}
+
 STATIC void
 xfs_fs_put_super(
 	struct super_block	*sb)
@@ -1995,6 +2040,11 @@ static const struct super_operations xfs_super_operations = {
 	.free_cached_objects	= xfs_fs_free_cached_objects,
 };
 
+static const struct fs_context_operations xfs_context_ops = {
+	.parse_param = xfs_parse_param,
+	.get_tree    = xfs_get_tree,
+};
+
 static struct file_system_type xfs_fs_type = {
 	.owner			= THIS_MODULE,
 	.name			= "xfs",

