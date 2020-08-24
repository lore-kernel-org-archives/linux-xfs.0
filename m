Return-Path: <SRS0=BK4F=CC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DF22C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 20:37:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18CBA204EA
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 20:37:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbgHXUhy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Aug 2020 16:37:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:42404 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725904AbgHXUhy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 24 Aug 2020 16:37:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 286B2AC8B;
        Mon, 24 Aug 2020 20:38:23 +0000 (UTC)
From:   Anthony Iliopoulos <ailiop@suse.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/6] mkfs: warn if blocksize doesn't match pagesize on dax devices
Date:   Mon, 24 Aug 2020 22:37:20 +0200
Message-Id: <20200824203724.13477-3-ailiop@suse.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824203724.13477-1-ailiop@suse.com>
References: <20200824203724.13477-1-ailiop@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Block devices that are dax-capable require that the blocksize matches
the platform page size in order to enable dax. Warn if this is not the
case during mkfs, to make it clear that the filesystem will not be
mountable with the dax option enabled.

Make the option overridable so that incompatible filesystem configs can
still be created, e.g. for testing or for cases where the filesystem is
not intended to be mounted with the dax option switched on.

Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
---
 mkfs/xfs_mkfs.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 2e6cd280e388..4fe0bbdcc40c 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1693,8 +1693,7 @@ validate_sectorsize(
 	struct mkfs_default_params *dft,
 	struct fs_topology	*ft,
 	char			*dfile,
-	int			dry_run,
-	int			force_overwrite)
+	int			dry_run)
 {
 	/*
 	 * Before anything else, verify that we are correctly operating on
@@ -1719,9 +1718,6 @@ validate_sectorsize(
 	if (cli->xi->disfile || cli->xi->lisfile || cli->xi->risfile)
 		cli->xi->isdirect = 0;
 
-	memset(ft, 0, sizeof(*ft));
-	get_topology(cli->xi, ft, force_overwrite);
-
 	/* set configured sector sizes in preparation for checks */
 	if (!cli->sectorsize) {
 		/*
@@ -1781,7 +1777,9 @@ static void
 validate_blocksize(
 	struct mkfs_params	*cfg,
 	struct cli_params	*cli,
-	struct mkfs_default_params *dft)
+	struct mkfs_default_params *dft,
+	struct fs_topology	*ft,
+	int			force)
 {
 	/*
 	 * Blocksize and sectorsize first, other things depend on them
@@ -1809,6 +1807,16 @@ _("Minimum block size for CRC enabled filesystems is %d bytes.\n"),
 		usage();
 	}
 
+	if (ft->dax && cfg->blocksize != getpagesize()) {
+		fprintf(stderr,
+_("warning: block size should match platform page size on dax devices.\n"));
+
+		if (!force) {
+			fprintf(stderr,
+				_("Use -f to force usage of block size\n"));
+			usage();
+		}
+	}
 }
 
 /*
@@ -3694,9 +3702,9 @@ main(
 	 * Extract as much of the valid config as we can from the CLI input
 	 * before opening the libxfs devices.
 	 */
-	validate_blocksize(&cfg, &cli, &dft);
-	validate_sectorsize(&cfg, &cli, &dft, &ft, dfile, dry_run,
-			    force_overwrite);
+	get_topology(cli.xi, &ft, force_overwrite);
+	validate_blocksize(&cfg, &cli, &dft, &ft, force_overwrite);
+	validate_sectorsize(&cfg, &cli, &dft, &ft, dfile, dry_run);
 
 	/*
 	 * XXX: we still need to set block size and sector size global variables
-- 
2.28.0

