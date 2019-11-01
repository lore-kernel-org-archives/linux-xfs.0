Return-Path: <SRS0=5kOL=YZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD02FCA9EC9
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 07:51:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 984BB208CB
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 07:51:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729855AbfKAHv1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Nov 2019 03:51:27 -0400
Received: from icp-osb-irony-out7.external.iinet.net.au ([203.59.1.107]:9078
        "EHLO icp-osb-irony-out7.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727053AbfKAHv1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Nov 2019 03:51:27 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2AUAACY47td/xK90HYNVxwBAQEBAQc?=
 =?us-ascii?q?BAREBBAQBAYFpBwEBCwGBc4JJhCiII4c3AQEBAQEBBoERigiFMAGKFYF7CQE?=
 =?us-ascii?q?BAQEBAQEBATcBAYQ7AwIChB40CQ4CDAEBAQQBAQEBAQUDAYVYhioCAQMjBFI?=
 =?us-ascii?q?QGA0CJgICRxAGE4V1sF51fzMaijeBDigBgWSKRHiBB4ERM4Mdh1WCXgSMb4J?=
 =?us-ascii?q?TN4ZBQ5Z1gi6VUAyOKAOLLqoOghFNLgqDJ1CEUQECjSlnjmwBAQ?=
X-IPAS-Result: =?us-ascii?q?A2AUAACY47td/xK90HYNVxwBAQEBAQcBAREBBAQBAYFpB?=
 =?us-ascii?q?wEBCwGBc4JJhCiII4c3AQEBAQEBBoERigiFMAGKFYF7CQEBAQEBAQEBATcBA?=
 =?us-ascii?q?YQ7AwIChB40CQ4CDAEBAQQBAQEBAQUDAYVYhioCAQMjBFIQGA0CJgICRxAGE?=
 =?us-ascii?q?4V1sF51fzMaijeBDigBgWSKRHiBB4ERM4Mdh1WCXgSMb4JTN4ZBQ5Z1gi6VU?=
 =?us-ascii?q?AyOKAOLLqoOghFNLgqDJ1CEUQECjSlnjmwBAQ?=
X-IronPort-AV: E=Sophos;i="5.68,254,1569254400"; 
   d="scan'208";a="215830056"
Received: from unknown (HELO [192.168.1.222]) ([118.208.189.18])
  by icp-osb-irony-out7.iinet.net.au with ESMTP; 01 Nov 2019 15:50:50 +0800
Subject: [PATCH v8 09/16] xfs: avoid redundant checks when options is empty
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Fri, 01 Nov 2019 15:50:50 +0800
Message-ID: <157259465023.28278.3190346597342810121.stgit@fedora-28>
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

When options passed to xfs_parseargs() is NULL the checks performed
after taking the branch are made with the initial values of dsunit,
dswidth and iosizelog. But all the checks do nothing in this case
so return immediately instead.

Signed-off-by: Ian Kent <raven@themaw.net>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_super.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 0dc072700599..17188a9ed541 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -199,7 +199,7 @@ xfs_parseargs(
 	mp->m_allocsize_log = 16; /* 64k */
 
 	if (!options)
-		goto done;
+		return 0;
 
 	while ((p = strsep(&options, ",")) != NULL) {
 		int		token;
@@ -379,7 +379,6 @@ xfs_parseargs(
 		return -EINVAL;
 	}
 
-done:
 	if (mp->m_logbufs != -1 &&
 	    mp->m_logbufs != 0 &&
 	    (mp->m_logbufs < XLOG_MIN_ICLOGS ||

