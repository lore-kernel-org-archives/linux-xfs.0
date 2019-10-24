Return-Path: <SRS0=feM8=YR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1023BCA9EAF
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 07:51:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF4F62166E
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 07:51:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408746AbfJXHvl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Oct 2019 03:51:41 -0400
Received: from icp-osb-irony-out1.external.iinet.net.au ([203.59.1.210]:26989
        "EHLO icp-osb-irony-out1.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2408743AbfJXHvl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Oct 2019 03:51:41 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2AeAADRVrFd/0e30XYNWBsBAQEBAQE?=
 =?us-ascii?q?BBQEBAREBAQMDAQEBgWoDAQEBCwEBgXKCSIQoj0kGizOFIAGMDgkBAQEBAQE?=
 =?us-ascii?q?BAQE3AQGEOwMCAoNZNwYOAgwBAQEEAQEBAQEFAwGFWIEaAQwBhQECAQMjBFI?=
 =?us-ascii?q?QGA0CJgICRxAGE4V1sXR1fzMaijCBDigBgWSKQniBB4ERg1CHVYJeBIxqglM?=
 =?us-ascii?q?3hkBDlmyCLpVFDIIvi3ADEIsUqhWBe00uCoMnUIRRAQKNKWeKVoVYAQE?=
X-IPAS-Result: =?us-ascii?q?A2AeAADRVrFd/0e30XYNWBsBAQEBAQEBBQEBAREBAQMDA?=
 =?us-ascii?q?QEBgWoDAQEBCwEBgXKCSIQoj0kGizOFIAGMDgkBAQEBAQEBAQE3AQGEOwMCA?=
 =?us-ascii?q?oNZNwYOAgwBAQEEAQEBAQEFAwGFWIEaAQwBhQECAQMjBFIQGA0CJgICRxAGE?=
 =?us-ascii?q?4V1sXR1fzMaijCBDigBgWSKQniBB4ERg1CHVYJeBIxqglM3hkBDlmyCLpVFD?=
 =?us-ascii?q?IIvi3ADEIsUqhWBe00uCoMnUIRRAQKNKWeKVoVYAQE?=
X-IronPort-AV: E=Sophos;i="5.68,224,1569254400"; 
   d="scan'208";a="250044037"
Received: from unknown (HELO [192.168.1.222]) ([118.209.183.71])
  by icp-osb-irony-out1.iinet.net.au with ESMTP; 24 Oct 2019 15:51:38 +0800
Subject: [PATCH v7 12/17] xfs: avoid redundant checks when options is empty
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Thu, 24 Oct 2019 15:51:38 +0800
Message-ID: <157190349799.27074.795104447849311945.stgit@fedora-28>
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

When options passed to xfs_parseargs() is NULL the checks performed
after taking the branch are made with the initial values of dsunit,
dswidth and iosizelog. But all the checks do nothing in this case
so return immediately instead.

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/xfs/xfs_super.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 003ec725d4b6..92a37ac0b907 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -211,7 +211,7 @@ xfs_parseargs(
 	mp->m_logbsize = -1;
 
 	if (!options)
-		goto done;
+		return 0;
 
 	while ((p = strsep(&options, ",")) != NULL) {
 		int		token;
@@ -390,7 +390,6 @@ xfs_parseargs(
 		return -EINVAL;
 	}
 
-done:
 	if (dsunit && !(mp->m_flags & XFS_MOUNT_NOALIGN)) {
 		/*
 		 * At this point the superblock has not been read

