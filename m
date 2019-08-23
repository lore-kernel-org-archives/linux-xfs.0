Return-Path: <SRS0=lWMA=WT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D077C3A5A1
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Aug 2019 01:09:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D5CB233A2
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Aug 2019 01:09:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732613AbfHWBJI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Aug 2019 21:09:08 -0400
Received: from icp-osb-irony-out2.external.iinet.net.au ([203.59.1.155]:5587
        "EHLO icp-osb-irony-out2.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387589AbfHWBJI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Aug 2019 21:09:08 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2DWAQAROl9d/3Wz0XYNWBwBAQEEAQE?=
 =?us-ascii?q?HBAEBgWeEM4Qgj1YBAQaBEYoRigSHHwkBAQEBAQEBAQE3AQGEOgMCAoMCOBM?=
 =?us-ascii?q?CCQEBAQQBAgEBBgMBhViGGQIBAyMEUhAYDQImAgJHEAYThRmrUHN/MxqKQIE?=
 =?us-ascii?q?MKIFjiiR4gQeBETODHYdPglgEjD2CV4YPQpV3CYIflFgMjVsDimAtg3OjYYF?=
 =?us-ascii?q?5TS4KgyeCTheOL2WMVgEB?=
X-IPAS-Result: =?us-ascii?q?A2DWAQAROl9d/3Wz0XYNWBwBAQEEAQEHBAEBgWeEM4Qgj?=
 =?us-ascii?q?1YBAQaBEYoRigSHHwkBAQEBAQEBAQE3AQGEOgMCAoMCOBMCCQEBAQQBAgEBB?=
 =?us-ascii?q?gMBhViGGQIBAyMEUhAYDQImAgJHEAYThRmrUHN/MxqKQIEMKIFjiiR4gQeBE?=
 =?us-ascii?q?TODHYdPglgEjD2CV4YPQpV3CYIflFgMjVsDimAtg3OjYYF5TS4KgyeCTheOL?=
 =?us-ascii?q?2WMVgEB?=
X-IronPort-AV: E=Sophos;i="5.64,419,1559491200"; 
   d="scan'208";a="231796736"
Received: from unknown (HELO [192.168.1.222]) ([118.209.179.117])
  by icp-osb-irony-out2.iinet.net.au with ESMTP; 23 Aug 2019 08:59:54 +0800
Subject: [PATCH v2 07/15] xfs: mount-api - refactor xfs_fs_fill_super()
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Date:   Fri, 23 Aug 2019 08:59:54 +0800
Message-ID: <156652199438.2607.11044864070510345078.stgit@fedora-28>
In-Reply-To: <156652158924.2607.14608448087216437699.stgit@fedora-28>
References: <156652158924.2607.14608448087216437699.stgit@fedora-28>
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
 fs/xfs/xfs_super.c |   65 ++++++++++++++++++++++++++++++++++------------------
 1 file changed, 42 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 7cdda17ee0ff..d3fc9938987d 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1690,27 +1690,14 @@ xfs_mount_alloc(
 
 
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
@@ -1737,7 +1724,7 @@ xfs_fs_fill_super(
 
 	error = xfs_open_devices(mp);
 	if (error)
-		goto out_free_fsname;
+		goto out;
 
 	error = xfs_init_mount_workqueues(mp);
 	if (error)
@@ -1872,10 +1859,6 @@ xfs_fs_fill_super(
 	xfs_destroy_mount_workqueues(mp);
  out_close_devices:
 	xfs_close_devices(mp);
- out_free_fsname:
-	sb->s_fs_info = NULL;
-	xfs_free_fsname(mp);
-	kfree(mp);
  out:
 	return error;
 
@@ -1885,6 +1868,42 @@ xfs_fs_fill_super(
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
+		goto out;
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
+out:
+	return error;
+}
+
 STATIC void
 xfs_fs_put_super(
 	struct super_block	*sb)

