Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC533D5661
	for <linux-xfs@vger.kernel.org>; Mon, 25 May 2026 07:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779695908; cv=none; b=GLQr/01kHlHkN57NSaUDGwKtQ4PQA/gjeELWxWJFBT1Gwl2PD9etYrcd87CHS9JrjjFHP5EYUrZRmMNR5av/YOR7btp2fBQ0l2rRFlDTSVpmVLsnJ5M+ctoex2nU6rTkkqrzuHT7KJmN9cArl1nHsQyK8ObSk6nrYR1u1bwPAow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779695908; c=relaxed/simple;
	bh=O+4R669vSlkRvYgyx+5iydZmbRcGw9uDZpZYMdjxBFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P+AOUFBHelW2HPhX7dQFNTCCb9J8ic6BzwlUFAi+o3j4KkbyCxSsgYbj2wz42sLz7g+e2YKMwa3MiLuvqBvypmdujPOaZRhE8xFjmMBV2rWozJpW2m4Z3ldDkHM6izJiRX5cg8m/RM2eVXn7sjWqoRBghmvQk/ffgcx28m1NrOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id 75C0C180F2E9;
	Mon, 25 May 2026 09:58:21 +0200 (CEST)
Received: from trufa.intra.herbolt.com.com ([172.168.31.30])
	by mx0.herbolt.com with ESMTPSA
	id rrOwOhUBFGoUrzcAKEJqOA:T3
	(envelope-from <lukas@herbolt.com>); Mon, 25 May 2026 09:58:21 +0200
From: Lukas Herbolt <lukas@herbolt.com>
To: djwong@kernel.org,
	sandeen@sandeen.net,
	aalbersh@kernel.org,
	dgc@kernel.org
Cc: linux-xfs@vger.kernel.org,
	Lukas Herbolt <lukas@herbolt.com>
Subject: [RFC PATCH v2 2/5] xfsprogs: mkfs.xfs add default configuration file.
Date: Mon, 25 May 2026 09:57:49 +0200
Message-ID: <20260525075752.4159504-3-lukas@herbolt.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260525075752.4159504-1-lukas@herbolt.com>
References: <20260525075752.4159504-1-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Various users may prefer different default values. Having a default config
file will allow them to utilize it without the need specifying configuration
file on command line. The behavior is: build time options are overwritten
by the default config file and this options can be overwritten either by
command line options or by config file.

Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
---
 include/builddefs.in      |   1 +
 mkfs/Makefile             |   2 +
 mkfs/default.conf.example |  10 ++++
 mkfs/xfs_mkfs.c           | 113 ++++++++++++++++++++++++++++++++------
 4 files changed, 108 insertions(+), 18 deletions(-)
 create mode 100644 mkfs/default.conf.example

diff --git a/include/builddefs.in b/include/builddefs.in
index 3b52d1afd703..bafea70af8ea 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -59,6 +59,7 @@ PKG_DOC_DIR	= @datadir@/doc/@pkg_name@
 PKG_LOCALE_DIR	= @datadir@/locale
 PKG_DATA_DIR	= @datadir@/@pkg_name@
 MKFS_CFG_DIR	= @datadir@/@pkg_name@/mkfs
+MKFS_SYSCFG_DIR = @sysconfdir@/mkfs.xfs.d
 PKG_STATE_DIR	= @localstatedir@/lib/@pkg_name@
 
 XFS_SCRUB_ALL_AUTO_MEDIA_SCAN_STAMP=$(PKG_STATE_DIR)/xfs_scrub_all_media.stamp
diff --git a/mkfs/Makefile b/mkfs/Makefile
index fb1473324cde..468d2ab7896e 100644
--- a/mkfs/Makefile
+++ b/mkfs/Makefile
@@ -11,6 +11,7 @@ XFS_PROTOFILE = xfs_protofile.py
 HFILES =
 CFILES = proto.c xfs_mkfs.c
 CFGFILES = \
+	default.conf.example \
 	dax_x86_64.conf \
 	lts_4.19.conf \
 	lts_5.4.conf \
@@ -21,6 +22,7 @@ CFGFILES = \
 	lts_6.12.conf \
 	lts_6.18.conf
 
+LCFLAGS += -DMKFS_CFG_DIR=\"$(MKFS_CFG_DIR)\" -DMKFS_SYSCFG_DIR=\"$(MKFS_SYSCFG_DIR)\"
 LLDLIBS += $(LIBXFS) $(LIBXCMD) $(LIBFROG) $(LIBRT) $(LIBBLKID) \
 	$(LIBUUID) $(LIBINIH) $(LIBURCU) $(LIBPTHREAD)
 LTDEPENDENCIES += $(LIBXFS) $(LIBXCMD) $(LIBFROG)
diff --git a/mkfs/default.conf.example b/mkfs/default.conf.example
new file mode 100644
index 000000000000..ab418eab000d
--- /dev/null
+++ b/mkfs/default.conf.example
@@ -0,0 +1,10 @@
+# Default config file example.
+#[metadata]
+#bigtime=1
+#crc=1
+
+#[inode]
+#sparse=1
+
+#[naming]
+#parent=1
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 349afe65c9fc..bff7d078901c 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -44,6 +44,11 @@
  */
 #define WHACK_SIZE (128 * 1024)
 
