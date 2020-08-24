Return-Path: <SRS0=BK4F=CC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0A16C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 20:38:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDEF1204EA
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 20:38:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726257AbgHXUiB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Aug 2020 16:38:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:42454 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725904AbgHXUiB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 24 Aug 2020 16:38:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7C17AAC8B;
        Mon, 24 Aug 2020 20:38:29 +0000 (UTC)
From:   Anthony Iliopoulos <ailiop@suse.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 4/6] mkfs: introduce -y option to force incompat config combinations
Date:   Mon, 24 Aug 2020 22:37:22 +0200
Message-Id: <20200824203724.13477-5-ailiop@suse.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824203724.13477-1-ailiop@suse.com>
References: <20200824203724.13477-1-ailiop@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Introduce a new command line option that can be used to override bailing
out on combinations of incompatible configurations and other warnings.

The -f option is currently overloaded to include these semantics, but it
conceals cases where there is an fs signature detected and confirmation
is required to overwrite the filesystem.

Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
---
 libfrog/topology.c  | 14 +++++++-------
 man/man8/mkfs.xfs.8 |  6 ++++++
 mkfs/xfs_mkfs.c     | 16 ++++++++++------
 3 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/libfrog/topology.c b/libfrog/topology.c
index 713358b01b4c..ad317fe4e287 100644
--- a/libfrog/topology.c
+++ b/libfrog/topology.c
@@ -181,7 +181,7 @@ static void blkid_get_topology(
 	int		*lsectorsize,
 	int		*psectorsize,
 	int		*dax,
-	int		force_overwrite)
+	int		force)
 {
 
 	blkid_topology tp;
@@ -240,9 +240,9 @@ static void blkid_get_topology(
 			_("warning: device is not properly aligned %s\n"),
 			device);
 
-		if (!force_overwrite) {
+		if (!force) {
 			fprintf(stderr,
-				_("Use -f to force usage of a misaligned device\n"));
+				_("Use -y to force usage of a misaligned device\n"));
 
 			exit(EXIT_FAILURE);
 		}
@@ -281,7 +281,7 @@ static void blkid_get_topology(
 	int		*lsectorsize,
 	int		*psectorsize,
 	int		*dax,
-	int		force_overwrite)
+	int		force)
 {
 	/*
 	 * Shouldn't make any difference (no blkid = no block device access),
@@ -296,7 +296,7 @@ static void blkid_get_topology(
 void get_topology(
 	libxfs_init_t		*xi,
 	struct fs_topology	*ft,
-	int			force_overwrite)
+	int			force)
 {
 	struct stat statbuf;
 	char *dfile = xi->volname ? xi->volname : xi->dname;
@@ -326,7 +326,7 @@ void get_topology(
 	} else {
 		blkid_get_topology(dfile, &ft->dsunit, &ft->dswidth,
 				   &ft->lsectorsize, &ft->psectorsize,
-				   &ft->dax, force_overwrite);
+				   &ft->dax, force);
 	}
 
 	if (xi->rtname && !xi->risfile) {
@@ -334,6 +334,6 @@ void get_topology(
 
 		blkid_get_topology(xi->rtname, &sunit, &ft->rtswidth,
 				   &lsectorsize, &psectorsize, &ft->dax,
-				   force_overwrite);
+				   force);
 	}
 }
diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index 9d762a43011a..d84db416db1b 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -41,6 +41,8 @@ mkfs.xfs \- construct an XFS filesystem
 .B \-N
 ] [
 .B \-K
+] [
+.B \-y
 ]
 .I device
 .br
@@ -919,6 +921,10 @@ Do not attempt to discard blocks at mkfs time.
 .TP
 .B \-V
 Prints the version number and exits.
+.TP
+.B \-y
+Override warnings and force usage of incompatible features.
+.TP
 .SH SEE ALSO
 .BR xfs (5),
 .BR mkfs (8),
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index b8739c2b9093..75e910dd4a30 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1813,7 +1813,7 @@ _("warning: block size should match platform page size on dax devices.\n"));
 
 		if (!force) {
 			fprintf(stderr,
-				_("Use -f to force usage of block size\n"));
+				_("Use -y to force usage of block size\n"));
 			usage();
 		}
 	}
@@ -2010,7 +2010,7 @@ _("rmapbt not supported with realtime devices\n"));
 
 		if (!force) {
 			fprintf(stderr,
-				_("Use -f to force enabling reflink\n"));
+				_("Use -y to force enabling reflink\n"));
 			usage();
 		}
 	}
@@ -3586,6 +3586,7 @@ main(
 	int			dry_run = 0;
 	int			discard = 1;
 	int			force_overwrite = 0;
+	int			force = 0;
 	int			quiet = 0;
 	char			*protofile = NULL;
 	char			*protostring = NULL;
@@ -3658,7 +3659,7 @@ main(
 	memcpy(&cli.sb_feat, &dft.sb_feat, sizeof(cli.sb_feat));
 	memcpy(&cli.fsx, &dft.fsx, sizeof(cli.fsx));
 
-	while ((c = getopt(argc, argv, "b:d:i:l:L:m:n:KNp:qr:s:CfV")) != EOF) {
+	while ((c = getopt(argc, argv, "b:d:i:l:L:m:n:KNp:qr:s:CfVy")) != EOF) {
 		switch (c) {
 		case 'C':
 		case 'f':
@@ -3696,6 +3697,9 @@ main(
 		case 'V':
 			printf(_("%s version %s\n"), progname, VERSION);
 			exit(0);
+		case 'y':
+			force = 1;
+			break;
 		default:
 			unknown(optopt, "");
 		}
@@ -3714,8 +3718,8 @@ main(
 	 * Extract as much of the valid config as we can from the CLI input
 	 * before opening the libxfs devices.
 	 */
-	get_topology(cli.xi, &ft, force_overwrite);
-	validate_blocksize(&cfg, &cli, &dft, &ft, force_overwrite);
+	get_topology(cli.xi, &ft, force);
+	validate_blocksize(&cfg, &cli, &dft, &ft, force);
 	validate_sectorsize(&cfg, &cli, &dft, &ft, dfile, dry_run);
 
 	/*
@@ -3726,7 +3730,7 @@ main(
 	sectorsize = cfg.sectorsize;
 
 	validate_log_sectorsize(&cfg, &cli, &dft);
-	validate_sb_features(&cfg, &cli, &ft, force_overwrite);
+	validate_sb_features(&cfg, &cli, &ft, force);
 
 	/*
 	 * we've now completed basic validation of the features, sector and
-- 
2.28.0

