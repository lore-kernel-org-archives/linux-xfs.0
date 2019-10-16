Return-Path: <SRS0=pjFm=YJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3A5AECE59D
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 00:41:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3DA62067B
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 00:41:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390284AbfJPAlb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Oct 2019 20:41:31 -0400
Received: from icp-osb-irony-out1.external.iinet.net.au ([203.59.1.210]:40390
        "EHLO icp-osb-irony-out1.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388246AbfJPAlb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Oct 2019 20:41:31 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2DmAQDRZqZd/0e30XYNWRwBAQEBAQc?=
 =?us-ascii?q?BAREBBAQBAYF7hDyEJY8zAQEBAQEBBoERih2FIAGEa4U8gWcJAQEBAQEBAQE?=
 =?us-ascii?q?BNwEBhDsDAgKDEjgTAgwBAQEEAQEBAQEFAwGFWIYaAgEDIwRSEBgNAiYCAkc?=
 =?us-ascii?q?QBhOFda4HdX8zGoopgQwogWWKQXiBB4FEgx2ELIMmgl4EjzY3hj5Dll2CLJU?=
 =?us-ascii?q?2DIIui2gDEIsNLalQgXpNLgqDJ1CQRmeRUQEB?=
X-IPAS-Result: =?us-ascii?q?A2DmAQDRZqZd/0e30XYNWRwBAQEBAQcBAREBBAQBAYF7h?=
 =?us-ascii?q?DyEJY8zAQEBAQEBBoERih2FIAGEa4U8gWcJAQEBAQEBAQEBNwEBhDsDAgKDE?=
 =?us-ascii?q?jgTAgwBAQEEAQEBAQEFAwGFWIYaAgEDIwRSEBgNAiYCAkcQBhOFda4HdX8zG?=
 =?us-ascii?q?oopgQwogWWKQXiBB4FEgx2ELIMmgl4EjzY3hj5Dll2CLJU2DIIui2gDEIsNL?=
 =?us-ascii?q?alQgXpNLgqDJ1CQRmeRUQEB?=
X-IronPort-AV: E=Sophos;i="5.67,301,1566835200"; 
   d="scan'208";a="247444241"
Received: from unknown (HELO [192.168.1.222]) ([118.209.183.71])
  by icp-osb-irony-out1.iinet.net.au with ESMTP; 16 Oct 2019 08:41:27 +0800
Subject: [PATCH v6 08/12] xfs: refactor suffix_kstrtoint()
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Wed, 16 Oct 2019 08:41:27 +0800
Message-ID: <157118648744.9678.4128365130843690618.stgit@fedora-28>
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

The mount-api doesn't have a "human unit" parse type yet so
the options that have values like "10k" etc. still need to
be converted by the fs.

But the value comes to the fs as a string (not a substring_t
type) so there's a need to change the conversion function to
take a character string instead.

When xfs is switched to use the new mount-api match_kstrtoint()
will no longer be used and will be removed.

Signed-off-by: Ian Kent <raven@themaw.net>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_super.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 1f706cbf9624..e54348be2a17 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -110,13 +110,13 @@ static const match_table_t tokens = {
 
 
 STATIC int
-suffix_kstrtoint(const substring_t *s, unsigned int base, int *res)
+suffix_kstrtoint(const char *s, unsigned int base, int *res)
 {
 	int	last, shift_left_factor = 0, _res;
 	char	*value;
 	int	ret = 0;
 
-	value = match_strdup(s);
+	value = kstrdup(s, GFP_KERNEL);
 	if (!value)
 		return -ENOMEM;
 
@@ -141,6 +141,20 @@ suffix_kstrtoint(const substring_t *s, unsigned int base, int *res)
 	return ret;
 }
 
+STATIC int
+match_kstrtoint(const substring_t *s, unsigned int base, int *res)
+{
+	const char	*value;
+	int ret;
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
@@ -203,7 +217,7 @@ xfs_parseargs(
 				return -EINVAL;
 			break;
 		case Opt_logbsize:
-			if (suffix_kstrtoint(args, 10, &mp->m_logbsize))
+			if (match_kstrtoint(args, 10, &mp->m_logbsize))
 				return -EINVAL;
 			break;
 		case Opt_logdev:
@@ -219,7 +233,7 @@ xfs_parseargs(
 				return -ENOMEM;
 			break;
 		case Opt_allocsize:
-			if (suffix_kstrtoint(args, 10, &iosize))
+			if (match_kstrtoint(args, 10, &iosize))
 				return -EINVAL;
 			iosizelog = ffs(iosize) - 1;
 			break;

