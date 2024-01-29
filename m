Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DFB74F1E7
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jan 2024 07:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706513584; cv=none; b=cocLscJkHWOdoyTSzhyqV7IrQuRYatoaGuLSxG07E38DGgrfKWb2OhpupuV1vLuCGeIbQwf3HBt749MpPD5zoMei5AIvR6qWa5gM3Rttpkub3j/W0tIoDtynV9N52+zkz/kFrEX4+DgEsBpSR8s1P6+m6apgNdj3XRWjuxy1Z6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706513584; c=relaxed/simple;
	bh=eAD5iS4Z5lXJjqP6JjVWCvghU/+7/7HYQnpFR6Hf4bc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kp17qofxUK8UoDTWB/G4eQzwnKttQ1cWmFj+BU13u3gfWh9Fq9eF27B94eJdLzJnsaqukuIPcIryRTjW3jZndyq4DCUZw7J7Sc2boOj0ebqYew5CY5MVROrdU4kW3f2r8z71hzQHNaKAnAIPMuLvL+cG7OKyClF1hMacMuejLtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dc85npNk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dc85npNk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=sW8SIXG09IfWp22edtLs/2VhKhXIZq34o/jWD7Fcvzc=; b=dc85npNk2Y8xPitBbU49qkXWNf
	deS8eTYRoAJpGXT5G2CH/W163B8Da1fWsnGVZEfpMQRGuLTY/M7rvZru4ciimDfVb3EWzygnonAKe
	g8rqDPWPy2kbDs8yZvG6zpqg50nqCUz/HJrzQNGyydwZHDkSqWjdK+L4pd67f7hFwhYh1PJbpC5ns
	/OSn5FspBqSlljsWCochjjIgdrsHJ0zlXOQbMMInnObWuueGtCclFL4R2Ynv0qq4FKrAzEmx8VzAR
	gWrX9j9COhLMQLAWiH/MuzWPiM1zFfmT3nkH7S50pCoEjAaMAMfohBDUyqjU5w9/ATFklcGKNbS1s
	HDLw6LKw==;
Received: from [2001:4bb8:182:6550:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rUM8c-0000000BciD-2Sa3;
	Mon, 29 Jan 2024 07:33:03 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 17/27] configure: don't check for fallocate
Date: Mon, 29 Jan 2024 08:32:05 +0100
Message-Id: <20240129073215.108519-18-hch@lst.de>
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

fallocate has been supported since Linux 2.6.23 and glibc 2.10.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 configure.ac          |  1 -
 include/builddefs.in  |  4 ----
 include/linux.h       |  2 --
 io/Makefile           |  4 ----
 io/prealloc.c         |  8 --------
 m4/package_libcdev.m4 | 19 -------------------
 6 files changed, 38 deletions(-)

diff --git a/configure.ac b/configure.ac
index abedaacf2..8c903ea2d 100644
--- a/configure.ac
+++ b/configure.ac
@@ -162,7 +162,6 @@ AC_PACKAGE_NEED_PTHREADMUTEXINIT
 AC_PACKAGE_NEED_URCU_H
 AC_PACKAGE_NEED_RCU_INIT
 
-AC_HAVE_FALLOCATE
 AC_HAVE_PWRITEV2
 AC_HAVE_PREADV
 AC_HAVE_COPY_FILE_RANGE
diff --git a/include/builddefs.in b/include/builddefs.in
index 47ac7173c..64468f486 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -90,7 +90,6 @@ ENABLE_SCRUB	= @enable_scrub@
 
 HAVE_ZIPPED_MANPAGES = @have_zipped_manpages@
 
-HAVE_FALLOCATE = @have_fallocate@
 HAVE_PREADV = @have_preadv@
 HAVE_PWRITEV2 = @have_pwritev2@
 HAVE_COPY_FILE_RANGE = @have_copy_file_range@
@@ -144,9 +143,6 @@ endif
 ifeq ($(HAVE_GETFSMAP),yes)
 PCFLAGS+= -DHAVE_GETFSMAP
 endif
