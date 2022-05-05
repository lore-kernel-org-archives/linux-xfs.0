Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FF07C433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 16:04:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381642AbiEEQIZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 12:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233041AbiEEQIV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 12:08:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 466C15C34A
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 09:04:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C850B61D76
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 16:04:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31A3DC385A4;
        Thu,  5 May 2022 16:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651766680;
        bh=WKg+OJ6VaxC8dya7SXRJuCmKutAMqKBcL0n1Dc3zb3I=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=NKmYI2BCLRJ0K7vSFZiBLozfPbDP4hkll7FiypS5oO7SULmKJolZJkF2s+8U/7hw0
         4xmAP635xq+iv/0tbf4vJJ49BC+uCBX0O1dogQJdVYKznqn/7f7ESx8HxQhbAvG02Q
         3URUGIMXgareZ0MWK1bD1qCFTmOlZ/GtA4aOYCfwrPi3TsA8jTT1UBM2UViH2qAe0F
         cDM8nRtdj4aQbT+M9wGzb1rVmg5piHhzQkvJxZQwbI48gCTbFrOOf/+abPfMLP0f70
         5yUiewRgmlQYvuIgwScWaSL597yf8h4IeDNLvSOialanQaWyDuz++BKrAsH7sVeafN
         qbKpLXvkWiU/g==
Subject: [PATCH 2/2] xfs_db: report absolute maxlevels for each btree type
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 May 2022 09:04:39 -0700
Message-ID: <165176667978.247073.1336353301538627043.stgit@magnolia>
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

Augment the xfs_db btheight command so that the debugger can display the
absolute maximum btree height for each btree type.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/btheight.c            |   73 ++++++++++++++++++++++++++++++++++++++++------
 libxfs/libxfs_api_defs.h |    5 +++
 man/man8/xfs_db.8        |    5 +++
 3 files changed, 72 insertions(+), 11 deletions(-)


diff --git a/db/btheight.c b/db/btheight.c
index e4cd4eda..0b421ab5 100644
--- a/db/btheight.c
+++ b/db/btheight.c
@@ -24,16 +24,45 @@ static int rmap_maxrecs(struct xfs_mount *mp, int blocklen, int leaf)
 
 struct btmap {
 	const char	*tag;
+	unsigned int	(*maxlevels)(void);
 	int		(*maxrecs)(struct xfs_mount *mp, int blocklen,
 				   int leaf);
 } maps[] = {
-	{"bnobt", libxfs_allocbt_maxrecs},
-	{"cntbt", libxfs_allocbt_maxrecs},
-	{"inobt", libxfs_inobt_maxrecs},
-	{"finobt", libxfs_inobt_maxrecs},
-	{"bmapbt", libxfs_bmbt_maxrecs},
-	{"refcountbt", refc_maxrecs},
-	{"rmapbt", rmap_maxrecs},
+	{
+		.tag		= "bnobt",
+		.maxlevels	= libxfs_allocbt_maxlevels_ondisk,
+		.maxrecs	= libxfs_allocbt_maxrecs,
+	},
+	{
+		.tag		= "cntbt",
+		.maxlevels	= libxfs_allocbt_maxlevels_ondisk,
+		.maxrecs	= libxfs_allocbt_maxrecs,
+	},
+	{
+		.tag		= "inobt",
+		.maxlevels	= libxfs_iallocbt_maxlevels_ondisk,
+		.maxrecs	= libxfs_inobt_maxrecs,
+	},
+	{
+		.tag		= "finobt",
+		.maxlevels	= libxfs_iallocbt_maxlevels_ondisk,
+		.maxrecs	= libxfs_inobt_maxrecs,
+	},
+	{
+		.tag		= "bmapbt",
+		.maxlevels	= libxfs_bmbt_maxlevels_ondisk,
+		.maxrecs	= libxfs_bmbt_maxrecs,
+	},
+	{
+		.tag		= "refcountbt",
+		.maxlevels	= libxfs_refcountbt_maxlevels_ondisk,
+		.maxrecs	= refc_maxrecs,
+	},
+	{
+		.tag		= "rmapbt",
+		.maxlevels	= libxfs_rmapbt_maxlevels_ondisk,
+		.maxrecs	= rmap_maxrecs,
+	},
 };
 
 static void
@@ -55,6 +84,7 @@ btheight_help(void)
 "   -n -- Number of records we want to store.\n"
 "   -w max -- Show only the best case scenario.\n"
 "   -w min -- Show only the worst case scenario.\n"
+"   -w absmax -- Print the maximum possible btree height for all filesystems.\n"
 "\n"
 " Supported btree types:\n"
 "   all "
@@ -232,6 +262,22 @@ _("%s: pointer size must be less than selected block size (%u bytes).\n"),
 #define REPORT_DEFAULT	(-1U)
 #define REPORT_MAX	(1 << 0)
 #define REPORT_MIN	(1 << 1)
