Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D03FCC61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:10:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbjBPVKB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:10:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbjBPVKA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:10:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 097423B23C
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 13:09:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8BA9B826BA
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 21:09:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70ECDC4339C;
        Thu, 16 Feb 2023 21:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581796;
        bh=zCFzbFJnogEByhUNcN/M+j232qS8x0E8wwoI7cMHtdw=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=qH93aydrpHnZZG8BjqtooPX/VjVBHLRKpQjcTTYqN8A0WRYJlKuwezWs+8ScZiAFP
         ihH8j1m+QgCacmi05+q6pG9GL4E0zWRMeDF/esJH1PHaEylnVMf8cxGJq02YZDrDo4
         i/BWfpr1L+AFQ5bbmubY/pDpzx3JLayB+Bm4qvUHZk+/4nYlytujzTYooN1DwDl+Ri
         KvZPsk0cvlplxP7XhOF3WNbDnNV4YxGGHG2ZZW/P84TuNd64mrwLXT0fZ4vBEeDxY3
         tuv/ZTvDOkEdBcsKR6TrAYXVdC6Dg1gbopGiR/MgptnvAgbou0ehGjeGsESOjkOczu
         g7SbTQLfsZWlg==
Date:   Thu, 16 Feb 2023 13:09:55 -0800
Subject: [PATCH 6/8] xfs_repair: move the global dirent name store to a
 separate object
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657882044.3477807.12305464936599915965.stgit@magnolia>
In-Reply-To: <167657881963.3477807.5005383731904631094.stgit@magnolia>
References: <167657881963.3477807.5005383731904631094.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Abstract the main parent pointer dirent names xfblob object into a
separate data structure to hide implementation details.  This is the
first step towards deduplicating the names.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/Makefile   |    2 +
 repair/pptr.c     |   13 +++++----
 repair/strblobs.c |   80 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 repair/strblobs.h |   20 +++++++++++++
 4 files changed, 109 insertions(+), 6 deletions(-)
 create mode 100644 repair/strblobs.c
 create mode 100644 repair/strblobs.h


diff --git a/repair/Makefile b/repair/Makefile
index 925864c2..48ddcdd1 100644
--- a/repair/Makefile
+++ b/repair/Makefile
@@ -33,6 +33,7 @@ HFILES = \
 	rt.h \
 	scan.h \
 	slab.h \
+	strblobs.h \
 	threads.h \
 	versions.h
 
@@ -71,6 +72,7 @@ CFILES = \
 	sb.c \
 	scan.c \
 	slab.c \
+	strblobs.c \
 	threads.c \
 	versions.c \
 	xfs_repair.c
diff --git a/repair/pptr.c b/repair/pptr.c
index b1f5fb4e..20d66884 100644
--- a/repair/pptr.c
+++ b/repair/pptr.c
@@ -14,6 +14,7 @@
 #include "repair/threads.h"
 #include "repair/incore.h"
 #include "repair/pptr.h"
+#include "repair/strblobs.h"
 
 #undef PPTR_DEBUG
 
@@ -194,7 +195,7 @@ struct garbage_xattr {
 };
 
 /* Global names storage file. */
-static struct xfblob	*names;
+static struct strblobs	*nameblobs;
 static pthread_mutex_t	names_mutex = PTHREAD_MUTEX_INITIALIZER;
 static struct ag_pptrs	*fs_pptrs;
 
@@ -261,7 +262,7 @@ parent_ptr_free(
 	free(fs_pptrs);
 	fs_pptrs = NULL;
 
-	xfblob_destroy(names);
+	strblobs_destroy(&nameblobs);
 }
 
 void
@@ -274,7 +275,7 @@ parent_ptr_init(
 	if (!xfs_has_parent(mp))
 		return;
 
-	error = -xfblob_create(mp, "parent pointer names", &names);
+	error = strblobs_init(mp, "parent pointer names", &nameblobs);
 	if (error)
 		do_error(_("init parent pointer names failed: %s\n"),
 				strerror(error));
@@ -325,7 +326,7 @@ add_parent_ptr(
 		return;
 
 	pthread_mutex_lock(&names_mutex);
-	error = -xfblob_store(names, &ag_pptr.name_cookie, fname,
+	error = strblobs_store(nameblobs, &ag_pptr.name_cookie, fname,
 			ag_pptr.namelen);
 	pthread_mutex_unlock(&names_mutex);
 	if (error)
@@ -613,7 +614,7 @@ add_missing_parent_ptr(
 	unsigned char		name[MAXNAMELEN];
 	int			error;
 
-	error = -xfblob_load(names, ag_pptr->name_cookie, name,
+	error = strblobs_load(nameblobs, ag_pptr->name_cookie, name,
 			ag_pptr->namelen);
 	if (error)
 		do_error(
@@ -714,7 +715,7 @@ compare_parent_pointers(
 	unsigned char		name2[MAXNAMELEN] = { };
 	int			error;
 
-	error = -xfblob_load(names, ag_pptr->name_cookie, name1,
+	error = strblobs_load(nameblobs, ag_pptr->name_cookie, name1,
 			ag_pptr->namelen);
 	if (error)
 		do_error(
diff --git a/repair/strblobs.c b/repair/strblobs.c
new file mode 100644
index 00000000..2b7a7a5e
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
index 00000000..f5680175
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

