Return-Path: <SRS0=pjFm=YJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15616ECE59F
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 00:41:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0C2D2067B
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 00:41:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390290AbfJPAlZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Oct 2019 20:41:25 -0400
Received: from icp-osb-irony-out1.external.iinet.net.au ([203.59.1.210]:40401
        "EHLO icp-osb-irony-out1.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388302AbfJPAlZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Oct 2019 20:41:25 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2DeAQDRZqZd/0e30XYNWRwBAQEBAQc?=
 =?us-ascii?q?BAREBBAQBAYF7hDyEJY8zAQEBAQEBBosuhSABjA4JAQEBAQEBAQEBNwEBhDs?=
 =?us-ascii?q?DAgKDEjgTAgwBAQEEAQEBAQEFAwGFWIYaAgEDIwRSEBgNAiYCAkcQBhOFda4?=
 =?us-ascii?q?HdX8zGoopgQwogWWKQXiBB4ERg1CHUoJeBI0Hgi83hV1hQ5ZdgiyVNgyOFgO?=
 =?us-ascii?q?LHS2pUIF6TS4KgydQgX8XjjBnkVEBAQ?=
X-IPAS-Result: =?us-ascii?q?A2DeAQDRZqZd/0e30XYNWRwBAQEBAQcBAREBBAQBAYF7h?=
 =?us-ascii?q?DyEJY8zAQEBAQEBBosuhSABjA4JAQEBAQEBAQEBNwEBhDsDAgKDEjgTAgwBA?=
 =?us-ascii?q?QEEAQEBAQEFAwGFWIYaAgEDIwRSEBgNAiYCAkcQBhOFda4HdX8zGoopgQwog?=
 =?us-ascii?q?WWKQXiBB4ERg1CHUoJeBI0Hgi83hV1hQ5ZdgiyVNgyOFgOLHS2pUIF6TS4Kg?=
 =?us-ascii?q?ydQgX8XjjBnkVEBAQ?=
X-IronPort-AV: E=Sophos;i="5.67,301,1566835200"; 
   d="scan'208";a="247444145"
Received: from unknown (HELO [192.168.1.222]) ([118.209.183.71])
  by icp-osb-irony-out1.iinet.net.au with ESMTP; 16 Oct 2019 08:41:03 +0800
Subject: [PATCH v6 04/12] xfs: use super s_id instead of mount info m_fsname
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Wed, 16 Oct 2019 08:41:03 +0800
Message-ID: <157118646315.9678.439818770752389112.stgit@fedora-28>
In-Reply-To: <157118625324.9678.16275725173770634823.stgit@fedora-28>
References: <157118625324.9678.16275725173770634823.stgit@fedora-28>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Eliminate mount info field m_fsname by using the super block s_id
field directly.

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/xfs/xfs_error.c     |    2 +-
 fs/xfs/xfs_log.c       |    2 +-
 fs/xfs/xfs_message.c   |    4 ++--
 fs/xfs/xfs_mount.c     |    5 +++--
 fs/xfs/xfs_mount.h     |    1 -
 fs/xfs/xfs_pnfs.c      |    2 +-
 fs/xfs/xfs_super.c     |   35 +++++++++++++----------------------
 fs/xfs/xfs_trans_ail.c |    2 +-
 8 files changed, 22 insertions(+), 31 deletions(-)

diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 849fd4476950..3ff3fc202522 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -257,7 +257,7 @@ xfs_errortag_test(
 
 	xfs_warn_ratelimited(mp,
 "Injecting error (%s) at file %s, line %d, on filesystem \"%s\"",
-			expression, file, line, mp->m_fsname);
+			expression, file, line, mp->m_super->s_id);
 	return true;
 }
 
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index a2beee9f74da..ed99f4f063c3 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1479,7 +1479,7 @@ xlog_alloc_log(
 
 	log->l_ioend_workqueue = alloc_workqueue("xfs-log/%s",
 			WQ_MEM_RECLAIM | WQ_FREEZABLE | WQ_HIGHPRI, 0,
-			mp->m_fsname);
+			mp->m_super->s_id);
 	if (!log->l_ioend_workqueue)
 		goto out_free_iclog;
 
diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
index 9804efe525a9..aaea6faf5acc 100644
--- a/fs/xfs/xfs_message.c
+++ b/fs/xfs/xfs_message.c
@@ -20,8 +20,8 @@ __xfs_printk(
 	const struct xfs_mount	*mp,
 	struct va_format	*vaf)
 {
-	if (mp && mp->m_fsname) {
-		printk("%sXFS (%s): %pV\n", level, mp->m_fsname, vaf);
+	if (mp && mp->m_super && mp->m_super->s_id) {
+		printk("%sXFS (%s): %pV\n", level, mp->m_super->s_id, vaf);
 		return;
 	}
 	printk("%sXFS: %pV\n", level, vaf);
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index ba5b6f3b2b88..b6145a70a593 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -706,7 +706,8 @@ xfs_mountfs(
 	/* enable fail_at_unmount as default */
 	mp->m_fail_unmount = true;
 
-	error = xfs_sysfs_init(&mp->m_kobj, &xfs_mp_ktype, NULL, mp->m_fsname);
+	error = xfs_sysfs_init(&mp->m_kobj, &xfs_mp_ktype,
+			       NULL, mp->m_super->s_id);
 	if (error)
 		goto out;
 
@@ -1277,7 +1278,7 @@ xfs_mod_fdblocks(
 	printk_once(KERN_WARNING
 		"Filesystem \"%s\": reserve blocks depleted! "
 		"Consider increasing reserve pool size.",
-		mp->m_fsname);
+		mp->m_super->s_id);
 fdblocks_enospc:
 	spin_unlock(&mp->m_sb_lock);
 	return -ENOSPC;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index b3230f7ca2bf..f2a9f316fa6c 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -89,7 +89,6 @@ typedef struct xfs_mount {
 	struct percpu_counter	m_delalloc_blks;
 
 	struct xfs_buf		*m_sb_bp;	/* buffer for superblock */
-	char			*m_fsname;	/* filesystem name */
 	char			*m_rtname;	/* realtime device name */
 	char			*m_logname;	/* external log device name */
 	int			m_bsize;	/* fs logical block size */
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index a339bd5fa260..81df10f69ade 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -59,7 +59,7 @@ xfs_fs_get_uuid(
 
 	printk_once(KERN_NOTICE
 "XFS (%s): using experimental pNFS feature, use at your own risk!\n",
-		mp->m_fsname);
+		mp->m_super->s_id);
 
 	if (*len < sizeof(uuid_t))
 		return -EINVAL;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index cfa306f62bec..5876c2b551b5 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -165,14 +165,6 @@ xfs_parseargs(
 	int			iosize = 0;
 	uint8_t			iosizelog = 0;
 
-	/*
-	 * set up the mount name first so all the errors will refer to the
-	 * correct device.
-	 */
-	mp->m_fsname = kstrndup(sb->s_id, MAXNAMELEN, GFP_KERNEL);
-	if (!mp->m_fsname)
-		return -ENOMEM;
-
 	/*
 	 * Copy binary VFS mount flags we are interested in.
 	 */
@@ -805,33 +797,33 @@ xfs_init_mount_workqueues(
 	struct xfs_mount	*mp)
 {
 	mp->m_buf_workqueue = alloc_workqueue("xfs-buf/%s",
-			WQ_MEM_RECLAIM|WQ_FREEZABLE, 1, mp->m_fsname);
+			WQ_MEM_RECLAIM|WQ_FREEZABLE, 1, mp->m_super->s_id);
 	if (!mp->m_buf_workqueue)
 		goto out;
 
 	mp->m_unwritten_workqueue = alloc_workqueue("xfs-conv/%s",
-			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0, mp->m_fsname);
+			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0, mp->m_super->s_id);
 	if (!mp->m_unwritten_workqueue)
 		goto out_destroy_buf;
 
 	mp->m_cil_workqueue = alloc_workqueue("xfs-cil/%s",
 			WQ_MEM_RECLAIM | WQ_FREEZABLE | WQ_UNBOUND,
-			0, mp->m_fsname);
+			0, mp->m_super->s_id);
 	if (!mp->m_cil_workqueue)
 		goto out_destroy_unwritten;
 
 	mp->m_reclaim_workqueue = alloc_workqueue("xfs-reclaim/%s",
-			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0, mp->m_fsname);
+			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0, mp->m_super->s_id);
 	if (!mp->m_reclaim_workqueue)
 		goto out_destroy_cil;
 
 	mp->m_eofblocks_workqueue = alloc_workqueue("xfs-eofblocks/%s",
-			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0, mp->m_fsname);
+			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0, mp->m_super->s_id);
 	if (!mp->m_eofblocks_workqueue)
 		goto out_destroy_reclaim;
 
 	mp->m_sync_workqueue = alloc_workqueue("xfs-sync/%s", WQ_FREEZABLE, 0,
-					       mp->m_fsname);
+					       mp->m_super->s_id);
 	if (!mp->m_sync_workqueue)
 		goto out_destroy_eofb;
 
