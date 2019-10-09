Return-Path: <SRS0=7gTY=YC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 269BAC47404
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 11:31:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0545B21721
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 11:31:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730523AbfJILbb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 07:31:31 -0400
Received: from icp-osb-irony-out3.external.iinet.net.au ([203.59.1.153]:33473
        "EHLO icp-osb-irony-out3.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730398AbfJILbb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 07:31:31 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2BYAQBxxJ1d/0e30XYNWRwBAQEBAQc?=
 =?us-ascii?q?BAREBBAQBAYF7gW+CS4QjjygBAQEDBosuhR+MDwkBAQEBAQEBAQE3AQGEOwM?=
 =?us-ascii?q?CAoJyOBMCDAEBAQQBAQEBAQUDAYVYhhoCAQMjBFIQGA0CJgICRxAGE4UZr29?=
 =?us-ascii?q?1fzMaiiyBDCiBZYpBeIEHgRGDUIdSglgEjzQ3hjxDllmCLJU0DI4VA4scLYQ?=
 =?us-ascii?q?KpT2Bek0uCoMnUIF/F44wZ5EUAQE?=
X-IPAS-Result: =?us-ascii?q?A2BYAQBxxJ1d/0e30XYNWRwBAQEBAQcBAREBBAQBAYF7g?=
 =?us-ascii?q?W+CS4QjjygBAQEDBosuhR+MDwkBAQEBAQEBAQE3AQGEOwMCAoJyOBMCDAEBA?=
 =?us-ascii?q?QQBAQEBAQUDAYVYhhoCAQMjBFIQGA0CJgICRxAGE4UZr291fzMaiiyBDCiBZ?=
 =?us-ascii?q?YpBeIEHgRGDUIdSglgEjzQ3hjxDllmCLJU0DI4VA4scLYQKpT2Bek0uCoMnU?=
 =?us-ascii?q?IF/F44wZ5EUAQE?=
X-IronPort-AV: E=Sophos;i="5.67,273,1566835200"; 
   d="scan'208";a="216229114"
Received: from unknown (HELO [192.168.1.222]) ([118.209.183.71])
  by icp-osb-irony-out3.iinet.net.au with ESMTP; 09 Oct 2019 19:31:30 +0800
Subject: [PATCH v5 15/17] xfs: mount-api - dont set sb in xfs_mount_alloc()
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Wed, 09 Oct 2019 19:31:30 +0800
Message-ID: <157062068996.32346.198461609951852574.stgit@fedora-28>
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

When changing to use the new mount api the super block won't be
available when the xfs_mount info struct is allocated so move
setting the super block in xfs_mount to xfs_fs_fill_super().

Also change xfs_mount_alloc() decalaration static -> STATIC.

Signed-off-by: Ian Kent <raven@themaw.net>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_super.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index c7c33395b648..910739789aed 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1766,9 +1766,8 @@ xfs_destroy_percpu_counters(
 	percpu_counter_destroy(&mp->m_delalloc_blks);
 }
 
-static struct xfs_mount *
-xfs_mount_alloc(
-	struct super_block	*sb)
+STATIC struct xfs_mount *
+xfs_mount_alloc(void)
 {
 	struct xfs_mount	*mp;
 
@@ -1776,7 +1775,6 @@ xfs_mount_alloc(
 	if (!mp)
 		return NULL;
 
-	mp->m_super = sb;
 	spin_lock_init(&mp->m_sb_lock);
 	spin_lock_init(&mp->m_agirotor_lock);
 	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_ATOMIC);
@@ -1990,9 +1988,10 @@ xfs_fs_fill_super(
 	 * allocate mp and do all low-level struct initializations before we
 	 * attach it to the super
 	 */
-	mp = xfs_mount_alloc(sb);
+	mp = xfs_mount_alloc();
 	if (!mp)
 		return -ENOMEM;
+	mp->m_super = sb;
 	sb->s_fs_info = mp;
 
 	error = xfs_parseargs(mp, (char *)data);

