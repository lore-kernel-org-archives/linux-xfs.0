Return-Path: <SRS0=feM8=YR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEEF4CA9EAF
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 07:51:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B3AA21872
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 07:51:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408742AbfJXHvP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Oct 2019 03:51:15 -0400
Received: from icp-osb-irony-out1.external.iinet.net.au ([203.59.1.210]:26989
        "EHLO icp-osb-irony-out1.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407212AbfJXHvP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Oct 2019 03:51:15 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2AaAADRVrFd/0e30XYNWBsBAQEBAQE?=
 =?us-ascii?q?BBQEBAREBAQMDAQEBgWkEAQEBCwEBhDqEKI9JBoERiiKFIAGKE4F7CQEBAQE?=
 =?us-ascii?q?BAQEBATcBAYQ7AwICg1k2Bw4CDAEBAQQBAQEBAQUDAYVYgRoBAQQHAYUBAgE?=
 =?us-ascii?q?DIwRSEBgNAiYCAkcQBhOFdbF0dX8zGoowgQ4oAYFkikJ4gQeBETODHYdVgl4?=
 =?us-ascii?q?EjQ6CLzeGQEOWbIIulUUMjh8DiyQtqVkEggZNLgqDJ1CRfWeHPYMZhVgBAQ?=
X-IPAS-Result: =?us-ascii?q?A2AaAADRVrFd/0e30XYNWBsBAQEBAQEBBQEBAREBAQMDA?=
 =?us-ascii?q?QEBgWkEAQEBCwEBhDqEKI9JBoERiiKFIAGKE4F7CQEBAQEBAQEBATcBAYQ7A?=
 =?us-ascii?q?wICg1k2Bw4CDAEBAQQBAQEBAQUDAYVYgRoBAQQHAYUBAgEDIwRSEBgNAiYCA?=
 =?us-ascii?q?kcQBhOFdbF0dX8zGoowgQ4oAYFkikJ4gQeBETODHYdVgl4EjQ6CLzeGQEOWb?=
 =?us-ascii?q?IIulUUMjh8DiyQtqVkEggZNLgqDJ1CRfWeHPYMZhVgBAQ?=
X-IronPort-AV: E=Sophos;i="5.68,224,1569254400"; 
   d="scan'208";a="250043915"
Received: from unknown (HELO [192.168.1.222]) ([118.209.183.71])
  by icp-osb-irony-out1.iinet.net.au with ESMTP; 24 Oct 2019 15:51:12 +0800
Subject: [PATCH v7 07/17] xfs: move xfs_mount_alloc to be with parsing code
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Thu, 24 Oct 2019 15:51:12 +0800
Message-ID: <157190347206.27074.7719123415772242317.stgit@fedora-28>
In-Reply-To: <157190333868.27074.13987695222060552856.stgit@fedora-28>
References: <157190333868.27074.13987695222060552856.stgit@fedora-28>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The struct xfs_mount allocation (and freeing) is only used by the mount
code, so move xfs_mount_alloc() to the same area as the option handling
code (as part of the work to locate the mount code together).

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/xfs/xfs_super.c |   63 ++++++++++++++++++++++++++--------------------------
 1 file changed, 31 insertions(+), 32 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 896609827e3c..0596d491dbbe 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -415,6 +415,37 @@ xfs_parseargs(
 	return 0;
 }
 
+static struct xfs_mount *
+xfs_mount_alloc(
+	struct super_block	*sb)
+{
+	struct xfs_mount	*mp;
+
+	mp = kmem_alloc(sizeof(struct xfs_mount), KM_ZERO);
+	if (!mp)
+		return NULL;
+
+	mp->m_super = sb;
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
+	return mp;
+}
+
 struct proc_xfs_info {
 	uint64_t	flag;
 	char		*str;
@@ -1529,38 +1560,6 @@ xfs_destroy_percpu_counters(
 	percpu_counter_destroy(&mp->m_delalloc_blks);
 }
 
-static struct xfs_mount *
-xfs_mount_alloc(
-	struct super_block	*sb)
-{
-	struct xfs_mount	*mp;
-
-	mp = kmem_alloc(sizeof(struct xfs_mount), KM_ZERO);
-	if (!mp)
-		return NULL;
-
-	mp->m_super = sb;
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
-
 STATIC int
 xfs_fs_fill_super(
 	struct super_block	*sb,

