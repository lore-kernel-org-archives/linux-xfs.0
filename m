Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C0FA17FAC
	for <xfs@oss.sgi.com>; Thu, 11 Sep 2014 16:06:17 -0500 (CDT)
Date: Thu, 11 Sep 2014 16:06:17 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH 13/13] xfsprogs: add a preliminary test for utf8 support
Message-ID: <20140911210617.GV13262@sgi.com>
References: <20140911203735.GA19952@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140911203735.GA19952@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: tinguely@sgi.com, olaf@sgi.com

From: Ben Myers <bpm@sgi.com>

Here's a preliminary test for utf8 support in xfs.  It is based on
Olaf's code that does some testing in the trie generator.  Here too we
are using the NormalizationTest.txt file from the unicode distribution.
We check that the normalization in libxfs is working and then run checks
on a filesystem.  Note that there are some 'blacklisted' unichars which
normalize to reserved characters.

FIXME:

For convenience of build this patch is against xfsprogs access to
libxfs.  Handling of ignorables and case fold is also not implemented
here.

---
 Makefile                  |   2 +-
 chkutf8data/Makefile      |  21 +++
 chkutf8data/chkutf8data.c | 430 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 452 insertions(+), 1 deletion(-)
 create mode 100644 chkutf8data/Makefile
 create mode 100644 chkutf8data/chkutf8data.c

diff --git a/Makefile b/Makefile
index c442da6..d4c0a23 100644
--- a/Makefile
+++ b/Makefile
@@ -42,7 +42,7 @@ endif
 
 LIB_SUBDIRS = support libxfs libxlog libxcmd libhandle libdisk
 TOOL_SUBDIRS = copy db estimate fsck fsr growfs io logprint mkfs quota \
-		mdrestore repair rtcp m4 man doc po debian
+		mdrestore repair rtcp m4 man doc po debian chkutf8data
 
 SUBDIRS = include $(LIB_SUBDIRS) $(TOOL_SUBDIRS)
 
