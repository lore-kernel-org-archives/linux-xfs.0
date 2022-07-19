Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D4DEC43334
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jul 2022 21:45:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240108AbiGSVpR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Jul 2022 17:45:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238048AbiGSVpP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jul 2022 17:45:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D3CD2BC4
        for <linux-xfs@vger.kernel.org>; Tue, 19 Jul 2022 14:45:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3736061A77
        for <linux-xfs@vger.kernel.org>; Tue, 19 Jul 2022 21:45:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9227EC341C6;
        Tue, 19 Jul 2022 21:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658267109;
        bh=XIpLahx9QzJHIIgpsI3Zbtijnzgpyueu5lZV79eCIjU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nDO/fcc2llZUKjJBYO2Kcxy8hnD5crLTnp9RPLR+Xc9NWEH1/iSuMZSS8cBx7eDW+
         nE7eaXv7szOMjXvrwEMXSgZjlN+3z3l7c4deLk0ST7TG69szsi49Kq1qoCDlbwiQZT
         rsg7NKfpLG7rEcOKXG1RfnHnjCSYjqJAZuGS2ZUk4uIiVQ7wtJnJc9slp4ynntK8um
         37nbqMmQCpuAUDNt7WBWbxzQq5YwjvZjE3fV62yMyUitcJJC12wSo4HetxLmaZ3+Nn
         QiNWaGi6OJoSSRStSLcgdZoSTR+eJMm2irIZ0pU4KzWAZUOvvCogZ76cVUkNHDwLTz
         lww6xStgPR8Xg==
Subject: [PATCH 2/2] mkfs: stop allowing tiny filesystems
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 19 Jul 2022 14:45:09 -0700
Message-ID: <165826710918.3268874.7904878185632986856.stgit@magnolia>
In-Reply-To: <165826709801.3268874.7256134380224140720.stgit@magnolia>
References: <165826709801.3268874.7256134380224140720.stgit@magnolia>
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
---
 mkfs/xfs_mkfs.c |   82 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 81 insertions(+), 1 deletion(-)


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

