Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1F32C00140
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jul 2022 19:57:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbiGZT5s (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jul 2022 15:57:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231818AbiGZT5r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jul 2022 15:57:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AEE6357F0
        for <linux-xfs@vger.kernel.org>; Tue, 26 Jul 2022 12:57:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0663CB8091B
        for <linux-xfs@vger.kernel.org>; Tue, 26 Jul 2022 19:57:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6396C433C1;
        Tue, 26 Jul 2022 19:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658865463;
        bh=QzpxI9Fkzu7qBzmW5huLzttkYUB3ehT4Jy6xnboZwy0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=iR3IKQN9agzV6UB14O68CKpqg2O0QWd4HRirCuNO7knfMxdPRRe3XMGoPfxAiDodu
         W+i6LkRPR+/yX5wj6U0Qbx4cpVJaPWCWXWZemKVkx7CqLStZsf+eRYOKCae0GTmZ3t
         N5OaSrhy4ExrXel8kAuxhKKnm4vyHBim+m8Dgz+Gj0jA9Hto4nwcy3DFg5Oeg8ZRfp
         BDXa8LTEhnSelm+UpVIIqdLR0wZUBq08yVqpIrWSmo8LoXsgH/p8it5CFck1gdSfhl
         P4eryRVSGYDY60VSu0S8LwP+JUXn9P+qcUSvud0qko1Rx+HA0CYWAtQiknUiau6djp
         Q2//d4UtTDZaw==
Subject: [PATCH 2/2] mkfs: stop allowing tiny filesystems
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org
Date:   Tue, 26 Jul 2022 12:57:43 -0700
Message-ID: <165886546327.1604534.12013161880363320742.stgit@magnolia>
In-Reply-To: <165886545204.1604534.17138015950772754915.stgit@magnolia>
References: <165886545204.1604534.17138015950772754915.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Refuse to format a filesystem that are "too small", because these
configurations are known to have performance and redundancy problems
that are not present on the volume sizes that XFS is best at handling.

Specifically, this means that we won't allow logs smaller than 64MB, we
won't allow single-AG filesystems, and we won't allow volumes smaller
than 300MB.  There are two exceptions: the first is an undocumented CLI
option that can be used for crafting debug filesystems.

The second exception is that if fstests is detected, because there are a
lot of fstests that use tiny filesystems to perform targeted regression
and functional testing in a controlled environment.  Fixing the ~40 or
so tests to run more slowly with larger filesystems isn't worth the risk
of breaking the tests.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 man/man8/mkfs.xfs.8.in |   13 +++++---
 mkfs/xfs_mkfs.c        |   82 +++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 90 insertions(+), 5 deletions(-)


diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
index b961bc30..211e7b0c 100644
--- a/man/man8/mkfs.xfs.8.in
+++ b/man/man8/mkfs.xfs.8.in
@@ -67,11 +67,11 @@ SCSI disk, use:
 .PP
 The metadata log can be placed on another device to reduce the number
 of disk seeks.  To create a filesystem on the first partition on the
-first SCSI disk with a 10MiB log located on the first partition
+first SCSI disk with a 100MiB log located on the first partition
 on the second SCSI disk, use:
 .RS
 .HP
-.B mkfs.xfs\ \-l\ logdev=/dev/sdb1,size=10m /dev/sda1
+.B mkfs.xfs\ \-l\ logdev=/dev/sdb1,size=100m /dev/sda1
 .RE
 .PP
 Each of the
@@ -81,9 +81,9 @@ suboptions if multiple suboptions apply to the same option.
 Equivalently, each main option can be given multiple times with
 different suboptions.
 For example,
-.B \-l internal,size=10m
+.B \-l internal,size=100m
 and
-.B \-l internal \-l size=10m
+.B \-l internal \-l size=100m
 are equivalent.
 .PP
 In the descriptions below, sizes are given in sectors, bytes, blocks,
@@ -404,6 +404,8 @@ is required if
 .B \-d file[=1]
 is given. Otherwise, it is only needed if the filesystem should occupy
 less space than the size of the special file.
+
+The data section must be at least 300MB in size.
 .TP
 .BI sunit= value
 This is used to specify the stripe unit for a RAID device or a
@@ -702,6 +704,9 @@ suffix meaning multiplication by the filesystem block size, as
 described above. The overriding minimum value for size is 512 blocks.
 With some combinations of filesystem block size, inode size,
 and directory block size, the minimum log size is larger than 512 blocks.
+
+The log must be at least 64MB in size.
+The log cannot be more than 2GB in size.
 .TP
 .BI version= value
 This specifies the version of the log. The current default is 2,
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 68d6bd18..9dd0e79c 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -859,6 +859,7 @@ struct cli_params {
 	int64_t	logagno;
 	int	loginternal;
 	int	lsunit;
+	int	is_supported;
 
 	/* parameters where 0 is not a valid value */
 	int64_t	agcount;
@@ -2496,6 +2497,68 @@ _("illegal CoW extent size hint %lld, must be less than %u.\n"),
 	}
 }
 
