Return-Path: <SRS0=y7rh=X4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82A15C10F14
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Oct 2019 10:25:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62578218DE
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Oct 2019 10:25:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729065AbfJCKZs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Oct 2019 06:25:48 -0400
Received: from icp-osb-irony-out7.external.iinet.net.au ([203.59.1.107]:42874
        "EHLO icp-osb-irony-out7.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726039AbfJCKZr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Oct 2019 06:25:47 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2AVAADHy5Vd/7q70HYNWRwBAQEEAQE?=
 =?us-ascii?q?MBAEBgVMHAQELAYQ5hCKIIocIAwaBEYoaigmFKBSBZwkBAQEBAQEBAQE3AQG?=
 =?us-ascii?q?EOwMCAoJoNAkOAgwBAQEEAQEBAQEFAwGFWIYaAgEDIwRSEBgNAiYCAkcQBhO?=
 =?us-ascii?q?FGa4MdX8zGoongQwoAYFkikF4gQeBRIMdhCyDJYJYBI8wN4Y5Q5ZUgi2VMwy?=
 =?us-ascii?q?CLYtmAxCLDC2ECqUdghFNLgqDJ1CQRmeRGwEB?=
X-IPAS-Result: =?us-ascii?q?A2AVAADHy5Vd/7q70HYNWRwBAQEEAQEMBAEBgVMHAQELA?=
 =?us-ascii?q?YQ5hCKIIocIAwaBEYoaigmFKBSBZwkBAQEBAQEBAQE3AQGEOwMCAoJoNAkOA?=
 =?us-ascii?q?gwBAQEEAQEBAQEFAwGFWIYaAgEDIwRSEBgNAiYCAkcQBhOFGa4MdX8zGoong?=
 =?us-ascii?q?QwoAYFkikF4gQeBRIMdhCyDJYJYBI8wN4Y5Q5ZUgi2VMwyCLYtmAxCLDC2EC?=
 =?us-ascii?q?qUdghFNLgqDJ1CQRmeRGwEB?=
X-IronPort-AV: E=Sophos;i="5.67,251,1566835200"; 
   d="scan'208";a="207652728"
Received: from unknown (HELO [192.168.1.222]) ([118.208.187.186])
  by icp-osb-irony-out7.iinet.net.au with ESMTP; 03 Oct 2019 18:25:45 +0800
Subject: [PATCH v4 05/17] xfs: mount-api - refactor suffix_kstrtoint()
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Thu, 03 Oct 2019 18:25:45 +0800
Message-ID: <157009834551.13858.14742362473505930539.stgit@fedora-28>
In-Reply-To: <157009817203.13858.7783767645177567968.stgit@fedora-28>
References: <157009817203.13858.7783767645177567968.stgit@fedora-28>
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
Reviewed-by: Brian Foster <bfoster@redhat.com>
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

