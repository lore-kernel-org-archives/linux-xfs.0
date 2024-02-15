Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B6FBA37
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 06:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707980077; cv=none; b=gjbF27VBLPot6mauPGxk+DComzkRhIWsK+vR5/WmtiwFxVdM+Dl4XdJH8vy75TQuzvqbTCREgYu6dljP5KQIO2+j0Ik6NWYNCSejs0sX6bmbkKmLVOurGhi2cPOZP/FqNLTOjGxjNOG07dGc71CoVNZsraHqpri+0tf8d3Lo5qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707980077; c=relaxed/simple;
	bh=wEMwfUwc9RsIigETTi+qa9cwyZYM4et4NkV/Ibwwlhc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iwf8lMzDnvMfZ/lUozRZSFEeAZdzvLgmM4OJsQEE1/pNlt54d4YiD/IjLeP+wd+0Mx4zbehimbICE3WTEK+9TP0/L/h1fXlsJBtKoJIFoNWfM8Ol/zpaY3aaMivptQ999dBH+4H8yMaY4h+J3AJY9AbrKsPLqG9A/QQvAz6EP20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FNfTtsx3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FNfTtsx3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=mY2xR8Hh4yu907AIdC9esK2UdkAc11v70ACyPsqNn+M=; b=FNfTtsx32dCF7aOxg0XBoM1kf7
	9nyUiXAJLDY6ebJBAuAsK/xxPNQCZlqagE1g0jtEzPi51Zj3X7eeSLTX/wtTX80TYD/wLmgzCqfFm
	6HNuQs/fPweVJjgabmy1PSTUMu3cxEQ7oR2qouWNEzvcnluYNss4VDnWTqrMlGbU4s/5vVrONW2p3
	+g58pmLJxeM87DBiC2dO7V9kGBDuHDTZnXHSanEhfsadCpULsdFKWeOnGm3xRUJGN+dGDXKqOBMf3
	ZxI+OuzqUWPusq1/aSsjLl9KlPOPzO/Xi2QYbSORUVquoeEY018GveSBXlLUyiflaMf18hTadRXv/
	GqD2j2bg==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1raVdj-0000000F9BZ-24p9;
	Thu, 15 Feb 2024 06:54:35 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 02/26] include: unconditionally define umode_t
Date: Thu, 15 Feb 2024 07:54:00 +0100
Message-Id: <20240215065424.2193735-3-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240215065424.2193735-1-hch@lst.de>
References: <20240215065424.2193735-1-hch@lst.de>
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
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 configure.ac               |  1 -
 include/builddefs.in       |  3 ---
 include/platform_defs.h.in |  3 ---
 m4/Makefile                |  1 -
 m4/package_types.m4        | 14 --------------
 5 files changed, 22 deletions(-)
 delete mode 100644 m4/package_types.m4

diff --git a/configure.ac b/configure.ac
index 59c52545e..9133f88d9 100644
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

