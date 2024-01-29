Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416574F1F3
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jan 2024 07:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706513545; cv=none; b=fc4y7rI2Z2tWNiso2rYl4IFKa94wKscd70P4yvOqxlODQLqUpTLHBXc0wL9ouOOH/lbvt9/OkMSwM95p9YC2R8r8FLxf7foVJDM/QnAMErhl2CdBHej0JVLLSuodyy9gK+bdcYRvU2UzRnSv7ibBAOlgzHp9mzEClPEYgrW7zVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706513545; c=relaxed/simple;
	bh=2B2/lKhKWyf9FgkyB3FPfAcCUHa1h+4kYvkWpMKJzug=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dSgPHK991OVZE7mlmHdByEXLVHZX7+12fR+pJ7H//At90HCFdXp4utk8JIj9ucqYZ/KZgQDoijrvw1R190Qd24z95MEy+1A6D2tE2TCgpMnARAhBc5Q4ZxXzulclmVB1VLEnu8Bir1AlkR50H1bxWqw3zjfqy/Tm/gdOHtWZQpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YbDLdxHp; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YbDLdxHp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=QJ4e0zlnd3xXlMbW7y4Wt87Deo14V24+1vEBIqWjfDU=; b=YbDLdxHpBLkQmUk2I3dzTP8hxb
	XqTZoaVm+UuUqYSCcAHLs2nIcBdFS4Hpy4c2VOpZkdWHMZb707dH5hVxyBR/goegXaj3LWTgq2F6K
	2gdA+atSF8yBDR+stZ4ZQO+/oGssQgAtND09MLrVpiGonHvojewoglhU1HQ4WanCyu5MmG/AlNsBh
	KSAf+RnbXGfOcFNrSMozgrMZsyuKVDpTNCQ6OjuGvu4z7FIagbeqbPdKNydtzmalUZb2sKTRX1XkI
	5pJOh3gccSXUg6tllASsboAJlSGjNpjqoYjY5mOHBgyAZt0cJKREpKb+DeJbyRdBUGjatf1y1tvWe
	WttsYBuw==;
Received: from [2001:4bb8:182:6550:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rUM7z-0000000BcZa-1pJp;
	Mon, 29 Jan 2024 07:32:23 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 02/27] include: unconditionally define umode_t
Date: Mon, 29 Jan 2024 08:31:50 +0100
Message-Id: <20240129073215.108519-3-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240129073215.108519-1-hch@lst.de>
References: <20240129073215.108519-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

No system or kernel uapi header defines umode_t, so just define it
unconditionally.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 configure.ac               |  1 -
 include/builddefs.in       |  3 ---
 include/platform_defs.h.in |  3 ---
 m4/Makefile                |  1 -
 m4/package_types.m4        | 14 --------------
 5 files changed, 22 deletions(-)
 delete mode 100644 m4/package_types.m4

diff --git a/configure.ac b/configure.ac
index 2034f02e5..482b2452c 100644
--- a/configure.ac
+++ b/configure.ac
@@ -250,7 +250,6 @@ fi
 
 AC_CHECK_SIZEOF([long])
 AC_CHECK_SIZEOF([char *])
-AC_TYPE_UMODE_T
 AC_MANUAL_FORMAT
 AC_HAVE_LIBURCU_ATOMIC64
 
diff --git a/include/builddefs.in b/include/builddefs.in
index a3745efbe..6e7eaface 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -136,9 +136,6 @@ GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
 
 # _LGPL_SOURCE is for liburcu to work correctly with GPL/LGPL programs
 PCFLAGS = -D_LGPL_SOURCE -D_GNU_SOURCE $(GCCFLAGS)
-ifeq ($(HAVE_UMODE_T),yes)
-PCFLAGS += -DHAVE_UMODE_T
-endif
 DEPENDFLAGS = -D__linux__
 ifeq ($(HAVE_FLS),yes)
 LCFLAGS+= -DHAVE_FLS
diff --git a/include/platform_defs.h.in b/include/platform_defs.h.in
index 02b0e08b5..17262dcff 100644
--- a/include/platform_defs.h.in
+++ b/include/platform_defs.h.in
@@ -30,10 +30,7 @@
 #undef SIZEOF_CHAR_P
 #define BITS_PER_LONG (SIZEOF_LONG * CHAR_BIT)
 
-/* Check whether to define umode_t ourselves. */
-#ifndef HAVE_UMODE_T
 typedef unsigned short umode_t;
-#endif
 
 /* Define if you want gettext (I18N) support */
 #undef ENABLE_GETTEXT
diff --git a/m4/Makefile b/m4/Makefile
index 731205303..84174c3d3 100644
--- a/m4/Makefile
+++ b/m4/Makefile
@@ -22,7 +22,6 @@ LSRCFILES = \
 	package_pthread.m4 \
 	package_sanitizer.m4 \
 	package_services.m4 \
-	package_types.m4 \
 	package_icu.m4 \
 	package_urcu.m4 \
 	package_utilies.m4 \
diff --git a/m4/package_types.m4 b/m4/package_types.m4
deleted file mode 100644
index 6e817a310..000000000
--- a/m4/package_types.m4
+++ /dev/null
@@ -1,14 +0,0 @@
-#
-# Check if we have umode_t
-#
-AH_TEMPLATE([HAVE_UMODE_T], [Whether you have umode_t])
-AC_DEFUN([AC_TYPE_UMODE_T],
-  [ AC_MSG_CHECKING([for umode_t])
-    AC_COMPILE_IFELSE(
-    [	AC_LANG_PROGRAM([[
-#include <asm/types.h>
-	]], [[
-umode_t umode;
-	]])
-    ], AC_DEFINE(HAVE_UMODE_T) AC_MSG_RESULT(yes) , AC_MSG_RESULT(no))
-  ])
-- 
2.39.2

