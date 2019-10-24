Return-Path: <SRS0=feM8=YR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E96BCA9EAF
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 07:50:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0CBF72084C
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 07:50:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407250AbfJXHux (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Oct 2019 03:50:53 -0400
Received: from icp-osb-irony-out1.external.iinet.net.au ([203.59.1.210]:26989
        "EHLO icp-osb-irony-out1.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407212AbfJXHux (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Oct 2019 03:50:53 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2DCAgDRVrFd/0e30XYNWBwBAQEBAQc?=
 =?us-ascii?q?BAREBBAQBAYF7AoQ6hCiPSQaBEYoihSABjA4JAQEBAQEBAQEBNwEBhDsDAgK?=
 =?us-ascii?q?DWTgTAgwBAQEEAQEBAQEFAwGFWIEaAQEEBwGFAQIBAyMEUhAYDQImAgJHEAY?=
 =?us-ascii?q?ThXWxdHV/MxqKMIEOKAGBZIpCeIEHgUSDHYdVgl4Ejz03hV9hQ5Zsgi6VRQy?=
 =?us-ascii?q?OHwOLJC2paYF6TS4KgydQkX1nhz2DGYVYAQE?=
X-IPAS-Result: =?us-ascii?q?A2DCAgDRVrFd/0e30XYNWBwBAQEBAQcBAREBBAQBAYF7A?=
 =?us-ascii?q?oQ6hCiPSQaBEYoihSABjA4JAQEBAQEBAQEBNwEBhDsDAgKDWTgTAgwBAQEEA?=
 =?us-ascii?q?QEBAQEFAwGFWIEaAQEEBwGFAQIBAyMEUhAYDQImAgJHEAYThXWxdHV/MxqKM?=
 =?us-ascii?q?IEOKAGBZIpCeIEHgUSDHYdVgl4Ejz03hV9hQ5Zsgi6VRQyOHwOLJC2paYF6T?=
 =?us-ascii?q?S4KgydQkX1nhz2DGYVYAQE?=
X-IronPort-AV: E=Sophos;i="5.68,224,1569254400"; 
   d="scan'208";a="250043795"
Received: from unknown (HELO [192.168.1.222]) ([118.209.183.71])
  by icp-osb-irony-out1.iinet.net.au with ESMTP; 24 Oct 2019 15:50:51 +0800
Subject: [PATCH v7 03/17] xfs: remove unused struct xfs_mount field
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
Date:   Thu, 24 Oct 2019 15:50:51 +0800
Message-ID: <157190345118.27074.6572797343172412242.stgit@fedora-28>
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

The struct xfs_mount field m_fsname_len is not used anywhere, remove it.

Signed-off-by: Ian Kent <raven@themaw.net>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
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