+#define REPORT_ABSMAX	(1 << 2)
+
+static void
+report_absmax(const char *tag)
+{
+	struct btmap	*m;
+	int		i;
+
+	for (i = 0, m = maps; i < ARRAY_SIZE(maps); i++, m++) {
+		if (!strcmp(m->tag, tag)) {
+			printf("%s: %u\n", tag, m->maxlevels());
+			return;
+		}
+	}
+	printf(_("%s: Don't know how to report max height.\n"), tag);
+}
 
 static void
 report(
@@ -243,6 +289,11 @@ report(
 	unsigned int		records_per_block[2];
 	int			ret;
 
+	if (report_what == REPORT_ABSMAX) {
+		report_absmax(tag);
+		return;
+	}
+
 	ret = construct_records_per_block(tag, blocksize, records_per_block);
 	if (ret)
 		return;
@@ -344,6 +395,8 @@ btheight_f(
 				report_what = REPORT_MIN;
 			else if (!strcmp(optarg, "max"))
 				report_what = REPORT_MAX;
+			else if (!strcmp(optarg, "absmax"))
+				report_what = REPORT_ABSMAX;
 			else {
 				btheight_help();
 				return 0;
@@ -355,20 +408,20 @@ btheight_f(
 		}
 	}
 
-	if (nr_records == 0) {
+	if (report_what != REPORT_ABSMAX && nr_records == 0) {
 		fprintf(stderr,
 _("Number of records must be greater than zero.\n"));
 		return 0;
 	}
 
-	if (blocksize > INT_MAX) {
+	if (report_what != REPORT_ABSMAX && blocksize > INT_MAX) {
 		fprintf(stderr,
 _("The largest block size this command will consider is %u bytes.\n"),
 			INT_MAX);
 		return 0;
 	}
 
-	if (blocksize < 128) {
+	if (report_what != REPORT_ABSMAX && blocksize < 128) {
 		fprintf(stderr,
 _("The smallest block size this command will consider is 128 bytes.\n"));
 		return 0;
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 0862d4b0..8abbd231 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -23,6 +23,7 @@
 #define xfs_ag_block_count		libxfs_ag_block_count
 
 #define xfs_alloc_ag_max_usable		libxfs_alloc_ag_max_usable
+#define xfs_allocbt_maxlevels_ondisk	libxfs_allocbt_maxlevels_ondisk
 #define xfs_allocbt_maxrecs		libxfs_allocbt_maxrecs
 #define xfs_allocbt_stage_cursor	libxfs_allocbt_stage_cursor
 #define xfs_alloc_fix_freelist		libxfs_alloc_fix_freelist
@@ -39,6 +40,7 @@
 #define xfs_bmapi_read			libxfs_bmapi_read
 #define xfs_bmapi_write			libxfs_bmapi_write
 #define xfs_bmap_last_offset		libxfs_bmap_last_offset
+#define xfs_bmbt_maxlevels_ondisk	libxfs_bmbt_maxlevels_ondisk
 #define xfs_bmbt_maxrecs		libxfs_bmbt_maxrecs
 #define xfs_bmdr_maxrecs		libxfs_bmdr_maxrecs
 
@@ -109,6 +111,7 @@
 #define xfs_highbit32			libxfs_highbit32
 #define xfs_highbit64			libxfs_highbit64
 #define xfs_ialloc_calc_rootino		libxfs_ialloc_calc_rootino
+#define xfs_iallocbt_maxlevels_ondisk	libxfs_iallocbt_maxlevels_ondisk
 #define xfs_idata_realloc		libxfs_idata_realloc
 #define xfs_idestroy_fork		libxfs_idestroy_fork
 #define xfs_iext_lookup_extent		libxfs_iext_lookup_extent
@@ -138,6 +141,7 @@
 #define xfs_refc_block			libxfs_refc_block
 #define xfs_refcountbt_calc_reserves	libxfs_refcountbt_calc_reserves
 #define xfs_refcountbt_init_cursor	libxfs_refcountbt_init_cursor
+#define xfs_refcountbt_maxlevels_ondisk	libxfs_refcountbt_maxlevels_ondisk
 #define xfs_refcountbt_maxrecs		libxfs_refcountbt_maxrecs
 #define xfs_refcountbt_stage_cursor	libxfs_refcountbt_stage_cursor
 #define xfs_refcount_get_rec		libxfs_refcount_get_rec
@@ -146,6 +150,7 @@
 #define xfs_rmap_alloc			libxfs_rmap_alloc
 #define xfs_rmapbt_calc_reserves	libxfs_rmapbt_calc_reserves
 #define xfs_rmapbt_init_cursor		libxfs_rmapbt_init_cursor
+#define xfs_rmapbt_maxlevels_ondisk	libxfs_rmapbt_maxlevels_ondisk
 #define xfs_rmapbt_maxrecs		libxfs_rmapbt_maxrecs
 #define xfs_rmapbt_stage_cursor		libxfs_rmapbt_stage_cursor
 #define xfs_rmap_compare		libxfs_rmap_compare
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 55ac3487..1a2bb7e9 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -402,7 +402,7 @@ If the cursor points at an inode, dump the extended attribute block mapping btre
 Dump all keys and pointers in intermediate btree nodes, and all records in leaf btree nodes.
 .RE
 .TP
-.BI "btheight [\-b " blksz "] [\-n " recs "] [\-w " max "|\-w " min "] btree types..."
+.BI "btheight [\-b " blksz "] [\-n " recs "] [\-w " max "|" min "|" absmax "] btree types..."
 For a given number of btree records and a btree type, report the number of
 records and blocks for each level of the btree, and the total number of blocks.
 The btree type must be given after the options.
@@ -435,6 +435,9 @@ The default is the filesystem block size.
 is used to specify the number of records to store.
 This argument is required.
 .TP
+.B \-w absmax
+shows the maximum possible height for the given btree types.
+.TP
 .B \-w max
 shows only the best case scenario, which is when the btree blocks are
 maximally loaded.

