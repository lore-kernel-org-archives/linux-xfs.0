Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BA3EC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jun 2022 20:50:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbiF1Uuf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jun 2022 16:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiF1Uuf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 16:50:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ACBE31357
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 13:50:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F269EB81E04
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 20:50:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF3EC341C8;
        Tue, 28 Jun 2022 20:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656449431;
        bh=Pim4edv5NpSQ29QIjHa50XamoxK3gWUKRtIXDfDASEU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=jAzz6DTj3vlvdtOpjQ1J+V3RDiNS0qgxQakRoAQgjBoK5qnARKXUqoxqK7vwcog9G
         iDpFqnkOP8l5i3G5ZzZdD4A06pV4FF2SXDgdQjSjA4l6qeJO3Jd3UxisPBY1bZW12w
         vfBmv6gR86fLqclOwcpKJpM3N4xAlYWhaVIg0yo7xO6/4vR/Uf0zh09yDqKoztlkrc
         eJtpdPGDD12ES5NEtuHiLfLE3kg2xHwBiE27GIUmtj0dLWghA4tFrEzjE8sX0H+OSt
         Ilgle9Tu0Gn1wzVkWCWDihJ3GrBSbKMVEjAR33V0p7lHJatPHOQpvUyVsSLWsde/gd
         8+hlV3dcfw8Pg==
Subject: [PATCH 1/1] mkfs: stop allowing tiny filesystems
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 28 Jun 2022 13:50:31 -0700
Message-ID: <165644943121.1091646.10171089108168615883.stgit@magnolia>
In-Reply-To: <165644942559.1091646.1065506297333895934.stgit@magnolia>
References: <165644942559.1091646.1065506297333895934.stgit@magnolia>
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
index db322b3a..728a001a 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -847,6 +847,7 @@ struct cli_params {
 	int64_t	logagno;
 	int	loginternal;
 	int	lsunit;
+	int	has_warranty;
 
 	/* parameters where 0 is not a valid value */
 	int64_t	agcount;
@@ -2484,6 +2485,68 @@ _("illegal CoW extent size hint %lld, must be less than %u.\n"),
 	}
 }
 
+/* Complain if this filesystem is not a supported configuration. */
+static void
+validate_warranty(
+	struct xfs_mount	*mp,
+	struct cli_params	*cli)
+{
+	/* Undocumented option to enable unsupported tiny filesystems. */
+	if (!cli->has_warranty) {
+		printf(
+ _("Filesystems formatted with --yes-i-know-what-i-am-doing are not supported!!\n"));
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
+ _("Filesystem must have redundant superblocks!\n"));
+		usage();
+	}
+}
+
 /*
  * Validate the configured stripe geometry, or is none is specified, pull
  * the configuration from the underlying device.
@@ -3933,9 +3996,21 @@ main(
 	struct cli_params	cli = {
 		.xi = &xi,
 		.loginternal = 1,
+		.has_warranty	= 1,
 	};
 	struct mkfs_params	cfg = {};
 
+	struct option		long_options[] = {
+	{
+		.name		= "yes-i-know-what-i-am-doing",
+		.has_arg	= no_argument,
+		.flag		= &cli.has_warranty,
+		.val		= 0,
+	},
+	{NULL, 0, NULL, 0 },
+	};
+	int			option_index = 0;
+
 	/* build time defaults */
 	struct mkfs_default_params	dft = {
 		.source = _("package build definitions"),
@@ -3995,8 +4070,11 @@ main(
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
@@ -4134,6 +4212,8 @@ main(
 	validate_extsize_hint(mp, &cli);
 	validate_cowextsize_hint(mp, &cli);
 
+	validate_warranty(mp, &cli);
+
 	/* Print the intended geometry of the fs. */
 	if (!quiet || dry_run) {
 		struct xfs_fsop_geom	geo;

