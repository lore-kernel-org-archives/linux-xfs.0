Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:41148 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725971AbeJKFmc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Oct 2018 01:42:32 -0400
Subject: [PATCH 01/18 V2] xfsprogs: enable sparse checking with "make C=[12]"
References: <1539201682-22198-1-git-send-email-sandeen@redhat.com>
 <1539201682-22198-2-git-send-email-sandeen@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <3048f94d-191c-0e62-1a3b-a0ec0e4b8374@sandeen.net>
Date: Wed, 10 Oct 2018 17:18:20 -0500
MIME-Version: 1.0
In-Reply-To: <1539201682-22198-2-git-send-email-sandeen@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org

Enable "make C=1" or "make C=2" to do sparse checking.
Blatantly ripped off from djwong's patch in e2fsprogs to do the same.

This is a bit simpler than redefining CC for the whole build, which
requires extra commandline definitions and apparently is enough of a
barrier that nobody's doing sparse checking.

Note, this requires unreleased sparse after v0.5, which enables the
CHAR_BIT definition; otherwise it chokes.

Add information about these helpers to doc/sparse.txt

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/Makefile b/Makefile
index d031a60..7f3e774 100644
--- a/Makefile
+++ b/Makefile
@@ -16,6 +16,20 @@ else
   Q = @
 endif
 
+CHECK=sparse
+CHECK_OPTS=-Wsparse-all -Wno-transparent-union -Wno-return-void -Wno-undef \
+	-Wno-non-pointer-null -D__linux__
+ifeq ("$(C)", "2")
+  CHECK_CMD=$(CHECK) $(CHECK_OPTS) -Wbitwise -D__CHECK_ENDIAN__
+else
+  ifeq ("$(C)", "1")
+    CHECK_CMD=$(CHECK) $(CHECK_OPTS)
+   else
+    CHECK_CMD=@true
+  endif
+endif
+export CHECK_CMD
+
 MAKEOPTS = --no-print-directory Q=$(Q)
 
 TOPDIR = .
diff --git a/doc/sparse.txt b/doc/sparse.txt
index 36a34a0..d426739 100644
--- a/doc/sparse.txt
+++ b/doc/sparse.txt
@@ -5,9 +5,20 @@ to check the source code of the open source XFS commands and utilites
 First you need to install sparse, either from your distribution or from
 source as provided at http://www.kernel.org/pub/software/devel/sparse/.
 
-To simply build the xfsprogs source code while checking the source using
-sparse just set the compiler to cgcc, which is a wrapper that calls both
-sparse and gcc using:
+The xfsprogs Makefile has a convenient shortcut to running sparse, by setting
+the C ("check") variable on the make commandline.  To perform generic checks,
+
+	make C=1
+
+which checks with -Wsparse-all -Wno-transparent-union -Wno-return-void
+-Wno-undef -Wno-non-pointer-null, or to perform the bitwise checks, use
+
+	make C=2
+
+which checks with -Wbitwise -D__CHECK_ENDIAN__
+
+If you'd rather run sparse more manually, just set the compiler to cgcc,
+which is a wrapper that calls both sparse and gcc using:
 
 	CC=cgcc ./configure
 
diff --git a/include/buildrules b/include/buildrules
index c57fdfc..23fc866 100644
--- a/include/buildrules
+++ b/include/buildrules
@@ -54,10 +54,12 @@ $(LTLIBRARY) : $(SUBDIRS) $(LTOBJECTS)
 %.lo: %.c
 	@echo "    [CC]     $@"
 	$(Q)$(LTCOMPILE) -c $<
+	$(Q)$(CHECK_CMD) $(CFLAGS) $<
 else
 %.o: %.c
 	@echo "    [CC]     $@"
 	$(Q)$(CC) $(CFLAGS) -c $<
+	$(Q)$(CHECK_CMD) $(CFLAGS) $<
 
 endif
 
