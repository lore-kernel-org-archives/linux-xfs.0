Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from icp-osb-irony-out1.external.iinet.net.au ([203.59.1.210]:33430
        "EHLO icp-osb-irony-out1.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726858AbfFXDIm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Jun 2019 23:08:42 -0400
Subject: [PATCH 08/10] xfs: mount-api - switch to new mount-api
From: Ian Kent <raven@themaw.net>
Date: Mon, 24 Jun 2019 10:59:07 +0800
Message-ID: <156134514772.2519.274012421344093746.stgit@fedora-28>
In-Reply-To: <156134510205.2519.16185588460828778620.stgit@fedora-28>
References: <156134510205.2519.16185588460828778620.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>, David Howells <dhowells@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>

The infrastructure needed to use the new mount-api is now
in place, switch over to use it.

Also remove Opt_err enum as it's no longer used.

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/xfs/xfs_super.c |   72 +++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 68 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 0a771e1390e7..6e6eace31e07 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -71,7 +71,7 @@ enum {
 	Opt_filestreams, Opt_quota, Opt_noquota, Opt_usrquota, Opt_grpquota,
 	Opt_prjquota, Opt_uquota, Opt_gquota, Opt_pquota,
 	Opt_uqnoenforce, Opt_gqnoenforce, Opt_pqnoenforce, Opt_qnoenforce,
-	Opt_discard, Opt_nodiscard, Opt_dax, Opt_err,
+	Opt_discard, Opt_nodiscard, Opt_dax,
 };
 
 static const match_table_t tokens = {
@@ -118,7 +118,6 @@ static const match_table_t tokens = {
 	{Opt_discard,	"discard"},	/* Discard unused blocks */
 	{Opt_nodiscard,	"nodiscard"},	/* Do not discard unused blocks */
 	{Opt_dax,	"dax"},		/* Enable direct access to bdev pages */
-	{Opt_err,	NULL},
 };
 
 static const struct fs_parameter_spec xfs_param_specs[] = {
@@ -2407,7 +2406,6 @@ static const struct super_operations xfs_super_operations = {
 	.freeze_fs		= xfs_fs_freeze,
 	.unfreeze_fs		= xfs_fs_unfreeze,
 	.statfs			= xfs_fs_statfs,
-	.remount_fs		= xfs_fs_remount,
 	.show_options		= xfs_fs_show_options,
 	.nr_cached_objects	= xfs_fs_nr_cached_objects,
 	.free_cached_objects	= xfs_fs_free_cached_objects,
@@ -2442,10 +2440,76 @@ static const struct fs_context_operations xfs_context_ops = {
 	.free	     = xfs_fc_free,
 };
 
+/*
+ * Set up the filesystem mount context.
+ */
+int xfs_init_fs_context(struct fs_context *fc)
+{
+	struct xfs_fs_context	*ctx;
+	struct xfs_mount	*mp;
+
+	ctx = kzalloc(sizeof(struct xfs_fs_context), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	mp = kzalloc(sizeof(struct xfs_mount), GFP_KERNEL);
+	if (!mp) {
+		kfree(ctx);
+		return -ENOMEM;
+	}
+
+	spin_lock_init(&mp->m_sb_lock);
+	spin_lock_init(&mp->m_agirotor_lock);
+	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_ATOMIC);
+	spin_lock_init(&mp->m_perag_lock);
+	mutex_init(&mp->m_growlock);
+	atomic_set(&mp->m_active_trans, 0);
+	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
+	INIT_DELAYED_WORK(&mp->m_eofblocks_work, xfs_eofblocks_worker);
+	INIT_DELAYED_WORK(&mp->m_cowblocks_work, xfs_cowblocks_worker);
+	mp->m_kobj.kobject.kset = xfs_kset;
+	/*
+	 * We don't create the finobt per-ag space reservation until after log
+	 * recovery, so we must set this to true so that an ifree transaction
+	 * started during log recovery will not depend on space reservations
+	 * for finobt expansion.
+	 */
+	mp->m_finobt_nores = true;
+
+	/*
+	 * Set some default flags that could be cleared by the mount option
+	 * parsing.
+	 */
+	mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
+
+	/*
+	 * These can be overridden by the mount option parsing.
+	 */
+	mp->m_logbufs = -1;
+	mp->m_logbsize = -1;
+
+	/*
+	 * Copy binary VFS mount flags we are interested in.
+	 */
+	if (fc->sb_flags & SB_RDONLY)
+		mp->m_flags |= XFS_MOUNT_RDONLY;
+	if (fc->sb_flags & SB_DIRSYNC)
+		mp->m_flags |= XFS_MOUNT_DIRSYNC;
+	if (fc->sb_flags & SB_SYNCHRONOUS)
+		mp->m_flags |= XFS_MOUNT_WSYNC;
+
+	fc->fs_private = ctx;
+	fc->s_fs_info = mp;
+	fc->ops = &xfs_context_ops;
+
+	return 0;
+}
+
 static struct file_system_type xfs_fs_type = {
 	.owner			= THIS_MODULE,
 	.name			= "xfs",
-	.mount			= xfs_fs_mount,
+	.init_fs_context	= xfs_init_fs_context,
+	.parameters		= &xfs_fs_parameters,
 	.kill_sb		= kill_block_super,
 	.fs_flags		= FS_REQUIRES_DEV,
 };
