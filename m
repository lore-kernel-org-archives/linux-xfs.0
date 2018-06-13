Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:34470 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934978AbeFMTcN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Jun 2018 15:32:13 -0400
Subject: [PATCH 2/5] mkfs: move config file enums to config.h
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 13 Jun 2018 12:31:58 -0700
Message-ID: <152891831888.3968.419374576285554912.stgit@magnolia>
In-Reply-To: <152891829964.3968.4760134019673731615.stgit@magnolia>
References: <152891829964.3968.4760134019673731615.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the config file enums to config.h and make the names distinct from
the cli ones.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 mkfs/config.c |   90 ++++++++++++++++++---------------------------------------
 mkfs/config.h |   32 ++++++++++++++++++++
 2 files changed, 61 insertions(+), 61 deletions(-)


diff --git a/mkfs/config.c b/mkfs/config.c
index 835adc45..23447aa4 100644
--- a/mkfs/config.c
+++ b/mkfs/config.c
@@ -32,38 +32,6 @@
  * We only provide definitions for what we currently support parsing.
  */
 
-enum data_subopts {
-	D_NOALIGN = 0,
-};
-
-enum inode_subopts {
-	I_ALIGN = 0,
-	I_PROJID32BIT,
-	I_SPINODES,
-};
-
-enum log_subopts {
-	L_LAZYSBCNTR = 0,
-};
-
-enum metadata_subopts {
-	M_CRC = 0,
-	M_FINOBT,
-	M_RMAPBT,
-	M_REFLINK,
-};
-
-enum naming_subopts {
-	N_FTYPE = 0,
-};
-
-enum rtdev_subopts {
-	R_NOALIGN = 0,
-};
-
-/* Just define the max options array size manually right now */
-#define MAX_SUBOPTS	5
-
 static int
 config_check_bool(
 	uint64_t	value)
