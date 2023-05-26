Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3226C77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:31:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbjEZCbq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbjEZCbp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:31:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C216CBC
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:31:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F5F064C57
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:31:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB773C433EF;
        Fri, 26 May 2023 02:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685068303;
        bh=vtw/6VWm5KvSTd/PM7FH3FwTC5D1s2FPO6Ai/zI7sXE=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=Bp8hg1fEvrFJLgw6t7sU7MqcSUrnn05ZdyonHrRMHai2laZKfXo0MxkuuI9fbyEgw
         LIe1ctzGdcjpkRUAF3WOwtzynPWEENRnfSCBhrPKFXu3baSXSzVOe35uJGZjwBonAY
         G5sMnQT+QHpy7hjzilxSP+keSc2JTHEZo3MJn3HqfcMPkQjsWoJv5H1HA9fkLbanE/
         i+hwt1/l5Zrsob3aaXGXkzxNDf3TO+NeupwKJxqRTx2MUtgET3PVRFbb13DLExwsyh
         keAwhc+yNzDFMVPCjgmUj4wbHXdvy67/4x3033Ljt9bOAUpgRIFPFds+XQZz+GeQlR
         BV36O3ZWSXP0g==
Date:   Thu, 25 May 2023 19:31:43 -0700
Subject: [PATCH 08/14] xfs_repair: move the global dirent name store to a
 separate object
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506078705.3750196.486322651196750646.stgit@frogsfrogsfrogs>
In-Reply-To: <168506078591.3750196.1821601831633863822.stgit@frogsfrogsfrogs>
References: <168506078591.3750196.1821601831633863822.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Abstract the main parent pointer dirent names xfblob object into a
separate data structure to hide implementation details.

The goals here are (a) reduce memory usage when we can by deduplicating
dirent names that exist in multiple directories; and (b) provide a
unique id for each name in the system so that sorting incore parent
pointer records can be done in a stable manner.  Fast stable sorting of
records is required for the dirent <-> pptr matching algorithm.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/Makefile   |    2 +
 repair/pptr.c     |   11 ++++---
 repair/strblobs.c |   80 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 repair/strblobs.h |   20 +++++++++++++
 4 files changed, 108 insertions(+), 5 deletions(-)
 create mode 100644 repair/strblobs.c
 create mode 100644 repair/strblobs.h


diff --git a/repair/Makefile b/repair/Makefile
index a5102015651..320f2f9a21d 100644
--- a/repair/Makefile
+++ b/repair/Makefile
@@ -35,6 +35,7 @@ HFILES = \
 	rt.h \
 	scan.h \
 	slab.h \
+	strblobs.h \
 	threads.h \
 	versions.h
 
@@ -75,6 +76,7 @@ CFILES = \
 	sb.c \
 	scan.c \
 	slab.c \
+	strblobs.c \
 	threads.c \
 	versions.c \
 	xfs_repair.c
diff --git a/repair/pptr.c b/repair/pptr.c
index 847e4885aba..04da9fa1194 100644
--- a/repair/pptr.c
+++ b/repair/pptr.c
@@ -9,6 +9,7 @@
 #include "repair/err_protos.h"
 #include "repair/slab.h"
 #include "repair/pptr.h"
+#include "repair/strblobs.h"
 
 #undef PPTR_DEBUG
 
@@ -55,7 +56,7 @@
  * This tuple is recorded in the per-AG master parent pointer index.  Note
  * that names are stored separately in an xfblob data structure so that the
  * rest of the information can be sorted and processed as fixed-size records;
