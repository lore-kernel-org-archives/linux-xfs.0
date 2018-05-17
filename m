Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751061AbeEQT1E (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 May 2018 15:27:04 -0400
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH v2 2/5] mkfs: move shared structs and cli params into their own headers
Date: Thu, 17 May 2018 12:26:57 -0700
Message-Id: <20180517192700.23457-3-mcgrof@kernel.org>
In-Reply-To: <20180517192700.23457-1-mcgrof@kernel.org>
References: <20180517192700.23457-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com, "Luis R. Rodriguez" <mcgrof@kernel.org>

Both struct sb_feat_args and struct mkfs_default_params will be shared
between CLI processing and the configuration file processing added later,
so move these to their own header. The struct cli_params are CLI specific
so move them to its own CLI header as well.

This will help ensure we split things neatly later and also will help
ensure the configuration file processing code from the CLI code are kept
separate and cannot touch each other's data structures. This also makes
it clear what is actually shared between both.

There are no introduced functional changes in this commit and no
documentation changes, this is just code shuffling.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 mkfs/xfs_mkfs.c        | 115 +------------------------------------------------
 mkfs/xfs_mkfs_cli.h    |  65 ++++++++++++++++++++++++++++
 mkfs/xfs_mkfs_common.h |  64 +++++++++++++++++++++++++++
 3 files changed, 131 insertions(+), 113 deletions(-)
 create mode 100644 mkfs/xfs_mkfs_cli.h
 create mode 100644 mkfs/xfs_mkfs_common.h

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 95cd6ced13f0..ac97039abc34 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -20,6 +20,8 @@
 #include <ctype.h>
 #include "xfs_multidisk.h"
 #include "libxcmd.h"
+#include "xfs_mkfs_common.h"
+#include "xfs_mkfs_cli.h"
 
 
 
@@ -706,98 +708,6 @@ cli_opt_set(
 	       opts->subopt_params[subopt].str_seen;
 }
 
