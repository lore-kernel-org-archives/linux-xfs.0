Return-Path: <SRS0=9rhF=Y4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5550ACA9EA0
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 10:54:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34DE5222C1
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 10:54:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728537AbfKDKym (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 05:54:42 -0500
Received: from icp-osb-irony-out4.external.iinet.net.au ([203.59.1.220]:34019
        "EHLO icp-osb-irony-out4.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728559AbfKDKym (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 05:54:42 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2AuAAC6AsBd/xK90HYNWRwBAQEBAQc?=
 =?us-ascii?q?BAREBBAQBAYFrBQEBCwGEPIQpj1gBAQEBAQEGgRGKCYUxihaBewkBAQEBAQE?=
 =?us-ascii?q?BAQE3AQGEOwMCAoQwNgcOAg4BAQEEAQEBAQEFAwGFWIYqAgEDIwRSEBgNAiY?=
 =?us-ascii?q?CAkcQBhOFdbBidX8zGoozgQ4oAYFkikZ4gQeBRIMdh1WCXgSPQzeFX2FDlnW?=
 =?us-ascii?q?CLpVRDI4oA4suLaltDIF+TS4KgydQkX5njm0BAQ?=
X-IPAS-Result: =?us-ascii?q?A2AuAAC6AsBd/xK90HYNWRwBAQEBAQcBAREBBAQBAYFrB?=
 =?us-ascii?q?QEBCwGEPIQpj1gBAQEBAQEGgRGKCYUxihaBewkBAQEBAQEBAQE3AQGEOwMCA?=
 =?us-ascii?q?oQwNgcOAg4BAQEEAQEBAQEFAwGFWIYqAgEDIwRSEBgNAiYCAkcQBhOFdbBid?=
 =?us-ascii?q?X8zGoozgQ4oAYFkikZ4gQeBRIMdh1WCXgSPQzeFX2FDlnWCLpVRDI4oA4suL?=
 =?us-ascii?q?altDIF+TS4KgydQkX5njm0BAQ?=
X-IronPort-AV: E=Sophos;i="5.68,266,1569254400"; 
   d="scan'208";a="207138636"
Received: from unknown (HELO [192.168.1.222]) ([118.208.189.18])
  by icp-osb-irony-out4.iinet.net.au with ESMTP; 04 Nov 2019 18:54:40 +0800
Subject: [PATCH v9 01/17] xfs: remove unused struct xfs_mount field
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
Date:   Mon, 04 Nov 2019 18:54:40 +0800
Message-ID: <157286488093.18393.9022601793898185462.stgit@fedora-28>
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

