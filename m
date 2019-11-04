Return-Path: <SRS0=9rhF=Y4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44DEECA9EA0
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 10:55:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14D3221D7F
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 10:55:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728540AbfKDKzE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 05:55:04 -0500
Received: from icp-osb-irony-out4.external.iinet.net.au ([203.59.1.220]:34019
        "EHLO icp-osb-irony-out4.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728520AbfKDKzE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 05:55:04 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2APAAC6AsBd/xK90HYNWRsBAQEBAQE?=
 =?us-ascii?q?BBQEBAREBAQMDAQEBgWsEAQEBCwGEPIQpj1gBAQEBAQEGgRGKCYUxihaBewk?=
 =?us-ascii?q?BAQEBAQEBAQE3AQGEOwMCAoQwNgcOAg4BAQEEAQEBAQEFAwGFWIYqAgEDIwR?=
 =?us-ascii?q?SEBgNAiYCAkcQBhOFdbBidX8zGoozgQ4oAYFkikZ4gQeBETODHYdVgl4Ej0M?=
 =?us-ascii?q?3hkBDlnWCLpVRDI4oA4suqhoJggFNLgqDJ1CDNxeOMGeObQEB?=
X-IPAS-Result: =?us-ascii?q?A2APAAC6AsBd/xK90HYNWRsBAQEBAQEBBQEBAREBAQMDA?=
 =?us-ascii?q?QEBgWsEAQEBCwGEPIQpj1gBAQEBAQEGgRGKCYUxihaBewkBAQEBAQEBAQE3A?=
 =?us-ascii?q?QGEOwMCAoQwNgcOAg4BAQEEAQEBAQEFAwGFWIYqAgEDIwRSEBgNAiYCAkcQB?=
 =?us-ascii?q?hOFdbBidX8zGoozgQ4oAYFkikZ4gQeBETODHYdVgl4Ej0M3hkBDlnWCLpVRD?=
 =?us-ascii?q?I4oA4suqhoJggFNLgqDJ1CDNxeOMGeObQEB?=
X-IronPort-AV: E=Sophos;i="5.68,266,1569254400"; 
   d="scan'208";a="207138653"
Received: from unknown (HELO [192.168.1.222]) ([118.208.189.18])
  by icp-osb-irony-out4.iinet.net.au with ESMTP; 04 Nov 2019 18:55:02 +0800
Subject: [PATCH v9 05/17] xfs: merge freeing of mp names and mp
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Mon, 04 Nov 2019 18:55:02 +0800
Message-ID: <157286490216.18393.1751888232608516285.stgit@fedora-28>
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

In all cases when struct xfs_mount (mp) fields m_rtname and m_logname
are freed mp is also freed, so merge these into a single function
xfs_mount_free()

Signed-off-by: Ian Kent <raven@themaw.net>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_super.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index eb919e74d8eb..6d908b76aa9e 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -998,12 +998,13 @@ xfs_fs_drop_inode(
 	return generic_drop_inode(inode) || (ip->i_flags & XFS_IDONTCACHE);
 }
 
-STATIC void
-xfs_free_names(
+static void
+xfs_mount_free(
 	struct xfs_mount	*mp)
 {
 	kfree(mp->m_rtname);
 	kfree(mp->m_logname);
+	kmem_free(mp);
 }
 
 STATIC int
@@ -1178,8 +1179,7 @@ xfs_test_remount_options(
 
 	tmp_mp->m_super = sb;
 	error = xfs_parseargs(tmp_mp, options);
-	xfs_free_names(tmp_mp);
-	kmem_free(tmp_mp);
+	xfs_mount_free(tmp_mp);
 
 	return error;
 }
@@ -1710,8 +1710,7 @@ xfs_fs_fill_super(
 	xfs_close_devices(mp);
  out_free_names:
 	sb->s_fs_info = NULL;
-	xfs_free_names(mp);
-	kmem_free(mp);
+	xfs_mount_free(mp);
  out:
 	return error;
 
@@ -1742,8 +1741,7 @@ xfs_fs_put_super(
 	xfs_close_devices(mp);
 
 	sb->s_fs_info = NULL;
-	xfs_free_names(mp);
-	kmem_free(mp);
+	xfs_mount_free(mp);
 }
 
 STATIC struct dentry *

