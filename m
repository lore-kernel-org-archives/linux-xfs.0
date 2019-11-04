Return-Path: <SRS0=9rhF=Y4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF8B5CA9EA0
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 10:55:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE024217F5
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 10:55:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728310AbfKDKzg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 05:55:36 -0500
Received: from icp-osb-irony-out4.external.iinet.net.au ([203.59.1.220]:34019
        "EHLO icp-osb-irony-out4.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727771AbfKDKzg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 05:55:36 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2AfAAC6AsBd/xK90HYNWRsBAQEBAQE?=
 =?us-ascii?q?BBQEBAREBAQMDAQEBgWwDAQEBCwGEPIQpj1gBAQEBAQEGgRGKCYUxjBEJAQE?=
 =?us-ascii?q?BAQEBAQEBNwEBhDsDAgKEMDcGDgIOAQEBBAEBAQEBBQMBhViGKgIBAyMEUhA?=
 =?us-ascii?q?YDQImAgJHEAYThXWwYnV/MxqKM4EOKAGBZIpGeIEHgREzgx2HVYJeBI0UL4I?=
 =?us-ascii?q?AN4VfYUOWdYIulVEMgjCLeAMQix4tqXyBe00uCoMnUJF+Z4wwK4ISAQE?=
X-IPAS-Result: =?us-ascii?q?A2AfAAC6AsBd/xK90HYNWRsBAQEBAQEBBQEBAREBAQMDA?=
 =?us-ascii?q?QEBgWwDAQEBCwGEPIQpj1gBAQEBAQEGgRGKCYUxjBEJAQEBAQEBAQEBNwEBh?=
 =?us-ascii?q?DsDAgKEMDcGDgIOAQEBBAEBAQEBBQMBhViGKgIBAyMEUhAYDQImAgJHEAYTh?=
 =?us-ascii?q?XWwYnV/MxqKM4EOKAGBZIpGeIEHgREzgx2HVYJeBI0UL4IAN4VfYUOWdYIul?=
 =?us-ascii?q?VEMgjCLeAMQix4tqXyBe00uCoMnUJF+Z4wwK4ISAQE?=
X-IronPort-AV: E=Sophos;i="5.68,266,1569254400"; 
   d="scan'208";a="207138685"
Received: from unknown (HELO [192.168.1.222]) ([118.208.189.18])
  by icp-osb-irony-out4.iinet.net.au with ESMTP; 04 Nov 2019 18:55:33 +0800
Subject: [PATCH v9 11/17] xfs: move xfs_parseargs() validation to a helper
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Mon, 04 Nov 2019 18:55:33 +0800
Message-ID: <157286493371.18393.14942381362906162909.stgit@fedora-28>
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

Move the validation code of xfs_parseargs() into a helper for later
use within the mount context methods.

Signed-off-by: Ian Kent <raven@themaw.net>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_super.c |  109 ++++++++++++++++++++++++++++------------------------
 1 file changed, 58 insertions(+), 51 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 391c07ca6a32..4b570ba3456a 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -308,59 +308,10 @@ xfs_fc_parse_param(
 	return 0;
 }
 
-/*
- * This function fills in xfs_mount_t fields based on mount args.
- * Note: the superblock has _not_ yet been read in.
- *
- * Note that this function leaks the various device name allocations on
- * failure.  The caller takes care of them.
- *
- * *sb is const because this is also used to test options on the remount
- * path, and we don't want this to have any side effects at remount time.
- * Today this function does not change *sb, but just to future-proof...
- */
 static int
-xfs_parseargs(
-	struct xfs_mount	*mp,
-	char			*options)
+xfs_fc_validate_params(
+	struct xfs_mount	*mp)
 {
-	const struct super_block *sb = mp->m_super;
-	char			*p;
-	substring_t		args[MAX_OPT_ARGS];
-
-	/*
-	 * Copy binary VFS mount flags we are interested in.
-	 */
-	if (sb_rdonly(sb))
-		mp->m_flags |= XFS_MOUNT_RDONLY;
-	if (sb->s_flags & SB_DIRSYNC)
-		mp->m_flags |= XFS_MOUNT_DIRSYNC;
-	if (sb->s_flags & SB_SYNCHRONOUS)
-		mp->m_flags |= XFS_MOUNT_WSYNC;
-
-	/*
-	 * These can be overridden by the mount option parsing.
-	 */
-	mp->m_logbufs = -1;
-	mp->m_logbsize = -1;
-	mp->m_allocsize_log = 16; /* 64k */
-
-	if (!options)
-		return 0;
-
-	while ((p = strsep(&options, ",")) != NULL) {
-		int		token;
-		int		ret;
-
-		if (!*p)
-			continue;
-
-		token = match_token(p, tokens, args);
-		ret = xfs_fc_parse_param(token, p, args, mp);
-		if (ret)
-			return ret;
-	}
-
 	/*
 	 * no recovery flag requires a read-only mount
 	 */
@@ -425,6 +376,62 @@ xfs_parseargs(
 	return 0;
 }
 
+/*
+ * This function fills in xfs_mount_t fields based on mount args.
+ * Note: the superblock has _not_ yet been read in.
+ *
+ * Note that this function leaks the various device name allocations on
+ * failure.  The caller takes care of them.
+ *
+ * *sb is const because this is also used to test options on the remount
+ * path, and we don't want this to have any side effects at remount time.
+ * Today this function does not change *sb, but just to future-proof...
+ */
+static int
+xfs_parseargs(
+	struct xfs_mount	*mp,
+	char			*options)
+{
+	const struct super_block *sb = mp->m_super;
+	char			*p;
+	substring_t		args[MAX_OPT_ARGS];
+
+	/*
+	 * Copy binary VFS mount flags we are interested in.
+	 */
+	if (sb_rdonly(sb))
+		mp->m_flags |= XFS_MOUNT_RDONLY;
+	if (sb->s_flags & SB_DIRSYNC)
+		mp->m_flags |= XFS_MOUNT_DIRSYNC;
+	if (sb->s_flags & SB_SYNCHRONOUS)
+		mp->m_flags |= XFS_MOUNT_WSYNC;
+
+	/*
+	 * These can be overridden by the mount option parsing.
+	 */
+	mp->m_logbufs = -1;
+	mp->m_logbsize = -1;
+	mp->m_allocsize_log = 16; /* 64k */
+
+	if (!options)
+		return 0;
+
+	while ((p = strsep(&options, ",")) != NULL) {
+		int		token;
+		int		ret;
+
+		if (!*p)
+			continue;
+
+		token = match_token(p, tokens, args);
+		ret = xfs_fc_parse_param(token, p, args, mp);
+		if (ret)
+			return ret;
+	}
+
+	return xfs_fc_validate_params(mp);
+}
+
 struct proc_xfs_info {
 	uint64_t	flag;
 	char		*str;

