Return-Path: <SRS0=9rhF=Y4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94559CA9ECF
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 10:55:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72ABD217F5
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 10:55:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727985AbfKDKz0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 05:55:26 -0500
Received: from icp-osb-irony-out4.external.iinet.net.au ([203.59.1.220]:34019
        "EHLO icp-osb-irony-out4.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728310AbfKDKz0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 05:55:26 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2AKAAC6AsBd/xK90HYNWRsBAQEBAQE?=
 =?us-ascii?q?BBQEBAREBAQMDAQEBgWoFAQEBCwGBc4JJhCmPWAEBAQEBAQaBEYoJhTGKFoF?=
 =?us-ascii?q?7CQEBAQEBAQEBATcBAYQ7AwIChDA1CA4CDgEBAQQBAQEBAQUDAYVYhioCAQM?=
 =?us-ascii?q?jBFIQGA0CJgICRxAGE4V1sGJ1fzMaijOBDigBgWSKRniBB4ERM4Mdh1WCXgS?=
 =?us-ascii?q?McIJTN4ZAQ5Z1gi6VUQyOKAOLLqoVA4IMTS4KgydQhFIBAo0pZ45tAQE?=
X-IPAS-Result: =?us-ascii?q?A2AKAAC6AsBd/xK90HYNWRsBAQEBAQEBBQEBAREBAQMDA?=
 =?us-ascii?q?QEBgWoFAQEBCwGBc4JJhCmPWAEBAQEBAQaBEYoJhTGKFoF7CQEBAQEBAQEBA?=
 =?us-ascii?q?TcBAYQ7AwIChDA1CA4CDgEBAQQBAQEBAQUDAYVYhioCAQMjBFIQGA0CJgICR?=
 =?us-ascii?q?xAGE4V1sGJ1fzMaijOBDigBgWSKRniBB4ERM4Mdh1WCXgSMcIJTN4ZAQ5Z1g?=
 =?us-ascii?q?i6VUQyOKAOLLqoVA4IMTS4KgydQhFIBAo0pZ45tAQE?=
X-IronPort-AV: E=Sophos;i="5.68,266,1569254400"; 
   d="scan'208";a="207138674"
Received: from unknown (HELO [192.168.1.222]) ([118.208.189.18])
  by icp-osb-irony-out4.iinet.net.au with ESMTP; 04 Nov 2019 18:55:23 +0800
Subject: [PATCH v9 09/17] xfs: avoid redundant checks when options is empty
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Mon, 04 Nov 2019 18:55:23 +0800
Message-ID: <157286492330.18393.10252610238010972274.stgit@fedora-28>
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

