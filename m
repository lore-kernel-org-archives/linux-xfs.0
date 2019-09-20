Return-Path: <SRS0=+mcJ=XP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 286FCC49ED7
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Sep 2019 09:56:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0FE220665
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Sep 2019 09:56:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408601AbfITJ4W (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Sep 2019 05:56:22 -0400
Received: from icp-osb-irony-out5.external.iinet.net.au ([203.59.1.221]:6242
        "EHLO icp-osb-irony-out5.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2408596AbfITJ4W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Sep 2019 05:56:22 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2CNAQDfoYRd/zmr0HYNVxwBAQEEAQE?=
 =?us-ascii?q?HBAEBgWcChDKEIo9nAQEGgRGKGoUfjAkJAQEBAQEBAQEBNwEBhDoDAgKDKjg?=
 =?us-ascii?q?TAgwBAQEEAQEBAQEFAwGFWIEQARABhHcCAQMjBFIQGA0CJgICRxAGE4UZqwZ?=
 =?us-ascii?q?zfzMaii6BDCgBgWKKPniBB4ERM4Mdh0+CWASPVoVNX0KWR4IslSUMjgcDiw4?=
 =?us-ascii?q?thAalDYF5TS4KgydQgX4Xji9mgmuJbyuCJwEB?=
X-IPAS-Result: =?us-ascii?q?A2CNAQDfoYRd/zmr0HYNVxwBAQEEAQEHBAEBgWcChDKEI?=
 =?us-ascii?q?o9nAQEGgRGKGoUfjAkJAQEBAQEBAQEBNwEBhDoDAgKDKjgTAgwBAQEEAQEBA?=
 =?us-ascii?q?QEFAwGFWIEQARABhHcCAQMjBFIQGA0CJgICRxAGE4UZqwZzfzMaii6BDCgBg?=
 =?us-ascii?q?WKKPniBB4ERM4Mdh0+CWASPVoVNX0KWR4IslSUMjgcDiw4thAalDYF5TS4Kg?=
 =?us-ascii?q?ydQgX4Xji9mgmuJbyuCJwEB?=
X-IronPort-AV: E=Sophos;i="5.64,528,1559491200"; 
   d="scan'208";a="253491523"
Received: from unknown (HELO [192.168.1.222]) ([118.208.171.57])
  by icp-osb-irony-out5.iinet.net.au with ESMTP; 20 Sep 2019 17:56:20 +0800
Subject: [PATCH v3 09/16] xfs: mount-api - add xfs_get_tree()
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Date:   Fri, 20 Sep 2019 17:56:20 +0800
Message-ID: <156897338014.20210.5611545088879475424.stgit@fedora-28>
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

Add the fs_context_operations method .get_tree that validates
mount options and fills the super block as previously done
by the file_system_type .mount method.

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/xfs/xfs_super.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 9cf5c85d1341..3a4c724de1cc 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1931,6 +1931,51 @@ xfs_fs_fill_super(
 	return error;
 }
 
+STATIC int
+xfs_fill_super(
+	struct super_block	*sb,
+	struct fs_context	*fc)
+{
+	struct xfs_fs_context	*ctx = fc->fs_private;
+	struct xfs_mount	*mp = sb->s_fs_info;
+	int			silent = fc->sb_flags & SB_SILENT;
+	int			error = -ENOMEM;
+
+	mp->m_super = sb;
+
+	/*
+	 * set up the mount name first so all the errors will refer to the
+	 * correct device.
+	 */
+	mp->m_fsname = kstrndup(sb->s_id, MAXNAMELEN, GFP_KERNEL);
+	if (!mp->m_fsname)
+		return -ENOMEM;
+	mp->m_fsname_len = strlen(mp->m_fsname) + 1;
+
+	error = xfs_validate_params(mp, ctx, false);
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
+
+	return error;
+}
+
+STATIC int
+xfs_get_tree(
+	struct fs_context	*fc)
+{
+	return vfs_get_block_super(fc, xfs_fill_super);
+}
+
 STATIC void
 xfs_fs_put_super(
 	struct super_block	*sb)

