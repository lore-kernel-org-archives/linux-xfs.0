Return-Path: <SRS0=pjFm=YJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A468ECE59E
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 00:41:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BA1E21928
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 00:41:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388287AbfJPAlZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Oct 2019 20:41:25 -0400
Received: from icp-osb-irony-out1.external.iinet.net.au ([203.59.1.210]:40390
        "EHLO icp-osb-irony-out1.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388246AbfJPAlY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Oct 2019 20:41:24 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2DmAQDRZqZd/0e30XYNWRwBAQEBAQc?=
 =?us-ascii?q?BAREBBAQBAYF7hDyEJY8zAQEBAQEBBoERih2FIAGMDgkBAQEBAQEBAQE3AQG?=
 =?us-ascii?q?EOwMCAoMSOBMCDAEBAQQBAQEBAQUDAYVYhhoCAQMjBFIQGA0CJgICRxAGE4V?=
 =?us-ascii?q?1rgd1fzMaiimBDCiBZYpBeIEHgUSDHYdSgl4EjzY3hV1hQ5ZdgiyVNgyOFgO?=
 =?us-ascii?q?LHS2pUIF6TS4KgydQkEZnkVEBAQ?=
X-IPAS-Result: =?us-ascii?q?A2DmAQDRZqZd/0e30XYNWRwBAQEBAQcBAREBBAQBAYF7h?=
 =?us-ascii?q?DyEJY8zAQEBAQEBBoERih2FIAGMDgkBAQEBAQEBAQE3AQGEOwMCAoMSOBMCD?=
 =?us-ascii?q?AEBAQQBAQEBAQUDAYVYhhoCAQMjBFIQGA0CJgICRxAGE4V1rgd1fzMaiimBD?=
 =?us-ascii?q?CiBZYpBeIEHgUSDHYdSgl4EjzY3hV1hQ5ZdgiyVNgyOFgOLHS2pUIF6TS4Kg?=
 =?us-ascii?q?ydQkEZnkVEBAQ?=
X-IronPort-AV: E=Sophos;i="5.67,301,1566835200"; 
   d="scan'208";a="247444122"
Received: from unknown (HELO [192.168.1.222]) ([118.209.183.71])
  by icp-osb-irony-out1.iinet.net.au with ESMTP; 16 Oct 2019 08:40:58 +0800
Subject: [PATCH v6 03/12] xfs: remove unused mount info field m_fsname_len
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Wed, 16 Oct 2019 08:40:58 +0800
Message-ID: <157118645790.9678.2717342742220454176.stgit@fedora-28>
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

The mount info field m_fsname_len is not used anywhere, remove it.

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/xfs/xfs_mount.h |    1 -
 fs/xfs/xfs_super.c |    1 -
 2 files changed, 2 deletions(-)

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index fdb60e09a9c5..b3230f7ca2bf 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -90,7 +90,6 @@ typedef struct xfs_mount {
 
 	struct xfs_buf		*m_sb_bp;	/* buffer for superblock */
 	char			*m_fsname;	/* filesystem name */
-	int			m_fsname_len;	/* strlen of fs name */
 	char			*m_rtname;	/* realtime device name */
 	char			*m_logname;	/* external log device name */
 	int			m_bsize;	/* fs logical block size */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 1bb7ede5d75b..cfa306f62bec 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -172,7 +172,6 @@ xfs_parseargs(
 	mp->m_fsname = kstrndup(sb->s_id, MAXNAMELEN, GFP_KERNEL);
 	if (!mp->m_fsname)
 		return -ENOMEM;
-	mp->m_fsname_len = strlen(mp->m_fsname) + 1;
 
 	/*
 	 * Copy binary VFS mount flags we are interested in.

