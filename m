Return-Path: <SRS0=5kOL=YZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85BD9CA9EC9
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 07:50:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56A5F2080F
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 07:50:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729825AbfKAHuR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Nov 2019 03:50:17 -0400
Received: from icp-osb-irony-out7.external.iinet.net.au ([203.59.1.107]:8687
        "EHLO icp-osb-irony-out7.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725787AbfKAHuQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Nov 2019 03:50:16 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2AUAABb4rtd/xK90HYNVxwBAQEBAQc?=
 =?us-ascii?q?BAREBBAQBAYFpBwEBCwGEPIQoiCOHNgEBAQEBAQaBEYoIhTABhG2FKIF7CQE?=
 =?us-ascii?q?BAQEBAQEBATcBAYQ7AwIChB40CQ4CDAEBAQQBAQEBAQUDAYVYhioCAQMjBFI?=
 =?us-ascii?q?QGA0CJgICRxAGE4V1sGR1fzMaijeBDigBgWSKRHiBB4FEgx2EKoMrgl4Ej0I?=
 =?us-ascii?q?3hkFDlnWCLpVQDI4oA4suLYo9nySCEU0uCoMnUJF9Z4wugj4BAQ?=
X-IPAS-Result: =?us-ascii?q?A2AUAABb4rtd/xK90HYNVxwBAQEBAQcBAREBBAQBAYFpB?=
 =?us-ascii?q?wEBCwGEPIQoiCOHNgEBAQEBAQaBEYoIhTABhG2FKIF7CQEBAQEBAQEBATcBA?=
 =?us-ascii?q?YQ7AwIChB40CQ4CDAEBAQQBAQEBAQUDAYVYhioCAQMjBFIQGA0CJgICRxAGE?=
 =?us-ascii?q?4V1sGR1fzMaijeBDigBgWSKRHiBB4FEgx2EKoMrgl4Ej0I3hkFDlnWCLpVQD?=
 =?us-ascii?q?I4oA4suLYo9nySCEU0uCoMnUJF9Z4wugj4BAQ?=
X-IronPort-AV: E=Sophos;i="5.68,254,1569254400"; 
   d="scan'208";a="215829922"
Received: from unknown (HELO [192.168.1.222]) ([118.208.189.18])
  by icp-osb-irony-out7.iinet.net.au with ESMTP; 01 Nov 2019 15:50:13 +0800
Subject: [PATCH v8 03/16] xfs: dont use XFS_IS_QUOTA_RUNNING() for option
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
Date:   Fri, 01 Nov 2019 15:50:13 +0800
Message-ID: <157259461351.28278.7899654768801700302.stgit@fedora-28>
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

When CONFIG_XFS_QUOTA is not defined any quota option is invalid.

Using the macro XFS_IS_QUOTA_RUNNING() as a check if any quota option
has been given is a little misleading so use a simple m_qflags != 0
check to make the intended use more explicit.

Also change to use the IS_ENABLED() macro for the kernel config check.

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/xfs/xfs_super.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 6438738a204a..fb90beeb3184 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -341,12 +341,10 @@ xfs_parseargs(
 		return -EINVAL;
 	}
 
-#ifndef CONFIG_XFS_QUOTA
-	if (XFS_IS_QUOTA_RUNNING(mp)) {
+	if (!IS_ENABLED(CONFIG_XFS_QUOTA) && mp->m_qflags != 0) {
 		xfs_warn(mp, "quota support not available in this kernel.");
 		return -EINVAL;
 	}
-#endif
 
 	if ((mp->m_dalign && !mp->m_swidth) ||
 	    (!mp->m_dalign && mp->m_swidth)) {

