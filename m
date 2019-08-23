Return-Path: <SRS0=lWMA=WT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC952C3A5A1
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Aug 2019 01:09:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCD9E233A2
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Aug 2019 01:09:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387621AbfHWBJ1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Aug 2019 21:09:27 -0400
Received: from icp-osb-irony-out2.external.iinet.net.au ([203.59.1.155]:5622
        "EHLO icp-osb-irony-out2.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732721AbfHWBJ1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Aug 2019 21:09:27 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2DWAQAROl9d/3Wz0XYNWBwBAQEEAQE?=
 =?us-ascii?q?HBAEBgWeEM4Qgj1YBAQaBEYoRkSMJAQEBAQEBAQEBNwEBhDoDAgKDAjgTAgk?=
 =?us-ascii?q?BAQEEAQIBAQYDAYVYhhkCAQMjBFIQGA0CJgICRxAGE4UZq1BzfzMaikCBDCi?=
 =?us-ascii?q?BY4okeIEHgREzgx2HT4JYBI8UhTJdQpV3CYIflFgMjVsDimAtg3OjYYF5TS4?=
 =?us-ascii?q?KgyeCTheOL2WKBiuCJQEB?=
X-IPAS-Result: =?us-ascii?q?A2DWAQAROl9d/3Wz0XYNWBwBAQEEAQEHBAEBgWeEM4Qgj?=
 =?us-ascii?q?1YBAQaBEYoRkSMJAQEBAQEBAQEBNwEBhDoDAgKDAjgTAgkBAQEEAQIBAQYDA?=
 =?us-ascii?q?YVYhhkCAQMjBFIQGA0CJgICRxAGE4UZq1BzfzMaikCBDCiBY4okeIEHgREzg?=
 =?us-ascii?q?x2HT4JYBI8UhTJdQpV3CYIflFgMjVsDimAtg3OjYYF5TS4KgyeCTheOL2WKB?=
 =?us-ascii?q?iuCJQEB?=
X-IronPort-AV: E=Sophos;i="5.64,419,1559491200"; 
   d="scan'208";a="231796756"
Received: from unknown (HELO [192.168.1.222]) ([118.209.179.117])
  by icp-osb-irony-out2.iinet.net.au with ESMTP; 23 Aug 2019 09:00:01 +0800
Subject: [PATCH v2 08/15] xfs: mount-api - add xfs_get_tree()
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Date:   Fri, 23 Aug 2019 08:59:59 +0800
Message-ID: <156652199954.2607.8863934346265980917.stgit@fedora-28>
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

Add the fs_context_operations method .get_tree that validates
mount options and fills the super block as previously done
by the file_system_type .mount method.

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/xfs/xfs_super.c |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index d3fc9938987d..7de64808eb00 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1904,6 +1904,52 @@ xfs_fs_fill_super(
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
+		return -ENOMEM;
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
+
+	return error;
+}
+
+STATIC int
+xfs_get_tree(
+	struct fs_context	*fc)
+{
+	return vfs_get_block_super(fc, xfs_fill_super);
+}
+
 STATIC void
 xfs_fs_put_super(
 	struct super_block	*sb)
@@ -1976,6 +2022,7 @@ static const struct super_operations xfs_super_operations = {
 
 static const struct fs_context_operations xfs_context_ops = {
 	.parse_param = xfs_parse_param,
+	.get_tree    = xfs_get_tree,
 };
 
 static struct file_system_type xfs_fs_type = {

