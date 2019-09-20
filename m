Return-Path: <SRS0=+mcJ=XP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4344BC49ED7
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Sep 2019 09:56:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0EC1420665
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Sep 2019 09:56:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437957AbfITJ4R (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Sep 2019 05:56:17 -0400
Received: from icp-osb-irony-out5.external.iinet.net.au ([203.59.1.221]:6242
        "EHLO icp-osb-irony-out5.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2408596AbfITJ4R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Sep 2019 05:56:17 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2COAQDfoYRd/zmr0HYNVxwBAQEEAQE?=
 =?us-ascii?q?HBAEBgWcChDKEIo9nAQEGgRGKGoUfhGqHHwkBAQEBAQEBAQE3AQGEOgMCAoM?=
 =?us-ascii?q?qOBMCDAEBAQQBAQEBAQUDAYVYgRABEAGEdwIBAyMEUhAYDQImAgJHEAYThRm?=
 =?us-ascii?q?rBnN/MxqKLoEMKAGBYoo+eIEHgREzgx2HT4JYBIxxgmWGLEKWR4IslSUMjgc?=
 =?us-ascii?q?Diw4thAalDYF5TS4KgydQgX4Xji9mgmuMQQEB?=
X-IPAS-Result: =?us-ascii?q?A2COAQDfoYRd/zmr0HYNVxwBAQEEAQEHBAEBgWcChDKEI?=
 =?us-ascii?q?o9nAQEGgRGKGoUfhGqHHwkBAQEBAQEBAQE3AQGEOgMCAoMqOBMCDAEBAQQBA?=
 =?us-ascii?q?QEBAQUDAYVYgRABEAGEdwIBAyMEUhAYDQImAgJHEAYThRmrBnN/MxqKLoEMK?=
 =?us-ascii?q?AGBYoo+eIEHgREzgx2HT4JYBIxxgmWGLEKWR4IslSUMjgcDiw4thAalDYF5T?=
 =?us-ascii?q?S4KgydQgX4Xji9mgmuMQQEB?=
X-IronPort-AV: E=Sophos;i="5.64,528,1559491200"; 
   d="scan'208";a="253491511"
Received: from unknown (HELO [192.168.1.222]) ([118.208.171.57])
  by icp-osb-irony-out5.iinet.net.au with ESMTP; 20 Sep 2019 17:56:14 +0800
Subject: [PATCH v3 08/16] xfs: mount-api - refactor xfs_fs_fill_super()
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Date:   Fri, 20 Sep 2019 17:56:15 +0800
Message-ID: <156897337496.20210.12017610313535735470.stgit@fedora-28>
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

Much of the code in xfs_fs_fill_super() will be used by the fill super
function of the new mount-api.

So refactor the common code into a helper in an attempt to show what's
actually changed.

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/xfs/xfs_super.c |   64 +++++++++++++++++++++++++++++++++-------------------
 1 file changed, 41 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 5cb9a9fd1a15..9cf5c85d1341 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1718,27 +1718,14 @@ xfs_mount_alloc(
 
 
 STATIC int
-xfs_fs_fill_super(
-	struct super_block	*sb,
-	void			*data,
+__xfs_fs_fill_super(
+	struct xfs_mount	*mp,
 	int			silent)
 {
+	struct super_block	*sb = mp->m_super;
 	struct inode		*root;
-	struct xfs_mount	*mp = NULL;
-	int			flags = 0, error = -ENOMEM;
-
-	/*
-	 * allocate mp and do all low-level struct initializations before we
-	 * attach it to the super
-	 */
-	mp = xfs_mount_alloc(sb);
-	if (!mp)
-		goto out;
-	sb->s_fs_info = mp;
-
-	error = xfs_parseargs(mp, (char *)data);
-	if (error)
-		goto out_free_fsname;
+	int			flags = 0;
+	int			error;
 
 	sb_min_blocksize(sb, BBSIZE);
 	sb->s_xattr = xfs_xattr_handlers;
@@ -1765,7 +1752,7 @@ xfs_fs_fill_super(
 
 	error = xfs_open_devices(mp);
 	if (error)
-		goto out_free_fsname;
+		goto out;
 
 	error = xfs_init_mount_workqueues(mp);
 	if (error)
@@ -1900,10 +1887,6 @@ xfs_fs_fill_super(
 	xfs_destroy_mount_workqueues(mp);
  out_close_devices:
 	xfs_close_devices(mp);
- out_free_fsname:
-	sb->s_fs_info = NULL;
-	xfs_free_fsname(mp);
-	kfree(mp);
  out:
 	return error;
 
@@ -1913,6 +1896,41 @@ xfs_fs_fill_super(
 	goto out_free_sb;
 }
 
+STATIC int
+xfs_fs_fill_super(
+	struct super_block	*sb,
+	void			*data,
+	int			silent)
+{
+	struct xfs_mount	*mp = NULL;
+	int			error = -ENOMEM;
+
+	/*
+	 * allocate mp and do all low-level struct initializations before we
+	 * attach it to the super
+	 */
+	mp = xfs_mount_alloc(sb);
+	if (!mp)
+		return -ENOMEM;
+	sb->s_fs_info = mp;
+
+	error = xfs_parseargs(mp, (char *)data);
+	if (error)
+		goto out_free_fsname;
+
+	error = __xfs_fs_fill_super(mp, silent);
+	if (error)
+		goto out_free_fsname;
+
+	return 0;
+
+ out_free_fsname:
+	sb->s_fs_info = NULL;
+	xfs_free_fsname(mp);
+	kfree(mp);
+	return error;
+}
+
 STATIC void
 xfs_fs_put_super(
 	struct super_block	*sb)

