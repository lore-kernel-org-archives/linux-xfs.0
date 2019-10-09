Return-Path: <SRS0=7gTY=YC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E137C47404
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 11:31:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E2DB20B7C
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 11:31:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730384AbfJILbW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 07:31:22 -0400
Received: from icp-osb-irony-out3.external.iinet.net.au ([203.59.1.153]:33473
        "EHLO icp-osb-irony-out3.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730111AbfJILbW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 07:31:22 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2BZAQBxxJ1d/0e30XYNWRwBAQEBAQc?=
 =?us-ascii?q?BAREBBAQBAYF7hDqEI48oAQEBAwaBEYodhR+MDwkBAQEBAQEBAQE3AQGEOwM?=
 =?us-ascii?q?CAoJyOBMCDAEBAQQBAQEBAQUDAYVYhhoCAQMjBE0FEBgNAiYCAkcQBhOFGa9?=
 =?us-ascii?q?vdX8zGoosgQwogWWKQXiBB4EQNIMdh1KCWASPNDeGPEOWWYIslTQMjhUDixw?=
 =?us-ascii?q?thAqlPYF6TS4KgydQkEZnjkIrgicBAQ?=
X-IPAS-Result: =?us-ascii?q?A2BZAQBxxJ1d/0e30XYNWRwBAQEBAQcBAREBBAQBAYF7h?=
 =?us-ascii?q?DqEI48oAQEBAwaBEYodhR+MDwkBAQEBAQEBAQE3AQGEOwMCAoJyOBMCDAEBA?=
 =?us-ascii?q?QQBAQEBAQUDAYVYhhoCAQMjBE0FEBgNAiYCAkcQBhOFGa9vdX8zGoosgQwog?=
 =?us-ascii?q?WWKQXiBB4EQNIMdh1KCWASPNDeGPEOWWYIslTQMjhUDixwthAqlPYF6TS4Kg?=
 =?us-ascii?q?ydQkEZnjkIrgicBAQ?=
X-IronPort-AV: E=Sophos;i="5.67,273,1566835200"; 
   d="scan'208";a="216229097"
Received: from unknown (HELO [192.168.1.222]) ([118.209.183.71])
  by icp-osb-irony-out3.iinet.net.au with ESMTP; 09 Oct 2019 19:31:19 +0800
Subject: [PATCH v5 13/17] xfs: mount api - add xfs_reconfigure()
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Wed, 09 Oct 2019 19:31:19 +0800
Message-ID: <157062067944.32346.8228418435930532076.stgit@fedora-28>
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

Add the fs_context_operations method .reconfigure that performs
remount validation as previously done by the super_operations
.remount_fs method.

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/xfs/xfs_super.c |   62 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 7e634706626b..230b0e2a184c 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1544,6 +1544,67 @@ xfs_fs_remount(
 	return 0;
 }
 
+/*
+ * Logically we would return an error here to prevent users
+ * from believing they might have changed mount options using
+ * remount which can't be changed.
+ *
+ * But unfortunately mount(8) adds all options from mtab and
+ * fstab to the mount arguments in some cases so we can't
+ * blindly reject options, but have to check for each specified
+ * option if it actually differs from the currently set option
+ * and only reject it if that's the case.
+ *
+ * Until that is implemented we return success for every remount
+ * request, and silently ignore all options that we can't actually
+ * change.
+ */
+STATIC int
+xfs_reconfigure(
+	struct fs_context *fc)
+{
+	struct xfs_fs_context	*ctx = fc->fs_private;
+	struct xfs_mount	*mp = XFS_M(fc->root->d_sb);
+	struct xfs_mount        *new_mp = fc->s_fs_info;
+	xfs_sb_t		*sbp = &mp->m_sb;
+	int			flags = fc->sb_flags;
+	int			error;
+
+	error = xfs_validate_params(new_mp, ctx, false);
+	if (error)
+		return error;
+
+	/* inode32 -> inode64 */
+	if ((mp->m_flags & XFS_MOUNT_SMALL_INUMS) &&
+	    !(new_mp->m_flags & XFS_MOUNT_SMALL_INUMS)) {
+		mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
+		mp->m_maxagi = xfs_set_inode_alloc(mp, sbp->sb_agcount);
+	}
+
+	/* inode64 -> inode32 */
+	if (!(mp->m_flags & XFS_MOUNT_SMALL_INUMS) &&
+	    (new_mp->m_flags & XFS_MOUNT_SMALL_INUMS)) {
+		mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
+		mp->m_maxagi = xfs_set_inode_alloc(mp, sbp->sb_agcount);
+	}
+
+	/* ro -> rw */
+	if ((mp->m_flags & XFS_MOUNT_RDONLY) && !(flags & SB_RDONLY)) {
+		error = xfs_remount_rw(mp);
+		if (error)
+			return error;
+	}
+
+	/* rw -> ro */
+	if (!(mp->m_flags & XFS_MOUNT_RDONLY) && (flags & SB_RDONLY)) {
+		error = xfs_remount_ro(mp);
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
+
 /*
  * Second stage of a freeze. The data is already frozen so we only
  * need to take care of the metadata. Once that's done sync the superblock
@@ -2069,6 +2130,7 @@ static const struct super_operations xfs_super_operations = {
 static const struct fs_context_operations xfs_context_ops = {
 	.parse_param = xfs_parse_param,
 	.get_tree    = xfs_get_tree,
+	.reconfigure = xfs_reconfigure,
 };
 
 static struct file_system_type xfs_fs_type = {