@@ -84,13 +52,13 @@ data_config_parser(
 	int				psubopt,
 	uint64_t			value)
 {
-	enum data_subopts		subopt = psubopt;
+	enum cfg_data_subopts		subopt = psubopt;
 
 	if (config_check_bool(value) != 0)
 		return -1;
 
 	switch (subopt) {
-	case D_NOALIGN:
+	case CFG_D_NOALIGN:
 		dft->sb_feat.nodalign = value;
 		return 0;
 	}
@@ -103,19 +71,19 @@ inode_config_parser(
 	int				psubopt,
 	uint64_t			value)
 {
-	enum inode_subopts		subopt = psubopt;
+	enum cfg_inode_subopts		subopt = psubopt;
 
 	if (config_check_bool(value) != 0)
 		return -1;
 
 	switch (subopt) {
-	case I_ALIGN:
+	case CFG_I_ALIGN:
 		dft->sb_feat.inode_align = value;
 		return 0;
-	case I_PROJID32BIT:
+	case CFG_I_PROJID32BIT:
 		dft->sb_feat.projid32bit = value;
 		return 0;
-	case I_SPINODES:
+	case CFG_I_SPINODES:
 		dft->sb_feat.spinodes = value;
 		return 0;
 	}
@@ -128,13 +96,13 @@ log_config_parser(
 	int				psubopt,
 	uint64_t			value)
 {
-	enum log_subopts		subopt = psubopt;
+	enum cfg_log_subopts		subopt = psubopt;
 
 	if (config_check_bool(value) != 0)
 		return -1;
 
 	switch (subopt) {
-	case L_LAZYSBCNTR:
+	case CFG_L_LAZYSBCNTR:
 		dft->sb_feat.lazy_sb_counters = value;
 		return 0;
 	}
@@ -147,24 +115,24 @@ metadata_config_parser(
 	int				psubopt,
 	uint64_t			value)
 {
-	enum metadata_subopts		subopt = psubopt;
+	enum cfg_metadata_subopts	subopt = psubopt;
 
 	if (config_check_bool(value) != 0)
 		return -1;
 
 	switch (subopt) {
-	case M_CRC:
+	case CFG_M_CRC:
 		dft->sb_feat.crcs_enabled = value;
 		if (dft->sb_feat.crcs_enabled)
 			dft->sb_feat.dirftype = true;
 		return 0;
-	case M_FINOBT:
+	case CFG_M_FINOBT:
 		dft->sb_feat.finobt = value;
 		return 0;
-	case M_RMAPBT:
+	case CFG_M_RMAPBT:
 		dft->sb_feat.rmapbt = value;
 		return 0;
-	case M_REFLINK:
+	case CFG_M_REFLINK:
 		dft->sb_feat.reflink = value;
 		return 0;
 	}
@@ -177,13 +145,13 @@ naming_config_parser(
 	int				psubopt,
 	uint64_t			value)
 {
-	enum naming_subopts		subopt = psubopt;
+	enum cfg_naming_subopts		subopt = psubopt;
 
 	if (config_check_bool(value) != 0)
 		return -1;
 
 	switch (subopt) {
-	case N_FTYPE:
+	case CFG_N_FTYPE:
 		dft->sb_feat.dirftype = value;
 		return 0;
 	}
@@ -196,13 +164,13 @@ rtdev_config_parser(
 	int				psubopt,
 	uint64_t			value)
 {
-	enum rtdev_subopts		subopt = psubopt;
+	enum cfg_rtdev_subopts		subopt = psubopt;
 
 	if (config_check_bool(value) != 0)
 		return -1;
 
 	switch (subopt) {
-	case R_NOALIGN:
+	case CFG_R_NOALIGN:
 		dft->sb_feat.nortalign = value;
 		return 0;
 	}
@@ -211,7 +179,7 @@ rtdev_config_parser(
 
 struct confopts {
 	const char	*name;
-	const char	*subopts[MAX_SUBOPTS];
+	const char	*subopts[CFG_MAX_SUBOPTS];
 	int		(*parser)(struct mkfs_default_params *dft,
 				  int psubopt, uint64_t value);
 	bool		seen;
@@ -219,7 +187,7 @@ struct confopts {
 	{
 		.name = "data",
 		.subopts = {
-			[D_NOALIGN] = "noalign",
+			[CFG_D_NOALIGN] = "noalign",
 			NULL
 		},
 		.parser = data_config_parser,
@@ -227,9 +195,9 @@ struct confopts {
 	{
 		.name = "inode",
 		.subopts = {
-			[I_ALIGN] = "align",
-			[I_PROJID32BIT] = "projid32bit",
-			[I_SPINODES] = "sparse",
+			[CFG_I_ALIGN] = "align",
+			[CFG_I_PROJID32BIT] = "projid32bit",
+			[CFG_I_SPINODES] = "sparse",
 			NULL
 		},
 		.parser = inode_config_parser,
@@ -237,7 +205,7 @@ struct confopts {
 	{
 		.name = "log",
 		.subopts = {
-			[L_LAZYSBCNTR] = "lazy-count",
+			[CFG_L_LAZYSBCNTR] = "lazy-count",
 			NULL
 		},
 		.parser = log_config_parser,
@@ -245,7 +213,7 @@ struct confopts {
 	{
 		.name = "naming",
 		.subopts = {
-			[N_FTYPE] = "ftype",
+			[CFG_N_FTYPE] = "ftype",
 			NULL
 		},
 		.parser = naming_config_parser,
@@ -253,7 +221,7 @@ struct confopts {
 	{
 		.name = "rtdev",
 		.subopts = {
-			[R_NOALIGN] = "noalign",
+			[CFG_R_NOALIGN] = "noalign",
 			NULL
 		},
 		.parser = rtdev_config_parser,
@@ -261,10 +229,10 @@ struct confopts {
 	{
 		.name = "metadata",
 		.subopts = {
-			[M_CRC] = "crc",
-			[M_FINOBT] = "finobt",
-			[M_RMAPBT] = "rmapbt",
-			[M_REFLINK] = "reflink",
+			[CFG_M_CRC] = "crc",
+			[CFG_M_FINOBT] = "finobt",
+			[CFG_M_RMAPBT] = "rmapbt",
+			[CFG_M_REFLINK] = "reflink",
 			NULL
 		},
 		.parser = metadata_config_parser,
diff --git a/mkfs/config.h b/mkfs/config.h
index 544f8a6d..f00849e9 100644
--- a/mkfs/config.h
+++ b/mkfs/config.h
@@ -119,6 +119,38 @@ parse_defaults_file(
 	struct mkfs_default_params	*dft,
 	const char			*config_file);
 
+enum cfg_data_subopts {
+	CFG_D_NOALIGN = 0,
+};
+
+enum cfg_inode_subopts {
+	CFG_I_ALIGN = 0,
+	CFG_I_PROJID32BIT,
+	CFG_I_SPINODES,
+};
+
+enum cfg_log_subopts {
+	CFG_L_LAZYSBCNTR = 0,
+};
+
+enum cfg_metadata_subopts {
+	CFG_M_CRC = 0,
+	CFG_M_FINOBT,
+	CFG_M_RMAPBT,
+	CFG_M_REFLINK,
+};
+
+enum cfg_naming_subopts {
+	CFG_N_FTYPE = 0,
+};
+
+enum cfg_rtdev_subopts {
+	CFG_R_NOALIGN = 0,
+};
+
+/* Just define the max options array size manually right now */
+#define CFG_MAX_SUBOPTS	5
+
 extern const struct sb_feat_args default_features;
 
 #endif /* _XFS_MKFS_CONFIG_H */

