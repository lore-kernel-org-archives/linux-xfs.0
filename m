Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754991AbeEYDTq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 24 May 2018 23:19:46 -0400
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH v3 1/4] mkfs: distinguish between struct sb_feat_args and struct cli_params
Date: Thu, 24 May 2018 20:19:40 -0700
Message-Id: <20180525031943.29440-2-mcgrof@kernel.org>
In-Reply-To: <20180525031943.29440-1-mcgrof@kernel.org>
References: <20180525031943.29440-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com, "Luis R. Rodriguez" <mcgrof@kernel.org>

The struct sb_feat_args will actually be shared between the code which
processes command line options and the configuration file, as such we
need to clarify and reflect this clearly in documentation.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 mkfs/xfs_mkfs.c | 45 ++++++++++++++++++++++++++++-----------------
 1 file changed, 28 insertions(+), 17 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 3804814b3b8a..95cd6ced13f0 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -707,26 +707,18 @@ cli_opt_set(
 }
 
 /*
- * Options configured on the command line.
- *
- * This stores all the specific config parameters the user sets on the command
- * line. We do not use these values directly - they are inputs to the mkfs
- * geometry validation and override any default configuration value we have.
+ * Shared superblock configuration options
  *
- * We don't keep flags to indicate what parameters are set - if we need to check
- * if an option was set on the command line, we check the relevant entry in the
- * option table which records whether it was specified in the .seen and
- * .str_seen variables in the table.
+ * These options provide shared configuration tunables for the filesystem
+ * superblock. There are three possible sources for these options set, each
+ * source can overriding the later source:
  *
- * Some parameters are stored as strings for post-parsing after their dependent
- * options have been resolved (e.g. block size and sector size have been parsed
- * and validated).
+ * 	o built-in defaults
+ * 	o configuration file (XXX)
+ * 	o command line
  *
- * This allows us to check that values have been set without needing separate
- * flags for each value, and hence avoids needing to record and check for each
- * specific option that can set the value later on in the code. In the cases
- * where we don't have a cli_params structure around, the above cli_opt_set()
- * function can be used.
+ * These values are not used directly - they are inputs into the mkfs geometry
+ * validation.
  */
 struct sb_feat_args {
 	int	log_version;
@@ -747,6 +739,25 @@ struct sb_feat_args {
 	bool	nortalign;
 };
 
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
 struct cli_params {
 	int	sectorsize;
 	int	blocksize;
-- 
2.16.3