-/*
- * Shared superblock configuration options
- *
- * These options provide shared configuration tunables for the filesystem
- * superblock. There are three possible sources for these options set, each
- * source can overriding the later source:
- *
- * 	o built-in defaults
- * 	o configuration file (XXX)
- * 	o command line
- *
- * These values are not used directly - they are inputs into the mkfs geometry
- * validation.
- */
-struct sb_feat_args {
-	int	log_version;
-	int	attr_version;
-	int	dir_version;
-	bool	inode_align;		/* XFS_SB_VERSION_ALIGNBIT */
-	bool	nci;			/* XFS_SB_VERSION_BORGBIT */
-	bool	lazy_sb_counters;	/* XFS_SB_VERSION2_LAZYSBCOUNTBIT */
-	bool	parent_pointers;	/* XFS_SB_VERSION2_PARENTBIT */
-	bool	projid32bit;		/* XFS_SB_VERSION2_PROJID32BIT */
-	bool	crcs_enabled;		/* XFS_SB_VERSION2_CRCBIT */
-	bool	dirftype;		/* XFS_SB_VERSION2_FTYPE */
-	bool	finobt;			/* XFS_SB_FEAT_RO_COMPAT_FINOBT */
-	bool	spinodes;		/* XFS_SB_FEAT_INCOMPAT_SPINODES */
-	bool	rmapbt;			/* XFS_SB_FEAT_RO_COMPAT_RMAPBT */
-	bool	reflink;		/* XFS_SB_FEAT_RO_COMPAT_REFLINK */
-	bool	nodalign;
-	bool	nortalign;
-};
-
-/*
- * Options configured on the command line.
- *
- * This stores all the specific config parameters the user sets on the command
- * line.  We don't keep flags to indicate what parameters are set - if we need
- * to check if an option was set on the command line, we check the relevant
- * entry in the option table which records whether it was specified in the
- * .seen and .str_seen variables in the table.
- *
- * Some parameters are stored as strings for post-parsing after their dependent
- * options have been resolved (e.g. block size and sector size have been parsed
- * and validated).
- *
- * This allows us to check that values have been set without needing separate
- * flags for each value, and hence avoids needing to record and check for each
- * specific option that can set the value later on in the code. In the cases
- * where we don't have a cli_params structure around, the function cli_opt_set()
- * function can be used.
- */
-struct cli_params {
-	int	sectorsize;
-	int	blocksize;
-
-	/* parameters that depend on sector/block size being validated. */
-	char	*dsize;
-	char	*agsize;
-	char	*dsu;
-	char	*dirblocksize;
-	char	*logsize;
-	char	*lsu;
-	char	*rtextsize;
-	char	*rtsize;
-
-	/* parameters where 0 is a valid CLI value */
-	int	dsunit;
-	int	dswidth;
-	int	dsw;
-	int64_t	logagno;
-	int	loginternal;
-	int	lsunit;
-
-	/* parameters where 0 is not a valid value */
-	int64_t	agcount;
-	int	inodesize;
-	int	inopblock;
-	int	imaxpct;
-	int	lsectorsize;
-	uuid_t	uuid;
-
-	/* feature flags that are set */
-	struct sb_feat_args	sb_feat;
-
-	/* root inode characteristics */
-	struct fsxattr		fsx;
-
-	/* libxfs device setup */
-	struct libxfs_xinit	*xi;
-};
-
 /*
  * Calculated filesystem feature and geometry information.
  *
@@ -850,27 +760,6 @@ struct mkfs_params {
 	struct sb_feat_args	sb_feat;
 };
 
-/*
- * Default filesystem features and configuration values
- *
- * This structure contains the default mkfs values that are to be used when
- * a user does not specify the option on the command line. We do not use these
- * values directly - they are inputs to the mkfs geometry validation and
- * calculations.
- */
-struct mkfs_default_params {
-	char	*source;	/* where the defaults came from */
-
-	int	sectorsize;
-	int	blocksize;
-
-	/* feature flags that are set */
-	struct sb_feat_args	sb_feat;
-
-	/* root inode characteristics */
-	struct fsxattr		fsx;
-};
-
 static void __attribute__((noreturn))
 usage( void )
 {
diff --git a/mkfs/xfs_mkfs_cli.h b/mkfs/xfs_mkfs_cli.h
new file mode 100644
index 000000000000..2050814aec02
--- /dev/null
+++ b/mkfs/xfs_mkfs_cli.h
@@ -0,0 +1,65 @@
+#ifndef _XFS_MKFS_CLI_H
+#define _XFS_MKFS_CLI_H
+
+#include "xfs_mkfs_common.h"
+
+/*
+ * Options configured on the command line.
+ *
+ * This stores all the specific config parameters the user sets on the command
+ * line.  We don't keep flags to indicate what parameters are set - if we need
+ * to check if an option was set on the command line, we check the relevant
+ * entry in the option table which records whether it was specified in the
+ * .seen and .str_seen variables in the table.
+ *
+ * Some parameters are stored as strings for post-parsing after their dependent
+ * options have been resolved (e.g. block size and sector size have been parsed
+ * and validated).
+ *
+ * This allows us to check that values have been set without needing separate
+ * flags for each value, and hence avoids needing to record and check for each
+ * specific option that can set the value later on in the code. In the cases
+ * where we don't have a cli_params structure around, the function cli_opt_set()
+ * function can be used.
+ */
+struct cli_params {
+	int	sectorsize;
+	int	blocksize;
+
+	/* parameters that depend on sector/block size being validated. */
+	char	*dsize;
+	char	*agsize;
+	char	*dsu;
+	char	*dirblocksize;
+	char	*logsize;
+	char	*lsu;
+	char	*rtextsize;
+	char	*rtsize;
+
+	/* parameters where 0 is a valid CLI value */
+	int	dsunit;
+	int	dswidth;
+	int	dsw;
+	int64_t	logagno;
+	int	loginternal;
+	int	lsunit;
+
+	/* parameters where 0 is not a valid value */
+	int64_t	agcount;
+	int	inodesize;
+	int	inopblock;
+	int	imaxpct;
+	int	lsectorsize;
+	uuid_t	uuid;
+
+	/* feature flags that are set */
+	struct sb_feat_args	sb_feat;
+
+	/* root inode characteristics */
+	struct fsxattr		fsx;
+
+	/* libxfs device setup */
+	struct libxfs_xinit	*xi;
+};
+
+#endif /* _XFS_MKFS_CLI_H */
diff --git a/mkfs/xfs_mkfs_common.h b/mkfs/xfs_mkfs_common.h
new file mode 100644
index 000000000000..9b0f67b70cf1
--- /dev/null
+++ b/mkfs/xfs_mkfs_common.h
@@ -0,0 +1,64 @@
+#ifndef _XFS_MKFS_COMMON_H
+#define _XFS_MKFS_COMMON_H
+
+#include "libxfs.h"
+
+#include <ctype.h>
+
+struct fsxattr;
+
+/*
+ * Shared superblock configuration options
+ *
+ * These options provide shared configuration tunables for the filesystem
+ * superblock. There are three possible sources for these options set, each
+ * source can overriding the later source:
+ *
+ * 	o built-in defaults
+ * 	o configuration file (XXX)
+ * 	o command line
+ *
+ * These values are not used directly - they are inputs into the mkfs geometry
+ * validation.
+ */
+struct sb_feat_args {
+	int	log_version;
+	int	attr_version;
+	int	dir_version;
+	bool	inode_align;		/* XFS_SB_VERSION_ALIGNBIT */
+	bool	nci;			/* XFS_SB_VERSION_BORGBIT */
+	bool	lazy_sb_counters;	/* XFS_SB_VERSION2_LAZYSBCOUNTBIT */
+	bool	parent_pointers;	/* XFS_SB_VERSION2_PARENTBIT */
+	bool	projid32bit;		/* XFS_SB_VERSION2_PROJID32BIT */
+	bool	crcs_enabled;		/* XFS_SB_VERSION2_CRCBIT */
+	bool	dirftype;		/* XFS_SB_VERSION2_FTYPE */
+	bool	finobt;			/* XFS_SB_FEAT_RO_COMPAT_FINOBT */
+	bool	spinodes;		/* XFS_SB_FEAT_INCOMPAT_SPINODES */
+	bool	rmapbt;			/* XFS_SB_FEAT_RO_COMPAT_RMAPBT */
+	bool	reflink;		/* XFS_SB_FEAT_RO_COMPAT_REFLINK */
+	bool	nodalign;
+	bool	nortalign;
+};
+
+/*
+ * Default filesystem features and configuration values
+ *
+ * This structure contains the default mkfs values that are to be used when
+ * a user does not specify the option on the command line. We do not use these
+ * values directly - they are inputs to the mkfs geometry validation and
+ * calculations.
+ */
+struct mkfs_default_params {
+	char	*source;	/* where the defaults came from */
+
+	int	sectorsize;
+	int	blocksize;
+
+	/* feature flags that are set */
+	struct sb_feat_args	sb_feat;
+
+	/* root inode characteristics */
+	struct fsxattr		fsx;
+};
+
+#endif /* _XFS_MKFS_COMMON_H */
-- 
2.16.3

