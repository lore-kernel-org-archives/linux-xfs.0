Return-Path: <SRS0=9rhF=Y4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37624CA9EA0
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 10:56:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16EBA217F5
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 10:56:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728682AbfKDK4H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 05:56:07 -0500
Received: from icp-osb-irony-out4.external.iinet.net.au ([203.59.1.220]:34330
        "EHLO icp-osb-irony-out4.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728663AbfKDK4H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 05:56:07 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2C2AAC6AsBd/xK90HYNWRsBAQEBAQE?=
 =?us-ascii?q?BBQEBAREBAQMDAQEBgX0ChDuEKY9YAQEBAQEBBoERigmFMYRuhyMJAQEBAQE?=
 =?us-ascii?q?BAQEBNwEBhDsDAgKEMDgTAg4BAQEEAQEBAQEFAwGFWIEaARABhH4CAQMjBFI?=
 =?us-ascii?q?QGA0CJgICRxAGE4V1sGJ1fzMaijOBDigBgWSKRniBB4ERM4Mdh1WCXgSNFII?=
 =?us-ascii?q?vN4ZAQ5Z1gi6VUQyOKAOLLi2pfYF6TS4KgydQgzcXjjBniWSFCQEB?=
X-IPAS-Result: =?us-ascii?q?A2C2AAC6AsBd/xK90HYNWRsBAQEBAQEBBQEBAREBAQMDA?=
 =?us-ascii?q?QEBgX0ChDuEKY9YAQEBAQEBBoERigmFMYRuhyMJAQEBAQEBAQEBNwEBhDsDA?=
 =?us-ascii?q?gKEMDgTAg4BAQEEAQEBAQEFAwGFWIEaARABhH4CAQMjBFIQGA0CJgICRxAGE?=
 =?us-ascii?q?4V1sGJ1fzMaijOBDigBgWSKRniBB4ERM4Mdh1WCXgSNFIIvN4ZAQ5Z1gi6VU?=
 =?us-ascii?q?QyOKAOLLi2pfYF6TS4KgydQgzcXjjBniWSFCQEB?=
X-IronPort-AV: E=Sophos;i="5.68,266,1569254400"; 
   d="scan'208";a="207138746"
Received: from unknown (HELO [192.168.1.222]) ([118.208.189.18])
  by icp-osb-irony-out4.iinet.net.au with ESMTP; 04 Nov 2019 18:56:05 +0800
Subject: [PATCH v9 17/17] xfs: fold xfs_mount-alloc() into
 xfs_init_fs_context()
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Mon, 04 Nov 2019 18:56:05 +0800
Message-ID: <157286496581.18393.3802665855647124772.stgit@fedora-28>
In-Reply-To: <157286480109.18393.6285224459642752559.stgit@fedora-28>
References: <157286480109.18393.6285224459642752559.stgit@fedora-28>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

After switching to use the mount-api the only remaining caller of
xfs_mount_alloc() is xfs_init_fs_context(), so fold xfs_mount_alloc()
into it.

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/xfs/xfs_super.c |   49 +++++++++++++++++++------------------------------
 1 file changed, 19 insertions(+), 30 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index e156fd59d592..c14f285f3256 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1096,35 +1096,6 @@ static const struct super_operations xfs_super_operations = {
 	.free_cached_objects	= xfs_fs_free_cached_objects,
 };
 
-static struct xfs_mount *
-xfs_mount_alloc(void)
-{
-	struct xfs_mount	*mp;
-
-	mp = kmem_alloc(sizeof(struct xfs_mount), KM_ZERO);
-	if (!mp)
-		return NULL;
-
-	spin_lock_init(&mp->m_sb_lock);
-	spin_lock_init(&mp->m_agirotor_lock);
-	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_ATOMIC);
-	spin_lock_init(&mp->m_perag_lock);
-	mutex_init(&mp->m_growlock);
-	atomic_set(&mp->m_active_trans, 0);
-	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
-	INIT_DELAYED_WORK(&mp->m_eofblocks_work, xfs_eofblocks_worker);
-	INIT_DELAYED_WORK(&mp->m_cowblocks_work, xfs_cowblocks_worker);
-	mp->m_kobj.kobject.kset = xfs_kset;
-	/*
-	 * We don't create the finobt per-ag space reservation until after log
-	 * recovery, so we must set this to true so that an ifree transaction
-	 * started during log recovery will not depend on space reservations
-	 * for finobt expansion.
-	 */
-	mp->m_finobt_nores = true;
-	return mp;
-}
-
 static int
 suffix_kstrtoint(
 	const char	*s,
@@ -1763,10 +1734,28 @@ static int xfs_init_fs_context(
 {
 	struct xfs_mount	*mp;
 
-	mp = xfs_mount_alloc();
+	mp = kmem_alloc(sizeof(struct xfs_mount), KM_ZERO);
 	if (!mp)
 		return -ENOMEM;
 
+	spin_lock_init(&mp->m_sb_lock);
+	spin_lock_init(&mp->m_agirotor_lock);
+	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_ATOMIC);
+	spin_lock_init(&mp->m_perag_lock);
+	mutex_init(&mp->m_growlock);
+	atomic_set(&mp->m_active_trans, 0);
+	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
+	INIT_DELAYED_WORK(&mp->m_eofblocks_work, xfs_eofblocks_worker);
+	INIT_DELAYED_WORK(&mp->m_cowblocks_work, xfs_cowblocks_worker);
+	mp->m_kobj.kobject.kset = xfs_kset;
+	/*
+	 * We don't create the finobt per-ag space reservation until after log
+	 * recovery, so we must set this to true so that an ifree transaction
+	 * started during log recovery will not depend on space reservations
+	 * for finobt expansion.
+	 */
+	mp->m_finobt_nores = true;
+
 	/*
 	 * These can be overridden by the mount option parsing.
 	 */

