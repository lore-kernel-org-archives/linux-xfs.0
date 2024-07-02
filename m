Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7BA69441
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719883158; cv=none; b=BBfeEnTfmywfFh1/0tRMtc5ypnBQNE+LD1x2oaiNHODv1VZPjZj9lY8IMNZ/PI6DBqZlGZfzteMdTmk8ZFMXiBVkWkNdl4S/1/W8lsI78dKqz4n+t/30FOUzKFvvX07yyFF/OOatNV7dtnWOvk/9fKoIRntWrmHfFwqhgmG6YvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719883158; c=relaxed/simple;
	bh=rOPHKtAQt6DKduNW1mLOh6UVQ8kvWRphpvzgApjgtgs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BrUU+p29vsA/q2Ko4GnHpROjQAh6MsYvDZmyNOoMMt6VLn+Q1mDBdjtfeSvFcfJGGnySFhnsWpO0FDJ3zosX80saJaLoOzN3HsVuQW15888Dhfi2QnkevFd+1gxqDAsnfEHOOldXYKGn7AsXjYvqYipUDAN5p02qCO/qifxJjJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m5sdkXKz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m5sdkXKz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B327C116B1;
	Tue,  2 Jul 2024 01:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719883158;
	bh=rOPHKtAQt6DKduNW1mLOh6UVQ8kvWRphpvzgApjgtgs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=m5sdkXKzcDLO9t1VOJNt/97Ib5x2Z8QnLJeaFt1uh3F1EHwgcFGzpLGwuMVCLE7J7
	 TgvyVdsj0aLmP3emA8Ioxpi3yqlNdn9nlCQ8cLjPFmQVICmjicGFufJ8cW25u4xC/a
	 494hf3dRvXAwE0mec5UwjsQ8s1Dj31v3eq7C6yXB7ye4CaUKBK8g8k3ps0ADMdDnOB
	 1qHmMWhbldumNUUwxzQcZuIDEhHkZQhr5eXu0jWfLUTleM5ssgU5IEN9cd+X57LQXU
	 VSSxHs1QJD10p0GzVE+yzNfD9IKFmmN1gdud+8eXfXhzTD/4aZZ1PCue/gxCKJHv9H
	 4hsY/uEWdoOAg==
Date: Mon, 01 Jul 2024 18:19:17 -0700
Subject: [PATCH 07/12] xfs_repair: move the global dirent name store to a
 separate object
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com, hch@lst.de
Message-ID: <171988122273.2010218.9308056457503800032.stgit@frogsfrogsfrogs>
In-Reply-To: <171988122147.2010218.8997075209577453030.stgit@frogsfrogsfrogs>
References: <171988122147.2010218.8997075209577453030.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

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
 repair/strblobs.c |   79 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 repair/strblobs.h |   19 +++++++++++++
 4 files changed, 106 insertions(+), 5 deletions(-)
 create mode 100644 repair/strblobs.c
 create mode 100644 repair/strblobs.h


diff --git a/repair/Makefile b/repair/Makefile
index b0acc8c46a33..a36a95e353a5 100644
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
index 193daa0a5467..9f219b398208 100644
--- a/repair/pptr.c
+++ b/repair/pptr.c
@@ -10,6 +10,7 @@
 #include "repair/err_protos.h"
 #include "repair/slab.h"
 #include "repair/pptr.h"
+#include "repair/strblobs.h"
 
 #undef PPTR_DEBUG
 
@@ -56,7 +57,7 @@
  * This tuple is recorded in the per-AG master parent pointer index.  Note
  * that names are stored separately in an xfblob data structure so that the
  * rest of the information can be sorted and processed as fixed-size records;
- * the incore parent pointer record contains a pointer to the xfblob data.
+ * the incore parent pointer record contains a pointer to the strblob data.
  */
 
 struct ag_pptr {
@@ -92,7 +93,7 @@ struct ag_pptrs {
 };
 
 /* Global names storage file. */
-static struct xfblob	*names;
+static struct strblobs	*nameblobs;
 static pthread_mutex_t	names_mutex = PTHREAD_MUTEX_INITIALIZER;
 static struct ag_pptrs	*fs_pptrs;
 
@@ -112,7 +113,7 @@ parent_ptr_free(
 	free(fs_pptrs);
 	fs_pptrs = NULL;
 
-	xfblob_destroy(names);
+	strblobs_destroy(&nameblobs);
 }
 
 void
@@ -128,7 +129,7 @@ parent_ptr_init(
 
 	descr = kasprintf(GFP_KERNEL, "xfs_repair (%s): parent pointer names",
 			mp->m_fsname);
-	error = -xfblob_create(descr, &names);
+	error = strblobs_init(descr, &nameblobs);
 	kfree(descr);
 	if (error)
 		do_error(_("init parent pointer names failed: %s\n"),
@@ -188,7 +189,7 @@ add_parent_ptr(
 	ag_pptr.namehash = libxfs_dir2_hashname(mp, &dname);
 
 	pthread_mutex_lock(&names_mutex);
-	error = -xfblob_store(names, &ag_pptr.name_cookie, fname,
+	error = strblobs_store(nameblobs, &ag_pptr.name_cookie, fname,
 			ag_pptr.namelen);
 	pthread_mutex_unlock(&names_mutex);
 	if (error)
diff --git a/repair/strblobs.c b/repair/strblobs.c
new file mode 100644
index 000000000000..45d2559c7223
--- /dev/null
+++ b/repair/strblobs.c
@@ -0,0 +1,79 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2023-2024 Oracle.  All Rights Reserved.
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
+	error = -xfblob_create(descr, &sb->strings);
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
index 000000000000..27e98eee2080
--- /dev/null
+++ b/repair/strblobs.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2023-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __REPAIR_STRBLOBS_H__
+#define __REPAIR_STRBLOBS_H__
+
+struct strblobs;
+
+int strblobs_init(const char *descr, struct strblobs **sblobs);
+void strblobs_destroy(struct strblobs **sblobs);
+
+int strblobs_store(struct strblobs *sblobs, xfblob_cookie *str_cookie,
+		const unsigned char *str, unsigned int str_len);
+int strblobs_load(struct strblobs *sblobs, xfblob_cookie str_cookie,
+		unsigned char *str, unsigned int str_len);
+
+#endif /* __REPAIR_STRBLOBS_H__ */