-ifeq ($(HAVE_FALLOCATE),yes)
-PCFLAGS += -DHAVE_FALLOCATE
-endif
 
 LIBICU_LIBS = @libicu_LIBS@
 LIBICU_CFLAGS = @libicu_CFLAGS@
diff --git a/include/linux.h b/include/linux.h
index eddc4ad9c..95a0deee2 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -27,9 +27,7 @@
 #include <asm/types.h>
 #include <mntent.h>
 #include <fcntl.h>
-#if defined(HAVE_FALLOCATE)
 #include <linux/falloc.h>
-#endif
 #ifdef OVERRIDE_SYSTEM_FSXATTR
 # define fsxattr sys_fsxattr
 #endif
diff --git a/io/Makefile b/io/Makefile
index 837716238..eb6ad0574 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -33,10 +33,6 @@ ifeq ($(ENABLE_EDITLINE),yes)
 LLDLIBS += $(LIBEDITLINE) $(LIBTERMCAP)
 endif
 
-ifeq ($(HAVE_FALLOCATE),yes)
-LCFLAGS += -DHAVE_FALLOCATE
-endif
-
 # Also implies PWRITEV
 ifeq ($(HAVE_PREADV),yes)
 LCFLAGS += -DHAVE_PREADV -DHAVE_PWRITEV
diff --git a/io/prealloc.c b/io/prealloc.c
index 5805897a4..8e968c9f2 100644
--- a/io/prealloc.c
+++ b/io/prealloc.c
@@ -4,9 +4,7 @@
  * All Rights Reserved.
  */
 
-#if defined(HAVE_FALLOCATE)
 #include <linux/falloc.h>
-#endif
 #include "command.h"
 #include "input.h"
 #include "init.h"
@@ -37,14 +35,12 @@ static cmdinfo_t freesp_cmd;
 static cmdinfo_t resvsp_cmd;
 static cmdinfo_t unresvsp_cmd;
 static cmdinfo_t zero_cmd;
-#if defined(HAVE_FALLOCATE)
 static cmdinfo_t falloc_cmd;
 static cmdinfo_t fpunch_cmd;
 static cmdinfo_t fcollapse_cmd;
 static cmdinfo_t finsert_cmd;
 static cmdinfo_t fzero_cmd;
 static cmdinfo_t funshare_cmd;
-#endif
 
 static int
 offset_length(
@@ -182,7 +178,6 @@ zero_f(
 }
 
 
-#if defined (HAVE_FALLOCATE)
 static void
 falloc_help(void)
 {
@@ -381,7 +376,6 @@ funshare_f(
 	}
 	return 0;
 }
-#endif	/* HAVE_FALLOCATE */
 
 void
 prealloc_init(void)
@@ -435,7 +429,6 @@ prealloc_init(void)
 	add_command(&unresvsp_cmd);
 	add_command(&zero_cmd);
 
-#if defined (HAVE_FALLOCATE)
 	falloc_cmd.name = "falloc";
 	falloc_cmd.cfunc = fallocate_f;
 	falloc_cmd.argmin = 2;
@@ -496,5 +489,4 @@ prealloc_init(void)
 	funshare_cmd.oneline =
 	_("unshares shared blocks within the range");
 	add_command(&funshare_cmd);
-#endif	/* HAVE_FALLOCATE */
 }
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 17319bb23..758b9378c 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -1,22 +1,3 @@
-#
-# Check if we have a fallocate libc call (Linux)
-#
-AC_DEFUN([AC_HAVE_FALLOCATE],
-  [ AC_MSG_CHECKING([for fallocate])
-    AC_LINK_IFELSE(
-    [	AC_LANG_PROGRAM([[
-#define _GNU_SOURCE
-#include <fcntl.h>
-#include <linux/falloc.h>
-	]], [[
-fallocate(0, 0, 0, 0);
-	]])
-    ], have_fallocate=yes
-       AC_MSG_RESULT(yes),
-       AC_MSG_RESULT(no))
-    AC_SUBST(have_fallocate)
-  ])
-
 #
 # Check if we have a preadv libc call (Linux)
 #
-- 
2.39.2