@@ -1036,10 +1028,9 @@ xfs_fs_drop_inode(
 }
 
 STATIC void
-xfs_free_fsname(
+xfs_free_names(
 	struct xfs_mount	*mp)
 {
-	kfree(mp->m_fsname);
 	kfree(mp->m_rtname);
 	kfree(mp->m_logname);
 }
@@ -1216,7 +1207,7 @@ xfs_test_remount_options(
 
 	tmp_mp->m_super = sb;
 	error = xfs_parseargs(tmp_mp, options);
-	xfs_free_fsname(tmp_mp);
+	xfs_free_names(tmp_mp);
 	kmem_free(tmp_mp);
 
 	return error;
@@ -1591,7 +1582,7 @@ xfs_fs_fill_super(
 
 	error = xfs_parseargs(mp, (char *)data);
 	if (error)
-		goto out_free_fsname;
+		goto out_free_names;
 
 	sb_min_blocksize(sb, BBSIZE);
 	sb->s_xattr = xfs_xattr_handlers;
@@ -1618,7 +1609,7 @@ xfs_fs_fill_super(
 
 	error = xfs_open_devices(mp);
 	if (error)
-		goto out_free_fsname;
+		goto out_free_names;
 
 	error = xfs_init_mount_workqueues(mp);
 	if (error)
@@ -1755,9 +1746,9 @@ xfs_fs_fill_super(
 	xfs_destroy_mount_workqueues(mp);
  out_close_devices:
 	xfs_close_devices(mp);
- out_free_fsname:
+ out_free_names:
 	sb->s_fs_info = NULL;
-	xfs_free_fsname(mp);
+	xfs_free_names(mp);
 	kfree(mp);
  out:
 	return error;
@@ -1789,7 +1780,7 @@ xfs_fs_put_super(
 	xfs_close_devices(mp);
 
 	sb->s_fs_info = NULL;
-	xfs_free_fsname(mp);
+	xfs_free_names(mp);
 	kfree(mp);
 }
 
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 6ccfd75d3c24..aea71ee189f5 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -836,7 +836,7 @@ xfs_trans_ail_init(
 	init_waitqueue_head(&ailp->ail_empty);
 
 	ailp->ail_task = kthread_run(xfsaild, ailp, "xfsaild/%s",
-			ailp->ail_mount->m_fsname);
+			ailp->ail_mount->m_super->s_id);
 	if (IS_ERR(ailp->ail_task))
 		goto out_free_ailp;
 

