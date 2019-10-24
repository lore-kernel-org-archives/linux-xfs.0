Return-Path: <SRS0=feM8=YR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3341DCA9EBB
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 07:51:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F4B82084C
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 07:51:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390783AbfJXHvT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Oct 2019 03:51:19 -0400
Received: from icp-osb-irony-out1.external.iinet.net.au ([203.59.1.210]:26989
        "EHLO icp-osb-irony-out1.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389149AbfJXHvT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Oct 2019 03:51:19 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2A3AADRVrFd/0e30XYNWBsBAQEBAQE?=
 =?us-ascii?q?BBQEBAREBAQMDAQEBgWoDAQEBCwEBhDqEKI9JBoERiiKFIAGMDgkBAQEBAQE?=
 =?us-ascii?q?BAQE3AQGEOwMCAoNZNwYOAgwBAQEEAQEBAQEFAwGFWIEaAQEEBwGFAQIBAyM?=
 =?us-ascii?q?EUhAYDQImAgJHEAYThXWxdHV/MxqKMIEOKAGBZIpCeIEHgREzgx2HVYJeBI0?=
 =?us-ascii?q?Ogi83hkBDlmyCLpVFDI4fA4skqhWBe00uCoMnUIM2F44wZ4c9gxmFWAEB?=
X-IPAS-Result: =?us-ascii?q?A2A3AADRVrFd/0e30XYNWBsBAQEBAQEBBQEBAREBAQMDA?=
 =?us-ascii?q?QEBgWoDAQEBCwEBhDqEKI9JBoERiiKFIAGMDgkBAQEBAQEBAQE3AQGEOwMCA?=
 =?us-ascii?q?oNZNwYOAgwBAQEEAQEBAQEFAwGFWIEaAQEEBwGFAQIBAyMEUhAYDQImAgJHE?=
 =?us-ascii?q?AYThXWxdHV/MxqKMIEOKAGBZIpCeIEHgREzgx2HVYJeBI0Ogi83hkBDlmyCL?=
 =?us-ascii?q?pVFDI4fA4skqhWBe00uCoMnUIM2F44wZ4c9gxmFWAEB?=
X-IronPort-AV: E=Sophos;i="5.68,224,1569254400"; 
   d="scan'208";a="250043961"
Received: from unknown (HELO [192.168.1.222]) ([118.209.183.71])
  by icp-osb-irony-out1.iinet.net.au with ESMTP; 24 Oct 2019 15:51:17 +0800
Subject: [PATCH v7 08/17] xfs: merge freeing of mp names and mp
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Thu, 24 Oct 2019 15:51:17 +0800
Message-ID: <157190347727.27074.15948763811572596699.stgit@fedora-28>
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

In all cases when struct xfs_mount (mp) fields m_rtname and m_logname
are freed mp is also freed, so merge these into a single function
xfs_mount_free().

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/xfs/xfs_super.c |   26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 0596d491dbbe..297e6c98742e 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -446,6 +446,15 @@ xfs_mount_alloc(
 	return mp;
 }
 
+static void
+xfs_mount_free(
+	struct xfs_mount	*mp)
+{
+	kfree(mp->m_rtname);
+	kfree(mp->m_logname);
+	kmem_free(mp);
+}
+
 struct proc_xfs_info {
 	uint64_t	flag;
 	char		*str;
@@ -1058,14 +1067,6 @@ xfs_fs_drop_inode(
 	return generic_drop_inode(inode) || (ip->i_flags & XFS_IDONTCACHE);
 }
 
-STATIC void
-xfs_free_names(
-	struct xfs_mount	*mp)
-{
-	kfree(mp->m_rtname);
-	kfree(mp->m_logname);
-}
-
 STATIC int
 xfs_fs_sync_fs(
 	struct super_block	*sb,
@@ -1238,8 +1239,7 @@ xfs_test_remount_options(
 
 	tmp_mp->m_super = sb;
 	error = xfs_parseargs(tmp_mp, options);
-	xfs_free_names(tmp_mp);
-	kmem_free(tmp_mp);
+	xfs_mount_free(tmp_mp);
 
 	return error;
 }
@@ -1747,8 +1747,7 @@ xfs_fs_fill_super(
 	xfs_close_devices(mp);
  out_free_names:
 	sb->s_fs_info = NULL;
-	xfs_free_names(mp);
-	kmem_free(mp);
+	xfs_mount_free(mp);
  out:
 	return error;
 
@@ -1779,8 +1778,7 @@ xfs_fs_put_super(
 	xfs_close_devices(mp);
 
 	sb->s_fs_info = NULL;
-	xfs_free_names(mp);
-	kmem_free(mp);
+	xfs_mount_free(mp);
 }
 
 STATIC struct dentry *

