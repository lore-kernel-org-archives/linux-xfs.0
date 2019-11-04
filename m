Return-Path: <SRS0=9rhF=Y4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD087CA9EA0
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 10:54:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0FD1217F5
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 10:54:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728559AbfKDKy6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 05:54:58 -0500
Received: from icp-osb-irony-out4.external.iinet.net.au ([203.59.1.220]:34019
        "EHLO icp-osb-irony-out4.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728520AbfKDKy6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 05:54:58 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2AKAAC6AsBd/xK90HYNWRsBAQEBAQE?=
 =?us-ascii?q?BBQEBAREBAQMDAQEBgWoFAQEBCwGEPIQpj1gBAQEBAQEGgRGKCYUxihaBewk?=
 =?us-ascii?q?BAQEBAQEBAQE3AQGEOwMCAoQwNQgOAg4BAQEEAQEBAQEFAwGFWIYqAgEDIwR?=
 =?us-ascii?q?SEBgNAiYCAkcQBhOFdbBidX8zGoozgQ4oAYFkikZ4gQeBETODHYdVgl4Ej0M?=
 =?us-ascii?q?3hkBDlnWCLpVRDI4oA4suLalnAYIPTS4KgydQkX5njm0BAQ?=
X-IPAS-Result: =?us-ascii?q?A2AKAAC6AsBd/xK90HYNWRsBAQEBAQEBBQEBAREBAQMDA?=
 =?us-ascii?q?QEBgWoFAQEBCwGEPIQpj1gBAQEBAQEGgRGKCYUxihaBewkBAQEBAQEBAQE3A?=
 =?us-ascii?q?QGEOwMCAoQwNQgOAg4BAQEEAQEBAQEFAwGFWIYqAgEDIwRSEBgNAiYCAkcQB?=
 =?us-ascii?q?hOFdbBidX8zGoozgQ4oAYFkikZ4gQeBETODHYdVgl4Ej0M3hkBDlnWCLpVRD?=
 =?us-ascii?q?I4oA4suLalnAYIPTS4KgydQkX5njm0BAQ?=
X-IronPort-AV: E=Sophos;i="5.68,266,1569254400"; 
   d="scan'208";a="207138649"
Received: from unknown (HELO [192.168.1.222]) ([118.208.189.18])
  by icp-osb-irony-out4.iinet.net.au with ESMTP; 04 Nov 2019 18:54:56 +0800
Subject: [PATCH v9 04/17] xfs: use kmem functions for struct xfs_mount
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Mon, 04 Nov 2019 18:54:57 +0800
Message-ID: <157286489698.18393.11608985261787201461.stgit@fedora-28>
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

