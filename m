Return-Path: <SRS0=9rhF=Y4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE3ECCA9ECF
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 10:56:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 856EA22474
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 10:56:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728810AbfKDKz7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 05:55:59 -0500
Received: from icp-osb-irony-out4.external.iinet.net.au ([203.59.1.220]:34330
        "EHLO icp-osb-irony-out4.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727500AbfKDKz6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 05:55:58 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2AwAAC6AsBd/xK90HYNWRsBAQEBAQE?=
 =?us-ascii?q?BBQEBAREBAQMDAQEBgWwDAQEBCwGEPIQpj1gBAQEBAQEGgRGKCYUxhG6HIwk?=
 =?us-ascii?q?BAQEBAQEBAQE3AQGDLYEOAwIChDA3Bg4CDgEBAQQBAQEBAQUDAYVYhioCAQM?=
 =?us-ascii?q?jBFIQGA0CJgICRxAGE4V1sGJ1fzMaijOBDigBgWSKRniBB4EQATODHYdVgl4?=
 =?us-ascii?q?EjQoKgi83hkBDc5YCgi6VUQyOKAOLLi2pfIF7TS4KgydQgzcXjjBnjm0BAQ?=
X-IPAS-Result: =?us-ascii?q?A2AwAAC6AsBd/xK90HYNWRsBAQEBAQEBBQEBAREBAQMDA?=
 =?us-ascii?q?QEBgWwDAQEBCwGEPIQpj1gBAQEBAQEGgRGKCYUxhG6HIwkBAQEBAQEBAQE3A?=
 =?us-ascii?q?QGDLYEOAwIChDA3Bg4CDgEBAQQBAQEBAQUDAYVYhioCAQMjBFIQGA0CJgICR?=
 =?us-ascii?q?xAGE4V1sGJ1fzMaijOBDigBgWSKRniBB4EQATODHYdVgl4EjQoKgi83hkBDc?=
 =?us-ascii?q?5YCgi6VUQyOKAOLLi2pfIF7TS4KgydQgzcXjjBnjm0BAQ?=
X-IronPort-AV: E=Sophos;i="5.68,266,1569254400"; 
   d="scan'208";a="207138729"
Received: from unknown (HELO [192.168.1.222]) ([118.208.189.18])
  by icp-osb-irony-out4.iinet.net.au with ESMTP; 04 Nov 2019 18:55:55 +0800
Subject: [PATCH v9 15/17] xfs: move xfs_fc_get_tree() above
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
Date:   Mon, 04 Nov 2019 18:55:55 +0800
Message-ID: <157286495541.18393.8677396885063730295.stgit@fedora-28>
In-Reply-To: <157286480109.18393.6285224459642752559.stgit@fedora-28>
References: <157286480109.18393.6285224459642752559.stgit@fedora-28>
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
This is a straight code move, there aren't any functional changes.

Signed-off-by: Ian Kent <raven@themaw.net>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_super.c |  116 ++++++++++++++++++++++++++--------------------------
 1 file changed, 58 insertions(+), 58 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 2746051da8c1..a0233fc9f569 100644
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

