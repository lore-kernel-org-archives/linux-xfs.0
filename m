Return-Path: <SRS0=feM8=YR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7473BCA9EAF
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 07:51:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 529182084C
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 07:51:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408743AbfJXHv5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Oct 2019 03:51:57 -0400
Received: from icp-osb-irony-out1.external.iinet.net.au ([203.59.1.210]:26989
        "EHLO icp-osb-irony-out1.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404960AbfJXHv4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Oct 2019 03:51:56 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2BRAADRVrFd/0e30XYNWBwBAQEBAQc?=
 =?us-ascii?q?BAREBBAQBAYFpBQEBCwEBhDqEKI9JBoERiiKFIAGKE4F7CQEBAQEBAQEBATc?=
 =?us-ascii?q?BAYQ7AwICg1k2Bw4CDAEBAQQBAQEBAQUDAYVYgRoBAQQHAYUBAgEDIwRSEBg?=
 =?us-ascii?q?NAiYCAkcQBhOFdbF0dX8zGoowgQ4oAYFkikJ4gQeBETODHYdVgl4Ejz03hkB?=
 =?us-ascii?q?DlmyCLpVFDI4fA4skLalZCoIATS4KgydQgzYXjjBnhz2DGYVYAQE?=
X-IPAS-Result: =?us-ascii?q?A2BRAADRVrFd/0e30XYNWBwBAQEBAQcBAREBBAQBAYFpB?=
 =?us-ascii?q?QEBCwEBhDqEKI9JBoERiiKFIAGKE4F7CQEBAQEBAQEBATcBAYQ7AwICg1k2B?=
 =?us-ascii?q?w4CDAEBAQQBAQEBAQUDAYVYgRoBAQQHAYUBAgEDIwRSEBgNAiYCAkcQBhOFd?=
 =?us-ascii?q?bF0dX8zGoowgQ4oAYFkikJ4gQeBETODHYdVgl4Ejz03hkBDlmyCLpVFDI4fA?=
 =?us-ascii?q?4skLalZCoIATS4KgydQgzYXjjBnhz2DGYVYAQE?=
X-IronPort-AV: E=Sophos;i="5.68,224,1569254400"; 
   d="scan'208";a="250044096"
Received: from unknown (HELO [192.168.1.222]) ([118.209.183.71])
  by icp-osb-irony-out1.iinet.net.au with ESMTP; 24 Oct 2019 15:51:54 +0800
Subject: [PATCH v7 15/17] xfs: dont set sb in xfs_mount_alloc()
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Thu, 24 Oct 2019 15:51:54 +0800
Message-ID: <157190351411.27074.16401313075311476494.stgit@fedora-28>
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

When changing to use the new mount api the super block won't be
available when struct xfs_mount is allocated so move setting the super
block to xfs_fs_fill_super().

Also change xfs_mount_alloc() decalaration static -> STATIC.

Signed-off-by: Ian Kent <raven@themaw.net>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_super.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index b3c27a0781ed..24eec22bcac1 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -403,8 +403,7 @@ xfs_fc_validate_params(
 }
 
 static struct xfs_mount *
-xfs_mount_alloc(
-	struct super_block	*sb)
+xfs_mount_alloc(void)
 {
 	struct xfs_mount	*mp;
 
@@ -412,7 +411,6 @@ xfs_mount_alloc(
 	if (!mp)
 		return NULL;
 
-	mp->m_super = sb;
 	spin_lock_init(&mp->m_sb_lock);
 	spin_lock_init(&mp->m_agirotor_lock);
 	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_ATOMIC);
@@ -1652,9 +1650,10 @@ xfs_fs_fill_super(
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

