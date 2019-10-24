Return-Path: <SRS0=feM8=YR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E735ECA9EAF
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 07:51:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3CED21872
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 07:51:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408745AbfJXHvf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Oct 2019 03:51:35 -0400
Received: from icp-osb-irony-out1.external.iinet.net.au ([203.59.1.210]:26989
        "EHLO icp-osb-irony-out1.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2408743AbfJXHvf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Oct 2019 03:51:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2BeAADRVrFd/0e30XYNWBwBAQEBAQc?=
 =?us-ascii?q?BAREBBAQBAYFqBAEBCwEBhDqEKI9JBoszhSABhGuFPIFnCQEBAQEBAQEBATc?=
 =?us-ascii?q?BAYQ7AwICg1k3Bg4CDAEBAQQBAQEBAQUDAYVYgRoBDAGFAQIBAyMEUhAYDQI?=
 =?us-ascii?q?mAgJHEAYThXWxdHV/MxqKMIEOKAGBZIpCeIEHhGGELYMogl4EjT2CADeGQEO?=
 =?us-ascii?q?WbIIulUUMgi+LcAMQixQtqWiBe00uCoMnUJF9Z4pWhVgBAQ?=
X-IPAS-Result: =?us-ascii?q?A2BeAADRVrFd/0e30XYNWBwBAQEBAQcBAREBBAQBAYFqB?=
 =?us-ascii?q?AEBCwEBhDqEKI9JBoszhSABhGuFPIFnCQEBAQEBAQEBATcBAYQ7AwICg1k3B?=
 =?us-ascii?q?g4CDAEBAQQBAQEBAQUDAYVYgRoBDAGFAQIBAyMEUhAYDQImAgJHEAYThXWxd?=
 =?us-ascii?q?HV/MxqKMIEOKAGBZIpCeIEHhGGELYMogl4EjT2CADeGQEOWbIIulUUMgi+Lc?=
 =?us-ascii?q?AMQixQtqWiBe00uCoMnUJF9Z4pWhVgBAQ?=
X-IronPort-AV: E=Sophos;i="5.68,224,1569254400"; 
   d="scan'208";a="250044022"
Received: from unknown (HELO [192.168.1.222]) ([118.209.183.71])
  by icp-osb-irony-out1.iinet.net.au with ESMTP; 24 Oct 2019 15:51:32 +0800
Subject: [PATCH v7 11/17] xfs: refactor suffix_kstrtoint()
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Thu, 24 Oct 2019 15:51:32 +0800
Message-ID: <157190349282.27074.327122390885823342.stgit@fedora-28>
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

The mount-api doesn't have a "human unit" parse type yet so the options
that have values like "10k" etc. still need to be converted by the fs.

But the value comes to the fs as a string (not a substring_t type) so
there's a need to change the conversion function to take a character
string instead.

When xfs is switched to use the new mount-api match_kstrtoint() will no
longer be used and will be removed.

Signed-off-by: Ian Kent <raven@themaw.net>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_super.c |   38 +++++++++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 97c3f1edb69c..003ec725d4b6 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -112,14 +112,17 @@ static const match_table_t tokens = {
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
 
@@ -144,6 +147,23 @@ suffix_kstrtoint(const substring_t *s, unsigned int base, int *res)
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
@@ -155,7 +175,7 @@ suffix_kstrtoint(const substring_t *s, unsigned int base, int *res)
  * path, and we don't want this to have any side effects at remount time.
  * Today this function does not change *sb, but just to future-proof...
  */
-STATIC int
+static int
 xfs_parseargs(
 	struct xfs_mount	*mp,
 	char			*options)
@@ -206,7 +226,7 @@ xfs_parseargs(
 				return -EINVAL;
 			break;
 		case Opt_logbsize:
-			if (suffix_kstrtoint(args, 10, &mp->m_logbsize))
+			if (match_kstrtoint(args, 10, &mp->m_logbsize))
 				return -EINVAL;
 			break;
 		case Opt_logdev:
@@ -222,7 +242,7 @@ xfs_parseargs(
 				return -ENOMEM;
 			break;
 		case Opt_allocsize:
-			if (suffix_kstrtoint(args, 10, &iosize))
+			if (match_kstrtoint(args, 10, &iosize))
 				return -EINVAL;
 			iosizelog = ffs(iosize) - 1;
 			break;

