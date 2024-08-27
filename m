Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6111A158D9C
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 11:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724759442; cv=none; b=iLDkzMVnRJPS8LyMNcqzO0iN55CM0HZn2JtN2jqitMThpRH6fLZWlgtcUBl/xZp1DqLqmRiKOEmogLTYmKqLjioX7y88BHBCzWJg34H+cAIRN1U1u5MJcVTjeviXg7TsLLI7qIsmZ1B5fbzn9Cx2DcqEhL1o/o7qjrHsxo+f3LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724759442; c=relaxed/simple;
	bh=K+f1HKNawDQtC5HkoPto55QyUXeh5WOK8n3vJkXI1YQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kte1pV4dr80eUbVnPx0F9m8aUje9KqT3gvgfVdo0kstC+SgACaX56byh0N+Ou9akmGIHA4+GMeaxIfsWYEwbeXLJqS9hYwG62tufn+COyM3+SRDqkqJYqWlG9yc3fihjUdmHTdCKZioLOTlt3X5OVoGJKamIKlyLzXD9ills4QQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sfcGL09q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sfcGL09q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2B6CC515FF;
	Tue, 27 Aug 2024 11:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724759441;
	bh=K+f1HKNawDQtC5HkoPto55QyUXeh5WOK8n3vJkXI1YQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sfcGL09qj/8VrSdQ4SZ3fhqCJcuOOOSzX5yy0Y2h12y0+rg8ns74XKuVW4ihPPMTF
	 JTfcaHoFz/ltQ9hV7ZYT/IAXiRNaVZ55zrReplpLUDQS4CfPDcohRPETdlUDQnI1am
	 LQ4qQbSkS6x7GxEDjB6Lt8A0EeQvG0l1OP9/iYxoepa5jPTygCFQMTVsxba5nCUzsM
	 EP8sbBca7tHUqyHjPum8pWw41kgHAQBFIIsxmDF7idqC9We0fs+wKNW2QaTNRcFPlA
	 E8JTU8Zab3nuqmwEvdvxTS7RHzVb1dqC9W9U6XWuaoCbCIZm+t967MdVYBxQF9RP6I
	 pJvB2xJoZVLNg==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de,
	hch@infradead.org
Subject: [PATCH 2/3] libfrog: remove libattr dependency
Date: Tue, 27 Aug 2024 13:50:23 +0200
Message-ID: <20240827115032.406321-3-cem@kernel.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827115032.406321-1-cem@kernel.org>
References: <20240827115032.406321-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

Get rid of libfrog's libattr dependency, and move the needed local
definitions to a new header - libfrog/attr.h

We could keep the ATTR_ENTRY definition local to fsprops.h, but we'll
add more content to it in the next patch.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libfrog/Makefile  |  7 ++-----
 libfrog/attr.h    | 18 ++++++++++++++++++
 libfrog/fsprops.c |  7 +++----
 3 files changed, 23 insertions(+), 9 deletions(-)
 create mode 100644 libfrog/attr.h

diff --git a/libfrog/Makefile b/libfrog/Makefile
index acddc894e..8581c146b 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -21,6 +21,7 @@ crc32.c \
 file_exchange.c \
 fsgeom.c \
 fsproperties.c \
+fsprops.c \
 getparents.c \
 histogram.c \
 list_sort.c \
@@ -49,6 +50,7 @@ div64.h \
 file_exchange.h \
 fsgeom.h \
 fsproperties.h \
+fsprops.h \
 getparents.h \
 histogram.h \
 logging.h \
@@ -62,11 +64,6 @@ workqueue.h
 
 LSRCFILES += gen_crc32table.c
 
-ifeq ($(HAVE_LIBATTR),yes)
-CFILES+=fsprops.c
-HFILES+=fsprops.h
-endif
-
 LDIRT = gen_crc32table crc32table.h
 
 default: ltdepend $(LTLIBRARY)
diff --git a/libfrog/attr.h b/libfrog/attr.h
new file mode 100644
index 000000000..9110499f2
--- /dev/null
+++ b/libfrog/attr.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2024 Red Hat, Inc.  All Rights Reserved.
+ * Author: Carlos Maiolino <cmaiolino@redhat.com>
+ */
+#ifndef __LIBFROG_ATTR_H__
+#define __LIBFROG_ATTR_H__
+
+/*
+ * Those definitions come from libattr
+ *
+ * We are redifining here so we don't need to keep libattr as a dependency anymore
+ */
+#define ATTR_ENTRY(buffer, index)		\
+	((struct xfs_attrlist_ent *)		\
+	 &((char *)buffer)[ ((struct xfs_attrlist *)(buffer))->al_offset[index] ])
+
+#endif /* __LIBFROG_ATTR_H__ */
diff --git a/libfrog/fsprops.c b/libfrog/fsprops.c
index 05a584a56..ea47c66ed 100644
--- a/libfrog/fsprops.c
+++ b/libfrog/fsprops.c
@@ -10,8 +10,7 @@
 #include "libfrog/bulkstat.h"
 #include "libfrog/fsprops.h"
 #include "libfrog/fsproperties.h"
-
-#include <attr/attributes.h>
+#include "libfrog/attr.h"
 
 /*
  * Given an xfd and a mount table path, get us the handle for the root dir so
@@ -70,7 +69,7 @@ fsprops_walk_names(
 {
 	struct xfs_attrlist_cursor	cur = { };
 	char				attrbuf[XFS_XATTR_LIST_MAX];
-	struct attrlist			*attrlist = (struct attrlist *)attrbuf;
+	struct xfs_attrlist		*attrlist = (struct xfs_attrlist *)attrbuf;
 	int				ret;
 
 	memset(attrbuf, 0, XFS_XATTR_LIST_MAX);
@@ -81,7 +80,7 @@ fsprops_walk_names(
 		unsigned int	i;
 
 		for (i = 0; i < attrlist->al_count; i++) {
-			struct attrlist_ent	*ent = ATTR_ENTRY(attrlist, i);
+			struct xfs_attrlist_ent	*ent = ATTR_ENTRY(attrlist, i);
 			const char		*p =
 				attr_name_to_fsprop_name(ent->a_name);
 
-- 
2.46.0

