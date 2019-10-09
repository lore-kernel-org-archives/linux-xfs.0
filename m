Return-Path: <SRS0=7gTY=YC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDB30C47404
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 11:31:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1F3820B7C
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 11:31:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725914AbfJILbJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 07:31:09 -0400
Received: from icp-osb-irony-out3.external.iinet.net.au ([203.59.1.153]:33489
        "EHLO icp-osb-irony-out3.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729699AbfJILbJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 07:31:09 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2BZAQBxxJ1d/0e30XYNWRwBAQEBAQc?=
 =?us-ascii?q?BAREBBAQBAYF7hDqEI48oAQEBAwaBEYodhR+MDwkBAQEBAQEBAQE3AQGEOwM?=
 =?us-ascii?q?CAoJyOBMCDAEBAQQBAQEBAQUDAYVYhhoCAQMjBFIQGA0CJgICRxAGE4UZr29?=
 =?us-ascii?q?1fzMaiiyBDCiBZYpBeIEHgREzgx2HUoJYBI80N4VbYUOWWYIslTQMjhUDixw?=
 =?us-ascii?q?thAqlPYF6TS4KgydQgX8XjjBnjkIrgicBAQ?=
X-IPAS-Result: =?us-ascii?q?A2BZAQBxxJ1d/0e30XYNWRwBAQEBAQcBAREBBAQBAYF7h?=
 =?us-ascii?q?DqEI48oAQEBAwaBEYodhR+MDwkBAQEBAQEBAQE3AQGEOwMCAoJyOBMCDAEBA?=
 =?us-ascii?q?QQBAQEBAQUDAYVYhhoCAQMjBFIQGA0CJgICRxAGE4UZr291fzMaiiyBDCiBZ?=
 =?us-ascii?q?YpBeIEHgREzgx2HUoJYBI80N4VbYUOWWYIslTQMjhUDixwthAqlPYF6TS4Kg?=
 =?us-ascii?q?ydQgX8XjjBnjkIrgicBAQ?=
X-IronPort-AV: E=Sophos;i="5.67,273,1566835200"; 
   d="scan'208";a="216229069"
Received: from unknown (HELO [192.168.1.222]) ([118.209.183.71])
  by icp-osb-irony-out3.iinet.net.au with ESMTP; 09 Oct 2019 19:31:03 +0800
Subject: [PATCH v5 10/17] xfs: mount-api - add xfs_get_tree()
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Wed, 09 Oct 2019 19:31:03 +0800
Message-ID: <157062066316.32346.11258138585168789863.stgit@fedora-28>
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

Add the fs_context_operations method .get_tree that validates
mount options and fills the super block as previously done
by the file_system_type .mount method.

Signed-off-by: Ian Kent <raven@themaw.net>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_super.c |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index cc2da9093e34..314acafffd0b 100644
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
+		goto out_error;
+	mp->m_fsname_len = strlen(mp->m_fsname) + 1;
+
+	error = xfs_validate_params(mp, ctx, false);
+	if (error)
+		goto out_error;
+
+	error = __xfs_fs_fill_super(mp, silent);
+	if (error)
+		goto out_error;
+
+	return 0;
+
+ out_error:
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

