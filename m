Return-Path: <SRS0=+mcJ=XP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E92F3C49ED7
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Sep 2019 09:55:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFA7220665
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Sep 2019 09:55:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408595AbfITJzm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Sep 2019 05:55:42 -0400
Received: from icp-osb-irony-out5.external.iinet.net.au ([203.59.1.221]:6242
        "EHLO icp-osb-irony-out5.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405771AbfITJzm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Sep 2019 05:55:42 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2COAQDfoYRd/zmr0HYNVxwBAQEEAQE?=
 =?us-ascii?q?HBAEBgWcChDKEIo9nAQEGgREliXWFH4wJCQEBAQEBAQEBATcBAYQ6AwICgyo?=
 =?us-ascii?q?4EwIMAQEBBAEBAQEBBQMBhViBEAEQAYR3AgEDIwRSEBgIBQImAgJHEAYThRm?=
 =?us-ascii?q?rBnN/MxqKLoEMKAGBYoo+eIEHgREzgx2EDYNCglgEjE2DCYYsQpZHgiyVJQy?=
 =?us-ascii?q?OBwOLDi2pE4F5TS4KO4JsUIF+F44vZoJriW2CVAEB?=
X-IPAS-Result: =?us-ascii?q?A2COAQDfoYRd/zmr0HYNVxwBAQEEAQEHBAEBgWcChDKEI?=
 =?us-ascii?q?o9nAQEGgREliXWFH4wJCQEBAQEBAQEBATcBAYQ6AwICgyo4EwIMAQEBBAEBA?=
 =?us-ascii?q?QEBBQMBhViBEAEQAYR3AgEDIwRSEBgIBQImAgJHEAYThRmrBnN/MxqKLoEMK?=
 =?us-ascii?q?AGBYoo+eIEHgREzgx2EDYNCglgEjE2DCYYsQpZHgiyVJQyOBwOLDi2pE4F5T?=
 =?us-ascii?q?S4KO4JsUIF+F44vZoJriW2CVAEB?=
X-IronPort-AV: E=Sophos;i="5.64,528,1559491200"; 
   d="scan'208";a="253491438"
Received: from unknown (HELO [192.168.1.222]) ([118.208.171.57])
  by icp-osb-irony-out5.iinet.net.au with ESMTP; 20 Sep 2019 17:55:38 +0800
Subject: [PATCH v3 01/16] vfs: Create fs_context-aware mount_bdev()
 replacement
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Date:   Fri, 20 Sep 2019 17:55:38 +0800
Message-ID: <156897333849.20210.17630274935227065769.stgit@fedora-28>
In-Reply-To: <156897321789.20210.339237101446767141.stgit@fedora-28>
References: <156897321789.20210.339237101446767141.stgit@fedora-28>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Create a function, vfs_get_block_super(), that is fs_context-aware and a
replacement for mount_bdev().  It caches the block device pointer and file
open mode in the fs_context struct so that this information can be passed
into sget_fc()'s test and set functions.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: linux-block@vger.kernel.org
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/fs_context.c            |    2 +
 fs/super.c                 |  111 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs_context.h |    9 ++++
 3 files changed, 121 insertions(+), 1 deletion(-)

diff --git a/fs/fs_context.c b/fs/fs_context.c
index 103643c68e3f..270ecae32216 100644
--- a/fs/fs_context.c
+++ b/fs/fs_context.c
@@ -501,6 +501,8 @@ void put_fs_context(struct fs_context *fc)
 
 	if (fc->need_free && fc->ops && fc->ops->free)
 		fc->ops->free(fc);
+	if (fc->dev_destructor)
+		fc->dev_destructor(fc);
 
 	security_free_mnt_opts(&fc->security);
 	put_net(fc->net_ns);
diff --git a/fs/super.c b/fs/super.c
index 113c58f19425..95cf8a2d5b25 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1215,6 +1215,110 @@ int get_tree_single(struct fs_context *fc,
 EXPORT_SYMBOL(get_tree_single);
 
 #ifdef CONFIG_BLOCK
+static void fc_bdev_destructor(struct fs_context *fc)
+{
+	if (fc->bdev) {
+		blkdev_put(fc->bdev, fc->bdev_mode);
+		fc->bdev = NULL;
+	}
+}
+
+static int set_bdev_super_fc(struct super_block *s, struct fs_context *fc)
+{
+	s->s_mode = fc->bdev_mode;
+	s->s_bdev = fc->bdev;
+	s->s_dev = s->s_bdev->bd_dev;
+	s->s_bdi = bdi_get(s->s_bdev->bd_bdi);
+	fc->bdev = NULL;
+	return 0;
+}
+
+static int test_bdev_super_fc(struct super_block *s, struct fs_context *fc)
+{
+	return s->s_bdev == fc->bdev;
+}
+
+/**
+ * vfs_get_block_super - Get a superblock based on a single block device
+ * @fc: The filesystem context holding the parameters
+ * @keying: How to distinguish superblocks
+ * @fill_super: Helper to initialise a new superblock
+ */
+int vfs_get_block_super(struct fs_context *fc,
+			int (*fill_super)(struct super_block *,
+					  struct fs_context *))
+{
+	struct block_device *bdev;
+	struct super_block *s;
+	int error = 0;
+
+	fc->bdev_mode = FMODE_READ | FMODE_EXCL;
+	if (!(fc->sb_flags & SB_RDONLY))
+		fc->bdev_mode |= FMODE_WRITE;
+
+	if (!fc->source)
+		return invalf(fc, "No source specified");
+
+	bdev = blkdev_get_by_path(fc->source, fc->bdev_mode, fc->fs_type);
+	if (IS_ERR(bdev)) {
+		errorf(fc, "%s: Can't open blockdev", fc->source);
+		return PTR_ERR(bdev);
+	}
+
+	fc->dev_destructor = fc_bdev_destructor;
+	fc->bdev = bdev;
+
+	/* Once the superblock is inserted into the list by sget_fc(), s_umount
+	 * will protect the lockfs code from trying to start a snapshot while
+	 * we are mounting
+	 */
+	mutex_lock(&bdev->bd_fsfreeze_mutex);
+	if (bdev->bd_fsfreeze_count > 0) {
+		mutex_unlock(&bdev->bd_fsfreeze_mutex);
+		warnf(fc, "%pg: Can't mount, blockdev is frozen", bdev);
+		return -EBUSY;
+	}
+
+	fc->sb_flags |= SB_NOSEC;
+	s = sget_fc(fc, test_bdev_super_fc, set_bdev_super_fc);
+	mutex_unlock(&bdev->bd_fsfreeze_mutex);
+	if (IS_ERR(s))
+		return PTR_ERR(s);
+
+	if (s->s_root) {
+		/* Don't summarily change the RO/RW state. */
+		if ((fc->sb_flags ^ s->s_flags) & SB_RDONLY) {
+			warnf(fc, "%pg: Can't mount, would change RO state", bdev);
+			error = -EBUSY;
+			goto error_sb;
+		}
+
+		/* Leave fc->bdev to fc_bdev_destructor() to clean up to avoid
+		 * locking conflicts.
+		 */
+	} else {
+		snprintf(s->s_id, sizeof(s->s_id), "%pg", bdev);
+		sb_set_blocksize(s, block_size(bdev));
+		error = fill_super(s, fc);
+		if (error)
+			goto error_sb;
+
+		s->s_flags |= SB_ACTIVE;
+		bdev->bd_super = s;
+	}
+
+	BUG_ON(fc->root);
+	fc->root = dget(s->s_root);
+	return 0;
+
+error_sb:
+	deactivate_locked_super(s);
+	/* Leave fc->bdev to fc_bdev_destructor() to clean up */
+	return error;
+}
+EXPORT_SYMBOL(vfs_get_block_super);
+
+
 static int set_bdev_super(struct super_block *s, void *data)
 {
 	s->s_bdev = data;
@@ -1414,8 +1518,13 @@ int vfs_get_tree(struct fs_context *fc)
 	 * on the superblock.
 	 */
 	error = fc->ops->get_tree(fc);
-	if (error < 0)
+	if (error < 0) {
+		if (fc->dev_destructor) {
+			fc->dev_destructor(fc);
+			fc->dev_destructor = NULL;
+		}
 		return error;
+	}
 
 	if (!fc->root) {
 		pr_err("Filesystem %s get_tree() didn't set fc->root\n",
diff --git a/include/linux/fs_context.h b/include/linux/fs_context.h
index 7c6fe3d47fa6..ed5b4349671e 100644
--- a/include/linux/fs_context.h
+++ b/include/linux/fs_context.h
@@ -88,6 +88,9 @@ struct fs_context {
 	struct mutex		uapi_mutex;	/* Userspace access mutex */
 	struct file_system_type	*fs_type;
 	void			*fs_private;	/* The filesystem's context */
+	union {
+		struct block_device *bdev;	/* The backing blockdev (if applicable) */
+	};
 	struct dentry		*root;		/* The root and superblock */
 	struct user_namespace	*user_ns;	/* The user namespace for this mount */
 	struct net		*net_ns;	/* The network namespace for this mount */
@@ -97,6 +100,7 @@ struct fs_context {
 	const char		*subtype;	/* The subtype to set on the superblock */
 	void			*security;	/* Linux S&M options */
 	void			*s_fs_info;	/* Proposed s_fs_info */
+	fmode_t			bdev_mode;	/* File open mode for bdev */
 	unsigned int		sb_flags;	/* Proposed superblock flags (SB_*) */
 	unsigned int		sb_flags_mask;	/* Superblock flags that were changed */
 	unsigned int		s_iflags;	/* OR'd with sb->s_iflags */
@@ -105,6 +109,7 @@ struct fs_context {
 	enum fs_context_phase	phase:8;	/* The phase the context is in */
 	bool			need_free:1;	/* Need to call ops->free() */
 	bool			global:1;	/* Goes into &init_user_ns */
+	void (*dev_destructor)(struct fs_context *fc); /* For block or mtd */
 };
 
 struct fs_context_operations {
@@ -154,6 +159,10 @@ extern int get_tree_single(struct fs_context *fc,
 			 int (*fill_super)(struct super_block *sb,
 					   struct fs_context *fc));
 
+extern int vfs_get_block_super(struct fs_context *fc,
+			       int (*fill_super)(struct super_block *sb,
+						 struct fs_context *fc));
+
 extern const struct file_operations fscontext_fops;
 
 /*