diff --git a/chkutf8data/Makefile b/chkutf8data/Makefile
new file mode 100644
index 0000000..6ce5706
--- /dev/null
+++ b/chkutf8data/Makefile
@@ -0,0 +1,21 @@
+#
+# Copyright (c) 2014 SGI. All Rights Reserved.
+#
+
+TOPDIR = ..
+include $(TOPDIR)/include/builddefs
+
+LTCOMMAND = chkutf8data
+CFILES = chkutf8data.c
+
+LLDLIBS = $(LIBXFS)
+LTDEPENDENCIES = $(LIBXFS)
+LLDFLAGS = -static
+
+default: depend $(LTCOMMAND)
+
+include $(BUILDRULES)
+
+install: default
+
+-include .ltdep
diff --git a/chkutf8data/chkutf8data.c b/chkutf8data/chkutf8data.c
new file mode 100644
index 0000000..487cf1e
--- /dev/null
+++ b/chkutf8data/chkutf8data.c
@@ -0,0 +1,430 @@
+/*
+ * Copyright (c) 2014 SGI.
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#include <sys/types.h>
+#include <stddef.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <assert.h>
+#include <string.h>
+#include <unistd.h>
+#include <errno.h>
+#include <fcntl.h>
+#include "utf8norm.h"
+
+#define FOLD_NAME	"CaseFolding.txt"
+#define TEST_NAME	"NormalizationTest.txt"
+
+const char	*fold_name = FOLD_NAME;
+const char	*test_name = TEST_NAME;
+
+/* An arbitrary line size limit on input lines. */
+
+#define LINESIZE	1024
+char line[LINESIZE];
+char buf0[LINESIZE];
+char buf1[LINESIZE];
+char buf2[LINESIZE];
+char buf3[LINESIZE];
+char buf4[LINESIZE];
+char buf5[LINESIZE];
+
+const char *mtpt;
+int verbose = 0;
+
+/* ------------------------------------------------------------------ */
+
+static void
+help(void)
+{
+	printf("The input files:\n");
+	printf("\t-f %s\n", FOLD_NAME);
+	printf("\t-t %s\n", TEST_NAME);
+	printf("\n\n");
+	printf("\t-m mtpt\n");
+	printf("\t-v (verbose)\n");
+	printf("\t-h (help)\n");
+	printf("\n");
+}
+
+static void
+usage(void)
+{
+	help();
+	exit(1);
+}
+
+static void
+open_fail(const char *name, int error)
+{
+	printf("Error %d opening %s: %s\n", error, name, strerror(error));
+	exit(1);
+}
+
+static void
+file_fail(const char *filename)
+{
+	printf("Error parsing %s\n", filename);
+	exit(1);
+}
+
+/* ------------------------------------------------------------------ */
+
+/*
+ * UTF8 valid ranges.
+ *
+ * The UTF-8 encoding spreads the bits of a 32bit word over several
+ * bytes. This table gives the ranges that can be held and how they'd
+ * be represented.
+ *
+ * 0x00000000 0x0000007F: 0xxxxxxx
+ * 0x00000000 0x000007FF: 110xxxxx 10xxxxxx
+ * 0x00000000 0x0000FFFF: 1110xxxx 10xxxxxx 10xxxxxx
+ * 0x00000000 0x001FFFFF: 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
+ * 0x00000000 0x03FFFFFF: 111110xx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx
+ * 0x00000000 0x7FFFFFFF: 1111110x 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx
+ *
+ * There is an additional requirement on UTF-8, in that only the
+ * shortest representation of a 32bit value is to be used.  A decoder
+ * must not decode sequences that do not satisfy this requirement.
+ * Thus the allowed ranges have a lower bound.
+ *
+ * 0x00000000 0x0000007F: 0xxxxxxx
+ * 0x00000080 0x000007FF: 110xxxxx 10xxxxxx
+ * 0x00000800 0x0000FFFF: 1110xxxx 10xxxxxx 10xxxxxx
+ * 0x00010000 0x001FFFFF: 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
+ * 0x00200000 0x03FFFFFF: 111110xx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx
+ * 0x04000000 0x7FFFFFFF: 1111110x 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx
+ *
+ * Actual unicode characters are limited to the range 0x0 - 0x10FFFF,
+ * 17 planes of 65536 values.  This limits the sequences actually seen
+ * even more, to just the following.
+ *
+ *          0 -     0x7f: 0                     0x7f
+ *       0x80 -    0x7ff: 0xc2 0x80             0xdf 0xbf
+ *      0x800 -   0xffff: 0xe0 0xa0 0x80        0xef 0xbf 0xbf
+ *    0x10000 - 0x10ffff: 0xf0 0x90 0x80 0x80   0xf4 0x8f 0xbf 0xbf
+ *
+ * Even within those ranges not all values are allowed: the surrogates
+ * 0xd800 - 0xdfff should never be seen.
+ *
+ * Note that the longest sequence seen with valid usage is 4 bytes,
+ * the same a single UTF-32 character.  This makes the UTF-8
+ * representation of Unicode strictly smaller than UTF-32.
+ *
+ * The shortest sequence requirement was introduced by:
+ *    Corrigendum #1: UTF-8 Shortest Form
+ * It can be found here:
+ *    http://www.unicode.org/versions/corrigendum1.html
+ *
+ */
+
+#define UTF8_2_BITS     0xC0
+#define UTF8_3_BITS     0xE0
+#define UTF8_4_BITS     0xF0
+#define UTF8_N_BITS     0x80
+#define UTF8_2_MASK     0xE0
+#define UTF8_3_MASK     0xF0
+#define UTF8_4_MASK     0xF8
+#define UTF8_N_MASK     0xC0
+#define UTF8_V_MASK     0x3F
+#define UTF8_V_SHIFT    6
+
+static int
+utf8key(unsigned int key, char keyval[])
+{
+	int keylen;
+
+	if (key < 0x80) {
+		keyval[0] = key;
+		keylen = 1;
+	} else if (key < 0x800) {
+		keyval[1] = key & UTF8_V_MASK;
+		keyval[1] |= UTF8_N_BITS;
+		key >>= UTF8_V_SHIFT;
+		keyval[0] = key;
+		keyval[0] |= UTF8_2_BITS;
+		keylen = 2;
+	} else if (key < 0x10000) {
+		keyval[2] = key & UTF8_V_MASK;
+		keyval[2] |= UTF8_N_BITS;
+		key >>= UTF8_V_SHIFT;
+		keyval[1] = key & UTF8_V_MASK;
+		keyval[1] |= UTF8_N_BITS;
+		key >>= UTF8_V_SHIFT;
+		keyval[0] = key;
+		keyval[0] |= UTF8_3_BITS;
+		keylen = 3;
+	} else if (key < 0x110000) {
+		keyval[3] = key & UTF8_V_MASK;
+		keyval[3] |= UTF8_N_BITS;
+		key >>= UTF8_V_SHIFT;
+		keyval[2] = key & UTF8_V_MASK;
+		keyval[2] |= UTF8_N_BITS;
+		key >>= UTF8_V_SHIFT;
+		keyval[1] = key & UTF8_V_MASK;
+		keyval[1] |= UTF8_N_BITS;
+		key >>= UTF8_V_SHIFT;
+		keyval[0] = key;
+		keyval[0] |= UTF8_4_BITS;
+		keylen = 4;
+	} else {
+		printf("%#x: illegal key\n", key);
+		keylen = 0;
+	}
+	return keylen;
+}
+
+static int
+normalize_line(utf8data_t tree, char *s, char *t)
+{
+	struct utf8cursor u8c;
+
+	if (utf8cursor(&u8c, tree, s)) {
+		printf("%s return utf8cursor failed\n", __func__);
+		return -1;
+	}
+
+	while ((*t = utf8byte(&u8c)) > 0)
+		t++;
+
+	if (*t < 0) {
+		printf("%s return error %d\r", __func__, *t);
+		return -1;
+	}
+	if (*t != 0) {
+		printf("%s return t not 0\n", __func__);
+		return -1;
+	}
+
+        return 0;
+}
+
+static void
+test_key(char	*source,
+	 char	*NFC,
+	 char	*NFD,
+	 char	*NFKC,
+	 char	*NFKD)
+{
+	int	fd;
+	int	error;
+
+	if (verbose)
+		printf("Testing %s -> %s\n", source, NFKD);
+
+	error = chdir(mtpt);	/* XXX hardcoded mount point */
+	if (error) {
+		perror(mtpt);
+		exit(-1);
+	}
+
+	/* the initial create should succeed */
+	if (verbose)
+		printf("Initial create %s... ", source);
+	fd = open(source, O_CREAT|O_EXCL, 0);
+	if (fd < 0) {
+		printf("Failed to create %s XXX\n", source);
+		perror(source);
+		close(fd);
+		exit(-1);
+	}
+	close(fd);
+	if (verbose)
+		printf("Success\n");
+
+	/* a second create should fail */
+	if (verbose)
+		printf("Second create %s (should return EEXIST)... ", NFKD);
+	fd = open(NFKD, O_CREAT|O_EXCL, 0);
+	if (fd >= 1) {
+		printf("Test Failed.  Was able to create %s XXX\n", NFKD);
+		perror(NFKD);
+		close(fd);
+		exit(-1);
+	}
+	close(fd);
+	if (verbose)
+		printf("EEXIST\n");
+
+       	error = unlink(NFKD);
+	if (error) {
+		printf("Unlink failed\n"); 
+		perror(NFKD);
+		exit(-1);
+	}
+}
+
+int
+blacklisted(unsigned int unichar)
+{
+	/* these unichars normalize to characters we don't allow */
+	unsigned int list[] = {	0x2024 /* . */,
+				0x2025 /* .. */,
+       				0x2100 /* a/c */,
+				0x2101 /* a/s */,
+				0x2105 /* c/o */,
+				0x2106 /* c/u */,
+				0xFE30 /* .. */,
+				0xFE52 /* . */,
+				0xFF0E /* . */,
+				0xFF0F /* / */};
+	int i;
+
+	for (i=0; i < (sizeof(list) / sizeof(unichar)); i++) {
+		if (list[i] == unichar)
+			return 1;
+	}
+	return 0;
+}
+
+static void
+normalization_test(void)
+{
+	FILE *file;
+	unsigned int unichar;
+	char *s;
+	char *t;
+	int ret;
+	int tests = 0;
+	int failures = 0;
+	char	source[LINESIZE];
+	char	NFKD[LINESIZE];
+	int	skip;
+	utf8data_t	nfkdi = utf8nfkdi(utf8version);
+
+	printf("Parsing %s\n", test_name);
+	/* Step one, read data from file. */
+	file = fopen(test_name, "r");
+	if (!file)
+		open_fail(test_name, errno);
+
+	while (fgets(line, LINESIZE, file)) {
+		ret = sscanf(line, "%[^;];%*[^;];%*[^;];%*[^;];%[^;];",
+				source, NFKD);
+			//NFC, NFD, NFKC, NFKD);
+		if (ret != 2 || *line == '#')
+			continue;
+
+		s = source;
+		t = buf2;
+		skip = 0;
+		while (*s) {
+			unichar = strtoul(s, &s, 16);
+			if (blacklisted(unichar))
+				skip++;
+			t += utf8key(unichar, t);
+		}
+		*t = '\0';
+
+		if (skip)
+			continue;
+
+		s = NFKD;
+		t = buf3;
+		while (*s) {
+			unichar = strtoul(s, &s, 16);
+			t += utf8key(unichar, t);
+		}
+		*t = '\0';
+
+		/* normalize source */
+		if (normalize_line(nfkdi, buf2, buf4) < 0) {
+			printf("normalize_line for unichar %s Failed\n", buf0);
+			exit(1);
+		}
+		if (verbose)
+			printf("(%s) %s normalized to %s... ",
+					source, buf2, buf4);
+
+		/* does it match NFKD? */
+		tests++;
+		if (memcmp(buf4, buf3, strlen(buf3))) {
+			if (verbose)
+				printf("Fail!\n");
+			failures++;
+		} else { 
+			if (verbose)
+				printf("Correct!\n");
+		}
+
+		/* normalize NFKD */
+		if (normalize_line(nfkdi, buf3, buf5) < 0) {
+			printf("normalize_line for unichar %s Failed\n",
+					buf3);
+			exit(1);
+		}
+		if (verbose)
+			printf("(%s) %s normalized to %s... ",
+					NFKD, buf3, buf5);
+
+		/* does it normalize to itself? */
+		tests++;
+		if (memcmp(buf5, buf3, strlen(buf3))) {
+			if (verbose)
+				printf("Fail!\n");
+			failures++;
+		} else {
+			if (verbose)
+				printf("Correct!\n");
+		}
+
+		/* XXX ignorables need to be taken into account? */
+		test_key(buf2, NULL, NULL, NULL, buf3);
+	}
+	fclose(file);
+	printf("Ran %d tests with %d failures\n", tests, failures);
+	if (failures)
+		file_fail(test_name);
+}
+
+int
+main(int argc, char *argv[])
+{
+	int opt;
+
+	while ((opt = getopt(argc, argv, "f:t:m:vh")) != -1) {
+		switch (opt) {
+		case 'f':
+			fold_name = optarg;
+			break;
+		case 't':
+			test_name = optarg;
+			break;
+		case 'm':
+			mtpt = optarg;
+			break;
+		case 'v':
+			verbose++;
+			break;
+		case 'h':
+			help();
+			exit(0);
+		default:
+			usage();
+		}
+	}
+
+	if (!test_name || !mtpt) {
+		usage();
+		exit(-1);
+	}
+
+	normalization_test();
+
+	return 0;
+}
-- 
1.7.12.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
