Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E9E158D9C
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 11:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724759444; cv=none; b=YzBZZAlQwDV7DCuxi8gL1IS7pNKd6+AFueMBbCY9ZEG+15pzTiFJYhan1o0IZ2z8Bcitiab0u/qRBrdT5BhDcdM1Dca22fqKHxCGK6kcRpNjNlgT5jthXOgIiK4BE2a4Fk5IOoNOslDOKXQM3HG11lCr+sROnhkedpkxP8JwZvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724759444; c=relaxed/simple;
	bh=zHJBaEx7H3mAeZsPVB3RA7XWhxv31v+xTa1MCt6Q8kU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dP9vigBM5aiWpKYEBYorMJhRp+nN8xzeKWThmLDZFgnwFVD5QMQrEWwF7QTSRjIxDLsRZO465mDxOlbizyd1o7r3jnMeISP+q0qe4FXhf1qvChmFyu52/rEUdDmH0dL/clxo890HSIArx+qjW+90Kq4zkHYb1dHkZpGHoqxlMBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qx3LS48N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qx3LS48N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BACEC519AA;
	Tue, 27 Aug 2024 11:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724759443;
	bh=zHJBaEx7H3mAeZsPVB3RA7XWhxv31v+xTa1MCt6Q8kU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qx3LS48N22Lmg0PndMXgzpaKKRsO3MqjrSTfPq4UHGluaSHnPAieVoTo4fQRkO9pD
	 BzIW+XTt2q28PEyunhaAe5i7dOGSi41ZNrEErrGJC8AOhrX1r4qc0jX60l37K2cyD3
	 RQr9nvi/6C/xdgSWo1CaiyLk3NO2GG6uPeXxd1FKmPUAtbf8+9W5jIhhA67GuvTRzz
	 ZjmamHSY4hEXVhuIYjEko8jTzCAml2iJnMIRcmKaCINHnqgXUwNd/mMqD18cRZcCuA
	 LKj9kwmNggJkncmFv3YLz/ttVwynC+Lkj5RX37VfFcIa9Tza5sLLizKRV6l/sn+PBT
	 X+MK16DECb/Tw==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de,
	hch@infradead.org
Subject: [PATCH 3/3] scrub: Remove libattr dependency
Date: Tue, 27 Aug 2024 13:50:24 +0200
Message-ID: <20240827115032.406321-4-cem@kernel.org>
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

Rename all attrlist usage to xfs_attrlist, and add a couple more
definitions to libfrog/attr.h

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libfrog/attr.h | 5 +++++
 scrub/Makefile | 4 ----
 scrub/phase5.c | 9 +++------
 3 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/libfrog/attr.h b/libfrog/attr.h
index 9110499f2..f1a10b5ae 100644
--- a/libfrog/attr.h
+++ b/libfrog/attr.h
@@ -11,8 +11,13 @@
  *
  * We are redifining here so we don't need to keep libattr as a dependency anymore
  */
+
 #define ATTR_ENTRY(buffer, index)		\
 	((struct xfs_attrlist_ent *)		\
 	 &((char *)buffer)[ ((struct xfs_attrlist *)(buffer))->al_offset[index] ])
 
+/* Attr flags used within xfsprogs, must match the definitions from libattr */
+#define ATTR_ROOT	0x0002	/* use root namespace attributes in op */
+#define ATTR_SECURE	0x0008	/* use security namespaces attributes in op */
+
 #endif /* __LIBFROG_ATTR_H__ */
diff --git a/scrub/Makefile b/scrub/Makefile
index 53e8cb02a..1e1109048 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -100,10 +100,6 @@ ifeq ($(HAVE_MALLINFO2),yes)
 LCFLAGS += -DHAVE_MALLINFO2
 endif
 
-ifeq ($(HAVE_LIBATTR),yes)
-LCFLAGS += -DHAVE_LIBATTR
-endif
-
 ifeq ($(HAVE_LIBICU),yes)
 CFILES += unicrash.c
 LCFLAGS += -DHAVE_LIBICU $(LIBICU_CFLAGS)
diff --git a/scrub/phase5.c b/scrub/phase5.c
index 27fa29be6..2e495643f 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -20,6 +20,7 @@
 #include "libfrog/scrub.h"
 #include "libfrog/bitmap.h"
 #include "libfrog/bulkstat.h"
+#include "libfrog/attr.h"
 #include "xfs_scrub.h"
 #include "common.h"
 #include "inodes.h"
@@ -164,7 +165,6 @@ out_unicrash:
 	return ret;
 }
 
-#ifdef HAVE_LIBATTR
 /* Routines to scan all of an inode's xattrs for name problems. */
 struct attrns_decode {
 	int			flags;
@@ -193,8 +193,8 @@ check_xattr_ns_names(
 	struct xfs_attrlist_cursor	cur;
 	char				attrbuf[XFS_XATTR_LIST_MAX];
 	char				keybuf[XATTR_NAME_MAX + 1];
-	struct attrlist			*attrlist = (struct attrlist *)attrbuf;
-	struct attrlist_ent		*ent;
+	struct xfs_attrlist		*attrlist = (struct xfs_attrlist *)attrbuf;
+	struct xfs_attrlist_ent		*ent;
 	struct unicrash			*uc = NULL;
 	int				i;
 	int				error;
@@ -267,9 +267,6 @@ check_xattr_names(
 	}
 	return ret;
 }
-#else
-# define check_xattr_names(c, d, h, b)	(0)
-#endif /* HAVE_LIBATTR */
 
 static int
 render_ino_from_handle(
-- 
2.46.0

