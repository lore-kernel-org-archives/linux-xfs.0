Return-Path: <SRS0=feM8=YR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5DDACA9EAF
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 07:51:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9810F2166E
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 07:51:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408741AbfJXHvJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Oct 2019 03:51:09 -0400
Received: from icp-osb-irony-out1.external.iinet.net.au ([203.59.1.210]:26989
        "EHLO icp-osb-irony-out1.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407212AbfJXHvJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Oct 2019 03:51:09 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2BRAADRVrFd/0e30XYNWBwBAQEBAQc?=
 =?us-ascii?q?BAREBBAQBAYFpBQEBCwEBhDqEKI9JBoERiiKFIAGKE4F7CQEBAQEBAQEBATc?=
 =?us-ascii?q?BAYQ7AwICg1k2Bw4CDAEBAQQBAQEBAQUDAYVYgRoBAQQHAYUBAgEDIwRSEBg?=
 =?us-ascii?q?NAiYCAkcQBhOFdbF0dX8zGoowgQ4oAYFkikJ4gQeBETODHYdVgl4Ejz03hkB?=
 =?us-ascii?q?DlmyCLpVFDI4fA4skLalZDYF9TS4KgydQkX1nhz2DGYVYAQE?=
X-IPAS-Result: =?us-ascii?q?A2BRAADRVrFd/0e30XYNWBwBAQEBAQcBAREBBAQBAYFpB?=
 =?us-ascii?q?QEBCwEBhDqEKI9JBoERiiKFIAGKE4F7CQEBAQEBAQEBATcBAYQ7AwICg1k2B?=
 =?us-ascii?q?w4CDAEBAQQBAQEBAQUDAYVYgRoBAQQHAYUBAgEDIwRSEBgNAiYCAkcQBhOFd?=
 =?us-ascii?q?bF0dX8zGoowgQ4oAYFkikJ4gQeBETODHYdVgl4Ejz03hkBDlmyCLpVFDI4fA?=
 =?us-ascii?q?4skLalZDYF9TS4KgydQkX1nhz2DGYVYAQE?=
X-IronPort-AV: E=Sophos;i="5.68,224,1569254400"; 
   d="scan'208";a="250043890"
Received: from unknown (HELO [192.168.1.222]) ([118.209.183.71])
  by icp-osb-irony-out1.iinet.net.au with ESMTP; 24 Oct 2019 15:51:06 +0800
Subject: [PATCH v7 06/17] xfs: use kmem functions for struct xfs_mount
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Thu, 24 Oct 2019 15:51:06 +0800
Message-ID: <157190346680.27074.12024650426066059590.stgit@fedora-28>
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

The remount function uses the kmem functions for allocating and freeing
struct xfs_mount, for consistency use the kmem functions everwhere for
struct xfs_mount.

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/xfs/xfs_super.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index a0805b74256c..896609827e3c 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1535,7 +1535,7 @@ xfs_mount_alloc(
 {
 	struct xfs_mount	*mp;
 
-	mp = kzalloc(sizeof(struct xfs_mount), GFP_KERNEL);
+	mp = kmem_alloc(sizeof(struct xfs_mount), KM_ZERO);
 	if (!mp)
 		return NULL;
 
@@ -1749,7 +1749,7 @@ xfs_fs_fill_super(
  out_free_names:
 	sb->s_fs_info = NULL;
 	xfs_free_names(mp);
-	kfree(mp);
+	kmem_free(mp);
  out:
 	return error;
 
@@ -1781,7 +1781,7 @@ xfs_fs_put_super(
 
 	sb->s_fs_info = NULL;
 	xfs_free_names(mp);
-	kfree(mp);
+	kmem_free(mp);
 }
 
 STATIC struct dentry *

