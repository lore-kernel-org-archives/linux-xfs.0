Return-Path: <SRS0=y7rh=X4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A68BC10F14
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Oct 2019 10:26:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4971C21A4C
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Oct 2019 10:26:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728689AbfJCK03 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Oct 2019 06:26:29 -0400
Received: from icp-osb-irony-out7.external.iinet.net.au ([203.59.1.107]:43057
        "EHLO icp-osb-irony-out7.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727657AbfJCK03 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Oct 2019 06:26:29 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2AiAADHy5Vd/7q70HYNWRwBAQEEAQE?=
 =?us-ascii?q?MBAEBgVQGAQELAYQ5hCKPKgMGgRGKGo8xgXsJAQEBAQEBAQEBNwEBhDsDAgK?=
 =?us-ascii?q?CaDUIDgIMAQEBBAEBAQEBBQMBhViGGgIBAyMETQUQGA0CJgICRxAGE4UZrgx?=
 =?us-ascii?q?1fzMaiieBDCgBgWSKQXiBB4EQNIMdh1GCWASPMDeGOUOWVIItlTMMgi2LZgO?=
 =?us-ascii?q?LHC2ECoswmW8DggxNLgqDJ1CQRmeOSSuCJwEB?=
X-IPAS-Result: =?us-ascii?q?A2AiAADHy5Vd/7q70HYNWRwBAQEEAQEMBAEBgVQGAQELA?=
 =?us-ascii?q?YQ5hCKPKgMGgRGKGo8xgXsJAQEBAQEBAQEBNwEBhDsDAgKCaDUIDgIMAQEBB?=
 =?us-ascii?q?AEBAQEBBQMBhViGGgIBAyMETQUQGA0CJgICRxAGE4UZrgx1fzMaiieBDCgBg?=
 =?us-ascii?q?WSKQXiBB4EQNIMdh1GCWASPMDeGOUOWVIItlTMMgi2LZgOLHC2ECoswmW8Dg?=
 =?us-ascii?q?gxNLgqDJ1CQRmeOSSuCJwEB?=
X-IronPort-AV: E=Sophos;i="5.67,251,1566835200"; 
   d="scan'208";a="207652925"
Received: from unknown (HELO [192.168.1.222]) ([118.208.187.186])
  by icp-osb-irony-out7.iinet.net.au with ESMTP; 03 Oct 2019 18:26:27 +0800
Subject: [PATCH v4 13/17] xfs: mount api - add xfs_reconfigure()
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Thu, 03 Oct 2019 18:26:27 +0800
Message-ID: <157009838772.13858.3951542955676751036.stgit@fedora-28>
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

Add the fs_context_operations method .reconfigure that performs
remount validation as previously done by the super_operations
.remount_fs method.

An attempt has also been made to update the comment about options
handling problems with mount(8) to reflect the current situation.

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/xfs/xfs_super.c |   68 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index ddcf030cca7c..06f650fb3a8c 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1544,6 +1544,73 @@ xfs_fs_remount(
 	return 0;
 }
 
+/*
+ * There can be problems with options passed from mount(8) when
+ * only the mount point path is given. The options are a merge
+ * of options from the fstab, mtab of the current mount and options
+ * given on the command line.
+ *
+ * But this can't be relied upon to accurately reflect the current
+ * mount options. Consequently rejecting options that can't be
+ * changed on reconfigure could erronously cause a mount failure.
+ *
+ * Nowadays it should be possible to compare incoming options
+ * and return an error for options that differ from the current
+ * mount and can't be changed on reconfigure.
+ *
+ * But this still might not always be the case so for now continue
+ * to return success for every reconfigure request, and silently
+ * ignore all options that can't actually be changed.
+ *
+ * See the commit log entry of this change for a more detailed
+ * desription of the problem.
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
@@ -2069,6 +2136,7 @@ static const struct super_operations xfs_super_operations = {
 static const struct fs_context_operations xfs_context_ops = {
 	.parse_param = xfs_parse_param,
 	.get_tree    = xfs_get_tree,
+	.reconfigure = xfs_reconfigure,
 };
 
 static struct file_system_type xfs_fs_type = {

