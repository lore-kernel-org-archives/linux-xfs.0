Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E0BAC433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 16:04:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381617AbiEEQIR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 12:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381612AbiEEQIQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 12:08:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DD275712C
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 09:04:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E674AB82C77
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 16:04:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E71C385AC;
        Thu,  5 May 2022 16:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651766674;
        bh=Ijy9qu8+sYyaO5KQj/F5JhVes6gpzkoeUPGs5LkZw/U=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DlRH4owiy9/Ex1SIQ/sl8rNoP+T7KhgHkDL/kchjNdH4t18Rx9EH3fkHpR0LZRYCE
         CD+XSHsxMSa/8VVaj1d2LwIPOnthTbNdo23lexsA+251TviIHrv7fY/TbH9L8q5EgH
         FzUhv9vNCiDLwA7GadtEXAPAlSJ/8d4tmIqC2jA+laAhdgezUAanMgYnQ3J5SJGyrV
         VUSHHuaqDU0NUb8+1u33iudYUdhOts+i0W8vtmGgbcLodWtajuH/bLKjHMt8iPDspo
         bBmGyQyR7KEtIwco7UF7WC+YUDxlay8DwnI24gtyfzkYYOsvdFOJvYZGnjqZw1hqU/
         GAq4M5dh67O1w==
Subject: [PATCH 1/2] xfs_db: support computing btheight for all cursor types
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 May 2022 09:04:34 -0700
Message-ID: <165176667420.247073.10421518802460549832.stgit@magnolia>
In-Reply-To: <165176666861.247073.17043246723787772129.stgit@magnolia>
References: <165176666861.247073.17043246723787772129.stgit@magnolia>
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

