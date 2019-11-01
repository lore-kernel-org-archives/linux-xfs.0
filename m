Return-Path: <SRS0=5kOL=YZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 640F2CA9EC9
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 07:50:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B7962080F
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 07:50:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbfKAHuF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Nov 2019 03:50:05 -0400
Received: from icp-osb-irony-out7.external.iinet.net.au ([203.59.1.107]:8687
        "EHLO icp-osb-irony-out7.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725787AbfKAHuF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Nov 2019 03:50:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2AUAABb4rtd/xK90HYNVxwBAQEBAQc?=
 =?us-ascii?q?BAREBBAQBAYFpBwEBCwGEPIQoiCOHNgEBAQEBAQaBEYoIhTABihWBewkBAQE?=
 =?us-ascii?q?BAQEBAQE3AQGEOwMCAoQeNAkOAgwBAQEEAQEBAQEFAwGFWIYqAgEDIwRSEBg?=
 =?us-ascii?q?NAiYCAkcQBhOFdbBkdX8zGoo3gQ4oAYFkikR4gQeBRIMdh1WCXgSPQjeFYGF?=
 =?us-ascii?q?DlnWCLpVQDI4oA4suLalhghFNLgqDJ1CRfWeObAEB?=
X-IPAS-Result: =?us-ascii?q?A2AUAABb4rtd/xK90HYNVxwBAQEBAQcBAREBBAQBAYFpB?=
 =?us-ascii?q?wEBCwGEPIQoiCOHNgEBAQEBAQaBEYoIhTABihWBewkBAQEBAQEBAQE3AQGEO?=
 =?us-ascii?q?wMCAoQeNAkOAgwBAQEEAQEBAQEFAwGFWIYqAgEDIwRSEBgNAiYCAkcQBhOFd?=
 =?us-ascii?q?bBkdX8zGoo3gQ4oAYFkikR4gQeBRIMdh1WCXgSPQjeFYGFDlnWCLpVQDI4oA?=
 =?us-ascii?q?4suLalhghFNLgqDJ1CRfWeObAEB?=
X-IronPort-AV: E=Sophos;i="5.68,254,1569254400"; 
   d="scan'208";a="215829848"
Received: from unknown (HELO [192.168.1.222]) ([118.208.189.18])
  by icp-osb-irony-out7.iinet.net.au with ESMTP; 01 Nov 2019 15:50:02 +0800
Subject: [PATCH v8 01/16] xfs: remove unused struct xfs_mount field
 m_fsname_len
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Fri, 01 Nov 2019 15:50:01 +0800
Message-ID: <157259460183.28278.15538164105796626018.stgit@fedora-28>
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

The struct xfs_mount field m_fsname_len is not used anywhere, remove it.

Signed-off-by: Ian Kent <raven@themaw.net>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_mount.h |    1 -
 fs/xfs/xfs_super.c |    1 -
 2 files changed, 2 deletions(-)

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index a46cb3fd24b1..6e7d746b41bc 100644
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
index bcb1575a5652..f3ecd696180d 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -168,7 +168,6 @@ xfs_parseargs(
 	mp->m_fsname = kstrndup(sb->s_id, MAXNAMELEN, GFP_KERNEL);
 	if (!mp->m_fsname)
 		return -ENOMEM;
-	mp->m_fsname_len = strlen(mp->m_fsname) + 1;
 
 	/*
 	 * Copy binary VFS mount flags we are interested in.

