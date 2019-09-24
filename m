Return-Path: <SRS0=ckLY=XT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E05DC432C2
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Sep 2019 13:23:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B5A42064A
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Sep 2019 13:23:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505049AbfIXNXA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Sep 2019 09:23:00 -0400
Received: from icp-osb-irony-out7.external.iinet.net.au ([203.59.1.107]:6001
        "EHLO icp-osb-irony-out7.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2505015AbfIXNW7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Sep 2019 09:22:59 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2AxAAA1GIpd/9+j0HYNWBwBAQEEAQE?=
 =?us-ascii?q?MBAEBgVUFAQELAYQ5hCKPWQEBAQEBAQaBEYoahR+EaoUkgXsJAQEBAQEBAQE?=
 =?us-ascii?q?BNwEBhDoDAgKDRDYHDgIMAQEBBAEBAQEBBQMBhViGGQIBAyMEUhAYDQImAgJ?=
 =?us-ascii?q?HEAYThRmtE3N/MxqKNIEMKAGBYoo+eIEHgREzgx2HT4JYBIxxgmWGLEKWSII?=
 =?us-ascii?q?slSUMjgcDiw8thAakfQiCAU0uCoMnUIF+F44vZo0lAQE?=
X-IPAS-Result: =?us-ascii?q?A2AxAAA1GIpd/9+j0HYNWBwBAQEEAQEMBAEBgVUFAQELA?=
 =?us-ascii?q?YQ5hCKPWQEBAQEBAQaBEYoahR+EaoUkgXsJAQEBAQEBAQEBNwEBhDoDAgKDR?=
 =?us-ascii?q?DYHDgIMAQEBBAEBAQEBBQMBhViGGQIBAyMEUhAYDQImAgJHEAYThRmtE3N/M?=
 =?us-ascii?q?xqKNIEMKAGBYoo+eIEHgREzgx2HT4JYBIxxgmWGLEKWSIIslSUMjgcDiw8th?=
 =?us-ascii?q?AakfQiCAU0uCoMnUIF+F44vZo0lAQE?=
X-IronPort-AV: E=Sophos;i="5.64,544,1559491200"; 
   d="scan'208";a="205615172"
Received: from unknown (HELO [192.168.1.222]) ([118.208.163.223])
  by icp-osb-irony-out7.iinet.net.au with ESMTP; 24 Sep 2019 21:22:43 +0800
Subject: [REPOST PATCH v3 08/16] xfs: mount-api - refactor
 xfs_fs_fill_super()
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Date:   Tue, 24 Sep 2019 21:22:43 +0800
Message-ID: <156933136376.20933.15291550203661966809.stgit@fedora-28>
In-Reply-To: <156933112949.20933.12761540130806431294.stgit@fedora-28>
References: <156933112949.20933.12761540130806431294.stgit@fedora-28>
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
index cfda58dd3822..ea3640ffd8f5 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1720,27 +1720,14 @@ xfs_mount_alloc(
 
 
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
@@ -1767,7 +1754,7 @@ xfs_fs_fill_super(
 
 	error = xfs_open_devices(mp);
 	if (error)
-		goto out_free_fsname;
+		goto out;
 
 	error = xfs_init_mount_workqueues(mp);
 	if (error)
@@ -1902,10 +1889,6 @@ xfs_fs_fill_super(
 	xfs_destroy_mount_workqueues(mp);
  out_close_devices:
 	xfs_close_devices(mp);
- out_free_fsname:
-	sb->s_fs_info = NULL;
-	xfs_free_fsname(mp);
-	kfree(mp);
  out:
 	return error;
 
@@ -1915,6 +1898,41 @@ xfs_fs_fill_super(
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

