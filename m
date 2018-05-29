Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S967446AbeE2WGI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 29 May 2018 18:06:08 -0400
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH v4 2/4] mkfs: move shared config structs and into their own headers
Date: Tue, 29 May 2018 15:06:01 -0700
Message-Id: <20180529220603.29420-3-mcgrof@kernel.org>
In-Reply-To: <20180529220603.29420-1-mcgrof@kernel.org>
References: <20180529220603.29420-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com, "Luis R. Rodriguez" <mcgrof@kernel.org>

Both struct sb_feat_args and struct mkfs_default_params will be shared
between CLI processing and the configuration file processing added later,
so move these to their own header.

This will help ensure we split things neatly later and also will help
ensure the configuration file processing code from the CLI code are kept
separate and cannot touch each other's data structures. This also makes
it clear what is actually shared between both.

There are no introduced functional changes in this commit and no
documentation changes, this is just code shuffling.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 mkfs/config.h   | 78 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 mkfs/xfs_mkfs.c | 55 +---------------------------------------
 2 files changed, 79 insertions(+), 54 deletions(-)
 create mode 100644 mkfs/config.h

diff --git a/mkfs/config.h b/mkfs/config.h
new file mode 100644
index 000000000000..e5ea968e2d65
--- /dev/null
+++ b/mkfs/config.h
@@ -0,0 +1,78 @@
+/*
+ * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * Copyright (c) 2016-2017 Red Hat, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#ifndef _XFS_MKFS_CONFIG_H
+#define _XFS_MKFS_CONFIG_H
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
+#endif /* _XFS_MKFS_CONFIG_H */
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 84e9d6b2562a..4664e507afbf 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -21,6 +21,7 @@
 #include "xfs_multidisk.h"
 #include "libxcmd.h"
 #include "fsgeom.h"
+#include "config.h"
 
 
 #define TERABYTES(count, blog)	((uint64_t)(count) << (40 - (blog)))
@@ -706,39 +707,6 @@ cli_opt_set(
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
 /*
  * Options configured on the command line.
  *
@@ -850,27 +818,6 @@ struct mkfs_params {
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
-- 
2.16.3

