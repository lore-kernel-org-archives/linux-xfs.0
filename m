Return-Path: <SRS0=feM8=YR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68110CA9EAF
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 07:51:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 368CD2084C
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 07:51:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408740AbfJXHvD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Oct 2019 03:51:03 -0400
Received: from icp-osb-irony-out1.external.iinet.net.au ([203.59.1.210]:26989
        "EHLO icp-osb-irony-out1.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407212AbfJXHvD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Oct 2019 03:51:03 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2CoAADRVrFd/0e30XYNWBwBAQEBAQc?=
 =?us-ascii?q?BAREBBAQBAYFqBAEBCwEBhDqEKI9JBoERiiKFIAGEa4cjCQEBAQEBAQEBATc?=
 =?us-ascii?q?BAYQ7AwICg1k3Bg4CDAEBAQQBAQEBAQUDAYVYgRoBAQQHAYUBAgEDIwRSEBg?=
 =?us-ascii?q?NAiYCAkcQBhOFdbF0dX8zGoowgQ4oAYFkikJ4gQeBRIMdhCqDK4JeBI89N4Z?=
 =?us-ascii?q?AQ5Zsgi6VRQyOHwOLJC2KOJ8wgXtNLgqDJ1CRfWeHPYMZgn6CWgEB?=
X-IPAS-Result: =?us-ascii?q?A2CoAADRVrFd/0e30XYNWBwBAQEBAQcBAREBBAQBAYFqB?=
 =?us-ascii?q?AEBCwEBhDqEKI9JBoERiiKFIAGEa4cjCQEBAQEBAQEBATcBAYQ7AwICg1k3B?=
 =?us-ascii?q?g4CDAEBAQQBAQEBAQUDAYVYgRoBAQQHAYUBAgEDIwRSEBgNAiYCAkcQBhOFd?=
 =?us-ascii?q?bF0dX8zGoowgQ4oAYFkikJ4gQeBRIMdhCqDK4JeBI89N4ZAQ5Zsgi6VRQyOH?=
 =?us-ascii?q?wOLJC2KOJ8wgXtNLgqDJ1CRfWeHPYMZgn6CWgEB?=
X-IronPort-AV: E=Sophos;i="5.68,224,1569254400"; 
   d="scan'208";a="250043860"
Received: from unknown (HELO [192.168.1.222]) ([118.209.183.71])
  by icp-osb-irony-out1.iinet.net.au with ESMTP; 24 Oct 2019 15:51:01 +0800
Subject: [PATCH v7 05/17] xfs: dont use XFS_IS_QUOTA_RUNNING() for option
 check
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Thu, 24 Oct 2019 15:51:01 +0800
Message-ID: <157190346159.27074.3152127833811363522.stgit@fedora-28>
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

When CONFIG_XFS_QUOTA is not defined any quota option is invalid.

Using the macro XFS_IS_QUOTA_RUNNING() as a check if any quota option
has been given is a little misleading so use a simple m_qflags != 0
check to make the intended use more explicit.

Also change to use the IS_ENABLED() macro for the kernel config check.

Signed-off-by: Ian Kent <raven@themaw.net>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_super.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 5876c2b551b5..a0805b74256c 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -348,8 +348,8 @@ xfs_parseargs(
 		return -EINVAL;
 	}
 
-#ifndef CONFIG_XFS_QUOTA
-	if (XFS_IS_QUOTA_RUNNING(mp)) {
+#if !IS_ENABLED(CONFIG_XFS_QUOTA)
+	if (mp->m_qflags != 0) {
 		xfs_warn(mp, "quota support not available in this kernel.");
 		return -EINVAL;
 	}

