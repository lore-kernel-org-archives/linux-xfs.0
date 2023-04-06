Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78B23C7618D
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:40:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236625AbjDFTk1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235542AbjDFTk1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:40:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2405A9F
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:40:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4D2E60EFE
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:40:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 263A7C433EF;
        Thu,  6 Apr 2023 19:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680810025;
        bh=THtBUQRtlmySFUvd1dyLA+TDVHqtlqOtN9g68ETqZho=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=R7mAEtG+PVp9sqOXAwRI9E8e3zdpnsZlbN4E2RIMnASjrfg1WDhvxKIxM5ugkgBE2
         aK1NZ2Vxwe39W6se5DmOxwaJmLJ4j/iRhv8/64WtFhRXnxVhtFjEzztNX3XIK0tMod
         mWrMnwQE+l5Og2H/JZnRw4+vswfeY9s1XUkDytXxQ+smn0gqAoFBQmeXLLYNRKFgBr
         9eBB5ZOLmYIX0VfV+fWXO8o98A9pjUj4bXpXhsy+mpKvg+SxQxSmPrhmfwLKiQ+o4J
         PnyN/iDAZEpoDxabRgeoKGVr7BuYW1vpE+Ll5GgJFhkNXAja3FxM7HESh6M20szAMP
         UOR4uamRm18cw==
Date:   Thu, 06 Apr 2023 12:40:24 -0700
Subject: [PATCH 2/7] xfs_repair: move the global dirent name store to a
 separate object
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080828286.617551.10139444869300828609.stgit@frogsfrogsfrogs>
In-Reply-To: <168080828258.617551.4008600376507330925.stgit@frogsfrogsfrogs>
References: <168080828258.617551.4008600376507330925.stgit@frogsfrogsfrogs>
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
index 18731613b..395466026 100644
--- a/repair/Makefile
+++ b/repair/Makefile
@@ -32,6 +32,7 @@ HFILES = \
 	rt.h \
 	scan.h \
 	slab.h \
+	strblobs.h \
 	threads.h \
 	versions.h
 
@@ -69,6 +70,7 @@ CFILES = \
 	sb.c \
 	scan.c \
 	slab.c \
+	strblobs.c \
 	threads.c \
 	versions.c \
 	xfs_repair.c
diff --git a/repair/pptr.c b/repair/pptr.c
index f1b3332fc..d18fa0493 100644
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
index 000000000..2b7a7a5e0
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
index 000000000..f56801754
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