+/*
+ * Default configuration file which can keep distro specific values.
+ */
+#define MKFS_DEFAULT_CFGFILE   MKFS_SYSCFG_DIR "/default.conf"
+
 /*
  * XXX: The configured block and sector sizes are defined as global variables so
  * that they don't need to be passed to getnum/cvtnum().
@@ -5800,7 +5805,8 @@ cfgfile_parse(
 		}
 		exit(1);
 	}
-	printf(_("Parameters parsed from config file %s successfully\n"),
+	if  (strcmp(cli->cfgfile, MKFS_DEFAULT_CFGFILE) != 0)
+		printf(_("Parameters parsed from config file %s successfully.\n"),
 		cli->cfgfile);
 }
 
@@ -5953,6 +5959,75 @@ check_rt_meta_prealloc(
 	mp->m_finobt_nores = false;
 }
 
+static void
+check_ignored_opt(
+	struct cli_params	*dflt,
+	const char		*section,
+	const char		*key)
+{
+	bool need_warn = false;
+	if (strcmp(section, "metadata") == 0 && strcmp(key, "uuid") == 0) {
+		if (!platform_uuid_is_null(&dflt->uuid)) {
+			platform_uuid_clear(&dflt->uuid);
+			need_warn = true;
+		}
+	}
+
+	if (strcmp(section, "data") == 0) {
+		if (strcmp(key, "sunit") == 0 || strcmp(key, "su") == 0) {
+	                dflt->dsunit = 0;
+	                dflt->dsu = NULL;
+                        need_warn = true;
+		}
+
+		if (strcmp(key, "swidth") == 0 || strcmp(key, "sw") == 0) {
+			dflt->dswidth = 0;
+			dflt->dsw = 0;
+			need_warn = true;
+		}
+	}
+
+	if (strcmp(section, "sector") == 0 && strcmp(key, "size") == 0) {
+			dflt->sectorsize = XFS_MIN_SECTORSIZE;
+                        need_warn = true;
+	}
+
+	if (strcmp(section, "block") == 0 && strcmp(key, "size") == 0) {
+			dflt->blocksize  = 1 << XFS_DFL_BLOCKSIZE_LOG;
+                        need_warn = true;
+	}
+
+	if (need_warn)
+		fprintf(stderr,
+		_("'%s' in section '%s' ignored in default config file\n"),
+		key, section);
+}
+
+static void
+reset_opts_seen(
+	struct cli_params	*dflt)
+{
+	struct subopts		*sop;
+	struct subopt_param	*sp;
+	int			i;
+
+	for (sop = &subopt_tab[0]; sop->opts; sop++) {
+		if (sop->opts->ini_section[0] == '\0')
+			continue;
+		for (i = 0; i < MAX_SUBOPTS; i++) {
+			if (!sop->opts->subopts[i])
+				break;
+			sp = &sop->opts->subopt_params[i];
+			if (sp->seen || sp->str_seen)
+				check_ignored_opt(dflt, sop->opts->ini_section,
+							sop->opts->subopts[i]);
+			sp->seen     = false;
+			sp->str_seen = false;
+		}
+	}
+}
+
+
 int
 main(
 	int			argc,
@@ -5978,6 +6053,7 @@ main(
 	struct fs_topology	ft = {};
 	struct mkfs_params	cfg = {};
 	struct cli_params	cli;
+	struct cli_params	file_dft;
 
 	struct option		long_options[] = {
 	{
@@ -5993,28 +6069,29 @@ main(
 	struct list_head	buffer_list;
 	int			error;
 
-	/* copy builtin defaults into CLI parsing structure */
-	memcpy(&cli, &bld_dft, sizeof(cli));
-	cli.xi = &xi;
-	platform_uuid_generate(&cli.uuid);
+	/* copy builtin defaults into file_dft parsing structure */
+	memcpy(&file_dft, &bld_dft, sizeof(cli));
 	progname = basename(argv[0]);
 	setlocale(LC_ALL, "");
 	bindtextdomain(PACKAGE, LOCALEDIR);
 	textdomain(PACKAGE);
 
-	/*
-	 * TODO: Sourcing defaults from a config file
-	 *
-	 * Before anything else, see if there's a config file with different
-	 * defaults. If a file exists in <package location>, read in the new
-	 * default values and overwrite them in the &dft structure. This way the
-	 * new defaults will apply before we parse the CLI, and the CLI will
-	 * still be able to override them. When more than one source is
-	 * implemented, emit a message to indicate where the defaults being
-	 * used came from.
-	 *
-	 * printf(_("Default configuration sourced from %s\n"), dft.source);
-	 */
+	if (access(MKFS_DEFAULT_CFGFILE, F_OK) == 0){
+		/*
+		 * We need to reset some values that were loaded from
+		 * build time and set the cfgfile to default value
+		 */
+		file_dft.cfgfile = MKFS_DEFAULT_CFGFILE;
+		cfgfile_parse(&file_dft);
+		reset_opts_seen(&file_dft);
+		printf(_("Default configuration sourced from %s\n"),
+				MKFS_DEFAULT_CFGFILE);
+	}
+
+	memcpy(&cli, &file_dft, sizeof(cli));
+	cli.cfgfile = NULL;
+	cli.xi = &xi;
+	platform_uuid_generate(&cli.uuid);
 
 	while ((c = getopt_long(argc, argv, "b:c:d:i:l:L:m:n:KNp:qr:s:CfV",
 					long_options, &option_index)) != EOF) {
-- 
2.54.0

