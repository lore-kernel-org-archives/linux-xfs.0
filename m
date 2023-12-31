Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E1BC2C5
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n7BkZ5Q4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36582C433C8;
	Sun, 31 Dec 2023 23:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704064579;
	bh=O552aeYldMIUmJmg73q8yoJwxaK9QVBkPxzvyFefxp8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=n7BkZ5Q4JBgQasNhzEw93U64juubEaP/Eejw9G7x4Fhw0l8EencRe91r1d5rkq+0K
	 YAqtWq4pfLzjDp4v+9rM4s2jZ41JaKv7Gkl6PNAlGwChLmqeVPndnWKAr/w/pxSapd
	 u9HMJI/3KG0F/9JV9WIfK9X9TKVeUzuqhYMCAiPoEzLUIwnd3IBeTCyaCqAxVvR9Dr
	 DdlFhSQk0yAy2T+K0ayS+oXPmYQDs7AZYFFhcJLtgbFD9+pXjXKfYgaCOxjp8I8tm6
	 BrO1W4kQfgHcykkH7oQeY0NyXalv3x3xsCrFbQsIbZk52Orh+ZXX/hS06p+EpW6Wtb
	 2KAWEFXMefWHA==
Date: Sun, 31 Dec 2023 15:16:18 -0800
Subject: [PATCH 11/18] xfs_repair: move the global dirent name store to a
 separate object
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com
Message-ID: <170405007008.1805510.4480196277046468402.stgit@frogsfrogsfrogs>
In-Reply-To: <170405006850.1805510.11145262768706358018.stgit@frogsfrogsfrogs>
References: <170405006850.1805510.11145262768706358018.stgit@frogsfrogsfrogs>
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
index 68cdd0ae424..88970f81348 100644
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
@@ -86,7 +87,7 @@ struct ag_pptrs {
 };
 
 /* Global names storage file. */
-static struct xfblob	*names;
+static struct strblobs	*nameblobs;
 static pthread_mutex_t	names_mutex = PTHREAD_MUTEX_INITIALIZER;
 static struct ag_pptrs	*fs_pptrs;
 
@@ -106,7 +107,7 @@ parent_ptr_free(
 	free(fs_pptrs);
 	fs_pptrs = NULL;
 
-	xfblob_destroy(names);
+	strblobs_destroy(&nameblobs);
 }
 
 void
@@ -122,7 +123,7 @@ parent_ptr_init(
 
 	descr = kasprintf("xfs_repair (%s): parent pointer names",
 			mp->m_fsname);
-	error = -xfblob_create(descr, &names);
+	error = strblobs_init(descr, &nameblobs);
 	kfree(descr);
 	if (error)
 		do_error(_("init parent pointer names failed: %s\n"),
@@ -178,7 +179,7 @@ add_parent_ptr(
 	ag_pptr.namehash = libxfs_dir2_hashname(mp, &dname);
 
 	pthread_mutex_lock(&names_mutex);
-	error = -xfblob_store(names, &ag_pptr.name_cookie, fname,
+	error = strblobs_store(nameblobs, &ag_pptr.name_cookie, fname,
 			ag_pptr.namelen);
 	pthread_mutex_unlock(&names_mutex);
 	if (error)
diff --git a/repair/strblobs.c b/repair/strblobs.c
new file mode 100644
index 00000000000..45d2559c722
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
index 00000000000..27e98eee208
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

