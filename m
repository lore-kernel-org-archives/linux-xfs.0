Return-Path: <SRS0=5kOL=YZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22DDCCA9ECF
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 07:51:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED8C22080F
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 07:51:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730007AbfKAHvi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Nov 2019 03:51:38 -0400
Received: from icp-osb-irony-out7.external.iinet.net.au ([203.59.1.107]:9129
        "EHLO icp-osb-irony-out7.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729856AbfKAHvi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Nov 2019 03:51:38 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2CHAACY47td/xK90HYNVxsBAQEBAQE?=
 =?us-ascii?q?BBQEBAREBAQMDAQEBgX2EPYQoj1oBAQEBAQEGgRGKCIUwAYRthyMJAQEBAQE?=
 =?us-ascii?q?BAQEBNwEBhDsDAgKEHjgTAgwBAQEEAQEBAQEFAwGFWIYqAgEDIwRNBRAYDQI?=
 =?us-ascii?q?mAgJHEAYThXWwXnV/MxqKN4EOKIFlikR4gQeBEAEzgx2HVYJeBI0JCoIvN4Z?=
 =?us-ascii?q?BQ3OWAoIulVAMgjCLeAOLLi2PU5olgXpNLgqDJ1CDNheOMGeObAEB?=
X-IPAS-Result: =?us-ascii?q?A2CHAACY47td/xK90HYNVxsBAQEBAQEBBQEBAREBAQMDA?=
 =?us-ascii?q?QEBgX2EPYQoj1oBAQEBAQEGgRGKCIUwAYRthyMJAQEBAQEBAQEBNwEBhDsDA?=
 =?us-ascii?q?gKEHjgTAgwBAQEEAQEBAQEFAwGFWIYqAgEDIwRNBRAYDQImAgJHEAYThXWwX?=
 =?us-ascii?q?nV/MxqKN4EOKIFlikR4gQeBEAEzgx2HVYJeBI0JCoIvN4ZBQ3OWAoIulVAMg?=
 =?us-ascii?q?jCLeAOLLi2PU5olgXpNLgqDJ1CDNheOMGeObAEB?=
X-IronPort-AV: E=Sophos;i="5.68,254,1569254400"; 
   d="scan'208";a="215830120"
Received: from unknown (HELO [192.168.1.222]) ([118.208.189.18])
  by icp-osb-irony-out7.iinet.net.au with ESMTP; 01 Nov 2019 15:51:16 +0800
Subject: [PATCH v8 14/16] xfs: move xfs_fc_reconfigure() above xfs_fc_free()
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Fri, 01 Nov 2019 15:51:16 +0800
Message-ID: <157259467671.28278.14729127257650613602.stgit@fedora-28>
In-Reply-To: <157259452909.28278.1001302742832626046.stgit@fedora-28>
References: <157259452909.28278.1001302742832626046.stgit@fedora-28>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Grouping the options parsing and mount handling functions above the
struct fs_context_operations but below the struct super_operations
should improve (some) the grouping of the super operations while also
improving the grouping of the options parsing and mount handling code.

Start by moving xfs_fc_reconfigure() and friends.

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/xfs/xfs_super.c |  324 ++++++++++++++++++++++++++--------------------------
 1 file changed, 162 insertions(+), 162 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index bed914bc087b..9c5ea74dbfd5 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1139,168 +1139,6 @@ xfs_quiesce_attr(
 	xfs_log_quiesce(mp);
 }
 
-static int
-xfs_remount_rw(
-	struct xfs_mount	*mp)
-{
-	struct xfs_sb		*sbp = &mp->m_sb;
-	int error;
-
-	if (mp->m_flags & XFS_MOUNT_NORECOVERY) {
-		xfs_warn(mp,
-			"ro->rw transition prohibited on norecovery mount");
-		return -EINVAL;
-	}
-
-	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
-	    xfs_sb_has_ro_compat_feature(sbp, XFS_SB_FEAT_RO_COMPAT_UNKNOWN)) {
-		xfs_warn(mp,
-	"ro->rw transition prohibited on unknown (0x%x) ro-compat filesystem",
-			(sbp->sb_features_ro_compat &
-				XFS_SB_FEAT_RO_COMPAT_UNKNOWN));
-		return -EINVAL;
-	}
-
-	mp->m_flags &= ~XFS_MOUNT_RDONLY;
-
-	/*
-	 * If this is the first remount to writeable state we might have some
-	 * superblock changes to update.
-	 */
-	if (mp->m_update_sb) {
-		error = xfs_sync_sb(mp, false);
-		if (error) {
-			xfs_warn(mp, "failed to write sb changes");
-			return error;
-		}
-		mp->m_update_sb = false;
-	}
-
-	/*
-	 * Fill out the reserve pool if it is empty. Use the stashed value if
-	 * it is non-zero, otherwise go with the default.
-	 */
-	xfs_restore_resvblks(mp);
-	xfs_log_work_queue(mp);
-
-	/* Recover any CoW blocks that never got remapped. */
-	error = xfs_reflink_recover_cow(mp);
-	if (error) {
-		xfs_err(mp,
-			"Error %d recovering leftover CoW allocations.", error);
-			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
-		return error;
-	}
-	xfs_start_block_reaping(mp);
-
-	/* Create the per-AG metadata reservation pool .*/
-	error = xfs_fs_reserve_ag_blocks(mp);
-	if (error && error != -ENOSPC)
-		return error;
-
-	return 0;
-}
-
-static int
-xfs_remount_ro(
-	struct xfs_mount	*mp)
-{
-	int error;
-
-	/*
-	 * Cancel background eofb scanning so it cannot race with the final
-	 * log force+buftarg wait and deadlock the remount.
-	 */
-	xfs_stop_block_reaping(mp);
-
-	/* Get rid of any leftover CoW reservations... */
-	error = xfs_icache_free_cowblocks(mp, NULL);
-	if (error) {
-		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
-		return error;
-	}
-
-	/* Free the per-AG metadata reservation pool. */
-	error = xfs_fs_unreserve_ag_blocks(mp);
-	if (error) {
-		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
-		return error;
-	}
-
-	/*
-	 * Before we sync the metadata, we need to free up the reserve block
-	 * pool so that the used block count in the superblock on disk is
-	 * correct at the end of the remount. Stash the current* reserve pool
-	 * size so that if we get remounted rw, we can return it to the same
-	 * size.
-	 */
-	xfs_save_resvblks(mp);
-
-	xfs_quiesce_attr(mp);
-	mp->m_flags |= XFS_MOUNT_RDONLY;
-
-	return 0;
-}
-
-/*
- * Logically we would return an error here to prevent users from believing
- * they might have changed mount options using remount which can't be changed.
- *
- * But unfortunately mount(8) adds all options from mtab and fstab to the mount
- * arguments in some cases so we can't blindly reject options, but have to
- * check for each specified option if it actually differs from the currently
- * set option and only reject it if that's the case.
- *
- * Until that is implemented we return success for every remount request, and
- * silently ignore all options that we can't actually change.
- */
-static int
-xfs_fc_reconfigure(
-	struct fs_context *fc)
-{
-	struct xfs_mount	*mp = XFS_M(fc->root->d_sb);
-	struct xfs_mount        *new_mp = fc->s_fs_info;
-	xfs_sb_t		*sbp = &mp->m_sb;
-	int			flags = fc->sb_flags;
-	int			error;
-
-	sync_filesystem(mp->m_super);
-
-	error = xfs_fc_validate_params(new_mp);
-	if (error)
-		return error;
-
-	/* inode32 -> inode64 */
-	if ((mp->m_flags & XFS_MOUNT_SMALL_INUMS) &&
-	    !(new_mp->m_flags & XFS_MOUNT_SMALL_INUMS)) {
-		mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
-		mp->m_maxagi = xfs_set_inode_alloc(mp, sbp->sb_agcount);
-	}
-
-	/* inode64 -> inode32 */
-	if (!(mp->m_flags & XFS_MOUNT_SMALL_INUMS) &&
-	    (new_mp->m_flags & XFS_MOUNT_SMALL_INUMS)) {
-		mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
-		mp->m_maxagi = xfs_set_inode_alloc(mp, sbp->sb_agcount);
-	}
-
-	/* ro -> rw */
-	if ((mp->m_flags & XFS_MOUNT_RDONLY) && !(flags & SB_RDONLY)) {
-		error = xfs_remount_rw(mp);
-		if (error)
-			return error;
-	}
-
-	/* rw -> ro */
-	if (!(mp->m_flags & XFS_MOUNT_RDONLY) && (flags & SB_RDONLY)) {
-		error = xfs_remount_ro(mp);
-		if (error)
-			return error;
-	}
-
-	return 0;
-}
-
 /*
  * Second stage of a freeze. The data is already frozen so we only
  * need to take care of the metadata. Once that's done sync the superblock
@@ -1735,6 +1573,168 @@ static const struct super_operations xfs_super_operations = {
 	.free_cached_objects	= xfs_fs_free_cached_objects,
 };
 
+static int
+xfs_remount_rw(
+	struct xfs_mount	*mp)
+{
+	struct xfs_sb		*sbp = &mp->m_sb;
+	int error;
+
+	if (mp->m_flags & XFS_MOUNT_NORECOVERY) {
+		xfs_warn(mp,
+			"ro->rw transition prohibited on norecovery mount");
+		return -EINVAL;
+	}
+
+	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
+	    xfs_sb_has_ro_compat_feature(sbp, XFS_SB_FEAT_RO_COMPAT_UNKNOWN)) {
+		xfs_warn(mp,
+	"ro->rw transition prohibited on unknown (0x%x) ro-compat filesystem",
+			(sbp->sb_features_ro_compat &
+				XFS_SB_FEAT_RO_COMPAT_UNKNOWN));
+		return -EINVAL;
+	}
+
+	mp->m_flags &= ~XFS_MOUNT_RDONLY;
+
+	/*
+	 * If this is the first remount to writeable state we might have some
+	 * superblock changes to update.
+	 */
+	if (mp->m_update_sb) {
+		error = xfs_sync_sb(mp, false);
+		if (error) {
+			xfs_warn(mp, "failed to write sb changes");
+			return error;
+		}
+		mp->m_update_sb = false;
+	}
+
+	/*
+	 * Fill out the reserve pool if it is empty. Use the stashed value if
+	 * it is non-zero, otherwise go with the default.
+	 */
+	xfs_restore_resvblks(mp);
+	xfs_log_work_queue(mp);
+
+	/* Recover any CoW blocks that never got remapped. */
+	error = xfs_reflink_recover_cow(mp);
+	if (error) {
+		xfs_err(mp,
+			"Error %d recovering leftover CoW allocations.", error);
+			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+		return error;
+	}
+	xfs_start_block_reaping(mp);
+
+	/* Create the per-AG metadata reservation pool .*/
+	error = xfs_fs_reserve_ag_blocks(mp);
+	if (error && error != -ENOSPC)
+		return error;
+
+	return 0;
+}
+
+static int
+xfs_remount_ro(
+	struct xfs_mount	*mp)
+{
+	int error;
+
+	/*
+	 * Cancel background eofb scanning so it cannot race with the final
+	 * log force+buftarg wait and deadlock the remount.
+	 */
+	xfs_stop_block_reaping(mp);
+
+	/* Get rid of any leftover CoW reservations... */
+	error = xfs_icache_free_cowblocks(mp, NULL);
+	if (error) {
+		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+		return error;
+	}
+
+	/* Free the per-AG metadata reservation pool. */
+	error = xfs_fs_unreserve_ag_blocks(mp);
+	if (error) {
+		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+		return error;
+	}
+
+	/*
+	 * Before we sync the metadata, we need to free up the reserve block
+	 * pool so that the used block count in the superblock on disk is
+	 * correct at the end of the remount. Stash the current* reserve pool
+	 * size so that if we get remounted rw, we can return it to the same
+	 * size.
+	 */
+	xfs_save_resvblks(mp);
+
+	xfs_quiesce_attr(mp);
+	mp->m_flags |= XFS_MOUNT_RDONLY;
+
+	return 0;
+}
+
+/*
+ * Logically we would return an error here to prevent users from believing
+ * they might have changed mount options using remount which can't be changed.
+ *
+ * But unfortunately mount(8) adds all options from mtab and fstab to the mount
+ * arguments in some cases so we can't blindly reject options, but have to
+ * check for each specified option if it actually differs from the currently
+ * set option and only reject it if that's the case.
+ *
+ * Until that is implemented we return success for every remount request, and
+ * silently ignore all options that we can't actually change.
+ */
+static int
+xfs_fc_reconfigure(
+	struct fs_context *fc)
+{
+	struct xfs_mount	*mp = XFS_M(fc->root->d_sb);
+	struct xfs_mount        *new_mp = fc->s_fs_info;
+	xfs_sb_t		*sbp = &mp->m_sb;
+	int			flags = fc->sb_flags;
+	int			error;
+
+	sync_filesystem(mp->m_super);
+
+	error = xfs_fc_validate_params(new_mp);
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
 static void xfs_fc_free(struct fs_context *fc)
 {
 	struct xfs_mount	*mp = fc->s_fs_info;

