Return-Path: <SRS0=5kOL=YZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18E44CA9EC9
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 07:51:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA6552080F
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 07:51:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729965AbfKAHvf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Nov 2019 03:51:35 -0400
Received: from icp-osb-irony-out7.external.iinet.net.au ([203.59.1.107]:9129
        "EHLO icp-osb-irony-out7.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729856AbfKAHvf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Nov 2019 03:51:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2AUAACY47td/xK90HYNVxwBAQEBAQc?=
 =?us-ascii?q?BAREBBAQBAYFpBwEBCwGBboJOhCiII4c3AQEBAQEBBoERigiFMAGKFYF7CQE?=
 =?us-ascii?q?BAQEBAQEBATcBAYQ7AwIChB40CQ4CDAEBAQQBAQEBAQUDAYVYhioCAQMjBFI?=
 =?us-ascii?q?QGA0CJgICRxAGE4V1sF51fzMaijeBDigBgWSKRHiBB4ERM4Mdh1WCXgSPQje?=
 =?us-ascii?q?GQUOWdYIulVAMjigDiy4tqWGCEU0uCoMnUIM2F44wZ45sAQE?=
X-IPAS-Result: =?us-ascii?q?A2AUAACY47td/xK90HYNVxwBAQEBAQcBAREBBAQBAYFpB?=
 =?us-ascii?q?wEBCwGBboJOhCiII4c3AQEBAQEBBoERigiFMAGKFYF7CQEBAQEBAQEBATcBA?=
 =?us-ascii?q?YQ7AwIChB40CQ4CDAEBAQQBAQEBAQUDAYVYhioCAQMjBFIQGA0CJgICRxAGE?=
 =?us-ascii?q?4V1sF51fzMaijeBDigBgWSKRHiBB4ERM4Mdh1WCXgSPQjeGQUOWdYIulVAMj?=
 =?us-ascii?q?igDiy4tqWGCEU0uCoMnUIM2F44wZ45sAQE?=
X-IronPort-AV: E=Sophos;i="5.68,254,1569254400"; 
   d="scan'208";a="215830091"
Received: from unknown (HELO [192.168.1.222]) ([118.208.189.18])
  by icp-osb-irony-out7.iinet.net.au with ESMTP; 01 Nov 2019 15:51:06 +0800
Subject: [PATCH v8 12/16] xfs: dont set sb in xfs_mount_alloc()
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Fri, 01 Nov 2019 15:51:06 +0800
Message-ID: <157259466607.28278.4456308072088112584.stgit@fedora-28>
In-Reply-To: <157259452909.28278.1001302742832626046.stgit@fedora-28>
References: <157259452909.28278.1001302742832626046.stgit@fedora-28>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

When changing to use the new mount api the super block won't be
available when the xfs_mount struct is allocated so move setting the
super block in xfs_mount to xfs_fs_fill_super().

Signed-off-by: Ian Kent <raven@themaw.net>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_super.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 4b570ba3456a..62dfc678c415 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1560,8 +1560,7 @@ xfs_destroy_percpu_counters(
 }
 
 static struct xfs_mount *
-xfs_mount_alloc(
-	struct super_block	*sb)
+xfs_mount_alloc(void)
 {
 	struct xfs_mount	*mp;
 
@@ -1569,7 +1568,6 @@ xfs_mount_alloc(
 	if (!mp)
 		return NULL;
 
-	mp->m_super = sb;
 	spin_lock_init(&mp->m_sb_lock);
 	spin_lock_init(&mp->m_agirotor_lock);
 	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_ATOMIC);
@@ -1605,9 +1603,10 @@ xfs_fs_fill_super(
 	 * allocate mp and do all low-level struct initializations before we
 	 * attach it to the super
 	 */
-	mp = xfs_mount_alloc(sb);
+	mp = xfs_mount_alloc();
 	if (!mp)
 		goto out;
+	mp->m_super = sb;
 	sb->s_fs_info = mp;
 
 	error = xfs_parseargs(mp, (char *)data);

