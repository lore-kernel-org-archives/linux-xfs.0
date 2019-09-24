Return-Path: <SRS0=ckLY=XT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46E88C432C1
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Sep 2019 13:23:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2499D2064A
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Sep 2019 13:23:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505056AbfIXNXR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Sep 2019 09:23:17 -0400
Received: from icp-osb-irony-out7.external.iinet.net.au ([203.59.1.107]:5979
        "EHLO icp-osb-irony-out7.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2505051AbfIXNXR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Sep 2019 09:23:17 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2CuAQA1GIpd/9+j0HYNWBwBAQEEAQE?=
 =?us-ascii?q?MBAEBgWeBb4JLhCKPWQEBAQEBAQaBEYoahR+MCQkBAQEBAQEBAQE3AQGEOgM?=
 =?us-ascii?q?CAoNEOBMCDAEBAQQBAQEBAQUDAYVYhhkCAQMjBFIQGA0CJgICRxAGE4UZrRN?=
 =?us-ascii?q?zfzMaijSBDCiBY4o+eIEHgREzgx2HT4JYBI9WhixClkiCLJUlDI4HA4sPLYQ?=
 =?us-ascii?q?GpQ2BeU0uCoMnUIF+F44vZo0lAQE?=
X-IPAS-Result: =?us-ascii?q?A2CuAQA1GIpd/9+j0HYNWBwBAQEEAQEMBAEBgWeBb4JLh?=
 =?us-ascii?q?CKPWQEBAQEBAQaBEYoahR+MCQkBAQEBAQEBAQE3AQGEOgMCAoNEOBMCDAEBA?=
 =?us-ascii?q?QQBAQEBAQUDAYVYhhkCAQMjBFIQGA0CJgICRxAGE4UZrRNzfzMaijSBDCiBY?=
 =?us-ascii?q?4o+eIEHgREzgx2HT4JYBI9WhixClkiCLJUlDI4HA4sPLYQGpQ2BeU0uCoMnU?=
 =?us-ascii?q?IF+F44vZo0lAQE?=
X-IronPort-AV: E=Sophos;i="5.64,544,1559491200"; 
   d="scan'208";a="205615229"
Received: from unknown (HELO [192.168.1.222]) ([118.208.163.223])
  by icp-osb-irony-out7.iinet.net.au with ESMTP; 24 Sep 2019 21:23:15 +0800
Subject: [REPOST PATCH v3 14/16] xfs: mount-api - dont set sb in
 xfs_mount_alloc()
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Date:   Tue, 24 Sep 2019 21:23:15 +0800
Message-ID: <156933139515.20933.9493412268081010607.stgit@fedora-28>
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

When changing to use the new mount api the super block won't be
available when the xfs_mount info struct is allocated so move
setting the super block in xfs_mount to xfs_fs_fill_super().

Also change xfs_mount_alloc() decalaration static -> STATIC.

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/xfs/xfs_super.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 5bc2363269a9..1c25d5dfd090 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1796,9 +1796,8 @@ xfs_destroy_percpu_counters(
 	percpu_counter_destroy(&mp->m_delalloc_blks);
 }
 
-static struct xfs_mount *
-xfs_mount_alloc(
-	struct super_block	*sb)
+STATIC struct xfs_mount *
+xfs_mount_alloc(void)
 {
 	struct xfs_mount	*mp;
 
@@ -1806,7 +1805,6 @@ xfs_mount_alloc(
 	if (!mp)
 		return NULL;
 
-	mp->m_super = sb;
 	spin_lock_init(&mp->m_sb_lock);
 	spin_lock_init(&mp->m_agirotor_lock);
 	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_ATOMIC);
@@ -2020,9 +2018,10 @@ xfs_fs_fill_super(
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

