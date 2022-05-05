Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAF9EC433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 16:04:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353854AbiEEQHu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 12:07:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379571AbiEEQHs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 12:07:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 887DD56F95
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 09:04:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D2A6B82DEF
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 16:04:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF8B9C385A8;
        Thu,  5 May 2022 16:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651766645;
        bh=gI8pByn89S5P91VaYOe2hZ3TmWZqBeQmlhueVIlATqk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=IIsrdSktTm67QEwmK+dnzcnuYycVEJEK9LPE4XXPPQweyf2CUDcL4DEaFBjxZG1sO
         0LeI3C5GUUPxrxwCGpKEE+g53uXQXricR0tozEYpVsi1LC7s5xyhuwuFhuWK8ajmQI
         skatvnbCVmrGidteNsuKrKNuuonN5hgRg2sfzIe8+aBPikwLAPTrSnvr5/gvAJcKuX
         ZyjwJJvSn2hPlIS+TXjwRKGkgAQubDvqY9gmY5Y9pSN0Hb5EBzvqLYzhpNF2SYc3du
         3HMFUQSQtBs5XXBamP4QcL/Oa3fI03BIgSzvh/DtE2AHmaY4pc0m6nezGs3Y1OfViz
         QZRbTf9urreow==
Subject: [PATCH 1/2] xfs_scrub: move to mallinfo2 when available
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 May 2022 09:04:05 -0700
Message-ID: <165176664529.246897.6962083531265042879.stgit@magnolia>
In-Reply-To: <165176663972.246897.5479033385952013770.stgit@magnolia>
References: <165176663972.246897.5479033385952013770.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Starting with glibc 2.35, the mallinfo library call has finally been
upgraded to return 64-bit memory usage quantities.  Migrate to the new
call, since it also warns about mallinfo being deprecated.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 configure.ac          |    1 +
 include/builddefs.in  |    1 +
 m4/package_libcdev.m4 |   18 ++++++++++++++++++
 scrub/Makefile        |    4 ++++
 scrub/xfs_scrub.c     |   47 +++++++++++++++++++++++++++++------------------
 5 files changed, 53 insertions(+), 18 deletions(-)


diff --git a/configure.ac b/configure.ac
index 160f64dd..4650d56c 100644
--- a/configure.ac
+++ b/configure.ac
@@ -192,6 +192,7 @@ AC_HAVE_STATFS_FLAGS
 AC_HAVE_MAP_SYNC
 AC_HAVE_DEVMAPPER
 AC_HAVE_MALLINFO
+AC_HAVE_MALLINFO2
 AC_PACKAGE_WANT_ATTRIBUTES_H
 AC_HAVE_LIBATTR
 if test "$enable_scrub" = "yes"; then
diff --git a/include/builddefs.in b/include/builddefs.in
index 626db210..e0a2f3cb 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -115,6 +115,7 @@ HAVE_STATFS_FLAGS = @have_statfs_flags@
 HAVE_MAP_SYNC = @have_map_sync@
 HAVE_DEVMAPPER = @have_devmapper@
 HAVE_MALLINFO = @have_mallinfo@
+HAVE_MALLINFO2 = @have_mallinfo2@
 HAVE_LIBATTR = @have_libattr@
 HAVE_LIBICU = @have_libicu@
 HAVE_OPENAT = @have_openat@
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index adab9bb9..8d05dc40 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -367,6 +367,24 @@ AC_DEFUN([AC_HAVE_MALLINFO],
     AC_SUBST(have_mallinfo)
   ])
 
+#
+# Check if we have a mallinfo2 libc call
+#
+AC_DEFUN([AC_HAVE_MALLINFO2],
+  [ AC_MSG_CHECKING([for mallinfo2 ])
+    AC_TRY_COMPILE([
+#include <malloc.h>
+    ], [
+         struct mallinfo2 test;
+
+         test.arena = 0; test.hblkhd = 0; test.uordblks = 0; test.fordblks = 0;
+         test = mallinfo2();
+    ], have_mallinfo2=yes
+       AC_MSG_RESULT(yes),
+       AC_MSG_RESULT(no))
+    AC_SUBST(have_mallinfo2)
+  ])
+
 #
 # Check if we have a openat call
 #
diff --git a/scrub/Makefile b/scrub/Makefile
index 74492fb6..aba14ed2 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -77,6 +77,10 @@ ifeq ($(HAVE_MALLINFO),yes)
 LCFLAGS += -DHAVE_MALLINFO
 endif
 
+ifeq ($(HAVE_MALLINFO2),yes)
+LCFLAGS += -DHAVE_MALLINFO2
+endif
+
 ifeq ($(HAVE_SYNCFS),yes)
 LCFLAGS += -DHAVE_SYNCFS
 endif
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index 41839c26..7a0411b0 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -282,6 +282,34 @@ phase_start(
 	return error;
 }
 
+static inline unsigned long long
+kbytes(unsigned long long x)
+{
+	return (x + 1023) / 1024;
+}
+
+static void
+report_mem_usage(
+	const char			*phase,
+	const struct phase_rusage	*pi)
+{
+#if defined(HAVE_MALLINFO2) || defined(HAVE_MALLINFO)
+# ifdef HAVE_MALLINFO2
+	struct mallinfo2		mall_now = mallinfo2();
+# else
+	struct mallinfo			mall_now = mallinfo();
+# endif
+	fprintf(stdout, _("%sMemory used: %lluk/%lluk (%lluk/%lluk), "),
+		phase,
+		kbytes(mall_now.arena), kbytes(mall_now.hblkhd),
+		kbytes(mall_now.uordblks), kbytes(mall_now.fordblks));
+#else
+	fprintf(stdout, _("%sMemory used: %lluk, "),
+		phase,
+		kbytes(((char *) sbrk(0)) - ((char *) pi->brk_start)));
+#endif
+}
+
 /* Report usage stats. */
 static int
 phase_end(
@@ -289,9 +317,6 @@ phase_end(
 	unsigned int		phase)
 {
 	struct rusage		ruse_now;
-#ifdef HAVE_MALLINFO
-	struct mallinfo		mall_now;
-#endif
 	struct timeval		time_now;
 	char			phasebuf[DESCR_BUFSZ];
 	double			dt;
@@ -323,21 +348,7 @@ phase_end(
 	else
 		phasebuf[0] = 0;
 
-#define kbytes(x)	(((unsigned long)(x) + 1023) / 1024)
-#ifdef HAVE_MALLINFO
-
-	mall_now = mallinfo();
-	fprintf(stdout, _("%sMemory used: %luk/%luk (%luk/%luk), "),
-		phasebuf,
-		kbytes(mall_now.arena), kbytes(mall_now.hblkhd),
-		kbytes(mall_now.uordblks), kbytes(mall_now.fordblks));
-#else
-	fprintf(stdout, _("%sMemory used: %luk, "),
-		phasebuf,
-		(unsigned long) kbytes(((char *) sbrk(0)) -
-				       ((char *) pi->brk_start)));
-#endif
-#undef kbytes
+	report_mem_usage(phasebuf, pi);
 
 	fprintf(stdout, _("time: %5.2f/%5.2f/%5.2fs\n"),
 		timeval_subtract(&time_now, &pi->time),

