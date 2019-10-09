Return-Path: <SRS0=7gTY=YC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C82BECE596
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 11:31:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8096E20B7C
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 11:31:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729699AbfJILbK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 07:31:10 -0400
Received: from icp-osb-irony-out3.external.iinet.net.au ([203.59.1.153]:33503
        "EHLO icp-osb-irony-out3.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729575AbfJILbK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 07:31:10 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2AnAABxxJ1d/0e30XYNWRwBAQEBAQc?=
 =?us-ascii?q?BAREBBAQBAYFpBQEBCwGEOYQjjygBAQEDBoERih2FH4RshSiBewkBAQEBAQE?=
 =?us-ascii?q?BAQE3AQGEOwMCAoJyNgcOAgwBAQEEAQEBAQEFAwGFWIYaAgEDIwRSEBgNAiY?=
 =?us-ascii?q?CAkcQBhOFGa9vdX8zGoosgQwoAYFkikF4gQeBETODHYdSglgEjQWCLzeGPEO?=
 =?us-ascii?q?WWYIslTQMjhUDixwthAqlLAGCCk0uCoMnUIF/F44wZ5EUAQE?=
X-IPAS-Result: =?us-ascii?q?A2AnAABxxJ1d/0e30XYNWRwBAQEBAQcBAREBBAQBAYFpB?=
 =?us-ascii?q?QEBCwGEOYQjjygBAQEDBoERih2FH4RshSiBewkBAQEBAQEBAQE3AQGEOwMCA?=
 =?us-ascii?q?oJyNgcOAgwBAQEEAQEBAQEFAwGFWIYaAgEDIwRSEBgNAiYCAkcQBhOFGa9vd?=
 =?us-ascii?q?X8zGoosgQwoAYFkikF4gQeBETODHYdSglgEjQWCLzeGPEOWWYIslTQMjhUDi?=
 =?us-ascii?q?xwthAqlLAGCCk0uCoMnUIF/F44wZ5EUAQE?=
X-IronPort-AV: E=Sophos;i="5.67,273,1566835200"; 
   d="scan'208";a="216229059"
Received: from unknown (HELO [192.168.1.222]) ([118.209.183.71])
  by icp-osb-irony-out3.iinet.net.au with ESMTP; 09 Oct 2019 19:30:58 +0800
Subject: [PATCH v5 09/17] xfs: mount-api - refactor xfs_fs_fill_super()
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Wed, 09 Oct 2019 19:30:58 +0800
Message-ID: <157062065791.32346.8183392339697088078.stgit@fedora-28>
In-Reply-To: <157062043952.32346.977737248061083292.stgit@fedora-28>
References: <157062043952.32346.977737248061083292.stgit@fedora-28>
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
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_super.c |   64 +++++++++++++++++++++++++++++++++-------------------
 1 file changed, 41 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 7008355df065..cc2da9093e34 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1712,27 +1712,14 @@ xfs_mount_alloc(
 
 
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
@@ -1759,7 +1746,7 @@ xfs_fs_fill_super(
 
 	error = xfs_open_devices(mp);
 	if (error)
-		goto out_free_fsname;
+		goto out;
 
 	error = xfs_init_mount_workqueues(mp);
 	if (error)
@@ -1894,10 +1881,6 @@ xfs_fs_fill_super(
 	xfs_destroy_mount_workqueues(mp);
  out_close_devices:
 	xfs_close_devices(mp);
- out_free_fsname:
-	sb->s_fs_info = NULL;
-	xfs_free_fsname(mp);
-	kfree(mp);
  out:
 	return error;
 
@@ -1907,6 +1890,41 @@ xfs_fs_fill_super(
 	goto out_free_sb;
 }
 
+STATIC int
+xfs_fs_fill_super(
+	struct super_block	*sb,
+	void			*data,
+	int			silent)
+{
+	struct xfs_mount	*mp;
+	int			error;
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

