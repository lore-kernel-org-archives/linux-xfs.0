Return-Path: <SRS0=pjFm=YJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEF0AECE59D
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 00:41:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 902492067B
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 00:41:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388302AbfJPAl0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Oct 2019 20:41:26 -0400
Received: from icp-osb-irony-out1.external.iinet.net.au ([203.59.1.210]:40358
        "EHLO icp-osb-irony-out1.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390284AbfJPAlY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Oct 2019 20:41:24 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2DmAQDRZqZd/0e30XYNWRwBAQEBAQc?=
 =?us-ascii?q?BAREBBAQBAYF7hDyEJY8zAQEBAQEBBoERih2FIAGEa4cjCQEBAQEBAQEBATc?=
 =?us-ascii?q?BAYQ7AwICgxI4EwIMAQEBBAEBAQEBBQMBhViGGgIBAyMEUhAYDQImAgJHEAY?=
 =?us-ascii?q?ThXWuB3V/MxqKKYEMKIFlikF4gQeBRIMdhA0cgymCXgSPNjeGPkOWXYIslTY?=
 =?us-ascii?q?MjhYDix0tijSfHIF6TS4KgydQkEZnjn0BglMBAQ?=
X-IPAS-Result: =?us-ascii?q?A2DmAQDRZqZd/0e30XYNWRwBAQEBAQcBAREBBAQBAYF7h?=
 =?us-ascii?q?DyEJY8zAQEBAQEBBoERih2FIAGEa4cjCQEBAQEBAQEBATcBAYQ7AwICgxI4E?=
 =?us-ascii?q?wIMAQEBBAEBAQEBBQMBhViGGgIBAyMEUhAYDQImAgJHEAYThXWuB3V/MxqKK?=
 =?us-ascii?q?YEMKIFlikF4gQeBRIMdhA0cgymCXgSPNjeGPkOWXYIslTYMjhYDix0tijSfH?=
 =?us-ascii?q?IF6TS4KgydQkEZnjn0BglMBAQ?=
X-IronPort-AV: E=Sophos;i="5.67,301,1566835200"; 
   d="scan'208";a="247444163"
Received: from unknown (HELO [192.168.1.222]) ([118.209.183.71])
  by icp-osb-irony-out1.iinet.net.au with ESMTP; 16 Oct 2019 08:41:08 +0800
Subject: [PATCH v6 05/12] xfs: dont use XFS_IS_QUOTA_RUNNING() for option
 check
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Wed, 16 Oct 2019 08:41:08 +0800
Message-ID: <157118646832.9678.14900204464012668551.stgit@fedora-28>
In-Reply-To: <157118625324.9678.16275725173770634823.stgit@fedora-28>
References: <157118625324.9678.16275725173770634823.stgit@fedora-28>
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

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/xfs/xfs_super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 5876c2b551b5..f8770206b66e 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -349,7 +349,7 @@ xfs_parseargs(
 	}
 
 #ifndef CONFIG_XFS_QUOTA
-	if (XFS_IS_QUOTA_RUNNING(mp)) {
+	if (mp->m_qflags != 0) {
 		xfs_warn(mp, "quota support not available in this kernel.");
 		return -EINVAL;
 	}

