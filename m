Return-Path: <SRS0=9rhF=Y4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CA16CA9EA0
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 10:54:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13B26217F5
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 10:54:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728654AbfKDKyy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 05:54:54 -0500
Received: from icp-osb-irony-out4.external.iinet.net.au ([203.59.1.220]:34019
        "EHLO icp-osb-irony-out4.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728559AbfKDKyy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 05:54:54 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2APAAC6AsBd/xK90HYNWRsBAQEBAQE?=
 =?us-ascii?q?BBQEBAREBAQMDAQEBgWsEAQEBCwGEPIQpj1gBAQEBAQEGgRGKCYUxhG6FKIF?=
 =?us-ascii?q?7CQEBAQEBAQEBATcBAYQ7AwIChDA2Bw4CDgEBAQQBAQEBAQUDAYVYhioCAQM?=
 =?us-ascii?q?jBFIQGA0CJgICRxAGE4V1sGJ1fzMaijOBDigBgWSKRniBB4FEgx2EKoMrgl4?=
 =?us-ascii?q?Ej0M3hkBDlnWCLpVRDI4oA4suLYo+ny8BgglNLgqDJ1CRfmeML4I+AQE?=
X-IPAS-Result: =?us-ascii?q?A2APAAC6AsBd/xK90HYNWRsBAQEBAQEBBQEBAREBAQMDA?=
 =?us-ascii?q?QEBgWsEAQEBCwGEPIQpj1gBAQEBAQEGgRGKCYUxhG6FKIF7CQEBAQEBAQEBA?=
 =?us-ascii?q?TcBAYQ7AwIChDA2Bw4CDgEBAQQBAQEBAQUDAYVYhioCAQMjBFIQGA0CJgICR?=
 =?us-ascii?q?xAGE4V1sGJ1fzMaijOBDigBgWSKRniBB4FEgx2EKoMrgl4Ej0M3hkBDlnWCL?=
 =?us-ascii?q?pVRDI4oA4suLYo+ny8BgglNLgqDJ1CRfmeML4I+AQE?=
X-IronPort-AV: E=Sophos;i="5.68,266,1569254400"; 
   d="scan'208";a="207138647"
Received: from unknown (HELO [192.168.1.222]) ([118.208.189.18])
  by icp-osb-irony-out4.iinet.net.au with ESMTP; 04 Nov 2019 18:54:51 +0800
Subject: [PATCH v9 03/17] xfs: dont use XFS_IS_QUOTA_RUNNING() for option
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
Date:   Mon, 04 Nov 2019 18:54:51 +0800
Message-ID: <157286489165.18393.1272288484990933796.stgit@fedora-28>
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

When CONFIG_XFS_QUOTA is not defined any quota option is invalid.

Using the macro XFS_IS_QUOTA_RUNNING() as a check if any quota option
has been given is a little misleading so use a simple m_qflags != 0
check to make the intended use more explicit.

Also change to use the IS_ENABLED() macro for the kernel config check.

Signed-off-by: Ian Kent <raven@themaw.net>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
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