- * the incore parent pointer record contains a pointer to the xfblob data.
+ * the incore parent pointer record contains a pointer to the strblob data.
  */
 
 struct ag_pptr {
@@ -85,7 +86,7 @@ struct ag_pptrs {
 };
 
 /* Global names storage file. */
-static struct xfblob	*names;
+static struct strblobs	*nameblobs;
 static pthread_mutex_t	names_mutex = PTHREAD_MUTEX_INITIALIZER;
 static struct ag_pptrs	*fs_pptrs;
 
@@ -105,7 +106,7 @@ parent_ptr_free(
 	free(fs_pptrs);
 	fs_pptrs = NULL;
 
-	xfblob_destroy(names);
+	strblobs_destroy(&nameblobs);
 }
 
 void
@@ -118,7 +119,7 @@ parent_ptr_init(
 	if (!xfs_has_parent(mp))
 		return;
 
-	error = -xfblob_create(mp, "parent pointer names", &names);
+	error = strblobs_init(mp, "parent pointer names", &nameblobs);
 	if (error)
 		do_error(_("init parent pointer names failed: %s\n"),
 				strerror(error));
@@ -173,7 +174,7 @@ add_parent_ptr(
 	ag_pptr.namehash = libxfs_dir2_hashname(mp, &dname);
 
 	pthread_mutex_lock(&names_mutex);
-	error = -xfblob_store(names, &ag_pptr.name_cookie, fname,
+	error = strblobs_store(nameblobs, &ag_pptr.name_cookie, fname,
 			ag_pptr.namelen);
 	pthread_mutex_unlock(&names_mutex);
 	if (error)
diff --git a/repair/strblobs.c b/repair/strblobs.c
new file mode 100644
index 00000000000..2b7a7a5e04f
--- /dev/null
+++ b/repair/strblobs.c
@@ -0,0 +1,80 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2023 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "libxfs.h"
+#include "libxfs/xfile.h"
+#include "libxfs/xfblob.h"
+#include "repair/strblobs.h"
+
+/*
+ * String Blob Structure
+ * =====================
+ *
+ * This data structure wraps the storage of strings with explicit length in an
+ * xfblob structure.
+ */
+struct strblobs {
+	struct xfblob		*strings;
+};
+
+/* Initialize a string blob structure. */
+int
+strblobs_init(
+	struct xfs_mount	*mp,
+	const char		*descr,
+	struct strblobs		**sblobs)
+{
+	struct strblobs		*sb;
+	int			error;
+
+	sb = malloc(sizeof(struct strblobs));
+	if (!sb)
+		return ENOMEM;
+
+	error = -xfblob_create(mp, descr, &sb->strings);
+	if (error)
+		goto out_free;
+
+	*sblobs = sb;
+	return 0;
+
+out_free:
+	free(sb);
+	return error;
+}
+
+/* Deconstruct a string blob structure. */
+void
+strblobs_destroy(
+	struct strblobs		**sblobs)
+{
+	struct strblobs		*sb = *sblobs;
+
+	xfblob_destroy(sb->strings);
+	free(sb);
+	*sblobs = NULL;
+}
+
+/* Store a string and return a cookie for its retrieval. */
+int
+strblobs_store(
+	struct strblobs		*sblobs,
+	xfblob_cookie		*str_cookie,
+	const unsigned char	*str,
+	unsigned int		str_len)
+{
+	return -xfblob_store(sblobs->strings, str_cookie, str, str_len);
+}
+
+/* Retrieve a previously stored string. */
+int
+strblobs_load(
+	struct strblobs		*sblobs,
+	xfblob_cookie		str_cookie,
+	unsigned char		*str,
+	unsigned int		str_len)
+{
+	return -xfblob_load(sblobs->strings, str_cookie, str, str_len);
+}
diff --git a/repair/strblobs.h b/repair/strblobs.h
new file mode 100644
index 00000000000..f5680175476
--- /dev/null
+++ b/repair/strblobs.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (C) 2023 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __REPAIR_STRBLOBS_H__
+#define __REPAIR_STRBLOBS_H__
+
+struct strblobs;
+
+int strblobs_init(struct xfs_mount *mp, const char *descr,
+		struct strblobs **sblobs);
+void strblobs_destroy(struct strblobs **sblobs);
+
+int strblobs_store(struct strblobs *sblobs, xfblob_cookie *str_cookie,
+		const unsigned char *str, unsigned int str_len);
+int strblobs_load(struct strblobs *sblobs, xfblob_cookie str_cookie,
+		unsigned char *str, unsigned int str_len);
+
+#endif /* __REPAIR_STRBLOBS_H__ */