+/* Complain if this filesystem is not a supported configuration. */
+static void
+validate_supported(
+	struct xfs_mount	*mp,
+	struct cli_params	*cli)
+{
+	/* Undocumented option to enable unsupported tiny filesystems. */
+	if (!cli->is_supported) {
+		printf(
+ _("Filesystems formatted with --unsupported are not supported!!\n"));
+		return;
+	}
+
+	/*
+	 * fstests has a large number of tests that create tiny filesystems to
+	 * perform specific regression and resource depletion tests in a
+	 * controlled environment.  Avoid breaking fstests by allowing
+	 * unsupported configurations if TEST_DIR, TEST_DEV, and QA_CHECK_FS
+	 * are all set.
+	 */
+	if (getenv("TEST_DIR") && getenv("TEST_DEV") && getenv("QA_CHECK_FS"))
+		return;
+
+	/*
+	 * We don't support filesystems smaller than 300MB anymore.  Tiny
+	 * filesystems have never been XFS' design target.  This limit has been
+	 * carefully calculated to prevent formatting with a log smaller than
+	 * the "realistic" size.
+	 *
+	 * If the realistic log size is 64MB, there are four AGs, and the log
+	 * AG should be at least 1/8 free after formatting, this gives us:
+	 *
+	 * 64MB * (8 / 7) * 4 = 293MB
+	 */
+	if (mp->m_sb.sb_dblocks < MEGABYTES(300, mp->m_sb.sb_blocklog)) {
+		fprintf(stderr,
+ _("Filesystem must be larger than 300MB.\n"));
+		usage();
+	}
+
+	/*
+	 * For best performance, we don't allow unrealistically small logs.
+	 * See the comment for XFS_MIN_REALISTIC_LOG_BLOCKS.
+	 */
+	if (mp->m_sb.sb_logblocks <
+			XFS_MIN_REALISTIC_LOG_BLOCKS(mp->m_sb.sb_blocklog)) {
+		fprintf(stderr,
+ _("Log size must be at least 64MB.\n"));
+		usage();
+	}
+
+	/*
+	 * Filesystems should not have fewer than two AGs, because we need to
+	 * have redundant superblocks.
+	 */
+	if (mp->m_sb.sb_agcount < 2) {
+		fprintf(stderr,
+ _("Filesystem must have at least 2 superblocks for redundancy!\n"));
+		usage();
+	}
+}
+
 /*
  * Validate the configured stripe geometry, or is none is specified, pull
  * the configuration from the underlying device.
@@ -3966,9 +4029,21 @@ main(
 	struct cli_params	cli = {
 		.xi = &xi,
 		.loginternal = 1,
+		.is_supported	= 1,
 	};
 	struct mkfs_params	cfg = {};
 
+	struct option		long_options[] = {
+	{
+		.name		= "unsupported",
+		.has_arg	= no_argument,
+		.flag		= &cli.is_supported,
+		.val		= 0,
+	},
+	{NULL, 0, NULL, 0 },
+	};
+	int			option_index = 0;
+
 	/* build time defaults */
 	struct mkfs_default_params	dft = {
 		.source = _("package build definitions"),
@@ -4028,8 +4103,11 @@ main(
 	memcpy(&cli.sb_feat, &dft.sb_feat, sizeof(cli.sb_feat));
 	memcpy(&cli.fsx, &dft.fsx, sizeof(cli.fsx));
 
-	while ((c = getopt(argc, argv, "b:c:d:i:l:L:m:n:KNp:qr:s:CfV")) != EOF) {
+	while ((c = getopt_long(argc, argv, "b:c:d:i:l:L:m:n:KNp:qr:s:CfV",
+					long_options, &option_index)) != EOF) {
 		switch (c) {
+		case 0:
+			break;
 		case 'C':
 		case 'f':
 			force_overwrite = 1;
@@ -4167,6 +4245,8 @@ main(
 	validate_extsize_hint(mp, &cli);
 	validate_cowextsize_hint(mp, &cli);
 
+	validate_supported(mp, &cli);
+
 	/* Print the intended geometry of the fs. */
 	if (!quiet || dry_run) {
 		struct xfs_fsop_geom	geo;

