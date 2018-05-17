Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751409AbeEQT1F (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 May 2018 15:27:05 -0400
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH v2 4/5] mkfs: add helpers to process defaults
Date: Thu, 17 May 2018 12:26:59 -0700
Message-Id: <20180517192700.23457-5-mcgrof@kernel.org>
In-Reply-To: <20180517192700.23457-1-mcgrof@kernel.org>
References: <20180517192700.23457-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com, "Luis R. Rodriguez" <mcgrof@kernel.org>

Move the built-in defaults globally and add helpers to reset and
process the defaults. This will be expanded on later. The commented
out print of the defaults source is moved below CLI processing to
acknowledge that one will later want to be able to specify a
different configuration file to be used through the CLI.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 mkfs/xfs_mkfs.c | 93 ++++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 63 insertions(+), 30 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index de0eab3f68e0..cb549be89835 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3662,6 +3662,61 @@ rewrite_secondary_superblocks(
 	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
 }
 
+/* build time defaults */
+struct mkfs_default_params	built_in_dft = {
+	.type = DEFAULTS_BUILTIN,
+	.sectorsize = XFS_MIN_SECTORSIZE,
+	.blocksize = 1 << XFS_DFL_BLOCKSIZE_LOG,
+	.sb_feat = {
+		.log_version = 2,
+		.attr_version = 2,
+		.dir_version = 2,
+		.inode_align = true,
+		.nci = false,
+		.lazy_sb_counters = true,
+		.projid32bit = true,
+		.crcs_enabled = true,
+		.dirftype = true,
+		.finobt = true,
+		.spinodes = true,
+		.rmapbt = false,
+		.reflink = false,
+		.parent_pointers = false,
+		.nodalign = false,
+		.nortalign = false,
+	},
+};
+
+/* installs new defaults into the CLI parsing structure */
+static void install_defaults(
+	struct mkfs_default_params	*dft,
+	struct cli_params		*cli)
+{
+	memcpy(&cli->sb_feat, &dft->sb_feat, sizeof(cli->sb_feat));
+	memcpy(&cli->fsx, &dft->fsx, sizeof(cli->fsx));
+}
+
+/*
+ * Reset defaults first to built-in defaults. Then resets cli opts to start
+ * with these built-in defaults. All previously set CLI options will be ignored.
+ */
+static void reset_defaults_and_cli(
+	struct mkfs_default_params	*dft,
+	struct cli_params		*cli)
+{
+	*dft = built_in_dft;
+
+	install_defaults(dft, cli);
+}
+
+/* Does the required work to process a new set of defaults */
+static void process_defaults(
+	struct mkfs_default_params	*dft,
+	struct cli_params		*cli)
+{
+	install_defaults(dft, cli);
+}
+
 int
 main(
 	int			argc,
@@ -3694,31 +3749,9 @@ main(
 		.loginternal = 1,
 	};
 	struct mkfs_params	cfg = {};
+	struct mkfs_default_params	dft;
 
-	/* build time defaults */
-	struct mkfs_default_params	dft = {
-		.type = DEFAULTS_BUILTIN,
-		.sectorsize = XFS_MIN_SECTORSIZE,
-		.blocksize = 1 << XFS_DFL_BLOCKSIZE_LOG,
-		.sb_feat = {
-			.log_version = 2,
-			.attr_version = 2,
-			.dir_version = 2,
-			.inode_align = true,
-			.nci = false,
-			.lazy_sb_counters = true,
-			.projid32bit = true,
-			.crcs_enabled = true,
-			.dirftype = true,
-			.finobt = true,
-			.spinodes = true,
-			.rmapbt = false,
-			.reflink = false,
-			.parent_pointers = false,
-			.nodalign = false,
-			.nortalign = false,
-		},
-	};
+	reset_defaults_and_cli(&dft, &cli);
 
 	platform_uuid_generate(&cli.uuid);
 	progname = basename(argv[0]);
@@ -3736,14 +3769,9 @@ main(
 	 * still be able to override them. When more than one source is
 	 * implemented, emit a message to indicate where the defaults being
 	 * used came from.
-	 *
-	 * printf(_("Default configuration sourced from %s\n"),
-	 *	  default_type_str(dft.type));
 	 */
 
-	/* copy new defaults into CLI parsing structure */
-	memcpy(&cli.sb_feat, &dft.sb_feat, sizeof(cli.sb_feat));
-	memcpy(&cli.fsx, &dft.fsx, sizeof(cli.fsx));
+	process_defaults(&dft, &cli);
 
 	while ((c = getopt(argc, argv, "b:d:i:l:L:m:n:KNp:qr:s:CfV")) != EOF) {
 		switch (c) {
@@ -3795,6 +3823,11 @@ main(
 	} else
 		dfile = xi.dname;
 
+	/*
+	 * printf(_("Default configuration sourced from %s\n"),
+	 *	  default_type_str(dft.type));
+	 */
+
 	protostring = setup_proto(protofile);
 
 	/*
-- 
2.16.3

