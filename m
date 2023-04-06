Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAAEAC7619A
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 00:04:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232605AbjDFAEM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Apr 2023 20:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbjDFAEL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Apr 2023 20:04:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 450A1729F
        for <linux-xfs@vger.kernel.org>; Wed,  5 Apr 2023 17:03:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B0B0629AB
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 00:03:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AA53C433EF;
        Thu,  6 Apr 2023 00:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680739396;
        bh=Q/gkr4umQm2jlY1SqWexD8cie622zkzwaKb4CK8HshE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=t1N0WsphqDrzepJlp182DY9sLFVFGvUIlNeDY8Y7cQDMb7fTavIL3vC70N51c+PDj
         nS7caD57hCP04DT0duNDNrumIJsioaktJUUGCXw/nMhWWo6mzL+OKLtQE+Vckl6fvl
         43v9bx3JLW53Jhm/SeLA+lnpvIWXhwqnx/4S4URYprSK6rO7T9rJkVY8gMfXEm/tfS
         DSaJQ7v+2VVqx0gEyCUuiifwVWV3mslJwvY+k8bXE/JE7PG9KasruoS7IyKWm21KH4
         +0XNwQyDL5F6qLtSLf2sqAB7S814Vu5ARsZQWDjEOU04ymgSJH7WvMOPcLzn5Qv722
         v7oOdmZpbqY+w==
Subject: [PATCH 4/4] xfs: deprecate the ascii-ci feature
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Wed, 05 Apr 2023 17:03:16 -0700
Message-ID: <168073939615.1648023.11626629628611950172.stgit@frogsfrogsfrogs>
In-Reply-To: <168073937339.1648023.5029899643925660515.stgit@frogsfrogsfrogs>
References: <168073937339.1648023.5029899643925660515.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This feature is a mess -- the hash function has been broken for the
entire 15 years of its existence if you create names with extended ascii
bytes; metadump name obfuscation has silently failed for just as long;
and the feature clashes horribly with the UTF8 encodings that most
systems use today.  There is exactly one fstest for this feature.

In other words, this feature is crap.  Let's deprecate it now so we can
remove it from the codebase in 2030.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 Documentation/admin-guide/xfs.rst |    1 +
 fs/xfs/Kconfig                    |   27 +++++++++++++++++++++++++++
 fs/xfs/xfs_super.c                |   13 +++++++++++++
 3 files changed, 41 insertions(+)


diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
index e2561416391c..e85a9404d5c0 100644
--- a/Documentation/admin-guide/xfs.rst
+++ b/Documentation/admin-guide/xfs.rst
@@ -240,6 +240,7 @@ Deprecated Mount Options
   Name				Removal Schedule
 ===========================     ================
 Mounting with V4 filesystem     September 2030
+Mounting ascii-ci filesystem    September 2030
 ikeep/noikeep			September 2025
 attr2/noattr2			September 2025
 ===========================     ================
diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index 9fac5ea8d0e4..09c5ff136f22 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -47,6 +47,33 @@ config XFS_SUPPORT_V4
 	  To continue supporting the old V4 format (crc=0), say Y.
 	  To close off an attack surface, say N.
 
+config XFS_SUPPORT_ASCII_CI
+	bool "Support deprecated case-insensitive ascii (ascii-ci=1) format"
+	depends on XFS_FS
+	default y
+	help
+	  The ASCII case insensitivity filesystem feature only works correctly
+	  on systems that have been coerced into using ISO 8859-1, and it does
+	  not work on extended attributes.  The kernel has no visibility into
+	  the locale settings in userspace, so it corrupts UTF-8 names.
+	  Enabling this feature makes XFS vulnerable to mixed case sensitivity
+	  attacks.  Because of this, the feature is deprecated.  All users
+	  should upgrade by backing up their files, reformatting, and restoring
+	  from the backup.
+
+	  Administrators and users can detect such a filesystem by running
+	  xfs_info against a filesystem mountpoint and checking for a string
+	  beginning with "ascii-ci=".  If the string "ascii-ci=1" is found, the
+	  filesystem is a case-insensitive filesystem.  If no such string is
+	  found, please upgrade xfsprogs to the latest version and try again.
+
+	  This option will become default N in September 2025.  Support for the
+	  feature will be removed entirely in September 2030.  Distributors
+	  can say N here to withdraw support earlier.
+
+	  To continue supporting case-insensitivity (ascii-ci=1), say Y.
+	  To close off an attack surface, say N.
+
 config XFS_QUOTA
 	bool "XFS Quota support"
 	depends on XFS_FS
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 4f814f9e12ab..4d2e87462ac4 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1548,6 +1548,19 @@ xfs_fs_fill_super(
 #endif
 	}
 
+	/* ASCII case insensitivity is undergoing deprecation. */
+	if (xfs_has_asciici(mp)) {
+#ifdef CONFIG_XFS_SUPPORT_ASCII_CI
+		xfs_warn_once(mp,
+	"Deprecated ASCII case-insensitivity feature (ascii-ci=1) will not be supported after September 2030.");
+#else
+		xfs_warn(mp,
+	"Deprecated ASCII case-insensitivity feature (ascii-ci=1) not supported by kernel.");
+		error = -EINVAL;
+		goto out_free_sb;
+#endif
+	}
+
 	/* Filesystem claims it needs repair, so refuse the mount. */
 	if (xfs_has_needsrepair(mp)) {
 		xfs_warn(mp, "Filesystem needs repair.  Please run xfs_repair.");

