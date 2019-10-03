Return-Path: <SRS0=y7rh=X4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDE75C32792
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Oct 2019 10:25:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD9E521A4C
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Oct 2019 10:25:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728546AbfJCKZ0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Oct 2019 06:25:26 -0400
Received: from icp-osb-irony-out7.external.iinet.net.au ([203.59.1.107]:42874
        "EHLO icp-osb-irony-out7.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726199AbfJCKZ0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Oct 2019 06:25:26 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2CtAQDHy5Vd/7q70HYNWRwBAQEEAQE?=
 =?us-ascii?q?MBAEBgWeEOoQijyoDBoERJYl1kSwJAQEBAQEBAQEBNwEBhDsDAgKCaDgTAgw?=
 =?us-ascii?q?BAQEEAQEBAQEFAwGFWIYaAgEDIwRSEBgIBQImAgJHEAYThRmuDHV/MxqKJ4E?=
 =?us-ascii?q?MKIFlikF4gQeBRIMdh1GCWASPMDeGOUOWVIItlTMMjhMDixwtqT6Bek0uCju?=
 =?us-ascii?q?CbFCBfxeOMGeORyqCKgEB?=
X-IPAS-Result: =?us-ascii?q?A2CtAQDHy5Vd/7q70HYNWRwBAQEEAQEMBAEBgWeEOoQij?=
 =?us-ascii?q?yoDBoERJYl1kSwJAQEBAQEBAQEBNwEBhDsDAgKCaDgTAgwBAQEEAQEBAQEFA?=
 =?us-ascii?q?wGFWIYaAgEDIwRSEBgIBQImAgJHEAYThRmuDHV/MxqKJ4EMKIFlikF4gQeBR?=
 =?us-ascii?q?IMdh1GCWASPMDeGOUOWVIItlTMMjhMDixwtqT6Bek0uCjuCbFCBfxeOMGeOR?=
 =?us-ascii?q?yqCKgEB?=
X-IronPort-AV: E=Sophos;i="5.67,251,1566835200"; 
   d="scan'208";a="207652639"
Received: from unknown (HELO [192.168.1.222]) ([118.208.187.186])
  by icp-osb-irony-out7.iinet.net.au with ESMTP; 03 Oct 2019 18:25:23 +0800
Subject: [PATCH v4 01/17] vfs: Create fs_context-aware mount_bdev()
 replacement
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Thu, 03 Oct 2019 18:25:23 +0800
Message-ID: <157009832362.13858.8955723133061833207.stgit@fedora-28>
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

From: David Howells <dhowells@redhat.com>

Create a function, get_tree_bdev(), that is fs_context-aware and a
->get_tree() counterpart of mount_bdev().

It caches the block device pointer in the fs_context struct so that this
information can be passed into sget_fc()'s test and set functions.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: linux-block@vger.kernel.org
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/super.c                 |   94 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs_context.h |    5 ++
 2 files changed, 99 insertions(+)

diff --git a/fs/super.c b/fs/super.c
index 113c58f19425..a7f62c964e58 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1215,6 +1215,7 @@ int get_tree_single(struct fs_context *fc,
 EXPORT_SYMBOL(get_tree_single);
 
 #ifdef CONFIG_BLOCK
+
 static int set_bdev_super(struct super_block *s, void *data)
 {
 	s->s_bdev = data;
@@ -1224,6 +1225,99 @@ static int set_bdev_super(struct super_block *s, void *data)
 	return 0;
 }
 
+static int set_bdev_super_fc(struct super_block *s, struct fs_context *fc)
+{
+	return set_bdev_super(s, fc->sget_key);
+}
+
+static int test_bdev_super_fc(struct super_block *s, struct fs_context *fc)
+{
+	return s->s_bdev == fc->sget_key;
+}
+
+/**
+ * get_tree_bdev - Get a superblock based on a single block device
+ * @fc: The filesystem context holding the parameters
+ * @fill_super: Helper to initialise a new superblock
+ */
+int get_tree_bdev(struct fs_context *fc,
+		int (*fill_super)(struct super_block *,
+				  struct fs_context *))
+{
+	struct block_device *bdev;
+	struct super_block *s;
+	fmode_t mode = FMODE_READ | FMODE_EXCL;
+	int error = 0;
+
+	if (!(fc->sb_flags & SB_RDONLY))
+		mode |= FMODE_WRITE;
+
+	if (!fc->source)
+		return invalf(fc, "No source specified");
+
+	bdev = blkdev_get_by_path(fc->source, mode, fc->fs_type);
+	if (IS_ERR(bdev)) {
+		errorf(fc, "%s: Can't open blockdev", fc->source);
+		return PTR_ERR(bdev);
+	}
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
+	fc->sget_key = bdev;
+	s = sget_fc(fc, test_bdev_super_fc, set_bdev_super_fc);
+	mutex_unlock(&bdev->bd_fsfreeze_mutex);
+	if (IS_ERR(s))
+		return PTR_ERR(s);
+
+	if (s->s_root) {
+		/* Don't summarily change the RO/RW state. */
+		if ((fc->sb_flags ^ s->s_flags) & SB_RDONLY) {
+			warnf(fc, "%pg: Can't mount, would change RO state", bdev);
+			deactivate_locked_super(s);
+			blkdev_put(bdev, mode);
+			return -EBUSY;
+		}
+
+		/*
+		 * s_umount nests inside bd_mutex during
+		 * __invalidate_device().  blkdev_put() acquires
+		 * bd_mutex and can't be called under s_umount.  Drop
+		 * s_umount temporarily.  This is safe as we're
+		 * holding an active reference.
+		 */
+		up_write(&s->s_umount);
+		blkdev_put(bdev, mode);
+		down_write(&s->s_umount);
+	} else {
+		s->s_mode = mode;
+		snprintf(s->s_id, sizeof(s->s_id), "%pg", bdev);
+		sb_set_blocksize(s, block_size(bdev));
+		error = fill_super(s, fc);
+		if (error) {
+			deactivate_locked_super(s);
+			return error;
+		}
+
+		s->s_flags |= SB_ACTIVE;
+		bdev->bd_super = s;
+	}
+
+	BUG_ON(fc->root);
+	fc->root = dget(s->s_root);
+	return 0;
+}
+EXPORT_SYMBOL(get_tree_bdev);
+
 static int test_bdev_super(struct super_block *s, void *data)
 {
 	return (void *)s->s_bdev == data;
diff --git a/include/linux/fs_context.h b/include/linux/fs_context.h
index 7c6fe3d47fa6..7bf6179a83fd 100644
--- a/include/linux/fs_context.h
+++ b/include/linux/fs_context.h
@@ -88,6 +88,7 @@ struct fs_context {
 	struct mutex		uapi_mutex;	/* Userspace access mutex */
 	struct file_system_type	*fs_type;
 	void			*fs_private;	/* The filesystem's context */
+	void			*sget_key;
 	struct dentry		*root;		/* The root and superblock */
 	struct user_namespace	*user_ns;	/* The user namespace for this mount */
 	struct net		*net_ns;	/* The network namespace for this mount */
@@ -154,6 +155,10 @@ extern int get_tree_single(struct fs_context *fc,
 			 int (*fill_super)(struct super_block *sb,
 					   struct fs_context *fc));
 
+extern int get_tree_bdev(struct fs_context *fc,
+			       int (*fill_super)(struct super_block *sb,
+						 struct fs_context *fc));
+
 extern const struct file_operations fscontext_fops;
 
 /*

