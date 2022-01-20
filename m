Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 404A2C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:26:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345413AbiATA0Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:26:16 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48470 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344774AbiATA0Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:26:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A6DCB81A7D
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:26:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 230E1C004E1;
        Thu, 20 Jan 2022 00:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638374;
        bh=Ijy9qu8+sYyaO5KQj/F5JhVes6gpzkoeUPGs5LkZw/U=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XTq1Np8dEQJbL/zH4jEK+lH+8Mqm2uZc0iX/UQih1ZDPshccgRnqaSYduwwrIPS17
         kOemM5RpQ0+5NVS+Rmbuh8sGWfbtGrZRFtGVxOF3kPDjOZYTRUifPJ3s+AZitDcNDA
         gkv5E53ShWG/UUM7va3gDDNWIgQMG3FsPlNRuJ9IQGpLMBh8WZu4rMOsNGd887DVdn
         eUuXZuS0I9HUHw02DBF+MoK73VcPSO80d9MH0jqXHAOq3cYALc6duikRxVrWhlfGO7
         2WHrsOmr4XBd2sWJni/HzVpsDFkO/W3X3kJaTaI8Ce7aS8+r6QqKWAuoc6O88jGDRc
         OkDoW2MKpbcqg==
Subject: [PATCH 33/48] xfs_db: support computing btheight for all cursor types
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:26:13 -0800
Message-ID: <164263837382.865554.13379551225158713817.stgit@magnolia>
In-Reply-To: <164263819185.865554.6000499997543946756.stgit@magnolia>
References: <164263819185.865554.6000499997543946756.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add the special magic btree type value 'all' to the btheight command so
that we can display information about all known btree types at once.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/btheight.c     |   26 +++++++++++++++++++++++---
 man/man8/xfs_db.8 |    3 +++
 2 files changed, 26 insertions(+), 3 deletions(-)


diff --git a/db/btheight.c b/db/btheight.c
index 8aa17c89..e4cd4eda 100644
--- a/db/btheight.c
+++ b/db/btheight.c
@@ -57,7 +57,7 @@ btheight_help(void)
 "   -w min -- Show only the worst case scenario.\n"
 "\n"
 " Supported btree types:\n"
-"   "
+"   all "
 ));
 	for (i = 0, m = maps; i < ARRAY_SIZE(maps); i++, m++)
 		printf("%s ", m->tag);
@@ -107,7 +107,7 @@ calc_height(
 
 static int
 construct_records_per_block(
-	char		*tag,
+	const char	*tag,
 	int		blocksize,
 	unsigned int	*records_per_block)
 {
@@ -235,7 +235,7 @@ _("%s: pointer size must be less than selected block size (%u bytes).\n"),
 
 static void
 report(
-	char			*tag,
+	const char		*tag,
 	unsigned int		report_what,
 	unsigned long long	nr_records,
 	unsigned int		blocksize)
@@ -297,6 +297,19 @@ _("%s: worst case per %u-byte block: %u records (leaf) / %u keyptrs (node)\n"),
 	}
 }
 
+static void
+report_all(
+	unsigned int		report_what,
+	unsigned long long	nr_records,
+	unsigned int		blocksize)
+{
+	struct btmap		*m;
+	int			i;
+
+	for (i = 0, m = maps; i < ARRAY_SIZE(maps); i++, m++)
+		report(m->tag, report_what, nr_records, blocksize);
+}
+
 static int
 btheight_f(
 	int		argc,
@@ -366,6 +379,13 @@ _("The smallest block size this command will consider is 128 bytes.\n"));
 		return 0;
 	}
 
+	for (i = optind; i < argc; i++) {
+		if (!strcmp(argv[i], "all")) {
+			report_all(report_what, nr_records, blocksize);
+			return 0;
+		}
+	}
+
 	for (i = optind; i < argc; i++)
 		report(argv[i], report_what, nr_records, blocksize);
 
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 58727495..55ac3487 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -420,6 +420,9 @@ The supported btree types are:
 .IR refcountbt ,
 and
 .IR rmapbt .
+The magic value
+.I all
+can be used to walk through all btree types.
 
 Options are as follows:
 .RS 1.0i

