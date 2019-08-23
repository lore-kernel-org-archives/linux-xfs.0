Return-Path: <SRS0=lWMA=WT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5E96C3A5A1
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Aug 2019 01:09:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C69AE233A0
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Aug 2019 01:09:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732721AbfHWBJ3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Aug 2019 21:09:29 -0400
Received: from icp-osb-irony-out2.external.iinet.net.au ([203.59.1.155]:5651
        "EHLO icp-osb-irony-out2.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387606AbfHWBJ3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Aug 2019 21:09:29 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2DWAQAROl9d/3Wz0XYNWBwBAQEEAQE?=
 =?us-ascii?q?HBAEBgWeEM4Qgj1YBAQaBEYoRkSMJAQEBAQEBAQEBNwEBhDoDAgKDAjgTAgk?=
 =?us-ascii?q?BAQEEAQIBAQYDAYVYhhkCAQMjBE0FEBgNAiYCAkcQBhOFGatQc38zGopAgQw?=
 =?us-ascii?q?ogWOKJHiBB4EQNIMdh0+CWASMOYJbhg9ClXcJgh+LaYhvDIIlizYDimAtg3O?=
 =?us-ascii?q?KdZhsgXlNLgqDJ5EUZYoGK4IlAQE?=
X-IPAS-Result: =?us-ascii?q?A2DWAQAROl9d/3Wz0XYNWBwBAQEEAQEHBAEBgWeEM4Qgj?=
 =?us-ascii?q?1YBAQaBEYoRkSMJAQEBAQEBAQEBNwEBhDoDAgKDAjgTAgkBAQEEAQIBAQYDA?=
 =?us-ascii?q?YVYhhkCAQMjBE0FEBgNAiYCAkcQBhOFGatQc38zGopAgQwogWOKJHiBB4EQN?=
 =?us-ascii?q?IMdh0+CWASMOYJbhg9ClXcJgh+LaYhvDIIlizYDimAtg3OKdZhsgXlNLgqDJ?=
 =?us-ascii?q?5EUZYoGK4IlAQE?=
X-IronPort-AV: E=Sophos;i="5.64,419,1559491200"; 
   d="scan'208";a="231796845"
Received: from unknown (HELO [192.168.1.222]) ([118.209.179.117])
  by icp-osb-irony-out2.iinet.net.au with ESMTP; 23 Aug 2019 09:00:16 +0800
Subject: [PATCH v2 11/15] xfs: mount api - add xfs_reconfigure()
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Date:   Fri, 23 Aug 2019 09:00:16 +0800
Message-ID: <156652201687.2607.7837619342391140067.stgit@fedora-28>
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

Add the fs_context_operations method .reconfigure that performs
remount validation as previously done by the super_operations
.remount_fs method.

An attempt has also been made to update the comment about options
handling problems with mount(8) to reflect the current situation.

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/xfs/xfs_super.c |   84 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 84 insertions(+)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 76374d602257..aae0098fecab 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1522,6 +1522,89 @@ xfs_fs_remount(
 	return 0;
 }
 
+/*
+ * There have been problems in the past with options passed from mount(8).
+ *
+ * The problem being that options passed by mount(8) in the case where only
+ * the the mount point path is given would consist of the existing fstab
+ * options with the options from mtab for the current mount merged in and
+ * the options given on the command line last. But the result couldn't be
+ * relied upon to accurately reflect the current mount options so that
+ * rejecting options that can't be changed on reconfigure could erronously
+ * cause mount failure.
+ *
+ * The mount-api uses a legacy mount options handler in the VFS to handle
+ * mount(8) so these options will continue to be passed. Even if mount(8)
+ * is updated to use fsopen()/fsconfig()/fsmount() it's likely to continue
+ * to set the existing options so options problems with reconfigure could
+ * continue.
+ *
+ * For the longest time mtab locking was a problem and this could have been
+ * one possible cause. It's also possible there could have been options
+ * order problems.
+ *
+ * That has changed now as mtab is a link to the proc file system mount
+ * table so mtab options should be always accurate.
+ *
+ * Consulting the util-linux maintainer (Karel Zak) he is confident that,
+ * in this case, the options passed by mount(8) will be those of the current
+ * mount and the options order should be a correct merge of fstab and mtab
+ * options, and new options given on the command line.
+ *
+ * So, in theory, it should be possible to compare incoming options and
+ * return an error for options that differ from the current mount and can't
+ * be changed on reconfigure to prevent users from believing they might have
+ * changed mount options using remount which can't be changed.
+ *
+ * But for now continue to return success for every reconfigure request, and
+ * silently ignore all options that can't actually be changed.
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
@@ -2049,6 +2132,7 @@ static const struct super_operations xfs_super_operations = {
 static const struct fs_context_operations xfs_context_ops = {
 	.parse_param = xfs_parse_param,
 	.get_tree    = xfs_get_tree,
+	.reconfigure = xfs_reconfigure,
 };
 
 static struct file_system_type xfs_fs_type = {

