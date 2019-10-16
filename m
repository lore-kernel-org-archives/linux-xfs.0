Return-Path: <SRS0=pjFm=YJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B055ECE59D
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 00:41:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29C902067B
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 00:41:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390296AbfJPAll (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Oct 2019 20:41:41 -0400
Received: from icp-osb-irony-out1.external.iinet.net.au ([203.59.1.210]:40471
        "EHLO icp-osb-irony-out1.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388246AbfJPAll (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Oct 2019 20:41:41 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2DmAQDRZqZd/0e30XYNWRwBAQEBAQc?=
 =?us-ascii?q?BAREBBAQBAYF7hDyEJY8zAQEBAQEBBoERih2FIAGMDgkBAQEBAQEBAQE3AQG?=
 =?us-ascii?q?EOwMCAoMSOBMCDAEBAQQBAQEBAQUDAYVYhhoCAQMjBFIQGA0CJgICRxAGE4V?=
 =?us-ascii?q?1rgd1fzMaiimBDCiBZYpBeIEHgREzgx2HUoJeBI0HL4IAN4VdYUOWXYIslTY?=
 =?us-ascii?q?Mgi6LaAMQiw0tqVCBek0uCoMnUJBGZ45/K4InAQE?=
X-IPAS-Result: =?us-ascii?q?A2DmAQDRZqZd/0e30XYNWRwBAQEBAQcBAREBBAQBAYF7h?=
 =?us-ascii?q?DyEJY8zAQEBAQEBBoERih2FIAGMDgkBAQEBAQEBAQE3AQGEOwMCAoMSOBMCD?=
 =?us-ascii?q?AEBAQQBAQEBAQUDAYVYhhoCAQMjBFIQGA0CJgICRxAGE4V1rgd1fzMaiimBD?=
 =?us-ascii?q?CiBZYpBeIEHgREzgx2HUoJeBI0HL4IAN4VdYUOWXYIslTYMgi6LaAMQiw0tq?=
 =?us-ascii?q?VCBek0uCoMnUJBGZ45/K4InAQE?=
X-IronPort-AV: E=Sophos;i="5.67,301,1566835200"; 
   d="scan'208";a="247444265"
Received: from unknown (HELO [192.168.1.222]) ([118.209.183.71])
  by icp-osb-irony-out1.iinet.net.au with ESMTP; 16 Oct 2019 08:41:38 +0800
Subject: [PATCH v6 10/12] xfs: move xfs_parseargs() validation to a helper
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Wed, 16 Oct 2019 08:41:38 +0800
Message-ID: <157118649791.9678.5158511909924114010.stgit@fedora-28>
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

Move the validation code of xfs_parseargs() into a helper for later
use within the mount context methods.

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/xfs/xfs_super.c |  136 +++++++++++++++++++++++++++++-----------------------
 1 file changed, 75 insertions(+), 61 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index cd17e4e6b922..f5ea96073d11 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -305,67 +305,16 @@ xfs_parse_param(
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
-STATIC int
-xfs_parseargs(
-	struct xfs_mount	*mp,
-	char			*options)
+static int
+xfs_validate_params(
+	struct xfs_mount        *mp,
+	int			dsunit,
+	int			dswidth,
+	uint8_t			iosizelog,
+	bool			nooptions)
 {
-	const struct super_block *sb = mp->m_super;
-	char			*p;
-	substring_t		args[MAX_OPT_ARGS];
-	int			dsunit = 0;
-	int			dswidth = 0;
-	uint8_t			iosizelog = 0;
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
-	 * Set some default flags that could be cleared by the mount option
-	 * parsing.
-	 */
-	mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
-
-	/*
-	 * These can be overridden by the mount option parsing.
-	 */
-	mp->m_logbufs = -1;
-	mp->m_logbsize = -1;
-
-	if (!options)
-		goto done;
-
-	while ((p = strsep(&options, ",")) != NULL) {
-		int		token;
-		int		ret;
-
-		if (!*p)
-			continue;
-
-		token = match_token(p, tokens, args);
-		ret = xfs_parse_param(token, p, args, mp,
-				      &dsunit, &dswidth, &iosizelog);
-		if (ret)
-			return ret;
-	}
+	if (nooptions)
+		goto noopts;
 
 	/*
 	 * no recovery flag requires a read-only mount
@@ -401,7 +350,7 @@ xfs_parseargs(
 		return -EINVAL;
 	}
 
-done:
+noopts:
 	if (dsunit && !(mp->m_flags & XFS_MOUNT_NOALIGN)) {
 		/*
 		 * At this point the superblock has not been read
@@ -449,6 +398,71 @@ xfs_parseargs(
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
+	int			dsunit = 0;
+	int			dswidth = 0;
+	uint8_t			iosizelog = 0;
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
+	 * Set some default flags that could be cleared by the mount option
+	 * parsing.
+	 */
+	mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
+
+	/*
+	 * These can be overridden by the mount option parsing.
+	 */
+	mp->m_logbufs = -1;
+	mp->m_logbsize = -1;
+
+	if (!options)
+		goto done;
+
+	while ((p = strsep(&options, ",")) != NULL) {
+		int		token;
+		int		ret;
+
+		if (!*p)
+			continue;
+
+		token = match_token(p, tokens, args);
+		ret = xfs_parse_param(token, p, args, mp,
+				      &dsunit, &dswidth, &iosizelog);
+		if (ret)
+			return ret;
+	}
+done:
+	return xfs_validate_params(mp, dsunit, dswidth, iosizelog, false);
+}
+
 struct proc_xfs_info {
 	uint64_t	flag;
 	char		*str;

