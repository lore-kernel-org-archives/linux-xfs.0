Return-Path: <SRS0=9rhF=Y4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56D1ACA9EA0
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 10:55:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12499217F5
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 10:55:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728713AbfKDKzT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 05:55:19 -0500
Received: from icp-osb-irony-out4.external.iinet.net.au ([203.59.1.220]:34019
        "EHLO icp-osb-irony-out4.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727985AbfKDKzT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 05:55:19 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2CTAQC6AsBd/xK90HYNWRwBAQEBAQc?=
 =?us-ascii?q?BAREBBAQBAYF9hD2EKY9YAQEBAQEBBoERigmFMYRuhTyBZwkBAQEBAQEBAQE?=
 =?us-ascii?q?3AQGEOwMCAoQwOBMCDgEBAQQBAQEBAQUDAYVYhioCAQMjBFIQGA0CJgICRxA?=
 =?us-ascii?q?GE4V1sGJ1fzMaijOBDiiBZYpGeIEHgUSDHYQtgyiCXgSNQ4IAN4ZAQ5Z1gi6?=
 =?us-ascii?q?VUQyCMIt4AxCLHi2pfYF6TS4KgydQkX5njm0BAQ?=
X-IPAS-Result: =?us-ascii?q?A2CTAQC6AsBd/xK90HYNWRwBAQEBAQcBAREBBAQBAYF9h?=
 =?us-ascii?q?D2EKY9YAQEBAQEBBoERigmFMYRuhTyBZwkBAQEBAQEBAQE3AQGEOwMCAoQwO?=
 =?us-ascii?q?BMCDgEBAQQBAQEBAQUDAYVYhioCAQMjBFIQGA0CJgICRxAGE4V1sGJ1fzMai?=
 =?us-ascii?q?jOBDiiBZYpGeIEHgUSDHYQtgyiCXgSNQ4IAN4ZAQ5Z1gi6VUQyCMIt4AxCLH?=
 =?us-ascii?q?i2pfYF6TS4KgydQkX5njm0BAQ?=
X-IronPort-AV: E=Sophos;i="5.68,266,1569254400"; 
   d="scan'208";a="207138672"
Received: from unknown (HELO [192.168.1.222]) ([118.208.189.18])
  by icp-osb-irony-out4.iinet.net.au with ESMTP; 04 Nov 2019 18:55:18 +0800
Subject: [PATCH v9 08/17] xfs: refactor suffix_kstrtoint()
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Mon, 04 Nov 2019 18:55:18 +0800
Message-ID: <157286491808.18393.8705951673756927899.stgit@fedora-28>
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

The mount-api doesn't have a "human unit" parse type yet so the options
that have values like "10k" etc. still need to be converted by the fs.

But the value comes to the fs as a string (not a substring_t type) so
there's a need to change the conversion function to take a character
string instead.

When xfs is switched to use the new mount-api match_kstrtoint() will no
longer be used and will be removed.

Signed-off-by: Ian Kent <raven@themaw.net>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_super.c |   38 +++++++++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index bdf6c069e3ea..0dc072700599 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -108,14 +108,17 @@ static const match_table_t tokens = {
 };
 
 
-STATIC int
-suffix_kstrtoint(const substring_t *s, unsigned int base, int *res)
+static int
+suffix_kstrtoint(
+	const char	*s,
+	unsigned int	base,
+	int		*res)
 {
-	int	last, shift_left_factor = 0, _res;
-	char	*value;
-	int	ret = 0;
+	int		last, shift_left_factor = 0, _res;
+	char		*value;
+	int		ret = 0;
 
-	value = match_strdup(s);
+	value = kstrdup(s, GFP_KERNEL);
 	if (!value)
 		return -ENOMEM;
 
@@ -140,6 +143,23 @@ suffix_kstrtoint(const substring_t *s, unsigned int base, int *res)
 	return ret;
 }
 
+static int
+match_kstrtoint(
+	const substring_t	*s,
+	unsigned int		base,
+	int			*res)
+{
+	const char		*value;
+	int			ret;
+
+	value = match_strdup(s);
+	if (!value)
+		return -ENOMEM;
+	ret = suffix_kstrtoint(value, base, res);
+	kfree(value);
+	return ret;
+}
+
 /*
  * This function fills in xfs_mount_t fields based on mount args.
  * Note: the superblock has _not_ yet been read in.
@@ -151,7 +171,7 @@ suffix_kstrtoint(const substring_t *s, unsigned int base, int *res)
  * path, and we don't want this to have any side effects at remount time.
  * Today this function does not change *sb, but just to future-proof...
  */
-STATIC int
+static int
 xfs_parseargs(
 	struct xfs_mount	*mp,
 	char			*options)
@@ -194,7 +214,7 @@ xfs_parseargs(
 				return -EINVAL;
 			break;
 		case Opt_logbsize:
-			if (suffix_kstrtoint(args, 10, &mp->m_logbsize))
+			if (match_kstrtoint(args, 10, &mp->m_logbsize))
 				return -EINVAL;
 			break;
 		case Opt_logdev:
@@ -210,7 +230,7 @@ xfs_parseargs(
 				return -ENOMEM;
 			break;
 		case Opt_allocsize:
-			if (suffix_kstrtoint(args, 10, &size))
+			if (match_kstrtoint(args, 10, &size))
 				return -EINVAL;
 			mp->m_allocsize_log = ffs(size) - 1;
 			mp->m_flags |= XFS_MOUNT_ALLOCSIZE;

