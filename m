Return-Path: <SRS0=ckLY=XT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2D15C432C2
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Sep 2019 13:22:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C07502064A
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Sep 2019 13:22:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730045AbfIXNW4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Sep 2019 09:22:56 -0400
Received: from icp-osb-irony-out7.external.iinet.net.au ([203.59.1.107]:5979
        "EHLO icp-osb-irony-out7.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727930AbfIXNW4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Sep 2019 09:22:56 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2AxAAA1GIpd/9+j0HYNWBwBAQEEAQE?=
 =?us-ascii?q?MBAEBgVUFAQELAYQ5hCKPWQEBAQEBAQaBEYoahR+EaoUkFIFnCQEBAQEBAQE?=
 =?us-ascii?q?BATcBAYQ6AwICg0Q2Bw4CDAEBAQQBAQEBAQUDAYVYhhkCAQMjBFIQGA0CJgI?=
 =?us-ascii?q?CRxAGE4UZrRNzfzMaijSBDCgBgWKKPniBB4FEgx2ELIMjglgEj1aGLEKWSII?=
 =?us-ascii?q?slSUMgiqLXQMQin8thAakfQGCCE0uCoMnUJBEZo0lAQE?=
X-IPAS-Result: =?us-ascii?q?A2AxAAA1GIpd/9+j0HYNWBwBAQEEAQEMBAEBgVUFAQELA?=
 =?us-ascii?q?YQ5hCKPWQEBAQEBAQaBEYoahR+EaoUkFIFnCQEBAQEBAQEBATcBAYQ6AwICg?=
 =?us-ascii?q?0Q2Bw4CDAEBAQQBAQEBAQUDAYVYhhkCAQMjBFIQGA0CJgICRxAGE4UZrRNzf?=
 =?us-ascii?q?zMaijSBDCgBgWKKPniBB4FEgx2ELIMjglgEj1aGLEKWSIIslSUMgiqLXQMQi?=
 =?us-ascii?q?n8thAakfQGCCE0uCoMnUJBEZo0lAQE?=
X-IronPort-AV: E=Sophos;i="5.64,544,1559491200"; 
   d="scan'208";a="205615148"
Received: from unknown (HELO [192.168.1.222]) ([118.208.163.223])
  by icp-osb-irony-out7.iinet.net.au with ESMTP; 24 Sep 2019 21:22:22 +0800
Subject: [REPOST PATCH v3 04/16] xfs: mount-api - refactor suffix_kstrtoint()
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Date:   Tue, 24 Sep 2019 21:22:21 +0800
Message-ID: <156933134131.20933.9564849082876972338.stgit@fedora-28>
In-Reply-To: <156933112949.20933.12761540130806431294.stgit@fedora-28>
References: <156933112949.20933.12761540130806431294.stgit@fedora-28>
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

After refactoring xfs_parseargs() and changing it to use
xfs_parse_param() match_kstrtoint() will no longer be used
and will be removed.

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/xfs/xfs_super.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 9c1ce3d70c08..6a16750b1314 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -160,13 +160,13 @@ static const struct fs_parameter_description xfs_fs_parameters = {
 };
 
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
 
@@ -191,6 +191,20 @@ suffix_kstrtoint(const substring_t *s, unsigned int base, int *res)
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
@@ -262,7 +276,7 @@ xfs_parseargs(
 				return -EINVAL;
 			break;
 		case Opt_logbsize:
-			if (suffix_kstrtoint(args, 10, &mp->m_logbsize))
+			if (match_kstrtoint(args, 10, &mp->m_logbsize))
 				return -EINVAL;
 			break;
 		case Opt_logdev:
@@ -278,7 +292,7 @@ xfs_parseargs(
 				return -ENOMEM;
 			break;
 		case Opt_allocsize:
-			if (suffix_kstrtoint(args, 10, &iosize))
+			if (match_kstrtoint(args, 10, &iosize))
 				return -EINVAL;
 			iosizelog = ffs(iosize) - 1;
 			break;

