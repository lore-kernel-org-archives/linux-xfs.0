Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDB49EB64DD
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 22:27:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232249AbjG0W11 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jul 2023 18:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232185AbjG0W11 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2023 18:27:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 340A02D76
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 15:27:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5ADA61F57
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 22:27:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA9FC433C7;
        Thu, 27 Jul 2023 22:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690496845;
        bh=S+1ysFwRY5xt4iCxYmVl6C2kfo3nj+X34QvRM9uILKE=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=gBMHJ/S96QGWd/zWqjI3pPotDRS+KT5rElNkfZI7UEWJd9AwifmaTwzPaQv4zLzK0
         SFub3hsmWNBY0FV+zOTYeI+MUIMm15463qGRWB6WQP149xVUMWqRUr67V+Tvo17cO6
         PpGhVqlGaTO5tLOINsJoiOjlXc0rqI6qMo2dSS10heff2ZM0Nhjx+aBFApi9fss0TH
         uLBMZ9W+tbBdewk9fQ/wve7Atdm6g1f1bjkisEvUFIsRIM0AfI0PDvrDSne1aHpIqm
         QEi0iSGVQFWgbeKXqnRDpImzVWXoGggqDewRuagc3DqyXUd2c5O/edoJjcNwZLv5jH
         xoZmx8iRSF+ag==
Date:   Thu, 27 Jul 2023 15:27:24 -0700
Subject: [PATCH 1/2] xfs: create scaffolding for creating debugfs entries
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <169049623983.921701.11854916632868926473.stgit@frogsfrogsfrogs>
In-Reply-To: <169049623967.921701.643201943864960800.stgit@frogsfrogsfrogs>
References: <169049623967.921701.643201943864960800.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Set up debugfs directories for xfs as a whole, and a subdirectory for
each mounted filesystem.  This will enable the creation of debugfs files
in the next patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_linux.h |    1 +
 fs/xfs/xfs_mount.h |    1 +
 fs/xfs/xfs_super.c |   32 ++++++++++++++++++++++++++++++--
 fs/xfs/xfs_super.h |    2 ++
 4 files changed, 34 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 74dcb05069e89..e9d317a3dafe4 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -63,6 +63,7 @@ typedef __u32			xfs_nlink_t;
 #include <linux/rhashtable.h>
 #include <linux/xattr.h>
 #include <linux/mnt_idmapping.h>
+#include <linux/debugfs.h>
 
 #include <asm/page.h>
 #include <asm/div64.h>
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index e2866e7fa60c2..0b86bf10a4cc3 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -208,6 +208,7 @@ typedef struct xfs_mount {
 	uint64_t		m_resblks_avail;/* available reserved blocks */
 	uint64_t		m_resblks_save;	/* reserved blks @ remount,ro */
 	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
+	struct dentry		*m_debugfs;	/* debugfs parent */
 	struct xfs_kobj		m_kobj;
 	struct xfs_kobj		m_error_kobj;
 	struct xfs_kobj		m_error_meta_kobj;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 8185102431301..31ac4744fdbec 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -49,6 +49,7 @@
 
 static const struct super_operations xfs_super_operations;
 
+static struct dentry *xfs_debugfs;	/* top-level xfs debugfs dir */
 static struct kset *xfs_kset;		/* top-level xfs sysfs dir */
 #ifdef DEBUG
 static struct xfs_kobj xfs_dbg_kobj;	/* global debug sysfs attrs */
@@ -758,6 +759,7 @@ static void
 xfs_mount_free(
 	struct xfs_mount	*mp)
 {
+	debugfs_remove(mp->m_debugfs);
 	kfree(mp->m_rtname);
 	kfree(mp->m_logname);
 	kmem_free(mp);
@@ -1479,6 +1481,21 @@ xfs_fs_validate_params(
 	return 0;
 }
 
+struct dentry *
+xfs_debugfs_mkdir(
+	const char	*name,
+	struct dentry	*parent)
+{
+	struct dentry	*child;
+
+	/* Apparently we're expected to ignore error returns?? */
+	child = debugfs_create_dir(name, parent);
+	if (IS_ERR(child))
+		return NULL;
+
+	return child;
+}
+
 static int
 xfs_fs_fill_super(
 	struct super_block	*sb,
@@ -1521,6 +1538,13 @@ xfs_fs_fill_super(
 	if (error)
 		goto out_free_names;
 
+	if (xfs_debugfs) {
+		mp->m_debugfs = xfs_debugfs_mkdir(mp->m_super->s_id,
+						  xfs_debugfs);
+	} else {
+		mp->m_debugfs = NULL;
+	}
+
 	error = xfs_init_mount_workqueues(mp);
 	if (error)
 		goto out_close_devices;
@@ -2353,10 +2377,12 @@ init_xfs_fs(void)
 	if (error)
 		goto out_cleanup_procfs;
 
+	xfs_debugfs = xfs_debugfs_mkdir("xfs", NULL);
+
 	xfs_kset = kset_create_and_add("xfs", NULL, fs_kobj);
 	if (!xfs_kset) {
 		error = -ENOMEM;
-		goto out_sysctl_unregister;
+		goto out_debugfs_unregister;
 	}
 
 	xfsstats.xs_kobj.kobject.kset = xfs_kset;
@@ -2400,7 +2426,8 @@ init_xfs_fs(void)
 	free_percpu(xfsstats.xs_stats);
  out_kset_unregister:
 	kset_unregister(xfs_kset);
- out_sysctl_unregister:
+ out_debugfs_unregister:
+	debugfs_remove(xfs_debugfs);
 	xfs_sysctl_unregister();
  out_cleanup_procfs:
 	xfs_cleanup_procfs();
@@ -2427,6 +2454,7 @@ exit_xfs_fs(void)
 	xfs_sysfs_del(&xfsstats.xs_kobj);
 	free_percpu(xfsstats.xs_stats);
 	kset_unregister(xfs_kset);
+	debugfs_remove(xfs_debugfs);
 	xfs_sysctl_unregister();
 	xfs_cleanup_procfs();
 	xfs_mru_cache_uninit();
diff --git a/fs/xfs/xfs_super.h b/fs/xfs/xfs_super.h
index 364e2c2648a8a..302e6e5d6c7e2 100644
--- a/fs/xfs/xfs_super.h
+++ b/fs/xfs/xfs_super.h
@@ -100,4 +100,6 @@ extern struct workqueue_struct *xfs_discard_wq;
 
 #define XFS_M(sb)		((struct xfs_mount *)((sb)->s_fs_info))
 
+struct dentry *xfs_debugfs_mkdir(const char *name, struct dentry *parent);
+
 #endif	/* __XFS_SUPER_H__ */

