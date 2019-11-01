Return-Path: <SRS0=5kOL=YZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9C5ECA9EC9
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 07:50:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD3E72080F
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 07:50:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729855AbfKAHu1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Nov 2019 03:50:27 -0400
Received: from icp-osb-irony-out7.external.iinet.net.au ([203.59.1.107]:8821
        "EHLO icp-osb-irony-out7.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725787AbfKAHu1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Nov 2019 03:50:27 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2AUAABb4rtd/xK90HYNVxwBAQEBAQc?=
 =?us-ascii?q?BAREBBAQBAYFpBwEBCwGEPIQoiCOHNgEBAQEBAQaBEYoIhTABihWBewkBAQE?=
 =?us-ascii?q?BAQEBAQE3AQGEOwMCAoQeNAkOAgwBAQEEAQEBAQEFAwGFWIYqAgEDIwRSEBg?=
 =?us-ascii?q?NAiYCAkcQBhOFdbBkdX8zGoo3gQ4oAYFkikR4gQeBETODHYdVgl4Ej0I3hkF?=
 =?us-ascii?q?DlnWCLpVQDI4oA4suLalhghFNLgqDJ1CRfWeObAEB?=
X-IPAS-Result: =?us-ascii?q?A2AUAABb4rtd/xK90HYNVxwBAQEBAQcBAREBBAQBAYFpB?=
 =?us-ascii?q?wEBCwGEPIQoiCOHNgEBAQEBAQaBEYoIhTABihWBewkBAQEBAQEBAQE3AQGEO?=
 =?us-ascii?q?wMCAoQeNAkOAgwBAQEEAQEBAQEFAwGFWIYqAgEDIwRSEBgNAiYCAkcQBhOFd?=
 =?us-ascii?q?bBkdX8zGoo3gQ4oAYFkikR4gQeBETODHYdVgl4Ej0I3hkFDlnWCLpVQDI4oA?=
 =?us-ascii?q?4suLalhghFNLgqDJ1CRfWeObAEB?=
X-IronPort-AV: E=Sophos;i="5.68,254,1569254400"; 
   d="scan'208";a="215829931"
Received: from unknown (HELO [192.168.1.222]) ([118.208.189.18])
  by icp-osb-irony-out7.iinet.net.au with ESMTP; 01 Nov 2019 15:50:21 +0800
Subject: [PATCH v8 04/16] xfs: use kmem functions for struct xfs_mount
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Fri, 01 Nov 2019 15:50:18 +0800
Message-ID: <157259461883.28278.12453744341651659940.stgit@fedora-28>
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

The remount function uses the kmem functions for allocating and freeing
struct xfs_mount, for consistency use the kmem functions everwhere for
struct xfs_mount.

Signed-off-by: Ian Kent <raven@themaw.net>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_super.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index fb90beeb3184..eb919e74d8eb 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1497,7 +1497,7 @@ xfs_mount_alloc(
 {
 	struct xfs_mount	*mp;
 
-	mp = kzalloc(sizeof(struct xfs_mount), GFP_KERNEL);
+	mp = kmem_alloc(sizeof(struct xfs_mount), KM_ZERO);
 	if (!mp)
 		return NULL;
 
@@ -1711,7 +1711,7 @@ xfs_fs_fill_super(
  out_free_names:
 	sb->s_fs_info = NULL;
 	xfs_free_names(mp);
-	kfree(mp);
+	kmem_free(mp);
  out:
 	return error;
 
@@ -1743,7 +1743,7 @@ xfs_fs_put_super(
 
 	sb->s_fs_info = NULL;
 	xfs_free_names(mp);
-	kfree(mp);
+	kmem_free(mp);
 }
 
 STATIC struct dentry *

