Return-Path: <SRS0=5kOL=YZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 172ACCA9EC9
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 07:51:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC66A2080F
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 07:51:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729856AbfKAHvj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Nov 2019 03:51:39 -0400
Received: from icp-osb-irony-out7.external.iinet.net.au ([203.59.1.107]:9149
        "EHLO icp-osb-irony-out7.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729894AbfKAHvj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Nov 2019 03:51:39 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2AYAACY47td/xK90HYNVxsBAQEBAQE?=
 =?us-ascii?q?BBQEBAREBAQMDAQEBgWsEAQEBCwGEPIQoj1oBAQEBAQEGgRGKCIUwAYRthSi?=
 =?us-ascii?q?BewkBAQEBAQEBAQE3AQGDLYEOAwIChB42Bw4CDAEBAQQBAQEBAQUDAYVYhio?=
 =?us-ascii?q?CAQMjBFIQGA0CJgICRxAGE4V1sF51fzMaijeBDigBgWSKRHiBB4EQATODHYd?=
 =?us-ascii?q?Vgl4EjQkKgi83hkFDc5YCgi6VUAyOKAOLLi2paAKCCE0uCoMnUIM2F44wZ45?=
 =?us-ascii?q?sAQE?=
X-IPAS-Result: =?us-ascii?q?A2AYAACY47td/xK90HYNVxsBAQEBAQEBBQEBAREBAQMDA?=
 =?us-ascii?q?QEBgWsEAQEBCwGEPIQoj1oBAQEBAQEGgRGKCIUwAYRthSiBewkBAQEBAQEBA?=
 =?us-ascii?q?QE3AQGDLYEOAwIChB42Bw4CDAEBAQQBAQEBAQUDAYVYhioCAQMjBFIQGA0CJ?=
 =?us-ascii?q?gICRxAGE4V1sF51fzMaijeBDigBgWSKRHiBB4EQATODHYdVgl4EjQkKgi83h?=
 =?us-ascii?q?kFDc5YCgi6VUAyOKAOLLi2paAKCCE0uCoMnUIM2F44wZ45sAQE?=
X-IronPort-AV: E=Sophos;i="5.68,254,1569254400"; 
   d="scan'208";a="215830142"
Received: from unknown (HELO [192.168.1.222]) ([118.208.189.18])
  by icp-osb-irony-out7.iinet.net.au with ESMTP; 01 Nov 2019 15:51:22 +0800
Subject: [PATCH v8 15/16] xfs: move xfs_fc_get_tree() above
 xfs_fc_reconfigure()
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Fri, 01 Nov 2019 15:51:22 +0800
Message-ID: <157259468201.28278.11198315382109394618.stgit@fedora-28>
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

Now move xfs_fc_get_tree() and friends, also take the oppertunity to
change STATIC to static for the xfs_fs_put_super() function.

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/xfs/xfs_super.c |  116 ++++++++++++++++++++++++++--------------------------
 1 file changed, 58 insertions(+), 58 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 9c5ea74dbfd5..7ff35ee0dc8f 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1291,6 +1291,64 @@ xfs_destroy_percpu_counters(
 	percpu_counter_destroy(&mp->m_delalloc_blks);
 }
 
+static void
+xfs_fs_put_super(
+	struct super_block	*sb)
+{
+	struct xfs_mount	*mp = XFS_M(sb);
+
+	/* if ->fill_super failed, we have no mount to tear down */
+	if (!sb->s_fs_info)
+		return;
+
+	xfs_notice(mp, "Unmounting Filesystem");
+	xfs_filestream_unmount(mp);
+	xfs_unmountfs(mp);
+
+	xfs_freesb(mp);
+	free_percpu(mp->m_stats.xs_stats);
+	xfs_destroy_percpu_counters(mp);
+	xfs_destroy_mount_workqueues(mp);
+	xfs_close_devices(mp);
+
+	sb->s_fs_info = NULL;
+	xfs_mount_free(mp);
+}
+
+static long
+xfs_fs_nr_cached_objects(
+	struct super_block	*sb,
+	struct shrink_control	*sc)
+{
+	/* Paranoia: catch incorrect calls during mount setup or teardown */
+	if (WARN_ON_ONCE(!sb->s_fs_info))
+		return 0;
+	return xfs_reclaim_inodes_count(XFS_M(sb));
+}
+
+static long
+xfs_fs_free_cached_objects(
+	struct super_block	*sb,
+	struct shrink_control	*sc)
+{
+	return xfs_reclaim_inodes_nr(XFS_M(sb), sc->nr_to_scan);
+}
+
+static const struct super_operations xfs_super_operations = {
+	.alloc_inode		= xfs_fs_alloc_inode,
+	.destroy_inode		= xfs_fs_destroy_inode,
+	.dirty_inode		= xfs_fs_dirty_inode,
+	.drop_inode		= xfs_fs_drop_inode,
+	.put_super		= xfs_fs_put_super,
+	.sync_fs		= xfs_fs_sync_fs,
+	.freeze_fs		= xfs_fs_freeze,
+	.unfreeze_fs		= xfs_fs_unfreeze,
+	.statfs			= xfs_fs_statfs,
+	.show_options		= xfs_fs_show_options,
+	.nr_cached_objects	= xfs_fs_nr_cached_objects,
+	.free_cached_objects	= xfs_fs_free_cached_objects,
+};
+
 static struct xfs_mount *
 xfs_mount_alloc(void)
 {
@@ -1515,64 +1573,6 @@ xfs_fc_get_tree(
 	return get_tree_bdev(fc, xfs_fc_fill_super);
 }
 
-STATIC void
-xfs_fs_put_super(
-	struct super_block	*sb)
-{
-	struct xfs_mount	*mp = XFS_M(sb);
-
-	/* if ->fill_super failed, we have no mount to tear down */
-	if (!sb->s_fs_info)
-		return;
-
-	xfs_notice(mp, "Unmounting Filesystem");
-	xfs_filestream_unmount(mp);
-	xfs_unmountfs(mp);
-
-	xfs_freesb(mp);
-	free_percpu(mp->m_stats.xs_stats);
-	xfs_destroy_percpu_counters(mp);
-	xfs_destroy_mount_workqueues(mp);
-	xfs_close_devices(mp);
-
-	sb->s_fs_info = NULL;
-	xfs_mount_free(mp);
-}
-
-static long
-xfs_fs_nr_cached_objects(
-	struct super_block	*sb,
-	struct shrink_control	*sc)
-{
-	/* Paranoia: catch incorrect calls during mount setup or teardown */
-	if (WARN_ON_ONCE(!sb->s_fs_info))
-		return 0;
-	return xfs_reclaim_inodes_count(XFS_M(sb));
-}
-
-static long
-xfs_fs_free_cached_objects(
-	struct super_block	*sb,
-	struct shrink_control	*sc)
-{
-	return xfs_reclaim_inodes_nr(XFS_M(sb), sc->nr_to_scan);
-}
-
-static const struct super_operations xfs_super_operations = {
-	.alloc_inode		= xfs_fs_alloc_inode,
-	.destroy_inode		= xfs_fs_destroy_inode,
-	.dirty_inode		= xfs_fs_dirty_inode,
-	.drop_inode		= xfs_fs_drop_inode,
-	.put_super		= xfs_fs_put_super,
-	.sync_fs		= xfs_fs_sync_fs,
-	.freeze_fs		= xfs_fs_freeze,
-	.unfreeze_fs		= xfs_fs_unfreeze,
-	.statfs			= xfs_fs_statfs,
-	.show_options		= xfs_fs_show_options,
-	.nr_cached_objects	= xfs_fs_nr_cached_objects,
-	.free_cached_objects	= xfs_fs_free_cached_objects,
-};
-
 static int
 xfs_remount_rw(
 	struct xfs_mount	*mp)

