Return-Path: <SRS0=ckLY=XT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23704C432C1
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Sep 2019 13:23:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 008FE2064A
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Sep 2019 13:23:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505054AbfIXNXH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Sep 2019 09:23:07 -0400
Received: from icp-osb-irony-out7.external.iinet.net.au ([203.59.1.107]:5979
        "EHLO icp-osb-irony-out7.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2505051AbfIXNXH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Sep 2019 09:23:07 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2CuAQA1GIpd/9+j0HYNWBwBAQEEAQE?=
 =?us-ascii?q?MBAEBgWeEOoQij1kBAQEBAQEGgRGKGoUfjAkJAQEBAQEBAQEBNwEBhDoDAgK?=
 =?us-ascii?q?DRDgTAgwBAQEEAQEBAQEFAwGFWIYZAgEDIwRNBRAYDQImAgJHEAYThRmtE3N?=
 =?us-ascii?q?/MxqKNIEMKIFjij54gQeBEDSDHYdPglgEjG2CaYYsQpZIgiyMGYkMDIIqi10?=
 =?us-ascii?q?Diw8thAaLI5lqgXlNLgqDJ1CQRGaKUyuCJwEB?=
X-IPAS-Result: =?us-ascii?q?A2CuAQA1GIpd/9+j0HYNWBwBAQEEAQEMBAEBgWeEOoQij?=
 =?us-ascii?q?1kBAQEBAQEGgRGKGoUfjAkJAQEBAQEBAQEBNwEBhDoDAgKDRDgTAgwBAQEEA?=
 =?us-ascii?q?QEBAQEFAwGFWIYZAgEDIwRNBRAYDQImAgJHEAYThRmtE3N/MxqKNIEMKIFji?=
 =?us-ascii?q?j54gQeBEDSDHYdPglgEjG2CaYYsQpZIgiyMGYkMDIIqi10Diw8thAaLI5lqg?=
 =?us-ascii?q?XlNLgqDJ1CQRGaKUyuCJwEB?=
X-IronPort-AV: E=Sophos;i="5.64,544,1559491200"; 
   d="scan'208";a="205615212"
Received: from unknown (HELO [192.168.1.222]) ([118.208.163.223])
  by icp-osb-irony-out7.iinet.net.au with ESMTP; 24 Sep 2019 21:23:04 +0800
Subject: [REPOST PATCH v3 12/16] xfs: mount api - add xfs_reconfigure()
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Date:   Tue, 24 Sep 2019 21:23:04 +0800
Message-ID: <156933138468.20933.1616184640263037904.stgit@fedora-28>
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
index de75891c5551..e7627f7ca7f2 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1552,6 +1552,89 @@ xfs_fs_remount(
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
@@ -2077,6 +2160,7 @@ static const struct super_operations xfs_super_operations = {
 static const struct fs_context_operations xfs_context_ops = {
 	.parse_param = xfs_parse_param,
 	.get_tree    = xfs_get_tree,
+	.reconfigure = xfs_reconfigure,
 };
 
 static struct file_system_type xfs_fs_type = {

